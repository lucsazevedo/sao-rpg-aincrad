---
titulo: Registro de Quests — Andar 1
andar: 1
---

Complemento a `00_indice_primeira_aventura.md`. As quatro quests da primeira
aventura (`01_javalis_na_pastagem.md` a `04_o_caminho_ate_o_labirinto.md`)
já têm prosa completa e continuam sendo o ponto de entrada da campanha. As
**56 quests abaixo** completam o andar 1 até um total de **60** — cada uma
com gancho, estrutura em beats, múltiplos testes (d20+atributo, 10+/7-9/6-),
encontro (quando aplicável), complicação, e recompensa proporcional à
dificuldade real da tarefa.

Cada quest tem `requer` (o que precisa estar concluído antes de aparecer)
e `desbloqueia` (o que ela libera ao ser concluída) — mesma lógica de
"explorar revela pontos próximos" do mapa interativo, aplicada a quests.
Cadeias sem `requer` podem ser oferecidas a qualquer momento depois que o
grupo chega na região correspondente.

## Como conduzir estas quests na mesa

Este arquivo funciona melhor se cada quest for tratada como **cena jogável**,
não como checklist de tarefa.

Prioridade do mestre, nesta ordem:

1. **Imagem forte** — o que o grupo vê/ouve/cheira quando a quest começa.
2. **Escolha visível** — o que divide a mesa em pelo menos duas abordagens.
3. **Complicação com avanço** — 6- piora a situação, mas não mata o ritmo.
4. **Conexão humana** — quem é afetado por isso, além do objetivo imediato.

Quando faltar detalhe numa quest, improvise sempre nestes quatro eixos:

- **Quem responde?**
- **O que está em jogo se ninguém agir?**
- **O que muda no mundo se o grupo resolver isso?**
- **Qual a imagem que faz isso valer assistir?**

## Regra de transmissão

Como esta campanha vai ser transmitida, cada quest deveria ter pelo menos:

- **1 abertura forte** (uma imagem ou frase que prenda rápido),
- **1 decisão divisiva** (correr risco, proteger alguém, recuar, mentir,
  poupar, capturar),
- **1 consequência que ecoa depois** (reputação, rumor, NPC lembrando, item,
  rota aberta, culpa, favor),
- **1 ponto de corte** bom para fim de bloco/sessão.

Se a cena estiver boa, deixe os jogadores falarem. Se estiver morna, corte
mais cedo para a decisão.

## Escala de dificuldade e recompensa

Mesma lógica de ameaça já usada pro bestiário (`docs/guia_sistema_aincrad.md`
— golpes-para-derrotar fraco/comum/forte/elite) aplicada a quest inteira, não
só a um combate. Toda quest abaixo declara sua dificuldade; a recompensa em
Col e a raridade do material seguem esta tabela como piso — o mestre pode
ajustar pra cima em caso de sucesso excepcional (10+ em todos os testes) ou
pra baixo em fracasso feio, mas não deveria inverter a ordem entre tiers.

| Dificuldade       | Perfil                                                                                                              | Col     | Material                            |
| ----------------- | ------------------------------------------------------------------------------------------------------------------- | ------- | ----------------------------------- |
| **Fácil**         | Sem combate real, ou ameaça fraca isolada; poucos testes                                                            | 20-50   | Comum garantido                     |
| **Médio**         | Ameaça comum, investigação com pressão real, ou doma/negociação de risco moderado                                   | 50-120  | Comum garantido + chance de Incomum |
| **Difícil**       | Ameaça forte, puzzle de múltiplas etapas, ou consequência social/narrativa grave em caso de erro                    | 120-250 | Incomum garantido + chance de Raro  |
| **Muito Difícil** | Ameaça elite ou de grupo, região "acima do nível recomendado", ou cadeia de falhas com risco real de fracasso total | 250-500 | Raro garantido + chance de Épico    |

O raid contra Illfang (`tolbana_12_o_raid_contra_illfang`) fica fora dessa
escala — usa a própria tabela de chefe em `monstros/illfang_the_kobold_lord.md`.

## Índice das cadeias

| Cadeia                   | Região principal          | Quests          | Tema                                                        |
| ------------------------ | ------------------------- | --------------- | ----------------------------------------------------------- |
| A — Primeiros Passos     | Cidade do Início / campos | 4 (já escritas) | Tutorial, já cobre o sistema                                |
| B — Caçadores de Horunka | Floresta de Horunka       | 8               | Vida na vila de caça, mistério da marca na árvore           |
| C — Águas de Sylvaine    | Lago Sylvaine             | 6               | O Lacustre Vagador e o redemoinho estranho                  |
| D — Picos de Grauvenn    | Montanhas de Grauvenn     | 6               | Mineração arriscada, ameaça acima do nível recomendado      |
| E — Vida em Tolbana      | Tolbana                   | 8               | Comércio, guildas, informação — sem risco de combate pesado |
| F — Memorial de Voss     | Necrópole de Voss         | 6               | Mistério ligado ao Coveiro e a um nome apagado              |
| G — O Mural do Castelo   | Castelo de Ferro Negro    | 6               | Expande o puzzle dos 5 cristais já documentado              |
| H — Preparativos do Raid | Tolbana → Labirinto       | 8               | Ponte direta pro confronto com Illfang                      |
| I — Contratos Avulsos    | Espalhadas pelo mapa      | 8               | Bounties standalone, sem pré-requisito entre si             |

---

## Cadeia B — Caçadores de Horunka

A cadeia gira em torno de duas coisas: a rotina de caça real da vila (ninhos,
material, doma) e um mistério pessoal e pequeno — o código de marcas que o
Eremita da Floresta guarda. Nada aqui liga ao mistério do andar 2 até
`horunka_08`, e mesmo ali é só mais um fragmento, não a resposta.

### `horunka_01_primeira_cacada` — Primeira Caçada em Horunka

**Tipo:** Eliminação · **Dificuldade:** Fácil · **Região:** Floresta de Horunka · **NPC:** morador da vila (crie na hora, ou use o Eremita da Floresta se ele já tiver aparecido)

**Requer:** — · **Desbloqueia:** `horunka_02_marca_no_tronco`, `horunka_03_madeira_que_nao_serve`, `horunka_06_vespa_rainha`

**Gancho**

A vila de Horunka é pequena — dez construções, todo mundo se conhece de
vista. Quando o grupo chega, alguém já está esperando visitante novo com
um pedido: nos últimos dias, criaturas pequenas (Toca na Raiz — variante
territorial e fraca) andaram se aproximando demais das casas do lado
leste. Não é uma ameaça grande, mas está deixando gente nervosa numa vila
que vive de se sentir segura.

**Leia em voz alta**

> Horunka parece pequena o bastante pra caber inteira numa mesma preocupação.
> A lenha está empilhada do lado de fora, as ferramentas ficam onde qualquer
> um alcança, e mesmo assim ninguém larga nada sem olhar duas vezes para a
> borda leste da vila. O problema não é grande. É pior: é próximo.

**O que está em jogo**

- Se o grupo ignorar, a vila passa a tratar forasteiro como enfeite, não ajuda.
- Se resolver mal, protege a vila hoje mas estraga vegetação e confiança.
- A cena mostra que nem toda quest boa começa com monstro forte; às vezes
  começa com comunidade perdendo rotina.

**Estrutura em beats**

1. Chegada em Horunka — a pousada, a loja de ferramentas, o clima de vila
   que confia em quem já conhece. O grupo é claramente forasteiro.
2. O pedido: eliminar 2-3 criaturas nas bordas leste da vila, sem
   destruir a vegetação que a vila usa pra coleta.
3. Rastreamento — seguir pegadas/sinais até o ninho territorial.
4. Combate — as criaturas defendem território, não atacam à distância;
   se o grupo for barulhento demais, um segundo grupo aparece.
5. Ao voltar, alguém nota que o grupo passou perto de uma árvore com uma
   marca entalhada estranha — gancho natural pra `horunka_02`.

**Testes sugeridos**

- d20+Destreza — rastrear os sinais sem perder tempo
- d20+Força ou Reflexo — o combate em si (ameaça fraca, golpes 1-2)
- d20+Inteligência — notar a marca no tronco ao voltar (só quem prestar atenção vê)

**NPCs na cena**

- **Morador da vila / dono da pousada / caçador local** — quer a borda leste
  limpa e a vegetação intacta.
- **Responde:** onde viram as criaturas, quem quase foi pego, qual lado da
  vila anda evitando sair à noite.
- **Recusa:** chamar isso de “pânico”; para ele é rotina começando a falhar.
- **Se pressionado:** admite que Horunka já não dorme tão tranquila quanto
  parecia por fora.

**Encontro**

2-3 criaturas territoriais fracas (golpes 1-2, sem ataque à distância).
Se o teste de rastreamento falhar, um grupo extra aparece por barulho.

**Complicações úteis**

- O grupo resolve, mas quebra vegetação importante para a vila.
- O ninho estava mais perto das casas do que parecia, e alguém vê tudo.
- As criaturas fogem em vez de morrer, arrastando o problema para a mata.
- A marca no tronco é vista cedo demais e rouba atenção do pedido imediato.

**Recompensas**

Col 30 + Pelagem Comum (garantido). Se o teste de Conhecimento no beat 5
for 10+, o grupo já sai com a localização exata da marca — pula direto
pro meio de `horunka_02` na próxima sessão.

Em sucesso total, o primeiro comentário sobre o grupo em Horunka deixa de ser
“forasteiros” e vira “os que resolveram sem fazer bagunça”.

**Gancho pra próxima quest**

A marca entalhada não é decoração — é entalhe recente, feito de propósito.

**Gancho visual / de transmissão**

- A vila pequena demais para esconder nervosismo.
- O contraste entre “ameaça fraca” e “impacto real na rotina”.
- A marca no tronco surgindo como detalhe estranho depois da luta.

---

### `horunka_02_marca_no_tronco` — A Marca no Tronco

**Tipo:** Investigação · **Dificuldade:** Médio · **Região:** Floresta de Horunka

**Requer:** `horunka_01_primeira_cacada` · **Desbloqueia:** `horunka_04_o_eremita_sabe`

**Gancho**

A marca do tronco (ponto "Marca no Tronco" no mapa) é um símbolo simples —
um corte em ângulo, uma linha curta abaixo. Não parece escrita, mas também
não parece acidente. E quanto mais o grupo procura pela área, mais marcas
parecidas aparecem, sempre em troncos altos, sempre voltadas pra um lado
específico.

**Leia em voz alta**

> A primeira marca parece pouco. A segunda tira isso de vocês. A terceira já
> obriga alguém a admitir que existe intenção ali. Não é arte, não é aviso
> para monstro e não é decoração. É trabalho deixado por alguém que esperava
> ser entendido por quem viesse depois.

**O que está em jogo**

- Se o grupo lê certo o padrão, a floresta ganha profundidade humana.
- Se lê errado, perde tempo e confiança no próprio instinto.
- A cena é boa porque transforma detalhe visual em direção concreta.

**Estrutura em beats**

1. Examinar a primeira marca de perto — o entalhe é preciso, feito com
   ferramenta boa, não com garra ou dente.
2. Procurar mais marcas na região (2-3 adicionais, espalhadas num raio
   curto) — cada uma aponta um pouco mais fundo na floresta.
3. Perceber o padrão: todas as marcas, juntas, formam uma direção — não
   um mapa completo, só um rumo.
4. Seguir o rumo até onde as marcas param de aparecer, perto de uma área
   isolada da floresta — território que só um morador antigo frequentaria.

**Testes sugeridos**

- d20+Inteligência — examinar o entalhe e perceber que é intencional, não natural
- d20+Destreza — encontrar as marcas adicionais sem se perder na mata fechada
- d20+Sabedoria — juntar as marcas num padrão de direção coerente

**Complicações úteis**

- O grupo encontra marcas demais e começa a ver padrão onde não existe.
- Uma trilha de animal cruza o mesmo rumo e confunde leitura.
- A descoberta chama atenção de alguém da vila antes da hora.
- O padrão leva a um lugar certo por um motivo parcialmente errado.

**Complicação**

Se qualquer teste sair 6-, a trilha se perde e o grupo precisa voltar
outro dia (sem penalidade além do tempo) — ou pedir ajuda de quem já
morou na floresta a vida toda.

**Recompensas**

Direção clara até a área isolada — não entrega quem fez as marcas, só
onde procurar por respostas. Isso é o que abre `horunka_04`.

**Gancho visual / de transmissão**

- A terceira marca confirmando que não é coincidência.
- O grupo debatendo direção no meio da mata.
- A sensação de que a floresta foi usada por gente, não só habitada por bicho.

**Gancho pra próxima quest**

A área isolada tem uma cabana. Alguém mora ali, sozinho, há muito tempo.

---

### `horunka_03_madeira_que_nao_serve` — Madeira que Não Serve

**Tipo:** Coleta · **Dificuldade:** Fácil · **Região:** Floresta de Horunka · **NPC:** Lenhador da vila (crie na hora)

**Requer:** `horunka_01_primeira_cacada` · **Desbloqueia:** —

**Gancho**

O Lenhador de Horunka recebeu um pedido de um Ferreiro de Tolbana:
Madeira Nodosa, a variante mais densa que só aparece ocasionalmente entre
os troncos comuns. Ele mesmo não tem tempo de ir atrás — a vila inteira
depende dele pra madeira do dia a dia.

**Leia em voz alta**

> O Lenhador não trata madeira como recurso genérico. Ele passa a mão no veio
> de um tronco cortado e fala de peso, som e fibra como quem descreve caráter.
> Quando cita a Madeira Nodosa, a diferença parece invisível até ele colocar
> um pedaço comum e um bom lado a lado sobre a mesa.

**O que está em jogo**

- A quest é simples, mas ajuda a vender ofício e economia como parte do mundo.
- Se o grupo errar, perde tempo e aprende a diferença entre “achar madeira” e
  “trazer a madeira certa”.
- É uma boa pausa de ritmo entre mistério e combate.

**Estrutura em beats**

1. O Lenhador explica a diferença entre madeira comum e Madeira Nodosa
   (veios mais grossos, mais escura, mais pesada) — sem isso, é fácil
   confundir.
2. Busca na floresta, testando tronco por tronco.
3. Ao achar a primeira unidade, decisão: continuar procurando a segunda
   ou voltar já com uma (menos Col, mas menos risco/tempo).

**Testes sugeridos**

- d20+Inteligência — reconhecer Madeira Nodosa de verdade em vez de confundir com madeira comum
- d20+Destreza — cortar sem rachar o veio (madeira rachada vale menos)

**NPCs na cena**

- **Lenhador da vila** — quer a Madeira Nodosa certa, não qualquer madeira
  boa.
- **Responde:** como reconhecer o veio certo, o que o Ferreiro de Tolbana
  vai fazer com ela, por que não foi ele mesmo buscar.
- **Recusa:** aceitar madeira comum disfarçada de nodosa, mesmo sob pressão
  de prazo.
- **Se pressionado:** admite que a vila inteira depende dele pra madeira do
  dia a dia, e sair pra floresta por conta própria significa deixar
  encomendas atrasando.

**Complicações úteis**

- O grupo acha o tronco certo, mas numa área ruim para corte rápido.
- Chuva leve muda o som do tronco e confunde a leitura.
- Um bom pedaço sai pesado demais para levar junto com tudo.
- O Lenhador reconhece, pela rachadura, exatamente qual erro foi cometido.

**Recompensas**

Col 40 + reputação com o Lenhador — da próxima vez que o grupo comprar
madeira ou ferramentas na vila, o preço é melhor. Quest simples,
propositalmente mais leve que as outras da cadeia — boa pra intercalar.

**Gancho visual / de transmissão**

- A comparação física entre madeira comum e Madeira Nodosa.
- O momento do corte certo ou do veio rachando.
- O Lenhador avaliando a peça em silêncio antes de dar a resposta.

---

### `horunka_04_o_eremita_sabe` — O Eremita Sabe de Algo

**Tipo:** Diálogo/Investigação · **Dificuldade:** Médio · **Região:** Floresta de Horunka · **NPC:** Eremita da Floresta (`npcs/eremita_da_floresta.md`)

**Requer:** `horunka_02_marca_no_tronco` · **Desbloqueia:** `horunka_08_o_que_a_floresta_escondeu`

**Gancho**

A cabana no fim da trilha é simples — galhos amarrados, fumaça fina. Um
homem de meia-idade vive ali sozinho desde o segundo dia do jogo. Ele não
é hostil, mas também não abre a porta (literal ou figurativamente) pra
qualquer um que apareça pedindo respostas.

**Leia em voz alta**

> A cabana aparece tarde demais para parecer acidente. Pequena, seca, bem
> montada demais para improviso. Antes de qualquer voz de dentro, já dá para
> sentir que quem vive ali escolheu distância como rotina. O grupo chegou até
> alguém que não se perdeu na floresta. Se retirou dela só o bastante para
> continuar vendo tudo.

**O que está em jogo**

- Se o grupo falar certo, ganha acesso a uma camada mais íntima de Horunka.
- Se falar errado, a floresta continua aberta, mas a confiança fecha.
- A cena precisa fazer o Eremita parecer pessoa inteira, não “guardião de pista”.

**Estrutura em beats**

1. Primeiro contato — o Eremita observa o grupo antes de dizer qualquer
   coisa. Ele já viu jogadores passarem por ali antes; a maioria nunca
   volta.
2. Ele pergunta, sem rodeios, por que o grupo está atrás da marca — a
   resposta importa mais que qualquer coisa que digam depois.
3. Se convencido, ele explica: as marcas são um código informal que os
   caçadores da vila usavam antes do dia 1, indicando direção e distância
   até esconderijos de suprimento de emergência. Ele mesmo era caçador.
4. Ele ensina o "básico" do código — o suficiente pra decifrar as marcas
   já vistas, não o sistema inteiro.

**Testes sugeridos**

- d20+Sabedoria — convencer o Eremita de que o interesse é genuíno, não curiosidade vazia
- d20+Inteligência — absorver o código rápido o bastante pra aplicar nas marcas já vistas

**NPCs na cena**

- **Eremita da Floresta** — quer motivo melhor do que curiosidade.
- **Responde:** sobre trilha, presa, ritmo da mata, e depois sobre parte do código.
- **Recusa:** perguntas feitas rápido demais ou com fome de segredo.
- **Se pressionado:** encerra a fala antes de virar briga; isso dói mais.

**Complicação**

Numa falha (6-) no primeiro teste, ele não expulsa o grupo — só fecha a
conversa e sugere "voltem quando tiverem motivo melhor". Isso não bloqueia
a quest pra sempre; é um convite a fazer algo por ele ou pela vila antes
de voltar (o mestre pode usar `horunka_06`/`horunka_07` como essa prova).

**Recompensas**

Recompensa de informação, não material: o código do "Código da Floresta"
— peça central do mistério, sem a qual `horunka_08` não avança (ver
`docs/interacoes_e_segredos.md`). Se o mestre quiser um extra tangível,
o Eremita também aponta um ponto de coleta de Cogumelos Selvagens que só
ele conhece (equivalente a Col 60 em tempo economizado).

**Gancho visual / de transmissão**

- A cabana simples no fim da trilha certa.
- O Eremita avaliando o grupo em silêncio antes de responder.
- A primeira explicação do código transformando marcas em linguagem.

**Gancho pra próxima quest**

Com o código em mãos, as marcas já vistas apontam pra um lugar específico
— um esconderijo, não mais um símbolo solto.

---

### `horunka_05_ovule_perdido` — Ovule Perdido

**Tipo:** Caça · **Dificuldade:** Difícil · **Região:** Floresta de Horunka

**Requer:** — · **Desbloqueia:** —

**Gancho**

Corre um boato entre caçadores visitantes: a variante rara de Little
Nepenthes — a que tem uma flor vermelha brotando do topo — foi avistada de
novo, mais fundo na floresta do que o normal. Quem já enfrentou uma Little
Nepenthes comum sabe que essa versão é mais perigosa e mais valiosa.

**Leia em voz alta**

> A flor vermelha no topo da Nepenthes é bonita de um jeito ofensivo. O grupo
> a vê antes de ver o resto da planta inteira, porque o vermelho não pertence
> àquela paleta de verde úmido. Quem sabe o que está olhando entende na hora
> que aquilo vale muito. Quem sabe ainda mais entende também que vale muito
> porque poucos conseguem tirar dali intacto.

**O que está em jogo**

- Sucesso rende recurso raro e reputação de caça séria.
- Falha custa equipamento, tempo e talvez a peça mais valiosa da cena.
- É uma quest ótima para mostrar perícia em vez de força bruta.

**Estrutura em beats**

1. Rastrear rumores/pegadas até a área onde a variante foi vista.
2. Encontro — a variante ataca com o mesmo spray corrosivo da versão
   comum, mas com alcance/frequência maior.
3. Decisão tática: atacar rápido pra minimizar exposição ao spray, ou
   provocar o spray de propósito e desviar primeiro pra depois avançar
   com segurança.
4. Extração cuidadosa do Ovule — golpe errado destrói o item.

**Testes sugeridos**

- d20+Inteligência — rastrear a variante sem alarmar outros monstros da área
- d20+Destreza — desviar do spray corrosivo (falha danifica equipamento)
- d20+Destreza — extrair o Ovule sem esmagar (falha = item danificado, ainda vendável por menos)

**Complicações úteis**

- O grupo vence, mas alguém sai com equipamento corroído de verdade.
- A variante recua para terreno ruim antes de usar o spray.
- Um caçador visitante aparece tarde demais e quer parte do mérito.
- O Ovule sai danificado, mas ainda “bonito o suficiente” para tentar vender como íntegro.

**Encontro**

1 Little Nepenthes variante rara — comum na estrutura de ataque, mas
tratar como ameaça "forte" pelo alcance extra do spray.

**Recompensas**

Col 150 + Little Nepenthes's Ovule intacto (sucesso total) ou danificado/
qualidade menor (parcial) — raro, usado por Alquimista/Joalheiro. Boa
quest de caça pura pra intercalar entre as mais densas da cadeia.

**Gancho visual / de transmissão**

- A flor vermelha aparecendo no verde da mata.
- O spray abrindo no ar antes do desvio.
- A extração cuidadosa do Ovule como se fosse cirurgia.

---

### `horunka_06_vespa_rainha` — Vespa Rainha

**Tipo:** Combate · **Dificuldade:** Difícil · **Região:** Floresta de Horunka

**Requer:** `horunka_01_primeira_cacada` · **Desbloqueia:** `horunka_07_contrato_do_domador`

**Gancho**

Um zumbido baixo, constante demais, vem de uma parte da floresta que
ninguém da vila costuma visitar. O ninho de Stabbing Wasp que o grupo já
soube existir (via `horunka_01`) cresceu — muito além do que qualquer
morador de Horunka já catalogou.

**Leia em voz alta**

> Antes de o grupo ver o ninho, o corpo já entende que alguma coisa está errada.
> O zumbido é constante demais, cheio demais, vivo demais. Quando o ninho
> aparece entre os troncos, ele não parece só grande. Parece uma decisão ruim
> que ficou sem resposta por tempo demais.

**O que está em jogo**

- Se o grupo resolver isso bem, protege Horunka de uma ameaça que cresce.
- Se resolver mal, a consequência volta para a vila à noite.
- A cena existe para misturar combate, urgência e responsabilidade.

**Estrutura em beats**

1. Aproximação — o zumbido aumenta conforme o grupo se aproxima; dá pra
   perceber o tamanho do problema antes de ver o ninho.
2. Decisão: atacar o ninho direto (mais rápido, mais arriscado) ou
   afastar o enxame aos poucos (mais lento, mais seguro).
3. Combate — múltiplas vespas atacando em sequência, não uma de cada vez.
4. Consequência — se o combate for barulhento/longo demais, o enxame
   dispersa em vez de morrer, e parte dele voa em direção à vila.

**Testes sugeridos**

- d20+Inteligência — avaliar o tamanho real do ninho antes de decidir a abordagem
- d20+Força — o combate propriamente dito (múltiplas vespas, ameaça comum cada)
- d20+Destreza — conter a dispersão do enxame se o combate demorar demais

**Complicações úteis**

- O ninho quebra de um jeito pior do que o grupo queria.
- O enxame recua e tenta contornar o grupo em vez de atravessá-lo.
- Um personagem precisa escolher entre golpear o ninho ou proteger alguém.
- O barulho da luta entrega o grupo para a floresta inteira.

**Complicação**

Numa falha no teste de contenção, o enxame disperso ataca a vila à noite
— o mestre pode transformar isso numa cena curta de defesa comunitária,
ou só numa consequência narrada (feridos leves, moral abalada).

**Recompensas**

Col 180 + Glândula de Veneno (material de caça, Incomum). Sucesso total
sem complicação também rende reconhecimento real da vila — abre bem
`horunka_07`.

**Gancho visual / de transmissão**

- O ninho aparecendo tarde demais entre os troncos.
- O enxame mudando de direção como se pensasse junto.
- O medo de ver parte dele voando rumo à vila.

**Gancho pra próxima quest**

Com a área mais segura, um Domador da vila pede um favor.

---

### `horunka_07_contrato_do_domador` — Contrato do Domador

**Tipo:** Doma · **Dificuldade:** Médio · **Região:** Floresta de Horunka · **NPC:** Domador da vila (crie na hora)

**Requer:** `horunka_06_vespa_rainha` · **Desbloqueia:** —

**Gancho**

Com a área mais calma, um Domador da vila quer aproveitar a janela de
segurança pra tentar o que vem tentando há semanas: amansar um Frenzy
Boar. Ele já tentou sozinho sem sucesso — precisa de gente que segure o
perímetro enquanto ele trabalha de perto.

**Leia em voz alta**

> O Domador de Horunka não fala do javali como prêmio. Fala como quem está
> tentando acertar o ritmo de uma criatura que ainda não decidiu se o mundo
> permite confiança. Quando aponta as ervas e explica a distância certa, o
> grupo percebe rápido que essa cena pode virar parceria ou erro em segundos.

**O que está em jogo**

- Se der certo, a vila ganha mais do que uma montaria: ganha confiança no método.
- Se der errado, o grupo aprende que doma exige controle de clima, não só coragem.
- A cena ajuda a fazer Domador parecer protagonista sem virar “captura automática”.

**Estrutura em beats**

1. O Domador explica o método: paciência, não força — oferecer ervas
   comuns repetidamente até o animal parar de fugir (ver
   `docs/economia_profissoes.md`).
2. O grupo mantém distância seguindo o javali sem assustá-lo, enquanto o
   Domador se aproxima aos poucos.
3. Momento de tensão — em algum ponto o javali percebe o cerco e decide
   entre aceitar a comida ou atacar por se sentir encurralado.
4. Resultado — sucesso rende um aliado; falha pode render um combate
   curto e desnecessário, ou só uma tentativa fracassada sem dano real.

**Testes sugeridos**

- d20+Destreza — manter distância segura sem perder o javali de vista
- d20+Destreza — a aproximação final do Domador (o grupo pode ajudar com um teste de apoio)
- d20+Sabedoria — manter a calma do grupo se o javali reagir mal (evita escalar pra combate desnecessário)

**NPCs na cena**

- **Domador da vila** — quer acertar, mas está cansado de errar quase lá.
- **Responde:** por que insiste nesse javali, o que já tentou, o que não vai fazer.
- **Recusa:** transformar a cena em “cercar e bater até cansar”.
- **Se pressionado:** deixa escapar frustração antes de recuperar a postura.

**Recompensas**

Col 80 pelo trabalho, independente do resultado. Se sucesso total: o
javali se torna aliado/montaria pequena da vila (ou de um jogador, à
escolha do mestre) e o Domador fica em dívida com o grupo. Se parcial: o
javali aceita comida mas ainda não confia — pode virar uma quest de
retorno mais pra frente. Se falha: combate curto contra um Frenzy Boar
assustado (ameaça fraca) e só o Col base.

**Gancho visual / de transmissão**

- O Domador estendendo a mão no limite certo da distância.
- O momento em que o javali decide entre avançar ou aceitar.
- A tensão do grupo tentando ajudar sem atrapalhar.

---

### `horunka_08_o_que_a_floresta_escondeu` — O Que a Floresta Escondeu

**Tipo:** Resolução/Puzzle · **Dificuldade:** Difícil · **Região:** Floresta de Horunka

**Requer:** `horunka_04_o_eremita_sabe` · **Desbloqueia:** —

**Gancho**

Com o código do Eremita em mãos, as marcas já vistas na floresta deixam
de ser símbolos soltos e viram um caminho real. Elas apontam pra um
esconderijo específico — e é do próprio Eremita, abandonado desde que ele
parou de caçar.

**Leia em voz alta**

> Depois que o código faz sentido, a floresta muda de idioma. As marcas deixam
> de parecer detalhe e começam a parecer frase. O esconderijo, quando enfim
> aparece, não tem nada de místico. E justamente por isso pesa mais: alguém
> viveu, trabalhou, guardou coisas ali e escolheu nunca mais voltar.

**O que está em jogo**

- Resolver isso fecha Horunka com peso humano, não só com loot.
- O achado pode ser devolvido, guardado ou exposto, e nenhuma escolha é neutra.
- A cena existe para encerrar cadeia com memória, não só com prêmio.

**Estrutura em beats**

1. Decodificar as marcas restantes usando o que o Eremita ensinou —
   confirma a localização exata do esconderijo.
2. Chegada ao esconderijo — um compartimento simples, escondido sob
   raízes ou dentro de um tronco oco, quase intacto depois de tanto tempo.
3. Dentro: um diário de caçador (explica, sem melodrama, por que o
   Eremita parou — motivo pessoal, não conspiração) e um kit de caça
   Incomum bem conservado, um dos primeiros feitos na vila.
4. Decisão do grupo: devolver o achado ao Eremita, ficar com ele, ou
   contar pra vila — cada escolha muda a relação do grupo com Horunka
   dali em diante.

**Testes sugeridos**

- d20+Inteligência — decodificar as marcas restantes sem erro
- d20+Força ou Técnica — abrir o esconderijo sem danificar o conteúdo
- (Opcional) d20+Sabedoria — decidir como agir com o que foi encontrado, se o grupo quiser forçar uma cena de peso

**Complicações úteis**

- O grupo chega certo, mas percebe tarde que alguém mais esteve ali antes.
- O esconderijo abre fácil demais e isso assusta mais do que deveria.
- O diário explica o suficiente para doer, mas não para absolver ninguém.
- A discussão sobre devolver ou guardar divide o grupo de um jeito produtivo.

**Complicação**

Numa falha no teste de decodificação, o grupo encontra o esconderijo
errado primeiro — vazio, ou pertencente a outro caçador antigo — e precisa
tentar de novo com uma pista a menos de erro.

**Recompensas**

Col 150 (o que sobrou no esconderijo) + o diário do Eremita (peça de lore
pessoal) + um kit de caça Incomum (item de sabor, não arma poderosa — o
valor é narrativo). Devolver o achado ao Eremita rende a confiança dele
de forma permanente; guardar ou expor tem consequências sociais que o
mestre define.

**Gancho visual / de transmissão**

- As marcas virando linguagem de verdade.
- O esconderijo simples demais para ser lenda.
- O diário abrindo no trecho certo para mudar o tom da cena.

**Fecha a cadeia B.** Não há gancho automático pro mistério do andar 2
aqui — é uma resolução pessoal e local, por escolha de design (ver
`docs/interacoes_e_segredos.md`).

---

## Cadeia C — Águas de Sylvaine

A cadeia sobe de intensidade de propósito: começa em observação pura,
passa por um encontro de sobrevivência (não de vitória), e só depois monta
o caminho real pra lidar com o Lacustre Vagador. `lago_02`/`lago_06`
correm em paralelo à linha de doma e entregam outro fragmento do mistério
do andar 2 — mesmo princípio de pista parcial que a cadeia B usa.

### `lago_01_peixe_estranho` — Peixe Estranho

**Tipo:** Investigação · **Dificuldade:** Fácil · **Região:** Lago Sylvaine

**Requer:** — · **Desbloqueia:** `lago_02_o_redemoinho`

**Gancho**

Pescadores da Vila de Brenmoor comentam, meio de brincadeira, que os
peixes andam "burros" perto da Ilha de Pemberton — nadando em círculo,
alguns até encalhando na margem sem predador nenhum por perto. Ninguém
acha que é sério. Ninguém foi verificar de perto.

**Leia em voz alta**

> O primeiro peixe encalhado parece acaso. O segundo estraga isso. O terceiro,
> debatendo-se numa margem calma demais para justificar pânico, já faz o lago
> parecer doente de um jeito que ninguém na vila sabe explicar sem rir antes.

**O que está em jogo**

- A cena começa pequena, mas é a primeira rachadura visível no comportamento do lago.
- Se o grupo prestar atenção agora, entra no resto da cadeia com vantagem real.
- É uma quest ótima para premiar paciência e curiosidade.

**Estrutura em beats**

1. Conversa com pescadores (ou o Pescador Veterano, `npcs/pescador_veterano.md`,
   se já apresentado) — eles descrevem o comportamento com mais humor que
   preocupação.
2. Observação direta na margem perto da ilha — o padrão fica claro se o
   grupo tiver paciência.
3. Um peixe encalhado ainda vivo pode ser examinado de perto sem entrar
   na água.

**Testes sugeridos**

- d20+Sabedoria — ter paciência suficiente pra observar sem se distrair
- d20+Inteligência — identificar que o padrão de nado aponta pra uma
  direção específica no lago (rumo ao redemoinho, sem nomear ainda)

**NPCs na cena**

- **Pescadores de Brenmoor** — tratam o estranho como piada até alguém olhar direito.
- **Responde:** onde viram mais peixe encalhando, o que mudou nos últimos dias.
- **Recusa:** transformar medo em teoria grande cedo demais.
- **Se pressionados:** admitem que pararam de pescar em um trecho específico.

**Recompensas**

Col 25 + Peixe (2 un.). Sucesso total no teste de Conhecimento já aponta
a direção certa, economizando um beat inteiro em `lago_02`.

**Gancho visual / de transmissão**

- Peixes girando onde não deviam.
- A margem ficando “errada” sem precisar de monstro.
- A primeira vez que o grupo percebe uma direção no caos.

**Gancho pra próxima quest**

A direção aponta pra um ponto específico do lago — água girando onde não
deveria.

---

### `lago_02_o_redemoinho` — O Redemoinho

**Tipo:** Investigação · **Dificuldade:** Médio · **Região:** Lago Sylvaine

**Requer:** `lago_01_peixe_estranho` · **Desbloqueia:** `lago_06_barqueiro_contra_corrente`

**Gancho**

O redemoinho não é grande, mas também não devia existir ali — a correnteza
do Lago Sylvaine é fraca demais pra formar algo assim sozinha. De longe,
parece só um ponto estranho na água. De perto, alguma coisa nele parece
errada de um jeito difícil de descrever.

**Leia em voz alta**

> De longe, o redemoinho quase parece detalhe. De perto, ele incomoda como
> frase dita com a ordem errada das palavras. A água gira, mas não como água de
> lago fechado devia girar. Quem encara por tempo demais começa a sentir que a
> margem está certa e o centro é que está olhando de volta.

**O que está em jogo**

- Esta é a hora em que o lago deixa de ser bonito e passa a ser suspeito.
- Entrar na água pode trazer prova, mas cobra risco real.
- Observar bem aqui fortalece o peso de `lago_06`.

**Estrutura em beats**

1. Aproximação segura pela margem — dá pra observar de longe sem risco.
2. Decisão: investigar de perto (na água) ou só observar à distância com
   mais tempo (mais seguro, menos conclusivo).
3. Se entrar na água, o redemoinho puxa de verdade — não é decoração.
4. De perto, o padrão da água não bate com nenhuma correnteza natural —
   informação que só faz sentido cruzada com o que o Barqueiro sabe
   (`lago_06`).

**Testes sugeridos**

- d20+Força — nadar contra a correnteza sem ser puxado pro centro
- d20+Inteligência — perceber que o comportamento da água é artificial, não natural

**Complicações úteis**

- O grupo perde um item pequeno e isso vira prova física de que o lago “puxa”.
- Alguém vê algo no centro e não consegue ter certeza se viu mesmo.
- Um personagem sai da água mais abalado do que ferido.
- A margem parece segura até parar de parecer de repente.

**Complicação**

Numa falha no teste de Corpo, o grupo é puxado e precisa nadar de volta —
sem dano grave, mas perde equipamento solto (item pequeno, à escolha do
jogador) se o mestre quiser aumentar a tensão.

**Recompensas**

Col 60 + pista sólida sobre a natureza do redemoinho (fragmento do
mistério do andar 2 — ver `docs/interacoes_e_segredos.md`, "O Que o
Redemoinho Esconde"). Liga direto a `lago_06`.

**Gancho visual / de transmissão**

- A água girando sem merecer confiança.
- O puxão súbito em algo que parecia controlado.
- O grupo entendendo que o lago tem comportamento, não só cenário.

**Gancho pra próxima quest**

Só quem conhece o lago de verdade pode confirmar o que o grupo suspeita.

---

### `lago_03_garras_no_barro` — Garras no Barro

**Tipo:** Caça (sobrevivência) · **Dificuldade:** Difícil · **Região:** Lago Sylvaine

**Requer:** — · **Desbloqueia:** `lago_04_isca_pro_vagador`

**Gancho**

O primeiro contato com o Lacustre Vagador não é planejado — é um susto.
Marcas de garra enormes na lama da margem, fundas demais pra qualquer
coisa que a vila já catalogou. E então a água se move, perto demais, na
direção errada.

**Leia em voz alta**

> As marcas na lama não parecem pegadas. Parecem argumento. Fundas, recentes e
> grandes o bastante para fazer a água ao lado parecer esconder mais volume do
> que um lago deveria ter. Quando a superfície mexe perto delas, o grupo não
> ganha uma confirmação. Ganha um aviso.

**O que está em jogo**

- Esta quest precisa ensinar que recuar também é ação inteligente.
- Sobreviver aqui vale mais do que “ganhar combate”.
- É o primeiro grande susto físico da cadeia do lago.

**Estrutura em beats**

1. Descoberta das marcas — grandes, recentes, um padrão de arrasto até a
   água.
2. A criatura aparece — não ataca de imediato, só observa, o que é mais
   assustador que um ataque direto.
3. Decisão real: recuar organizadamente (objetivo da quest) ou arriscar
   um primeiro golpe (não recomendado — é ameaça "forte" e o grupo não
   tem isca nem preparo ainda).
4. Recuo — a criatura pode perseguir por um trecho curto antes de voltar
   pra água.

**Testes sugeridos**

- d20+Inteligência — reconhecer que enfrentar agora é má ideia (informa a decisão do grupo)
- d20+Destreza — organizar o recuo sem deixar ninguém pra trás
- d20+Força — se alguém for pego durante a perseguição, resistir/escapar do primeiro golpe

**Encontro**

1 Lacustre Vagador (ameaça forte, golpes 5-7, ver `monstros/lacustre_vagador.md`).
Esta quest é desenhada pra NÃO ser vencida em combate direto — é
sobrevivência e informação, preparando a abordagem mais inteligente de
`lago_04`/`lago_05`.

**Complicação**

Numa falha no teste de Reflexo, alguém fica isolado por um momento — não
é morte automática, é uma cena de tensão real (o grupo precisa decidir
voltar por essa pessoa ou confiar que ela vai se safar sozinha).

**Complicações úteis**

- Um personagem larga algo importante para correr mais rápido.
- A criatura não persegue até o fim, só o bastante para parecer escolha.
- O grupo sai inteiro, mas com versões diferentes do que viu.
- Alguém da vila não acredita no relato até ver o estado da margem.

**Recompensas**

Col 100 (o valor não vem de matar, vem de sobreviver e trazer informação
de qualidade) + respeito real da Vila de Brenmoor — ninguém mais achou
esse encontro engraçado depois disso.

**Gancho visual / de transmissão**

- As garras abrindo a lama antes de qualquer corpo aparecer.
- A água mexendo na direção errada.
- O recuo organizado parecendo mais heroico do que um ataque.

**Gancho pra próxima quest**

Enfrentar de novo, sem plano, é burrice. Precisa de uma abordagem melhor.

---

### `lago_04_isca_pro_vagador` — Isca pro Vagador

**Tipo:** Crafting/Coleta · **Dificuldade:** Médio · **Região:** Lago Sylvaine

**Requer:** `lago_03_garras_no_barro` · **Desbloqueia:** `lago_05_doma_no_lago`

**Gancho**

Depois do susto, alguém do grupo (ou o Pescador Veterano) sugere o óbvio:
parar de improvisar. A receita de Isca para Lacustre Vagador existe por um
motivo — ela transforma um encontro de sobrevivência num de controle.

**Leia em voz alta**

> Depois de ver o Vagador de perto, improviso começa a soar como outro nome
> para orgulho. A isca não nasce de bravura; nasce de gente que quase morreu
> antes e teve humildade suficiente para aprender. O lago exige isso.

**O que está em jogo**

- Esta quest muda o grupo de reação para preparo.
- Se a isca ficar boa, a próxima cena vira chance real em vez de aposta cega.
- A preparação aqui ajuda a vender ofício, observação e método.

**Estrutura em beats**

1. Conseguir Ferrão de Vespa — comprado de um Caçador ou extraído de um
   Stabbing Wasp abatido (ver `docs/economia_profissoes.md`).
2. Preparar a isca com tempo de observação no lago — não é instantâneo,
   exige paciência real.
3. Testar a isca numa área segura antes de levar pro encontro real.

**Testes sugeridos**

- d20+Inteligência — preparar a isca corretamente (proporção certa, tempo certo)
- d20+Sabedoria — manter a paciência durante o tempo de observação exigido pela receita

**NPCs na cena**

- **Pescador Veterano** — sabe mais do que parece, mas respeita método acima de pressa.
- **Responde:** o que já viu funcionar, por que o ferrão importa, como testar sem se expor.
- **Recusa:** chamar de “superstição” algo que ele viu salvar gente.
- **Se pressionado:** entrega a receita, mas deixa claro que receita sem calma mata.

**Recompensas**

Col 20 de custo (Ferrão de Vespa, se comprado em vez de caçado) e a Isca
para Lacustre Vagador pronta (sucesso total = qualidade máxima, vantagem
no teste de `lago_05`; parcial = isca funcional mas fraca, sem vantagem).

**Gancho visual / de transmissão**

- Ingredientes simples tratados como coisa séria.
- O teste da isca funcionando cedo demais ou tarde demais.
- O grupo sentindo que finalmente tem um plano.

**Gancho pra próxima quest**

Com a isca pronta, é hora de tentar de verdade — dessa vez em termos do
grupo, não da criatura.

---

### `lago_05_doma_no_lago` — Doma no Lago

**Tipo:** Doma · **Dificuldade:** Muito Difícil · **Região:** Lago Sylvaine

**Requer:** `lago_04_isca_pro_vagador` · **Desbloqueia:** —

**Gancho**

Com a isca pronta, o grupo volta ao mesmo trecho de margem onde tudo
começou. Dessa vez não é surpresa — é um plano, mas ainda assim contra
uma criatura que pode facilmente vencer um combate direto.

**Leia em voz alta**

> O mesmo trecho de margem parece menor quando o grupo volta preparado. Não
> porque o lago encolheu, mas porque agora a tensão tem forma. A isca está na
> mão certa, a água está quieta demais e todo mundo sabe que quietude aqui é
> só a parte do acordo que vem antes do risco.

**O que está em jogo**

- Esta é a cena que paga tudo o que a cadeia vinha preparando.
- Se der certo, vira momento de lenda do grupo.
- Se der errado, ainda assim precisa render consequência forte, não frustração seca.

**Estrutura em beats**

1. Posicionamento — a isca precisa ser colocada num ponto que atraia o
   Lacustre Vagador sem expor o grupo demais.
2. A criatura aparece, atraída pela isca — momento de tensão real, ainda
   ameaçadora mesmo sem atacar de imediato.
3. Tentativa de doma — aproximação lenta, controlada, usando a isca como
   ponte de confiança.
4. Resultado: aliado (sucesso total), retirada tensa mas sem combate
   (parcial), ou combate real se tudo der errado.

**Testes sugeridos**

- d20+Destreza — posicionar a isca sem se expor
- d20+Destreza — a aproximação de doma em si (bônus se a isca foi qualidade máxima em `lago_04`)
- d20+Sabedoria — manter a calma do grupo durante a aproximação (uma reação de pânico assusta a criatura)

**Complicações úteis**

- O Vagador aceita a isca, mas não o grupo inteiro por perto.
- Um personagem faz o movimento certo tarde demais.
- A água sobe no ponto errado e muda todo o posicionamento.
- O sucesso vem, mas com marca clara de que aquilo ainda é um animal perigoso.

**Encontro (se der errado)**

1 Lacustre Vagador (ameaça forte, golpes 5-7) — mas agora o grupo já tem
informação e preparo, ao contrário de `lago_03`.

**Recompensas**

Sucesso total: Lacustre Vagador como aliado de terreno aquático (item
único, não repetível). Parcial: a criatura foge mas fica visivelmente
menos hostil em encontros futuros no lago (efeito permanente leve). Falha:
combate real — Col 200 + Garras Completas de Lacustre Vagador (material
de caça) se o grupo vencer o combate.

**Gancho visual / de transmissão**

- O primeiro surgimento controlado do Vagador.
- O silêncio do grupo inteiro esperando a reação.
- O instante em que a criatura decide não atacar.

---

### `lago_06_barqueiro_contra_corrente` — O Barqueiro Sabe Nadar Contra a Corrente

**Tipo:** Diálogo/Resolução · **Dificuldade:** Médio · **Região:** Lago Sylvaine · **NPC:** Barqueiro (`npcs/barqueiro.md`)

**Requer:** `lago_02_o_redemoinho` · **Desbloqueia:** —

**Gancho**

O Barqueiro atravessa o Rio Coluber e borda o Lago Sylvaine todo santo
dia — se alguém no andar sabe alguma coisa real sobre o redemoinho, é
ele. O problema é que ele gosta mais de conversar sobre qualquer outra
coisa primeiro.

**Leia em voz alta**

> O Barqueiro parece o tipo de homem que conhece tudo e confirma pouco. Ele
> fala do tempo, da água, do humor dos viajantes e só chega perto do assunto
> certo quando decide que o grupo tem paciência para não desperdiçar resposta.

**O que está em jogo**

- Esta é a cena que transforma suspeita em contexto.
- Se o grupo ganhar a confiança certa, sai com uma verdade parcial muito boa.
- O peso dela está menos na informação bruta e mais em quem a entrega.

**Estrutura em beats**

1. Abordagem — o Barqueiro está sempre disposto a conversar, mas desviar
   pra um assunto sério exige jeito.
2. Ele nota que o grupo já sabe de algo (se `lago_02` foi feito) — isso
   muda o tom da conversa, de evasivo pra cauteloso.
3. Ele entrega uma verdade parcial: já viu a água do lago “errar o caminho”
   outras vezes, sempre em dias específicos, e aprendeu a não atravessar
   aquele trecho quando ela parece calma demais.

**Testes sugeridos**

- d20+Sabedoria — conduzir a conversa até o ponto sério sem soar apressado
- d20+Inteligência — perceber o valor real do que ele está dizendo, mesmo quando fala por metáfora

**NPCs na cena**

- **Barqueiro** — gosta de conversar à vontade, mas testa paciência antes de confiança.
- **Responde:** o que viu, o que evita, como aprendeu a respeitar o lago.
- **Recusa:** frase direta demais pedindo “a resposta”.
- **Se pressionado:** finge leveza, encerra o assunto e muda de rota.

**Complicações úteis**

- O Barqueiro fala em parábola e o grupo precisa separar estilo de conteúdo.
- Uma terceira pessoa entra na conversa na pior hora.
- O grupo ganha uma pista boa, mas tarde demais para usar no mesmo dia.
- O Barqueiro percebe que eles sabem mais do que deveriam e fica cauteloso.

**Recompensas**

Col 0 + confirmação qualificada de que o redemoinho não é natural e segue
um padrão observável. Em sucesso total, o Barqueiro também indica o melhor
horário para voltar ao lago sem ser pego pelo comportamento mais agressivo
da água.

**Gancho visual / de transmissão**

- O Barqueiro falando sério sem parar de remar.
- Uma verdade importante escondida dentro de frase aparentemente banal.
- O grupo percebendo que experiência vale mais que rumor.

3. Confirmação (ou negação) do que o grupo suspeita — ele confirma que o
   fenômeno é real e antigo, mas não sabe explicar a causa.
4. Ele pede, em troca da informação completa, que o grupo não espalhe o
   assunto pra qualquer um — não quer virar atração de turista de guilda.

**Testes sugeridos**

- d20+Sabedoria — puxar o assunto sério sem quebrar o clima social da conversa
- d20+Inteligência — reconhecer quando ele está sendo evasivo por educação vs. por realmente não saber

**Recompensas**

Col 70 (não é o Barqueiro que paga — é o valor da informação pra quem
compra do grupo depois, se decidirem vender) + confirmação real do
fenômeno, fechando o fragmento de pista da cadeia C. Se o grupo prometer
discrição e cumprir, o Barqueiro vira contato recorrente com desconto
permanente na travessia.

**Fecha a cadeia C.**

---

## Cadeia D — Picos de Grauvenn

**Aviso pro mestre:** nível de ameaça acima do recomendado pra grupos
recém-formados — a dificuldade base de toda a cadeia já sobe um degrau em
relação às outras (o "Fácil" daqui equivale ao "Médio" de Horunka). Usar
como conteúdo pra quando o grupo já tiver passado pela primeira aventura
completa e quiser um desafio real.

### `montanha_01_primeira_subida` — Primeira Subida

**Tipo:** Exploração · **Dificuldade:** Médio · **Região:** Montanhas de Grauvenn

**Requer:** — · **Desbloqueia:** `montanha_02_minerio_que_nao_e_comum`, `montanha_03_ninho_de_altitude`

**Gancho**

As Montanhas de Grauvenn começam onde a floresta para de crescer — rocha
nua, vento constante, e uma trilha que só existe até certo ponto antes de
virar escalada de verdade. O Veio Exposto que todo caçador de Tolbana
comenta fica bem no meio de um trecho instável.

**Estrutura em beats**

1. A subida inicial — trilha normal, sem risco real, só cansativo.
2. O trecho instável — pedra solta, vento forte o suficiente pra
   atrapalhar o equilíbrio.
3. Escolha de rota: caminho mais curto (mais arriscado) ou mais longo
   (mais seguro, gasta mais tempo do dia).
4. Chegada ao veio — primeira vista real da região, incluindo o que vem
   depois nesta cadeia (ninho de altitude visível ao longe, uma fenda na
   rocha logo abaixo).

**Testes sugeridos**

- d20+Força — atravessar o trecho instável sem escorregar
- d20+Destreza — se o grupo escolher o caminho curto, reagir ao vento forte

**Complicação**

Numa falha, o grupo não cai de verdade — mas perde tempo recuando e
tentando de novo, o que pode empurrar o resto da expedição pra mais perto
do anoitecer (o mestre pode usar isso pra aumentar tensão nas quests
seguintes da mesma sessão).

**Recompensas**

Col 40 + XP de exploração. Sucesso total sem complicação também revela de
cima a localização exata do ninho de altitude e da fenda — economiza um
teste de busca em `montanha_03` e `montanha_04`.

---

### `montanha_02_minerio_que_nao_e_comum` — Minério Que Não é Comum

**Tipo:** Coleta · **Dificuldade:** Difícil · **Região:** Montanhas de Grauvenn

**Requer:** `montanha_01_primeira_subida` · **Desbloqueia:** `montanha_04_fenda_na_rocha`

**Gancho**

O Veio Exposto rende Minério Raro — visível, fácil de identificar, difícil
de extrair sem barulho. E barulho, nessa altitude, atrai coisa que
ninguém quer conhecer de perto.

**Estrutura em beats**

1. Avaliação do veio — quanto dá pra extrair, quanto tempo leva, qual o
   risco de cada método (picareta rápida e barulhenta vs. extração lenta
   e silenciosa).
2. Extração propriamente dita.
3. Se o processo for barulhento demais, algo se aproxima — não
   necessariamente ataca, mas o grupo sente que não está mais sozinho.

**Testes sugeridos**

- d20+Destreza — extrair o minério (quantidade e qualidade dependem do resultado)
- d20+Inteligência — perceber sinais de que algo se aproximou antes que seja tarde demais

**Complicação**

Numa falha dupla (Técnica e Conhecimento), o grupo termina a extração e
descobre, tarde demais, que não está mais sozinho — gancho direto pra um
encontro extra com o Ninho de Altitude fora da quest `montanha_03`, se o
mestre quiser escalar.

**Recompensas**

Col 0 (o valor está no material, não em pagamento) + Minério Raro: 2
unidades (10+), 1 unidade (7-9), 0 (6-). Minério Raro é peça-chave da
cadeia de Ferreiro em `docs/economia_profissoes.md` — vale a viagem
mesmo em resultado parcial.

---

### `montanha_03_ninho_de_altitude` — Ninho de Altitude

**Tipo:** Combate · **Dificuldade:** Difícil · **Região:** Montanhas de Grauvenn

**Requer:** `montanha_01_primeira_subida` · **Desbloqueia:** `montanha_05_cristal_de_gelo`

**Gancho**

Numa saliência estreita, um ninho grande demais pro que deveria viver ali
esconde uma criatura alada que não gosta de visitas. Diferente dos
combates dos campos, esse acontece em pé numa borda de pedra — errar o
pé pesa tanto quanto errar o golpe.

**Estrutura em beats**

1. Aproximação pela saliência — o terreno em si já é um obstáculo antes
   do combate começar.
2. A criatura ataca de cima, usando a vantagem de voo contra quem está
   preso ao chão estreito.
3. Combate — cada golpe errado tem risco duplo (dano + posição).
4. Resolução: vencer, ou recuar controladamente sem cair.

**Testes sugeridos**

- d20+Destreza — manter o equilíbrio na saliência durante o combate
- d20+Força ou Reflexo — o combate em si (ameaça comum, golpes 3-4, mas com vantagem de altura pra criatura)

**Encontro**

1 criatura alada (ameaça comum, golpes 3-4, atributo de fraqueza Reflexo)
— o desafio real não é a criatura sozinha, é o terreno.

**Complicação**

Numa falha no teste de equilíbrio durante o combate, o personagem
escorrega — não cai de vez (a menos que o mestre queira uma cena de
tensão maior), mas perde a próxima ação se recompondo.

**Recompensas**

Col 130 + material de caça (Pena ou Garra, Incomum). Vencer sem ninguém
escorregar rende também uma vista clara da rota até o Cristal de Gelo em
`montanha_05`.

---

### `montanha_04_fenda_na_rocha` — Fenda na Rocha

**Tipo:** Investigação/Puzzle · **Dificuldade:** Médio · **Região:** Montanhas de Grauvenn

**Requer:** `montanha_02_minerio_que_nao_e_comum` · **Desbloqueia:** `montanha_06_o_que_ha_alem_da_fenda`

**Gancho**

Uma passagem estreita corta a montanha logo abaixo do veio — estreita
demais pra qualquer armadura pesada passar sem se espremer. Ninguém da
região documentou o que tem do outro lado, só que existe.

**Estrutura em beats**

1. Avaliar a fenda — só passa quem estiver disposto a tirar equipamento
   volumoso (ou quem já usa armadura leve).
2. Atravessar — espaço apertado, escuro, desconfortável mas não
   fisicamente perigoso por si só.
3. Do outro lado: um espaço pequeno, claramente visitado por alguém antes
   (ou algo) — o gancho real pra `montanha_06`.

**Testes sugeridos**

- d20+Força — atravessar o espaço apertado sem ficar preso
- d20+Inteligência — notar detalhes do espaço do outro lado que indicam visita anterior

**Complicação**

Numa falha no teste de Corpo, quem tentou passar fica preso e precisa de
ajuda do resto do grupo (teste de apoio, sem risco real, só tempo
perdido) — ou desiste e cede a vez a outro personagem mais magro/ágil.

**Recompensas**

Col 20 + acesso garantido a `montanha_06`. Esta quest é propositalmente
mais barata em recompensa direta — o valor real está no que ela
desbloqueia.

---

### `montanha_05_cristal_de_gelo` — Cristal de Gelo

**Tipo:** Coleta · **Região:** Montanhas de Grauvenn · **Dificuldade:** Difícil

**Requer:** `montanha_03_ninho_de_altitude` · **Desbloqueia:** —

**Gancho**

No ponto mais alto que a cadeia alcança, cristais de gelo que nunca
derretem — nem sob o sol mais forte do andar — crescem nas fendas da
rocha. Raro mesmo pros padrões de Grauvenn.

**Estrutura em beats**

1. A subida final até o ponto mais alto — mais cansativa que perigosa,
   depois do que o grupo já enfrentou nessa cadeia.
2. Localizar um cristal que valha a pena extrair — nem todos têm o
   tamanho ou pureza certos.
3. Extração cuidadosa — o cristal racha fácil se manuseado com pressa.

**Testes sugeridos**

- d20+Inteligência — identificar o melhor cristal disponível
- d20+Destreza — extrair sem rachar

**Recompensas**

Col 0 + Cristal de Gelo: intacto (10+), rachado/qualidade menor (7-9),
perdido (6-). Raro, usado por Joalheiro/Alquimista — um dos poucos
materiais Raros do andar 1 obtido puramente por coleta, sem combate.

---

### `montanha_06_o_que_ha_alem_da_fenda` — O Que Há Além da Fenda

**Tipo:** Resolução · **Dificuldade:** Muito Difícil · **Região:** Montanhas de Grauvenn

**Requer:** `montanha_04_fenda_na_rocha` · **Desbloqueia:** —

**Gancho**

O espaço do outro lado da fenda não é natural — alguém (ou algo) esteve
ali, e recentemente. O que exatamente o grupo encontra fica a critério do
mestre, mas o tom é claro: isso é mais estranho do que qualquer coisa que
Grauvenn deveria esconder.

**Estrutura em beats**

1. Exploração do espaço — pequeno, mas com sinais claros de uso (o mestre
   define os detalhes: marcas, um objeto fora de lugar, uma passagem
   ainda mais estreita).
2. Investigação do achado central — item Raro isolado, ou fragmento
   físico de pista sobre o andar 2 (mesmo princípio de informação parcial
   das outras cadeias).
3. Se o achado "desperta" algo (resultado de falha), uma ameaça reage à
   presença do grupo — não precisa ser combate direto, pode ser só a
   pressão de sair rápido.

**Testes sugeridos**

- d20+Inteligência — entender o que foi encontrado
- d20+Sabedoria — manter a calma se algo reagir à presença do grupo

**Complicação**

Numa falha no teste de Conhecimento, o achado vem com uma ameaça atrelada
— algo desperta e o grupo precisa decidir entre investigar mais fundo
(mais risco, mais recompensa) ou recuar com o que já tem.

**Recompensas**

Col 300 + item Raro isolado OU pista fragmentada de andar 2 (à escolha do
mestre — não as duas coisas ao mesmo tempo, pra manter o valor de cada
uma). Esta é a recompensa mais alta de toda a cadeia D, condizente com
ser também o ponto mais arriscado.

**Fecha a cadeia D.**

---

## Cadeia E — Vida em Tolbana

Sem risco de combate pesado — pensada pra intercalar com as cadeias de
ação. Pode rodar em qualquer momento depois que o grupo visita Tolbana.
O fio condutor é reputação: `tolbana_e02` e `tolbana_e05` registram como o
grupo é visto na cidade, e `tolbana_e08` fecha o arco cobrando essas
escolhas de volta.

### `tolbana_e01_encomenda_urgente` — Encomenda Urgente

**Tipo:** Entrega · **Dificuldade:** Fácil · **Região:** Tolbana

**Requer:** — · **Desbloqueia:** `tolbana_e04_fio_de_prata`

**Gancho**

Um comerciante de Tolbana precisa que um pacote lacrado chegue à Cidade
do Início antes do fim do dia — ele não diz o que tem dentro, só que "não
pode chacoalhar demais".

**Estrutura em beats**

1. O pedido, com prazo apertado mas não impossível.
2. A viagem entre Tolbana e a Cidade do Início — rota conhecida, sem
   perigo real se o grupo não se distrair.
3. Tentação: o pacote pesa estranho e faz um barulho leve — abrir ou não
   é decisão do grupo, sem consequência mecânica além do que o mestre
   quiser improvisar.
4. Entrega, com ou sem atraso.

**Testes sugeridos**

- d20+Destreza — manter o ritmo de viagem sem perder tempo
- d20+Força — atravessar sem danificar o pacote se o caminho tiver algum obstáculo

**Recompensas**

Col 50 (10+, entrega rápida e intacta), Col 30 (7-9, entrega atrasada),
Col 15 + reputação levemente abalada (6-, pacote danificado).

**Gancho pra próxima quest**

O comerciante fica satisfeito o suficiente pra confiar outro pedido —
dessa vez, algo que precisa ser comprado, não só entregue.

---

### `tolbana_e02_disputa_de_preco` — Disputa de Preço

**Tipo:** Diplomacia · **Dificuldade:** Médio · **Região:** Tolbana

**Requer:** — · **Desbloqueia:** `tolbana_e05_rivalidade_de_guildas`

**Gancho**

Na Praça de Tolbana, dois comerciantes brigam alto o suficiente pra parar
o movimento ao redor — o motivo é o preço de Placas de Metal Refinado,
que um dos dois acha que o outro está usando pra sufocar a concorrência.

**Estrutura em beats**

1. Chegada no meio da discussão — já em ponto de ebulição, plateia se
   formando.
2. Ouvir os dois lados — cada um tem um argumento razoável, o que torna
   escolher "o certo" mais difícil do que parece.
3. Mediação — tentar um meio-termo, tomar partido, ou usar autoridade
   improvisada (se algum jogador tiver reputação/profissão relevante).
4. Resultado público — a cidade toda vê como termina.

**Testes sugeridos**

- d20+Sabedoria — mediar sem escalar a tensão
- d20+Inteligência — entender a economia real por trás da briga (ajuda a propor uma solução que funcione de verdade)

**Complicação**

Numa falha, a briga piora na hora — não vira violência, mas vira boato
ruim sobre o grupo se espalhando pela cidade antes do fim do dia.

**Recompensas**

Col 60 + reputação em Tolbana (registrada pro mestre usar em `tolbana_e08`).
Sucesso total: os dois lados ficam gratos. Parcial: um lado fica
ressentido — anota qual, importa depois. Falha: reputação leve negativa.

**Gancho pra próxima quest**

A disputa não era só entre dois comerciantes — tem guilda por trás dos
dois lados.

---

### `tolbana_e03_corretores_desconfiados` — Corretores Desconfiados

**Tipo:** Investigação · **Dificuldade:** Médio · **Região:** Tolbana · **NPC:** Corretores de Informação (ponto `tolbana_corretores`)

**Requer:** — · **Desbloqueia:** `tolbana_e06_o_preco_da_informacao`

**Gancho**

Os corretores de informação de Tolbana (ver `docs/misterio_andar2.md`)
vendem teoria sobre o Labirinto pra qualquer um disposto a pagar — mas o
que vendem de graça na conversa é sempre menos interessante que o que
guardam pra quem parece saber fazer a pergunta certa.

**Estrutura em beats**

1. Primeira abordagem — o corretor testa o grupo com informação genérica,
   já sabida, só pra ver como reagem.
2. Se o grupo demonstrar que já sabe de algo real (por ter feito outras
   quests de pista), o tom muda — o corretor fica mais cauteloso, não
   mais aberto.
3. Negociação sutil — puxar mais informação sem parecer desesperado ou
   ameaçador.

**Testes sugeridos**

- d20+Inteligência — fazer as perguntas certas, na ordem certa
- d20+Sabedoria — manter a postura calma mesmo se a negociação esfriar

**NPCs na cena**

- **Corretores de Informação** — querem Col por informação, e clientes que
  saibam perguntar sem parecer desesperados.
- **Responde:** fragmentos de teoria sobre o Labirinto e sobre o mistério
  do andar 2 — misturando informação real e chute, sempre por Col (ver
  `docs/misterio_andar2.md`).
- **Recusa:** admitir qual parte do que vendem é chute; tratam as duas
  coisas com a mesma confiança de venda.
- **Se pressionado:** ficam mais reservados, não mais honestos — desconfiança
  profissional, não hostilidade.

**Complicação**

Numa falha, os corretores fecham o jogo de vez com esse grupo específico
— não é hostilidade, é desconfiança profissional. Reabrir a relação exige
uma cena separada de reconstrução de confiança, à critério do mestre.

**Recompensas**

Col 0 (o pagamento aqui é informação, não Col) + uma pista sobre o
mistério do andar 2 — real ou red herring, a critério do mestre (ver
"red herrings" em `docs/misterio_andar2.md`). Sucesso total garante que a
pista seja real; parcial deixa ambíguo de propósito.

**Gancho pra próxima quest**

Informação de verdade, os corretores deixam claro, tem preço maior do que
uma conversa na praça.

---

### `tolbana_e04_fio_de_prata` — Fio de Prata

**Tipo:** Coleta/Comércio · **Dificuldade:** Fácil · **Região:** Tolbana

**Requer:** `tolbana_e01_encomenda_urgente` · **Desbloqueia:** —

**Gancho**

O Joalheiro da Cidade do Início precisa de fio de prata pra terminar um
encomenda — só se acha em Tolbana, e o fornecedor local não é dos mais
fáceis de negociar.

**Estrutura em beats**

1. Encontrar o vendedor certo — não é óbvio de cara, o mercado de Tolbana
   tem várias bancas parecidas.
2. Negociação — o preço inicial é alto; dá pra baixar com argumento bom
   ou reputação já construída (bônus se `tolbana_e02` foi resolvida bem).
3. Levar de volta pro Joalheiro.

**Testes sugeridos**

- d20+Inteligência — achar o vendedor certo sem perder tempo
- d20+Sabedoria ou Conhecimento — negociar o preço

**Recompensas**

Fio de Prata (quantidade suficiente pra receita do Joalheiro) + Col 30 de
lucro se a negociação sair muito bem (10+). Reputação com o Joalheiro
sobe — desconto permanente em itens de Joalheiro no futuro.

---

### `tolbana_e05_rivalidade_de_guildas` — Rivalidade de Guildas

**Tipo:** Diplomacia · **Dificuldade:** Difícil · **Região:** Tolbana

**Requer:** `tolbana_e02_disputa_de_preco` · **Desbloqueia:** `tolbana_e08_reputacao_em_tolbana`

**Gancho**

A disputa de preço não era só entre dois comerciantes — cada um tem apoio
de uma guilda diferente (ver `docs/economia_profissoes.md`: Sindicato,
LHUB, Dndalcin, iBarr's, Terraço Geek, Guilda de Nerds), e a tensão real
está subindo pra um nível que passa longe de resolução fácil.

**Estrutura em beats**

1. Representantes das duas guildas procuram o grupo separadamente,
   tentando puxar apoio pro próprio lado — cada um oferece algo diferente.
2. O grupo decide: apoiar uma guilda, ficar neutro publicamente, ou
   tentar mediar uma reconciliação real entre as duas.
3. Consequência imediata — a escolha muda como as duas guildas tratam o
   grupo dali em diante (preços, acesso a informação, convites).
4. Se o grupo tentar reconciliar, é o caminho mais difícil e mais
   arriscado — mas o único que evita fazer um inimigo permanente.

**Testes sugeridos**

- d20+Sabedoria — a conversa com cada representante de guilda
- d20+Inteligência — se tentar reconciliar, entender o que cada lado realmente quer por trás do orgulho

**Complicação**

Escolher um lado sem querer (10+ na conversa com só uma guilda, sem
Espírito investido na outra) resolve rápido mas cria ressentimento
permanente do lado não escolhido — não é errado, é uma escolha real com
peso real.

**Recompensas**

Col 150 + mudança registrada de reputação com as guildas envolvidas
(documentar pro mestre usar em `tolbana_e08` e em cenas futuras — acesso
a recompensas de guilda, tratamento em lojas, convites pra eventos).
Reconciliar bem-sucedida (resultado raro, exige 10+ no teste de
Conhecimento) rende reputação positiva com as duas ao mesmo tempo.

**Gancho pra próxima quest**

Como quer que tenha terminado, a cidade toda já sabe o nome do grupo.

---

### `tolbana_e06_o_preco_da_informacao` — O Preço da Informação

**Tipo:** Investigação · **Dificuldade:** Difícil · **Região:** Tolbana

**Requer:** `tolbana_e03_corretores_desconfiados` · **Desbloqueia:** —

**Gancho**

Os corretores voltam a falar com o grupo — dessa vez com uma proposta
concreta: uma pista específica sobre o que realmente acontece depois de
um chefe de andar cair. O preço não é só Col.

**Estrutura em beats**

1. A proposta — o corretor pede algo específico em troca: um item raro,
   um favor, ou informação que o próprio grupo tenha e ele não.
2. Negociação sobre o que exatamente será pago — o mestre pode usar
   qualquer material/item Incomum+ que o grupo já tenha coletado em
   outras cadeias.
3. Entrega do pagamento e recebimento da informação.

**Testes sugeridos**

- d20+Inteligência — avaliar se o preço pedido é justo (evita ser enganado)
- d20+Sabedoria — negociar o preço pra baixo sem ofender o corretor

**Complicação**

Numa falha no teste de Conhecimento, o grupo paga um preço injusto sem
perceber — só descobre depois, o que pode alimentar desconfiança futura
com os corretores.

**Recompensas**

Custo: item Incomum ou favor equivalente a Col 150+ (à escolha do grupo/
mestre). Recompensa: pista real e completa (10+), real mas incompleta
(7-9), ou falsa vendida como verdadeira (6- — o grupo só descobre a
mentira mais tarde, quando a pista não bater com outra fonte).

---

### `tolbana_e07_guarda_costas_por_um_dia` — Guarda-Costas por um Dia

**Tipo:** Escolta · **Dificuldade:** Médio · **Região:** Tolbana (Estrada de Ombric)

**Requer:** — · **Desbloqueia:** —

**Gancho**

Um comerciante contrata proteção pra uma viagem curta pela Estrada de
Ombric — rota conhecida por ter sido palco de assaltos antes (ver ponto
"Ponto de Assalto" no mapa).

**Estrutura em beats**

1. Combinação de termos — pagamento, rota, o que exatamente está sendo
   transportado.
2. A viagem — tranquila na maior parte, com tensão crescente conforme se
   aproxima do trecho conhecido por assaltos.
3. Se houver emboscada: defesa da carga contra assaltantes (ver
   `bounty_06_caravana_emboscada` — o mestre pode ligar as duas quests
   diretamente, usando o mesmo encontro).
4. Chegada ao destino.

**Testes sugeridos**

- d20+Destreza — perceber sinais de emboscada antes que aconteça
- d20+Força — defender a carga se o ataque acontecer

**Encontro (se aplicável)**

Se ligado a `bounty_06`: grupo pequeno de assaltantes (ameaça comum,
golpes 3-4).

**Recompensas**

Col 90 (viagem tranquila) ou Col 90 + Col 40 extra de bônus por defender
a carga com sucesso num ataque. Falha total na defesa (perder a carga)
ainda paga Col 30 pelo esforço, mas com reputação abalada com esse
comerciante específico.

---

### `tolbana_e08_reputacao_em_tolbana` — Reputação em Tolbana

**Tipo:** Resolução · **Dificuldade:** — (sem teste) · **Região:** Tolbana

**Requer:** `tolbana_e05_rivalidade_de_guildas` · **Desbloqueia:** —

**Gancho**

Depois de tudo — a disputa de preço, a escolha entre guildas, qualquer
outra interação que o grupo teve na cidade — Tolbana já formou uma
opinião sobre eles. Essa cena fecha o arco cobrando as escolhas de volta.

**Estrutura em beats**

1. Cena de chegada na cidade — como as pessoas reagem ao ver o grupo
   (cumprimentos, olhares desconfiados, ou indiferença, conforme o
   registro de `tolbana_e02`/`tolbana_e05`).
2. Um NPC específico (comerciante, guarda, ou representante de guilda)
   comenta diretamente sobre a reputação do grupo — positiva ou negativa.
3. Efeito prático declarado: preços, acesso a áreas/informação, e
   disposição de NPCs a ajudar dali em diante.

**Sem teste** — esta é resolução narrativa pura, baseada no que já
aconteceu. O mestre consulta o registro de reputação acumulado nas
quests anteriores da cadeia e narra a consequência.

**Recompensas**

Efeito duradouro documentado: desconto ou sobretaxa em compras em
Tolbana (10-20%), acesso ou bloqueio a informação de guilda, e o tom com
que NPCs da cidade tratam o grupo em cenas futuras.

**Fecha a cadeia E.**

---

## Cadeia F — Memorial de Voss

A resolução completa do mistério já está definida em
`docs/interacoes_e_segredos.md` ("O Nome Apagado") — a pessoa enterrada
morreu de um jeito que envergonhava alguém próximo (dívida não paga,
covardia num momento de pânico — algo humano, não sinistro), e esse
alguém, que ainda visita o memorial de forma anônima, pediu ao Zelador
pra apagar o nome. A identidade exata do visitante fica pro mestre
escolher (boa chance de reaproveitar um NPC já existente e dar
profundidade a ele). As quests abaixo levam o grupo até essa resposta —
não inventam uma nova.

### `necropole_01_lapide_sem_nome` — A Lápide Sem Nome

**Tipo:** Investigação · **Dificuldade:** Fácil · **Região:** Necrópole de Voss

**Requer:** — · **Desbloqueia:** `necropole_02_zelador_nao_confia`

**Gancho**

Entre as fileiras organizadas de lápides da Necrópole de Voss, uma se
destaca por um motivo estranho: o nome foi raspado. Não desgastado pelo
tempo — raspado, de propósito, com ferramenta.

**Leia em voz alta**

> Na Necrópole de Voss, o silêncio não é vazio. É manutenção. Alguém cuida da
> grama, alinha as pedras e decide o que continua digno de nome. Por isso a
> lápide raspada incomoda tanto: não parece abandono. Parece decisão.

**O que está em jogo**

- Se o grupo agir sem respeito, perde o memorial antes de entender o mistério.
- Se agir bem, ganha uma das linhas mais humanas do andar.
- A cena precisa fazer a Necrópole parecer lugar de consequência, não decoração.

**Estrutura em beats**

1. Passagem pela Necrópole — atmosfera de respeito silencioso, o Zelador
   observando de longe sem se aproximar ainda.
2. Exame da lápide — a raspagem é recente, não tem mais que algumas
   semanas.
3. Decisão: examinar mais de perto (risco de ofender o Zelador se ele
   achar que o grupo está desrespeitando o lugar) ou perguntar
   diretamente.

**Testes sugeridos**

- d20+Sabedoria — examinar com respeito suficiente pra não incomodar o Zelador
- d20+Inteligência — perceber que a raspagem foi feita por alguém específico, não é vandalismo aleatório

**NPCs na cena**

- **Zelador do Memorial (à distância)** — quer medir intenção antes de falar.
- **Responde:** nada de primeira; ele observa.
- **Recusa:** curiosidade vazia ou gesto de profanação.
- **Se pressionado:** aproxima-se cedo demais e a conversa já começa torta.

**Complicação**

Numa falha, o Zelador nota o grupo mexendo onde não devia e a abordagem
em `necropole_02` começa em desvantagem — ele parte mais desconfiado do
que precisaria.

**Recompensas**

Col 20 (nada de material aqui — o valor é todo em informação) + confirmação
de que a raspagem foi proposital e recente. Isso é o suficiente pra abrir
`necropole_02`.

**Gancho visual / de transmissão**

- A raspagem fresca no lugar onde um nome deveria estar.
- O Zelador observando sem interromper.
- O grupo percebendo que mexer ali é quase falar alto em igreja.

---

### `necropole_02_zelador_nao_confia` — O Zelador Não Confia em Qualquer Um

**Tipo:** Diálogo · **Dificuldade:** Médio · **Região:** Necrópole de Voss · **NPC:** Zelador do Memorial (`npcs/zelador_do_memorial.md`)

**Requer:** `necropole_01_lapide_sem_nome` · **Desbloqueia:** `necropole_03_ossos_que_nao_deviam`

**Gancho**

O Zelador não pergunta o nome de quem chega — só de quem já não pode
mais dizer o próprio. Ele sabe exatamente do que o grupo está atrás
assim que perguntam sobre a lápide, e não vai facilitar pra qualquer um.

**Leia em voz alta**

> O Zelador trabalha sem pressa, mas nada nele parece lento. Ele ouve o grupo
> inteiro antes de erguer os olhos direito, como se estivesse decidindo se
> aquela conversa merece existir. Quando responde, a voz não sai dura. Sai
> cansada de um jeito que pede ser levado a sério.

**O que está em jogo**

- Se o grupo ganhar confiança, a cadeia anda pelo caminho certo.
- Se perder margem com ele, o memorial fecha sem precisar de ameaça.
- A cena vende autoridade moral sem virar NPC “misterioso por vaidade”.

**Estrutura em beats**

1. Primeira abordagem — o Zelador escuta sem revelar nada, avaliando as
   intenções do grupo pelo tom da pergunta.
2. Ele testa o grupo: pede um favor primeiro (cuidar do memorial por um
   tempo, ou trazer Ossos Antigos pra um propósito que ele não explica de
   imediato) antes de considerar confiar.
3. Se o grupo cumprir ou convencer sem o favor, ele começa a contar —
   parcialmente, sem entregar tudo de uma vez.

**Testes sugeridos**

- d20+Sabedoria — convencer o Zelador de que o interesse é respeitoso, não curiosidade vazia

**NPCs na cena**

- **Zelador do Memorial** — quer proteger o lugar e quem ele representa.
- **Responde:** o bastante para medir caráter.
- **Recusa:** transformar a Necrópole em fonte rápida de drama ou lucro.
- **Se pressionado:** encerra com educação tão seca que fica pior.

**Complicação**

Numa falha, ele fecha a conversa e pede pra não voltarem tão cedo — não é
definitivo, mas exige tempo (ou cumprir `necropole_06` primeiro como
gesto de boa fé) antes de tentar de novo.

**Recompensas**

Acesso ao início da história — confirmação de que alguém pediu pra
apagar o nome, sem ainda revelar quem ou por quê. Isso é suficiente pra
abrir `necropole_03`.

**Gancho visual / de transmissão**

- O Zelador escolhendo as palavras como se cada uma custasse.
- O grupo entendendo que ali respeito é mecânica, não só tom.
- A primeira frase em que ele confirma que o nome foi apagado por pedido.

---

### `necropole_03_ossos_que_nao_deviam` — Ossos Que Não Deviam Estar Ali

**Tipo:** Coleta/Investigação · **Dificuldade:** Médio · **Região:** Necrópole de Voss

**Requer:** `necropole_02_zelador_nao_confia` · **Desbloqueia:** `necropole_04_o_nome_apagado`

**Gancho**

Como parte do que o Zelador pediu (ou permitiu), o grupo precisa vasculhar
uma área mais antiga do memorial — restos espalhados, mais velhos que
qualquer coisa que morreu dentro do próprio jogo, misturados com
possíveis indícios reais sobre a lápide sem nome.

**Leia em voz alta**

> A parte antiga do memorial não parece abandonada. Parece poupada. O chão
> segura melhor o som dos passos, as pedras têm nomes mais gastos, e os restos
> espalhados ali incomodam menos pelo que são do que pelo que não deveriam
> estar fazendo fora do lugar.

**O que está em jogo**

- Se o grupo tratar a área como loot fácil, perde a confiança do Zelador.
- Se agir com cuidado, ganha uma pista que vale mais do que o material.
- A cena precisa fazer a Necrópole parecer peso de gente, não só mapa de recurso.

**Estrutura em beats**

1. Vasculhar a área antiga sob supervisão distante do Zelador.
2. Separar o que é "só osso comum" (material de crafting) do que pode ser
   indício relevante (um objeto pessoal, um fragmento de registro).
3. Levar o achado de volta ao Zelador, que reage de acordo com o que foi
   encontrado.

**Testes sugeridos**

- d20+Inteligência — separar material comum de indício real
- d20+Destreza — não danificar nada durante a busca

**NPCs na cena**

- **Zelador do Memorial** — quer verdade, mas não quer profanação.
- **Responde:** o que é recente, o que já estava ali antes, o que o preocupa.
- **Recusa:** transformar o memorial em pedreira ou espetáculo.
- **Se pressionado:** fecha a expressão, continua presente, e o grupo sente na
  hora que perdeu margem com ele.

**Complicação**

Numa falha grave, o grupo destrói o indício sem perceber — a quest não
trava, mas `necropole_04` fica mais difícil (o Zelador precisa contar a
história inteira de memória, sem a ajuda do objeto físico).

**Complicações úteis**

- O grupo encontra material valioso e quase perde o indício importante no meio.
- Um objeto pessoal aparece cedo demais e direciona suspeita errada.
- O Zelador percebe um gesto de desrespeito e muda o tom da cena.
- A prova física existe, mas está incompleta ou danificada.

**Recompensas**

Col 30 + Ossos Antigos (Alquimista/Coveiro) +, em sucesso total, um
objeto pessoal que serve de prova física da história por vir.

**Gancho visual / de transmissão**

- O grupo ajoelhado entre nomes apagados pelo tempo e restos fora do lugar.
- O momento em que um objeto pessoal pequeno pesa mais do que os ossos.
- O Zelador reagindo antes de falar.

---

### `necropole_04_o_nome_apagado` — O Nome Apagado

**Tipo:** Resolução · **Dificuldade:** Difícil · **Região:** Necrópole de Voss

**Requer:** `necropole_03_ossos_que_nao_deviam` · **Desbloqueia:** `necropole_05_prestar_contas`

**Gancho**

Com a confiança do Zelador conquistada e o indício em mãos, a história sai:
a pessoa enterrada ali morreu de um jeito que envergonhava alguém
próximo — não um crime, não uma conspiração, só um momento humano de
covardia ou uma dívida que nunca foi paga. Esse alguém pediu, entre
lágrimas, que o nome fosse apagado — e ainda visita o memorial, sozinho,
sempre em horários diferentes, sem nunca ser notado.

**Leia em voz alta**

> O Zelador não conta a história como quem revela segredo. Conta como quem
> devolve peso ao lugar certo. O objeto encontrado, se o grupo trouxe um,
> parece pequeno demais para sustentar tudo aquilo até o instante em que ele
> encosta na pedra e a ausência de nome fica mais difícil de ignorar.

**O que está em jogo**

- Entender certo evita apontar culpa errada para alguém vivo.
- Entender errado machuca gente que já está carregando o bastante.
- A cena existe para premiar escuta, cuidado e interpretação.

**Estrutura em beats**

1. O Zelador conta a história com cuidado — ele mesmo carrega o peso de
   ter concordado em apagar o nome.
2. Cruzando o que foi dito com o objeto físico (se recuperado em
   `necropole_03`), o grupo pode identificar quem é o visitante anônimo —
   boa chance de ser um NPC que já apareceu em outra parte da campanha.
3. Confronto ou não com essa informação fica pra `necropole_05`.

**Testes sugeridos**

- d20+Inteligência — entender a história completa sem tirar conclusões precipitadas
- d20+Sabedoria — reagir à revelação sem julgar o Zelador ou o visitante anônimo abertamente diante dele

**Complicação**

Numa falha no teste de Conhecimento, o grupo entende a história errada —
aponta o dedo pra pessoa errada, o que pode gerar uma cena de
constrangimento real (e uma correção necessária mais tarde).

**Complicações úteis**

- O grupo acerta os fatos, mas erra o tom ao comentar na frente do Zelador.
- Um detalhe do objeto físico parece incriminar a pessoa errada por um momento.
- A história mexe com alguém da mesa por associação e isso muda a conversa.
- O nome verdadeiro surge, mas não resolve o que fazer com ele.

**Gancho visual / de transmissão**

- O objeto pessoal tocando a pedra sem nome.
- O Zelador parando um segundo antes da parte mais difícil.
- A mesa percebendo que a resposta é humana demais para virar “plot twist”.

**Recompensas**

Sem recompensa material — o valor é inteiramente narrativo. XP de
exploração alto pela profundidade da descoberta.

---

### `necropole_05_prestar_contas` — Prestar Contas

**Tipo:** Decisão de grupo · **Dificuldade:** — (sem teste) · **Região:** Necrópole de Voss

**Requer:** `necropole_04_o_nome_apagado` · **Desbloqueia:** —

**Gancho**

Agora que sabem quem é o visitante anônimo e por quê o nome foi apagado,
o grupo decide o que fazer com isso.

**Leia em voz alta**

> Saber a verdade não resolve a cena. Só tira a desculpa da ignorância. Na
> Necrópole, entre lápides limpas demais para permitir leviandade, o grupo
> precisa decidir se verdade serve para curar, para expor ou só para pesar.

**O que está em jogo**

- Esta é a quest que transforma descoberta em posição moral.
- A escolha aqui muda relações, não estatística.
- O valor da cena está em como o grupo age quando já entendeu tudo.

**Estrutura em beats**

1. Cena de decisão — confrontar o visitante diretamente, guardar segredo
   e nunca mencionar, ou tentar ajudar a reconciliar a situação sem expor
   ninguém (ex: convencer o visitante a se perdoar, ou o Zelador a
   permitir uma pequena homenagem discreta).
2. Consequência — o mestre decide o efeito de longo prazo conforme a
   escolha (o visitante pode virar aliado grato, ou se afastar de vez se
   confrontado sem cuidado).

**Sem teste fixo** — é decisão de roleplay puro. Se o mestre quiser um
teste pra uma abordagem específica (ex: convencer o visitante a se
perdoar), use d20+Sabedoria.

**Complicações úteis**

- O visitante aceita ouvir, mas não perdoa a própria versão da história.
- O Zelador concorda com a intenção do grupo, mas não com o método.
- Uma boa decisão vem com custo social fora da Necrópole.
- O grupo percebe que ajudar sem expor também exige mentir para alguém.

**Recompensas**

Consequência narrativa de longo prazo — não em Col ou item, e sim em
relação (o visitante anônimo, revelado, pode se tornar um contato
recorrente grato pela discrição do grupo).

**Gancho visual / de transmissão**

- A pausa antes de alguém dizer “então vamos fazer assim”.
- O visitante reagindo mais ao tom do que ao conteúdo.
- O fim da cena deixando alívio e incômodo ao mesmo tempo.

**Fecha a linha principal da cadeia F.**

---

### `necropole_06_memorial_comum` — Memorial Comum

**Tipo:** Serviço · **Dificuldade:** Fácil · **Região:** Necrópole de Voss

**Requer:** — · **Desbloqueia:** —

**Gancho**

Sem relação direta com o mistério da lápide — o Zelador só precisa de
ajuda braçal organizando o memorial: reposicionar pedras, limpar
vegetação que cresceu demais, reorganizar registros.

**Leia em voz alta**

> O trabalho no memorial não é difícil porque pesa. É difícil porque obriga
> atenção. Cada pedra mexida lembra que alguém deixou de voltar, e o Zelador
> trata o serviço inteiro como se respeito também fosse uma forma de limpeza.

**O que está em jogo**

- Esta é a melhor porta de entrada silenciosa para a cadeia da Necrópole.
- O grupo pode conquistar confiança sem pedir nada em troca.
- A cena serve para mostrar cuidado como ação jogável.

**Estrutura em beats**

1. O pedido, simples e direto.
2. O trabalho em si — cansativo, não perigoso.
3. Conversa lateral com o Zelador durante o trabalho — boa oportunidade
   de construir confiança antes mesmo de `necropole_02` (se feita antes,
   dá vantagem lá).

**Testes sugeridos**

- d20+Força — o trabalho braçal em si

**NPCs na cena**

- **Zelador do Memorial** — observa mais do que conversa, mas percebe tudo.
- **Responde:** histórias curtas, fatos concretos e nada melodramático.
- **Recusa:** qualquer pressa ou gesto descuidado com o memorial.
- **Se pressionado:** fica mais calado, não mais aberto.

**Recompensas**

Col 25 (simbólico) + reputação com o Zelador. Se feita antes de
`necropole_02`, concede vantagem no teste de Espírito daquela quest —
o Zelador já viu o grupo agir com respeito antes de qualquer pergunta.

**Gancho visual / de transmissão**

- Mãos sujas de terra em lugar sagrado.
- O Zelador aprovando em silêncio, quase sem olhar.
- A descoberta de que serviço simples pode carregar muito peso.

---

## Cadeia G — O Mural do Castelo

Expande o puzzle já documentado em `docs/interacoes_e_segredos.md` (mural
dos 5 cristais no pátio do Castelo de Ferro Negro). A cantiga abaixo é o
conteúdo real da pista — use exatamente estas letras/versos na mesa.

**A cantiga** ("Verso da Viagem do Peregrino Perdido", cantada pelo
Músico busker na Taverna/praça):

> _Azul foi o primeiro passo, que o levou pra longe de casa,_
> _Verde a folha que curou seu pé cansado,_
> _Roxo o fruto que tirou o mal do corpo,_
> _Dourada a luz que guiou seu caminho na noite,_
> _Prata o escudo que o protegeu até o fim._

Cada verso, na ordem, corresponde a uma cor de cristal — e a ordem dos
versos é a ordem de encaixe no mural: **Teleporte (azul) → Cura (verde) →
Antídoto (roxo) → Luz (dourado) → Barreira (prata)**.

### `castelo_01_cantiga_do_musico` — A Cantiga do Músico

**Tipo:** Investigação · **Dificuldade:** Médio · **Região:** Castelo de Ferro Negro (Cidade do Início) · **NPC:** Músico busker (ponto "Taverna")

**Requer:** — · **Desbloqueia:** `castelo_02_cinco_cristais`

**Gancho**

Na Taverna da Cidade do Início, um Músico busker canta a mesma cantiga
todas as noites — ninguém presta atenção de verdade na letra, tratada
como só mais uma música de ambiente.

**Leia em voz alta**

> A cantiga já estava no ar antes de o grupo entrar na taverna. E é justamente
> isso que a torna perigosa: todo mundo já decidiu que ela é fundo. Quando se
> presta atenção de verdade, os versos parecem limpos demais para serem só
> música de mesa.

**O que está em jogo**

- Esta é uma pista que premia escuta ativa.
- Se o grupo ouvir com calma, ganha acesso a uma das linhas mais elegantes do castelo.
- A cena existe para fazer informação parecer descoberta, não exposição.

**Estrutura em beats**

1. Primeira audição — a cantiga toca como música de fundo, fácil de
   ignorar.
2. Pedir pro Músico repetir/explicar — ele conta que aprendeu de outro
   busker, que aprendeu de um terceiro; ninguém sabe a origem real.
3. Decifrar a letra com atenção — cada verso tem uma cor associada, e a
   ordem dos versos importa.

**Testes sugeridos**

- d20+Inteligência — decifrar a cantiga inteira e associar cada cor ao
  tipo de cristal certo (Teleporte/Cura/Antídoto/Luz/Barreira)
- d20+Sabedoria — convencer o Músico a repetir a cantiga com calma o
  suficiente pra anotar cada verso

**NPCs na cena**

- **Músico busker** — gosta de atenção, mas não sabe o valor completo do que canta.
- **Responde:** onde aprendeu a cantiga, quem mais costuma pedir para repetir.
- **Recusa:** tratar a música como código sem antes tratá-la como canção.
- **Se pressionado:** faz piada para sair da situação.

**Complicação**

Numa falha no teste de Conhecimento, o grupo decifra a sequência errada
(troca a ordem de dois versos) — se tentarem o mural sem confirmar antes,
`castelo_02` começa com uma combinação errada já testada.

**Recompensas**

Col 0 + a sequência completa e correta (10+), ou incompleta/com um erro
(7-9 — falta um verso ou a ordem de dois está trocada). Essa informação é
o que abre `castelo_02` de verdade.

**Gancho visual / de transmissão**

- A taverna inteira ignorando a pista certa.
- O momento em que um verso deixa de soar decorativo.
- A mesa percebendo que a resposta estava em público o tempo todo.

---

### `castelo_02_cinco_cristais` — Cinco Cristais

**Tipo:** Puzzle · **Dificuldade:** Difícil · **Região:** Castelo de Ferro Negro

**Requer:** `castelo_01_cantiga_do_musico` · **Desbloqueia:** `castelo_03_rachadura_na_muralha`

**Gancho**

No pátio do Castelo de Ferro Negro, um mural de pedra tem 5 encaixes
vazios, cada um com o contorno de um tipo de cristal. Ninguém carrega os
5 tipos sozinho normalmente — Teleporte e Cura são comuns, Antídoto um
pouco menos, Luz e Barreira são raros de verdade.

**Leia em voz alta**

> O mural não parece trancado. Parece paciente. Os encaixes estão ali, claros
> demais para serem decorativos, como se a parede soubesse que a maior parte
> das pessoas vai olhar, entender metade e ir embora antes de pagar o preço
> inteiro de tentar.

**O que está em jogo**

- Esta é a hora em que pista vira investimento real.
- O custo dos cristais faz a solução pesar de verdade.
- Resolver o mural bem muda como o grupo olha para o castelo inteiro.

**Estrutura em beats**

1. Reunir os 5 cristais — isso sozinho é uma sub-quest de comércio/troca
   entre jogadores ou lojas (Luz e Barreira provavelmente exigem
   negociação real, não só Col).
2. Aplicar a sequência decifrada em `castelo_01`: Teleporte → Cura →
   Antídoto → Luz → Barreira.
3. Encaixar os cristais na ordem — cada encaixe errado ativa um alarme
   sonoro leve, não uma armadilha letal.
4. Ao completar a sequência certa, a passagem parcial se abre.

**Testes sugeridos**

- d20+Destreza — o encaixe físico dos cristais (precisão manual)
- d20+Inteligência — confirmar a sequência antes de começar a encaixar (evita erro caro)

**Complicação**

Numa falha (6-), o grupo erra a combinação e precisa esperar antes de
tentar de novo (o mural "reseta" depois de um tempo) — e o alarme sonoro
de um erro anterior já pode ter chamado atenção de guardas, tornando
tentativas futuras mais arriscadas.

**Complicações úteis**

- O grupo tem os cristais certos, mas hesita sobre a ordem no pior momento.
- Um guarda escuta o alarme parcial e decide ficar por perto.
- Um cristal raro precisa ser “emprestado” de alguém que vai cobrar depois.
- O grupo resolve, mas não consegue fingir que aquilo foi barato.

**Recompensas**

Acesso a uma câmara pequena (não a Dungeon Oculta principal) com uma
inscrição cifrada citando "a recompensa do golpe final" — a primeira
pista real e concreta do mistério do andar 2 (ver `docs/misterio_andar2.md`),
sem precisar enfrentar o Scavenge Toad. Col 0 — o valor aqui é
inteiramente informacional.

**Gancho visual / de transmissão**

- O clique de cada cristal encaixando na ordem certa.
- O erro soando baixo demais para ser confortável.
- A parede finalmente cedendo.

**Gancho pra próxima quest**

Resolver o mural deixa o grupo olhando o resto do castelo com outros
olhos.

---

### `castelo_03_rachadura_na_muralha` — Rachadura na Muralha

**Tipo:** Investigação · **Dificuldade:** Médio · **Região:** Castelo de Ferro Negro

**Requer:** `castelo_02_cinco_cristais` · **Desbloqueia:** `castelo_04_guarda_insone`

**Gancho**

Com o pátio já examinado de perto, alguém nota uma fenda fina na pedra da
muralha, escondida atrás de uma trepadeira — pode ser só desgaste, ou
pode ser um ponto fraco real na defesa do castelo.

**Leia em voz alta**

> A rachadura quase não quer ser encontrada. Fina, escondida e fácil de chamar
> de desgaste comum se ninguém estiver olhando com a cabeça certa. Mas depois
> do mural, o grupo já sabe que o castelo recompensa gente que insiste no detalhe.

**O que está em jogo**

- Pequena descoberta, grande implicação.
- A cena reforça que o castelo tem camadas e olhos por perto.
- É boa para tensão baixa com risco social alto.

**Estrutura em beats**

1. Exame da fenda — precisa de proximidade real, não dá pra avaliar de
   longe.
2. Decisão: investigar abertamente (risco de ser visto) ou esperar um
   momento de menor movimento de guardas.
3. Confirmação — é ponto fraco real ou só pedra velha.

**Testes sugeridos**

- d20+Destreza — investigar sem ser notado

**Complicação**

Numa falha, o grupo é visto de longe por um guarda — não gera confronto
imediato, mas planta desconfiança que pode aparecer depois (o Guarda
Insone comenta sobre isso em `castelo_04`).

**Recompensas**

Col 0 + informação estratégica real (10+: ponto fraco confirmado e
guardado em segredo; 7-9: confirmado mas visto; 6-: nada encontrado,
parede só velha mesmo) — uso puramente narrativo/tático do mestre.

**Gancho visual / de transmissão**

- A trepadeira saindo e revelando a fenda.
- O grupo parando de falar para ouvir se alguém viu.
- O detalhe pequeno parecendo grande demais depois.

---

### `castelo_04_guarda_insone` — O Guarda Insone Viu Algo

**Tipo:** Diálogo · **Dificuldade:** Médio · **Região:** Castelo de Ferro Negro · **NPC:** Guarda Insone (`npcs/guarda_insone.md`)

**Requer:** `castelo_03_rachadura_na_muralha` · **Desbloqueia:** `castelo_05_quem_mais_sabe`

**Gancho**

Ele vigia o mesmo posto sozinho, mesmo fora do turno — os outros guardas
acham estranho e preferem não comentar. Se alguém viu o grupo mexendo no
pátio ou na muralha, foi ele.

**Leia em voz alta**

> O Guarda Insone tem o tipo de cansaço que não vem de uma noite mal dormida.
> Vem de repetir para si mesmo uma coisa que ninguém quer ouvir até ela soar
> paranoia até para quem viu de perto. Quando ele olha para o grupo, dá para
> sentir que ele mede risco antes de confiança.

**O que está em jogo**

- Se a conversa encaixar, ele vira uma ponte rara entre suspeita e confirmação.
- Se encaixar mal, ele se fecha e o grupo perde a forma mais humana de validar a pista.
- A cena vende desconforto sem precisar de ameaça.

**Estrutura em beats**

1. Abordagem durante a noite — de dia ele não confia na própria voz por
   perto de outros guardas.
2. Ele já sabe (ou desconfia) do que o grupo andou fazendo — a conversa
   começa em terreno desconfortável se `castelo_03` teve complicação.
3. Ele confirma ou nega o que viu, dependendo de como é abordado.

**Testes sugeridos**

- d20+Sabedoria — conduzir a conversa sem parecer ameaçador ou desesperado

**NPCs na cena**

- **Guarda Insone** — quer que alguém confirme que ele não está enlouquecendo,
  sem se expor demais pra isso.
- **Responde:** o que viu (ou jura ter visto) perto da muralha, há quanto
  tempo o posto virou fixação pessoal.
- **Recusa:** admitir isso na frente de outros guardas, de dia, ou pra
  qualquer um que pareça querer usar a informação contra o castelo.
- **Se pressionado:** quase confirma tudo, recua, e só solta o resto se o
  grupo mantiver a calma em vez de insistir.

**Complicação**

Se `castelo_03` teve falha no teste de Reflexo (foi visto), este teste
começa com desvantagem — o mestre pode narrar que ele já está de
guarda alta antes mesmo da conversa começar.

**Recompensas**

Col 0 + confirmação com detalhes (10+), confirmação parcial e desconfiada
(7-9), ou negação total mesmo sabendo (6- — o grupo percebe que ele está
mentindo, o que também é informação útil).

**Gancho visual / de transmissão**

- O posto vazio demais para um castelo daquele tamanho.
- O momento em que ele quase fala e recua.
- A confirmação vindo mais pelo jeito do que pela frase.

---

### `castelo_05_quem_mais_sabe` — Quem Mais Sabe

**Tipo:** Investigação ampla · **Dificuldade:** Difícil · **Região:** Castelo de Ferro Negro → Tolbana

**Requer:** `castelo_04_guarda_insone` · **Desbloqueia:** `castelo_06_segredo_guardado`

**Gancho**

As pistas do mural cruzam com o que o beta tester de
`tolbana_07_boato_do_betatester` (cadeia H) sabe — se ambas as quests
estiverem em andamento na mesma campanha, esse é o ponto onde as linhas
se encontram.

**Leia em voz alta**

> Separadas, as pistas parecem promissoras. Juntas, ficam perigosas. O grupo
> não está mais comparando rumores; está começando a montar um desenho que
> outras pessoas talvez tenham visto em parte e preferido não terminar.

**O que está em jogo**

- Esta é a quest de “amarrar fios” do castelo.
- Se o grupo cruzar bem as fontes, sai com um quadro incompleto, mas forte.
- Se cruzar mal, ganha uma teoria plausível o bastante para causar problema depois.

**Estrutura em beats**

1. Reunir tudo que o grupo já sabe — a inscrição do mural, a confirmação
   (ou não) do Guarda Insone, qualquer coisa já ouvida em Tolbana.
2. Cruzar as informações — algumas batem, outras se contradizem
   (red herrings misturados de propósito, ver `docs/misterio_andar2.md`).
3. Chegar a um quadro geral — ainda incompleto, mas mais sólido que
   qualquer fonte isolada.

**Testes sugeridos**

- d20+Inteligência — separar informação real de red herring ao cruzar as fontes

**Complicações úteis**

- Duas pistas reais parecem se contradizer até alguém perceber o contexto.
- O grupo quer certeza de algo que o material só permite suspeitar.
- Um red herring é emocionalmente mais convincente do que a verdade parcial.
- A teoria errada nasce elegante demais para ser descartada rápido.

**Complicação**

Numa falha, o grupo mistura pistas reais com red herrings e sai com uma
teoria plausível mas parcialmente errada — o mestre decide qual parte é
falsa, sem avisar o grupo.

**Recompensas**

Col 0 + visão mais completa do mistério do andar 2 — ainda incompleta de
propósito. Esse é o ponto mais próximo que a cadeia G chega de "revelar"
o mistério, e mesmo assim não entrega a resposta final.

**Gancho visual / de transmissão**

- Papéis, anotações e memórias finalmente postos lado a lado.
- O grupo percebendo que sabe “demais” sem saber o bastante.
- A teoria ficando forte antes de ficar segura.

---

### `castelo_06_segredo_guardado` — Segredo Guardado

**Tipo:** Decisão de grupo · **Dificuldade:** — (sem teste) · **Região:** Castelo de Ferro Negro

**Requer:** `castelo_05_quem_mais_sabe` · **Desbloqueia:** —

**Gancho**

O grupo agora sabe mais sobre o mural e o que ele esconde do que quase
qualquer um em Aincrad. A pergunta não é mais "o que descobrimos" — é "o
que fazemos com isso".

**Leia em voz alta**

> Descoberta boa nem sempre pede anúncio. Às vezes pede estômago. O grupo está
> sentado em informação que vale poder, atenção, favor e problema. A decisão
> daqui não muda a verdade do mural. Muda quem passa a orbitar o grupo depois.

**O que está em jogo**

- Esta é a escolha política da cadeia do castelo.
- O segredo em si já foi encontrado; agora importa administração de consequência.
- A cena funciona melhor quando cada personagem revela o que faria com poder imperfeito.

**Estrutura em beats**

1. Cena de decisão — contar pra uma guilda (qual? por quê?), vender a
   informação a corretores, ou guardar pra uso próprio no futuro raid.
2. Consequência — cada escolha muda quem se interessa pelo grupo dali em
   diante (guildas curiosas, corretores oferecendo negócio, ou silêncio
   estratégico que só o grupo controla).

**Sem teste** — decisão de roleplay, efeito de longo prazo definido pelo
mestre.

**Complicações úteis**

- Guardar segredo custa mentir para gente confiável.
- Contar a alguém útil atrai atenção de gente menos útil.
- Vender informação resolve uma necessidade curta e cria um problema longo.
- O grupo concorda no conteúdo, mas não no destinatário.

**Recompensas**

Consequência narrativa: reputação, alvo de interesse de guildas (positivo
ou incômodo, conforme a escolha), ou vantagem silenciosa e real no futuro
raid contra Illfang (`tolbana_12_o_raid_contra_illfang`) se o grupo
guardar a informação estratégica pra usar na hora certa.

**Gancho visual / de transmissão**

- O mapa, a anotação ou a lembrança importante no centro da roda.
- O silêncio antes de alguém defender vender a informação.
- A sensação de que a descoberta pesou mais depois de resolvida.

**Fecha a cadeia G.**

---

## Cadeia H — Preparativos do Raid

Ponte entre `04_o_caminho_ate_o_labirinto.md` e o confronto com Illfang.
`tolbana_05_reconhecimento_do_labirinto` é o `desbloqueia` já registrado
no frontmatter de `04_o_caminho_ate_o_labirinto.md`. Esta é a cadeia mais
longa e mais "canônica" do andar — segue de perto o que acontece no anime
antes do raid: Diavel organizando a força-tarefa, corretores de
informação, a tensão de um grupo grande se formando pela primeira vez.

### `tolbana_05_reconhecimento_do_labirinto` — Reconhecimento do Labirinto

**Tipo:** Investigação · **Dificuldade:** Médio · **Região:** Labirinto (entrada)

**Requer:** `04_o_caminho_ate_o_labirinto` · **Desbloqueia:** `tolbana_06_fragmentos_sem_amassar`, `tolbana_07_boato_do_betatester`

**Gancho**

Antes de qualquer raid organizado, alguém precisa entrar e mapear o
primeiro trecho de verdade — não como quem passa correndo, mas como quem
presta atenção em rota de patrulha, becos sem saída e pontos de
descanso seguro.

**Leia em voz alta**

> O Labirinto muda o som do grupo antes de mudar qualquer outra coisa. Passo,
> respiração, metal, tecido: tudo volta mais seco, como se a pedra mastigasse
> o eco e cuspisse só o que importa. Entrar ali para “olhar” já parece mentira
> na primeira curva.

**O que está em jogo**

- Se o grupo fizer isso bem, chega ao raid como gente que sabe do que está falando.
- Se fizer mal, ainda ajuda a história a andar, mas espalha confiança torta.
- A cena serve para vender disciplina como heroísmo, não covardia.

**Estrutura em beats**

1. Entrada controlada — o grupo já viu o Labirinto de fora
   (`04_o_caminho_ate_o_labirinto`); agora entra com propósito de
   reconhecimento, não de progresso.
2. Mapeamento do primeiro trecho — rotas de patrulha de Ruin Kobold
   Trooper, becos sem saída, pontos onde a luz das tochas cria sombra
   suficiente pra descanso seguro.
3. Um encontro evitável — o grupo pode escolher observar de longe uma
   patrulha em vez de engajar, testando a disciplina de "reconhecimento,
   não combate".
4. Registro — o mapa (mental ou literal, se o grupo tiver um Cartógrafo)
   vira recurso real pra força-tarefa maior.

**Testes sugeridos**

- d20+Inteligência — mapear o layout com precisão
- d20+Destreza — evitar engajamento desnecessário com uma patrulha

**NPCs na cena**

- **Força-tarefa de Tolbana (indireta)** — quer mapa confiável, não bravata.
- **Responde:** quem paga por informação boa, quem já tentou entrar antes,
  como outros grupos descrevem o primeiro trecho.
- **Recusa:** tratar reconhecimento como glória; isso é trabalho ingrato.
- **Se pressionado:** alguém admite que prefere mentir que entrou fundo a
  confessar que recuou cedo.

**Encontro (opcional)**

1 Ruin Kobold Trooper em patrulha (ameaça comum, golpes 3-4) — só se o
grupo escolher (ou for forçado a) engajar.

**Complicação**

Numa falha no teste de Conhecimento, o mapa sai errado — não trava a
quest, mas o mestre pode usar isso mais tarde: uma "patrulha extra"
inesperada durante uma cena futura, porque a informação registrada estava
incompleta.

**Complicações úteis**

- O mapa sai certo, mas o grupo deixa marca de presença.
- O grupo evita combate, mas perde uma rota segura por hesitar.
- A patrulha não vê o grupo, mas ouve alguma coisa e muda o padrão.
- Um personagem jura ter ouvido algo maior do que os outros ouviram.

**Recompensas**

Col 60 + vantagem tática registrada pro raid (o mestre concede um bônus
situacional numa cena futura envolvendo o Labirinto, condizente com o
grupo "conhecer o terreno").

Em sucesso total, o grupo ganha também autoridade narrativa: em Tolbana,
alguém vai querer ouvir o relato deles inteiro.

**Gancho visual / de transmissão**

- O som do grupo mudando dentro do Labirinto.
- A patrulha passando perto demais sem ver ninguém.
- O momento em que o mapa vira “prova” em vez de só anotação.

---

### `tolbana_06_fragmentos_sem_amassar` — Fragmentos Sem Amassar

**Tipo:** Caça · **Dificuldade:** Médio · **Região:** Labirinto (entrada)

**Requer:** `tolbana_05_reconhecimento_do_labirinto` · **Desbloqueia:** —

**Gancho**

O Ferreiro que serve a força-tarefa organizada por Diavel precisa de
Fragmento de Armadura Kobold intacto — material de caça exclusivo,
extraído do corpo de um Ruin Kobold recém-abatido, não comprado em loja
nenhuma.

**Leia em voz alta**

> O ferreiro de Tolbana não fala como artesão pedindo favor. Fala como alguém
> fazendo conta com vidas. Ele bate com o dedo num pedaço amassado de metal
> kobold sobre a bancada e diz que aquilo não serve. Não para uma lâmina que
> vai entrar na sala do chefe. O grupo não precisa só matar um kobold. Precisa
> trazer dele a parte certa, do jeito certo, antes que o corpo perca valor.

**O que está em jogo**

- Se o grupo entregar material bom, ajuda o raid antes mesmo da luta começar.
- Se falhar na extração, aprende que “vencer combate” e “trazer recurso” são
  competências diferentes.
- A cena ajuda a fazer preparo parecer heroísmo também.

**Estrutura em beats**

1. Localizar e enfrentar um Ruin Kobold Trooper ou Sentinel — combate
   direto, não emboscada.
2. Extração cuidadosa do fragmento imediatamente após a vitória — o
   material se degrada rápido se não for extraído logo.
3. Entrega ao Ferreiro em Tolbana.

**Testes sugeridos**

- d20+Força ou Reflexo — o combate em si (ameaça comum, golpes 3-4)
- d20+Destreza — extrair o fragmento sem amassar (d20+Destreza, ver
  `docs/economia_profissoes.md` — material de caça exclusivo do Caçador)

**NPCs na cena**

- **Ferreiro da força-tarefa** — quer metal confiável, não intenção boa.
- **Responde:** por que o fragmento precisa sair inteiro, o que pretende fazer
  com ele, qual erro de luta costuma amassar a peça.
- **Recusa:** fingir que sucata serve só porque o grupo tentou.
- **Se pressionado:** admite que está com medo de mandar gente mal equipada
  para um chefe de andar.

**Complicação**

Numa falha no teste de extração, o combate "vira briga feia" — o corpo é
danificado demais durante a luta e o fragmento é perdido, exigindo um
segundo Ruin Kobold pra tentar de novo.

**Complicações úteis**

- O fragmento sai quase bom, mas o grupo precisa decidir se entrega assim mesmo.
- Outro grupo viu a luta e quer comprar o material na volta.
- O corpo cai em posição ruim e a extração vira urgência sob risco de patrulha.
- O ferreiro reconhece, pelo dano da peça, exatamente como o grupo lutou.

**Recompensas**

Col 100 + Fragmento de Armadura Kobold (Incomum) — insumo de qualidade
pra `docs/economia_profissoes.md` (Lâmina Reforçada do Ferreiro). Entregar
ao Ferreiro da força-tarefa também rende reconhecimento visível entre
quem está se preparando pro raid.

**Gancho visual / de transmissão**

- O ferreiro rejeitando metal amassado como quem rejeita descuido.
- O momento da extração ainda com o corpo quente.
- A peça intacta virando algo “importante de verdade” na mão dele.

---

### `tolbana_07_boato_do_betatester` — Boato do Betatester

**Tipo:** Diálogo · **Dificuldade:** Difícil · **Região:** Tolbana · **NPC:** beta tester (crie na hora — ver "quem sabe o que" em `docs/misterio_andar2.md`)

**Requer:** `tolbana_05_reconhecimento_do_labirinto` · **Desbloqueia:** `tolbana_08_reuniao_com_diavel`

**Gancho**

Corre um boato específico: um dos jogadores que participou do beta
fechado de SAO está em Tolbana, e evita conversar sobre o que sabe do
sistema do jogo — mas não porque não sabe nada.

**Leia em voz alta**

> Em Tolbana, boato tem dono por no máximo meia hora. Depois disso vira moeda.
> O nome do beta tester não vem inteiro em lugar nenhum; vem em fragmentos de
> descrição, em gente falando baixo demais e em olhares que param num mesmo
> canto da praça mais do que deveriam. O grupo não está caçando uma pessoa.
> Está caçando alguém que já aprendeu a não ser encontrado.

**O que está em jogo**

- Se conseguirem falar com ele do jeito certo, ganham uma das poucas pistas
  legítimas do andar.
- Se pressionarem demais, viram só mais um grupo atrás de vantagem.
- A cena serve para vender que informação em Aincrad tem peso emocional, não
  só valor de mercado.

**Estrutura em beats**

1. Localizar o beta tester — ele não se anuncia, o grupo precisa perguntar
   por aí ou reconhecer sinais (equipamento levemente diferente, jeito de
   falar sobre o jogo como quem já viu por trás da cortina).
2. Primeira abordagem — ele é evasivo por padrão, treinado a não confiar
   fácil (já foi abordado por corretores antes, sem gostar da experiência).
3. Se o grupo for paciente e genuíno, ele solta uma pista real, mas
   parcial, sobre o "quem sabe o que" do mistério do andar 2 — nunca a
   resposta inteira.

**Testes sugeridos**

- d20+Inteligência — reconhecer os sinais de que essa pessoa é mesmo
  quem o boato diz
- d20+Sabedoria — conduzir a conversa sem parecer só mais um caçador de
  informação

**NPCs na cena**

- **Beta tester** — quer ficar útil sem virar fonte pública.
- **Responde:** o que viu no beta que ainda reconhece no jogo atual, onde a
  memória falha, por que evita corretores.
- **Recusa:** qualquer pergunta que soe como “me dá a resposta pronta”.
- **Se pressionado:** fecha o corpo, encerra a conversa e sai sem olhar para trás.

**Complicação**

Numa falha no teste de Espírito, ele se fecha — acha que o grupo está
"puxando informação demais, rápido demais", igual todo mundo que já
tentou. Não é hostil, só encerra a conversa; reabrir exige uma abordagem
bem diferente depois (talvez via `tolbana_e03`/`tolbana_e06`, se essas
quests já tiverem sido feitas).

**Complicações úteis**

- O grupo encontra a pessoa certa, mas no lugar errado para conversar bem.
- Alguém escuta metade da conversa e entende tudo errado.
- O beta tester solta uma pista real junto com uma defesa emocional forte.
- Um corretor percebe o interesse do grupo e passa a segui-los de longe.

**Recompensas**

Col 0 + pista real (mas parcial) sobre o andar 2 — uma das fontes
legítimas listadas em `docs/misterio_andar2.md`. Sucesso total (10+)
rende também um comentário passageiro sobre Diavel estar organizando algo
grande — gancho direto pra `tolbana_08`.

**Gancho visual / de transmissão**

- O grupo identificando alguém “que sabe” só pelo jeito de falar do jogo.
- A conversa curta demais, tensa demais, com informação boa demais no meio.
- O beta tester indo embora logo depois de largar uma pista real.

---

### `tolbana_08_reuniao_com_diavel` — Reunião com Diavel

**Tipo:** Diplomacia · **Dificuldade:** Difícil · **Região:** Tolbana · **NPC:** Diavel

**Requer:** `tolbana_07_boato_do_betatester` · **Desbloqueia:** `tolbana_09_abastecendo_o_grupo`, `tolbana_10_ultima_noite_em_tolbana`

**Gancho**

Diavel — o jogador que descobriu a sala do chefe e está montando a força-
tarefa pra enfrentar Illfang — está reunindo grupos dispostos a participar.
Ele não aceita qualquer um: quer saber se o grupo entende o risco real
(morte permanente) e se tem preparo o suficiente.

**Leia em voz alta**

> O anfiteatro de Tolbana não está cheio de heróis. Está cheio de gente tentando
> parecer pronta. Quando Diavel sobe no tablado, a conversa cai um pouco antes
> de ele levantar a mão. Ele fala como alguém que já aceitou que algumas dessas
> pessoas não voltam, e mesmo assim está tentando fazer o melhor com isso.

**O que está em jogo**

- Se o grupo convencer Diavel, entra no raid com função e reconhecimento.
- Se não convencer, ainda pode entrar na história, mas sem o mesmo peso.
- A cena precisa vender liderança, ego, nervosismo e esperança ao mesmo tempo.

**Estrutura em beats**

1. A reunião geral — Diavel se dirige a vários grupos de uma vez,
   explicando o plano e o risco com honestidade que impressiona (ele é
   assim no anime: carismático, direto, genuinamente preocupado com
   vidas, não só com glória).
2. Avaliação individual — ele conversa com o grupo à parte, perguntando
   sobre experiência, equipamento, e o que já sabem sobre o Labirinto
   (bônus se `tolbana_05`/`tolbana_06` já foram feitas).
3. Decisão de Diavel — aceita o grupo como participante pleno, como apoio
   vigiado, ou pede pra provarem valor antes.

**Testes sugeridos**

- d20+Sabedoria — convencer Diavel da disposição real do grupo
- d20+Inteligência — impressionar com informação concreta sobre o
  Labirinto (bônus automático se `tolbana_05` foi 10+)

**NPCs na cena**

- **Diavel** — quer gente viva na porta do chefe, não mártires bonitos.
- **Responde:** plano, risco, papel esperado de cada grupo, onde a linha pode quebrar.
- **Recusa:** prometer segurança ou tratar imprudência como coragem.
- **Se pressionado:** não perde a calma, mas a exaustão aparece por um segundo.

- **Outros grupos** — querem vaga, prestígio e direito de dizer que estavam lá.
- **Responde:** o que fizeram, o que sabem, onde acham que brilham.
- **Recusa:** ser tratados como figurantes de outro grupo.
- **Se pressionados:** a conversa vira disputa de ego em dois passos.

**Complicação**

Numa falha, Diavel não expulsa o grupo — ele é gentil demais pra isso —
mas pede que provem valor primeiro. O mestre pode usar `tolbana_06` (se
ainda não feita) como essa prova, ou inventar uma tarefa equivalente.

**Complicações úteis**

- O grupo impressiona Diavel, mas compra antipatia de outra equipe.
- Alguém fala bem demais e parece arrogante em vez de pronto.
- Diavel reconhece valor, mas exige prova concreta antes da vaga plena.
- Um boato errado vindo de Tolbana entra na conversa na pior hora.

**Recompensas**

Vaga confirmada no raid — plena (10+) ou condicional/vigiada (7-9). Falha
não fecha a porta, só atrasa: Col 0, mas a reunião planta o grupo
firmemente dentro da narrativa do raid que vem.

**Gancho visual / de transmissão**

- O anfiteatro cheio de jogadores tentando não demonstrar medo.
- A primeira vez que Diavel fala “morte permanente” e ninguém ri.
- O momento em que o grupo percebe se foi aceito ou só tolerado.

---

### `tolbana_09_abastecendo_o_grupo` — Abastecendo o Grupo

**Tipo:** Comércio · **Dificuldade:** Médio · **Região:** Tolbana

**Requer:** `tolbana_08_reuniao_com_diavel` · **Desbloqueia:** —

**Gancho**

Com a vaga no raid confirmada, o grupo tem um período curto pra se
equipar direito — poções, reparos, qualquer arma ou armadura melhor que
o Col disponível permita. Não é hora de economizar.

**Leia em voz alta**

> Tolbana em véspera de raid parece feira e quartel ao mesmo tempo. Ferreiro
> sem dormir, alquimista cobrando adiantado, gente vendendo o que jurava que
> nunca venderia, grupo contando moeda como se isso pudesse comprar margem
> contra um chefe de andar. O problema não é só o que falta. É o que não dá
> para levar tudo junto.

**O que está em jogo**

- Comprar bem melhora a chance do grupo voltar vivo.
- Comprar mal não impede o raid, mas planta complicação concreta.
- A cena ajuda a transformar inventário em decisão dramática, não planilha.

**Estrutura em beats**

1. Levantamento do que falta — o grupo avalia o próprio inventário contra
   o que sabe sobre Illfang (duas fases, reforços de Ruin Kobold Sentinel).
2. Compras/negociação em Tolbana — Ferreiro, Alquimista, Comerciante,
   conforme o que cada personagem precisa.
3. Decisão de prioridade se o Col não for suficiente pra tudo.

**Testes sugeridos**

- d20+Inteligência — priorizar as compras certas com o Col disponível

**NPCs na cena**

- **Comerciantes e artesãos de Tolbana** — querem vender, mas também ler o
  desespero do grupo.
- **Responde:** o que está em falta, o que chegou hoje, o que realmente vale levar.
- **Recusa:** fingir que ainda há estoque normal ou preço estável.
- **Se pressionados:** sobem preço, pedem favor ou escolhem para quem vendem.

**Recompensas**

Sem Col de recompensa aqui — é quest de gasto, não ganho. Sucesso total
(10+): inventário completo com sobra de Col. Parcial (7-9): essencial
coberto. Falha (6-): falta algo específico que o mestre anota e usa como
complicação real durante `tolbana_12`.

**Complicações úteis**

- O item certo existe, mas alguém do grupo precisa abrir mão de outra compra.
- Um NPC oferece desconto em troca de favor depois do raid.
- O grupo percebe tarde demais que todo mundo quer a mesma peça do estoque.
- Alguém vende algo pessoal para fechar a conta.

**Gancho visual / de transmissão**

- A bancada cheia de itens importantes e Col insuficiente.
- O grupo discutindo prioridade enquanto o tempo corre.
- A compra final parecendo menos “upgrade” e mais “aposta”.

---

### `tolbana_10_ultima_noite_em_tolbana` — Última Noite em Tolbana

**Tipo:** Roleplay puro · **Dificuldade:** — (sem teste obrigatório) · **Região:** Tolbana

**Requer:** `tolbana_08_reuniao_com_diavel` · **Desbloqueia:** `tolbana_11_formacao_da_estrategia`

**Gancho**

A noite antes do raid. A cidade está mais cheia que o normal — grupos
inteiros que vão participar da força-tarefa passam a noite em Tolbana,
cada um lidando com a tensão à própria maneira. Essa é a cena de
personagem, não de mecânica.

**Leia em voz alta**

> Tolbana à noite não parece cidade de descanso. Parece cidade prendendo a
> respiração. Tem lâmina sendo afiada tarde demais, oração sendo sussurrada por
> gente que nunca rezou, riso curto demais para ser alegria e silêncio longo
> demais para ser paz. Amanhã algumas dessas vozes somem.

**O que está em jogo**

- Esta é a melhor chance de transformar preparação em vínculo.
- O que for dito ou evitado aqui muda como o raid vai doer depois.
- A cena existe para premiar jogador que interpreta sem precisar “otimizar”.

**Estrutura em beats**

1. Ambientação — Tolbana à noite, cheia de gente que sabe que amanhã
   pode ser o último dia de alguém. Conversas em voz baixa, alguém bebendo
   demais, alguém rezando, alguém só quieto.
2. Cena de personagem — cada jogador tem espaço pra uma cena pessoal:
   uma confissão, uma despedida não dita, um momento de dúvida ou de
   determinação.
3. Interação de grupo — o vínculo entre os personagens (e com NPCs já
   conhecidos, se algum estiver por perto) se aprofunda antes do risco
   real do dia seguinte.

**Complicações úteis**

- Um personagem tenta parecer tranquilo e convence menos do que gostaria.
- Um NPC conhecido aparece só para desejar sorte e isso pesa mais do que devia.
- Alguém ouve, ao longe, um grupo brigando por medo disfarçado de estratégia.
- Um dos personagens percebe que ainda não disse algo que talvez merecesse ser dito.

**Teste opcional**

d20+Sabedoria, só se algum jogador quiser forçar um momento específico de
coragem ou confissão em cena — sucesso rende clareza emocional real;
falha rende um momento de vulnerabilidade não resolvida (também
interessante narrativamente, não é "punição").

**Recompensas**

Sem Col. Vínculo mecânico opcional: se a cena render bem, o mestre pode
conceder vantagem numa cena específica do raid (`tolbana_12`) pro
personagem que teve o momento mais forte — não obrigatório, só uma forma
de premiar boa interpretação.

**Gancho visual / de transmissão**

- A cidade acordada tarde demais.
- O silêncio entre uma fala íntima e a resposta.
- O corte perfeito para fim de episódio antes do raid.

---

### `tolbana_11_formacao_da_estrategia` — Formação da Estratégia

**Tipo:** Preparo tático · **Dificuldade:** Difícil · **Região:** Tolbana → Labirinto

**Requer:** `tolbana_10_ultima_noite_em_tolbana` · **Desbloqueia:** `tolbana_12_o_raid_contra_illfang`

**Gancho**

Na manhã do raid, a força-tarefa inteira se reúne pra formação final —
Diavel divide os grupos em funções (linha de frente, suporte, contenção
dos reforços de Ruin Kobold Sentinel). É a última chance de o grupo
definir seu papel antes do combate real.

**Leia em voz alta**

> A praça improvisada de Tolbana está cheia de gente armada tentando parecer
> mais pronta do que está. Todo mundo fala mais baixo do que deveria para um
> grupo tão grande. Quando Diavel começa a explicar o plano, ninguém interrompe
> — e isso, por si só, já deixa claro o tamanho do medo.

**O que está em jogo**

- Se o grupo conseguir um papel que combine com o que sabe fazer, entra no
  raid com moral e clareza.
- Se falhar, não perde o direito de participar — perde conforto e margem de erro.
- A cena mostra que raid não é só boss fight; é ego, coordenação e confiança.

**Estrutura em beats**

1. Briefing geral de Diavel — ele expõe o plano: como as duas fases de
   Illfang funcionam, e como os Sentinels reforçam ao longo da luta
   (3 no início, +3 a cada barra de HP perdida).
2. Negociação de papel — o grupo argumenta por uma função específica com
   base no que sabe fazer bem (combate direto, suporte, controle de
   reforços).
3. Atrito possível — nem todo grupo consegue o papel que quer; outros
   grupos da força-tarefa também estão disputando posição.

**Testes sugeridos**

- d20+Inteligência — argumentar a própria posição com base em preparo real (bônus se `tolbana_05`/`tolbana_06`/`tolbana_09` foram bem-sucedidas)

**NPCs na cena**

- **Diavel** — quer ordem, mas precisa vender essa ordem para dezenas de pessoas.
- **Responde:** plano, função de cada frente, onde estão os maiores riscos.
- **Recusa:** prometer que todo mundo volta.
- **Se pressionado:** segura a postura, mas deixa passar um traço de exaustão.

- **Outros líderes de grupo** — querem espaço, reconhecimento e chance de sair
  da sala do chefe como “os que fizeram a diferença”.
- **Responde:** o que acham do plano, onde acham que brilharão.
- **Recusa:** ceder papel sem resistência.
- **Se pressionados:** transformam debate tático em atrito pessoal.

**Complicação**

Numa falha, há confusão de comando — não é culpa do grupo especificamente,
é o tamanho da força-tarefa gerando ruído. O mestre pode usar isso como
uma complicação real durante `tolbana_12` (ex: reforço chegando em
momento inesperado por causa de coordenação falha).

**Complicações úteis**

- O grupo consegue o papel, mas compra rivalidade de outro grupo.
- Diavel aceita o argumento, mas exige prova rápida ou compromisso duro.
- Um boato vindo de `tolbana_07`/`tolbana_09` bagunça a confiança na sala.
- Alguém importante interpreta cautela como medo, ou agressividade como imprudência.

**Recompensas**

Vantagem tática real registrada pro confronto final (10+: papel ideal,
bônus mecânico claro; 7-9: papel definido, sem bônus extra; 6-:
desvantagem registrada, usada pelo mestre como complicação em
`tolbana_12`).

**Gancho visual / de transmissão**

- Várias equipes armadas tentando esconder nervosismo ao mesmo tempo.
- O silêncio antes de alguém discordar do plano em voz alta.
- A função final do grupo sendo definida como se fosse escalação de guerra.

---

### `tolbana_12_o_raid_contra_illfang` — O Raid Contra Illfang

**Tipo:** Combate de chefe · **Dificuldade:** Chefe (fora da escala normal) · **Região:** Labirinto (sala do chefe / Covil de Illfang)

**Requer:** `tolbana_11_formacao_da_estrategia` · **Desbloqueia:** —

**Gancho**

A força-tarefa inteira entra na sala do chefe, organizada em grupos
conforme a formação decidida em `tolbana_11`. Este é o clímax de toda a
cadeia H — e de boa parte da primeira metade da campanha no andar 1.

**Leia em voz alta**

> A porta da sala do chefe abre devagar o suficiente para ninguém ter desculpa
> de não sentir o peso daquilo. O ar muda antes da visão inteira entrar. O
> espaço é grande demais, o silêncio é limpo demais e, quando Illfang se mexe,
> todo mundo entende ao mesmo tempo que treino e coragem não são a mesma coisa.

**O que está em jogo**

- É o primeiro grande teste coletivo do andar.
- O grupo não precisa ser “o centro exclusivo” para ser memorável.
- A luta precisa alternar espetáculo, caos e pequenos gestos de heroísmo.

**Estrutura em beats**

1. Entrada coordenada — múltiplos grupos entrando em sequência conforme
   o plano, tensão alta, silêncio quebrado só pelo som dos próprios
   passos.
2. **Fase 1** de Illfang — machado e escudo tipo broquel, dano de curto
   alcance, reforçado por 3 Ruin Kobold Sentinels desde o início.
3. **Fase 2** — ao esvaziar a última barra de HP até 1/3, Illfang descarta
   machado e escudo e passa a usar um nodachi, ganhando Skills de katana —
   o momento icônico em que um grupo desavisado pode ser pego de
   surpresa. Mais 3 Sentinels a cada barra de HP esvaziada (até 12 no
   total ao longo da luta).
4. O golpe final — quem desfere é quem recebe o Last Attack Bonus (ver
   `docs/misterio_andar2.md`: o item "Cristal de Ascensão" é o gatilho
   real pro andar 2, não a morte do chefe em si — isso NÃO é revelado
   automaticamente ao grupo).

**Estrutura de combate**

Ver `monstros/illfang_the_kobold_lord.md` pra ficha completa: 4 barras de
HP, 6-8 golpes cada (24-32 total). Ver `monstros/ruin_kobold_sentinel.md`
pros reforços. Este é conteúdo de raid — o grupo do jogador é uma peça
entre várias, não o centro exclusivo da cena; o mestre narra a força-
tarefa como um todo reagindo em conjunto.

**Testes sugeridos**

- Testes de combate padrão conforme a arma/skill de cada personagem
- d20+Sabedoria — manter a coordenação e a calma durante a transição de
  fase (fase 2 pega muita gente de surpresa, inclusive NPCs)

**Complicações úteis**

- Um grupo aliado quebra formação e abre um problema novo.
- Um Sentinel atravessa a linha errada e muda a prioridade do grupo.
- A troca de arma de Illfang pega alguém no lugar pior possível.
- O último golpe vira disputa tensa entre necessidade e ego.

**Recompensas**

XP muito alto + Col alto + equipamento de drop de chefe (raridade Raro+,
à escolha do mestre) + o gancho de virada pro fim do andar 1: quem
desferir o golpe final recebe o Cristal de Ascensão — guardado pelo
mestre, não anunciado ao grupo. O que fazem com ele (ou se nem percebem
a importância no calor do momento) define o próximo arco da campanha.

**Gancho visual / de transmissão**

- A porta abrindo para a sala do chefe.
- A primeira vez que Illfang muda de arma.
- O segundo de silêncio depois do golpe final.

**Fecha a cadeia H — e a primeira grande jornada do andar 1.**

---

## Cadeia I — Contratos Avulsos

Sem pré-requisito entre si — cada uma standalone, ligada a um ponto
específico já existente no mapa (`scripts/web/dados_mapa.js`). Servem de
conteúdo de preenchimento entre as cadeias principais: uma sessão que
ficou curta, um grupo que quer variedade sem se comprometer com uma
cadeia inteira.

### `bounty_01_sentinela_esquecida` — Sentinela Esquecida

**Tipo:** Combate · **Dificuldade:** Difícil · **Região:** Campo de Ruyn

**Requer:** — · **Desbloqueia:** —

**Gancho**

No meio do Campo de Ruyn — planície de ruínas onde uma batalha esquecida
aconteceu antes mesmo do jogo começar (ou assim parece) — uma silhueta
fica parada tempo demais pra ser só uma pedra. Só se move se alguém
chegar perto.

**Leia em voz alta**

> O Campo de Ruyn já parece depois de alguma coisa. Por isso a silhueta parada
> ali se mistura tão bem ao resto até o instante em que o grupo percebe que
> está imóvel do jeito errado: não como ruína, mas como vigia.

**O que está em jogo**

- Esta bounty funciona melhor como duelo contra algo que parece resto de guerra.
- O medo bom aqui vem do atraso entre notar e confirmar.
- É simples, mas pode ficar memorável com imagem forte.

**Estrutura em beats**

1. Aproximação — de longe, é indistinguível de uma estátua ou ruína.
2. Confirmação de que é uma ameaça real — ela reage a proximidade, não a
   barulho.
3. Combate — postura defensiva até ser provocada, depois ataca com força
   total.

**Testes sugeridos**

- d20+Inteligência — perceber que não é uma ruína antes de chegar perto demais
- d20+Destreza ou Corpo — o combate em si (ameaça forte, golpes 5-7)

**Encontro**

1 Sentinela Esquecida (ameaça forte, golpes 5-7, atributo de fraqueza
Técnica).

**Recompensas**

Col 150 + material incomum. Não persegue além do campo — recuar em caso
de dificuldade é sempre uma opção segura, sem penalidade.

**Gancho visual / de transmissão**

- A silhueta deixando de parecer pedra.
- O primeiro movimento seco demais para ser orgânico.
- O campo inteiro parecendo assistir ao combate.

---

### `bounty_02_luz_errante` — Luz Errante

**Tipo:** Investigação/Puzzle · **Dificuldade:** Médio · **Região:** Bosque de Ashwen

**Requer:** — · **Desbloqueia:** —

**Gancho**

Um pontinho de luz se move devagar entre os troncos do Bosque de Ashwen,
sempre a uma certa distância de quem observa — nunca perto demais, nunca
longe o suficiente pra desaparecer de vez.

**Leia em voz alta**

> A luz não corre de vocês. Também não espera. Ela mantém exatamente a distância
> necessária para parecer convite se o grupo estiver curioso, ou armadilha se
> alguém no grupo já tiver bom senso demais.

**O que está em jogo**

- Esta bounty é ótima para clima, desconfiança e debate de mesa.
- O destino importa, mas o trajeto é o que vende a cena.
- Serve bem para sessões mais contemplativas com tensão baixa.

**Estrutura em beats**

1. Avistamento — a luz reage à presença do grupo, parece "convidar" a ser
   seguida.
2. Perseguição — mantém distância constante, testando a paciência de
   quem segue.
3. Resultado — leva a algum lugar real, ou some antes do fim.

**Testes sugeridos**

- d20+Sabedoria — manter o ritmo de perseguição sem se frustrar ou se perder

**Recompensas**

Revela outro ponto da região ainda não descoberto (10+: revela e chega
com segurança; 7-9: chega perto, mas a luz some antes do fim — revela
parcialmente, o mestre pode dar uma pista em vez do ponto completo; 6-:
perde a luz de vista, sem revelação).

**Gancho visual / de transmissão**

- A luz sempre longe o bastante.
- O grupo decidindo seguir mesmo sem garantia.
- O sumiço súbito dela perto do fim.

---

### `bounty_03_eco_estranho` — Eco Estranho

**Tipo:** Investigação/Puzzle · **Dificuldade:** Médio · **Região:** Caverna de Mournhall

**Requer:** — · **Desbloqueia:** —

**Gancho**

Dentro da Caverna de Mournhall, o eco dos próprios passos do grupo volta
errado — atrasado demais, ou vindo da direção errada, como se a caverna
tivesse uma geometria que os olhos não veem.

**Leia em voz alta**

> O primeiro eco errado parece detalhe. O segundo já entra na conversa. Quando
> a voz de alguém volta da direção que ninguém está olhando, a caverna deixa de
> parecer espaço e começa a parecer problema.

**O que está em jogo**

- Esta bounty existe para dar estranheza espacial sem precisar de monstro.
- Se o grupo entrar no clima, a caverna ganha muito valor de mesa.
- Funciona muito bem como pausa tensa entre combates mais diretos.

**Estrutura em beats**

1. Percepção do problema — precisa de silêncio e atenção real pra notar,
   fácil de atribuir a cansaço ou imaginação.
2. Investigação da fonte — seguir o eco até a área onde ele se comporta
   de forma mais estranha.
3. Descoberta (ou não) de uma passagem/câmara oculta que explica o
   fenômeno.

**Testes sugeridos**

- d20+Inteligência — perceber que a geometria não bate matematicamente com o que os olhos veem

**Complicação**

Numa falha, o grupo identifica a estranheza, mas erra o ponto exato de
origem — perde tempo, acende tocha demais, faz barulho demais ou entra
num ramo morto antes de voltar.

**Recompensas**

Revela outro ponto da região (10+: percebe e localiza algo oculto por
completo; 7-9: percebe o suficiente para marcar a área e voltar depois;
6-: entende o fenômeno, mas não acha a abertura certa naquela visita).

**Gancho visual / de transmissão**

- O eco vindo do lado errado.
- A caverna parecendo maior por dentro do que por fora.
- O grupo parando de confiar no próprio ouvido.

---

### `bounty_04_vista_do_topo` — Vista do Topo

**Tipo:** Exploração · **Dificuldade:** Médio · **Região:** Penhascos de Vaelor

**Requer:** — · **Desbloqueia:** —

**Gancho**

O ponto mais alto dos Penhascos de Vaelor promete uma vista que nenhum
mapa comprado consegue replicar — inclusive de trechos do andar ainda não
visitados pelo grupo.

**Leia em voz alta**

> Subir Vaelor não parece heroico no começo. Parece insistência. Pedra, vento,
> fôlego e céu demais. Mas quanto mais o grupo sobe, mais o andar inteiro vai
> mudando de escala, como se o mapa conhecido fosse só uma versão modesta do
> que existe de verdade.

**O que está em jogo**

- Esta bounty existe para premiar exploração pura.
- A vista vale porque muda a cabeça do grupo sobre o andar, não só o mapa.
- O risco aqui é mais de exposição e teimosia do que de combate.

**Estrutura em beats**

1. A subida — íngreme, ventosa, sem ser tecnicamente perigosa como as
   Montanhas de Grauvenn.
2. Um momento de risco real perto do topo — uma rajada de vento, uma
   pedra solta.
3. A vista, se alcançada — recompensa puramente de exploração/informação.

**Testes sugeridos**

- d20+Destreza — a subida em si, especialmente o trecho final

**Complicações úteis**

- O grupo chega ao topo, mas precisa largar algo para segurar equilíbrio.
- A rajada mais forte vem quando a recompensa já está quase à vista.
- Alguém percebe um ponto novo enquanto outro só quer descer logo.
- A vista revela coisa demais e muda prioridades do grupo na hora.

**Recompensas**

Revela pontos próximos ainda não descobertos no mapa (10+: chega com
segurança, revelação completa; 7-9: chega com um susto, revelação
parcial; 6-: desiste na subida, sem revelação — mas sem dano real).

**Gancho visual / de transmissão**

- O grupo ficando pequeno contra a borda do penhasco.
- A rajada final antes do topo.
- O mapa mental do andar se abrindo de uma vez.

---

### `bounty_05_colheita_ameacada` — Colheita Ameaçada

**Tipo:** Defesa · **Dificuldade:** Médio · **Região:** Terraços de Solveig · **NPC:** Guardião da Colheita / Fazendeiro Local (`npcs/fazendeiro_local.md`)

**Requer:** — · **Desbloqueia:** —

**Gancho**

Um monstro de campo está atacando a plantação dos Terraços de Solveig —
para os moradores, isso não é só prejuízo material, é "um mês sem plantar
de novo" (nas palavras do próprio Fazendeiro Local).

**Leia em voz alta**

> Os Terraços de Solveig são bonitos até alguém correr entre eles gritando.
> A plantação desce em degraus perfeitos pela encosta, e justamente por isso
> qualquer estrago parece pior: dá para ver a perda de longe. Gente demais
> está olhando para cima ao mesmo tempo, esperando descobrir de onde vem o
> próximo impacto.

**O que está em jogo**

- Se o grupo ignorar, a vila perde alimento, renda e calma ao mesmo tempo.
- Se lutar pensando só em matar, talvez vença tarde demais para salvar a safra.
- A cena funciona melhor quando a colheita parece personagem, não cenário.

**Estrutura em beats**

1. Chegada durante o ataque (ou logo antes, se o grupo for rápido) —
   urgência real, não é uma quest pra adiar.
2. Defesa da plantação — proteger a colheita é o objetivo, não
   necessariamente matar o monstro.
3. Resolução — o monstro foge, é abatido, ou a colheita é parcialmente
   perdida antes que o grupo consiga conter.

**Testes sugeridos**

- d20+Força — defender a plantação diretamente

**NPCs na cena**

- **Fazendeiro Local / Guardião da Colheita** — quer salvar o máximo possível,
  mesmo que o monstro escape.
- **Responde:** o que está mais ameaçado, onde a plantação quebra primeiro,
  quem ainda está lá em cima trabalhando.
- **Recusa:** abandonar a área sem antes tentar salvar alguma parte do cultivo.
- **Se pressionado:** escolhe uma fileira, um depósito ou uma pessoa como
  prioridade e isso muda a cena.

**Encontro**

1 monstro de campo (ameaça comum, à escolha do mestre conforme o
bestiário disponível).

**Complicações úteis**

- Salvar a plantação de cima expõe o grupo ao ataque.
- Salvar um trabalhador custa parte da colheita.
- O monstro foge e deixa destruição em vez de corpo.
- O grupo segura a linha, mas a água/terra dos terraços cede sob pressão.

**Recompensas**

Colheita de qualidade superior (ingrediente pro Cozinheiro) + reputação
local (10+: defende sem perda; 7-9: defende com perda parcial; 6-:
colheita destruída, o Guardião da Colheita fica abalado — reputação
neutra, não negativa, já que o grupo tentou).

Em sucesso total, o Fazendeiro Local guarda o nome do grupo e passa a
separar produto melhor quando eles aparecem.

**Gancho visual / de transmissão**

- Os terraços bonitos sendo destruídos degrau por degrau.
- A decisão entre salvar safra, trabalhador ou chance de abater o bicho.
- A visão do campo depois, deixando claro o que foi salvo e o que não foi.

---

### `bounty_06_caravana_emboscada` — Caravana Emboscada

**Tipo:** Investigação/Combate · **Dificuldade:** Difícil · **Região:** Estrada de Ombric (ponto "Ponto de Assalto")

**Requer:** — · **Desbloqueia:** —

**Gancho**

Marcas de luta antigas na Estrada de Ombric mostram que caravanas já
foram atacadas ali antes — a pergunta é se ainda tem alguém rondando a
área. Esta quest pode ser ligada diretamente a `tolbana_e07_guarda_costas_por_um_dia`
se ambas estiverem em jogo na mesma sessão, usando o mesmo encontro.

**Leia em voz alta**

> A Estrada de Ombric é larga o bastante para parecer segura até o chão começar
> a contar outra história. Madeira quebrada, trilha desviada, marca de roda
> que terminou rápido demais e silêncio nos lugares onde gente costumava
> diminuir o passo para conversar.

**O que está em jogo**

- Esta bounty pode ser simples, mas fica melhor quando a estrada parece ter memória.
- Se a ameaça ainda estiver ativa, o grupo pode impedir que outro erro se repita.
- A cena mistura leitura de terreno com confronto potencial.

**Estrutura em beats**

1. Investigação do local do assalto — marcas de luta, rastros, sinais de
   quanto tempo faz.
2. Avaliação: é um evento passado e encerrado, ou o padrão indica que vai
   se repetir?
3. Se ativo: confronto com quem ainda ronda a área (bandidos, ou um
   monstro territorial, à escolha do mestre).

**Testes sugeridos**

- d20+Inteligência — reconhecer o padrão do assalto e antecipar se é ameaça ativa

**Complicações úteis**

- O grupo lê o local certo, mas tarde demais para emboscar de volta.
- Um sinal falso faz parecer monstro quando era gente, ou o contrário.
- O inimigo observa antes de atacar e escolhe o pior momento.
- A estrada está vazia, mas a sensação de ataque recente continua forte.

**Encontro (se ativo)**

Pequeno grupo de assaltantes ou 1 monstro territorial (ameaça comum,
golpes 3-4).

**Complicação**

Numa falha, o grupo é pego de surpresa por quem ainda ronda o local — o
combate começa em desvantagem.

**Recompensas**

Col 120 + informação sobre quem anda assaltando a rota (útil pro mestre
usar em ganchos futuros de Tolbana).

**Gancho visual / de transmissão**

- O chão explicando o que aconteceu antes da fala de qualquer NPC.
- O grupo percebendo que a emboscada foi organizada, não caótica.
- A estrada aberta parecendo mais perigosa do que um corredor fechado.

---

### `bounty_07_recruta_precisa_de_prova` — Recruta Precisa de Prova

**Tipo:** Missão de guilda · **Dificuldade:** Fácil · **Região:** Posto de Kaldrin

**Requer:** — · **Desbloqueia:** —

**Gancho**

Um recruta novo de uma guilda local (Sindicato, LHUB, Dndalcin, iBarr's,
Terraço Geek ou Guilda de Nerds — à escolha do mestre) está tentando
provar valor pros veteranos e pede ajuda do grupo pra uma tarefa simples.

**Leia em voz alta**

> O recruta tenta falar como quem já pertence à guilda, mas a pressa entrega
> o contrário. Não é falta de coragem. É excesso de vontade de não parecer
> peso morto diante de gente que já tem nome, função e história.

**O que está em jogo**

- Esta bounty funciona muito melhor como cena de vínculo do que como tarefa.
- A prova em si importa menos do que o que ela revela sobre o recruta.
- Boa oportunidade para o grupo mostrar que liderança também é protagonismo.

**Estrutura em beats**

1. O pedido — direto, sem mistério: o recruta precisa de uma prova de
   competência, e não tem certeza se consegue sozinho.
2. Execução — o mestre pode reaproveitar qualquer combate/coleta já feito
   nessa sessão como "a prova", ou inventar uma tarefa nova rápida.
3. Entrega da prova — o recruta agradece, visivelmente aliviado.

**Sem teste fixo** — usa o resultado da tarefa escolhida como prova.

**Complicações úteis**

- O recruta quer impressionar e quase estraga algo simples.
- Um veterano da guilda aparece cedo demais para avaliar.
- O grupo percebe que a tarefa é fácil, mas a vergonha do recruta não é.
- A “prova” funciona, mas o recruta ainda acha que foi carregado demais.

**Recompensas**

Col 30 + reputação com a guilda escolhida — possível convite futuro pra
atividades da guilda (gancho reaproveitável em sessões futuras).

**Gancho visual / de transmissão**

- O recruta fingindo confiança um segundo antes de perdê-la.
- A pequena prova ganhando peso social demais.
- O alívio visível na entrega final.

---

### `bounty_08_o_que_a_pedreira_escondia` — O Que a Pedreira Escondia

**Tipo:** Investigação · **Dificuldade:** Médio · **Região:** Pedreira de Dunhelm

**Requer:** — · **Desbloqueia:** —

**Gancho**

Na Pedreira de Dunhelm, entre pilhas de sucata e minério comum, um
maquinário chama atenção por um motivo específico: as engrenagens são
grandes demais e finas demais pra qualquer coisa feita nesse andar — a
tecnologia destoa do resto de Aincrad.

**Leia em voz alta**

> A Pedreira de Dunhelm cheira a poeira, ferro e repetição. Justamente por isso
> a máquina errada salta tanto aos olhos. Não porque brilha. Porque pertence a
> uma lógica mais precisa do que o resto do entulho ao redor.

**O que está em jogo**

- Esta bounty é curta, mas ótima para tempero de mundo.
- Se o grupo perceber o valor da estranheza, ganha um tipo diferente de recompensa.
- O objetivo aqui não é resolver mistério inteiro; é sentir que o mundo tem costuras.

**Estrutura em beats**

1. Descoberta do maquinário em meio à sucata comum.
2. Exame de perto — comparação mental (ou literal, se o grupo tiver
   registro) com qualquer outra tecnologia já vista no andar.
3. Conclusão — reconhecimento de que isso não bate com o padrão, sem
   necessariamente entender o porquê.

**Testes sugeridos**

- d20+Inteligência — reconhecer que a tecnologia destoa do resto do jogo

**Complicações úteis**

- O grupo acha que entendeu “o que é”, quando só entendeu que não encaixa.
- Um detalhe da máquina lembra outra coisa vista no andar e pode confundir.
- A pista parece pequena demais até alguém descrevê-la em voz alta.
- O grupo leva uma peça achando que ajuda, mas isso muda a leitura do local.

**Recompensas**

Col 20 (recurso de sucata comum ao redor, sem valor central) + pista
atmosférica não-mecânica (10+: reconhecimento claro, mistério real pro
mestre usar quando quiser; 7-9: percebe só que é estranho, sem
conclusão; 6-: ignora, parece só entulho — quest permanece disponível
pra tentar de novo depois). Boa pra tempero de mundo — não precisa levar
a lugar nenhum se o mestre não quiser expandir.

**Gancho visual / de transmissão**

- A peça fina demais no meio de máquina bruta.
- O grupo entendendo que o estranho nem sempre vem com luz ou magia.
- A sensação de encontrar algo “fora do padrão” sem saber por quê.

**Fecha a cadeia I e o registro completo das 60 quests do andar 1.**
