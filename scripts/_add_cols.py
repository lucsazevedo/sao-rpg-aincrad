# -*- coding: utf-8 -*-
"""Add colunas novas em personagens e perfis para integração Discord/avatar."""
import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
sys.path.insert(0, 'scripts')
from migrar_para_supabase import conectar

ALTERS = """
-- ----------- personagens: foto avatar + discord -----------
alter table personagens add column if not exists foto_url text;
alter table personagens add column if not exists discord_nome text;
alter table personagens add column if not exists discord_email text;

-- ----------- perfis: discord (mesmos campos, sincronizados quando mestre criar) -----------
alter table perfis add column if not exists discord_nome text;
alter table perfis add column if not exists discord_email text;
alter table perfis add column if not exists foto_url text;

comment on column personagens.foto_url is 'Avatar do jogador. URL completa (ex: cdn.discordapp.com ou gravatar)';
comment on column personagens.discord_nome is 'Username#0000 discord da mesa';
comment on column personagens.discord_email is 'Email vinculado ao discord do jogador';
"""

c = conectar()
cur = c.cursor()
for cmd in [c for c in ALTERS.strip().split(";") if c.strip()]:
    try:
        cur.execute(cmd)
        print("✅ ", cmd.strip()[:100])
    except Exception as ex:
        print("⚠️  ", cmd.strip()[:80], "→", str(ex)[:120])
c.commit()

# Verificar resultado
cur.execute("select column_name, data_type from information_schema.columns where table_name='personagens' and column_name in ('foto_url','discord_nome','discord_email') order by column_name")
print("\npersonagens novas cols:", cur.fetchall())
cur.execute("select column_name from information_schema.columns where table_name='perfis' and column_name in ('foto_url','discord_nome','discord_email') order by column_name")
print("perfis novas cols:", cur.fetchall())
cur.close(); c.close()
