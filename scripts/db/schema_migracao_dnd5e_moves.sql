-- ============================================================================
-- MIGRAÇÃO PRA D&D 5e -- PARTE 5: catálogo de golpes (moves_arma/moves_profissao)
-- ============================================================================
-- moves_arma/moves_profissao guardavam o catálogo PBTA antigo (move_a/
-- move_b/golpe_2/golpe_3/limit_breaker com gatilho+dez_mais+sete_nove+
-- seis_menos). Esta migração ADICIONA as colunas novas (não apaga as
-- antigas -- ficam de histórico) com o conteúdo real de Sword Skills
-- (Seções 55-59) e habilidades de profissão por nível (Seções 30-44) do
-- SAO_RPG_5e.md. Dados inseridos por scripts/db/_popular_moves_dnd5e.py
-- (este arquivo só prepara as colunas).
-- ============================================================================

alter table moves_arma add column if not exists sword_skills jsonb;
alter table moves_arma add column if not exists limit_break_novo jsonb;

alter table moves_profissao add column if not exists niveis jsonb;

comment on column moves_arma.sword_skills is 'Array de {nivel,nome,descricao} -- as 7 Sword Skills normais (Seções 55-59 do SAO_RPG_5e.md). Substitui move_a/move_b/golpe_2/golpe_3 (PBTA, histórico).';
comment on column moves_arma.limit_break_novo is '{nivel,nome,descricao} -- Limit Break (nível 5). Nome novo pra não colidir com a coluna limit_breaker antiga (formato PBTA diferente, mantida como histórico).';
comment on column moves_profissao.niveis is 'Array de {nivel,nome,descricao} -- habilidades por nível 1/5/10/15/20 (Seções 30-44 do SAO_RPG_5e.md). Substitui move_a/move_b/move_c (PBTA, histórico).';
