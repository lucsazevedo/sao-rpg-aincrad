---
nome: Serpente das Águas Rasas
epiteto: 
tipo: besta
andar: 1
zona: Águas e Pântanos
local: ilhota / margem de lago
regioes: [lago, ilha_lago, rio_serpente]
nivel_recomendado: "4-5"
nivel_ameaca: comum
ca: 11
pv: 26
dado_vida: 4d8+8  # 4d8 médio 18 + 8 = 26
bonus_ataque: +3
cd_resistencia: 11
abertura: golpe atrás da cabeça enquanto ela está enrolada, antes do bote
atributo_fraqueza: Destreza
resistencias: [água, dano hídrico]
vulnerabilidades: [frio, ser tirada da água]
imagem: ../imagens/monstro_serpente_das_aguas_rasas.png
canonico: nao
fonte: 
---

## Habitat

Margens rasas do Lago Sylvaine e a orla da Ilha de Pemberton. Fica enrolada em raiz submersa, na altura do tornozelo, onde ninguém procura.

**Comportamento:** passiva enrolada e explosiva quando não está. Só dá o bote uma vez por aproximação; se errar, desenrola e recua para outra raiz.

## Aparência

Dois metros e meio de corpo achatado lateralmente, escamas verde-escuras nas
costas e amarelo-pálidas na barriga, com uma faixa prateada correndo do
focinho até a cauda. Nada com o corpo quase todo submerso — só a faixa
prateada aparece, e à distância parece o reflexo do sol na água.

Vive nas rasas ao redor da **Ilha de Pemberton**, no Lago Sylvaine, onde a
água bate na altura do joelho por dezenas de metros. É exatamente a
profundidade em que um jogador se sente seguro.

## Leia em voz alta

> A água bate no tornozelo e é limpa o bastante para ver o fundo. O que parecia raiz enrolada na pedra à sua esquerda tem um desenho regular demais nas escamas, e a ponta dela acabou de se ajustar.

## Sinal antes do ataque

O corpo se comprime. A espiral aperta meio palmo antes do bote, e é o único aviso.

## Ataques

- **Bote das rasas** — surge de baixo, dano moderado; contra alvo que não
  sabia que ela estava lá, conta como 2 golpes
- **Enrolar** — imobiliza uma perna; o alvo precisa de teste de Força pra se
  soltar antes do próximo bote
- **Puxar para o fundo** — só contra alvo já imobilizado e em água acima da
  cintura. É a complicação séria: o mestre deve deixar claro que ela está
  arrastando, e dar uma rodada pro grupo reagir

## Fraquezas

- **Atributo — Destreza:** o bote é explosivo e único — um ataque que usa Destreza, lido na compressão da espiral, chega antes e causa +1d6 de dano extra.
- Enrolada, antes do bote, a nuca fica descoberta e imóvel.
- Ela dá um bote por aproximação. Depois dele, recuar é seguro.

## O que torna este encontro memorável

É a lição de que água rasa não é água segura. O Lago Sylvaine parece o lugar mais tranquilo do andar até alguém aprender a olhar as raízes submersas — e depois disso ninguém atravessa a margem sem olhar de novo.

## Complicações úteis

- Vencem, e a puxada levou alguém para a parte funda.
- Ela recua ferida e a próxima aproximação já é em outro ponto.
- O bote acerta a bolsa de coleta em vez da perna.
- Um Pescador percebe que a horta está pisada demais e pergunta por quê.

## Tabela de drop

| Item | Raridade | Qtd | Chance | Serve pra |
|---|---|---|---|---|
| Escama Prateada | Comum | 2-3 | 55% | Costureiro, Joalheiro |
| Pele Lisa de Serpente | Comum | 1-2 | 40% | Costureiro |
| Presa Curva | Incomum | 1 | 25% | Joalheiro, Médico |
| Col | — | 130-190 | 100% | — |

<!-- convertido-dnd5e -->

## Stat Block D&D 5e

Convertido automaticamente pela fórmula da Seção 73 do `SAO_RPG_5e.md` (Nível de Ameaça **comum**, Andar 1). Os textos de "Ataques"/"Fraquezas" acima são flavor histórico (PBTA) — a mecânica real de jogo é esta:

- **CA:** 11
- **PV:** 26 (4d8+8)
- **Bônus de Ataque:** +3
- **CD de Resistência:** 11
- **Atributo de fraqueza:** Destreza — um ataque que usa Destreza contra esta criatura causa +1d6 de dano extra (Seção 73).

## Lore

É a fonte alternativa de Escama Prateada do andar, e a única acessível a quem não quer entrar em água funda atrás do Lacustre Vagador. Isso a torna o monstro mais caçado do Sylvaine e o motivo de a margem rasa perto de Pemberton estar sempre pisada. Os pescadores chamam aquele trecho de a horta, e não é elogio.

*Ela não está escondida. Está enrolada exatamente onde você vai pisar.*

## Notas para o mestre

Existe por duas razões de design:

1. **Segunda fonte de Escama Prateada.** Antes dela, todo Joalheiro do andar
   dependia exclusivamente do Lacustre Vagador (`docs/economia_profissoes.md`)
   — o que travava a profissão inteira atrás de uma criatura só. Agora existem
   duas rotas, em pontos diferentes do lago.
2. **Doma intermediária.** Com 6 sucessos, ela fica entre o Lobo das Estepes
   (4) e o Lacustre Vagador (8) — o degrau que faltava. Domada, é um aliado
   aquático mais ágil e mais frágil que o Lacustre: alcança lugares no lago
   que ninguém alcança, mas cai rápido se entrar em combate aberto.

A doma dela é a mais **lenta** do andar de propósito: a isca precisa ser
deixada por três dias no mesmo ponto, o que significa três sessões (ou três
retornos) antes do primeiro teste de Destreza. Domador que se compromete com
ela está fazendo um investimento visível pro resto da mesa.

Ligada a: Ilha de Pemberton e Lago Sylvaine (`dados_mapa.js`), Pescador
Veterano (`npcs/pescador_veterano.md`), cadeia C (`Águas de Sylvaine`).
