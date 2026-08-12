-- 203 dos 251 mat_id usados em receitas.materiais nao existiam em
-- materiais_basicos (catalogo so tinha 48 linhas) -- gap achado ao investigar
-- o pedido "todas as profissoes precisam de ferramentas... materiais
-- precisam ser dropados". Sem essas linhas, nao da pra dar drop de combate
-- coerente (sem categoria/raridade real pra guiar em qual monstro cai) nem
-- mostrar nome bonito na UI.
--
-- Categoria/raridade inferidas automaticamente: raridade pelo nivel_receita
-- medio onde o mat_id aparece (nivel<=2 comum, 3-4 incomum, 5-6 raro, 7-8
-- epico, 9+ lendario); categoria por palavra-chave no proprio id (token
-- inteiro, nao substring solta -- corrigido um bug de colisao real:
-- "vermelho" batendo com "mel" na primeira tentativa). nivel_obtencao e
-- peso_uso_esperado seguem a mesma correlacao ja usada nas 48 linhas
-- originais.
--
-- 2 colisoes de nome com material ja existente (2 ids diferentes pro mesmo
-- item, sobra de geracao de receita em lotes separados) -- resolvidas
-- redirecionando a receita pro id real em vez de duplicar linha de catalogo:
--   mat_pergaminho_simples -> mat_pergaminho_sim ("Pergaminho Simples")
--   mat_vidro_temperado    -> mat_vidro_temper   ("Vidro Temperado")

insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_acucar_natural','Açúcar Natural','quimico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_acucar_raro','Açúcar Raro','quimico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_agua_cristalizada','Água Cristalizada','quimico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_agua_limpa','Água Limpa','quimico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_agua_pura','Água Pura','quimico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_agua_purificada','Água Purificada','quimico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_agua_sagrada','Água Sagrada','quimico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_agulha_magnetizada','Agulha Magnetizada','exotico','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_bandagem_purificada','Bandagem Purificada','quimico','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_barra_de_aco','Barra De Aço','mineral','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_barra_de_bronze','Barra De Bronze','mineral','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_barra_de_ferro','Barra De Ferro','mineral','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cabeca_balanceada','Cabeca Balanceada','exotico','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_carne_de_animal','Carne De Animal','animal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_carne_de_caca_rara','Carne De Caca Rara','animal','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_carne_de_chefe','Carne De Chefe','animal','epico',8,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_carne_de_monstro','Carne De Monstro','animal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_carne_de_monstro_raro','Carne De Monstro Raro','animal','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_carne_lendaria','Carne Lendaria','animal','epico',8,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_carne_resistente','Carne Resistente','animal','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_carvao','Carvao','mineral','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_carvao_refinado','Carvao Refinado','mineral','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cogumelo_especial','Cogumelo Especial','exotico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_corda','Corda','tecido','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_corda_encantada','Corda Encantada','tecido','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_corda_forte','Corda Forte','tecido','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_corrente_de_aco','Corrente De Aço','mineral','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_corrente_sagrada','Corrente Sagrada','mineral','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_corrente_simples','Corrente Simples','mineral','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_couro_curtido','Couro Curtido','animal','incomum',2,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_couro_de_lobo','Couro De Lobo','animal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_couro_fino','Couro Fino','animal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_couro_grosso','Couro Grosso','animal','incomum',2,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_couro_nobre','Couro Nobre','animal','incomum',4,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_couro_reforcado','Couro Reforcado','animal','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_couro_sombrio','Couro Sombrio','animal','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristais_puros','Cristais Puros','exotico','lendario',10,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_azul','Cristal Azul','exotico','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_azul_perfeito','Cristal Azul Perfeito','exotico','lendario',10,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_claro','Cristal Claro','exotico','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_de_controle','Cristal De Controle','exotico','epico',8,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_de_defesa','Cristal De Defesa','exotico','raro',5,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_de_deteccao','Cristal De Deteccao','exotico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_de_fogo','Cristal De Fogo','exotico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_de_fogo_pequeno','Cristal De Fogo Pequeno','exotico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_de_forca','Cristal De Forca','exotico','epico',8,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_de_furtividade','Cristal De Furtividade','exotico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_de_gelo','Cristal De Gelo','exotico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_de_impacto','Cristal De Impacto','exotico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_de_localizacao','Cristal De Localizacao','exotico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_de_precisao','Cristal De Precisao','exotico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_de_retorno','Cristal De Retorno','exotico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_de_vento','Cristal De Vento','exotico','epico',7,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_de_visao','Cristal De Visao','exotico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_elemental','Cristal Elemental','exotico','epico',7,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_elemental_supremo','Cristal Elemental Supremo','exotico','epico',8,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_espiritual','Cristal Espiritual','exotico','lendario',10,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_flamejante','Cristal Flamejante','exotico','epico',8,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_luminoso','Cristal Luminoso','exotico','incomum',4,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_natural','Cristal Natural','exotico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_pequeno','Cristal Pequeno','exotico','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_prismatico','Cristal Prismatico','exotico','lendario',10,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_sombrio','Cristal Sombrio','exotico','epico',7,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_verde','Cristal Verde','exotico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_vermelho','Cristal Vermelho','exotico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_cristal_vital','Cristal Vital','exotico','epico',8,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_encadernacao_reforcada','Encadernação Reforcada','tecido','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_erva_aquatica','Erva Aquatica','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_erva_aromatica','Erva Aromatica','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_erva_azul','Erva Azul','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_erva_curativa','Erva Curativa','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_erva_curativa_rara','Erva Curativa Rara','vegetal','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_erva_doce','Erva Doce','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_erva_escura','Erva Escura','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_erva_forte','Erva Forte','vegetal','raro',5,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_erva_lendaria','Erva Lendaria','vegetal','lendario',10,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_erva_lubrificante','Erva Lubrificante','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_erva_purificadora','Erva Purificadora','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_erva_vital','Erva Vital','vegetal','incomum',4,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_ervas_ancestrais','Ervas Ancestrais','vegetal','epico',8,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_ervas_especiais','Ervas Especiais','vegetal','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_ervas_medicinais','Ervas Medicinais','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_ervas_selvagens','Ervas Selvagens','vegetal','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_ervas_sombras','Ervas Sombras','vegetal','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_ervas_tranquilas','Ervas Tranquilas','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_escama_de_dragao','Escama De Dragao','animal','epico',8,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_escama_de_monstro','Escama De Monstro','animal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_essencia_ancestral','Essência Ancestral','exotico','lendario',10,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_essencia_aquatica','Essência Aquatica','exotico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_essencia_da_vida','Essência Da Vida','exotico','lendario',10,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_essencia_de_monstro','Essência De Monstro','exotico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_essencia_do_sistema','Essência Do Sistema','exotico','lendario',10,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_essencia_elemental','Essência Elemental','exotico','epico',8,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_essencia_espacial','Essência Espacial','exotico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_essencia_espiritual','Essência Espiritual','exotico','epico',8,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_essencia_flamejante','Essência Flamejante','exotico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_essencia_lendaria','Essência Lendaria','exotico','lendario',10,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_essencia_lunar','Essência Lunar','exotico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_essencia_magica','Essência Magica','exotico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_essencia_mistica','Essência Mistica','exotico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_essencia_oculta','Essência Oculta','exotico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_essencia_protetora','Essência Protetora','exotico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_essencia_vital','Essência Vital','exotico','raro',5,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_farinha','Farinha','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_ferro','Ferro','mineral','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_ferro_reforcado','Ferro Reforcado','mineral','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_fibra_forte','Fibra Forte','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_fibra_vegetal','Fibra Vegetal','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_fio_prata','Fio Prata','mineral','incomum',2,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_fivela_de_ferro','Fivela De Ferro','mineral','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_flecha_perfeita','Flecha Perfeita','mineral','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_flechas_perfeitas','Flechas Perfeitas','mineral','epico',8,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_flechas_perfurantes','Flechas Perfurantes','mineral','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_flechas_simples','Flechas Simples','mineral','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_forja_compacta','Forja Compacta','exotico','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_fragmento_dimensional','Fragmento Dimensional','exotico','incomum',4,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_fragmento_magico','Fragmento Magico','exotico','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_frasco','Frasco','quimico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_frasco_especial','Frasco Especial','quimico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_frasco_reforcado','Frasco Reforcado','quimico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_frasco_vazio','Frasco Vazio','quimico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_fruta_rara','Fruta Rara','vegetal','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_frutas_lendarias','Frutas Lendarias','vegetal','lendario',10,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_frutas_raras','Frutas Raras','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_garra_de_fera','Garra De Fera','animal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_gatilho_afiado','Gatilho Afiado','mineral','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_ingrediente_unico','Ingrediente Unico','quimico','lendario',10,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_lamina_fina_polida','Lâmina Fina Polida','mineral','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_lamina_temperada','Lâmina Temperada','mineral','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_latao_em_po','Latao Em Pó','mineral','comum',1,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_leite_fresco','Leite Fresco','animal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_lente_polida','Lente Polida','quimico','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_liga_de_mithril','Liga De Mithril','mineral','lendario',9,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_liga_resistente_ao_fogo','Liga Resistente Ao Fogo','exotico','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_linha_de_aco','Linha De Aço','mineral','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_linha_mistica','Linha Mistica','tecido','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_linha_reforcada','Linha Reforcada','tecido','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_linha_resistente','Linha Resistente','tecido','incomum',2,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_madeira','Madeira','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_madeira_ancestral','Madeira Ancestral','vegetal','epico',8,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_madeira_de_carvalho','Madeira De Carvalho','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_madeira_leve','Madeira Leve','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_madeira_nobre','Madeira Nobre','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_madeira_resistente','Madeira Resistente','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_mel','Mel','animal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_mel_natural','Mel Natural','animal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_metal_lendario','Metal Lendario','exotico','epico',8,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_minerio_de_bronze','Minério De Bronze','mineral','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_molde_gravado','Molde Gravado','exotico','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_molho_raro','Molho Raro','quimico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_nucleo_ancestral','Núcleo Ancestral','exotico','lendario',10,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_nucleo_de_chefe','Núcleo De Chefe','exotico','lendario',10,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_nucleo_de_chefe_final','Núcleo De Chefe Final','exotico','lendario',10,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_nucleo_de_criatura_ancestral','Núcleo De Criatura Ancestral','exotico','epico',8,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_nucleo_de_gigante','Núcleo De Gigante','exotico','epico',8,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_nucleo_de_guardiao','Núcleo De Guardiao','exotico','lendario',9,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_nucleo_de_monstro','Núcleo De Monstro','exotico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_nucleo_de_monstro_chefe','Núcleo De Monstro Chefe','exotico','epico',8,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_oleo','Óleo','exotico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_oleo_natural','Óleo Natural','exotico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_osso_de_chefe','Osso De Chefe','animal','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_osso_de_fera','Osso De Fera','animal','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_ouro_refinado','Ouro Refinado','mineral','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_pedra_comum','Pedra Comum','mineral','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_pedra_de_amolar','Pedra De Amolar','mineral','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_peixe_raro','Peixe Raro','exotico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_pena','Pena','animal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_pena_de_ave','Pena De Ave','animal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_pena_de_ave_grande','Pena De Ave Grande','animal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_pena_pequena','Pena Pequena','animal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_pena_rara','Pena Rara','animal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_pinca_de_precisao','Pinca De Precisao','quimico','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_placa_de_aco','Placa De Aço','mineral','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_placa_de_ferro','Placa De Ferro','mineral','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_placa_de_ferro_pequena','Placa De Ferro Pequena','mineral','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_placa_reforcada','Placa Reforcada','mineral','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_planta_veloz','Planta Veloz','vegetal','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_po_mineral','Pó Mineral','mineral','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_polvora','Pólvora','quimico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_ponta_de_aco','Ponta De Aço','mineral','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_ponta_de_ferro','Ponta De Ferro','mineral','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_ponta_de_ferro_afiada','Ponta De Ferro Afiada','mineral','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_prata_bruta','Prata Bruta','mineral','incomum',2,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_prata_refinada','Prata Refinada','mineral','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_presa_de_monstro','Presa De Monstro','animal','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_raiz_gigante','Raiz Gigante','vegetal','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_rebite_de_ferro','Rebite De Ferro','mineral','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_resina_natural','Resina Natural','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_sal','Sal','quimico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_sangue_de_monstro','Sangue De Monstro','animal','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_seda_rara','Seda Rara','tecido','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_seda_resistente','Seda Resistente','tecido','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_serpentina_de_cobre','Serpentina De Cobre','mineral','incomum',3,6,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_tecido_resistente','Tecido Resistente','tecido','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_tempero_especial','Tempero Especial','quimico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_tempero_lendario','Tempero Lendario','quimico','epico',8,4,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_tempero_natural','Tempero Natural','quimico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_tempero_simples','Tempero Simples','quimico','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_trigo','Trigo','vegetal','comum',2,7,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_veneno_natural','Veneno Natural','quimico','raro',6,5,true,false)
  on conflict (id) do nothing;
insert into materiais_basicos (id, nome, categoria, raridade, nivel_obtencao, peso_uso_esperado, visivel, excluido)
  values ('mat_virote_de_aco','Virote De Aço','mineral','raro',6,5,true,false)
  on conflict (id) do nothing;

-- reconciliacao dos 2 ids duplicados (ver comentario acima)
update receitas set materiais = (
  select jsonb_agg(case when e->>'mat_id' = 'mat_pergaminho_simples' then jsonb_set(e, '{mat_id}', 'mat_pergaminho_sim'::jsonb) else e end)
  from jsonb_array_elements(materiais) e
) where materiais::text ilike '%' || 'mat_pergaminho_simples' || '%';
update receitas set materiais = (
  select jsonb_agg(case when e->>'mat_id' = 'mat_vidro_temperado' then jsonb_set(e, '{mat_id}', 'mat_vidro_temper'::jsonb) else e end)
  from jsonb_array_elements(materiais) e
) where materiais::text ilike '%' || 'mat_vidro_temperado' || '%';
