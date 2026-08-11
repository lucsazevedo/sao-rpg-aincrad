#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Consolida um snapshot fiel do schema public inteiro (tabelas, views,
funções, RLS) direto do banco de produção — não tenta reconstruir juntando
os `schema_*.sql` incrementais na mão (a sessão de 10/08 já teve um
quase-acidente fazendo isso com `_gerar_receitas_balanceadas.py`, que
truncava o arquivo). Isso vira a fonte de verdade nova; os `schema_*.sql`
incrementais continuam no repo como histórico de "o que mudou quando" mas
não precisam mais ser lidos em sequência pra saber o estado atual."""
import sys

sys.path.insert(0, "scripts")
from migrar_para_supabase import conectar  # noqa: E402

# extensões que trazem função/tipo próprio — não precisa (nem dá, com
# segurança) recriar isso num snapshot do app.
SCHEMAS_EXTENSAO = {
    "vector", "halfvec", "sparsevec",  # pgvector
}


def main():
    conn = conectar()
    cur = conn.cursor()
    partes = []

    partes.append("-- Snapshot completo do schema public — gerado automaticamente\n"
                   "-- (scripts/db/_gerar_snapshot_schema.py) em 2026-08-10.\n"
                   "-- Não é pra rodar como migração — é referência de \"como o banco\n"
                   "-- está agora\", já que os schema_*.sql incrementais desta sessão\n"
                   "-- não foram todos mesclados de volta no schema_jogo_online.sql\n"
                   "-- original. Pra recriar um banco do zero, ainda é mais seguro rodar\n"
                   "-- os schema_*.sql na ordem cronológica (ver docs/pendencias.md).\n")

    # 1) extensões
    cur.execute("select extname from pg_extension where extname <> 'plpgsql' order by 1")
    exts = [r[0] for r in cur.fetchall()]
    partes.append("\n-- ========== EXTENSÕES ==========\n")
    for e in exts:
        partes.append(f'create extension if not exists "{e}";\n')

    # 2) tabelas (create table if not exists, coluna a coluna, com tipo/default/not null)
    cur.execute("""
        select table_name from information_schema.tables
        where table_schema='public' and table_type='BASE TABLE'
        order by table_name
    """)
    tabelas = [r[0] for r in cur.fetchall()]
    partes.append("\n-- ========== TABELAS ==========\n")
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
            tipo_sql = udt if tipo == 'USER-DEFINED' or tipo == 'ARRAY' else tipo
            if tipo == 'character varying' and maxlen:
                tipo_sql = f"varchar({maxlen})"
            linha = f'  "{nome}" {tipo_sql}'
            if default is not None:
                linha += f" default {default}"
            if nullable == 'NO':
                linha += " not null"
            linhas_col.append(linha)
        partes.append(f'create table if not exists "{t}" (\n' + ",\n".join(linhas_col) + "\n);\n")

    # 3) constraints (PK, FK, UNIQUE, CHECK) — separado das tabelas pra não
    #    depender de ordem de criação entre tabelas com FK cruzada.
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

    # 4) views
    cur.execute("select viewname, definition from pg_views where schemaname='public' order by viewname")
    partes.append("\n-- ========== VIEWS ==========\n")
    for nome, defi in cur.fetchall():
        partes.append(f'create or replace view "{nome}" as {defi}\n')

    # 5) funções (exclui as trazidas por extensão)
    # exclui funcao que pertence a uma extensao (pg_depend deptype='e') --
    # filtro por prefixo de nome era fragil e deixou passar C functions do
    # pgvector, que davam "permission denied for language c" ao tentar
    # recriar (linguagem C so' pode ser usada via CREATE EXTENSION mesmo).
    cur.execute("""
        select p.proname, pg_get_functiondef(p.oid)
        from pg_proc p
        join pg_namespace n on n.oid = p.pronamespace
        where n.nspname = 'public' and p.prokind = 'f'
          and not exists (
            select 1 from pg_depend d
            where d.objid = p.oid and d.deptype = 'e'
          )
        order by p.proname
    """)
    partes.append("\n-- ========== FUNÇÕES ==========\n")
    for nome, defi in cur.fetchall():
        partes.append(defi + ";\n\n")

    # 6) RLS (enable + policies)
    partes.append("\n-- ========== RLS ==========\n")
    cur.execute("""
        select relname from pg_class c join pg_namespace n on n.oid=c.relnamespace
        where n.nspname='public' and c.relrowsecurity = true and c.relkind='r'
        order by relname
    """)
    for (t,) in cur.fetchall():
        partes.append(f'alter table "{t}" enable row level security;\n')
    cur.execute("""
        select tablename, policyname, cmd, qual, with_check
        from pg_policies where schemaname='public' order by tablename, policyname
    """)
    for tabela, nome, cmd, qual, check in cur.fetchall():
        cmd_sql = "all" if cmd == "*" else cmd.lower()
        linha = f'drop policy if exists "{nome}" on "{tabela}";\n'
        linha += f'create policy "{nome}" on "{tabela}" for {cmd_sql}'
        if qual:
            linha += f" using ({qual})"
        if check:
            linha += f" with check ({check})"
        linha += ";\n"
        partes.append(linha)

    # 7) cron jobs
    try:
        cur.execute("select jobname, schedule, command from cron.job order by jobname")
        partes.append("\n-- ========== PG_CRON ==========\n")
        for nome, sched, cmd in cur.fetchall():
            partes.append(f"select cron.unschedule(jobid) from cron.job where jobname = '{nome}';\n")
            partes.append(f"select cron.schedule('{nome}', '{sched}', $${cmd}$$);\n")
    except Exception as e:
        print("aviso: nao consegui ler cron.job:", e)

    with open("scripts/db/schema_snapshot_2026-08-10.sql", "w", encoding="utf-8") as f:
        f.write("".join(partes))
    print("snapshot escrito, tamanho:", sum(len(p) for p in partes), "chars")


if __name__ == "__main__":
    main()
