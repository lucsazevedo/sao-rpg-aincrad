# Pipeline de criação de conteúdo — SAO Aincrad RPG: The Perfect Chaos

Como gerar cada tipo de conteúdo do RPG usando as IAs locais, **e a ordem
que realmente funcionou** pra construir o Andar 1 do zero — pra repetir no
Andar 2 (e além) mais rápido, sem redescobrir os mesmos ajustes.

## ⚠️ Mudança importante: o banco (Supabase) é a fonte de verdade do site

Desde [2026-08-06], `scripts/web/compendio_andar1.html`,
`personagens.html` e `admin.html` **não leem mais `dados_conteudo.js`
direto** — leem do banco Supabase (ver `scripts/db/schema.sql` e
`docs/registro_clas_e_reputacao.md` como exemplo já migrado). O `.md`
continua sendo **onde novo conteúdo nasce** (via `gerar_npc.py` etc., como
sempre foi), mas o passo final mudou:

- **Conteúdo novo** (NPC novo, quest nova, andar novo): siga o pipeline
  normal abaixo até `.md`, depois rode `python
  scripts/migrar_para_supabase.py` — ele faz upsert no banco a partir dos
  `dados_*.js` recompilados. Isso é seguro pra registro que ainda não
  existe no banco.
- **Editar algo que já existe**: use `scripts/web/admin.html` (login de
  mestre) direto — **não** edite o `.md` e rode a migração de novo pra
  isso. A migração faz upsert por id/nome; ela **sobrescreve** qualquer
  edição feita só no banco com o que estiver no `.md`, silenciosamente.
- Se editar um `.md` de algo que **já foi editado no admin.html**, replique
  a mudança nos dois lados na mão — não existe sincronismo automático
  banco→markdown ainda.

## Antes de tudo

## Antes de tudo

- **Ollama** precisa estar rodando (`ollama list` no terminal confirma — se
  não estiver, o próprio comando costuma subir o app no Windows). Modelos
  usados: `qwen2.5:14b` (geração rápida) e `deepseek-r1:14b`
  (revisão/coerência, com `--revisar`).
- **ComfyUI** precisa estar rodando em `127.0.0.1:8188`
  (`C:\AI\ComfyUI\run_nvidia_gpu.bat`) antes de gerar qualquer imagem.
  Carregar o modelo leva alguns minutos depois de iniciado.
- Os scripts de texto (`scripts/*.py`) usam só a stdlib do Python — rodam
  com qualquer instalação de Python, não precisam de venv.
- Os scripts de áudio (`gerar_sao.py` etc.) ficam em `C:\AI\AudioCraft` e
  **precisam** da venv de lá (`venv\Scripts\python.exe`), porque usam
  torch/transformers na GPU.
- `base/` guarda o material de referência que você for mandando (manual do
  jogador, imagens etc.) — solte arquivos novos lá. Quando enviar mais
  páginas do manual, atualize `SAO_RPG_5e.md` (raiz do projeto) com o
  conteúdo novo — é dele que `scripts/ollama_client.py:carregar_guia_sistema()`
  lê, e é o que todos os geradores usam automaticamente. `docs/guia_sistema_aincrad.md`
  virou um redirect histórico curto — não é mais lido pelos scripts.

---

## Playbook: como construir um andar do zero (ordem que funcionou)

Isto é o roteiro reconstruído depois de já ter feito o Andar 1 inteiro +
o esqueleto do Andar 2. Segue esta ordem — cada etapa depende da anterior
pra ter contexto real (nomes, tom, NPCs) em vez de inventar solto.

### 0. Ancoragem canônica (antes de escrever qualquer coisa)

Pesquise o andar na SAO Fandom Wiki: nome da cidade principal, chefe de
andar, tema geográfico/visual, qualquer NPC ou evento que o anime/LN
mencione (mesmo de passagem). Anote isso **antes** de gerar conteúdo —
tudo que vier depois deve se encaixar nesse esqueleto canônico, com
homebrew preenchendo as lacunas que o cânone deixa (que é a maior parte).
Ver `docs/fontes.md` pra onde registrar a fonte.

**Lição do Andar 2:** bastou saber "Urbus" (cidade) e "Baran, o Rei Touro"
(chefe) + o tema geral (planalto árido) pra montar um esqueleto inteiro
coerente sem inventar fora do tom. Não precisa de mais cânone que isso pra
começar.

### 1. Abertura narrativa e estado da campanha

Escreva `docs/historia_campanha_andar<N>.md`: como a chegada acontece
(mecanismo de transição — reaproveitar a lógica de "Cristal de Ascensão"
de `docs/misterio_andar2.md` como molde, mesmo que o gatilho real do
andar seguinte seja outro), estado social/geográfico, e 2-3 ganchos de
abertura alternativos pro mestre escolher. Isto vira a fonte de verdade que
todo o resto do andar deve respeitar (mesmo papel de
`docs/historia_campanha.md` pro Andar 1).

### 2. Cidade principal

Uma ficha em `cidades/<nome>.md`, seguindo `cidades/_modelo_cidade.md`:
descrição, atmosfera, pontos de interesse, NPCs notáveis, ganchos. Baixo
volume esperado (uma cidade principal por andar) — não vale a pena um
gerador dedicado ainda; escrever à mão é mais rápido que criar/testar
script pra volume tão baixo.

### 3. NPCs de apoio da cidade (5-8 pra começar)

```
python scripts/gerar_npc.py "guarda veterano da cidade principal do andar N" --revisar
```
Opções: `--andar`, `--profissao`, `--arma`, `--papel`. Ou escreva
diretamente seguindo `npcs/_modelo_npc.md` quando o contexto/tom pedir
controle fino (foi o caso dos 6 NPCs do Andar 2 — todos escritos
diretamente, sem Ollama, porque cada um carregava uma tensão social
específica do andar que era mais rápido controlar escrevendo direto).
Cubra pelo menos: um NPC de recepção/orientação (papel de Guardiã de
Urbus), um de comércio/poder (Comerciante de Água), e um ligado ao tema
central do andar (Engenheira dos Aquedutos).

### 4. Monstros (3-5 pra começar, mais o chefe de andar)

```
python scripts/gerar_monstro.py "descrição da criatura" --revisar
```
Ou escreva direto seguindo `monstros/_modelo_monstro.md` — cubra o tema
geral do andar (2-3 criaturas de campo/terreno aberto) mais 1 de terreno
fechado/dungeon (ensina lógica de combate diferente — corredor apertado,
voo, etc.). O **chefe de andar** é o item mais importante desta etapa:
nome/forma canônicos se existirem, 3 fases (igual Illfang e Baran),
elemento de fraqueza claro, e uma "abertura real" que a mesa precisa
descobrir (não avisar de graça).

### 5. Mapa — esboço de regiões

`mapas/andar_<N>.md`: diagrama ASCII aproximado + lista de regiões
conhecidas com 2-3 frases cada. **Não** tente replicar o Compêndio
interativo (dados_mapa.js com coordenadas calibradas) nesta fase — isso só
vale a pena depois que o andar tiver conteúdo suficiente pra justificar (ver
item 9). Esboço em texto já serve pra rodar sessão.

### 6. Quests de entrada (8-10 pra começar)

`cenas/quests_andar<N>.md`, mesmo formato de `quests_andar1.md`: chegada →
tutorial de combate (2x, terreno aberto + fechado) → 2-3 quests sociais
que desenvolvem a tensão central do andar → preparação de raid → raid
contra o chefe. Isso é o "esqueleto jogável mínimo" — dá pra rodar sessões
reais só com isso, mesmo sem as outras etapas.

### 7. Puzzles e segredos (quando o andar crescer)

Só depois que o esqueleto básico (1-6) estiver rodando de verdade — puzzles
multi-etapa e segredos fragmentados (`docs/interacoes_e_segredos.md`,
`docs/puzzles_andar1.md` como molde) valem mais quando já existe contexto
de mundo pra ancorar a pista.

### 8. Armas/equipamentos/mercado (se o andar precisar de itens novos)

Só vale a pena se o andar introduzir um tipo de recurso genuinamente novo
(o Andar 1 não precisou de arma nova — as 19 armas da conversão pra D&D 5e,
`SAO_RPG_5e.md` Seção 7, já cobrem tudo). Preço e
venda seguem `docs/mercado_andar1.md` como molde de formato; balanceamento
segue a régua de `armas/00_catalogo_expandido.md` ("A regra de
balanceamento: facilidade de obter define o teto").

### 9. Compêndio interativo completo (só quando valer o investimento)

Esta é a etapa mais cara e só compensa depois que o andar tiver volume
comparável ao Andar 1 (30 regiões, 200+ pontos):
1. Coordenadas calibradas em `dados_mapa_andar<N>.js` (mesmo formato de
   `dados_mapa.js`).
2. `guias/pontos_andar<N>/<regiao>.md` — ficha por ponto (molde:
   `guias/pontos/cidade_inicio.md`), priorizando a cidade principal e as
   regiões que o grupo pisa primeiro (mesma lógica usada no Andar 1: saída
   inicial → primeira vila → cidade secundária → puzzles).
3. Estender `scripts/gerar_dados_web.py` (ou criar uma versão paralela) pra
   ler os arquivos do andar N e alimentar uma nova aba do Compêndio, ou um
   Compêndio próprio — decisão a tomar quando chegar nessa etapa, não
   antes (ver `docs/pendencias.md` sobre o app do Andar 1 hoje misturar
   monstros/NPCs de todos os andares nas mesmas abas).

### 10. Imagens e áudio (a qualquer momento depois que houver ficha)

```
python scripts/gerar_imagem.py "<descrição>" --nome npc_<slug>       # NPC
python scripts/gerar_imagem.py "<descrição>" --prompt-bruto --negativo "..." --nome monstro_<slug>  # monstro (SEMPRE --prompt-bruto)
python scripts/gerar_faltantes.py tudo                                # gera tudo que falta de uma vez
```
Rode `python scripts/gerar_dados_web.py` depois de qualquer ficha nova —
é o passo que "fecha o ciclo" e atualiza o app.

---

## Lições da rodada de varredura final (o que faria diferente/mais rápido)

- **Cross-reference com o elenco existente antes de inventar NPC novo.**
  Boa parte da profundidade do Andar 1 veio de reaproveitar NPCs já
  catalogados em cenas novas (ex: Suri Cartógrafa, Kazuo Tanaka, Diavel
  reaparecendo nas 50 Crônicas) em vez de sempre criar alguém do zero.
  Antes de escrever um NPC novo, `grep` rápido em `npcs/*.md` pelo papel
  que você precisa — geralmente já existe alguém que serve.
- **Balanceamento por atributo vale conferir cedo, não só no fim.** A
  auditoria final (feita ainda no sistema PBTA, antes da conversão pra
  D&D 5e — números de então, hoje históricos) achou que Conhecimento
  (Chicote/Pá) era o único atributo sem item Raro em 51 armas — um
  desequilíbrio que existia desde o catálogo original e só foi pego numa
  varredura dedicada. Ao criar itens novos por chefe/quest, checar
  rapidamente "quantos Raros esse atributo já tem" evita acumular a mesma
  lacuna no Andar 2 — hoje conferindo contra as 19 armas de `SAO_RPG_5e.md`
  Seção 7, não contra a lista antiga. `docs/balanceamento_armas_oficios.md`
  documenta o método usado (o arquivo em si virou redirect histórico).
- **`requer`/`revela` de ponto de mapa viraram campo morto** depois que o
  fog-of-war foi removido do Compêndio (virou "escudo do mestre" — tudo
  visível desde o início). Pro Andar 2, não vale a pena replicar esses
  campos nos dados de mapa a menos que o fog-of-war seja reativado de
  propósito — documentar a intenção evita o mesmo acúmulo de campo
  vestigial.
- **Documentação do próprio projeto desatualiza rápido.** Vários números
  em `docs/pendencias.md` e `docs/visao_geral.md` ficaram errados por
  duas rodadas seguidas (contagens antigas de monstro/NPC/ponto) porque
  cada rodada de conteúdo não voltava pra atualizar o resumo. Prática que
  ajudaria: sempre que uma rodada grande de conteúdo terminar, rodar a
  varredura de contagem (`grep`/Python simples contando arquivos e
  entradas) e atualizar os três documentos-resumo (`visao_geral.md`,
  `pendencias.md`, este arquivo) na mesma sessão, não depois.
- **56 quests já vieram com boa profundidade de uma rodada anterior sem
  isso estar registrado** — uma pendência "falta o passe de profundidade"
  ficou no backlog por rodadas inteiras depois de já ter sido resolvida.
  Antes de assumir que algo falta, conferir programaticamente (regex
  simples) é mais rápido e mais confiável que confiar no que o backlog diz.

## NPCs

```
python scripts/gerar_npc.py "guarda veterano da cidade do inicio" --revisar
```
Gera a ficha em `npcs/<nome>.md`. Opções: `--andar`, `--profissao`, `--arma`,
`--papel` (aliado/inimigo/neutro/vendedor/chefe_de_andar).

## Armas e itens

```
python scripts/gerar_arma.py "rapieira de um mestre de esgrima do andar 1"
```
Gera a ficha em `armas/<nome>.md`. Opções: `--tipo` (uma das 19 armas,
`SAO_RPG_5e.md` Seção 7), `--raridade` (Comum/Incomum/Raro/Épico/Lendário,
Seção 51/72), `--andar`.

## Monstros

```
python scripts/gerar_monstro.py "criatura territorial da regiao X" --revisar
```
Gera a ficha em `monstros/<nome>.md`, seguindo `monstros/_modelo_monstro.md`
(aparência, comportamento, ataques, 4 fraquezas, drop, doma).

## Cenas e quests

```
python scripts/gerar_cena.py "grupo encontra a entrada da masmorra do andar 1" --revisar
```
Gera a cena em `cenas/<titulo>.md`, já com sugestão de humor musical e
prompts prontos de trilha (MusicGen) e visual (ComfyUI). Opções: `--andar`,
`--local`, `--tipo` (exploracao/combate/social/chefe), `--npcs "Fulano,Beltrano"`.

## Cidades

Sem gerador automático — preencher `cidades/_modelo_cidade.md` na mão
(baixo volume esperado: uma cidade principal por andar). Se o volume
crescer muito, um `gerar_cidade.py` seguiria o mesmo padrão dos outros.

## Mapa, placas de arte e dados do app

```
python scripts/gerar_mapa_arte.py andar --tentativas 4   # placa do mapa (só terreno)
python scripts/gerar_mapa_arte.py todas                  # placa + planta da cidade + vistas
python scripts/gerar_dados_web.py                        # .md -> scripts/web/dados_conteudo.js
```

`gerar_dados_web.py` é o passo que **fecha o ciclo**: qualquer ficha nova em
`monstros/`, `npcs/`, `armas/`, `equipamentos/`, `docs/mercado_andar1.md`,
`cenas/quests_andar1.md` ou `cenas/cronicas_de_aincrad_ep*.md` só aparece
no Compêndio depois de rodar ele. Ele também imprime a lista de quem ainda
está sem imagem. Rode sempre depois de escrever conteúdo novo.

## Imagens (ComfyUI + Ollama)

```
python scripts/gerar_imagem.py "<descrição>" --nome npc_<slug>
python scripts/gerar_imagem.py "<descrição>" --prompt-bruto --negativo "..." --nome monstro_<slug>
python scripts/gerar_faltantes.py tudo   # gera tudo que falta de uma vez, lote completo
```
Monstros **precisam** de `--prompt-bruto` (ver `docs/guia_estilo_visual.md`,
seção "Monstros") — sem isso viram cavaleiro humano genérico. Precisa de
Ollama **e** ComfyUI rodando (ver "Antes de tudo" no topo).

## Música e efeitos sonoros

Em `C:\AI\AudioCraft`:
```
venv\Scripts\python.exe gerar_sao.py "ambiente da praca da cidade do inicio, dia 10"
```
Detecta sozinho (via Ollama) se é música ou SFX e onde salvar
(`musicas/` ou `efeitos_sonoros/` do projeto SAO RPG). Ver
`docs/guia_estilo_audio.md` pro vocabulário/categorias. As 6 trilhas
principais (`01_abertura` ... `06_cidade`) já foram geradas por
`gerar_trilhas_sao.py` — `gerar_sao.py` é pra variações extras e SFX pontuais.

## Vídeo/cenas (ComfyUI)

Sem automação ainda — ver `docs/guia_estilo_visual.md` pro prompt manual e
o próximo passo real (exportar um workflow da UI antes de automatizar).

## Fora de escopo (decisão do usuário, não pendência)

- **VTT (Foundry ou qualquer outro).** `base/foundry_sistema/` continua
  vazia por decisão explícita — o Compêndio HTML é o único "app" que este
  projeto usa. Não reabrir esse item a menos que o usuário peça de novo.
- Descrição automática de imagens de referência com `qwen2.5vl:7b` — fácil
  de adicionar se um dia precisar, mas não há demanda hoje.
