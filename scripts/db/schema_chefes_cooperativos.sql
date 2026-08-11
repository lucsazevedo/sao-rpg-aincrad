-- Item 11 do dolist: miniboss/chefe exigindo grupo, mas adaptado ao jogo
-- ser ASSÍNCRONO (não existe "todo mundo online ao mesmo tempo" — cada
-- jogador ataca quando quiser, sozinho). Em vez de exigir N jogadores
-- simultâneos, o chefe vira um HP COMPARTILHADO: qualquer personagem pode
-- atacar a qualquer momento, mas ele só cai quando (a) a vida chegar a
-- zero E (b) pelo menos `min_contribuintes` personagens DIFERENTES já
-- tiverem batido nele em algum momento (contribuição cumulativa, não
-- simultânea).
--
-- Pedido original do usuário: miniboss=3, chefe=10 jogadores. Mantido
-- como default por tier de ameaça, mas guardado por MONSTRO (editável no
-- Compêndio do Mestre) — se o grupo real tiver menos gente que o número,
-- dá pra baixar por chefe específico sem mexer em código.

alter table monstros add column if not exists min_contribuintes integer not null default 1;
alter table monstros add column if not exists chefe_vida_max integer;

update monstros set min_contribuintes = 3, chefe_vida_max = 180 where ameaca = 'elite' and chefe_vida_max is null;
update monstros set min_contribuintes = 10, chefe_vida_max = 500 where ameaca = 'chefe' and chefe_vida_max is null;

create table if not exists chefes_ativos (
  id bigserial primary key,
  monstro_id text not null references monstros(id),
  vida_max integer not null,
  vida_atual integer not null,
  derrotado boolean not null default false,
  criado_em timestamptz not null default now(),
  derrotado_em timestamptz
);
create index if not exists idx_chefes_ativos_monstro on chefes_ativos(monstro_id) where not derrotado;

create table if not exists chefes_contribuicoes (
  id bigserial primary key,
  chefe_ativo_id bigint not null references chefes_ativos(id),
  personagem_nome text not null,
  dano_total integer not null default 0,
  ataques integer not null default 0,
  ultima_acao timestamptz not null default now(),
  unique(chefe_ativo_id, personagem_nome)
);

alter table chefes_ativos enable row level security;
alter table chefes_contribuicoes enable row level security;
drop policy if exists "leitura_publica" on "chefes_ativos";
create policy "leitura_publica" on chefes_ativos for select using (true);
drop policy if exists "leitura_publica" on "chefes_contribuicoes";
create policy "leitura_publica" on chefes_contribuicoes for select using (true);
-- escrita só via RPC (SECURITY DEFINER) — sem policy de INSERT/UPDATE pra
-- authenticated, mesmo padrão de combate_log/transacoes.

-- RPC principal: ataca um chefe/miniboss (monstros.ameaca in elite/chefe).
-- Mesma mecânica PBTA de combater_monstro (custo de fôlego, vida do
-- JOGADOR cai em parcial/falha, bônus de fraqueza de atributo) — a
-- diferença é que o dano em sucesso vai pro HP COMPARTILHADO do chefe,
-- não é resolvido na hora.
create or replace function public.atacar_chefe(p_monstro_id text)
returns text
language plpgsql
security definer
set search_path to 'public'
as $function$
declare
  v_personagem text;
  v_m monstros%rowtype;
  v_chefe chefes_ativos%rowtype;
  v_nivel_jog int;
  v_nivel_monstro int;
  v_custo_folego int;
  v_dif int;
  v_mod int;
  v_dados int[];
  v_soma int;
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

  -- pega o chefe ativo (cria um novo se não tiver nenhum em andamento)
  select * into v_chefe from chefes_ativos where monstro_id = p_monstro_id and not derrotado order by criado_em desc limit 1;
  if not found then
    insert into chefes_ativos (monstro_id, vida_max, vida_atual)
      values (p_monstro_id, coalesce(v_m.chefe_vida_max, 200), coalesce(v_m.chefe_vida_max, 200))
      returning * into v_chefe;
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
    select a.atributo into v_arma_atributo from personagens p join armas a on a.id = p.arma where p.nome = v_personagem;
    if v_arma_atributo = v_m.atributo_fraqueza then
      v_bonus_fraqueza := 1;
      v_mod := v_mod + v_bonus_fraqueza;
    end if;
  end if;

  v_dados := array[(1 + floor(random()*6))::int, (1 + floor(random()*6))::int];
  v_soma := v_dados[1] + v_dados[2] + v_mod;

  if v_soma >= 10 then
    v_resultado := 'sucesso_total'; v_vida_perdida := 0; v_dano_chefe := 18 + v_nivel_monstro * 2;
  elsif v_soma >= 7 then
    v_resultado := 'sucesso_parcial'; v_vida_perdida := 3 + v_nivel_monstro; v_dano_chefe := 9 + v_nivel_monstro;
  else
    v_resultado := 'falha'; v_vida_perdida := 8 + v_nivel_monstro * 2; v_dano_chefe := 0;
  end if;

  if v_vida_perdida > 0 then
    update personagens set vida_atual = greatest(0, vida_atual - v_vida_perdida), vida_atualizada_em = now()
      where nome = v_personagem returning vida_atual into v_vida_jog_nova;
  end if;

  -- registra contribuição (upsert) antes de aplicar dano, pra contar quem
  -- participou mesmo se o golpe não tirar vida nenhuma
  insert into chefes_contribuicoes (chefe_ativo_id, personagem_nome, dano_total, ataques, ultima_acao)
    values (v_chefe.id, v_personagem, v_dano_chefe, 1, now())
    on conflict (chefe_ativo_id, personagem_nome)
    do update set dano_total = chefes_contribuicoes.dano_total + v_dano_chefe,
                  ataques = chefes_contribuicoes.ataques + 1, ultima_acao = now();

  select count(*) into v_contribuintes from chefes_contribuicoes where chefe_ativo_id = v_chefe.id;

  if v_dano_chefe > 0 then
    -- trava a vida em 1 (não deixa "morrer" de verdade) enquanto não
    -- bater o mínimo de contribuintes distintos — impede um só jogador
    -- (ou poucos) zerarem o chefe sozinhos.
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
    -- recompensa TODO MUNDO que contribuiu, não só quem deu o golpe final
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
    'resultado', v_resultado, 'dados', v_dados, 'soma_com_mod', v_soma,
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
$function$;
