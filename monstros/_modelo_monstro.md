---
nome:
epiteto: # "Capanga do Lorde Kobold", "Boss do 1º Andar" -- vazio se não tem hierarquia
tipo: # besta | planta | humanoide | morto-vivo | construto | inseto | chefe_de_andar
andar: 1
zona: # Floresta e Planícies Iniciais | Águas e Pântanos | Ruínas e Necrópole | Montanhas e Penhascos | Labirinto
local: # campo | caverna | dungeon/labirinto | dungeon_oculta | água | cidade
regioes: [] # ids de dados_mapa.js onde ele aparece de verdade
nivel_recomendado: # faixa, ex "4-5" -- o andar 1 vai até 10
nivel_ameaca: # fraco | comum | forte | elite | chefe
ca: # CA numérica -- ver Seção 73 do SAO_RPG_5e.md pra referência por Nível de Ameaça/andar
dado_vida: # ex "4d8+8" -- dado pelo tipo (d6 inseto pequeno, d8 besta/humanoide/morto-vivo, d10 planta/construto, d12 chefe de andar); o total tem que bater com o campo pv abaixo
pv: # PV numérico, igual ao total do dado_vida acima -- mesma referência de Seção 73
bonus_ataque: # ex "+3"
cd_resistencia: # ex "11"
abertura: # a abertura concreta, ex "garganta exposta no fim da investida"
atributo_fraqueza: # Força | Destreza | Inteligência | Sabedoria -- só esses 4 (Seção 65 do SAO_RPG_5e.md); um ataque que usa esse atributo causa +1d6 de dano extra (Seção 73)
resistencias: [] # tipos de dano, não atributo
vulnerabilidades: [] # tipos de dano, não atributo
imagem: # ../imagens/monstro_<slug>.png
canonico: # sim (wiki/anime) | nao (homebrew)
fonte: # link da fandom wiki, se canonico
---

## Habitat

Onde ele vive, em uma ou duas frases concretas. Cite as regiões pelo nome.

**Comportamento:** passivo ou agressivo, como se move, com quem anda, o que o
faz atacar. Este parágrafo é o que o mestre lê para decidir se a luta começa.

## Aparência

O que a mesa vê. Objetivo: reconhecer a criatura em dois segundos.

## Leia em voz alta

> Um parágrafo curto e forte, escrito para ser lido sem adaptar. Concreto:
> cheiro, som, o que se mexe, o que não se mexe.

## Sinal antes do ataque

Qual é o aviso? Som, cheiro, marca no chão, silêncio, mudança na água, poeira,
eco, luz, animal sumindo. Toda criatura entra em cena antes de aparecer.

## Ataques

- **Nome do golpe** — o que faz e o que ele custa a quem toma.

## Fraquezas

Quatro, sempre. A primeira é a de atributo; as outras três são posicionais
ou táticas — coisas que a mesa descobre olhando, não rolando.

- **Atributo — <Força/Destreza/Inteligência/Sabedoria>:** por que uma arma
  cujo atributo principal é esse morde nele (deve bater com o
  `atributo_fraqueza` do frontmatter). Um ataque que usa esse atributo
  contra o ponto certo causa **+1d6** de dano extra (Seção 73 do
  `SAO_RPG_5e.md`). A fraqueza é descoberta em jogo (observação, teste de
  Sistema, Caçador/Mercenário/Informante, comportamento do próprio
  monstro) — nunca informação de graça.
- Abertura de posição.
- Abertura de ritmo (depois de que ação ele fica exposto).
- Fraqueza de contexto (sozinho, no escuro, na água, longe do grupo).

## O que torna este encontro memorável

O que muda quando ele entra? Terreno, ritmo, moral, visão, som. Monstro bom
não é número de golpes: ele obriga a mesa a agir diferente.

## Complicações úteis

- O grupo vence, mas perde posição.
- O grupo percebe tarde qual era o padrão de caça.
- O terreno ajuda a criatura mais do que parecia.
- Ela recua em vez de morrer e volta de outro ângulo.

## Tabela de drop

Raridade de **material**: Comum · Incomum · Raro · **Épico** (só chefe).
Não confundir com a raridade de **equipamento**, que vai até Único.

| Item | Raridade | Qtd | Chance | Serve pra |
|---|---|---|---|---|
| | Comum | 1-2 | 60% | Costureiro |
| | Incomum | 1 | 30% | Alquimista |
| Col | — | 90-140 | 100% | — |

## Stat Block D&D 5e

- **CA:** [bate com `ca` do frontmatter]
- **PV:** [bate com `pv`] ([bate com `dado_vida`, ex. 4d8+8])
- **Bônus de Ataque:** [bate com `bonus_ataque`]
- **CD de Resistência:** [bate com `cd_resistencia`]
- **Atributo de fraqueza:** [bate com `atributo_fraqueza`] — um ataque que usa esse atributo contra esta criatura causa +1d6 de dano extra (Seção 73).

## Lore

Um parágrafo de mundo — o que ele é dentro da ficção, não dentro da regra.
Fecha com uma linha de destaque, em itálico, que a mesa possa repetir.

*Uma frase que resume a ameaça.*

## Notas para o mestre

- **Onde entra:** ids dos pontos de `dados_mapa.js`.
- **Como usar em transmissão:** a imagem ou o som que quem assiste vai lembrar.
- **Erro comum do grupo:** o que jogadores tendem a fazer errado da primeira vez.
- **Como a cena encerra sem HP:** a saída que não é matar.
