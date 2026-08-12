---
titulo: Backlog — reforma de profissões, minigames e balanceamento
tamanho: G
uso: mestre
---

# Backlog — reforma de profissões, minigames e balanceamento

Anotado em 12/08 durante a sessão de golpes de arma (item 02) — usuário
mandou uma sequência rápida de ideias/decisões pra profissões que não
cabem todas na mesma resposta. Registrado aqui pra não perder, cada item
ainda precisa de spec própria antes de virar código.

## ✅ Decidido (já sendo aplicado — ver commit de profissões)
- Bibliotecário + Diplomata → unificam em **Informante** (Conhecimento).
- Coveiro → sai do roster, funções absorvidas por **Mercenário**.
- "Pescador" (nunca foi profissão formal no roster, só NPC/lore) → fica
  confirmado que pesca é escopo do **Caçador** (o Move Exclusivo dele já
  cobre "pescar" explicitamente).
- Roster ganha 3 profissões novas com Move Exclusivo pronto (PDF
  `SAO_PBTA_Profissoes_e_Moves.pdf`): **Informante**, **Mestre de
  Montarias**, **Minerador**.

## ✅ Resolvido (12/08, segunda rodada) — "resolve você, modo Cellbit"

Usuário deu carta branca ("você toma as decisões, você resolve") pro
resto da lista. Decisões tomadas e already implementadas (ver
`scripts/db/schema_reforma_cellbit_profissoes.sql`):

- **Cartógrafo : Historiador** → Cartógrafo **absorve** o papel de
  Historiador (não vira profissão separada). Marca atualizada + Move
  Exclusivo novo "Crônica do Andar" (+Conhecimento, documentar/catalogar
  locais e eventos do andar).

- **Minigame do Cartógrafo — "Névoa do Andar"**: grade 3×3 por
  personagem, revela até 3 áreas por dia (reseta à meia-noite), cada
  área dá Col (10-40), XP de Cartógrafo (5-15) ou nada. Freio anti-farm
  = limite diário fixo de 3, mesmo espírito do `limite_diario` que já
  existe em `transacoes`. UI em Profissoes.vue, aba só visível pra quem
  é Cartógrafo.

- **Minigame do Músico — "Composição Viva"**: sequência tipo Simon (5
  notas, 4 símbolos), jogador repete a ordem. Sucesso cria um registro
  em `buffs_grupo` ("+1 na próxima rolagem importante", 2h de validade),
  visível pra mesa inteira num banner no StatusBar. Custa 2 de Fôlego
  por tentativa (sucesso ou não) e trava em 2 buffs bem-sucedidos por
  dia — mesmo racional de fôlego-como-limite já usado em craft.
  **Importante**: o buff é só um registro visível — não é aplicado
  automaticamente em nenhuma rolagem (nada no sistema hoje resolve dado
  no servidor pra combate/craft usar isso sozinho), o mestre aplica o
  +1 manualmente na mesa quando alguém pede pra usar o buff ativo.

- **Limitar profissão por clã** → decidido: cada clã pode (opcional)
  listar `profissoes_aceitas`. Vazio/null = aceita qualquer profissão.
  Travado dentro de `pedir_entrada_cla` (erro claro se a profissão do
  personagem não estiver na lista), editável no Compêndio do mestre, e
  mostrado no card de recrutamento pro jogador saber antes de tentar.

- **Balancear profissões / anti-farm** → resolvido *para o que é
  digital*: os dois minigames novos já nasceram com freio (3/dia e
  2/dia). O resto do sistema de profissão (os 15 Moves Exclusivos do
  PDF) **não é digitalizado** — não tem botão que resolve dado sozinho,
  é o mestre narrando na mesa com 2d6 físico ou mental, então "farm
  infinito" não se aplica a eles do jeito que se aplicaria a um botão
  de app. Balanceamento fino de economia (Col/hora, XP/hora entre
  profissões) segue em aberto — isso só dá pra calibrar com dado real de
  playtest, não em cima de chute.

## Como retomar o que ainda falta

Restam só itens fora do que foi decidido nesta rodada: balanceamento
fino de economia entre profissões (precisa de dado de playtest, não de
mais decisão de design) e qualquer ajuste de sensação de jogo nos dois
minigames depois de testados na mesa de verdade.
