---
titulo: Equipamento e inventário no site
tamanho: M
uso: mestre
---

# Sistema de equipamento e inventário no site

## A ideia

O personagem no site (hoje `personagens.html` só mostra a ficha estática)
ganha inventário de verdade — item que ele tem, item que está equipado,
progredindo conforme ele joga (drop, compra, craft).

## Por que isso é a base de tudo o resto

Item 7 (cartas/drop) e item 9 (dinheiro/mercado) só fazem sentido se
existir um lugar pra **guardar** o que foi conseguido. Recomendo este ser o
**primeiro** dos itens de economia a construir (ver `06_jogo_online_diario.md`).

## O que precisa

- Tabela `inventario` (jogador_id, item_id, tipo do item — arma, equip,
  carta, material —, quantidade).
- Colunas de "equipado atualmente" (arma equipada, peça por slot, carta —
  ver item 7) no personagem, ou uma tabela `equipado` separada.
- UI em `personagens.html`: ver o que tem, equipar/desequipar.
- RLS: cada jogador só edita o próprio inventário (autenticado, id bate com
  o personagem) — mestre vê/edita tudo, mesmo padrão já usado em todo o
  resto do banco.

## Preciso saber

- Um jogador pode ter **mais de um personagem**, ou é um personagem por
  conta (como a Umbra é hoje)?
- Craft e compra entram por aqui direto, ou só depois que os itens 7 e 9
  existirem? (Recomendo construir a tabela de inventário já pensando nos
  três, mesmo que só ligue um por vez.)
