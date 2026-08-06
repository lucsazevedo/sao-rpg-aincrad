#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Orquestrador de tarefas de conteúdo pro Ollama local -- delega o que a
dolist já provou que ele faz bem (volume seguindo molde), NUNCA aplica
direto: sempre escreve uma PROPOSTA em markdown pra revisão humana antes
de qualquer coisa virar arquivo final ou linha de banco.

So usa a stdlib + o que ja existe em scripts/ollama_client.py e
scripts/gerar_dados_web.py -- nao precisa de nada novo instalado.

Uso:
    python scripts/orquestrar_ollama.py elemento_para_atributo
"""
import base64
import json
import os
import re
import sys
import urllib.request

RAIZ = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
sys.path.insert(0, os.path.join(RAIZ, "scripts"))

from ollama_client import chamar_ollama, extrair_json, MODELO_RAPIDO  # noqa: E402
from gerar_dados_web import frontmatter, ler, secoes  # noqa: E402

ATRIBUTOS = ["Corpo", "Reflexo", "Conhecimento", "Espírito", "Técnica"]
OLLAMA_URL = "http://localhost:11434/api/generate"


def modelo_disponivel(nome):
    """Confere no `ollama list` local antes de tentar usar um modelo que
    ainda pode estar baixando -- falha com mensagem clara, nao trava."""
    import subprocess
    r = subprocess.run(["ollama", "list"], capture_output=True, text=True)
    return nome.split(":")[0] in r.stdout


def chamar_ollama_visao(prompt, caminho_imagem, model="qwen2.5vl:7b", temperature=0.3, timeout=180):
    with open(caminho_imagem, "rb") as f:
        img_b64 = base64.b64encode(f.read()).decode("ascii")
    payload = {
        "model": model, "prompt": prompt, "images": [img_b64],
        "stream": False, "options": {"temperature": temperature},
    }
    req = urllib.request.Request(
        OLLAMA_URL, data=json.dumps(payload).encode("utf-8"),
        headers={"Content-Type": "application/json"},
    )
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        data = json.loads(resp.read().decode("utf-8"))
    return data["response"]


def escreve_incremental(caminho, cabecalho, marca_regex):
    """Prepara um arquivo de revisão pra escrita incremental, devolvendo o
    conjunto do que já foi processado (pra retomar sem duplicar)."""
    if os.path.exists(caminho):
        with open(caminho, "r", encoding="utf-8") as f:
            existente = f.read()
        return set(re.findall(marca_regex, existente))
    with open(caminho, "w", encoding="utf-8") as f:
        f.write(cabecalho)
    return set()


# --------------------------------------------------------------------------
# Item 13: propor atributo_fraqueza pra cada monstro que hoje tem elemento
# --------------------------------------------------------------------------

def tarefa_elemento_para_atributo():
    dir_ = os.path.join(RAIZ, "monstros")
    saida = os.path.join(RAIZ, "dolist", "revisao_item13_elemento_para_atributo.md")

    # escreve incremental (append + flush a cada monstro) -- se o processo
    # cair no meio, o que ja foi feito nao se perde.
    ja_feitos = set()
    if os.path.exists(saida):
        with open(saida, "r", encoding="utf-8") as f:
            conteudo_existente = f.read()
        ja_feitos = set(re.findall(r"- arquivo: `monstros/([^`]+)`", conteudo_existente))
    else:
        with open(saida, "w", encoding="utf-8") as f:
            f.write(
                "---\ntitulo: Revisão — proposta de atributo_fraqueza (item 13)\n"
                "uso: mestre\n---\n\n"
                "# Proposta do Ollama — elemento → atributo\n\n"
                "Gerado automaticamente. **Nada foi aplicado ainda** — isto é só a "
                "proposta, monstro por monstro, pra revisar antes de trocar de "
                "verdade em `monstros/*.md` e no banco.\n"
            )

    arquivos = sorted(
        f for f in os.listdir(dir_)
        if f.endswith(".md") and not f.startswith("_") and f not in ja_feitos
    )
    if ja_feitos:
        print("Retomando -- %d ja feitos antes, %d restantes." % (len(ja_feitos), len(arquivos)))
    print("Monstros a processar: %d" % len(arquivos))

    system = (
        "Você é designer de RPG de mesa (Sword Art Online, sistema Aincrad "
        "RPG). O jogo está removendo o sistema elemental (Fogo/Trovão/Gelo/"
        "Veneno) e substituindo por fraqueza de atributo. Os 5 atributos são: "
        "Corpo (força física), Reflexo (agilidade), Conhecimento "
        "(inteligência/leitura), Espírito (vontade/foco mental), Técnica "
        "(perícia/manejo de arma). Dada a ficha de um monstro, escolha QUAL "
        "desses 5 é a fraqueza dele -- baseado no comportamento e na "
        "aparência descrita, não no elemento antigo. Responda só com JSON: "
        '{"atributo_fraqueza": "<um dos 5, exato>", "justificativa": "<1 frase>"}.'
    )

    for i, nome_arq in enumerate(arquivos, 1):
        caminho = os.path.join(dir_, nome_arq)
        fm, corpo = frontmatter(ler(caminho))
        nome = fm.get("nome", nome_arq[:-3])
        elemento_antigo = fm.get("elemento_fraqueza", "") or "(nenhum)"
        secs = secoes(corpo)
        descricao = " ".join(
            secs.get(k, "") for k in ("Aparência", "Comportamento", "Aparencia", "Ataques")
        ).strip() or corpo[:800]

        user = "Nome: %s\nElemento antigo: %s\nDescrição:\n%s" % (
            nome, elemento_antigo, descricao[:1200],
        )
        try:
            resposta = chamar_ollama(system, user, MODELO_RAPIDO, temperature=0.3)
            dados = extrair_json(resposta)
            atributo = dados.get("atributo_fraqueza", "?")
            justificativa = dados.get("justificativa", "")
            if atributo not in ATRIBUTOS:
                atributo = "?? (\"%s\" não bateu com nenhum dos 5 -- checar na mão)" % atributo
        except Exception as e:
            atributo, justificativa = "ERRO", str(e)

        print("  [%d/%d] %s -> %s" % (i, len(arquivos), nome, atributo))
        with open(saida, "a", encoding="utf-8") as f:
            f.write(
                "\n## %s\n- arquivo: `monstros/%s`\n- elemento antigo: %s\n"
                "- **proposta: %s**\n- por quê: %s\n"
                % (nome, nome_arq, elemento_antigo, atributo, justificativa)
            )
            f.flush()

    print("\nProposta completa em %s -- revisar antes de aplicar." % saida)


# --------------------------------------------------------------------------
# Item 4a: extrair roster (bioma + comuns/miniboss/mvp/boss + drop) das
# imagens do bestiário em dolist/ -- so' o ROSTER, nao a ficha completa.
# --------------------------------------------------------------------------

def tarefa_roster_bestiario():
    dir_ = os.path.join(RAIZ, "dolist")
    saida = os.path.join(dir_, "revisao_item4_roster_bestiario.md")
    imagens = sorted(
        f for f in os.listdir(dir_)
        if f.lower().endswith(".png") and f != "Domador.png"
    )
    ja_feitas = escreve_incremental(
        saida,
        "---\ntitulo: Revisão — roster extraído das imagens do bestiário (item 4)\n"
        "uso: mestre\n---\n\n# Roster extraído — página por página\n\n"
        "Gerado automaticamente por visão (qwen2.5vl:7b). **Nada foi criado "
        "como monstro de verdade ainda** — é só o roster (nome/categoria/"
        "drop) de cada página, pra revisar antes de virar ficha completa.\n",
        r"- imagem: `dolist/([^`]+)`",
    )
    pendentes = [f for f in imagens if f not in ja_feitas]
    print("Imagens a processar: %d (de %d)" % (len(pendentes), len(imagens)))

    prompt = (
        "Esta imagem é uma página de bestiário de RPG, mostrando um ou mais "
        "andares de uma torre. Pra cada andar mostrado, extraia: número do "
        "andar, nome do bioma/região, lista de monstros Comuns (só nomes), "
        "Mini Boss (nome + itens de drop), MVP (nome + drops), Boss (nome + "
        "drops). Responda em JSON: {\"andares\": [{\"andar\": N, \"bioma\": "
        "\"...\", \"comuns\": [...], \"mini_boss\": {\"nome\":..,\"drops\":[...]}, "
        "\"mvp\": {...}, \"boss\": {...}}, ...]}. Só o JSON, nada mais."
    )

    for i, nome_img in enumerate(pendentes, 1):
        caminho = os.path.join(dir_, nome_img)
        print("  [%d/%d] %s..." % (i, len(pendentes), nome_img))
        try:
            resposta = chamar_ollama_visao(prompt, caminho, timeout=240)
            dados = extrair_json(resposta)
            texto = json.dumps(dados, ensure_ascii=False, indent=1)
        except Exception as e:
            texto = "ERRO: %s" % e
        with open(saida, "a", encoding="utf-8") as f:
            f.write("\n## %s\n- imagem: `dolist/%s`\n```json\n%s\n```\n" % (nome_img, nome_img, texto))
            f.flush()

    print("\nRoster em %s -- revisar antes de virar ficha." % saida)


# --------------------------------------------------------------------------
# Item 1: propor quais monstros domáveis existentes rendem ovo/pet, e um
# resumo de efeito (o craft de verdade fica pro Domador, isto é só proposta)
# --------------------------------------------------------------------------

def tarefa_pets_domador():
    dir_ = os.path.join(RAIZ, "monstros")
    saida = os.path.join(RAIZ, "dolist", "revisao_item1_pets_domador.md")
    ja_feitos = escreve_incremental(
        saida,
        "---\ntitulo: Revisão — proposta de pets a partir de monstros domáveis (item 1)\n"
        "uso: mestre\n---\n\n# Proposta do Ollama — pet por monstro domável\n\n"
        "Gerado automaticamente. **Nada foi aplicado** — proposta de quais "
        "monstros já domáveis rendem bem um pet-craft e qual seria o efeito "
        "resumido dele.\n",
        r"- arquivo: `monstros/([^`]+)`",
    )

    candidatos = []
    for nome_arq in sorted(os.listdir(dir_)):
        if nome_arq.startswith("_") or not nome_arq.endswith(".md") or nome_arq in ja_feitos:
            continue
        fm, _ = frontmatter(ler(os.path.join(dir_, nome_arq)))
        if str(fm.get("domavel", "")).strip().lower() == "sim":
            candidatos.append((nome_arq, fm))
    print("Monstros domáveis a processar: %d" % len(candidatos))

    system = (
        "Você é designer de RPG (Sword Art Online, sistema Aincrad RPG). O "
        "Domador agora também pode chocar ovo de monstro e criar um pet -- "
        "o pet funciona como um item craftado, com efeito curto (\"bate\", "
        "\"dá bônus de X\", etc), não uma ficha de monstro completa. Dado um "
        "monstro já domável, proponha um nome de pet (versão filhote/jovem "
        "dele) e um efeito de UMA frase pro craft, pensando em raridade "
        "Incomum (nem fraco nem exagerado). Responda em JSON: "
        '{"nome_pet": "...", "efeito": "..."}.'
    )

    for i, (nome_arq, fm) in enumerate(candidatos, 1):
        nome = fm.get("nome", nome_arq[:-3])
        print("  [%d/%d] %s..." % (i, len(candidatos), nome))
        try:
            resposta = chamar_ollama(system, "Monstro: %s" % nome, MODELO_RAPIDO, temperature=0.5)
            dados = extrair_json(resposta)
            nome_pet = dados.get("nome_pet", "?")
            efeito = dados.get("efeito", "?")
        except Exception as e:
            nome_pet, efeito = "ERRO", str(e)
        with open(saida, "a", encoding="utf-8") as f:
            f.write(
                "\n## %s\n- arquivo: `monstros/%s`\n- **pet proposto: %s**\n- efeito: %s\n"
                % (nome, nome_arq, nome_pet, efeito)
            )
            f.flush()

    print("\nProposta em %s -- revisar antes de aplicar." % saida)


# --------------------------------------------------------------------------
# Item 2 (piloto): desenha 2 golpes normais (atributo diferente do
# principal) + Limit Breaker pra UMA arma só -- modelo pra aprovar antes
# de repetir pras 23. Usa devstral:24b se já tiver baixado (engenharia de
# regra fina se beneficia mais de um modelo maior); cai pro qwen 14b se não.
# --------------------------------------------------------------------------

def tarefa_moves_arma_piloto():
    arma = "Foice"
    atributo_principal = "Técnica"
    model = "devstral:24b" if modelo_disponivel("devstral") else MODELO_RAPIDO
    print("Piloto da arma '%s' usando modelo: %s" % (arma, model))

    system = (
        "Você é designer de regras pra um RPG PBTA (Powered by the "
        "Apocalypse) adaptado de Sword Art Online. Toda Move segue o "
        "formato: nome, teste '2d6+Atributo', resultado em 10+ (escolha "
        "entre opções) e 7-9 (sucesso com custo). Os 5 atributos: Corpo, "
        "Reflexo, Conhecimento, Espírito, Técnica. A arma '%s' já tem um "
        "golpe principal usando %s (Move de Combate já existente, não "
        "repita). Crie MAIS 2 golpes normais pra ela, cada um usando um "
        "atributo DIFERENTE de %s e diferente entre si, e 1 golpe especial "
        "'Limit Breaker' -- destravado só depois de um contador de "
        "sucesso/erro bater 10, mais forte que os outros 3. Responda em "
        "JSON: {\"golpe_2\": {\"nome\":..,\"atributo\":..,\"teste\":..,"
        "\"dez_mais\":..,\"sete_nove\":..}, \"golpe_3\": {...(mesmo "
        "formato, atributo diferente do golpe_2)}, \"limit_breaker\": "
        "{\"nome\":..,\"atributo\":..,\"efeito\":..}}."
    ) % (arma, atributo_principal, atributo_principal)

    resposta = chamar_ollama(system, "Arma: %s" % arma, model, temperature=0.6, timeout=300)
    dados = extrair_json(resposta)

    saida = os.path.join(RAIZ, "dolist", "revisao_item2_moves_arma_piloto.md")
    with open(saida, "w", encoding="utf-8") as f:
        f.write(
            "---\ntitulo: Revisão — piloto de golpes novos (item 2)\nuso: mestre\n---\n\n"
            "# Piloto — %s (modelo usado: %s)\n\n"
            "Gerado automaticamente, **nada aplicado**. Se aprovar o formato, "
            "repete pras outras 22 armas.\n\n```json\n%s\n```\n"
            % (arma, model, json.dumps(dados, ensure_ascii=False, indent=1))
        )
    print("Piloto em %s -- revisar antes de escalar pras outras 22 armas." % saida)


# --------------------------------------------------------------------------
# Item 2 (escala): repete o piloto pras 23 armas, escrita incremental
# (retomável) igual ao item 13. Usa devstral:24b se disponível.
# --------------------------------------------------------------------------

ARMAS_ATRIBUTO = {
    "Arco e Flecha": "Reflexo", "Adagas": "Técnica",
    "Adagas de Arremesso": "Reflexo", "Besta": "Reflexo",
    "Chakrams": "Técnica", "Chicote": "Conhecimento",
    "Escudo e Espada": "Corpo", "Espada Longa": "Corpo",
    "Foice": "Técnica", "Katana": "Espírito", "Lança": "Técnica",
    "Machado": "Corpo", "Martelo": "Corpo", "Pá": "Conhecimento",
    "Rapieira": "Reflexo", "Bastão": "Espírito", "Tonfas": "Técnica",
    "Clava": "Corpo", "Nunchaku": "Técnica", "Glaive": "Reflexo",
    "Corrente com Peso": "Técnica", "Manopla": "Corpo", "Leque": "Técnica",
}


def tarefa_moves_arma_todas():
    model = "devstral:24b" if modelo_disponivel("devstral") else MODELO_RAPIDO
    saida = os.path.join(RAIZ, "dolist", "revisao_item2_moves_arma_todas.md")
    ja_feitas = escreve_incremental(
        saida,
        "---\ntitulo: Revisão — golpes novos pras 23 armas (item 2)\nuso: mestre\n---\n\n"
        "# Proposta do Ollama — 2 golpes extra + Limit Breaker por arma\n\n"
        "Gerado automaticamente (modelo: %s). **Nada aplicado ainda** — "
        "proposta arma por arma, pra revisar antes de somar aos moves já "
        "existentes em `MOVES_ARMA`/banco.\n" % model,
        r"- arma: `([^`]+)`",
    )
    pendentes = [(a, attr) for a, attr in ARMAS_ATRIBUTO.items() if a not in ja_feitas]
    if ja_feitas:
        print("Retomando -- %d ja feitas antes, %d restantes." % (len(ja_feitas), len(pendentes)))
    print("Armas a processar: %d (modelo: %s)" % (len(pendentes), model))

    system = (
        "Você é designer de regras pra um RPG PBTA (Powered by the "
        "Apocalypse) adaptado de Sword Art Online. Toda Move segue o "
        "formato: nome, teste '2d6+Atributo', resultado em 10+ (escolha "
        "entre opções) e 7-9 (sucesso com custo). Os 5 atributos: Corpo, "
        "Reflexo, Conhecimento, Espírito, Técnica. A arma '%s' já tem um "
        "golpe principal usando %s (Move de Combate já existente, não "
        "repita). Crie MAIS 2 golpes normais pra ela, cada um usando um "
        "atributo DIFERENTE de %s e diferente entre si, e 1 golpe especial "
        "'Limit Breaker' -- destravado só depois de um contador de "
        "sucesso/erro bater 10, mais forte que os outros 3. Responda em "
        "JSON: {\"golpe_2\": {\"nome\":..,\"atributo\":..,\"teste\":..,"
        "\"dez_mais\":..,\"sete_nove\":..}, \"golpe_3\": {...(mesmo "
        "formato, atributo diferente do golpe_2)}, \"limit_breaker\": "
        "{\"nome\":..,\"atributo\":..,\"efeito\":..}}."
    )

    for i, (arma, atributo_principal) in enumerate(pendentes, 1):
        print("  [%d/%d] %s..." % (i, len(pendentes), arma))
        try:
            resposta = chamar_ollama(
                system % (arma, atributo_principal, atributo_principal),
                "Arma: %s" % arma, model, temperature=0.6, timeout=300,
            )
            dados = extrair_json(resposta)
            texto = json.dumps(dados, ensure_ascii=False, indent=1)
        except Exception as e:
            texto = "ERRO: %s" % e
        with open(saida, "a", encoding="utf-8") as f:
            f.write("\n## %s\n- arma: `%s`\n- atributo principal: %s\n```json\n%s\n```\n"
                     % (arma, arma, atributo_principal, texto))
            f.flush()

    print("\nProposta completa em %s -- revisar antes de aplicar." % saida)


TAREFAS = {
    "elemento_para_atributo": tarefa_elemento_para_atributo,
    "roster_bestiario": tarefa_roster_bestiario,
    "pets_domador": tarefa_pets_domador,
    "moves_arma_piloto": tarefa_moves_arma_piloto,
    "moves_arma_todas": tarefa_moves_arma_todas,
}


def main():
    if len(sys.argv) < 2 or sys.argv[1] not in TAREFAS:
        print("Uso: python scripts/orquestrar_ollama.py <tarefa>")
        print("Tarefas disponíveis: %s" % ", ".join(TAREFAS))
        return
    TAREFAS[sys.argv[1]]()


if __name__ == "__main__":
    main()
