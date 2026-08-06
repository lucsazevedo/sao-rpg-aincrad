---
titulo: Sistema de dinheiro/economia
tamanho: M–G
uso: mestre
---

# Sistema de dinheiro (economia online)

## A ideia

Personagem ganha Col fazendo missão (com **limite diário** — não dá pra
grindar sem fim), pode craftar pra vender, pode gastar no próprio mercado
ou no de outro jogador — uma economia de verdade, não só um número que só
sobe.

## O que precisa

- **Carteira**: saldo de Col por personagem — coluna simples.
- **Limite diário**: precisa de um contador que reseta (quanto já ganhou
  hoje vs. o teto) — mesmo tipo de mecanismo que "missão diária" (item 6)
  já vai precisar, dá pra construir junto.
- **Log de transação**: pra não virar caixa preta — quem pagou quem, por
  quê, quando. Útil também pro mestre auditar se algo tá desbalanceado.
- **Mercado**: aqui mora a decisão grande — ver a pergunta no
  `06_jogo_online_diario.md` sobre mercado por jogador vs. compartilhado.
  Um mercado por jogador é, na prática, uma mini loja com CRUD própria
  (listar item, definir preço, tirar do ar) — reaproveita o padrão de
  tabela+RLS já usado em tudo, mas é uma peça de e-commerce real, não um
  saldo simples.

## Preciso saber

- O limite diário é em **Col ganho** (não importa como) ou **por
  atividade** (X de missão + Y de venda, tetos separados)?
- Preço no mercado é **livre** (cada jogador define) ou tem faixa
  sugerida/máxima pro mestre não perder controle da economia?
