-- Pedido do usuário: "nada é público, tudo só é visual se logado, e isso
-- depende ainda de nível mínimo pra ser exibido — todo tipo de item,
-- monstro, região, missão... tudo depende de um nível".
--
-- Duas camadas, aplicadas juntas em cada tabela de conteúdo de mundo:
-- 1) LOGIN obrigatório — troca a antiga policy "visivel=true" pública
--    (que qualquer anônimo lia) por "visivel=true E autenticado".
-- 2) NÍVEL mínimo — SÓ nas tabelas que têm um campo de nível de verdade
--    e populado (ver levantamento abaixo). Onde não existe (ou existe
--    mas está vazio, caso de guias.nivel), não dá pra inventar um número
--    — fica só o gate de login por enquanto, documentado no dolist.
--
-- "Nível do jogador" = maior Nível de Profissão que o personagem tem
-- (mesma régua que combater_monstro/craftar_item já usam pra dificuldade
-- — não é um nível de personagem novo, reaproveita o que já existe).

create or replace function public.nivel_jogador_atual()
returns int
language sql
stable
security definer
set search_path to 'public'
as $$
  select coalesce(
    (select max(np.nivel) from nivel_profissao np
       join personagens p on p.nome = np.personagem_nome
       where p.dono_id = auth.uid()),
    1
  );
$$;

-- ===================== GRUPO A: login + nível =====================
-- monstros e dungeons guardam nível como TEXTO (às vezes faixa, "6-11" ou
-- frase livre "MUITO acima do andar 1") — extrai o primeiro número; sem
-- número nenhum, trata como nível 1 (não esconde por engano).

drop policy if exists "select_publico_ou_mestre" on "monstros";
create policy "select_publico_ou_mestre" on "monstros" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated'
    and coalesce(nullif(substring(nivel_recomendado from '\d+'), '')::int, 1) <= nivel_jogador_atual())
  or is_mestre() or pode_ver('monstros', id)
);

drop policy if exists "select_publico_ou_mestre" on "dungeons";
create policy "select_publico_ou_mestre" on "dungeons" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated'
    and coalesce(nullif(substring(nivel from '\d+'), '')::int, 1) <= nivel_jogador_atual())
  or is_mestre() or pode_ver('dungeons', id)
);

drop policy if exists "select_publico_ou_mestre" on "materiais_basicos";
create policy "select_publico_ou_mestre" on "materiais_basicos" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated'
    and coalesce(nivel_obtencao, 1) <= nivel_jogador_atual())
  or is_mestre()
);

drop policy if exists "select_publico_ou_mestre" on "receitas";
create policy "select_publico_ou_mestre" on "receitas" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated'
    and coalesce(nivel_receita, 1) <= nivel_jogador_atual())
  or is_mestre()
);

drop policy if exists "select_publico_ou_mestre" on "ferramentas_oficio";
create policy "select_publico_ou_mestre" on "ferramentas_oficio" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated'
    and coalesce(nivel_ferramenta, 1) <= nivel_jogador_atual())
  or is_mestre()
);

drop policy if exists "select_publico_ou_mestre" on "ovos_catalogo";
create policy "select_publico_ou_mestre" on "ovos_catalogo" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated'
    and coalesce(nivel_min, 1) <= nivel_jogador_atual())
  or is_mestre()
);

drop policy if exists "select_publico_ou_mestre" on "missoes_quadro";
create policy "select_publico_ou_mestre" on "missoes_quadro" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated'
    and coalesce(nivel_min, 1) <= nivel_jogador_atual())
  or is_mestre()
);

-- ===================== GRUPO B: só login (sem campo de nível de verdade) =====================
-- guias.nivel existe na tabela mas está vazio em 100% das linhas (nunca
-- foi preenchido) — sem dado real pra gatear, fica só login por enquanto.
-- armas/equipamentos.requisito é texto de ATRIBUTO ("Corpo 0+"), não
-- nível numérico — não dá pra tratar como nível sem reescrever o campo.
-- puzzles/pontos/pontos_detalhe/npcs/quests/cronicas/salas_dungeon/
-- cidades/clas/cartas/cristais/oficios/producao/mercado/sistema não têm
-- nenhum campo de nível.

drop policy if exists "select_publico_ou_mestre" on "guias";
create policy "select_publico_ou_mestre" on "guias" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('guias', id)
);

drop policy if exists "select_publico_ou_mestre" on "puzzles";
create policy "select_publico_ou_mestre" on "puzzles" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('puzzles', id)
);

drop policy if exists "select_publico_ou_mestre" on "pontos";
create policy "select_publico_ou_mestre" on "pontos" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('pontos', id)
);

drop policy if exists "select_publico_ou_mestre" on "pontos_detalhe";
create policy "select_publico_ou_mestre" on "pontos_detalhe" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('pontos_detalhe', id)
);

drop policy if exists "select_publico_ou_mestre" on "npcs";
create policy "select_publico_ou_mestre" on "npcs" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('npcs', id)
);

drop policy if exists "select_publico_ou_mestre" on "quests";
create policy "select_publico_ou_mestre" on "quests" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('quests', id)
);

drop policy if exists "select_publico_ou_mestre" on "cronicas";
create policy "select_publico_ou_mestre" on "cronicas" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('cronicas', id)
);

drop policy if exists "select_publico_ou_mestre" on "salas_dungeon";
create policy "select_publico_ou_mestre" on "salas_dungeon" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('salas_dungeon', id)
);

drop policy if exists "select_publico_ou_mestre" on "cidades";
create policy "select_publico_ou_mestre" on "cidades" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('cidades', id)
);

drop policy if exists "select_publico_ou_mestre" on "clas";
create policy "select_publico_ou_mestre" on "clas" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('clas', nome)
);

drop policy if exists "select_publico_ou_mestre" on "armas";
create policy "select_publico_ou_mestre" on "armas" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('armas', id)
);

drop policy if exists "select_publico_ou_mestre" on "equipamentos";
create policy "select_publico_ou_mestre" on "equipamentos" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('equipamentos', id)
);

drop policy if exists "select_publico_ou_mestre" on "cartas";
create policy "select_publico_ou_mestre" on "cartas" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre()
);

drop policy if exists "select_publico_ou_mestre" on "cristais";
create policy "select_publico_ou_mestre" on "cristais" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre()
);

drop policy if exists "select_publico_ou_mestre" on "oficios";
create policy "select_publico_ou_mestre" on "oficios" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('oficios', nome)
);

drop policy if exists "select_publico_ou_mestre" on "producao";
create policy "select_publico_ou_mestre" on "producao" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('producao', profissao)
);

drop policy if exists "select_publico_ou_mestre" on "mercado";
create policy "select_publico_ou_mestre" on "mercado" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('mercado', id)
);

drop policy if exists "select_publico_ou_mestre" on "sistema";
create policy "select_publico_ou_mestre" on "sistema" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('sistema', titulo)
);

-- ===================== views *_publico (WHERE próprio, não herda RLS) =====================
-- Views rodam com o privilégio de quem criou (não do jogador que consulta
-- via REST), então o WHERE daqui é o gate de verdade pra quem passa pela
-- view — que agora é SEMPRE (mestre incluído, ver Compendio.vue) desde a
-- correção do "permission denied" de 10/08. Precisa do mesmo gate de
-- login+nível que a policy da tabela base ganhou acima, senão a view
-- furaria o que acabou de ser fechado.

create or replace view monstros_publico as
select id, nome, epiteto, arquivo, img, carta, tipo, zona, regioes, nivel_recomendado,
  ameaca, golpes, local, canonico, fonte, fraqueza, atributo_fraqueza, fraquezas,
  resistencias, vulnerabilidades, resumo, habitat, comportamento, leitura, sinal, lore,
  drops, corpo, visivel, updated_at,
  case when is_mestre() then notas else null::text end as notas,
  domavel, doma_requisito, doma_sucessos, min_contribuintes, chefe_vida_max
from monstros
where (visivel = true and excluido = false and auth.role() = 'authenticated'
        and coalesce(nullif(substring(nivel_recomendado from '\d+'), '')::int, 1) <= nivel_jogador_atual())
  or is_mestre() or pode_ver('monstros', id);

create or replace view guias_publico as
select id, nome, arquivo, bioma, nivel, chegada, leitura, cena, acoes, demora, evento,
  locais, ligado, visivel, updated_at,
  case when is_mestre() then mestre else null::text end as mestre
from guias
where (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('guias', id);

create or replace view puzzles_publico as
select id, n, nome, arquivo, regiao, tipo, cadeia, duracao, recompensa, corpo, visivel, updated_at,
  case when is_mestre() then verdade else null::text end as verdade
from puzzles
where (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('puzzles', id);

create or replace view pontos_publico as
select id, regiao, nome, categoria, x, y, tipo, ref, descricao, respawn_horas, teste,
  recompensa, ameaca, golpes, atributo_fraqueza, fala, oferece, vende, obs, visivel, updated_at,
  case when is_mestre() then mestre else null::text end as mestre
from pontos
where (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('pontos', id);

create or replace view pontos_detalhe_publico as
select id, nome, regiao, arquivo, leitura, oque, acoes, atalhos, visivel, updated_at,
  case when is_mestre() then mestre else null::text end as mestre
from pontos_detalhe
where (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('pontos_detalhe', id);

create or replace view clas_publico as
select nome, destaque, forca, necessidade, rival, rumor, status, resumo, bons, precisa,
  nao_admitem, proximo, atravessado, quests, aparecem, simbolo, reputacao, visivel, updated_at,
  case when is_mestre() then ganchos else null::jsonb end as ganchos
from clas
where (visivel = true and excluido = false and auth.role() = 'authenticated')
  or is_mestre() or pode_ver('clas', nome);
