---
titulo: Drops estilo MMO (equipável, consumível, carta única)
tamanho: M–G
uso: mestre
---

# Aumentar drops — estilo MMO de verdade

## A ideia

Tabela de drop de monstro vira de verdade — não só "1-2 materiais", mas o
padrão de MMO: **equipável**, **consumível** e **carta**, cada monstro com
sua própria mistura das três. Cartas seguem a torção própria: no Ragnarok
você equipa uma por *slot*; aqui **o jogador só pode equipar uma carta no
total**, não importa quantos itens tenha.

## Por que a mecânica em si é simples

É basicamente: uma tabela nova `cartas` (nome, efeito, raridade, monstro de
origem — mesmo formato de `armas`/`equipamentos` que já existe), mais **um
slot só** no personagem pra carta equipada (uma coluna, não uma tabela de
relação). Reaproveita 100% do padrão já construído (tabela + RLS + CRUD no
`admin.html`).

## Onde está o trabalho de verdade

**Volume de conteúdo**: decidir, monstro por monstro, o que ele dropa nas
três categorias (equipável, consumível, carta) e com que chance. Isso
cresce **junto** com o item 4 (bestiário até andar 50) — na prática é o
mesmo trabalho: toda vez que um monstro entra no jogo (Andar 1 hoje, os
outros 49 depois), já nasce com a tabela de drop completa, não só um
material solto. Por isso o tamanho subiu de M pra **M–G** — o esqueleto
(schema + regra) é médio, mas ele não para de crescer conforme o bestiário
cresce.

## Preciso saber

- A carta dá bônus em qual tipo de coisa — atributo, dano, resistência,
  algo narrativo (tipo as Especialidades do sistema de Evolução)?
- Ela é **igual a "Único"** no catálogo atual (uma unidade no andar inteiro,
  paga um preço) ou mais comum que isso, tipo Raro?
