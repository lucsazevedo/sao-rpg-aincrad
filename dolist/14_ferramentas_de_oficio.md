---
titulo: Ferramentas de ofício (bônus de sucesso em craft)
tamanho: M
uso: mestre
---

# Ferramentas de ofício

## A ideia

Além do Nível de Profissão (item 5, progresso geral do ofício), cada
profissão pode ter uma **ferramenta própria** que sobe de nível separado e
melhora a chance de sucesso numa ação específica daquele ofício. Nasceu do
Domador (ver `01_domador_criador.md`): a **Incubadora** tem nível próprio,
e quanto maior o nível dela, maior a chance do ovo chocar.

## Por que é separado de Nível de Profissão

Nível de Profissão é geral (mede progresso do ofício inteiro, e agora
também alimenta a chance de sucesso em missão/combate — ver
`12_sistema_de_poder.md`). Ferramenta é um **multiplicador local**: presa
a uma ação específica do ofício (chocar ovo, forjar item raro, destilar
poção instável), upada separado, sem depender de subir Nível de Profissão
inteiro pra melhorar só aquela ação.

## O que precisa

- Schema: ferramenta como item próprio do personagem (tabela nova ou
  coluna em `personagens.estado`), com nível/tier.
- Por profissão, decidir: qual ação a ferramenta dela afeta, como ela sobe
  de nível (craft, compra, Marco), quantos degraus tem.
- Fórmula de bônus: ferramenta nível N soma quanto de chance/redução de
  risco na ação que ela cobre.

## ✅ Fechado (10/08) — as outras 15 profissões ganharam ferramenta própria

Respondendo direto: **todas as 16 desde já** (não só Domador). Cada uma
das 15 profissões que não tinham nada ganhou 2 tiers de ferramenta —
tier 1 simples (+1 no teste, craft de 1 estágio) e tier 2 com a cadeia de
refino 2 estágios do item 16 (+2 no teste). Cada ofício crafta a própria
ferramenta (não tem ferramenta cruzada tipo "Ferreiro crafta pro
Domador" — mais simples de administrar, e bate com como craftar_item/
craftar_ferramenta já funcionam). Ferramenta é item único por personagem
(upa a mesma peça, registra em `personagem_ferramentas` — não quebra por
uso, não tem reposição).

Script: `scripts/db/_importar_ferramentas_15_profissoes.py`. Testado via
HTTP real (Shen craftou "Martelo Comum" do Ferreiro, virou linha em
`personagem_ferramentas`) — dados de teste limpos depois.

## Preciso saber (histórico, já resolvido acima)

- Isso é uma feature de **todas as 16 profissões** desde já, ou começa só
  no Domador (Incubadora) e as outras ganham ferramenta própria depois,
  uma de cada vez conforme fizer sentido?
- Ferramenta é craftável por qualquer ofício relacionado (ex: Ferreiro
  crafta a Incubadora do Domador), ou cada ofício craft a própria
  ferramenta?

## ✅ Fechado (11/08) — ferramenta obrigatória em toda receita de item, e gasta de verdade

Pedido do usuário: "todas [as profissões] precisam de ferramentas que são
gastos no craft". Respondendo a pergunta em aberto acima ("item único ou
consumível que quebra"): ficou **híbrido** — a ferramenta é um item
duradouro (upa de tier, craftada uma vez via `craftar_ferramenta`), mas tem
uma chance real de ser **destruída** quando o craft de item "danifica" ela
(`ferramenta_danificada`, já existia como flag desde antes mas nunca fazia
nada — 8% em sucesso parcial, 20% em falha). Quando destrói, some de
`personagem_ferramentas` e o jogador precisa craftar de novo, gastando
material de novo — é o "gasto no craft" pedido, sem transformar ferramenta
em item de uso único (o que mataria o sentido de ter tier/refino).

Todas as 205 receitas tipo=item (16 profissões) agora têm
`requer_ferramenta_id` apontando pro tier de ferramenta correspondente ao
próprio nível da receita — sem a ferramenta certa craftada, `craftar_item`
recusa antes de gastar fôlego/material. Achado no caminho: 60 das 90
receitas de ferramenta das 15 profissões não-Domador (n2/n3_est1/n5/n5_ref)
nunca tinham virado linha real em `ferramentas_oficio` — craftar essas
"tiers" produzia ferramenta fantasma, sem bônus nenhum. Corrigido (bônus
novo: n1=1, n2=1, n3_est1=1 transitório, n3_est2=2, n5=3 transitório,
n5_ref=4).

Schema: `scripts/db/schema_ferramentas_tiers_completos.sql` +
`scripts/db/schema_receitas_requer_ferramenta.sql` +
`scripts/db/schema_profissoes_ferramenta_obrigatoria_e_drop_unico.sql`.
