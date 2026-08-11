-- Segue de `dolist/08_equipamento_inventario.md` — item marcado como
-- resolvido faltando esta peça: mochila vs. baú/stash de verdade (a
-- distinção não existia no schema, só no rascunho antigo do
-- Equipamentos.vue, que eu tinha desmontado por falta de coluna).
--
-- Simplificação assumida: item novo (drop de missão/combate/craft) entra
-- sempre em 'mochila' — não fiz o auto-roteamento "material vai direto
-- pro stash" que uma versão antiga do dolist sugeria, porque exigiria
-- editar de novo 4 RPCs grandes só pra isso; o jogador move manualmente
-- com um clique. Se preferir automático, é fácil ajustar depois.
alter table inventario add column if not exists local text not null default 'mochila'
  check (local in ('mochila', 'stash'));

create or replace function mover_inventario(p_inventario_id bigint, p_para text)
returns text language plpgsql security definer set search_path = public as $$
declare v_personagem text; v_it inventario%rowtype;
begin
  if p_para not in ('mochila', 'stash') then return '{"erro":"destino invalido"}'; end if;
  select nome into v_personagem from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  select * into v_it from inventario where id = p_inventario_id and personagem_nome = v_personagem and not excluido;
  if not found then return '{"erro":"item nao encontrado"}'; end if;
  if v_it.equipado and p_para = 'stash' then return '{"erro":"desequipe antes de guardar no bau"}'; end if;

  update inventario set local = p_para where id = p_inventario_id;
  return '{"ok":true}';
end;
$$;
grant execute on function mover_inventario(bigint, text) to authenticated;
