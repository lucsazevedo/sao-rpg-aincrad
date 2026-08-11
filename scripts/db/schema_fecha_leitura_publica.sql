-- Achado 10/08 (usuário: "tem muita informação sendo exibida pra usuário
-- que não logou"): 9 tabelas tinham uma policy "leitura_publica" com
-- qual = true — QUALQUER UM na internet, sem login, lê a linha inteira
-- via REST (a anon key é pública, está no bundle JS). Não é só estética
-- de tela — é a política de RLS de verdade, o Vue nunca foi a proteção.
--
-- Modelo corrigido:
-- - inventario/nivel_profissao/criaturas_domadas/limit_breaker_contador:
--   já tinham policy "dono_gerencia" (dono OU mestre) — a leitura_publica
--   tornava essa policy inútil (RLS é OR entre policies). Removida a
--   leitura_publica, sobra só dono+mestre. Não tem motivo pra outro
--   jogador ou visitante ver a mochila/nível/pet/contador de alguém.
-- - cla_autoridade: idem, mas precisa de um substituto (não tinha policy
--   de leitura pra membro nenhuma) — membro do clã (ou mestre) agora lê
--   quem são os cargos do PRÓPRIO clã, mesmo padrão já usado em
--   cla_inventario.membros_leem_mestre_tudo.
-- - reputacao_personagem: idem, substituto = dono lê a própria reputação
--   (ou mestre) — Ficha.vue já mostra isso pro jogador, só nunca teve
--   policy correta, era só a leitura_publica genérica.
-- - metas_doacoes: fica pública pra qualquer LOGADO (não precisa ser
--   dono/mestre) — é um quadro de doação coletiva, transparência entre
--   jogadores faz sentido, só não pra quem nem tem conta.
-- - personagens: a policy "visivel=true" (fichas públicas entre
--   jogadores) ganha "AND autenticado" — visitante anônimo não vê mais
--   nenhuma ficha, jogador logado continua vendo as públicas normalmente.
--
-- NÃO mexido (revisado e considerado correto como está):
-- - vitrine: marketplace público de verdade, faz sentido navegar sem
--   conta, como olhar vitrine de loja antes de logar.
-- - metas_globais: quadro de metas comunitárias, não é dado de jogador
--   específico, é conteúdo de mundo — fica público.

drop policy if exists "leitura_publica" on "inventario";
drop policy if exists "leitura_publica" on "nivel_profissao";
drop policy if exists "leitura_publica" on "criaturas_domadas";
drop policy if exists "leitura_publica" on "limit_breaker_contador";

drop policy if exists "leitura_publica" on "cla_autoridade";
create policy "membro_ou_mestre_le" on "cla_autoridade" for select
  using (
    is_mestre()
    or exists (select 1 from personagens p where p.dono_id = auth.uid() and p.guilda = cla_autoridade.cla_nome)
  );

drop policy if exists "leitura_publica" on "reputacao_personagem";
create policy "dono_ou_mestre_le" on "reputacao_personagem" for select
  using (is_mestre() or e_dono_personagem(personagem_nome));

drop policy if exists "leitura_publica" on "metas_doacoes";
create policy "logado_le" on "metas_doacoes" for select
  using (auth.role() = 'authenticated' or is_mestre());

drop policy if exists "sel_publico_ou_privado_dono_mestre" on "personagens";
create policy "sel_publico_ou_privado_dono_mestre" on "personagens" for select
  using (
    (visivel = true and auth.role() = 'authenticated')
    or auth.role() = 'service_role'
    or is_mestre()
    or dono_id = auth.uid()
  );
