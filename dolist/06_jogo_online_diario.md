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

## Referência: TheCrims, adaptado pro que já existe na mesa

Pesquisado (ver `pt.wikipedia.org/wiki/The_Crims` e o guia oficial). Não
copia mecânica nova — reaproveita vocabulário que a mesa já tem:

- **Fôlego** (energia): teto numérico, regenera com o tempo, velocidade
  ligada ao atributo Espírito. É a Condição "Exaurido" que já existe em
  `regras_nucleares_campanha.md`, só que virando barra de verdade no site.
  Ação custa Fôlego; ação arriscada exige um mínimo.
- **Desmaio** (TheCrims manda pra cadeia num roubo falhado): reaproveita
  **À Beira** e a Condição "Crítico" (3 Condições acumuladas) — tentar algo
  ousado e falhar deixa o personagem impedido de agir por um tempo, com
  custo real (perde item/Col), redutível pagando ou esperando. Mesmo peso
  dramático que já vale na mesa.
- **Liberação por nível**: monstros já têm `nivelRecomendado`/`ameaca` no
  banco — hoje é só texto. Vira trava de verdade: nível abaixo do
  recomendado, local/monstro fica bloqueado.
- **Craft demorado**: a régua de raridade já existente
  (`armas/00_catalogo_expandido.md` — "facilidade de obter define o teto")
  ganha um cronômetro: Comum rápido, Incomum médio, Raro demorado.

## Decidido (ritmo do jogo)

- **Fôlego**: casual — enche sozinho em 3-4h. Dá pra logar 2-3x ao dia sem
  virar grind de app.
- **Desmaio**: tempo travado + perde uma fração do Col que está "na mão"
  (não guardado) — mesma lógica do TheCrims (20%), precisa existir a
  carteira (item 9) antes de valer a pena ligar essa punição.
- **Craft**: Comum = minutos, Incomum = 1-3h, Raro = 6-12h. Sempre cabe
  num dia, ninguém trava esperando demais.

## Preciso saber

- Concorda com essa ordem, ou tem uma peça que é mais urgente pra você
  especificamente?
- "Cada jogador pode ter um mercado" — é um mercado **por jogador**
  (cada um com sua própria vitrine) ou um mercado **compartilhado** onde
  todo mundo lista item no mesmo lugar (tipo leilão)? Muda bastante o
  design.
