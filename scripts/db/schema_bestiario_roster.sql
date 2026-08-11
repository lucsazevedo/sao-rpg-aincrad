-- Item 4 do dolist (Biomas/monstros até o Andar 50) — escopo decidido no
-- próprio arquivo: "só o roster extraído" é o tamanho pequeno/tratável
-- (virar ficha jogável completa pros ~350 monstros é projeto de vários
-- meses, não um item). Esta tabela é SÓ o roster (nome, bioma, categoria,
-- drops nomeados) — NÃO substitui `monstros` (fichas completas, hoje só
-- Andar 1+esqueleto Andar 2). Os dois convivem: quando um andar futuro
-- ganhar ficha de verdade, o monstro "sobe" de `bestiario_roster` pra
-- `monstros`.
create table if not exists bestiario_roster (
  id bigserial primary key,
  andar int not null,
  bioma text,
  categoria text not null check (categoria in ('comum','mini_boss','mvp','boss')),
  nome text not null,
  emoji text,
  materiais jsonb not null default '[]'::jsonb,
  cristais jsonb not null default '[]'::jsonb,   -- nomes; catálogo de verdade em `cristais`
  cartas jsonb not null default '[]'::jsonb,     -- nomes; catálogo de verdade em `cartas`
  visivel boolean not null default true,
  excluido boolean not null default false,
  updated_at timestamptz not null default now()
);

alter table bestiario_roster enable row level security;
drop policy if exists "select_publico_ou_mestre" on bestiario_roster;
create policy "select_publico_ou_mestre" on bestiario_roster for select
  using ((visivel = true and excluido = false) or is_mestre());
drop policy if exists "escrita_mestre" on bestiario_roster;
create policy "escrita_mestre" on bestiario_roster for all
  using (is_mestre()) with check (is_mestre());
