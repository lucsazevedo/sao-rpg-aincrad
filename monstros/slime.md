---
nome: Slime
epiteto:
tipo: besta
andar: 1
zona: Floresta e Planícies Iniciais
local: campo
regioes: [vale_moinhos]
nivel_recomendado: "2-6"
nivel_ameaca: fraco
ca: 10
pv: 14
dado_vida: 2d8+5  # 2d8 médio 9 + 5 = 14
bonus_ataque: +2
cd_resistencia: 10
abertura: ponto de fusão exposto no centro, antes de se juntar a outro
atributo_fraqueza: Inteligência
resistencias: [veneno]
vulnerabilidades: []
imagem: ../imagens/monstro_slime.png
canonico: nao
fonte:
---

## Habitat

Aparece em eventos súbitos e localizados — o mais registrado até hoje foi
no Vale de Molwyn (ver `EP.29 — A Noite dos Slimes`,
`cenas/cronicas_de_aincrad_ep26_50.md`). Fora de evento, slimes isolados
podem surgir em qualquer zona úmida ou agrícola do andar 1.

**Comportamento:** individualmente passivo, quase brincalhão — pula,
reflete luz, reage a toque com curiosidade, não hostilidade. O
comportamento muda por completo quando dois slimes se tocam: em vez de se
repelirem, **se fundem**, e o resultado é sempre mais agressivo que a soma
das partes.

## Aparência

Uma massa gelatinosa translúcida, colorida (a cor varia — o evento de
Molwyn produziu tons vivos, quase festivos), do tamanho de uma bola grande.
Ao se fundir, dois slimes formam uma massa maior, mais escura no centro, com
uma segunda "camada" visível sob a translucidez — o início do que vira,
depois de fusões suficientes, um Slime Grande.

## Leia em voz alta

> No começo é quase engraçado — bolhas coloridas pulando entre as pernas,
> refletindo o sol em tons que não deveriam existir na natureza. Então duas
> se tocam. Em vez de se separarem, elas **se fundem**, e o som que fazem ao
> virar uma coisa só não tem nada de engraçado.

## Sinal antes do ataque

Slimes individuais nunca atacam por conta própria — o sinal de perigo real
é a **proximidade entre dois ou mais**: se estão se aproximando um do
outro, uma fusão está a caminho, e o grupo tem poucos segundos pra separar
ou agir antes que aconteça.

## Ataques

- **Investida gelatinosa** (Slime comum) — dano baixo, empurra o alvo.
- **Esmagamento** (Slime Médio, pós-1ª fusão) — dano moderado, pode prender
  brevemente quem for atingido.
- **Onda de impacto** (Slime Grande, pós-2ª+ fusão) — dano alto em área
  curta, ameaça estruturas leves (cercas, barracas, portas de madeira).

## Fraquezas

- **Atributo — Inteligência:** a fusão é o único truque, e quem entendeu o
  ponto de fusão sabe onde bater — um ataque que usa Inteligência, de quem
  leu o comportamento, causa +1d6 de dano extra.
- Atacar o ponto de fusão exposto no centro impede a divisão acidental
  (atacar em outro ponto pode fazer um slime comum **se dividir em dois**
  em vez de morrer, multiplicando o problema).
- Separar fisicamente dois slimes antes do contato evita a fusão sem
  precisar de combate algum.
- O Núcleo de Slime (catalisador, ver Lore) é sempre o ponto mais fraco:
  destruí-lo encerra qualquer evento de fusão em andamento, não importa o
  tamanho já alcançado pelos slimes fundidos.

## Variantes por fusão

| Estágio | Origem | Golpes p/ derrotar | Ameaça | Observação |
|---|---|---|---|---|
| Slime (base) | spawn inicial | 2 | fraco | não ataca sozinho |
| Slime Médio | fusão de 2-3 | 3-4 | comum | investida + esmagamento |
| Slime Grande | fusão de 4+ | 5-7 | forte | ameaça estrutura; onda de impacto |

## O que torna este encontro memorável

A decisão tática real não é "quanto dano causar", é "quando intervir": um
evento de slimes ignorado cedo é fácil; ignorado até o pico vira ameaça de
verdade. É um dos poucos encontros do andar 1 em que **esperar** é
literalmente a pior escolha possível.

## Complicações úteis

- Atacar no ponto errado divide um slime em dois em vez de eliminá-lo.
- Uma criança (NPC) se aproxima querendo "brincar" com um slime no meio do
  evento, forçando resgate.
- O Núcleo de Slime catalisador está protegido por uma concentração maior
  de slimes ao redor, dificultando acesso direto.

## Tabela de drop

| Item | Raridade | Qtd | Chance | Serve pra |
|---|---|---|---|---|
| Gel Comum | Comum | 1-2 | 70% | Alquimista |
| Núcleo de Slime | Incomum | 1 | 20% (garantido se poupar a colônia) | Alquimista, doma de Domador |
| Col | — | 20-60 (por slime) | 100% | — |

<!-- convertido-dnd5e -->

## Stat Block D&D 5e

Convertido automaticamente pela fórmula da Seção 73 do `SAO_RPG_5e.md` (Nível de Ameaça **fraco**, Andar 1). Os textos de "Ataques"/"Fraquezas" acima são flavor histórico (PBTA) — a mecânica real de jogo é esta:

- **CA:** 10
- **PV:** 14 (2d8+5)
- **Bônus de Ataque:** +2
- **CD de Resistência:** 10
- **Atributo de fraqueza:** Inteligência — um ataque que usa Inteligência contra esta criatura causa +1d6 de dano extra (Seção 73).

## Lore

Ninguém sabe explicar por que slimes se fundem em vez de se repelirem — não
bate com nenhum comportamento catalogado de criatura territorial do andar
1. O fenômeno de Molwyn (`EP.29`) foi o primeiro registrado em escala, mas
caçadores isolados já relatam slimes soltos, sempre sozinhos, em zonas
agrícolas do mapa.

*Um slime sozinho é curiosidade. Dois juntos são decisão. Quatro juntos são
problema.*

## Notas para o mestre

- **Onde entra:** `vale_moinhos` (Vale de Molwyn) em `dados_mapa.js`;
  fora de evento, pode aparecer isolado em qualquer zona agrícola/úmida.
- **Como usar em transmissão:** a escalada visual de "fofo" pra "ameaça
  real" é o próprio arco da cena — deixe o momento da primeira fusão
  pesar na mesa.
- **Erro comum do grupo:** atacar cada slime individualmente sem perceber
  que o problema real é impedir contato entre eles.
- **Como a cena encerra sem HP:** destruir o Núcleo de Slime catalisador
  encerra o evento imediatamente, independente do tamanho já alcançado
  pelos slimes fundidos — mais rápido (e mais interessante) que abater
  cada massa uma a uma.
- Domado (3 sucessos, com Núcleo de Slime intacto), vira companheiro
  inofensivo que absorve pequenos itens perdidos e os devolve intactos —
  bom gancho de Domador não-combatente, no mesmo espírito da
  `monstros/fada_da_poeira.md`.
