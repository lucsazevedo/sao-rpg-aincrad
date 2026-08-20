#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Converte o conteudo existente (monstros/, npcs/, armas/) do sistema PBTA
antigo (5 atributos: Corpo/Reflexo/Conhecimento/Espirito/Tecnica) pra D&D 5e
(6 atributos: FOR/DES/CON/INT/SAB/CAR), seguindo a regra fixada na Secao 66
do SAO_RPG_5e.md.

Nao mexe em texto narrativo (Aparencia, Lore, Habitat, Historia etc.) --
so em frontmatter mecanico e insere um bloco de stat block calculado
(monstros) ou os 6 atributos D&D (npcs). Idempotente: se already
convertido (marcador no arquivo), pula.

Uso:
    python scripts/_converter_conteudo_dnd5e.py
"""
import glob
import os
import re

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# --------------------------------------------------------------------------
# regra de conversao de atributo (Secao 66 do SAO_RPG_5e.md)
# --------------------------------------------------------------------------
MAPA_ATRIBUTO = {
    "corpo": "Força",
    "reflexo": "Destreza",
    "conhecimento": "Inteligência",
    "espírito": "Sabedoria",
    "espirito": "Sabedoria",
    "técnica": "Destreza",
    "tecnica": "Destreza",
}

# formula de nivel de ameaca -> CA/PV/bonus/CD (Secao 74)
TABELA_AMEACA = {
    "fraco":  dict(pv_base=10, pv_mult=4,  ca_base=10, bonus_base=2, cd_base=10),
    "comum":  dict(pv_base=20, pv_mult=6,  ca_base=11, bonus_base=3, cd_base=11),
    "forte":  dict(pv_base=40, pv_mult=8,  ca_base=13, bonus_base=4, cd_base=13),
    "elite":  dict(pv_base=70, pv_mult=10, ca_base=15, bonus_base=5, cd_base=14),
    "chefe":  dict(pv_base=150, pv_mult=15, ca_base=16, bonus_base=6, cd_base=15),
}

MARCADOR = "<!-- convertido-dnd5e -->"


def clamp(v, lo=3, hi=20):
    return max(lo, min(hi, v))


# --------------------------------------------------------------------------
# MONSTROS
# --------------------------------------------------------------------------

def converter_monstros():
    convertidos, pulados = 0, 0
    for caminho in sorted(glob.glob(os.path.join(RAIZ, "monstros", "*.md"))):
        nome_arq = os.path.basename(caminho)
        if nome_arq.startswith("_modelo"):
            continue
        with open(caminho, encoding="utf-8") as f:
            texto = f.read()
        if MARCADOR in texto:
            pulados += 1
            continue

        m_andar = re.search(r"^andar:\s*(\d+)", texto, re.M)
        andar = int(m_andar.group(1)) if m_andar else 1

        m_ameaca = re.search(r"^nivel_ameaca:\s*(\S+)", texto, re.M)
        ameaca = (m_ameaca.group(1).strip().lower() if m_ameaca else "comum")
        if ameaca not in TABELA_AMEACA:
            ameaca = "comum"
        t = TABELA_AMEACA[ameaca]
        pv = t["pv_base"] + t["pv_mult"] * andar
        ca = t["ca_base"] + andar // 3
        bonus_ataque = t["bonus_base"] + andar // 4
        cd = t["cd_base"] + andar // 4

        m_attr = re.search(r"^atributo_fraqueza:\s*(.+)$", texto, re.M)
        attr_novo = None
        if m_attr:
            valor_antigo = m_attr.group(1).split("#")[0].strip()
            chave = valor_antigo.lower()
            attr_novo = MAPA_ATRIBUTO.get(chave)
            if attr_novo:
                texto = re.sub(
                    r"^atributo_fraqueza:\s*.+$",
                    f"atributo_fraqueza: {attr_novo}",
                    texto, count=1, flags=re.M,
                )

        # insere CA/PV/bonus/CD logo apos a linha golpes_para_derrotar
        bloco_novo = (
            f"ca: {ca}\n"
            f"pv: {pv}\n"
            f"bonus_ataque: +{bonus_ataque}\n"
            f"cd_resistencia: {cd}\n"
        )
        if re.search(r"^golpes_para_derrotar:.*$", texto, re.M):
            texto = re.sub(
                r"(^golpes_para_derrotar:.*$\n)",
                r"\1" + bloco_novo,
                texto, count=1, flags=re.M,
            )
        else:
            # insere antes do fechamento do frontmatter
            texto = texto.replace("\n---\n", "\n" + bloco_novo + "---\n", 1)

        stat_block = (
            f"\n{MARCADOR}\n\n"
            f"## Stat Block D&D 5e\n\n"
            f"Convertido automaticamente pela fórmula da Seção 74 do "
            f"`SAO_RPG_5e.md` (Nível de Ameaça **{ameaca}**, Andar {andar}). "
            f"Os textos de \"Ataques\"/\"Fraquezas\" acima são flavor "
            f"histórico (PBTA) — a mecânica real de jogo é esta:\n\n"
            f"- **CA:** {ca}\n"
            f"- **PV:** {pv}\n"
            f"- **Bônus de Ataque:** +{bonus_ataque}\n"
            f"- **CD de Resistência:** {cd}\n"
        )
        if attr_novo:
            stat_block += (
                f"- **Atributo de fraqueza:** {attr_novo} — um ataque que usa "
                f"{attr_novo} contra esta criatura causa +1d6 de dano extra "
                f"(Seção 74).\n"
            )
        stat_block += (
            "\n> Texto legado: menções a \"7-9\"/\"10+\" nas seções acima "
            "são do sistema PBTA anterior e não valem mais como mecânica — "
            "só como referência de intensidade narrativa.\n"
        )

        if "\n## Lore" in texto:
            texto = texto.replace("\n## Lore", stat_block + "\n## Lore", 1)
        elif "\n## Notas para o mestre" in texto:
            texto = texto.replace("\n## Notas para o mestre", stat_block + "\n## Notas para o mestre", 1)
        else:
            texto = texto.rstrip("\n") + "\n" + stat_block

        with open(caminho, "w", encoding="utf-8") as f:
            f.write(texto)
        convertidos += 1
    print(f"monstros: {convertidos} convertidos, {pulados} já convertidos (pulados)")


# --------------------------------------------------------------------------
# NPCS
# --------------------------------------------------------------------------

def converter_npcs():
    convertidos, pulados, sem_atributo = 0, 0, 0
    for caminho in sorted(glob.glob(os.path.join(RAIZ, "npcs", "*.md"))):
        nome_arq = os.path.basename(caminho)
        if nome_arq.startswith("_modelo"):
            continue
        with open(caminho, encoding="utf-8") as f:
            texto = f.read()
        if MARCADOR in texto:
            pulados += 1
            continue

        bloco_match = re.search(
            r"^atributos:\n"
            r"  corpo:\s*(-?\d*)\n"
            r"  reflexo:\s*(-?\d*)\n"
            r"  conhecimento:\s*(-?\d*)\n"
            r"  espirito:\s*(-?\d*)\n"
            r"  tecnica:\s*(-?\d*)\n",
            texto, re.M,
        )
        if not bloco_match:
            sem_atributo += 1
            continue

        def val(g):
            g = g.strip()
            return int(g) if g else 0

        corpo, reflexo, conhecimento, espirito, tecnica = (val(g) for g in bloco_match.groups())

        forca = clamp(10 + 2 * corpo)
        constituicao = forca
        destreza = clamp(10 + 2 * max(reflexo, tecnica))
        inteligencia = clamp(10 + 2 * conhecimento)
        sabedoria = clamp(10 + 2 * espirito)
        carisma = sabedoria

        bloco_novo = (
            "atributos:\n"
            f"  forca: {forca}\n"
            f"  destreza: {destreza}\n"
            f"  constituicao: {constituicao}\n"
            f"  inteligencia: {inteligencia}\n"
            f"  sabedoria: {sabedoria}\n"
            f"  carisma: {carisma}\n"
        )
        texto = texto[:bloco_match.start()] + bloco_novo + texto[bloco_match.end():]
        texto += f"\n{MARCADOR}\n"

        with open(caminho, "w", encoding="utf-8") as f:
            f.write(texto)
        convertidos += 1
    print(f"npcs: {convertidos} convertidos, {pulados} já convertidos, {sem_atributo} sem bloco de atributos (pulados)")


# --------------------------------------------------------------------------
# ARMAS (item-cards)
# --------------------------------------------------------------------------

MAPA_ARMA_ATRIBUTO = {
    "espada + escudo": "Força", "escudo e espada": "Força",
    "martelo": "Força", "pá": "Força",
    "lança": "Destreza", "lanca": "Destreza",
    "corrente com peso": "Destreza", "adagas": "Destreza",
    "arco e flecha": "Destreza", "espada longa": "Força", "rapieira": "Destreza",
    "katana": "Sabedoria", "manopla": "Força", "leque": "Sabedoria",
    "bastão": "Sabedoria", "bastao": "Sabedoria", "chicote": "Inteligência",
    "besta": "Destreza", "chakram": "Destreza", "chakrams": "Destreza",
    "foice": "Sabedoria",
    "adagas de arremesso": "Destreza", "machado": "Força",
}


def converter_armas():
    convertidos, pulados, sem_tipo = 0, 0, 0
    for caminho in sorted(glob.glob(os.path.join(RAIZ, "armas", "*.md"))):
        nome_arq = os.path.basename(caminho)
        if nome_arq.startswith("_modelo") or nome_arq.startswith("00_"):
            continue
        with open(caminho, encoding="utf-8") as f:
            texto = f.read()
        if MARCADOR in texto:
            pulados += 1
            continue

        m_tipo = re.search(r"^tipo:\s*(.+)$", texto, re.M)
        if not m_tipo:
            sem_tipo += 1
            continue
        tipo = m_tipo.group(1).strip().lower()
        attr_novo = MAPA_ARMA_ATRIBUTO.get(tipo)
        if not attr_novo:
            sem_tipo += 1
            continue

        texto = re.sub(
            r"^atributo_principal:\s*.*$",
            f"atributo_principal: {attr_novo}",
            texto, count=1, flags=re.M,
        )
        texto = texto.rstrip("\n") + f"\n\n{MARCADOR}\n"

        with open(caminho, "w", encoding="utf-8") as f:
            f.write(texto)
        convertidos += 1
    print(f"armas: {convertidos} convertidos, {pulados} já convertidos, {sem_tipo} sem tipo reconhecido")


if __name__ == "__main__":
    converter_monstros()
    converter_npcs()
    converter_armas()
