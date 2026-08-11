---
titulo: Reputação — jogador e clã
tamanho: M
uso: mestre
---

# Reputação (jogador e clã)

## A ideia

Quanto mais ação boa pra "comunidade" o jogador faz, mais mordomia ele
ganha — e isso vale tanto pro personagem individual quanto pro clã inteiro
dele.

## Isso já existe, parcialmente — não é do zero

`docs/regras_nucleares_campanha.md` já tem a regra **Favor e Suspeita**:
reputação de **-3 a +3**, registrada por pessoa, facção ou clã, mudando no
máximo 1 ponto por relação por sessão. E cada clã já tem uma tabela de
**Reputação atual** por frente (Cidade do Início, Tolbana, Kaldrin, Mercado,
Labirinto, Outros clãs) — ver `clas`/`clas_publico` no banco, já usado pelo
Sindicato dos Ossos e os outros 5 clãs.

O que falta é levar isso **do papel pro site**: hoje é o mestre que
acompanha na mão, sessão a sessão. A ideia nova é isso virar **número de
verdade no banco**, que sobe sozinho quando o jogador completa missão/ação
boa (item 6), e que **desbloqueia mordomia** — desconto num mercado, acesso
a área/missão que exige reputação mínima, etc.

## O que precisa

- Coluna de reputação por `personagens` (jogador) — provavelmente reaproveitando
  a escala -3/+3 já documentada, não inventando uma nova.
- Tabela de reputação **por clã**, ligando personagem → clã com um número
  próprio (a versão "pessoal" da tabela que hoje é só clã→cidade).
- Lista de "mordomias" — o que cada faixa de reputação libera. Isso é
  decisão de conteúdo, não só de schema.

## Preciso saber

- ~~Reputação de jogador é só com o próprio clã, ou também com cada um dos
  outros 5?~~ **Respondido (10/08): universo inteiro** — cidades, vilas e
  NPCs, não só os 6 clãs. Ver "Resolvido" abaixo.
- As "mordomias" são coisa do jogo online (desconto, acesso) ou também
  afetam a mesa de RPG (o Favor/Suspeita já documentado passa a ser
  alimentado pelas ações do site, em vez de só anotado pelo mestre)? —
  **ainda em aberto**, não decidido nesta rodada. Implementado por enquanto
  só como registro (número + histórico); nenhuma mordomia concreta
  (desconto, acesso condicionado) foi ligada ainda — é conteúdo, não schema.

## ✅ Resolvido (10/08) — schema, trigger e UI

- `reputacao_personagem.cla_nome` (FK pra `clas`, só 6 valores possíveis)
  virou `alvo_nome` (texto livre, sem FK) + `alvo_tipo`
  (`cla/cidade/vila/npc/faccao/outro`) — `scripts/db/schema_reputacao_universal.sql`.
  Mesma mudança em `missoes_quadro.reputacao_cla_nome` → `reputacao_alvo_nome`
  (+ `reputacao_alvo_tipo`), hoje sem nenhuma missão usando ainda (conteúdo
  pendente, não é bug).
- **Ganho automático por missão**: trigger `reputacao_por_missao` em
  `missao_diaria` — quando uma missão concluída tem `reputacao_alvo_nome`/
  `reputacao_delta`, soma automático (clampado -3..+3) sem precisar de
  código novo no app. Testado ponta a ponta com rollback.
- **Mestre ajusta na mão**: RPC `mestre_ajustar_reputacao`, gated por
  `is_mestre()` — jogador **não pode** editar a própria reputação (RLS
  bloqueia insert/update direto na tabela também, testado). UI em
  `Mestre.vue`, dentro da ficha de cada jogador.
- **Leitura pro jogador**: `Ficha.vue` mostra a lista de relações do
  próprio personagem (read-only).
