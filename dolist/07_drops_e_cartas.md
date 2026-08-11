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

## Decidido: o que dropa por categoria de monstro

Reaproveita as 4 categorias que o roster do bestiário já usa (Comum/Mini
Boss/MVP/Boss — ver `revisao_item4_roster_bestiario.md`):

| Categoria | Crafting | Equipável | Carta | Cristal |
|---|---|---|---|---|
| Comum | ✓ | | | |
| Mini Boss | ✓ | ✓ | | |
| MVP | ✓ | ✓ | ✓ | |
| Boss | ✓ | ✓ | ✓ | ✓ (exclusivo) |

Cada categoria é superset da anterior — Boss dropa tudo que MVP dropa,
mais **cristal**, que é exclusivo dele. *(Registrando minha leitura da
mensagem — se "cristal" não for exclusivo de Boss, avisa que ajusto.)*

**Cristal é categoria nova**, ainda sem definição de efeito — precisa
decidir o que ele faz (embutir em equipamento tipo socket, ingrediente de
craft de tier mais alto, algo próprio). Ver "Preciso saber" no fim.

## Lembrete: nada disso tem efeito mecânico *dentro* do jogo online

Confirmado junto com `08_equipamento_inventario.md`: equipável/consumível/
carta/cristal dropados no site **não bônus nenhum enquanto o personagem
está no jogo online** — servem pra levar pra mesa de RPG de verdade, onde
o efeito existe. Isso é o que permite `12_sistema_de_poder.md` derrubar o
"Poder por equipamento": não tem por que somar poder de algo que não age
no jogo online.

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

## ✅ Resolvido em parte (10/08) — catálogo populado a partir do roster (item 4)

**Achado que corrige uma suposição deste arquivo**: no roster de verdade,
**cristal não é exclusivo de Boss** — Mini Boss e MVP também têm cristal
próprio nomeado (ex. Alfa Lupino/mini_boss → "Cristal Selvagem"). A
tabela de "o que dropa por categoria" no topo deste arquivo está com essa
premissa errada — Boss é só quem tem MAIS coisa (crafting+equipável+
carta+cristal), não quem tem cristal *sozinho*.

Importado (`scripts/db/_importar_bestiario.py`, reaproveita o parse do
item 4): **150 cartas** e **57 cristais únicos** em `cartas`/`cristais`
(já existiam vazias no schema). `raridade`/`tipo_bonus` preenchidos por
heurística (categoria do monstro de origem → raridade; palavra-chave no
nome → tipo_bonus, dos 4 valores que o CHECK do banco já trava:
atributo/dano/resist/especial). **Descrição/efeito de cada carta e
cristal ficou como placeholder** ("efeito ainda não definido") — isso é
justamente o que as perguntas abaixo pediam e eu não inventei 200+ textos
de efeito sem direção sua.

**Slot de carta equipada**: já resolvido sem precisar de trabalho novo —
`Equipamentos.vue` (rescrito no item 8) já tem o slot "Carta Equipada" no
paper doll, um só, igual pedido aqui.

## Preciso saber (ainda em aberto — conteúdo, não schema)

- A carta dá bônus em qual tipo de coisa — atributo, dano, resistência,
  algo narrativo? (`tipo_bonus` já tem as 4 opções no banco, só falta
  confirmar/ajustar carta por carta, hoje é heurística de nome.)
- Ela é igual a "Único" (uma unidade no andar inteiro) ou mais comum, tipo
  Raro? (Hoje mapeei raridade da carta pela categoria do monstro:
  mini_boss→Incomum, mvp→Raro, boss→Épico — não usei "Único".)
- **Cristal**: o que ele faz de verdade (socket, ingrediente de craft,
  Especialidade nova)? Catálogo existe (57 nomes), efeito não.
