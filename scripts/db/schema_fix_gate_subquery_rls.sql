-- Bug achado testando: as policies de pontos/pontos_detalhe/salas_dungeon
-- usavam uma subquery correlacionada pra buscar o nível de guias/dungeons
-- (`select ... from guias g where g.id = pontos.regiao`) — mas guias e
-- dungeons TAMBÉM têm RLS com gate de nível. Subquery dentro de USING
-- roda com o MESMO contexto de auth do usuário que está consultando, e
-- portanto tá sujeita à RLS da tabela referenciada também. Resultado:
-- se a dungeons/guias em questão tem nível ALTO (bloqueada pra esse
-- jogador), a subquery não acha a linha, retorna NULL, e o
-- `coalesce(NULL, 1)` trata isso como "nível 1, pode mostrar" — o
-- OPOSTO do que devia (deveria ficar MAIS restrito, não menos).
-- Confirmado: salas de "Mournhall" (dungeons.nivel='8-13') apareciam
-- pra um jogador nível 2, porque a subquery pra achar o nível de
-- Mournhall era ela mesma bloqueada pela RLS de dungeons.
--
-- Fix: funções SECURITY DEFINER pra ler o nível — rodam com o
-- privilégio de quem criou a função, ignoram RLS da tabela de origem
-- (mesma técnica já usada em nivel_jogador_atual() e nos outros helpers
-- desta sessão).

create or replace function public.nivel_da_guia(p_guia_id text)
returns int
language sql
stable
security definer
set search_path to 'public'
as $$
  select coalesce(nullif(substring(nivel from '\d+'), '')::int, 1) from guias where id = p_guia_id;
$$;

create or replace function public.nivel_da_dungeon(p_dungeon_id text)
returns int
language sql
stable
security definer
set search_path to 'public'
as $$
  select coalesce(nullif(substring(nivel from '\d+'), '')::int, 1) from dungeons where id = p_dungeon_id;
$$;

drop policy if exists "select_publico_ou_mestre" on "pontos";
create policy "select_publico_ou_mestre" on "pontos" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated'
    and coalesce(nivel_da_guia(regiao), 1) <= nivel_jogador_atual())
  or is_mestre() or pode_ver('pontos', id)
);

drop policy if exists "select_publico_ou_mestre" on "pontos_detalhe";
create policy "select_publico_ou_mestre" on "pontos_detalhe" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated'
    and coalesce(nivel_da_guia(regiao), 1) <= nivel_jogador_atual())
  or is_mestre() or pode_ver('pontos_detalhe', id)
);

drop policy if exists "select_publico_ou_mestre" on "salas_dungeon";
create policy "select_publico_ou_mestre" on "salas_dungeon" for select using (
  (visivel = true and excluido = false and auth.role() = 'authenticated'
    and coalesce(nivel_da_dungeon(dungeon_id), 1) <= nivel_jogador_atual())
  or is_mestre() or pode_ver('salas_dungeon', id)
);

create or replace view pontos_publico as
select id, regiao, nome, categoria, x, y, tipo, ref, descricao, respawn_horas, teste,
  recompensa, ameaca, golpes, atributo_fraqueza, fala, oferece, vende, obs, visivel, updated_at,
  case when is_mestre() then mestre else null::text end as mestre
from pontos
where (visivel = true and excluido = false and auth.role() = 'authenticated'
        and coalesce(nivel_da_guia(regiao), 1) <= nivel_jogador_atual())
  or is_mestre() or pode_ver('pontos', id);

create or replace view pontos_detalhe_publico as
select id, nome, regiao, arquivo, leitura, oque, acoes, atalhos, visivel, updated_at,
  case when is_mestre() then mestre else null::text end as mestre
from pontos_detalhe
where (visivel = true and excluido = false and auth.role() = 'authenticated'
        and coalesce(nivel_da_guia(regiao), 1) <= nivel_jogador_atual())
  or is_mestre() or pode_ver('pontos_detalhe', id);
