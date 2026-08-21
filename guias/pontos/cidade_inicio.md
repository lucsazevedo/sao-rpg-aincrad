---
titulo: Pontos — Cidade do Início
regiao: cidade_inicio
andar: 1
pontos: 18
---

# Pontos da Cidade do Início

Conteúdo próprio de **cada ponto clicável** da capital. O guia da região
(`guias/01_coracao_do_andar.md`) dá o clima e a visão geral; aqui está o que o
mestre precisa quando o grupo para num lugar específico e pergunta "o que tem
aqui?".

Formato de cada ponto: texto de leitura em voz alta, o que é, a tabela de
ações com teste, o que só o mestre sabe e os atalhos (NPC, quest, região).

O gerador (`scripts/gerar_dados_web.py`) lê este arquivo e o Compêndio mostra
tudo isso ao clicar no marcador. **Um arquivo destes por região** — este é o
molde para os outros 29.

---

### cidade_praca · Praça do Portão de Teletransporte
> A praça é redonda e larga demais pro número de gente que sobrou nela. No
> centro, o portão de teletransporte: um arco de pedra clara com uma película
> azul girando devagar dentro, sem barulho nenhum. Tem uma marca no chão em
> volta dele, um círculo gasto — dez mil pessoas apareceram exatamente ali no
> dia 1 e ninguém pisa mais no meio.

**O que é:** o centro geográfico e emocional do andar. Todo evento de cidade
acontece aqui. O portão só leva a destinos já registrados, e no dia 10 isso
significa **a própria cidade e nada mais** — piada amarga que os jogadores
fazem sozinhos na primeira vez que testam.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Ler o clima da praça | d20+Sabedoria | Sabe quem está indo pro campo hoje, quem desistiu e quem está esperando alguém voltar | Percebe a tensão, não a causa | Só vê gente andando |
| Ouvir boato | d20+Sabedoria | Um boato verdadeiro **e** a fonte dele | Um boato verdadeiro, fonte desconhecida | Um boato falso que soa verdadeiro |
| Falar em voz alta pra praça | d20+Sabedoria | Vinte pessoas param e ouvem até o fim | Metade ouve, metade zomba | Ninguém para, e alguém repete o que você disse imitando você |
| Tocar o portão | — | Sem teste. Ele responde "destino não registrado" com voz de sistema. Sempre |  |  |

**Só o mestre:** o círculo gasto no chão é o melhor detalhe da cidade. Descreva
uma vez, no primeiro dia, e nunca explique. Se algum jogador pisar de propósito
no meio, alguém na praça reage — não com raiva, com desconforto.

**Atalhos:** regiao:cidade_inicio · quest:castelo_01_cantiga_do_musico

---

### cidade_lynx · Loja de Armaduras (Lynx)
> Balcão baixo, prateleiras até o teto, e Lynx de pé — ela nunca senta. Tem
> sempre uma peça na mão que ela está examinando enquanto fala com você, e ela
> olha pra peça, não pra você, até decidir que vale a pena.

**O que é:** a loja de armadura da capital e o atalho canônico para Tolbana.
Vende **pronto e caro**, sem exigir material — é o caminho de quem tem Col e
não tem tempo (ver `docs/mercado_andar1.md`).

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Perguntar sobre o Labirinto | — | Sem teste. Ela manda o grupo procurar a amiga dela em **Tolbana**. Sempre a mesma resposta |  |  |
| Pechinchar | d20+Inteligência | 10% de desconto e ela passa a te reconhecer | Preço cheio, mas ela explica por que aquela peça vale | Ela devolve a peça pra prateleira |
| Pedir conselho de equipamento | d20+Sabedoria | Ela olha o grupo inteiro e diz **quem** vai morrer primeiro e por quê | Ela aponta uma falha só | "Compra o que puder pagar" |
| Vender espólio | — | 40% do preço base, como qualquer NPC |  |  |

**Só o mestre:** Lynx não é fria, é econômica. Ela quer que o grupo volte —
cliente morto não compra. Se o grupo já a ajudou alguma vez, o desconto de 10%
é permanente e ela lembra do nome de todo mundo.

**Atalhos:** npc:lynx · regiao:tolbana

---

### cidade_mulher_aflita · Alambique da Mulher Aflita
> Um cômodo estreito com cheiro forte de erva fervida e três bancadas
> ocupadas por vidro. Ela trabalha de costas pra porta e responde sem virar.
> Tem uma bolsa de coleta pendurada no prego ao lado da saída, vazia, com
> poeira em cima.

**O que é:** alquimia e compra de material — e o primeiro sinal do puzzle da
Necrópole de Voss. Ela paga bem por Seiva, Ervas e Ferrão porque **não sai
mais dos muros** desde o dia 5.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Vender material de coleta | — | Preço de tabela +10% se vier limpo (`docs/mercado_andar1.md`) |  |  |
| Perguntar por que ela não sai | d20+Sabedoria | Ela conta do dia 5 sem detalhe, e isso já é muito | "Já saí o suficiente." Fim | Ela pede pra você comprar ou ir embora |
| Encomendar antídoto | d20+Inteligência | Fica pronto na mesma sessão | Pronto na próxima, e ela cobra o frasco | Falta frasco — e frasco só vem do Comerciante |
| Mencionar a Necrópole de Voss | d20+Sabedoria | Ela para de mexer nas mãos. Isso é a informação | Ela muda de assunto rápido demais | Ela te dispensa educadamente |

**Só o mestre:** ela é **Talia** (`npcs/talia.md`), irmã do nome apagado da
lápide de Voss. Não confirme cedo. A bolsa de coleta com poeira é a pista
plantada — deixe visível toda vez, sem comentar.

**Atalhos:** npc:talia · npc:mulher_aflita · puzzle:3

---

### cidade_garota_arco · Pátio da Garota do Arco
> Um pátio de terra batida atrás da loja de armas, com três alvos de palha
> castigados demais pro tempo que existem. Ela atira, anda até o alvo, volta,
> atira de novo. Não usa luva. Os dedos mostram isso.

**O que é:** treino aberto e a melhor aliada temporária de campo pra grupo
novo. Ela topa expedição, mas não vai sozinha e diz isso sem vergonha.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Treinar tiro com ela | d20+Destreza | Ela corrige seu erro: +1 no primeiro teste de arma à distância da próxima sessão | Você acerta o alvo e nada mais | Estraga uma flecha dela, e ela conta as flechas |
| Convidar pra uma expedição | d20+Sabedoria | Ela vai, e vale por um personagem inteiro em campo aberto | Ela vai, mas só até onde der pra ver a muralha | Recusa: "não com esse plano" |
| Perguntar por que não vai sozinha | d20+Sabedoria | Ela responde de verdade, e é uma resposta boa | Piada e desvio | Silêncio constrangido |
| Comprar dedeiras / arco | — | Depois de duas expedições juntas, ela vende as `Dedeiras de Arqueiro` (250 Col) |  |  |

**Só o mestre:** os dedos machucados são gancho — ela treina demais porque
acha que não é boa o suficiente, e é ótima. Um elogio específico (não genérico)
vale mais que Col com ela.

**Atalhos:** npc:garota_do_arco · arma:dedeiras_de_arqueiro

---

### cidade_armas · Loja de Armas
> Um barracão de madeira colado na parede da igreja, com as vinte e duas armas
> penduradas por tipo em ganchos numerados. O dono está sentado num banquinho
> lendo alguma coisa e não levanta os olhos quando vocês entram.

**O que é:** loja de sistema. Preço fixo, sem desconto, **sem nada acima de
Comum**. É onde o personagem novo compra a primeira arma e onde ninguém volta
depois do dia 15.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Comprar arma Comum | — | 80-200 Col conforme o tipo. Todos os 22 tipos sempre em estoque |  |  |
| Experimentar uma arma que não é a sua | d20+Destreza | Você entende a Marca daquela arma — e o mestre te diz qual é | Você entende que não é pra você | Derruba, e o dono levanta os olhos |
| Perguntar o que vende melhor | d20+Inteligência | "Espada Longa. Sempre Espada Longa." E ele diz por quê, e é sobre medo | Ele responde só o nome | Ele dá de ombros |
| Comprar flecha / virote | — | 15 Col o lote de 20 |  |  |

**Só o mestre:** o dono já viu gente demais comprar a primeira espada. Ele não
é rude, é poupado. Se um jogador perguntar o nome dele, ele diz — e ninguém
nunca perguntou.

**Atalhos:** regiao:cidade_inicio

---

### cidade_ferreiro · Forja de Kazuo
> Fogo aceso o dia inteiro, mesmo sem encomenda. Kazuo trabalha de costas pra
> rua, e a primeira coisa que vocês veem dele é a cicatriz de brasa no
> antebraço direito, que aparece toda vez que ele levanta o martelo.

**O que é:** o coração da economia do andar. Vende **componente e conserto**,
não arma pronta — e explica o motivo sem que ninguém pergunte.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Comprar Placas de Metal Refinado | — | 90 Col cada, 3 por semana. Com Minério Raro próprio: -15% |  |  |
| Consertar peça rachada | — | 1/5 do preço base do item |  |  |
| Pedir pra ele avaliar um material | d20+Inteligência | Ele diz o que dá pra fazer com aquilo e quanto vale | Diz se presta ou não | Ele está no meio de uma têmpera e manda voltar |
| Mostrar Fragmento de Armadura Kobold | — | Sem teste. Ele **para tudo**. Desconto de 20% e ele passa a pedir mais |  |  |
| Encomendar arma Incomum | d20+Destreza (dele) | Fica pronta numa sessão | Pronta, mas ele usou material seu a mais | Ele recusa: falta componente |

**Só o mestre:** Kazuo tem uma lista mental de gente de clã com quem está de
mal e não explica pra ninguém — só diz "hoje não". Use isso quando o grupo
estiver alinhado com um clã que ele evita (`docs/registro_clas_e_reputacao.md`).

**Atalhos:** npc:kazuo_tanaka · regiao:montanhas

---

### cidade_ateliê · Ateliê de Mestra Sorrel
> Uma sala pequena com retalhos organizados por tipo, cor e espessura num
> sistema que só ela entende. Ela olha vocês de cima a baixo antes de dizer
> qualquer coisa — não com desprezo, com medida. Está literalmente tirando
> medidas.

**O que é:** roupa, armadura leve e o conjunto do Batedor. Também é a NPC que
lembra de todo cliente e do que ele vestia — fonte de informação que ninguém
pensa em consultar.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Comprar peça de tecido/couro | — | Tabela de `docs/mercado_andar1.md`. Com Pelagem Azulada própria: -20% |  |  |
| Perguntar quem comprou o quê | d20+Sabedoria | Ela lembra da pessoa, da peça e do dia | Lembra da peça, não da pessoa | "Não falo de cliente" |
| Pedir avaliação do seu equipamento | d20+Destreza | Ela aponta a falha exata e conserta na hora | Aponta a falha, cobra pra consertar | "Serve." (e é elogio) |
| Encomendar o Traje de Batedor | — | Ela monta as três peças se o grupo trouxer material; mais caro que em Horunka e melhor feito |  |  |

**Só o mestre:** se o grupo aparecer com equipamento rachado três vezes
seguidas, ela senta os quatro e dá uma bronca de dez minutos sobre manutenção.
Depois conserta de graça. É uma das cenas mais queridas da campanha.

**Atalhos:** npc:mestra_sorrel · equip:coleto_do_batedor_de_horunka

---

### cidade_mercado_negro · Ruela das Versões
> Um beco entre dois prédios onde não bate sol. Três vendedores, e nunca são
> os mesmos três. Ninguém anuncia nada em voz alta; eles esperam você olhar
> pra alguma coisa e só então falam.

**O que é:** tudo 30% mais barato e tudo com **risco declarado**. O mestre rola
o risco escondido (`docs/mercado_andar1.md`).

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Comprar item sem procedência | d20+Inteligência | Você identifica o risco antes de pagar | Compra sem saber qual é o risco | Compra o pior item da banca achando que é o melhor |
| Perguntar de onde veio | d20+Sabedoria | Uma meia-verdade útil | "De alguém." | Encerram a conversa e somem por uma semana |
| Vender algo que não é seu | d20+Inteligência | Vendido, sem perguntas, 60% do valor | Vendido a 40%, e alguém viu | Alguém reconhece o item |
| Comprar Cristal "recuperado" | — | 200 Col (de 350). 20% de chance de ser um Cristal de Luz repintado |  |  |

**Só o mestre:** clãs evitam ser vistos aqui. Um Diplomata pego comprando
perde o efeito do `Selo de Trégua` até reparar publicamente. Isso é
consequência social, não punição — anuncie o risco antes.

**Atalhos:** regiao:trilha_contrabandistas · npc:contato_sem_nome

---

### cidade_treinamento · Centro de Treinamento
> Um pátio cercado com sete bonecos de pano, três deles já sem cabeça. Um
> instrutor NPC repete a mesma frase a cada cinco minutos, e ninguém está
> ouvindo mais.

**O que é:** o mais perto de tutorial que a cidade oferece, e o melhor lugar
pra um personagem novo entrar na mesa sem justificativa nenhuma.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Treinar sua arma | d20+Destreza | Entende sua arma: +1 no primeiro teste dela na próxima sessão | Treina e cansa, sem efeito | Machuca o pulso: complicação no primeiro combate |
| Ensinar alguém | d20+Sabedoria | O aluno ganha o +1 em vez de você, e te deve uma | Ele entende metade | Ele entende errado, e você vai ver isso em campo |
| Observar quem treina | d20+Inteligência | Você identifica dois jogadores competentes pra recrutar depois | Um só | Todo mundo parece igual |
| Provocar um duelo de treino | d20+Destreza | Vitória limpa, e a plateia reparou | Empate suado | Derrota, e a plateia reparou mais ainda |

**Só o mestre:** a frase repetida do instrutor deve ser sempre a mesma, toda
vez que o grupo passar. Depois de três sessões, mude uma palavra e veja se
alguém nota.

**Atalhos:** regiao:cidade_inicio

---

### cidade_taverna · Taverna de Perim
> Salão de teto baixo, cheio na hora do almoço e vazio às três da tarde. Perim
> está num banquinho perto da lareira com um alaúde que não é dele, tocando a
> mesma cantiga de sempre. Ninguém presta atenção. Ele toca mesmo assim.

**O que é:** boato de ouvido e a **chave do puzzle do mural**. A cantiga do
"Peregrino Perdido" carrega a ordem dos cinco cristais.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Ouvir a cantiga de verdade | d20+Sabedoria (Músico: automático) | Decora a letra inteira e sacou que são cores de cristal | Decora a letra | Lembra do refrão e mais nada |
| Comprar boato | d20+Inteligência | Dois boatos, um deles conferível hoje | Um boato | Um boato velho que todo mundo já sabe |
| Tocar junto com ele (Músico) | — | Sem teste. Ele solta o **sexto verso** que acha que inventou sozinho |  |  |
| Pagar uma rodada pra mesa | — | 30 Col. Todo mundo fala com vocês pelo resto da tarde |  |  |

**Só o mestre:** Perim não faz ideia do que carrega. Se perguntarem do mural,
ele responde "que mural?" com sinceridade total. O alaúde emprestado é do
gancho pessoal dele — só entregue se insistirem três vezes.

**Atalhos:** npc:perim · puzzle:1 · quest:castelo_01_cantiga_do_musico

---

### cidade_hospedaria · Hospedaria da Porta Aberta
> Construção de dois andares com a porta escorada aberta com uma pedra, de
> propósito, a qualquer hora. Lá dentro é limpo e silencioso, e tem uma mesa
> perto da entrada com água e pão que ninguém está cobrando.

**O que é:** cama paga e o ponto de apoio da **Nadia** (`npcs/nadia.md`). A
porta escorada é decisão dela, não descuido.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Dormir | — | 15 Col. Zona segura: recupera tudo |  |  |
| Ser tratado de status negativo | d20+Sabedoria (Nadia) | Veneno, paralisia ou confusão removidos sem gastar Cristal | Removido, mas leva a noite inteira | Precisa de material que ela não tem |
| Perguntar quem passou por aqui | d20+Sabedoria | Ela conta o que é público e nada além | Ela desconversa arrumando ervas | Silêncio absoluto — ela nunca fala de paciente |
| Deixar alguém aos cuidados dela | — | Sem teste, sem cobrança. Ela aceita. Sempre |  |  |

**Só o mestre:** Nadia é a mentora do Médico jogador e a única fonte que ensina
a tratar status sem Cristal. Ela precisa de material do Charco de Grenna — use
isso pra empurrar o grupo pra lá sem dar quest formal.

**Atalhos:** npc:nadia · regiao:charco_ras

---

### cidade_memorial · Memorial dos Caídos
> Uma parede de pedra clara, coberta de nomes gravados em linhas apertadas.
> Não é monumento: é lista, e ela cresce. Tem espaço em branco embaixo, muito
> espaço, e alguém está sempre parado ali lendo.

**O que é:** o registro de quem morreu de verdade. Ponto de acesso do
**Coveiro** e o vértice do triângulo Marco → Memorial → Cela Vazia.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Procurar um nome | d20+Inteligência | Acha, com data e quem registrou | Acha o nome, sem contexto | O nome está lá e você passa direto |
| Ler as datas em sequência | d20+Inteligência | Percebe que os quatro nomes do grupo do Marco foram registrados no mesmo dia | Percebe um agrupamento estranho | Só nomes |
| Registrar um nome novo | — | Sem teste. Irmão Anselm escreve — mas pede que **você** segure a mão dele ou escreva junto |  |  |
| Ficar em silêncio ali | d20+Sabedoria | Limpa qualquer condição emocional narrada | Alívio parcial | Você sai pior do que entrou |

**Só o mestre:** este é o ponto onde a campanha cobra. Toda morte de NPC
recorrente (Gilda, um recruta de Kaldrin, alguém do raid) deve aparecer aqui na
visita seguinte, sem aviso. Deixe o grupo descobrir lendo.

**Atalhos:** npc:zelador_do_memorial · npc:irmao_anselm · npc:marco · regiao:necropole

---

### cidade_igreja · Igreja e Abrigo da Capela
> Pedra clara, vitral simples, e um silêncio que não é religioso — é só
> silêncio, e é a única coisa da cidade que ninguém está cobrando. Irmão
> Anselm está num banco lateral, nunca no altar.

**O que é:** o lugar onde a Cidade do Início respira. Não tem missa e nunca
teve; as pessoas vêm pelo silêncio.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Sentar em silêncio | — | Sem teste. Uma cena inteira ali remove qualquer condição emocional narrada |  |  |
| Conversar com Anselm | d20+Sabedoria | Ele ouve, e devolve a pergunta certa | Ele ouve e não devolve nada | Ele te dá espaço, e isso dói mais |
| Perguntar quem tem vindo | d20+Sabedoria | Ele conta com discrição — e é um raio-X emocional do andar | Conta parte | "Não falo do que me falam" |
| Perguntar do sino | d20+Inteligência | Alguém conta os toques em voz alta desde o dia 3, e Anselm sabe quem | Ele confirma que alguém conta | Ele muda de assunto |

**Só o mestre:** Anselm não é padre e corrige quem o chama assim. Ele era
professor. Escreve os nomes no Memorial junto com o Zelador de Voss — os dois
se correspondem por bilhete, e esse detalhe liga a capital à Necrópole sem
quest formal.

**Atalhos:** npc:irmao_anselm · regiao:necropole

---

### cidade_quadro · Quadro de Rumores e Pedidos
> Um quadro de madeira de três metros coberto em camadas: papel oficial do
> sistema por baixo, papel escrito à mão por cima, e alguns pregados com
> faca. Alguém arrancou três pedidos hoje de manhã e não devolveu.

**O que é:** a fila de quests do andar. Pedido oficial paga melhor; pedido
manuscrito importa mais.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Ler o quadro | d20+Inteligência | Duas quests úteis **e** qual paga melhor | Uma quest, com o pedido incompleto | Só pedidos velhos já resolvidos |
| Procurar pedido manuscrito | d20+Sabedoria | Acha um pedido pessoal que ninguém quis pegar | Acha um, mas está rasgado no meio | Nada — alguém levou os bons |
| Pregar um pedido seu | d20+Inteligência | Alguém responde até a próxima sessão | Responde, mas cobra caro | Seu papel é coberto em uma hora |
| Descobrir quem arrancou os três | d20+Inteligência | Foi um clã, e você sabe qual | Foi alguém organizado | Ninguém viu |

**Só o mestre:** use o quadro como o seu painel de controle. Se o grupo estiver
sem rumo, um manuscrito novo aparece; se estiver sobrecarregado, os pedidos
somem porque outros grupos pegaram — o mundo continua sem eles.

**Atalhos:** regiao:cidade_inicio

---

### cidade_lago · Pequeno Lago Central
> Um lago de uns quarenta metros dentro da muralha, com um caminho de pedra
> em volta e um banco de madeira. Bren está sentado com uma panela em cima de
> um fogareiro improvisado, e o cheiro chega antes dele falar qualquer coisa.

**O que é:** o único lugar bonito da capital, e a cozinha informal de **Bren do
Lago** (`npcs/bren_do_lago.md`). Zona segura, sem comércio formal.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Comer o que Bren está fazendo | — | 15 Col ou uma conversa. Bônus de refeição na próxima expedição |  |  |
| Deixar Bren te ouvir | d20+Sabedoria | Ele deixa o silêncio durar até você dizer o que estava evitando — e isso limpa uma condição emocional | Você fala, e não resolve nada | Você enche o silêncio de piada e ele deixa |
| Pescar | d20+Destreza | 2 peixes pequenos e ninguém liga | 1 peixe | Um guarda avisa que não é pra pescar aqui |
| Cozinhar junto (Cozinheiro) | d20+Inteligência | Ele te ensina uma receita e passa a guardar ingrediente pra você | Prato sai bom | Vocês discutem sobre tempero, seriamente |

**Só o mestre:** Bren é a válvula emocional da capital. Ele não dá conselho —
ele espera. Use quando um personagem estiver carregando algo que o jogador
ainda não colocou em cena.

**Atalhos:** npc:bren_do_lago

---

### cidade_portao_oeste · Portão Oeste de Verrun
> O portão que dá pra Planície de Verrun, aberto, com dois batentes de pedra
> gastos na altura da mão — todo mundo encosta ali ao sair. Daren está de pé
> ao lado, lança apoiada, e ele conta quantos saem.

**O que é:** a saída "fácil" da cidade e o posto de **Daren Vigília**
(`npcs/daren_vigilia.md`). Ele não impede ninguém; ele pergunta.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Responder à pergunta de Daren | d20+Sabedoria | Ele aponta um perigo real da rota de hoje, de graça | Ele deixa passar sem dizer nada | Ele te olha por tempo demais e você sai desconfortável |
| Perguntar quem saiu hoje | d20+Inteligência | Números exatos, nomes de quem não voltou ontem | Só o número | "Muita gente" |
| Pedir escolta | d20+Sabedoria | Ele arruma alguém confiável | Arruma alguém disponível | Ninguém, e ele diz por quê |
| Sair sem plano de retirada | — | Sem teste. Ele deixa. E anota |  |  |

**Só o mestre:** a pergunta padrão dele é *"e se der errado, vocês voltam por
onde?"*. Se o grupo não tiver resposta, não impeça — mas cobre isso na
primeira complicação do dia.

**Atalhos:** npc:daren_vigilia · regiao:campos_oeste

---

### cidade_portao_leste · Portão Leste de Kaldan
> O portão leste é mais estreito e menos usado, com capim crescendo na
> junta das pedras. Maelis está sentada em cima do batente, com um caderno no
> colo, e não desce pra falar com ninguém.

**O que é:** a saída pras Estepes de Kaldan — rota mais dura — e o posto de
**Maelis da Estepe** (`npcs/maelis_da_estepe.md`), Cartógrafa.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Comprar informação de rota | d20+Inteligência | Rota exata, com o ponto onde o vento mascara som | Rota, sem o detalhe que importa | Ela cobra caro e entrega pouco |
| Admitir que está com medo | — | Sem teste. Ela respeita, desce do batente e ajuda de verdade |  |  |
| Vender bravata | d20+Sabedoria | Ela finge acreditar e você não ganha nada | Ela ri | Ela desmonta seu plano na frente do grupo, item por item |
| Trocar mapa por mapa | d20+Inteligência | Troca justa, e ela passa a te procurar | Troca desigual a seu favor hoje, contra você depois | Ela recusa: "seu desenho não vale tinta" |

**Só o mestre:** Maelis respeita **medo declarado** e despreza bravata. Isso é
uma alavanca de interpretação: o jogador que se expõe ganha mais que o que
posa. É um bom lugar pra oferecer **Impulso**.

**Atalhos:** npc:maelis_da_estepe · regiao:campos_leste

---

### cidade_guarita_norte · Guarita dos Cartógrafos
> Uma guarita de pedra na saída norte, tomada por papel: mapas pregados em
> três paredes, alguns em cima dos outros. Suri trabalha com três tintas
> diferentes e um sistema de cores que ela explica sem ninguém pedir.

**O que é:** o arquivo cartográfico do andar, tocado por **Suri Cartógrafa**
(`npcs/suri_cartografa.md`). É a saída para o Castelo de Ferro Negro e, mais
adiante, para o Labirinto.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Consultar o arquivo | d20+Inteligência | Ela separa o que ela **viu**, o que **ouviu** e o que **alguém jurou** — e as três coisas são úteis | Ela entrega tudo junto e você separa sozinho | Ela não empresta: "volta com algo pra trocar" |
| Vender uma região mapeada | — | 10 Col por ponto revelado (`docs/economia_profissoes.md`) |  |  |
| Pedir a rota até o Labirinto | d20+Inteligência | Rota completa até o Limiar, com onde acampar | Rota até Tolbana e "pergunta lá" | Ela desenha o caminho errado de propósito, pra te proteger |
| Copiar um mapa sem pedir | d20+Destreza | Ninguém vê | Ela vê e não diz nada — hoje | Ela vê, diz, e o arquivo fecha pra você |

**Só o mestre:** o sistema de cores da Suri é a melhor ferramenta de mestre da
capital: use as três categorias dela pra entregar informação sobre o mistério
do andar 2 **já classificada por confiabilidade**, sem precisar avisar o que é
verdade.

**Atalhos:** npc:suri_cartografa · regiao:castelo_ferro_negro · regiao:labirinto_entrada
