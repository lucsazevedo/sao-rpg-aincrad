---
titulo: Sistema de Poder (pontos por equipamento)
tamanho: M
uso: mestre
---

# Sistema de Poder

## A ideia

Cada equipamento vale ponto de Poder. Soma de tudo que está equipado = Poder
total do personagem, um número só, visível na ficha. Missão/monstro tem um
**poder recomendado** — abaixo disso ainda dá pra tentar, só que arrisca
Desmaio se falhar. Mesma tensão do roubo do TheCrims (dá pra tentar acima
da sua chance segura, mas paga caro se der errado), só que "poder de
equipamento" em vez de "perícia de ladrão".

## Duas travas diferentes, dois papéis diferentes

- **Nível** (item 5): trava de **acesso** — abaixo do nível, a região/monstro
  nem aparece como opção. Decisão já fechada em `06_jogo_online_diario.md`.
- **Poder** (este item): trava de **risco** — o conteúdo já está acessível
  (você tem nível pra isso), mas se seu Poder está abaixo do recomendado,
  a chance de dar errado sobe, e errar aciona o **Desmaio** (tempo travado
  + 20% do Col na mão, já decidido no item 6).

Isso dá duas alavancas com sensação diferente: nível é "eu ainda não posso
nem tentar", poder é "eu posso tentar, mas é arriscado".

## Proposta de escala (ponto de partida, ajustável)

| Raridade | Poder |
|---|---|
| Comum | 10 |
| Incomum | 25 |
| Raro | 60 |
| Épico | 150 |
| Lendário | 400 |

Não-linear de propósito — ecoa a mesma filosofia de
`armas/00_catalogo_expandido.md` ("a facilidade de obter define o teto"):
item raro vale desproporcionalmente mais, não só um pouco mais.

**Poder total** = soma de arma + cada peça de equipamento equipada + carta
(item 7, se tiver) + pet ativo (item 1, se tiver).

## Como o risco escala com o déficit

Proposta inicial (número exato é chute, ajusta depois de testar):
- Poder ≥ recomendado: chance normal.
- Poder < recomendado: cada faixa de déficit soma risco de falha, até um
  teto (nunca 100% de certeza de dar errado — sempre dá pra tentar a sorte).
- Falhar aciona Desmaio.

## O que precisa

- Constante de poder por raridade (tabela acima).
- Campo `poder_recomendado` nos monstros/quests — extensão do
  `nivelRecomendado` que já existe.
- Cálculo de Poder total = soma do que está equipado — **depende do item 8
  (inventário/equipamento) existir primeiro**, é onde mora "o que está
  equipado agora".
- Fórmula de risco por déficit — pode nascer simples e afinar depois.

## Preciso saber

- Concorda com a escala 10/25/60/150/400, ou quer outra proporção entre os
  degraus?
- Tentar acima do seu poder e **ter sucesso mesmo assim** — dá o drop
  cheio, ou um drop "raspando" (menor)? Isso muda se vale a pena arriscar
  de propósito ou só em desespero.
