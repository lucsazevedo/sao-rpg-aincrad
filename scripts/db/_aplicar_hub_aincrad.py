"""
Aplica scripts/db/schema_hub_aincrad.sql direto no Postgres do Supabase,
usando as credenciais do .env da raiz do repo (SUPABASE_DB_*). Roda numa
única transação — se falhar, nada fica aplicado pela metade.

Rode: python scripts/db/_aplicar_hub_aincrad.py
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

ARQUIVO = "schema_hub_aincrad.sql"

conn = psycopg2.connect(
    host=env["SUPABASE_DB_HOST"],
    port=env.get("SUPABASE_DB_PORT", "5432"),
    dbname=env.get("SUPABASE_DB_NAME", "postgres"),
    user=env["SUPABASE_DB_USER"],
    password=env["SUPABASE_DB_PASSWORD"],
    connect_timeout=15,
)
conn.autocommit = False

caminho = os.path.join(os.path.dirname(os.path.abspath(__file__)), ARQUIVO)
with open(caminho, encoding="utf-8") as f:
    sql = f.read()

cur = conn.cursor()
try:
    cur.execute(sql)
    conn.commit()
    print(f"[OK] {ARQUIVO}")
except Exception as e:
    conn.rollback()
    print(f"[ERRO] {ARQUIVO}: {e}")
    sys.exit(1)
finally:
    cur.close()
    conn.close()
