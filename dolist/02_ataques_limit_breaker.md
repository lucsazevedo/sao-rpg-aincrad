---
titulo: 3 ataques por arma + Limit Breaker
tamanho: G
uso: mestre
---

# 3 ataques por arma (2 normais + Limit Breaker)

## A ideia

Cada uma das 23 armas ganha **3 golpes nomeados** em vez de 1 Move de
Combate só:
- 2 ataques "normais", cada um usando um **atributo diferente** (ex: foice
  hoje só usa Técnica — um segundo golpe dela usaria Corpo, um terceiro
  Reflexo, por exemplo).
- 1 **Limit Breaker**: um golpe especial destravado por um **contador de
  sucesso/erro** — ao bater 10, o jogador pode usar.

## Por que isso é o maior item da lista

Isso não é "adicionar uma regra" — é redesenhar **69 movesets** (23 armas ×
3), cada um precisando de: nome, atributo, gatilho, resultado em 10+/7-9/6-,
e cuidado pra não duplicar o que a Move de Combate atual já cobre. É
comparável, em volume de design, a ter feito as 23 armas originais de novo.

Além disso precisa de:
- **Mecanismo de contador**: onde ele mora (por personagem? por arma
  equipada? zera ao trocar de arma?), como sobe (todo teste conta, só
  combate conta, só uma arma específica soma), e onde fica salvo — schema
  novo, provavelmente uma coluna em `personagens.estado` ou tabela própria
  se for por-arma.
- **Retrofit** no que já existe: `moves_arma` no banco hoje tem só
  `move_a`/`move_b` — vira `move_a`/`move_b`/`move_c`, e o painel
  `admin.html` + `admin_schema.js` precisam do campo novo.
- Balanceamento: dois golpes "normais" por arma não podem competir demais
  com o golpe já existente, nem tornar irrelevante a escolha de atributo
  principal da arma.

## ✅ Carregado (10/08) — texto dos 69 movesets, ainda SEM revisão de qualidade

Achado numa varredura: uma sessão anterior já tinha gerado os 69 movesets
via Ollama (`scripts/db/dml_moves_armas_golpes.sql`, commits "Propostas do
Ollama"/"Piloto de golpes de arma") — arquivo pronto, nunca tinha sido
aplicado no banco. Apliquei: as 23 armas agora têm `golpe_2`, `golpe_3` e
`limit_breaker` preenchidos em `moves_arma`.

**Revisão automatizada feita (10/08)**: conferido programaticamente nas
23 armas — 0 problema estrutural (nome/atributo/efeito faltando, nome
duplicado entre os 5 campos de uma arma) e **as 3 atributos por arma são
sempre diferentes entre si** (move_a/golpe_2/golpe_3), batendo exatamente
com o pedido original do item ("2 ataques normais, cada um usando um
atributo diferente"). Isso é mais do que eu esperava de um rascunho de
IA — a checagem estrutural e de design passou limpa. **O que não foi
feito**: leitura humana de balanceamento/tom narrativo linha a linha —
isso é julgamento subjetivo que só uma leitura sua resolve. Nenhum lugar
do site/mesa ainda exibe esses campos pra ninguém ver, então dá pra
revisar sem pressa quando quiser.

## ✅ Resolvido (10/08) — mecanismo do contador construído e testado

Decidido pelo usuário: **por arma equipada** (cada um dos 23 tipos guarda
o próprio número, trocar de arma não zera o anterior), **zera ao usar**
(limiar 10, já estava definido em `dolist/02_ataques_limit_breaker.md`
antigo). Tabela `limit_breaker_contador`
(`scripts/db/schema_limit_breaker.sql`) — chave (personagem, tipo de
arma), RLS mestre-only pra escrever (é ferramenta de mesa, não algo que o
jogador se autopromove; jogador só lê o próprio). UI: `Mestre.vue` (ficha
de cada jogador — adicionar tipo de arma, +1/−1, "Usar" zera) e
`Ficha.vue` (jogador vê os próprios contadores, leitura). Testado com
rollback: 10 incrementos chegam a 10, "usar" zera, jogador não consegue
editar contador de outro personagem (RLS bloqueia, 0 linhas afetadas).

Achado no caminho: `armas.tipo` tinha uma linha com "Lanca" sem cedilha
(`lanca_de_guarda`) enquanto `moves_arma.nome` usa "Lança" — os 23 tipos
não batiam 100% por causa disso. Corrigido (agora os dois lados usam a
mesma grafia em todas as 23 armas).

## ✅ Resolvido (12/08) — 13 armas reescritas a partir do PDF oficial do usuário

Usuário trouxe `SAO_PBTA_Armas_e_Moves_Atualizado.pdf` — texto definitivo
(não rascunho de IA) pra 13 das 23 armas: Chakrams, Escudo e Espada,
Espada Longa, Foice, Katana, Lança, Machado, Martelo, Rapieira, Bastão,
Clava, Corrente com Peso, Leque. Cada uma com 2 golpes normais + Limit
Break (3º move, +2 no acerto já embutido no gatilho), formato
"Quando [gatilho], role +Atributo" / 10+ escolha 2 / 7-9 escolha 1 / 6-
o Mestre narra (5 ideias cada).

Transcrito via `scripts/db/_gerar_dml_moves_pdf.py` →
`scripts/db/dml_moves_armas_pdf_pbta.sql` (rodar contra o banco pra
aplicar). Mapeamento pro schema existente: `move_a` = Move 1, `golpe_2` =
Move 2, `limit_breaker` = Move 3/LIMIT BREAK; `move_b` e `golpe_3` foram
zerados nessas 13 (o PDF usa só 3 golpes por arma, não 5 — essas duas
colunas eram do rascunho Ollama de 10/08, que esse PDF substitui pras 13
que ele cobre).

**Leque**: pedido explícito do usuário ("crie o leque, que será de
técnica") — já vinha com golpes genéricos no rascunho antigo, agora tem o
conteúdo oficial do PDF (Dança das Lâminas, Véu Cortante, Tempestade das
Mil Lâminas), atributo Técnica.

**Ainda não coberto pelo PDF** (mantidas com o rascunho antigo, sem
revisão): Adagas, Adagas de Arremesso, Arco e Flecha, Besta, Chicote,
Glaive, Manopla, Nunchaku, Pá, Tonfas — 10 armas. Se/quando o usuário
trouxer material equivalente pra elas, repetir o mesmo processo.

## ✅ Resolvido (12/08) — as 10 armas restantes, mesmo formato

Pedido do usuário: "com base em tudo que você criou você já tem base pra
fazer isso no restante da base" — estendi o mesmo formato PBTA (2 golpes
normais + Limit Break, mesmo atributo nos 3, +2 no acerto do Limit Break)
pras 10 armas que o PDF não cobria. Diferente das 13 anteriores (transcrição
literal de um PDF trazido pelo usuário), aqui não havia texto pronto — usei
como base **docs/guia_sistema_aincrad.md** (fonte canônica já existente:
atributo principal + Marca + "Move de Combate" original de cada arma).
Move 1 de cada arma é uma reformatação fiel desse Move de Combate
canônico pro molde 10+/7-9/6-; Move 2 é um segundo ângulo de combate novo
pra mesma arma; o Limit Break é um golpe de assinatura novo, nomeado a
partir da própria identidade/Marca da arma (ex: "Território Disputado"
pro Chicote, ecoando a Marca "transforma espaço aberto em território
disputado").

Gerado por `scripts/db/_gerar_dml_moves_restante.py` →
`scripts/db/dml_moves_armas_restante.sql`, mesma validação de JSON que o
lote anterior (30 blocos, 10 armas × 3 golpes, 5 itens em cada lista).

**Com isso, as 23 armas estão no mesmo padrão PBTA de 3 golpes.** Falta só
aplicar os dois arquivos `dml_moves_armas_*.sql` no banco (não tenho
acesso de escrita ao Supabase daqui) — e ainda vale o ponto de 10/08: em
lugar nenhum do site isso é exibido pro jogador ainda, só no editor do
Compêndio do mestre.

**Ainda não exibido em lugar nenhum do site/mesa** — mesma observação de
10/08, ninguém lê `moves_arma` na tela ainda (só o editor do mestre no
Compêndio). Item futuro em aberto: decidir onde/como mostrar os 3 golpes
pro jogador (Ficha? Combate?).
