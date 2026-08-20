#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Converte a notacao "2d6+Atributo" (PBTA) pra "d20+ModAtributo" (D&D 5e)
dentro de texto narrativo (cenas/quests, receitas, servicos de NPC, guias
de ponto) -- SEM tocar em outra prosa. So mexe no token de dado em si
(padrao fixo e estreito: "2d6" seguido de "+"/" + " e um dos 5 nomes de
atributo PBTA, ou "arma"/"Oficio"/generico), preservando tudo em volta.

Nao mexe nas faixas de sucesso "10+/7-9/6-" soltas no meio de paragrafo
(risco de falso positivo com outros numeros) -- so o token de dado.

Uso:
    python scripts/_converter_2d6_narrativo.py
"""
import glob
import os
import re

RAIZ = os.path.dirname(os.path.abspath(__file__))
RAIZ_PROJETO = os.path.dirname(RAIZ)

MAPA_ATRIBUTO = {
    "corpo": "Força",
    "reflexo": "Destreza",
    "conhecimento": "Inteligência",
    "espírito": "Sabedoria",
    "espirito": "Sabedoria",
    "técnica": "Destreza",
    "tecnica": "Destreza",
}

PADROES = [
    os.path.join(RAIZ_PROJETO, "cenas", "*.md"),
    os.path.join(RAIZ_PROJETO, "docs", "receitas_*.md"),
    os.path.join(RAIZ_PROJETO, "docs", "servicos_*.md"),
    os.path.join(RAIZ_PROJETO, "docs", "catalogo_receitas_por_oficio.md"),
    os.path.join(RAIZ_PROJETO, "docs", "economia_profissoes.md"),
    os.path.join(RAIZ_PROJETO, "docs", "guia_publico_andar1.md"),
    os.path.join(RAIZ_PROJETO, "docs", "oficios_andar1.md"),
    os.path.join(RAIZ_PROJETO, "docs", "producao_por_oficio.md"),
    os.path.join(RAIZ_PROJETO, "docs", "puzzles_andar1.md"),
    os.path.join(RAIZ_PROJETO, "docs", "visao_geral.md"),
    os.path.join(RAIZ_PROJETO, "Comidas", "*.md"),
    os.path.join(RAIZ_PROJETO, "pocoes", "*.md"),
    os.path.join(RAIZ_PROJETO, "guias", "*.md"),
    os.path.join(RAIZ_PROJETO, "guias", "pontos", "*.md"),
    os.path.join(RAIZ_PROJETO, "mapas", "dungeons_andar1.md"),
    os.path.join(RAIZ_PROJETO, "monstros", "frenzy_boar.md"),
    os.path.join(RAIZ_PROJETO, "npcs", "nissa.md"),
    os.path.join(RAIZ_PROJETO, "personagens", "umbra.md"),
]

RE_ATRIBUTO = re.compile(
    r"2d6\s*\+\s*(Corpo|Reflexo|Conhecimento|Esp[íi]rito|T[ée]cnica)",
    re.IGNORECASE,
)
RE_ARMA = re.compile(r"2d6\s*\+\s*arma\b", re.IGNORECASE)
RE_OFICIO = re.compile(r"2d6\s*\+\s*Of[íi]cio\b", re.IGNORECASE)
RE_GENERICO = re.compile(r"2d6\s*\+\s*\[atributo\]", re.IGNORECASE)
RE_GENERICO2 = re.compile(r"2d6\s*\+\s*atributo\b", re.IGNORECASE)


def converter_texto(texto):
    def sub_attr(m):
        nome = MAPA_ATRIBUTO[m.group(1).lower()]
        return f"d20+{nome}"

    texto = RE_ATRIBUTO.sub(sub_attr, texto)
    texto = RE_ARMA.sub("d20+arma", texto)
    texto = RE_OFICIO.sub("d20+Ofício", texto)
    texto = RE_GENERICO.sub("d20+[atributo]", texto)
    texto = RE_GENERICO2.sub("d20+atributo", texto)
    return texto


def main():
    arquivos = []
    for padrao in PADROES:
        arquivos.extend(glob.glob(padrao))
    arquivos = sorted(set(arquivos))

    convertidos = 0
    trocas_totais = 0
    for caminho in arquivos:
        with open(caminho, encoding="utf-8") as f:
            original = f.read()
        novo = converter_texto(original)
        if novo != original:
            n_trocas = len(RE_ATRIBUTO.findall(original)) + len(RE_ARMA.findall(original)) + \
                len(RE_OFICIO.findall(original)) + len(RE_GENERICO.findall(original)) + len(RE_GENERICO2.findall(original))
            with open(caminho, "w", encoding="utf-8") as f:
                f.write(novo)
            convertidos += 1
            trocas_totais += n_trocas
            rel = os.path.relpath(caminho, RAIZ_PROJETO)
            print(f"{rel}: {n_trocas} trocas")

    print(f"\n{convertidos} arquivos convertidos, {trocas_totais} trocas de token 2d6+X -> d20+X")

    # checagem final: quanto sobrou de "2d6" nos arquivos alvo (deve ser só
    # menção solta em prosa, tipo comparação "2d6 vs d20", não token de teste)
    sobrou = 0
    for caminho in arquivos:
        with open(caminho, encoding="utf-8") as f:
            texto = f.read()
        n = len(re.findall(r"2d6", texto))
        if n:
            sobrou += n
            rel = os.path.relpath(caminho, RAIZ_PROJETO)
            print(f"  ainda tem '2d6' em {rel}: {n}x (revisar manualmente)")
    print(f"\n'2d6' restante nos arquivos alvo: {sobrou}")


if __name__ == "__main__":
    main()
