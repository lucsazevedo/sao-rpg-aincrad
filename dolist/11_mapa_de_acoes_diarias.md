---
titulo: Mapa de ações — o que dá pra fazer no jogo online
uso: mestre
---

# Mapa de ações diárias

## Combate / Exploração (todo mundo tem acesso)

| Ação | Custo de Fôlego | Resultado |
|---|---|---|
| Enfrentar monstro comum de região desbloqueada | Baixo | Drop comum, XP pequeno |
| Enfrentar monstro **acima** do nível recomendado | Alto | Drop melhor, XP maior, **risco de Desmaio** |
| Miniboss/boss de andar | Alto, talvez em grupo | Drop raro, XP grande |
| (Domador) chocar ovo / cuidar de pet | Médio | Pet craftado (item 1) |

A trava de nível (`nivelRecomendado` já no banco) decide o que aparece
como "comum" vs "acima do nível" pra cada personagem — não é fixo, é
relativo a quem está jogando.

## Ofício (o que muda de personagem pra personagem)

Reaproveita **as mesmas 3 Ações de Ofício que cada profissão já tem** —
não precisa inventar ação nova, só dar Fôlego/tempo/recompensa pra elas.
Alguns exemplos, pra mostrar a variedade real (16 no total):

- **Caçador**: extrai material de um abatido, lê rastro, arma espera.
- **Ferreiro**: processa minério, forja peça, lê metal desconhecido.
- **Bibliotecário**: pesquisa criatura antes do combate, lê símbolo.
- **Diplomata**: media conflito, consegue audiência.
- **Músico**: toca pra levantar o grupo, lê a sala.
- **Cozinheiro**: prepara refeição com bônus, puxa conversa.

Cada uma rende **material, Col, ou progresso de reputação**, dependendo
da ação — não é sempre a mesma moeda.

## Craft / Produção

- Inicia o craft (consome material coletado), espera o tempo da raridade
  (minutos a 12h — já decidido em `06_jogo_online_diario.md`), coleta
  quando pronto.
- Item craftado pode ser usado ou vendido no próprio mercado.

## Social / Comunidade

- Missão do quadro do dia — pode misturar tipo (matar X, coletar Y,
  entregar Z pra NPC, mediar disputa de clã) em vez de ser sempre "mate
  N monstros".
- Ajudar outro jogador, NPC ou clã → alimenta reputação (item 10).
- Comprar/vender no mercado de outro jogador (item 9).

## Progressão

- Toda ação acima rende XP (item 5).
- Nível sobe → libera região/monstro novo (a trava já decidida).

## O que fica de fora, de propósito, por enquanto

- **PvP direto** (atacar outro jogador, tipo TheCrims) — não é o tom que o
  Sindicato dos Ossos nem a mesa até agora pediram. Fica como pergunta em
  aberto, não decisão tomada.

## Preciso saber

- Todas as **16 profissões** entram já na v1, ou começa com um
  subconjunto (ex: Caçador, Ferreiro, Alquimista, Domador — as mais
  "ativas" pro loop diário) e expande depois?
- PvP entra em algum momento (mesmo que light, tipo duelo consentido) ou
  fica de fora por princípio?
- Boss/miniboss **exige** grupo (precisa de outro jogador online junto),
  ou dá pra encarar sozinho com risco maior?
