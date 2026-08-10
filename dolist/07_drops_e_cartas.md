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

## Preciso saber

- A carta dá bônus em qual tipo de coisa — atributo, dano, resistência,
  algo narrativo (tipo as Especialidades do sistema de Evolução)? (Vale só
  pra quando o jogador leva o item pra mesa — no online não tem efeito.)
- Ela é **igual a "Único"** no catálogo atual (uma unidade no andar inteiro,
  paga um preço) ou mais comum que isso, tipo Raro?
- **Cristal** (novo, exclusivo de Boss): o que ele faz? Ideias possíveis —
  encaixa num equipamento como um segundo slot de bônus (tipo socket),
  vira ingrediente pra craft de raridade mais alta, ou é o "abrir uma
  Especialidade nova" do sistema de Evolução. Preciso de direção antes de
  desenhar o schema dele.
