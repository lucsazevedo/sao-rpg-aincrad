-- Pedido do usuário: (1) upload de verdade pra Logo do clã — e pro mesmo
-- padrão em qualquer campo de imagem do Compêndio (antes era só colar
-- URL), (2) aba de Recrutamento pra jogador sem clã pedir entrada, com
-- aprovação (mestre ou liderança do clã — cargo lider/oficial em
-- cla_autoridade, item 18B).

-- ======================================================================
-- 1) Storage: bucket público pras imagens enviadas pelo mestre
--    (logo de clã, e o campo "img" de npcs/monstros/armas/equipamentos
--    daqui pra frente — ver EditorEntidade.vue). Leitura pública (sem
--    isso a imagem não carrega no navegador do jogador), escrita só
--    mestre.
-- ======================================================================
insert into storage.buckets (id, name, public)
values ('compendio-imagens', 'compendio-imagens', true)
on conflict (id) do nothing;

alter table storage.objects enable row level security;

drop policy if exists "compendio_imagens_leitura_publica" on storage.objects;
create policy "compendio_imagens_leitura_publica" on storage.objects for select
  using (bucket_id = 'compendio-imagens');

drop policy if exists "compendio_imagens_escrita_mestre" on storage.objects;
create policy "compendio_imagens_escrita_mestre" on storage.objects for all
  using (bucket_id = 'compendio-imagens' and is_mestre())
  with check (bucket_id = 'compendio-imagens' and is_mestre());

-- ======================================================================
-- 2) clas: logo (imagem, separada do "simbolo" que é descrição em texto)
--    + flag de recrutamento
-- ======================================================================
alter table clas add column if not exists logo_url text;
alter table clas add column if not exists recrutando boolean not null default false;

create or replace view clas_publico as
  select nome, destaque, forca, necessidade, rival, rumor, status, resumo, bons,
         precisa, nao_admitem, proximo, atravessado, quests, aparecem, simbolo,
         logo_url, recrutando, reputacao, updated_at,
         case when is_mestre() then ganchos else null end as ganchos
  from clas
  where (visivel = true and excluido = false) or is_mestre() or pode_ver('clas', nome);

-- ======================================================================
-- 3) Pedidos de entrada em clã — fila de aprovação (mestre OU
--    lider/oficial do próprio clã, via cla_autoridade)
-- ======================================================================
create table if not exists cla_pedidos (
  id bigserial primary key,
  cla_nome text not null references clas(nome) on delete cascade,
  personagem_nome text not null references personagens(nome) on delete cascade,
  mensagem text,
  status text not null default 'pendente' check (status in ('pendente','aprovado','recusado','cancelado')),
  criado_em timestamptz not null default now(),
  resolvido_em timestamptz,
  resolvido_por uuid references auth.users(id)
);
-- só um pedido pendente por (clã, personagem) de cada vez
create unique index if not exists cla_pedidos_pendente_unico
  on cla_pedidos (cla_nome, personagem_nome) where (status = 'pendente');

alter table cla_pedidos enable row level security;
drop policy if exists "ve_proprio_ou_mestre_ou_lideranca" on cla_pedidos;
create policy "ve_proprio_ou_mestre_ou_lideranca" on cla_pedidos for select using (
  is_mestre()
  or exists (select 1 from personagens p where p.dono_id = auth.uid() and p.nome = cla_pedidos.personagem_nome)
  or exists (
    select 1 from personagens p
    where p.dono_id = auth.uid()
      and _cargo_do_personagem(cla_pedidos.cla_nome, p.nome) in ('lider','oficial')
  )
);
drop policy if exists "so_rpc_escreve" on cla_pedidos;
create policy "so_rpc_escreve" on cla_pedidos for all using (is_mestre()) with check (is_mestre());

-- Jogador sem clã pede entrada num clã que está recrutando.
create or replace function pedir_entrada_cla(p_cla_nome text, p_mensagem text default null)
returns text language plpgsql security definer set search_path = public as $$
declare v_personagem text; v_guilda text; v_cla clas%rowtype;
begin
  select nome, guilda into v_personagem, v_guilda from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;
  if v_guilda is not null and v_guilda <> '' then return '{"erro":"você já tem clã"}'; end if;

  select * into v_cla from clas where nome = p_cla_nome and visivel = true and excluido = false;
  if not found then return '{"erro":"clã não encontrado"}'; end if;
  if not coalesce(v_cla.recrutando, false) then return '{"erro":"esse clã não está recrutando no momento"}'; end if;

  if exists (select 1 from cla_pedidos where cla_nome = p_cla_nome and personagem_nome = v_personagem and status = 'pendente') then
    return '{"erro":"você já tem um pedido pendente pra esse clã"}';
  end if;

  insert into cla_pedidos (cla_nome, personagem_nome, mensagem) values (p_cla_nome, v_personagem, nullif(trim(p_mensagem), ''));
  return '{"ok":true,"mensagem":"Pedido enviado — aguarde aprovação do mestre ou da liderança do clã."}';
end;
$$;
grant execute on function pedir_entrada_cla(text, text) to authenticated;

-- Jogador cancela o próprio pedido pendente.
create or replace function cancelar_pedido_cla(p_pedido_id bigint)
returns text language plpgsql security definer set search_path = public as $$
declare v_personagem text; v_pedido cla_pedidos%rowtype;
begin
  select nome into v_personagem from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  select * into v_pedido from cla_pedidos where id = p_pedido_id;
  if not found then return '{"erro":"pedido não encontrado"}'; end if;
  if v_pedido.personagem_nome <> v_personagem then return '{"erro":"esse pedido não é seu"}'; end if;
  if v_pedido.status <> 'pendente' then return '{"erro":"pedido já foi resolvido"}'; end if;

  update cla_pedidos set status = 'cancelado', resolvido_em = now() where id = p_pedido_id;
  return '{"ok":true}';
end;
$$;
grant execute on function cancelar_pedido_cla(bigint) to authenticated;

-- Mestre ou lider/oficial do clã aprova/recusa um pedido pendente.
create or replace function responder_pedido_cla(p_pedido_id bigint, p_aprovar boolean)
returns text language plpgsql security definer set search_path = public as $$
declare v_pedido cla_pedidos%rowtype; v_meu_personagem text; v_meu_cargo text; v_guilda_atual text;
begin
  select * into v_pedido from cla_pedidos where id = p_pedido_id;
  if not found then return '{"erro":"pedido não encontrado"}'; end if;
  if v_pedido.status <> 'pendente' then return '{"erro":"pedido já foi resolvido"}'; end if;

  if not is_mestre() then
    select nome into v_meu_personagem from personagens where dono_id = auth.uid();
    v_meu_cargo := _cargo_do_personagem(v_pedido.cla_nome, v_meu_personagem);
    if v_meu_cargo is null or v_meu_cargo not in ('lider','oficial') then
      return '{"erro":"só o mestre ou a liderança do clã respondem pedidos"}';
    end if;
  end if;

  if not p_aprovar then
    update cla_pedidos set status = 'recusado', resolvido_em = now(), resolvido_por = auth.uid() where id = p_pedido_id;
    return '{"ok":true,"mensagem":"Pedido recusado."}';
  end if;

  select guilda into v_guilda_atual from personagens where nome = v_pedido.personagem_nome;
  if v_guilda_atual is not null and v_guilda_atual <> '' then
    update cla_pedidos set status = 'recusado', resolvido_em = now(), resolvido_por = auth.uid() where id = p_pedido_id;
    return '{"erro":"personagem já entrou em outro clã nesse meio tempo — pedido recusado automaticamente"}';
  end if;

  update personagens set guilda = v_pedido.cla_nome, updated_at = now() where nome = v_pedido.personagem_nome;
  insert into cla_autoridade (cla_nome, personagem_nome, cargo)
    values (v_pedido.cla_nome, v_pedido.personagem_nome, 'membro')
    on conflict (cla_nome, personagem_nome) do nothing;
  update cla_pedidos set status = 'aprovado', resolvido_em = now(), resolvido_por = auth.uid() where id = p_pedido_id;
  return '{"ok":true,"mensagem":"Pedido aprovado — personagem entrou no clã."}';
end;
$$;
grant execute on function responder_pedido_cla(bigint, boolean) to authenticated;
