---
titulo: Biomas e monstros até o Andar 50
tamanho: P (roster) / GG (ficha completa)
uso: mestre
---

# Biomas/monstros até o Andar 50

## O que já existe

As imagens em `dolist/` (10 arquivos `ChatGPT_Image_*`) parecem ser páginas
de um "Bestiário de Aincrad" — a que eu abri é a "Página 01", andares 1-5,
com bioma, 4-5 comuns, mini boss (+ drops), MVP (+ drops) e boss (+ drops)
por andar. Se as outras 9 seguem o mesmo padrão (5 andares por página), isso
cobre o roster inteiro até o andar 50.

## Por que o tamanho depende inteiramente do que você quer

- **Só extrair o roster** (nome de cada bicho, categoria, drops, num
  arquivo/planilha por andar) — isso é **pequeno**, é transcrição.
- **Virar ficha jogável de verdade** (o que o Andar 1 tem hoje: aparência,
  comportamento, fraqueza, golpes-pra-derrotar, tabela de drop completa,
  imagem gerada) pros ~45 monstros por faixa de 5 andares × 10 faixas — isso
  **não é um item de dolist, é o projeto dos próximos andares inteiro**.
  `docs/pipeline.md` documenta que só o Andar 1 levou "várias rodadas" pra
  chegar no volume que tem hoje (45 monstros, 50 NPCs, 60+ quests).

## ✅ Resolvido (10/08) — roster extraído e importado (escopo P, como decidido)

Achado no caminho: as imagens nunca precisaram ser lidas de novo —
`dolist/🐉 Bestiário de Aincrad.txt` já era a transcrição completa dos 50
andares (feita numa sessão anterior), só nunca tinha virado dado
estruturado. Parseado e importado pra tabela nova `bestiario_roster`
(`scripts/db/schema_bestiario_roster.sql` + `scripts/db/_importar_bestiario.py`,
reaproveitável se o `.txt` mudar): **500 monstros, 50 andares, 4
categorias** (comum/mini_boss/mvp/boss — 350/50/50/50). Fica separado de
`monstros` de propósito — é roster, não ficha jogável completa (a
diferença que este arquivo já explicava). Também alimentou direto o item 7
(cartas/cristais) — ver `07_drops_e_cartas.md`.

Vira ficha jogável de verdade (o trabalho de vários meses que este arquivo
já avisava) continua em aberto — não é algo que "faça tudo" cobre numa
tarde.
