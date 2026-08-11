-- Item 2 do dolist — mecanismo do contador que destrava o Limit Breaker.
-- Decidido pelo usuário (10/08): contador POR ARMA EQUIPADA (não por
-- personagem) — trocar de arma não zera o progresso da anterior, cada
-- tipo de arma (as 23 de `moves_arma`) guarda o próprio número. Zera ao
-- USAR o Limit Breaker (não por sessão, não fica subindo pra sempre).
-- Limiar pra destravar = 10 (já estava definido em `dolist/02_ataques_limit_breaker.md`:
-- "ao bater 10, o jogador pode usar").
--
-- É ferramenta de mesa (combate tabletop não passa pelo site — o site só
-- resolve missão abstrata), por isso mestre-only pra escrever, jogador só
-- lê o próprio (mesmo padrão de nivel_profissao/criaturas_domadas).

create table if not exists limit_breaker_contador (
  personagem_nome text not null references personagens(nome) on delete cascade,
  arma_tipo text not null references moves_arma(nome) on delete cascade,
  contador int not null default 0 check (contador between 0 and 10),
  updated_at timestamptz not null default now(),
  primary key (personagem_nome, arma_tipo)
);

alter table limit_breaker_contador enable row level security;
drop policy if exists "dono_gerencia" on limit_breaker_contador;
create policy "dono_gerencia" on limit_breaker_contador for all
  using (e_dono_personagem(personagem_nome) or is_mestre())
  with check (e_dono_personagem(personagem_nome) or is_mestre());
drop policy if exists "leitura_publica" on limit_breaker_contador;
create policy "leitura_publica" on limit_breaker_contador for select using (true);
