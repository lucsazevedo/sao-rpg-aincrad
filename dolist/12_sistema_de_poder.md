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

## Fraqueza por atributo (não elemento) — bônus por escolha de arma

**Deliberadamente separado** do sistema elemental de mesa
(`docs/elementos_andar1.md` — Fogo/Trovão/Gelo/Veneno, regra de mesa, não
muda). No jogo online, a variável tática é **qual arma você leva**, não
qual elemento: cada uma das 23 armas já tem um atributo principal
(Corpo/Reflexo/Conhecimento/Espírito/Técnica — já documentado em
`docs/guia_sistema_aincrad.md`). Cada monstro ganha uma **fraqueza de
atributo** (campo novo, separado do `elemento_fraqueza` que já existe pra
mesa). Levar a arma certa pro monstro certo melhora a chance — incentiva
trocar de equipamento, não só acumular Poder bruto.

**Como mexe na fórmula de risco:** bater a fraqueza reduz o déficit efetivo
de Poder (ou soma um bônus fixo de chance — a decidir), então um jogador
com Poder abaixo do recomendado ainda pode ter uma tentativa segura se
escolher a arma certa.

## O que precisa

- Constante de poder por raridade (tabela acima).
- Campo `poder_recomendado` nos monstros/quests — extensão do
  `nivelRecomendado` que já existe.
- Campo novo `atributo_fraqueza` em `monstros` (um dos 5 atributos) —
  separado do `elemento_fraqueza` já existente, que continua sendo só de
  mesa.
- Cálculo de Poder total = soma do que está equipado — **depende do item 8
  (inventário/equipamento) existir primeiro**, é onde mora "o que está
  equipado agora" (inclusive qual arma).
- Fórmula de risco por déficit, com o ajuste de fraqueza — pode nascer
  simples e afinar depois.

## Preciso saber

- Concorda com a escala 10/25/60/150/400, ou quer outra proporção entre os
  degraus?
- Tentar acima do seu poder e **ter sucesso mesmo assim** — dá o drop
  cheio, ou um drop "raspando" (menor)? Isso muda se vale a pena arriscar
  de propósito ou só em desespero.
- O bônus por acertar a fraqueza de atributo é um número fixo (ex: sempre
  reduz X% do déficit) ou escala com algo (nível da arma, raridade)?
- O personagem troca de arma livremente antes de cada ação (escolhe a
  certa pro monstro certo), ou fica preso numa arma "equipada" por um
  tempo, tipo craft?
