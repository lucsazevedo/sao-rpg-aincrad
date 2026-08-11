# -*- coding: utf-8 -*-
import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
sys.path.insert(0, 'scripts')
from migrar_para_supabase import conectar
c = conectar()
cur = c.cursor()

# 1. Rodar RPC sortear_missoes_do_dia SEM user (service role -> autentica como servico)
print("1. Rodar RPC sortear_missoes_do_dia() (service role):")
try:
    cur.execute("select sortear_missoes_do_dia()")
    res = cur.fetchall()
    print("   OK. Qtde de missões retornadas:", len(res))
    if len(res):
        print("   Primeiro:", (str(res[0])[:240]))
except Exception as e:
    print("   ERRO:", e)

# 2. Quem é autor da função? SECURITY DEFINER ou não?
cur.execute("select proname, prosecdef, proconfig from pg_proc where proname like '%missoes%' or proname like '%sortear%' order by proname")
print("\n2. Lista funções relacionadas missoes:")
for r in cur.fetchall():
    print(f"   {r[0]}  ·  secdef={r[1]}  cfg={r[2]}")

# 3. Ver se o corpo da função usa CTE "box" que pode dar problema de permissão
cur.execute("select prosrc from pg_proc where proname='sortear_missoes_do_dia'")
src = cur.fetchone()
print("\n3. Fonte sortear_missoes_do_dia (prosrc primeiro 800):")
if src and src[0]:
    for linha in (src[0][:800]).splitlines():
        print("   ", linha)

cur.close(); c.close()
