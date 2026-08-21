---
nome: Fada da Poeira
epiteto: 
tipo: besta
andar: 1
zona: Floresta e Planícies Iniciais
local: campo florido
regioes: [jardim_selvagem, bosque_sussurrante, campos_oeste]
nivel_recomendado: "3-4"
nivel_ameaca: comum
ca: 11
pv: 26
dado_vida: 4d8+8  # 4d8 médio 18 + 8 = 26
bonus_ataque: +3
cd_resistencia: 11
abertura: agarrar durante o pouso, quando as asas param
atributo_fraqueza: Inteligência
resistencias: [veneno]
vulnerabilidades: [água, fumaça]
imagem: ../imagens/monstro_fada_da_poeira.png
canonico: nao
fonte: 
---

## Habitat

O Jardim de Fenwyth e os canteiros floridos que sobram nas bordas da Planície de Verrun. Onde há flor rara, há três delas.

**Comportamento:** curiosa e ladra. Não fere de propósito: rouba. Item pequeno, brilhante, solto — some da mochila e reaparece a trinta metros, no chão, intacto, como convite.

## Aparência

Criatura do tamanho de duas mãos, com corpo alongado de inseto coberto por
uma penugem clara que solta pó dourado a cada batida de asa. Quatro asas
translúcidas, veias visíveis contra a luz. Não tem rosto — tem duas manchas
escuras onde um rosto estaria, e é justamente isso que assusta quem esperava
uma fada.

O nome é apelido de jogador, não descrição: quem viu de longe, no Jardim de
Fenwyth cheio de pólen suspenso, achou que fosse uma fada. Quem viu de perto
parou de achar.

## Leia em voz alta

> A luz entre as flores não vem do sol. São três, do tamanho de um punho, e o pó que soltam fica pendurado no ar depois delas passarem. Uma delas está com a fivela do seu cinto.

## Sinal antes do ataque

O pó dourado no ar parado. Se ele está ali, elas passaram há pouco — e voltam pelo mesmo caminho.

## Ataques

- **Sopro de pó** — não causa dano; impõe complicação de visão e uma
  contagem de barulho (espirro) que o mestre deve usar pra puxar um encontro
  próximo
- **Ferroada rasa** — dano leve, só se o alvo insistir em ficar embaixo da
  nuvem

## Fraquezas

- **Atributo — Inteligência:** o truque delas é distrair — um ataque que usa Inteligência, de quem acompanhou o rastro de pó em vez do brilho, causa +1d6 de dano extra.
- As asas param no pouso, e no pouso dá para agarrar.
- Não sabem recusar coisa brilhante oferecida de propósito.
- Sozinha, uma fada não rouba nada. Elas precisam de três.

## Tabela de drop

| Item | Raridade | Qtd | Chance | Serve pra |
|---|---|---|---|---|
| Pó Dourado | Comum | 1-2 | 70% | Alquimista, Joalheiro |
| Asa Translúcida Fina | Incomum | 1 | 30% | Costureiro |
| Néctar de Flor Rara | Incomum | 1 | 20% | Alquimista, doma de Domador |
| Col | — | 70-120 | 100% | — |

<!-- convertido-dnd5e -->

## Stat Block D&D 5e

Convertido automaticamente pela fórmula da Seção 73 do `SAO_RPG_5e.md` (Nível de Ameaça **comum**, Andar 1). Os textos de "Ataques"/"Fraquezas" acima são flavor histórico (PBTA) — a mecânica real de jogo é esta:

- **CA:** 11
- **PV:** 26 (4d8+8)
- **Bônus de Ataque:** +3
- **CD de Resistência:** 11
- **Atributo de fraqueza:** Inteligência — um ataque que usa Inteligência contra esta criatura causa +1d6 de dano extra (Seção 73).

## Lore

O que elas roubam nunca é o que vale mais. É sempre o que brilha mais, e as duas coisas quase nunca coincidem — o que faz delas o melhor teste de caráter barato do andar. Um grupo descobre muito rápido quem trouxe o quê, quando uma fada leva a única coisa que alguém não queria mostrar que estava carregando.

*Elas não levam o que é caro. Levam o que você estava escondendo.*

## Notas para o mestre

É a criatura de **doma utilitária** do andar: domada (4 sucessos, com Néctar
de Flor Rara), vira uma fonte de luz viva que acompanha o Domador — ilumina
o suficiente pra ler uma inscrição ou não tropeçar, e nada mais. Não luta,
não carrega, não avisa de perigo. Existe pra dar ao Domador um aliado que
**não** é de combate, porque todo o resto da tabela de doma puxa pra
combate ou montaria.

Boa isca de puzzle: uma Fada da Poeira domada resolve a escuridão da Câmara
da Inscrição e da Gruta de Lumis sem gastar Cristal de Luz — o que faz o
Domador ser convidado pra expedições por um motivo que não é força.

Ligada a: Jardim de Fenwyth (`dados_mapa.js`), tabela de doma em
`docs/economia_profissoes.md`, e ao Néctar de Flor Rara que o Alquimista
também quer.
