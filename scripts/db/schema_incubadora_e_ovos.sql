-- Item 1 do dolist (Domador → Criador). Achado numa varredura (10/08): a
-- mecânica inteira já estava construída (chocar_ovo/verificar_chocagem,
-- ovos_catalogo com 12 ovos, receitas de Incubadora com 4 estágios,
-- PetsTab.vue funcional) — só faltavam duas pontas soltas:
--
-- 1) ferramentas_oficio (de onde chocar_ovo lê o nível da incubadora) não
--    tinha NENHUMA linha — craftar uma Incubadora "funcionava" (upsert em
--    personagem_ferramentas) mas o nível nunca aparecia em lugar nenhum,
--    então todo Domador ficava travado no nível 1 pra sempre (coalesce
--    default), mesmo tendo craftado a versão Sagrada/Primordial.
-- 2) Nenhuma missão tinha `drop_item_id` apontando pra um ovo — não havia
--    como conseguir o primeiro ovo pra começar o ciclo.

-- ---------------------------------------------------------------------
-- 0) Achado testando: criaturas_domadas.monstro_id tinha FK pra monstros,
-- mas 10 dos 12 ovos_catalogo.monstro_id são espécie "roster" (nome já
-- existe pro item 4 — biomas/monstros até andar 50 — mas ficha jogável
-- completa em `monstros` ainda não foi escrita, é GG de conteúdo à parte).
-- Isso quebrava chocar_ovo com FK violation pra 10 de 12 ovos. Solta:
-- pet não devia depender de o monstro de origem já ter ficha de combate.
-- ---------------------------------------------------------------------
alter table criaturas_domadas drop constraint if exists criaturas_domadas_monstro_id_fkey;

-- ---------------------------------------------------------------------
-- 1) Catálogo da Incubadora — os 4 estágios que já tinham receita em
-- `receitas` (domador_ferramenta_n1/n2/n5/n5_ref), usando o MESMO id da
-- receita como id aqui (é o que craftar_ferramenta grava em
-- personagem_ferramentas.ferramenta_id).
-- ---------------------------------------------------------------------
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, como_sobe, acao_afetada, visivel) values
  ('domador_ferramenta_n1', 'Domador', 'Incubadora Pequena',    1, 3,  '+3% em atividades de domador. Choca ovos com incubadora_min 1.',  'craft', 'chocar_ovo', true),
  ('domador_ferramenta_n2', 'Domador', 'Incubadora Média',      2, 6,  '+6% em atividades de domador. Choca ovos com incubadora_min ≤2.', 'craft', 'chocar_ovo', true),
  ('domador_ferramenta_n5', 'Domador', 'Incubadora Sagrada',    3, 12, '+12% em atividades de domador. Choca ovos com incubadora_min ≤3.','craft', 'chocar_ovo', true),
  ('domador_ferramenta_n5_ref', 'Domador', 'Incubadora Primordial', 5, 15, '+15% em atividades de domador. Choca qualquer ovo do catálogo (incubadora_min ≤5) — substitui a Sagrada ao craftar.', 'craft (refino da Sagrada)', 'chocar_ovo', true)
on conflict (id) do update set
  nivel_ferramenta = excluded.nivel_ferramenta,
  bonus_acao = excluded.bonus_acao,
  descricao = excluded.descricao;

-- ---------------------------------------------------------------------
-- 2) Wire de drop: só achei UM casamento de verdade entre os 100
-- missoes_quadro existentes e as 12 espécies de ovos_catalogo — as
-- outras 11 espécies (javali, lobo, urso, avestruz, aranha-sombra em
-- nível certo, coruja-sábia, dragão, fênix) não têm nenhuma missão de
-- caça correspondente hoje. Não forcei par errado (espécie ou nível
-- incompatível) só pra preencher — fica como pendência de conteúdo
-- real (escrever mais missões, ou usar `drop_tabela` genérico) em vez
-- de fingir que está resolvido.
-- drop_item_id é o slot de UM bônus extra além do material genérico que
-- toda missão já dá — troco o material antigo pelo ovo aqui, não é
-- perda (o generico continua rolando igual).
-- ---------------------------------------------------------------------
update missoes_quadro set drop_item_id = 'ovo_ratogig', drop_chance = 0.30
  where id = 'n1-caca-ratos';
