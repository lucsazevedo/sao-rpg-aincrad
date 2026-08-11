---
titulo: Itens e receitas de craft novas
tamanho: P–M
uso: mestre
---

# Itens/crafts novos

## A ideia

Você mencionou já ter uma série de itens e receitas de craft pensados —
ainda não sei o volume nem o formato (lista solta, imagem, rascunho em
outro lugar).

## Por que o tamanho está em aberto

O caminho pra integrar já existe e é barato de rodar por item: ficha em
`.md` (seguindo `armas/_modelo_arma.md` ou `equipamentos/00_indice.md`) →
`gerar_dados_web.py` → `migrar_para_supabase.py`. O custo real depende só
de **quantos itens** e se já estão em formato perto do que o sistema espera
(nome, raridade, requisito, efeito, obter) ou se precisam ser escritos do
zero a partir de uma ideia solta.

## Preciso saber

- Onde está esse material? (Cola aqui, joga na pasta `dolist/`, ou descreve
  um por um?)
- É item de fato novo (arma/equipamento tipo já existente com efeito novo),
  ou introduz mecânica nova (tipo carta — ver item 7 — ou algo sem
  equivalente hoje)?

## ✅ Resolvido (10/08) — 9 catálogos do dolist importados (141 receitas + 75 catálogo novo)

O material era os 9 arquivos `dolist/*.txt` com emoji no nome (Comidas,
Munições, Acessórios, Cristais de SAO, Armaduras, Botas, Luvas, Elmos,
Poções e Consumíveis) — rascunhos prontos no formato Materiais/Ferramentas/
Produz/Efeito, já bem perto do que o schema espera.

**Duas famílias, mesmo padrão dos itens já existentes:**
- **Equipável** (Armaduras, Botas, Luvas, Elmos, Acessórios — 15 cada = 75
  itens): ganhou linha nova em `equipamentos` (slot já existia no schema:
  Armaduras/Botas/Elmos/Luvas/Acessórios) + `receitas` apontando pra ela via
  `resultado_item_id`. Craftado com sucesso, vai pro inventário como
  `tipo='equipamento'` — equipável no boneco de 10 slots do jogador
  ([Equipamentos.vue](../scripts/app/src/views/Equipamentos.vue)) sem
  nenhum ajuste extra, o `SLOT_PARA_KEY` de lá já cobria as 5 categorias.
- **Consumível** (Comidas 17, Poções 9, Munições 20, Cristais de SAO 20 —
  66 itens): só `receitas` nova, sem catálogo — mesmo padrão das 128
  receitas antigas (resultado direto no inventário como `consumivel`).

**Achado no caminho, corrigido**: `craftar_item` sempre gravava
`tipo='consumivel'` e `quantidade=1` fixo no inventário, não importava o
que a receita produzisse — certo pras 128 receitas antigas (nenhuma tinha
`resultado_item_id` nem produzia mais de 1), errado pras novas (armadura
precisa `tipo='equipamento'` pra ser equipável; munição produz 10x/5x, não
1x). Corrigido em
[schema_craft_equipamento_e_qtd.sql](../scripts/db/schema_craft_equipamento_e_qtd.sql)
— mesmo padrão de cascata (`armas`→`equipamentos`) que
`aceitar_e_resolver_missao` já usava pra drop de missão. Coluna nova
`receitas.resultado_qtd` (default 1, sem mudar as 128 receitas antigas).
Testado via HTTP real (login Shen): craft de "Vestimenta de Aventureiro"
foi sucesso_total, caiu no inventário como `equipamento`, confirmado no
catálogo (`GET /equipamentos?id=eq.armadura_vestimenta_de_aventureiro`).

**Decisões de mapeamento (nomes do rascunho não são as 16 profissões
oficiais — ver `docs/guia_sistema_aincrad.md`):**
- "Coureiro" e "Artesão" (nomes inventados no rascunho) → **Costureiro**
  (Técnica) — é quem já cobre roupa/tecido/couro no sistema oficial.
- "Cristalista/Alquimista" → **Alquimista** (Conhecimento).
- "Arqueiro/Flecheiro" (Munições) → **Caçador** (Reflexo) — tematicamente
  quem usa arco no cenário.
- Ferreiro, Joalheiro, Cozinheiro já eram nomes oficiais, sem mudança.

**Sabor elemental mantido** (Flecha Elemental, Cristal Elemental, Elixir
Elemental Supremo etc. escolhem Fogo/Gelo/Raio/Vento) — isso é texto de
efeito de item craftado pelo jogador, não é o sistema de fraqueza de
monstro que o item 13 tratou (aquele foi elemento→atributo especificamente
pra resistência de monstro). Não conflita com a decisão já fechada.

**Duplicidade resolvida sem perguntar**: `Poções e Consumíveis.txt` repetia
vários cristais que já estavam em `Cristais de SAO.txt` com nome idêntico
(Cristal de Cura, Purificação, Luz, Teleporte, Retorno, Visão, Calor,
Ressurreição...) — tratei `Cristais de SAO.txt` como fonte única pra esses
e importei de `Poções` só o que não duplicava (9 poções reais).

**Script reutilizável**:
[_importar_itens_dolist3.py](../scripts/db/_importar_itens_dolist3.py)
(idempotente via `ON CONFLICT DO UPDATE`, roda com `--commit` pra aplicar).

**O que ainda não foi feito**: nenhuma dessas 141 receitas tem
`requer_ferramenta_id` setado (mesmo bloqueio do item 16 — ativar ferramenta
obrigatória é decisão de conteúdo). Preço de venda (`equipamentos.preco`)
ficou null pros 75 itens novos — se quiser que apareçam à venda no Mercado
por padrão, é um `update equipamentos set preco=...` à parte.
