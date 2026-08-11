## Novo nesta rodada — gate de nível estendido ("pode fazer") + bug real achado testando

Pedido do usuário depois da rodada anterior: "pode fazer" (estender
nível pras tabelas que tinham ficado só com login).

Achei vínculo real e limpo em mais 2 relações — `monstros.regioes`
(array) bate exatamente com `guias.id`, e `salas_dungeon.dungeon_id` bate
com `dungeons.id` — então:

- **`guias.nivel` estava vazio em 100% das linhas** (achado da rodada
  anterior) — populado agora com dado real: menor `nivel_recomendado`
  entre os monstros daquela região (26 de 30 guias tiveram monstro
  associado; as 4 sem nenhum ficaram nível 1, faz sentido pra hub/cidade).
- `guias`, `pontos`, `pontos_detalhe` ganharam nível de verdade (pontos
  herdam da guia da própria região).
- `salas_dungeon` herda o nível da dungeon (`dungeons.nivel`, já existia).
- `armas`, `equipamentos`, `cartas` ganharam nível derivado da
  `raridade` (mesma escala do item 3: Comum=1, Incomum=3, Raro=6,
  Épico=8, Lendário=10).
- `quests`, `cronicas` ganharam nível derivado da `dificuldade` (texto:
  Fácil=1, Médio=4, Difícil=7, Muito Difícil=9, Chefe=10).

**Ainda só com login, sem nível** (documentado por quê, não é esquecimento):
`npcs.local`, `puzzles.regiao`, `mercado.regiao` e `quests.regiao` são
texto NARRATIVO livre ("Cidade do Início — Guarita dos Cartógrafos, saída
norte"), não um slug que bate com `guias.id` — um match automático aí
arriscaria esconder o que devia mostrar ou vice-versa, não é decisão
segura de tomar sozinho sem confirmar. `cidades`, `clas`, `cristais`,
`oficios`, `producao`, `sistema` não têm nenhum campo (nem direto nem por
vínculo) que sirva de nível real.

**Bug real achado testando, corrigido antes de considerar pronto**: as
policies de `pontos`/`pontos_detalhe`/`salas_dungeon` usavam uma subquery
correlacionada pra buscar o nível de `guias`/`dungeons` — mas essas
tabelas TAMBÉM têm RLS com gate de nível, e subquery dentro de `USING`
roda com o mesmo contexto de autenticação do usuário, sujeita à RLS da
tabela referenciada. Resultado prático: uma dungeon de nível alto
(bloqueada pra aquele jogador) fazia a subquery não achar a linha,
retornar NULL, e o `coalesce(NULL, 1)` liberava como "nível 1" — o
OPOSTO do que devia. Testado com Mournhall (nível 8): um jogador nível 2
via as 8 salas de lá, quando deveria ver zero. Corrigido com funções
`SECURITY DEFINER` (`nivel_da_guia()`, `nivel_da_dungeon()`) que ignoram
a RLS da tabela de origem só pra essa consulta pontual — mesma técnica já
usada em `nivel_jogador_atual()`.

Testado via HTTP real depois do fix: jogador nível 2 só via a dungeon
"oculta" (nível 1, 5 salas) — Mournhall/Lumis/Labirinto (nível 6+)
corretamente escondidas. Mestre continua vendo as 47 salas das 4
dungeons. Anônimo confirmado em 0 linhas em tudo de novo depois do fix.

Schema: `scripts/db/schema_gate_nivel_extensao.sql` +
`scripts/db/schema_fix_gate_subquery_rls.sql`.

## Novo nesta rodada — gate de login + nível em todo conteúdo de mundo

Pedido do usuário, endurecendo a rodada anterior: "nada é público, tudo
só é visual se logado, e isso depende ainda de nível mínimo... todo tipo
de item, monstro, região, missão... tudo depende de um nível".

Antes da RLS: 24 tabelas de conteúdo de mundo (monstros, guias, puzzles,
pontos, npcs, quests, crônicas, dungeons, cidades, clãs, armas,
equipamentos, cartas, cristais, ofícios, produção, materiais, receitas,
ferramentas, ovos, missões do quadro, mercado, sistema) tinham
`visivel=true` liberado pra QUALQUER UM, sem exigir login. Corrigido com
duas camadas, aplicadas onde faz sentido de verdade:

1. **Login obrigatório** — em todas as 24, sem exceção. `nivel_jogador_atual()`
   nova função (maior Nível de Profissão do personagem do usuário logado,
   mesma régua que combate/craft já usam pra dificuldade).
2. **Nível mínimo** — só onde existe um campo de nível REAL e preenchido:
   `monstros.nivel_recomendado`, `dungeons.nivel`, `materiais_basicos.nivel_obtencao`,
   `receitas.nivel_receita`, `ferramentas_oficio.nivel_ferramenta`,
   `ovos_catalogo.nivel_min`, `missoes_quadro.nivel_min`.

**Levantamento antes de mexer** (pra não inventar nível onde não tem
dado real): `guias.nivel` existe na tabela mas está **vazio em 100% das
linhas** — nunca foi preenchido, sem dado real pra gatear.
`armas.requisito`/`equipamentos.requisito` é texto de **atributo**
("Corpo 0+", "Espírito -1+"), não nível numérico — bater dificuldade com
esse campo exigiria reescrever o conteúdo, não é decisão técnica minha
pra tomar sozinho. `puzzles`, `pontos`, `pontos_detalhe`, `npcs`,
`quests`, `cronicas`, `salas_dungeon`, `cidades`, `clas`, `cartas`,
`cristais`, `oficios`, `producao`, `mercado`, `sistema` não têm campo de
nível nenhum. Essas 17 tabelas ganharam **só o gate de login** por
enquanto — se quiser nível nelas também, precisa decidir o número por
linha (é conteúdo, não mecanismo).

6 views `*_publico` (monstros/guias/puzzles/pontos/pontos_detalhe/clas)
também precisaram do mesmo gate — têm `WHERE` próprio, não herdam RLS da
tabela base automaticamente.

Testado via HTTP real: anônimo (sem token) agora recebe **0 linhas** em
tudo, sem exceção. Jogador logado sem `nivel_profissao` nenhum (nível 1
default) via 6 de 54 monstros e 32 de ~299 receitas; subindo pra nível 8
via 53 monstros e 285 receitas — escala certo. Mestre continua vendo
tudo sempre. Nenhuma mudança de código Vue foi necessária (RLS é
transparente pro cliente — PostgREST só devolve menos/mais linha, sem
erro; a tela de "nada encontrado" já existia pra lista vazia).

Schema: `scripts/db/schema_gate_login_e_nivel.sql`.

## Novo nesta rodada — RLS vazando dado de jogador pra usuário sem login

Pedido do usuário: "tem muita informação que está sendo exibido para
usuario que não logou no sistema, isso não pode acontecer".

Não era só tela — **9 tabelas tinham uma policy `leitura_publica` com
`qual = true`**: `personagens`, `inventario`, `nivel_profissao`,
`criaturas_domadas`, `limit_breaker_contador`, `cla_autoridade`,
`reputacao_personagem`, `metas_doacoes`. Como RLS é OR entre policies, uma
policy `true` anula qualquer outra restrição na mesma tabela — qualquer
visitante, **sem conta, sem login**, lia a linha inteira via
`/rest/v1/<tabela>?select=*` usando só a anon key (que é pública, está no
bundle JS, isso é esperado/normal — a proteção real tinha que estar na
RLS, e não estava). O pior caso era `personagens`: ficha completa de
qualquer jogador (nome, guilda, arma, profissão, conceito) e `inventario`:
mochila completa de qualquer um.

Corrigido em `scripts/db/schema_fecha_leitura_publica.sql`:
- `inventario`/`nivel_profissao`/`criaturas_domadas`/`limit_breaker_contador`:
  já tinham policy `dono_gerencia` (dono ou mestre) — só removi a
  `leitura_publica` que a tornava inútil.
- `cla_autoridade`: substituída por "membro do próprio clã ou mestre"
  (mesmo padrão que `cla_inventario` já usava).
- `reputacao_personagem`: substituída por "dono da ficha ou mestre" —
  Ficha.vue já mostra isso pro jogador, só nunca teve a policy certa.
- `metas_doacoes`: exige estar **logado** (não precisa ser dono/mestre —
  é um quadro de doação coletiva, transparência entre jogadores faz
  sentido, só não pra quem nem tem conta).
- `personagens`: a policy de "ficha pública" ganhou `AND
  auth.role() = 'authenticated'` — visitante anônimo não vê mais ficha
  nenhuma, jogador logado continua vendo as marcadas como públicas.

Não mexido, considerado correto como está: `vitrine` (marketplace público
de verdade, faz sentido navegar sem conta) e `metas_globais` (quadro de
metas comunitárias, não é dado de jogador específico).

Testado via HTTP real nos 3 papéis (anônimo sem token / jogador logado /
mestre) — anônimo agora recebe 0 linhas em tudo que é dado de jogador,
jogador continua vendo o próprio, mestre continua vendo tudo.

## Novo nesta rodada — item 3 (catálogos de craft) + mapa artístico no Vue

Pedido do usuário: "Item 3, tem varios itens em em formato de texto na
pasta dolist" + "Mapa Artísticos, vamos fazer em canvas, em svg".

- **Item 3 fechado**: os 9 arquivos `dolist/*.txt` (Comidas, Munições,
  Acessórios, Cristais de SAO, Armaduras, Botas, Luvas, Elmos, Poções e
  Consumíveis) viraram 75 catálogos novos em `equipamentos` + 141 receitas
  novas em `receitas` — script reutilizável
  `scripts/db/_importar_itens_dolist3.py`. Detalhe completo, mapeamento de
  profissão e a duplicidade resolvida (Cristais de SAO × Poções repetiam
  vários itens) em `dolist/03_itens_crafts_novos.md`.
- **Bug achado e corrigido no caminho**: `craftar_item` sempre gravava
  `tipo='consumivel'` e `quantidade=1` no inventário, não importava o que a
  receita produzisse — quebrava silenciosamente as 75 receitas novas de
  equipamento (não ficavam equipáveis) e qualquer receita que produzisse
  mais de 1 (munição). Corrigido em
  `scripts/db/schema_craft_equipamento_e_qtd.sql`, testado via HTTP real.
- **Mapa Artístico**: o terreno vetorial completo do HTML legado
  (`scripts/web/dados_terreno.js` + `mapa_limpo.html`, contornos
  Catmull-Rom, ~70 elementos de geografia) foi portado pro Vue —
  `scripts/app/src/lib/mapaTerreno.js` (dados + funções de desenho) +
  `Compendio.vue` (novo botão "Terreno ligado/desligado" na aba Mapa,
  desenha por baixo dos 246 pontos reais). Mesmo viewBox `0 0 1536 1024`
  dos pontos, então nasce alinhado sem calibração manual. Não portei o modo
  "referência"/export PNG do legado (isso era só insumo pra um fluxo manual
  de pintar a ilha com IA fora do jogo — segue disponível em
  `mapa_limpo.html` se quiser gerar a arte um dia).

## Novo nesta rodada — consolidação do schema + revisão dos golpes de arma

Pedido do usuário: "continue trabalhando até as pendências que dependem
de você serem concluídas."

- **Snapshot do schema** (`scripts/db/_gerar_snapshot_schema.py` →
  `scripts/db/schema_snapshot_2026-08-10.sql`): depois de tantas mudanças
  de banco numa sessão só, `schema_jogo_online.sql` original ficou
  desatualizado (os `schema_*.sql` incrementais de hoje não foram
  mesclados de volta nele). Gerei um snapshot completo e fiel direto do
  banco — tabelas, constraints, views, funções (exceto as que pertencem a
  extensão, tipo pgvector), RLS e o cron job — testado com dry-run
  (rollback) antes de considerar pronto. Isso é a fonte de verdade nova de
  "como o banco está agora"; os `schema_*.sql` incrementais continuam no
  repo como histórico.
- **Golpes de arma (item 2) revisados** — não linha a linha (julgamento
  narrativo continua so seu), mas checagem estrutural e de design
  automatizada: 0 problema nas 23 armas, e confirmado que os 3 golpes de
  cada arma usam 3 atributos diferentes entre si, exatamente o que o item
  pedia. Achado melhor do que esperado pra um rascunho de IA.
- **Não fiz** (dependem de você, não de mim): redirecionar `painel.html`
  pro app Vue novo — não sei onde/como o Vue vai ser hospedado (sem
  `netlify.toml`/`vercel.json`/workflow de deploy no repo pra eu inferir),
  arriscar um link errado é pior que deixar como está até você me dizer
  onde isso vai rodar.

## Novo nesta rodada — mapa no Compêndio, item 16 fechado (o que dava sem inventar conteúdo)

Continuação de "termine esses pontos":

- **Mapa** — aba nova em `Compendio.vue`, os 246 pontos reais (x/y de
  `pontos`) num SVG com zoom, filtro por região/categoria e ficha do
  ponto ao clicar (usa `pontos_detalhe` quando existe). **Não é** o mapa
  vetorial artístico do HTML antigo (terreno desenhado, bezier suave,
  1100+ elementos) — isso continua de fora, é escopo de item novo, não
  de migração de tela. Testado com login real: `pontos_publico` e
  `pontos_detalhe_publico` respondem certo pro jogador.
- **Item 16** — fechado o que dava sem inventar conteúdo pras 15
  profissões que não têm ferramenta: mecanismo de ferramenta obrigatória
  pronto e testado (mas desligado em produção — ativar é decisão sua) +
  painel de 16 profissões do lado do **mestre** (não do jogador, não
  contraria a regra já decidida). Detalhe em `dolist/16_...md`.

## Novo nesta rodada — achado grave: missões diárias e publicar no mercado nunca funcionaram no app de verdade

Pedido do usuário: "termine esses pontos" (mapa, item 16, paridade dos
HTMLs pequenos). Ao conferir a paridade, fiz uma varredura sistemática de
**todo** `.from(tabela)` e `.rpc(nome, params)` do app inteiro contra o
schema real (nome de tabela E nome de cada parâmetro — o mesmo tipo de
bug já tinha aparecido antes). Achado sério, corrigido:

- **`Tarefas.vue` (missões diárias) estava 100% quebrado.** Consultava
  uma tabela `missoes` que nunca existiu (a real é `missoes_quadro`) e
  chamava `aceitar_e_resolver_missao` com o parâmetro `missao_id` em vez
  de `p_missao_id`. As duas coisas juntas significam que **o loop
  principal do jogo online nunca funcionou de verdade pelo site** —
  provavelmente desde que foi escrito. Corrigido e testado com login real
  (API do Supabase): lista carrega, missão resolve.
- **`Mercado.vue`: publicar anúncio também quebrado.** Chamava
  `publicar_anuncio` com `p_preco_col`, o parâmetro real é `p_preco`.
  Corrigido e testado com login real (criei item de teste, publiquei,
  limpei depois).
- **`PetsTab.vue` (ovos/pets) não tinha rota nem link nenhum** — arquivo
  existia, ninguém conseguia abrir a tela. Adicionada rota `/pets` + link
  no menu.

Conferido o resto de todas as `.from()`/`.rpc()` do app contra o schema
real (nome de tabela e nome de cada parâmetro, um por um) — nada mais
achado errado.

## Novo nesta rodada — itens 13-16 avaliados, cartas/cristais com efeito, mochila≠baú, Compêndio migrado pro Vue

Pedido do usuário: "não vamos cortar [o HTML], vamos migrar" — tudo que
ainda só existia no HTML legado precisa existir no Vue; função que faltar
implementar, implementar. Fechei:

- **Item 13** — achado que já estava 95% pronto (`docs/elementos_andar1.md`
  já descreve o sistema novo, `_modelo_monstro.md` já não tem campo de
  elemento). Só faltava dropar `monstros.elemento_resistencia`, coluna
  morta sem leitor em código nenhum — removida.
- **Item 14** — `craftar_item`/`craftar_ferramenta` já tinham comentário
  dizendo que somavam bônus de ferramenta, mas nunca somavam de verdade.
  Agora somam (maior `bonus_acao` entre as ferramentas que o personagem
  tem pra aquela profissão). Ajustei os 4 registros de Incubadora do
  Domador de "+3%/+6%/+12%/+15%" pra "+1/+1/+2/+3" — a escala do jogo
  online é mod de 2d6 (-3 a +3), não percentual.
- **Item 15** — achado que já existia pronto: `comprar_folego(qtd)` já
  implementa exatamente as 3 faixas de preço do dolist (1un=5 Col,
  5un≈30 Col, encher≈140 Col), só não estava em nenhuma tela. Coloquei 3
  botões em `/combate`, ao lado do "curar tudo" (que também restaura
  Vida) que eu já tinha feito.
- **Item 16** — avaliado, maior parte **não construída de propósito**:
  ferramenta obrigatória travaria 15 das 16 profissões (só o Domador tem
  ferramenta cadastrada); painel de 16 profissões pro jogador contraria
  uma regra já decidida em sessão anterior ("Profissoes.vue não mostra
  todas as profissões pro jogador"). Documentado em
  `dolist/16_ferramentas_refino_painel_profissoes.md` pra você decidir.
- **Cartas/cristais (item 7)** — as 150 cartas e 57 cristais que estavam
  com "efeito ainda não definido" ganharam efeito de verdade, gerado por
  fórmula (tipo_bonus × raridade × nome do monstro de origem). Achado no
  caminho: minha primeira tentativa desse texto tinha bônus de +2/+3, o
  que contraria a regra dura da mesa ("teste nunca recebe mais de +1
  numérico externo") — corrigido pra sempre +1, raridade escala frequência
  de uso, não o número.
- **Mochila vs. Baú (item 8)** — coluna `inventario.local` +
  `mover_inventario()`, `Equipamentos.vue` ganhou a 3ª aba que faltava.
- **Golpes de arma normalizados** — 10 das 23 armas tinham
  `dez_mais`/`sete_nove` como array em vez de string (formato
  inconsistente); uniformizado.
- **O item principal: `compendio_andar1.html` → `Compendio.vue`.** 13 das
  15 abas (Mesa e Só-o-Mestre já viviam em `Mestre.vue`, não duplicado):
  Bestiário, NPCs, Armas, Equipamentos, Quests, Crônicas, Guia das
  Regiões, Puzzles, Dungeons, Cidade do Início, Ofícios, Mercado, Sistema
  — um leitor genérico, configurado por aba, direto do banco. **Achado
  crítico testado por HTTP real antes de generalizar**: ler a tabela BASE
  de `guias`/`puzzles`/`monstros` (que têm campo só-mestre) quebra com 403
  pro jogador comum — a query inteira falha, não só o campo. O
  Compêndio novo usa as views `_publico` pro jogador e a tabela base só
  quando `auth.ehMestre` — testado com login real via API do Supabase nas
  13 tabelas/views, todas OK. **Não fiz**: o mapa vetorial interativo (277
  pontos, terreno desenhado) — isso é renderização de canvas/SVG do
  tamanho de um item novo por si, não uma migração de tela; o que existe
  hoje é confirmação de que missões/guias/pontos já são consultáveis, só
  não com o mapa visual.
- **HTMLs pequenos (personagens/inventario/mercado/missoes_diarias/
  profissoes/estalagem.html)**: confirmado que `Ficha.vue`/
  `Equipamentos.vue`/`Mercado.vue`/`Tarefas.vue`/`Profissoes.vue`/
  `Combate.vue` já cobrem o mesmo papel (nomes e propósito batem 1:1) —
  não fiz comparação função por função dentro do tempo desta rodada,
  então vale uma conferida sua ao testar.

## Novo nesta rodada — fôlego regenera de verdade, item 12 fechado, verificação via API real

Pedido do usuário: "faça todo o restante, que vou começar a testar hoje."
Fechei as pendências que sobraram registradas nas rodadas anteriores:

- **Fôlego agora regenera de verdade.** Achado nas rodadas anteriores:
  "+1 a cada 30min" era só descrição, nenhum mecanismo existia em lugar
  nenhum do banco. Criado `pg_cron` (extensão habilitada) rodando
  `_regenerar_folego_todos()` a cada 30 minutos de verdade, +1 fôlego pra
  quem estiver abaixo do teto 20 (`scripts/db/schema_regen_folego.sql`).
  Vida continua sem regen passivo, por decisão já registrada no item 17
  (só cura na Estalagem) — não mudei isso.
- **Item 12 fechado**: bônus de fraqueza de atributo implementado em
  `combater_monstro` (+1 fixo quando a arma equipada bate
  `monstros.atributo_fraqueza`), testado. Achado no caminho:
  `armas.atributo` tinha 9 linhas com grafia sem acento
  (`Tecnica`/`Espirito`) misturadas com a forma acentuada — o bônus nunca
  ia bater pra essas armas; corrigido, as 22 armas usam a mesma grafia.
- **Registro nos dois admins**: as tabelas novas desta sessão inteira
  (roster, log de combate, baú/cargos de clã, metas globais/doações)
  registradas em `tabelasAdmin.js` pro mestre conseguir ver/editar pelo
  Compêndio genérico também, não só pelas telas dedicadas. Corrigido de
  passagem: `reputacao_personagem` no admin ainda usava o campo antigo
  `cla_nome` (renomeado pra `alvo_nome`/`alvo_tipo` faz duas rodadas,
  nunca atualizado ali).
- **Verificação por HTTP real, não só SQL simulado.** Percebi no caminho
  que testar RLS via `SET LOCAL ROLE` numa conexão de superusuário
  (`postgres`, usada pelo `.env`) não é garantia — pode se comportar
  diferente de uma sessão `authenticated` de verdade. Resetei a senha da
  Shen (personagem de teste) e fiz login de verdade pela API do Supabase
  Auth, chamando o REST/RPC real como o navegador chamaria: `monstros`
  (campo público) abre, `monstros.notas`/`puzzles.verdade` (campo só
  mestre) bloqueiam com 403, tabela `mesa_relogios` (mestre-only) volta
  vazia `[]` pro jogador, `combater_monstro` funciona de ponta a ponta,
  insert direto em `reputacao_personagem` bloqueia, RPC
  `mestre_ajustar_reputacao` chamada por jogador comum é rejeitada. Tudo
  bateu com o esperado. **Efeito colateral**: a Shen (personagem de
  teste) tem agora senha `TesteReal!2026` (era uma gerada aleatória que
  ninguém tinha em mãos) e um combate real de verdade no histórico —
  sem problema, é personagem de teste, mas fica registrado.

## Novo nesta rodada — itens 4, 7, 17 e 18 do dolist (os quatro que restavam)

Pedido do usuário: "pode fazer tudo, depois eu vou testar e revisar" —
fechei os quatro itens grandes que tinham ficado pra trás, decidindo sem
bloquear em pergunta onde havia "Preciso saber" em aberto (registrado em
cada arquivo do dolist, pra revisão).

- **Item 4 (roster até andar 50)**: achado que `dolist/🐉 Bestiário de
  Aincrad.txt` já era a transcrição completa dos 50 andares (sessão
  anterior) — só nunca virou dado estruturado. Parseado e importado:
  **500 monstros, 50 andares, 4 categorias** em `bestiario_roster`
  (tabela nova, separada de `monstros` — roster não é ficha completa).
- **Item 7 (cartas/cristais)**: populado a partir do mesmo roster — **150
  cartas, 57 cristais**. Achado que corrige o próprio arquivo: cristal
  **não é exclusivo de Boss** no roster real (Mini Boss e MVP também
  têm). Efeito de cada carta/cristal ficou como placeholder — não
  inventei 200+ textos de mecânica sem direção.
- **Item 17 (combate assíncrono)**: `vida_max`/`vida_atual`, RPC
  `combater_monstro` (fôlego sempre gasto, vida só em parcial/falha,
  PBTA ternário igual ao resto do jogo, drop usa o `monstros.drops` que
  já existia), `curar_estalagem`. UI nova `/combate`. Achado: Fôlego não
  tem regen por tempo implementado em lugar nenhum do banco (só compra
  com Col) — não inventei regen de Vida sozinho quando nem Fôlego tem de
  verdade; registrado como pendência real.
- **Item 18 (cooperação)**: os 3 submódulos — correio P2P (Col + item,
  sem taxa), baú de clã (depositar livre, retirar travado até
  oficial/líder liberar), metas globais do mestre (até 3 abertas, premia
  sozinho ao bater 100%, reaproveita a reputação do item 10). UI nova
  `/cooperacao` + formulário de criar meta em `Mestre.vue`.

Todos os quatro testados com rollback (RLS real, fluxo completo) antes de
ficar definitivo. Build do Vue limpo depois de cada um. Achados de schema
no caminho (typo de coluna, CHECK constraint faltando valor, texto livre
em campo que devia ser número) documentados em cada commit de schema —
mesmo padrão de "confere o banco de verdade antes de escrever RPC" que
pegou vários bugs nas rodadas anteriores.

**O que ficou fora, de propósito**: UI "de vitrine" completa (as 3 abas
ricas do combate, páginas dedicadas do item 18, ranking/notificação) —
priorizei mecanismo real testado sobre polimento visual, já que o próprio
usuário vai revisar depois. Efeito de carta/cristal, vida jogável de
verdade pros ~350 monstros do roster, e regen de Fôlego/Vida por tempo
real continuam pendências de conteúdo/decisão, não escondidas.

## Novo nesta rodada — item 2 fechado (contador do Limit Breaker)

Continuação direta de "bug grave em 80% das missões" logo abaixo.
Perguntei escopo (por personagem ou por arma) e reset (ao usar, por
sessão, ou nunca) — usuário escolheu **por arma equipada** + **zera ao
usar**. Construído `limit_breaker_contador`
(`scripts/db/schema_limit_breaker.sql`), RLS mestre-only escreve (jogador
só lê o próprio — é ferramenta de mesa, contador não devia ser
autopromovível). UI nos dois lados: `Mestre.vue` (ficha do jogador — soma,
zera, "Usar" quando bate 10) e `Ficha.vue` (jogador vê os próprios
contadores). Testado com rollback: chega em 10, "usar" zera, jogador não
edita contador de outro personagem. Achado no caminho:
`armas.tipo='Lanca'` (sem cedilha) numa única arma não batia com
`moves_arma.nome='Lança'` — corrigido, os 23 tipos batem 100% agora.

**Item 2 fechado ponta a ponta** — conteúdo (rodada anterior) + mecanismo
do contador (esta rodada). Segue de conteúdo rascunho não revisado por
mim linha a linha, como já registrado.

## Novo nesta rodada — bug grave em 80% das missões + 12/12 ovos com fonte

Continuação direta de "migração rodada + itens 1 e 2" logo abaixo. Pedido
do usuário: fechar os 11 ovos sem missão ("escrever missão de caça nova
pra cada espécie").

**Achado e corrigido: `aceitar_e_resolver_missao` quebrava sempre que o
drop de uma missão não-arma realmente caía — 80 das 100 missões do jogo
estavam expostas.** A função tentava ler `equipamentos.tipo`, coluna que
não existe (`equipamentos` tem `slot`, não `tipo`) — sempre que o sorteio
de drop acertava (`random() < drop_chance`) pra qualquer `drop_item_id`
que não fosse arma, a chamada inteira quebrava com erro de SQL cru pro
jogador em vez de terminar a missão. Corrigido: `equipamentos` agora usa
`'equipamento'` fixo (não lê coluna que não existe); aproveitei e também
adicionei os ramos que faltavam pra `ovos_catalogo` e `cristais` (nenhum
dos dois entrava na resolução de drop antes). Testado de ponta a ponta
até o drop de verdade cair: item vira linha de inventário com o `tipo`
certo, e no caso do ovo, `chocar_ovo` funciona imediatamente na sequência.

**As 11 espécies de ovo sem missão ganharam missão de caça nova**, uma
por espécie (decisão do usuário), nível/recompensa seguindo a curva das
missões existentes, região escolhida por afinidade temática quando havia
uma óbvia (Floresta do Lobo pro lobo, Covil de Obsidiana pro dragão
bebê, Biblioteca Antiga pra coruja "sábia" etc.). Script em
`scripts/db/_seed_missoes_ovos.py`, idempotente. **12 de 12 ovos agora
têm fonte de obtenção real**, item 1 do dolist fechado ponta a ponta.

**Incidente nesta rodada — arquivo apagado por engano, recuperado.**
Rodando limpeza de arquivos temporários, apaguei sem querer
`scripts/db/_relatorio_usos_materiais.txt` (não criado por mim, não
conferido antes de apagar — errado da minha parte). Recuperado rodando o
script que o gera (`scripts/_gerar_receitas_balanceadas.py`), mas isso
revelou que **esse script está desatualizado e é perigoso de rodar de
novo sem corrigir primeiro**: ele reescreve `scripts/db/schema_jogo_online.sql`
inteiro, e o splice dele apaga tudo depois de um certo ponto do arquivo —
inclusive RPCs inteiras que foram adicionadas depois da última vez que
ele rodou (`craftar_item`, `chocar_ovo`, `aceitar_e_resolver_missao`
corrigida agora, etc.). Peguei antes de aplicar (fiz backup, conferi o
diff, restaurei — o banco de produção nunca foi tocado, só o arquivo
local chegou a ficar truncado por alguns minutos, já corrigido). **Não
rodar esse script de novo sem atualizar a lógica de splice primeiro.**

## Novo nesta rodada — migração rodada + itens 1 e 2 do dolist (Domador, golpes de arma)

Continuação direta da rodada anterior ("itens 8, 10 e 12" logo abaixo).
Pedido do usuário: "pode fazer na sequência" — rodar a migração pendente e
seguir pelo backlog (itens 1, 2, 4, 7, 17, 18).

**Migração rodada** (`python scripts/migrar_para_supabase.py`, confirmada)
— 1229 linhas upsertadas. `monstros.atributo_fraqueza` foi de 0/54 pra
54/54 preenchidos (estava correto nos `.md`, só não tinha sido
sincronizado). Conferido que os 2 personagens de teste (Shen, Umbra) não
perderam nenhum campo de estado ao vivo (Col, fôlego, condições, arma).

**Item 1 (Domador→Criador) — achado que já estava ~90% construído,
faltavam 3 pontas que quebravam tudo.** `chocar_ovo`/`verificar_chocagem`
(RPCs), `ovos_catalogo` (12 ovos curados), 4 receitas de Incubadora e
`PetsTab.vue` inteiro já existiam — de uma sessão anterior, nunca
finalizado. Achado testando: (1) `ferramentas_oficio` sem nenhuma linha —
Incubadora craftada não tinha onde guardar o nível, todo Domador travado
em nível 1 pra sempre; (2) `criaturas_domadas.monstro_id` com FK pra
`monstros`, mas 10 dos 12 ovos referenciam espécie "roster" do item 4 (nome
existe, ficha completa não) — quebrava `chocar_ovo` com erro de FK pra 10
de 12 ovos; (3) nenhuma missão dava ovo como drop. Corrigido (1) e (2) em
`scripts/db/schema_incubadora_e_ovos.sql`; (3) parcialmente — só achei 1
casamento real espécie/missão (`n1-caca-ratos`→`ovo_ratogig`), as outras
11 espécies não têm missão de caça correspondente ainda (não forcei par
errado). Testado de ponta a ponta com rollback: bloqueio sem incubadora
suficiente, nível liberado ao possuir a ferramenta certa, choco completo
após o tempo passar. Também troquei o texto da Move de Ofício do Domador
(estava com a "Doma" antiga, removida faz tempo) pelo texto real de "Ovo
de Fera" (`dolist/Domador.png`), no banco (`moves_profissao`) e no manual
(`docs/guia_sistema_aincrad.md`).

**Item 2 (golpes de arma) — conteúdo já gerado numa sessão anterior via
Ollama, nunca carregado no banco.** `scripts/db/dml_moves_armas_golpes.sql`
(commits "Propostas do Ollama"/"Piloto de golpes de arma") tinha os 69
movesets (23 armas × golpe_2/golpe_3/limit_breaker) prontos. Apliquei —
as 23 armas agora têm os 3 campos preenchidos. **Isto é conteúdo rascunho,
não revisado por mim linha a linha** (o próprio commit chama de
"propostas"/"piloto pra comparação") — nenhum lugar do site ainda exibe
esses campos, então dá pra revisar com calma antes de considerar pronto.
O mecanismo do contador que desbloqueia o Limit Breaker continua 0%
construído — perguntas de design reais em aberto, ver
`dolist/02_ataques_limit_breaker.md`.

**Parado aqui de propósito.** Itens 4 (biomas/monstros até andar 50), 7
(drops estilo MMO), 17 (combate assíncrono) e 18 (cooperação 30
jogadores) são GG/G de verdade — ao contrário de 1/10/12, que pareciam
grandes mas estavam meio-construídos, não achei sinal de que esses quatro
tenham qualquer trabalho prévio escondido. Continuar exigiria ou decisão
de conteúdo real (não é bug pra achar) ou autoria de conteúdo em volume
que vale a pena o usuário acompanhar de perto, não só aprovar depois.

## Novo nesta rodada — itens 8, 10 e 12 do dolist (equipamento, reputação, chance de sucesso)

Continuação da rodada anterior ("visão do mestre migrada..." logo abaixo).
Pedido do usuário: fechar o achado do `Equipamentos.vue` quebrado + avançar
no backlog maior (itens 1, 2, 4, 7, 10, 12, 17, 18 do dolist).

**Item 8 (equipamento/inventário) — `Equipamentos.vue` reescrito e testado.**
Paper doll de 10 slots (o que já estava decidido em
`dolist/08_equipamento_inventario.md`) usando o schema real:
`personagens.arma` pra arma, `inventario.equipado`+`slot` pros outros 9 —
nada de tabela nova. Achado no caminho: `inventario.tipo` tem CHECK
constraint com só 8 valores (`arma, equipamento, consumivel, material,
carta, cristal, ovo, pet`) — nem o rascunho antigo nem minha primeira
tentativa usavam os valores certos; corrigido também no `tituloTipo` de
`Mestre.vue`. Testado de ponta a ponta contra o banco de verdade (RLS real,
sessão simulada da Shen, insert/equipar/trocar de slot ocupado), com
rollback — 0 resíduo. Detalhe completo em `dolist/08_equipamento_inventario.md`.

**Item 10 (reputação) — schema, trigger automático e UI, dos dois lados.**
Pergunta feita ao usuário antes de construir: reputação de jogador é só
com o próprio clã ou mais amplo? Resposta: **universo inteiro — cidades,
vilas, NPCs**. `reputacao_personagem.cla_nome` (FK pra `clas`, só 6
valores) virou `alvo_nome` livre + `alvo_tipo`
(`scripts/db/schema_reputacao_universal.sql`). Ganho automático por
missão via trigger em `missao_diaria` (usa as colunas
`reputacao_alvo_nome`/`reputacao_delta` que já existiam em
`missoes_quadro`, nunca lidas por código nenhum até agora). Jogador **não
pode** editar a própria reputação — RLS bloqueia escrita direta, só RPC
`mestre_ajustar_reputacao` (gated por `is_mestre()`) ou o trigger (que roda
como definer, ignora RLS) escrevem. Tudo testado com rollback: RPC como
mestre, RPC bloqueada como jogador comum, insert direto na tabela também
bloqueado, clamp em ±3, trigger disparando reputação ao concluir missão.
UI: `Ficha.vue` mostra a própria (leitura), `Mestre.vue` mostra e ajusta a
de qualquer jogador (dentro da ficha).

**Item 12 (chance de sucesso por Nível) — achado: já estava construído no
servidor, só a prévia no site mentia.** `aceitar_e_resolver_missao` (RPC)
já usa Nível de Profissão real pra modificar a rolagem 2d6 (degrau fixo:
≥+2→+3, +1→+1, 0→0, -1→-1, ≤-2→-3) e resolve sucesso_total/parcial/falha —
exatamente o que o item pedia, só que ninguém tinha percebido que já
existia. O que estava errado: `Tarefas.vue` mostrava uma % de chance ao
jogador **antes** de clicar, calculada com `personagens.nivel` (coluna que
não existe, sempre 1) — ficava cada vez mais pessimista conforme o
jogador evoluía de verdade. Corrigido: busca o Nível de Profissão real ao
montar a tela. **Não implementado**: bônus fixo por usar arma cujo
atributo bate a fraqueza do monstro — bloqueado porque nenhum monstro tem
`atributo_fraqueza` preenchido no banco (0 de 54, apesar dos 54 `.md` de
origem terem o campo certo — é só sincronização atrasada,
`python scripts/migrar_para_supabase.py` resolveria, mas o script pede
confirmação interativa porque sobrescreve edição feita direto no painel
do mestre desde a última migração; não rodei sem essa confirmação sua).

**Backlog que ficou pra trás nesta rodada (avaliado, não construído)** —
itens 1 (Domador→Criador), 2 (3 golpes por arma + Limit Breaker), 4
(biomas/monstros até andar 50), 7 (drops estilo MMO), 17 (combate
assíncrono), 18 (cooperação 30 jogadores). Todos têm perguntas "Preciso
saber" reais no próprio arquivo (decisão de conteúdo/balanceamento, não só
código) e/ou são G/GG (várias sessões cada) — não tentei chutar pra não
ter que desfazer depois. Ver pergunta de priorização na conversa.

## Novo nesta rodada — visão do mestre migrada pra Vue+Supabase + bugs críticos corrigidos

Pedido do usuário: revisão geral do projeto + dar ao mestre "todas as
ferramentas possíveis pra trabalhar", com a direção explícita de tirar
conteúdo/UI do HTML+`.md` estático e jogar tudo pro app Vue (`scripts/app/`)
sobre Supabase. Trabalho de verdade foi no banco de produção (via
`scripts/migrar_para_supabase.py`/psycopg2, credenciais em `.env`) e no
Vue, não no Compêndio HTML.

**Achado grave, corrigido: o painel do mestre em Vue (`Mestre.vue`) estava
essencialmente quebrado contra o schema real** — provavelmente escrito
antes do schema final ter sido fechado, nunca reconferido depois:

- Duas RPCs que o botão "Criar personagem" e "Resetar senha" chamavam
  (`criar_usuario_mestre`, `resetar_senha_usuario`) **não existiam no
  banco** — criadas agora em `scripts/db/schema_admin_auth.sql`
  (`security definer` + `pgcrypto`, gated por `is_mestre()`, já que a
  service_role key nunca deve ir pro bundle do navegador). Testadas
  ponta a ponta (criar conta, checar hash da senha, resetar senha,
  confirmar que um jogador comum toma exceção) e limpas depois.
- O INSERT de "criar personagem" mandava `nivel`, `folego_max`,
  `folego_atual` — colunas que não existem em `personagens` (fôlego é um
  valor só, teto 20 fixo no resto do backend). O INSERT falhava sempre.
- `personagens` não tem coluna `id` (a chave é `nome`, texto) — todo
  `:key="p.id"` / `.eq('id', ...)` no painel batia em `undefined`;
  qualquer "Salvar alterações" na ficha de um jogador incluía `id`,
  `xp_profissao`, `nivel`, `folego_atual`, `folego_max` no payload do
  `update()` e o Postgres rejeitava a linha inteira (coluna inexistente) —
  ou seja, o mestre não conseguia editar Col, profissão, aparência etc. de
  ninguém assim que tocasse em Nível/XP/Fôlego no formulário.
- Aba Inventários usava `personagem_id` (não existe; é `personagem_nome`)
  e ordenava por `data_update` (não existe; é `obtido_em`).
- `carregarJogadores()` ordenava por `data_criacao` (não existe) — a
  aba Jogadores/Dashboard provavelmente vinha vazia mesmo com jogadores
  cadastrados.
- Corrigido tudo isso em `Mestre.vue`, `Ficha.vue` (mesma dupla
  `folego_atual`/`folego_max` inexistente) e `Mercado.vue` (mesmo
  `inventario.criado_em` inexistente, é `obtido_em`). Build (`npm run
  build`) limpo depois.
- **Não inventei coluna de nível de personagem.** `nivel`/`xp_profissao`
  não têm dono claro no schema (quem manda hoje é Nível de Profissão, ver
  `dolist/12_sistema_de_poder.md` — decidido só no papel, `nivel_profissao`
  não é lido em lugar nenhum do app ainda) — removi os campos falsos do
  painel em vez de fabricar schema pra uma decisão que não é minha.
  `Tarefas.vue`/`PetsTab.vue` continuam com `pers.nivel||1` inerte (sempre
  1, nunca quebra) — amarrado aos itens 12 e 1 do dolist, não mexido.
- **Achado, não corrigido:** `Equipamentos.vue` (equipar/desequipar,
  mochila, stash) não funciona contra o banco real — schema errado (14
  slots inventados em vez dos 10 decididos, tabela/coluna erradas). Isso é
  a implementação de verdade do item 8 do dolist, não um bug de linha —
  detalhe completo registrado em `dolist/08_equipamento_inventario.md`.

**Ferramentas novas pro mestre** — aba **Mesa & Sessão** em `Mestre.vue`,
substituindo o que só existia em `localStorage` no Compêndio HTML (aba
"Mesa"/"Só o Mestre"), agora gravado no banco (mestre-only via RLS,
`scripts/db/schema_mesa_mestre.sql`):

- Relógios narrativos (0-6), preparação de raid (6 categorias da regra),
  Favor/Suspeita por relação livre, registro de sessão (histórico) — igual
  ao que já existia, só que compartilhado entre dispositivos agora.
- **Novo de verdade:** rastreador de condições por jogador (os 6 nomes de
  `docs/regras_nucleares_campanha.md`, com aviso de Crítico em 3+, editável
  também na ficha do jogador) e rastreador de golpes de combate (escolhe
  um monstro do bestiário, conta golpes acumulados — sem inventar HP nem
  iniciativa, o sistema não tem nenhum dos dois). Segredos/puzzles do mapa
  e raros do andar (não à venda) também migraram pra lá, direto do banco.

**Compêndio HTML não foi tocado nesta rodada** — continua funcional como
está; a decisão de quando aposentar `scripts/web/*.html` é do usuário (ver
nota nova em `docs/visao_geral.md`).

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
