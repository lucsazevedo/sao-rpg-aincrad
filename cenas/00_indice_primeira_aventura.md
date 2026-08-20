---
titulo: Índice — Primeira Aventura (Andar 1)
andar: 1
local: Cidade do Início -> Campos -> Tolbana -> Labirinto do Andar 1
tipo: exploracao
npcs_envolvidos: [Lynx, Mulher Aflita, Garota do Arco]
humor_musical: 01_abertura
---

Módulo pronto pra rodar a primeira sessão da campanha "Sword Art Online:
The Perfect Chaos" (dia 10 depois do anúncio, andar 1, pré-chefe -- ver
`docs/historia_campanha.md`). Cobre os quatro tipos de quest canônicos do
jogo (Coleta, Eliminação, Escolta, Investigação/Errand -- ver
`docs/guia_bestiario_andar1.md` e a pesquisa da fandom wiki).

As quatro cenas abaixo foram aprofundadas para rodar bem **na mesa e em
transmissão**: cada uma agora trabalha leitura de abertura, stakes claros,
decisão visível, complicações que não travam a sessão e um gancho visual forte
o suficiente pra prender quem está assistindo.

## Ordem sugerida

1. **[Javalis na Pastagem](01_javalis_na_pastagem.md)** (Eliminação) --
   primeiro combate, ensina o sistema d20+atributo com risco baixo.
2. **[Seiva para a Alquimista](02_seiva_para_a_alquimista.md)** (Coleta) --
   primeira exploração de verdade, apresenta a Mulher Aflita e o Little
   Nepenthes.
3. **[Resgate nos Campos](03_resgate_nos_campos.md)** (Escolta) --
   apresenta a Garota do Arco como aliada em potencial, sobe a tensão.
4. **[O Caminho até o Labirinto](04_o_caminho_ate_o_labirinto.md)**
   (Investigação -> gancho de chefe) -- leva o grupo até Tolbana e a
   entrada do Labirinto, primeiro combate de masmorra (Ruin Kobold
   Trooper), termina com o grupo pronto pra participar do raid contra
   Illfang the Kobold Lord numa sessão futura.

As quests não precisam ser feitas nessa ordem exata nem todas na mesma
sessão -- servem como um menu inicial. O que **não** deveria acontecer na
primeira aventura é a luta contra Illfang em si: no anime é um raid de
várias equipes organizado pelo jogador Diavel, não algo pra um grupo
pequeno recém-formado (ver `monstros/illfang_the_kobold_lord.md`).

## Depois destas quatro: mais 56 quests em cadeia

`quests_andar1.md` cobre o resto do andar 1 até um total de **60 quests**,
organizadas em 8 cadeias temáticas (Horunka, Lago Sylvaine, Montanhas de
Grauvenn, Tolbana, Necrópole de Voss, Mural do Castelo, Preparativos do
Raid, Contratos Avulsos), cada uma com `requer`/`desbloqueia` -- a mesma
lógica de "concluir isso libera aquilo" que o mapa interativo já usa pra
pontos de exploração. `04_o_caminho_ate_o_labirinto.md` desbloqueia
diretamente a cadeia H (`tolbana_05_reconhecimento_do_labirinto`), que é
a ponte até o raid contra Illfang.

Se o resto das 56 quests for revisado no mesmo padrão, usar como checklist:
- `Leia em voz alta`
- `O que está em jogo`
- `NPCs na cena`
- `Complicações úteis`
- `Se o grupo tentar outro caminho`
- `Gancho visual / de transmissão`

## Elenco desta aventura

- **NPCs**: `npcs/lynx.md`, `npcs/mulher_aflita.md`, `npcs/garota_do_arco.md`
- **Monstros**: `monstros/frenzy_boar.md`, `stabbing_wasp.md`,
  `little_nepenthes.md`, `ruin_kobold_trooper.md`, `ruin_kobold_sentinel.md`,
  `illfang_the_kobold_lord.md`
- **Local**: `cidades/cidade_do_inicio.md`, `mapas/andar_1.md`

## Depois da primeira aventura

- Gerar armas/itens de recompensa específicos com `scripts/gerar_arma.py`
- Gerar novas quests/cenas com `scripts/gerar_cena.py` (ex: preparativos
  pro raid, tensão entre guildas sobre quem lidera o ataque a Illfang)
- Trilhas: `03_combate` e `04_combate_epico` já cobrem os combates daqui;
  gerar variações extras com `C:\AI\AudioCraft\gerar_sao.py` se quiser
