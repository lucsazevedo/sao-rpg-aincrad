---
titulo: Puzzles e Enigmas do Andar 1
andar: 1
puzzles: 7
---

# Puzzles e Enigmas do Andar 1

Sete quebra-cabeças completos, cada um montado como uma aventura pequena:
como o grupo topa com aquilo, o que dá pra fazer em cada etapa, o que
acontece quando erram, os diálogos que importam, e uma recompensa **nomeada**
— nunca "uma pista solta".

Substitui a seção de segredos de `docs/interacoes_e_segredos.md`, que
continua válido para as **interações de chegada**.

## Índice

| # | Puzzle | Região | Tipo | Recompensa |
|---|---|---|---|---|
| 1 | O Mural dos Cinco Cristais | Castelo de Ferro Negro | Ordem + coleta social | `Anel dos Cinco Encaixes`, `Martelo do Mural` |
| 2 | O Código de Horunka | Floresta de Horunka | Linguagem + confiança | `Diário de Ferren`, `Kit de Caça de Antes` |
| 3 | A Lápide Sem Nome | Necrópole de Voss | Investigação social | `Capuz do Nome Apagado`, `Rapieira do Duelo Sem Nome` |
| 4 | O Redemoinho que Sobe | Lago Sylvaine / Rio Coluber | Observação + timing | `Frasco de Água que Sobe`, mapa da correnteza |
| 5 | O Círculo de Pedras de Kaldan | Estepes de Kaldan | Astronomia falsa | `Bússola de Kaldan` |
| 6 | O Relógio Sem Ponteiros | Torre de Aldric | Mecânica + dedução | `Ponteiro de Aldric`, tese do Estudioso |
| 7 | O Círculo de Cogumelos | Bosque de Ashwen | Memória + ordem | `Lanterna de Ashwen` |

## Regras comuns a todos

**Nenhum puzzle trava a campanha.** Todo puzzle tem pelo menos duas rotas de
entrada e uma saída "meia-boca" que entrega parte da recompensa. Se o grupo
travar de verdade, o mundo oferece a próxima pista sozinho depois de uma
sessão — via NPC, via boato, via consequência.

**Errar custa, mas não fecha.** Falha gasta recurso, tempo ou reputação. Nunca
apague um puzzle por causa de uma Falha.

**Nenhum puzzle entrega a resposta do andar 2.** Todos alimentam
`docs/misterio_andar2.md` e todos param um passo antes.

## Como puxar estes puzzles para A+

Para cada puzzle deste arquivo, o mestre deve procurar quatro coisas em cena:

1. **Imagem forte de abertura.** Antes de qualquer teste, descreva um detalhe
   que já faça a mesa querer chegar mais perto.
2. **Descoberta em camadas.** Nunca entregue tudo no primeiro acerto; entregue
   certeza, depois contexto, depois custo.
3. **Erro interessante.** Falhar deve custar tempo, recurso, reputação ou
   posição — não apagar a brincadeira.
4. **Pagamento emocional.** A recompensa nomeada é importante, mas o melhor
   momento do puzzle é quando a mesa entende o que acabou de descobrir.

## Se o grupo travar

Use esta ordem antes de entregar resposta direta:

- **Primeiro:** repita um detalhe físico da cena.
- **Depois:** faça um NPC ou fenômeno reagir ao erro.
- **Depois:** ofereça uma pista parcial que confirme o caminho, mas não a
  solução inteira.
- **Só por último:** entregue o próximo passo via boato, consequência ou
  ajuda externa.

## Uso em transmissão

Todo puzzle aqui rende melhor quando tem:

- **um momento de silêncio** antes da conclusão,
- **uma aposta clara** (“vamos gastar isso mesmo?”),
- **uma reação física do cenário** (parede mexendo, eco mudando, água
  invertendo, luz apagando),
- **um objeto concreto** para mostrar no fim da cena.

---

# 1. O Mural dos Cinco Cristais

**Região:** Castelo de Ferro Negro · **Cadeia:** G (`castelo_01` a `castelo_06`)
**Tipo:** ordem correta + coleta que exige outras pessoas
**Duração estimada:** 2 a 4 sessões, em paralelo com outras coisas

## A verdade (só o mestre)

O mural não é uma fechadura mágica. É um **painel de calibragem** — um
mecanismo de manutenção que o próprio sistema do jogo usa, deixado exposto
onde qualquer um poderia mexer, o que é o tipo de descuido que não deveria
existir num jogo desenhado por Kayaba Akihiko.

Encaixar os cinco cristais na ordem certa não "abre um segredo". Faz o painel
**responder**: a parede atrás dele desliza dois palmos, revelando a Câmara da
Inscrição, que é uma sala de serviço. A inscrição na parede não é lore
antiga — é anotação de trabalho de alguém que estava calibrando alguma coisa,
e a última linha está incompleta.

A frase que importa está na inscrição e o grupo vai levar meses pra entender:
**"recompensa do golpe final — verificar antes do andar 2"**.

## Como o grupo topa com isso

Três entradas, todas passivas — nenhuma exige que você anuncie nada:

1. **Vendo o mural.** Qualquer um que ande até o pátio do Castelo vê cinco
   buracos do tamanho de um cristal na parede. Isso basta.
2. **Ouvindo a cantiga.** O busker da Taverna canta o "Verso da Viagem do
   Peregrino Perdido" há dias. É música de fundo até alguém prestar atenção.
3. **Pelo Guarda Insone.** Ele viu a parede se mexer na noite do dia 6, e é
   por isso que não dorme. Ele não conta isso de primeira.

## Etapa 1 — Perceber que a ordem importa

O mural tem cinco encaixes idênticos em tamanho, diferentes em contorno: cada
um tem o formato exato de um tipo de cristal (Teleporte, Cura, Antídoto, Luz,
Barreira). Encaixe errado **não** entra — o formato impede. O que a ordem
decide é a **sequência de encaixe**, não a posição.

| Ação | Teste | Sucesso total | Sucesso parcial | Falha |
|---|---|---|---|---|
| Examinar os encaixes | d20+Inteligência | Entende que os cinco entram, mas há desgaste desigual: alguns foram usados mais vezes, em ordem | Entende que os cinco cabem | Conclui que é decorativo |
| Encaixar um cristal na tentativa | — | O cristal **entra e não sai**. Ordem errada = cristal perdido. Diga isso ANTES de deixar rolar |  |  |
| Escutar a pedra (bater) | d20+Destreza | Há um vão atrás e ele é raso — sala pequena, não dungeon | Há vão | O guarda pergunta o que você está fazendo |

**Custo real:** cada tentativa errada consome cristais de verdade. Um Cristal
de Teleporte custa 500 Col. O grupo aprende rápido que chutar é caríssimo, e é
aí que a busca pela ordem começa pra valer.

## Etapa 2 — Achar a ordem

A cantiga do busker é a chave. Ele canta assim (letra completa):

> *Azul foi o primeiro passo, que o levou pra longe de casa,*
> *Verde a folha que curou seu pé cansado,*
> *Roxo o fruto que tirou o mal do corpo,*
> *Dourada a luz que guiou seu caminho na noite,*
> *Prata o escudo que o protegeu até o fim.*

**Ordem: Teleporte (azul) → Cura (verde) → Antídoto (roxo) → Luz (dourado) →
Barreira (prata).**

| Ação | Teste | Sucesso total | Sucesso parcial | Falha |
|---|---|---|---|---|
| Ouvir a cantiga com atenção | d20+Sabedoria (Músico: automático) | Decora a letra inteira e sacou que são cores de cristal | Decora a letra | Lembra do refrão e mais nada |
| Perguntar ao busker de onde vem | d20+Sabedoria | Ele lembra do nome do busker que ensinou | Ele diz que veio de outro busker | Ele se irrita: "é só uma música" |
| Ler o verso rabiscado na Dungeon Oculta | d20+Inteligência | Verso idêntico, e mais velho que a cantiga | Verso parecido | Rabisco ilegível — e você está no lugar errado do andar |

### Diálogo do busker

Ele é um Músico jogador, magro, com um alaúde emprestado. Chama-se **Perim**.

- **Se perguntarem da música:** "Aprendi de outro cara, que aprendeu de um
  terceiro. Não sei quem inventou. Só sei que ela conta certinho, se prestar
  atenção."
- **Se perguntarem "conta o quê?":** "Sei lá. Uma viagem. Uma ordem de
  coisas. Cada vez que canto sobra a impressão de que tá faltando um verso."
- **Se perguntarem se ele sabe do mural:** "Que mural?" — e ele fala a
  verdade. Perim não faz ideia.
- **O que ele NÃO responde:** de onde veio o primeiro busker; ele
  genuinamente não sabe, e insistir só o deixa desconfortável.
- **Se um Músico da mesa tocar com ele:** ele solta o sexto verso, que ele
  achava que tinha inventado sozinho — *"e um sexto ficou de fora, porque
  ninguém soube dizer a cor"*. Isso é o gancho pro Cristal "Outros".

## Etapa 3 — Reunir os cinco cristais

É aqui que o puzzle vira **social**, e é o ponto do design: ninguém carrega
cinco tipos de cristal sozinho no dia 10.

| Cristal | Onde | Dificuldade real |
|---|---|---|
| Teleporte | Comerciante da praça, 500 Col | Caro |
| Cura | Comerciante, 350 Col; drop raro | Caro |
| Antídoto | Comerciante, 250 Col; baú do Labirinto I-5 | Médio |
| Luz | Comerciante, 180 Col; baú do Labirinto I-5 | Fácil |
| Barreira | Comerciante, 400 Col; baú da Gruta L-5 | Escasso — estoque 1/semana |

Somando: **1680 Col** comprando tudo. Um grupo de quatro no dia 10 tem entre
300 e 800. Ou seja: **é impossível fazer sozinho**, e essa é a mecânica.

Saídas: pedir emprestado a outra guilda (Diplomata brilha), fazer contrato de
escolta pra bancar, caçar os baús específicos, ou convencer o Comerciante da
praça a fiar (d20+Inteligência; Sucesso total ele fia metade, Sucesso
parcial fia um só e cobra juros em serviço, Falha ele ri).

## Etapa 4 — O encaixe

Cena de mesa, sem rolagem. Cada cristal entra com um som diferente. Ao quinto,
a parede desliza dois palmos e para. O som é de mecanismo, não de magia.

**Se a ordem estiver errada:** o cristal encaixado some, a parede não se mexe,
e a partir da segunda tentativa errada o Guarda Insone aparece — não pra
impedir, mas pra dizer, muito baixo, "vocês também viram, então".

## A Câmara da Inscrição

Sala de três por três metros. Seca. Sem poeira, o que é errado. Uma parede
inteira coberta de escrita miúda no mesmo alfabeto de Verrun, Kaldan,
Pemberton e Braxhold. Não é antiga: é **recente**.

No chão, junto à parede: um anel de ferro escuro com cinco depressões, quatro
vazias. Preso na parede, na altura do ombro: um martelo de cabeça escura com
as mesmas cinco depressões na face.

**Leia em voz alta:**
> A parede inteira está escrita. Não gravada — escrita, com alguma coisa
> parecida com giz que não sai quando você passa o dedo. A letra é pequena,
> regular, e vai do chão ao teto sem parágrafo nenhum. Na altura do peito, num
> ponto qualquer, a escrita simplesmente para no meio de uma linha. Como se
> quem estava escrevendo tivesse sido interrompido e nunca voltado.

## Recompensas

**`Anel dos Cinco Encaixes`** (Acessório, Raro) — +1 em Inteligência para
decifrar qualquer coisa. Encostado em pedra gravada de qualquer lugar do
andar, toca um segundo da cantiga do busker — sempre o mesmo trecho, sempre
parando antes do último verso.

**`Martelo do Mural`** (Martelo, Raro) — +1 em Força pra quebrar estrutura ou
construto. Golpear pedra gravada revela se há vazio atrás. É o detector de
passagem secreta do andar.

**A linha interrompida** — anote a frase e devolva ao grupo por escrito, num
papel de verdade se sua mesa for presencial:
> *"...recompensa do golpe final — verificar antes do and"*

Ela para aí. Não continue. Não explique. Ver `docs/misterio_andar2.md`.

**Se o grupo falhar de vez** (gastou cristais demais e desistiu): o Guarda
Insone, na quest `castelo_04`, conta o que viu na noite do dia 6 — a parede
aberta, alguém saindo, e a parede fechando. Isso entrega o *fato* sem o anel
nem o martelo. O puzzle continua disponível para sempre.

## Como vender este puzzle na mesa

- **Imagem forte:** o mural público que ninguém resolveu há dias.
- **Decisão boa:** gastar cristais caros agora ou sair para caçar informação.
- **Momento de virada:** quando a mesa percebe que a cantiga infantil é manual
  de manutenção disfarçado.
- **Ponto de corte ideal:** a parede deslizando e revelando a Câmara.

---

# 2. O Código de Horunka

**Região:** Floresta de Horunka · **Cadeia:** B (`horunka_02`, `horunka_04`, `horunka_08`)
**Tipo:** linguagem, mas destravada por confiança
**Duração:** 2 sessões

## A verdade (só o mestre)

As marcas nos troncos são um código prático de caçadores, inventado **antes do
dia 1** por um grupo de cinco moradores de Horunka que caçava longe e precisava
marcar esconderijos de suprimento. Não tem nada de sobrenatural.

O que o código guarda é pessoal: o último esconderijo marcado pertence a
**Ferren**, hoje conhecido como o Eremita da Floresta. Ele parou de caçar no
dia 2 e o motivo não é uma conspiração — ele deixou um companheiro morrer
porque hesitou meio segundo. Só isso. E é o suficiente.

## Como o grupo topa com isso

1. **A Trilha Antiga** — símbolo entalhado numa árvore alta, cicatrizado.
2. **Uma quest da vila** — `horunka_02_marca_no_tronco` é oferecida por
   qualquer morador depois de `horunka_01`.
3. **Perguntando sobre o Eremita** — a vila fala dele com respeito e
   desconforto, e alguém menciona "as marcas dele".

## A gramática do código

Cada marca tem três partes, e o grupo pode deduzir duas sozinho:

| Parte | Como aparece | O que significa |
|---|---|---|
| **Traço vertical** | 1 a 4 riscos | Distância em "meias-horas de caminhada" |
| **Ângulo do corte** | inclinado ↗ ou ↘ | Direção: subindo o terreno ou descendo |
| **Ponto queimado** | presente ou não | Presença = esconderijo de suprimento. Ausência = aviso de perigo |

**O que só o Eremita ensina:** que as marcas se leem **da mais nova pra mais
velha** (pela cicatrização da casca), e não na ordem em que se encontra. Sem
isso, o grupo lê a rota ao contrário e chega no lugar errado — o que deve
acontecer pelo menos uma vez, e deve ser divertido, não punitivo.

## Etapas

| Etapa | Ação | Teste | Sucesso total | Sucesso parcial | Falha |
|---|---|---|---|---|---|
| 1 | Achar uma marca | d20+Destreza | Acha e nota a cicatrização | Acha a marca | Passa direto |
| 2 | Deduzir distância/direção | d20+Inteligência | Deduz as duas | Deduz uma | Anota errado |
| 3 | Achar o Eremita | d20+Sabedoria | Ele aparece por vontade própria | Acha a cabana vazia | Perde o dia |
| 4 | Convencer o Eremita | d20+Sabedoria | Ensina o código inteiro | Ensina metade e cobra um favor | Ele encerra e some por uma sessão |
| 5 | Seguir a rota completa | d20+Inteligência | Chega no esconderijo direto | Chega, mas de noite | Chega no lugar errado (esconderijo vazio de outro caçador) |

## O Eremita — o que ele responde e o que não

**Nome:** Ferren. Ele não dá o nome antes da etapa 4.

- **Sobre a floresta:** responde tudo, com precisão e prazer. Rotas, ninhos,
  época de Ovule, onde a Trepadeira cresce. É generoso nisso.
- **Sobre o código:** só ensina a quem passou por `horunka_01` **e** não matou
  nada que não fosse usar. Ele sabe quem matou o quê. Pergunte ao grupo o que
  fizeram com as carcaças — e se a resposta for "deixamos lá", ele diz isso na
  cara deles, sem raiva.
- **Sobre por que se isolou:** nega três vezes. Na quarta, se o grupo tiver
  sido decente, ele conta em duas frases, sem drama, e muda de assunto na
  mesma respiração. **Não deixe o grupo transformar isso em terapia.**
- **O que ele NUNCA responde:** o nome do companheiro que morreu. Se
  insistirem, ele levanta e vai embora, e a quest `horunka_08` fica travada
  por uma sessão.

**Falas prontas:**
- "Você marca a árvore pra outro achar, não pra você lembrar. Quem marca pra
  si mesmo tá se preparando pra ficar sozinho."
- "Não tem segredo nenhum aí. Tem quatro riscos e um lado. O segredo é que
  alguém se deu ao trabalho."
- "Eu ainda venho aqui todo dia. Não caço. Só venho."

## Recompensas

**`Diário de Ferren`** (item de lore, não equipável) — dezoito páginas, letra
apertada, sem melodrama. Registra rotas, presas, tempo. As últimas quatro
páginas são só datas, sem entrada. O grupo entende sozinho o que essas páginas
significam.

**`Kit de Caça de Antes`** (Incomum, conta como Luvas) — um dos primeiros kits
feitos na vila, de antes de todo mundo entender que o jogo era real.
**Efeito:** +1 em Destreza para extrair material de caça, e o material nunca sai
imperfeito num Sucesso parcial. **Não pode ser vendido** — a vila reconhece o kit e
qualquer comerciante de Horunka se recusa a comprar.

**Reputação em Horunka: máxima.** Desconto de 40% em vez de 25%, a pousada
para de cobrar, e o estalajadeiro passa a chamar o grupo pelo nome.

**Se o grupo falhar:** o esconderijo pode ser achado por força bruta
(vasculhar a floresta, d20+Destreza, três sessões seguidas). Eles ganham o kit
e **não** ganham o diário — porque o diário o Eremita entrega em mãos, ou não
entrega.

## Como vender este puzzle na mesa

- **Imagem forte:** árvores marcadas por mãos humanas antigas, não por monstro.
- **Decisão boa:** insistir em decifrar sozinho ou admitir que precisam do Eremita.
- **Momento de virada:** descobrir que estavam lendo a rota ao contrário.
- **Ponto de corte ideal:** Ferren contando, em duas frases, por que parou.

---

# 3. A Lápide Sem Nome

**Região:** Necrópole de Voss · **Cadeia:** F (`necropole_01` a `necropole_05`)
**Tipo:** investigação social, sem combate, sem teste de força
**Duração:** 2 a 3 sessões

## A verdade (só o mestre)

A lápide é de **Aldo**, um jogador que morreu no dia 5. Ele não morreu de
forma heroica: ele morreu porque **fugiu**, e ao fugir puxou consigo o Frenzy
Boar que estava contido, e o bicho matou outra pessoa que estava de costas.

Quem raspou o nome foi **Talia**, irmã dele — não por vergonha de que ele
tenha fugido, mas porque os outros jogadores começaram a usar o nome dele
como piada. "Fugiu igual o Aldo." Ela raspou pra que o nome parasse de
existir.

Talia é uma NPC que o grupo já conhece de outra região. **Escolha uma** e use
a mesma pela campanha inteira: a Mulher Aflita da praça, a Garota do Arco, ou
uma das Recrutas de Kaldrin. A Mulher Aflita é a mais forte — ela parou de sair
dos muros no dia 5, e agora o grupo sabe por quê.

## Como o grupo topa com isso

1. **Vendo a lápide.** Terceira fileira, nome raspado com ferramenta, datas
   intactas.
2. **Pelo Zelador.** Ele corta a grama em volta dela com mais cuidado que nas
   outras, e alguém repara.
3. **Pelo Memorial dos Caídos** na capital, onde há um nome riscado na lista.

## Etapas

| Etapa | Ação | Teste | Sucesso total | Sucesso parcial | Falha |
|---|---|---|---|---|---|
| 1 | Notar que foi raspado, não gasto | d20+Inteligência | Vê marca de ferramenta e que é recente | Vê que está apagado | "Erosão" |
| 2 | Cruzar as datas com o Memorial | d20+Inteligência | Descobre que a data bate com uma morte dupla no dia 5 | Descobre a data | Registro incompleto |
| 3 | Ganhar a confiança do Zelador | d20+Sabedoria | Ele conta que alguém pediu, e que ele aceitou | Ele confirma que foi de propósito | Ele te acompanha até a saída, educado |
| 4 | Descobrir quem visita | d20+Destreza (vigília) ou +Inteligência (dedução) | Identifica Talia | Sabe que é uma mulher, sempre em horário diferente | Você é visto vigiando e a visitante para de vir |
| 5 | Falar com Talia | d20+Sabedoria | Ela conta tudo, e chora, e agradece | Ela conta metade e pede pra parar | Ela nega e corta relação com o grupo |

## O Zelador — o que ele responde e o que não

- **Sobre a Necrópole:** responde tudo. Quantas lápides, desde quando, quem
  cuidava antes dele (ninguém).
- **Sobre por que as lápides existem se ninguém fica enterrado:** ele responde
  com honestidade desarmante: *"Não sei. Elas já estavam aqui. Eu só comecei a
  cuidar."* — e essa é uma das frases mais importantes do andar.
- **Sobre a lápide raspada:** só depois de confiar. Ele não julga Talia e não
  vai deixar o grupo julgar na frente dele.
- **O que ele NUNCA faz:** dizer o nome que foi raspado. Ele apagou; falar o
  nome desfaria o trabalho. Se o grupo descobrir por conta própria, ele aceita.
- **Se profanarem uma sepultura:** ele para de falar com o grupo. Não expulsa,
  não briga. Só para. E a cadeia F trava até que devolvam e peçam desculpa —
  em cena, com palavras, não com teste.

**Falas prontas:**
- "Corto a grama. É o que dá pra fazer."
- "Vocês são os primeiros a não perguntar por tesouro."
- "Se você quer saber o nome, tem que querer pelo motivo certo. E eu vou saber
  qual é o seu."

## A escolha final (`necropole_05`)

Depois de descobrir tudo, o grupo escolhe. **Não há opção certa** e você não
deve sinalizar preferência:

**(a) Devolver o nome.** Gravar Aldo de volta na lápide. Talia briga, chora,
e depois agradece. A Necrópole ganha um nome; o grupo ganha inimizade de
quem fazia a piada.

**(b) Deixar apagado.** Talia continua vindo. O grupo carrega a informação e
não faz nada com ela. É a opção mais difícil e a mais respeitosa.

**(c) Contar a verdade publicamente** — que Aldo fugiu, sim, mas que quem
morreu estava de costas por escolha própria, cobrindo a retirada de outros
três. Isso limpa o nome dele às custas de expor tudo. Muda o clima social do
andar por sessões.

## Recompensas

**`Capuz do Nome Apagado`** (Capuz, Raro) — só nas rotas (a) e (b). O Zelador
entrega e não aceita nada em troca. Ele tinha o capuz guardado; ele **não
explica** de onde veio, e essa ausência de explicação é de propósito.

**`Rapieira do Duelo Sem Nome`** (Rapieira, Rara) — encostada na lápide desde
sempre. Pegá-la é uma decisão, não uma recompensa automática: quem pega não
consegue mais dizer em voz alta o nome de ninguém que morreu na campanha. Sai
como um espaço vazio na frase. **Descreva isso acontecendo na mesa** — o
jogador tenta falar e você simplesmente não deixa o nome existir.

**Se escolherem (c):** nenhum dos dois itens. Em vez disso, **Talia entrega o
arco/adaga/o que for de Aldo** — um item Incomum comum, sem efeito especial,
com o nome dele arranhado no cabo. Vale menos e pesa mais.

## Como vender este puzzle na mesa

- **Imagem forte:** uma lápide raspada com datas intactas.
- **Decisão boa:** buscar a verdade para reparar, proteger ou expor.
- **Momento de virada:** quando a mesa entende que o nome foi apagado para
  interromper a crueldade viva, não para esconder um grande crime.
- **Ponto de corte ideal:** a escolha final diante da lápide, sem música, sem pressa.

---

# 4. O Redemoinho que Sobe

**Região:** Rio Coluber (o redemoinho) e Lago Sylvaine (o efeito)
**Cadeia:** C (`lago_02`, `lago_06`) · **Tipo:** observação e timing
**Duração:** 1 a 2 sessões, espalhadas

## A verdade (só o mestre)

O redemoinho do Coluber **gira contra a correnteza** e **não tem fundo
mensurável**. O Lago Sylvaine, que é fechado, **tem maré**. As duas coisas são
o mesmo fenômeno: existe um fluxo de água atravessando o andar por baixo, e
ele não deveria existir num andar que flutua.

Não é sobrenatural e não é vilão. É estrutura. A água está sendo movida por
alguma coisa grande o suficiente pra mover água num andar inteiro — e as
engrenagens da Pedreira de Dunhelm têm exatamente esse tamanho.

Se o grupo ligar **redemoinho + maré do lago + engrenagens da pedreira**, essa
é a maior descoberta do andar 1. Dê a ela silêncio e uma pausa real na mesa.

## A janela de observação

O redemoinho só é visível **ao entardecer**, e só quando a água da região foi
perturbada nas últimas 24h (uma travessia, uma pesca grande, uma luta no
lago). Fora disso é correnteza comum.

Isso é intencionalmente chato de acertar: o grupo precisa voltar. Voltar é o
puzzle.

| Ação | Teste | Sucesso total | Sucesso parcial | Falha |
|---|---|---|---|---|
| Perceber o padrão de quando aparece | d20+Inteligência | Deduz a janela exata (entardecer + água mexida) | Deduz o entardecer | Acha que é aleatório |
| Fazer o Barqueiro falar | d20+Sabedoria | Ele conta o que viu e vai junto | Conta, mas não vai | Muda de assunto e fica calado o dia todo |
| Chegar perto de barco | d20+Destreza | Chega e observa com calma | Chega, o barco começa a girar | É puxado; teste de Força pra não virar |
| Medir a profundidade | d20+Destreza | A linha acaba antes do fundo — 40m e nada | Linha enrosca | Perde a linha e o peso |
| Encher um frasco no olho do redemoinho | d20+Destreza | Consegue: a água **sobe** dentro do frasco | Consegue meio frasco | Frasco quebra |
| Cruzar com a maré do lago | d20+Inteligência | Entende que são o mesmo sistema | Suspeita | Descarta a ideia |

## O Barqueiro — o que ele responde e o que não

**Nome:** ele diz que é **Ceno**, e provavelmente é mentira, e ele deixa isso
óbvio de propósito porque acha engraçado.

- **Sobre o rio:** fala pelos cotovelos. Correnteza, pontos rasos, onde a
  Sanguessuga fica, quem atravessou essa semana e com que cara.
- **Sobre o redemoinho:** muda de assunto duas vezes. Na terceira, se o grupo
  não pressionar e simplesmente esperar, ele conta sozinho.
- **O que ele viu:** remou pra dentro dele no dia 7, de propósito, "pra ver".
  O barco girou e ele levou quarenta minutos pra sair. Durante esses quarenta
  minutos, ele diz, **não anoiteceu** — o céu ficou parado.
- **O que ele NUNCA responde:** por que ele remou pra dentro. Ele desconversa
  com piada toda vez, e a piada fica pior a cada vez.

**Falas prontas:**
- "Travessia? Quarenta Col. Ou uma história boa. Prefiro a história."
- "Todo rio corre pra algum lugar. Esse aqui corre e volta. Já parei de
  pensar nisso."
- "Não, não vou lá de novo. Vocês vão? Ótimo. Eu seguro a corda."

## Recompensas

**`Frasco de Água que Sobe`** (Acessório, Incomum, único) — um frasco lacrado
com água do olho do redemoinho. Dentro dele, a água encosta na **tampa**, não
no fundo. Não faz nada mecanicamente. **Efeito:** qualquer NPC estudioso do
andar (Estudioso Obcecado, corretores de Tolbana, Zelador) para o que está
fazendo pra ver, e passa a tratar o grupo como gente séria — desconto e acesso
a informação que não vendem pra qualquer um.

**`Mapa da Correnteza`** (item de Cartógrafo) — desenhado com o Barqueiro.
Concede vantagem em qualquer teste de navegação no Coluber, Sylvaine, Grenna e
Kavir. Vendável por 300 Col em Tolbana, e o Cartógrafo que vender vai se
arrepender.

**A ligação com Dunhelm** — não é item. É a frase que você diz quando o grupo
finalmente junta as peças, e ela deve ser dita devagar:
> *"As engrenagens da pedreira têm o tamanho certo pra mover isso."*

**Se o grupo falhar:** eles perdem a janela algumas vezes e desistem. Tudo bem
— o Pescador Veterano de Brenmoor menciona a maré do lago em `lago_01` de
qualquer jeito, e a peça fica disponível pra ser recolhida mais tarde.

---

# 5. O Círculo de Pedras de Kaldan

**Região:** Estepes de Kaldan · **Tipo:** alinhamento — e a frustração é o ponto
**Duração:** 1 sessão pra descobrir; a campanha inteira pra aceitar

## A verdade (só o mestre)

Sete pedras de pé, uma caída. As sete apontam para posições no céu. **O céu de
Aincrad é falso** — é uma textura, e as estrelas nunca se movem.

O círculo aponta pra sete pontos onde **deveria** haver estrelas e não há. Ou
seja: alguém construiu este círculo pra um céu que existiu antes, ou pra um
céu que ainda vai existir.

A oitava pedra, a caída, aponta pro chão.

## Etapas

| Ação | Teste | Sucesso total | Sucesso parcial | Falha |
|---|---|---|---|---|
| Perceber que o arranjo é intencional | d20+Inteligência | Vê que as sete formam ângulos regulares | Vê que tem padrão | "Pedras largadas" |
| Descobrir que apontam pra cima | d20+Inteligência | Percebe a inclinação: são miras, não marcos | Percebe que estão inclinadas | Nada |
| Observar de noite e comparar | d20+Inteligência | **Nenhuma das sete tem estrela.** Todas as outras direções têm | Percebe que uma não tem | Céu é céu |
| Levantar a oitava pedra | d20+Força (precisa de 2 pessoas) | Levanta: ela aponta pro chão, e tem uma marca embaixo | Levanta, marca borrada | Não sai do lugar |
| Escavar sob a oitava | d20+Força/Técnica (Pá dá vantagem) | Acha uma bússola de bronze enterrada | Acha o buraco, vazio, com marca de algo retirado | Só terra |

## Recompensas

**`Bússola de Kaldan`** (Acessório, Raro — o oitavo Raro do andar) — bronze,
sem norte marcado. A agulha não aponta pro norte: aponta sempre pro **Castelo
de Ferro Negro**, de qualquer lugar do andar 1.
**Efeito:** +1 em Inteligência para se orientar ou achar rota, e o portador
nunca se perde em nenhuma região.
**Efeito único — Aponta pro Outro:** uma vez por sessão, o portador pode
perguntar "onde está X?" sobre uma pessoa ou coisa que ele já viu com os
próprios olhos. A agulha gira e aponta a direção. Não a distância.
**O detalhe que ninguém explica:** quando não perguntam nada, ela volta a
apontar pro Castelo.

**Se acharem o buraco vazio (Sucesso parcial):** alguém já esteve ali e levou a bússola.
Isso é pior e melhor: agora existe **outra pessoa** no andar que sabe. Você
pode plantar essa pessoa como NPC recorrente e nunca revelá-la.

**Nota de mestre:** este puzzle não tem "solução completa" de propósito.
Descobrir que faltam estrelas é a recompensa. Um jogador que exigir a
explicação deve receber um silêncio honesto — nem você sabe.

---

# 6. O Relógio Sem Ponteiros

**Região:** Torre de Aldric · **Tipo:** mecânico + dedução
**Duração:** 1 a 2 sessões

## A verdade (só o mestre)

A Torre de Aldric não media horas. As engrenagens do chão giram sem estar
ligadas a nada porque **estavam ligadas a alguma coisa que foi removida** — e
o mostrador na fachada não tem ponteiro porque nunca teve.

A torre media **andares**. O mostrador tem cem marcas, não doze. Ninguém
conta as marcas porque ninguém conta marcas de relógio.

Quando um jogador finalmente conta e chega em **cem**, essa é a cena.

## Etapas

| Ação | Teste | Sucesso total | Sucesso parcial | Falha |
|---|---|---|---|---|
| Examinar as engrenagens do chão | d20+Destreza | Percebe que giram sem carga: o eixo mestre sumiu | Percebe que não acionam nada | Acha que estão quebradas |
| Procurar o eixo removido | d20+Inteligência | Acha o encaixe vazio e a marca de serra: foi cortado | Acha o encaixe | Nada |
| Contar as marcas do mostrador | d20+Inteligência (ou simplesmente contar) | **Cem** | Perde a conta e recomeça: cem | — |
| Subir até o mostrador por dentro | d20+Força | Chega e vê o verso: há um ponteiro guardado, deitado | Chega, a escada cede na volta | Cai |
| Montar o ponteiro | d20+Destreza | O ponteiro encaixa e para na **primeira** marca | Encaixa torto | Quebra o encaixe |
| Perguntar ao Estudioso | d20+Sabedoria | Ele já suspeitava e chora um pouco quando você confirma | Ele discute e depois aceita | Ele te chama de amador |

## O Estudioso — o que ele responde e o que não

**Nome:** ele se apresenta como **Wilbrand**, e insiste em ser chamado assim.

- **Sobre qualquer monstro do bestiário:** responde com precisão. É a mecânica
  do Bibliotecário e ele coopera de graça com quem for decente.
- **Sobre a torre:** ele tem uma tese e a repete: a torre é **anterior** ao
  resto do design do andar. Ele não consegue provar.
- **Sobre as outras marcas do andar:** conhece três das cinco. Levar as duas
  que faltam (Pemberton, Braxhold) faz ele entregar o `Capuz do Estudioso`.
- **O que ele NÃO responde:** por que ele se importa tanto. Se pressionarem,
  ele diz "porque é a única coisa aqui dentro que não foi feita pra mim" — e
  não elabora.
- **Metade das teorias dele é lixo.** Deixe algumas serem simplesmente
  erradas. Um Bibliotecário jogador que aprender a filtrar Wilbrand aprendeu
  a lição mais útil do andar.

**Falas prontas:**
- "Tudo neste andar foi desenhado pra ser jogado. Menos isso aqui. Isso aqui
  foi desenhado pra funcionar."
- "Não, não quero seu dinheiro. Quero que você volte. Ninguém volta."
- "Cem. Você contou cem, não contou? Sente-se. Por favor, sente-se."

## Recompensas

**`Ponteiro de Aldric`** (Acessório, Incomum) — a haste de bronze do
mostrador, meio metro, pesada. **Efeito:** +1 em Inteligência para estimar
tempo, distância ou escala de qualquer estrutura. **Utilidade:** encostado em
qualquer construção do andar, o portador sabe se ela foi feita antes ou depois
da Cidade do Início. Isso é uma ferramenta de investigação, e você deve deixar
o grupo usar até em lugar bobo.

**A tese de Wilbrand, escrita** — ele copia à mão, em quatro páginas, o
argumento completo de que a torre é anterior. Serve como fonte de pesquisa
permanente: com ela, o Bibliotecário pode pesquisar **fora** da Torre de
Aldric, em qualquer lugar do andar.

**`Capuz do Estudioso`** — se levarem as cinco marcas.

**A cena que vale mais que os itens:** quando o ponteiro é montado e para na
primeira marca de cem, alguém na mesa vai dizer em voz alta "é um contador de
andares". Deixe o silêncio ficar. Depois, Wilbrand diz: *"Então ele está
funcionando. Está só... no começo."*

---

# 7. O Círculo de Cogumelos

**Região:** Bosque de Ashwen · **Tipo:** memória e ordem, com penalidade de tempo
**Duração:** meia sessão

## A verdade (só o mestre)

O anel de cogumelos brancos tem **nove** cogumelos. Entrar no círculo e sair
sem pisar na ordem certa apaga uma hora — literalmente: o grupo se vê do lado
de fora, uma hora depois, sem lembrar. Ninguém envelhece, ninguém se machuca.
A hora simplesmente não aconteceu.

A ordem certa não está escrita em lugar nenhum do andar. Ela é **descoberta
por repetição**: a cada perda de hora, um dos cogumelos escurece um pouco. O
grupo aprende a ordem errando, e o custo é tempo.

Isso é de propósito: é o único puzzle do andar que se resolve por
persistência burra, e a mesa vai lembrar dele por isso.

## Etapas

| Ação | Teste | Sucesso total | Sucesso parcial | Falha |
|---|---|---|---|---|
| Perceber que os cogumelos mudam | d20+Inteligência | Nota que um escureceu depois da primeira perda | Nota que estão diferentes | Nada |
| Mapear a sequência (por tentativa) | — | Sem teste: cada tentativa custa 1 hora e revela 1 posição. Nove no total, menos as deduzidas |  |  |
| Deduzir posições sem pisar | d20+Inteligência | Pula duas tentativas | Pula uma | Nenhuma |
| Ouvir a Voz Sem Corpo sobre o círculo | d20+Sabedoria | Ela dá **uma** posição, de graça | Ela dá uma posição errada, de propósito | Ela repete a sua pergunta e vai embora |
| Completar a ordem | — | Cena. O círculo se abre: o chão dentro dele afunda meio metro e revela uma raiz oca |  |  |

**Custo total se o grupo for burro:** nove horas de jogo. Isso significa cair a
noite em Ashwen, e a noite em Ashwen não passa (ver o guia da região).

## Recompensa

**`Lanterna de Ashwen`** (Acessório, Raro — o nono Raro do andar) — dentro da
raiz oca há uma lanterna de metal fosco sem combustível, sem vela, sem
cristal. Ela acende quando alguém a segura e **não** ilumina o ambiente:
ilumina só o que a pessoa está procurando.
**Efeito:** +1 em Inteligência ou Destreza para procurar qualquer coisa
específica que o portador possa nomear em voz alta.
**Efeito único — O Que Você Perdeu:** uma vez por sessão, o portador declara
uma coisa perdida (um item, uma pessoa, um caminho) e a lanterna aponta.
Funciona uma vez para cada coisa: a mesma coisa nunca é apontada duas vezes.
**Custo:** enquanto carregada, o portador não consegue se lembrar do rosto de
ninguém que não esteja na sua frente. Ele sabe quem são, sabe os nomes, sabe a
história — só não consegue montar o rosto.

**Se o grupo desistir:** o círculo continua ali para sempre e a cada visita um
cogumelo a mais está escuro, como se alguém estivesse tentando enquanto eles
não estão.

---

## Como os sete se somam

Nenhum resolve o mistério do andar 2. Juntos, eles estabelecem **cinco fatos**
que o grupo deveria conseguir listar no fim do andar 1:

1. Existe escrita recente, no mesmo alfabeto, em cinco pontos do andar — e a
   última linha da Câmara está interrompida no meio de "andar 2".
2. O andar tem estrutura embaixo: água em movimento, engrenagens de escala
   industrial, e uma face inferior visível dos Penhascos de Vaelor.
3. A Torre de Aldric conta até cem e está na marca um.
4. Alguma coisa foi construída aqui **antes** da Cidade do Início.
5. Alguém, em algum momento, estava trabalhando nisso — e parou no meio.

Se o grupo chegar no raid contra Illfang carregando esses cinco fatos, a hora
em que o andar 2 **não abre** vai ser a melhor cena da campanha.
