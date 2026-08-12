"""
Puxa do banco tudo que o livro de regras público precisa: as 23 armas
(com golpes completos) e as 16 profissões (com golpes completos), pra
gerar o HTML sem retranscrever nada à mão (fonte mais confiável = o que
está de fato aplicado no banco agora).

Rode: python scripts/db/_extrair_conteudo_livro.py
Saída: scripts/db/_conteudo_livro.json
"""
import json
import os
import psycopg2
import psycopg2.extras

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
conn = psycopg2.connect(
    host=env["SUPABASE_DB_HOST"], port=env.get("SUPABASE_DB_PORT", "5432"),
    dbname=env.get("SUPABASE_DB_NAME", "postgres"), user=env["SUPABASE_DB_USER"],
    password=env["SUPABASE_DB_PASSWORD"], connect_timeout=15,
)
cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)

cur.execute("""
    select nome, atributo, marca, move_a, golpe_2, limit_breaker
    from moves_arma where excluido = false order by nome
""")
armas = cur.fetchall()

cur.execute("""
    select nome, atributo, marca, move_a, move_b, move_c
    from moves_profissao where visivel = true order by nome
""")
profissoes = cur.fetchall()

cur.close()
conn.close()

saida = {"armas": armas, "profissoes": profissoes}
caminho_saida = os.path.join(os.path.dirname(os.path.abspath(__file__)), "_conteudo_livro.json")
with open(caminho_saida, "w", encoding="utf-8") as f:
    json.dump(saida, f, ensure_ascii=False, indent=2, default=str)

print(f"{len(armas)} armas, {len(profissoes)} profissões -> {caminho_saida}")
