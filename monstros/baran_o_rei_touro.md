---
nome: Baran, o Rei Touro
epiteto: Chefe do 2º Andar
tipo: chefe_de_andar
andar: 2
zona: Labirinto do Andar 2
local: dungeon_oculta
regioes: []
nivel_recomendado: "andar 2, conteúdo de raid"
nivel_ameaca: chefe
ca: 16
pv: 180
bonus_ataque: +6
cd_resistencia: 15
abertura: martelo cravado no chão após o golpe giratório — abertura curta e real
atributo_fraqueza: Destreza
resistencias: [investida corpo a corpo sem preparo]
vulnerabilidades: []
imagem: ../imagens/monstro_baran_o_rei_touro.png
canonico: sim
fonte: https://swordartonline.fandom.com/wiki/2nd_Floor
---

## Habitat

A câmara final do Labirinto do Andar 2 — layout interno ainda não
detalhado (ver `mapas/andar_2.md`, "o que falta"). Nome e forma geral são
canônicos; a sequência de combate abaixo é homebrew, escrita no mesmo
padrão de `monstros/illfang_the_kobold_lord.md`.

**Comportamento:** paciente na Fase 1, cada vez mais errático conforme
perde HP — o "rei" que começa calculista termina puro instinto de
sobrevivência.

## Aparência

Humanoide de porte descomunal com cabeça e chifres de touro, empunhando um
martelo de guerra pesado demais pra qualquer arma comum de jogador segurar
sem perícia dedicada. A pele tem textura de pedra rachada, não de couro.

## Leia em voz alta

> A câmara final é maior do que qualquer coisa que o grupo já viu no andar.
> Baran espera parado, martelo apoiado no chão como bengala, até a força-
> tarefa inteira estar dentro — só então ele se move, e o primeiro golpe do
> martelo no chão faz poeira cair do teto inteiro.

## Sinal antes do ataque

Um bufo grave, quase idêntico ao do Touro das Colinas, mas ecoando numa
escala muito maior — a câmara inteira vibra um instante antes de cada
golpe grande.

## Ataques

- **Golpe de martelo (Fase 1)** — dano alto em área frontal curta, quebra
  formação de quem estiver muito próximo.
- **Investida em linha (Fase 1)** — atravessa a câmara, ameaça quem estiver
  no caminho.
- **Golpe giratório (Fase 2, abaixo de 2/3 de HP)** — dano em área ampla ao
  redor dele; termina cravando o martelo no chão, criando a abertura
  central de fraqueza.
- **Investida dupla (Fase 3, abaixo de 1/3 de HP)** — duas investidas
  seguidas, cada vez mais erráticas e imprevisíveis na direção.

## Fraquezas

- **Atributo — Destreza:** chefe pesado de investida — um ataque que usa Destreza,
  explorando as aberturas que ele deixa entre um golpe grande e outro, causa
  +1d6 de dano extra.
- O martelo cravado no chão após o golpe giratório (Fase 2+) é a abertura
  real: alguém precisa estar posicionado pra aproveitar antes dele erguer o
  martelo de novo.
- Força bruta não abre a Fase 1 — o grupo precisa de pelo menos uma arma
  de Destreza pra aproveitar as aberturas entre os golpes grandes.
- Na Fase 3, a imprevisibilidade da investida dupla é, paradoxalmente, uma
  fraqueza: ele para de "ler" o grupo e fica mais fácil prever onde NÃO
  estar.

## O que torna este encontro memorável

É o segundo grande teste coletivo da campanha — mesma escala social de
`tolbana_12_o_raid_contra_illfang`, mas com uma variável nova: ninguém sabe
ainda, coletivamente, como o andar 2 abre pro andar 3. O golpe final aqui
carrega o mesmo peso dramático que o Last Attack Bonus teve em Illfang (ver
`docs/misterio_andar2.md`).

## Complicações úteis

- A poeira caindo do teto reduz visibilidade durante golpes grandes.
- Um grupo de apoio mal posicionado é pego pela investida em linha.
- A abertura do martelo cravado dura só um turno — perder a janela custa
  caro.
- Na Fase 3, a imprevisibilidade da investida acerta quem menos esperava.

## Tabela de drop

| Item | Raridade | Qtd | Chance | Serve pra |
|---|---|---|---|---|
| Chifre do Rei Touro | Épico | 1 | 100% (Last Attack) | Ferreiro (arma de assinatura) |
| Fragmento de Martelo | Raro | 1-2 | 60% | Ferreiro, Joalheiro |
| Couro de Pedra Rachada | Incomum | 2-3 | 80% | Costureiro |
| Col | — | 3000-4500 | 100% | — |

<!-- convertido-dnd5e -->

## Stat Block D&D 5e

Convertido automaticamente pela fórmula da Seção 73 do `SAO_RPG_5e.md` (Nível de Ameaça **chefe**, Andar 2). Os textos de "Ataques"/"Fraquezas" acima são flavor histórico (PBTA) — a mecânica real de jogo é esta:

- **CA:** 16
- **PV:** 180
- **Bônus de Ataque:** +6
- **CD de Resistência:** 15
- **Atributo de fraqueza:** Destreza — um ataque que usa Destreza contra esta criatura causa +1d6 de dano extra (Seção 73).

## Lore

Baran governava o planalto do andar 2 muito antes de qualquer jogador
chegar — nas palavras dos moradores mais antigos de Urbus (o que quer que
"antigo" signifique pra uma cidade que só existe há semanas), ele "nasceu
junto com a seca", guardião e causa do problema de água ao mesmo tempo.

*Ele não protege o andar 3. Ele só ainda não decidiu deixar ninguém passar.*

## Notas para o mestre

- **Onde entra:** câmara final do Labirinto do Andar 2 (layout ainda a
  desenvolver).
- **Como usar em transmissão:** a poeira caindo do teto a cada golpe
  grande — mesmo recurso visual de "o mundo reage à luta", já usado com
  Illfang.
- **Erro comum do grupo:** entrar na Fase 1 sem ninguém de arma de Destreza
  no grupo — planeje isso na cadeia de preparação de raid do andar 2
  (equivalente a `tolbana_09_abastecendo_o_grupo`).
- **Como a cena encerra sem HP:** não há saída sem combate — é chefe de
  andar. A única "saída" é decidir quem lidera a formação e quando recuar
  uma fase mal preparada (Preparação de Raid, `docs/regras_nucleares_campanha.md`).
