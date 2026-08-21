---
titulo: Dungeons do Andar 1 — guia sala a sala
andar: 1
dungeons: 4
salas: 27
---

# Dungeons do Andar 1

Layout interno completo das quatro dungeons, sala a sala: o que o mestre lê em
voz alta, o que dá pra fazer com teste, o que mora ali, o que tem de tesouro
com nome e o que está escondido.

O mesmo conteúdo alimenta a aba **Dungeons** do Compêndio
(`scripts/web/compendio_andar1.html`) via `scripts/gerar_dados_web.py`. As
coordenadas do desenho ficam em `scripts/web/dados_dungeons.js`; o texto vem
daqui. Editou aqui, roda o gerador.

## Tipos de sala

| Tipo | Significado |
|---|---|
| `entrada` | Ponto de acesso, sempre seguro |
| `corredor` | Passagem; encontro só se o grupo demorar |
| `patrulha` | Encontro garantido, respawna |
| `armadilha` | Perigo sem monstro |
| `tesouro` | Baú ou recurso, com item nomeado |
| `descanso` | Ponto seguro; recupera |
| `puzzle` | Não se resolve com arma |
| `miniboss` | Encontro forte/elite, único |
| `chefe` | Chefe de andar |
| `segredo` | Só aparece pra quem procura |

## Três regras de dungeon

**1. Corredor estreito muda a arma.** Em qualquer sala descrita como estreita,
armas de haste longa e duas mãos (Espada Longa, Lança, Foice, Martelo)
não dão bônus e podem custar complicação. Adagas, Rapieira e Manopla
brilham. Diga isso na primeira vez.

**2. Barulho tem preço.** Toda dungeon do andar tem uma mecânica de atenção:
o Labirinto tem patrulhas que respawnam, Mournhall tem eco que derruba pedra,
Lumis tem o Contador de Vibração, a Dungeon Oculta tem o que ninguém quer
acordar. Combate limpo é sempre melhor que combate rápido.

**3. Tesouro tem nome.** Nenhuma sala deste documento dá "um item aleatório".
Se está escrito, é aquilo.

**4. Toda dungeon lembra de gente.** Se a sala estiver funcional demais,
adicione um vestígio humano: giz, bilhete, barraca desmontada, item largado,
marca de faca, corda cortada, nome rabiscado, comida esquecida. Labirinto bom
não é só arquitetura; é rastro de tentativa.

## Como deixar cada trecho A+

Use esta ordem de prioridade:

1. **Pressão espacial** — eco, altura, água, largura, luz.
2. **Pressão humana** — quem passou aqui antes e em que estado.
3. **Escolha ruim vs. pior** — seguir, recuar, gastar recurso, fazer barulho.
4. **Ponto de corte** — toda incursão boa termina uma vez antes do seguro.

## Pontos de transmissão

As dungeons rendem melhor em stream quando cada trecho entrega:
- uma imagem de abertura muito clara,
- um som que a mesa passe a temer,
- um objeto concreto que prove passagem humana,
- e um final de bloco que faça parecer errado continuar sem descanso.

---

# 1. Labirinto do Andar 1

**Região:** Limiar do Labirinto → Covil de Illfang · **Nível:** 7 – 10
**Estrutura:** 20 sub-níveis canônicos agrupados em **5 trechos** de 4. Cada
trecho é uma sessão razoável.
**Regra de fôlego:** no máximo **dois trechos** por incursão antes de sair ou
usar um `descanso`. É isso que transforma o Labirinto em campanha.

## Trecho I — Sub-níveis 1-4 · "As Galerias Abertas"

A parte que todo mundo já mapeou. Existem esboços à venda em Tolbana por 50
Col, e eles são honestos.

### I-1 · Portal de Entrada — `entrada`
> O arco tem trinta metros de vão e nenhuma porta. A pedra em volta é lisa de
> um jeito que pedra velha não é. Cinquenta metros atrás de vocês tem um
> acampamento inteiro de gente que não entra; um metro à frente, o chão muda
> de cor e o som muda de textura. Não tem aviso. Não tem guarda. Só tem o
> lado de dentro.

**O que dá pra fazer:** examinar o arco (d20+Inteligência — sucesso total: a pedra é da
mesma família da Torre de Aldric e do Castelo de Ferro Negro); falar com o
Marco (`npcs/marco.md`); recuar sem vergonha nenhuma.
**Quem está aqui:** ninguém. É o único ponto do Labirinto que nunca tem nada.

### I-2 · Galeria Longa — `corredor`
> Duzentos metros retos, teto a quinze de altura, e cristais azuis embutidos na
> parede a cada dez passos. Cada passo volta como eco três vezes. Falar em voz
> normal aqui é a mesma coisa que gritar.

**O que dá pra fazer:** atravessar em silêncio (**impossível** — diga isso;
a galeria não permite furtividade, e é a primeira lição do Labirinto);
arrancar um cristal da parede (d20+Destreza — sucesso total: um Cristal de Luz de
verdade, sucesso parcial: ele apaga ao sair, falha: racha e o barulho puxa I-4).
**Detalhe:** as marcas de giz no chão começam aqui. Metade é de gente honesta.

### I-3 · Posto Avançado — `descanso`
> Umas seis barracas encostadas na parede esquerda, um fogo pequeno, e quatro
> pessoas que olham pra vocês com o alívio de quem checa se são humanos.
> Alguém está vendendo bandagem por um preço criminoso. Um cara dorme sentado
> com a mão na espada.

**O que dá pra fazer:** descansar (recupera, e não respawna nada); comprar
(tudo 40% acima da tabela — é preço de dentro de dungeon); ouvir boato
(d20+Sabedoria — sucesso total: alguém conta da Trifurcação do Trecho II e que dois
corredores são becos).
**Quem está aqui:** batedores de guilda. **Vess** (`npcs/vess.md`) passa por
aqui todo entardecer.
**Vestígio humano:** uma panela ainda morna e uma faixa de pano com sangue já
seco. Gente descansa aqui, mas nunca relaxa de verdade.

### I-4 · Ronda Baixa — `patrulha`
> Dois vultos baixos e curvados atravessam o corredor à frente, sem pressa,
> com lança curta e escudo de couro. Eles não viram vocês ainda. O da direita
> está mancando.

**Quem está aqui:** **Ruin Kobold Trooper x2** (comum, 26 PV cada).
Respawn 3h.
**O que dá pra fazer:** emboscar (d20+Destreza — sucesso total: o primeiro cai antes de
reagir); passar sem lutar (d20+Destreza — só possível se apagarem a luz);
lutar de frente (justo, e a lição é que kobold luta em par de propósito).
**Material:** Fragmento de Armadura Kobold (só o Caçador extrai, d20+Destreza).

### I-5 · Nicho Rachado — `tesouro`
> Uma rachadura na parede larga o suficiente pra passar de lado. Lá dentro,
> um espaço do tamanho de um armário, e no chão um baú de madeira com ferragem
> — fechado, não trancado, e sem uma única marca de tentativa de arrombamento.

**Tesouro (nomeado):** 120 Col, **um Cristal de Luz** e **um Cristal de
Antídoto**. Os dois cristais que o puzzle do mural precisa e que o grupo não
tem dinheiro pra comprar — é aqui que o Labirinto paga o Castelo.
**O que dá pra fazer:** verificar armadilha (d20+Destreza — não tem, e isso é
informação: alguém deixou o baú aí de propósito e fechado).

### I-6 · Escada Descendente — `corredor`
> A escada desce quarenta degraus e o ar muda de temperatura no décimo quinto.
> Não fica mais frio. Fica mais parado.

**O que dá pra fazer:** marcar o caminho (recomendado, e o Trecho II vai
mostrar por quê).

---

## Trecho II — Sub-níveis 5-8 · "Os Corredores Falsos"

Aqui o Labirinto começa a mentir. É onde o **Cartógrafo** justifica existir.

### II-1 · Trifurcação — `puzzle`
> Três corredores idênticos. Mesma largura, mesma altura, mesmo espaçamento
> de cristal na parede, mesma marca de giz no chão — a mesma marca, nos três.
> Quem desenhou isso desenhou pra confundir, e conseguiu.

**O teste:** d20+Inteligência. **sucesso total:** acha o corredor certo (o do meio, e o
detalhe que entrega é que só nele o pó do chão está pisado nos dois sentidos —
gente foi e voltou). **sucesso parcial:** acha o certo, mas encosta na parede errada e
dispara um alarme: a patrulha de II-6 vem até vocês. **falha:** beco.
**Atalho:** **Vess** vende essa informação por 80 Col em Tolbana, e é o melhor
dinheiro que o grupo vai gastar.

### II-2 · Beco da Lâmina — `armadilha`
> Corredor curto que termina em parede lisa. No chão, a três metros do fim,
> uma placa de pedra levemente mais clara que as outras.

**Armadilha:** placa de pressão → lâmina lateral saindo da parede na altura
da coxa. d20+Destreza pra desarmar (sucesso total: trava o mecanismo pra sempre; sucesso parcial:
trava e a lâmina volta em uma hora; falha: dispara).
**As `Grevas de Verme-Cristal` ignoram a placa completamente.**
**Recompensa por desarmar:** a lâmina destravada é aço bom — vale um
**Fragmento de Armadura Kobold** de material pra quem souber retirar.

### II-3 · Beco do Teto Baixo — `armadilha`
> O corredor afunila e o teto começa a descer. Não rápido. Devagar o
> suficiente pra dar tempo de pensar, e é isso que faz ser cruel.

**Armadilha:** teto descendente. Duas saídas: **Corpo** pra escorar (sucesso total:
escora e o grupo passa; sucesso parcial: escora, mas alguém fica pra trás; falha: precisa
recuar e o beco fecha por uma hora) ou **Técnica** pra travar o mecanismo
(mesmo perfil, e trava permanente no 10+).
**Detalhe:** encaixado entre o teto e a parede, esmagado, tem um escudo de
madeira antigo. Não é do grupo do Marco. É de alguém que ninguém procura.

### II-4 · Corredor Verdadeiro — `corredor`
> O corredor certo. Dá pra ter certeza porque o pó está pisado nos dois
> sentidos, e porque as marcas de giz aqui têm três estilos de letra
> diferentes — três grupos passaram, em momentos diferentes, e concordaram.

**O que dá pra fazer:** ler as marcas de giz (d20+Inteligência — sucesso total: uma das
letras é do grupo do Marco, e diz "voltamos por aqui" com a data do dia 6).

### II-5 · Depósito Esquecido — `tesouro`
> Uma sala lateral com prateleiras de pedra escavadas na parede. Em cima delas,
> material empilhado com cuidado: placas de armadura kobold separadas por
> tamanho, e três barras de metal que não são de kobold nenhum.

**Tesouro (nomeado):** **Fragmento de Armadura Kobold x3** e **Placas de
Metal Refinado x1**. As Placas são o achado real — é material processado, e
não existe forja no Labirinto. Alguém trouxe de fora e deixou.
**O que dá pra fazer:** perguntar quem organizou isso (d20+Inteligência — sucesso total:
foi organizado por mãos humanas, recentemente, e por alguém metódico).

### II-6 · Sala do Sino — `patrulha`
> Sala grande com um nicho elevado na parede do fundo, uns quatro metros
> acima do chão. No nicho, dois kobolds com arco curto. Entre eles, pendurado
> numa viga, um sino de bronze do tamanho de um capacete.

**Quem está aqui:** **Ruin Kobold Arqueiro x2** (comum, 26 PV cada).
**A mecânica:** se o sino tocar, chegam **mais dois Troopers** em duas
rodadas. Um dos arqueiros vai tentar tocá-lo na primeira rodada.
**O que dá pra fazer:** derrubar o sino primeiro (d20+Destreza com arma de
alcance — sucesso total: o sino cai e não toca nunca mais); tomar o nicho (d20+Força
pra escalar); recuar e fechar o corredor.
**Tesouro:** o sino, se recuperado inteiro, vale **200 Col** com Tor em
Tolbana — e ele paga com prazer porque é bronze fundido de verdade, coisa que
o andar não produz.

---

## Trecho III — Sub-níveis 9-12 · "A Descida Molhada"

Água infiltrando, piso liso, gotejamento constante que mascara passos — de
todo mundo, inclusive dos kobolds.

### III-1 · Escadaria Escorregadia — `armadilha`
> Sessenta degraus descendo, com um filete de água correndo no meio de cada um
> e limo verde nas bordas. O som da água bate na parede e volta multiplicado.

**Teste:** d20+Destreza pra descer (sucesso total: desce e ajuda o próximo; sucesso parcial: desce,
mas larga algo não equipado; falha: cai o lance inteiro — complicação séria e
barulho).
**As `Botas Cravejadas de Montanha` dispensam o teste. As `Botas de Sola
Macia` pioram: role com complicação.**

### III-2 · Cisterna — `patrulha`
> Uma sala redonda com trinta centímetros de água parada cobrindo o chão
> inteiro. A superfície está imóvel. Em três pontos diferentes, ela não está.

**Quem está aqui:** **Sanguessuga Gigante x3** (comum, 26 PV cada).
**Mecânica:** elas grudam. Quem estiver com `Calça Encerada de Pescador` ou
`Casaco Encerado do Pântano` **não pode ser grudado** e ganha uma rodada de
vantagem pro grupo inteiro.
**Material:** material de Sanguessuga (Médico, Alquimista).
**O que dá pra fazer:** atravessar por cima (d20+Destreza, pulando de saliência
em saliência — sucesso total: passa sem tocar a água); drenar (não dá — e descobrir que
não dá custa uma ação).

### III-3 · Passarela Estreita — `corredor`
> Uma passarela de pedra de sessenta centímetros de largura atravessando um
> vão que a luz não alcança. Sem corrimão. Sem fundo visível. Fila indiana,
> e a fila decide quem morre primeiro se algo vier.

**Regra:** fila indiana obrigatória. **Espada Longa e Lança não
funcionam aqui.** Quem estiver na frente enfrenta sozinho.
**O que dá pra fazer:** amarrar corda entre todos (d20+Destreza — sucesso total: uma
queda não é fatal pra ninguém; falha: a corda vira o problema).
**Detalhe:** jogue uma pedra no vão e conte. Não tem som de fundo.

### III-4 · Alcova Seca — `descanso`
> Um vão seco atrás de uma coluna, do tamanho de dois cavalos. Não pinga água
> aqui, e ninguém sabe explicar por quê, porque pinga em todo o resto.
> Alguém empilhou pedra na entrada pra formar um parapeito baixo.

**Um dos dois únicos pontos seguros do Labirinto inteiro.** Descanso completo.
**O que dá pra fazer:** procurar (d20+Inteligência — sucesso total: acha um bilhete
dobrado sob uma pedra: *"se você tá lendo isso, a gente conseguiu voltar até
aqui"*, quatro assinaturas, dia 6).
**Momento bom de mesa:** se o grupo parar aqui depois de apanhar, deixe o
silêncio trabalhar. Esta é uma sala para conversa curta, medo honesto e plano
ruim virando plano possível.

### III-5 · Câmara do Ralo — `segredo`
> No canto da alcova, sob duas pedras empilhadas, uma grade de ferro do
> tamanho de uma tampa de poço. Ela está solta. Embaixo, uma escada de ferro
> descendo no escuro.

**Como achar:** d20+Inteligência em III-4, ou d20+Destreza se alguém
especificamente procurar o chão.
**Recompensa:** **atalho direto pro Trecho V.** Pula os Trechos III-6 e IV
inteiros. É o maior atalho do andar e ninguém sabe que existe — **nem a Vess**,
que passou quatro dias travada a dez metros dele.
**Custo:** a escada é longa e escura, e no meio dela dá pra ouvir o Trecho IV
acontecendo do outro lado da parede. Vozes de kobold. Muitas.

### III-6 · Guarita Inundada — `miniboss`
> Um posto de guarda com água pela canela, e no meio dele um kobold que é
> claramente diferente dos outros: mais alto, com placas de metal de verdade
> cobrindo o tronco e a garganta protegida por um colar de couro grosso. Ele
> está de pé, imóvel, virado pra porta. Ele está esperando faz tempo.

**Quem está aqui:** **Ruin Kobold Sentinel** (forte, 48 PV). Resiste a
golpes no corpo. **Fraqueza: a garganta** — o único ponto sem armadura, e o
colar de couro precisa ser cortado ou removido antes.
**O que dá pra fazer:** cortar o colar (d20+Destreza com arma leve — sucesso total: colar
cai e a garganta abre, próximos golpes contam dobrado); usar a água (d20+Inteligência — sucesso total: derrubá-lo na água anula a vantagem da armadura pesada
por uma rodada).
**Tesouro:** as **braçadeiras dele** — leve a Mestre Bram e viram
`Braçadeiras do Mercenário`.

---

## Trecho IV — Sub-níveis 13-16 · "O Ninho"

Território kobold de verdade: fogueira, osso, tapume improvisado. Eles moram
aqui, e isso muda o tom. Não é dungeon abandonada. É casa de alguém.

### IV-1 · Barricada — `patrulha`
> O corredor foi fechado por tapumes de madeira e escudo amarrado, com duas
> frestas na altura do peito. Atrás deles, movimento. Isso não é instinto
> animal: isso é engenharia de quem já foi atacado antes e aprendeu.

**Quem está aqui:** **Ruin Kobold Trooper x3** atrás de cobertura.
**Mecânica:** cobertura anula bônus de arma à distância. `Pavês de Portão` e
`Lança de Parede de Escudos` brilham — é exatamente a luta pra qual foram
feitos.
**O que dá pra fazer:** derrubar o tapume (d20+Força, Machado ou Marreta dá
vantagem); passar por cima (d20+Destreza); negociar (**sim, dá** — d20+Sabedoria
com sucesso total faz eles recuarem sem lutar, e essa possibilidade deve estar visível).

### IV-2 · Fogueira Central — `patrulha`
> Uma sala ampla com uma fogueira de verdade no meio, ossos limpos empilhados
> num canto com organização, e peles estendidas pra secar. Três kobolds em
> volta do fogo. Um deles está costurando alguma coisa.

**Quem está aqui:** **Trooper x2 + Arqueiro x1**.
**O que dá pra fazer:** atravessar sem lutar (d20+Destreza sucesso total — é possível e
o grupo deve saber disso); atacar de surpresa; **observar por uma rodada
antes** (d20+Sabedoria — sucesso total: o grupo vê que estão costurando, comendo e
conversando, e a mesa inteira fica desconfortável, que é o objetivo).
**Nota de mestre:** esta sala existe pra tornar o Labirinto moralmente
esquisito. Não sublinhe. Só descreva o que está acontecendo e deixe.
**Vestígio humano:** há uma colher de metal humano torta perto da fogueira.
Ninguém do grupo precisa comentar; basta estar ali.

### IV-3 · Depósito de Espólio — `tesouro`
> Uma câmara lateral cheia de coisa tomada de gente: mochilas, armas, um
> alaúde quebrado, três capas dobradas. Está tudo separado por tipo. Alguém
> catalogou o que roubou.

**Tesouro (nomeado):** **340 Col**, **um Cristal de Cura**, e uma **arma
Incomum aleatória entre as do catálogo** (role ou escolha — mas ela tem dono
anterior e o nome dele está no cabo).
**O que dá pra fazer:** procurar algo específico (d20+Inteligência — sucesso total: acha
o que estiver procurando, se for razoável); levar tudo (não cabe — o grupo tem
que escolher, e escolher é a cena).

### IV-4 · Cela Vazia — `segredo`
> Uma cela de pedra com grade de ferro, aberta. Dentro, não tem ninguém. Tem
> quatro conjuntos de equipamento, empilhados com cuidado contra a parede do
> fundo. Um deles tem um escudo retangular com o nome riscado no verso.

**Como achar:** só entra quem procurar sala lateral em IV-2 (d20+Inteligência).
**O que tem:** o equipamento completo do grupo do Marco — quatro conjuntos,
incluindo o **`Escudo e Espada do Primeiro Muro`** (Raro).
**A informação:** não há corpo, porque corpo vira luz. Não há sinal de luta
nesta sala. O equipamento foi **empilhado**, com cuidado, por alguém.
**O que dá pra fazer:** identificar os donos (d20+Inteligência — sucesso total: os
quatro nomes que o Marco repete); descobrir quem empilhou (não dá — e essa
ausência é o ponto).
**Isto fecha o triângulo:** Marco (Limiar) + Memorial dos Caídos (capital) +
esta cela. Ver `npcs/marco.md`.
**Ponto de corte ideal:** terminar sessão aqui é crueldade boa. A mesa fica
com prova física, pergunta aberta e medo novo ao mesmo tempo.

### IV-5 · Passagem Guardada — `miniboss`
> Duas figuras altas de placas nos dois lados de uma porta larga. Elas não se
> mexem quando vocês entram. Se mexem quando vocês dão o segundo passo.

**Quem está aqui:** **Ruin Kobold Sentinel x2** (forte, 48 PV cada).
**Este é o encontro que decide se o grupo está pronto pro chefe.** Dois
Sentinels ao mesmo tempo exigem foco alvo a alvo, uso de terreno e alguém
segurando linha. Se o grupo apanhar feio aqui, eles **não** estão prontos, e o
mestre deve dizer isso com o combate, não com palavras.
**O que dá pra fazer:** puxar um de cada vez (d20+Destreza — sucesso total: consegue e a
luta fica justa); fechar a porta atrás (d20+Força).

---

## Trecho V — Sub-níveis 17-20 · "A Antessala"

Silêncio. Nenhum kobold comum passa daqui — eles evitam.

### V-1 · Salão dos Estandartes — `corredor`
> Um salão alto com estandartes pendurados dos dois lados, do teto ao chão.
> Estão rasgados, queimados nas pontas, e são muitos — trinta, quarenta. Todos
> com o mesmo símbolo, em cores diferentes. Não é decoração de monstro. É
> registro.

**O que dá pra fazer:** ler a heráldica (d20+Inteligência — **sucesso total:** os
estandartes contam uma sucessão: quarenta gerações de alguma coisa, e o
símbolo do último é o mesmo que está gravado no corredor da sala do chefe.
**Os kobolds não são nativos deste andar. Eles chegaram aqui.** sucesso parcial: entende
que é sucessão, não guerra. falha: "pano velho").
**Recompensa:** essa informação, levada ao **Estudioso Obcecado**, rende a
tese completa dele por escrito e destrava pesquisa de Bibliotecário fora da
Torre.

### V-2 · Última Alcova — `descanso`
> Um recuo na parede com espaço pra vinte pessoas. O chão está limpo. Alguém
> varreu. Há marcas de fogueira antiga em três pontos diferentes, de
> tamanhos diferentes — três grupos, em três momentos, pararam exatamente aqui
> antes de continuar.

**O segundo e último ponto seguro.** É aqui que o raid se organiza.
**O que dá pra fazer:** a cena de véspera. Sem rolagem. Deixe cada jogador
falar. Vale mais que qualquer teste do andar.
**Momento bom de mesa:** peça o último gesto de preparo de cada personagem.
Afia? Reza? Cala? Escreve? Dorme? Finge que não está com medo? Isso vale ouro.

### V-3 · Porta do Chefe — `puzzle`
> Uma porta de seis metros de altura, de pedra, sem maçaneta, sem fechadura,
> sem mecanismo. Ela abre empurrando. É pesada demais pra uma pessoa. É
> pesada demais pra três.

**A mecânica é social, não teste:** precisa de **quatro pessoas empurrando ao
mesmo tempo**. Se o grupo veio com menos de quatro, eles não abrem — e a
solução é sair, voltar a Tolbana e convencer gente a vir.
**Isto não é bloqueio arbitrário.** É a tese do andar inteiro dita em pedra:
ninguém sobe sozinho. Diga isso com a porta, nunca com a boca.

### V-4 · Sala de Illfang — `chefe`
> A sala é redonda e enorme, com o teto perdido no escuro. No fundo, num
> trono baixo de pedra, um kobold de dois metros e meio com pelo escuro,
> talwar numa mão e broquel na outra. Atrás dele, encostado no trono, algo
> comprido enrolado em pano. Ele levanta devagar. Ele não tem pressa nenhuma.

**Quem está aqui:** **Illfang the Kobold Lord** (chefe — 4 barras x 6-8
PV, chefe com fases — Seção 79) + **Ruin Kobold Sentinel x2** de apoio.

**Fase 1 (barras 1-3):** talwar e broquel. **Golpes frontais são bloqueados.**
Quem atacar de frente sem abrir a guarda perde a ação. Recompense flanco,
distração e coordenação.

**Fase 2 (barra 4):** ele larga os dois e desembrulha o **nodachi**. Muda todo
o padrão e **perde o bônus de defesa do escudo** — fica mais mortal e mais
vulnerável ao mesmo tempo. É canonicamente aqui que o raid perde gente,
porque a informação que compraram estava incompleta (ver `npcs/vell.md`,
`npcs/nissa.md`, `npcs/diavel.md`).

**Recompensa:** ~2000 Col dividido, XP alto dividido, e **uma unidade** do
`Nodachi de Illfang` pro raid vencedor. Quem fica com ela é discussão de mesa,
de propósito.

**Depois:** o andar 2 **não abre**. Ninguém entende por quê. Ver
`docs/misterio_andar2.md` — é aqui que a campanha começa de verdade.

---

# 2. Caverna de Mournhall

**Região:** noroeste, atrás do Bosque de Ashwen · **Nível:** 7 – 9
**Perfil:** dungeon menor opcional, 8 salas, uma incursão.
**Mecânica central — escuridão total:** sem fonte de luz, todo teste ganha
complicação e a Sombra de Mournhall ataca com vantagem. Uma **Fada da Poeira
domada** resolve isso sem gastar Cristal de Luz, e é por isso que o Domador
vira indispensável aqui.
**Sem ligação com o mistério do andar 2.** É recompensa de exploração pura.

### M-1 · Boca da Caverna — `entrada`
> A boca tem seis metros de altura e a luz do dia entra exatamente dez passos.
> No décimo primeiro é preto — não escuro, preto, sem gradiente. O ar que sai
> é mais frio que o de fora e cheira a pedra molhada.

**O que dá pra fazer:** acender e organizar antes de entrar (dê essa chance
explicitamente); estimar profundidade pelo eco (d20+Sabedoria).

### M-2 · Galeria de Estalactites — `patrulha`
> Estalactites do teto ao chão em fileiras irregulares, algumas grossas como
> tronco. Passando a luz por elas, o teto inteiro se move.

**Quem está aqui:** **Morcego Ecoante** em bando (fraco, 14 PV cada — trate
o bando como um obstáculo, não como oito fichas).
**Mecânica:** barulho alto os solta do teto de uma vez. Silêncio os mantém
dormindo, e o grupo passa sem rolar nada.
**Doma:** Morcego Ecoante é domável (2 sucessos, só silêncio na aproximação) e
vira batedor de caverna — o melhor aliado possível pro resto de Mournhall.

### M-3 · Fenda Estreita — `armadilha`
> A galeria termina numa fenda de trinta centímetros de largura. Dá pra passar
> de lado, esvaziando o peito. Dá pra passar com mochila? Não.

**Regra:** quem usar **Armadura pesada, Pavês de Portão ou Peitoral de
Pedra-Viva** precisa tirar e empurrar na frente. d20+Destreza (sucesso total: passa com
tudo; sucesso parcial: passa, deixa a peça pesada pro outro lado; falha: entala, gasta uma
hora e faz barulho, o que acorda M-2).

### M-4 · Poço de Ecos — `puzzle`
> Uma câmara redonda de vinte metros com um poço no centro e o teto coberto de
> lascas de pedra soltas, penduradas, que dá pra ver tremendo. O menor som
> aqui derruba uma. Uma derruba dez.

**A mecânica não tem rolagem:** é **acordo de mesa**. Anuncie que qualquer
jogador que falar em voz alta durante a travessia derruba pedra — e então
conduza a cena inteira em voz baixa, de verdade, na sua mesa. Funciona.
**O que dá pra fazer:** comunicar por gesto; amarrar o equipamento pra não
tilintar (d20+Destreza); jogar uma pedra no poço de propósito (não tem fundo,
e agora o teto está caindo).

### M-5 · Veio de Musgo Luminoso — `tesouro`
> Uma parede inteira coberta de musgo que acende — verde-pálido, fraco,
> constante. Não é reflexo. Está vivo e está brilhando.

**Tesouro (nomeado):** **Musgo Luminoso x3** (Alquimista). É a isca de doma da
Sombra de Mournhall e a única fonte do andar.
**Teste:** d20+Inteligência pra colher sem matar (sucesso total: 3 unidades e o veio
continua; sucesso parcial: 1 unidade; falha: o musgo apaga e não volta).

### M-6 · Câmara Cega — `patrulha`
> A sala mais escura da caverna. A luz de vocês alcança dois metros e para,
> como se batesse em alguma coisa. Alguma coisa se move nesse limite. Ela
> não entra na luz.

**Quem está aqui:** **Sombra de Mournhall** (forte, 48 PV). Resiste a
escuridão. **Vulnerável a luz intensa.**
**Mecânica:** um **Cristal de Luz** usado aqui vira arma — o primeiro golpe
depois dele é sucesso automático. A Fada da Poeira domada não é forte o
bastante pra isso (é luz fraca), o que faz da escolha entre gastar o Cristal
agora ou guardar uma decisão de verdade.
**Doma:** ela é domável (5 sucessos, isca de Musgo Luminoso) e vira um aliado
que enxerga no escuro.

### M-7 · Nicho Seco — `descanso` / `segredo`
> Atrás de uma coluna grossa, um espaço que a luz não alcançava. Seco, do
> tamanho de uma cama, com uma marca de fogueira antiga.

**Como achar:** d20+Inteligência em M-6, ou simplesmente contornar a coluna.
**O que tem:** descanso seguro **e** uma mochila abandonada com **Ração x2**,
**uma Tocha** e um **mapa parcial da caverna** desenhado à mão que erra o
caminho pra M-8 de propósito. Quem desenhou não queria que ninguém achasse o
Guardião.

### M-8 · Sala do Guardião — `miniboss`
> A caverna se abre numa câmara alta, e no centro dela tem um monte de pelo
> grisalho do tamanho de uma carroça, respirando. Devagar. Ele ergue a cabeça
> antes de vocês darem o próximo passo, e depois ergue o resto.

**Quem está aqui:** **Guardião de Mournhall** (elite, **80 PV**).
Resiste a escuridão e impacto. **Fraqueza: o ventre exposto quando se ergue.**
**Mecânica:** ele se ergue nas patas traseiras a cada duas rodadas. Nessa
janela, um golpe no ventre conta **dobrado**. Quem esperar essa janela vence;
quem bater sem parar perde.
**Aviso ao mestre:** dê três sinais antes (pegada no barro de M-5, pelo
grisalho preso na fenda de M-3, e o silêncio dos morcegos perto de M-7). Um
grupo de nível 8 sem preparo perde gente aqui.
**Tesouro (nomeado):** **Pelagem Grisalha** (100%) e **Presa do Guardião**
(40%). A Pelagem vira a **`Cota do Guardião`** com Kazuo Tanaka **e** Mestra
Sorrel — a única receita do andar que exige dois ofícios. A Presa vira o
**`Machado de Osso de Guardião`**.

---

# 3. Gruta de Lumis

**Região:** leste, base das Colinas de Braxhold · **Nível:** 6 – 8
**Perfil:** dungeon de **coleta**, 7 salas. Dá pra sair rico sem lutar
nenhuma vez — se souberem parar na hora.

**Mecânica central — Contador de Vibração:** +1 por extração, +1 por combate,
+1 por queda ou barulho alto. Ao chegar em **3**, um Verme de Cristal emerge.
Zera quando o verme cai ou o grupo sai.
**Deixe o contador visível na mesa** — três moedas, um dado. Isso vale mais
que qualquer descrição.

### L-1 · Entrada Iluminada — `entrada`
> A fenda na rocha é alta e estreita, e ela brilha. Azul fraco, constante,
> vindo de dentro. Quando o primeiro de vocês passa, os cristais das paredes
> logo à frente acendem — e os de trás apagam. Eles estão acompanhando.

**Zona segura.** Nada spawna aqui.
**O que dá pra fazer:** testar a reação dos cristais (d20+Inteligência — sucesso total:
eles respondem a **movimento**, não a presença; ficar parado apaga tudo).

### L-2 · Corredor Azul — `corredor`
> O chão está coberto de lascas de cristal do tamanho de unhas. Cada passo
> estala. Não dá pra não estalar.

**Mecânica:** correr aqui custa **+1 de vibração**. Andar devagar não custa
nada, mas custa tempo — e tempo é a outra moeda desta dungeon.

### L-3 · Veio Menor — `tesouro`
> Uma parede lateral com um veio exposto de cristal bruto, do tamanho de uma
> porta. Dá pra ver pelo menos duas peças boas daqui.

**Tesouro (nomeado):** **Cristal Bruto x2**. Cada extração custa **+1 de
vibração**.
**Teste:** d20+Destreza (sucesso total: 2 unidades e o veio continua; sucesso parcial: 1 unidade;
falha: racha o veio, +2 de vibração e o veio fecha).

### L-4 · Câmara dos Reflexos — `puzzle`
> Uma sala onde as paredes são cristal polido. Vocês estão em toda parte, em
> todas as direções, repetidos. As quatro saídas são idênticas. Duas delas são
> reflexo.

**Teste:** d20+Inteligência (sucesso total: identifica as duas saídas reais e qual é a
certa — a que **não** devolve o brilho da lanterna; sucesso parcial: identifica as reais,
não qual é a certa; falha: o grupo anda em círculo por uma hora **e não percebe**
— narre a mesma sala de novo, com as mesmas palavras, e deixe eles notarem).
**Atalho:** cobrir uma parede com um pano quebra o efeito inteiro. Qualquer
jogador que pensar nisso resolve sem rolar, e deve ser recompensado por isso.

### L-5 · Veio Maior — `tesouro`
> A câmara inteira é veio. Cristal saindo do chão, da parede e do teto, e no
> meio de tudo, encaixado na rocha como se tivesse crescido ali, um cristal
> diferente: liso, facetado, com luz própria e cor.

**Tesouro (nomeado):** **Cristal Bruto x4** (+1 de vibração cada) e **um
Cristal de Barreira** de sistema, encaixado no centro. O de Barreira é o mais
escasso do andar (estoque 1/semana no Comerciante) e é o quinto cristal do
puzzle do mural.
**Custo:** arrancar o Cristal de Barreira custa **+2 de vibração** de uma vez.
Se o contador estava em 1, o Verme aparece no mesmo instante.

### L-6 · Galeria do Verme — `patrulha`
> Um túnel largo e liso demais pra ser natural — a rocha foi polida pela
> passagem de alguma coisa grande, muitas vezes. Nas paredes, sulcos paralelos
> à altura do peito.

**Quem está aqui:** **Verme de Cristal** (comum, 26 PV). Resiste a cristal
e impacto. **Caça por vibração, não por visão** — ficar imóvel é literalmente
invisibilidade.
**O que dá pra fazer:** ficar parado (d20+Sabedoria pra segurar o nervo — sucesso total:
ele passa a dois metros e vai embora); atacar a cabeça mole (d20+Força — sucesso total:
2 golpes); provocar de propósito (é a única forma de garantir a carapaça).
**Tesouro (nomeado):** **carapaça de Verme de Cristal x2 segmentos** →
**`Grevas de Verme-Cristal`** (Raro) com Mestre Bram, **se** o grupo tiver as
`Luvas de Malha Fina`; sem elas, a carapaça racha na montagem. Também vira
`Manoplas de Casco de Verme` e `Escudo de Casco de Verme`.

### L-7 · Fenda Fria — `segredo`
> No fundo da galeria, uma fenda de dois dedos de largura na rocha. Sai ar
> gelado dela. Constante. Numa caverna que devia estar mais quente que lá fora,
> num andar de clima temperado, saindo de um lugar fechado.

**Como achar:** d20+Inteligência em L-6, ou seguir o frio.
**O que dá pra fazer:** medir a temperatura (é mais frio que qualquer lugar do
andar); enfiar uma tocha (a chama é **puxada pra dentro**); alargar a fenda
(não dá — o cristal em volta é duro demais, e três sessões tentando não mudam
isso).
**Recompensa:** nenhuma. É gancho em aberto, e é seu. Ver a nota de mestre no
guia de região (`guias/03_leste_e_aguas.md`).

---

# 4. Dungeon Oculta sob o Castelo de Ferro Negro

**Região:** Castelo de Ferro Negro · **Nível:** MUITO acima do andar 1
**Perfil:** 5 salas conhecidas. **O mestre não deve deixar o grupo passar da
terceira.**
**Função narrativa:** estabelecer que existe algo maior. Não recompensar.

### D-1 · Escada Atrás da Coluna — `entrada`
> Atrás da terceira coluna do pátio, onde ninguém olha porque não há motivo
> pra olhar, o chão tem um degrau. Depois outro. É uma escada, e ela está
> maldisfarçada de um jeito quase desleixado — como se quem escondeu não
> esperasse que alguém procurasse.

**Requer:** ter descoberto o Pátio do Castelo.
**O que dá pra fazer:** perguntar ao Guarda Insone (ele fica pálido e diz
"não"); descer.

### D-2 · Descida Longa — `corredor`
> Oitenta degraus. A cada dez, o ar fica mais frio e mais parado. Não tem eco.
> No degrau quarenta, quem olhar pra trás não enxerga mais a entrada, e é cedo
> demais pra isso ser possível.

**O que dá pra fazer:** contar os degraus (d20+Inteligência — sucesso total: são oitenta
descendo e **oitenta e dois subindo**, e ninguém vai conseguir explicar isso);
voltar (sempre possível, e sempre a jogada certa).

### D-3 · Antecâmara Alagada — `armadilha`
> Água gelada até o tornozelo cobrindo o chão inteiro de uma câmara grande e
> vazia. Não tem nada aqui. Nem osso, nem baú, nem marca de garra. E a água
> está limpa.

**Aqui o mestre dá o último aviso claro** — em voz alta, fora de personagem se
precisar. Diga: *"a partir daqui eu não vou proteger vocês."*
**O que dá pra fazer:** ouvir (d20+Sabedoria — sucesso total: há respiração na sala
seguinte, e é grande, e é lenta); recuar (e ganhar, por isso, a informação de
D-5 na próxima visita de qualquer jeito).

### D-4 · Salão do Scavenge Toad — `miniboss`
> A câmara é enorme e o teto é alto demais pra caber embaixo do castelo. No
> meio dela, ocupando espaço que nenhuma criatura do andar 1 ocuparia, está
> uma coisa. Ela vira a cabeça na direção de vocês sem levantar o corpo.

**Quem está aqui:** **Scavenge Toad** — ameaça incompatível com o andar 1.
Não dê ficha, não dê contagem de PV. Descreva e deixe claro que a conta
não fecha.
**Fugir é a jogada certa e o mestre deve garantir que seja possível:**
qualquer teste de fuga em sucesso parcial ou mais funciona. Uma falha custa equipamento, nunca
uma vida — na primeira vez.
**Se insistirem:** eles foram avisados três vezes (boato em Tolbana, a frase
de Lynx, e D-3). Deixe as consequências acontecerem.

### D-5 · Porta Que Não Abre — `segredo`
> Do outro lado do salão, uma porta. Sem fechadura, sem maçaneta, sem
> dobradiça, sem batente. É uma laje de pedra do tamanho de uma porta, encaixada
> numa parede, e a junta em volta dela é fina demais pra passar uma lâmina.

**A pedra é a mesma da Câmara da Inscrição.**
**O que dá pra fazer:** usar o **`Martelo do Mural`** (soa diferente aqui — e
o som volta **de longe demais**, como se houvesse um espaço grande atrás);
usar o `Anel dos Cinco Encaixes` (ele esquenta e a cantiga que ele toca **não
para** no trecho de sempre: ela continua por mais duas notas, e para).
**Recompensa:** duas notas a mais da cantiga. Só isso. E é enorme.

**Se o grupo recuou em D-3 e nunca chegou aqui:** entregue a mesma informação
mais tarde, pela boca do Guarda Insone na quest `castelo_04` — ele viu a porta
na noite do dia 6, e ele viu ela **aberta**.
