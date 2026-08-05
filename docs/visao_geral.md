# Sword Art Online: The Perfect Chaos — Visão Geral do Projeto

Documento de entrada — leia este primeiro. Serve pra qualquer pessoa (ou
IA) que precise entender o projeto inteiro rapidamente: o que é, como o
sistema funciona, o que já existe, onde cada coisa está, e o que falta.
Para o backlog detalhado do que ainda precisa ser feito, ver
`docs/pendencias.md`. Para o passo a passo de **como construir um andar do
zero** (reaproveitando tudo que já foi aprendido no Andar 1), ver
`docs/pipeline.md`.

**Atualizado numa rodada de varredura final** — todos os números abaixo
foram reconferidos programaticamente, não estimados.

## O que é este projeto

RPG de mesa homebrew ambientado no universo de _Sword Art Online_ (anime),
usando um sistema próprio inspirado em PBTA (Powered by the Apocalypse).
Campanha: **"The Perfect Chaos"**, dia 10 depois do anúncio de Kayaba
Akihiko, Andar 1 de Aincrad, antes do primeiro chefe de andar ser
enfrentado — mais um esqueleto inicial do **Andar 2** (pós-Illfang), pronto
pra crescer quando a mesa chegar lá.

**Princípios de design que guiam toda decisão de conteúdo:**

- Roleplay é o foco — combate é deliberadamente a parte menos importante.
- Toda decisão criativa se ancora no cânone real de SAO (anime como fonte
  primária, wiki `swordartonline.fandom.com`) — nunca fantasia genérica.
  Quando não há cânone pra algo (a maior parte do mapa não é detalhada no
  anime), o conteúdo novo segue o _estilo_ de nomenclatura e design de
  Aincrad, não inventa fora do tom da obra.
- O andar 2 é um mistério de verdade — matar o chefe não libera o andar
  sozinho. O gatilho real (Last Attack Bonus + Cristal de Ascensão) é
  conhecido só pelo mestre (ver `docs/misterio_andar2.md`).
- Existe um **segundo mistério, paralelo e não-excludente**: o arco
  "Cardinal" da Temporada 1 (`cenas/cronicas_de_aincrad_indice.md`),
  atravessando 17 dos 50 one-shots. Os dois mistérios nunca se explicam um
  pelo outro — ambos ficam abertos de propósito além do que já foi escrito.
- Conteúdo "de preenchimento" (pontos genéricos de recurso/monstro no
  mapa, itens comuns) pode ser mais simples; conteúdo nomeado/especial
  (NPCs, marcos, quests principais, puzzles) recebe profundidade real —
  modelo de duas camadas usado em todo o projeto.
- Balanceamento entre as 16 profissões e as 22 armas: auditado numa
  varredura final (`docs/balanceamento_armas_oficios.md`) — nenhuma
  profissão fica sem renda própria, e o único desequilíbrio estrutural
  real (Conhecimento sem item Raro em arma) foi corrigido.
- **VTT (Foundry ou qualquer outro) está fora de escopo, por decisão do
  usuário.** `base/foundry_sistema/` continua vazia de propósito — não é
  pendência, é escopo explicitamente descartado. O Compêndio HTML
  (`scripts/web/compendio_andar1.html`) é o único "app" que este projeto
  precisa.

## O sistema de jogo

Fonte completa: `docs/guia_sistema_aincrad.md` +
`docs/regras_nucleares_campanha.md` (Moves Núcleo, Condições, Progresso por
Marcos, Downtime, Favor/Suspeita, Preparação de Raid — cobre o que os
capítulos 12/13 do manual físico cobririam, antes deles serem
fotografados).

- **Resolução:** 2d6 + atributo. **10+** sucesso limpo. **7-9** sucesso
  com complicação/custo. **6-** fracasso ou complicação séria.
- **5 atributos:** Corpo, Reflexo, Conhecimento, Espírito, Técnica. Criação
  de personagem distribui **-2, -1, -1, -1, 0** — ninguém começa forte.
- **22 tipos de arma**, cada um com atributo principal fixo, Marca, Move de
  Combate e Move Utilitário (tabela completa em `guia_sistema_aincrad.md`).
  Arma e profissão são escolhas **independentes** — não precisam
  compartilhar atributo.
- **7 slots de equipamento:** Armaduras, Escudos, Capuz, Acessórios,
  Luvas, Parte de Cima, Parte de Baixo.
- **16 profissões**, cada uma com atributo, Marca, Move de Ofício e Move de
  Cena — tabela completa e cadeia de produção em
  `docs/economia_profissoes.md`.
- **Combate:** monstros têm "golpes para derrotar" por tier — fraco 1-2,
  comum 3-4, forte 5-7, elite 8-10, chefe = várias barras de 6-8 golpes.
- **PvP/Duelos/Player Killing** (cap. 5 do manual, ainda homebrew — ver
  `guia_sistema_aincrad.md`): zona segura bloqueia todo PvP por sistema;
  fora dela, Duelo Selado (sem risco de morte) ou Duelo de Sangue
  (consensual, risco real); PK confirmado derruba Suspeita pra -3 na hora.
- **Doma (Domador):** mesma lógica de barra de sucessos do combate — N
  sucessos em 2d6+Técnica antes de 2 falhas, N escala com o tier de ameaça.
  Tabela completa em `docs/economia_profissoes.md`.
- **Raridade (material):** Comum → Incomum → Raro → Épico (só chefe).
  **Raridade (equipamento):** Comum → Incomum → Raro → Único.
- **Cristais (6 tipos):** Teleporte, Cura, Antídoto, Luz, Barreira, Outros.
- **4 elementos** (Fogo, Trovão, Gelo, Veneno) — nunca somam número, negam
  a reação do monstro na fraqueza certa. Ver `docs/elementos_andar1.md`.

## Estrutura de pastas

```
SAO RPG/
  docs/                  guias de sistema, economia, lore, pipeline, pendências, balanceamento
  mapas/                 mapa narrativo (andar_1.md, andar_2.md) + arte gerada
  cidades/               fichas de cidade (Cidade do Início, Urbus)
  npcs/                  fichas de NPC (.md, uma por personagem) — andar 1 e 2
  monstros/              fichas de bestiário (.md, uma por criatura) — andar 1 e 2
  armas/                 fichas de arma/item (.md, uma por item) + catálogo expandido
  cenas/                 quests (andar 1 e 2) + as 50 Crônicas de Aincrad (Temporada 1)
  guias/                 GUIA DO MESTRE das 30 regiões do andar 1 + guias/pontos/ (ficha por ponto)
  efeitos_sonoros/       SFX gerados
  musicas/               trilha sonora gerada
  imagens/               retratos de NPC, monstro, arma (geradas via ComfyUI)
  equipamentos/          catálogo dos 7 slots (66 itens, um arquivo por slot)
  Comidas/, pocoes/      catálogos de receita (Cozinheiro, Alquimista)
  scripts/               geradores (Python, chamam Ollama local) + scripts/web/ (Compêndio HTML)
  scripts/web/
    compendio_andar1.html         ★ O APP. Pôster + mapa + escudo de campanha, 15 abas
    dados_mapa.js                 mapa do andar 1: 30 regiões, 276 pontos (escrito à mão, calibrado)
    dados_dungeons.js             layout interno das 4 dungeons do andar 1
    dados_conteudo.js             GERADO por scripts/gerar_dados_web.py — não editar à mão
  base/                  material de referência que o usuário forneceu (manual do jogador em imagem)
```

## O que já existe (inventário — contagens reais)

### Compêndio do Andar 1 — o app

`scripts/web/compendio_andar1.html` — um arquivo, **15 abas**: Mapa, Cidade
do Início, Dungeons, Guia das Regiões, Puzzles, Ofícios, Sistema, Mesa,
NPCs, Bestiário, Armas, Equipamentos, Mercado, **Quests**, **Crônicas**
(nova) e Só o Mestre.

`scripts/gerar_dados_web.py` lê os `.md` de `monstros/`, `npcs/`, `armas/`,
`equipamentos/`, `docs/mercado_andar1.md`, `cenas/quests_andar1.md` e as
duas `cenas/cronicas_de_aincrad_ep*.md`, e escreve
`scripts/web/dados_conteudo.js`. Escreveu ficha nova? Roda o script.

**Nota:** os monstros/NPCs do Andar 2 (4 monstros, 6 NPCs — ver abaixo)
também são lidos por serem genéricos ao diretório, e aparecem hoje
misturados às abas Bestiário/NPCs do app do andar 1, que ainda não filtra
por `andar`. Sem problema funcional, só falta de distinção visual — ver
`docs/pendencias.md`.

### O mapa do Andar 1

`scripts/web/dados_mapa.js` — **30 regiões, 276 pontos** de interesse
(subiu de 237: +3 spawns criados numa rodada recente + os que já existiam).
**86 desses pontos** (8 regiões prioritárias + a capital) têm ficha própria
em `guias/pontos/` — leitura em voz alta, tabela de ação com teste, nota só
do mestre, atalhos clicáveis. Restam 21 regiões (~155 pontos) sem ficha
própria própria, usando só a descrição genérica do `dados_mapa.js`.

Os campos `requer`/`revela` de cada ponto são **vestigiais** (de um design
de fog-of-war já removido) — documentado no cabeçalho do próprio arquivo.

### Quests do Andar 1 — 56 + 4 com prosa completa = 60

`cenas/` (4 com prosa completa: `01_javalis_na_pastagem.md` a
`04_o_caminho_ate_o_labirinto.md`) + `cenas/quests_andar1.md` (56 quests) +
`cenas/contratos_de_oficio.md` (16 contratos, um por profissão). Todas com
gancho, beats, testes, NPCs com responde/recusa, encontro nomeado quando
aplicável, e recompensa concreta. Auditadas ponta a ponta numa varredura
final — 0 referências quebradas de `requer`/`desbloqueia`.

### Crônicas de Aincrad — Temporada 1 (50 one-shots)

`cenas/cronicas_de_aincrad_indice.md` + `cenas/cronicas_de_aincrad_ep01_25.md`
+ `..._ep26_50.md` — 50 episódios standalone (qualquer trio pode jogar
qualquer um), organizados em **Arco A** (vida cotidiana em Aincrad, a
maioria) e **Arco B** ("Cardinal", 17 episódios formando um mistério
contínuo sobre a natureza do próprio Aincrad, sem nunca contradizer
`docs/misterio_andar2.md`). Elenco recorrente com fichas próprias:
`npcs/o_sentado.md`, `npcs/mercador_de_memorias.md`,
`npcs/crianca_da_floresta.md`; monstros/entidades:
`monstros/enxame_de_abelhas_douradas.md`, `monstros/slime.md`,
`monstros/sem_cor.md`. Integrado ao Compêndio (aba **Crônicas** própria).

### Bestiário — 49 criaturas (45 andar 1 + 4 andar 2)

`monstros/` — canônicas (Frenzy Boar, Little Nepenthes, Stabbing Wasp,
Ruin Kobold Trooper/Sentinel, Illfang the Kobold Lord, Baran o Rei Touro) +
homebrew grounded no estilo de Aincrad. Cada uma com aparência,
comportamento, ataques, 4 fraquezas (elemental + 3 posicionais/táticas),
tabela de drop e status de doma explícito.

### NPCs — 50 (44 andar 1 + 6 andar 2)

`npcs/` — personagens com ficha de conversa, limite, mudança após a
primeira cena e gancho.

### Armas — 51 itens nos 22 tipos canônicos

`armas/` — 22 fichas individuais + `armas/00_catalogo_expandido.md` com 29
itens (22 Incomum, um por tipo + 7 Raro, um por atributo — corrigido numa
auditoria de balanceamento, ver `docs/balanceamento_armas_oficios.md`).

### Equipamentos — 66 itens nos 7 slots

`equipamentos/` — auditado: distribuição por slot e por raridade já
equilibrada (8-12 itens por slot, exatamente 1 Raro por slot), nenhuma
mudança necessária.

### Mercado — 18 vendedores com preço e estoque

`docs/mercado_andar1.md` — inventário e preço por NPC vendedor + tabela de
renda por profissão (as 16, reconfirmada balanceada).

### Dungeons — layout interno das 4 (Andar 1)

`mapas/dungeons_andar1.md` + `scripts/web/dados_dungeons.js` — Labirinto,
Caverna de Mournhall, Gruta de Lumis, Dungeon Oculta.

### Guias de mestre — 30 regiões (Andar 1)

`guias/00_como_usar.md` a `04_norte_e_o_labirinto.md` — cobre o mesmo papel
que o capítulo "Mestre" do manual físico cobriria (ver
`docs/pendencias.md`, item de capítulos).

### Andar 2 — esqueleto inicial

`docs/historia_campanha_andar2.md` (abertura), `mapas/andar_2.md` (esboço
de regiões), `cidades/urbus.md` (cidade principal, nome canônico), 4
monstros (incl. **Baran, o Rei Touro** — chefe de andar, nome/forma
canônicos, combate homebrew), 6 NPCs, `cenas/quests_andar2.md` (9 quests:
chegada → tutorial de combate → disputa social pela água → raid final).
Ainda não tem Compêndio próprio nem regiões além de Urbus — ver
`docs/pipeline.md` pro passo a passo de como continuar.

### Economia e mecânicas de profissão

`docs/economia_profissoes.md` — as 16 profissões com mecânica própria,
cadeia de produção, tabela de doma completa, mecânicas de mapa pra
Cartógrafo e Bibliotecário, tabela de material por monstro/zona.

### Segredos, puzzles e mistérios

`docs/interacoes_e_segredos.md` (4 interações de chegada + 4 puzzles
multi-etapa do andar 1), `docs/puzzles_andar1.md` (7 puzzles como
aventuras completas), `docs/misterio_andar2.md` (segredo real do andar 2,
só mestre), `cenas/cronicas_de_aincrad_indice.md` (arco Cardinal, segredo
paralelo, só mestre).

### Trilha sonora — 23 faixas

`musicas/` — abertura, ambiente de cidade/dungeon, combate comum/épico/
chefe, vitória, momento emocional.

## Como tudo se conecta

- **Mapa → NPCs/Monstros/Armas**: pontos do mapa com `ref` apontam pra um
  id em `NPCS`/`MONSTROS` — clicar no ponto mostra a ficha completa.
  Conferido: 0 refs quebradas nos 57 pontos de categoria monstro.
- **Mapa → Quests**: quests referenciam pontos/regiões do mapa por nome; a
  cadeia de quests usa `requer`/`desbloqueia` (esse sim, ativo e lido pelo
  Compêndio, ao contrário do `requer`/`revela` de ponto de mapa).
- **Monstros → Economia**: tabela de material de caça e tabela de doma
  vivem em `docs/economia_profissoes.md`.
- **Puzzles/Quests → Mistério do Andar 2**: várias pistas fragmentadas
  alimentam `docs/misterio_andar2.md` — nenhuma entrega a resposta sozinha.
- **Crônicas → Andar 2**: `EP.50 — Ecos de Aincrad` fecha a Temporada 1
  sem fechar o mistério de Cardinal — o fio continua disponível pro mestre
  puxar de novo quando quiser, em qualquer andar futuro.

## Como o conteúdo é gerado

Pipeline local na máquina do usuário (RTX 4070 Ti) — detalhes completos e
**passo a passo reaproveitável pro Andar 2** em `docs/pipeline.md`:

- **Texto:** Ollama local (`qwen2.5:14b`, com `deepseek-r1:14b` disponível
  pra revisão) gera fichas estruturadas. Muito conteúdo (quests, monstros,
  NPCs, Crônicas, docs de mecânica, esqueleto do Andar 2) foi escrito
  diretamente por mim (Claude), sem passar pelo Ollama, quando a
  qualidade/controle justificava.
- **Imagem:** ComfyUI + checkpoint anime (Animagine XL). Fórmula de
  prompt específica em `docs/guia_estilo_visual.md`.
- **Áudio:** MusicGen local, com continuação de áudio pra consistência
  entre segmentos.

## Próximo passo

Ver `docs/pendencias.md` para o backlog completo, priorizado, do que
ainda falta — e `docs/pipeline.md` pro roteiro de como construir o Andar 2
mais rápido, reaproveitando a ordem que funcionou no Andar 1.
