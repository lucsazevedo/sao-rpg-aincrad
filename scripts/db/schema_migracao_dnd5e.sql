-- ============================================================================
-- MIGRAÇÃO DO JOGO ONLINE PRA D&D 5e (SAO_RPG_5e.md)
-- ============================================================================
-- Substitui a rolagem central (2d6 + staircase de nível, "sucesso_total /
-- sucesso_parcial / falha") por d20 + modificador de atributo + bônus de
-- proficiência vs. CD, mantendo o resultado ternário (sucesso_total/
-- sucesso_parcial/falha) que toda a economia do jogo (materiais, XP, drops)
-- já usa -- só a matemática por baixo muda, não a estrutura de resposta.
--
-- Regra de banda: sucesso_total = bate a CD por 5+ ou d20 natural;
-- sucesso_parcial = bate a CD por menos de 5; falha = não bate (d20 natural
-- 1 sempre falha, mesmo com modificador alto).
--
-- IMPORTANTE: backup completo já feito antes desta migração
-- (scripts/db/backups/backup_pre_dnd5e_*.sql, local, gitignored) -- ver
-- docs/pendencias.md.
--
-- Rodar com: python scripts/db/_aplicar_migracao_dnd5e.py
-- ============================================================================

-- ==========================================================================
-- 1) NOVAS COLUNAS
-- ==========================================================================

alter table personagens add column if not exists atributos_dnd jsonb;
alter table personagens add column if not exists nivel integer default 1;
alter table personagens add column if not exists ca integer default 10;
alter table personagens add column if not exists bonus_proficiencia integer default 2;

alter table monstros add column if not exists ca integer;
alter table monstros add column if not exists pv integer;
alter table monstros add column if not exists bonus_ataque integer;
alter table monstros add column if not exists cd_resistencia integer;

comment on column personagens.atributos_dnd is 'FOR/DES/CON/INT/SAB/CAR (D&D 5e) -- substitui "atributos" (PBTA: corpo/reflexo/conhecimento/espirito/tecnica), que fica só de histórico.';
comment on column personagens.nivel is 'Nível de personagem D&D (1-20, Seção 71 do SAO_RPG_5e.md) -- diferente de nivel_profissao, que continua sendo o grind de ofício.';
comment on column monstros.cd_resistencia is 'CD que o jogador precisa bater pra vencer o encontro (Seção 74 do SAO_RPG_5e.md) -- usado por combater_monstro.';

-- ==========================================================================
-- 2) MIGRAÇÃO DE DADOS -- personagens
-- ==========================================================================

update personagens set atributos_dnd = jsonb_build_object(
  'forca', greatest(3, least(20, 10 + 2 * coalesce((atributos->>'corpo')::int, 0))),
  'constituicao', greatest(3, least(20, 10 + 2 * coalesce((atributos->>'corpo')::int, 0))),
  'destreza', greatest(3, least(20, 10 + 2 * greatest(
    coalesce((atributos->>'reflexo')::int, 0),
    coalesce((atributos->>'tecnica')::int, 0)
  ))),
  'inteligencia', greatest(3, least(20, 10 + 2 * coalesce((atributos->>'conhecimento')::int, 0))),
  'sabedoria', greatest(3, least(20, 10 + 2 * coalesce((atributos->>'espirito')::int, 0))),
  'carisma', greatest(3, least(20, 10 + 2 * coalesce((atributos->>'espirito')::int, 0)))
)
where atributos is not null and atributos_dnd is null;

-- nível de personagem: melhor proxy disponível hoje é o maior nível de
-- profissão (grind já existente) -- ponto de partida razoável, evolui por
-- XP de combate/missão dali em diante.
update personagens p set nivel = coalesce(
  (select max(np.nivel) from nivel_profissao np where np.personagem_nome = p.nome), 1
)
where nivel is null or nivel = 1;

update personagens set bonus_proficiencia = case
  when nivel between 1 and 4 then 2
  when nivel between 5 and 8 then 3
  when nivel between 9 and 12 then 4
  when nivel between 13 and 16 then 5
  else 6
end;

update personagens set ca = 10 + floor((coalesce((atributos_dnd->>'destreza')::int, 10) - 10) / 2.0)::int
where atributos_dnd is not null;

-- pv_max/pv_atual: reaproveita vida_max/vida_atual (já tinham semântica de
-- PV -- máximo/atual, dano de combate reduz) -- não duplica em coluna nova.

-- ==========================================================================
-- 3) MIGRAÇÃO DE DADOS -- monstros (atributo_fraqueza + stat block)
-- ==========================================================================

update monstros set atributo_fraqueza = case lower(atributo_fraqueza)
  when 'corpo' then 'Força'
  when 'reflexo' then 'Destreza'
  when 'conhecimento' then 'Inteligência'
  when 'espírito' then 'Sabedoria'
  when 'espirito' then 'Sabedoria'
  when 'técnica' then 'Destreza'
  when 'tecnica' then 'Destreza'
  else atributo_fraqueza
end
where atributo_fraqueza is not null;

-- extrai um "nível" numérico de nivel_recomendado pra fórmula da Seção 74:
-- pega o primeiro número da string, ignorando parênteses tipo "(andar 2)"
-- (armadilha já documentada em docs/pendencias.md -- "(andar 2)" é o piso,
-- não dificuldade).
with niveis as (
  select id,
    coalesce(nullif(substring(split_part(nivel_recomendado, '(', 1) from '\d+'), '')::int, 5) as nivel
  from monstros
)
update monstros m set
  ca = case m.ameaca
    when 'fraco' then 10 when 'comum' then 11 when 'forte' then 13
    when 'elite' then 15 when 'chefe' then 16 else 11
  end + (n.nivel / 3),
  pv = case m.ameaca
    when 'fraco' then 10 when 'comum' then 20 when 'forte' then 40
    when 'elite' then 70 when 'chefe' then 150 else 20
  end + n.nivel * (case m.ameaca
    when 'fraco' then 4 when 'comum' then 6 when 'forte' then 8
    when 'elite' then 10 when 'chefe' then 15 else 6
  end),
  bonus_ataque = case m.ameaca
    when 'fraco' then 2 when 'comum' then 3 when 'forte' then 4
    when 'elite' then 5 when 'chefe' then 6 else 3
  end + (n.nivel / 4),
  cd_resistencia = case m.ameaca
    when 'fraco' then 10 when 'comum' then 11 when 'forte' then 13
    when 'elite' then 14 when 'chefe' then 15 else 11
  end + (n.nivel / 4)
from niveis n
where m.id = n.id;

-- ==========================================================================
-- 4) armas.atributo e receitas.atributo_teste
-- ==========================================================================

-- CHECK antiga só permitia os 5 nomes PBTA -- derruba antes do UPDATE
-- abaixo (senão o UPDATE quebra a própria constraint); recriada pros 6
-- nomes de D&D depois do UPDATE, no fim desta seção.
alter table receitas drop constraint if exists receitas_atributo_teste_check;

-- armas: usa a tabela canônica por TIPO (Seção 7 do SAO_RPG_5e.md), não um
-- mapeamento cego 5->6 -- garante consistência com armas/*.md já convertido.
update armas set atributo = case lower(tipo)
  when 'espada + escudo' then 'Força' when 'escudo e espada' then 'Força'
  when 'martelo' then 'Força' when 'pá' then 'Força' when 'pa' then 'Força'
  when 'lança' then 'Destreza' when 'lanca' then 'Destreza'
  when 'corrente com peso' then 'Destreza' when 'adagas' then 'Destreza'
  when 'arco e flecha' then 'Destreza' when 'espada longa' then 'Força'
  when 'rapieira' then 'Destreza' when 'katana' then 'Sabedoria'
  when 'manopla' then 'Força' when 'leque' then 'Sabedoria'
  when 'bastão' then 'Sabedoria' when 'bastao' then 'Sabedoria'
  when 'chicote' then 'Inteligência' when 'besta' then 'Destreza'
  when 'chakram' then 'Destreza' when 'chakrams' then 'Destreza'
  when 'foice' then 'Sabedoria' when 'adagas de arremesso' then 'Destreza'
  when 'machado' then 'Força'
  else (case lower(atributo)
    when 'corpo' then 'Força' when 'reflexo' then 'Destreza'
    when 'conhecimento' then 'Inteligência' when 'espírito' then 'Sabedoria'
    when 'espirito' then 'Sabedoria' when 'técnica' then 'Destreza'
    when 'tecnica' then 'Destreza' else atributo end)
end;

update receitas set atributo_teste = case lower(atributo_teste)
  when 'corpo' then 'Força' when 'reflexo' then 'Destreza'
  when 'conhecimento' then 'Inteligência' when 'espírito' then 'Sabedoria'
  when 'espirito' then 'Sabedoria' when 'técnica' then 'Destreza'
  when 'tecnica' then 'Destreza' else atributo_teste
end
where atributo_teste is not null;

alter table receitas add constraint receitas_atributo_teste_check
  check (atributo_teste = any (array['Força','Destreza','Constituição','Inteligência','Sabedoria','Carisma']));

-- ==========================================================================
-- 4b) profissoes_atributo -- lookup profissão -> atributo D&D (Seção 19 do
--     SAO_RPG_5e.md). Inclui os nomes pré-fusão (Bibliotecário/Cartógrafo/
--     Diplomata/Coveiro/Pescador/Açougueiro) porque receitas.profissao e
--     personagens.profissao ainda têm dado legado com esses nomes -- não é
--     escopo desta migração renomear profissão em dado existente, só
--     garantir que o teste de d20 sempre ache um atributo.
-- ==========================================================================

create table if not exists profissoes_atributo (
  profissao text primary key,
  atributo text not null
);

insert into profissoes_atributo (profissao, atributo) values
  ('Alquimista', 'Inteligência'),
  ('Caçador', 'Destreza'),
  ('Informante', 'Inteligência'),
  ('Comerciante', 'Carisma'),
  ('Costureiro', 'Destreza'),
  ('Cozinheiro', 'Inteligência'),
  ('Ferreiro', 'Força'),
  ('Lenhador', 'Força'),
  ('Mercenário', 'Força'),
  ('Médico', 'Inteligência'),
  ('Minerador', 'Força'),
  ('Mestre de Montarias', 'Destreza'),
  ('Domador', 'Destreza'),
  ('Joalheiro', 'Destreza'),
  ('Músico', 'Carisma'),
  -- nomes pré-fusão (Seção 17 do SAO_RPG_5e.md) -- mapeados pro atributo
  -- da profissão que os absorveu.
  ('Bibliotecário', 'Inteligência'),
  ('Cartógrafo', 'Inteligência'),
  ('Diplomata', 'Inteligência'),
  ('Coveiro', 'Força'),
  ('Pescador', 'Destreza')
on conflict (profissao) do update set atributo = excluded.atributo;

alter table profissoes_atributo enable row level security;
drop policy if exists "leitura_logada" on profissoes_atributo;
create policy "leitura_logada" on profissoes_atributo for select
  using (auth.role() = 'authenticated');

-- ==========================================================================
-- 5) FUNÇÕES AUXILIARES (d20)
-- ==========================================================================

create or replace function bonus_proficiencia_por_nivel(p_nivel int)
returns int language sql immutable as $$
  select case
    when p_nivel between 1 and 4 then 2
    when p_nivel between 5 and 8 then 3
    when p_nivel between 9 and 12 then 4
    when p_nivel between 13 and 16 then 5
    else 6
  end;
$$;

create or replace function cd_por_nivel_conteudo(p_nivel int)
returns int language sql immutable as $$
  -- Seção 29 do SAO_RPG_5e.md: Fácil=10, Moderada=12, Difícil=15,
  -- Muito difícil=18, Excepcional=20 -- mapeado pela curva de nível
  -- 1/2/4/6/8/10 já usada em receitas/missões (docs/pendencias.md).
  select case
    when p_nivel <= 2 then 10
    when p_nivel <= 4 then 12
    when p_nivel <= 6 then 15
    when p_nivel <= 8 then 18
    else 20
  end;
$$;

create or replace function mod_atributo_personagem(p_personagem text, p_atributo text)
returns int language sql stable security definer set search_path to 'public' as $$
  select floor((coalesce((
    select case lower(coalesce(p_atributo, ''))
      when 'força' then atributos_dnd->>'forca'
      when 'forca' then atributos_dnd->>'forca'
      when 'destreza' then atributos_dnd->>'destreza'
      when 'constituição' then atributos_dnd->>'constituicao'
      when 'constituicao' then atributos_dnd->>'constituicao'
      when 'inteligência' then atributos_dnd->>'inteligencia'
      when 'inteligencia' then atributos_dnd->>'inteligencia'
      when 'sabedoria' then atributos_dnd->>'sabedoria'
      when 'carisma' then atributos_dnd->>'carisma'
      else atributos_dnd->>'forca'
    end
    from personagens where nome = p_personagem
  )::int, 10) - 10) / 2.0)::int;
$$;

-- ==========================================================================
-- 6) RPCs -- rolagem central trocada de 2d6-staircase pra d20+mod+prof vs CD
-- ==========================================================================
-- (definições completas na Fase 3b -- ver scripts/db/schema_migracao_dnd5e_rpcs.sql)
