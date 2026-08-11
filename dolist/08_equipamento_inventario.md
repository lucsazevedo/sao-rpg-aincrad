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

## Decidido: item do online não tem efeito nenhum no online

Equipar uma arma/peça/carta/cristal no site **não muda nada mecanicamente
enquanto o personagem está no jogo online** — chance de sucesso ali é só
Nível de Profissão (ver `12_sistema_de_poder.md`, que por isso descartou
"Poder por equipamento"). O inventário/equipado serve pra **duas coisas**:
mostrar o que o jogador tem/coleciona, e ser o que ele **leva pra mesa de
RPG de verdade** — lá sim o item vale mecanicamente, com as regras normais
de equipamento (`docs/oficios_andar1.md`, `armas/00_catalogo_expandido.md`).
Isso simplifica bastante o "equipar" do site: é inventário/vitrine, não
um sistema de stats a calcular em tempo real.

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

## ✅ Resolvido (10/08) — `Equipamentos.vue` reescrito, testado contra o banco real

Reescrito seguindo a UI decidida acima (paper doll de 10 slots + grade de
mochila com busca/filtro). Contra o schema real, não o imaginado:

- **Arma** mora em `personagens.arma` (mesmo campo já usado desde a
  criação do personagem) — não em `inventario`.
- Os outros 9 slots usam as colunas que já existiam em `inventario`
  (`equipado` bool + `slot` text) em vez de uma tabela `equipado` separada
  — equipar troca o item marcado naquele slot, sem duplicar estado.
- `inventario.tipo` tem CHECK constraint no banco com só 8 valores
  (`arma, equipamento, consumivel, material, carta, cristal, ovo, pet`) —
  nem o rascunho antigo nem a minha primeira tentativa usavam esses
  valores certos (tinha `armadura`/`ferramenta`/`comida`/`pocao`/`ouro`/
  `incubadora`, nenhum deles existe). Corrigido também em `Mestre.vue`
  (aba Inventários).
- Testado de ponta a ponta contra o banco de verdade simulando a sessão
  do jogador (RLS `dono_gerencia`): inserir item, equipar, trocar de arma,
  equipar por cima de um slot já ocupado (desequipa o anterior sozinho) —
  tudo com rollback, sem deixar lixo.
- **Não incluído**: a distinção Mochila vs. Stash/Baú geral que estava no
  rascunho antigo não existe no schema (não há coluna de local/stash em
  `inventario` — tudo que o personagem tem é só "inventário"). Se quiser
  esse Baú/Stash separado de verdade, precisa de uma coluna nova
  (`local text default 'mochila'`) e atualizar as RPCs que inserem drop de
  missão/craft pra decidir onde cai — não fiz isso agora, ficou fora de
  escopo desta rodada.

## Achado numa varredura (10/08) — `Equipamentos.vue` existe mas não funciona

Já existe um rascunho (`scripts/app/src/views/Equipamentos.vue`, 3 abas:
Equipados/Inventário/Stash) que **diverge do que está decidido acima e não
roda contra o banco real**:

- Usa 14 slots inventados (cabeca/pescoco/ombros/.../r1/r2) em vez dos 10
  decididos aqui (Arma, Mão Secundária, Elmo/Capuz, Armadura/Capa, Luvas,
  Acessório 1, Acessório 2, Botas, Carta Equipada, Cristal Socket).
- Lê/escreve equipado numa tabela `equipamentos` com coluna `personagem_id`
  — essa tabela é só o **catálogo global** de equipamentos (sem essa
  coluna) e tem RLS mestre-only; jogador não consegue gravar nela de
  jeito nenhum. O lugar certo pra "equipado agora" é a própria
  `personagens.equipado` (jsonb, já existe na tabela).
- Filtra mochila vs. stash por um campo `local_item` que não existe em
  `inventario` (colunas reais: `id, personagem_nome, tipo, item_id, nome,
  quantidade, equipado, slot, cristal_id, origem, obtido_em, excluido`).
- `auth.personagem.id` também não existe (pk de `personagens` é `nome`).

Ou seja: nenhum botão dessa tela funciona hoje (equipar, desequipar, mandar
pro stash, tirar do stash) — falha silenciosa (só `console.warn`). Não é
um bug de uma linha; é a implementação de verdade deste item, ainda por
fazer seguindo o "UI decidida" acima. Próxima sessão que pegar isso:
comece migrando pra `personagens.equipado` (jsonb) + os 10 slots reais em
vez de tentar consertar o que já tem.

## Preciso saber

- **Decidido:** É 1 personagem por conta (1-a-1 com dono_id, unique no banco como já está no schema).
- **Decidido:** Inventário recebe craft e compra DIRETO quando esses módulos forem ligados. Tabela já foi desenhada pensando nos 3 fluxos (craft / compra / drop).
- **UI decidida por usabilidade:** layout 2 colunas: esquerda = PAPER DOLL (slots fixos: Arma, Mão Secundária, Elmo/Capuz, Armadura/Capa, Luvas, Acessório 1, Acessório 2, Botas, Carta Equipada, Cristal Socket) + direita = SACO DE INVENTÁRIO GRID 8×8 = 64 slots, com filtros por tipo/raridade/slot e busca de texto. Botão "Vender no Mercado" aparece no tooltip de cada item. Cada item stackável (materiais/munições/poções) ocupa 1 slot com contador de quantidade (cap 99 por slot).
