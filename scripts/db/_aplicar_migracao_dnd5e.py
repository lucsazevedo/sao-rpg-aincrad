#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Aplica schema_migracao_dnd5e.sql + schema_migracao_dnd5e_rpcs.sql no banco
de producao, numa unica transacao (tudo ou nada -- se algo falhar, rollback
completo, banco fica exatamente como estava).

Pre-requisito: scripts/db/_backup_completo.py ja rodado (ver
docs/pendencias.md). Este script NAO faz backup sozinho.

Uso:
    python scripts/db/_aplicar_migracao_dnd5e.py
"""
import os
import sys

import psycopg2

sys.path.insert(0, os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
from migrar_para_supabase import carregar_env  # noqa: E402

AQUI = os.path.dirname(os.path.abspath(__file__))
ARQUIVOS = [
    os.path.join(AQUI, "schema_migracao_dnd5e.sql"),
    os.path.join(AQUI, "schema_migracao_dnd5e_rpcs.sql"),
]


def conectar_transacional():
    env = carregar_env()
    conn = psycopg2.connect(
        host=env["SUPABASE_DB_HOST"],
        port=env["SUPABASE_DB_PORT"],
        dbname=env["SUPABASE_DB_NAME"],
        user=env["SUPABASE_DB_USER"],
        password=env["SUPABASE_DB_PASSWORD"],
        sslmode="require",
    )
    conn.autocommit = False  # tudo ou nada
    return conn


def main():
    conn = conectar_transacional()
    cur = conn.cursor()
    try:
        for caminho in ARQUIVOS:
            print(f"aplicando {os.path.basename(caminho)}...")
            with open(caminho, encoding="utf-8") as f:
                sql = f.read()
            cur.execute(sql)
            print(f"  ok ({len(sql)} chars)")

        # verificacao minima antes de commitar
        cur.execute("select count(*) from personagens where atributos_dnd is not null")
        n_pers = cur.fetchone()[0]
        cur.execute("select count(*) from monstros where cd_resistencia is not null")
        n_monst = cur.fetchone()[0]
        cur.execute("select count(*) from personagens where excluido=false")
        n_pers_total = cur.fetchone()[0]
        print(f"personagens com atributos_dnd: {n_pers} (de {n_pers_total} nao excluidos)")
        print(f"monstros com cd_resistencia: {n_monst}")

        if n_pers == 0:
            raise RuntimeError("nenhum personagem migrado -- abortando (rollback)")

        conn.commit()
        print("MIGRACAO APLICADA E COMMITADA.")
    except Exception as e:
        conn.rollback()
        print(f"ERRO: {e}")
        print("ROLLBACK feito -- banco nao foi alterado.")
        raise
    finally:
        cur.close()
        conn.close()


if __name__ == "__main__":
    main()
