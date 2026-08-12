"""
Aplica os .sql pendentes desta sessão direto no Postgres do Supabase,
usando as credenciais do .env da raiz do repo (SUPABASE_DB_*). Cada
arquivo roda dentro da própria transação — se um falhar, os já
aplicados ficam valendo, e para por ali (não tenta os seguintes às
cegas).

Rode: python scripts/db/_aplicar_pendentes.py
"""
import os
import sys
import psycopg2

RAIZ = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
ENV_PATH = os.path.join(RAIZ, ".env")

def carregar_env(caminho):
    env = {}
    with open(caminho, encoding="utf-8") as f:
        for linha in f:
            linha = linha.strip()
            if not linha or linha.startswith("#") or "=" not in linha:
                continue
            k, v = linha.split("=", 1)
            env[k.strip()] = v.strip().strip('"').strip("'")
    return env

env = carregar_env(ENV_PATH)

ARQUIVOS = [
    "schema_upload_imagens_e_recrutamento_cla.sql",
    "dml_moves_armas_pdf_pbta.sql",
    "dml_moves_armas_restante.sql",
    "dml_moves_profissao_pbta.sql",
    "schema_reforma_cellbit_profissoes.sql",
]

conn = psycopg2.connect(
    host=env["SUPABASE_DB_HOST"],
    port=env.get("SUPABASE_DB_PORT", "5432"),
    dbname=env.get("SUPABASE_DB_NAME", "postgres"),
    user=env["SUPABASE_DB_USER"],
    password=env["SUPABASE_DB_PASSWORD"],
    connect_timeout=15,
)
conn.autocommit = False

pasta = os.path.dirname(os.path.abspath(__file__))
ok_total = 0
for nome in ARQUIVOS:
    caminho = os.path.join(pasta, nome)
    if not os.path.exists(caminho):
        print(f"[PULADO] {nome} — arquivo não encontrado")
        continue
    with open(caminho, encoding="utf-8") as f:
        sql = f.read()
    cur = conn.cursor()
    try:
        cur.execute(sql)
        conn.commit()
        print(f"[OK] {nome}")
        ok_total += 1
    except Exception as e:
        conn.rollback()
        print(f"[ERRO] {nome}: {e}")
        print("Parando aqui — os arquivos anteriores já aplicados continuam valendo.")
        sys.exit(1)
    finally:
        cur.close()

conn.close()
print(f"\n{ok_total}/{len(ARQUIVOS)} arquivos aplicados com sucesso.")
