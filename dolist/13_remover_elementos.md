---
titulo: Remover sistema elemental, trocar por fraqueza de atributo
tamanho: M
uso: mestre
---

# Remover elemento, virar tudo fraqueza de atributo

## Decisão

Fogo/Trovão/Gelo/Veneno sai do jogo inteiro (mesa e site). Fraqueza de
monstro passa a ser sempre um dos 5 atributos (Corpo/Reflexo/Conhecimento/
Espírito/Técnica) — a mesma variável que já define arma e teste em toda a
mesa. Detalhe da mecânica nova em `12_sistema_de_poder.md`; este item é só
**a limpeza do que já existe**.

## O que precisa mudar

- **`docs/elementos_andar1.md`** — hoje descreve o sistema elemental
  inteiro. Fica obsoleto; precisa virar aviso de descontinuado ou sair do
  RAG (`documentos`, já migrado lá).
- **~50 monstros do Andar 1** — cada um tem hoje `elemento_fraqueza`,
  `elemento_resistencia`, `vulnerabilidades` e `resistencias` com valor
  elemental (ex: "Trovão", "Gelo"). Precisa virar `atributo_fraqueza`
  monstro por monstro — é decisão de conteúdo (qual atributo faz sentido
  pra cada bicho), não só trocar o nome da coluna.
- **`docs/regras_nucleares_campanha.md`** e qualquer outro doc de mesa que
  cite elemento — passada de revisão.
- Ficha de monstro (`monstros/_modelo_monstro.md`) — tirar campo de
  elemento do molde pra quem for escrever monstro novo não usar mais.

## Preciso saber

- Reescrever os 50 monstros existentes é prioridade **antes** de eu
  desenhar o sistema de Poder/fraqueza de vez, ou dá pra desenhar o
  sistema novo primeiro e migrar o conteúdo depois, em paralelo?
- Pra decidir a fraqueza de atributo de cada monstro — tem alguma lógica
  que você já pensou (ex: bicho pesado/lento = fraco a Reflexo, bicho
  etéreo/mágico = fraco a Espírito), ou decido caso a caso conforme a
  ficha de cada um?
