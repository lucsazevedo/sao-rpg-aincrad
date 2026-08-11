-- Item 17 do dolist — Combate assíncrono free-roam (atalho direto: clica
-- no monstro, ganha XP/drop na hora, sem missão no meio). Decisões
-- tomadas sem bloquear em pergunta (usuário pediu "faça tudo, eu reviso
-- depois"), registradas aqui pra revisão:
--
-- 1) Fôlego SEMPRE gasto (variável por nível do monstro); Vida só perde
--    em sucesso parcial/falha — "ambos" era a opção default do próprio
--    arquivo dolist/17.
-- 2) Resolução real continua PBTA ternário (10+/7-9/6-) igual a todo o
--    resto do jogo online (missão, craft) — não fui pro binário
--    vitória/derrota que o MD original sugeria, pra manter consistência
--    com aceitar_e_resolver_missao/craftar_item.
-- 3) "Chance %" mostrada ANTES do clique usa a fórmula exata do dolist/17
--    (função abaixo) — é só a prévia; a rolagem de verdade no servidor
--    usa o mesmo staircase de mod PBTA que as outras RPCs já usam
--    (consistência > fórmula nova).
-- 4) Vida máxima = 50 + (melhor nível de profissão − 1) × 5 (simplifiquei
--    a curva de exemplo do dolist/17, que não fechava uma fórmula única).
-- 5) SEM regeneração passiva por tempo — achei que fôlego (que o dolist/09
--    também descreve como regenerando "+1/30min") não tem NENHUM
--    mecanismo de regen implementado em lugar nenhum do banco hoje (só
--    RPC de comprar com Col). Não inventei regen pra vida sozinho quando
--    nem fôlego tem — os dois só recuperam via Estalagem (Col) por
--    enquanto. Registrar como pendência real, não decisão escondida.
-- 6) Derrota (vida chega a 0): fica com vida=0 até curar na Estalagem
--    (reaproveita o RPC de fôlego — ver `curar_estalagem` abaixo, cobre
--    os dois de uma vez); RPC de combate recusa novo combate com vida=0.

alter table personagens add column if not exists vida_max int not null default 50;
alter table personagens add column if not exists vida_atual int not null default 50;
alter table personagens add column if not exists vida_atualizada_em timestamptz not null default now();

create table if not exists combate_log (
  id bigserial primary key,
  personagem_nome text not null references personagens(nome) on delete cascade,
  monstro_id text not null,
  monstro_nome text not null,
  resultado text not null,          -- sucesso_total / sucesso_parcial / falha
  dados int[] not null,
  vida_perdida int not null default 0,
  xp_ganho int not null default 0,
  col_ganho int not null default 0,
  folego_gasto int not null default 0,
  drop_item_id text,
  drop_inventario_id bigint,
  criado_em timestamptz not null default now()
);

alter table combate_log enable row level security;
drop policy if exists "dono_ve" on combate_log;
create policy "dono_ve" on combate_log for select
  using (e_dono_personagem(personagem_nome) or is_mestre());
drop policy if exists "so_sistema_insere" on combate_log;
-- inserção só via RPC security definer (nunca direto pelo cliente) —
-- então nem precisa policy de insert pra authenticated; mestre pode
-- inserir manualmente se quiser corrigir um log.
create policy "so_sistema_insere" on combate_log for insert
  with check (is_mestre());

-- ---------------------------------------------------------------------
-- Chance % de exibição (prévia, ANTES do clique) — fórmula exata do
-- dolist/17_combate_assincrono_chance_vida.md.
-- ---------------------------------------------------------------------
create or replace function chance_combate_preview(p_nivel_jogador int, p_nivel_monstro int)
returns jsonb language sql immutable as $$
  select jsonb_build_object(
    'chance_vitoria', greatest(5, least(95,
      (50 + (p_nivel_jogador - p_nivel_monstro) * 7)
      + (25 - greatest(0, (p_nivel_jogador - p_nivel_monstro) * 2)) * 0.7
    )),
    'dif', p_nivel_jogador - p_nivel_monstro
  );
$$;

-- ---------------------------------------------------------------------
-- combater_monstro: o clique de verdade. Transação atômica única.
-- ---------------------------------------------------------------------
create or replace function combater_monstro(p_monstro_id text)
returns text language plpgsql security definer set search_path = public as $$
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
  -- atributo bate a fraqueza do monstro. Só dá pra calcular agora que
  -- monstros.atributo_fraqueza está populado (migração rodada 10/08).
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
    if not exists (select 1 from personagens p where p.nome = v_personagem) then null; end if;
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

  -- drop: usa monstros.drops jsonb (já tem qtd/item/chance por entrada) —
  -- só em sucesso (total ou parcial), rola cada entrada pela própria chance.
  if v_resultado <> 'falha' and v_m.drops is not null then
    for v_drop in select * from jsonb_array_elements(v_m.drops) loop
      -- monstros.drops->>'chance' e' texto livre ("70%", "100% (Last Attack)",
      -- "só se efetivamente cercado" sem número nenhum) — extrai o primeiro
      -- número e trata como percentual; sem número achável, usa 30% default.
      if random() < coalesce(nullif(substring(v_drop->>'chance' from '\d+\.?\d*'), '')::numeric / 100.0, 0.3) then
        v_drop_nome := v_drop->>'item';
        v_drop_qtd := coalesce(nullif(substring(v_drop->>'qtd' from '\d+'), '')::int, 1);
        v_drop_item := coalesce('mat_' || lower(regexp_replace(v_drop_nome, '[^a-zA-Z0-9]+', '_', 'g')), v_drop_nome);
        insert into inventario (personagem_nome, item_id, nome, tipo, quantidade, origem)
          values (v_personagem, v_drop_item, v_drop_nome, 'material', v_drop_qtd, 'combate')
          returning id into v_drop_inv_id;
        exit; -- só o primeiro drop que rolar, pra nao chover item por clique
      end if;
    end loop;
  end if;

  insert into combate_log (personagem_nome, monstro_id, monstro_nome, resultado, dados, vida_perdida, xp_ganho, col_ganho, folego_gasto, drop_item_id, drop_inventario_id)
    values (v_personagem, p_monstro_id, v_m.nome, v_resultado, v_dados, v_vida_perdida, v_xp_ganho, v_col_ganho, v_custo_folego, v_drop_item, v_drop_inv_id);

  v_resp := jsonb_build_object(
    'resultado', v_resultado, 'dados', v_dados, 'soma_com_mod', v_soma,
    'monstro_nome', v_m.nome, 'vida_perdida', v_vida_perdida, 'vida_atual', v_vida_nova, 'vida_max', (select vida_max from personagens where nome=v_personagem),
    'xp_ganho', v_xp_ganho, 'col_ganho', v_col_ganho, 'folego_gasto', v_custo_folego,
    'drop_item', v_drop_nome, 'derrotado', (v_vida_nova <= 0), 'bonus_fraqueza', v_bonus_fraqueza
  );
  return v_resp::text;
end;
$$;
grant execute on function combater_monstro(text) to authenticated;
grant execute on function chance_combate_preview(int, int) to authenticated;

-- ---------------------------------------------------------------------
-- Cura na Estalagem (item 15) — estendida pra cobrir vida também, mesmo
-- padrão/preço do fôlego (10 Col = curar tudo).
-- ---------------------------------------------------------------------
create or replace function curar_estalagem()
returns text language plpgsql security definer set search_path = public as $$
declare v_personagem text; v_col int;
begin
  select nome, col_mao into v_personagem, v_col from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;
  if v_col < 10 then return '{"erro":"precisa de 10 Col"}'; end if;
  update personagens set col_mao = col_mao - 10, folego = 20, vida_atual = vida_max,
    vida_atualizada_em = now(), updated_at = now()
    where nome = v_personagem;
  insert into transacoes (de_personagem, para_personagem, tipo, valor, observacao)
    values (v_personagem, null, 'estalagem', 10, 'curou fôlego e vida na estalagem');
  return '{"ok":true,"folego":20,"vida":"cheia"}';
end;
$$;
grant execute on function curar_estalagem() to authenticated;

-- vida_max cresce com o melhor nível de profissão — recalculado sempre
-- que nivel_profissao mudar (trigger), pra nao depender do cliente lembrar.
create or replace function _recalcular_vida_max() returns trigger
language plpgsql security definer set search_path = public as $$
declare v_melhor int;
begin
  select coalesce(max(nivel),1) into v_melhor from nivel_profissao where personagem_nome = new.personagem_nome;
  update personagens set vida_max = 50 + (v_melhor - 1) * 5 where nome = new.personagem_nome;
  return new;
end;
$$;
drop trigger if exists recalcular_vida_max on nivel_profissao;
create trigger recalcular_vida_max
  after insert or update of nivel on nivel_profissao
  for each row execute function _recalcular_vida_max();
