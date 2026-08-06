---
titulo: Chance de sucesso por Nível (Poder por equipamento removido)
tamanho: M
uso: mestre
---

# Chance de sucesso por Nível

## Decisão — Poder por equipamento SAI do jogo

A ideia original deste item (Poder = soma de pontos de cada equipamento,
travando risco) foi **descartada**. Motivo, direto da decisão do usuário:
equipamento no jogo online não carrega efeito mecânico nenhum (ver
`08_equipamento_inventario.md` — item craftado/dropado ali só vale nas
aventuras de mesa, não no site). Sem efeito de equipamento, não faz
sentido somar "pontos de Poder" por peça equipada — a trava inteira teria
que vir de outro lugar.

**Chance de sucesso contra monstro (matar, sobreviver a uma missão, etc.)
passa a ser definida só pelo Nível** — o mesmo Nível de Profissão que o
item 5 define (ver `05_niveis_e_xp.md`). Não existe mais uma segunda
variável ("Poder") competindo com o Nível pra decidir risco.

## O que continua da versão antiga

- **Nível trava acesso** (decisão já fechada em `06_jogo_online_diario.md`):
  abaixo do nível, a região/monstro nem aparece como opção.
- **Nível agora também define chance de sucesso** dentro do que já está
  acessível: quanto mais alto o Nível de Profissão em relação ao
  `nivelRecomendado` do monstro/missão, melhor a chance. Fica **uma única
  alavanca** fazendo os dois papéis (acesso e risco), não duas.
- **Falhar aciona o estado de Bug** (renomeado de "Desmaio" — ver
  `06_jogo_online_diario.md`), tempo travado escalando com quanto de "bug"
  o personagem acumulou.

## Fraqueza por atributo — continua valendo, agora ajusta o Nível efetivo

A parte de fraqueza por atributo de arma (ver `13_remover_elementos.md`)
não dependia de Poder de verdade — só usava "reduzir o déficit" como
metáfora. Sem Poder, o mesmo bônus vale direto sobre a chance de sucesso:
levar a arma cujo atributo bate com a fraqueza do monstro melhora a
chance, como um ajuste sobre o Nível efetivo pra aquela tentativa
específica. Continua incentivando trocar de arma pro monstro certo, só
que a régua agora é Nível, não Poder.

## O que precisa

- Fórmula: chance de sucesso como função de (Nível de Profissão do
  personagem − `nivelRecomendado` do monstro/missão), com ajuste positivo
  se a arma usada bate a fraqueza de atributo do monstro.
- Campo `nivelRecomendado` nos monstros/quests já existe — não precisa de
  `poder_recomendado` novo (era do sistema antigo).
- Campo `atributo_fraqueza` em `monstros` (um dos 5 atributos, separado do
  `elemento_fraqueza` de mesa) — mesma pendência já registrada em
  `13_remover_elementos.md`.
- **Não depende mais do item 8 (inventário) pra existir** — antes a ordem
  travava nisso porque Poder somava equipamento; Nível de Profissão já
  existe independente de inventário.

## Preciso saber

- Fórmula de chance por diferença de Nível: degrau fixo por ponto de
  diferença, ou curva (ex: cada nível abaixo soma X% de risco, com teto)?
- O bônus por acertar a fraqueza de atributo é fixo (ex: sempre soma X% de
  chance) ou escala com o Nível da arma/profissão usada?
- Tentar acima do que o Nível recomenda e **ter sucesso mesmo assim** — dá
  o drop cheio, ou um drop "raspando" (menor)? Isso muda se vale a pena
  arriscar de propósito ou só em desespero.
