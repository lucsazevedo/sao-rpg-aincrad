-- Corrige aceitar_e_resolver_missao(): o ramo de drop de `equipamentos`
-- tentava ler a coluna "tipo" (equipamentos so tem "slot") -- quebrava a
-- funcao inteira sempre que o drop de qualquer missao nao-arma realmente
-- caia (achado 10/08, afetava 80 das 100 missoes). Tambem adiciona os
-- ramos que faltavam pra ovos_catalogo e cristais no mesmo resolvedor de
-- drop. Roda como CREATE OR REPLACE — idempotente.

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
  v_dados int[];
  v_soma int;
  v_dif int;
  v_resultado text;      -- sucesso_total / sucesso_parcial / falha
  v_col_ganho int;
  v_xp_ganho int;
  v_droppou boolean;
  v_drop_novo_id bigint;
  v_novo_nivel int;
  v_xp_subiu_nivel boolean;
  v_folego_gasto int;
  v_nova_md_id bigint;
  v_resp jsonb;
  v_drops_mat_ids bigint[];  -- ids dos drops de material adicionados (para resposta)
  v_novo_mat_id bigint;
begin
  -- 0) validar sessão
  select nome into v_personagem from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  -- 1) validar missão existe, visível, nível mínimo ok
  select * into v_m from missoes_quadro where id = p_missao_id and visivel=true and excluido=false;
  if not found then return '{"erro":"missao invalida"}'; end if;

  select nivel, xp into v_nivel, v_xp_atual
    from nivel_profissao where personagem_nome = v_personagem
    order by nivel desc limit 1;
  if v_nivel is null then v_nivel := 1; v_xp_atual := 0; end if;

  if v_m.nivel_min > v_nivel then
    return format('{"erro":"nivel minimo %s necessario (voce=%s)"}', v_m.nivel_min, v_nivel);
  end if;

  -- 2) validar fôlego
  if not exists (select 1 from personagens where nome = v_personagem and folego >= v_m.custo_folego) then
    return format('{"erro":"folego insuficiente: precisa %s"}', v_m.custo_folego);
  end if;

  -- 3) gastar fôlego
  update personagens
     set folego = folego - v_m.custo_folego, updated_at = now()
     where nome = v_personagem;
  v_folego_gasto := v_m.custo_folego;

  -- 4) calcular nível de dificuldade vs personagem → rolar 2d6 + modificador PBTA
  -- Fórmula de chance base (dif = personagem nivel - missao nivel_min):
  --   dif ≥ +2 → mod = +3
  --   dif = +1 → mod = +1
  --   dif = 0  → mod = 0
  --   dif = -1 → mod = -1
  --   dif ≤ -2 → mod = -3
  v_dif := v_nivel - v_m.nivel_min;
  declare v_mod int; begin
    v_mod := case
      when v_dif >= 2 then 3
      when v_dif = 1  then 1
      when v_dif = 0  then 0
      when v_dif = -1 then -1
      else -3
    end;
    v_dados := array[(1 + floor(random()*6))::int, (1 + floor(random()*6))::int];
    v_soma := v_dados[1] + v_dados[2] + v_mod;
  end;

  -- 5) aplicar resultado (PBTA 3 vias)
  if v_soma >= 10 then
    v_resultado := 'sucesso_total';
    v_xp_ganho := v_m.recompensa_xp;
    v_col_ganho := v_m.recompensa_col_min +
      floor(random() * (v_m.recompensa_col_max - v_m.recompensa_col_min + 1));
  elsif v_soma >= 7 then
    v_resultado := 'sucesso_parcial';
    v_xp_ganho := (v_m.recompensa_xp * 0.7)::int;
    v_col_ganho := ((v_m.recompensa_col_min + v_m.recompensa_col_max) / 2 * 0.8)::int;
  else
    v_resultado := 'falha';
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

  -- 6) DROPS: (a) especifico da missao + (b) generico de materiais SEMPRE (100% obtencao via drop, sem NPCs)
  v_drop_novo_id := null;
  v_drops_mat_ids := array[]::bigint[];

  -- (a) drop ESPECÍFICO (se a missao tem drop_item_id definido — arma/equip/carta etc)
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
          -- equipamentos NAO tem coluna "tipo" (tem "slot") -- ler coalesce(tipo,...)
          -- daqui quebrava a funcao inteira com "column tipo does not exist"
          -- sempre que um drop de missao caia nesse ramo (achado 10/08).
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
          -- se nao existir em nenhum catalogo, interpreta como material de craft (fallback)
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

  -- (b) drop GENÉRICO DE MATERIAIS DE CRAFT — sempre rola quando sucesso/parcial,
  --     garantindo regra #2: "só drop obtém TUDO, nenhuma dependência de NPC".
  --     Regras de roll:
  --       · Nível missão → raridade permitida (escala suave)
  --       · Tipo missão  → categoria preferencial (caca=animal, coleta=vegetal/mineral etc)
  --       · 1-3 materiais por missão (2 padrão, 1 em parcial, 3 só total alto nivel)
  --       · qtd por material: comum 3-8 / incomum 2-5 / raro 1-3 / épico 1-2 / lendário 1
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
      -- qtd de materiais a sortear: parcial = 1-2 / total = 2-3
      if v_resultado = 'sucesso_total' then
        v_qtd_mats := 2 + case when v_m.nivel_min >= 6 then 1 else 0 end;  -- +1 a partir de nv6 total
      else
        v_qtd_mats := 1 + case when v_m.nivel_min >= 8 then 1 else 0 end;  -- parcial = 1 ou 2
      end if;

      -- raridade permitida baseada em nivel_min da missao (escala progressiva, sem saltos)
      -- chance de raridade ALTA aumenta com sucesso_total (até 25%)
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
        else  -- nv 9-10
          v_rar_allowed := case when random() < v_chance_rar_alta
            then array['lendario'] else array['epico','lendario'] end;
      end case;

      -- categorias preferidas por TIPO de missão (categoria exata → mais provável)
      case coalesce(v_m.tipo, 'combate')
        when 'caca'                then v_cats_pref := array['animal','mineral','exotico'];
        when 'coleta'              then v_cats_pref := array['vegetal','mineral','quimico'];
        when 'oficio'              then v_cats_pref := array['mineral','tecido','quimico','vegetal'];
        when 'entrega'             then v_cats_pref := array['tecido','nobre','quimico'];
        when 'social'              then v_cats_pref := array['tecido','nobre','quimico','vegetal'];
        when 'contrato_arriscado'  then v_cats_pref := array['exotico','nobre','animal','lendario'];
        else                             v_cats_pref := array['mineral','animal','vegetal'];
      end case;

      -- loop para dropar cada material (não repete material na mesma missão)
      v_cont := 0;
      declare
        v_ja_usados text[] := array[]::text[];
      begin
        while v_cont < v_qtd_mats loop
          -- (i) escolhe uma raridade do pool permitido
          v_roll_rar := v_rar_allowed[1 + floor(random() * array_length(v_rar_allowed, 1))::int];

          -- (ii) 60% chance de usar categoria preferida, 40% qualquer outra
          if random() < 0.60 then
            v_roll_cat := v_cats_pref[1 + floor(random() * array_length(v_cats_pref, 1))::int];
            -- escolhe material com essa raridade E categoria preferida OU só raridade se não tiver
            select id, nome into v_roll_mat_id, v_roll_mat_nome
              from materiais_basicos
              where raridade = v_roll_rar and categoria = v_roll_cat
                and visivel and not excluido
                and id <> all (v_ja_usados)
              order by random() limit 1;
          else
            v_roll_cat := null;
          end if;
          -- fallback: só raridade, qualquer categoria
          if v_roll_mat_id is null then
            select id, nome into v_roll_mat_id, v_roll_mat_nome
              from materiais_basicos
              where raridade = v_roll_rar and visivel and not excluido
                and id <> all (v_ja_usados)
              order by random() limit 1;
          end if;

          if v_roll_mat_id is not null then
            -- quantidade baseada em raridade
            v_roll_qtd := case v_roll_rar
              when 'comum'    then 3 + floor(random() * 6)::int   -- 3..8
              when 'incomum'  then 2 + floor(random() * 4)::int   -- 2..5
              when 'raro'     then 1 + floor(random() * 3)::int   -- 1..3
              when 'epico'    then 1 + (random() < 0.4)::int      -- 1..2
              else 1                                              -- lendario = 1
            end;
            -- sucesso_total dá +50% na qtd (round up)
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
          -- evita loop infinito se faltar material
          exit when v_cont > 10;
        end loop;
      end;
    end;
  end if;

  -- 7) recompensas col e xp + subir nível
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

  -- 8) inserir transação log
  if v_col_ganho > 0 then
    insert into transacoes (de_personagem, para_personagem, tipo, valor, item_id, observacao)
      values (null, v_personagem, 'missao', v_col_ganho, v_m.drop_item_id,
              format('missao %s %s (xp=%s)', v_m.id, v_resultado, v_xp_ganho));
  end if;

  -- 9) salvar no histórico missao_diaria
  v_resp := jsonb_build_object(
    'resultado', v_resultado,
    'dados', v_dados,
    'soma_com_mod', v_soma,
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
