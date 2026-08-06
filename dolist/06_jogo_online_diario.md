---
titulo: Jogo online diário (missões, desbloqueio, mercado)
tamanho: GG
uso: mestre
---

# Jogo online diário — o projeto principal

## A ideia

Jogador loga, faz coisa todo dia: craft, missão diária, quadro de missão,
drop, compra, ir desbloqueando conteúdo novo conforme progride, **cada
jogador pode ter o próprio mercado** pra vender o que craftou.

## Por que isso é "GG" e não um item

Isso é a junção de tudo mais nesta lista — **níveis/XP (5)**, **drop e
carta (7)**, **inventário/equipamento (8)** e **dinheiro/mercado (9)** são
literalmente as peças que fazem esse loop existir. Cada peça sozinha é
"médio"; a soma delas funcionando junto, com missão diária puxando XP que
libera craft que abastece o mercado que gera dinheiro que compra a próxima
missão, é o projeto inteiro da fase 2 do site (a fase 1 foi tudo que já
construímos: banco, login, visibilidade, painel, RAG).

## Ordem que eu sugiro

1. **Inventário/equipamento (8)** primeiro — sem lugar pra guardar item,
   nada mais faz sentido.
2. **Drop e carta (7)** — enche o inventário com conteúdo real.
3. **Nível/XP (5)** — dá a curva de progresso.
4. **Dinheiro/mercado (9)** — fecha a economia.
5. **O loop diário em si**: quadro de missão, missão diária, o que
   desbloqueia o quê — só faz sentido desenhar depois que 1-4 existirem,
   porque é literalmente "o que essas peças fazem juntas".

## Preciso saber

- Concorda com essa ordem, ou tem uma peça que é mais urgente pra você
  especificamente?
- "Cada jogador pode ter um mercado" — é um mercado **por jogador**
  (cada um com sua própria vitrine) ou um mercado **compartilhado** onde
  todo mundo lista item no mesmo lugar (tipo leilão)? Muda bastante o
  design.
