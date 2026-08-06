#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Migra o conteudo hoje espalhado em scripts/web/dados_*.js (+ cidades/*.md,
que nenhum gerador le ainda) pro banco Postgres do Supabase.

Le as credenciais de .env na raiz do projeto (nunca commitado). Roda uma vez
(idempotente: upsert por id/chave primaria) sempre que algo mudar nos
dados_*.js ou em cidades/*.md.

Uso:
    python scripts/migrar_para_supabase.py
"""
import json
import os
import re
import subprocess
import sys

import psycopg2
import psycopg2.extras

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WEB = os.path.join(RAIZ, "scripts", "web")

sys.path.insert(0, os.path.join(RAIZ, "scripts"))
from gerar_dados_web import frontmatter, secoes, slug, ler  # noqa: E402


# --------------------------------------------------------------------------
# infra
# --------------------------------------------------------------------------

def carregar_env():
    env = {}
    with open(os.path.join(RAIZ, ".env"), encoding="utf-8") as f:
        for linha in f:
            linha = linha.strip()
            if linha and "=" in linha and not linha.startswith("#"):
                k, v = linha.split("=", 1)
                env[k] = v
    return env


def conectar():
    env = carregar_env()
    conn = psycopg2.connect(
        host=env["SUPABASE_DB_HOST"],
        port=env["SUPABASE_DB_PORT"],
        dbname=env["SUPABASE_DB_NAME"],
        user=env["SUPABASE_DB_USER"],
        password=env["SUPABASE_DB_PASSWORD"],
        sslmode="require",
    )
    conn.autocommit = True
    return conn


RE_SNAKE1 = re.compile(r"(.)([A-Z][a-z]+)")
RE_SNAKE2 = re.compile(r"([a-z0-9])([A-Z])")


def to_snake(nome):
    s = RE_SNAKE1.sub(r"\1_\2", nome)
    s = RE_SNAKE2.sub(r"\1_\2", s)
    return s.lower()


EXTRATOR_JS = os.path.join(RAIZ, "scripts", "db", "extrair_dados_js.js")


def carregar_dados_js(caminho):
    """Roda o arquivo numa VM Node de verdade e devolve os `var` de nivel
    superior como dict. Os dados_*.js sao JS de fato (tem string com `+`,
    chave sem aspas etc.), nao JSON puro — reparsear na mao e fragil demais,
    entao deixa o proprio motor JS avaliar."""
    r = subprocess.run(
        ["node", EXTRATOR_JS, caminho],
        capture_output=True, text=True, encoding="utf-8",
    )
    if r.returncode != 0:
        print("  aviso: node falhou em %s:\n%s" % (caminho, r.stderr))
        return {}
    return json.loads(r.stdout)


def snake_dict(d, renomeia=None, remove=None):
    renomeia = renomeia or {}
    remove = remove or ()
    out = {}
    for k, v in d.items():
        if k in remove:
            continue
        novo = renomeia.get(k, to_snake(k))
        out[novo] = v
    return out


J = psycopg2.extras.Json


def sim_nao_bool(r, campo="canonico"):
    """'sim'/'nao' (string, PT) -> bool. So mexe se o campo existir."""
    if campo in r:
        r[campo] = str(r[campo]).strip().lower() == "sim"
    return r


def upsert(cur, tabela, pk, linhas):
    if not linhas:
        return 0
    cols = sorted({c for linha in linhas for c in linha.keys()})
    cols_sql = ",".join('"%s"' % c for c in cols)
    valores_ph = ",".join(["%s"] * len(cols))
    atualiza = ",".join('"%s"=excluded."%s"' % (c, c) for c in cols if c != pk)
    sql = (
        'insert into "%s" (%s) values (%s) '
        'on conflict ("%s") do update set %s'
        % (tabela, cols_sql, valores_ph, pk, atualiza)
    )
    n = 0
    for linha in linhas:
        vals = [linha.get(c) for c in cols]
        cur.execute(sql, vals)
        n += 1
    return n


# --------------------------------------------------------------------------
# coleções: dados_conteudo.js
# --------------------------------------------------------------------------

def migrar_conteudo(cur):
    blocos = carregar_dados_js(os.path.join(WEB, "dados_conteudo.js"))
    total = 0

    if "NPCS" in blocos:
        linhas = [snake_dict(r) for r in blocos["NPCS"]]
        for r in linhas:
            r["atributos"] = J(r.get("atributos") or {})
            sim_nao_bool(r)
        total += upsert(cur, "npcs", "id", linhas)

    if "MONSTROS" in blocos:
        linhas = [snake_dict(r) for r in blocos["MONSTROS"]]
        for r in linhas:
            r["drops"] = J(r.get("drops") or [])
            sim_nao_bool(r)
        total += upsert(cur, "monstros", "id", linhas)

    if "ARMAS" in blocos:
        linhas = [snake_dict(r) for r in blocos["ARMAS"]]
        total += upsert(cur, "armas", "id", linhas)

    if "EQUIPAMENTOS" in blocos:
        linhas = [snake_dict(r) for r in blocos["EQUIPAMENTOS"]]
        total += upsert(cur, "equipamentos", "id", linhas)

    if "MOVES_ARMA" in blocos:
        linhas = [snake_dict(r) for r in blocos["MOVES_ARMA"]]
        for r in linhas:
            r["move_a"] = J(r.get("move_a") or {})
            r["move_b"] = J(r.get("move_b") or {})
        total += upsert(cur, "moves_arma", "nome", linhas)

    if "MOVES_PROFISSAO" in blocos:
        linhas = [snake_dict(r) for r in blocos["MOVES_PROFISSAO"]]
        for r in linhas:
            r["move_a"] = J(r.get("move_a") or {})
            r["move_b"] = J(r.get("move_b") or {})
        total += upsert(cur, "moves_profissao", "nome", linhas)

    if "SISTEMA" in blocos:
        linhas = [snake_dict(r) for r in blocos["SISTEMA"]]
        total += upsert(cur, "sistema", "titulo", linhas)

    if "MERCADO" in blocos:
        lojas, itens = [], []
        for r in blocos["MERCADO"]:
            rid = slug(r.get("nome", ""))
            loja = snake_dict(r, renomeia={"desc": "descricao"}, remove=("itens",))
            loja["id"] = rid
            lojas.append(loja)
            for it in r.get("itens", []) or []:
                itens.append({"mercado_id": rid, **snake_dict(it)})
        total += upsert(cur, "mercado", "id", lojas)
        if itens:
            cur.execute('delete from mercado_itens where mercado_id = any(%s)',
                        ([l["id"] for l in lojas],))
            cols = sorted({c for i in itens for c in i.keys()})
            sql = 'insert into mercado_itens (%s) values (%s)' % (
                ",".join('"%s"' % c for c in cols),
                ",".join(["%s"] * len(cols)),
            )
            for it in itens:
                cur.execute(sql, [it.get(c) for c in cols])
            total += len(itens)

    if "COMPRA_MATERIAIS" in blocos:
        cur.execute("delete from compra_materiais")
        linhas = [snake_dict(r) for r in blocos["COMPRA_MATERIAIS"]]
        for r in linhas:
            cur.execute(
                "insert into compra_materiais (material,col,quem) values (%s,%s,%s)",
                (r.get("material"), r.get("col"), r.get("quem")),
            )
        total += len(linhas)

    if "QUESTS" in blocos:
        linhas = [snake_dict(r) for r in blocos["QUESTS"]]
        total += upsert(cur, "quests", "id", linhas)

    if "CRONICAS" in blocos:
        linhas = [snake_dict(r) for r in blocos["CRONICAS"]]
        total += upsert(cur, "cronicas", "id", linhas)

    if "GUIAS" in blocos:
        linhas = [snake_dict(r) for r in blocos["GUIAS"]]
        for r in linhas:
            r["acoes"] = J(r.get("acoes") or [])
            r["locais"] = J(r.get("locais") or [])
        total += upsert(cur, "guias", "id", linhas)

    if "PUZZLES" in blocos:
        linhas = []
        for r in blocos["PUZZLES"]:
            rr = snake_dict(r)
            rr["id"] = slug(rr.get("nome", ""))
            linhas.append(rr)
        total += upsert(cur, "puzzles", "id", linhas)

    if "OFICIOS" in blocos:
        linhas = [snake_dict(r) for r in blocos["OFICIOS"]]
        for r in linhas:
            r["acoes"] = J(r.get("acoes") or [])
            r["postos"] = J(r.get("postos") or [])
        total += upsert(cur, "oficios", "nome", linhas)

    if "PRODUCAO" in blocos:
        linhas = []
        for nome, r in blocos["PRODUCAO"].items():
            rr = snake_dict(r)
            rr["profissao"] = nome
            rr["itens"] = J(rr.get("itens") or [])
            linhas.append(rr)
        total += upsert(cur, "producao", "profissao", linhas)

    if "PONTOS_DETALHE" in blocos:
        linhas = []
        for pid, r in blocos["PONTOS_DETALHE"].items():
            rr = snake_dict(r)
            rr["id"] = pid
            rr["acoes"] = J(rr.get("acoes") or [])
            rr["atalhos"] = J(rr.get("atalhos") or [])
            linhas.append(rr)
        total += upsert(cur, "pontos_detalhe", "id", linhas)

    if "SALAS_DUNGEON" in blocos:
        # dungeon_id vem do mapeamento sala->dungeon feito em migrar_mapa()
        global MAPA_SALA_DUNGEON
        linhas = []
        for sid, r in blocos["SALAS_DUNGEON"].items():
            rr = snake_dict(r)
            rr["id"] = sid
            rr["dungeon_id"] = MAPA_SALA_DUNGEON.get(sid)
            linhas.append(rr)
        total += upsert(cur, "salas_dungeon", "id", linhas)

    return total


# --------------------------------------------------------------------------
# dados_mapa.js -> pontos (REGIOES/CATEGORIAS ficam estaticos, nao migram)
# --------------------------------------------------------------------------

def migrar_mapa(cur):
    blocos = carregar_dados_js(os.path.join(WEB, "dados_mapa.js"))
    total = 0
    if "PONTOS" in blocos:
        linhas = []
        for r in blocos["PONTOS"]:
            rr = snake_dict(
                r,
                renomeia={"desc": "descricao", "respawnHoras": "respawn_horas",
                          "atributoFraqueza": "atributo_fraqueza"},
                remove=("requer", "revela"),  # campos mortos, ver dados_mapa.js
            )
            rr["teste"] = J(rr.get("teste") or {})
            linhas.append(rr)
        total += upsert(cur, "pontos", "id", linhas)
    return total


# --------------------------------------------------------------------------
# dados_dungeons.js -> dungeons (+ mapa sala->dungeon pra salas_dungeon)
# --------------------------------------------------------------------------

MAPA_SALA_DUNGEON = {}


def migrar_dungeons(cur):
    global MAPA_SALA_DUNGEON
    blocos = carregar_dados_js(os.path.join(WEB, "dados_dungeons.js"))
    total = 0
    if "DUNGEONS" in blocos:
        linhas = []
        for r in blocos["DUNGEONS"]:
            rr = snake_dict(r)
            rr["setores"] = J(rr.get("setores") or [])
            rr["salas"] = J(rr.get("salas") or [])
            rr["ligacoes"] = J(rr.get("ligacoes") or [])
            linhas.append(rr)
            for sala in r.get("salas", []) or []:
                MAPA_SALA_DUNGEON[sala["id"]] = r["id"]
        total += upsert(cur, "dungeons", "id", linhas)
    return total


# --------------------------------------------------------------------------
# dados_clas.js / dados_personagens.js — ja em formato limpo
# --------------------------------------------------------------------------

def migrar_clas(cur):
    blocos = carregar_dados_js(os.path.join(WEB, "dados_clas.js"))
    total = 0
    if "CLAS" in blocos:
        linhas = [snake_dict(r) for r in blocos["CLAS"]]
        for r in linhas:
            r["reputacao"] = J(r.get("reputacao") or [])
            r["ganchos"] = J(r.get("ganchos") or [])
        total += upsert(cur, "clas", "nome", linhas)
    return total


def migrar_personagens(cur):
    blocos = carregar_dados_js(os.path.join(WEB, "dados_personagens.js"))
    total = 0
    if "PERSONAGENS" in blocos:
        linhas = [snake_dict(r) for r in blocos["PERSONAGENS"]]
        for r in linhas:
            for campo in ("atributos", "arma_detalhe", "profissao_detalhe",
                          "companheiro", "estado"):
                if campo in r:
                    r[campo] = J(r[campo])
        total += upsert(cur, "personagens", "nome", linhas)
    return total


# --------------------------------------------------------------------------
# cidades/*.md — ninguem le essa pasta hoje, entao parseia aqui mesmo
# --------------------------------------------------------------------------

def migrar_cidades(cur):
    dir_ = os.path.join(RAIZ, "cidades")
    linhas = []
    for nome_arq in sorted(os.listdir(dir_)):
        if nome_arq.startswith("_") or not nome_arq.endswith(".md"):
            continue
        fm, corpo = frontmatter(ler(os.path.join(dir_, nome_arq)))
        ident = slug(fm.get("nome", nome_arq[:-3]))
        linhas.append({
            "id": ident,
            "nome": fm.get("nome", nome_arq[:-3]),
            "andar": str(fm.get("andar", "")),
            "tipo_de_zona": fm.get("tipo_de_zona", ""),
            "guildas_presentes": fm.get("guildas_presentes") or [],
            "canonico": str(fm.get("canonico", "nao")).lower() == "sim",
            "fonte": fm.get("fonte", ""),
            "arquivo": "cidades/%s" % nome_arq,
            "corpo": corpo.strip(),
        })
    return upsert(cur, "cidades", "id", linhas)


# --------------------------------------------------------------------------

def main():
    conn = conectar()
    cur = conn.cursor()
    total = 0
    print("Migrando dungeons (precisa rodar antes de salas_dungeon)...")
    total += migrar_dungeons(cur)
    print("Migrando conteudo (npcs, monstros, quests, guias, ...)...")
    total += migrar_conteudo(cur)
    print("Migrando pontos do mapa...")
    total += migrar_mapa(cur)
    print("Migrando clas...")
    total += migrar_clas(cur)
    print("Migrando personagens...")
    total += migrar_personagens(cur)
    print("Migrando cidades...")
    total += migrar_cidades(cur)
    cur.close()
    conn.close()
    print("Pronto: %d linhas upsertadas." % total)


if __name__ == "__main__":
    main()
