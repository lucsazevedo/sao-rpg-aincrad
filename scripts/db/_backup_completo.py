#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Backup completo do banco de produção (schema + TODAS as linhas de TODAS
as tabelas) antes da migração de schema PBTA -> D&D 5e.

Diferente de `_gerar_snapshot_schema.py` (só estrutura), este script gera
também os dados reais (INSERT por linha, via `cur.mogrify` — escapa tudo
certinho, inclusive jsonb/array/null) pra poder restaurar o banco inteiro
rodando o .sql gerado do zero, se a migração precisar ser revertida.

Uso:
    python scripts/db/_backup_completo.py
"""
import datetime
import os
import sys

import psycopg2.extras

sys.path.insert(0, os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
from migrar_para_supabase import conectar  # noqa: E402


def _adaptar(valor):
    """dict/list vêm do driver já parseados (jsonb) — precisam voltar a ser
    Json() pra `mogrify` conseguir montar o literal de volta."""
    if isinstance(valor, (dict, list)):
        return psycopg2.extras.Json(valor)
    return valor


def main():
    conn = conectar()
    cur = conn.cursor()
    partes = []

    agora = datetime.datetime.now().strftime("%Y-%m-%d_%H%M%S")
    partes.append(
        f"-- Backup completo (schema + dados) gerado em {agora}\n"
        f"-- por scripts/db/_backup_completo.py, antes da migração pra D&D 5e.\n"
        f"-- Pra restaurar: rodar este arquivo inteiro num banco Postgres vazio\n"
        f"-- (mesmas extensões do Supabase habilitadas) ou colar trecho a trecho.\n\n"
    )

    # 1) extensões
    cur.execute("select extname from pg_extension where extname <> 'plpgsql' order by 1")
    exts = [r[0] for r in cur.fetchall()]
    partes.append("-- ========== EXTENSÕES ==========\n")
    for e in exts:
        partes.append(f'create extension if not exists "{e}";\n')

    # 2) tabelas (estrutura)
    cur.execute("""
        select table_name from information_schema.tables
        where table_schema='public' and table_type='BASE TABLE'
        order by table_name
    """)
    tabelas = [r[0] for r in cur.fetchall()]
    partes.append("\n-- ========== TABELAS (estrutura) ==========\n")
    for t in tabelas:
        cur.execute("""
            select column_name, data_type, udt_name, is_nullable, column_default,
                   character_maximum_length
            from information_schema.columns
            where table_schema='public' and table_name=%s
            order by ordinal_position
        """, (t,))
        cols = cur.fetchall()
        linhas_col = []
        for nome, tipo, udt, nullable, default, maxlen in cols:
            tipo_sql = udt if tipo in ('USER-DEFINED', 'ARRAY') else tipo
            if tipo == 'character varying' and maxlen:
                tipo_sql = f"varchar({maxlen})"
            linha = f'  "{nome}" {tipo_sql}'
            if default is not None:
                linha += f" default {default}"
            if nullable == 'NO':
                linha += " not null"
            linhas_col.append(linha)
        partes.append(f'create table if not exists "{t}" (\n' + ",\n".join(linhas_col) + "\n);\n")

    # 3) constraints
    partes.append("\n-- ========== CONSTRAINTS ==========\n")
    cur.execute("""
        select conrelid::regclass::text as tabela, conname, pg_get_constraintdef(oid)
        from pg_constraint
        where connamespace = 'public'::regnamespace
        order by conrelid::regclass::text, conname
    """)
    for tabela, nome, defi in cur.fetchall():
        partes.append(
            f'do $$ begin\n'
            f'  alter table "{tabela}" add constraint "{nome}" {defi};\n'
            f'exception when duplicate_object then null; when others then null; end $$;\n'
        )

    # 4) DADOS — INSERT linha a linha, todas as tabelas, na ordem que
    #    reduz problema de FK (tabelas sem FK primeiro, mas na dúvida
    #    deixamos `set session_replication_role = replica` pra ignorar
    #    triggers/FK na restauração, que é o mais seguro pra um dump bruto).
    partes.append("\n-- ========== DADOS ==========\n")
    partes.append("set session_replication_role = replica; -- ignora FK/trigger na restauração\n\n")
    total_linhas = 0
    for t in tabelas:
        cur2 = conn.cursor()
        cur2.execute(f'select * from "{t}"')
        cols = [d[0] for d in cur2.description]
        col_list = ", ".join(f'"{c}"' for c in cols)
        linhas = cur2.fetchall()
        if not linhas:
            continue
        partes.append(f'-- {t}: {len(linhas)} linha(s)\n')
        for row in linhas:
            row = tuple(_adaptar(v) for v in row)
            template = "(" + ", ".join(["%s"] * len(cols)) + ")"
            valores_sql = cur2.mogrify(template, row).decode("utf-8")
            partes.append(f'insert into "{t}" ({col_list}) values {valores_sql};\n')
        total_linhas += len(linhas)
        partes.append("\n")
    partes.append("set session_replication_role = default;\n")

    os.makedirs("scripts/db/backups", exist_ok=True)
    caminho = f"scripts/db/backups/backup_pre_dnd5e_{agora}.sql"
    with open(caminho, "w", encoding="utf-8") as f:
        f.write("".join(partes))
    tamanho = os.path.getsize(caminho)
    print(f"backup escrito em {caminho}")
    print(f"tamanho: {tamanho} bytes, {len(tabelas)} tabelas, {total_linhas} linhas de dado")
    if tamanho == 0:
        print("AVISO: arquivo de backup vazio — não prosseguir com a migração!")
        sys.exit(1)


if __name__ == "__main__":
    main()
