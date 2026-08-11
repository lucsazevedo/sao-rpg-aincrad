-- Item 10 do dolist (Reputação — jogador e clã), decisão do usuário
-- (10/08): reputação de jogador cobre "o universo inteiro, principalmente
-- cidades, vilas e NPCs" — não só os 6 clãs. `reputacao_personagem` como
-- estava (coluna `cla_nome` com FK pra `clas`) não suportava isso; solto
-- daqui pra frente. Tabela estava vazia (0 linhas) — sem dado pra migrar.

alter table reputacao_personagem drop constraint if exists reputacao_personagem_cla_nome_fkey;
alter table reputacao_personagem rename column cla_nome to alvo_nome;
alter table reputacao_personagem add column if not exists alvo_tipo text not null default 'outro'
  check (alvo_tipo in ('cla','cidade','vila','npc','faccao','outro'));
comment on column reputacao_personagem.alvo_nome is
  'Nome livre — clã, cidade, vila, NPC, facção. Sem FK: reputação cobre qualquer entidade nomeada do mundo, não só os 6 clãs.';

-- mesma coisa em missoes_quadro: o "prêmio de reputação" de uma missão
-- também deixa de ser só-clã.
alter table missoes_quadro rename column reputacao_cla_nome to reputacao_alvo_nome;
alter table missoes_quadro add column if not exists reputacao_alvo_tipo text default 'outro'
  check (reputacao_alvo_tipo in ('cla','cidade','vila','npc','faccao','outro'));

-- ---------------------------------------------------------------------
-- Helper interno (SEM grant pra `authenticated`): só chamável por outras
-- funções SECURITY DEFINER do próprio schema (trigger de missão, RPC do
-- mestre abaixo). Clampa -3..+3, soma ao valor existente (upsert).
-- ---------------------------------------------------------------------
create or replace function _ajustar_reputacao_interna(
  p_personagem_nome text, p_alvo_nome text, p_delta int,
  p_alvo_tipo text default 'outro', p_motivo text default null
) returns int language plpgsql security definer set search_path = public as $$
declare v_novo int;
begin
  insert into reputacao_personagem (personagem_nome, alvo_nome, alvo_tipo, nivel, motivo)
    values (p_personagem_nome, p_alvo_nome, coalesce(p_alvo_tipo,'outro'),
            greatest(-3, least(3, p_delta)), p_motivo)
  on conflict (personagem_nome, alvo_nome) do update
    set nivel = greatest(-3, least(3, reputacao_personagem.nivel + p_delta)),
        alvo_tipo = coalesce(excluded.alvo_tipo, reputacao_personagem.alvo_tipo),
        motivo = coalesce(p_motivo, reputacao_personagem.motivo),
        ultima_alteracao = now(),
        updated_at = now()
  returning nivel into v_novo;
  return v_novo;
end;
$$;

-- RPC pública: só o mestre ajusta reputação diretamente (jogador não pode
-- se auto-promover). Ganho automático por missão vem do trigger abaixo.
create or replace function mestre_ajustar_reputacao(
  p_personagem_nome text, p_alvo_nome text, p_delta int,
  p_alvo_tipo text default 'outro', p_motivo text default null
) returns int language plpgsql security definer set search_path = public as $$
begin
  if not is_mestre() then
    raise exception 'só o mestre ajusta reputação diretamente';
  end if;
  return _ajustar_reputacao_interna(p_personagem_nome, p_alvo_nome, p_delta, p_alvo_tipo, p_motivo);
end;
$$;
grant execute on function mestre_ajustar_reputacao(text, text, int, text, text) to authenticated;

-- ---------------------------------------------------------------------
-- Ganho automático: quando uma missão com reputacao_alvo_nome/delta é
-- concluída (aceitar_e_resolver_missao insere direto em missao_diaria com
-- status final, não passa por update — então o gatilho é AFTER INSERT).
-- Só sucesso conta (aceitar_e_resolver_missao já grava status='expirou'
-- quando o resultado foi falha — ver resultado->>'resultado').
-- ---------------------------------------------------------------------
create or replace function trg_reputacao_por_missao() returns trigger
language plpgsql security definer set search_path = public as $$
declare v_m missoes_quadro%rowtype;
begin
  if new.status <> 'concluida' then return new; end if;
  select * into v_m from missoes_quadro where id = new.missao_id;
  if v_m.reputacao_alvo_nome is not null and coalesce(v_m.reputacao_delta,0) <> 0 then
    perform _ajustar_reputacao_interna(
      new.personagem_nome, v_m.reputacao_alvo_nome, v_m.reputacao_delta,
      coalesce(v_m.reputacao_alvo_tipo,'outro'),
      'missão: ' || coalesce(v_m.titulo, v_m.id)
    );
  end if;
  return new;
end;
$$;

drop trigger if exists reputacao_por_missao on missao_diaria;
create trigger reputacao_por_missao
  after insert on missao_diaria
  for each row execute function trg_reputacao_por_missao();

-- ========================= RLS =========================
-- DIFERENTE do padrão "dono_gerencia" do resto do banco de propósito:
-- reputação não é algo que o próprio jogador deveria conseguir editar
-- (senão ele se auto-promove). Só o mestre escreve direto; o ganho comum
-- vem do trigger acima, que roda como SECURITY DEFINER e ignora RLS.
-- Leitura continua pública (mesmo padrão de nivel_profissao etc).
alter table reputacao_personagem enable row level security;
drop policy if exists "dono_gerencia" on reputacao_personagem;
drop policy if exists "so_mestre_escreve" on reputacao_personagem;
create policy "so_mestre_escreve" on reputacao_personagem for all
  using (is_mestre()) with check (is_mestre());
drop policy if exists "leitura_publica" on reputacao_personagem;
create policy "leitura_publica" on reputacao_personagem for select using (true);
