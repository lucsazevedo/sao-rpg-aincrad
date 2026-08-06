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
import os
import sys

RAIZ = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
sys.path.insert(0, os.path.join(RAIZ, "scripts"))

from ollama_client import chamar_ollama, extrair_json, MODELO_RAPIDO  # noqa: E402
from gerar_dados_web import frontmatter, ler, secoes  # noqa: E402

ATRIBUTOS = ["Corpo", "Reflexo", "Conhecimento", "Espírito", "Técnica"]


# --------------------------------------------------------------------------
# Item 13: propor atributo_fraqueza pra cada monstro que hoje tem elemento
# --------------------------------------------------------------------------

def tarefa_elemento_para_atributo():
    dir_ = os.path.join(RAIZ, "monstros")
    saida = os.path.join(RAIZ, "dolist", "revisao_item13_elemento_para_atributo.md")
    linhas = [
        "---\ntitulo: Revisão — proposta de atributo_fraqueza (item 13)\n"
        "uso: mestre\n---\n",
        "# Proposta do Ollama — elemento → atributo\n",
        "Gerado automaticamente. **Nada foi aplicado ainda** — isto é só a",
        "proposta, monstro por monstro, pra revisar antes de trocar de verdade",
        "em `monstros/*.md` e no banco.\n",
    ]

    arquivos = sorted(
        f for f in os.listdir(dir_)
        if f.endswith(".md") and not f.startswith("_")
    )
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
        linhas.append(
            "## %s\n- arquivo: `monstros/%s`\n- elemento antigo: %s\n"
            "- **proposta: %s**\n- por quê: %s\n"
            % (nome, nome_arq, elemento_antigo, atributo, justificativa)
        )

    with open(saida, "w", encoding="utf-8") as f:
        f.write("\n".join(linhas))
    print("\nProposta escrita em %s -- revisar antes de aplicar." % saida)


TAREFAS = {
    "elemento_para_atributo": tarefa_elemento_para_atributo,
}


def main():
    if len(sys.argv) < 2 or sys.argv[1] not in TAREFAS:
        print("Uso: python scripts/orquestrar_ollama.py <tarefa>")
        print("Tarefas disponíveis: %s" % ", ".join(TAREFAS))
        return
    TAREFAS[sys.argv[1]]()


if __name__ == "__main__":
    main()
