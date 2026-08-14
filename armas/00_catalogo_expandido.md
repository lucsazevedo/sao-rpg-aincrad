---
titulo: Catálogo Expandido de Armas — Andar 1
andar: 1
itens_novos: 29
---

# Catálogo Expandido de Armas — Andar 1

Os 22 arquivos individuais em `armas/` cobrem **um item por tipo**, quase
todos Comuns — é o equipamento de saída. Este catálogo adiciona **29 itens**
(22 Incomuns, um por tipo, + 7 Raros espalhados pelo andar — um por
atributo, ver nota de balanceamento no fim do arquivo), levando o roster
para **51 armas**, com fonte concreta em cada uma: drop de um monstro
nomeado, recompensa de uma quest existente, ou venda por um NPC que já existe
no mapa.

Preços e quem vende: `docs/mercado_andar1.md`. Regras de bônus de
equipamento (o teto de +1, durabilidade, requisito de atributo):
`equipamentos/00_indice.md` — **valem igual para armas**.

> **Nota sobre Moves de Arma.** As regras e os Moves de Arma (combate +
> utilitário), feitos para manter **todas as armas Tier S em protagonismo**,
> vivem no manual do jogador: `docs/guia_sistema_aincrad.md`.

## A regra de balanceamento: facilidade de obter define o teto

Vale para **armas e equipamentos**, e é a única regra que precisa ser
respeitada sem exceção quando você criar item novo:

| Nível       | Como se consegue                                                           | Pode ser desbalanceado?                                                                  |
| ----------- | -------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| **Comum**   | Comprado em qualquer loja                                                  | **Não.** Zero bônus numérico. Só utilidade estreita                                      |
| **Incomum** | Comprado, craftado ou quest Média                                          | **Não.** Exatamente **um** +1, sempre situacional. Nunca dois efeitos                    |
| **Raro**    | Quest Difícil, miniboss, puzzle inteiro                                    | **Um pouco.** Um +1 mais amplo **+ um efeito único**, e o efeito único **paga um preço** |
| **Único**   | Uma unidade no andar inteiro. Chefe, cadeia completa, escolha irreversível | **Sim, e deve ser.** É o prêmio. Mas o custo tem que doer                                |

**O motivo:** um item que qualquer um compra por 300 Col e que resolve
qualquer situação faz todo mundo comprar aquele item, e aí não existem mais
escolhas — existe uma build. Já um item que só existe uma vez no andar inteiro
**precisa** ser forte demais, senão a conquista não significa nada.

**Como isso aparece na prática neste catálogo:**

- Os 22 **Incomuns** dão exatamente um +1, sempre amarrado a uma situação
  (água, vento, armadura, planta, corredor). Nenhum tem segundo efeito.
- Os 6 **Raros** são todos **únicos** — uma unidade no andar — e todos quebram
  a curva de propósito, cada um pagando com uma coisa concreta:

| Único                              | Quebra a curva assim                                               | E paga assim                                                             |
| ---------------------------------- | ------------------------------------------------------------------ | ------------------------------------------------------------------------ |
| `Nodachi de Illfang`               | Vira +1 automático em **tudo** quando você está a um golpe de cair | Não pode ser usado em corredor, sala pequena ou luta agarrada            |
| `Arco do Arauto`                   | Um tiro por combate conta como 2 golpes e ignora escudo            | Fecha a doma do Arauto para sempre; nenhum deles deixa você chegar perto |
| `Rapieira do Duelo Sem Nome`       | Um teste automático por sessão (conta como 10+ sem rolar)          | Você não consegue dizer em voz alta o nome de ninguém que morreu         |
| `Martelo do Mural`                 | Detector de passagem secreta do andar inteiro                      | Nenhum — é utilitário, não combate. Por isso é o mais fraco dos seis     |
| `Lança da Vigília`                 | Imunidade a sono, paralisia e confusão pro grupo                   | O portador não recupera nada descansando, nunca                          |
| `Escudo e Espada do Primeiro Muro` | Salva um aliado da derrota, uma vez por sessão                     | Não pode ser vendido, largado nem destruído enquanto você tiver grupo    |

Os 7 equipamentos **Raros** (`equipamentos/00_indice.md`) seguem a mesma
lógica, e o teto de **+1 por teste** continua valendo até pra eles — o que os
Únicos quebram é o **efeito**, nunca o número.

## Skills provisórias por tipo de arma

As Skills de arma foram substituídas pelos **Moves de Arma** (Move de Combate +
Move Utilitário) descritos no manual do jogador:
`docs/guia_sistema_aincrad.md`.

Este catálogo existe para listar **itens** (as 22 armas iniciais + 28 novas) e
suas fontes no mundo. A regra de raridade e o teto de item continuam valendo.

---

# Incomuns — um por tipo

## Arco do Vigia de Kaldan — Incomum · Arco e Flecha · Reflexo

**Requisito:** Reflexo -1+ · **Preço:** 320 Col

Arco recurvo de teixo laminado com chifre, corda dupla. A empunhadura tem
duas marcas de dedo desgastadas — o dono anterior atirava sempre igual.

**Efeito:** +1 em testes de Reflexo para atirar em **alvo parado ou
distraído**. Numa falha, a flecha não se perde: é recuperável.

**Como obter:** vendido pela Garota do Arco depois de duas expedições juntas;
recompensa de `bounty_03`.

---

## Adagas de Osso de Voss — Incomum · Adagas · Técnica

**Requisito:** Técnica -1+ · **Preço:** 300 Col

Lâminas curtas talhadas de Ossos Antigos, brancas e frias, com cabo de couro
enrolado. Não enferrujam e não fazem barulho ao sair da bainha.

**Efeito:** +1 em testes de Técnica contra criaturas **não-corpóreas ou
mortas-vivas** (Espectro Sussurrante). Contra elas, o dano físico normalmente
resistido conta.

**Como obter:** crafting de Coveiro + Ferreiro (Ossos Antigos x4); cadeia F.

---

## Punhais de Lastro — Incomum · Adagas de Arremesso · Reflexo

**Requisito:** Reflexo -1+ · **Preço:** 280 Col

Seis lâminas pequenas com peso de chumbo na ponta e cabo sem guarda, num
cinto de bainhas. Voam retas mesmo com vento.

**Efeito:** +1 em testes de Reflexo para arremessar **em local aberto e
ventoso** (Penhascos de Vaelor, Estepes de Kaldan, topo das Montanhas).

**Como obter:** Loja de Armas de Tolbana; recompensa de `bounty_04`.

---

## Besta de Manivela de Grauvenn — Incomum · Besta · Reflexo

**Requisito:** Técnica -1+ · **Preço:** 380 Col

Besta pesada com manivela lateral e trava de segurança de mineiro. Recarrega
mais devagar e bate muito mais forte.

**Efeito:** +1 em testes de Reflexo para atirar em **alvo com armadura**
(Ruin Kobold Sentinel, Armadura Animada, Sentinela Esquecida).

**Como obter:** Ferreiro de Tolbana; recompensa de `grauvenn_04`.

---

## Chakrams de Escama — Incomum · Chakrams · Técnica

**Requisito:** Técnica -1+ · **Preço:** 340 Col

Dois aros de metal leve revestidos de Escama Prateada nas bordas. Cortam água
sem perder velocidade e voltam molhados.

**Efeito:** +1 em testes de Técnica para arremessar **sobre ou dentro
d'água** — inclui arremessar de um barco no Lago Sylvaine.

**Como obter:** crafting de Joalheiro + Ferreiro (Escama Prateada x6); cadeia C.

---

## Chicote de Vinha Curada — Incomum · Chicote · Conhecimento

**Requisito:** Conhecimento -1+ · **Preço:** 310 Col

Uma Trepadeira Estranguladora morta, curada em resina até virar corda rígida
e flexível. Ainda tem espinhos, agora inertes. Quase.

**Efeito:** +1 em testes de Conhecimento para **desarmar, puxar ou prender à
distância**. Contra criaturas-planta, o chicote não é resistido pelas vinhas.

**Como obter:** crafting de Alquimista + Costureiro (Trepadeira abatida
inteira + Seiva de Nepenthes); cadeia B.

---

## Par de Guarda de Tolbana — Incomum · Escudo e Espada · Corpo

**Requisito:** Corpo -1+ · **Preço:** 400 Col

Espada curta de lâmina larga e escudo redondo combinando, com o mesmo
punho — feitos pra serem usados juntos, e desequilibrados se separados.

**Efeito:** +1 em testes de Corpo para **proteger outra pessoa** enquanto
ataca. Enquanto o par estiver equipado junto, a Skill **Muro** em 7-9 permite
os dois efeitos se o aliado protegido também estiver adjacente.

**Como obter:** Loja de Armas de Tolbana; padrão da guarda da cidade.

---

## Espada Longa de Aço Kobold — Incomum · Espada Longa · Corpo

**Requisito:** Corpo -1+ · **Preço:** 420 Col

Lâmina reforjada a partir de placas de Ruin Kobold, com uma têmpera irregular
que deixou linhas escuras no aço. Pesada na ponta.

**Efeito:** +1 em testes de Corpo para atacar **inimigos com armadura**.

**Como obter:** crafting de Ferreiro (Lâmina Reforçada + Fragmento de
Armadura Kobold x2); cadeia H.

---

## Foice de Ceifa dos Terraços — Incomum · Foice · Técnica

**Requisito:** Técnica -1+ · **Preço:** 290 Col

Arma longa de cabo liso e lâmina curva. Boa para abrir passagem, puxar algo
sem tocar e lutar em ângulos ruins.

**Efeito:** +1 em testes de Técnica contra **criaturas pequenas em grupo**
(Gafanhoto Gigante, Enxame do Rio, ninhada de Toca na Raiz) — a lâmina larga
pega vários de uma vez.

**Como obter:** Fazendeiro Local (Terraços de Solveig), depois de
`bounty_05_colheita_ameacada`.

---

## Katana de Punho Envolto — Incomum · Katana · Espírito

**Requisito:** Espírito -1+ · **Preço:** 430 Col

Lâmina reta demais pra ser tradicional, com o punho enrolado em tecido escuro
por cima do couro original — alguém quis esconder alguma coisa gravada ali.

**Efeito:** +1 em testes de Espírito para atacar quando o personagem está
**em desvantagem numérica** (sozinho contra dois ou mais).

**Como obter:** Mercado Negro da Cidade do Início, sem explicação de
procedência. Desenrolar o punho é um gancho de mestre em aberto.

---

## Lança de Parede de Escudos — Incomum · Lança · Técnica

**Requisito:** Técnica -1+ · **Preço:** 350 Col

Haste de freixo com ponta longa e estreita e um contrapeso de ferro na base.
Feita pra ser usada da segunda fila, atrás de quem segura o escudo.

**Efeito:** +1 em testes de Técnica para atacar **de trás de um aliado ou de
uma cobertura** — o item que faz formação de grupo valer a pena mecanicamente.

**Como obter:** Loja de Armas de Tolbana; cadeia H.

---

## Machado de Lenhador de Horunka — Incomum · Machado · Corpo

**Requisito:** Corpo -1+ · **Preço:** 330 Col

Cabeça larga, cabo curto, gume ainda com resina grudada. Um machado de
trabalho que virou arma porque foi o que tinha à mão.

**Efeito:** +1 em testes de Corpo contra **criaturas-planta e alvos de
madeira** (Little Nepenthes, Trepadeira Estranguladora, porta de dungeon).
Também serve como ferramenta de Lenhador sem penalidade.

**Como obter:** Loja de Ferramentas de Horunka; cadeia B.

---

## Marreta de Pedreira — Incomum · Martelo · Corpo

**Requisito:** Corpo 0+ · **Preço:** 390 Col

Cabeça de ferro fundido em bloco, cabo de aço envolto em corda. Feita pra
quebrar pedra, não pessoas — o que a torna especialmente ruim de levar.

**Efeito:** +1 em testes de Corpo contra **construtos e criaturas de casca
dura** (Armadura Animada, Sentinela Esquecida, Verme de Cristal, Escorpião
de Poeira).

**Como obter:** Pedreira de Dunhelm (a maioria está largada lá); Ferreiro
de Tolbana por 390 Col.

---

## Pá de Trincheira de Ruyn — Incomum · Pá · Conhecimento

**Requisito:** Conhecimento -1+ · **Preço:** 300 Col

Pá curta de borda afiada, encontrada aos montes no Campo de Ruyn, onde
alguém, algum dia, cavou muita coisa às pressas.

**Efeito:** +1 em testes de Conhecimento para **usar o terreno a favor** —
cavar cobertura, abrir vala, desenterrar algo, derrubar um alvo em solo
instável.

**Como obter:** coleta livre no Campo de Ruyn (teste de Conhecimento pra
achar uma que ainda preste); vendida por 300 Col em Tolbana.

---

## Rapieira de Copo Fechado — Incomum · Rapieira · Reflexo

**Requisito:** Reflexo -1+ · **Preço:** 410 Col

Lâmina fina e longa com guarda em copo trabalhado protegendo a mão inteira.
Elegante de um jeito que não combina com o dia 10.

**Efeito:** +1 em testes de Reflexo em **duelo um contra um** — contra
exatamente um oponente, sem aliados nem inimigos adjacentes.

**Como obter:** Loja de Armas de Tolbana; recompensa de `tolbana_e05`.

---

## Bastão de Peregrino — Incomum · Bastão · Espírito

**Requisito:** Espírito -1+ · **Preço:** 270 Col

Vara alta de madeira escura, lisa de tanto uso, com uma marca a cada palmo —
alguém contava distância percorrida.

**Efeito:** +1 em testes de Espírito para **manter a calma ou inspirar
alguém** enquanto empunha. Funciona como bordão de viagem: o grupo ignora
complicação por cansaço em marcha longa.

**Como obter:** Contador de Histórias (Cidade do Início) o dá a quem ouvir
sua história inteira sem interromper. Uma vez só, e ele sabe quem já ouviu.

---

## Machado de Osso de Guardião — Incomum · Machado · Corpo

**Requisito:** Corpo 0+ · **Preço:** 440 Col

Um fêmur do Guardião de Mournhall, denso como pedra, lascado até virar fio,
com o punho enrolado em tira de couro. Ainda tem a Presa do Guardião cravada
na lâmina.

**Efeito:** +1 em testes de Corpo para **derrubar ou empurrar** um alvo maior
que o usuário. Criaturas de caverna hesitam ao vê-lo: primeiro ataque delas
contra o portador sofre complicação.

**Como obter:** crafting de Mercenário + Ferreiro com a Presa do Guardião
(drop 40% do Guardião de Mournhall).

---

## Corrente de Âncora do Rio — Incomum · Corrente com Peso · Técnica

**Requisito:** Técnica -1+ · **Preço:** 360 Col

Corrente pesada com uma âncora pequena de barco na ponta, enferrujada em
laranja. Do Barqueiro do Rio Coluber, que jura ter parado de precisar dela.

**Efeito:** +1 em testes de Técnica para **prender ou puxar** um alvo. A
Skill **Prender** em 10+ imobiliza por 2 rodadas em vez de 1 contra
criaturas aquáticas (Lacustre Vagador, Enxame do Rio, Sanguessuga).

**Como obter:** comprada do Barqueiro; recompensa de `sylvaine_04`.

---

## Manoplas de Casco de Verme — Incomum · Manopla · Corpo

**Requisito:** Corpo -1+ · **Preço:** 380 Col

Punhos revestidos com placas de carapaça de Verme de Cristal. Cada golpe
solta um estalo agudo, alto demais.

**Efeito:** +1 em testes de Corpo para **golpear alvo de casca dura ou
mineral**. O estalo atrai atenção — furtividade fica impossível durante o
combate, e o mestre deve cobrar isso em dungeon.

**Como obter:** crafting de Ferreiro (carapaça de Verme de Cristal, Gruta de
Lumis).

---

# Raros — 6 no andar inteiro

## Nodachi de Illfang — Raro · Katana · Espírito

**Requisito:** Espírito 0+ · **Preço:** não é vendido · **Canônico**

A lâmina longa demais que Illfang saca na última barra, quando larga o talwar
e o broquel. Desproporcional na mão de qualquer jogador — precisa dos dois
braços e de espaço que quase nenhum corredor do Labirinto tem.

**Efeito:** +1 em testes de Espírito para atacar **em espaço aberto**.
**Efeito único — Última Barra:** quando o usuário está a um golpe da derrota,
o bônus vira +1 automático em **todo** teste até o fim do combate.
**Custo:** em corredor, sala pequena ou luta agarrada, o nodachi não pode ser
usado. É a arma que exige escolher o campo de batalha.

**Como obter:** drop garantido de `illfang_the_kobold_lord`, **1 unidade por
raid vencedor** (`monstros/illfang_the_kobold_lord.md`). Quem fica com ela é
uma discussão de mesa, de propósito.

---

## Arco do Arauto — Raro · Arco e Flecha · Reflexo

**Requisito:** Reflexo 0+ · **Preço:** não é vendido

Arco montado com uma costela e tendões de Arauto das Alturas, com penas do
próprio bicho amarradas nas pontas. A corda vibra num tom que dá pra ouvir do
outro lado do campo.

**Efeito:** +1 em testes de Reflexo para atirar **em qualquer alvo aéreo ou
mais alto que o atirador**.
**Efeito único — Tiro do Alto:** uma vez por combate, disparado de um ponto
elevado, o tiro conta como **2 golpes** e não pode ser bloqueado por escudo.
**Peso:** enquanto o arco estiver equipado, nenhum Arauto das Alturas permite
aproximação — a rota de doma da cadeia D fecha, e não reabre.

**Como obter:** abater um Arauto das Alturas e levar o material ao Ferreiro
**e** ao Costureiro. Incompatível com o `Manto do Arauto` obtido por doma:
o jogador escolhe um caminho. Também concorre com o `Troféu do Arauto`
do Caçador (`docs/receitas_cacador.md`) — mesma carcaça de abate, o grupo
escolhe entre a arma e o troféu na hora.

---

## Rapieira do Duelo Sem Nome — Raro · Rapieira · Reflexo

**Requisito:** Reflexo 0+ · **Preço:** não é vendido

Encontrada na Necrópole de Voss, encostada numa lápide sem nome, como se
alguém a tivesse deixado ali de propósito. Sem marca de forja, sem desgaste,
sem uma única mossa.

**Efeito:** +1 em testes de Reflexo em duelo um contra um.
**Efeito único — Estocada Lembrada:** uma vez por sessão, ao atacar um
inimigo do **mesmo tipo** que o usuário já enfrentou antes, o teste é
automático (conta como 10+, sem rolar). A lâmina sabe o caminho.
**Peso:** enquanto empunhada, o usuário não consegue dizer em voz alta o nome
de ninguém que já morreu na campanha. Sai como um espaço vazio na frase.
Ver `docs/misterio_andar2.md`.

**Como obter:** cadeia F (`Memorial de Voss`), ao descobrir de quem era a
lápide sem nome — e escolher pegar a arma em vez de deixá-la onde estava.
Essa escolha tem consequência narrativa; ver notas da cadeia.

---

## Martelo do Mural — Raro · Martelo · Corpo

**Requisito:** Corpo 0+ · **Preço:** não é vendido

Cabeça de ferro escuro com cinco depressões na face, do mesmo tamanho das do
Anel dos Cinco Encaixes. Bater com ele em pedra gravada produz uma nota
musical, não um estrondo.

**Efeito:** +1 em testes de Corpo para **quebrar estrutura, parede, porta ou
construto**.
**Efeito único — Nota de Pedra:** golpear qualquer superfície de pedra
gravada do andar revela, por um instante, se há vazio do outro lado. É o
detector de passagem secreta do andar 1.
**Aviso ao mestre:** como o Anel, é fio do mistério, não resposta.

**Como obter:** Câmara da Inscrição do Castelo de Ferro Negro (cadeia G),
depois do puzzle dos 5 cristais — está preso na parede, e tirá-lo faz a
câmara inteira soar.

---

## Lança da Vigília — Raro · Lança · Técnica

**Requisito:** Técnica 0+ · **Preço:** não é vendido

Haste de madeira nodosa escura com ponta de metal refinado, e uma lanterna
pequena presa logo abaixo da lâmina. A chama nunca apaga, nem debaixo d'água.

**Efeito:** +1 em testes de Técnica para **negar a reação** do alvo —
interromper uma investida no meio, prender a arma antes do golpe, derrubar
antes do bote. (Ver a nota sobre iniciativa em `guias/00_como_usar.md`: neste
sistema o grupo sempre age e o monstro reage, então o que vale não é chegar
primeiro, é impedir a resposta.)
**Efeito único — Não Dormir:** o portador e todo aliado a dois passos dele
são **imunes a sono, paralisia e confusão**. Isso fecha três das complicações
mais usadas do Labirinto de uma vez.
**Custo:** o portador não recupera nada descansando — nem em estalagem, nem
em ponto de descanso de dungeon. Precisa passar a lança pra outra pessoa por
uma noite inteira, o que exige confiar em alguém.

**Como obter:** dada pelo Guarda Insone (`npcs/guarda_insone.md`) a quem
descobrir por que ele não dorme e resolver isso. Ele entrega aliviado.

---

## Escudo e Espada do Primeiro Muro — Raro · Escudo e Espada · Corpo

**Requisito:** Corpo 0+ · **Preço:** não é vendido

Par simples, sem ornamento nenhum: espada curta de guarda reta e escudo
retangular com a tinta descascada. Foi de alguém do primeiro grupo que tentou
o Labirinto e não voltou inteiro. O nome no verso do escudo está riscado.

**Efeito:** +1 em testes de Corpo para **proteger outra pessoa**.
**Efeito único — Ninguém Cai Hoje:** uma vez por sessão, quando um **aliado**
seria derrotado, o portador troca de lugar com ele: o golpe vem pro portador,
e o portador fica de pé com 1 golpe restante independentemente do que
aconteceria.
**Peso:** o item não pode ser vendido, largado ou destruído enquanto o
portador tiver um grupo. Ele só passa de mão quando o portador entrega
voluntariamente a alguém — e todo mundo na mesa vê quando isso acontece.

**Como obter:** cadeia H, `labirinto_h07` — recuperar o equipamento do grupo
do Marco, o mesmo grupo que o jogador solitário da entrada do Labirinto está
esperando (`CHEGADAS.labirinto_marco` no mapa) e o mesmo que o Memorial dos
Caídos registra. As três pontas se encontram aqui.

---

# Leque — 23ª arma, catálogo completo

O Leque foi adicionado depois do catálogo original (`docs/guia_sistema_aincrad.md`
tem o Move de Arma completo). Segue exatamente a mesma régua de raridade das
armas privilegiadas: Comum sem bônus, Incomum com um +1 situacional, Raro com
+1 amplo + efeito único que paga preço.

## Leque de Guerra Simples — Comum · Leque · Técnica

**Requisito:** — · **Preço:** 80 Col

Varetas de metal simples, pontas discretamente afiadas, sem entalhe nem
ornamento. O mesmo tipo de peça que qualquer ferreiro de cidade sabe montar.

**Efeito:** —

**Como obter:** loja da Cidade do Início, ou fabricado por um ferreiro local.

---

## Leque de Brasa Viva — Incomum · Leque · Técnica

**Requisito:** Técnica -1+ · **Preço:** 310 Col

Varetas enegrecidas por fumaça antiga, tecido chamuscado nas bordas mas ainda
inteiro — cheira a cinza mesmo quando fechado.

**Efeito:** +1 em testes de Técnica para **comandar mais de um aliado ao
mesmo tempo**.

**Como obter:** Ferreiro de Tolbana, sob encomenda — sem ingrediente raro, só
técnica de forja. 310 Col à vista.

---

## Leque das Mil Vozes — Raro · Leque · Técnica

**Requisito:** Técnica 0+ · **Preço:** não é vendido

Tecido pálido, tingido com a madeira do Bosque de Ashwen — sussurra baixinho
quando abre, mesmo sem vento.

**Efeito:** +1 em testes de Técnica para comandar, em qualquer situação.
**Efeito único — Coro:** uma vez por sessão, **Aceno que Comanda** afeta
todos os aliados na cena numa única rolagem.
**Custo:** toda vez que ela usa o Coro, um segredo que ela nunca contou
escapa junto — o mestre escolhe quem ouve e o quê.

**Como obter:** resolver o que a Voz Sem Corpo quer no Bosque de Ashwen
(`docs/oficios_andar1.md`, posto de trabalho do Lenhador). É negociação e
resolução de conflito, não craft nem compra. Nenhuma profissão é exigida
pra tentar.

---

## Chicote de Raiz-Mãe — Raro · Chicote · Conhecimento

**Requisito:** Conhecimento 0+ · **Preço:** não é vendido

Trançado com o Cordão-Âncora Seco que sobra da Mãe-Raiz de Horunka depois de
abatida — ainda muda de espessura sozinho, devagar, como se lembrasse de
puxar raiz.

**Nota de balanceamento:** adicionado numa rodada de revisão porque Chicote e
Pá (as duas armas de Conhecimento) eram os únicos tipos sem nenhum Raro no
catálogo — os outros 20 tipos tinham ao menos a chance de um. Ver
`docs/balanceamento_armas_oficios.md`.

**Efeito:** +1 em testes de Conhecimento para **imobilizar ou redirecionar**
um alvo (prender, puxar para um ponto ruim, negar avanço).
**Efeito único — Raiz que Lembra:** uma vez por cena, o chicote prende um
alvo por uma troca inteira sem precisar de teste — mas ele soltar-se cedo
demais (7-9 ou 6- no próximo teste do portador) faz o cordão "esquecer"
esse alvo pelo resto da sessão (não funciona duas vezes na mesma pessoa).
**Custo:** o cordão precisa de umidade — em terreno seco (Colinas Secas do
andar 2, deserto, dungeon quente) ele perde o efeito único até ser molhado
de novo.

**Como obter:** derrotar a Mãe-Raiz de Horunka (`monstros/mae_raiz_de_horunka.md`,
`floresta_covil`) e levar o Cordão-Âncora Seco ao Ferreiro **e** ao
Costureiro pra trançar — mesma lógica de dois-ofícios do Arco do Arauto.
