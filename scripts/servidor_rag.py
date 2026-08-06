#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Servidor local de busca (RAG) — recebe uma pergunta, embedda com o
Ollama local, procura os pedaços de `documento_chunks` mais parecidos por
significado, devolve em JSON. Pensado pro assistente de IA local
(`assistente_ia.html`) ou qualquer script chamar em vez de colar um
arquivo inteiro no prompt.

Roda com a MESMA conexão direta de banco que `gerar_embeddings.py` usa
(via .env) — é uma ferramenta local de confiança do mestre, então não
passa pela regra de "só público" que o site (com login de verdade) usa;
mostra tudo que não estiver excluído. Se um dia isso for exposto pra além
da própria máquina, trocar pra ir através do Supabase com sessão real.

Uso:
    python scripts/servidor_rag.py            # porta 8788
    curl -X POST localhost:8788/buscar -d '{"pergunta":"como funciona dano elemental","k":5}'
"""
import http.server
import json
import os
import socketserver
import urllib.request

import psycopg2

RAIZ = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
OLLAMA_URL = "http://localhost:11434"
MODELO_EMBED = "nomic-embed-text"
PORTA = 8788


def carregar_env():
    env = {}
    with open(os.path.join(RAIZ, ".env"), encoding="utf-8") as f:
        for linha in f:
            linha = linha.strip()
            if linha and "=" in linha and not linha.startswith("#"):
                k, v = linha.split("=", 1)
                env[k] = v
    return env


ENV = carregar_env()


def conectar():
    return psycopg2.connect(
        host=ENV["SUPABASE_DB_HOST"], port=ENV["SUPABASE_DB_PORT"],
        dbname=ENV["SUPABASE_DB_NAME"], user=ENV["SUPABASE_DB_USER"],
        password=ENV["SUPABASE_DB_PASSWORD"], sslmode="require",
    )


def embeddar(texto):
    body = json.dumps({"model": MODELO_EMBED, "prompt": texto}).encode("utf-8")
    req = urllib.request.Request(
        OLLAMA_URL + "/api/embeddings", data=body,
        headers={"Content-Type": "application/json"},
    )
    with urllib.request.urlopen(req, timeout=60) as r:
        return json.loads(r.read())["embedding"]


def vec_literal(v):
    return "[" + ",".join(repr(float(x)) for x in v) + "]"


def buscar(pergunta, k=5, categoria=None):
    emb = vec_literal(embeddar(pergunta))
    conn = conectar()
    cur = conn.cursor()
    sql = """
        select d.id, d.titulo, d.caminho, d.categoria, c.titulo_secao, c.conteudo,
               1 - (c.embedding <=> %s::vector) as similaridade
        from documento_chunks c
        join documentos d on d.id = c.documento_id
        where d.visivel = true and d.excluido = false
    """
    params = [emb]
    if categoria:
        sql += " and d.categoria = %s"
        params.append(categoria)
    sql += " order by c.embedding <=> %s::vector limit %s"
    params += [emb, k]
    cur.execute(sql, params)
    linhas = cur.fetchall()
    cur.close()
    conn.close()
    return [
        {
            "documento_id": r[0], "titulo": r[1], "caminho": r[2],
            "categoria": r[3], "titulo_secao": r[4], "conteudo": r[5],
            "similaridade": round(r[6], 4),
        }
        for r in linhas
    ]


class Handler(http.server.BaseHTTPRequestHandler):
    def _cors(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")

    def do_OPTIONS(self):
        self.send_response(204)
        self._cors()
        self.end_headers()

    def do_POST(self):
        if self.path != "/buscar":
            self.send_error(404)
            return
        tam = int(self.headers.get("Content-Length", 0))
        try:
            corpo = json.loads(self.rfile.read(tam) or b"{}")
            pergunta = corpo.get("pergunta", "").strip()
            if not pergunta:
                raise ValueError("campo 'pergunta' vazio")
            resultados = buscar(
                pergunta, k=int(corpo.get("k", 5)), categoria=corpo.get("categoria")
            )
            saida = json.dumps({"resultados": resultados}, ensure_ascii=False).encode("utf-8")
            self.send_response(200)
            self._cors()
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.end_headers()
            self.wfile.write(saida)
        except Exception as e:
            erro = json.dumps({"erro": str(e)}).encode("utf-8")
            self.send_response(400)
            self._cors()
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.end_headers()
            self.wfile.write(erro)

    def log_message(self, fmt, *args):
        print("[rag] " + (fmt % args))


def main():
    with socketserver.ThreadingTCPServer(("127.0.0.1", PORTA), Handler) as httpd:
        print("Servidor RAG em http://localhost:%d/buscar (POST, JSON: {pergunta, k, categoria})" % PORTA)
        httpd.serve_forever()


if __name__ == "__main__":
    main()
