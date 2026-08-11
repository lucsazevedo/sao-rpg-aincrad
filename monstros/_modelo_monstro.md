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
golpes_para_derrotar: # numero (ou "4x6-8" pra chefes com barras)
abertura: # a abertura concreta, ex "garganta exposta no fim da investida"
atributo_fraqueza: # Corpo | Reflexo | Conhecimento | Espírito | Técnica — ver docs/elementos_andar1.md
resistencias: []
vulnerabilidades: []
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

- **Atributo — <Corpo/Reflexo/Conhecimento/Espírito/Técnica>:** por que uma
  arma cujo atributo principal é esse morde nele. Acertar a fraqueza faz
  7-9 virar 10+ funcional (a criatura não reage), e 10+ tira dele uma
  capacidade pelo resto da cena — diga qual (ver `docs/elementos_andar1.md`).
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

## Lore

Um parágrafo de mundo — o que ele é dentro da ficção, não dentro da regra.
Fecha com uma linha de destaque, em itálico, que a mesa possa repetir.

*Uma frase que resume a ameaça.*

## Notas para o mestre

- **Onde entra:** ids dos pontos de `dados_mapa.js`.
- **Como usar em transmissão:** a imagem ou o som que quem assiste vai lembrar.
- **Erro comum do grupo:** o que jogadores tendem a fazer errado da primeira vez.
- **Como a cena encerra sem HP:** a saída que não é matar.
