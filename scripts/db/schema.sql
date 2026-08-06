-- Schema inicial do Sindicato dos Ossos / Aincrad RPG.
-- Rodar uma vez contra o banco Supabase do projeto. Idempotente o
-- suficiente pra reaplicar em dev (usa "if not exists" e recria policies).

-- ========================= TABELAS =========================

create table if not exists npcs (
  id text primary key,
  nome text not null,
  arquivo text, img text,
  papel text, profissao text, arma text, local text,
  atributos jsonb,
  resumo text, gancho text,
  falas text[],
  corpo text,
  canonico boolean default false,
  fonte text,
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists monstros (
  id text primary key,
  nome text not null, epiteto text, arquivo text, img text, carta text,
  tipo text, zona text, regioes text[],
  nivel_recomendado text, ameaca text, golpes text, local text,
  canonico boolean default false, fonte text,
  fraqueza text, elemento_fraqueza text, elemento_resistencia text,
  fraquezas text[], resistencias text[], vulnerabilidades text[],
  domavel text, doma_sucessos text, doma_requisito text,
  resumo text, habitat text, comportamento text, leitura text, sinal text,
  lore text,
  notas text, -- só mestre
  drops jsonb,
  corpo text,
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists armas (
  id text primary key,
  nome text not null, arquivo text, img text,
  tipo text, atributo text, raridade text,
  requisito text, preco numeric, preco_txt text,
  resumo text, efeito text, obter text, skills text[],
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists equipamentos (
  id text primary key,
  nome text not null, img text, slot text, raridade text,
  conjunto boolean default false, arquivo text,
  requisito text, preco numeric, preco_txt text,
  resumo text, efeito text, obter text,
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists moves_arma (
  nome text primary key,
  atributo text, marca text,
  move_a jsonb, move_b jsonb,
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists moves_profissao (
  nome text primary key,
  atributo text, marca text,
  move_a jsonb, move_b jsonb,
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists sistema (
  titulo text primary key,
  corpo text,
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists mercado (
  id text primary key,
  nome text not null, regiao text, descricao text, desconto text,
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists mercado_itens (
  id bigserial primary key,
  mercado_id text not null references mercado(id) on delete cascade,
  item text, col text, obs text
);

create table if not exists compra_materiais (
  id bigserial primary key,
  material text not null, col text, quem text,
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists quests (
  id text primary key,
  titulo text not null, cadeia text, tipo text, dificuldade text,
  regiao text, npc text,
  requer text[], desbloqueia text[],
  resumo text, corpo text,
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists cronicas (
  id text primary key,
  numero int, ep_rotulo text, titulo text not null, arquivo text,
  tipo text, dificuldade text, regiao text, conexoes text, elenco text,
  resumo text, corpo text,
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists guias (
  id text primary key,
  nome text not null, arquivo text, bioma text, nivel text, chegada text,
  leitura text, cena text,
  acoes jsonb,
  mestre text, -- só mestre
  demora text, evento text,
  locais jsonb, ligado text[],
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists puzzles (
  id text primary key,
  n int, nome text not null, arquivo text, regiao text, tipo text,
  cadeia text, duracao text,
  verdade text, -- só mestre
  recompensa text, corpo text,
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists oficios (
  nome text primary key,
  atributo text, arquivo text, marca text,
  acoes jsonb, postos jsonb,
  contato text, gancho text, renda text, item text,
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists dungeons (
  id text primary key,
  nome text not null, regiao text, nivel text, perfil text, nota text,
  setores jsonb, salas jsonb, ligacoes jsonb,
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists salas_dungeon (
  id text primary key,
  dungeon_id text references dungeons(id),
  nome text, tipo text, leitura text, corpo text,
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists producao (
  profissao text primary key,
  moeda text, itens jsonb, vale text,
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists pontos (
  id text primary key,
  regiao text, nome text not null, categoria text, x int, y int, tipo text,
  ref text, descricao text, respawn_horas int, teste jsonb,
  recompensa text, ameaca text, golpes text, atributo_fraqueza text,
  fala text, oferece text, vende text, obs text,
  mestre text, -- só mestre
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists pontos_detalhe (
  id text primary key,
  nome text, regiao text, arquivo text, leitura text, oque text,
  acoes jsonb,
  mestre text, -- só mestre
  atalhos jsonb,
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists clas (
  nome text primary key,
  destaque boolean default false,
  forca text, necessidade text, rival text, rumor text, status text,
  resumo text, bons text, precisa text, nao_admitem text, proximo text,
  atravessado text, quests text, aparecem text, simbolo text,
  reputacao jsonb,
  ganchos jsonb, -- só mestre
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists personagens (
  nome text primary key,
  guilda text, arma text, profissao text,
  conceito text, referencias text, aparencia text,
  atributos jsonb, arma_detalhe jsonb, profissao_detalhe jsonb,
  companheiro jsonb, estado jsonb, simbolo text,
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists cidades (
  id text primary key,
  nome text not null, andar text, tipo_de_zona text,
  guildas_presentes text[], canonico boolean default false, fonte text,
  corpo text, arquivo text,
  visivel boolean not null default true,
  updated_at timestamptz not null default now()
);

-- ========================= RLS =========================
-- leitura: pública se visivel, sempre liberada pra sessão autenticada
-- (mestre). escrita: só sessão autenticada.

do $$
declare t text;
begin
  foreach t in array array[
    'npcs','monstros','armas','equipamentos','moves_arma','moves_profissao',
    'sistema','mercado','compra_materiais','quests','cronicas','guias',
    'puzzles','oficios','dungeons','salas_dungeon','producao','pontos',
    'pontos_detalhe','clas','personagens','cidades'
  ]
  loop
    execute format('alter table %I enable row level security', t);
    execute format('drop policy if exists "select_publico_ou_mestre" on %I', t);
    execute format(
      'create policy "select_publico_ou_mestre" on %I for select using (visivel = true or auth.role() = ''authenticated'')',
      t
    );
    execute format('drop policy if exists "escrita_mestre" on %I', t);
    execute format(
      'create policy "escrita_mestre" on %I for all using (auth.role() = ''authenticated'') with check (auth.role() = ''authenticated'')',
      t
    );
  end loop;
end $$;

alter table mercado_itens enable row level security;
drop policy if exists "select_livre" on mercado_itens;
create policy "select_livre" on mercado_itens for select using (true);
drop policy if exists "escrita_mestre" on mercado_itens;
create policy "escrita_mestre" on mercado_itens for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- ================== VIEWS PÚBLICAS (sem coluna de mestre) ==================

create or replace view monstros_publico with (security_invoker = true) as
  select id,nome,epiteto,arquivo,img,carta,tipo,zona,regioes,nivel_recomendado,
         ameaca,golpes,local,canonico,fonte,fraqueza,elemento_fraqueza,
         elemento_resistencia,fraquezas,resistencias,vulnerabilidades,
         domavel,doma_sucessos,doma_requisito,resumo,habitat,comportamento,
         leitura,sinal,lore,drops,corpo,updated_at
  from monstros where visivel;

create or replace view guias_publico with (security_invoker = true) as
  select id,nome,arquivo,bioma,nivel,chegada,leitura,cena,acoes,demora,
         evento,locais,ligado,updated_at
  from guias where visivel;

create or replace view puzzles_publico with (security_invoker = true) as
  select id,n,nome,arquivo,regiao,tipo,cadeia,duracao,recompensa,corpo,updated_at
  from puzzles where visivel;

create or replace view pontos_publico with (security_invoker = true) as
  select id,regiao,nome,categoria,x,y,tipo,ref,descricao,respawn_horas,teste,
         recompensa,ameaca,golpes,atributo_fraqueza,fala,oferece,vende,obs,
         updated_at
  from pontos where visivel;

create or replace view pontos_detalhe_publico with (security_invoker = true) as
  select id,nome,regiao,arquivo,leitura,oque,acoes,atalhos,updated_at
  from pontos_detalhe where visivel;

create or replace view clas_publico with (security_invoker = true) as
  select nome,destaque,forca,necessidade,rival,rumor,status,resumo,bons,
         precisa,nao_admitem,proximo,atravessado,quests,aparecem,simbolo,
         reputacao,updated_at
  from clas where visivel;
