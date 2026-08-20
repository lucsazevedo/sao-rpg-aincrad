---
nome: Enxame de Abelhas Douradas
epiteto:
tipo: inseto
andar: 1
zona: Floresta e Planícies Iniciais
local: campo
regioes: [floresta_horunka]
nivel_recomendado: "3-5"
nivel_ameaca: comum
golpes_para_derrotar: 3
ca: 11
pv: 26
bonus_ataque: +3
cd_resistencia: 11
abertura: disperso ao primeiro sinal de fumaça, some do golpe individual
atributo_fraqueza: Destreza
resistencias: []
vulnerabilidades: [fumaça]
imagem: ../imagens/monstro_enxame_de_abelhas_douradas.png
canonico: nao
fonte:
---

## Habitat

A colmeia funda perto do Bosque de Coleta, na Floresta de Horunka. Não se
espalha — o enxame defende um único ponto fixo, a colmeia em si, e raramente
persegue quem se afasta o suficiente.

**Comportamento:** territorial, não predatório. Não caça: reage a
proximidade da colmeia e a movimento brusco perto dela. Um enxame calmo se
torna agressivo em segundos se a colheita for feita sem cuidado.

## Aparência

Centenas de pequenos corpos dourados, quase indistinguíveis um do outro à
distância — de perto, cada abelha é maior que o normal, com um brilho
metálico nas asas que deixa um rastro de poeira dourada no ar por onde
passam. A colmeia em si é maior que um jogador adulto, pendurada numa
árvore alta o bastante pra exigir escalada.

## Leia em voz alta

> O zumbido chega antes da colmeia aparecer — grave, constante, uníssono
> demais pra ser natural. Quando a árvore certa surge entre os troncos, a
> colmeia pulsa de leve, como se respirasse, e uma nuvem dourada se ergue
> em resposta ao primeiro passo em falso.

## Sinal antes do ataque

O zumbido sobe de tom e a nuvem dourada se adensa ao redor da colmeia —
sinal claro de que o enxame percebeu presença próxima e está decidindo se
reage.

## Ataques

- **Ferroadas em enxame** — dano baixo por ferroada individual, mas conta
  em volume: cada rodada sem controle da situação aumenta o número de
  abelhas atacando ao mesmo tempo.
- **Nuvem cega-olhos** — não causa dano; impõe complicação de visão e
  obriga teste extra pra qualquer ação fina (escalada, coleta, mira) até o
  grupo se afastar ou dispersar o enxame.

## Fraquezas

- **Atributo — Reflexo:** a nuvem cega-olhos pune ação precisa — arma de
  Reflexo, golpeada em reação pura, dispersa a onda. Em 10+ o enxame
  inteiro se dispersa pelo resto da cena (sem matar a colônia — ela volta
  a se formar em dias).
- Golpes individuais dispersam abelhas isoladas, mas não afetam o enxame
  como um todo — é preciso tratar como grupo, não como inimigos únicos.
- Longe da colmeia (mais de alguns metros), o enxame perde o ímpeto de
  perseguição rapidamente.
- Movimento brusco perto da colmeia (correr, golpear sem necessidade) é o
  gatilho mais comum de agressão — coleta cuidadosa raramente provoca reação.

## O que torna este encontro memorável

A decisão real não é "vencer o enxame" — é decidir entre colheita cuidadosa
(menos mel agora, colmeia intacta pro futuro) ou colheita agressiva (mais
mel, recurso destruído). Bom pra ensinar que nem todo "combate" em Aincrad
deveria terminar em morte do alvo.

## Complicações úteis

- O grupo dispersa o enxame, mas ele se reagrupa mais irritado se a coleta
  continuar sem pausa.
- Outro grupo de caçadores, também de olho no mel, complica a colheita
  (ver `cenas/cronicas_de_aincrad_ep01_25.md`, EP.08).
- A nuvem cega-olhos esconde um obstáculo de terreno (raiz, buraco) que
  também vira problema.

## Tabela de drop

| Item | Raridade | Qtd | Chance | Serve pra |
|---|---|---|---|---|
| Mel Comum | Comum | 1-2 | 70% | Cozinheiro |
| Mel Dourado | Incomum | 1 | 30% | Cozinheiro (receita de Halden), Alquimista |
| Cera Dourada | Comum | 1 | 40% | Costureiro, Joalheiro |
| Col | — | 40-90 | 100% | — |

<!-- convertido-dnd5e -->

## Stat Block D&D 5e

Convertido automaticamente pela fórmula da Seção 74 do `SAO_RPG_5e.md` (Nível de Ameaça **comum**, Andar 1). Os textos de "Ataques"/"Fraquezas" acima são flavor histórico (PBTA) — a mecânica real de jogo é esta:

- **CA:** 11
- **PV:** 26
- **Bônus de Ataque:** +3
- **CD de Resistência:** 11
- **Atributo de fraqueza:** Destreza — um ataque que usa Destreza contra esta criatura causa +1d6 de dano extra (Seção 74).

> Texto legado: menções a "7-9"/"10+" nas seções acima são do sistema PBTA anterior e não valem mais como mecânica — só como referência de intensidade narrativa.

## Lore

O nome é apelido de caçador, não classificação oficial — ninguém sabe dizer
se as abelhas sempre foram douradas ou se isso é só reflexo do próprio mel
raro que produzem. O que se sabe é que a colônia sobrevive intacta há mais
tempo que a maioria dos recursos do andar 1, exatamente porque poucos
caçadores têm paciência pra colher sem destruir.

*Quem colhe com pressa leva menos mel — e a colmeia lembra disso.*

## Notas para o mestre

- **Onde entra:** `floresta_horunka_madeira` (Bosque de Coleta) em
  `dados_mapa.js`.
- **Como usar em transmissão:** o zumbido crescente e a nuvem dourada se
  adensando — bom efeito sonoro/visual antes de qualquer dano acontecer.
- **Erro comum do grupo:** tratar o enxame como "um monstro só" e atacar a
  colmeia direto — funciona, mas acaba com o recurso de vez.
- **Como a cena encerra sem HP:** dispersar com fumaça e
  coletar o mel que já caiu no processo, sem necessidade de "vencer" a
  colônia inteira.
