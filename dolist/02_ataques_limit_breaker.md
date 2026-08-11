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
