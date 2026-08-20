-- ============================================================================
-- MIGRAÇÃO PRA D&D 5e -- PARTE 4: atacar_chefe (combate cooperativo de boss)
-- ============================================================================
-- Mesma troca 2d6-staircase -> d20+mod+prof vs CD já aplicada em
-- combater_monstro (schema_migracao_dnd5e_rpcs.sql). Lógica de negócio ao
-- redor (dano ao chefe, trava de contribuintes mínimos, distribuição de
-- recompensa pra todo mundo que contribuiu) mantida idêntica.
-- ============================================================================

CREATE OR REPLACE FUNCTION public.atacar_chefe(p_monstro_id text)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_personagem text;
  v_m monstros%rowtype;
  v_chefe chefes_ativos%rowtype;
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
  v_dano_chefe int;
  v_vida_jog_nova int;
  v_arma_atributo text;
  v_bonus_fraqueza int := 0;
  v_contribuintes int;
  v_resp jsonb;
  v_xp_total int;
  v_col_total int;
  v_contrib record;
begin
  select nome into v_personagem from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  select * into v_m from monstros where id = p_monstro_id and visivel=true and excluido=false;
  if not found then return '{"erro":"monstro invalido"}'; end if;
  if v_m.ameaca not in ('elite','chefe') then
    return '{"erro":"esse monstro nao e chefe/miniboss -- use combater_monstro"}';
  end if;

  select vida_atual into v_vida_jog_nova from personagens where nome = v_personagem;
  if v_vida_jog_nova <= 0 then
    return '{"erro":"sem vida — cure na Estalagem antes de lutar de novo"}';
  end if;

  select * into v_chefe from chefes_ativos where monstro_id = p_monstro_id and not derrotado order by criado_em desc limit 1;
  if not found then
    insert into chefes_ativos (monstro_id, vida_max, vida_atual)
      values (p_monstro_id, coalesce(v_m.chefe_vida_max, 200), coalesce(v_m.chefe_vida_max, 200))
      returning * into v_chefe;
  end if;

  v_nivel_monstro := coalesce(nullif(substring(split_part(v_m.nivel_recomendado, '(', 1) from '\d+'), '')::int, 1);
  v_custo_folego := greatest(1, ceil(v_nivel_monstro / 3.0)::int);

  if not exists (select 1 from personagens where nome = v_personagem and folego >= v_custo_folego) then
    return format('{"erro":"folego insuficiente: precisa %s"}', v_custo_folego);
  end if;

  select coalesce(max(nivel), 1) into v_nivel_jog from nivel_profissao where personagem_nome = v_personagem;
  update personagens set folego = folego - v_custo_folego, updated_at = now() where nome = v_personagem;

  select a.atributo into v_arma_atributo from personagens p join armas a on a.id = p.arma where p.nome = v_personagem;
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
    v_resultado := 'falha'; v_vida_perdida := 8 + v_nivel_monstro * 2; v_dano_chefe := 0;
  elsif v_d20 = 20 or v_total >= v_cd + 5 then
    v_resultado := 'sucesso_total'; v_vida_perdida := 0; v_dano_chefe := 18 + v_nivel_monstro * 2;
  elsif v_total >= v_cd then
    v_resultado := 'sucesso_parcial'; v_vida_perdida := 3 + v_nivel_monstro; v_dano_chefe := 9 + v_nivel_monstro;
  else
    v_resultado := 'falha'; v_vida_perdida := 8 + v_nivel_monstro * 2; v_dano_chefe := 0;
  end if;

  if v_vida_perdida > 0 then
    update personagens set vida_atual = greatest(0, vida_atual - v_vida_perdida), vida_atualizada_em = now()
      where nome = v_personagem returning vida_atual into v_vida_jog_nova;
  end if;

  insert into chefes_contribuicoes (chefe_ativo_id, personagem_nome, dano_total, ataques, ultima_acao)
    values (v_chefe.id, v_personagem, v_dano_chefe, 1, now())
    on conflict (chefe_ativo_id, personagem_nome)
    do update set dano_total = chefes_contribuicoes.dano_total + v_dano_chefe,
                  ataques = chefes_contribuicoes.ataques + 1, ultima_acao = now();

  select count(*) into v_contribuintes from chefes_contribuicoes where chefe_ativo_id = v_chefe.id;

  if v_dano_chefe > 0 then
    if v_contribuintes >= v_m.min_contribuintes then
      update chefes_ativos set vida_atual = greatest(0, vida_atual - v_dano_chefe) where id = v_chefe.id
        returning * into v_chefe;
    else
      update chefes_ativos set vida_atual = greatest(1, vida_atual - v_dano_chefe) where id = v_chefe.id
        returning * into v_chefe;
    end if;
  end if;

  v_xp_total := 0; v_col_total := 0;

  if v_chefe.vida_atual <= 0 and not v_chefe.derrotado and v_contribuintes >= v_m.min_contribuintes then
    update chefes_ativos set derrotado = true, derrotado_em = now() where id = v_chefe.id returning * into v_chefe;
    v_xp_total := 40 + v_nivel_monstro * 8;
    v_col_total := 25 + v_nivel_monstro * 6;
    for v_contrib in select * from chefes_contribuicoes where chefe_ativo_id = v_chefe.id loop
      declare v_prof text; v_xp_novo int; v_prox int; v_subiu boolean; v_nv int; begin
        update personagens set col_mao = col_mao + v_col_total, updated_at = now() where nome = v_contrib.personagem_nome;
        insert into transacoes (de_personagem, para_personagem, tipo, valor, item_id, observacao)
          values (null, v_contrib.personagem_nome, 'combate', v_col_total, p_monstro_id,
                  format('chefe derrotado: %s (contribuiu %s de dano)', v_m.nome, v_contrib.dano_total));
        select profissao into v_prof from personagens where nome = v_contrib.personagem_nome;
        v_prof := coalesce(v_prof, 'Aventureiro');
        if not exists (select 1 from nivel_profissao where personagem_nome=v_contrib.personagem_nome and profissao=v_prof) then
          insert into nivel_profissao (personagem_nome, profissao, nivel, xp) values (v_contrib.personagem_nome, v_prof, 1, 0);
        end if;
        update nivel_profissao set xp = xp + v_xp_total, updated_at = now()
          where personagem_nome=v_contrib.personagem_nome and profissao=v_prof returning xp into v_xp_novo;
        <<sobe>> loop
          v_subiu := false;
          select nivel into v_nv from nivel_profissao where personagem_nome=v_contrib.personagem_nome and profissao=v_prof;
          select xp_necessario into v_prox from nivel_profissao_xp where nivel = v_nv + 1;
          exit sobe when v_prox is null;
          if v_xp_novo >= v_prox then
            update nivel_profissao set nivel=nivel+1, xp=xp-v_prox, updated_at=now()
              where personagem_nome=v_contrib.personagem_nome and profissao=v_prof returning xp into v_xp_novo;
            v_subiu := true;
          end if;
          exit sobe when not v_subiu;
        end loop sobe;
      end;
    end loop;
  end if;

  insert into combate_log (personagem_nome, monstro_id, monstro_nome, resultado, dados, vida_perdida, xp_ganho, col_ganho, folego_gasto)
    values (v_personagem, p_monstro_id, v_m.nome, v_resultado, v_dados, v_vida_perdida,
            case when v_chefe.derrotado then v_xp_total else 0 end,
            case when v_chefe.derrotado then v_col_total else 0 end, v_custo_folego);

  v_resp := jsonb_build_object(
    'resultado', v_resultado, 'dados', v_dados, 'd20', v_d20, 'cd', v_cd, 'total', v_total,
    'monstro_nome', v_m.nome, 'dano_causado', v_dano_chefe,
    'vida_perdida_jogador', v_vida_perdida, 'vida_jogador_atual', v_vida_jog_nova,
    'chefe_vida_atual', v_chefe.vida_atual, 'chefe_vida_max', v_chefe.vida_max,
    'contribuintes_distintos', v_contribuintes, 'min_contribuintes', v_m.min_contribuintes,
    'chefe_derrotado', v_chefe.derrotado,
    'xp_ganho', case when v_chefe.derrotado then v_xp_total else 0 end,
    'col_ganho', case when v_chefe.derrotado then v_col_total else 0 end,
    'bonus_fraqueza', v_bonus_fraqueza
  );
  return v_resp::text;
end;
$function$
;
