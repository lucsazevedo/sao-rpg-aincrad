-- Item 3 do dolist: craftar_item ate aqui sempre inseria o resultado no
-- inventario com tipo='consumivel' e quantidade=1, fixo -- certo pras 128
-- receitas antigas (nenhuma tinha resultado_item_id nem produzia >1), mas
-- errado pras novas receitas de armadura/bota/luva/elmo/acessorio (precisam
-- tipo='equipamento' pra aparecer no boneco de equipar) e pras de municao
-- (produzem 10x/5x, nao 1x). Mesmo bug-pattern que aceitar_e_resolver_missao
-- teve corrigido nesta sessao (drop de equipamentos quebrava por causa de
-- coluna errada) -- aqui o sintoma era silencioso: craftava, ia pro
-- inventario, so que como tipo/qtd errados.
create or replace function public.craftar_item(p_receita_id text)
 returns text
 language plpgsql
 security definer
 set search_path to 'public'
as $function$
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
  v_bonus_ferramenta int := 0;
  v_tipo_resultado text;
  v_qtd_resultado int;
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

  if v_rec.requer_ferramenta_id is not null then
    if not exists (select 1 from personagem_ferramentas where personagem_nome = v_personagem and ferramenta_id = v_rec.requer_ferramenta_id) then
      return (select format('{"erro":"precisa da ferramenta: %s"}', nome) from ferramentas_oficio where id = v_rec.requer_ferramenta_id);
    end if;
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

  select coalesce(max(f.bonus_acao), 0) into v_bonus_ferramenta
    from personagem_ferramentas pf join ferramentas_oficio f on f.id = pf.ferramenta_id
    where pf.personagem_nome = v_personagem and f.profissao = v_rec.profissao;
  v_mod := v_mod + v_bonus_ferramenta;

  v_dados := array[(1 + floor(random()*6))::int, (1 + floor(random()*6))::int];
  v_soma := v_dados[1] + v_dados[2] + v_mod;

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

  -- PASSO 7 (patch item 3): descobre tipo real do resultado -- se
  -- resultado_item_id aponta pra um equipamentos, vira tipo='equipamento'
  -- (mesmo cascata usada em aceitar_e_resolver_missao pra drop); senao
  -- continua 'consumivel' como sempre foi. Quantidade usa resultado_qtd
  -- (default 1, mas municao/flecha produz 10x etc.)
  v_novo_item_inv_id := null;
  v_qtd_resultado := coalesce(v_rec.resultado_qtd, 1);
  if v_resultado <> 'falha' then
    v_tipo_resultado := 'consumivel';
    if v_rec.resultado_item_id is not null then
      if exists (select 1 from equipamentos where id = v_rec.resultado_item_id) then
        v_tipo_resultado := 'equipamento';
      elsif exists (select 1 from armas where id = v_rec.resultado_item_id) then
        v_tipo_resultado := 'arma';
      end if;
    end if;
    insert into inventario
      (personagem_nome, item_id, nome, tipo, quantidade, origem)
      values (v_personagem, v_rec.id, v_rec.nome_resultado, v_tipo_resultado, v_qtd_resultado, 'craft')
      returning id into v_novo_item_inv_id;
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
            format('craft_item %s %s (xp=%s soma=%s)', v_rec.id, v_resultado, v_xp_ganho, v_soma));

  v_resp := jsonb_build_object(
    'resultado', v_resultado,
    'dados', v_dados,
    'soma_com_mod', v_soma,
    'mod_pbta', v_mod, 'bonus_ferramenta', v_bonus_ferramenta,
    'xp', v_xp_ganho,
    'folego_gasto', v_folego_gasto,
    'materiais_consumidos', to_jsonb(v_materiais_usados),
    'item_inventario_id', v_novo_item_inv_id,
    'item_nome', v_rec.nome_resultado,
    'item_tipo', v_tipo_resultado,
    'item_qtd', v_qtd_resultado,
    'item_raridade', v_rec.resultado_raridade,
    'novo_nivel_profissao', v_novo_nivel,
    'ferramenta_danificada', v_ferramenta_danificada,
    'efeitos', v_rec.efeitos
  );
  return v_resp::text;
end $function$;
