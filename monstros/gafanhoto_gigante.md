---
nome: Gafanhoto Gigante
epiteto: 
tipo: besta
andar: 1
zona: Floresta e Planícies Iniciais
local: agricultura em socalco
regioes: [terracos, vale_moinhos, campos_leste]
nivel_recomendado: "3-4"
nivel_ameaca: comum
golpes_para_derrotar: 3
ca: 11
pv: 26
bonus_ataque: +3
cd_resistencia: 11
abertura: golpe nas patas traseiras antes do salto
atributo_fraqueza: Destreza
resistencias: []
vulnerabilidades: [fogo, ataque em área]
imagem: ../imagens/monstro_gafanhoto_gigante.png
canonico: nao
fonte: 
---

## Habitat

Os Terraços de Solveig e as lavouras do Vale de Molwyn. Onde há plantio em degrau, há ninhada — e a ninhada é o problema, não o adulto.

**Comportamento:** agressivo por reflexo, não por fome. Salta na direção de qualquer movimento brusco, inclusive de outro gafanhoto, e o resultado é uma lavoura inteira saltando ao mesmo tempo quando alguém corre.

## Aparência

Do tamanho de um cão médio, verde-oliva manchado de marrom seco, com patas
traseiras desproporcionalmente grandes e mandíbulas que trabalham sem parar
mesmo quando ele não está comendo nada. As asas são curtas demais pra voar de
verdade — servem pra planar depois de um salto de dez metros.

Nunca aparece sozinho. Um Gafanhoto Gigante visível significa entre oito e
vinte deles no mesmo terraço, e é assim que os Terraços de Solveig perdem uma
colheita inteira em duas noites.

## Leia em voz alta

> O terraço parece vazio até alguém dar um passo rápido. Aí o degrau inteiro se levanta de uma vez — dezenas deles, do tamanho de um cachorro, todos na mesma direção, e a direção é vocês.

## Sinal antes do ataque

O ruído de serra vindo do mato. Uma perna esfregando é curiosidade; dez esfregando ao mesmo tempo é a ninhada acordando.

## Ataques

- **Salto de impacto** — atinge quem estiver no ponto de queda; complicação de
  ser derrubado, dano leve
- **Mandíbula** — dano leve, mas destrói equipamento de tecido/couro exposto
  (uma peça de Parte de Cima ou Baixo pode **rachar**, ver
  `equipamentos/00_indice.md`)
- **Debandada** — quando três ou mais são abatidos, o resto salta de uma vez;
  qualquer teste feito nessa rodada sofre complicação

## Fraquezas

- **Atributo — Reflexo:** a força deles é o salto em massa — arma de Reflexo, reagindo no tempo do salto, quebra a coordenação. Em 10+ a ninhada perde o salto coordenado pelo resto da cena.
- As patas traseiras se dobram antes do salto, e nesse instante ele está preso ao chão.
- Movimento devagar não dispara nada. O grupo controla quando a luta começa.
- Na ninhada, destruir as ovas encerra tudo sem lutar contra nenhum adulto.

## Tabela de drop

| Item | Raridade | Qtd | Chance | Serve pra |
|---|---|---|---|---|
| Perna Serrilhada | Comum | 1-2 | 65% | Cozinheiro; Ferreiro usa como lima |
| Casca Quitinosa | Comum | 2-3 | 40% | Costureiro, Alquimista |
| Ovas de Gafanhoto | Incomum | 2-4 | 100% na ninhada | Cozinheiro, Alquimista |
| Col | — | 70-110 | 100% | — |

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

Os Terraços de Solveig perdem uma colheita inteira a cada poucas semanas, e a fazenda comunitária do Vale contrata quem aparecer para limpar ninhada. É o trabalho mais honesto e mais chato do Andar 1, paga pouco, e é a razão de metade dos grupos novos conhecerem o Fazendeiro Local antes de conhecerem qualquer NPC importante.

*Um é comida. Trinta é uma safra perdida.*

## Notas para o mestre

É o monstro que **não deve ser resolvido por combate** — se o grupo só matar
gafanhotos, eles voltam na sessão seguinte, e essa deve ser uma consequência
visível. A solução está em `bounty_05_colheita_ameacada`: achar e queimar a
ninhada nas fendas, o que exige um teste de Conhecimento (Cartógrafo/
Bibliotecário brilham) antes de qualquer teste de Corpo.

Também é a fonte prática do **Cozinheiro** no leste do mapa: Perna
Serrilhada é proteína barata e abundante, o que dá ao Cozinheiro uma fonte
que não depende do Caçador comprar carne de Frenzy Boar.

Ligado a: Terraços de Solveig e Vale de Molwyn (`dados_mapa.js`), Fazendeiro
Local (`npcs/fazendeiro_local.md`), `bounty_05_colheita_ameacada`.
