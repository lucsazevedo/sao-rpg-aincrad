---
titulo: Produção por Ofício — o que cada profissão fabrica, presta ou descobre
andar: 1
uso: jogador_e_mestre
producoes: 48
---

# Produção por Ofício

## O problema que este arquivo resolve

Auditoria de agosto/2026: dos 116 itens do catálogo, **só 4 profissões
craftam** — Costureiro (15 itens), Ferreiro (13), Joalheiro (7) e Coveiro (3).
As outras doze não produziam **nada**, e oito não tinham nem uma linha de
receita: Cartógrafo, Cozinheiro, Diplomata, Bibliotecário, Domador, Médico,
Músico e Mercenário.

Isso é desequilíbrio de verdade, e não se resolve dando martelo pra todo mundo.
Um Diplomata não forja espada — mas ele **produz** alguma coisa, senão não é
profissão, é adjetivo.

## As três moedas de produção

Toda profissão entrega uma das três, e as três valem o mesmo na mesa:

| Moeda | O que sai | Quem trabalha assim |
|---|---|---|
| **Matéria** | um objeto que entra no inventário | Ferreiro, Costureiro, Joalheiro, Alquimista, Cozinheiro, Coveiro, Lenhador, Caçador |
| **Serviço** | um efeito que dura uma cena, uma sessão ou uma expedição | Médico, Músico, Mercenário, Domador |
| **Conhecimento** | uma informação que outro grupo paga pra ter | Cartógrafo, Bibliotecário, Comerciante, Diplomata |

**Regra de troca:** serviço e conhecimento são **vendáveis**. Um mapa, uma
escolta, um diagnóstico e uma trégua têm preço em Col igual a qualquer item
Incomum. Se o grupo aceitar de graça, aceitou de graça — mas o preço existe.

## Como cada produção funciona

Estrutura idêntica para as 48: **precisa de** algo, **rola** um teste, e o
resultado tem três faixas. Nenhuma exige oficina, nenhuma exige que outro
jogador esteja presente — só que o material exista no mercado.

**7-9 sempre entrega.** Produção não é combate: o preço do parcial é
quantidade, qualidade, tempo ou exclusividade — nunca "não saiu".

**Qualidade.** Um 10+ em produção de Matéria pode sair **uma raridade acima**
se o material permitir (ver o teto por raridade em
`armas/00_catalogo_expandido.md`). Comum vira Incomum; Incomum **não** vira
Raro — Raro é conquista, não fabricação.

---

## Caçador — Matéria

| Produz | Precisa de | Teste | 10+ | 7-9 |
|---|---|---|---|---|
| **Material de caça bônus** | corpo recém-abatido | 2d6+Reflexo | Peça íntegra, valor cheio | Imperfeita, metade do valor |
| **Carne curada de viagem** | carne fresca + sal ou fumaça | 2d6+Técnica | 3 rações que não estragam | 2 rações, e uma azeda em dois dias |
| **Isca de rastro** | glândula ou víscera da presa | 2d6+Reflexo | Atrai a espécie escolhida por uma cena inteira | Atrai, mas também o que caça aquela espécie |

**Vale:** material 15-60 Col conforme a peça · ração 20 Col o lote · isca 30 Col.

**Cardápio concreto:** `docs/receitas_cacador.md`.

---

## Lenhador — Matéria

| Produz | Precisa de | Teste | 10+ | 7-9 |
|---|---|---|---|---|
| **Madeira boa / Nodosa** | árvore certa e tempo | 2d6+Reflexo | 2 unidades, com chance de Nodosa | 1 unidade, e a queda faz barulho |
| **Cabo e haste** | madeira + faca | 2d6+Técnica | Cabo de reposição pra qualquer arma de haste; conserta a peça sem Ferreiro | Serve, mas racha na próxima chuva |
| **Acampamento montado** | madeira, meia hora, um lugar | 2d6+Reflexo | Descanso seguro **e** o mestre remove uma pressão do caminho | Seguro, mas custa uma vigília |

**Vale:** Madeira 6 Col · Nodosa 22 Col · cabo 25 Col · acampamento vendido a
outro grupo 40 Col a noite.

**Cardápio concreto:** `docs/receitas_lenhador.md`.

---

## Cartógrafo — Conhecimento

| Produz | Precisa de | Teste | 10+ | 7-9 |
|---|---|---|---|---|
| **Mapa de região** | ter percorrido a região | 2d6+Conhecimento | Mapa completo, vendável, com os pontos ocultos | Mapa dos pontos óbvios |
| **Rota segura** | o destino e um ponto de vista alto | 2d6+Conhecimento | O grupo evita uma ameaça prevista na travessia | Evita, mas chega num lugar pior |
| **Marco de retorno** | tinta, giz ou pedra | 2d6+Técnica | A marca aguenta chuva e ninguém além do seu grupo entende | Aguenta, mas outro grupo aprende a ler |

**Vale:** mapa 10 Col por ponto revelado · rota 60-120 Col antes de incursão ·
marco não se vende, se troca.

**Cardápio concreto:** `docs/servicos_cartografo.md`.

---

## Comerciante — Conhecimento

| Produz | Precisa de | Teste | 10+ | 7-9 |
|---|---|---|---|---|
| **Avaliação** | o item na mão | 2d6+Conhecimento | Raridade real, procedência e preço justo | A raridade, sem a história |
| **Lote importado** | capital adiantado | 2d6+Conhecimento | Chega na próxima sessão, com margem | Chega com 30% de acréscimo |
| **Carta de crédito** | reputação com um vendedor | 2d6+Conhecimento | O grupo compra fiado em três lojas | Numa loja, e ela cobra juro em serviço |

**Vale:** avaliação 20 Col ou favor · lote é a margem que você fizer · crédito
não tem preço, tem consequência.

**Cardápio concreto:** `docs/servicos_comerciante.md`.

---

## Cozinheiro — Matéria

| Produz | Precisa de | Teste | 10+ | 7-9 |
|---|---|---|---|---|
| **Prato com bônus** | proteína + erva + fogo | 2d6+Conhecimento | Bônus de refeição pro grupo inteiro na próxima expedição | Pra metade do grupo |
| **Conserva de viagem** | qualquer material perecível + sal | 2d6+Técnica | O material dura a campanha inteira | Dura três sessões |
| **Chá de recuperação** | erva comum + água quente | 2d6+Conhecimento | Remove uma Condição leve sem gastar item | Alivia; a Condição volta se a cena piorar |

**Vale:** prato 20-40 Col · conserva 15 Col a unidade · chá é de graça, e é de
propósito.

**Cardápio concreto:** `Comidas/00_catalogo_receitas_cozinheiro.md` — 17
receitas nomeadas em 3 dificuldades, prontas pra jogar em vez de narrar do
zero toda vez.

---

## Diplomata — Conhecimento

| Produz | Precisa de | Teste | 10+ | 7-9 |
|---|---|---|---|---|
| **Acordo escrito** | as duas partes na mesma sala | 2d6+Conhecimento | O acordo se sustenta sozinho e vira precedente | Se sustenta enquanto você estiver por perto |
| **Salvo-conduto** | reputação com um clã | 2d6+Conhecimento | Passagem livre pro grupo em território daquele clã | Passagem pra você, mediante favor |
| **Leitura de sala** | estar presente antes de começar | 2d6+Espírito | Você sabe quem vai ceder, quem vai brigar e quem está blefando | Sabe quem vai brigar |

**Vale:** acordo 70-150 Col de comissão · salvo-conduto 80 Col · leitura de sala
é o que salva a cena, e não se cobra por isso.

**Cardápio concreto:** `docs/servicos_diplomata.md`.

---

## Bibliotecário — Conhecimento

| Produz | Precisa de | Teste | 10+ | 7-9 |
|---|---|---|---|---|
| **Dossiê de criatura** | acesso a uma fonte real | 2d6+Conhecimento | Fraqueza, resistências e vulnerabilidades — vendável a outro grupo | Só a fraqueza principal |
| **Transcrição** | tempo, papel e a inscrição na frente | 2d6+Técnica | Cópia fiel, transportável, que outro estudioso aceita | Cópia parcial |
| **Cruzamento de fontes** | duas fontes que discordam | 2d6+Conhecimento | Você acha a contradição — e a contradição é a pista | Descobre que discordam |

**Vale:** dossiê 60-120 Col antes de raid · transcrição 40 Col · cruzamento não
se vende: é o que muda a campanha.

**Cardápio concreto:** `docs/servicos_bibliotecario.md`.

---

## Alquimista — Matéria

| Produz | Precisa de | Teste | 10+ | 7-9 |
|---|---|---|---|---|
| **Frasco de Antídoto** | Seiva limpa + frasco vazio | 2d6+Conhecimento | 2 frascos | 1 frasco |
| **Pomada e reagente** | Ervas + componente comprado | 2d6+Conhecimento | Lote de 3, e um extra pro Médico | Lote de 2 |
| **Estabilizante de viagem** | material volátil + frasco | 2d6+Técnica | O material chega inteiro em qualquer distância | Chega com metade da potência |

**Vale:** antídoto 250 Col (contra 250 do Cristal — e o seu não tem recarga) ·
pomada 60 Col · estabilizante 40 Col.

**Cardápio concreto:** `pocoes/00_catalogo_pocoes_alquimista.md` — 17
receitas nomeadas em 3 dificuldades.

---

## Costureiro — Matéria

| Produz | Precisa de | Teste | 10+ | 7-9 |
|---|---|---|---|---|
| **Peça de tecido ou couro** | Pelagem/tecido + molde | 2d6+Técnica | Sai uma raridade acima se o material permitir | Sai no prazo dobrado |
| **Reforço com placa** | a peça + Placas de Metal Refinado | 2d6+Técnica | Vira Armadura de Couro Reforçada, sem perder mobilidade | Vira, mas pesa: complicação em furtividade |
| **Remendo de campo** | agulha, linha e cinco minutos | 2d6+Técnica | Conserta peça rachada sem oficina | Conserta, e fica visível |

**Vale:** peça 90-390 Col · reforço 260 Col · remendo 1/5 do preço do item.

**Cardápio concreto:** `docs/receitas_costureiro.md`.

---

## Domador — Serviço

| Produz | Precisa de | Teste | 10+ | 7-9 |
|---|---|---|---|---|
| **Vínculo com criatura** | o petisco certo e paciência | 2d6+Técnica na barra | 1 sucesso limpo | 1 sucesso, e ela reage mal no turno |
| **Adestramento de tarefa** | criatura já domada | 2d6+Técnica | Ela executa uma tarefa específica sozinha, longe de você | Executa, mas volta machucada |
| **Serviço de batedor** | criatura domada + um contratante | 2d6+Técnica | O contratante atravessa a região sem encontro | Atravessa com um encontro evitável |

**Vale:** serviço de batedor 80 Col a travessia · criatura domada **não se
vende** — e quem tentar vender descobre por quê.

**Cardápio concreto:** `docs/receitas_domador.md`.

---

## Ferreiro — Matéria

| Produz | Precisa de | Teste | 10+ | 7-9 |
|---|---|---|---|---|
| **Placas de Metal Refinado** | Minério Raro + Madeira | 2d6+Técnica | 2 Placas | 1 Placa |
| **Lâmina Reforçada** | Placas + Fragmento Kobold | 2d6+Técnica | Insumo de qualidade pra arma Incomum, e sobra aparo | Sai, com uma imperfeição visível |
| **Conserto e têmpera** | forja acesa | 2d6+Técnica | Conserta e melhora a durabilidade permanentemente | Conserta |

**Vale:** Placa 90-100 Col · Lâmina 180 Col · conserto 1/5 do preço base.

**Cardápio concreto:** `docs/receitas_ferreiro.md`.

---

## Joalheiro — Matéria

| Produz | Precisa de | Teste | 10+ | 7-9 |
|---|---|---|---|---|
| **Acessório engastado** | pedra + fio de prata | 2d6+Técnica | Sai perfeito e sobra material | Sai, gastando o dobro |
| **Lapidação** | Cristal Bruto | 2d6+Técnica | Bruto vira reagente puro: vale o dobro | Vale o mesmo, com perda de 30% |
| **Selo ou insígnia** | metal + um símbolo pra copiar | 2d6+Técnica | Cópia que passa por original | Passa de longe |

**Vale:** acessório 300-350 Col · lapidação dobra o preço do Cristal Bruto ·
selo 120 Col, e o uso dele é problema de quem comprou.

**Cardápio concreto:** `docs/receitas_joalheiro.md`.

---

## Coveiro — Matéria

| Produz | Precisa de | Teste | 10+ | 7-9 |
|---|---|---|---|---|
| **Terço e talismã de osso** | Ossos Antigos + ritual próprio | 2d6+Espírito | A peça funciona (só vale se você mesmo montar) | Funciona pela metade |
| **Registro de morte** | o nome e a confirmação | 2d6+Espírito | Entra no Memorial, e a família sabe primeiro | Entra, e alguém vai duvidar |
| **Preparo de sepultura** | tempo e respeito | 2d6+Espírito | O lugar aceita: nenhum não-corpóreo se manifesta ali de novo | Fica quieto por uma sessão |

**Vale:** talismã 240 Col · registro não se cobra · preparo é pago em acesso —
o Zelador passa a te responder.

**Cardápio concreto:** `docs/receitas_coveiro.md`.

---

## Médico — Serviço

| Produz | Precisa de | Teste | 10+ | 7-9 |
|---|---|---|---|---|
| **Tratamento de status** | Ervas + componente do Alquimista | 2d6+Espírito | Remove veneno, paralisia, sono ou confusão sem gastar Cristal | Remove, e leva a noite |
| **Kit de primeiros socorros** | bandagem, ervas, frasco | 2d6+Técnica | 3 usos, e qualquer um do grupo consegue usar | 2 usos, e só você sabe usar |
| **Laudo** | examinar quem está estranho | 2d6+Conhecimento | Nomeia a causa — e nomear muda o que dá pra fazer | Sabe o que **não** é |

**Vale:** tratamento 80 Col (contra 250 do Cristal de Antídoto) · kit 90 Col ·
laudo 50 Col, e vale mais quando é ruim.

**Cardápio concreto:** `docs/receitas_medico.md`.

---

## Músico — Serviço

| Produz | Precisa de | Teste | 10+ | 7-9 |
|---|---|---|---|---|
| **Toque de ânimo** | instrumento e ser ouvido | 2d6+Espírito | Todo aliado que falhou no teste anterior rola de novo | Um aliado rola de novo |
| **Canção de trabalho** | um grupo fazendo tarefa longa | 2d6+Espírito | A tarefa rende o dobro e ninguém desiste no meio | Rende, mas cansa igual |
| **Cantiga com recado** | a mensagem e uma melodia | 2d6+Espírito | A mensagem viaja pelo andar sem você levar, e só quem deve entende | Viaja, e mais alguém entende |

**Vale:** toque na praça = 10% de desconto pro grupo enquanto durar · canção de
trabalho 50 Col por jornada · cantiga com recado 70 Col, e é o correio mais
seguro do andar.

**Cardápio concreto:** `docs/servicos_musico.md`.

---

## Mercenário — Serviço

| Produz | Precisa de | Teste | 10+ | 7-9 |
|---|---|---|---|---|
| **Escolta** | um contratante e uma rota | 2d6+Corpo | Chegam inteiros, e você fica com parte do material | Chegam, e o escoltado perde algo |
| **Perímetro** | um lugar pra defender | 2d6+Corpo | Ninguém passa enquanto o grupo faz outra coisa | Passa um |
| **Avaliação de ameaça** | ver o inimigo antes | 2d6+Conhecimento | Quantos são, o que querem, e se dá pra evitar | Quantos são |

**Vale:** escolta 100-200 Col por expedição, mais parte do material ·
perímetro 60 Col a cena · avaliação 40 Col, e evita a briga que custaria mais.

**Cardápio concreto:** `docs/servicos_mercenario.md`.

---

# Conferência

| | Quantidade |
|---|---|
| Profissões com produção definida | **16 de 16** |
| Produções no total | **48** (3 por profissão) |
| Profissões que produzem Matéria | 8 |
| Profissões que produzem Serviço | 4 |
| Profissões que produzem Conhecimento | 4 |
| Profissões sem nada pra produzir | **0** (antes: 8) |

**A regra que mantém isso equilibrado:** ao criar item novo, pergunte **qual
moeda ele usa**. Se a resposta for sempre "Matéria, feito pelo Ferreiro", o
desequilíbrio volta. As doze profissões que não martelam metal precisam que
serviço e conhecimento continuem valendo Col de verdade na sua mesa — é isso
que faz um Diplomata sentar à mesa com um Ferreiro como igual.
