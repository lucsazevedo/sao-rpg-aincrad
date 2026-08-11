---
titulo: Dolist 15 — Estalagem (recuperar Fôlego gastando Col)
uso: mestre
---

# 15. Estalagem: recuperar Fôlego gastando Col

> Inspirado na seção 1 do MD de referência ("Menu de Descanso"). O sistema
> já tem **Fôlego** recuperação passiva de +1 a cada 30min (cheio em 6h).
> Esse item é o **atalho pago**: gastar moedas pra não esperar.

## Tamanho estimado

**P** — muito pequeno, é só uma tela com 2-3 botões + 1 RPC.

## O que já existe e é reaproveitado

- `personagens.folego` int (teto 20) + `personagens.col_mao`/`col_guardado`
- RPC `salvar_estado_online()` já permite whitelist de colunas online (só fôlego não está lá hj — precisamos decidir se a recuperação é RPC atômico separado, ou por lá)
- UI: pode ser uma página separada `estalagem.html` ou uma aba dentro de `missoes_diarias.html`

## Desenho sugerido

**3 opções, preço fixo por ponto de Fôlego crescente (pra não abusar):**
1. ⚡ +1 Fôlego = 5 Col (preço barato — recuperou 1 de 30min de espera agora)
2. ⚡⚡ +5 Fôlego = 30 Col (pacote médio)
3. 🔥 Encher TUDO (20/20) = 150 Col (equivalente a 6h de espera)
- Preços são **sugestão**; valores reais o mestre decide e podem ser campos editáveis no admin `sistema` (uma tupla nova `estalagem_precos` como JSON ou colunas)
- Regra dura: **não vende Fôlego negativo (vazio) com juros**, só vende para encher/parcial. Ou seja, o jogador tem 3/20 e clica +5, chega em 8/20 e paga 30 Col. Se ele tem 19/20 e clica em +5, só dá +1 e paga preço proporcional? Ou proíbe? → **Pendente, no "Preciso saber"**

**UI da Estalagem:**
- 3 cards com ícones (mesma estética do inventário.html: fundo painel, borda dourada, botão dourado primário)
- Abaixo, linha informativa: "⏱️ Passivamente você recupera +1 Fôlego a cada 30 minutos. Cheio às [HH:MM]."
- Mensagem de sucesso tipo: "+5 Fôlego! Agora você tem 13/20."
- Se saldo insuficiente: "Saldo insuficiente — precisa ter 30 Col na mão."

## Bancos / RPCs

- Função atômica `comprar_folego(p_qtd int) returns text` com SECURITY DEFINER:
  - valida 1<=p_qtd<=20
  - calcula preço via tabela de preço (se colunas em sistema) ou hardcoded
  - valida `col_mao >= preco`
  - update `personagens` set `col_mao = col_mao - preco, folego = LEAST(folego + p_qtd, 20)`
  - log em `transacoes` tipo_check='outros' (ou adicionar enum 'estalagem' no tipo_check)
- **Não precisa de whitelist em salvar_estado_online(), porque é transação atômica isolada.**

## Dependências

- Nenhuma forte — pode fazer antes ou depois de missões_diarias.html. Fica melhor com missões_diarias pra jogador ter pra que gastar o fôlego recém comprado.

## Preciso saber

1. **Preço base:** quanto vale +1 Fôlego em Col? As 3 opções (5, 30, 150) o mestre acha ok ou quer outro valor?
2. **Preço proporcional ou bloqueio?** Jogador com 19/20 clica no pacote +5 → cobra só 5 Col pelo +1, ou bloqueia o botão dizendo "você não precisa de todo esse pacote"?
3. **Teto diário de compras?** Ex.: "só pode encher completo 1 vez por dia" para evitar jogador muito rico ficar infinitamente grindando (controle extra além de Fôlego como régua). Ou sem limite?
4. **Página separada (`estalagem.html`) ou aba dentro de `missoes_diarias.html`/`inventario.html`?**
