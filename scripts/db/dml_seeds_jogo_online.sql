-- SEEDS GERAIS: Jogo Online (Itens 1, 5, 7, 9, 10, 12, 14)
-- Execute DEPOIS de schema_jogo_online.sql
-- Ordem: ferramentas → moves_profissao update → cartas → missoes_quadro (seeds mínimos já estão no schema)

-- ============================================================
-- ITEM 14: Ferramentas de Ofício (16 profissões x 5 níveis)
-- Regra: cada ofício crafta a própria ferramenta.
--        Item único (não quebra). +3% de bônus por nível na ação específica.
--        Desbloqueia nível de ferramenta a cada 2 níveis de profissão.
-- ============================================================

INSERT INTO ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, receita, excluido, visivel) VALUES
-- Caçador (Reflexo) — ação: Rastrear e abater caça
('cacador_n1',  'Caçador',    'Arco de Caça Iniciante',      1, 3,  '+3% em missões de caça e coleta de materiais de caça',   '{"materiais":["Madeira Comum 5","Linho 2"]}',                false, true),
('cacador_n2',  'Caçador',    'Arco de Caça Treinado',        2, 6,  '+6% em missões de caça, chance extra de couro raro',      '{"materiais":["Madeira Incomum 5","Linho 3","Óleo Animal 2"]}',false, true),
('cacador_n3',  'Caçador',    'Bestinha de Precisão',         3, 9,  '+9% em caça, ignora 1 nível de ameaça no rastreio',      '{"materiais":["Madeira Rara 5","Aço 3","Mira Simples"]}',    false, true),
('cacador_n4',  'Caçador',    'Arco de Caça Épico',           4, 12, '+12% em caça, drop extra garantido de 1 material por missão', '{"materiais":["Chifre de Besta Épica","Aço Raro 3","Corda de Couro"]}', false, true),
('cacador_n5',  'Caçador',    'Arco do Caçador Lendário',     5, 15, '+15% em caça, chance de encontrar Ovo de Fera em missão',  '{"materiais":["Gema do Andar 10+","Osso de Chefe","Couro Lendário"]}', false, true),

-- Lenhador (Reflexo) — ação: Cortar madeira
('lenhador_n1', 'Lenhador',   'Machado de Lenhador Iniciante', 1, 3,  '+3% em coleta de madeira',                              '{"materiais":["Madeira Comum 10","Pedra 5"]}',               false, true),
('lenhador_n2', 'Lenhador',   'Machado de Lenhador Treinado',  2, 6,  '+6% em madeira, chance extra de madeira Incomum',        '{"materiais":["Madeira Comum 15","Aço Comum 5"]}',           false, true),
('lenhador_n3', 'Lenhador',   'Serra de Poda',                 3, 9,  '+9% em madeira, chance de obter madeira Rara',           '{"materiais":["Aço Incomum 8","Lâmina Dupla"]}',            false, true),
('lenhador_n4', 'Lenhador',   'Machado de Dupla Face',         4, 12, '+12% em madeira, +1 unidade por árvore',                '{"materiais":["Aço Raro 5","Cabouco de Carvalho Centenário"]}', false, true),
('lenhador_n5', 'Lenhador',   'Machado de Gigantes',           5, 15, '+15% em madeira, chance de obter madeira Épica',         '{"materiais":["Gema Andar 10+","Minério de Adamantita","Núcleo de Ent"]}', false, true),

-- Cartógrafo (Conhecimento) — ação: Mapear região
('cartografo_n1','Cartógrafo','Prancha de Desenho Simples',    1, 3,  '+3% em missões de mapeamento e reconhecimento',        '{"materiais":["Madeira Comum 3","Pergaminho 2","Carvão 2"]}',false, true),
('cartografo_n2','Cartógrafo','Bússola de Bolso',              2, 6,  '+6% em mapeamento, revela 1 ponto adjacente extra',    '{"materiais":["Cobre 3","Ímã","Pergaminho Incomum 2"]}',    false, true),
('cartografo_n3','Cartógrafo','Kit de Topografia',             3, 9,  '+9% em mapeamento, revela segredos de região',         '{"materiais":["Prata 3","Lente de Vidro","Pergaminho Raro"]}',false, true),
('cartografo_n4','Cartógrafo','Astrolábio Portátil',           4, 12, '+12% em mapeamento, reduz chance de erro em 10%',       '{"materiais":["Ouro 2","Lentes de Cristal","Engrenagens de Bronze"]}', false, true),
('cartografo_n5','Cartógrafo','Globo de Aincrad',              5, 15, '+15% em mapeamento, atalho de teleporte entre pontos visitados', '{"materiais":["Gema Mestra","Fragmento de Aincrad","Cristais Estrelados"]}', false, true),

-- Comerciante (Conhecimento) — ação: Negociar preço
('comerciante_n1','Comerciante','Balança de Bolso',            1, 3,  '+3% de preço melhor em compra/venda',                   '{"materiais":["Ferro Comum 3","Pratos de Cobre 2"]}',       false, true),
('comerciante_n2','Comerciante','Pergaminho de Mercado',       2, 6,  '+6% de negociação, conhece preço atual do mercado',    '{"materiais":["Pergaminho Incomum 2","Tinta 3","Lacre de Cera"]}', false, true),
('comerciante_n3','Comerciante','Tábua de Tarifas',            3, 9,  '+9% de negociação, evita golpes em até 15%',            '{"materiais":["Prata 3","Madeira Incomum","Caderno"]}',     false, true),
('comerciante_n4','Comerciante','Anel do Mercador',            4, 12, '+12% de negociação, cria contrato vinculante',          '{"materiais":["Ouro 3","Pedra de Selar","Runa de Veracidade"]}', false, true),
('comerciante_n5','Comerciante','Livro do Comércio Lendário',  5, 15, '+15% de negociação, acesso a itens exclusivos do mercado', '{"materiais":["Contrato de Dragão","Moeda Antiga","Pena de Fênix"]}', false, true),

-- Cozinheiro (Conhecimento) — ação: Preparar refeição
('cozinheiro_n1','Cozinheiro', 'Faca de Cozinheiro Iniciante', 1, 3,  '+3% de qualidade em refeições',                         '{"materiais":["Ferro Comum 2","Madeira 3","Pedra de Amolar"]}', false, true),
('cozinheiro_n2','Cozinheiro', 'Panela de Ferro',              2, 6,  '+6% em refeições, aumenta regeneração de buff',         '{"materiais":["Ferro Comum 5","Alça de Couro","Tampa"]}',   false, true),
('cozinheiro_n3','Cozinheiro', 'Conjunto de Temperos',         3, 9,  '+9% em refeições, cria efeito adicional temporário',    '{"materiais":["Vidro 5","Rótulos","Ervas Raras 3"]}',       false, true),
('cozinheiro_n4','Cozinheiro', 'Fogão Móvel',                  4, 12, '+12% em refeições, reduz tempo de preparo em 50%',       '{"materiais":["Aço Incomum 8","Tijolos Refratários","Canos"]}', false, true),
('cozinheiro_n5','Cozinheiro', 'Colher do Chefe Supremo',      5, 15, '+15% em refeições, receitas lendárias dão XP extra',    '{"materiais":["Cristal Culinário","Pele de Javali Épica","Essência de Dragão"]}', false, true),

-- Diplomata (Conhecimento) — ação: Negociar NPC
('diplomata_n1', 'Diplomata',  'Livro de Etiquetas',           1, 3,  '+3% em testes sociais e negociações com NPC',           '{"materiais":["Pergaminho 3","Tinta 2","Couro Comum"]}',   false, true),
('diplomata_n2', 'Diplomata',  'Cetro de Cerimônia',           2, 6,  '+6% em testes sociais, abre portas em guildas',          '{"materiais":["Madeira Nobre","Prata 2","Pérola"]}',        false, true),
('diplomata_n3', 'Diplomata',  'Selo Diplomático',             3, 9,  '+9% em testes sociais, cancela 1 ofensa por dia',       '{"materiais":["Ouro 2","Cera Nobre","Anel de Selo"]}',     false, true),
('diplomata_n4', 'Diplomata',  'Corrente de Escrivão',          4, 12, '+12% em testes sociais, reduz Suspeita do grupo',        '{"materiais":["Ouro 5","Estandarte Pequeno","Documento Real"]}', false, true),
('diplomata_n5', 'Diplomata',  'Trono Portátil do Embaixador', 5, 15, '+15% em testes sociais, convence chefes sem combate',   '{"materiais":["Coroa Simbólica","Manto de Honra","Pacto dos Ancestrais"]}', false, true),

-- Bibliotecário (Conhecimento) — ação: Pesquisar informação
('bibliotecario_n1','Bibliotecário','Marcador de Página',     1, 3,  '+3% em testes de conhecimento e pesquisa',              '{"materiais":["Pergaminho 2","Fita de Linho","Tinta"]}',    false, true),
('bibliotecario_n2','Bibliotecário','Lupa Simples',           2, 6,  '+6% em pesquisa, encontra pista escondida',             '{"materiais":["Lente de Vidro","Armadura de Latão","Alça"]}',false, true),
('bibliotecario_n3','Bibliotecário','Grimório de Anotações',  3, 9,  '+9% em pesquisa, reduz tempo de estudo em 30%',          '{"materiais":["Couro Nobre","Pergaminhos Incomuns 10","Tinta Especial"]}', false, true),
('bibliotecario_n4','Bibliotecário','Cristal de Memória',     4, 12, '+12% em pesquisa, grava conhecimento pra consulta',     '{"materiais":["Cristal Branco","Runa de Memória","Base de Ouro"]}', false, true),
('bibliotecario_n5','Bibliotecário','Tomo da Sabedoria',      5, 15, '+15% em pesquisa, concede 1 relançamento de teste por dia','{"materiais":["Pele de Dragão","Tinta Lendária","Páginas de Grifinória"]}', false, true),

-- Alquimista (Conhecimento) — ação: Destilar poção
('alquimista_n1','Alquimista', 'Cadinho de Barro',            1, 3,  '+3% em sucesso de destilação de poções',                '{"materiais":["Argila 5","Palheta de Madeira","Carvão"]}', false, true),
('alquimista_n2','Alquimista', 'Frascos Padronizados',        2, 6,  '+6% em poções, reduz chance de efeito colateral',       '{"materiais":["Vidro 10","Cortiça 5","Rótulos 10"]}',       false, true),
('alquimista_n3','Alquimista', 'Alambique Simples',           3, 9,  '+9% em poções, rende 1 unidade extra',                  '{"materiais":["Vidro Temperado 5","Cobre 3","Tubo de Ensaio"]}', false, true),
('alquimista_n4','Alquimista', 'Caldeirão de Cobre',          4, 12, '+12% em poções, cria poção de qualidade superior',      '{"materiais":["Cobre 12","Pedra de Fogo","Alça de Ferro"]}',false, true),
('alquimista_n5','Alquimista', 'Pedra Filosofal Portátil',    5, 15, '+15% em poções, transmuta materiais comuns em raros',   '{"materiais":["Mercúrio Lendário","Enxofre Puro","Sal de Filósofo"]}', false, true),

-- Costureiro (Técnica) — ação: Costurar roupa/equipamento
('costureiro_n1','Costureiro', 'Agulha de Aço',               1, 3,  '+3% em costura e criação de tecidos',                   '{"materiais":["Aço Comum 2","Linho 10","Linha 5"]}',       false, true),
('costureiro_n2','Costureiro', 'Máquina de Costura Manual',   2, 6,  '+6% em costura, aumenta defesa de armaduras leves',     '{"materiais":["Ferro 5","Madeira Nobre 3","Agulhas Extra"]}', false, true),
('costureiro_n3','Costureiro', 'Estojo de Bordados',          3, 9,  '+9% em costura, adiciona efeitos de status em roupas',  '{"materiais":["Fios Coloridos 20","Lantejoulas","Agulhas Curvas"]}', false, true),
('costureiro_n4','Costureiro', 'Tear Mágico',                 4, 12, '+12% em costura, cria tecido com propriedades mágicas',  '{"materiais":["Runa de Tecelagem","Fios de Prata","Estrutura de Carvalho"]}', false, true),
('costureiro_n5','Costureiro', 'Agulha dos Deuses',           5, 15, '+15% em costura, roupas concedem resistência elemental','{"materiais":["Fio de Destino","Metal das Fadas","Fragmento de Lendário"]}', false, true),

-- Domador (Técnica) → Criador — ação: Chocar ovo de Fera
('domador_n1',  'Domador',    'Incubadora Pequena',           1, 3,  '+3% de chance do Ovo de Fera chocar',                   '{"materiais":["Madeira Comum 8","Palha 10","Frasco de Névoa Quente"]}', false, true),
('domador_n2',  'Domador',    'Incubadora Média',             2, 6,  '+6% de chance de chocar, reduz tempo em 12h',           '{"materiais":["Vidro 5","Aço Incomum 3","Termômetro"]}',  false, true),
('domador_n3',  'Domador',    'Incubadora de Raridade',       3, 9,  '+9% de chance, permite Ovo de raridade Rara',           '{"materiais":["Prata 5","Gema Branca 2","Manta Térmica"]}',false, true),
('domador_n4',  'Domador',    'Incubadora Sagrada',           4, 12, '+12% de chance, nasce com bônus de atributo',           '{"materiais":["Ouro 3","Cristal Gênesis 2","Runa de Vida"]}',false, true),
('domador_n5',  'Domador',    'Incubadora Primordial',        5, 15, '+15% de chance, permite Ovo de chefes/Épicos',          '{"materiais":["Fragmento de Aincrad","Núcleo de Dragão","Fonte da Juventude"]}', false, true),

-- Ferreiro (Técnica) — ação: Forjar arma/equipamento
('ferreiro_n1', 'Ferreiro',   'Martelo de Ferreiro',          1, 3,  '+3% em forja, reduz consumo de minério',                '{"materiais":["Ferro Comum 5","Madeira 3","Rebites"]}',    false, true),
('ferreiro_n2', 'Ferreiro',   'Bigorna Portátil',             2, 6,  '+6% em forja, aumenta durabilidade do item',            '{"materiais":["Ferro 10","Aço Comum 5","Pé de Cabra"]}',   false, true),
('ferreiro_n3', 'Ferreiro',   'Fole Duplo',                   3, 9,  '+9% em forja, permite armas de raridade Rara',          '{"materiais":["Couro 5","Madeira Nobre 5","Bronze"]}',     false, true),
('ferreiro_n4', 'Ferreiro',   'Dado de Corte',                4, 12, '+12% em forja, cria arma com efeito adicional',         '{"materiais":["Aço Incomum 8","Modelos de Corte","Óleo de Templo"]}', false, true),
('ferreiro_n5', 'Ferreiro',   'Fornalha de Vulcano',          5, 15, '+15% em forja, cria itens Únicos/Épicos',               '{"materiais":["Minério de Adamantita","Chama de Dragão","Bigorna Lendária"]}', false, true),

-- Joalheiro (Técnica) — ação: Lapidar jóia / criar anel
('joalheiro_n1','Joalheiro',  'Lixa Simples',                 1, 3,  '+3% em lapidação de gemas e jóias',                     '{"materiais":["Pano Macio 3","Pó de Esmeril","Lixa Fina"]}',false, true),
('joalheiro_n2','Joalheiro',  'Alicate de Ourives',           2, 6,  '+6% em jóias, aumenta bônus de atributo',               '{"materiais":["Aço 4","Cortadores","Pinça"]}',             false, true),
('joalheiro_n3','Joalheiro',  'Paquímetro de Precisão',       3, 9,  '+9% em jóias, evita desperdício de pedra',              '{"materiais":["Bronze","Marcador","Lupa de Lapidação"]}',  false, true),
('joalheiro_n4','Joalheiro',  'Mesa de Ourives',              4, 12, '+12% em jóias, cria anel com 2 slots de gema',          '{"materiais":["Mesa de Carvalho","Ferramentas Miniatura","Candeeiro"]}', false, true),
('joalheiro_n5','Joalheiro',  'Gema da Criação Lendária',     5, 15, '+15% em jóias, concede propriedade mágica única',       '{"materiais":["Olho de Fênix","Pó de Diamante","Molde de Dragão"]}', false, true),

-- Coveiro (Espírito) — ação: Preparar corpo / lidar com morto-vivo
('coveiro_n1',  'Coveiro',    'Pá Simples',                   1, 3,  '+3% em lidar com morto-vivo e conhecimento fúnebre',     '{"materiais":["Madeira 5","Ferro 3","Prego 10"]}',         false, true),
('coveiro_n2',  'Coveiro',    'Lanterna de Luto',             2, 6,  '+6% em morto-vivo, acalma espíritos inquietos',          '{"materiais":["Vidro Fumê","Óleo Mineral","Ferro Escuro"]}',false, true),
('coveiro_n3',  'Coveiro',    'Livro dos Mortos',             3, 9,  '+9% em morto-vivo, afasta aparições por 1 cena',         '{"materiais":["Couro Preto","Tinta Sangrenta","Pergaminho Antigo 5"]}', false, true),
('coveiro_n4',  'Coveiro',    'Incensário de Purificação',    4, 12, '+12% em morto-vivo, purifica área amaldiçoada',          '{"materiais":["Bronze","Incenso Sagrado 10","Brasa de Templo"]}', false, true),
('coveiro_n5',  'Coveiro',    'Foice de São Juízo',           5, 15, '+15% em morto-vivo, derrota espectro instantaneamente',  '{"materiais":["Aço Bento","Lâmina Ossada","Cabo de Carvalho Negro"]}', false, true),

-- Médico (Espírito) — ação: Curar / tratar ferimento
('medico_n1',   'Médico',     'Estojo de Curativos',          1, 3,  '+3% em cura e primeiros socorros',                       '{"materiais":["Linho 5","Álcool 2","Ataduras 10"]}',       false, true),
('medico_n2',   'Médico',     'Frasco de Antisséptico',       2, 6,  '+6% em cura, evita infecção em feridas',                '{"materiais":["Vidro 3","Ervas Medicinais 5","Receituário"]}', false, true),
('medico_n3',   'Médico',     'Kit Cirúrgico Básico',         3, 9,  '+9% em cura, realiza pequenas cirurgias',                '{"materiais":["Aço Inoxidável 5","Gaze 10","Anestésico"]}',false, true),
('medico_n4',   'Médico',     'Seringa de Platina',           4, 12, '+12% em cura, aplica poção injetável potente',           '{"materiais":["Platina 3","Agulha Hipodérmica","Pistão"]}',false, true),
('medico_n5',   'Médico',     'Báculo da Vida',               5, 15, '+15% em cura, ressuscita aliado 1x por dia (sem morte permanente)', '{"materiais":["Árvore da Vida","Essência de Fênix","Gema da Cura"]}', false, true),

-- Músico (Espírito) — ação: Atuar / inspirar aliados
('musico_n1',   'Músico',     'Afinador Simples',             1, 3,  '+3% em testes de música e inspiração de aliados',        '{"materiais":["Madeira 3","Pino de Latão","Penas 5"]}',    false, true),
('musico_n2',   'Músico',     'Pauta e Partitura',            2, 6,  '+6% em atuação, inspira mais 1 aliado por cena',         '{"materiais":["Pergaminho 5","Tinta 3","Régua"]}',         false, true),
('musico_n3',   'Músico',     'Amplificador Acústico',        3, 9,  '+9% em atuação, adiciona efeito de amedrontar inimigos','{"materiais":["Cone de Madeira","Couro Esticado","Régua de Som"]}', false, true),
('musico_n4',   'Músico',     'Coral Portátil',               4, 12, '+12% em atuação, canção cria barreira de som',           '{"materiais":["Mini-Harpa","Bóias de Água","Caixa de Eco"]}',false, true),
('musico_n5',   'Músico',     'Lira de Orfeu',                5, 15, '+15% em atuação, domar feras pela canção',              '{"materiais":["Caixa de Tartaruga","Corda de Tripa de Dragão","Pena de Cisne Negro"]}', false, true),

-- Mercenário (Corpo) — ação: Treinar / sobreviver em combate
('mercenario_n1','Mercenário','Chave de Punho',               1, 3,  '+3% em dano corpo a corpo bônus e treino diário',        '{"materiais":["Couro Cru 3","Pano de Limpeza","Aço Comum"]}', false, true),
('mercenario_n2','Mercenário','Colete de Treino',            2, 6,  '+6% em sobrevivência, reduz dano recebido em treino',    '{"materiais":["Couro 5","Rebites 10","Peso 5kg"]}',        false, true),
('mercenario_n3','Mercenário','Kit de Sobrevivência',        3, 9,  '+9% em sobrevivência, acampa em qualquer lugar',        '{"materiais":["Lona","Cantil","Isqueiro","Barraca Miniatura"]}', false, true),
('mercenario_n4','Mercenário','Escudo de Combate',           4, 12, '+12% em combate, bloqueia 1 ataque extra por cena',     '{"materiais":["Aço Incomum 8","Couro Nobre","Bordas Reforçadas"]}', false, true),
('mercenario_n5','Mercenário','Armadura do Gladiador',       5, 15, '+15% em combate, ativa Rage (2x dano por 1 cena)',      '{"materiais":["Adamantita 5","Cristais de Rage","Peitoral de Campeão"]}', false, true)
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- ITEM 1: Move do Domador (Criador) — Ovo de Fera
-- Atualiza move_c de moves_profissao para o Domador (Move Ovo de Fera)
-- ============================================================

UPDATE moves_profissao SET
  move_c = '{
    "nome": "Move de Ofício — Ovo de Fera",
    "atributo": "Técnica",
    "teste": "2d6+Técnica",
    "gatilho": "Quando você passar tempo suficiente com um Ovo de Fera (drop ou recompensa) usando sua Incubadora.",
    "sucesso_total": [
      "O ovo choca com sucesso e o pet nasce com 1 raridade acima do esperado (Comum→Incomum, Incomum→Raro, Raro→Épico).",
      "O pet nasce com um efeito extra ligado à espécie de origem (ex: Aguia de Pedra ganha voo curto, Slime absorve 1 golpe por dia).",
      "Você aprende algo sobre a espécie: +1 Conhecimento permanente sobre criaturas daquele tipo.",
      "O pet reconhece você como seu cuidador: desobedece a ordens de terceiros.",
      "O nascimento é visível e atrai atenção na cidade: +1 de Favor com a guilda de Domadores."
    ],
    "sucesso_parcial": [
      "O ovo choca, mas o pet nasce com a raridade padrão (sem upgrade).",
      "O pet é pequeno e frágil nos primeiros dias: demora o dobro do tempo pra demonstrar seu efeito.",
      "O pet tem uma deficiência genérica (ex: cego de um olho, medo de fogo) — tem papel de cena, não penalidade mecânica.",
      "O nascimento dá um pequeno susto: alguém próximo se machuca levemente (dano cenográfico).",
      "Você tem dúvida sobre a alimentação correta: gasta 50 Col extras em itens pra o primeiro mês."
    ],
    "complicou": [
      "O ovo racha e o filhote nasce morto. A Incubadora permanece intacta.",
      "O ovo eclode mas o filhote nasce agressivo: você tem que soltá-lo na natureza antes que ele ataque alguém.",
      "A Incubadora queima um componente: tem que trocar antes da próxima chocagem (custo 20% da receita de nível).",
      "O pet sobrevive mas nasce com 1 raridade ABAIXO do esperado (Incomum→Comum; Raro→Incomum).",
      "O ovo eclode de noite atrai um monstro ao redor do seu ponto de incubação: cena de combate surpresa."
    ],
    "regras_especiais": [
      "Cada ovo tem tempo de chocagem em horas reais (online), diminuído pelo nível da Incubadora.",
      "Pet é item do inventário (tipo = pet), não ficha própria: efeito segue a régua de raridade.",
      "Raridade do ovo define o resultado base: sucesso parcial mantém, sucesso total sobe 1 nível."
    ]
  }'::jsonb
WHERE nome = 'Domador';

-- ============================================================
-- ITEM 5: Curva XP de Personagem (Andar 1 → Nível máximo 10)
-- Progressão em eventos de mesa (não afeta jogo online diretamente)
-- Tabela referencial (inserida como sistema, pode ser view ou tabela)
-- ============================================================

-- Aqui fica o GUIDE: documentação apenas. O schema real de níveis por personagem fica em nivel_profissao.

-- ============================================================
-- ITEM 7: Cartas de Monstro (Catálogo Inicial - Andar 1)
-- Cartas: < 1% MVP, ~5% Boss. Bônus de atributo, dano ou resist.
-- 1 carta equipável só por personagem.
-- ============================================================

INSERT INTO cartas (id, nome, raridade, tipo_bonus, valor_bonus, descricao, drop_de, chance_drop, excluido, visivel) VALUES
-- MVP / Épicos (menos de 1%)
('carta_baran',      'Baran, o Rei Touro',  'Épico',   'atributo',  2, '+2 Corpo enquanto equipada. Quando você faz 10+ num teste de Corpo, o próximo golpe não conta limite diário.', 'Baran, o Rei Touro', 0.8,  false, true),
('carta_illfang',    'Illfang, o Kobold Lord', 'Épico', 'dano',     1, '+1 dano em qualquer arma. Contra humanoides, isso vira +2.', 'Illfang the Kobold Lord', 0.8, false, true),

-- Bosses (cerca de 5% por chefe)
('carta_mae_raiz',   'Mãe-Raiz de Horunka', 'Raro',    'resist',    1, '-1 dano recebido de plantas. Em floresta, +1 Reflexo passivo.', 'Mãe-Raiz de Horunka', 5.0, false, true),
('carta_guardiao_m', 'Guardião de Mournhall', 'Raro',  'atributo',  1, '+1 Espírito passivamente. Reduz Bug em 1 se você falhar missão solo.', 'Guardião de Mournhall', 5.0, false, true),
('carta_sombra_m',   'Sombra de Mournhall', 'Raro',     'resist',    1, '-1 dano de morto-vivo. À noite, +1 em ataques furtivos.', 'Sombra de Mournhall', 5.0, false, true),
('carta_arauto',     'Arauto das Alturas',  'Raro',     'atributo',  1, '+1 Reflexo. Quando você toma dano de queda, pode rolar Reflexo pra ignorar metade.', 'Arauto das Alturas', 5.0, false, true),
('carta_rei_plan',   'Rei das Planícies',   'Raro',     'dano',      1, '+1 dano contra Bestas. Bestas de pequeno porte não te atacam de surpresa.', 'Rei das Planícies', 5.0, false, true),

-- Incomuns (drops mais largos: ~10-15%, só para referência — jogador pode equipar só 1)
('carta_alfa_lupo',  'Alfa Lupino',         'Incomum',  'dano',     0, 'Testes de intimidar animais: você rola com vantagem (melhor de 2).', 'Alfa Lupino', 15.0, false, true),
('carta_ent',       'Ent Ancião',          'Incomum',  'resist',    0, 'Florestas são terreno seguro pra você: descanso recupera 1 fôlego extra no online.', 'Ent Ancião', 12.0, false, true),
('carta_slime',      'Slime',               'Incomum',  'atributo',  0, '+1 Conhecimento em testes de identificar criaturas.', 'Slime', 20.0, false, true),

-- Comuns (raridade baixa, catálogo de referência)
('carta_urso',       'Urso de Pedra',       'Comum',    'dano',      0, 'Você pode agarrar um inimigo de mesmo porte depois de 10+ em golpe corpo a corpo.', 'Urso de Pedra', 25.0, false, true),
('carta_coruja',     'Coruja das Sombras',  'Comum',    'atributo',  0, 'Visão noturna passiva. Ignora penalidade de escuridão em combate noturno.', 'Coruja das Sombras', 22.0, false, true)
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- ITEM 7: Cristais (Socket em arma/equipamento — 100% em Boss)
-- Diferente de carta: cristal é SOCKET em item específico do inventario.cristal_id
-- ============================================================

INSERT INTO cristais (id, nome, tipo_bonus, valor_bonus, descricao, drop_de, excluido, visivel) VALUES
('cristal_fogo',    'Cristal de Chamas',    'dano',     1, 'Socket em arma. +1 dano contra plantas e mortos-vivos.', 'Qualquer Boss de tipo planta/incêndio', false, true),
('cristal_gelo',    'Cristal de Gelo',      'resist',   1, 'Socket em peitoral. -1 dano de fogo ou frio recebido.', 'Boss de tipo água/gelo', false, true),
('cristal_trovao',  'Cristal de Trovão',    'atributo', 1, 'Socket em arma. +1 Reflexo enquanto equipado.', 'Boss de tipo trovão/elétrico', false, true),
('cristal_veneno',  'Cristal de Veneno',    'dano',     1, 'Socket em arma. Ataques aplicam sangramento leve (1 dano extra por 2 rodadas).', 'Boss de tipo inseto/veneno', false, true),
('cristal_vida',    'Cristal de Vida',      'resist',   2, 'Socket em qualquer equipamento. -2 dano de qualquer golpe que mataria você (1x por dia).', 'MVP / Chefe de Andar', false, true),
('cristal_sorte',   'Cristal da Sorte',     'atributo', 0, 'Socket em qualquer item. 1 vez por dia, você pode transformar um 6 num 7 no resultado de 2d6.', 'Chefe Secreto / Raro drop', false, true)
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- ITEM 9 e 10: Reputação e Mordomias (documentados em tabela)
-- A tabela reputacao_personagem armazena -3 a +3 por clã por jogador.
-- Valores de referência — efeitos narrativos (implementados no painel/html):
--
-- -3 Suspeito:   Sem acesso a guilda, alerta guarda, +20% preço em lojas
-- -2 Indesejado: Alojamento proibido, sem ajuda de NPCs da guilda
-- -1 Desconfiado:    +10% preço lojas, serviço de ofício negado
--  0 Neutro:     Preço normal
-- +1 Conhecido: -5% preço em lojas da guilda, 1 informação pública/dia
-- +2 Respeitado:    -10% preço, contrato de serviço prioritário, 1 favor pequeno por semana
-- +3 Honorário: Acesso a quartos da guilda, reunião com líder, 1 favor médio por semana (missão exclusiva)
--
-- (Favor grande — clã te salva — é narrativo, não mecânico.)
-- ============================================================

-- Fim seeds
