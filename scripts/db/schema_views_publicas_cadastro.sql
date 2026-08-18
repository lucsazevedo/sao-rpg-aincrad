-- Bug relatado pelo usuário: no autocadastro (Cadastro.vue), os selects de
-- Profissão e Arma vinham vazios. Causa: as duas tabelas (oficios, armas)
-- têm RLS "select_publico_ou_mestre" que exige auth.role() = 'authenticated'
-- — faz sentido pro resto do Compêndio (que já pede login antes de
-- navegar), mas Cadastro.vue É o fluxo que leva de visitante anônimo pra
-- logado, então corre nesse meio-tempo como anon. Não dá pra simplesmente
-- abrir a RLS de "armas"/"oficios" pra anon (isso liberaria o Compêndio
-- inteiro sem login, mudança maior do que o pedido). Solução mesma do
-- resto do banco: view separada, owner (postgres) ignora a RLS da tabela
-- base, e a própria view decide o que é seguro mostrar antes de logar —
-- só nome/atributo de ofício e nome/id de arma Comum, nada sensível.
create or replace view oficios_signup_publico as
  select nome, atributo from oficios where visivel = true and excluido = false;
grant select on oficios_signup_publico to anon, authenticated;

create or replace view armas_comuns_signup_publico as
  select id, nome from armas where visivel = true and excluido = false and raridade = 'Comum';
grant select on armas_comuns_signup_publico to anon, authenticated;

-- Mesmo problema em FichaPublica.vue (rota pública /personagem/:nome, sem
-- login): busca o nome da arma equipada, qualquer raridade — não só
-- Comum, que é o "kit inicial" do autocadastro. View separada porque o
-- alcance é diferente (todas as armas, não só as iniciais).
create or replace view armas_publico as
  select id, nome, tipo, raridade from armas where visivel = true and excluido = false;
grant select on armas_publico to anon, authenticated;
