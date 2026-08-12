-- Pedido do usuário, 4 partes:
--
-- 1) "todas [profissões] precisam de ferramentas que são gastos no craft"
--    -> toda receita de ITEM (299 receitas, 16 profissões) agora exige
--    requer_ferramenta_id (script Python à parte fez o mapeamento nivel->
--    ferramenta e já rodou, ver histórico do chat). Aqui: a ferramenta
--    exigida tem chance real de ser CONSUMIDA (destruída) quando o craft
--    "danifica" a ferramenta — mecanismo que já existia como flag
--    (v_ferramenta_danificada) mas nunca fazia nada de verdade. Agora
--    remove a linha de personagem_ferramentas quando isso acontece,
--    forçando re-craftar (gastar material de novo) — é o "gasto" real.
--
-- 2) "para criar os itens e as ferramentas precisam ser dropadas" ->
--    catálogo de materiais tava 80% incompleto (203 de 251 mat_id usados
--    em receitas nem existiam em materiais_basicos — corrigido à parte,
--    ver script Python). Cobertura de monstro pra cada material vem no
--    próximo arquivo (schema_cobertura_drops_bestiario.sql).
--
-- 3) "cada drop tem um percentual, e é sorteado uma vez, [...] se o
--    usuário conseguir o drop de 20, ele vai conseguir junto o de 30 e
--    qualquer outro que tenha o percentual maior que 20%" -> mecânica
--    NOVA, substitui o "cada entrada rola a própria chance" da correção
--    anterior (schema_fix_drops_combate_ovo.sql). Agora é UM roll
--    compartilhado por eventos de combate, comparado contra o percentual
--    de CADA entrada — quem tem chance >= o roll "bate junto". Centralizado
--    numa função só (resolver_drops), pra não duplicar a lógica em vários
--    lugares.
--
-- 4) "isso em um lugar só, ajuste tudo ai" -> resolver_drops() é chamada
--    de combater_monstro; fica pronta pra qualquer outro lugar que precise
--    da mesma mecânica no futuro (ex. drop de chefe) sem reimplementar.

create or replace function public.resolver_drops(p_drops jsonb)
returns jsonb
language plpgsql
stable
as $$
declare
  v_roll numeric;
  v_chance numeric;
  v_drop jsonb;
  v_drop_nome text;
  v_drop_qtd int;
  v_cat_id text;
  v_cat_nome text;
  v_resultado jsonb := '[]'::jsonb;
begin
  if p_drops is null then return v_resultado; end if;

  -- UM roll só pra todo o evento (não por entrada) -- é essa a peça central
  -- do pedido: quem "bate" na entrada rara automaticamente bate em toda
  -- entrada de chance igual ou maior, porque é o MESMO número comparado.
  v_roll := random() * 100;

  for v_drop in select * from jsonb_array_elements(p_drops) loop
    -- "Col" é o texto legado da mesa de RPG de verdade (moeda), não
    -- material -- Col real já é dado à parte por v_col_ganho.
    if trim(lower(coalesce(v_drop->>'item',''))) = 'col' then continue; end if;

    v_chance := coalesce(nullif(substring(v_drop->>'chance' from '\d+\.?\d*'), '')::numeric, 30);
    if v_roll > v_chance then continue; end if;

    v_drop_nome := v_drop->>'item';
    v_drop_qtd := coalesce(nullif(substring(v_drop->>'qtd' from '\d+'), '')::int, 1);

    -- casa com o catálogo real de materiais_basicos pelo nome antes de
    -- inventar id -- senão nunca bate com o mat_id que as receitas pedem.
    v_cat_id := null;
    select id, nome into v_cat_id, v_cat_nome from materiais_basicos
      where visivel and not excluido and nome ilike v_drop_nome
      limit 1;
    if v_cat_id is null then
      select id, nome into v_cat_id, v_cat_nome from materiais_basicos
        where visivel and not excluido
          and (nome ilike '%'||v_drop_nome||'%' or v_drop_nome ilike '%'||nome||'%')
        order by length(nome) desc limit 1;
    end if;

    v_resultado := v_resultado || jsonb_build_object(
      'item', coalesce(v_cat_nome, v_drop_nome),
      'item_id', coalesce(v_cat_id, 'mat_' || lower(regexp_replace(v_drop_nome, '[^a-zA-Z0-9]+', '_', 'g'))),
      'qtd', v_drop_qtd,
      'chance_da_entrada', v_chance,
      'tipo', 'material'
    );
  end loop;

  return v_resultado;
end;
$$;

-- combater_monstro: troca o loop de drop independente por UMA chamada a
-- resolver_drops() (rolo único compartilhado), inserindo cada item que
-- bateu. Resto da função idêntico ao schema_fix_drops_combate_ovo.sql.
create or replace function public.combater_monstro(p_monstro_id text)
 returns text
 language plpgsql
 security definer
 set search_path to 'public'
as $function$
declare
  v_personagem text;
  v_m monstros%rowtype;
  v_nivel_jog int;
  v_nivel_monstro int;
  v_custo_folego int;
  v_dif int;
  v_mod int;
  v_dados int[];
  v_soma int;
  v_resultado text;
  v_vida_perdida int;
  v_xp_ganho int;
  v_col_ganho int;
  v_drop_item text;
  v_drop_nome text;
  v_drop_inv_id bigint;
  v_vida_nova int;
  v_resp jsonb;
  v_arma_atributo text;
  v_bonus_fraqueza int := 0;
  v_drops_resolvidos jsonb;
  v_drop_entry jsonb;
  v_ovo_cat ovos_catalogo%rowtype;
  v_chance_ovo numeric;
  v_drop_ovo_inv_id bigint;
begin
  select nome into v_personagem from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  select * into v_m from monstros where id = p_monstro_id and visivel=true and excluido=false;
  if not found then return '{"erro":"monstro invalido"}'; end if;

  select vida_atual into v_vida_nova from personagens where nome = v_personagem;
  if v_vida_nova <= 0 then
    return '{"erro":"sem vida — cure na Estalagem antes de lutar de novo"}';
  end if;

  v_nivel_monstro := coalesce(nullif(substring(v_m.nivel_recomendado from '\d+'), '')::int, 1);
  v_custo_folego := greatest(1, ceil(v_nivel_monstro / 3.0)::int);

  if not exists (select 1 from personagens where nome = v_personagem and folego >= v_custo_folego) then
    return format('{"erro":"folego insuficiente: precisa %s"}', v_custo_folego);
  end if;

  select coalesce(max(nivel), 1) into v_nivel_jog from nivel_profissao where personagem_nome = v_personagem;

  update personagens set folego = folego - v_custo_folego, updated_at = now() where nome = v_personagem;

  v_dif := v_nivel_jog - v_nivel_monstro;
  v_mod := case when v_dif >= 2 then 3 when v_dif = 1 then 1 when v_dif = 0 then 0 when v_dif = -1 then -1 else -3 end;

  if v_m.atributo_fraqueza is not null then
    select a.atributo into v_arma_atributo from personagens p
      join armas a on a.id = p.arma where p.nome = v_personagem;
    if v_arma_atributo = v_m.atributo_fraqueza then
      v_bonus_fraqueza := 1;
      v_mod := v_mod + v_bonus_fraqueza;
    end if;
  end if;

  v_dados := array[(1 + floor(random()*6))::int, (1 + floor(random()*6))::int];
  v_soma := v_dados[1] + v_dados[2] + v_mod;

  if v_soma >= 10 then
    v_resultado := 'sucesso_total'; v_vida_perdida := 0;
    v_xp_ganho := 10 + v_nivel_monstro * 4;
    v_col_ganho := 5 + v_nivel_monstro * 3;
  elsif v_soma >= 7 then
    v_resultado := 'sucesso_parcial'; v_vida_perdida := 3 + v_nivel_monstro;
    v_xp_ganho := (10 + v_nivel_monstro * 4) / 2;
    v_col_ganho := (5 + v_nivel_monstro * 3) / 2;
  else
    v_resultado := 'falha'; v_vida_perdida := 8 + v_nivel_monstro * 2;
    v_xp_ganho := 0; v_col_ganho := 0;
  end if;

  if v_vida_perdida > 0 then
    update personagens set vida_atual = greatest(0, vida_atual - v_vida_perdida), vida_atualizada_em = now()
      where nome = v_personagem
      returning vida_atual into v_vida_nova;
  else
    select vida_atual into v_vida_nova from personagens where nome = v_personagem;
  end if;

  if v_xp_ganho > 0 then
    declare v_prof text; v_xp_novo int; v_prox int; v_subiu boolean; v_nv int; begin
      select profissao into v_prof from personagens where nome = v_personagem;
      v_prof := coalesce(v_prof, 'Aventureiro');
      if not exists (select 1 from nivel_profissao where personagem_nome=v_personagem and profissao=v_prof) then
        insert into nivel_profissao (personagem_nome, profissao, nivel, xp) values (v_personagem, v_prof, 1, 0);
      end if;
      update nivel_profissao set xp = xp + v_xp_ganho, updated_at = now()
        where personagem_nome=v_personagem and profissao=v_prof returning xp into v_xp_novo;
      <<sobe>> loop
        v_subiu := false;
        select nivel into v_nv from nivel_profissao where personagem_nome=v_personagem and profissao=v_prof;
        select xp_necessario into v_prox from nivel_profissao_xp where nivel = v_nv + 1;
        exit sobe when v_prox is null;
        if v_xp_novo >= v_prox then
          update nivel_profissao set nivel=nivel+1, xp=xp-v_prox, updated_at=now()
            where personagem_nome=v_personagem and profissao=v_prof returning xp into v_xp_novo;
          v_subiu := true;
        end if;
        exit sobe when not v_subiu;
      end loop sobe;
    end;
  end if;

  if v_col_ganho > 0 then
    update personagens set col_mao = col_mao + v_col_ganho, updated_at = now() where nome = v_personagem;
    insert into transacoes (de_personagem, para_personagem, tipo, valor, item_id, observacao)
      values (null, v_personagem, 'combate', v_col_ganho, p_monstro_id, format('combate %s (%s)', v_m.nome, v_resultado));
  end if;

  -- drop: rolo único compartilhado (resolver_drops), não mais uma chance
  -- independente por entrada -- ver comentário no topo do arquivo.
  v_drops_resolvidos := '[]'::jsonb;
  if v_resultado <> 'falha' and v_m.drops is not null then
    v_drops_resolvidos := resolver_drops(v_m.drops);
    for v_drop_entry in select * from jsonb_array_elements(v_drops_resolvidos) loop
      insert into inventario (personagem_nome, item_id, nome, tipo, quantidade, origem)
        values (v_personagem, v_drop_entry->>'item_id', v_drop_entry->>'item', 'material',
                (v_drop_entry->>'qtd')::int, 'combate')
        returning id into v_drop_inv_id;
      v_drop_item := v_drop_entry->>'item_id';
      v_drop_nome := v_drop_entry->>'item';
    end loop;
  end if;

  -- drop de ovo: mecânica separada (não é uma lista de % — é uma chance
  -- única ligada a ovos_catalogo.monstro_id), continua com roll próprio.
  if v_resultado <> 'falha' then
    select * into v_ovo_cat from ovos_catalogo
      where monstro_id = p_monstro_id and visivel = true and excluido = false
      limit 1;
    if found then
      v_chance_ovo := case v_ovo_cat.raridade
        when 'comum' then 0.15 when 'incomum' then 0.08
        when 'raro' then 0.04 when 'epico' then 0.02 else 0.10 end;
      if random() < v_chance_ovo then
        insert into inventario (personagem_nome, item_id, nome, tipo, quantidade, origem)
          values (v_personagem, v_ovo_cat.id, v_ovo_cat.nome, 'ovo', 1, 'combate')
          returning id into v_drop_ovo_inv_id;
        v_drops_resolvidos := v_drops_resolvidos || jsonb_build_object('item', v_ovo_cat.nome, 'item_id', v_ovo_cat.id, 'qtd', 1, 'tipo', 'ovo');
        v_drop_nome := v_ovo_cat.nome;
        v_drop_inv_id := v_drop_ovo_inv_id;
        v_drop_item := v_ovo_cat.id;
      end if;
    end if;
  end if;

  insert into combate_log (personagem_nome, monstro_id, monstro_nome, resultado, dados, vida_perdida, xp_ganho, col_ganho, folego_gasto, drop_item_id, drop_inventario_id)
    values (v_personagem, p_monstro_id, v_m.nome, v_resultado, v_dados, v_vida_perdida, v_xp_ganho, v_col_ganho, v_custo_folego, v_drop_item, v_drop_inv_id);

  v_resp := jsonb_build_object(
    'resultado', v_resultado, 'dados', v_dados, 'soma_com_mod', v_soma,
    'monstro_nome', v_m.nome, 'vida_perdida', v_vida_perdida, 'vida_atual', v_vida_nova, 'vida_max', (select vida_max from personagens where nome=v_personagem),
    'xp_ganho', v_xp_ganho, 'col_ganho', v_col_ganho, 'folego_gasto', v_custo_folego,
    'drop_item', v_drop_nome, 'drops_todos', v_drops_resolvidos, 'derrotado', (v_vida_nova <= 0), 'bonus_fraqueza', v_bonus_fraqueza
  );
  return v_resp::text;
end;
$function$;

-- craftar_item: ferramenta exigida agora tem CHANCE REAL de ser consumida
-- (removida de personagem_ferramentas) quando o craft "danifica" ela --
-- v_ferramenta_danificada já existia, só nunca fazia nada. É o "gasto no
-- craft" pedido. Resto idêntico ao craftar_item já existente.
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
  v_ferramenta_consumida boolean := false;
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

  -- ferramenta gasta: só se a receita EXIGIA uma (requer_ferramenta_id) e o
  -- craft danificou -- some de personagem_ferramentas, jogador precisa
  -- craftar de novo (gastando material de novo) antes do próximo item.
  if v_ferramenta_danificada and v_rec.requer_ferramenta_id is not null then
    delete from personagem_ferramentas
      where personagem_nome = v_personagem and ferramenta_id = v_rec.requer_ferramenta_id;
    if found then v_ferramenta_consumida := true; end if;
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
    'ferramenta_consumida', v_ferramenta_consumida,
    'efeitos', v_rec.efeitos
  );
  return v_resp::text;
end $function$;
