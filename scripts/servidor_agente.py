#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Uso: python scripts/servidor_agente.py [--porta 8787] [--modelo qwen2.5:14b]

Servidor local que da ao Ollama a capacidade de EXPLORAR e PROPOR mudancas
nos arquivos do projeto -- listar pastas, ler arquivo, buscar texto, e
propor uma versao nova de um arquivo. E' o "motor" por tras do Modo Agente
do scripts/web/assistente_ia.html.

Regras de seguranca, de proposito nao-negociaveis:
  - So enxerga arquivos DENTRO da raiz do projeto (sem ../, sem caminho
    absoluto de fora).
  - Nunca le nem escreve .env, nem nada em scripts/db/ que pareça segredo.
  - NUNCA escreve nada em disco sozinho. `propor_edicao` so guarda a
    proposta em memoria; so o endpoint /aplicar escreve, e so nos arquivos
    que o usuario marcou como aprovados na tela.
  - Loop tem um teto de passos (--max-passos) pra nao ficar chamando
    ferramenta pra sempre se o modelo entrar em roda-viva.

So usa a biblioteca padrao do Python (nenhum pip install).
"""
import argparse
import difflib
import fnmatch
import http.server
import json
import os
import re
import socketserver
import sys
import threading
import time
import urllib.error
import urllib.request
import uuid

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OLLAMA_URL = "http://localhost:11434/api/chat"
MODELO_PADRAO = "qwen2.5:14b"
MAX_PASSOS_PADRAO = 15
MAX_CHARS_LEITURA = 60000   # teto por arquivo lido -- acima disso o modelo (32k tokens) nao da conta
MAX_RESULTADOS_BUSCA = 60

# pastas que o agente nunca deve tocar (segredo, geradas, binario)
BLOQUEADAS = ("scripts/db", ".git", "node_modules", "musicas", "efeitos_sonoros")
ARQUIVOS_BLOQUEADOS = (".env",)
EXT_TEXTO = (".md", ".js", ".html", ".py", ".json", ".css", ".sql", ".txt", ".yml", ".yaml")

PROPOSTAS = {}  # id_sessao -> {caminho_relativo: {"conteudo_novo","motivo","existia","conteudo_antigo"}}
LIDOS_INTEIROS = {}  # id_sessao -> set(caminho_relativo) -- arquivos que o modelo leu SEM truncar nesta sessao

SYSTEM_PROMPT = """Voce e' um assistente de edicao de conteudo para o repositorio de uma
campanha de RPG de mesa (Sword Art Online: The Perfect Chaos, sistema Aincrad RPG/PBTA).
O repositorio tem docs/ (guia de sistema, historia), monstros/, npcs/, armas/, equipamentos/,
cenas/, guias/ (regioes) -- tudo em Markdown com front-matter, em portugues.

Voce tem ferramentas pra EXPLORAR o projeto (listar_arquivos, ler_arquivo, buscar_texto) e
pra PROPOR mudancas (propor_edicao). Regras obrigatorias:

1. NUNCA proponha edicao em um arquivo que voce nao leu antes com ler_arquivo nesta mesma
   conversa. Se nao leu, leia primeiro.
2. Ao propor edicao, envie o CONTEUDO INTEIRO do arquivo (com a mudanca ja aplicada), nao um
   trecho nem um diff -- o arquivo completo, do jeito que deve ficar salvo.
3. Preserve o formato original: front-matter, campos, secoes, tom em portugues do arquivo.
   Nao invente campos novos sem necessidade; se adicionar um campo novo, siga o padrao dos
   campos que ja existem no arquivo (ou no _modelo_*.md da pasta, se existir).
4. Suas propostas NAO sao salvas automaticamente -- elas ficam pendentes ate o usuario
   aprovar cada uma manualmente. Por isso pode (e deve) propor edicao em quantos arquivos
   forem necessarios pra cumprir o pedido -- o usuario decide o que aceitar depois.
5. Quando tiver terminado de explorar e propor tudo que o pedido exige, pare de chamar
   ferramentas e escreva um resumo final em texto: o que voce mudou, em quais arquivos, e
   por que. Se algo do pedido ficou ambiguo ou voce nao teve certeza, diga isso no resumo
   em vez de inventar.
"""

FERRAMENTAS = [
    {
        "type": "function",
        "function": {
            "name": "listar_arquivos",
            "description": "Lista os arquivos de uma pasta do projeto (nao recursivo).",
            "parameters": {
                "type": "object",
                "properties": {"pasta": {"type": "string", "description": "caminho relativo, ex: monstros"}},
                "required": ["pasta"],
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "ler_arquivo",
            "description": "Le o conteudo de um arquivo de texto do projeto.",
            "parameters": {
                "type": "object",
                "properties": {"caminho": {"type": "string", "description": "caminho relativo, ex: monstros/lobo.md"}},
                "required": ["caminho"],
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "buscar_texto",
            "description": "Busca um trecho de texto (case-insensitive) em arquivos do projeto, tipo grep. Devolve arquivo e linha de cada ocorrencia.",
            "parameters": {
                "type": "object",
                "properties": {
                    "padrao": {"type": "string"},
                    "pasta": {"type": "string", "description": "opcional, limita a busca a essa pasta"},
                },
                "required": ["padrao"],
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "propor_edicao",
            "description": "Registra uma proposta de novo conteudo para um arquivo (nao escreve em disco -- fica pendente de aprovacao do usuario).",
            "parameters": {
                "type": "object",
                "properties": {
                    "caminho": {"type": "string"},
                    "conteudo_novo": {"type": "string", "description": "arquivo inteiro, ja com a mudanca aplicada"},
                    "motivo": {"type": "string", "description": "explicacao curta do que mudou e por que"},
                },
                "required": ["caminho", "conteudo_novo"],
            },
        },
    },
]


# --------------------------------------------------------------------------
# seguranca de caminho
# --------------------------------------------------------------------------

class CaminhoInvalido(Exception):
    pass


def resolver_caminho(rel):
    rel = (rel or "").strip().replace("\\", "/").lstrip("/")
    alvo = os.path.normpath(os.path.join(RAIZ, rel))
    raiz_norm = os.path.normpath(RAIZ)
    if alvo != raiz_norm and not alvo.startswith(raiz_norm + os.sep):
        raise CaminhoInvalido(f"'{rel}' sai da pasta do projeto -- recusado.")
    rel_norm = os.path.relpath(alvo, raiz_norm).replace(os.sep, "/")
    if any(rel_norm == b or rel_norm.startswith(b + "/") for b in BLOQUEADAS):
        raise CaminhoInvalido(f"'{rel_norm}' e' uma pasta bloqueada pro agente.")
    if os.path.basename(alvo) in ARQUIVOS_BLOQUEADOS:
        raise CaminhoInvalido(f"'{rel_norm}' nao pode ser lido/editado pelo agente.")
    return alvo, rel_norm


# --------------------------------------------------------------------------
# ferramentas
# --------------------------------------------------------------------------

def ferr_listar_arquivos(pasta):
    alvo, rel_norm = resolver_caminho(pasta)
    if not os.path.isdir(alvo):
        return {"erro": f"'{rel_norm}' nao e' uma pasta"}
    itens = sorted(os.listdir(alvo))
    itens = [i for i in itens if not i.startswith(".")]
    return {"pasta": rel_norm, "itens": itens[:300]}


def checar_extensao_texto(rel_norm):
    if not rel_norm.lower().endswith(EXT_TEXTO):
        raise CaminhoInvalido(
            f"'{rel_norm}' nao e' um arquivo de texto (extensoes aceitas: {', '.join(EXT_TEXTO)}) -- "
            "o agente nao mexe em imagem/binario, so em conteudo escrito."
        )


def ferr_ler_arquivo(id_sessao, caminho):
    alvo, rel_norm = resolver_caminho(caminho)
    if not os.path.isfile(alvo):
        return {"erro": f"'{rel_norm}' nao existe"}
    checar_extensao_texto(rel_norm)
    with open(alvo, "r", encoding="utf-8", errors="replace") as f:
        conteudo = f.read()
    truncado = len(conteudo) > MAX_CHARS_LEITURA
    if truncado:
        conteudo = conteudo[:MAX_CHARS_LEITURA]
        return {
            "caminho": rel_norm, "conteudo": conteudo, "truncado": True,
            "aviso": (f"Este arquivo tem mais de {MAX_CHARS_LEITURA} caracteres e foi CORTADO nesta "
                      "leitura -- voce esta vendo so o comeco. NAO chame propor_edicao pra ele: "
                      "reescrever o arquivo inteiro com base num trecho truncado apagaria o resto. "
                      "Se o pedido exige mudar algo perto do fim, avise no resumo final que esse "
                      "arquivo e' grande demais pra editar com seguranca nesta ferramenta."),
        }
    LIDOS_INTEIROS.setdefault(id_sessao, set()).add(rel_norm)
    return {"caminho": rel_norm, "conteudo": conteudo, "truncado": False}


def ferr_buscar_texto(padrao, pasta=None):
    base = RAIZ
    rel_base = ""
    if pasta:
        base, rel_base = resolver_caminho(pasta)
    achados = []
    padrao_re = re.compile(re.escape(padrao), re.IGNORECASE)
    for raiz_atual, dirs, arquivos in os.walk(base):
        rel_raiz = os.path.relpath(raiz_atual, RAIZ).replace(os.sep, "/")
        if rel_raiz == ".":
            rel_raiz = ""
        dirs[:] = [d for d in dirs if not d.startswith(".") and
                   not any((rel_raiz + "/" + d if rel_raiz else d) == b or (rel_raiz + "/" + d if rel_raiz else d).startswith(b + "/") for b in BLOQUEADAS)]
        for nome in arquivos:
            if not nome.lower().endswith(EXT_TEXTO):
                continue
            caminho_rel = (rel_raiz + "/" + nome) if rel_raiz else nome
            try:
                with open(os.path.join(raiz_atual, nome), "r", encoding="utf-8", errors="replace") as f:
                    for i, linha in enumerate(f, 1):
                        if padrao_re.search(linha):
                            achados.append({"arquivo": caminho_rel, "linha": i, "trecho": linha.strip()[:200]})
                            if len(achados) >= MAX_RESULTADOS_BUSCA:
                                return {"padrao": padrao, "achados": achados, "truncado": True}
            except (UnicodeDecodeError, OSError):
                continue
    return {"padrao": padrao, "achados": achados, "truncado": False}


def ferr_propor_edicao(id_sessao, caminho, conteudo_novo, motivo=""):
    alvo, rel_norm = resolver_caminho(caminho)
    checar_extensao_texto(rel_norm)
    existia = os.path.isfile(alvo)
    if existia and rel_norm not in LIDOS_INTEIROS.get(id_sessao, set()):
        return {"erro": (
            f"Recusado: '{rel_norm}' ja existe e voce nao leu ele INTEIRO nesta conversa (ou ele e' "
            f"grande demais e veio truncado). Pra propor edicao num arquivo que ja existe, primeiro "
            f"chame ler_arquivo nele e confirme que 'truncado' veio false. Se veio true, esse arquivo "
            "e' grande demais pra essa ferramenta editar com seguranca -- explique isso no resumo."
        )}
    conteudo_antigo = ""
    if existia:
        with open(alvo, "r", encoding="utf-8", errors="replace") as f:
            conteudo_antigo = f.read()
    PROPOSTAS.setdefault(id_sessao, {})[rel_norm] = {
        "conteudo_novo": conteudo_novo,
        "conteudo_antigo": conteudo_antigo,
        "motivo": motivo,
        "existia": existia,
    }
    return {"status": "proposta registrada, aguardando aprovacao do usuario", "caminho": rel_norm}


def executar_ferramenta(id_sessao, nome, args):
    try:
        if nome == "listar_arquivos":
            return ferr_listar_arquivos(args.get("pasta", "."))
        if nome == "ler_arquivo":
            return ferr_ler_arquivo(id_sessao, args.get("caminho", ""))
        if nome == "buscar_texto":
            return ferr_buscar_texto(args.get("padrao", ""), args.get("pasta"))
        if nome == "propor_edicao":
            return ferr_propor_edicao(id_sessao, args.get("caminho", ""), args.get("conteudo_novo", ""), args.get("motivo", ""))
        return {"erro": f"ferramenta desconhecida: {nome}"}
    except CaminhoInvalido as e:
        return {"erro": str(e)}
    except Exception as e:
        return {"erro": f"falha executando {nome}: {e}"}


# --------------------------------------------------------------------------
# loop do agente (chama Ollama com tool-calling)
# --------------------------------------------------------------------------

def chamar_ollama_chat(messages, modelo, timeout=300):
    payload = {
        "model": modelo,
        "messages": messages,
        "tools": FERRAMENTAS,
        "stream": False,
        # qwen2.5:14b tem 32768 tokens de contexto no total; 24576 deixa espaco de sobra pro
        # prompt/ferramentas e ainda cobre arquivos de ate MAX_CHARS_LEITURA (~60k chars).
        "options": {"temperature": 0.3, "num_ctx": 24576},
    }
    req = urllib.request.Request(
        OLLAMA_URL,
        data=json.dumps(payload).encode("utf-8"),
        headers={"Content-Type": "application/json"},
    )
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        return json.loads(resp.read().decode("utf-8"))


def rodar_agente(objetivo, modelo, id_sessao, max_passos, emitir):
    messages = [
        {"role": "system", "content": SYSTEM_PROMPT},
        {"role": "user", "content": objetivo},
    ]
    for passo in range(1, max_passos + 1):
        emitir({"tipo": "passo", "n": passo})
        try:
            resp = chamar_ollama_chat(messages, modelo)
        except urllib.error.URLError as e:
            emitir({"tipo": "erro", "texto": f"Nao consegui falar com o Ollama: {e}"})
            return
        except Exception as e:
            emitir({"tipo": "erro", "texto": f"Erro chamando o modelo: {e}"})
            return

        msg = resp.get("message", {})
        tool_calls = msg.get("tool_calls") or []

        if not tool_calls:
            texto = msg.get("content", "") or "(sem resposta)"
            propostas = montar_resumo_propostas(id_sessao)
            emitir({"tipo": "fim", "texto": texto, "propostas": propostas})
            return

        messages.append(msg)
        for tc in tool_calls:
            fn = tc.get("function", {})
            nome = fn.get("name", "")
            args = fn.get("arguments", {})
            if isinstance(args, str):
                try:
                    args = json.loads(args)
                except json.JSONDecodeError:
                    args = {}
            emitir({"tipo": "ferramenta", "nome": nome, "args": resumir_args(args)})
            resultado = executar_ferramenta(id_sessao, nome, args)
            emitir({"tipo": "resultado_ferramenta", "nome": nome, "resultado": resumir_resultado(resultado)})
            messages.append({"role": "tool", "content": json.dumps(resultado, ensure_ascii=False)})

    propostas = montar_resumo_propostas(id_sessao)
    emitir({"tipo": "fim", "texto": f"Parei depois de {max_passos} passos sem o modelo se dar por satisfeito. Revise as propostas abaixo (se houver) ou refine o pedido.", "propostas": propostas})


def resumir_args(args):
    out = {}
    for k, v in (args or {}).items():
        if isinstance(v, str) and len(v) > 300:
            out[k] = v[:300] + f"... ({len(v)} chars)"
        else:
            out[k] = v
    return out


def resumir_resultado(resultado):
    r = dict(resultado)
    if "conteudo" in r and isinstance(r["conteudo"], str) and len(r["conteudo"]) > 500:
        r["conteudo"] = r["conteudo"][:500] + f"... ({len(r['conteudo'])} chars, truncado no resumo)"
    return r


def montar_resumo_propostas(id_sessao):
    out = {}
    for caminho, dados in PROPOSTAS.get(id_sessao, {}).items():
        diff = "\n".join(difflib.unified_diff(
            dados["conteudo_antigo"].splitlines(),
            dados["conteudo_novo"].splitlines(),
            fromfile=f"a/{caminho}", tofile=f"b/{caminho}", lineterm="",
        ))
        out[caminho] = {"motivo": dados["motivo"], "existia": dados["existia"], "diff": diff}
    return out


# --------------------------------------------------------------------------
# servidor HTTP
# --------------------------------------------------------------------------

class Handler(http.server.BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"

    def _cors(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")

    def do_OPTIONS(self):
        self.send_response(204)
        self._cors()
        self.end_headers()

    def _json(self, status, obj):
        body = json.dumps(obj, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self._cors()
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _ler_corpo(self):
        tam = int(self.headers.get("Content-Length", 0))
        if not tam:
            return {}
        return json.loads(self.rfile.read(tam).decode("utf-8"))

    def do_POST(self):
        if self.path == "/perguntar":
            return self._perguntar()
        if self.path == "/aplicar":
            return self._aplicar()
        self._json(404, {"erro": "rota desconhecida"})

    def do_GET(self):
        if self.path == "/status":
            return self._json(200, {"ok": True, "raiz": RAIZ})
        self._json(404, {"erro": "rota desconhecida"})

    def _perguntar(self):
        try:
            corpo = self._ler_corpo()
        except Exception:
            return self._json(400, {"erro": "corpo invalido"})
        objetivo = (corpo.get("objetivo") or "").strip()
        modelo = corpo.get("modelo") or MODELO_PADRAO
        max_passos = int(corpo.get("max_passos") or self.server.max_passos)
        if not objetivo:
            return self._json(400, {"erro": "faltou 'objetivo'"})

        id_sessao = uuid.uuid4().hex[:12]
        self.send_response(200)
        self._cors()
        self.send_header("Content-Type", "application/x-ndjson; charset=utf-8")
        self.send_header("Transfer-Encoding", "chunked")
        self.end_headers()

        def emitir(evento):
            evento["id_sessao"] = id_sessao
            linha = (json.dumps(evento, ensure_ascii=False) + "\n").encode("utf-8")
            chunk = f"{len(linha):x}\r\n".encode("ascii") + linha + b"\r\n"
            try:
                self.wfile.write(chunk)
                self.wfile.flush()
            except (BrokenPipeError, ConnectionAbortedError):
                pass

        emitir({"tipo": "inicio", "modelo": modelo})
        try:
            rodar_agente(objetivo, modelo, id_sessao, max_passos, emitir)
        except Exception as e:
            emitir({"tipo": "erro", "texto": f"Erro inesperado: {e}"})
        try:
            self.wfile.write(b"0\r\n\r\n")
            self.wfile.flush()
        except (BrokenPipeError, ConnectionAbortedError):
            pass

    def _aplicar(self):
        try:
            corpo = self._ler_corpo()
        except Exception:
            return self._json(400, {"erro": "corpo invalido"})
        id_sessao = corpo.get("id_sessao", "")
        arquivos = corpo.get("arquivos") or []
        pendentes = PROPOSTAS.get(id_sessao, {})
        aplicados, falhas = [], []
        for caminho in arquivos:
            dados = pendentes.get(caminho)
            if not dados:
                falhas.append({"caminho": caminho, "erro": "proposta nao encontrada (sessao expirou?)"})
                continue
            try:
                alvo, rel_norm = resolver_caminho(caminho)
                checar_extensao_texto(rel_norm)
                os.makedirs(os.path.dirname(alvo), exist_ok=True)
                with open(alvo, "w", encoding="utf-8", newline="\n") as f:
                    f.write(dados["conteudo_novo"])
                aplicados.append(rel_norm)
            except Exception as e:
                falhas.append({"caminho": caminho, "erro": str(e)})
        self._json(200, {"aplicados": aplicados, "falhas": falhas})

    def log_message(self, fmt, *args):
        print("[agente]", fmt % args)


class ServidorThreaded(socketserver.ThreadingMixIn, http.server.HTTPServer):
    daemon_threads = True


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--porta", type=int, default=8787)
    ap.add_argument("--modelo", default=MODELO_PADRAO)
    ap.add_argument("--max-passos", type=int, default=MAX_PASSOS_PADRAO)
    args = ap.parse_args()

    httpd = ServidorThreaded(("127.0.0.1", args.porta), Handler)
    httpd.max_passos = args.max_passos
    print(f"Servidor do agente em http://127.0.0.1:{args.porta}  (raiz: {RAIZ})")
    print(f"Modelo padrao: {args.modelo}  |  max passos por pedido: {args.max_passos}")
    print("Abra scripts/web/assistente_ia.html, ligue o 'Modo Agente'. Ctrl+C pra parar.")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nParando.")


if __name__ == "__main__":
    main()
