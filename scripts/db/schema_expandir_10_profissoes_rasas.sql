-- Achado ao responder "todas as profissoes estao equilibradas?": 10 das 16
-- profissoes (Bibliotecario, Cartografo, Comerciante, Coveiro, Diplomata,
-- Domador, Lenhador, Medico, Mercenario, Musico) tinham só 4 receitas de
-- item cada, parando em nivel 6, com xp/folego IDENTICOS entre si (mesmo
-- template generico, so trocando o nome) -- enquanto as outras 6
-- (Ferreiro, Alquimista, Costureiro, Cacador, Cozinheiro, Joalheiro) tem
-- 14 a 40 receitas cada, indo ate nivel 10. Um jogador dessas 10
-- profissoes ficava sem NADA novo pra craftar depois do nivel 6.
--
-- Nao existe nivel 3/5/7/9 em receita alguma no jogo (nem nas ricas) --
-- confirmado: a progressao real e 1/2/4/6/8/10 (comum/comum/incomum/
-- raro/epico/lendario). Entao o problema nao era "nivel faltando", era
-- variedade nos niveis que ja existem + as duas tiers mais altas
-- (epico=8, lendario=10) que essas 10 profissoes nunca tinham.
--
-- 12 itens novos por profissao (3 no nivel 1, 3 no nivel 2, 2 no nivel 4,
-- 2 no nivel 6, 1 epico novo no nivel 8, 1 lendario novo no nivel 10),
-- nomeados a partir do proprio tema oficial de cada profissao
-- (docs/guia_sistema_aincrad.md, secao "Moves de Profissao") e emendando o
-- estilo dos 4 itens que ja existiam (mesma formula de xp/folego/raridade
-- por nivel que as profissoes ricas usam). atributo_teste usa o atributo
-- canonico da profissao (a tabela de origem tinha atributo inconsistente
-- por item -- nao mexido nos 4 originais, so usado o certo daqui pra
-- frente). requer_ferramenta_id calculado igual as receitas existentes.
--
-- 120 receitas novas (10 profissoes x 12), cada uma leva cada profissao de
-- 4 para 16 receitas de item -- mesma faixa da Joalheiro (14), dentro do
-- "~15-25" combinado.

insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('bibliotecario_item_n1_lupa_de_leitura','Bibliotecário',1,'item','Lupa de Leitura','[{"mat_id": "mat_latao_em_po", "qtd": 8}, {"mat_id": "mat_minerio_de_bronze", "qtd": 7}]'::jsonb,'Conhecimento',12,1,'comum',1,'bibliotecario_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('bibliotecario_item_n1_marcador_de_pagina','Bibliotecário',1,'item','Marcador de Página','[{"mat_id": "mat_linho_fibra", "qtd": 7}, {"mat_id": "mat_corda", "qtd": 7}]'::jsonb,'Conhecimento',12,1,'comum',1,'bibliotecario_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('bibliotecario_item_n1_tinteiro_portatil','Bibliotecário',1,'item','Tinteiro Portátil','[{"mat_id": "mat_sal", "qtd": 8}, {"mat_id": "mat_erva_comum", "qtd": 7}]'::jsonb,'Conhecimento',12,1,'comum',1,'bibliotecario_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('bibliotecario_item_n2_catalogo_de_fichas','Bibliotecário',2,'item','Catálogo de Fichas','[{"mat_id": "mat_ervas_tranquilas", "qtd": 8}, {"mat_id": "mat_lingo_pinho", "qtd": 6}]'::jsonb,'Conhecimento',18,1,'comum',1,'bibliotecario_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('bibliotecario_item_n2_estante_dobravel','Bibliotecário',2,'item','Estante Dobrável','[{"mat_id": "mat_lingo_pinho", "qtd": 8}, {"mat_id": "mat_palha", "qtd": 5}]'::jsonb,'Conhecimento',18,1,'comum',1,'bibliotecario_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('bibliotecario_item_n2_pena_de_escrever','Bibliotecário',2,'item','Pena de Escrever','[{"mat_id": "mat_couro_de_lobo", "qtd": 5}, {"mat_id": "mat_mel_natural", "qtd": 8}]'::jsonb,'Conhecimento',18,1,'comum',1,'bibliotecario_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('bibliotecario_item_n4_compendio_de_fraquezas','Bibliotecário',4,'item','Compêndio de Fraquezas','[{"mat_id": "mat_pergaminho_sim", "qtd": 3}]'::jsonb,'Conhecimento',45,2,'incomum',1,'bibliotecario_ferramenta_n3_est2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('bibliotecario_item_n4_oculos_de_precisao','Bibliotecário',4,'item','Óculos de Precisão','[{"mat_id": "mat_lamina_temperada", "qtd": 3}, {"mat_id": "mat_corrente_sagrada", "qtd": 5}]'::jsonb,'Conhecimento',45,2,'incomum',1,'bibliotecario_ferramenta_n3_est2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('bibliotecario_item_n6_selo_de_autenticacao','Bibliotecário',6,'item','Selo de Autenticação','[{"mat_id": "mat_cristal_branco", "qtd": 3}]'::jsonb,'Conhecimento',65,3,'raro',1,'bibliotecario_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('bibliotecario_item_n6_cifra_restaurada','Bibliotecário',6,'item','Cifra Restaurada','[{"mat_id": "mat_cristal_de_furtividade", "qtd": 3}]'::jsonb,'Conhecimento',65,3,'raro',1,'bibliotecario_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('bibliotecario_item_n8_tomo_selado','Bibliotecário',8,'item','Tomo Selado','[{"mat_id": "mat_cristal_sombrio", "qtd": 1}]'::jsonb,'Conhecimento',90,4,'epico',1,'bibliotecario_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('bibliotecario_item_n10_arquivo_ancestral','Bibliotecário',10,'item','Arquivo Ancestral','[{"mat_id": "mat_cristais_puros", "qtd": 1}]'::jsonb,'Conhecimento',120,5,'lendario',1,'bibliotecario_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('cartografo_item_n1_bussola_improvisada','Cartógrafo',1,'item','Bússola Improvisada','[{"mat_id": "mat_linha_de_aco", "qtd": 7}, {"mat_id": "mat_placa_reforcada", "qtd": 7}]'::jsonb,'Conhecimento',12,1,'comum',1,'cartografo_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('cartografo_item_n1_regua_de_trilha','Cartógrafo',1,'item','Régua de Trilha','[{"mat_id": "mat_madeira", "qtd": 7}, {"mat_id": "mat_madeira_de_carvalho", "qtd": 8}]'::jsonb,'Conhecimento',12,1,'comum',1,'cartografo_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('cartografo_item_n1_estojo_de_pena','Cartógrafo',1,'item','Estojo de Pena','[{"mat_id": "mat_leite_fresco", "qtd": 10}, {"mat_id": "mat_pena_de_ave_grande", "qtd": 9}]'::jsonb,'Conhecimento',12,1,'comum',1,'cartografo_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('cartografo_item_n2_tinta_cartografica','Cartógrafo',2,'item','Tinta Cartográfica','[{"mat_id": "mat_frasco_vazio", "qtd": 8}, {"mat_id": "mat_agua_sagrada", "qtd": 7}]'::jsonb,'Conhecimento',18,1,'comum',1,'cartografo_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('cartografo_item_n2_suporte_de_pergaminho','Cartógrafo',2,'item','Suporte de Pergaminho','[{"mat_id": "mat_erva_curativa", "qtd": 6}, {"mat_id": "mat_madeira_resistente", "qtd": 6}]'::jsonb,'Conhecimento',18,1,'comum',1,'cartografo_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('cartografo_item_n2_corda_de_medicao','Cartógrafo',2,'item','Corda de Medição','[{"mat_id": "mat_linho_fibra", "qtd": 7}, {"mat_id": "mat_linha_reforcada", "qtd": 8}]'::jsonb,'Conhecimento',18,1,'comum',1,'cartografo_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('cartografo_item_n4_luneta_de_explorador','Cartógrafo',4,'item','Luneta de Explorador','[{"mat_id": "mat_fio_prata", "qtd": 5}, {"mat_id": "mat_corrente_sagrada", "qtd": 2}]'::jsonb,'Conhecimento',45,2,'incomum',1,'cartografo_ferramenta_n3_est2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('cartografo_item_n4_mapa_relevo','Cartógrafo',4,'item','Mapa-Relevo','[{"mat_id": "mat_latao_po", "qtd": 5}, {"mat_id": "mat_fio_aluminio", "qtd": 4}]'::jsonb,'Conhecimento',45,2,'incomum',1,'cartografo_ferramenta_n3_est2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('cartografo_item_n6_astrolabio_simples','Cartógrafo',6,'item','Astrolábio Simples','[{"mat_id": "mat_vidro_temper", "qtd": 2}]'::jsonb,'Conhecimento',65,3,'raro',1,'cartografo_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('cartografo_item_n6_bussola_de_precisao','Cartógrafo',6,'item','Bússola de Precisão','[{"mat_id": "mat_coral_negro", "qtd": 1}]'::jsonb,'Conhecimento',65,3,'raro',1,'cartografo_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('cartografo_item_n8_astrolabio_de_aincrad','Cartógrafo',8,'item','Astrolábio de Aincrad','[{"mat_id": "mat_essencia_divina", "qtd": 2}]'::jsonb,'Conhecimento',90,4,'epico',1,'cartografo_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('cartografo_item_n10_mapa_completo_do_andar','Cartógrafo',10,'item','Mapa Completo do Andar','[{"mat_id": "mat_essencia_ancestral", "qtd": 1}]'::jsonb,'Conhecimento',120,5,'lendario',1,'cartografo_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('comerciante_item_n1_balanca_de_feira','Comerciante',1,'item','Balança de Feira','[{"mat_id": "mat_ponta_de_aco", "qtd": 10}, {"mat_id": "mat_po_mineral", "qtd": 10}]'::jsonb,'Conhecimento',12,1,'comum',1,'comerciante_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('comerciante_item_n1_caixa_registradora','Comerciante',1,'item','Caixa Registradora','[{"mat_id": "mat_lingo_pinho", "qtd": 7}, {"mat_id": "mat_erva_doce", "qtd": 10}]'::jsonb,'Conhecimento',12,1,'comum',1,'comerciante_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('comerciante_item_n1_livro_caixa','Comerciante',1,'item','Livro-Caixa','[{"mat_id": "mat_madeira_resistente", "qtd": 7}, {"mat_id": "mat_palha", "qtd": 9}]'::jsonb,'Conhecimento',12,1,'comum',1,'comerciante_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('comerciante_item_n2_selo_de_autenticidade','Comerciante',2,'item','Selo de Autenticidade','[{"mat_id": "mat_ponta_de_ferro", "qtd": 8}, {"mat_id": "mat_flechas_simples", "qtd": 8}]'::jsonb,'Conhecimento',18,1,'comum',1,'comerciante_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('comerciante_item_n2_fardo_de_amostras','Comerciante',2,'item','Fardo de Amostras','[{"mat_id": "mat_seda_resistente", "qtd": 7}, {"mat_id": "mat_linho_fibra", "qtd": 8}]'::jsonb,'Conhecimento',18,1,'comum',1,'comerciante_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('comerciante_item_n2_cofre_de_viagem','Comerciante',2,'item','Cofre de Viagem','[{"mat_id": "mat_linha_de_aco", "qtd": 6}, {"mat_id": "mat_ponta_de_aco", "qtd": 5}]'::jsonb,'Conhecimento',18,1,'comum',1,'comerciante_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('comerciante_item_n4_contrato_lacrado','Comerciante',4,'item','Contrato Lacrado','[{"mat_id": "mat_lente_polida", "qtd": 2}, {"mat_id": "mat_tinta_preta", "qtd": 4}]'::jsonb,'Conhecimento',45,2,'incomum',1,'comerciante_ferramenta_n3_est2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('comerciante_item_n4_balcao_portatil','Comerciante',4,'item','Balcão Portátil','[{"mat_id": "mat_madeira_nodosa", "qtd": 3}, {"mat_id": "mat_resina_arvore", "qtd": 5}]'::jsonb,'Conhecimento',45,2,'incomum',1,'comerciante_ferramenta_n3_est2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('comerciante_item_n6_cofre_reforcado','Comerciante',6,'item','Cofre Reforçado','[{"mat_id": "mat_flecha_perfeita", "qtd": 1}]'::jsonb,'Conhecimento',65,3,'raro',1,'comerciante_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('comerciante_item_n6_anel_de_credito','Comerciante',6,'item','Anel de Crédito','[{"mat_id": "mat_cristal_branco", "qtd": 2}]'::jsonb,'Conhecimento',65,3,'raro',1,'comerciante_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('comerciante_item_n8_rede_de_contatos','Comerciante',8,'item','Rede de Contatos','[{"mat_id": "mat_essencia_espiritual", "qtd": 2}]'::jsonb,'Conhecimento',90,4,'epico',1,'comerciante_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('comerciante_item_n10_titulo_de_guilda','Comerciante',10,'item','Título de Guilda','[{"mat_id": "mat_gema_andar10", "qtd": 1}]'::jsonb,'Conhecimento',120,5,'lendario',1,'comerciante_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('coveiro_item_n1_mortalha_simples','Coveiro',1,'item','Mortalha Simples','[{"mat_id": "mat_tecido_resistente", "qtd": 9}, {"mat_id": "mat_seda_resistente", "qtd": 10}]'::jsonb,'Espírito',12,1,'comum',1,'coveiro_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('coveiro_item_n1_vela_de_vigilia','Coveiro',1,'item','Vela de Vigília','[{"mat_id": "mat_agua_sagrada", "qtd": 10}, {"mat_id": "mat_agua_pura", "qtd": 8}]'::jsonb,'Espírito',12,1,'comum',1,'coveiro_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('coveiro_item_n1_pa_de_sepultamento','Coveiro',1,'item','Pá de Sepultamento','[{"mat_id": "mat_ferro_bruto", "qtd": 8}, {"mat_id": "mat_barra_de_bronze", "qtd": 8}]'::jsonb,'Espírito',12,1,'comum',1,'coveiro_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('coveiro_item_n2_sino_funebre','Coveiro',2,'item','Sino Fúnebre','[{"mat_id": "mat_ponta_de_ferro_afiada", "qtd": 6}, {"mat_id": "mat_argila", "qtd": 8}]'::jsonb,'Espírito',18,1,'comum',1,'coveiro_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('coveiro_item_n2_amuleto_de_descanso','Coveiro',2,'item','Amuleto de Descanso','[{"mat_id": "mat_pena_pequena", "qtd": 6}, {"mat_id": "mat_couro_fino", "qtd": 7}]'::jsonb,'Espírito',18,1,'comum',1,'coveiro_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('coveiro_item_n2_oleo_ritualistico','Coveiro',2,'item','Óleo Ritualístico','[{"mat_id": "mat_erva_comum", "qtd": 6}, {"mat_id": "mat_frasco", "qtd": 7}]'::jsonb,'Espírito',18,1,'comum',1,'coveiro_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('coveiro_item_n4_urna_de_cinzas','Coveiro',4,'item','Urna de Cinzas','[{"mat_id": "mat_prata_bruta", "qtd": 4}, {"mat_id": "mat_fio_aluminio", "qtd": 2}]'::jsonb,'Espírito',45,2,'incomum',1,'coveiro_ferramenta_n3_est2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('coveiro_item_n4_lapide_gravada','Coveiro',4,'item','Lápide Gravada','[{"mat_id": "mat_lamina_fina_polida", "qtd": 5}, {"mat_id": "mat_gatilho_afiado", "qtd": 5}]'::jsonb,'Espírito',45,2,'incomum',1,'coveiro_ferramenta_n3_est2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('coveiro_item_n6_relicario_simples','Coveiro',6,'item','Relicário Simples','[{"mat_id": "mat_coral_negro", "qtd": 1}]'::jsonb,'Espírito',65,3,'raro',1,'coveiro_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('coveiro_item_n6_incenso_ancestral','Coveiro',6,'item','Incenso Ancestral','[{"mat_id": "mat_essencia_vital", "qtd": 3}]'::jsonb,'Espírito',65,3,'raro',1,'coveiro_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('coveiro_item_n8_relicario_sagrado','Coveiro',8,'item','Relicário Sagrado','[{"mat_id": "mat_essencia_espiritual", "qtd": 1}]'::jsonb,'Espírito',90,4,'epico',1,'coveiro_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('coveiro_item_n10_veu_da_travessia','Coveiro',10,'item','Véu da Travessia','[{"mat_id": "mat_cristal_espiritual", "qtd": 1}]'::jsonb,'Espírito',120,5,'lendario',1,'coveiro_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('diplomata_item_n1_leque_de_cortesia','Diplomata',1,'item','Leque de Cortesia','[{"mat_id": "mat_seda_crua", "qtd": 10}]'::jsonb,'Conhecimento',12,1,'comum',1,'diplomata_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('diplomata_item_n1_cartao_de_visita','Diplomata',1,'item','Cartão de Visita','[{"mat_id": "mat_borracha_látex", "qtd": 9}, {"mat_id": "mat_madeira_de_carvalho", "qtd": 7}]'::jsonb,'Conhecimento',12,1,'comum',1,'diplomata_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('diplomata_item_n1_tinta_de_assinatura','Diplomata',1,'item','Tinta de Assinatura','[{"mat_id": "mat_acucar_natural", "qtd": 7}, {"mat_id": "mat_tempero_natural", "qtd": 8}]'::jsonb,'Conhecimento',12,1,'comum',1,'diplomata_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('diplomata_item_n2_broche_de_guilda','Diplomata',2,'item','Broche de Guilda','[{"mat_id": "mat_placa_reforcada", "qtd": 5}, {"mat_id": "mat_linha_de_aco", "qtd": 5}]'::jsonb,'Conhecimento',18,1,'comum',1,'diplomata_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('diplomata_item_n2_manto_leve','Diplomata',2,'item','Manto Leve','[{"mat_id": "mat_linho_fibra", "qtd": 6}, {"mat_id": "mat_linha_reforcada", "qtd": 8}]'::jsonb,'Conhecimento',18,1,'comum',1,'diplomata_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('diplomata_item_n2_selo_pessoal','Diplomata',2,'item','Selo Pessoal','[{"mat_id": "mat_barra_de_bronze", "qtd": 7}, {"mat_id": "mat_linha_de_aco", "qtd": 7}]'::jsonb,'Conhecimento',18,1,'comum',1,'diplomata_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('diplomata_item_n4_manto_cerimonial','Diplomata',4,'item','Manto Cerimonial','[{"mat_id": "mat_linha_resistente", "qtd": 2}, {"mat_id": "mat_tecido_grosso", "qtd": 5}]'::jsonb,'Conhecimento',45,2,'incomum',1,'diplomata_ferramenta_n3_est2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('diplomata_item_n4_anel_de_audiencia','Diplomata',4,'item','Anel de Audiência','[{"mat_id": "mat_lente_polida", "qtd": 5}, {"mat_id": "mat_pinca_de_precisao", "qtd": 4}]'::jsonb,'Conhecimento',45,2,'incomum',1,'diplomata_ferramenta_n3_est2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('diplomata_item_n6_tratado_lacrado','Diplomata',6,'item','Tratado Lacrado','[{"mat_id": "mat_agua_cristalizada", "qtd": 1}]'::jsonb,'Conhecimento',65,3,'raro',1,'diplomata_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('diplomata_item_n6_colar_de_embaixada','Diplomata',6,'item','Colar de Embaixada','[{"mat_id": "mat_cristal_branco", "qtd": 3}]'::jsonb,'Conhecimento',65,3,'raro',1,'diplomata_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('diplomata_item_n8_anel_de_embaixador','Diplomata',8,'item','Anel de Embaixador','[{"mat_id": "mat_gema_branca", "qtd": 2}]'::jsonb,'Conhecimento',90,4,'epico',1,'diplomata_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('diplomata_item_n10_selo_real_de_aincrad','Diplomata',10,'item','Selo Real de Aincrad','[{"mat_id": "mat_essencia_do_sistema", "qtd": 1}]'::jsonb,'Conhecimento',120,5,'lendario',1,'diplomata_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('domador_item_n1_apito_de_chamado','Domador',1,'item','Apito de Chamado','[{"mat_id": "mat_placa_de_ferro_pequena", "qtd": 7}, {"mat_id": "mat_corrente_simples", "qtd": 9}]'::jsonb,'Técnica',12,1,'comum',1,'domador_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('domador_item_n1_racoes_de_trilha','Domador',1,'item','Rações de Trilha','[{"mat_id": "mat_erva_aquatica", "qtd": 7}, {"mat_id": "mat_trigo", "qtd": 9}]'::jsonb,'Técnica',12,1,'comum',1,'domador_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('domador_item_n1_cabresto_simples','Domador',1,'item','Cabresto Simples','[{"mat_id": "mat_pena", "qtd": 7}, {"mat_id": "mat_pena_de_ave", "qtd": 9}]'::jsonb,'Técnica',12,1,'comum',1,'domador_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('domador_item_n2_escova_de_pelagem','Domador',2,'item','Escova de Pelagem','[{"mat_id": "mat_mel", "qtd": 7}, {"mat_id": "mat_pena_rara", "qtd": 6}]'::jsonb,'Técnica',18,1,'comum',1,'domador_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('domador_item_n2_manta_de_sela','Domador',2,'item','Manta de Sela','[{"mat_id": "mat_corda", "qtd": 6}, {"mat_id": "mat_linha_reforcada", "qtd": 7}]'::jsonb,'Técnica',18,1,'comum',1,'domador_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('domador_item_n2_isca_aromatica','Domador',2,'item','Isca Aromática','[{"mat_id": "mat_tempero_simples", "qtd": 6}, {"mat_id": "mat_tempero_natural", "qtd": 6}]'::jsonb,'Técnica',18,1,'comum',1,'domador_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('domador_item_n4_arreio_reforcado','Domador',4,'item','Arreio Reforçado','[{"mat_id": "mat_couro_grosso", "qtd": 5}]'::jsonb,'Técnica',45,2,'incomum',1,'domador_ferramenta_n5',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('domador_item_n4_sino_de_rebanho','Domador',4,'item','Sino de Rebanho','[{"mat_id": "mat_carvao", "qtd": 5}, {"mat_id": "mat_fio_prata", "qtd": 2}]'::jsonb,'Técnica',45,2,'incomum',1,'domador_ferramenta_n5',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('domador_item_n6_amuleto_de_vinculo','Domador',6,'item','Amuleto de Vínculo','[{"mat_id": "mat_cogumelo_especial", "qtd": 2}]'::jsonb,'Técnica',65,3,'raro',1,'domador_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('domador_item_n6_coleira_trancada','Domador',6,'item','Coleira Trançada','[{"mat_id": "mat_carne_resistente", "qtd": 2}]'::jsonb,'Técnica',65,3,'raro',1,'domador_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('domador_item_n8_coleira_ancestral','Domador',8,'item','Coleira Ancestral','[{"mat_id": "mat_cristal_elemental", "qtd": 2}]'::jsonb,'Técnica',90,4,'epico',1,'domador_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('domador_item_n10_elo_primordial','Domador',10,'item','Elo Primordial','[{"mat_id": "mat_essencia_do_sistema", "qtd": 1}]'::jsonb,'Técnica',120,5,'lendario',1,'domador_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('lenhador_item_n1_machado_de_mao','Lenhador',1,'item','Machado de Mão','[{"mat_id": "mat_linha_de_aco", "qtd": 7}, {"mat_id": "mat_ferro", "qtd": 7}]'::jsonb,'Reflexo',12,1,'comum',1,'lenhador_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('lenhador_item_n1_feixe_de_lenha','Lenhador',1,'item','Feixe de Lenha','[{"mat_id": "mat_erva_curativa", "qtd": 10}, {"mat_id": "mat_erva_azul", "qtd": 9}]'::jsonb,'Reflexo',12,1,'comum',1,'lenhador_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('lenhador_item_n1_cunha_de_madeira','Lenhador',1,'item','Cunha de Madeira','[{"mat_id": "mat_erva_azul", "qtd": 10}, {"mat_id": "mat_madeira_de_carvalho", "qtd": 7}]'::jsonb,'Reflexo',12,1,'comum',1,'lenhador_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('lenhador_item_n2_corda_trancada','Lenhador',2,'item','Corda Trançada','[{"mat_id": "mat_linha_mistica", "qtd": 7}, {"mat_id": "mat_tecido_resistente", "qtd": 5}]'::jsonb,'Reflexo',18,1,'comum',1,'lenhador_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('lenhador_item_n2_abrigo_improvisado','Lenhador',2,'item','Abrigo Improvisado','[{"mat_id": "mat_madeira_nobre", "qtd": 5}, {"mat_id": "mat_ervas_medicinais", "qtd": 6}]'::jsonb,'Reflexo',18,1,'comum',1,'lenhador_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('lenhador_item_n2_serra_manual','Lenhador',2,'item','Serra Manual','[{"mat_id": "mat_placa_de_ferro", "qtd": 6}, {"mat_id": "mat_pedra_comum", "qtd": 7}]'::jsonb,'Reflexo',18,1,'comum',1,'lenhador_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('lenhador_item_n4_viga_reforcada','Lenhador',4,'item','Viga Reforçada','[{"mat_id": "mat_madeira_nodosa", "qtd": 5}, {"mat_id": "mat_resina_arvore", "qtd": 5}]'::jsonb,'Reflexo',45,2,'incomum',1,'lenhador_ferramenta_n3_est2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('lenhador_item_n4_machado_duplo','Lenhador',4,'item','Machado Duplo','[{"mat_id": "mat_latao_po", "qtd": 3}, {"mat_id": "mat_fio_aluminio", "qtd": 3}]'::jsonb,'Reflexo',45,2,'incomum',1,'lenhador_ferramenta_n3_est2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('lenhador_item_n6_ponte_de_emergencia','Lenhador',6,'item','Ponte de Emergência','[{"mat_id": "mat_erva_ancestral", "qtd": 1}]'::jsonb,'Reflexo',65,3,'raro',1,'lenhador_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('lenhador_item_n6_cabana_portatil','Lenhador',6,'item','Cabana Portátil','[{"mat_id": "mat_raiz_gigante", "qtd": 2}]'::jsonb,'Reflexo',65,3,'raro',1,'lenhador_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('lenhador_item_n8_madeira_ancestral_talhada','Lenhador',8,'item','Madeira Ancestral Talhada','[{"mat_id": "mat_madeira_ancestral", "qtd": 1}]'::jsonb,'Reflexo',90,4,'epico',1,'lenhador_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('lenhador_item_n10_totem_da_floresta_ancestral','Lenhador',10,'item','Totem da Floresta Ancestral','[{"mat_id": "mat_frutas_lendarias", "qtd": 1}]'::jsonb,'Reflexo',120,5,'lendario',1,'lenhador_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('medico_item_n1_compressa_fria','Médico',1,'item','Compressa Fria','[{"mat_id": "mat_seda_crua", "qtd": 8}, {"mat_id": "mat_linho_fibra", "qtd": 7}]'::jsonb,'Espírito',12,1,'comum',1,'medico_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('medico_item_n1_torniquete','Médico',1,'item','Torniquete','[{"mat_id": "mat_tecido_resistente", "qtd": 7}, {"mat_id": "mat_linha_reforcada", "qtd": 8}]'::jsonb,'Espírito',12,1,'comum',1,'medico_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('medico_item_n1_cha_medicinal','Médico',1,'item','Chá Medicinal','[{"mat_id": "mat_ervas_tranquilas", "qtd": 8}, {"mat_id": "mat_erva_azul", "qtd": 7}]'::jsonb,'Espírito',12,1,'comum',1,'medico_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('medico_item_n2_pomada_cicatrizante','Médico',2,'item','Pomada Cicatrizante','[{"mat_id": "mat_agua_purificada", "qtd": 6}]'::jsonb,'Espírito',18,1,'comum',1,'medico_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('medico_item_n2_talas_de_imobilizacao','Médico',2,'item','Talas de Imobilização','[{"mat_id": "mat_fibra_vegetal", "qtd": 6}, {"mat_id": "mat_trigo", "qtd": 7}]'::jsonb,'Espírito',18,1,'comum',1,'medico_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('medico_item_n2_frasco_de_antisseptico','Médico',2,'item','Frasco de Antisséptico','[{"mat_id": "mat_agua_purificada", "qtd": 8}, {"mat_id": "mat_agua_limpa", "qtd": 5}]'::jsonb,'Espírito',18,1,'comum',1,'medico_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('medico_item_n4_antidoto_amplo','Médico',4,'item','Antídoto Amplo','[{"mat_id": "mat_bandagem_purificada", "qtd": 5}, {"mat_id": "mat_pinca_de_precisao", "qtd": 5}]'::jsonb,'Espírito',45,2,'incomum',1,'medico_ferramenta_n3_est2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('medico_item_n4_maca_de_campo','Médico',4,'item','Maca de Campo','[{"mat_id": "mat_corda_encantada", "qtd": 3}, {"mat_id": "mat_tecido_grosso", "qtd": 5}]'::jsonb,'Espírito',45,2,'incomum',1,'medico_ferramenta_n3_est2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('medico_item_n6_kit_de_transfusao','Médico',6,'item','Kit de Transfusão','[{"mat_id": "mat_virote_de_aco", "qtd": 1}]'::jsonb,'Espírito',65,3,'raro',1,'medico_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('medico_item_n6_balsamo_raro','Médico',6,'item','Bálsamo Raro','[{"mat_id": "mat_acucar_raro", "qtd": 1}]'::jsonb,'Espírito',65,3,'raro',1,'medico_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('medico_item_n8_soro_milagroso','Médico',8,'item','Soro Milagroso','[{"mat_id": "mat_cristal_de_vento", "qtd": 1}]'::jsonb,'Espírito',90,4,'epico',1,'medico_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('medico_item_n10_elixir_da_vida_plena','Médico',10,'item','Elixir da Vida Plena','[{"mat_id": "mat_essencia_do_sistema", "qtd": 1}]'::jsonb,'Espírito',120,5,'lendario',1,'medico_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('mercenario_item_n1_corda_de_rapel','Mercenário',1,'item','Corda de Rapel','[{"mat_id": "mat_linha_reforcada", "qtd": 7}, {"mat_id": "mat_corda", "qtd": 10}]'::jsonb,'Corpo',12,1,'comum',1,'mercenario_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('mercenario_item_n1_faca_de_campo','Mercenário',1,'item','Faca de Campo','[{"mat_id": "mat_carvao_pedra", "qtd": 7}, {"mat_id": "mat_ferro", "qtd": 8}]'::jsonb,'Corpo',12,1,'comum',1,'mercenario_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('mercenario_item_n1_cantil_reforcado','Mercenário',1,'item','Cantil Reforçado','[{"mat_id": "mat_fivela_de_ferro", "qtd": 7}, {"mat_id": "mat_carvao_pedra", "qtd": 10}]'::jsonb,'Corpo',12,1,'comum',1,'mercenario_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('mercenario_item_n2_mochila_de_batalha','Mercenário',2,'item','Mochila de Batalha','[{"mat_id": "mat_linha_reforcada", "qtd": 5}, {"mat_id": "mat_tecido_resistente", "qtd": 5}]'::jsonb,'Corpo',18,1,'comum',1,'mercenario_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('mercenario_item_n2_fogueira_portatil','Mercenário',2,'item','Fogueira Portátil','[{"mat_id": "mat_pedra_de_amolar", "qtd": 7}, {"mat_id": "mat_ponta_de_aco", "qtd": 6}]'::jsonb,'Corpo',18,1,'comum',1,'mercenario_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('mercenario_item_n2_bracadeira_de_couro','Mercenário',2,'item','Braçadeira de Couro','[{"mat_id": "mat_pena_de_ave", "qtd": 7}, {"mat_id": "mat_leite_fresco", "qtd": 8}]'::jsonb,'Corpo',18,1,'comum',1,'mercenario_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('mercenario_item_n4_armadura_improvisada','Mercenário',4,'item','Armadura Improvisada','[{"mat_id": "mat_lamina_temperada", "qtd": 3}]'::jsonb,'Corpo',45,2,'incomum',1,'mercenario_ferramenta_n3_est2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('mercenario_item_n4_bandoleira_de_municao','Mercenário',4,'item','Bandoleira de Munição','[{"mat_id": "mat_encadernacao_reforcada", "qtd": 3}, {"mat_id": "mat_linha_resistente", "qtd": 3}]'::jsonb,'Corpo',45,2,'incomum',1,'mercenario_ferramenta_n3_est2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('mercenario_item_n6_escudo_reforcado','Mercenário',6,'item','Escudo Reforçado','[{"mat_id": "mat_ferro_reforcado", "qtd": 1}]'::jsonb,'Corpo',65,3,'raro',1,'mercenario_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('mercenario_item_n6_elmo_de_batalha','Mercenário',6,'item','Elmo de Batalha','[{"mat_id": "mat_ferro_reforcado", "qtd": 2}]'::jsonb,'Corpo',65,3,'raro',1,'mercenario_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('mercenario_item_n8_brasao_de_veterano','Mercenário',8,'item','Brasão de Veterano','[{"mat_id": "mat_gema_branca", "qtd": 1}]'::jsonb,'Corpo',90,4,'epico',1,'mercenario_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('mercenario_item_n10_estandarte_de_guerra','Mercenário',10,'item','Estandarte de Guerra','[{"mat_id": "mat_nucleo_de_chefe", "qtd": 1}]'::jsonb,'Corpo',120,5,'lendario',1,'mercenario_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('musico_item_n1_pandeiro_simples','Músico',1,'item','Pandeiro Simples','[{"mat_id": "mat_garra_de_fera", "qtd": 7}, {"mat_id": "mat_couro_de_lobo", "qtd": 9}]'::jsonb,'Espírito',12,1,'comum',1,'musico_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('musico_item_n1_corda_de_reserva','Músico',1,'item','Corda de Reserva','[{"mat_id": "mat_tecido_resistente", "qtd": 7}]'::jsonb,'Espírito',12,1,'comum',1,'musico_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('musico_item_n1_apito_de_sinal','Músico',1,'item','Apito de Sinal','[{"mat_id": "mat_barra_de_bronze", "qtd": 9}]'::jsonb,'Espírito',12,1,'comum',1,'musico_ferramenta_n1',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('musico_item_n2_estante_de_partitura','Músico',2,'item','Estante de Partitura','[{"mat_id": "mat_erva_doce", "qtd": 6}, {"mat_id": "mat_farinha", "qtd": 6}]'::jsonb,'Espírito',18,1,'comum',1,'musico_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('musico_item_n2_baqueta_talhada','Músico',2,'item','Baqueta Talhada','[{"mat_id": "mat_resina_natural", "qtd": 5}, {"mat_id": "mat_ervas_medicinais", "qtd": 8}]'::jsonb,'Espírito',18,1,'comum',1,'musico_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('musico_item_n2_palheta_de_osso','Músico',2,'item','Palheta de Osso','[{"mat_id": "mat_carne_de_monstro", "qtd": 6}]'::jsonb,'Espírito',18,1,'comum',1,'musico_ferramenta_n2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('musico_item_n4_alaude_trabalhado','Músico',4,'item','Alaúde Trabalhado','[{"mat_id": "mat_erva_vital", "qtd": 5}]'::jsonb,'Espírito',45,2,'incomum',1,'musico_ferramenta_n3_est2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('musico_item_n4_sino_de_presenca','Músico',4,'item','Sino de Presença','[{"mat_id": "mat_gatilho_afiado", "qtd": 4}]'::jsonb,'Espírito',45,2,'incomum',1,'musico_ferramenta_n3_est2',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('musico_item_n6_corda_de_prata','Músico',6,'item','Corda de Prata','[{"mat_id": "mat_barra_de_aco", "qtd": 2}]'::jsonb,'Espírito',65,3,'raro',1,'musico_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('musico_item_n6_caixa_de_ressonancia','Músico',6,'item','Caixa de Ressonância','[{"mat_id": "mat_ervas_selvagens", "qtd": 1}]'::jsonb,'Espírito',65,3,'raro',1,'musico_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('musico_item_n8_trompa_ancestral','Músico',8,'item','Trompa Ancestral','[{"mat_id": "mat_essencia_elemental", "qtd": 1}]'::jsonb,'Espírito',90,4,'epico',1,'musico_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, materiais, atributo_teste, xp_recompensa, folego_custo, resultado_raridade, resultado_qtd, requer_ferramenta_id, visivel, excluido)
  values ('musico_item_n10_requiem_de_aincrad','Músico',10,'item','Réquiem de Aincrad','[{"mat_id": "mat_essencia_ancestral", "qtd": 1}]'::jsonb,'Espírito',120,5,'lendario',1,'musico_ferramenta_n5_ref',true,false)
  on conflict (id) do nothing;
