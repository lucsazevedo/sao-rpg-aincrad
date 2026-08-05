---
andar: 1
nome: Aincrad — Andar 1
---

# Mapa do Andar 1

Pesquisa real na [SAO Fandom Wiki](https://swordartonline.fandom.com/wiki/1st_Floor_(Aincrad))
(resumido/adaptado, não é cópia literal). Este documento é a referência
narrativa/geográfica; o mapa jogável de verdade é o **Compêndio** em
`scripts/web/compendio_andar1.html` (dados em `scripts/web/dados_mapa.js` —
30 regiões, 305 pontos com teste PBTA/recompensa/fluxo de descoberta; arte de
fundo em `mapas/andar_1_placa.png`, com fallback pra `andar_1_mapa_arte.png`)
e as 60 quests em `cenas/`.

O **interior** das dungeons deste andar (Labirinto, Caverna de Mournhall,
Gruta de Lumis, Dungeon Oculta) vive em `mapas/dungeons_andar1.md`.

## Geografia geral

O andar 1 é **geograficamente o maior andar** de Aincrad: quase totalmente
circular, ~10km de diâmetro (~80km²). Ao contrário dos andares mais altos,
não tem um tema dominante — é terreno misto (campos, floresta, lago,
montanha).

```
                         (montanhas — ruinas, vales,
                          monstros fortes demais p/ inicio)
                                    |
              FLORESTA (NO)        |        LAGO (NE)
              Horunka  ●           |
                    \               |
                     \              |
                      \             |          1F LABIRINTO (norte)
                       \            |          entrada = torre 300x100m
                        \           |          -> leva ao andar 2
                         \          |          guardada por um Field Boss
                          \         |          20 sub-niveis ate a sala
                           \        |          do chefe (Illfang)
        CIDADE DO INICIO ●--campos--+
        (centro/inicio)   (Frenzy Boar)
                           \
                            \
                             ● Tolbana
                               (2a maior cidade do andar,
                                ~30 min da entrada do labirinto)
```//
(Diagrama aproximado, não geometricamente preciso — só pra orientação de mesa.)

## Locais

### Cidade do Início (Town of Beginnings)
A maior cidade do andar, ponto de chegada de todo mundo. Ver
`cidades/cidade_do_inicio.md` pra detalhes (praça, Castelo de Ferro Negro,
lojas, NPCs).

### Campos ao redor da Cidade do Início
Terreno aberto logo fora da cidade — território de **Frenzy Boar** e
**Stabbing Wasp** (ver `monstros/`). Primeiro lugar onde personagens novos
treinam combate. Logo na saída da cidade, um caminho se divide em duas
direções:

- **Planície de Verrun** (a oeste) — rota mais tranquila, cheia de NPCs de
  quest e monstros fracos/médios (Frenzy Boar, Stabbing Wasp). Corresponde
  à área que o jogo mobile *Integral Factor* chama de "Quest Plains" —
  nome mantido como referência de fonte, não como nome de mesa.
- **Estepes de Kaldan** (a leste) — rota um pouco mais dura, com Stabbing
  Wasp, lobos e **Little Nepenthes** com mais frequência. Equivalente à
  "Rivalry Plains" do *Integral Factor*.

Ambas as rotas eventualmente levam a **Tolbana**.

### Floresta (noroeste) + Horunka
Região de floresta densa a noroeste da Cidade do Início. Dentro dela fica
**Horunka**, uma vila pequena (~10 construções: pousada, loja de armas,
loja de ferramentas) — boa base de caça avançada. Importante: os monstros
que aparecem ao redor de Horunka **não causam paralisia nem destroem
equipamento** — é uma área relativamente seguem pra caçadas mais longas.
Provável habitat de **Little Nepenthes** (monstro-planta).

### Lago (nordeste)
Região de lago a nordeste da Cidade do Início. Pouco documentado —
bom espaço em branco pra ganchos originais (pesca, NPC recluso, ruína
submersa).

### Montanhas (anel externo)
Além da floresta/lago fica uma região montanhosa com ruínas e vales —
monstros mais difíceis, não recomendado pra personagens no dia 10 (ainda
sem ter passado do andar 1).

### Tolbana
Segunda maior cidade do andar 1, a mais próxima da entrada do Labirinto
(~30 min de viagem). Base natural de operações pra grupos que vão encarar
a masmorra. É pra lá que NPCs como Lynx apontam jogadores que perguntam
sobre o Labirinto.

### Labirinto do Andar 1 (dungeon)
Fica na borda norte do andar. A entrada é parte de uma torre gigantesca
(300m de largura x 100m de altura) que, na verdade, é a estrutura que leva
ao andar 2. **A entrada é guardada por um Field Boss** — regra geral de
Aincrad é que o Labirinto de cada andar fica bloqueado até esse guardião
cair (não achei o nome documentado desse guardião especificamente pro
andar 1 nesta pesquisa — bom gancho de mistério/aventura em aberto).
Dentro, são **20 sub-níveis** de corredores, armadilhas e becos sem saída
até a sala do chefe (layout jogável sala a sala, agrupado em 5 trechos, em
`mapas/dungeons_andar1.md`), no 20º nível, onde fica **Illfang the Kobold Lord**
com seus Ruin Kobold Sentinels. **Ruin Kobold Troopers** patrulham e
respawnam pelos corredores antes disso.

## Sobre a luta contra Illfang (contexto pra mais adiante)

No anime, é o jogador **Diavel** quem encontra a sala do chefe e convoca uma
reunião geral, compartilhando informação de corretores de informação (info
brokers) e pedindo que os jogadores se unam num grupo grande pra enfrentar
o chefe. Isso é conteúdo natural pra **depois** da primeira aventura —
a luta contra Illfang é um raid de várias equipes, não algo pra um grupo
pequeno recém-criado.

## Nota — imagem visual do mapa

Resolvido: `mapas/andar_1_mapa_arte.png` é a arte de fundo real (vista de
cima, cidade murada central, rio a oeste, lago a sudeste, montanhas no
topo), usada como base do mapa interativo. As coordenadas de todas as
regiões/pontos em `dados_mapa.js` foram calibradas contra essa imagem.
