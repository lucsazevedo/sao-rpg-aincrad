-- Continuação do gate de nível (schema_gate_login_e_nivel.sql): usuário
-- pediu pra estender pro resto. Achei vínculo real e limpo em mais 2
-- tabelas (monstros.regioes casa exatamente com guias.id — populei
-- guias.nivel, que antes estava vazio — e salas_dungeon.dungeon_id casa
-- com dungeons.id), então guias/pontos/pontos_detalhe/salas_dungeon
-- ganham nível de verdade agora. armas/equipamentos/cartas ganham nível
-- derivado da raridade (mesma escala usada em receitas do item 3 —
-- Comum=1, Incomum=3, Raro=6, Épico=8, Lendário=10). quests/cronicas
-- ganham nível derivado da dificuldade.
--
-- NÃO estendido (documentado por quê, sem inventar vínculo furado):
-- npcs.local, puzzles.regiao, mercado.regiao e quests.regiao são texto
-- NARRATIVO livre ("Cidade do Início — Guarita dos Cartógrafos, saída
-- norte"), não um slug que bate com guias.id — um match automático aí
-- seria isca pra ficar errado (esconder o que devia mostrar ou
-- vice-versa), não é decisão técnica seguro de tomar sozinho. cidades,
-- clas, cristais, oficios, producao, sistema não têm nenhum campo (nem
-- direto nem por vínculo) que sirva de nível real.

drop policy if exists "select_publico_ou_mestre" on "guias";
create policy "select_publico_ou_mestre" on "guias" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated'
    and coalesce(nullif(substring(nivel from '\d+'), '')::int, 1) <= nivel_jogador_atual())
  or is_mestre() or pode_ver('guias', id)
);

drop policy if exists "select_publico_ou_mestre" on "pontos";
create policy "select_publico_ou_mestre" on "pontos" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated'
    and coalesce((select nullif(substring(g.nivel from '\d+'), '')::int from guias g where g.id = pontos.regiao), 1) <= nivel_jogador_atual())
  or is_mestre() or pode_ver('pontos', id)
);

drop policy if exists "select_publico_ou_mestre" on "pontos_detalhe";
create policy "select_publico_ou_mestre" on "pontos_detalhe" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated'
    and coalesce((select nullif(substring(g.nivel from '\d+'), '')::int from guias g where g.id = pontos_detalhe.regiao), 1) <= nivel_jogador_atual())
  or is_mestre() or pode_ver('pontos_detalhe', id)
);

drop policy if exists "select_publico_ou_mestre" on "salas_dungeon";
create policy "select_publico_ou_mestre" on "salas_dungeon" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated'
    and coalesce((select nullif(substring(d.nivel from '\d+'), '')::int from dungeons d where d.id = salas_dungeon.dungeon_id), 1) <= nivel_jogador_atual())
  or is_mestre() or pode_ver('salas_dungeon', id)
);

drop policy if exists "select_publico_ou_mestre" on "armas";
create policy "select_publico_ou_mestre" on "armas" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated'
    and case raridade
      when 'Comum' then 1 when 'Incomum' then 3 when 'Raro' then 6
      when 'Épico' then 8 when 'Lendário' then 10 else 1 end <= nivel_jogador_atual())
  or is_mestre() or pode_ver('armas', id)
);

drop policy if exists "select_publico_ou_mestre" on "equipamentos";
create policy "select_publico_ou_mestre" on "equipamentos" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated'
    and case raridade
      when 'Comum' then 1 when 'Incomum' then 3 when 'Raro' then 6
      when 'Épico' then 8 when 'Lendário' then 10 else 1 end <= nivel_jogador_atual())
  or is_mestre() or pode_ver('equipamentos', id)
);

drop policy if exists "select_publico_ou_mestre" on "cartas";
create policy "select_publico_ou_mestre" on "cartas" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated'
    and case raridade
      when 'Comum' then 1 when 'Incomum' then 3 when 'Raro' then 6
      when 'Épico' then 8 when 'Lendário' then 10 else 1 end <= nivel_jogador_atual())
  or is_mestre()
);

drop policy if exists "select_publico_ou_mestre" on "quests";
create policy "select_publico_ou_mestre" on "quests" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated'
    and case
      when dificuldade ilike '%muito difícil%' then 9
      when dificuldade ilike '%chefe%' then 10
      when dificuldade ilike '%difícil%' then 7
      when dificuldade ilike '%médio%' then 4
      when dificuldade ilike '%fácil%' then 1
      else 1 end <= nivel_jogador_atual())
  or is_mestre() or pode_ver('quests', id)
);

drop policy if exists "select_publico_ou_mestre" on "cronicas";
create policy "select_publico_ou_mestre" on "cronicas" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated'
    and case
      when dificuldade ilike '%muito difícil%' then 9
      when dificuldade ilike '%difícil%' then 7
      when dificuldade ilike '%médio%' then 4
      when dificuldade ilike '%fácil%' then 1
      else 1 end <= nivel_jogador_atual())
  or is_mestre() or pode_ver('cronicas', id)
);

-- views *_publico que também mudaram de gate (guias, pontos, pontos_detalhe)
create or replace view guias_publico as
select id, nome, arquivo, bioma, nivel, chegada, leitura, cena, acoes, demora, evento,
  locais, ligado, visivel, updated_at,
  case when is_mestre() then mestre else null::text end as mestre
from guias
where (visivel = true and excluido = false and auth.role() = 'authenticated'
        and coalesce(nullif(substring(nivel from '\d+'), '')::int, 1) <= nivel_jogador_atual())
  or is_mestre() or pode_ver('guias', id);

create or replace view pontos_publico as
select id, regiao, nome, categoria, x, y, tipo, ref, descricao, respawn_horas, teste,
  recompensa, ameaca, golpes, atributo_fraqueza, fala, oferece, vende, obs, visivel, updated_at,
  case when is_mestre() then mestre else null::text end as mestre
from pontos
where (visivel = true and excluido = false and auth.role() = 'authenticated'
        and coalesce((select nullif(substring(g.nivel from '\d+'), '')::int from guias g where g.id = pontos.regiao), 1) <= nivel_jogador_atual())
  or is_mestre() or pode_ver('pontos', id);

create or replace view pontos_detalhe_publico as
select id, nome, regiao, arquivo, leitura, oque, acoes, atalhos, visivel, updated_at,
  case when is_mestre() then mestre else null::text end as mestre
from pontos_detalhe
where (visivel = true and excluido = false and auth.role() = 'authenticated'
        and coalesce((select nullif(substring(g.nivel from '\d+'), '')::int from guias g where g.id = pontos_detalhe.regiao), 1) <= nivel_jogador_atual())
  or is_mestre() or pode_ver('pontos_detalhe', id);
