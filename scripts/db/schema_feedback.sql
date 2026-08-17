-- Bug report + sugestões de melhoria, pedido do usuário junto com a
-- notícia de "beta aberto". Uma tabela só (tipo bug/sugestao) — os dois
-- são a mesma coisa no fundo (jogador escreve, mestre responde e muda
-- status), duplicar schema/RLS/RPC pros dois não valia a pena.
--
-- Não é conteúdo de jogo nem é público entre jogadores: cada um só vê os
-- próprios envios (mais o histórico de resposta do mestre); só o mestre
-- vê e responde tudo. Mesmo padrão de segurança de diario_entradas
-- (RPC security definer pro jogador escrever a própria linha, sem policy
-- de insert direta pra authenticated).
create table if not exists feedback (
  id bigserial primary key,
  tipo text not null check (tipo in ('bug', 'sugestao')),
  personagem_nome text references personagens(nome) on delete set null,
  titulo text not null,
  descricao text not null,
  pagina text, -- rota do site de onde foi enviado (contexto pro mestre)
  status text not null default 'aberto' check (status in ('aberto', 'em_analise', 'resolvido', 'recusado')),
  resposta_mestre text,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);

alter table feedback enable row level security;
drop policy if exists "ve_proprio_ou_mestre" on feedback;
create policy "ve_proprio_ou_mestre" on feedback for select using (
  is_mestre()
  or exists (select 1 from personagens p where p.dono_id = auth.uid() and p.nome = feedback.personagem_nome)
);
drop policy if exists "so_mestre_escreve" on feedback;
create policy "so_mestre_escreve" on feedback for all using (is_mestre()) with check (is_mestre());

-- Jogador envia o próprio bug/sugestão (RPC — sem policy de insert direta
-- pra authenticated, mesmo padrão de postar_diario_jogador).
create or replace function enviar_feedback(p_tipo text, p_titulo text, p_descricao text, p_pagina text default null)
returns text language plpgsql security definer set search_path = public as $$
declare v_personagem text;
begin
  if p_tipo not in ('bug', 'sugestao') then return '{"erro":"tipo inválido"}'; end if;
  select nome into v_personagem from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;
  if p_titulo is null or trim(p_titulo) = '' then return '{"erro":"informe um título"}'; end if;
  if p_descricao is null or trim(p_descricao) = '' then return '{"erro":"descreva o que aconteceu"}'; end if;

  insert into feedback (tipo, personagem_nome, titulo, descricao, pagina)
    values (p_tipo, v_personagem, trim(p_titulo), trim(p_descricao), nullif(p_pagina, ''));
  return '{"ok":true}';
end;
$$;
grant execute on function enviar_feedback(text, text, text, text) to authenticated;
