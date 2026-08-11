-- Achado testando ao vivo (11/08): três bugs reais e conectados no combate.
--
-- 1) "sistema de drop não funciona" / item 11 (chance independente por
--    entrada): o loop de drop de combater_monstro tinha um `exit;` logo
--    depois do primeiro item que rolasse com sucesso — ou seja, por mais
--    itens que a lista monstros.drops tivesse, só UM podia cair por combate,
--    sempre o primeiro da lista que passasse na própria chance. Removido:
--    agora cada entrada da lista rola a própria chance, independente das
--    outras (mesma regra que aceitar_e_resolver_missao já usa pros
--    materiais genéricos de missão).
--
-- 2) "domador... não tem o item Ferro Bruto" (mas mat_ferro_bruto EXISTE no
--    catálogo materiais_basicos, categoria mineral, comum): o loop de
--    combate nunca usava o catálogo real — ele inventava um item_id na hora
--    fazendo slug() do texto livre de monstros.drops->>'item'. Um monstro
--    dropando "Ferro" ou "Sucata de Ferro" virava 'mat_ferro' ou
--    'mat_sucata_de_ferro', nunca o 'mat_ferro_bruto' de verdade que as
--    receitas pedem — o jogador nunca conseguia craftar mesmo "tendo"
--    ferro. Corrigido: tenta casar o nome do drop com materiais_basicos
--    por nome antes de inventar id; só cai no id sintético se não achar
--    nada parecido no catálogo (loot puramente de flavor ainda funciona).
--
-- 3) "o drop de ovo não funciona": não existia NENHUM caminho pra um ovo
--    cair de combate — o loop de drops sempre inseria tipo='material',
--    então mesmo um monstro cujo texto de drop mencionasse "ovo" virava
--    material, nunca um item tipo='ovo' (o único tipo que chocar_ovo aceita
--    — ver CHECK em chocar_ovo: `where ... tipo = 'ovo'`). A tabela
--    ovos_catalogo já tem a coluna monstro_id ligando ovo a monstro
--    específico (ex.: ovo_lobo_alfa -> lobo_alfa) — só faltava usar essa
--    ligação. Adicionado: chance própria e independente de dropar o ovo
--    certo quando o monstro tem um ovos_catalogo correspondente, escalada
--    pela raridade do ovo (comum 15% / incomum 8% / raro 4% / épico 2% —
--    decisão de design documentada aqui, não existia número anterior pra
--    seguir).
--
-- Incubadora em si (craftar_ferramenta -> personagem_ferramentas,
-- chocar_ovo lendo personagem_ferramentas) já estava corretamente ligada
-- pelo id da receita == id da ferramenta (domador_ferramenta_n1 etc,
-- migração do item 14) — o problema real era só a origem do material E do
-- ovo, não a ferramenta em si.

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
  v_drop jsonb;
  v_drop_item text;
  v_drop_nome text;
  v_drop_qtd int;
  v_drop_inv_id bigint;
  v_vida_nova int;
  v_resp jsonb;
  v_arma_atributo text;
  v_bonus_fraqueza int := 0;
  v_cat_id text;
  v_cat_nome text;
  v_todos_drops jsonb := '[]'::jsonb;
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

  -- bônus de fraqueza (item 12, decisão do usuário: FIXO) — leva arma cujo
  -- atributo bate a fraqueza do monstro.
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

  -- drop de materiais: cada entrada de monstros.drops rola a PRÓPRIA chance,
  -- independente das outras (antes só a primeira que passasse contava).
  -- "Col" nos drops é o texto legado da mesa de RPG de verdade (moeda, não
  -- material) — o Col online já é dado por v_col_ganho acima; incluir de
  -- novo aqui como "item de inventário" era duplicar moeda como se fosse
  -- item craftável (só apareceu agora que a chance de cada entrada passou
  -- a ser independente — antes o bug do "só a primeira" quase sempre
  -- escondia isso).
  if v_resultado <> 'falha' and v_m.drops is not null then
    for v_drop in select * from jsonb_array_elements(v_m.drops) loop
      if trim(lower(coalesce(v_drop->>'item',''))) = 'col' then continue; end if;
      if random() < coalesce(nullif(substring(v_drop->>'chance' from '\d+\.?\d*'), '')::numeric / 100.0, 0.3) then
        v_drop_nome := v_drop->>'item';
        v_drop_qtd := coalesce(nullif(substring(v_drop->>'qtd' from '\d+'), '')::int, 1);

        -- tenta casar com o catálogo real de materiais_basicos pelo nome,
        -- pra virar um item_id que as receitas de craft reconhecem de
        -- verdade (antes: id sempre inventado do texto livre, nunca batia
        -- com o mat_id esperado pelas receitas).
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
        if v_cat_id is not null then
          v_drop_item := v_cat_id; v_drop_nome := v_cat_nome;
        else
          v_drop_item := coalesce('mat_' || lower(regexp_replace(v_drop_nome, '[^a-zA-Z0-9]+', '_', 'g')), v_drop_nome);
        end if;

        insert into inventario (personagem_nome, item_id, nome, tipo, quantidade, origem)
          values (v_personagem, v_drop_item, v_drop_nome, 'material', v_drop_qtd, 'combate')
          returning id into v_drop_inv_id;
        v_todos_drops := v_todos_drops || jsonb_build_object('item', v_drop_nome, 'item_id', v_drop_item, 'qtd', v_drop_qtd, 'tipo', 'material');
      end if;
    end loop;
  end if;

  -- drop de ovo: independente dos materiais acima. Só existe se esse
  -- monstro tiver um ovo cadastrado pra ele em ovos_catalogo.monstro_id.
  -- Chance escalada pela raridade do ovo (não existia nenhum número antes,
  -- decisão de design nova: comum 15% / incomum 8% / raro 4% / épico 2%).
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
        v_todos_drops := v_todos_drops || jsonb_build_object('item', v_ovo_cat.nome, 'item_id', v_ovo_cat.id, 'qtd', 1, 'tipo', 'ovo');
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
    'drop_item', v_drop_nome, 'drops_todos', v_todos_drops, 'derrotado', (v_vida_nova <= 0), 'bonus_fraqueza', v_bonus_fraqueza
  );
  return v_resp::text;
end;
$function$
;
