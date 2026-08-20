-- ============================================================================
-- MIGRAÇÃO DO JOGO ONLINE PRA D&D 5e -- PARTE 2: RPCs
-- ============================================================================
-- Reescreve as 4 funções que faziam rolagem 2d6+staircase pra usar
-- d20+modificador de atributo+bônus de proficiência vs. CD (funções
-- auxiliares de scripts/db/schema_migracao_dnd5e.sql). Toda a lógica de
-- negócio ao redor (fôlego, drops, materiais, XP, ferramentas) foi mantida
-- IDÊNTICA -- só o bloco de rolagem e a banda de resultado mudam.
--
-- Rodar depois de schema_migracao_dnd5e.sql (via
-- scripts/db/_aplicar_migracao_dnd5e.py, que roda os dois em sequência).
-- ============================================================================

-- ==== combater_monstro ====
CREATE OR REPLACE FUNCTION public.combater_monstro(p_monstro_id text)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_personagem text;
  v_m monstros%rowtype;
  v_nivel_jog int;
  v_nivel_monstro int;
  v_custo_folego int;
  v_cd int;
  v_mod_attr int;
  v_bonus_prof int;
  v_d20 int;
  v_total int;
  v_dados int[];
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

  v_nivel_monstro := coalesce(nullif(substring(split_part(v_m.nivel_recomendado, '(', 1) from '\d+'), '')::int, 1);
  v_custo_folego := greatest(1, ceil(v_nivel_monstro / 3.0)::int);

  if not exists (select 1 from personagens where nome = v_personagem and folego >= v_custo_folego) then
    return format('{"erro":"folego insuficiente: precisa %s"}', v_custo_folego);
  end if;

  select coalesce(max(nivel), 1) into v_nivel_jog from nivel_profissao where personagem_nome = v_personagem;

  update personagens set folego = folego - v_custo_folego, updated_at = now() where nome = v_personagem;

  -- atributo de ataque da arma equipada (D&D 5e, já convertido) -- Seção 74:
  -- acertar com o atributo de fraqueza do monstro aproxima o "+1d6 de dano
  -- extra" (aqui, sistema de resolução em rolagem única) como um bônus fixo.
  select a.atributo into v_arma_atributo from personagens p
    join armas a on a.id = p.arma where p.nome = v_personagem;
  v_arma_atributo := coalesce(v_arma_atributo, 'Força');
  if v_m.atributo_fraqueza is not null and v_arma_atributo = v_m.atributo_fraqueza then
    v_bonus_fraqueza := 2;
  end if;

  v_cd := coalesce(v_m.cd_resistencia, cd_por_nivel_conteudo(v_nivel_monstro));
  v_mod_attr := mod_atributo_personagem(v_personagem, v_arma_atributo);
  v_bonus_prof := bonus_proficiencia_por_nivel(v_nivel_jog);
  v_d20 := (1 + floor(random()*20))::int;
  v_total := v_d20 + v_mod_attr + v_bonus_prof + v_bonus_fraqueza;
  v_dados := array[v_d20];

  if v_d20 = 1 then
    v_resultado := 'falha'; v_vida_perdida := 8 + v_nivel_monstro * 2;
    v_xp_ganho := 0; v_col_ganho := 0;
  elsif v_d20 = 20 or v_total >= v_cd + 5 then
    v_resultado := 'sucesso_total'; v_vida_perdida := 0;
    v_xp_ganho := 10 + v_nivel_monstro * 4;
    v_col_ganho := 5 + v_nivel_monstro * 3;
  elsif v_total >= v_cd then
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
    'resultado', v_resultado, 'dados', v_dados, 'd20', v_d20, 'cd', v_cd, 'total', v_total,
    'monstro_nome', v_m.nome, 'vida_perdida', v_vida_perdida, 'vida_atual', v_vida_nova, 'vida_max', (select vida_max from personagens where nome=v_personagem),
    'xp_ganho', v_xp_ganho, 'col_ganho', v_col_ganho, 'folego_gasto', v_custo_folego,
    'drop_item', v_drop_nome, 'drops_todos', v_drops_resolvidos, 'derrotado', (v_vida_nova <= 0), 'bonus_fraqueza', v_bonus_fraqueza
  );
  return v_resp::text;
end;
$function$
;

-- ==== aceitar_e_resolver_missao ====
CREATE OR REPLACE FUNCTION public.aceitar_e_resolver_missao(p_missao_id text)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_personagem text;
  v_m missoes_quadro%rowtype;
  v_nivel int;
  v_xp_atual int;
  v_cd int;
  v_mod_attr int;
  v_bonus_prof int;
  v_d20 int;
  v_total int;
  v_dados int[];
  v_atributo text;
  v_resultado text;
  v_col_ganho int;
  v_xp_ganho int;
  v_droppou boolean;
  v_drop_novo_id bigint;
  v_novo_nivel int;
  v_xp_subiu_nivel boolean;
  v_folego_gasto int;
  v_nova_md_id bigint;
  v_resp jsonb;
  v_drops_mat_ids bigint[];
  v_novo_mat_id bigint;
begin
  select nome into v_personagem from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  select * into v_m from missoes_quadro where id = p_missao_id and visivel=true and excluido=false;
  if not found then return '{"erro":"missao invalida"}'; end if;

  select nivel, xp into v_nivel, v_xp_atual
    from nivel_profissao where personagem_nome = v_personagem
    order by nivel desc limit 1;
  if v_nivel is null then v_nivel := 1; v_xp_atual := 0; end if;

  if v_m.nivel_min > v_nivel then
    return format('{"erro":"nivel minimo %s necessario (voce=%s)"}', v_m.nivel_min, v_nivel);
  end if;

  if not exists (select 1 from personagens where nome = v_personagem and folego >= v_m.custo_folego) then
    return format('{"erro":"folego insuficiente: precisa %s"}', v_m.custo_folego);
  end if;

  update personagens
     set folego = folego - v_m.custo_folego, updated_at = now()
     where nome = v_personagem;
  v_folego_gasto := v_m.custo_folego;

  -- d20 + modificador de atributo da profissão do personagem + bônus de
  -- proficiência (Seção 68/71 do SAO_RPG_5e.md) vs. CD derivada do nível
  -- mínimo da missão (Seção 29). Substitui o antigo 2d6+staircase de nível.
  select profissao into v_atributo from personagens where nome = v_personagem;
  v_atributo := coalesce((select atributo from profissoes_atributo where profissao = trim(v_atributo)), 'Sabedoria');
  v_cd := cd_por_nivel_conteudo(v_m.nivel_min);
  v_mod_attr := mod_atributo_personagem(v_personagem, v_atributo);
  v_bonus_prof := bonus_proficiencia_por_nivel(v_nivel);
  v_d20 := (1 + floor(random()*20))::int;
  v_total := v_d20 + v_mod_attr + v_bonus_prof;
  v_dados := array[v_d20];

  if v_d20 = 1 then
    v_resultado := 'falha';
  elsif v_d20 = 20 or v_total >= v_cd + 5 then
    v_resultado := 'sucesso_total';
  elsif v_total >= v_cd then
    v_resultado := 'sucesso_parcial';
  else
    v_resultado := 'falha';
  end if;

  if v_resultado = 'sucesso_total' then
    v_xp_ganho := v_m.recompensa_xp;
    v_col_ganho := v_m.recompensa_col_min +
      floor(random() * (v_m.recompensa_col_max - v_m.recompensa_col_min + 1));
  elsif v_resultado = 'sucesso_parcial' then
    v_xp_ganho := (v_m.recompensa_xp * 0.7)::int;
    v_col_ganho := ((v_m.recompensa_col_min + v_m.recompensa_col_max) / 2 * 0.8)::int;
  else
    v_xp_ganho := 0;
    v_col_ganho := 0;
    if v_m.penalidade_col_falha > 0 then
      update personagens
        set col_mao = greatest(0, col_mao - v_m.penalidade_col_falha), updated_at = now()
        where nome = v_personagem;
    end if;
    if v_m.penalidade_folego_falha > 0 then
      update personagens
        set folego = greatest(0, folego - v_m.penalidade_folego_falha), updated_at = now()
        where nome = v_personagem;
    end if;
  end if;

  v_drop_novo_id := null;
  v_drops_mat_ids := array[]::bigint[];

  if v_resultado <> 'falha' and v_m.drop_item_id is not null then
    v_droppou := random() < v_m.drop_chance;
    if v_droppou then
      declare
        v_drop_nome text;
        v_drop_tipo text;
      begin
        select nome, coalesce(tipo, 'arma') into v_drop_nome, v_drop_tipo
          from armas where id = v_m.drop_item_id;
        if not found then
          select nome, 'equipamento' into v_drop_nome, v_drop_tipo
            from equipamentos where id = v_m.drop_item_id;
        end if;
        if not found then
          select nome, 'carta' into v_drop_nome, v_drop_tipo
            from cartas where id = v_m.drop_item_id;
        end if;
        if not found then
          select nome, 'ovo' into v_drop_nome, v_drop_tipo
            from ovos_catalogo where id = v_m.drop_item_id;
        end if;
        if not found then
          select nome, 'cristal' into v_drop_nome, v_drop_tipo
            from cristais where id = v_m.drop_item_id;
        end if;
        if v_drop_nome is null then
          v_drop_nome := coalesce((select nome from materiais_basicos where id = v_m.drop_item_id), v_m.drop_item_id);
          v_drop_tipo := 'material';
        end if;
        insert into inventario
          (personagem_nome, item_id, nome, tipo, quantidade, origem)
          values (v_personagem, v_m.drop_item_id, v_drop_nome, v_drop_tipo, 1, 'missao')
          returning id into v_drop_novo_id;
        if v_drop_tipo = 'material' then
          v_drops_mat_ids := array_append(v_drops_mat_ids, v_drop_novo_id);
        end if;
      end;
    end if;
  end if;

  if v_resultado <> 'falha' then
    declare
      v_qtd_mats int;
      v_rar_allowed text[];
      v_cats_pref text[];
      v_roll_rar text;
      v_roll_cat text;
      v_roll_mat_id text;
      v_roll_mat_nome text;
      v_roll_qtd int;
      v_cont int;
      v_chance_rar_alta numeric;
    begin
      if v_resultado = 'sucesso_total' then
        v_qtd_mats := 2 + case when v_m.nivel_min >= 6 then 1 else 0 end;
      else
        v_qtd_mats := 1 + case when v_m.nivel_min >= 8 then 1 else 0 end;
      end if;

      v_chance_rar_alta := case v_resultado
        when 'sucesso_total' then 0.25 else 0.08 end;
      case
        when v_m.nivel_min <= 2 then
          v_rar_allowed := case when random() < v_chance_rar_alta
            then array['comum','incomum'] else array['comum'] end;
        when v_m.nivel_min between 3 and 4 then
          v_rar_allowed := case when random() < v_chance_rar_alta
            then array['incomum','raro'] else array['comum','incomum'] end;
        when v_m.nivel_min between 5 and 6 then
          v_rar_allowed := case when random() < v_chance_rar_alta
            then array['raro','epico'] else array['incomum','raro'] end;
        when v_m.nivel_min between 7 and 8 then
          v_rar_allowed := case when random() < v_chance_rar_alta
            then array['epico','lendario'] else array['raro','epico'] end;
        else
          v_rar_allowed := case when random() < v_chance_rar_alta
            then array['lendario'] else array['epico','lendario'] end;
      end case;

      case coalesce(v_m.tipo, 'combate')
        when 'caca'                then v_cats_pref := array['animal','mineral','exotico'];
        when 'coleta'              then v_cats_pref := array['vegetal','mineral','quimico'];
        when 'oficio'              then v_cats_pref := array['mineral','tecido','quimico','vegetal'];
        when 'entrega'             then v_cats_pref := array['tecido','nobre','quimico'];
        when 'social'              then v_cats_pref := array['tecido','nobre','quimico','vegetal'];
        when 'contrato_arriscado'  then v_cats_pref := array['exotico','nobre','animal','lendario'];
        else                             v_cats_pref := array['mineral','animal','vegetal'];
      end case;

      v_cont := 0;
      declare
        v_ja_usados text[] := array[]::text[];
      begin
        while v_cont < v_qtd_mats loop
          v_roll_rar := v_rar_allowed[1 + floor(random() * array_length(v_rar_allowed, 1))::int];

          if random() < 0.60 then
            v_roll_cat := v_cats_pref[1 + floor(random() * array_length(v_cats_pref, 1))::int];
            select id, nome into v_roll_mat_id, v_roll_mat_nome
              from materiais_basicos
              where raridade = v_roll_rar and categoria = v_roll_cat
                and visivel and not excluido
                and id <> all (v_ja_usados)
              order by random() limit 1;
          else
            v_roll_cat := null;
          end if;
          if v_roll_mat_id is null then
            select id, nome into v_roll_mat_id, v_roll_mat_nome
              from materiais_basicos
              where raridade = v_roll_rar and visivel and not excluido
                and id <> all (v_ja_usados)
              order by random() limit 1;
          end if;

          if v_roll_mat_id is not null then
            v_roll_qtd := case v_roll_rar
              when 'comum'    then 3 + floor(random() * 6)::int
              when 'incomum'  then 2 + floor(random() * 4)::int
              when 'raro'     then 1 + floor(random() * 3)::int
              when 'epico'    then 1 + (random() < 0.4)::int
              else 1
            end;
            if v_resultado = 'sucesso_total' then
              v_roll_qtd := ceil(v_roll_qtd * 1.5)::int;
            end if;

            insert into inventario
              (personagem_nome, item_id, nome, tipo, quantidade, origem)
              values (v_personagem, v_roll_mat_id, v_roll_mat_nome, 'material', v_roll_qtd, 'missao')
              returning id into v_novo_mat_id;
            v_drops_mat_ids := array_append(v_drops_mat_ids, v_novo_mat_id);
            v_ja_usados := array_append(v_ja_usados, v_roll_mat_id);
          end if;

          v_cont := v_cont + 1;
          exit when v_cont > 10;
        end loop;
      end;
    end;
  end if;

  if v_xp_ganho > 0 or v_col_ganho > 0 then
    if v_col_ganho > 0 then
      update personagens set col_mao = col_mao + v_col_ganho, updated_at = now()
        where nome = v_personagem;
    end if;
    if v_xp_ganho > 0 then
      declare
        v_prof text;
        v_xp_novo int;
        v_prox_nivel_xp int;
      begin
        select profissao into v_prof from personagens where nome = v_personagem;
        if v_prof is null then v_prof := 'Aventureiro'; end if;
        if not exists (select 1 from nivel_profissao
                        where personagem_nome = v_personagem and profissao = v_prof) then
          insert into nivel_profissao (personagem_nome, profissao, nivel, xp)
            values (v_personagem, v_prof, 1, 0);
        end if;
        update nivel_profissao
           set xp = xp + v_xp_ganho, updated_at = now()
         where personagem_nome = v_personagem and profissao = v_prof
         returning xp into v_xp_novo;
        v_novo_nivel := null;
        <<sobe_nivel>> loop
          v_xp_subiu_nivel := false;
          select coalesce(max(nivel), 1) into v_nivel from nivel_profissao
            where personagem_nome = v_personagem;
          select xp_necessario into v_prox_nivel_xp from nivel_profissao_xp
            where nivel = v_nivel + 1;
          exit sobe_nivel when v_prox_nivel_xp is null;
          if v_xp_novo >= v_prox_nivel_xp then
            update nivel_profissao
               set nivel = nivel + 1,
                   xp = xp - v_prox_nivel_xp,
                   updated_at = now()
             where personagem_nome = v_personagem and profissao = v_prof
             returning xp into v_xp_novo;
            v_xp_subiu_nivel := true;
            v_novo_nivel := coalesce(v_novo_nivel, v_nivel + 1);
          end if;
          exit sobe_nivel when not v_xp_subiu_nivel;
        end loop sobe_nivel;
      end;
    end if;
  end if;

  if v_col_ganho > 0 then
    insert into transacoes (de_personagem, para_personagem, tipo, valor, item_id, observacao)
      values (null, v_personagem, 'missao', v_col_ganho, v_m.drop_item_id,
              format('missao %s %s (xp=%s)', v_m.id, v_resultado, v_xp_ganho));
  end if;

  v_resp := jsonb_build_object(
    'resultado', v_resultado,
    'dados', v_dados, 'd20', v_d20, 'cd', v_cd, 'total', v_total,
    'xp', v_xp_ganho,
    'col', v_col_ganho,
    'drop_item_id', v_m.drop_item_id,
    'drop_inventario_id', v_drop_novo_id,
    'drops_materiais_inventario_ids', v_drops_mat_ids,
    'folego_gasto', v_folego_gasto,
    'novo_nivel', v_novo_nivel,
    'missao_titulo', v_m.titulo,
    'missao_tipo', v_m.tipo,
    'missao_nivel_min', v_m.nivel_min
  );
  insert into missao_diaria (personagem_nome, missao_id, status, aceita_em, concluida_em, resultado)
    values (v_personagem, p_missao_id,
            case when v_resultado='falha' then 'expirou' else 'concluida' end::text,
            now(), now(), v_resp)
    returning id into v_nova_md_id;

  return v_resp::text;
end $function$
;

-- ==== craftar_item ====
CREATE OR REPLACE FUNCTION public.craftar_item(p_receita_id text)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
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
  v_cd int;
  v_mod_attr int;
  v_bonus_prof int;
  v_d20 int;
  v_total int;
  v_dados int[];
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

  select coalesce(max(f.bonus_acao), 0) into v_bonus_ferramenta
    from personagem_ferramentas pf join ferramentas_oficio f on f.id = pf.ferramenta_id
    where pf.personagem_nome = v_personagem and f.profissao = v_rec.profissao;

  -- d20 + atributo da receita + proficiência (nível de profissão) + bônus
  -- de ferramenta + modificador de dificuldade da própria receita, vs. CD
  -- pelo nível da receita (Seção 29/68/71 do SAO_RPG_5e.md).
  v_cd := cd_por_nivel_conteudo(v_rec.nivel_receita) - coalesce(v_rec.dificuldade_mod, 0);
  v_mod_attr := mod_atributo_personagem(v_personagem, v_rec.atributo_teste);
  v_bonus_prof := bonus_proficiencia_por_nivel(v_nivel);
  v_d20 := (1 + floor(random()*20))::int;
  v_total := v_d20 + v_mod_attr + v_bonus_prof + v_bonus_ferramenta;
  v_dados := array[v_d20];

  if v_d20 = 1 then
    v_resultado := 'falha';
    v_xp_ganho := (v_rec.xp_recompensa * 0.1)::int;
    v_perda_mat := 0.5;
    if random() < 0.2 then v_ferramenta_danificada := true; end if;
  elsif v_d20 = 20 or v_total >= v_cd + 5 then
    v_resultado := 'sucesso_total';
    v_xp_ganho := v_rec.xp_recompensa;
    v_perda_mat := 0.0;
  elsif v_total >= v_cd then
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
            format('craft_item %s %s (xp=%s total=%s)', v_rec.id, v_resultado, v_xp_ganho, v_total));

  v_resp := jsonb_build_object(
    'resultado', v_resultado,
    'dados', v_dados, 'd20', v_d20, 'cd', v_cd, 'total', v_total,
    'bonus_ferramenta', v_bonus_ferramenta,
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
end $function$
;

-- ==== craftar_ferramenta ====
CREATE OR REPLACE FUNCTION public.craftar_ferramenta(p_receita_id text)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_personagem text;
  v_nivel int;
  v_xp_atual int;
  v_rec receitas%rowtype;
  v_mats jsonb;
  v_mat_elem jsonb;
  v_mat_id text;
  v_mat_qtd int;
  v_tem int;
  v_cd int;
  v_mod_attr int;
  v_bonus_prof int;
  v_d20 int;
  v_total int;
  v_dados int[];
  v_resultado text;
  v_xp_ganho int;
  v_folego_gasto int;
  v_perda_mat numeric;
  v_consumiu int;
  v_ja_consumidos text[];
  v_novo_nivel int;
  v_resp jsonb;
  v_materiais_usados jsonb[];
  v_ferramenta_danificada boolean := false;
  v_bonus_ferramenta int := 0;
begin
  select nome into v_personagem from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  select * into v_rec from receitas where id = p_receita_id and visivel=true and excluido=false;
  if not found then return '{"erro":"receita invalida"}'; end if;
  if v_rec.tipo <> 'ferramenta' then return '{"erro":"use craftar_item para itens"}'; end if;

  if v_rec.receita_refino and v_rec.receita_estagio = 2 then
    if v_rec.receita_antecessora_id is not null then
      if not exists (select 1 from personagem_ferramentas
                      where personagem_nome = v_personagem
                        and ferramenta_id = v_rec.receita_antecessora_id) then
        return format('{"erro":"precisa craftar %s (estagio 1) antes"}', v_rec.receita_antecessora_id);
      end if;
    end if;
  end if;

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

  select coalesce(max(f.bonus_acao), 0) into v_bonus_ferramenta
    from personagem_ferramentas pf join ferramentas_oficio f on f.id = pf.ferramenta_id
    where pf.personagem_nome = v_personagem and f.profissao = v_rec.profissao;

  v_cd := cd_por_nivel_conteudo(v_rec.nivel_receita) - coalesce(v_rec.dificuldade_mod, 0);
  v_mod_attr := mod_atributo_personagem(v_personagem, v_rec.atributo_teste);
  v_bonus_prof := bonus_proficiencia_por_nivel(v_nivel);
  v_d20 := (1 + floor(random()*20))::int;
  v_total := v_d20 + v_mod_attr + v_bonus_prof + v_bonus_ferramenta;
  v_dados := array[v_d20];

  if v_d20 = 1 then
    v_resultado := 'falha';
    v_xp_ganho := (v_rec.xp_recompensa * 0.15)::int;
    v_perda_mat := 0.45;
    if random() < 0.15 then v_ferramenta_danificada := true; end if;
  elsif v_d20 = 20 or v_total >= v_cd + 5 then
    v_resultado := 'sucesso_total';
    v_xp_ganho := v_rec.xp_recompensa;
    v_perda_mat := 0.0;
  elsif v_total >= v_cd then
    v_resultado := 'sucesso_parcial';
    v_xp_ganho := (v_rec.xp_recompensa * 0.75)::int;
    v_perda_mat := 0.15;
    if random() < 0.05 then v_ferramenta_danificada := true; end if;
  else
    v_resultado := 'falha';
    v_xp_ganho := (v_rec.xp_recompensa * 0.15)::int;
    v_perda_mat := 0.45;
    if random() < 0.15 then v_ferramenta_danificada := true; end if;
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

  if v_resultado <> 'falha' then
    insert into personagem_ferramentas
      (personagem_nome, ferramenta_id, obtido_em, updated_at)
      values (v_personagem, v_rec.id, now(), now())
    on conflict (personagem_nome, ferramenta_id) do update
      set updated_at = now();
    if v_rec.receita_refino and v_rec.receita_estagio = 2 and v_rec.receita_antecessora_id is not null then
      delete from personagem_ferramentas
        where personagem_nome = v_personagem and ferramenta_id = v_rec.receita_antecessora_id;
    end if;
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
            format('craft_ferramenta %s %s (xp=%s total=%s)', v_rec.id, v_resultado, v_xp_ganho, v_total));

  v_resp := jsonb_build_object(
    'resultado', v_resultado,
    'dados', v_dados, 'd20', v_d20, 'cd', v_cd, 'total', v_total,
    'bonus_ferramenta', v_bonus_ferramenta,
    'xp', v_xp_ganho,
    'folego_gasto', v_folego_gasto,
    'materiais_consumidos', to_jsonb(v_materiais_usados),
    'ferramenta_id', v_rec.id,
    'ferramenta_nome', v_rec.nome_resultado,
    'ferramenta_raridade', v_rec.resultado_raridade,
    'novo_nivel_profissao', v_novo_nivel,
    'ferramenta_danificada', v_ferramenta_danificada,
    'efeitos', v_rec.efeitos,
    'refino_substituiu_antecessora',
      (v_rec.receita_refino and v_rec.receita_estagio = 2)
  );
  return v_resp::text;
end $function$
;

-- ==== chance_combate_preview (recalculada pra d20) ====
CREATE OR REPLACE FUNCTION public.chance_combate_preview(p_nivel_jogador integer, p_nivel_monstro integer)
 RETURNS jsonb
 LANGUAGE sql
 IMMUTABLE
AS $function$
  select jsonb_build_object(
    'chance_vitoria', greatest(5, least(95,
      (21 - (cd_por_nivel_conteudo(p_nivel_monstro) -
             (bonus_proficiencia_por_nivel(p_nivel_jogador) +
              greatest(-2, least(4, p_nivel_jogador - p_nivel_monstro)))
      )) * 5
    )),
    'dif', p_nivel_jogador - p_nivel_monstro
  );
$function$
;
