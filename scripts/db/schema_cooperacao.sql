-- Item 18 do dolist — Cooperação 30 jogadores (3 submódulos independentes).
-- Decisões tomadas sem bloquear em pergunta (usuário pediu "faça tudo,
-- revisa depois"), registradas pra revisão — todas seguem precedente já
-- decidido em itens irmãos (9/mercado: zero taxa; fôlego só em produção,
-- não em transferência):
--   1) Envio de Col: SEM taxa (100% chega, mesmo padrão do mercado).
--   2) Envio de item: SEM taxa/custo de postagem.
--   3) Clã continua OPCIONAL (`personagens.guilda` já é nullable hoje,
--      não criei obrigatoriedade nova).
--   4) Metas globais simultâneas: até 3 (sugestão do próprio dolist/18).
--   5) Doar pra meta: NÃO gasta Fôlego (mesmo raciocínio do mercado —
--      é mover recurso já ganho, não uma produção nova).
--   6) Recompensa: só quem doou qualquer quantidade recebe (não é
--      "todo mundo logado").

-- ======================================================================
-- 18A — Envios P2P (Col + item), RPCs atômicas
-- ======================================================================
create or replace function enviar_col(p_destinatario text, p_valor int)
returns text language plpgsql security definer set search_path = public as $$
declare v_remetente text; v_col_mao int;
begin
  if p_valor <= 0 then return '{"erro":"valor tem que ser positivo"}'; end if;
  select nome, col_mao into v_remetente, v_col_mao from personagens where dono_id = auth.uid();
  if v_remetente is null then return '{"erro":"sem personagem"}'; end if;
  if v_remetente = p_destinatario then return '{"erro":"não dá pra enviar pra si mesmo"}'; end if;
  if not exists (select 1 from personagens where nome = p_destinatario and excluido = false) then
    return '{"erro":"destinatário não existe"}';
  end if;
  if v_col_mao < p_valor then return format('{"erro":"col insuficiente: tem %s, precisa %s"}', v_col_mao, p_valor); end if;

  update personagens set col_mao = col_mao - p_valor, updated_at = now() where nome = v_remetente;
  update personagens set col_mao = col_mao + p_valor, updated_at = now() where nome = p_destinatario;
  insert into transacoes (de_personagem, para_personagem, tipo, valor, observacao)
    values (v_remetente, p_destinatario, 'transferencia', p_valor, 'envio P2P de Col');
  return format('{"ok":true,"mensagem":"Enviado %s Col para %s"}', p_valor, p_destinatario);
end;
$$;
grant execute on function enviar_col(text, int) to authenticated;

create or replace function enviar_item(p_destinatario text, p_inventario_id bigint, p_qtd int)
returns text language plpgsql security definer set search_path = public as $$
declare v_remetente text; v_it inventario%rowtype;
begin
  if p_qtd < 1 then return '{"erro":"quantidade tem que ser >= 1"}'; end if;
  select nome into v_remetente from personagens where dono_id = auth.uid();
  if v_remetente is null then return '{"erro":"sem personagem"}'; end if;
  if v_remetente = p_destinatario then return '{"erro":"não dá pra enviar pra si mesmo"}'; end if;
  if not exists (select 1 from personagens where nome = p_destinatario and excluido = false) then
    return '{"erro":"destinatário não existe"}';
  end if;

  select * into v_it from inventario where id = p_inventario_id and personagem_nome = v_remetente and not excluido;
  if not found then return '{"erro":"item não encontrado no seu inventário"}'; end if;
  if v_it.equipado then return '{"erro":"desequipe o item antes de enviar"}'; end if;
  if v_it.quantidade < p_qtd then return format('{"erro":"tem só %s, tentou enviar %s"}', v_it.quantidade, p_qtd); end if;

  if v_it.quantidade = p_qtd then
    update inventario set excluido = true where id = v_it.id;
  else
    update inventario set quantidade = quantidade - p_qtd where id = v_it.id;
  end if;
  insert into inventario (personagem_nome, item_id, nome, tipo, quantidade, slot, cristal_id, origem)
    values (p_destinatario, v_it.item_id, v_it.nome, v_it.tipo, p_qtd, null, v_it.cristal_id, 'envio');
  insert into transacoes (de_personagem, para_personagem, tipo, valor, item_id, observacao)
    values (v_remetente, p_destinatario, 'transferencia', p_qtd, v_it.item_id, format('envio de item: %s x%s', v_it.nome, p_qtd));
  return format('{"ok":true,"mensagem":"Enviado %s x%s para %s"}', v_it.nome, p_qtd, p_destinatario);
end;
$$;
grant execute on function enviar_item(text, bigint, int) to authenticated;

-- 'transferencia' precisa ser um tipo válido em transacoes (mesmo achado
-- do combate/estalagem — a lista antiga de tipos não previa isto).
alter table transacoes drop constraint if exists transacoes_tipo_check;
alter table transacoes add constraint transacoes_tipo_check check (
  tipo = any (array['missao','venda','compra','craft','bug','ajuste_mestre','npc','taxa',
                     'limite_diario','combate','estalagem','transferencia','meta_global'])
);

-- ======================================================================
-- 18B — Baú / Cofre do clã
-- ======================================================================
create table if not exists cla_inventario (
  id bigserial primary key,
  cla_nome text not null references clas(nome) on delete cascade,
  item_id text not null,
  nome text not null,
  tipo text,
  raridade text,
  qtd int not null default 1,
  liberado_para_membros boolean not null default false,
  depositado_por text references personagens(nome) on delete set null,
  depositado_em timestamptz not null default now(),
  excluido boolean not null default false
);

create table if not exists cla_autoridade (
  id bigserial primary key,
  cla_nome text not null references clas(nome) on delete cascade,
  personagem_nome text not null references personagens(nome) on delete cascade,
  cargo text not null check (cargo in ('lider','oficial','membro')),
  unique (cla_nome, personagem_nome)
);

create or replace function _cargo_do_personagem(p_cla_nome text, p_personagem_nome text)
returns text language sql stable security definer set search_path = public as $$
  select cargo from cla_autoridade where cla_nome = p_cla_nome and personagem_nome = p_personagem_nome;
$$;

create or replace function depositar_no_cla(p_inventario_id bigint)
returns text language plpgsql security definer set search_path = public as $$
declare v_personagem text; v_cla text; v_it inventario%rowtype;
begin
  select nome, guilda into v_personagem, v_cla from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;
  if v_cla is null then return '{"erro":"você não tem clã"}'; end if;

  select * into v_it from inventario where id = p_inventario_id and personagem_nome = v_personagem and not excluido;
  if not found then return '{"erro":"item não encontrado"}'; end if;
  if v_it.equipado then return '{"erro":"desequipe antes de depositar"}'; end if;

  if v_it.quantidade <= 1 then update inventario set excluido = true where id = v_it.id;
  else update inventario set quantidade = quantidade - 1 where id = v_it.id; end if;

  -- inventario nao tem coluna "raridade" (fica nos catalogos armas/equipamentos/etc, nao na linha do jogador)
  insert into cla_inventario (cla_nome, item_id, nome, tipo, qtd, depositado_por)
    values (v_cla, v_it.item_id, v_it.nome, v_it.tipo, 1, v_personagem);
  return '{"ok":true}';
end;
$$;
grant execute on function depositar_no_cla(bigint) to authenticated;

create or replace function retirar_do_cla(p_cla_inventario_id bigint)
returns text language plpgsql security definer set search_path = public as $$
declare v_personagem text; v_cla text; v_cargo text; v_it cla_inventario%rowtype;
begin
  select nome, guilda into v_personagem, v_cla from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  select * into v_it from cla_inventario where id = p_cla_inventario_id and not excluido;
  if not found then return '{"erro":"item não encontrado no baú"}'; end if;
  if v_it.cla_nome <> v_cla then return '{"erro":"esse baú não é do seu clã"}'; end if;

  v_cargo := coalesce(_cargo_do_personagem(v_cla, v_personagem), 'membro');
  if v_cargo = 'membro' and not v_it.liberado_para_membros then
    return '{"erro":"item travado — só oficial/líder retira (ou libera pra membros)"}';
  end if;

  update cla_inventario set excluido = true where id = v_it.id;
  insert into inventario (personagem_nome, item_id, nome, tipo, quantidade, origem)
    values (v_personagem, v_it.item_id, v_it.nome, coalesce(v_it.tipo,'material'), v_it.qtd, 'bau_cla');
  return '{"ok":true}';
end;
$$;
grant execute on function retirar_do_cla(bigint) to authenticated;

alter table cla_inventario enable row level security;
drop policy if exists "membros_leem_mestre_tudo" on cla_inventario;
create policy "membros_leem_mestre_tudo" on cla_inventario for select
  using (is_mestre() or exists (
    select 1 from personagens p where p.dono_id = auth.uid() and p.guilda = cla_inventario.cla_nome
  ));
drop policy if exists "so_rpc_escreve" on cla_inventario;
create policy "so_rpc_escreve" on cla_inventario for all using (is_mestre()) with check (is_mestre());

alter table cla_autoridade enable row level security;
drop policy if exists "leitura_publica" on cla_autoridade;
create policy "leitura_publica" on cla_autoridade for select using (true);
drop policy if exists "so_mestre_escreve" on cla_autoridade;
create policy "so_mestre_escreve" on cla_autoridade for all using (is_mestre()) with check (is_mestre());

-- ======================================================================
-- 18C — Metas globais do mestre
-- ======================================================================
create table if not exists metas_globais (
  id bigserial primary key,
  titulo text not null,
  descricao text,
  meta_item text not null,
  meta_qtd int not null check (meta_qtd > 0),
  progresso int not null default 0,
  recompensa_col int,
  recompensa_xp int,
  recompensa_item text,
  recompensa_reputacao_alvo_nome text,
  recompensa_reputacao_valor int,
  criado_por uuid references auth.users(id),
  criado_em timestamptz not null default now(),
  finalizada boolean not null default false,
  finalizada_em timestamptz,
  visivel boolean not null default true,
  excluido boolean not null default false
);

create table if not exists metas_doacoes (
  id bigserial primary key,
  meta_id bigint not null references metas_globais(id) on delete cascade,
  personagem_nome text not null references personagens(nome) on delete cascade,
  qtd_doada int not null check (qtd_doada > 0),
  doado_em timestamptz not null default now()
);

create or replace function criar_meta_global(
  p_titulo text, p_descricao text, p_meta_item text, p_meta_qtd int,
  p_recompensa_col int default null, p_recompensa_xp int default null,
  p_recompensa_item text default null,
  p_recompensa_reputacao_alvo_nome text default null, p_recompensa_reputacao_valor int default null
) returns text language plpgsql security definer set search_path = public as $$
declare v_abertas int;
begin
  if not is_mestre() then return '{"erro":"só o mestre cria meta global"}'; end if;
  select count(*) into v_abertas from metas_globais where finalizada = false and excluido = false;
  if v_abertas >= 3 then return '{"erro":"máximo 3 metas abertas ao mesmo tempo"}'; end if;
  insert into metas_globais (titulo, descricao, meta_item, meta_qtd, recompensa_col, recompensa_xp,
      recompensa_item, recompensa_reputacao_alvo_nome, recompensa_reputacao_valor, criado_por)
    values (p_titulo, p_descricao, p_meta_item, p_meta_qtd, p_recompensa_col, p_recompensa_xp,
      p_recompensa_item, p_recompensa_reputacao_alvo_nome, p_recompensa_reputacao_valor, auth.uid());
  return '{"ok":true}';
end;
$$;
grant execute on function criar_meta_global(text,text,text,int,int,int,text,text,int) to authenticated;

create or replace function doar_para_meta(p_meta_id bigint, p_inventario_id bigint, p_qtd int)
returns text language plpgsql security definer set search_path = public as $$
declare v_personagem text; v_meta metas_globais%rowtype; v_it inventario%rowtype; v_novo_progresso int;
begin
  if p_qtd < 1 then return '{"erro":"quantidade tem que ser >= 1"}'; end if;
  select nome into v_personagem from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  select * into v_meta from metas_globais where id = p_meta_id and visivel and not excluido;
  if not found then return '{"erro":"meta não encontrada"}'; end if;
  if v_meta.finalizada then return '{"erro":"meta já concluída"}'; end if;

  select * into v_it from inventario where id = p_inventario_id and personagem_nome = v_personagem and not excluido;
  if not found then return '{"erro":"item não encontrado no seu inventário"}'; end if;
  if v_it.nome <> v_meta.meta_item and v_it.item_id <> v_meta.meta_item then
    return format('{"erro":"essa meta pede %s"}', v_meta.meta_item);
  end if;
  if v_it.quantidade < p_qtd then return format('{"erro":"tem só %s"}', v_it.quantidade); end if;

  if v_it.quantidade = p_qtd then update inventario set excluido = true where id = v_it.id;
  else update inventario set quantidade = quantidade - p_qtd where id = v_it.id; end if;

  insert into metas_doacoes (meta_id, personagem_nome, qtd_doada) values (p_meta_id, v_personagem, p_qtd);
  update metas_globais set progresso = least(meta_qtd, progresso + p_qtd) where id = p_meta_id
    returning progresso into v_novo_progresso;

  if v_novo_progresso >= v_meta.meta_qtd then
    perform premiar_meta(p_meta_id);
  end if;
  return format('{"ok":true,"progresso":%s,"meta_qtd":%s}', v_novo_progresso, v_meta.meta_qtd);
end;
$$;
grant execute on function doar_para_meta(bigint, bigint, int) to authenticated;

create or replace function premiar_meta(p_meta_id bigint)
returns text language plpgsql security definer set search_path = public as $$
declare v_meta metas_globais%rowtype; v_doador record;
begin
  select * into v_meta from metas_globais where id = p_meta_id;
  if not found or v_meta.finalizada then return '{"erro":"nada a premiar"}'; end if;

  for v_doador in select distinct personagem_nome from metas_doacoes where meta_id = p_meta_id loop
    if v_meta.recompensa_col > 0 then
      update personagens set col_mao = col_mao + v_meta.recompensa_col, updated_at = now() where nome = v_doador.personagem_nome;
      insert into transacoes (de_personagem, para_personagem, tipo, valor, observacao)
        values (null, v_doador.personagem_nome, 'meta_global', v_meta.recompensa_col, 'recompensa meta: ' || v_meta.titulo);
    end if;
    if v_meta.recompensa_xp > 0 then
      declare v_prof text; begin
        select profissao into v_prof from personagens where nome = v_doador.personagem_nome;
        v_prof := coalesce(v_prof, 'Aventureiro');
        if not exists (select 1 from nivel_profissao where personagem_nome = v_doador.personagem_nome and profissao = v_prof) then
          insert into nivel_profissao (personagem_nome, profissao, nivel, xp) values (v_doador.personagem_nome, v_prof, 1, 0);
        end if;
        update nivel_profissao set xp = xp + v_meta.recompensa_xp, updated_at = now()
          where personagem_nome = v_doador.personagem_nome and profissao = v_prof;
      end;
    end if;
    if v_meta.recompensa_item is not null then
      insert into inventario (personagem_nome, item_id, nome, tipo, quantidade, origem)
        values (v_doador.personagem_nome, v_meta.recompensa_item, v_meta.recompensa_item, 'material', 1, 'meta_global');
    end if;
    if v_meta.recompensa_reputacao_alvo_nome is not null and coalesce(v_meta.recompensa_reputacao_valor,0) <> 0 then
      perform _ajustar_reputacao_interna(v_doador.personagem_nome, v_meta.recompensa_reputacao_alvo_nome,
        v_meta.recompensa_reputacao_valor, 'outro', 'recompensa meta: ' || v_meta.titulo);
    end if;
  end loop;

  update metas_globais set finalizada = true, finalizada_em = now() where id = p_meta_id;
  return '{"ok":true}';
end;
$$;
grant execute on function premiar_meta(bigint) to authenticated;

alter table metas_globais enable row level security;
drop policy if exists "leitura_publica" on metas_globais;
create policy "leitura_publica" on metas_globais for select using (visivel = true or is_mestre());
drop policy if exists "so_mestre_escreve" on metas_globais;
create policy "so_mestre_escreve" on metas_globais for all using (is_mestre()) with check (is_mestre());

alter table metas_doacoes enable row level security;
drop policy if exists "leitura_publica" on metas_doacoes;
create policy "leitura_publica" on metas_doacoes for select using (true);
drop policy if exists "so_rpc_escreve" on metas_doacoes;
create policy "so_rpc_escreve" on metas_doacoes for all using (is_mestre()) with check (is_mestre());
