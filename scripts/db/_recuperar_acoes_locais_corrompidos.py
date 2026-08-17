"""
Recuperação pontual — achado 16-17/08: guias.acoes, guias.locais e
oficios.acoes são jsonb (array de objeto), mas TABELAS_ADMIN os declarava
"lista-texto" (espera array de STRING). O editor genérico (EditorEntidade.vue)
mostrava cada objeto como "[object Object]" num <textarea>, e salvar sem
querer regravava esse texto quebrado no banco — destruiu 29/30 linhas de
guias.acoes, 27/28 de guias.locais e 3/16 de oficios.acoes.

Esse script já RODOU uma vez (16/08) e restaurou os 3 campos a partir de
scripts/web/dados_conteudo.js — a fonte original em disco, nunca passou pelo
editor quebrado, então tinha os objetos intactos. Fica aqui só como registro
e pra rodar de novo se o mesmo acidente acontecer (idempotente: sempre
sobrescreve com o que está no dados_conteudo.js, então rodar sem necessidade
não faz mal, só não traz nada que já não estivesse lá).

O tipo já foi corrigido pra "lista" (sub-schema fixo) em tabelasAdmin.js —
isso não deveria mais acontecer.

Rode: python scripts/db/_recuperar_acoes_locais_corrompidos.py
"""
import json
import os
import subprocess
import sys

import psycopg2
from psycopg2.extras import Json

RAIZ = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
ENV_PATH = os.path.join(RAIZ, ".env")
EXTRATOR_JS = os.path.join(RAIZ, "scripts", "db", "extrair_dados_js.js")
DADOS_CONTEUDO = os.path.join(RAIZ, "scripts", "web", "dados_conteudo.js")


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

r = subprocess.run(["node", EXTRATOR_JS, DADOS_CONTEUDO], capture_output=True, text=True, encoding="utf-8")
if r.returncode != 0:
    print("[ERRO] extrair_dados_js.js:", r.stderr)
    sys.exit(1)
blocos = json.loads(r.stdout)

conn = psycopg2.connect(
    host=env["SUPABASE_DB_HOST"],
    port=env.get("SUPABASE_DB_PORT", "5432"),
    dbname=env.get("SUPABASE_DB_NAME", "postgres"),
    user=env["SUPABASE_DB_USER"],
    password=env["SUPABASE_DB_PASSWORD"],
    connect_timeout=15,
)
conn.autocommit = False
cur = conn.cursor()

n_guias = 0
for linha in blocos["GUIAS"]:
    cur.execute(
        "update guias set acoes=%s, locais=%s where id=%s",
        (Json(linha.get("acoes") or []), Json(linha.get("locais") or []), linha["id"]),
    )
    n_guias += cur.rowcount

n_oficios = 0
for linha in blocos["OFICIOS"]:
    cur.execute(
        "update oficios set acoes=%s where nome=%s",
        (Json(linha.get("acoes") or []), linha["nome"]),
    )
    n_oficios += cur.rowcount

conn.commit()
print(f"guias atualizadas: {n_guias} / {len(blocos['GUIAS'])}")
print(f"oficios atualizados: {n_oficios} / {len(blocos['OFICIOS'])}")
cur.close()
conn.close()
