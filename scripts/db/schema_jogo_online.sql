-- Quarta migracao: o "jogo online" diario + as mudancas de sistema decididas
-- na pasta dolist/. Roda depois de schema.sql, schema_papeis.sql e
-- schema_views_seguras.sql. Cobre os itens:
--   1 (Domador -> Criador: ovos, pets-craft, Incubadora)
--   2 (3 golpes por arma + Limit Breaker: colunas novas em moves_arma)
--   5 (Nivel/XP de profissao)            7 (carta/cristal/ovo de drop)
--   8 (inventario/equipado)              9 (Col, limite diario, vitrine)
--   10 (reputacao de jogador)            12 (chance por Nivel — sem Poder)
--   13 (monstro perde elemento_*, ganha atributo_fraqueza)
--   14 (ferramentas de oficio com nivel proprio)
-- Regra de mesa continua so em docs/ — aqui mora o que o SITE precisa.
-- Regras detalhadas do loop: docs/jogo_online.md.

-- ================== ITEM 13 — monstros: elemento sai, atributo entra ======

alter table monstros add column if not exists atributo_fraqueza text;
-- um dos 5 atributos: Corpo | Reflexo | Conhecimento | Espírito | Técnica

-- elemento_* sai do jogo inteiro (mesa e site). As colunas antigas sao
-- derrubadas aqui; a view e o grant abaixo sao recriados sem elas.
alter table monstros drop column if exists elemento_fraqueza;
alter table monstros drop column if exists elemento_resistencia;

-- coluna antiga `fraqueza` (a abertura concreta, ex "garganta exposta no fim
-- da investida") CONTINUA — o md passa a chamar isso de `abertura`, e o
-- pipeline (gerar_dados_web.py) mapeia abertura -> fraqueza como antes.

revoke select on monstros from anon, authenticated;
grant select (id,nome,epiteto,arquivo,img,carta,tipo,zona,regioes,nivel_recomendado,
  ameaca,golpes,local,canonico,fonte,fraqueza,atributo_fraqueza,
  fraquezas,resistencias,vulnerabilidades,resumo,
  habitat,comportamento,leitura,sinal,lore,drops,corpo,visivel,excluido,updated_at)
  on monstros to anon, authenticated;

drop view if exists monstros_publico;
create view monstros_publico as
  select id,nome,epiteto,arquivo,img,carta,tipo,zona,regioes,nivel_recomendado,ameaca,
    golpes,local,canonico,fonte,fraqueza,atributo_fraqueza,
    fraquezas,resistencias,vulnerabilidades,
    resumo,habitat,comportamento,leitura,sinal,lore,drops,corpo,visivel,updated_at,
    case when is_mestre() then notas else null end as notas
  from monstros
  where (visivel = true and excluido = false) or is_mestre() or pode_ver('monstros', id::text);
grant select on monstros_publico to anon, authenticated;

-- ================== ITEM 2 — moves_arma: 2 golpes novos + Limit Breaker ====

alter table moves_arma add column if not exists golpe_2 jsonb;
alter table moves_arma add column if not exists golpe_3 jsonb;
alter table moves_arma add column if not exists limit_breaker jsonb;

-- ================== ITEM 1 — moves_profissao: move extra (Ovo de Fera) ====

alter table moves_profissao add column if not exists move_c jsonb;

-- ================== ITEM 8/9/6 — personagem ganha estado de jogo ==========

alter table personagens add column if not exists dono_id uuid references auth.users(id);
create unique index if not exists personagens_dono_uidx on personagens (dono_id)
  where dono_id is not null; -- um personagem por conta (decidido)

alter table personagens add column if not exists col_mao int not null default 0;
alter table personagens add column if not exists col_guardado int not null default 0;
alter table personagens add column if not exists col_ganho_hoje int not null default 0;
alter table personagens add column if not exists col_reset_dia date;
alter table personagens add column if not exists folego int not null default 20;
alter table personagens add column if not exists folego_atualizado_em timestamptz not null default now();
alter table personagens add column if not exists bug int not null default 0;
alter table personagens add column if not exists bug_ate timestamptz;
alter table personagens add column if not exists carga_limit int not null default 0;
alter table personagens add column if not exists equipado jsonb not null default '{}';
-- slots de equipado: arma, armadura, escudo, capuz, acessorio, luvas,
-- parte_cima, parte_baixo, carta (1 so, regra do item 7). Valores = inventario.id

-- jogador NAO ganha update direto na tabela (senao editava atributo/nome) —
-- todo estado de jogo passa por esta funcao, que so aceita as colunas da
-- lista branca e so na linha cujo dono e' o usuario logado.
create or replace function salvar_estado_online(p jsonb)
returns void language plpgsql security definer set search_path = public as $$
declare
  v_nome text;
  v_campo text;
begin
  select nome into v_nome from personagens where dono_id = auth.uid();
  if v_nome is null then
    raise exception 'nenhum personagem ligado a esta conta';
  end if;
  -- colunas numericas: so atualiza se a chave veio no payload
  foreach v_campo in array array[
    'col_mao','col_guardado','col_ganho_hoje','folego','bug','carga_limit'
  ]
  loop
    if p ? v_campo then
      execute format(
        'update personagens set %I = $1, updated_at = now() where nome = $2',
        v_campo
      ) using (p ->> v_campo)::int, v_nome;
    end if;
  end loop;
  -- data/timestamp e jsonb, um a um
  if p ? 'col_reset_dia' then
    update personagens set col_reset_dia = (p ->> 'col_reset_dia')::date, updated_at = now()
      where nome = v_nome;
  end if;
  if p ? 'bug_ate' then
    update personagens set bug_ate = (p ->> 'bug_ate')::timestamptz, updated_at = now()
      where nome = v_nome;
  end if;
  if p ? 'folego_atualizado_em' then
    update personagens set folego_atualizado_em = (p ->> 'folego_atualizado_em')::timestamptz,
      updated_at = now() where nome = v_nome;
  end if;
  if p ? 'equipado' then
    update personagens set equipado = (p -> 'equipado'), updated_at = now()
      where nome = v_nome;
  end if;
end $$;
grant execute on function salvar_estado_online(jsonb) to authenticated;

-- ================== ITEM 8 — inventario ===================================

create table if not exists inventario (
  id bigserial primary key,
  personagem_nome text not null references personagens(nome) on delete cascade,
  tipo text not null check (tipo in
    ('arma','equipamento','consumivel','material','carta','cristal','ovo','pet')),
  item_id text not null,      -- id na tabela de origem (armas.id, cartas.id...) ou nome livre
  nome text not null,         -- cache de exibicao
  quantidade int not null default 1,
  equipado boolean not null default false,
  slot text,                  -- arma | armadura | capuz | etc (se equipado)
  cristal_id text references cristais(id),  -- socket: cristal de boss encaixado
  origem text,                -- drop | craft | compra | missao
  obtido_em timestamptz not null default now(),
  excluido boolean not null default false
);

create or replace function e_dono_personagem(p_personagem_nome text)
returns boolean language sql stable security definer set search_path = public as $$
  select exists(select 1 from personagens where nome = p_personagem_nome and dono_id = auth.uid());
$$;

alter table inventario enable row level security;
drop policy if exists "dono_gerencia" on inventario;
create policy "dono_gerencia" on inventario for all
  using (e_dono_personagem(personagem_nome) or is_mestre())
  with check (e_dono_personagem(personagem_nome) or is_mestre());
drop policy if exists "leitura_publica" on inventario;
create policy "leitura_publica" on inventario for select
  using (true); -- vitrine alheia precisa mostrar o que esta a venda

-- ================== ITEM 7 — cartas e cristais (catalogo) =================

create table if not exists cartas (
  id text primary key,
  nome text not null,
  raridade text not null check (raridade in ('Comum','Incomum','Raro','Épico','Lendário')),
  tipo_bonus text not null check (tipo_bonus in ('atributo','dano','resist','especial')),
  valor_bonus int not null default 0,
  descricao text,
  drop_de text,               -- monstro de origem ou "MVP"/"Boss"
  chance_drop numeric not null default 0,  -- % de chance (0 a 100)
  img text,
  visivel boolean not null default true,
  excluido boolean not null default false,
  updated_at timestamptz not null default now()
);

create table if not exists cristais (
  id text primary key,
  nome text not null,
  tipo_bonus text not null check (tipo_bonus in ('atributo','dano','resist','especial')),
  valor_bonus int not null default 0,
  descricao text,
  drop_de text,               -- monstro de origem (100% em boss)
  img text,
  visivel boolean not null default true,
  excluido boolean not null default false,
  updated_at timestamptz not null default now()
);

-- ================== ITEM 14 — ferramentas de oficio =======================
-- IMPORTANTE: 5 níveis POR profissão (desbloqueia a cada 2 níveis de profissão)
-- Por isso PK é id, não profissão.

create table if not exists ferramentas_oficio (
  id text primary key,           -- ex: cacador_n1, domador_n5
  profissao text not null references oficios(nome),
  nome text not null,
  nivel_ferramenta int not null check (nivel_ferramenta between 1 and 5),
  bonus_acao int not null default 0,    -- % de bônus na ação específica
  descricao text,
  receita jsonb,                        -- materiais necessários pra craftar/upar
  acao_afetada text,                    -- qual ação do ofício ela melhora
  como_sobe text default 'craft via profissão',
  visivel boolean not null default true,
  excluido boolean not null default false,
  updated_at timestamptz not null default now()
);

create index if not exists ferramentas_oficio_prof_idx on ferramentas_oficio(profissao);
create index if not exists ferramentas_oficio_nivel_idx on ferramentas_oficio(nivel_ferramenta);

create table if not exists personagem_ferramentas (
  personagem_nome text not null references personagens(nome) on delete cascade,
  ferramenta_id text not null references ferramentas_oficio(id) on delete cascade,
  nivel_atual int not null default 1 check (nivel_atual between 1 and 5),
  obtido_em timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (personagem_nome, ferramenta_id)
);

-- ================== ITEM 1 — criaturas_domadas (pet = craft) ==============

create table if not exists criaturas_domadas (
  id bigserial primary key,
  personagem_nome text not null references personagens(nome) on delete cascade,
  especie text,               -- tipo de monstro de origem (monstros.tipo)
  monstro_id text references monstros(id),
  nome_pet text not null,
  raridade text not null default 'Comum' check (raridade in ('Comum','Incomum','Raro','Épico')),
  status text not null default 'incubando' check (status in ('incubando','ativo','perdido')),
  incubadora_nivel int not null default 1,
  efeitos jsonb not null default '{}', -- efeitos do pet (igual item craft)
  choca_em timestamptz,       -- cronometro de chocagem
  nascido_em timestamptz,
  obtido_em timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  excluido boolean not null default false
);

-- ================== ITEM 5 — nivel/XP por profissao =======================
-- REGRA: 1 personagem = 1 profissão apenas (aplicação garante, não trigger)

create table if not exists nivel_profissao (
  personagem_nome text not null references personagens(nome) on delete cascade,
  profissao text not null references oficios(nome),
  nivel int not null default 1 check (nivel between 1 and 10),  -- andar 1: teto 10
  xp int not null default 0,
  ultima_acao text,
  updated_at timestamptz not null default now(),
  primary key (personagem_nome, profissao)
);

-- ================== ITEM 9 — transacoes + vitrine =========================

create table if not exists transacoes (
  id bigserial primary key,
  criado_em timestamptz not null default now(),
  de_personagem text references personagens(nome),   -- null = sistema/NPC
  para_personagem text references personagens(nome), -- null = sistema/NPC
  tipo text not null check (tipo in
    ('missao','venda','compra','craft','bug','ajuste_mestre','npc')),
  valor int not null,
  item_id text,
  observacao text
);

create table if not exists vitrine (
  id bigserial primary key,
  vendedor_nome text not null references personagens(nome) on delete cascade,
  inventario_id bigint not null references inventario(id) on delete cascade,
  preco_col int not null check (preco_col > 0),
  criado_em timestamptz not null default now(),
  vendido boolean not null default false,
  comprador_nome text references personagens(nome),
  vendido_em timestamptz
);

-- comprar da vitrine de outro jogador mexe na carteira dos dois — por isso
-- e' funcao (jogador nao tem update na linha alheia). Devolve erro em texto
-- ou null em caso de sucesso.
create or replace function comprar_da_vitrine(p_vitrine_id bigint)
returns text language plpgsql security definer set search_path = public as $$
declare
  v vitrine%rowtype;
  v_comprador text;
  v_item inventario%rowtype;
  v_col int;
begin
  select nome into v_comprador from personagens where dono_id = auth.uid();
  if v_comprador is null then return 'sem personagem'; end if;
  select * into v from vitrine where id = p_vitrine_id and not vendido;
  if not found then return 'oferta nao existe mais'; end if;
  if v.vendedor_nome = v_comprador then return 'nao da pra comprar de voce mesmo'; end if;
  select * into v_item from inventario where id = v.inventario_id;
  if not found then return 'item sumiu'; end if;
  select col_mao into v_col from personagens where nome = v_comprador;
  if v_col < v.preco_col then return 'Col insuficiente na mao'; end if;

  update personagens set col_mao = col_mao - v.preco_col, updated_at = now()
    where nome = v_comprador;
  update personagens set col_mao = col_mao + v.preco_col, updated_at = now()
    where nome = v.vendedor_nome;
  update inventario set personagem_nome = v_comprador, origem = 'compra'
    where id = v.inventario_id;
  update vitrine set vendido = true, comprador_nome = v_comprador, vendido_em = now()
    where id = v.id;
  insert into transacoes (de_personagem, para_personagem, tipo, valor, item_id, observacao)
    values (v_comprador, v.vendedor_nome, 'compra', v.preco_col, v_item.item_id,
            'vitrine #' || v.id);
  return null;
end $$;
grant execute on function comprar_da_vitrine(bigint) to authenticated;

-- ================== ITEM 6/11 — quadro de missoes + fila de craft =========

create table if not exists missoes_quadro (
  id text primary key,
  titulo text not null,
  tipo text check (tipo in ('combate','coleta','oficio','social')),
  descricao text,
  custo_folego int not null default 5,
  nivel_min int not null default 1,
  requer_grupo boolean not null default false, -- true = boss/miniboss, 2-3 jog obrig
  recompensa_xp int not null default 40,
  recompensa_col_min int not null default 30,
  recompensa_col_max int not null default 80,
  drop_tabela text,            -- id da tabela de drop (ex: monstros comuns, chefes)
  visivel boolean not null default true,
  excluido boolean not null default false,
  updated_at timestamptz not null default now()
);

create table if not exists missao_diaria (
  id bigserial primary key,
  personagem_nome text not null references personagens(nome) on delete cascade,
  missao_id text not null references missoes_quadro(id) on delete cascade,
  status text not null default 'oferecida' check (status in ('oferecida','aceita','concluida','expirou')),
  oferecida_em timestamptz not null default now(),
  aceita_em timestamptz,
  concluida_em timestamptz,
  resultado jsonb             -- sucesso/falha, drops, XP, Col ganhos
);

create table if not exists craft_fila (
  id bigserial primary key,
  personagem_nome text not null references personagens(nome) on delete cascade,
  profissao text not null references oficios(nome),
  receita_id text not null,   -- id da receita do oficio
  quantidade int not null default 1,
  iniciado_em timestamptz not null default now(),
  pronto_em timestamptz not null,
  status text not null default 'fabricando' check (status in ('fabricando','pronto','coletado','falhou')),
  resultado jsonb
);

-- ================== ITEM 10 — reputacao de jogador ========================
-- valores entre -3 e +3, por clã/cidade/facção

create table if not exists reputacao_personagem (
  personagem_nome text not null references personagens(nome) on delete cascade,
  cla_nome text not null references clas(nome),
  nivel int not null default 0 check (nivel between -3 and 3),
  ultima_alteracao timestamptz not null default now(),
  motivo text,
  updated_at timestamptz not null default now(),
  primary key (personagem_nome, cla_nome)
);

-- ================== RLS ===================================================
-- catalogos: mesmo padrao do resto do banco (visivel/excluido + mestre).
-- tabelas de jogador: dono gerencia a sua, mestre ve tudo.

do $$
declare t text;
begin
  foreach t in array array['cartas','cristais','ferramentas_oficio','missoes_quadro']
  loop
    execute format('alter table %I enable row level security', t);
    execute format('drop policy if exists "select_publico_ou_mestre" on %I', t);
    execute format(
      'create policy "select_publico_ou_mestre" on %I for select using ' ||
      '((visivel = true and excluido = false) or is_mestre())', t);
    execute format('drop policy if exists "escrita_mestre" on %I', t);
    execute format(
      'create policy "escrita_mestre" on %I for all using (is_mestre()) with check (is_mestre())', t);
  end loop;
end $$;

do $$
declare t text;
begin
  foreach t in array array[
    'personagem_ferramentas','criaturas_domadas','nivel_profissao',
    'missao_diaria','craft_fila','reputacao_personagem'
  ]
  loop
    execute format('alter table %I enable row level security', t);
    execute format('drop policy if exists "dono_gerencia" on %I', t);
    execute format(
      'create policy "dono_gerencia" on %I for all ' ||
      'using (e_dono_personagem(personagem_nome) or is_mestre()) ' ||
      'with check (e_dono_personagem(personagem_nome) or is_mestre())', t);
    execute format('drop policy if exists "leitura_publica" on %I', t);
    execute format(
      'create policy "leitura_publica" on %I for select using (true)', t);
  end loop;
end $$;

alter table transacoes enable row level security;
drop policy if exists "partes_leem" on transacoes;
create policy "partes_leem" on transacoes for select
  using (e_dono_personagem(de_personagem) or e_dono_personagem(para_personagem) or is_mestre());
drop policy if exists "dono_insere" on transacoes;
create policy "dono_insere" on transacoes for insert
  with check (e_dono_personagem(de_personagem) or is_mestre());

alter table vitrine enable row level security;
drop policy if exists "leitura_publica" on vitrine;
create policy "leitura_publica" on vitrine for select using (true);
drop policy if exists "dono_gerencia" on vitrine;
create policy "dono_gerencia" on vitrine for all
  using (e_dono_personagem(vendedor_nome) or is_mestre())
  with check (e_dono_personagem(vendedor_nome) or is_mestre());

-- ================== seeds minimos (quadro de missoes) =====================

insert into missoes_quadro (id, titulo, tipo, descricao, custo_folego, nivel_min, requer_grupo, recompensa_xp, recompensa_col_min, recompensa_col_max, drop_tabela)
values
  ('caca-do-dia', 'Caça do dia', 'combate',
   'Abata um monstro comum da sua região. Sem pressa, sem risco extra.',
   5, 1, false, 40, 30, 80, 'monstros_comuns'),
  ('coleta-do-dia', 'Coleta do dia', 'coleta',
   'Traga material bruto de um ponto de coleta qualquer.',
   4, 1, false, 35, 25, 70, null),
  ('servico-de-oficio', 'Serviço de ofício', 'oficio',
   'Execute uma Ação de Ofício pra um NPC ou jogador — vale produção, serviço ou conhecimento.',
   6, 1, false, 50, 40, 100, null),
  ('mao-amiga', 'Mão amiga', 'social',
   'Ajude alguém de verdade: escolta, doação, mediação. Alimenta reputação.',
   3, 1, false, 60, 20, 60, null),
  ('contrato-arriscado', 'Contrato arriscado', 'combate',
   'Alvo acima do recomendado. Drop cheio se der certo; Bug se der errado.',
   10, 2, false, 90, 80, 200, 'monstros_elite')
on conflict (id) do nothing;

-- ================== EXPANSÕES PÓS-DECISÕES (Item 05 + 08 + 09) ==================

-- -------- Item 05: curva de XP por nível de profissão --------
create table if not exists nivel_profissao_xp (
  nivel int primary key check (nivel between 2 and 10),
  xp_necessario int not null
);
insert into nivel_profissao_xp (nivel, xp_necessario) values
  (2, 100), (3, 250), (4, 500), (5, 1000),
  (6, 2000), (7, 3500), (8, 6000), (9, 10000), (10, 18000)
on conflict (nivel) do nothing;

-- -------- Item 09: expiração de anúncio + tipos extra de transação --------
alter table vitrine add column if not exists expira_em timestamptz not null default now() + interval '7 days';
create index if not exists vitrine_expira_idx on vitrine(expira_em) where not vendido;

-- amplia check de transacoes com novos tipos (taxa, etc)
alter table transacoes drop constraint if exists transacoes_tipo_check;
alter table transacoes add constraint transacoes_tipo_check check (tipo in
  ('missao','venda','compra','craft','bug','ajuste_mestre','npc','taxa','limite_diario'));

-- função atômica: PUBLICAR ANÚNCIO (cria vitrine, marca item como origem=mercado, já expira 7d)
-- devolve id da vitrine ou erro em texto
create or replace function publicar_anuncio(p_inventario_id bigint, p_preco int)
returns text language plpgsql security definer set search_path = public as $$
declare
  v_item inventario%rowtype;
  v_dono text;
  v_vid bigint;
begin
  if p_preco is null or p_preco <= 0 then return 'preco invalido'; end if;
  select nome into v_dono from personagens where dono_id = auth.uid();
  if v_dono is null then return 'sem personagem'; end if;
  select * into v_item from inventario where id = p_inventario_id;
  if not found then return 'item nao existe'; end if;
  if v_item.personagem_nome <> v_dono then return 'nao e seu item'; end if;
  if v_item.equipado then return 'item equipado, desequipue antes'; end if;
  insert into vitrine (vendedor_nome, inventario_id, preco_col)
    values (v_dono, p_inventario_id, p_preco) returning id into v_vid;
  return v_vid::text;
end $$;
grant execute on function publicar_anuncio(bigint,int) to authenticated;

-- função atômica: REMOVER ANÚNCIO (antes de expirar) — devolve item, não cobra taxa
create or replace function remover_anuncio(p_vitrine_id bigint)
returns text language plpgsql security definer set search_path = public as $$
declare
  v vitrine%rowtype;
  v_dono text;
begin
  select nome into v_dono from personagens where dono_id = auth.uid();
  select * into v from vitrine where id = p_vitrine_id;
  if not found then return 'oferta nao existe'; end if;
  if v.vendido then return 'oferta ja vendida'; end if;
  if v.vendedor_nome <> v_dono and not is_mestre() then return 'nao e sua oferta'; end if;
  delete from vitrine where id = v.id;
  return null;
end $$;
grant execute on function remover_anuncio(bigint) to authenticated;

-- LIMPAR ANÚNCIOS EXPIRADOS (roda periodicamente, ou trigger on select)
-- devolve qtos foram removidos
create or replace function limpar_anuncios_expirados()
returns int language plpgsql security definer set search_path = public as $$
declare
  v_cont int := 0;
  r record;
begin
  for r in select * from vitrine where not vendido and expira_em < now() loop
    delete from vitrine where id = r.id;
    v_cont := v_cont + 1;
  end loop;
  return v_cont;
end $$;
grant execute on function limpar_anuncios_expirados() to authenticated;

-- -------- Item 09: ATUALIZA compra_da_vitrine — SEM TAXA, SEM TETO DIÁRIO --------
-- Jogadores recebem 100% do valor (sem taxa de administração); sem limite de ganho/dia.
-- O controle de grind é feito por Fôlego em missões/craft. Mercado funciona sempre.
drop function if exists comprar_da_vitrine(bigint);
create or replace function comprar_da_vitrine(p_vitrine_id bigint)
returns text language plpgsql security definer set search_path = public as $$
declare
  v vitrine%rowtype;
  v_comprador text;
  v_vendedor text;
  v_item inventario%rowtype;
  v_col int;
begin
  select nome into v_comprador from personagens where dono_id = auth.uid();
  if v_comprador is null then return 'sem personagem'; end if;

  select * into v from vitrine where id = p_vitrine_id and not vendido;
  if not found then return 'oferta nao existe mais'; end if;
  if v.vendedor_nome = v_comprador then return 'nao da pra comprar de voce mesmo'; end if;
  if v.expira_em < now() then return 'oferta expirou'; end if;

  v_vendedor := v.vendedor_nome;
  select * into v_item from inventario where id = v.inventario_id;
  if not found then return 'item sumiu'; end if;

  select col_mao into v_col from personagens where nome = v_comprador;
  if v_col < v.preco_col then return 'Col insuficiente na mao'; end if;

  -- 1) desconta Col do comprador
  update personagens set col_mao = col_mao - v.preco_col, updated_at = now()
    where nome = v_comprador;
  -- 2) repassa 100% DO VALOR pro vendedor (sem taxa, sem teto)
  update personagens
    set col_mao = col_mao + v.preco_col,
        updated_at = now()
    where nome = v_vendedor;
  -- 3) troca dono do item no inventário
  update inventario set personagem_nome = v_comprador, origem = 'compra'
    where id = v.inventario_id;
  -- 4) marca vitrine como vendida
  update vitrine set vendido = true, comprador_nome = v_comprador, vendido_em = now()
    where id = v.id;
  -- 5) log compra (entrada única; sem linha de taxa extra)
  insert into transacoes (de_personagem, para_personagem, tipo, valor, item_id, observacao)
    values (v_comprador, v_vendedor, 'compra', v.preco_col, v_item.item_id,
            format('vitrine #%s (100%% valor — sem taxa)', v.id));
  return null;
end $$;
grant execute on function comprar_da_vitrine(bigint) to authenticated;

-- ================== ITEM 06 (expansão) — Missões Diárias Completas ==============

-- -------- Novas colunas em missoes_quadro (mais ricas para o mestre editar) --------
alter table missoes_quadro drop constraint if exists missoes_quadro_tipo_check;
alter table missoes_quadro add constraint missoes_quadro_tipo_check check (tipo in
  ('caca','coleta','oficio','social','contrato_arriscado','entrega'));

alter table missoes_quadro add column if not exists regiao text default 'Andar 1 - Início';
alter table missoes_quadro add column if not exists alvo text;
alter table missoes_quadro add column if not exists alvo_qtd int default 1;
alter table missoes_quadro add column if not exists raridade text default 'comum'
  check (raridade in ('comum','incomum','raro','epico','lendario'));
alter table missoes_quadro add column if not exists drop_item_id text;
alter table missoes_quadro add column if not exists drop_chance real default 0.35;
alter table missoes_quadro add column if not exists reputacao_cla_nome text;
alter table missoes_quadro add column if not exists reputacao_delta int default 0;
alter table missoes_quadro add column if not exists penalidade_col_falha int default 0;
alter table missoes_quadro add column if not exists penalidade_folego_falha int default 0;

-- -------- Seeds: 48 missões por nível 1-10 (balanceadas por XP, Col, Fôlego) --------
-- Valores são editáveis no admin depois. Regra de balanceamento usada:
--   XP por fôlego ≈ nível × 6  (nível 1 = 6, nível 10 = 60)
--   Col por fôlego ≈ nível × (4 a 10), maior em raridade maior
insert into missoes_quadro (id, titulo, tipo, descricao, custo_folego, nivel_min,
  requer_grupo, recompensa_xp, recompensa_col_min, recompensa_col_max, raridade,
  regiao, alvo, alvo_qtd, drop_item_id, drop_chance) values
  -- ========= NÍVEL 1 (iniciante, qualquer um faz) =========
  ('n1-caca-ratos','Caça aos Ratos Gigantes','caca',
   'A adega do Armação está infestada. Mate 3 ratos para o dono do bar.',
   2,1,false,20,8,20,'comum','Andar 1 - Início','Rato Gigante',3,
   'ingrediente-carne-ruim',0.45),
  ('n1-coleta-ervas','Coletar Ervas de Planície','coleta',
   'A herborista de Início precisa de 5 ervas medicinais.',
   2,1,false,18,6,18,'comum','Andar 1 - Planície Ocidental','Erva Medicinal',5,
   'erva-medicinal',0.8),
  ('n1-entrega-carta','Entregar carta ao mercador','entrega',
   'Leve uma carta do prefeito para o mercador do Armazém Central.',
   1,1,false,10,5,10,'comum','Andar 1 - Cidade de Início',null,1,
   null,0.0),
  ('n1-oficio-corda','Fabricar corda básica','oficio',
   'A Forja do Bairro precisa de 2 cordas (fabrique com 4 fibra cada).',
   3,1,false,25,10,25,'comum','Andar 1 - Cidade de Início','Corda',2,
   'corda-basica',0.95),
  ('n1-social-idoso','Ajudar o idoso a atravessar','social',
   'O velho Elias tem medo da ponte de madeira. Acompanhe-o.',
   1,1,false,12,4,8,'comum','Andar 1 - Ponte de Madeira',null,1,null,0.0),
  ('n1-contrato-lobo','Contrato: Lobo Cinzento','contrato_arriscado',
   'Um lobo solitário está rondando os celeiros. Alvo mais forte.',
   4,1,false,45,25,45,'incomum','Andar 1 - Floresta do Lobo','Lobo Cinzento Alfa',1,
   'pelo-lobo',0.6),

  -- ========= NÍVEL 2 =========
  ('n2-caca-corvos','Afastar Corvos das Ruínas','caca',
   'Corvos gigantes atacam arqueólogos que escavam as Ruínas do Portal.',
   2,2,false,30,12,30,'comum','Andar 1 - Ruínas do Portal','Corvo das Ruínas',3,
   'pena-corvo-preto',0.5),
  ('n2-coleta-minerio','Garimpo de Cobre','coleta',
   'Extraia 5 minérios de cobre da Mina Aberta para a Guilda.',
   3,2,false,36,12,36,'comum','Andar 1 - Mina Aberta','Minério de Cobre',5,
   'minerio-cobre',0.75),
  ('n2-oficio-lingote','Lingote de Bronze','oficio',
   'Produza 3 lingotes: 2 minério cobre + 1 carvão = 1 lingote.',
   4,2,false,50,20,40,'comum','Andar 1 - Forja','Lingote de Bronze',3,
   'lingote-bronze',0.95),
  ('n2-entrega-encomenda','Encomenda do Ferreiro','entrega',
   'Entregue 1 espada curta ao comandante da Guarda da Vila.',
   2,2,false,28,14,28,'incomum','Andar 1 - Guarda',null,1,
   null,0.0),
  ('n2-social-resgate','Resgate de gato de família','social',
   'Busque o gato do mercador no telhado da antiga padaria.',
   1,2,false,16,6,14,'comum','Andar 1 - Padaria',null,1,null,0.0),
  ('n2-contrato-hound','Contrato: Hound de Cobre','contrato_arriscado',
   'Autômato de cobre do tipo canino fugiu da fundição. Recupere.',
   5,2,false,70,35,70,'raro','Andar 1 - Fundição Abandonada','Hound de Cobre',1,
   'nucleo-cobre',0.7),

  -- ========= NÍVEL 3 =========
  ('n3-caca-aranhas','Limpeza de Túnel: Aranhas','caca',
   'As teias bloquearam o Túnel do Vendedor. Elimine 4.',
   3,3,false,50,20,50,'incomum','Andar 1 - Túnel Oeste','Aranha Sombria',4,
   'fio-seda',0.6),
  ('n3-coleta-madeira','Tora de Madeira Dura','coleta',
   'Corte 8 toras de madeira para o carpinteiro.',
   4,3,false,60,18,48,'comum','Andar 1 - Floresta do Leste','Madeira Dura',8,
   'tora-madeira-dura',0.85),
  ('n3-oficio-carne','Cortar 10 porções de carne seca','oficio',
   'A Cantina da Guarda pede 10 porções (precisa de 15 cruas).',
   4,3,false,65,22,50,'incomum','Andar 1 - Cantina','Carne Seca',10,
   'carne-seca',0.95),
  ('n3-entrega-pedido','Pedido para o Clã Guerreiros','entrega',
   'Leve 5 lingotes de bronze para o QG do Clã dos Espadachins.',
   3,3,false,42,18,42,'incomum','Clã Guerreiros',null,1,null,0.0),
  ('n3-social-media','Mediador de briga de lojistas','social',
   'Dois lojistas lutam por espaço na Feira. Imponha a paz.',
   2,3,false,30,10,25,'incomum','Feira de Início',null,1,null,0.0),
  ('n3-contrato-ent','Contrato: Ent Ancião','contrato_arriscado',
   'Ent ancião despertou e não deixa lenhadores passar.',
   6,3,false,100,60,100,'raro','Floresta do Leste Profunda','Ent Ancião',1,
   'semente-anciao',0.5),

  -- ========= NÍVEL 4 =========
  ('n4-caca-kobolds','Patrulha de Kobolds','caca',
   'Bando saqueador de kobolds no Vale do Sol. Elimine 5.',
   3,4,false,65,24,65,'incomum','Vale do Sol','Guerreiro Kobold',5,
   'adaga-kobold',0.5),
  ('n4-coleta-peixe','Pesca no Lago Prateado','coleta',
   'Pesque 10 peixes do lago para o restaurante luxo.',
   4,4,false,72,25,60,'incomum','Lago Prateado','Peixe Prateado',10,
   'peixe-prateado',0.7),
  ('n4-oficio-pocao','Poção de Cura Básica (5 un.)','oficio',
   'Produza 5 poções (2 ervas medicinais + 1 água benta cada).',
   5,4,false,90,40,70,'incomum','Herborista','Poção de Cura',5,
   'pocao-cura-basica',0.9),
  ('n4-entrega-bens','Conduzir carro de mercadorias','entrega',
   'A escolta do carro de mercadorias ficou doente — substitua.',
   4,4,false,60,30,60,'raro','Estrada da Colina',null,1,null,0.0),
  ('n4-social-escolta','Escolta criança até a escola','social',
   'Mãe solteira trabalha e precisa de alguém para levar a criança.',
   2,4,false,28,8,20,'comum','Cidade de Início',null,1,null,0.0),
  ('n4-contrato-ilfang','Contrato: Ilfang (Chefe Kobold)','contrato_arriscado',
   'Rei dos kobolds no Túnel 1. Matá-lo termina a onda de saques.',
   8,4,false,170,100,170,'epico','Túnel 1 - Sala do Trono','Illfang the Kobold Lord',1,
   'ilfang-adaga',0.9),

  -- ========= NÍVEL 5 =========
  ('n5-caca-abelhas','Abelhas Gigantes do Apiário','caca',
   'Abelhas gigantes atacaram o apiário do vilarejo. Elimine a colônia.',
   4,5,false,90,40,90,'incomum','Vilarejo da Floresta','Abelha Gigante',4,
   'mel-gigante',0.45),
  ('n5-coleta-cristal','Cristal de mana fragmentado','coleta',
   'Colete 6 fragmentos da caverna de mana cristalizada.',
   5,5,false,110,40,80,'raro','Caverna Mana','Fragmento de Cristal',6,
   'cristal-mana-fragmentado',0.65),
  ('n5-oficio-armadura','Armadura de Couro Reforçada','oficio',
   'Para recruta: 6 couro + 8 ling. bronze + 4 corda = 1 armadura.',
   6,5,false,135,60,110,'raro','Forja da Colina','Armadura Couro Reforçada',1,
   'armadura-couro-reforcada',0.85),
  ('n5-entrega-relevo','Correr mensageiro de relevo','entrega',
   '3 estações de relevo entre cidades. Corra 1 trecho.',
   4,5,false,80,35,80,'incomum','Estradas entre cidades',null,1,null,0.0),
  ('n5-social-doacao','Arrecadar doação para órfãos','social',
   'Visite 5 lojas, consiga doações para o orfanato novo.',
   3,5,false,60,15,40,'incomum','Cidade do Mercado',null,5,null,0.0),
  ('n5-contrato-arautos','Contrato: Arautos das Alturas (x2)','contrato_arriscado',
   'Abutres gigantes atacam o correio aéreo. Mate 2.',
   7,5,false,200,140,200,'raro','Passos das Montanhas','Arauto das Alturas',2,
   'pena-arauto',0.7),

  -- ========= NÍVEL 6 =========
  ('n6-caca-hounds','Manada de Hounds de Prata','caca',
   'Autômatos caninos de prata no Deserto. Elimine 6.',
   5,6,false,130,60,130,'raro','Deserto de Prata','Hound de Prata',6,
   'nucleo-prata',0.55),
  ('n6-coleta-areia','Areia encantada','coleta',
   'Cristaleiro precisa de 12 areia encantada do deserto.',
   5,6,false,140,50,100,'raro','Deserto de Prata','Areia Encantada',12,
   'areia-encantada',0.8),
  ('n6-oficio-pet','Criar incubadora básica (Domador)','oficio',
   'Produto final: 1 incubadora (5 madeira + 3 prata + 2 mana cristal).',
   7,6,false,180,90,160,'raro','Domador','Incubadora Pequena',1,
   'incubadora-pequena',0.9),
  ('n6-entrega-tesoros','Transportar Baú da Guilda','entrega',
   'Escolta baú com 1000 Col em tesouros da Guilda até o banco vizinho.',
   5,6,false,120,70,120,'raro','Cidade da Guilda',null,1,null,0.0),
  ('n6-social-paz','Paz entre 2 clãs rivais','social',
   'Clã Ferreiros vs Ferreiros Negros. Negocie a trégua.',
   4,6,false,100,30,80,'raro','Reunião da Guilda',null,1,null,0.0),
  ('n6-contrato-armadura','Contrato: Armadura Animada','contrato_arriscado',
   'Armadura animada no Templo Selado. Só cair se crítico de Conhecimento.',
   9,6,false,280,180,280,'epico','Templo Selado','Armadura Animada',1,
   'peitoral-animado',0.85),

  -- ========= NÍVEL 7 =========
  ('n7-caca-corujas','Corujas das Sombras','caca',
   'Corujas das trevas no Velho Parque. Derrube 4.',
   5,7,false,170,70,170,'raro','Velho Parque','Coruja das Sombras',4,
   'olho-sombrio',0.5),
  ('n7-coleta-nectar','Néctar de Flor Lunar','coleta',
   'Coletar 8 flores lunares (apenas de noite) pro Alquimista Chefe.',
   6,7,false,200,70,140,'epico','Jardim da Lua à meia-noite','Flor Lunar',8,
   'nectar-lunar',0.6),
  ('n7-oficio-espada','Forjar Espada Longa (1 mão)','oficio',
   'Receita: 4 ling. aço + 2 madeira + 1 couro. Nível Ferreiro 7.',
   8,7,false,260,120,220,'epico','Forja Mestra','Espada Longa',1,
   'espada-longa-boa',0.85),
  ('n7-entrega-diplomatico','Diplomata em comboio real','entrega',
   'Comboio do Rei para a cidade vizinha. Você é a escolta VIP.',
   6,7,false,180,100,180,'epico','Caminho Real',null,1,null,0.0),
  ('n7-social-discurso','Discurso na Câmara dos Lores','social',
   'Discurso pedindo verbas para o orfanato expandir.',
   4,7,false,150,40,100,'epico','Palácio da Câmara',null,1,null,0.0),
  ('n7-contrato-alfa-lupino','Contrato: Alfa Lupino','contrato_arriscado',
   'Líder da alcateia gigante do Vale Nevado. Matar dissolve o bando.',
   10,7,false,360,250,360,'epico','Vale Nevado','Alfa Lupino',1,
   'pele-alfa',0.85),

  -- ========= NÍVEL 8 =========
  ('n8-caca-enxame','Enxame de Abelhas Douradas','caca',
   'Abelhas douradas invadiram os celeiros. Derrube a rainha.',
   6,8,false,240,100,240,'epico','Celeiros Reais','Rainha Abelha Dourada',1,
   'favo-dourado',0.7),
  ('n8-coleta-casca','Casca de Árvore Anciã','coleta',
   'Extraia 10 cascas da Grande Árvore do Mundo (cuidado, hostil).',
   7,8,false,280,100,180,'epico','Raiz da Árvore do Mundo','Casca Anciã',10,
   'casca-arvore-ancia',0.7),
  ('n8-oficio-armadura-mestra','Armadura de Placas Mestra','oficio',
   'Obra prima. 10 aço + 4 couro + 2 mana + 1 gema.',
   10,8,false,380,180,340,'epico','Forja Mestra','Armadura de Placas',1,
   'armadura-placas-mestra',0.9),
  ('n8-entrega-biblioteca','Restauração de livro antigo (via entrega)','entrega',
   'Transporte manuscrito sagrado com segurança.',
   6,8,false,240,150,240,'epico','Biblioteca Antiga',null,1,null,0.0),
  ('n8-social-sindical','Representar sindicato de oficiais','social',
   '16 ofícios. Negocie com o prefeito aumento de bolsa de estudo.',
   5,8,false,220,60,160,'epico','Prefeitura',null,1,null,0.0),
  ('n8-contrato-dragao','Contrato: Dragão Bebê de Obsidiana','contrato_arriscado',
   'Dragão bebê escapou do covil. Devolva ou elimine.',
   12,8,false,500,380,500,'lendario','Covil de Obsidiana','Dragão Bebê',1,
   'escama-obsidiana',0.85),

  -- ========= NÍVEL 9 =========
  ('n9-caca-lagartos','Bando de Lagartos da Floresta','caca',
   'Tropas lagartoides na fronteira do sul. Derrube 8.',
   7,9,false,320,140,320,'epico','Fronteira Sul','Lagarto da Floresta',8,
   'escama-lagarto',0.6),
  ('n9-coleta-gema','Mineração de Gemas','coleta',
   'Mina profunda. 3 gemas brutas (de 5 veios) pro joalheiro.',
   8,9,false,370,140,240,'epico','Mina Profunda 3','Gema Bruta',3,
   'gema-bruta',0.55),
  ('n9-oficio-anel','Anel de Proteção Mestra','oficio',
   '1 prata + 1 gema + 2 mana cristal + 1 fio de prata.',
   11,9,false,460,220,400,'lendario','Joalheria Real','Anel de Proteção Mestra',1,
   'anel-protecao-mestra',0.9),
  ('n9-entrega-coroa','Coroa Real (escolta máxima)','entrega',
   'Jóia da coroa. A escolta é você. Risco de assalto.',
   8,9,false,360,220,360,'lendario','Palácio Real',null,1,null,0.0),
  ('n9-social-tratado','Tratado de Fronteira','social',
   'Negociação de 2 cidades fronteiriças. Difícil.',
   6,9,false,340,100,260,'lendario','Câmara de Fronteira',null,1,null,0.0),
  ('n9-contrato-executor','Contrato: Executor Abissal','contrato_arriscado',
   'Cavaleiro caído. Derrote-o no abismo, solo (1v1).',
   14,9,false,700,550,700,'lendario','Abismo 9','Executor Abissal',1,
   'lamina-abissal',0.9),

  -- ========= NÍVEL 10 (MÁXIMO) =========
  ('n10-caca-chefes','Batalha contra 3 Mini-Chefes','caca',
   'Sub-chefes dos andares 3-5. Todos 3, um por dia.',
   10,10,false,480,220,480,'lendario','Andares 3-5','3 Mini-Chefes',3,
   'pequeno-tesouro',0.8),
  ('n10-coleta-esmeralda','Esmeraldas do Mar Interior','coleta',
   'Mergulho profundo. 4 esmeraldas do fundo do mar.',
   10,10,false,550,220,380,'lendario','Mar Interior','Esmeralda',4,
   'esmeralda-bruta',0.55),
  ('n10-oficio-cata-vento','Forjar Espadachim de Lendária (Duas Mãos)','oficio',
   'Receita lenda: 12 aço + 1 escama dragão + 2 gema + 1 raiz da Árvore.',
   15,10,false,700,350,600,'lendario','Forja dos Deuses','Espada Lendária Duas Mãos',1,
   'espada-lendaria-excalibur',0.95),
  ('n10-entrega-testamento','Testamento do Mestre (rota perigosa)','entrega',
   'Testamento do fundador da Guilda. Assalto garantido.',
   10,10,false,560,350,560,'lendario','Rota das Lendas',null,1,null,0.0),
  ('n10-social-ligacao','Fundador da Liga de Todos os Clãs','social',
   'Unir 5 clãs em uma liga para a guerra final. Discurso e acordo.',
   8,10,false,600,150,400,'lendario','Câmara da Liga',null,1,null,0.0),
  ('n10-contrato-chefe','Contrato LENDÁRIO: Chefe da Ordem Demônio','contrato_arriscado',
   'Luta final do andar 10. Grupo recomendado. Se solo, chance baixíssima.',
   20,10,true,1000,800,1000,'lendario','Sala do Chefe do andar 10','Chefe da Ordem Demônio',1,
   'relicario-chefe',0.95)
on conflict (id) do nothing;

-- -------- RPC atômico: aceitar_e_resolver_missao (click único, tudo no servidor) --------
-- Não é "aceitar depois resolver separado" — é um botão só: gastar fôlego, rolar 2d6,
-- aplicar resultado (sucesso / parcial / falha), dar recompensa tudo na mesma transação.
-- Retorna texto JSON com resultado para o front.
create or replace function aceitar_e_resolver_missao(p_missao_id text)
returns text language plpgsql security definer set search_path = public as $$
declare
  v_personagem text;
  v_m missoes_quadro%rowtype;
  v_nivel int;
  v_xp_atual int;
  v_dados int[];
  v_soma int;
  v_dif int;
  v_resultado text;      -- sucesso_total / sucesso_parcial / falha
  v_col_ganho int;
  v_xp_ganho int;
  v_droppou boolean;
  v_drop_novo_id bigint;
  v_novo_nivel int;
  v_xp_subiu_nivel boolean;
  v_folego_gasto int;
  v_nova_md_id bigint;
  v_resp jsonb;
  v_drops_mat_ids bigint[];  -- ids dos drops de material adicionados (para resposta)
  v_novo_mat_id bigint;
begin
  -- 0) validar sessão
  select nome into v_personagem from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  -- 1) validar missão existe, visível, nível mínimo ok
  select * into v_m from missoes_quadro where id = p_missao_id and visivel=true and excluido=false;
  if not found then return '{"erro":"missao invalida"}'; end if;

  select nivel, xp into v_nivel, v_xp_atual
    from nivel_profissao where personagem_nome = v_personagem
    order by nivel desc limit 1;
  if v_nivel is null then v_nivel := 1; v_xp_atual := 0; end if;

  if v_m.nivel_min > v_nivel then
    return format('{"erro":"nivel minimo %s necessario (voce=%s)"}', v_m.nivel_min, v_nivel);
  end if;

  -- 2) validar fôlego
  if not exists (select 1 from personagens where nome = v_personagem and folego >= v_m.custo_folego) then
    return format('{"erro":"folego insuficiente: precisa %s"}', v_m.custo_folego);
  end if;

  -- 3) gastar fôlego
  update personagens
     set folego = folego - v_m.custo_folego, updated_at = now()
     where nome = v_personagem;
  v_folego_gasto := v_m.custo_folego;

  -- 4) calcular nível de dificuldade vs personagem → rolar 2d6 + modificador PBTA
  -- Fórmula de chance base (dif = personagem nivel - missao nivel_min):
  --   dif ≥ +2 → mod = +3
  --   dif = +1 → mod = +1
  --   dif = 0  → mod = 0
  --   dif = -1 → mod = -1
  --   dif ≤ -2 → mod = -3
  v_dif := v_nivel - v_m.nivel_min;
  declare v_mod int; begin
    v_mod := case
      when v_dif >= 2 then 3
      when v_dif = 1  then 1
      when v_dif = 0  then 0
      when v_dif = -1 then -1
      else -3
    end;
    v_dados := array[(1 + floor(random()*6))::int, (1 + floor(random()*6))::int];
    v_soma := v_dados[1] + v_dados[2] + v_mod;
  end;

  -- 5) aplicar resultado (PBTA 3 vias)
  if v_soma >= 10 then
    v_resultado := 'sucesso_total';
    v_xp_ganho := v_m.recompensa_xp;
    v_col_ganho := v_m.recompensa_col_min +
      floor(random() * (v_m.recompensa_col_max - v_m.recompensa_col_min + 1));
  elsif v_soma >= 7 then
    v_resultado := 'sucesso_parcial';
    v_xp_ganho := (v_m.recompensa_xp * 0.7)::int;
    v_col_ganho := ((v_m.recompensa_col_min + v_m.recompensa_col_max) / 2 * 0.8)::int;
  else
    v_resultado := 'falha';
    v_xp_ganho := 0;
    v_col_ganho := 0;
    if v_m.penalidade_col_falha > 0 then
      update personagens
        set col_mao = greatest(0, col_mao - v_m.penalidade_col_falha), updated_at = now()
        where nome = v_personagem;
    end if;
    if v_m.penalidade_folego_falha > 0 then
      update personagens
        set folego = greatest(0, folego - v_m.penalidade_folego_falha), updated_at = now()
        where nome = v_personagem;
    end if;
  end if;

  -- 6) DROPS: (a) especifico da missao + (b) generico de materiais SEMPRE (100% obtencao via drop, sem NPCs)
  v_drop_novo_id := null;
  v_drops_mat_ids := array[]::bigint[];

  -- (a) drop ESPECÍFICO (se a missao tem drop_item_id definido — arma/equip/carta etc)
  if v_resultado <> 'falha' and v_m.drop_item_id is not null then
    v_droppou := random() < v_m.drop_chance;
    if v_droppou then
      declare
        v_drop_nome text;
        v_drop_tipo text;
      begin
        select nome, coalesce(tipo, 'arma') into v_drop_nome, v_drop_tipo
          from armas where id = v_m.drop_item_id;
        if not found then
          select nome, coalesce(tipo, 'equipamento') into v_drop_nome, v_drop_tipo
            from equipamentos where id = v_m.drop_item_id;
        end if;
        if not found then
          select nome, 'carta' into v_drop_nome, v_drop_tipo
            from cartas where id = v_m.drop_item_id;
        end if;
        if v_drop_nome is null then
          -- se nao existir em nenhuma catalogo, interpreta como material de craft (fallback)
          v_drop_nome := coalesce((select nome from materiais_basicos where id = v_m.drop_item_id), v_m.drop_item_id);
          v_drop_tipo := 'material';
        end if;
        insert into inventario
          (personagem_nome, item_id, nome, tipo, quantidade, origem)
          values (v_personagem, v_m.drop_item_id, v_drop_nome, v_drop_tipo, 1, 'missao')
          returning id into v_drop_novo_id;
        if v_drop_tipo = 'material' then
          v_drops_mat_ids := array_append(v_drops_mat_ids, v_drop_novo_id);
        end if;
      end;
    end if;
  end if;

  -- (b) drop GENÉRICO DE MATERIAIS DE CRAFT — sempre rola quando sucesso/parcial,
  --     garantindo regra #2: "só drop obtém TUDO, nenhuma dependência de NPC".
  --     Regras de roll:
  --       · Nível missão → raridade permitida (escala suave)
  --       · Tipo missão  → categoria preferencial (caca=animal, coleta=vegetal/mineral etc)
  --       · 1-3 materiais por missão (2 padrão, 1 em parcial, 3 só total alto nivel)
  --       · qtd por material: comum 3-8 / incomum 2-5 / raro 1-3 / épico 1-2 / lendário 1
  if v_resultado <> 'falha' then
    declare
      v_qtd_mats int;
      v_rar_allowed text[];
      v_cats_pref text[];
      v_roll_rar text;
      v_roll_cat text;
      v_roll_mat_id text;
      v_roll_mat_nome text;
      v_roll_qtd int;
      v_cont int;
      v_chance_rar_alta numeric;
    begin
      -- qtd de materiais a sortear: parcial = 1-2 / total = 2-3
      if v_resultado = 'sucesso_total' then
        v_qtd_mats := 2 + case when v_m.nivel_min >= 6 then 1 else 0 end;  -- +1 a partir de nv6 total
      else
        v_qtd_mats := 1 + case when v_m.nivel_min >= 8 then 1 else 0 end;  -- parcial = 1 ou 2
      end if;

      -- raridade permitida baseada em nivel_min da missao (escala progressiva, sem saltos)
      -- chance de raridade ALTA aumenta com sucesso_total (até 25%)
      v_chance_rar_alta := case v_resultado
        when 'sucesso_total' then 0.25 else 0.08 end;
      case
        when v_m.nivel_min <= 2 then
          v_rar_allowed := case when random() < v_chance_rar_alta
            then array['comum','incomum'] else array['comum'] end;
        when v_m.nivel_min between 3 and 4 then
          v_rar_allowed := case when random() < v_chance_rar_alta
            then array['incomum','raro'] else array['comum','incomum'] end;
        when v_m.nivel_min between 5 and 6 then
          v_rar_allowed := case when random() < v_chance_rar_alta
            then array['raro','epico'] else array['incomum','raro'] end;
        when v_m.nivel_min between 7 and 8 then
          v_rar_allowed := case when random() < v_chance_rar_alta
            then array['epico','lendario'] else array['raro','epico'] end;
        else  -- nv 9-10
          v_rar_allowed := case when random() < v_chance_rar_alta
            then array['lendario'] else array['epico','lendario'] end;
      end case;

      -- categorias preferidas por TIPO de missão (categoria exata → mais provável)
      case coalesce(v_m.tipo, 'combate')
        when 'caca'                then v_cats_pref := array['animal','mineral','exotico'];
        when 'coleta'              then v_cats_pref := array['vegetal','mineral','quimico'];
        when 'oficio'              then v_cats_pref := array['mineral','tecido','quimico','vegetal'];
        when 'entrega'             then v_cats_pref := array['tecido','nobre','quimico'];
        when 'social'              then v_cats_pref := array['tecido','nobre','quimico','vegetal'];
        when 'contrato_arriscado'  then v_cats_pref := array['exotico','nobre','animal','lendario'];
        else                             v_cats_pref := array['mineral','animal','vegetal'];
      end case;

      -- loop para dropar cada material (não repete material na mesma missão)
      v_cont := 0;
      declare
        v_ja_usados text[] := array[]::text[];
      begin
        while v_cont < v_qtd_mats loop
          -- (i) escolhe uma raridade do pool permitido
          v_roll_rar := v_rar_allowed[1 + floor(random() * array_length(v_rar_allowed, 1))::int];

          -- (ii) 60% chance de usar categoria preferida, 40% qualquer outra
          if random() < 0.60 then
            v_roll_cat := v_cats_pref[1 + floor(random() * array_length(v_cats_pref, 1))::int];
            -- escolhe material com essa raridade E categoria preferida OU só raridade se não tiver
            select id, nome into v_roll_mat_id, v_roll_mat_nome
              from materiais_basicos
              where raridade = v_roll_rar and categoria = v_roll_cat
                and visivel and not excluido
                and id <> all (v_ja_usados)
              order by random() limit 1;
          else
            v_roll_cat := null;
          end if;
          -- fallback: só raridade, qualquer categoria
          if v_roll_mat_id is null then
            select id, nome into v_roll_mat_id, v_roll_mat_nome
              from materiais_basicos
              where raridade = v_roll_rar and visivel and not excluido
                and id <> all (v_ja_usados)
              order by random() limit 1;
          end if;

          if v_roll_mat_id is not null then
            -- quantidade baseada em raridade
            v_roll_qtd := case v_roll_rar
              when 'comum'    then 3 + floor(random() * 6)::int   -- 3..8
              when 'incomum'  then 2 + floor(random() * 4)::int   -- 2..5
              when 'raro'     then 1 + floor(random() * 3)::int   -- 1..3
              when 'epico'    then 1 + (random() < 0.4)::int      -- 1..2
              else 1                                              -- lendario = 1
            end;
            -- sucesso_total dá +50% na qtd (round up)
            if v_resultado = 'sucesso_total' then
              v_roll_qtd := ceil(v_roll_qtd * 1.5)::int;
            end if;

            insert into inventario
              (personagem_nome, item_id, nome, tipo, quantidade, origem)
              values (v_personagem, v_roll_mat_id, v_roll_mat_nome, 'material', v_roll_qtd, 'missao')
              returning id into v_novo_mat_id;
            v_drops_mat_ids := array_append(v_drops_mat_ids, v_novo_mat_id);
            v_ja_usados := array_append(v_ja_usados, v_roll_mat_id);
          end if;

          v_cont := v_cont + 1;
          -- evita loop infinito se faltar material
          exit when v_cont > 10;
        end loop;
      end;
    end;
  end if;

  -- 7) recompensas col e xp + subir nível
  if v_xp_ganho > 0 or v_col_ganho > 0 then
    if v_col_ganho > 0 then
      update personagens set col_mao = col_mao + v_col_ganho, updated_at = now()
        where nome = v_personagem;
    end if;
    if v_xp_ganho > 0 then
      declare
        v_prof text;
        v_xp_novo int;
        v_prox_nivel_xp int;
      begin
        select profissao into v_prof from personagens where nome = v_personagem;
        if v_prof is null then v_prof := 'Aventureiro'; end if;
        if not exists (select 1 from nivel_profissao
                        where personagem_nome = v_personagem and profissao = v_prof) then
          insert into nivel_profissao (personagem_nome, profissao, nivel, xp)
            values (v_personagem, v_prof, 1, 0);
        end if;
        update nivel_profissao
           set xp = xp + v_xp_ganho, updated_at = now()
         where personagem_nome = v_personagem and profissao = v_prof
         returning xp into v_xp_novo;
        v_novo_nivel := null;
        <<sobe_nivel>> loop
          v_xp_subiu_nivel := false;
          select coalesce(max(nivel), 1) into v_nivel from nivel_profissao
            where personagem_nome = v_personagem;
          select xp_necessario into v_prox_nivel_xp from nivel_profissao_xp
            where nivel = v_nivel + 1;
          exit sobe_nivel when v_prox_nivel_xp is null;
          if v_xp_novo >= v_prox_nivel_xp then
            update nivel_profissao
               set nivel = nivel + 1,
                   xp = xp - v_prox_nivel_xp,
                   updated_at = now()
             where personagem_nome = v_personagem and profissao = v_prof
             returning xp into v_xp_novo;
            v_xp_subiu_nivel := true;
            v_novo_nivel := coalesce(v_novo_nivel, v_nivel + 1);
          end if;
          exit sobe_nivel when not v_xp_subiu_nivel;
        end loop sobe_nivel;
      end;
    end if;
  end if;

  -- 8) inserir transação log
  if v_col_ganho > 0 then
    insert into transacoes (de_personagem, para_personagem, tipo, valor, item_id, observacao)
      values (null, v_personagem, 'missao', v_col_ganho, v_m.drop_item_id,
              format('missao %s %s (xp=%s)', v_m.id, v_resultado, v_xp_ganho));
  end if;

  -- 9) salvar no histórico missao_diaria
  v_resp := jsonb_build_object(
    'resultado', v_resultado,
    'dados', v_dados,
    'soma_com_mod', v_soma,
    'xp', v_xp_ganho,
    'col', v_col_ganho,
    'drop_item_id', v_m.drop_item_id,
    'drop_inventario_id', v_drop_novo_id,
    'drops_materiais_inventario_ids', v_drops_mat_ids,
    'folego_gasto', v_folego_gasto,
    'novo_nivel', v_novo_nivel,
    'missao_titulo', v_m.titulo,
    'missao_tipo', v_m.tipo,
    'missao_nivel_min', v_m.nivel_min
  );
  insert into missao_diaria (personagem_nome, missao_id, status, aceita_em, concluida_em, resultado)
    values (v_personagem, p_missao_id,
            case when v_resultado='falha' then 'expirou' else 'concluida' end::text,
            now(), now(), v_resp)
    returning id into v_nova_md_id;

  return v_resp::text;
end $$;
grant execute on function aceitar_e_resolver_missao(text) to authenticated;

-- -------- RPC auxiliar: sortear_missoes_do_dia (5 missões random nível compatível) --------
-- Não salva nada, só devolve as 5 para o front.
create or replace function sortear_missoes_do_dia()
returns setof missoes_quadro language sql security definer set search_path = public as $$
  with me as (
    select coalesce(max(nivel), 1) as n
    from nivel_profissao
    where personagem_nome = (select nome from personagens where dono_id = auth.uid())
  )
  select q.*
  from missoes_quadro q, me
  where q.visivel and not q.excluido
    and q.nivel_min between greatest(1, me.n - 2) and me.n + 2
  order by random()
  limit 5;
$$;
grant execute on function sortear_missoes_do_dia() to authenticated;

-- ================== ITEM 15 — Estalagem (comprar fôlego com Col) ==================
-- Preços fixos por padrão; valores editáveis no admin na tabela "sistema" (campos
-- estalagem_p1, estalagem_p5, estalagem_p20) ou hardcoded abaixo por enquanto.
create or replace function comprar_folego(p_qtd int)
returns text language plpgsql security definer set search_path = public as $$
declare
  v_personagem text;
  v_col_mao int;
  v_folego_atual int;
  v_preco_por int;
  v_preco int;
  v_qtd_real int;
  v_resp jsonb;
begin
  select nome, col_mao, folego into v_personagem, v_col_mao, v_folego_atual
    from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  -- limita qtd máxima (não deixa passar de 20)
  v_qtd_real := least(p_qtd, 20 - coalesce(v_folego_atual, 0));
  if v_qtd_real <= 0 then
    return format('{"erro":"folego ja esta cheio (voce tem %s/20)"}', coalesce(v_folego_atual, 0));
  end if;

  -- tabela de preço fixa (3 faixas: 1un = 5Col, 5un = 6Col/un, 20un = 7.5Col/un)
  -- mestre pode mudar depois colocando em sistema.campo_json
  if v_qtd_real <= 1 then v_preco_por := 5;
  elsif v_qtd_real <= 5 then v_preco_por := 6;
  else v_preco_por := 7; end if;
  v_preco := v_qtd_real * v_preco_por;

  if v_col_mao < v_preco then
    return format('{"erro":"col insuficiente: precisa %s (tem %s). preco por unidade = %s Col"}', v_preco, v_col_mao, v_preco_por);
  end if;

  update personagens
     set col_mao = col_mao - v_preco,
         folego = folego + v_qtd_real,
         updated_at = now()
   where nome = v_personagem;

  insert into transacoes (de_personagem, para_personagem, tipo, valor, observacao)
    values (v_personagem, null, 'estalagem', v_preco,
            format('comprou +%s folego por %s Col (preco_un=%s)', v_qtd_real, v_preco, v_preco_por));

  v_resp := jsonb_build_object(
    'ok', true,
    'folego_gasto_col', v_preco,
    'folego_ganho_qtd', v_qtd_real,
    'preco_unidade', v_preco_por,
    'folego_agora', coalesce(v_folego_atual, 0) + v_qtd_real
  );
  return v_resp::text;
end $$;
grant execute on function comprar_folego(int) to authenticated;

-- -------- Expandir check de transacoes com novos tipos (estalagem, envio, transferencia) --------
alter table transacoes drop constraint if exists transacoes_tipo_check;
alter table transacoes add constraint transacoes_tipo_check check (tipo in
  ('missao','venda','compra','craft','bug','ajuste_mestre','npc','taxa','limite_diario','estalagem','transferencia','envio_item','chocagem'));

-- ================== ITEM 16.1 — CRAFT BALANCEADO: 40 MATERIAIS · 128 RECEITAS · OVOS ==================
--
-- REGRAS DE BALANCEAMENTO RÍGIDO (aplicadas nestes seeds):
--   1. Nenhum material fica órfão — cada um aparece em >=3 E <=6 receitas (média 4,5±1)
--   2. Nenhum material é "coringa" — máximo 6 usos/total
--   3. Materiais de nível maior = raridade maior = usados em receitas de nível maior
--   4. Profissões distintas compartilham ~1/3 dos materiais (ninguém fica 100% independente)
--   5. Ferramenta NvN requer materiais de nível N-1, N e N+1 (progressão suave)
--   6. Craft SEMPRE rola PBTA server-side (sucesso total / parcial / complicou) — nunca 100% garantido

-- ===== MATERIAIS BÁSICOS (40 unidades, 8 em cada faixa de raridade) =====
create table if not exists materiais_basicos (
  id text primary key,                 -- ex: mat_fibra_linho, mat_palha
  nome text not null unique,
  raridade text not null check (raridade in ('comum','incomum','raro','epico','lendario')),
  nivel_obtencao int not null check (nivel_obtencao between 1 and 10),  -- menor nível que dropa
  categoria text not null,             -- vegetal, mineral, animal, tecido, quimico, nobre, exotico, lendario
  peso_uso_esperado int not null default 4 check (peso_uso_esperado between 3 and 6),
  descricao text,
  fonte text,                          -- onde dropa (regiao, tipo missao, monstro)
  visivel boolean not null default true,
  excluido boolean not null default false,
  updated_at timestamptz not null default now()
);
create index if not exists mb_rar_idx on materiais_basicos(raridade);
create index if not exists mb_nv_idx on materiais_basicos(nivel_obtencao);
create index if not exists mb_cat_idx on materiais_basicos(categoria);

-- ===== RECEITAS DE PRODUÇÃO (128 receitas: 8 por profissão = Nv1..Nv10 mas pulamos 9-10 para ferramentas = 8 + 1 ovo / pet) =====
-- PK composta (profissão, nível_receita, tipo). tipo: 'ferramenta' (Nv1..5) ou 'item' (Nv1..10)
create table if not exists receitas (
  id text primary key,                 -- ex: cacador_item_n3, domador_ferramenta_n1
  profissao text not null references oficios(nome) on delete cascade,
  nivel_receita int not null check (nivel_receita between 1 and 10),
  tipo text not null check (tipo in ('ferramenta','item','ovo_especial')),
  nome_resultado text not null,        -- nome exibido (ex: Incubadora Pequena)
  resultado_item_id text,              -- id em outra tabela se houver (armas, ferramentas_oficio)
  resultado_raridade text check (resultado_raridade in ('comum','incomum','raro','epico','lendario')),
  atributo_teste text not null check (atributo_teste in ('Reflexo','Conhecimento','Técnica','Espírito','Corpo')),
  dificuldade_mod int not null default 0,   -- -1..+5 (dificuldade extra; mais fácil em receitas fáceis)
  folego_custo int not null default 1 check (folego_custo between 0 and 10),
  xp_recompensa int not null default 0,     -- xp de profissao ao craftar com sucesso
  materiais jsonb not null,            -- [{"mat_id":"mat_abc","qtd":3},...]
  efeitos jsonb not null default '{}', -- bonus, propriedades, descrição do item final
  receita_refino boolean not null default false,  -- verdadeiro se for receita de refino (2 estágios)
  receita_estagio int not null default 1 check (receita_estagio between 1 and 2),
  receita_antecessora_id text references receitas(id),  -- refino estágio 1 → estágio 2
  visivel boolean not null default true,
  excluido boolean not null default false,
  updated_at timestamptz not null default now()
);
create index if not exists rec_prof_idx on receitas(profissao);
create index if not exists rec_nv_idx on receitas(nivel_receita);
create index if not exists rec_tipo_idx on receitas(tipo);

-- ===== CATÁLOGO DE OVOS (12 criaturas iniciais, andar 1) =====
create table if not exists ovos_catalogo (
  id text primary key,                 -- ex: ovo_lobo_cinza, ovo_slime
  nome text not null unique,
  especie text,                        -- tipo de monstro (monstros.tipo)
  monstro_id text references monstros(id),
  raridade text not null check (raridade in ('comum','incomum','raro','epico','lendario')),
  nivel_min int not null default 1 check (nivel_min between 1 and 10),
  tempo_chocagem_horas int not null check (tempo_chocagem_horas between 1 and 72),
  incubadora_min int not null default 1 check (incubadora_min between 1 and 5),
  efeitos_padrao jsonb not null default '{}',  -- bônus do pet quando ativo
  como_obter text not null default 'drop em monstro especifico',
  descricao text,
  visivel boolean not null default true,
  excluido boolean not null default false,
  updated_at timestamptz not null default now()
);
create index if not exists ov_rar_idx on ovos_catalogo(raridade);
create index if not exists ov_nv_idx on ovos_catalogo(nivel_min);

-- ========== SEEDS (00) — CATÁLOGO DE OVOS (12 criaturas do andar 1, 3 vias de obtenção por ovo) ==========
-- Distribuição de raridade: 5 comum (nv1-2) · 3 incomum (nv3-4) · 2 raro (nv5-6) · 1 épico (nv7-8) · 1 lendário (nv9-10)
-- Cada ovo lista EXATAMENTE 3 formas de obter (regra do c4): (a) drop monstro específico; (b) missão de contrato/caça; (c) mercado / craft Domador
insert into ovos_catalogo (id, nome, especie, monstro_id, raridade, nivel_min, tempo_chocagem_horas, incubadora_min, efeitos_padrao, como_obter, descricao) values
  -- ============ COMUM (5 ovos · Nv 1-2) ============
  ('ovo_ratogig','Rato Gigante', 'Rato', 'rato_gigante', 'comum', 1, 4, 1,
   '{"bonus_furtividade": "+5%","bonus_caca": "+3%"}',
   '(a) Drop 15%: caça Rato Gigante (Nv1) · (b) Contrato caça "Infestação Celebre" (Nv1) · (c) Craft Domador Nv1',
   'Pequeno, ágil e sorrateiro. Bom pra iniciantes.'),
  ('ovo_jovali_jovem','Javali Jovem', 'Javali', 'javali_jovem', 'comum', 1, 6, 1,
   '{"bonus_corpo": "+4%","bonus_colheita": "+4%"}',
   '(a) Drop 12%: missão coleta "Javali Jovem (Nv1) · (b) Missão de entrega "Carne de Javali" (Nv1) · (c) Mercado de Nv1',
   'Temperamento calmo; fornece carne e couro em abundância.'),
  ('ovo_lobo_cinza','Lobo Cinzento', 'Lobo', 'lobo_cinza', 'comum', 2, 8, 1,
   '{"bonus_reflexo": "+6%","bonus_rastrear": "+5%"}',
   '(a) Drop 10%: caça em Alcateia Cinzenta (Nv2) · (b) Contrato "Líder Alcateia" (Nv2) · (c) Craft Domador Nv2',
   'Caçador nato de matilha. Aventureiro solitário.'),
  ('ovo_urso','Urso de Floresta', 'Urso', 'urso_floresta', 'comum', 2, 10, 1,
   '{"bonus_corpo": "+8%","resistencia_fria": "+5"}',
   '(a) Drop 8%: caça Urso (Nv2) · (b) Missão coleta "Covil do Urso" (Nv2-3) · (c) NPC lenhador missão social',
   'Resistente e forte; tank natural.'),
  ('ovo_arauto','Avestruz de Batalha', 'Avestruz', 'avestruz_batalha', 'comum', 2, 7, 1,
   '{"bonus_velocidade": "+10%","bonus_carga": "+15%"}',
   '(a) Drop 10%: Planície Avestruz (Nv2) · (b) Missão de corrida (Nv2) · (c) Mercado Nv2',
   'Montaria veloz; leva carga extra.'),

  -- ============ INCOMUM (3 ovos · Nv 3-4) ============
  ('ovo_lobo_alfa','Lobo Alfa', 'Lobo Alfa', 'lobo_alfa', 'incomum', 3, 14, 2,
   '{"bonus_reflexo": "+10%","bonus_caca": "+8%","aura_lider": "+3%"}',
   '(a) Drop 7%: contrato Alfa Lupino (Nv5 garantido 100%) · (b) Missão grupo "Matilha Alfa" (Nv3-4) · (c) Craft Domador Nv3',
   'Líder de matilha. Bônus de liderança.'),
  ('ovo_corvo_sombrio','Corvo Sombrio', 'Corvo', 'corvo_sombrio', 'incomum', 3, 12, 2,
   '{"bonus_conhecimento": "+7%","visao_noturna": "1","bonus_espirito": "+4%"}',
   '(a) Drop 8%: caça Corvos (Nv3) · (b) Missão social "Mensageiro Sombrio" (Nv3) · (c) Mercado Nv3',
   'Vê no escuro; carrega mensagens.'),
  ('ovo_javali_selvagem','Javali Selvagem (Frenzy)', 'Javali Frenzy', 'frenzy_boar', 'incomum', 4, 16, 2,
   '{"bonus_corpo": "+12%","resistencia_dano": "5%"}',
   '(a) Drop 6%: Frenzy Javali (Nv4) · (b) Contrato caça "Javali Enfurecido" (Nv4) · (c) Craft Domador Nv4',
   'Fúria incontrolável em batalha.'),

  -- ============ RARO (2 ovos · Nv 5-6) ============
  ('ovo_aranha_sombra','Aranha das Sombras', 'Aranha', 'aranha_sombra', 'raro', 5, 24, 3,
   '{"bonus_tecnica": "+12%","bonus_tecido": "+10%","veneno": "leve"}',
   '(a) Drop 5%: Túnel do Vendedor / Aranha Sombria (Nv6) · (b) Contrato grupo "Ninho Teia Sombria" (Nv5-6) · (c) Craft Domador Nv5',
   'Produz seda rara; detecta armadilhas.'),
  ('ovo_coruja_sombria','Coruja Sombria (sábia)', 'Coruja', 'coruja_sombria', 'raro', 6, 28, 3,
   '{"bonus_conhecimento": "+15%","bonus_espirito": "+8%","visao_noturna": "2"}',
   '(a) Drop 4%: Velho Parque · contrato Coruja das Sombras (Nv8 garantido 100%) · (b) Missão social "Sabedoria Anciã" (Nv6) · (c) Craft Domador Nv6',
   'Visão aguçada; sabedoria passiva.'),

  -- ============ ÉPICO (1 ovo · Nv 7-8) ============
  ('ovo_dragao_bebe','Dragão Bebê Obsidiana', 'Dragão', 'dragao_bebe_obsidiana', 'epico', 7, 48, 4,
   '{"bonus_corpo": "+20%","bonus_reflexo": "+15%","sopro_fogo": "1"}',
   '(a) Drop 3%: contrato Dragão Bebê Obsidiana (garantido) · (b) Grupo miniboss (Nv8) · (c) Craft Domador Nv7 + ovo especial',
   'Lendário filhote de dragão. Pequeno agora, mas enorme potencial.'),

  -- ============ LENDÁRIO (1 ovo · Nv 9-10) ============
  ('ovo_fenix_bebe','Fênix Bebê (Andar 10)', 'Fênix', 'fenix_bebe', 'lendario', 9, 72, 5,
   '{"bonus_espirito": "+30%","ressuscitar": "1/por dia","aura_fogo": "5"}',
   '(a) Drop único: Sala Chefe Final (1 por grupo) · (b) Evento mestre (1 único andar 10) · (c) Somente Domador Nv10',
   'Imortal. Recompensa final do Andar 1. Ressuscita o dono 1× por dia.')
on conflict (id) do nothing;

-- ========== SEEDS (01) — MATERIAIS BÁSICOS (48 unidades — 12 comum · 10 incomum · 9 raro · 12 epico · 5 lendario) ==========
-- Tetos de uso por raridade (alinhados à demanda por nível):
--   comum = 10 (nv1-2: 64 slots obrigatórios + 64 opcionais); incomum = 8; raro = 6; epico = 5; lendario = 4.
-- Distribuição: lendário tem exatamente 5 (16 slots _n5_ref / 5 = 3,2 usos média · mínimo 3). Os 4 extras foram épicos.

insert into materiais_basicos (id, nome, raridade, nivel_obtencao, categoria, peso_uso_esperado, descricao, fonte) values
  -- ============ COMUM (Nv 1-2 — 12 materiais) ============
  ('mat_linho_fibra',    'Fibra de Linho',         'comum',    1, 'tecido',   8, 'Fios longos usados em corda, tecido e curativo.',              'Missões Nv1-2: coleta, ofício e caça'),
  ('mat_madeira_comum',  'Madeira Comum',          'comum',    1, 'vegetal',  8, 'Tora leve, madeira seca de planície.',                         'Missões Nv1-2: coleta, lenhador'),
  ('mat_palha',          'Palha Seca',             'comum',    1, 'vegetal',  6, 'Palha de trigo ou aveia, armazenada em fardos.',               'Missões Nv1-2: coleta em fazendas'),
  ('mat_argila',         'Argila Bruta',           'comum',    1, 'mineral',  6, 'Argila de leito de rio. Base para tijolos e cerâmica.',       'Missões Nv1-2: coleta em beira de rio'),
  ('mat_pedra_lascada',  'Pedra Lascada',          'comum',    1, 'mineral',  6, 'Pedra quebrada com arestas vivas; matéria-prima de lâminas.', 'Missões Nv1-2: coleta em pedreira / caça'),
  ('mat_ferro_bruto',    'Ferro Bruto (sucata)',   'comum',    2, 'mineral',  8, 'Sucata de ferro recuperada. Passa por refino antes da forja.', 'Missões Nv2: coleta em minas abandonadas'),
  ('mat_carne_ruim',     'Carne Crua Comum',       'comum',    1, 'animal',   6, 'Carne de animal de porte pequeno. Seca ou cozinha rápido.',   'Missões Nv1-2: caça a Rato Gigante, Javali Jovem'),
  ('mat_erva_comum',     'Erva Medicinal Comum',   'comum',    1, 'quimico',  6, 'Erva amarga; antisséptico e analgésico simples.',             'Missões Nv1-2: coleta em planícies'),
  ('mat_lingo_pinho',    'Madeira de Pinho',       'comum',    1, 'vegetal',  6, 'Tora de pinho leve e resinosa; ideal para cabos e móveis.',   'Missões Nv1-2: coleta em Floresta de Pinheiros'),
  ('mat_seda_crua',      'Seda Crua (fios)',       'comum',    1, 'tecido',   6, 'Fios de seda de casulo de bicho-da-seda; base de tecidos finos.', 'Missões Nv1-2: coleta em sericultura, contrato fazenda'),
  ('mat_carvao_pedra',   'Carvão Mineral',         'comum',    2, 'mineral',  6, 'Carvão betuminoso; queima quente e constante para forjas.',   'Missões Nv2: coleta em Mina de Carvão Abandonada'),
  ('mat_borracha_látex', 'Látex Bruto',            'comum',    1, 'vegetal',  5, 'Seiva leitosa de seringueira; endurece em borracha flexível.','Missões Nv1-2: coleta em seringal, contratos do Comerciante'),

  -- ============ INCOMUM (Nv3-4 — 10 materiais) ============
  ('mat_cobre_pepita',   'Pepita de Cobre',        'incomum',  3, 'mineral',  7, 'Pepita de cobre puro extraída de veio.',                      'Missões Nv3-4: coleta em Mina Aberta'),
  ('mat_madeira_nodosa', 'Madeira Nodosa',         'incomum',  3, 'vegetal',  7, 'Madeira com nós densos; ideal para cabos resistentes.',       'Missões Nv3-4: coleta em Floresta do Leste'),
  ('mat_couro_cru',      'Couro Cru',              'incomum',  3, 'animal',   7, 'Pele curtida ainda não processada; base de armaduras leves.', 'Missões Nv3-4: caça a Lobo, Javali Adulto'),
  ('mat_tecido_grosso',  'Tecido Grosso',          'incomum',  3, 'tecido',   6, 'Tecido de tear manual; camada dupla.',                        'Missões Nv3: oficina Costureiro, missão de ofício'),
  ('mat_pergaminho_sim', 'Pergaminho Simples',     'incomum',  3, 'quimico',  6, 'Folha de papel tratado, aceita tinta e selo.',                'Missões Nv3-4: diplomata, bibliotecário'),
  ('mat_oleo_animal',    'Óleo Animal (banha)',    'incomum',  4, 'animal',   6, 'Gordura fervida de caça grande; lubrificante e combustível.','Missões Nv4: caça a Frenzy Boar'),
  ('mat_tinta_preta',    'Tinta Preta',            'incomum',  4, 'quimico',  6, 'Tinta de noz de gale + goma arábica.',                        'Missões Nv4: bibliotecário, missão de contrato no cartógrafo'),
  ('mat_latao_po',       'Pó de Latão (esmeril)',  'incomum',  4, 'mineral',  6, 'Pó abrasivo para polir e afiar metais e gemas.',              'Missões Nv4: Oficina Ferreiro / Joalheiro'),
  ('mat_resina_arvore',  'Resina de Árvore',       'incomum',  3, 'vegetal',  5, 'Resina pegajosa de conífera; cola, verniz e antisséptico.',   'Missões Nv3-4: coleta em floresta, lenhador contratos'),
  ('mat_fio_aluminio',   'Fio de Alumínio',        'incomum',  4, 'mineral',  5, 'Fio fino e leve de alumínio; jóias e componentes delicados.', 'Missões Nv4: Oficina Joalheiro, mina de bauxita'),

  -- ============ RARO (Nv5-6 — 9 materiais) ============
  ('mat_prata_lamina',   'Lâmina de Prata (1mm)',  'raro',     5, 'mineral',  6, 'Lâmina fina de prata laminada; usada em jóias e filtros.',    'Missões Nv5-6: minério raro + refino 2 estágios'),
  ('mat_aço_incomum',    'Aço Incomum (lingote)',  'raro',     5, 'mineral',  6, 'Aço com teor de carbono controlado.',                         'Missões Nv5: Forja, minério raro + carvão em 2 estágios'),
  ('mat_cristal_branco', 'Cristal Branco (pequeno)','raro',    5, 'nobre',    5, 'Cristal leitoso; conduz mana de forma segura.',              'Missões Nv5: caverna de mana, contrato com grupo'),
  ('mat_pelo_lobo_alfa', 'Pelagem Grisalha Alfa',  'raro',     5, 'animal',   5, 'Pele de Alfa Lupino; quente e resistente à água.',            'Missões Nv5-6: contrato Alfa Lupino (drop garantido)'),
  ('mat_vidro_temper',   'Vidro Temperado',        'raro',     6, 'mineral',  5, 'Vidro recozido em forno de cozinheiro; resiste a choques.',   'Missões Nv6: Oficina Vidreiro / Alquimista'),
  ('mat_erva_ancestral', 'Erva Ancestral',         'raro',     6, 'vegetal',  5, 'Erva de floresta antiga; base de poção média.',               'Missões Nv6: coleta noturna em floresta antiga'),
  ('mat_carnauba',       'Cera de Carnaúba',       'raro',     6, 'vegetal',  5, 'Cera natural impermeável e lustrosa.',                        'Missões Nv6: coleta em oásis do deserto'),
  ('mat_fio_seda',       'Fio de Seda Selvagem',   'raro',     6, 'tecido',   5, 'Fio de seda de aranha das sombras; muito resistente.',        'Missões Nv6: caça em Túnel do Vendedor (Aranha Sombria)'),
  ('mat_coral_negro',    'Coral Negro (pedaço)',   'raro',     5, 'nobre',    4, 'Coral negro de profundidade; jóias amuletísticas de proteção.','Missões Nv5: contrato mergulho em Mar Esmagador, raro drop'),

  -- ============ ÉPICO (Nv7-8 — 12 materiais) ============
  ('mat_aco_raro',       'Aço Raro (lingote)',     'epico',    7, 'mineral',  5, 'Aço com molibdênio; necessário para lâminas que não quebram.','Missões Nv7-8: refino 2 estágios + contrato de Oficina Mestra'),
  ('mat_ouro_folha',     'Ouro Folha (24k)',       'epico',    7, 'nobre',    4, 'Folha de ouro 0,1mm; decoração e jóias finas.',              'Missões Nv7: mina profunda, veio aurífero'),
  ('mat_nucleo_prata',   'Núcleo de Prata',        'epico',    7, 'exotico',  4, 'Núcleo de hound de prata; componente mágico-metálico.',       'Missões Nv7: manada de Hounds de Prata (drop raro)'),
  ('mat_nucleo_dragao',  'Núcleo de Dragão Bebê',  'epico',    8, 'exotico',  4, 'Coração/cristal interno de dragão bebê.',                    'Missões Nv8: contrato Dragão Obsidiana Bebê'),
  ('mat_casco_dourado',  'Favo Dourado Completo',  'epico',    8, 'animal',   4, 'Favo da Rainha Abelha Dourada; mel + cera + geleia real.',   'Missões Nv8: contrato Enxame Abelhas Douradas'),
  ('mat_olho_sombrio',   'Olho de Coruja Sombria', 'epico',    8, 'animal',   4, 'Olho preservado em névoa quente; visão noturna permanente.',  'Missões Nv8: Velho Parque, contrato Corujas das Sombras'),
  ('mat_gema_branca',    'Gema Branca Lapidada',   'epico',    8, 'nobre',    4, 'Gema branca de quartzo facetada; conduz encantamentos.',     'Missões Nv8: oficina Joalheiro, mina profunda 2 estágios'),
  ('mat_manta_termica',  'Manta Térmica (peça)',   'epico',    8, 'tecido',   4, 'Tecido de lã de carneiro + fibra de dragão bebê.',            'Missões Nv8: dragão bebê (contrato arriscado)'),
  ('mat_nectar_lunar',   'Néctar de Flor Lunar',   'epico',    7, 'quimico',  4, 'Seiva de flor lunar colhida à meia-noite.',                   'Missões Nv7: coleta noturna no Jardim da Lua'),
  ('mat_casca_ancia',    'Casca de Árvore Anciã',  'epico',    8, 'vegetal',  4, 'Casca de carvalho milenar; imbuída de espírito protetor.',    'Missões Nv8: raiz da Árvore do Mundo (hostil)'),
  ('mat_osso_chefe',     'Osso Lendário de Chefe', 'epico',    8, 'animal',   4, 'Ossos de 10 chefes; usado em armas/armaduras épicas.',       'Missões Nv8-9: conquista coletiva em masmorra'),
  ('mat_essencia_divina','Essência Divina (gota)', 'epico',    8, 'exotico',  4, 'Gota de névoa dourada pura; usado em refinamento avançado.', 'Missões Nv8-9: recompensa grupo em eventos raros'),

  -- ============ LENDÁRIO (Nv9-10 — 5 materiais; SÓ em ferramenta_n5_ref · 16 slots / 5 = 3,2 usos média) ============
  ('mat_adamantita',     'Fragmento de Adamantita','lendario', 9, 'mineral',  4, 'Metal lendário; inquebrável, mais leve que o ferro.',         'Missões Nv9-10: Sala do Chefe 9/10, drop 1 por chefe'),
  ('mat_aina_crista',    'Fragmento de Aincrad',   'lendario', 10, 'exotico',  4, 'Fragmento do Cristal Mestre de Aincrad; mana pura.',          'Missões Nv10: chefe Ordem Demônio (drop 1 grupo)'),
  ('mat_runa_vida',      'Runa de Vida (cópia)',   'lendario',10, 'quimico',  4, 'Runa inscrita em osso antigo; concede estabilidade vital.',   'Missões Nv10: forjada por Mestre Rúnico'),
  ('mat_fio_destino',    'Fio de Destino (1 metro)','lendario',9, 'tecido',   4, 'Fio de tear lendário; tecido confeccionado com ele é único.', 'Missões Nv9: tear das Moiras, contrato social'),
  ('mat_gema_andar10',   'Gema do Andar 10',       'lendario',10, 'nobre',    4, 'Gema extraída da câmara do chefe final; 7 cores.',           'Missões Nv10: 1 gema por jogador após final do andar 10')
on conflict (id) do nothing;

-- ========== SEEDS (02) — RECEITAS (128 = 16×8 · BALANCEAMENTO 3→TETO POR RARIDADE · GERADO AUTOMATICAMENTE) ==========
-- Regras rígidas aplicadas:
--   · 48 materiais × 3..10 usos cada (tetos: comum=10, incomum=8, raro=6, epico=5, lendario=4 · 224 refs total)
--   · Nenhum órfão (≥3 usos mínimos por material); sem coringas.
--   · Nv receita MAIOR ↔ raridade de material MAIOR (fallback só para raridade MENOR, nunca maior).
--   · Escolha por MENOS-USADO-PRIMEIRO (round-robin) + 2ª passada de troca.
--   · Nenhum typos (IDs canônicos de materiais_basicos).
-- Gerado por scripts/_gerar_receitas_balanceadas.py (seed=42 reprodutível).

-- (1) CAÇADOR (Reflexo) · 8 receitas
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, atributo_teste, dificuldade_mod, folego_custo, xp_recompensa, materiais, resultado_raridade, efeitos, receita_refino, receita_estagio, receita_antecessora_id) values
  ('cacador_ferramenta_n1','Caçador',1,'ferramenta','Arco Iniciante','Reflexo',0,1,20,'[{"mat_id": "mat_linho_fibra", "qtd": 5}, {"mat_id": "mat_lingo_pinho", "qtd": 10}]','comum','{"bonus": "+3% em atividades de caçador"}','f',1,null),
  ('cacador_ferramenta_n2','Caçador',2,'ferramenta','Arco Treinado','Reflexo',0,2,35,'[{"mat_id": "mat_tecido_grosso", "qtd": 7}, {"mat_id": "mat_tinta_preta", "qtd": 2}]','incomum','{"bonus": "+6% em atividades de caçador"}','f',1,null),
  ('cacador_item_n1','Caçador',1,'item','Rede Captura','Conhecimento',0,1,12,'[{"mat_id": "mat_ferro_bruto", "qtd": 5}, {"mat_id": "mat_palha", "qtd": 8}]','comum','{"efeito": "Item de Caçador: Rede Captura (nível 1)"}','f',1,null),
  ('cacador_item_n2','Caçador',2,'item','Farpas Caça','Reflexo',0,1,18,'[{"mat_id": "mat_carne_ruim", "qtd": 10}, {"mat_id": "mat_cobre_pepita", "qtd": 6}]','comum','{"efeito": "Item de Caçador: Farpas Caça (nível 2)"}','f',1,null),
  ('cacador_item_n4','Caçador',4,'item','Mochila Rastreio','Reflexo',1,2,45,'[{"mat_id": "mat_erva_ancestral", "qtd": 4}, {"mat_id": "mat_aço_incomum", "qtd": 2}]','incomum','{"efeito": "Item de Caçador: Mochila Rastreio (nível 4)"}','f',1,null),
  ('cacador_item_n6','Caçador',6,'item','Luvas Extração','Conhecimento',1,3,65,'[{"mat_id": "mat_olho_sombrio", "qtd": 1}]','raro','{"efeito": "Item de Caçador: Luvas Extração (nível 6)"}','f',1,null),
  ('cacador_ferramenta_n5','Caçador',5,'ferramenta','Arco Lendário Est1','Técnica',3,5,100,'[{"mat_id": "mat_gema_branca", "qtd": 2}, {"mat_id": "mat_nucleo_dragao", "qtd": 3}]','epico','{"bonus": "+12% em atividades de caçador", "estagio1": true}','f',1,null),
  ('cacador_ferramenta_n5_ref','Caçador',5,'ferramenta','Arco Lendário Est2','Reflexo',4,8,170,'[{"mat_id": "mat_gema_andar10", "qtd": 1}]','lendario','{"bonus": "+15% em atividades de caçador", "estagio2": true}','t',2,'cacador_ferramenta_n5')
on conflict (id) do nothing;

-- (2) LENHADOR (Corpo) · 8 receitas
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, atributo_teste, dificuldade_mod, folego_custo, xp_recompensa, materiais, resultado_raridade, efeitos, receita_refino, receita_estagio, receita_antecessora_id) values
  ('lenhador_ferramenta_n1','Lenhador',1,'ferramenta','Machado Iniciante','Corpo',0,1,20,'[{"mat_id": "mat_seda_crua", "qtd": 4}, {"mat_id": "mat_erva_comum", "qtd": 4}]','comum','{"bonus": "+3% em atividades de lenhador"}','f',1,null),
  ('lenhador_ferramenta_n2','Lenhador',2,'ferramenta','Machado Treinado','Corpo',0,2,35,'[{"mat_id": "mat_fio_aluminio", "qtd": 7}, {"mat_id": "mat_resina_arvore", "qtd": 4}]','incomum','{"bonus": "+6% em atividades de lenhador"}','f',1,null),
  ('lenhador_item_n1','Lenhador',1,'item','Estacas Madeira','Corpo',0,1,12,'[{"mat_id": "mat_pedra_lascada", "qtd": 10}, {"mat_id": "mat_argila", "qtd": 9}]','comum','{"efeito": "Item de Lenhador: Estacas Madeira (nível 1)"}','f',1,null),
  ('lenhador_item_n2','Lenhador',2,'item','Carvão Vegetal','Corpo',0,1,18,'[{"mat_id": "mat_oleo_animal", "qtd": 3}, {"mat_id": "mat_carvao_pedra", "qtd": 7}]','comum','{"efeito": "Item de Lenhador: Carvão Vegetal (nível 2)"}','f',1,null),
  ('lenhador_item_n4','Lenhador',4,'item','Pranchas Nobres','Corpo',1,2,45,'[{"mat_id": "mat_latao_po", "qtd": 2}, {"mat_id": "mat_fio_seda", "qtd": 5}]','incomum','{"efeito": "Item de Lenhador: Pranchas Nobres (nível 4)"}','f',1,null),
  ('lenhador_item_n6','Lenhador',6,'item','Torre Vigia','Corpo',1,3,65,'[{"mat_id": "mat_ouro_folha", "qtd": 2}]','raro','{"efeito": "Item de Lenhador: Torre Vigia (nível 6)"}','f',1,null),
  ('lenhador_ferramenta_n5','Lenhador',5,'ferramenta','Machado Gigantes Est1','Corpo',3,5,100,'[{"mat_id": "mat_couro_cru", "qtd": 5}, {"mat_id": "mat_nucleo_prata", "qtd": 2}]','epico','{"bonus": "+12% em atividades de lenhador", "estagio1": true}','f',1,null),
  ('lenhador_ferramenta_n5_ref','Lenhador',5,'ferramenta','Machado Gigantes Est2','Corpo',4,8,170,'[{"mat_id": "mat_fio_destino", "qtd": 1}]','lendario','{"bonus": "+15% em atividades de lenhador", "estagio2": true}','t',2,'lenhador_ferramenta_n5')
on conflict (id) do nothing;

-- (3) CARTÓGRAFO (Conhecimento) · 8 receitas
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, atributo_teste, dificuldade_mod, folego_custo, xp_recompensa, materiais, resultado_raridade, efeitos, receita_refino, receita_estagio, receita_antecessora_id) values
  ('cartografo_ferramenta_n1','Cartógrafo',1,'ferramenta','Prancha Desenho','Conhecimento',0,1,20,'[{"mat_id": "mat_borracha_látex", "qtd": 4}, {"mat_id": "mat_madeira_comum", "qtd": 10}]','comum','{"bonus": "+3% em atividades de cartógrafo"}','f',1,null),
  ('cartografo_ferramenta_n2','Cartógrafo',2,'ferramenta','Bússola Bolso','Conhecimento',0,2,35,'[{"mat_id": "mat_pergaminho_sim", "qtd": 6}, {"mat_id": "mat_madeira_nodosa", "qtd": 4}]','incomum','{"bonus": "+6% em atividades de cartógrafo"}','f',1,null),
  ('cartografo_item_n1','Cartógrafo',1,'item','Mapa Bolso','Corpo',0,1,12,'[{"mat_id": "mat_pedra_lascada", "qtd": 6}, {"mat_id": "mat_palha", "qtd": 10}]','comum','{"efeito": "Item de Cartógrafo: Mapa Bolso (nível 1)"}','f',1,null),
  ('cartografo_item_n2','Cartógrafo',2,'item','Marcador Terreno','Espírito',0,1,18,'[{"mat_id": "mat_argila", "qtd": 7}, {"mat_id": "mat_tinta_preta", "qtd": 2}]','comum','{"efeito": "Item de Cartógrafo: Marcador Terreno (nível 2)"}','f',1,null),
  ('cartografo_item_n4','Cartógrafo',4,'item','Caderno Campo','Conhecimento',1,2,45,'[{"mat_id": "mat_prata_lamina", "qtd": 4}, {"mat_id": "mat_carnauba", "qtd": 5}]','incomum','{"efeito": "Item de Cartógrafo: Caderno Campo (nível 4)"}','f',1,null),
  ('cartografo_item_n6','Cartógrafo',6,'item','Estojo Topográfico','Conhecimento',1,3,65,'[{"mat_id": "mat_vidro_temper", "qtd": 2}]','raro','{"efeito": "Item de Cartógrafo: Estojo Topográfico (nível 6)"}','f',1,null),
  ('cartografo_ferramenta_n5','Cartógrafo',5,'ferramenta','Astrolábio Portátil Est1','Conhecimento',3,5,100,'[{"mat_id": "mat_osso_chefe", "qtd": 1}, {"mat_id": "mat_cristal_branco", "qtd": 4}]','epico','{"bonus": "+12% em atividades de cartógrafo", "estagio1": true}','f',1,null),
  ('cartografo_ferramenta_n5_ref','Cartógrafo',5,'ferramenta','Globo Aincrad Est2','Conhecimento',4,8,170,'[{"mat_id": "mat_runa_vida", "qtd": 1}]','lendario','{"bonus": "+15% em atividades de cartógrafo", "estagio2": true}','t',2,'cartografo_ferramenta_n5')
on conflict (id) do nothing;

-- (4) COMERCIANTE (Conhecimento) · 8 receitas
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, atributo_teste, dificuldade_mod, folego_custo, xp_recompensa, materiais, resultado_raridade, efeitos, receita_refino, receita_estagio, receita_antecessora_id) values
  ('comerciante_ferramenta_n1','Comerciante',1,'ferramenta','Balança Bolso','Conhecimento',0,1,20,'[{"mat_id": "mat_madeira_comum", "qtd": 5}, {"mat_id": "mat_linho_fibra", "qtd": 10}]','comum','{"bonus": "+3% em atividades de comerciante"}','f',1,null),
  ('comerciante_ferramenta_n2','Comerciante',2,'ferramenta','Pergaminho Mercado','Conhecimento',0,2,35,'[{"mat_id": "mat_madeira_nodosa", "qtd": 3}, {"mat_id": "mat_seda_crua", "qtd": 5}]','incomum','{"bonus": "+6% em atividades de comerciante"}','f',1,null),
  ('comerciante_item_n1','Comerciante',1,'item','Nota Promissória','Conhecimento',0,1,12,'[{"mat_id": "mat_carne_ruim", "qtd": 4}, {"mat_id": "mat_lingo_pinho", "qtd": 10}]','comum','{"efeito": "Item de Comerciante: Nota Promissória (nível 1)"}','f',1,null),
  ('comerciante_item_n2','Comerciante',2,'item','Tábua Tarifas','Conhecimento',0,1,18,'[{"mat_id": "mat_cobre_pepita", "qtd": 7}, {"mat_id": "mat_borracha_látex", "qtd": 9}]','comum','{"efeito": "Item de Comerciante: Tábua Tarifas (nível 2)"}','f',1,null),
  ('comerciante_item_n4','Comerciante',4,'item','Bolsa Moedas','Técnica',1,2,45,'[{"mat_id": "mat_pelo_lobo_alfa", "qtd": 5}, {"mat_id": "mat_coral_negro", "qtd": 4}]','incomum','{"efeito": "Item de Comerciante: Bolsa Moedas (nível 4)"}','f',1,null),
  ('comerciante_item_n6','Comerciante',6,'item','Anel Mercador','Técnica',1,3,65,'[{"mat_id": "mat_casco_dourado", "qtd": 1}]','raro','{"efeito": "Item de Comerciante: Anel Mercador (nível 6)"}','f',1,null),
  ('comerciante_ferramenta_n5','Comerciante',5,'ferramenta','Livro Comércio Est1','Conhecimento',3,5,100,'[{"mat_id": "mat_aco_raro", "qtd": 1}, {"mat_id": "mat_essencia_divina", "qtd": 1}]','epico','{"bonus": "+12% em atividades de comerciante", "estagio1": true}','f',1,null),
  ('comerciante_ferramenta_n5_ref','Comerciante',5,'ferramenta','Livro Comércio Est2','Técnica',4,8,170,'[{"mat_id": "mat_aina_crista", "qtd": 1}]','lendario','{"bonus": "+15% em atividades de comerciante", "estagio2": true}','t',2,'comerciante_ferramenta_n5')
on conflict (id) do nothing;

-- (5) COZINHEIRO (Técnica) · 8 receitas
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, atributo_teste, dificuldade_mod, folego_custo, xp_recompensa, materiais, resultado_raridade, efeitos, receita_refino, receita_estagio, receita_antecessora_id) values
  ('cozinheiro_ferramenta_n1','Cozinheiro',1,'ferramenta','Faca Cozinheiro','Técnica',0,1,20,'[{"mat_id": "mat_erva_comum", "qtd": 7}, {"mat_id": "mat_ferro_bruto", "qtd": 9}]','comum','{"bonus": "+3% em atividades de cozinheiro"}','f',1,null),
  ('cozinheiro_ferramenta_n2','Cozinheiro',2,'ferramenta','Panela Ferro','Técnica',0,2,35,'[{"mat_id": "mat_couro_cru", "qtd": 6}, {"mat_id": "mat_fio_aluminio", "qtd": 4}]','incomum','{"bonus": "+6% em atividades de cozinheiro"}','f',1,null),
  ('cozinheiro_item_n1','Cozinheiro',1,'item','Refeição Simples','Técnica',0,1,12,'[{"mat_id": "mat_carvao_pedra", "qtd": 7}, {"mat_id": "mat_palha", "qtd": 6}]','comum','{"efeito": "Item de Cozinheiro: Refeição Simples (nível 1)"}','f',1,null),
  ('cozinheiro_item_n2','Cozinheiro',2,'item','Ervas Secas','Reflexo',0,1,18,'[{"mat_id": "mat_resina_arvore", "qtd": 3}, {"mat_id": "mat_tecido_grosso", "qtd": 4}]','comum','{"efeito": "Item de Cozinheiro: Ervas Secas (nível 2)"}','f',1,null),
  ('cozinheiro_item_n4','Cozinheiro',4,'item','Temperos Nobres','Técnica',1,2,45,'[{"mat_id": "mat_pergaminho_sim", "qtd": 2}, {"mat_id": "mat_latao_po", "qtd": 4}]','incomum','{"efeito": "Item de Cozinheiro: Temperos Nobres (nível 4)"}','f',1,null),
  ('cozinheiro_item_n6','Cozinheiro',6,'item','Fogão Móvel','Corpo',1,3,65,'[{"mat_id": "mat_casca_ancia", "qtd": 3}]','raro','{"efeito": "Item de Cozinheiro: Fogão Móvel (nível 6)"}','f',1,null),
  ('cozinheiro_ferramenta_n5','Cozinheiro',5,'ferramenta','Colher Chefe Est1','Técnica',3,5,100,'[{"mat_id": "mat_nectar_lunar", "qtd": 2}, {"mat_id": "mat_manta_termica", "qtd": 3}]','epico','{"bonus": "+12% em atividades de cozinheiro", "estagio1": true}','f',1,null),
  ('cozinheiro_ferramenta_n5_ref','Cozinheiro',5,'ferramenta','Colher Chefe Est2','Reflexo',4,8,170,'[{"mat_id": "mat_adamantita", "qtd": 1}]','lendario','{"bonus": "+15% em atividades de cozinheiro", "estagio2": true}','t',2,'cozinheiro_ferramenta_n5')
on conflict (id) do nothing;

-- (6) DIPLOMATA (Espírito) · 8 receitas
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, atributo_teste, dificuldade_mod, folego_custo, xp_recompensa, materiais, resultado_raridade, efeitos, receita_refino, receita_estagio, receita_antecessora_id) values
  ('diplomata_ferramenta_n1','Diplomata',1,'ferramenta','Livro Etiquetas','Espírito',0,1,20,'[{"mat_id": "mat_carvao_pedra", "qtd": 7}, {"mat_id": "mat_pedra_lascada", "qtd": 4}]','comum','{"bonus": "+3% em atividades de diplomata"}','f',1,null),
  ('diplomata_ferramenta_n2','Diplomata',2,'ferramenta','Cetro Cerimônia','Espírito',0,2,35,'[{"mat_id": "mat_oleo_animal", "qtd": 6}, {"mat_id": "mat_carne_ruim", "qtd": 9}]','incomum','{"bonus": "+6% em atividades de diplomata"}','f',1,null),
  ('diplomata_item_n1','Diplomata',1,'item','Carta Recomendação','Corpo',0,1,12,'[{"mat_id": "mat_linho_fibra", "qtd": 10}, {"mat_id": "mat_seda_crua", "qtd": 6}]','comum','{"efeito": "Item de Diplomata: Carta Recomendação (nível 1)"}','f',1,null),
  ('diplomata_item_n2','Diplomata',2,'item','Selo Cera','Espírito',0,1,18,'[{"mat_id": "mat_tinta_preta", "qtd": 4}, {"mat_id": "mat_lingo_pinho", "qtd": 7}]','comum','{"efeito": "Item de Diplomata: Selo Cera (nível 2)"}','f',1,null),
  ('diplomata_item_n4','Diplomata',4,'item','Terno Bordado','Espírito',1,2,45,'[{"mat_id": "mat_fio_seda", "qtd": 5}, {"mat_id": "mat_aço_incomum", "qtd": 3}]','incomum','{"efeito": "Item de Diplomata: Terno Bordado (nível 4)"}','f',1,null),
  ('diplomata_item_n6','Diplomata',6,'item','Selo Diplomático','Reflexo',1,3,65,'[{"mat_id": "mat_prata_lamina", "qtd": 3}]','raro','{"efeito": "Item de Diplomata: Selo Diplomático (nível 6)"}','f',1,null),
  ('diplomata_ferramenta_n5','Diplomata',5,'ferramenta','Corrente Escrivão Est1','Espírito',3,5,100,'[{"mat_id": "mat_nucleo_dragao", "qtd": 3}, {"mat_id": "mat_vidro_temper", "qtd": 3}]','epico','{"bonus": "+12% em atividades de diplomata", "estagio1": true}','f',1,null),
  ('diplomata_ferramenta_n5_ref','Diplomata',5,'ferramenta','Trono Portátil Est2','Conhecimento',4,8,170,'[{"mat_id": "mat_runa_vida", "qtd": 1}]','lendario','{"bonus": "+15% em atividades de diplomata", "estagio2": true}','t',2,'diplomata_ferramenta_n5')
on conflict (id) do nothing;

-- (7) BIBLIOTECÁRIO (Conhecimento) · 8 receitas
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, atributo_teste, dificuldade_mod, folego_custo, xp_recompensa, materiais, resultado_raridade, efeitos, receita_refino, receita_estagio, receita_antecessora_id) values
  ('bibliotecario_ferramenta_n1','Bibliotecário',1,'ferramenta','Marcador Página','Conhecimento',0,1,20,'[{"mat_id": "mat_argila", "qtd": 8}, {"mat_id": "mat_madeira_comum", "qtd": 10}]','comum','{"bonus": "+3% em atividades de bibliotecário"}','f',1,null),
  ('bibliotecario_ferramenta_n2','Bibliotecário',2,'ferramenta','Lupa Simples','Conhecimento',0,2,35,'[{"mat_id": "mat_fio_aluminio", "qtd": 7}, {"mat_id": "mat_erva_comum", "qtd": 10}]','incomum','{"bonus": "+6% em atividades de bibliotecário"}','f',1,null),
  ('bibliotecario_item_n1','Bibliotecário',1,'item','Caderno Anotações','Conhecimento',0,1,12,'[{"mat_id": "mat_borracha_látex", "qtd": 10}, {"mat_id": "mat_ferro_bruto", "qtd": 10}]','comum','{"efeito": "Item de Bibliotecário: Caderno Anotações (nível 1)"}','f',1,null),
  ('bibliotecario_item_n2','Bibliotecário',2,'item','Pombo Correio','Conhecimento',0,1,18,'[{"mat_id": "mat_oleo_animal", "qtd": 4}, {"mat_id": "mat_pergaminho_sim", "qtd": 7}]','comum','{"efeito": "Item de Bibliotecário: Pombo Correio (nível 2)"}','f',1,null),
  ('bibliotecario_item_n4','Bibliotecário',4,'item','Grimório Feitiços','Conhecimento',1,2,45,'[{"mat_id": "mat_carnauba", "qtd": 5}, {"mat_id": "mat_pelo_lobo_alfa", "qtd": 2}]','incomum','{"efeito": "Item de Bibliotecário: Grimório Feitiços (nível 4)"}','f',1,null),
  ('bibliotecario_item_n6','Bibliotecário',6,'item','Encadernação Nobre','Conhecimento',1,3,65,'[{"mat_id": "mat_coral_negro", "qtd": 4}]','raro','{"efeito": "Item de Bibliotecário: Encadernação Nobre (nível 6)"}','f',1,null),
  ('bibliotecario_ferramenta_n5','Bibliotecário',5,'ferramenta','Cristal Memória Est1','Conhecimento',3,5,100,'[{"mat_id": "mat_gema_branca", "qtd": 2}, {"mat_id": "mat_aco_raro", "qtd": 2}]','epico','{"bonus": "+12% em atividades de bibliotecário", "estagio1": true}','f',1,null),
  ('bibliotecario_ferramenta_n5_ref','Bibliotecário',5,'ferramenta','Tomo Sabedoria Est2','Corpo',4,8,170,'[{"mat_id": "mat_gema_andar10", "qtd": 1}]','lendario','{"bonus": "+15% em atividades de bibliotecário", "estagio2": true}','t',2,'bibliotecario_ferramenta_n5')
on conflict (id) do nothing;

-- (8) ALQUIMISTA (Técnica) · 8 receitas
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, atributo_teste, dificuldade_mod, folego_custo, xp_recompensa, materiais, resultado_raridade, efeitos, receita_refino, receita_estagio, receita_antecessora_id) values
  ('alquimista_ferramenta_n1','Alquimista',1,'ferramenta','Cadinho Barro','Reflexo',0,1,20,'[{"mat_id": "mat_seda_crua", "qtd": 4}, {"mat_id": "mat_argila", "qtd": 7}]','comum','{"bonus": "+3% em atividades de alquimista"}','f',1,null),
  ('alquimista_ferramenta_n2','Alquimista',2,'ferramenta','Frascos Padronizados','Técnica',0,2,35,'[{"mat_id": "mat_latao_po", "qtd": 3}, {"mat_id": "mat_madeira_nodosa", "qtd": 4}]','incomum','{"bonus": "+6% em atividades de alquimista"}','f',1,null),
  ('alquimista_item_n1','Alquimista',1,'item','Poção Cura Básica','Espírito',0,1,12,'[{"mat_id": "mat_lingo_pinho", "qtd": 5}, {"mat_id": "mat_carvao_pedra", "qtd": 10}]','comum','{"efeito": "Item de Alquimista: Poção Cura Básica (nível 1)"}','f',1,null),
  ('alquimista_item_n2','Alquimista',2,'item','Saco Secagem','Técnica',0,1,18,'[{"mat_id": "mat_resina_arvore", "qtd": 6}, {"mat_id": "mat_couro_cru", "qtd": 4}]','comum','{"efeito": "Item de Alquimista: Saco Secagem (nível 2)"}','f',1,null),
  ('alquimista_item_n4','Alquimista',4,'item','Caldeirão Pequeno','Técnica',1,2,45,'[{"mat_id": "mat_erva_ancestral", "qtd": 3}, {"mat_id": "mat_cristal_branco", "qtd": 2}]','incomum','{"efeito": "Item de Alquimista: Caldeirão Pequeno (nível 4)"}','f',1,null),
  ('alquimista_item_n6','Alquimista',6,'item','Extrato Néctar','Técnica',1,3,65,'[{"mat_id": "mat_olho_sombrio", "qtd": 3}]','raro','{"efeito": "Item de Alquimista: Extrato Néctar (nível 6)"}','f',1,null),
  ('alquimista_ferramenta_n5','Alquimista',5,'ferramenta','Pedra Filosofal Est1','Técnica',3,5,100,'[{"mat_id": "mat_essencia_divina", "qtd": 1}, {"mat_id": "mat_manta_termica", "qtd": 1}]','epico','{"bonus": "+12% em atividades de alquimista", "estagio1": true}','f',1,null),
  ('alquimista_ferramenta_n5_ref','Alquimista',5,'ferramenta','Pedra Filosofal Est2','Técnica',4,8,170,'[{"mat_id": "mat_aina_crista", "qtd": 1}]','lendario','{"bonus": "+15% em atividades de alquimista", "estagio2": true}','t',2,'alquimista_ferramenta_n5')
on conflict (id) do nothing;

-- (9) COSTUREIRO (Técnica) · 8 receitas
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, atributo_teste, dificuldade_mod, folego_custo, xp_recompensa, materiais, resultado_raridade, efeitos, receita_refino, receita_estagio, receita_antecessora_id) values
  ('costureiro_ferramenta_n1','Costureiro',1,'ferramenta','Agulha Aço','Técnica',0,1,20,'[{"mat_id": "mat_pedra_lascada", "qtd": 4}, {"mat_id": "mat_borracha_látex", "qtd": 6}]','comum','{"bonus": "+3% em atividades de costureiro"}','f',1,null),
  ('costureiro_ferramenta_n2','Costureiro',2,'ferramenta','Máquina Costura','Técnica',0,2,35,'[{"mat_id": "mat_cobre_pepita", "qtd": 4}, {"mat_id": "mat_tecido_grosso", "qtd": 7}]','incomum','{"bonus": "+6% em atividades de costureiro"}','f',1,null),
  ('costureiro_item_n1','Costureiro',1,'item','Roupa Comum','Técnica',0,1,12,'[{"mat_id": "mat_linho_fibra", "qtd": 7}, {"mat_id": "mat_erva_comum", "qtd": 5}]','comum','{"efeito": "Item de Costureiro: Roupa Comum (nível 1)"}','f',1,null),
  ('costureiro_item_n2','Costureiro',2,'item','Saco Dormir','Técnica',0,1,18,'[{"mat_id": "mat_resina_arvore", "qtd": 6}, {"mat_id": "mat_couro_cru", "qtd": 5}]','comum','{"efeito": "Item de Costureiro: Saco Dormir (nível 2)"}','f',1,null),
  ('costureiro_item_n4','Costureiro',4,'item','Túnica Resistida','Técnica',1,2,45,'[{"mat_id": "mat_cristal_branco", "qtd": 2}, {"mat_id": "mat_vidro_temper", "qtd": 5}]','incomum','{"efeito": "Item de Costureiro: Túnica Resistida (nível 4)"}','f',1,null),
  ('costureiro_item_n6','Costureiro',6,'item','Capa Tecido Mágico','Técnica',1,3,65,'[{"mat_id": "mat_nucleo_prata", "qtd": 3}]','raro','{"efeito": "Item de Costureiro: Capa Tecido Mágico (nível 6)"}','f',1,null),
  ('costureiro_ferramenta_n5','Costureiro',5,'ferramenta','Tear Mágico Est1','Técnica',3,5,100,'[{"mat_id": "mat_ouro_folha", "qtd": 2}, {"mat_id": "mat_casco_dourado", "qtd": 1}]','epico','{"bonus": "+12% em atividades de costureiro", "estagio1": true}','f',1,null),
  ('costureiro_ferramenta_n5_ref','Costureiro',5,'ferramenta','Agulha Deuses Est2','Técnica',4,8,170,'[{"mat_id": "mat_fio_destino", "qtd": 1}]','lendario','{"bonus": "+15% em atividades de costureiro", "estagio2": true}','t',2,'costureiro_ferramenta_n5')
on conflict (id) do nothing;

-- (10) DOMADOR (Técnica) · 8 receitas
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, atributo_teste, dificuldade_mod, folego_custo, xp_recompensa, materiais, resultado_raridade, efeitos, receita_refino, receita_estagio, receita_antecessora_id) values
  ('domador_ferramenta_n1','Domador',1,'ferramenta','Incubadora Pequena','Técnica',0,1,20,'[{"mat_id": "mat_carne_ruim", "qtd": 6}, {"mat_id": "mat_ferro_bruto", "qtd": 9}]','comum','{"bonus": "+3% em atividades de domador"}','f',1,null),
  ('domador_ferramenta_n2','Domador',2,'ferramenta','Incubadora Média','Técnica',0,2,35,'[{"mat_id": "mat_latao_po", "qtd": 7}, {"mat_id": "mat_fio_aluminio", "qtd": 3}]','incomum','{"bonus": "+6% em atividades de domador"}','f',1,null),
  ('domador_item_n1','Domador',1,'item','Laço Captura','Técnica',0,1,12,'[{"mat_id": "mat_palha", "qtd": 9}, {"mat_id": "mat_madeira_comum", "qtd": 9}]','comum','{"efeito": "Item de Domador: Laço Captura (nível 1)"}','f',1,null),
  ('domador_item_n2','Domador',2,'item','Comedouro Fera','Técnica',0,1,18,'[{"mat_id": "mat_oleo_animal", "qtd": 3}, {"mat_id": "mat_cobre_pepita", "qtd": 7}]','comum','{"efeito": "Item de Domador: Comedouro Fera (nível 2)"}','f',1,null),
  ('domador_item_n4','Domador',4,'item','Coleira Épica','Técnica',1,2,45,'[{"mat_id": "mat_pelo_lobo_alfa", "qtd": 3}, {"mat_id": "mat_erva_ancestral", "qtd": 4}]','incomum','{"efeito": "Item de Domador: Coleira Épica (nível 4)"}','f',1,null),
  ('domador_item_n6','Domador',6,'item','Incubadora Raridade','Conhecimento',1,3,65,'[{"mat_id": "mat_osso_chefe", "qtd": 1}]','raro','{"efeito": "Item de Domador: Incubadora Raridade (nível 6)"}','f',1,null),
  ('domador_ferramenta_n5','Domador',5,'ferramenta','Incubadora Sagrada Est1','Espírito',3,5,100,'[{"mat_id": "mat_nectar_lunar", "qtd": 2}, {"mat_id": "mat_casca_ancia", "qtd": 1}]','epico','{"bonus": "+12% em atividades de domador", "estagio1": true}','f',1,null),
  ('domador_ferramenta_n5_ref','Domador',5,'ferramenta','Incubadora Primordial Est2','Técnica',4,8,170,'[{"mat_id": "mat_adamantita", "qtd": 1}]','lendario','{"bonus": "+15% em atividades de domador", "estagio2": true}','t',2,'domador_ferramenta_n5')
on conflict (id) do nothing;

-- (11) FERREIRO (Corpo) · 8 receitas
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, atributo_teste, dificuldade_mod, folego_custo, xp_recompensa, materiais, resultado_raridade, efeitos, receita_refino, receita_estagio, receita_antecessora_id) values
  ('ferreiro_ferramenta_n1','Ferreiro',1,'ferramenta','Martelo Ferreiro','Corpo',0,1,20,'[{"mat_id": "mat_lingo_pinho", "qtd": 4}, {"mat_id": "mat_erva_comum", "qtd": 6}]','comum','{"bonus": "+3% em atividades de ferreiro"}','f',1,null),
  ('ferreiro_ferramenta_n2','Ferreiro',2,'ferramenta','Bigorna Portátil','Corpo',0,2,35,'[{"mat_id": "mat_tinta_preta", "qtd": 5}, {"mat_id": "mat_tecido_grosso", "qtd": 3}]','incomum','{"bonus": "+6% em atividades de ferreiro"}','f',1,null),
  ('ferreiro_item_n1','Ferreiro',1,'item','Rebites','Reflexo',0,1,12,'[{"mat_id": "mat_argila", "qtd": 9}, {"mat_id": "mat_carne_ruim", "qtd": 10}]','comum','{"efeito": "Item de Ferreiro: Rebites (nível 1)"}','f',1,null),
  ('ferreiro_item_n2','Ferreiro',2,'item','Fole Simples','Corpo',0,1,18,'[{"mat_id": "mat_madeira_nodosa", "qtd": 5}, {"mat_id": "mat_pergaminho_sim", "qtd": 6}]','comum','{"efeito": "Item de Ferreiro: Fole Simples (nível 2)"}','f',1,null),
  ('ferreiro_item_n4','Ferreiro',4,'item','Lâmina Bronze','Corpo',1,2,45,'[{"mat_id": "mat_carnauba", "qtd": 4}, {"mat_id": "mat_fio_seda", "qtd": 3}]','incomum','{"efeito": "Item de Ferreiro: Lâmina Bronze (nível 4)"}','f',1,null),
  ('ferreiro_item_n6','Ferreiro',6,'item','Fole Duplo','Corpo',1,3,65,'[{"mat_id": "mat_nucleo_prata", "qtd": 2}]','raro','{"efeito": "Item de Ferreiro: Fole Duplo (nível 6)"}','f',1,null),
  ('ferreiro_ferramenta_n5','Ferreiro',5,'ferramenta','Fornalha Vulcão Est1','Corpo',3,5,100,'[{"mat_id": "mat_nectar_lunar", "qtd": 3}, {"mat_id": "mat_aco_raro", "qtd": 1}]','epico','{"bonus": "+12% em atividades de ferreiro", "estagio1": true}','f',1,null),
  ('ferreiro_ferramenta_n5_ref','Ferreiro',5,'ferramenta','Fornalha Vulcão Est2','Corpo',4,8,170,'[{"mat_id": "mat_runa_vida", "qtd": 1}]','lendario','{"bonus": "+15% em atividades de ferreiro", "estagio2": true}','t',2,'ferreiro_ferramenta_n5')
on conflict (id) do nothing;

-- (12) JOALHEIRO (Técnica) · 8 receitas
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, atributo_teste, dificuldade_mod, folego_custo, xp_recompensa, materiais, resultado_raridade, efeitos, receita_refino, receita_estagio, receita_antecessora_id) values
  ('joalheiro_ferramenta_n1','Joalheiro',1,'ferramenta','Lixa Simples','Técnica',0,1,20,'[{"mat_id": "mat_linho_fibra", "qtd": 6}, {"mat_id": "mat_palha", "qtd": 4}]','comum','{"bonus": "+3% em atividades de joalheiro"}','f',1,null),
  ('joalheiro_ferramenta_n2','Joalheiro',2,'ferramenta','Alicate Ourives','Conhecimento',0,2,35,'[{"mat_id": "mat_madeira_nodosa", "qtd": 6}, {"mat_id": "mat_tecido_grosso", "qtd": 5}]','incomum','{"bonus": "+6% em atividades de joalheiro"}','f',1,null),
  ('joalheiro_item_n1','Joalheiro',1,'item','Pingente Simples','Conhecimento',0,1,12,'[{"mat_id": "mat_seda_crua", "qtd": 4}, {"mat_id": "mat_borracha_látex", "qtd": 5}]','comum','{"efeito": "Item de Joalheiro: Pingente Simples (nível 1)"}','f',1,null),
  ('joalheiro_item_n2','Joalheiro',2,'item','Anel Prata','Corpo',0,1,18,'[{"mat_id": "mat_carvao_pedra", "qtd": 4}, {"mat_id": "mat_cobre_pepita", "qtd": 2}]','comum','{"efeito": "Item de Joalheiro: Anel Prata (nível 2)"}','f',1,null),
  ('joalheiro_item_n4','Joalheiro',4,'item','Bracelete Bronze','Técnica',1,2,45,'[{"mat_id": "mat_coral_negro", "qtd": 2}, {"mat_id": "mat_aço_incomum", "qtd": 3}]','incomum','{"efeito": "Item de Joalheiro: Bracelete Bronze (nível 4)"}','f',1,null),
  ('joalheiro_item_n6','Joalheiro',6,'item','Anel Gema Branca','Técnica',1,3,65,'[{"mat_id": "mat_manta_termica", "qtd": 2}]','raro','{"efeito": "Item de Joalheiro: Anel Gema Branca (nível 6)"}','f',1,null),
  ('joalheiro_ferramenta_n5','Joalheiro',5,'ferramenta','Mesa Ourives Est1','Técnica',3,5,100,'[{"mat_id": "mat_prata_lamina", "qtd": 3}, {"mat_id": "mat_nucleo_dragao", "qtd": 3}]','epico','{"bonus": "+12% em atividades de joalheiro", "estagio1": true}','f',1,null),
  ('joalheiro_ferramenta_n5_ref','Joalheiro',5,'ferramenta','Gema Criação Est2','Técnica',4,8,170,'[{"mat_id": "mat_aina_crista", "qtd": 1}]','lendario','{"bonus": "+15% em atividades de joalheiro", "estagio2": true}','t',2,'joalheiro_ferramenta_n5')
on conflict (id) do nothing;

-- (13) COVEIRO (Espírito) · 8 receitas
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, atributo_teste, dificuldade_mod, folego_custo, xp_recompensa, materiais, resultado_raridade, efeitos, receita_refino, receita_estagio, receita_antecessora_id) values
  ('coveiro_ferramenta_n1','Coveiro',1,'ferramenta','Pá Simples','Espírito',0,1,20,'[{"mat_id": "mat_madeira_comum", "qtd": 7}, {"mat_id": "mat_pedra_lascada", "qtd": 5}]','comum','{"bonus": "+3% em atividades de coveiro"}','f',1,null),
  ('coveiro_ferramenta_n2','Coveiro',2,'ferramenta','Lanterna Luto','Espírito',0,2,35,'[{"mat_id": "mat_pergaminho_sim", "qtd": 4}, {"mat_id": "mat_oleo_animal", "qtd": 5}]','incomum','{"bonus": "+6% em atividades de coveiro"}','f',1,null),
  ('coveiro_item_n1','Coveiro',1,'item','Caixão Madeira','Espírito',0,1,12,'[{"mat_id": "mat_ferro_bruto", "qtd": 5}, {"mat_id": "mat_palha", "qtd": 8}]','comum','{"efeito": "Item de Coveiro: Caixão Madeira (nível 1)"}','f',1,null),
  ('coveiro_item_n2','Coveiro',2,'item','Incenso Purificador','Técnica',0,1,18,'[{"mat_id": "mat_couro_cru", "qtd": 7}, {"mat_id": "mat_latao_po", "qtd": 6}]','comum','{"efeito": "Item de Coveiro: Incenso Purificador (nível 2)"}','f',1,null),
  ('coveiro_item_n4','Coveiro',4,'item','Livro Mortos Cópia','Espírito',1,2,45,'[{"mat_id": "mat_carnauba", "qtd": 5}, {"mat_id": "mat_aço_incomum", "qtd": 3}]','incomum','{"efeito": "Item de Coveiro: Livro Mortos Cópia (nível 4)"}','f',1,null),
  ('coveiro_item_n6','Coveiro',6,'item','Incensário Purificação','Espírito',1,3,65,'[{"mat_id": "mat_casco_dourado", "qtd": 1}]','raro','{"efeito": "Item de Coveiro: Incensário Purificação (nível 6)"}','f',1,null),
  ('coveiro_ferramenta_n5','Coveiro',5,'ferramenta','Foice São Juízo Est1','Espírito',3,5,100,'[{"mat_id": "mat_gema_branca", "qtd": 3}, {"mat_id": "mat_casca_ancia", "qtd": 2}]','epico','{"bonus": "+12% em atividades de coveiro", "estagio1": true}','f',1,null),
  ('coveiro_ferramenta_n5_ref','Coveiro',5,'ferramenta','Foice São Juízo Est2','Espírito',4,8,170,'[{"mat_id": "mat_fio_destino", "qtd": 1}]','lendario','{"bonus": "+15% em atividades de coveiro", "estagio2": true}','t',2,'coveiro_ferramenta_n5')
on conflict (id) do nothing;

-- (14) MÉDICO (Espírito) · 8 receitas
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, atributo_teste, dificuldade_mod, folego_custo, xp_recompensa, materiais, resultado_raridade, efeitos, receita_refino, receita_estagio, receita_antecessora_id) values
  ('medico_ferramenta_n1','Médico',1,'ferramenta','Estojo Curativos','Espírito',0,1,20,'[{"mat_id": "mat_lingo_pinho", "qtd": 7}, {"mat_id": "mat_seda_crua", "qtd": 8}]','comum','{"bonus": "+3% em atividades de médico"}','f',1,null),
  ('medico_ferramenta_n2','Médico',2,'ferramenta','Frasco Antisséptico','Espírito',0,2,35,'[{"mat_id": "mat_fio_aluminio", "qtd": 7}, {"mat_id": "mat_tinta_preta", "qtd": 7}]','incomum','{"bonus": "+6% em atividades de médico"}','f',1,null),
  ('medico_item_n1','Médico',1,'item','Ataduras','Espírito',0,1,12,'[{"mat_id": "mat_argila", "qtd": 6}, {"mat_id": "mat_madeira_comum", "qtd": 8}]','comum','{"efeito": "Item de Médico: Ataduras (nível 1)"}','f',1,null),
  ('medico_item_n2','Médico',2,'item','Soro Hidratação','Espírito',0,1,18,'[{"mat_id": "mat_resina_arvore", "qtd": 6}, {"mat_id": "mat_pedra_lascada", "qtd": 8}]','comum','{"efeito": "Item de Médico: Soro Hidratação (nível 2)"}','f',1,null),
  ('medico_item_n4','Médico',4,'item','Kit Cirúrgico','Espírito',1,2,45,'[{"mat_id": "mat_vidro_temper", "qtd": 5}, {"mat_id": "mat_prata_lamina", "qtd": 5}]','incomum','{"efeito": "Item de Médico: Kit Cirúrgico (nível 4)"}','f',1,null),
  ('medico_item_n6','Médico',6,'item','Seringa Platina','Espírito',1,3,65,'[{"mat_id": "mat_ouro_folha", "qtd": 3}]','raro','{"efeito": "Item de Médico: Seringa Platina (nível 6)"}','f',1,null),
  ('medico_ferramenta_n5','Médico',5,'ferramenta','Báculo Vida Est1','Técnica',3,5,100,'[{"mat_id": "mat_olho_sombrio", "qtd": 1}, {"mat_id": "mat_essencia_divina", "qtd": 2}]','epico','{"bonus": "+12% em atividades de médico", "estagio1": true}','f',1,null),
  ('medico_ferramenta_n5_ref','Médico',5,'ferramenta','Báculo Vida Est2','Espírito',4,8,170,'[{"mat_id": "mat_adamantita", "qtd": 1}]','lendario','{"bonus": "+15% em atividades de médico", "estagio2": true}','t',2,'medico_ferramenta_n5')
on conflict (id) do nothing;

-- (15) MÚSICO (Espírito) · 8 receitas
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, atributo_teste, dificuldade_mod, folego_custo, xp_recompensa, materiais, resultado_raridade, efeitos, receita_refino, receita_estagio, receita_antecessora_id) values
  ('musico_ferramenta_n1','Músico',1,'ferramenta','Afinador Simples','Espírito',0,1,20,'[{"mat_id": "mat_linho_fibra", "qtd": 7}, {"mat_id": "mat_borracha_látex", "qtd": 4}]','comum','{"bonus": "+3% em atividades de músico"}','f',1,null),
  ('musico_ferramenta_n2','Músico',2,'ferramenta','Pauta Partitura','Espírito',0,2,35,'[{"mat_id": "mat_latao_po", "qtd": 6}, {"mat_id": "mat_carvao_pedra", "qtd": 4}]','incomum','{"bonus": "+6% em atividades de músico"}','f',1,null),
  ('musico_item_n1','Músico',1,'item','Flauta Madeira','Espírito',0,1,12,'[{"mat_id": "mat_erva_comum", "qtd": 8}, {"mat_id": "mat_ferro_bruto", "qtd": 5}]','comum','{"efeito": "Item de Músico: Flauta Madeira (nível 1)"}','f',1,null),
  ('musico_item_n2','Músico',2,'item','Tambor Pequeno','Conhecimento',0,1,18,'[{"mat_id": "mat_madeira_nodosa", "qtd": 3}, {"mat_id": "mat_tecido_grosso", "qtd": 5}]','comum','{"efeito": "Item de Músico: Tambor Pequeno (nível 2)"}','f',1,null),
  ('musico_item_n4','Músico',4,'item','Harpa Mística','Espírito',1,2,45,'[{"mat_id": "mat_erva_ancestral", "qtd": 2}, {"mat_id": "mat_fio_seda", "qtd": 3}]','incomum','{"efeito": "Item de Músico: Harpa Mística (nível 4)"}','f',1,null),
  ('musico_item_n6','Músico',6,'item','Amplificador Acústico','Espírito',1,3,65,'[{"mat_id": "mat_osso_chefe", "qtd": 2}]','raro','{"efeito": "Item de Músico: Amplificador Acústico (nível 6)"}','f',1,null),
  ('musico_ferramenta_n5','Músico',5,'ferramenta','Harpa Coral Est1','Espírito',3,5,100,'[{"mat_id": "mat_gema_branca", "qtd": 1}, {"mat_id": "mat_nucleo_prata", "qtd": 1}]','epico','{"bonus": "+12% em atividades de músico", "estagio1": true}','f',1,null),
  ('musico_ferramenta_n5_ref','Músico',5,'ferramenta','Lira Orfeu Est2','Espírito',4,8,170,'[{"mat_id": "mat_gema_andar10", "qtd": 1}]','lendario','{"bonus": "+15% em atividades de músico", "estagio2": true}','t',2,'musico_ferramenta_n5')
on conflict (id) do nothing;

-- (16) MERCENÁRIO (Corpo) · 8 receitas
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, atributo_teste, dificuldade_mod, folego_custo, xp_recompensa, materiais, resultado_raridade, efeitos, receita_refino, receita_estagio, receita_antecessora_id) values
  ('mercenario_ferramenta_n1','Mercenário',1,'ferramenta','Chave Punho','Corpo',0,1,20,'[{"mat_id": "mat_carne_ruim", "qtd": 10}, {"mat_id": "mat_seda_crua", "qtd": 9}]','comum','{"bonus": "+3% em atividades de mercenário"}','f',1,null),
  ('mercenario_ferramenta_n2','Mercenário',2,'ferramenta','Colete Treino','Corpo',0,2,35,'[{"mat_id": "mat_oleo_animal", "qtd": 4}, {"mat_id": "mat_tinta_preta", "qtd": 4}]','incomum','{"bonus": "+6% em atividades de mercenário"}','f',1,null),
  ('mercenario_item_n1','Mercenário',1,'item','Cantil','Corpo',0,1,12,'[{"mat_id": "mat_carvao_pedra", "qtd": 7}, {"mat_id": "mat_madeira_comum", "qtd": 7}]','comum','{"efeito": "Item de Mercenário: Cantil (nível 1)"}','f',1,null),
  ('mercenario_item_n2','Mercenário',2,'item','Barraca Tenda','Corpo',0,1,18,'[{"mat_id": "mat_couro_cru", "qtd": 5}, {"mat_id": "mat_fio_aluminio", "qtd": 7}]','comum','{"efeito": "Item de Mercenário: Barraca Tenda (nível 2)"}','f',1,null),
  ('mercenario_item_n4','Mercenário',4,'item','Kit Sobrevivência','Corpo',1,2,45,'[{"mat_id": "mat_pelo_lobo_alfa", "qtd": 4}, {"mat_id": "mat_cristal_branco", "qtd": 4}]','incomum','{"efeito": "Item de Mercenário: Kit Sobrevivência (nível 4)"}','f',1,null),
  ('mercenario_item_n6','Mercenário',6,'item','Escudo Combate','Corpo',1,3,65,'[{"mat_id": "mat_olho_sombrio", "qtd": 2}]','raro','{"efeito": "Item de Mercenário: Escudo Combate (nível 6)"}','f',1,null),
  ('mercenario_ferramenta_n5','Mercenário',5,'ferramenta','Armadura Gladiador Est1','Corpo',3,5,100,'[{"mat_id": "mat_manta_termica", "qtd": 1}, {"mat_id": "mat_casca_ancia", "qtd": 3}]','epico','{"bonus": "+12% em atividades de mercenário", "estagio1": true}','f',1,null),
  ('mercenario_ferramenta_n5_ref','Mercenário',5,'ferramenta','Armadura Gladiador Est2','Corpo',4,8,170,'[{"mat_id": "mat_runa_vida", "qtd": 1}]','lendario','{"bonus": "+15% em atividades de mercenário", "estagio2": true}','t',2,'mercenario_ferramenta_n5')
on conflict (id) do nothing;

-- ========== RLS CATÁLOGOS DE CRAFT (materiais_basicos, receitas, ovos_catalogo) ==========
-- Mesmo padrão das outras tabelas de catálogo: público lê (visivel=true, excluido=false),
-- mestre pode escrever tudo.
do $$
declare t text;
begin
  foreach t in array array['materiais_basicos','receitas','ovos_catalogo']
  loop
    execute format('alter table %I enable row level security', t);
    execute format('drop policy if exists "select_publico_ou_mestre" on %I', t);
    execute format(
      'create policy "select_publico_ou_mestre" on %I for select using ' ||
      '((visivel = true and excluido = false) or is_mestre())', t);
    execute format('drop policy if exists "escrita_mestre" on %I', t);
    execute format(
      'create policy "escrita_mestre" on %I for all using (is_mestre()) with check (is_mestre())', t);
  end loop;
end $$;

-- ========== RPC #1: craftar_item (receitas.tipo = 'item') ==========
-- Transação única: valida nível receita, consome materiais do inventário, gasta fôlego,
-- rola 2d6 + atributo PBTA (mod por diferença de nível), consome % materiais em falha/parcial,
-- adiciona item craftado no inventário, sobe nível profissão, log transação.
create or replace function craftar_item(p_receita_id text)
returns text language plpgsql security definer set search_path = public as $$
declare
  v_personagem text;
  v_prof text;
  v_nivel int;
  v_xp_atual int;
  v_rec receitas%rowtype;
  v_mats jsonb;
  v_mat_elem jsonb;
  v_mat_id text;
  v_mat_qtd int;
  v_tem int;
  v_inv_id bigint;
  v_dados int[];
  v_soma int;
  v_mod int;
  v_dif int;
  v_resultado text;
  v_xp_ganho int;
  v_folego_gasto int;
  v_perda_mat numeric;
  v_consumiu int;
  v_ja_consumidos text[];
  v_novo_nivel int;
  v_novo_item_inv_id bigint;
  v_resp jsonb;
  v_materiais_usados jsonb[];
  v_ferramenta_danificada boolean := false;
begin
  select nome, profissao into v_personagem, v_prof from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  select * into v_rec from receitas where id = p_receita_id and visivel=true and excluido=false;
  if not found then return '{"erro":"receita invalida"}'; end if;
  if v_rec.tipo <> 'item' then return '{"erro":"use craftar_ferramenta para ferramentas"}'; end if;

  select nivel, xp into v_nivel, v_xp_atual
    from nivel_profissao where personagem_nome = v_personagem and profissao = v_rec.profissao;
  if v_nivel is null then v_nivel := 1; v_xp_atual := 0; end if;

  if v_nivel < v_rec.nivel_receita then
    return format('{"erro":"nivel profissao %s necessita %s (voce=%s)"}', v_rec.profissao, v_rec.nivel_receita, v_nivel);
  end if;

  if not exists (select 1 from personagens where nome = v_personagem and folego >= v_rec.folego_custo) then
    return format('{"erro":"folego insuficiente: precisa %s"}', v_rec.folego_custo);
  end if;

  -- PASSO 1: verificar TODOS os materiais necessários ANTES de consumir
  v_mats := v_rec.materiais;
  for v_mat_elem in select * from jsonb_array_elements(v_mats) loop
    v_mat_id := v_mat_elem->>'mat_id';
    v_mat_qtd := (v_mat_elem->>'qtd')::int;
    select coalesce(sum(quantidade),0) into v_tem
      from inventario where personagem_nome = v_personagem
        and tipo='material' and item_id = v_mat_id and not excluido;
    if v_tem < v_mat_qtd then
      return format('{"erro":"material %s faltando: tem %s precisa %s"}', v_mat_id, v_tem, v_mat_qtd);
    end if;
  end loop;

  -- PASSO 2: gastar fôlego
  update personagens set folego = folego - v_rec.folego_custo, updated_at = now()
    where nome = v_personagem;
  v_folego_gasto := v_rec.folego_custo;

  -- PASSO 3: calcular modificador PBTA (diferença nível personagem vs nível receita)
  -- + bônus de ferramenta de ofício se equipada
  v_dif := v_nivel - v_rec.nivel_receita;
  v_mod := case
    when v_dif >= 2 then 3
    when v_dif = 1  then 1
    when v_dif = 0  then 0
    when v_dif = -1 then -1
    else -3
  end + coalesce(v_rec.dificuldade_mod, 0);

  -- PASSO 4: rolar 2d6
  v_dados := array[(1 + floor(random()*6))::int, (1 + floor(random()*6))::int];
  v_soma := v_dados[1] + v_dados[2] + v_mod;

  -- PASSO 5: aplicar resultado PBTA
  if v_soma >= 10 then
    v_resultado := 'sucesso_total';
    v_xp_ganho := v_rec.xp_recompensa;
    v_perda_mat := 0.0;
  elsif v_soma >= 7 then
    v_resultado := 'sucesso_parcial';
    v_xp_ganho := (v_rec.xp_recompensa * 0.7)::int;
    v_perda_mat := 0.2;
    if random() < 0.08 then v_ferramenta_danificada := true; end if;
  else
    v_resultado := 'falha';
    v_xp_ganho := (v_rec.xp_recompensa * 0.1)::int;
    v_perda_mat := 0.5;
    if random() < 0.2 then v_ferramenta_danificada := true; end if;
  end if;

  -- PASSO 6: consumir materiais (100% em sucesso; (1+perda)% em parcial/falha;
  --          arredonda pra cima: "mais risco = mais desperdício")
  v_materiais_usados := array[]::jsonb[];
  v_ja_consumidos := array[]::text[];
  for v_mat_elem in select * from jsonb_array_elements(v_mats) loop
    v_mat_id := v_mat_elem->>'mat_id';
    if v_mat_id = any(v_ja_consumidos) then continue; end if;
    v_ja_consumidos := array_append(v_ja_consumidos, v_mat_id);

    -- soma qtd total necessária DAS VEZES que esse material aparece
    v_mat_qtd := 0;
    for v_mat_elem in select * from jsonb_array_elements(v_mats) loop
      if v_mat_elem->>'mat_id' = v_mat_id then
        v_mat_qtd := v_mat_qtd + (v_mat_elem->>'qtd')::int;
      end if;
    end loop;

    if v_resultado = 'sucesso_total' then
      v_consumiu := v_mat_qtd;
    else
      v_consumiu := ceil(v_mat_qtd * (1.0 + v_perda_mat))::int;
    end if;

    -- consome por ordem de inventário (menores IDs primeiro)
    declare
      v_restante int := v_consumiu;
      v_cur cursor for select id, quantidade from inventario
        where personagem_nome = v_personagem and tipo='material' and item_id = v_mat_id
          and not excluido order by id for update;
      v_linha record;
      v_tirar int;
    begin
      open v_cur;
      loop
        fetch v_cur into v_linha;
        exit when not found or v_restante <= 0;
        v_tirar := least(v_linha.quantidade, v_restante);
        if v_tirar = v_linha.quantidade then
          update inventario set excluido = true where id = v_linha.id;
        else
          update inventario set quantidade = quantidade - v_tirar where id = v_linha.id;
        end if;
        v_restante := v_restante - v_tirar;
      end loop;
      close v_cur;
    end;

    v_materiais_usados := array_append(v_materiais_usados,
      jsonb_build_object('mat_id', v_mat_id, 'qtd_usada', v_consumiu));
  end loop;

  -- PASSO 7: sucesso/parcial = item vai pro inventário
  v_novo_item_inv_id := null;
  if v_resultado <> 'falha' then
    insert into inventario
      (personagem_nome, item_id, nome, tipo, quantidade, origem)
      values (v_personagem, v_rec.id, v_rec.nome_resultado, 'consumivel', 1, 'craft')
      returning id into v_novo_item_inv_id;
  end if;

  -- PASSO 8: XP + subir nível profissão
  v_novo_nivel := null;
  if v_xp_ganho > 0 then
    declare
      v_xp_novo int;
      v_prox_xp int;
      v_subiu boolean;
    begin
      if not exists (select 1 from nivel_profissao
                      where personagem_nome = v_personagem and profissao = v_rec.profissao) then
        insert into nivel_profissao (personagem_nome, profissao, nivel, xp)
          values (v_personagem, v_rec.profissao, 1, 0);
      end if;
      update nivel_profissao
         set xp = xp + v_xp_ganho, updated_at = now()
       where personagem_nome = v_personagem and profissao = v_rec.profissao
       returning xp into v_xp_novo;

      <<sobe>> loop
        v_subiu := false;
        select nivel into v_nivel from nivel_profissao
          where personagem_nome = v_personagem and profissao = v_rec.profissao;
        select xp_necessario into v_prox_xp from nivel_profissao_xp
          where nivel = v_nivel + 1;
        exit sobe when v_prox_xp is null;
        if v_xp_novo >= v_prox_xp then
          update nivel_profissao
             set nivel = nivel + 1, xp = xp - v_prox_xp, updated_at = now()
           where personagem_nome = v_personagem and profissao = v_rec.profissao
           returning xp into v_xp_novo;
          v_subiu := true;
          v_novo_nivel := coalesce(v_novo_nivel, v_nivel + 1);
        end if;
        exit sobe when not v_subiu;
      end loop sobe;
    end;
  end if;

  -- PASSO 9: log transação
  insert into transacoes (de_personagem, para_personagem, tipo, valor, item_id, observacao)
    values (null, v_personagem, 'craft', 0, v_rec.id,
            format('craft_item %s %s (xp=%s soma=%s)', v_rec.id, v_resultado, v_xp_ganho, v_soma));

  v_resp := jsonb_build_object(
    'resultado', v_resultado,
    'dados', v_dados,
    'soma_com_mod', v_soma,
    'mod_pbta', v_mod,
    'xp', v_xp_ganho,
    'folego_gasto', v_folego_gasto,
    'materiais_consumidos', to_jsonb(v_materiais_usados),
    'item_inventario_id', v_novo_item_inv_id,
    'item_nome', v_rec.nome_resultado,
    'item_raridade', v_rec.resultado_raridade,
    'novo_nivel_profissao', v_novo_nivel,
    'ferramenta_danificada', v_ferramenta_danificada,
    'efeitos', v_rec.efeitos
  );
  return v_resp::text;
end $$;
grant execute on function craftar_item(text) to authenticated;

-- ========== RPC #2: craftar_ferramenta (receitas.tipo = 'ferramenta') ==========
-- Mesmo fluxo de craftar_item mas resultado vai pra personagem_ferramentas (upsert).
-- Ferramenta_n5_ref (estágio 2) EXIGE que estágio 1 já esteja equipado.
create or replace function craftar_ferramenta(p_receita_id text)
returns text language plpgsql security definer set search_path = public as $$
declare
  v_personagem text;
  v_nivel int;
  v_xp_atual int;
  v_rec receitas%rowtype;
  v_mats jsonb;
  v_mat_elem jsonb;
  v_mat_id text;
  v_mat_qtd int;
  v_tem int;
  v_dados int[];
  v_soma int;
  v_mod int;
  v_dif int;
  v_resultado text;
  v_xp_ganho int;
  v_folego_gasto int;
  v_perda_mat numeric;
  v_consumiu int;
  v_ja_consumidos text[];
  v_novo_nivel int;
  v_resp jsonb;
  v_materiais_usados jsonb[];
  v_ferramenta_danificada boolean := false;
begin
  select nome into v_personagem from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  select * into v_rec from receitas where id = p_receita_id and visivel=true and excluido=false;
  if not found then return '{"erro":"receita invalida"}'; end if;
  if v_rec.tipo <> 'ferramenta' then return '{"erro":"use craftar_item para itens"}'; end if;

  -- se for estágio 2 de refino, precisa ter o estágio 1 já craftado
  if v_rec.receita_refino and v_rec.receita_estagio = 2 then
    if v_rec.receita_antecessora_id is not null then
      if not exists (select 1 from personagem_ferramentas
                      where personagem_nome = v_personagem
                        and ferramenta_id = v_rec.receita_antecessora_id) then
        return format('{"erro":"precisa craftar %s (estagio 1) antes"}', v_rec.receita_antecessora_id);
      end if;
    end if;
  end if;

  select nivel, xp into v_nivel, v_xp_atual
    from nivel_profissao where personagem_nome = v_personagem and profissao = v_rec.profissao;
  if v_nivel is null then v_nivel := 1; v_xp_atual := 0; end if;

  if v_nivel < v_rec.nivel_receita then
    return format('{"erro":"nivel profissao %s necessita %s (voce=%s)"}', v_rec.profissao, v_rec.nivel_receita, v_nivel);
  end if;

  if not exists (select 1 from personagens where nome = v_personagem and folego >= v_rec.folego_custo) then
    return format('{"erro":"folego insuficiente: precisa %s"}', v_rec.folego_custo);
  end if;

  v_mats := v_rec.materiais;
  for v_mat_elem in select * from jsonb_array_elements(v_mats) loop
    v_mat_id := v_mat_elem->>'mat_id';
    v_mat_qtd := (v_mat_elem->>'qtd')::int;
    select coalesce(sum(quantidade),0) into v_tem
      from inventario where personagem_nome = v_personagem
        and tipo='material' and item_id = v_mat_id and not excluido;
    if v_tem < v_mat_qtd then
      return format('{"erro":"material %s faltando: tem %s precisa %s"}', v_mat_id, v_tem, v_mat_qtd);
    end if;
  end loop;

  update personagens set folego = folego - v_rec.folego_custo, updated_at = now()
    where nome = v_personagem;
  v_folego_gasto := v_rec.folego_custo;

  v_dif := v_nivel - v_rec.nivel_receita;
  v_mod := case
    when v_dif >= 2 then 3
    when v_dif = 1  then 1
    when v_dif = 0  then 0
    when v_dif = -1 then -1
    else -3
  end + coalesce(v_rec.dificuldade_mod, 0);

  v_dados := array[(1 + floor(random()*6))::int, (1 + floor(random()*6))::int];
  v_soma := v_dados[1] + v_dados[2] + v_mod;

  if v_soma >= 10 then
    v_resultado := 'sucesso_total';
    v_xp_ganho := v_rec.xp_recompensa;
    v_perda_mat := 0.0;
  elsif v_soma >= 7 then
    v_resultado := 'sucesso_parcial';
    v_xp_ganho := (v_rec.xp_recompensa * 0.75)::int;
    v_perda_mat := 0.15;
    if random() < 0.05 then v_ferramenta_danificada := true; end if;
  else
    v_resultado := 'falha';
    v_xp_ganho := (v_rec.xp_recompensa * 0.15)::int;
    v_perda_mat := 0.45;
    if random() < 0.15 then v_ferramenta_danificada := true; end if;
  end if;

  v_materiais_usados := array[]::jsonb[];
  v_ja_consumidos := array[]::text[];
  for v_mat_elem in select * from jsonb_array_elements(v_mats) loop
    v_mat_id := v_mat_elem->>'mat_id';
    if v_mat_id = any(v_ja_consumidos) then continue; end if;
    v_ja_consumidos := array_append(v_ja_consumidos, v_mat_id);
    v_mat_qtd := 0;
    for v_mat_elem in select * from jsonb_array_elements(v_mats) loop
      if v_mat_elem->>'mat_id' = v_mat_id then
        v_mat_qtd := v_mat_qtd + (v_mat_elem->>'qtd')::int;
      end if;
    end loop;
    if v_resultado = 'sucesso_total' then
      v_consumiu := v_mat_qtd;
    else
      v_consumiu := ceil(v_mat_qtd * (1.0 + v_perda_mat))::int;
    end if;
    declare
      v_restante int := v_consumiu;
      v_cur cursor for select id, quantidade from inventario
        where personagem_nome = v_personagem and tipo='material' and item_id = v_mat_id
          and not excluido order by id for update;
      v_linha record;
      v_tirar int;
    begin
      open v_cur;
      loop
        fetch v_cur into v_linha;
        exit when not found or v_restante <= 0;
        v_tirar := least(v_linha.quantidade, v_restante);
        if v_tirar = v_linha.quantidade then
          update inventario set excluido = true where id = v_linha.id;
        else
          update inventario set quantidade = quantidade - v_tirar where id = v_linha.id;
        end if;
        v_restante := v_restante - v_tirar;
      end loop;
      close v_cur;
    end;
    v_materiais_usados := array_append(v_materiais_usados,
      jsonb_build_object('mat_id', v_mat_id, 'qtd_usada', v_consumiu));
  end loop;

  -- resultado: sucesso/parcial = upsert em personagem_ferramentas
  if v_resultado <> 'falha' then
    insert into personagem_ferramentas
      (personagem_nome, ferramenta_id, obtido_em, updated_at)
      values (v_personagem, v_rec.id, now(), now())
    on conflict (personagem_nome, ferramenta_id) do update
      set updated_at = now();
    -- refino estágio 2: exclui a antecessora (estágio 1 foi substituído)
    if v_rec.receita_refino and v_rec.receita_estagio = 2 and v_rec.receita_antecessora_id is not null then
      delete from personagem_ferramentas
        where personagem_nome = v_personagem and ferramenta_id = v_rec.receita_antecessora_id;
    end if;
  end if;

  v_novo_nivel := null;
  if v_xp_ganho > 0 then
    declare
      v_xp_novo int;
      v_prox_xp int;
      v_subiu boolean;
    begin
      if not exists (select 1 from nivel_profissao
                      where personagem_nome = v_personagem and profissao = v_rec.profissao) then
        insert into nivel_profissao (personagem_nome, profissao, nivel, xp)
          values (v_personagem, v_rec.profissao, 1, 0);
      end if;
      update nivel_profissao
         set xp = xp + v_xp_ganho, updated_at = now()
       where personagem_nome = v_personagem and profissao = v_rec.profissao
       returning xp into v_xp_novo;
      <<sobe>> loop
        v_subiu := false;
        select nivel into v_nivel from nivel_profissao
          where personagem_nome = v_personagem and profissao = v_rec.profissao;
        select xp_necessario into v_prox_xp from nivel_profissao_xp
          where nivel = v_nivel + 1;
        exit sobe when v_prox_xp is null;
        if v_xp_novo >= v_prox_xp then
          update nivel_profissao
             set nivel = nivel + 1, xp = xp - v_prox_xp, updated_at = now()
           where personagem_nome = v_personagem and profissao = v_rec.profissao
           returning xp into v_xp_novo;
          v_subiu := true;
          v_novo_nivel := coalesce(v_novo_nivel, v_nivel + 1);
        end if;
        exit sobe when not v_subiu;
      end loop sobe;
    end;
  end if;

  insert into transacoes (de_personagem, para_personagem, tipo, valor, item_id, observacao)
    values (null, v_personagem, 'craft', 0, v_rec.id,
            format('craft_ferramenta %s %s (xp=%s soma=%s)', v_rec.id, v_resultado, v_xp_ganho, v_soma));

  v_resp := jsonb_build_object(
    'resultado', v_resultado,
    'dados', v_dados,
    'soma_com_mod', v_soma,
    'mod_pbta', v_mod,
    'xp', v_xp_ganho,
    'folego_gasto', v_folego_gasto,
    'materiais_consumidos', to_jsonb(v_materiais_usados),
    'ferramenta_id', v_rec.id,
    'ferramenta_nome', v_rec.nome_resultado,
    'ferramenta_raridade', v_rec.resultado_raridade,
    'novo_nivel_profissao', v_novo_nivel,
    'ferramenta_danificada', v_ferramenta_danificada,
    'efeitos', v_rec.efeitos,
    'refino_substituiu_antecessora',
      (v_rec.receita_refino and v_rec.receita_estagio = 2)
  );
  return v_resp::text;
end $$;
grant execute on function craftar_ferramenta(text) to authenticated;

-- ========== RPC #3: chocar_ovo (inventario.tipo = 'ovo' → criaturas_domadas status='incubando') ==========
-- Valida que o item é ovo, pertence ao jogador, exista em ovos_catalogo com incubadora_min.
-- Se Domador tiver ferramenta_nX (incubadora) nível >= incubadora_min: acelera o tempo.
create or replace function chocar_ovo(p_inventario_ovo_id bigint)
returns text language plpgsql security definer set search_path = public as $$
declare
  v_personagem text;
  v_prof text;
  v_inv inventario%rowtype;
  v_ovo ovos_catalogo%rowtype;
  v_ferramenta_nivel int;
  v_tempo_horas int;
  v_mult numeric;
  v_choca_em timestamptz;
  v_novo_cd_id bigint;
  v_resp jsonb;
begin
  select nome, profissao into v_personagem, v_prof from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  select * into v_inv from inventario
    where id = p_inventario_ovo_id and personagem_nome = v_personagem
      and tipo = 'ovo' and not excluido;
  if not found then return '{"erro":"ovo nao encontrado no seu inventario"}'; end if;

  select * into v_ovo from ovos_catalogo
    where id = v_inv.item_id and visivel=true and excluido=false;
  if not found then
    -- fallback: usa defaults se ovo não está no catálogo
    v_ovo.id := v_inv.item_id;
    v_ovo.nome := coalesce(v_inv.nome, v_inv.item_id);
    v_ovo.raridade := 'comum';
    v_ovo.tempo_chocagem_horas := 12;
    v_ovo.incubadora_min := 1;
    v_ovo.efeitos_padrao := '{}';
  end if;

  -- verifica incubadora mínima: se for Domador, usa maior nível de ferramenta que ele tiver
  v_ferramenta_nivel := 1;
  if v_prof = 'Domador' then
    select coalesce(max(f.nivel_ferramenta), 1) into v_ferramenta_nivel
      from personagem_ferramentas pf
      join ferramentas_oficio f on f.id = pf.ferramenta_id
      where pf.personagem_nome = v_personagem and f.profissao = 'Domador';
  end if;
  if v_ferramenta_nivel < v_ovo.incubadora_min then
    return format('{"erro":"precisa incubadora nivel %s (voce tem %s)"}',
                  v_ovo.incubadora_min, v_ferramenta_nivel);
  end if;

  -- aceleração: cada nível de incubadora ACIMA do mínimo = -10% no tempo
  -- mínimo garantido: 25% do tempo original (nunca mais rápido que isso)
  v_mult := 1.0 - (0.10 * (v_ferramenta_nivel - v_ovo.incubadora_min));
  if v_mult < 0.25 then v_mult := 0.25; end if;
  v_tempo_horas := ceil(v_ovo.tempo_chocagem_horas * v_mult)::int;
  v_choca_em := now() + (v_tempo_horas || ' hours')::interval;

  -- remove ovo do inventário (exclusão lógica)
  update inventario set excluido = true where id = v_inv.id;

  -- cria entrada em criaturas_domadas
  insert into criaturas_domadas
    (personagem_nome, especie, monstro_id, nome_pet, raridade, status,
     incubadora_nivel, efeitos, choca_em, obtido_em)
    values (v_personagem, v_ovo.especie, v_ovo.monstro_id,
            'Filhote de ' || coalesce(v_ovo.nome, v_ovo.id),
            case v_ovo.raridade
              when 'comum' then 'Comum' when 'incomum' then 'Incomum'
              when 'raro' then 'Raro' when 'epico' then 'Épico' else 'Comum' end,
            'incubando', v_ferramenta_nivel, v_ovo.efeitos_padrao, v_choca_em, now())
  returning id into v_novo_cd_id;

  insert into transacoes (de_personagem, para_personagem, tipo, valor, item_id, observacao)
    values (null, v_personagem, 'craft', 0, v_ovo.id,
            format('chocar_ovo %s (tempo=%sh)', v_ovo.id, v_tempo_horas));

  v_resp := jsonb_build_object(
    'criatura_domada_id', v_novo_cd_id,
    'ovo_id', v_ovo.id,
    'ovo_nome', v_ovo.nome,
    'raridade', v_ovo.raridade,
    'incubadora_nivel_usada', v_ferramenta_nivel,
    'tempo_horas_original', v_ovo.tempo_chocagem_horas,
    'tempo_horas_acelerado', v_tempo_horas,
    'choca_em', to_char(v_choca_em, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'),
    'efeitos', v_ovo.efeitos_padrao
  );
  return v_resp::text;
end $$;
grant execute on function chocar_ovo(bigint) to authenticated;

-- ========== RPC #4: verificar_chocagem (status='incubando' E choca_em <= now() → 'ativo') ==========
-- Cliente chama isso quando usuário clica em "Verificar" na tela de incubação.
create or replace function verificar_chocagem(p_criatura_domada_id bigint)
returns text language plpgsql security definer set search_path = public as $$
declare
  v_personagem text;
  v_cd criaturas_domadas%rowtype;
  v_resp jsonb;
begin
  select nome into v_personagem from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  select * into v_cd from criaturas_domadas
    where id = p_criatura_domada_id and personagem_nome = v_personagem and not excluido;
  if not found then return '{"erro":"criatura nao encontrada"}'; end if;

  if v_cd.status <> 'incubando' then
    return format('{"erro":"status atual: %s (nao esta incubando)"}', v_cd.status);
  end if;

  if v_cd.choca_em > now() then
    return jsonb_build_object(
      'erro', 'ainda nao chocou',
      'choca_em', to_char(v_cd.choca_em, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'),
      'faltam_segundos',
        greatest(0, round(extract(epoch from (v_cd.choca_em - now())))::int)
    )::text;
  end if;

  -- concluído: muda status
  update criaturas_domadas
     set status = 'ativo', nascido_em = now(), updated_at = now()
   where id = v_cd.id;

  v_resp := jsonb_build_object(
    'ok', true,
    'criatura_domada_id', v_cd.id,
    'nome_pet', v_cd.nome_pet,
    'raridade', v_cd.raridade,
    'status_novo', 'ativo',
    'nascido_em', to_char(now(), 'YYYY-MM-DD"T"HH24:MI:SS"Z"'),
    'efeitos', v_cd.efeitos
  );
  return v_resp::text;
end $$;
grant execute on function verificar_chocagem(bigint) to authenticated;

