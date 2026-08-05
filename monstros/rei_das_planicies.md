---
nome: Rei das Planícies
epiteto: O Dono das Marcas
tipo: besta
andar: 1
zona: Floresta e Planícies Iniciais
local: campo
regioes: [campos_oeste, colinas_pedra, campos_leste]
nivel_recomendado: "9-10"
nivel_ameaca: chefe
golpes_para_derrotar: "3x5"
atributo_fraqueza: a galhada, quando ele a baixa para investir — e ela é a única coisa que ele protege
elemento_fraqueza: Trovão
elemento_resistencia: Gelo
resistencias: [frio, veneno, impacto]
vulnerabilidades: [trovão, terreno fechado]
imagem: ../imagens/monstro_rei_das_planicies.png
canonico: nao
fonte:
domavel: nao
---

## Habitat

Field boss da Planície de Verrun. Não fica num lugar: ele **percorre** um
circuito entre Verrun, Kaldan e as Colinas de Braxhold, e o circuito passa
exatamente pelos quatro pontos onde há pedra gravada no andar.

**Comportamento:** ignora completamente quem não incomodou os Guardiões. Se o
grupo matou um Guardião das Planícies, ele aparece na sessão seguinte, no
descampado, e não vai embora sem o encontro acontecer.

## Aparência

Grande como uma carroça. A galhada tem envergadura de três metros e não é
simétrica de nenhum jeito natural — os galhos crescem em ângulos que repetem,
e o padrão que repetem é escrita. A pelagem inteira é coberta das mesmas
marcas claras dos Guardiões, mas nele elas são densas, sem espaço em branco.

Nos olhos não há nada de animal.

## Leia em voz alta

> Ele atravessa o descampado num passo só, sem pressa, e para de frente para
> vocês a uns quarenta metros. A galhada é maior que uma carroça e está
> escrita. A pelagem está escrita. Ele espera, e enquanto espera vocês
> percebem que a escrita da galhada continua na do corpo, e que é uma frase
> só, e que ela dá a volta nele inteiro.

## Sinal antes do ataque

Ele abaixa a galhada até a ponta encostar no chão. É o único movimento dele
que não parece calculado, e é o único que precede violência.

## Ataques

- **Investida coroada** — atravessa o campo inteiro. Quem não sair da linha
  não fica de pé.
- **Convocar o rebanho** — bate o casco três vezes e traz dois Guardiões das
  Planícies. Só faz isso na segunda barra, e só uma vez.
- **Girar a galhada** — golpe amplo que limpa tudo num raio de cinco metros e
  deixa a galhada exposta logo depois.
- **Parar** — na terceira barra ele simplesmente para de atacar por uma rodada
  e olha o grupo. Isso não é misericórdia e não é bug.

## Fraquezas

- **Elemento — Trovão:** o cristal de descarga da Gruta de Lumis é o item
  desenhado para esta luta. Em 10+ ele perde a investida coroada pelo resto da
  cena, e sem ela a arena inteira muda de dono.
- **Resiste a Gelo e a Veneno** — não adianta, e o grupo deve descobrir isso
  antes pelo Guardião, não aqui.
- A galhada fica aberta depois do giro, e é a única parte dele que importa.
- Terreno fechado o anula: entre pedras, ele não corre, e sem corrida ele é
  grande e lento.

## O que torna este encontro memorável

A pausa da terceira barra. Um chefe que para de lutar e olha, no meio da luta,
sem explicação nenhuma, é a coisa mais perturbadora que o Andar 1 tem — e a
mesa vai discutir o que aquilo significa por sessões. Não responda.

E há a galhada: a única fonte de texto longo e legível do andar inteiro,
carregada por um animal que não devia saber escrever.

## Complicações úteis

- Vencem, e a rota de migração some. Verrun e Kaldan ficam sem caça grande, e
  Horunka sente no mês seguinte.
- Ele para na terceira barra e alguém baixa a arma. Deixe acontecer.
- A galhada quebra na luta e o texto fica incompleto para sempre.
- Ele recua vivo, e a partir daí o circuito dele evita o grupo — o que é pior,
  porque significa que ele aprendeu os rostos.

## Tabela de drop

| Item | Raridade | Qtd | Chance | Serve pra |
|---|---|---|---|---|
| Pele Resistente | Comum | 3-4 | 100% | Costureiro, Ferreiro |
| Carne Nobre | Incomum | 2-3 | 80% | Cozinheiro |
| Casco Polido | Incomum | 2 | 70% | Artesão |
| Núcleo Selvagem | Raro | 1-2 | 60% | Joalheiro, item Único |
| Galhada Escrita | Raro | 1 | 100% | Bibliotecário — texto longo e legível |
| Coroa do Campo | **Épico** | 1 | 100% | Torna Raro em Único na bancada |
| Col | — | 2200-3200 | 100% | — |

## Lore

Os quatro pontos de pedra gravada do Andar 1 — Verrun, Kaldan, Pemberton,
Braxhold — estão nas quatro pontas de um circuito, e o Rei das Planícies
caminha esse circuito desde antes de qualquer jogador acordar aqui. Wilbrand
acha que ele é anterior ao andar. Wilbrand acha isso de tudo, e nesse caso
específico pode estar certo, porque a escrita da galhada é a mesma das pedras
e as pedras não foram escritas por ninguém que ainda esteja aqui.

Ele não guarda um tesouro. Ele carrega um recado, e o carrega há tempo demais
para alguém que ainda espera entregá-lo.

*Se ele parar e olhar para vocês, não é sobre a luta.*

## Notas para o mestre

- **Onde entra:** field boss de `campos_oeste` (Planície de Verrun). Aparece
  na sessão seguinte à morte de um Guardião das Planícies.
- **A Galhada Escrita** é conteúdo do mistério: o texto dela é a mesma frase
  do mural do Castelo, completa. Ver `docs/misterio_andar2.md` antes de
  entregar, e não traduza tudo de uma vez.
- **Como usar em transmissão:** a pausa da terceira barra. Segure o silêncio
  mais tempo do que é confortável — inclusive para você.
- **Erro comum do grupo:** chegar sem Trovão. O caminho estava dado: Guardião
  resiste a Gelo, o cristal está na Gruta, os Corretores de Tolbana vendem a
  informação. Se chegarem sem, deixe a luta ser dura e honesta.
- **Como a cena encerra sem HP:** sair do circuito. Ele nunca persegue para
  fora da rota, e um grupo que entende isso pode encerrar o encontro andando
  em linha reta para o sul. Ninguém ganha nada, e todo mundo se lembra.
