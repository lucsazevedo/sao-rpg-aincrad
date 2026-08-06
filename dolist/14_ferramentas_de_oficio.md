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

## Preciso saber

- Isso é uma feature de **todas as 16 profissões** desde já, ou começa só
  no Domador (Incubadora) e as outras ganham ferramenta própria depois,
  uma de cada vez conforme fizer sentido?
- Ferramenta é craftável por qualquer ofício relacionado (ex: Ferreiro
  crafta a Incubadora do Domador), ou cada ofício craft a própria
  ferramenta?
- Ferramenta é item único por personagem (upa a mesma peça) ou consumível
  que precisa reposição em algum nível (ex: quebra depois de X usos)?
