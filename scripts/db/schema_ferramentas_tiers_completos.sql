-- Achado junto com o catalogo de materiais: das 6 receitas tipo=ferramenta
-- por profissao (n1, n2, n3_est1, n3_est2, n5, n5_ref), so 2 (n1 e n3_est2)
-- tinham linha correspondente em ferramentas_oficio pras 15 profissoes
-- fora Domador -- craftar n2/n3_est1/n5/n5_ref produzia uma ferramenta
-- "fantasma" (entra em personagem_ferramentas mas o JOIN com
-- ferramentas_oficio pro bonus_acao nao acha nada, fica sem efeito
-- nenhum). Domador ja tinha as 4 corretas desde o item 14.
--
-- Progressao de bonus_acao nova (nao existia antes pra esses tiers):
-- n1=1 (ja existia), n2=1, n3_est1=1 (transitorio -- substituido na hora
-- pelo n3_est2, existe so no intervalo entre craftar um e outro), n3_est2=2
-- (ja existia), n5=3 (transitorio ate o refino), n5_ref=4.
-- 60 linhas, 15 profissoes x 4 tiers.

insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('alquimista_ferramenta_n2','Alquimista','Frascos Padronizados',2,1,'Ferramenta de Alquimista, tier 2. Craftada via receita alquimista_ferramenta_n2.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('alquimista_ferramenta_n3_est1','Alquimista','Serpentina de Cobre',3,1,'Ferramenta de Alquimista, tier 3. Craftada via receita alquimista_ferramenta_n3_est1.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('alquimista_ferramenta_n5','Alquimista','Pedra Filosofal Est1',5,3,'Ferramenta de Alquimista, tier 5. Craftada via receita alquimista_ferramenta_n5.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('alquimista_ferramenta_n5_ref','Alquimista','Pedra Filosofal Est2',5,4,'Ferramenta de Alquimista, tier 5. Craftada via receita alquimista_ferramenta_n5_ref.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('bibliotecario_ferramenta_n2','Bibliotecário','Lupa Simples',2,1,'Ferramenta de Bibliotecário, tier 2. Craftada via receita bibliotecario_ferramenta_n2.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('bibliotecario_ferramenta_n3_est1','Bibliotecário','Lente Polida',3,1,'Ferramenta de Bibliotecário, tier 3. Craftada via receita bibliotecario_ferramenta_n3_est1.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('bibliotecario_ferramenta_n5','Bibliotecário','Cristal Memória Est1',5,3,'Ferramenta de Bibliotecário, tier 5. Craftada via receita bibliotecario_ferramenta_n5.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('bibliotecario_ferramenta_n5_ref','Bibliotecário','Tomo Sabedoria Est2',5,4,'Ferramenta de Bibliotecário, tier 5. Craftada via receita bibliotecario_ferramenta_n5_ref.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('cacador_ferramenta_n2','Caçador','Arco Treinado',2,1,'Ferramenta de Caçador, tier 2. Craftada via receita cacador_ferramenta_n2.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('cacador_ferramenta_n3_est1','Caçador','Gatilho Afiado',3,1,'Ferramenta de Caçador, tier 3. Craftada via receita cacador_ferramenta_n3_est1.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('cacador_ferramenta_n5','Caçador','Arco Lendário Est1',5,3,'Ferramenta de Caçador, tier 5. Craftada via receita cacador_ferramenta_n5.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('cacador_ferramenta_n5_ref','Caçador','Arco Lendário Est2',5,4,'Ferramenta de Caçador, tier 5. Craftada via receita cacador_ferramenta_n5_ref.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('cartografo_ferramenta_n2','Cartógrafo','Bússola Bolso',2,1,'Ferramenta de Cartógrafo, tier 2. Craftada via receita cartografo_ferramenta_n2.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('cartografo_ferramenta_n3_est1','Cartógrafo','Agulha Magnetizada',3,1,'Ferramenta de Cartógrafo, tier 3. Craftada via receita cartografo_ferramenta_n3_est1.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('cartografo_ferramenta_n5','Cartógrafo','Astrolábio Portátil Est1',5,3,'Ferramenta de Cartógrafo, tier 5. Craftada via receita cartografo_ferramenta_n5.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('cartografo_ferramenta_n5_ref','Cartógrafo','Globo Aincrad Est2',5,4,'Ferramenta de Cartógrafo, tier 5. Craftada via receita cartografo_ferramenta_n5_ref.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('comerciante_ferramenta_n2','Comerciante','Pergaminho Mercado',2,1,'Ferramenta de Comerciante, tier 2. Craftada via receita comerciante_ferramenta_n2.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('comerciante_ferramenta_n3_est1','Comerciante','Encadernação Reforçada',3,1,'Ferramenta de Comerciante, tier 3. Craftada via receita comerciante_ferramenta_n3_est1.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('comerciante_ferramenta_n5_ref','Comerciante','Livro Comércio Est2',5,4,'Ferramenta de Comerciante, tier 5. Craftada via receita comerciante_ferramenta_n5_ref.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('comerciante_ferramenta_n5','Comerciante','Livro Comércio Est1',5,3,'Ferramenta de Comerciante, tier 5. Craftada via receita comerciante_ferramenta_n5.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('costureiro_ferramenta_n2','Costureiro','Máquina Costura',2,1,'Ferramenta de Costureiro, tier 2. Craftada via receita costureiro_ferramenta_n2.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('costureiro_ferramenta_n3_est1','Costureiro','Lâmina Fina Polida',3,1,'Ferramenta de Costureiro, tier 3. Craftada via receita costureiro_ferramenta_n3_est1.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('costureiro_ferramenta_n5','Costureiro','Tear Mágico Est1',5,3,'Ferramenta de Costureiro, tier 5. Craftada via receita costureiro_ferramenta_n5.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('costureiro_ferramenta_n5_ref','Costureiro','Agulha Deuses Est2',5,4,'Ferramenta de Costureiro, tier 5. Craftada via receita costureiro_ferramenta_n5_ref.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('coveiro_ferramenta_n2','Coveiro','Lanterna Luto',2,1,'Ferramenta de Coveiro, tier 2. Craftada via receita coveiro_ferramenta_n2.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('coveiro_ferramenta_n3_est1','Coveiro','Corrente Sagrada',3,1,'Ferramenta de Coveiro, tier 3. Craftada via receita coveiro_ferramenta_n3_est1.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('coveiro_ferramenta_n5_ref','Coveiro','Foice São Juízo Est2',5,4,'Ferramenta de Coveiro, tier 5. Craftada via receita coveiro_ferramenta_n5_ref.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('coveiro_ferramenta_n5','Coveiro','Foice São Juízo Est1',5,3,'Ferramenta de Coveiro, tier 5. Craftada via receita coveiro_ferramenta_n5.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('cozinheiro_ferramenta_n2','Cozinheiro','Panela Ferro',2,1,'Ferramenta de Cozinheiro, tier 2. Craftada via receita cozinheiro_ferramenta_n2.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('cozinheiro_ferramenta_n3_est1','Cozinheiro','Liga Resistente ao Fogo',3,1,'Ferramenta de Cozinheiro, tier 3. Craftada via receita cozinheiro_ferramenta_n3_est1.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('cozinheiro_ferramenta_n5_ref','Cozinheiro','Colher Chefe Est2',5,4,'Ferramenta de Cozinheiro, tier 5. Craftada via receita cozinheiro_ferramenta_n5_ref.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('cozinheiro_ferramenta_n5','Cozinheiro','Colher Chefe Est1',5,3,'Ferramenta de Cozinheiro, tier 5. Craftada via receita cozinheiro_ferramenta_n5.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('diplomata_ferramenta_n2','Diplomata','Cetro Cerimônia',2,1,'Ferramenta de Diplomata, tier 2. Craftada via receita diplomata_ferramenta_n2.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('diplomata_ferramenta_n3_est1','Diplomata','Molde Gravado',3,1,'Ferramenta de Diplomata, tier 3. Craftada via receita diplomata_ferramenta_n3_est1.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('diplomata_ferramenta_n5','Diplomata','Corrente Escrivão Est1',5,3,'Ferramenta de Diplomata, tier 5. Craftada via receita diplomata_ferramenta_n5.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('diplomata_ferramenta_n5_ref','Diplomata','Trono Portátil Est2',5,4,'Ferramenta de Diplomata, tier 5. Craftada via receita diplomata_ferramenta_n5_ref.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('ferreiro_ferramenta_n2','Ferreiro','Bigorna Portátil',2,1,'Ferramenta de Ferreiro, tier 2. Craftada via receita ferreiro_ferramenta_n2.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('ferreiro_ferramenta_n3_est1','Ferreiro','Cabeça Balanceada',3,1,'Ferramenta de Ferreiro, tier 3. Craftada via receita ferreiro_ferramenta_n3_est1.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('ferreiro_ferramenta_n5_ref','Ferreiro','Fornalha Vulcão Est2',5,4,'Ferramenta de Ferreiro, tier 5. Craftada via receita ferreiro_ferramenta_n5_ref.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('ferreiro_ferramenta_n5','Ferreiro','Fornalha Vulcão Est1',5,3,'Ferramenta de Ferreiro, tier 5. Craftada via receita ferreiro_ferramenta_n5.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('joalheiro_ferramenta_n2','Joalheiro','Alicate Ourives',2,1,'Ferramenta de Joalheiro, tier 2. Craftada via receita joalheiro_ferramenta_n2.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('joalheiro_ferramenta_n3_est1','Joalheiro','Pinça de Precisão',3,1,'Ferramenta de Joalheiro, tier 3. Craftada via receita joalheiro_ferramenta_n3_est1.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('joalheiro_ferramenta_n5_ref','Joalheiro','Gema Criação Est2',5,4,'Ferramenta de Joalheiro, tier 5. Craftada via receita joalheiro_ferramenta_n5_ref.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('joalheiro_ferramenta_n5','Joalheiro','Mesa Ourives Est1',5,3,'Ferramenta de Joalheiro, tier 5. Craftada via receita joalheiro_ferramenta_n5.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('lenhador_ferramenta_n2','Lenhador','Machado Treinado',2,1,'Ferramenta de Lenhador, tier 2. Craftada via receita lenhador_ferramenta_n2.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('lenhador_ferramenta_n3_est1','Lenhador','Lâmina Temperada',3,1,'Ferramenta de Lenhador, tier 3. Craftada via receita lenhador_ferramenta_n3_est1.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('lenhador_ferramenta_n5','Lenhador','Machado Gigantes Est1',5,3,'Ferramenta de Lenhador, tier 5. Craftada via receita lenhador_ferramenta_n5.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('lenhador_ferramenta_n5_ref','Lenhador','Machado Gigantes Est2',5,4,'Ferramenta de Lenhador, tier 5. Craftada via receita lenhador_ferramenta_n5_ref.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('medico_ferramenta_n2','Médico','Frasco Antisséptico',2,1,'Ferramenta de Médico, tier 2. Craftada via receita medico_ferramenta_n2.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('medico_ferramenta_n3_est1','Médico','Bandagem Purificada',3,1,'Ferramenta de Médico, tier 3. Craftada via receita medico_ferramenta_n3_est1.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('medico_ferramenta_n5_ref','Médico','Báculo Vida Est2',5,4,'Ferramenta de Médico, tier 5. Craftada via receita medico_ferramenta_n5_ref.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('medico_ferramenta_n5','Médico','Báculo Vida Est1',5,3,'Ferramenta de Médico, tier 5. Craftada via receita medico_ferramenta_n5.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('mercenario_ferramenta_n2','Mercenário','Colete Treino',2,1,'Ferramenta de Mercenário, tier 2. Craftada via receita mercenario_ferramenta_n2.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('mercenario_ferramenta_n3_est1','Mercenário','Forja Compacta',3,1,'Ferramenta de Mercenário, tier 3. Craftada via receita mercenario_ferramenta_n3_est1.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('mercenario_ferramenta_n5','Mercenário','Armadura Gladiador Est1',5,3,'Ferramenta de Mercenário, tier 5. Craftada via receita mercenario_ferramenta_n5.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('mercenario_ferramenta_n5_ref','Mercenário','Armadura Gladiador Est2',5,4,'Ferramenta de Mercenário, tier 5. Craftada via receita mercenario_ferramenta_n5_ref.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('musico_ferramenta_n2','Músico','Pauta Partitura',2,1,'Ferramenta de Músico, tier 2. Craftada via receita musico_ferramenta_n2.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('musico_ferramenta_n3_est1','Músico','Corda Encantada',3,1,'Ferramenta de Músico, tier 3. Craftada via receita musico_ferramenta_n3_est1.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('musico_ferramenta_n5','Músico','Harpa Coral Est1',5,3,'Ferramenta de Músico, tier 5. Craftada via receita musico_ferramenta_n5.',true,false)
  on conflict (id) do nothing;
insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, visivel, excluido)
  values ('musico_ferramenta_n5_ref','Músico','Lira Orfeu Est2',5,4,'Ferramenta de Músico, tier 5. Craftada via receita musico_ferramenta_n5_ref.',true,false)
  on conflict (id) do nothing;
