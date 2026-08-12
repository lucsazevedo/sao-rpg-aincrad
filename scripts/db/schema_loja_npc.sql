-- Pedido do usuário: "cade os vendedores npcs" / "pra eu comprar itens".
--
-- As tabelas mercado/mercado_itens (18 NPCs, 109 itens) são conteúdo de
-- MESA de verdade (preço "60% do valor", "10 Col por ponto revelado",
-- "grátis, se ele gostar de você", estoque por sessão, item falsificado no
-- Mercado Negro) — escrito pro mestre narrar ao vivo, não dá pra virar
-- botão de comprar automático sem inventar número que não existe.
--
-- Fonte real usada em vez disso: armas (54 linhas, 100% com preco) e
-- equipamentos (287 linhas, 74% com preco) já têm Col de catálogo de
-- verdade. RLS de nível já filtra o que cada jogador pode ver (mesma regra
-- de sempre — Comum=nv1, Incomum=nv3, Raro=nv6, Épico=nv8, Lendário=nv10),
-- então a loja de NPC naturalmente só oferece o que o personagem já
-- desbloqueou.
--
-- Achado no caminho, corrigido aqui: nenhum insert de equipamento em
-- inventario (missão, craft, e agora compra) preenchia a coluna "slot" —
-- Equipamentos.vue exige slot pra liberar o botão "Equipar", então
-- equipamento comprado (ou ganho) nunca dava pra equipar. Corrigido só
-- pra essa RPC nova (as outras origens continuam com o mesmo gap,
-- documentado — não é escopo desse pedido consertar todas agora).

create or replace function public.comprar_de_npc(p_tabela text, p_item_id text)
 returns text
 language plpgsql
 security definer
 set search_path to 'public'
as $function$
declare
  v_personagem text;
  v_col int;
  v_nome text;
  v_preco numeric;
  v_slot text;
  v_tipo text;
  v_inv_id bigint;
begin
  if p_tabela not in ('armas', 'equipamentos') then
    return '{"erro":"loja so vende armas ou equipamentos"}';
  end if;

  select nome into v_personagem from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  if p_tabela = 'armas' then
    select nome, preco into v_nome, v_preco from armas
      where id = p_item_id and visivel = true and excluido = false;
    v_slot := 'arma';
    v_tipo := 'arma';
  else
    select nome, preco, slot into v_nome, v_preco, v_slot from equipamentos
      where id = p_item_id and visivel = true and excluido = false;
    v_tipo := 'equipamento';
  end if;

  if v_nome is null then return '{"erro":"item nao encontrado ou nao disponivel pro seu nivel"}'; end if;
  if v_preco is null then return '{"erro":"esse item nao esta a venda (sem preco definido)"}'; end if;

  select col_mao into v_col from personagens where nome = v_personagem;
  if v_col < v_preco then
    return format('{"erro":"Col insuficiente: precisa %s, voce tem %s"}', v_preco, v_col);
  end if;

  update personagens set col_mao = col_mao - v_preco, updated_at = now() where nome = v_personagem;

  insert into inventario (personagem_nome, item_id, nome, tipo, quantidade, slot, origem)
    values (v_personagem, p_item_id, v_nome, v_tipo, 1,
            case when p_tabela = 'equipamentos' then v_slot else null end, 'compra_npc')
    returning id into v_inv_id;

  -- transacoes.tipo tem check constraint -- 'npc' já é um valor aceito
  -- (achado testando: 'compra_npc' não é, dava erro na hora de logar).
  insert into transacoes (de_personagem, para_personagem, tipo, valor, item_id, observacao)
    values (v_personagem, null, 'npc', v_preco::int, p_item_id, format('comprou %s de NPC', v_nome));

  return jsonb_build_object(
    'ok', true, 'item_nome', v_nome, 'preco_pago', v_preco,
    'col_restante', v_col - v_preco, 'inventario_id', v_inv_id
  )::text;
end;
$function$;
