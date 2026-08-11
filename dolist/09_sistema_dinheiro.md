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

- **Decidido (ATUALIZADO):** Não existe limite diário de Col! A régua de grind do jogo online é **Fôlego** (já existe coluna `folego` int no schema — teto 20, recupera +1 a cada 30 minutos, ou totalmente com 6h de descanso). Atividades (missão de combate = 5, missão de coleta = 4, ofício = 6, contrato arriscado = 10, craft = 1-3 dependendo da dificuldade) gastam Fôlego; **Mercado (comprar, vender, criar anúncio, remover anúncio) NÃO gasta Fôlego NUNCA** — se o jogador estiver sem Fôlego, ele só para de fazer missão/craft, mas continua usando o mercado normalmente.
- **Decidido (ATUALIZADO):** Preço no mercado é **LIVRE** (estilo Mercado Livre); **NÃO EXISTE TAXA NENHUMA** — vendedor recebe 100% do valor do anúncio (zero custo pra anunciar, zero custo pra vender). Jogo é mesa pequena com poucos jogadores — não precisa de pia de dinheiro.
- **Loja por vendedor:** cada jogador tem página "Loja de [NomePersonagem]" listando todos os anúncios ativos + quantos itens já vendeu + ranking de reputação de vendedor (estrelas 1-5 por transação concluída sem reclamação).
- **Anúncio expira em 7 dias** (corridos). Expirou, item volta pro inventário do vendedor automático. Remover anúncio antes de expirar também é 100% livre sem penalidade.
- **Fluxo compra:** 1 clique em Comprar → confirmação → desconta Col do comprador → adiciona item no inventário do comprador → envia 100% Col pro vendedor → log em transacoes. Tudo atomicamente via função SQL.
- **Log transação:** tabela `transacoes` já existe no schema, campos: data, tipo (compra_mercado / venda_mercado / missao_recompensa / craft), personagem_id, outro_personagem_id (null se for NPC/missão), valor_col, observacao (id do anúncio, nome da missão, etc). Mestre pode auditar tudo via admin.
