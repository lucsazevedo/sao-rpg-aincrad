-- Hub de Aincrad (SAO_RPG_AINCRAD_SISTEMAS.md): Notícias, Andares, Evento
-- Global, Guildas/Clãs (extensão), Diário de Aincrad e Estado de Aincrad.
-- Roda depois de schema.sql + schema_papeis.sql (usa is_mestre()) e depois
-- de schema_upload_imagens_e_recrutamento_cla.sql (clas já tem logo_url/
-- recrutando/profissoes_aceitas). Idempotente.

-- ======================================================================
-- 1) NOTÍCIAS DE AINCRAD
-- ======================================================================
create table if not exists noticias (
  id bigserial primary key,
  titulo text not null,
  categoria text not null check (categoria in
    ('boss','exploracao','item_raro','guilda','evento','sistema','descoberta','conquista')),
  andar int,
  dia_aincrad int,
  texto text,
  destaque boolean not null default false,
  publicado_em timestamptz not null default now(),
  visivel boolean not null default true,
  excluido boolean not null default false,
  updated_at timestamptz not null default now()
);
alter table noticias enable row level security;
drop policy if exists "select_publico_ou_mestre" on noticias;
create policy "select_publico_ou_mestre" on noticias for select
  using ((visivel = true and excluido = false) or is_mestre());
drop policy if exists "escrita_mestre" on noticias;
create policy "escrita_mestre" on noticias for all
  using (is_mestre()) with check (is_mestre());

-- ======================================================================
-- 2) ANDARES (informações por andar)
-- ======================================================================
create table if not exists andares (
  numero int primary key,
  nome text,
  status text not null default 'bloqueado' check (status in
    ('bloqueado','em_exploracao','boss_descoberto','boss_derrotado','concluido')),
  exploracao_pct int not null default 0 check (exploracao_pct between 0 and 100),
  info_descobertas text,
  monstros_conhecidos text[] not null default '{}',
  mvp_personagem_nome text references personagens(nome) on delete set null,
  mvp_feito text,
  mvp_titulo text,
  boss_nome text,
  boss_img text,
  boss_localizacao text,
  boss_info text,
  boss_status text not null default 'nao_descoberto' check (boss_status in
    ('nao_descoberto','descoberto','batalha_disponivel','derrotado')),
  boss_grupo_responsavel text,
  boss_participantes text[] not null default '{}',
  boss_data_derrota timestamptz,
  boss_recompensas text,
  boss_drops text,
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);
alter table andares enable row level security;
drop policy if exists "select_publico_ou_mestre" on andares;
create policy "select_publico_ou_mestre" on andares for select
  using (visivel = true or is_mestre());
drop policy if exists "escrita_mestre" on andares;
create policy "escrita_mestre" on andares for all
  using (is_mestre()) with check (is_mestre());

insert into andares (numero, nome, status) values (1, 'Andar 1', 'em_exploracao')
  on conflict (numero) do nothing;

-- ======================================================================
-- 3) EVENTO GLOBAL
-- ======================================================================
create table if not exists eventos_globais (
  id bigserial primary key,
  nome text not null,
  descricao text,
  objetivo text,
  data_inicio timestamptz not null default now(),
  status text not null default 'em_breve' check (status in
    ('em_breve','ativo','concluido','fracassado')),
  progresso_pct int not null default 0 check (progresso_pct between 0 and 100),
  participantes text,
  recompensa text,
  consequencia_fracasso text,
  visivel boolean not null default true,
  excluido boolean not null default false,
  updated_at timestamptz not null default now()
);
alter table eventos_globais enable row level security;
drop policy if exists "select_publico_ou_mestre" on eventos_globais;
create policy "select_publico_ou_mestre" on eventos_globais for select
  using ((visivel = true and excluido = false) or is_mestre());
drop policy if exists "escrita_mestre" on eventos_globais;
create policy "escrita_mestre" on eventos_globais for all
  using (is_mestre()) with check (is_mestre());

create table if not exists eventos_globais_objetivos (
  id bigserial primary key,
  evento_id bigint not null references eventos_globais(id) on delete cascade,
  descricao text not null,
  meta int not null default 0,
  atual int not null default 0,
  updated_at timestamptz not null default now()
);
alter table eventos_globais_objetivos enable row level security;
drop policy if exists "select_publico_ou_mestre" on eventos_globais_objetivos;
create policy "select_publico_ou_mestre" on eventos_globais_objetivos for select
  using (
    exists (select 1 from eventos_globais e where e.id = evento_id and e.visivel = true and e.excluido = false)
    or is_mestre()
  );
drop policy if exists "escrita_mestre" on eventos_globais_objetivos;
create policy "escrita_mestre" on eventos_globais_objetivos for all
  using (is_mestre()) with check (is_mestre());

-- ======================================================================
-- 4) DIÁRIO DE AINCRAD
-- ======================================================================
create table if not exists diario_entradas (
  id bigserial primary key,
  dia int not null,
  autor_tipo text not null check (autor_tipo in ('mestre','jogador')),
  autor_personagem_nome text references personagens(nome) on delete set null,
  titulo text,
  texto text not null,
  categoria text,
  criado_em timestamptz not null default now(),
  visivel boolean not null default true,
  excluido boolean not null default false
);
alter table diario_entradas enable row level security;
drop policy if exists "select_publico_ou_mestre" on diario_entradas;
create policy "select_publico_ou_mestre" on diario_entradas for select
  using ((visivel = true and excluido = false) or is_mestre());
drop policy if exists "escrita_mestre" on diario_entradas;
create policy "escrita_mestre" on diario_entradas for all
  using (is_mestre()) with check (is_mestre());

-- Jogador posta a própria entrada (RPC — sem policy de insert direta pra
-- authenticated, mesmo padrão de pedir_entrada_cla).
create or replace function postar_diario_jogador(p_dia int, p_titulo text, p_texto text, p_categoria text default null)
returns text language plpgsql security definer set search_path = public as $$
declare v_personagem text;
begin
  select nome into v_personagem from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;
  if p_texto is null or trim(p_texto) = '' then return '{"erro":"texto vazio"}'; end if;

  insert into diario_entradas (dia, autor_tipo, autor_personagem_nome, titulo, texto, categoria)
    values (p_dia, 'jogador', v_personagem, nullif(trim(p_titulo), ''), trim(p_texto), nullif(trim(p_categoria), ''));
  return '{"ok":true}';
end;
$$;
grant execute on function postar_diario_jogador(int, text, text, text) to authenticated;

-- ======================================================================
-- 5) ESTADO DE AINCRAD (singleton — só o que não dá pra derivar de outras
--    tabelas: dia narrativo, contador manual de mortes, override de andar
--    atual)
-- ======================================================================
create table if not exists estado_aincrad (
  id boolean primary key default true check (id),
  dia_atual int not null default 10,
  mortes int not null default 0,
  andar_atual int,
  texto_extra text,
  updated_at timestamptz not null default now()
);
insert into estado_aincrad (id) values (true) on conflict (id) do nothing;

alter table estado_aincrad enable row level security;
drop policy if exists "select_publico" on estado_aincrad;
create policy "select_publico" on estado_aincrad for select using (true);
drop policy if exists "escrita_mestre" on estado_aincrad;
create policy "escrita_mestre" on estado_aincrad for all
  using (is_mestre()) with check (is_mestre());

-- ======================================================================
-- 6) CLÃS — campos novos (liderança/estatísticas/conquistas)
-- ======================================================================
alter table clas add column if not exists lider_personagem text references personagens(nome) on delete set null;
alter table clas add column if not exists vice_lider_personagem text references personagens(nome) on delete set null;
alter table clas add column if not exists missoes_concluidas int not null default 0;
alter table clas add column if not exists bosses_derrotados int not null default 0;
alter table clas add column if not exists conquistas jsonb not null default '[]'::jsonb;

-- drop+create: mesmo motivo do arquivo anterior (Postgres não deixa
-- reordenar coluna com CREATE OR REPLACE VIEW).
drop view if exists clas_publico;
create view clas_publico as
  select c.nome, c.destaque, c.forca, c.necessidade, c.rival, c.rumor, c.status, c.resumo, c.bons,
         c.precisa, c.nao_admitem, c.proximo, c.atravessado, c.quests, c.aparecem, c.simbolo,
         c.logo_url, c.recrutando, c.profissoes_aceitas, c.reputacao, c.updated_at,
         c.lider_personagem, c.vice_lider_personagem, c.missoes_concluidas, c.bosses_derrotados, c.conquistas,
         coalesce(m.membros_count, 0) as membros_count,
         m.nivel_medio,
         case when is_mestre() then c.ganchos else null end as ganchos
  from clas c
  left join (
    select p.guilda,
           count(*) as membros_count,
           round(avg(coalesce(np.nivel, 1))) as nivel_medio
    from personagens p
    left join nivel_profissao np on np.personagem_nome = p.nome and np.profissao = p.profissao
    where p.guilda is not null and p.guilda <> '' and p.visivel = true and p.excluido = false
    group by p.guilda
  ) m on m.guilda = c.nome
  where (c.visivel = true and c.excluido = false) or is_mestre() or pode_ver('clas', c.nome);

-- ======================================================================
-- 7) RPC de cascata — boss derrotado (seção 7 do doc)
-- ======================================================================
create or replace function mestre_resolver_boss_andar(
  p_numero int,
  p_recompensas text default null,
  p_drops text default null,
  p_mvp_personagem text default null,
  p_participantes text[] default '{}'
)
returns text language plpgsql security definer set search_path = public as $$
declare
  v_andar andares%rowtype;
  v_cla text;
  v_titulo text;
begin
  if not is_mestre() then return '{"erro":"só o mestre resolve boss"}'; end if;

  select * into v_andar from andares where numero = p_numero;
  if not found then return '{"erro":"andar não encontrado"}'; end if;

  update andares set
    boss_status = 'derrotado',
    status = 'concluido',
    boss_recompensas = coalesce(p_recompensas, boss_recompensas),
    boss_drops = coalesce(p_drops, boss_drops),
    boss_participantes = case when p_participantes is not null and array_length(p_participantes,1) > 0
                               then p_participantes else boss_participantes end,
    boss_data_derrota = now(),
    mvp_personagem_nome = coalesce(p_mvp_personagem, mvp_personagem_nome),
    updated_at = now()
    where numero = p_numero
    returning * into v_andar;

  v_titulo := format('BOSS DERROTADO NO %sº ANDAR', p_numero);
  insert into noticias (titulo, categoria, andar, texto, destaque)
    values (v_titulo, 'boss', p_numero,
            coalesce('O andar ' || p_numero || ' teve seu chefe derrotado. ' || coalesce('Recompensas: ' || p_recompensas, ''), v_titulo),
            true);

  insert into diario_entradas (dia, autor_tipo, titulo, texto, categoria)
    select coalesce(e.dia_atual, 10), 'mestre', v_titulo,
           'O chefe do ' || p_numero || 'º andar (' || coalesce(v_andar.boss_nome, 'desconhecido') || ') foi derrotado.',
           'boss'
    from estado_aincrad e;

  if p_participantes is not null then
    for v_cla in
      select distinct p.guilda from personagens p
      where p.nome = any(p_participantes) and p.guilda is not null and p.guilda <> ''
    loop
      update clas set bosses_derrotados = bosses_derrotados + 1, updated_at = now() where nome = v_cla;
    end loop;
  end if;

  if exists (select 1 from andares where numero = p_numero + 1 and status = 'bloqueado') then
    update andares set status = 'em_exploracao', updated_at = now() where numero = p_numero + 1;
    insert into noticias (titulo, categoria, andar, texto, destaque)
      values (format('NOVO ANDAR LIBERADO: %sº ANDAR', p_numero + 1), 'exploracao', p_numero + 1,
              'Com a queda do chefe do andar anterior, o caminho para o próximo andar foi liberado.', true);
  end if;

  return '{"ok":true}';
end;
$$;
grant execute on function mestre_resolver_boss_andar(int, text, text, text, text[]) to authenticated;

-- ======================================================================
-- 8) RPC de leitura — resumo do Estado de Aincrad (item 6 do doc). Precisa
-- de security definer porque a economia soma `transacoes`, cuja RLS ("
-- partes_leem", schema_jogo_online.sql) só deixa cada jogador ver as
-- próprias transações — o painel devolve só agregados (somas/contagens),
-- nunca uma transação individual de outra pessoa. Liberado pra anon
-- também: o Hub de Aincrad é vitrine pública, não exige login (mesmo
-- padrão de monstros/clas/guias, ver schema_views_seguras.sql).
-- ======================================================================
create or replace function estado_aincrad_resumo()
returns text language plpgsql stable security definer set search_path = public as $$
declare
  v_estado estado_aincrad%rowtype;
  v_jogadores int;
  v_bosses int;
  v_guildas int;
  v_andar_max int;
  v_eventos_ativos jsonb;
  v_col_circulando numeric;
  v_col_gasto_lojas numeric;
  v_col_recebido_missoes numeric;
  v_item_comercializado text;
  v_item_caro_id text;
  v_item_caro_valor numeric;
  v_guilda_rica text;
begin
  select * into v_estado from estado_aincrad limit 1;
  select count(*) into v_jogadores from personagens where visivel = true and excluido = false;
  select count(*) into v_bosses from andares where boss_status = 'derrotado';
  select count(*) into v_guildas from clas where visivel = true and excluido = false;
  select max(numero) into v_andar_max from andares where status <> 'bloqueado';

  select coalesce(sum(col_mao),0) into v_col_circulando from personagens where visivel = true and excluido = false;
  select coalesce(sum(valor),0) into v_col_gasto_lojas from transacoes where tipo = 'compra';
  select coalesce(sum(valor),0) into v_col_recebido_missoes from transacoes where tipo = 'missao';

  select item_id into v_item_comercializado from transacoes
    where tipo in ('compra','venda') and item_id is not null
    group by item_id order by count(*) desc limit 1;

  select item_id, valor into v_item_caro_id, v_item_caro_valor from transacoes
    where tipo = 'venda' order by valor desc nulls last limit 1;

  select guilda into v_guilda_rica from personagens
    where guilda is not null and guilda <> '' and visivel = true and excluido = false
    group by guilda order by sum(col_mao) desc limit 1;

  select jsonb_agg(jsonb_build_object('id', id, 'nome', nome)) into v_eventos_ativos
    from eventos_globais where status = 'ativo' and visivel = true and excluido = false;

  return jsonb_build_object(
    'dia_atual', coalesce(v_estado.dia_atual, 10),
    'mortes', coalesce(v_estado.mortes, 0),
    'andar_atual', coalesce(v_estado.andar_atual, v_andar_max, 1),
    'jogadores_ativos', v_jogadores,
    'bosses_derrotados', v_bosses,
    'quantidade_guildas', v_guildas,
    'eventos_ativos', coalesce(v_eventos_ativos, '[]'::jsonb),
    'economia', jsonb_build_object(
      'col_em_circulacao', v_col_circulando,
      'col_gasto_em_lojas', v_col_gasto_lojas,
      'col_recebido_em_missoes', v_col_recebido_missoes,
      'item_mais_comercializado', v_item_comercializado,
      'item_mais_caro_vendido', v_item_caro_id,
      'item_mais_caro_valor', v_item_caro_valor,
      'guilda_mais_rica', v_guilda_rica
    )
  )::text;
end;
$$;
grant execute on function estado_aincrad_resumo() to anon, authenticated;
