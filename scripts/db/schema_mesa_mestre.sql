-- Ferramentas de mesa do mestre (rodar depois de schema.sql + schema_papeis.sql
-- + schema_jogo_online.sql — usa is_mestre(), já criada em schema_papeis.sql).
--
-- Substitui o que antes só existia em localStorage no navegador
-- (scripts/web/compendio_andar1.html, abas "Mesa" e "Só o Mestre"): estado
-- agora fica no banco, então qualquer dispositivo logado como mestre vê o
-- mesmo estado — e sobrevive a limpar o navegador.
--
-- Tudo aqui é mestre-only (nem select liberado pra jogador): isso é
-- ferramenta de condução de sessão, não conteúdo de jogo. Idempotente
-- (create table if not exists / add column if not exists), roda de novo sem
-- problema.

-- ---------------------------------------------------------------------
-- 1. Relógios narrativos (progresso de ameaças/tramas de fundo, 0-6)
-- ---------------------------------------------------------------------
create table if not exists mesa_relogios (
  id text primary key,
  nome text not null,
  descricao text,
  valor int not null default 0 check (valor between 0 and 6),
  updated_at timestamptz not null default now()
);

insert into mesa_relogios (id, nome, descricao, valor) values
  ('raid',     'Pressão do Raid',      'Rumor → abastecimento → formação → convocação.', 0),
  ('mercado',  'Mercado de Guerra',    'Escassez → especulação → favores cobrados.', 0),
  ('misterio', 'Verdade do Andar',     'Sinais → conexões → interpretação pública perigosa.', 0),
  ('clas',     'Tensão entre Clãs',    'Crédito → boicote → aliança ou ruptura.', 0),
  ('memorial', 'Memorial',             'Ausência → nome → luto que muda decisões.', 0)
on conflict (id) do nothing;

-- ---------------------------------------------------------------------
-- 2. Preparação de raid (6 categorias fixas de docs/regras_nucleares_campanha.md)
-- ---------------------------------------------------------------------
create table if not exists mesa_raid_prep (
  categoria text primary key,
  uso text,
  marcado boolean not null default false,
  updated_at timestamptz not null default now()
);

insert into mesa_raid_prep (categoria, uso) values
  ('Reconhecimento', 'revelar rota, fraqueza ou saída'),
  ('Suprimentos',     'remover Exaurido ou evitar perda de recurso'),
  ('Equipamento',     'evitar rachadura ou absorver impacto'),
  ('Saúde',           'remover Ferido ou Abalado de um aliado'),
  ('Coesão',          'impedir pânico, deserção ou conflito de clã'),
  ('Inteligência',    'declarar uma verdade preparada sobre o chefe')
on conflict (categoria) do nothing;

-- ---------------------------------------------------------------------
-- 3. Favor e Suspeita — relações livres (pessoa/facção/clã), -3 a +3
-- ---------------------------------------------------------------------
create table if not exists mesa_relacoes (
  nome text primary key,
  valor int not null default 0 check (valor between -3 and 3),
  nota text,
  updated_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------
-- 4. Registro de sessão (histórico de episódios)
-- ---------------------------------------------------------------------
create table if not exists mesa_sessoes (
  id bigserial primary key,
  titulo text,
  trio text,
  fato text,
  rumor text,
  pressao text,
  criado_em timestamptz not null default now()
);

-- ---------------------------------------------------------------------
-- 5. Rastreador de combate (golpes acumulados por monstro em cena) —
-- não existe "iniciativa" nem "HP" no sistema (ver
-- docs/regras_nucleares_campanha.md): é só uma contagem manual de golpes
-- pra não precisar decorar. golpes_alvo é texto (alguns monstros têm
-- contagem composta, ex. "2 (individual) / 4-5 (fundido)") — referência,
-- não trava o contador.
-- ---------------------------------------------------------------------
create table if not exists mesa_combate (
  id bigserial primary key,
  monstro_id text,
  monstro_nome text not null,
  nivel_ameaca text,
  golpes_alvo text,
  golpes_atual int not null default 0,
  ativo boolean not null default true,
  criado_em timestamptz not null default now()
);

-- ---------------------------------------------------------------------
-- 6. Condições do personagem — substituem pontos de vida (ver regras).
-- Guardado na própria ficha (array de nomes de condição ativa).
-- ---------------------------------------------------------------------
alter table personagens add column if not exists condicoes jsonb not null default '[]'::jsonb;

-- ========================= RLS: tudo mestre-only =========================
do $$
declare t text;
begin
  foreach t in array array['mesa_relogios','mesa_raid_prep','mesa_relacoes','mesa_sessoes','mesa_combate']
  loop
    execute format('alter table %I enable row level security', t);
    execute format('drop policy if exists "so_mestre" on %I', t);
    execute format(
      'create policy "so_mestre" on %I for all using (is_mestre()) with check (is_mestre())', t);
  end loop;
end $$;
