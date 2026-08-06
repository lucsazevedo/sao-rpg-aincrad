-- Segunda migração: dois papéis (mestre/jogador) + autorização de conteúdo
-- por jogador específico. Roda depois de schema.sql.

create table if not exists perfis (
  id uuid primary key references auth.users(id) on delete cascade,
  papel text not null check (papel in ('mestre','jogador')),
  nome text,
  criado_em timestamptz not null default now()
);

create table if not exists conteudo_liberado (
  id bigserial primary key,
  jogador_id uuid not null references auth.users(id) on delete cascade,
  tabela text not null,
  registro_id text not null,
  liberado_em timestamptz not null default now(),
  unique (jogador_id, tabela, registro_id)
);

-- security definer: le perfis/conteudo_liberado ignorando RLS deles mesmos,
-- pra nao virar referencia circular na hora de montar a policy das outras
-- tabelas.
create or replace function is_mestre()
returns boolean language sql stable security definer set search_path = public as $$
  select exists(select 1 from perfis where id = auth.uid() and papel = 'mestre');
$$;

create or replace function pode_ver(p_tabela text, p_registro_id text)
returns boolean language sql stable security definer set search_path = public as $$
  select exists(
    select 1 from conteudo_liberado
    where jogador_id = auth.uid() and tabela = p_tabela and registro_id = p_registro_id
  );
$$;

alter table perfis enable row level security;
drop policy if exists "ve_proprio_perfil" on perfis;
create policy "ve_proprio_perfil" on perfis for select using (id = auth.uid());
drop policy if exists "mestre_gerencia_perfis" on perfis;
create policy "mestre_gerencia_perfis" on perfis for all
  using (is_mestre()) with check (is_mestre());

alter table conteudo_liberado enable row level security;
drop policy if exists "jogador_ve_proprias_liberacoes" on conteudo_liberado;
create policy "jogador_ve_proprias_liberacoes" on conteudo_liberado for select
  using (jogador_id = auth.uid() or is_mestre());
drop policy if exists "mestre_gerencia_liberacoes" on conteudo_liberado;
create policy "mestre_gerencia_liberacoes" on conteudo_liberado for all
  using (is_mestre()) with check (is_mestre());
