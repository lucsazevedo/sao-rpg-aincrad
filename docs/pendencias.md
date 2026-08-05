## Novo nesta rodada — pipeline de imagem de item corrigida (armas/equipamentos)

Usuário reportou, olhando o Compêndio: NPC Criança da Floresta "sem
imagem" (na verdade existe em disco, `imagens/npc_crianca_da_floresta.png`
— provavelmente cache de navegador desatualizado, pedir refresh), alguns
monstros também reportados como sem imagem (0 confirmados sem imagem numa
reconferência — mesma suspeita de cache), variação grande de estilo entre
monstros, e o pior: **armas/equipamentos gerando personagens (gente) em
vez do item isolado.**

**Causa raiz confirmada visualmente** (`imagens/arma_martelo_do_mural.png`
mostrava uma guerreira anime empunhando o martelo, em vez do martelo
sozinho): `fila_armas`/`fila_equipamentos` em `scripts/gerar_faltantes.py`
nunca usavam `--prompt-bruto` nem tinham negativo dedicado — o pedido em
português ia direto pro Ollama com o **mesmo schema genérico de
personagem** usado pra NPC, que interpretava "descrição de arma" como
"descrição de guerreiro empunhando a arma" com frequência alta e
imprevisível.

**Corrigido:**
- `scripts/gerar_imagem.py` ganhou um modo `--item` de verdade: schema
  próprio (`SCHEMA_ITEM`/`montar_system_item`) que instrui "descreva só o
  objeto, nunca gente segurando/vestindo", **mais** uma trava no código
  (não só no prompt) que força `"no humans, solo, "` no início do positivo
  se faltar, e mescla `NEG_ITEM_BASE` (humanos, mãos, segurando, vestindo,
  corpo humano, guerreiro...) automaticamente — não depende do Ollama
  "lembrar" nada.
- `fila_armas` e `fila_equipamentos` em `gerar_faltantes.py` agora passam
  `--item` sempre.
- `docs/guia_estilo_visual.md` ganhou a seção "Itens" (mesmo tratamento que
  a seção "Monstros" já tinha) + uma nota sobre reduzir variação de estilo
  entre monstros (evitar adjetivo de drama/atmosfera excessivo nos prompts
  hand-written, manter só a fórmula).
- Testado e confirmado: Chicote de Raiz-Mãe, que saiu como uma cena de
  portão decorativo com espada antes, saiu como produto isolado (chicote
  de vinha, sem gente) depois do fix.
- **Regeneração completa em andamento**: as 117 imagens de arma+equipamento
  existentes estão sendo refeitas com `--refazer` usando a pipeline nova,
  em background (~1-1h30). Resultado final e contagem a confirmar depois
  que terminar.

## Novo nesta rodada — varredura final do projeto

Pedido do usuário: varredura completa antes da reta final — documentar
tudo pro Andar 2 ficar mais rápido, comparar armas/profissões, achar e
melhorar o que não estiver bom, fechar histórias, e descartar VTT do
escopo. Resultado:

- **Inventário reconferido programaticamente** (não estimado): 49
  monstros, 50 NPCs, 51 armas, 66 equipamentos, 56+9 quests (andar 1+2),
  16 contratos de ofício, **50 Crônicas**, 86 pontos de mapa com ficha
  própria, 276 pontos de mapa no total, 42 documentos em `docs/`.
- **`docs/visao_geral.md` reescrito do zero** com todos os números atuais
  — estava desatualizado há duas rodadas (contagens antigas de monstro,
  NPC, ponto e aba do Compêndio).
- **`docs/pipeline.md` expandido num playbook completo**: ordem de 10
  passos pra construir um andar do zero (ancoragem canônica → abertura →
  cidade → NPCs → monstros → mapa esboçado → quests de entrada → puzzles →
  itens → Compêndio completo → imagem/áudio), mais uma seção de "lições
  da varredura final" com o que fazer diferente no Andar 2 pra não repetir
  retrabalho (ex: sempre conferir elenco existente antes de criar NPC
  novo; conferir balanceamento por atributo cedo, não só no fim; manter os
  três documentos-resumo atualizados na mesma sessão que gera conteúdo).
- **`docs/balanceamento_armas_oficios.md` — nova auditoria de
  balanceamento.** Achado real: distribuição de armas e profissões por
  atributo é desigual (Técnica é o atributo mais bem servido combinando
  arma+profissão, Espírito o menos), mas isso é estrutural ao sistema (22
  armas + 16 profissões fixas) e arma/profissão são escolhas
  independentes — nota explicativa disso foi adicionada a
  `guia_sistema_aincrad.md`. **Achado corrigido de verdade:** Conhecimento
  (Chicote/Pá) era o único atributo sem nenhum item Raro no catálogo de 50
  armas — corrigido com **Chicote de Raiz-Mãe** (Raro), fonte concreta na
  Mãe-Raiz de Horunka. Equipamentos (7 slots) e renda por profissão já
  estavam corretos, conferido sem necessidade de mudança.
- **Fios narrativos conferidos programaticamente**: 0 referências
  quebradas em `requer`/`desbloqueia` de quests (andar 1 e 2), 0 menções a
  episódios de Crônicas inexistentes, todos os 50 EP.XX existem e resolvem.
  Arco Cardinal confirmado como intencionalmente aberto (não é bug).
- **Qualidade — `dados_mapa.js`**: cabeçalho do arquivo estava descrevendo
  `requer`/`revela` de ponto como se controlassem visibilidade no
  Compêndio; conferido no código que isso é **vestigial** (fog-of-war foi
  removido numa rodada anterior) — comentário corrigido pra não induzir
  erro em trabalho futuro.
- **VTT/Foundry marcado como fora de escopo definitivo**, por pedido
  explícito do usuário — não é mais pendência, não reabrir.
- **17 monstros ganharam prompt de imagem** que faltava em
  `scripts/gerar_faltantes.py` (`PROMPTS_MONSTRO` só cobria os mais
  antigos) — incluindo Baran o Rei Touro, Rei das Planícies, Alfa Lupino e
  os monstros novos do Andar 2. Lote gerado com ComfyUI ligado nesta
  sessão (ver resultado ao final desta rodada, abaixo do resumo).

## Rodada anterior — itens 4 a 8 do backlog fechados/atualizados

Pedido do usuário: "faça do 4 ao 8" (numeração da lista de pendências então
vigente: quests, dados_mapa.js, guias/pontos, Andar 2, capítulos do manual).
Resultado real, por item:

**4. Passe de profundidade nas quests — na prática, já estava quase
completo.** Lido `cenas/quests_andar1.md` inteiro (3680+ linhas, 56
quests): a esmagadora maioria já tinha monstros explícitos, NPCs com
responde/recusa/se pressionado e recompensa nomeada — rodada de trabalho
anterior que não tinha sido refletida aqui. Only 3 lacunas reais
encontradas e corrigidas: `horunka_03_madeira_que_nao_serve`,
`tolbana_e03_corretores_desconfiados` e `castelo_04_guarda_insone`
ganharam seção **NPCs na cena** que faltava apesar de terem NPC no
cabeçalho. Busca por recompensa genérica ("material Incomum" sem nome)
não achou ocorrência real — já estava tudo nomeado.

**5. `dados_mapa.js` refs — também já estava resolvido.** Os "50 de 55
spawns sem ref" citados abaixo eram contagem antiga; conferido
programaticamente: **0 de 57** pontos de categoria monstro estão sem
`ref` hoje. O que realmente faltava — pontos próprios pra Fada da Poeira,
Gafanhoto Gigante e Serpente das Águas Rasas — foi criado (Jardim de
Fenwyth, Terraços de Solveig, Ilha de Pemberton). Sintaxe conferida com
`node --check`.

**6. `guias/pontos/` — 8 regiões prioritárias fechadas (68 pontos novos).**
Seguindo a ordem já sugerida abaixo: `campos_oeste.md`, `campos_leste.md`,
`floresta_horunka.md`, `tolbana.md`, `labirinto_entrada.md`,
`castelo_ferro_negro.md`, `torre_relogio.md`, `necropole.md`. Total agora:
**86 de 241 pontos** com ficha própria (era 18). Restam 21 regiões (~155
pontos) fora deste escopo — próxima leva natural: Grauvenn, Sylvaine,
Molwyn/Solveig, Voss/Ruyn, Lumis/Mournhall, Vaelor/Braxhold, e as vilas
menores (Brenmoor, Corvain, Ashwen etc.).

**7. Andar 2 — esqueleto inicial criado**, conforme escopo escolhido pelo
usuário (não o andar inteiro): `docs/historia_campanha_andar2.md`
(abertura, ancorada em `docs/misterio_andar2.md`), `mapas/andar_2.md`
(esboço de regiões), `cidades/urbus.md` (cidade principal, nome canônico),
4 monstros novos (`monstros/touro_das_colinas.md`,
`monstros/aguia_do_planalto.md`, `monstros/centopeia_do_aqueduto.md`,
`monstros/baran_o_rei_touro.md` — chefe de andar, nome/forma canônicos,
combate homebrew), 6 NPCs novos (`npcs/engenheira_dos_aquedutos.md`,
`npcs/comerciante_de_agua.md`, `npcs/guardia_de_urbus.md`,
`npcs/lider_da_faixa_verde.md`, `npcs/contrabandista_de_agua.md`,
`npcs/lider_da_travessia.md`) e `cenas/quests_andar2.md` (9 quests, chegada
até o raid contra Baran). **Sem app/Compêndio próprio ainda** — os
monstros/NPCs novos aparecem hoje misturados às abas Bestiário/NPCs do
Compêndio do andar 1 (que não filtra por `andar`); considerar adicionar
esse filtro quando o andar 2 crescer além do esqueleto.

**8. Capítulos do manual — cap. 5 (PvP/Duelos/PK) escrito como homebrew**
em `docs/guia_sistema_aincrad.md`, claramente marcado como não-oficial
(capítulo real ainda não fotografado). **Cap. 12 (Evolução/XP) e cap. 13
(Mestre) já estavam cobertos** por `docs/regras_nucleares_campanha.md`
("Progresso por Marcos" etc.) e `guias/00_como_usar.md` respectivamente —
outra pendência que já tinha sido resolvida sem atualizar este arquivo.
Não escrevi conteúdo novo redundante pra esses dois; só confirmei e deixo
registrado aqui.

**Validação desta rodada:** `python scripts/gerar_dados_web.py` rodado sem
erro (MONSTROS 45→49, NPCS 44→50, PONTOS_DETALHE 18→86, CRONICAS 50).
Sintaxe conferida com `node --check` em `dados_conteudo.js` e
`dados_mapa.js`. Imagens continuam fora do alcance desta sessão — ComfyUI
e Ollama não estavam rodando (ver rodada anterior, item de Crônicas,
abaixo).

## Novo na rodada anterior — Crônicas de Aincrad (50 one-shots)

`cenas/cronicas_de_aincrad_indice.md` + `cenas/cronicas_de_aincrad_ep01_25.md`
+ `cenas/cronicas_de_aincrad_ep26_50.md`: as 50 ideias de aventura do PDF do
usuário (`SAO_Cronicas_de_Aincrad_50_Aventuras.pdf`, ver `docs/fontes.md`)
aprofundadas no mesmo padrão de `cenas/quests_andar1.md` (gancho, leia em voz
alta, o que está em jogo, beats, testes, NPCs, encontro, complicações,
recompensas, gancho pra próxima cena, gancho visual). Reaproveita o elenco e
bestiário já catalogados sempre que possível (Suri Cartógrafa, Kazuo Tanaka,
Rei das Planícies, Alfa Lupino etc.) e organiza um arco B ("Cardinal") que
atravessa 17 episódios sem contradizer o segredo real de `misterio_andar2.md`
— os dois mistérios ficam paralelos, ambos só do mestre.

**Fechado nesta rodada (o que faltava):**
- **Fichas próprias** pros personagens/criaturas recorrentes do arco B, em
  vez de "crie na hora": `npcs/o_sentado.md`, `npcs/mercador_de_memorias.md`,
  `npcs/crianca_da_floresta.md`, `monstros/enxame_de_abelhas_douradas.md`,
  `monstros/slime.md` (com variantes por fusão), `monstros/sem_cor.md`. Nota
  cruzada adicionada em `npcs/contato_sem_nome.md` ligando-o ao "Homem de
  Capuz Cinza" de EP.16/33.
- **Integração ao Compêndio**: `scripts/gerar_dados_web.py` ganhou
  `carregar_cronicas()` (novo bloco `CRONICAS`, 50 itens) e
  `scripts/web/compendio_andar1.html` ganhou aba própria **"Crônicas"**
  (busca, filtro por Arco A/B, ficha completa por episódio — mesmo padrão
  da aba Quests). Rodado e validado: `dados_conteudo.js` gerado sem erro,
  sintaxe JS do Compêndio conferida com `node --check`.

**Ainda pendente (fora do meu alcance nesta sessão):**
- **Imagens.** ComfyUI (`127.0.0.1:8188`) e Ollama (`127.0.0.1:11434`) não
  estavam rodando nesta sessão — `scripts/gerar_imagem.py` depende dos dois
  localmente. Pendente pro menu de `scripts/gerar_faltantes.py` quando
  estiverem no ar, incluindo os 3 monstros novos desta rodada (Enxame de
  Abelhas Douradas, Slime, Sem-Cor) e os 3 NPCs novos (O Sentado, Mercador
  de Memórias, Criança da Floresta).
- NPCs/monstros exclusivos de um único episódio (sem recorrência entre
  cenas) continuam "crie na hora" (inline) por design — não é lacuna, seguem
  o mesmo padrão que `quests_andar1.md` já usa pros grupos rivais e
  contratantes avulsos.

# Pendências — Sword Art Online: The Perfect Chaos

Backlog com contagens reais conferidas no projeto (não estimadas). Ver
`docs/visao_geral.md` primeiro se este é seu primeiro contato. Organizado por
prioridade de dependência.

---

## O que fechou na rodada do "escudo do mestre"

- **Exploração/fog of war removida.** O Compêndio é escudo do mestre: tudo
  visível, nada escondido pelo app. Quem decide o que os jogadores sabem é
  você, narrando.
- **Ficha completa em tela cheia** para região, quest, NPC, monstro, arma,
  equipamento, puzzle e sala de dungeon — clique em qualquer card.
- **Guia de mestre das 30 regiões** (`guias/`): leia em voz alta, a cena,
  tabela de ações com teste, só o mestre, se demorarem, locais e ligações.
- **7 puzzles reescritos como aventuras** (`docs/puzzles_andar1.md`), com
  recompensa nomeada em vez de "pista solta".
- **NPCs: 12 → 36**, todos com o que respondem, o que se recusam a responder,
  falas prontas e o que acontece se pressionados.
- **Dungeons sala a sala**: 47 salas com texto de leitura, ações, monstros,
  armadilha com teste e tesouro nomeado.
- **Balanceamento:** Moves de Arma e Moves de Profissão atualizados no manual
  (`docs/guia_sistema_aincrad.md`) para manter tudo **Tier S em protagonismo**
  (escolha por personagem, não por “arma mais forte”), usando a regra de
  **Impulso** como prêmio por interpretação.
- **Correção de sistema:** não existe iniciativa (o jogador age, o monstro
  reage), então bônus de "atacar primeiro" foram reescritos como "negar a
  reação".
- **Mapa vetorial v2** (`scripts/web/dados_terreno.js`, 1.100+ elementos):
  contornos em bezier suave (Catmull-Rom) em vez de polígono, ilha com halo e
  faixa de costa, montanhas com face sombreada e neve, mata em três tons com
  sombra por copa, lago com raso e marolas, brejo com juncos, planície com
  tufos de capim, estrada com contorno, ruína com sombra projetada. O terreno é
  desenhado por código a partir das mesmas coordenadas dos pontos — muralha da
  capital, Tolbana, floresta de Horunka, Lago Sylvaine, Rio Coluber, montanhas
  de Grauvenn, torre do Labirinto, estradas. **Nunca desalinha.** O botão
  *Fundo: vetor/arte* alterna com a placa da IA quando ela existir.
- **Moves ligados ao app:** os 22 Moves de Arma e 16 de Profissão do manual
  aparecem na aba Sistema e na ficha de cada arma (Marca + os dois Moves).
- **Planta da Cidade do Início** refeita: usa as posições reais dos 18 pontos,
  com muralha, anéis, ruas radiais, quarteirões, praça, castelo e portões. Ela
  aceita arte por cima — rode `python scripts/gerar_mapa_arte.py cidade` e
  salve como `mapas/cidade_do_inicio_planta.png`; o botão *Arte da planta*
  aparece sozinho.
- **Usabilidade do mapa:** todo ponto tem nome (com anti-sobreposição por
  zoom e botão *Rótulos: todos / marcos / nenhum*), **todo ponto abre ficha**
  no 2º clique — mesmo sem arquivo próprio, o app monta a ficha com o que
  existe em `dados_mapa.js` + a ficha ligada + o mercado.
- **Atalhos cruzados:** ponto → NPC, monstro, região e vizinhos; NPC → o ponto
  dele no mapa, a região e **a tabela de preços da loja**; monstro → regiões
  onde aparece; item → **quem vende e por quanto**; guia de região → os pontos
  daquela região.
- **Níveis normalizados para o teto 10** no andar 1 — tabela de áreas do app,
  os 30 guias de região e as 4 dungeons.
- **Bug estrutural corrigido:** o HTML tinha 149 linhas de JavaScript coladas
  dentro do `<style>` e um documento inteiro duplicado (dois `<body>`). Isso
  quebrava CSS e deixava os Moves sem função. Arquivo reconstruído, 0 erros.

## O que fechou na rodada anterior

- **Compêndio unificado** (`scripts/web/compendio_andar1.html`) — pôster +
  mapa interativo + todos os catálogos num arquivo só, 13 abas.
- **Equipamentos**: 66 itens nos 7 slots (`equipamentos/`).
- **Armas**: 50 no total (22 fichas individuais + 28 no catálogo expandido),
  com Moves de Arma (combate + utilitário) no manual.
- **Mercado**: 18 vendedores com preço e estoque (`docs/mercado_andar1.md`).
- **Bestiário**: 34 escritos, incluindo Hound de Cobre (escolta) e Mimic de
  Marcos (leitura de rota).
- **Dungeons**: layout interno das 4 (`mapas/dungeons_andar1.md` +
  `scripts/web/dados_dungeons.js`).
- **Pipeline de dados**: `scripts/gerar_dados_web.py` — os `.md` viraram a
  fonte única; o app não desatualiza mais sozinho.
- **Pipeline de arte de mapa**: `scripts/gerar_mapa_arte.py`.

---

## 0. PRÓXIMA SESSÃO — ligar TODOS os pontos do mapa

**Padrão definido e já rodando na Cidade do Início.** Cada região ganha um
arquivo `guias/pontos/<regiao>.md` com um bloco por ponto:

```
### <id_do_ponto> · Nome do Local
> texto de leitura em voz alta

**O que é:** ...
**O que dá pra fazer:**
| Ação | Teste | 10+ | 7-9 | 6- |
**Só o mestre:** ...
**Atalhos:** npc:xxx · regiao:yyy · puzzle:1 · monstro:zzz
```

`scripts/gerar_dados_web.py` transforma isso em `PONTOS_DETALHE` e o Compêndio
passa a mostrar: caixa de leitura no painel lateral, botão **Ficha do local**,
tabela de ações com teste, notas de mestre e **atalhos clicáveis** que pulam
direto pro NPC, monstro, puzzle ou guia da região. Marcador com conteúdo
próprio ganha **anel dourado** no mapa — dá pra ver de longe o que já foi
feito e o que falta.

**Estado:** 86 de 241 pontos têm ficha própria — a capital (18) + as 8
regiões prioritárias abaixo (68), feitas na rodada "itens 4 a 8". Faltam 21
regiões (~155 pontos).

**Ordem sugerida** (as que o grupo pisa primeiro):

1. ~~`campos_oeste` (Verrun) e `campos_leste` (Kaldan) — a primeira saída~~ ✅
2. ~~`floresta_horunka` — a primeira vila~~ ✅
3. ~~`tolbana` e `labirinto_entrada` — a reta final do andar~~ ✅
4. ~~`castelo_ferro_negro`, `torre_relogio`, `necropole` — os puzzles~~ ✅
5. **o resto** (próximo bloco): Grauvenn, Sylvaine, Kaldrin, Molwyn,
   Solveig, Voss/Ruyn, Lumis, Mournhall, Vaelor, Braxhold, Brenmoor,
   Corvain, Ashwen, Rio Coluber, Estrada de Ombric, Charco de Grenna,
   Pântano de Kavir, Pedreira de Dunhelm, Ilha de Pemberton, Jardim de
   Fenwyth, Covil de Illfang.

**Números que ainda valem** (de `scripts/web/dados_mapa.js`, 276 pontos —
+3 desde a rodada anterior: spawns novos de Fada da Poeira, Gafanhoto
Gigante e Serpente das Águas Rasas):

| Problema | Quantos |
|---|---|
| Spawns de monstro sem `ref` | **0 de 57** — conferido programaticamente, já resolvido |
| Pontos sem teste 2d6+atributo | ~120 (não reconferido) |
| Pontos com descrição copiada de outro ponto | ~158 no `dados_mapa.js` bruto — mitigado nos 86 pontos que já têm `guias/pontos/`, que dão leitura própria por cima da descrição genérica |

## 1. Gerar a placa de arte nova do mapa — AÇÃO SUA

O Compêndio já procura `mapas/andar_1_placa.png` e cai de volta na arte antiga
(`andar_1_mapa_arte.png`) se não achar. A arte antiga é uma vista aérea
genérica de cidade — não é um mapa de andar, e é a maior fraqueza visual do
projeto hoje.

```
python scripts/gerar_mapa_arte.py andar --tentativas 4
```

Escolher a melhor, renomear pra `mapas/andar_1_placa.png`. Depois, as vistas:
`python scripts/gerar_mapa_arte.py todas`.

**Importante:** a geografia do prompt (cidade murada no centro, floresta a
noroeste, lago a sudeste, labirinto ao norte, Tolbana a nordeste) tem que ser
respeitada, senão os 233 marcadores desalinham. Se a arte sair com geografia
diferente e você gostar mesmo assim, me avise — dá pra recalibrar as
coordenadas em `dados_mapa.js`, mas é retrabalho.

## 2. Quests — passe de profundidade ✅ (conferido, quase tudo já estava feito)

Conferidas as 56 quests de `cenas/quests_andar1.md` uma a uma nesta rodada.
A esmagadora maioria já tinha monstros explícitos, NPCs com
responde/recusa/se pressionado e recompensa nomeada — só 3 lacunas reais
(NPC no cabeçalho sem seção "NPCs na cena"), já corrigidas:
`horunka_03_madeira_que_nao_serve`, `tolbana_e03_corretores_desconfiados`,
`castelo_04_guarda_insone`. Não achei recompensa genérica sem nome. Este
item pode ser considerado fechado.

## 3. Validação visual do Compêndio — AÇÃO SUA

Não consigo renderizar HTML nesta sessão (nenhum navegador headless
disponível). O arquivo foi testado funcionalmente com jsdom — os 10 painéis
renderizam, zoom/pan/filtros e as fichas completas funcionam, 0 erros de
JavaScript — mas **ninguém olhou pra ele ainda**. Abra
`scripts/web/compendio_andar1.html` e me diga o que ajustar: proporções,
cores, tamanho dos marcadores, densidade de informação.

## 4. Imagens — ✅ 100% dos monstros, NPCs, armas e equipamentos têm retrato

Fechado nesta rodada: liguei Ollama (estava parado, subiu sozinho ao
chamar `ollama list`) e ComfyUI (`run_nvidia_gpu.bat`, com autorização do
usuário) e rodei `python scripts/gerar_faltantes.py tudo` duas vezes.

- **17 monstros não tinham prompt escrito** em `PROMPTS_MONSTRO`
  (`scripts/gerar_faltantes.py`) — inclusive Baran o Rei Touro, Rei das
  Planícies, Alfa Lupino e os 4 monstros novos do Andar 2. Escrevi os 17
  prompts (fórmula "monstrous non-human creature, not a person" + cenário)
  e gerei o lote — 18/18 sucesso (17 monstros + a arma nova
  `chicote_de_raiz_mae`).
- **2 NPCs** (`roan_carregador.md`, `nissa_corretora.md`) tinham a imagem
  gerada em disco mas o campo `imagem:` do frontmatter vazio — bug latente
  no casamento nome-do-arquivo vs. slug-do-campo-`nome` (achado numa
  varredura dedicada: só esses 2 de 50 tinham essa divergência sem o
  campo já preenchido). Corrigido preenchendo `imagem:` nos dois arquivos.
- `python scripts/gerar_dados_web.py` confirma: **0 monstros, 0 NPCs, 0
  armas, 0 equipamentos sem imagem.**

**Ainda falta:** as 5 vistas de arte do mapa —
`python scripts/gerar_mapa_arte.py todas` (não fiz; é uma ação mais visual
que o usuário costuma querer escolher/aprovar, ver item 1 abaixo).

O Compêndio mostra um placeholder com o nome de arquivo esperado onde falta
imagem, então dá pra usar o app como checklist visual. Depois de gerar, rode
`python scripts/gerar_dados_web.py` pra o app enxergar as novas. A lista de
quem ainda falta sai impressa no fim desse script.

## 5. `dados_mapa.js` — pontos genéricos sem `ref` ✅ resolvido

Conferido programaticamente nesta rodada: **0 de 57** pontos de categoria
`monstro` estão sem `ref`. Os 3 monstros que ainda não tinham ponto próprio
(Fada da Poeira, Gafanhoto Gigante, Serpente das Águas Rasas) ganharam
spawn em Jardim de Fenwyth, Terraços de Solveig e Ilha de Pemberton.

## 6. Equilíbrio entre profissões — princípio ativo

Conferido nesta rodada (ver tabela final de `docs/mercado_andar1.md`): as 16
profissões têm renda própria e mecânica própria. Diplomata, Coveiro e Músico,
que estavam magros, ganharam peça de equipamento dedicada (Selo de Trégua,
Terço de Ossos Antigos, Diapasão de Prata Rachado) com efeito que só faz
sentido pra elas. **Continuar checando a cada leva de conteúdo novo.**

## 7. Capítulos do manual — cap. 5 escrito (homebrew); cap. 12/13 já cobertos ✅

`docs/guia_sistema_aincrad.md` cobre até a página 29 do manual físico, que
segue sem fotos das páginas de cap. 5/12/13. Nesta rodada:

- **Cap. 5 (PvP/Duelos/Player Killing)** — não existe fonte física ainda,
  então escrevi homebrew claramente marcado como tal (nota de proveniência
  no topo da seção em `guia_sistema_aincrad.md`), usando só mecânica já
  estabelecida (Moves Núcleo, Condições). Revisar/substituir se as páginas
  reais aparecerem.
- **Cap. 12 (Evolução/XP)** — já coberto por "Progresso por Marcos" em
  `docs/regras_nucleares_campanha.md` desde uma rodada anterior; não escrevi
  nada novo pra não duplicar.
- **Cap. 13 (Mestre)** — já coberto por `guias/00_como_usar.md` (que é,
  literalmente, um "Guia do Mestre — Andar 1" completo).

Os capítulos oficiais, quando fotografados, ainda devem ser conciliados com
a regra de **Impulso** e com os **Moves de Arma/Profissão** no manual.

Também não há regra de **nível/XP** separada de Marcos, o que deixa
`requisito_nivel` sem escala real. Por isso os 66 equipamentos usam
requisito de **atributo** (que existe) em vez de nível.

## 8. Itens antigos ainda em aberto

- **Zoom em múltiplos níveis (macro → região → macro)** — o Compêndio agora
  tem zoom/pan contínuo, o que cobre a maior parte da necessidade original.
  Falta o "entrar numa região" com mapa próprio, como a Cidade do Início e as
  dungeons já têm. Candidatas naturais: Tolbana e Horunka.
- **Imagens de cenário por região** — parcialmente endereçado pelas 5 vistas
  do `gerar_mapa_arte.py`; faltariam as outras 25 regiões.
- ~~Port pro Foundry VTT~~ — **fora de escopo, por decisão explícita do
  usuário** ("VTT ou coisas assim, não serão necessárias", rodada de
  varredura final). `base/foundry_sistema/` continua vazia de propósito.
  Não é mais pendência — não reabrir a menos que o usuário peça de novo.

## 9. Andar 2 — esqueleto inicial criado ✅ (não é o andar inteiro)

`docs/historia_campanha_andar2.md`, `mapas/andar_2.md`, `cidades/urbus.md`,
4 monstros, 6 NPCs e `cenas/quests_andar2.md` (9 quests, chegada até o raid
contra Baran). Ver a seção "Rodada anterior — itens 4 a 8" no topo deste
arquivo pra lista completa. **Ainda falta:** o resto das regiões do andar
2, o Labirinto do Andar 2 sala a sala, mais monstros/NPCs, e — quando isso
tudo crescer — um Compêndio próprio (hoje os monstros/NPCs do andar 2
aparecem misturados ao app do andar 1, que não filtra por `andar`).

---

## O que está genuinamente completo

- Sistema de regras até onde o manual foi transcrito + cap. 5 homebrew
  (PvP/Duelos/PK) + cap. 12/13 cobertos por documentos próprios
- Mapa do andar 1: 30 regiões, 276 pontos; 86 deles com ficha própria em
  `guias/pontos/` (leitura, ação com teste, notas de mestre, atalhos)
- 56 quests do andar 1 com dificuldade e recompensa balanceadas + 9 quests
  de esqueleto do andar 2 — 0 referências quebradas, conferido
- **50 one-shots** da Temporada 1 "Crônicas de Aincrad" (arcos A e B),
  integradas ao Compêndio
- 49 monstros com ficha completa, doma e drop (45 do andar 1 + 4 do andar 2)
  — todos com prompt de imagem escrito (17 que faltavam, cobertos nesta rodada)
- 50 NPCs com diálogo, limites e ganchos (44 do andar 1 + 6 do andar 2)
- Esqueleto inicial do andar 2: abertura, cidade (Urbus), mapa esboçado
- 30 regiões com guia de mestre completo
- 7 puzzles multi-etapa com recompensa nomeada
- 4 dungeons detalhadas sala a sala (47 salas)
- 51 armas e 66 equipamentos com fonte concreta — auditados por
  balanceamento (`docs/balanceamento_armas_oficios.md`), 1 lacuna real
  corrigida (Raro de Conhecimento)
- Mercado completo com 18 vendedores + renda por profissão reconfirmada
- Economia das 16 profissões com cadeia de produção coerente
- 23 faixas de trilha sonora
- `docs/visao_geral.md` e `docs/pipeline.md` atualizados/expandidos —
  playbook completo pra acelerar o Andar 2
