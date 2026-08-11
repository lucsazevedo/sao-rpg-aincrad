#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Item 4 (roster) + item 7 (cartas/cristais) — importa o JSON já parseado
de dolist/'Bestiário de Aincrad.txt' pro banco. Idempotente por natureza
do id determinístico usado (slug); roda de novo sem duplicar."""
import json
import re
import sys
import unicodedata

sys.path.insert(0, "scripts")
from migrar_para_supabase import conectar  # noqa: E402

RARIDADE_POR_CATEGORIA = {
    "mini_boss": "Incomum",
    "mvp": "Raro",
    "boss": "Épico",
}
VALOR_BONUS_POR_RARIDADE = {"Incomum": 1, "Raro": 2, "Épico": 3, "Lendário": 4}


def slug(txt):
    txt = unicodedata.normalize("NFKD", txt).encode("ascii", "ignore").decode()
    txt = re.sub(r"[^a-zA-Z0-9]+", "_", txt).strip("_").lower()
    return txt


def separar_emoji(nome_bruto):
    nome_bruto = nome_bruto.strip()
    partes = nome_bruto.split(" ", 1)
    if len(partes) == 2 and ord(partes[0][0]) > 0x2100:
        return partes[0], partes[1].strip()
    return None, nome_bruto


def tipo_bonus_heuristico(nome, categoria):
    # heurística simples por palavra-chave no nome — sem tempo de curar
    # tematicamente cada uma das ~150 cartas/cristais individualmente;
    # fica marcado como "a refinar" na descrição de cada uma.
    n = nome.lower()
    if any(w in n for w in ["guardi", "escud", "arma", "couraç", "tanque", "muralha", "prote"]):
        return "resist"
    if any(w in n for w in ["sacerdote", "mago", "arcano", "divin", "sagrad", "espírito", "alma", "místic"]):
        return "especial"
    if any(w in n for w in ["rei", "senhor", "lorde", "chefe", "capitão", "líder"]):
        return "atributo"
    return "dano"


def main():
    with open("scripts/db/_bestiario_roster.json", encoding="utf-8") as f:
        roster = json.load(f)
    roster = [m for m in roster if m["andar"] is not None]

    conn = conectar()
    cur = conn.cursor()

    # ---------------- 1) roster (item 4) ----------------
    linhas_roster = []
    for m in roster:
        emoji, nome_limpo = separar_emoji(m["nome"])
        linhas_roster.append((
            m["andar"], m["bioma"], m["categoria"], nome_limpo, emoji,
            json.dumps(m["materiais"], ensure_ascii=False),
            json.dumps(m["cristais"], ensure_ascii=False),
            json.dumps(m["cartas"], ensure_ascii=False),
        ))
    cur.execute("delete from bestiario_roster")  # reimport limpo (idempotente por natureza: sem pk natural no roster)
    cur.executemany(
        """insert into bestiario_roster (andar, bioma, categoria, nome, emoji, materiais, cristais, cartas)
           values (%s,%s,%s,%s,%s,%s::jsonb,%s::jsonb,%s::jsonb)""",
        linhas_roster,
    )
    print(f"roster: {len(linhas_roster)} linhas inseridas.")

    # ---------------- 2) cartas (item 7) ----------------
    cartas_vistas = {}
    for m in roster:
        for nome_carta in m["cartas"]:
            if nome_carta in cartas_vistas:
                continue
            rar = RARIDADE_POR_CATEGORIA.get(m["categoria"], "Incomum")
            cartas_vistas[nome_carta] = dict(
                id="carta_" + slug(nome_carta),
                nome=nome_carta,
                raridade=rar,
                tipo_bonus=tipo_bonus_heuristico(nome_carta, m["categoria"]),
                valor_bonus=VALOR_BONUS_POR_RARIDADE.get(rar, 1),
                descricao=f"Efeito ainda não definido (importado do roster, categoria {m['categoria']}) — "
                          f"ver dolist/07_drops_e_cartas.md, 'Preciso saber'.",
                drop_de=separar_emoji(m["nome"])[1],
                chance_drop=0.10 if m["categoria"] == "boss" else (0.15 if m["categoria"] == "mvp" else 0.20),
            )
    for c in cartas_vistas.values():
        cur.execute(
            """insert into cartas (id,nome,raridade,tipo_bonus,valor_bonus,descricao,drop_de,chance_drop,visivel,excluido)
               values (%(id)s,%(nome)s,%(raridade)s,%(tipo_bonus)s,%(valor_bonus)s,%(descricao)s,%(drop_de)s,%(chance_drop)s,true,false)
               on conflict (id) do update set nome=excluded.nome, drop_de=excluded.drop_de""",
            c,
        )
    print(f"cartas: {len(cartas_vistas)} linhas upsertadas.")

    # ---------------- 3) cristais (item 7) ----------------
    cristais_vistos = {}
    for m in roster:
        for nome_cristal in m["cristais"]:
            if nome_cristal in cristais_vistos:
                continue
            cristais_vistos[nome_cristal] = dict(
                id="cristal_" + slug(nome_cristal),
                nome=nome_cristal,
                tipo_bonus=tipo_bonus_heuristico(nome_cristal, m["categoria"]),
                valor_bonus=VALOR_BONUS_POR_RARIDADE.get(RARIDADE_POR_CATEGORIA.get(m["categoria"], "Incomum"), 1),
                descricao="Efeito ainda não definido — ver dolist/07_drops_e_cartas.md, 'Preciso saber' (o que o cristal faz não foi decidido).",
                drop_de=separar_emoji(m["nome"])[1],
            )
    for c in cristais_vistos.values():
        cur.execute(
            """insert into cristais (id,nome,tipo_bonus,valor_bonus,descricao,drop_de,visivel,excluido)
               values (%(id)s,%(nome)s,%(tipo_bonus)s,%(valor_bonus)s,%(descricao)s,%(drop_de)s,true,false)
               on conflict (id) do update set nome=excluded.nome, drop_de=excluded.drop_de""",
            c,
        )
    print(f"cristais: {len(cristais_vistos)} linhas upsertadas.")

    conn.commit()
    print("commit ok.")


if __name__ == "__main__":
    main()
