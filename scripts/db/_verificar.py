import os
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
conn = psycopg2.connect(
    host=env["SUPABASE_DB_HOST"], port=env.get("SUPABASE_DB_PORT", "5432"),
    dbname=env.get("SUPABASE_DB_NAME", "postgres"), user=env["SUPABASE_DB_USER"],
    password=env["SUPABASE_DB_PASSWORD"], connect_timeout=15,
)
cur = conn.cursor()

def q(titulo, sql):
    cur.execute(sql)
    rows = cur.fetchall()
    print(f"\n== {titulo} ==")
    for r in rows:
        print(" ", r)

q("bucket compendio-imagens", "select id, public from storage.buckets where id='compendio-imagens'")
q("armas com move_c preenchido (limit_breaker)", "select count(*) from moves_arma where limit_breaker is not null")
q("armas SEM limit_breaker (esperado: as 0 que faltam)", "select nome from moves_arma where limit_breaker is null order by nome")
q("Leque atributo/move_a", "select nome, atributo, move_a->>'nome' as move1 from moves_arma where nome='Leque'")
q("profissoes com move_c", "select nome from moves_profissao where move_c is not null order by nome")
q("profissoes novas existem?", "select nome, atributo, visivel from moves_profissao where nome in ('Informante','Mestre de Montarias','Minerador')")
q("bibliotecario/diplomata/coveiro visivel=false?", "select nome, visivel from moves_profissao where nome in ('Bibliotecário','Diplomata','Coveiro')")
q("cartografo marca/move_c", "select nome, marca, move_c->>'nome' as exclusivo from moves_profissao where nome='Cartógrafo'")
q("clas colunas novas", "select column_name from information_schema.columns where table_name='clas' and column_name in ('logo_url','recrutando','profissoes_aceitas')")
q("tabelas novas existem?", "select table_name from information_schema.tables where table_name in ('cla_pedidos','cartografo_nevoa','buffs_grupo')")
q("funcoes novas existem?", "select proname from pg_proc where proname in ('pedir_entrada_cla','cartografo_revelar','musico_compor','responder_pedido_cla','cancelar_pedido_cla')")

cur.close()
conn.close()
print("\nOK.")
