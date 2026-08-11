---
titulo: Dolist 17 — Combate assíncrono free-roam (chance % + Vida + derrota → Estalagem)
uso: mestre
---

# 17. Combate assíncrono free-roam

> Inspirado na seção 3 do MD (MonsterGame + KnightFight + Lyrania).
> **DIFERENTE de missões de caça:** missões são "alvo de 5 Kobolds = recompensa
> extra ao final", esse item é o "atalho direto" — jogador caça monstros
> diretamente do quadro, sem missão atrelada, ganha XP e drops imediatamente
> por clique, exatamente como idle RPG.

## Tamanho estimado

**G** — tem schema novo (vida, bar de monstros), RPC de combate com RNG, UI nova, integração inventário/drops.

## O que já existe e é reaproveitado

- Tabela `monstros` (54 linhas já migradas) — cada monstro já tem `nivel_recomendado`, `ameaca`, `drops` jsonb
- Tabela `nivel_profissao` + `nivel_profissao_xp` (curva de 2 a 10)
- `inventario` (onde os drops caem)
- `transacoes` (log de Col ganho)
- **NÃO TEM:** `vida`/`vida_max` em `personagens` — coluna nova a adicionar.

---

## A — Mecânica: Chance % no servidor

MD propõe: "1 a 100, se random ≤ chance → vitória". **Nós temos PBTA, então VAMOS MISTURAR:**
- O valor de "Chance %" exibido pro jogador é **um número de 0 a 100, derivado da fórmula abaixo** — ele só vê isso, não vê os números PBTA.
- **No servidor, a rolagem ainda é 2d6 (PBTA):**
  - 2-6 = Falha (derrota)
  - 7-9 = Sucesso Parcial (vitória com custo — ex: -2 vida extra, ou só metade do drop)
  - 10+ = Sucesso Total (vitória limpa)
- A "chance %" mostrada é **probabilidade estimada** (por exemplo, Nível jogador 5 vs monstro 5 = 65% de vitória, 20% sucesso parcial, 15% falha).

**Fórmula da chance (base):**
```
dif = nivel_profissao_combate_jogador - nivel_monstro (nivel_recomendado extraído como int)
chance_vitoria = 50 + (dif * 7)          // 7% por nível de diferença
chance_parcial = 25 - max(0, dif * 2)   // sucesso parcial diminui quanto mais forte você é
chance = min(95, max(5, chance_vitoria + chance_parcial * 0.7))
```
Os números exatos o mestre pode editar depois em `sistema.campo combate_chance_params JSON`.

---

## B — Vida (colunas NUEVAS em personagens)

```sql
alter table personagens add column vida_max int not null default 50;
alter table personagens add column vida_atual int not null default 50;
```
- Vida máxima cresce com **nível de profissão de combatente ou cristal de vida/equipamento?** → pendente em "Preciso saber" (hoje dizemos que equipamento não tem efeito mecânico online, talvez vida_max só cresça com nível).
- Derrota = `-X vida`, **se vida cair a 0 → jogador vai pra Estalagem automaticamente** e:
  1. Não pode fazer NENHUMA ação de combate/craft/missão por 1 hora real (timer). Ou
  2. Tem que pagar a Estalagem pra "curar tudo AGORA" (integra item 15) = 10 Col.
- Vida se recupera **passivamente +1 a cada 10 min** (mais rápido que Fôlego). Ou: só cura cheia automaticamente na estalagem. → **Pendente**.

---

## C — Fluxo de clique (exemplo)

**Antes do clique:**
```
[⚔️ Aventureiro Nv 5] vs [🦎 Lagarto da Floresta Nv 4]
🎯 Chance de Vitória: 72% (mista = sucesso total + parcial)
💰 Gastar: -2 Fôlego
[ Botão dourado: ⚔️ Atacar ]
```

**Após clique — 3 resultados possíveis:**
1. **✅ Sucesso Total (10+ no 2d6):** "Você derrotou o Lagarto em 1 golpe! +40 XP, +8 Col, dropou: Couro Verde."
2. **⚠️ Sucesso Parcial (7-9):** "Você venceu, mas tomou uma patada. +30 XP, +5 Col, -3 Vida, dropou: Couro Verde."
3. **❌ Falha (≤6):** "Você perdeu pro Lagarto! -10 Vida, voltou pra estalagem. Nenhum ganho."
- Em QUALQUER resultado: consome 2 Fôlego.

---

## D — UI: página `combate.html`

3 abas:
1. **🗺️ Por Bioma:** agrupa monstros por `zona`/`regioes` da tabela `monstros`; jogador clica numa zona → vê lista.
2. **📋 Todos os Monstros (filtros):** Busca, tipo (humanoide/besta/inseto/máquina etc.), raridade, nível mínimo/máximo.
3. **🏆 Meu último combate:** relatório do último resultado + 5 logs históricos.

Card de monstro:
- Faixa de raridade/nível (cor de acordo com ameaça)
- Nome, Nível recomendado, 🎯 Chance %, 💨 -X Fôlego
- Botão Atacar + "simular 1 clique a mais" sem gastar? → opcional

---

## Integração com outros itens

- **Item 06 (Jogo Online Diário):** combate free-roam é uma das 3 ações (junto com missões + crafting).
- **Item 07 (Drops estilo MMO):** Drops caem direto no inventário, com raridade. `drops` jsonb na tabela monstros já tem o formato (só precisa garantir consistência).
- **Item 15 (Estalagem):** Quando vida cai a 0, jogador é redirecionado automaticamente para estalagem.html com banner "Você foi derrotado! Pague 10 Col ou aguarde 1h".
- **Item 09 (Mercado):** Equivalência — jogador pode gastar Col com estalagem → mais fôlego + vida → mais combates → mais drops → mais Col no mercado. Fecha o ciclo.

## ✅ Resolvido (10/08) — construído e testado, decisões registradas

Usuário pediu "faça tudo, revisa depois" — decidi sem bloquear, tudo
revisável/ajustável depois:

1. **Ambos** (opção default do próprio arquivo): Fôlego sempre gasto,
   Vida só cai em parcial/falha.
2. **Vida máxima = 50 + (melhor Nível de Profissão − 1) × 5** — simplifiquei
   pra fórmula única em vez da curva de exemplo (que não fechava um
   padrão). Recalcula sozinho via trigger quando o nível sobe.
3. **Sem regeneração passiva** — achado: Fôlego (que a doc do item 9
   também descreve como "regenera +1/30min") **não tem nenhum mecanismo
   de regen implementado em lugar nenhum do banco**, só RPC de comprar
   com Col. Não inventei regen pra Vida sozinho quando nem Fôlego tem de
   verdade — os dois curam via Estalagem (10 Col, `curar_estalagem()`,
   estende o RPC que já existia do item 15). **Regen por tempo real
   continua pendência de verdade**, não decisão escondida.
4. **Mantido PBTA ternário** (10+/7-9/6-), não fui pro binário do MD —
   consistência com `aceitar_e_resolver_missao`/`craftar_item`, que já
   usam esse padrão em produção.
5. **Custo de Fôlego variável**: `max(1, ceil(nível do monstro / 3))`.

**Construído e testado com rollback** (`scripts/db/schema_combate_assincrono.sql`):
colunas `vida_max`/`vida_atual` em `personagens`, `combate_log`,
`combater_monstro()` (RPC atômica: fôlego, rolagem PBTA real com o mesmo
staircase de mod das outras RPCs, XP/Col/drop de `monstros.drops` —
já reaproveita o formato existente), `chance_combate_preview()` (fórmula
exata do dolist original, só pra mostrar % antes do clique),
`curar_estalagem()`. UI: `Combate.vue` (nova, rota `/combate`) — barra de
vida/fôlego, busca/filtro por ameaça, atacar, últimos 5 combates.

Achados de schema no caminho: `transacoes.tipo` não tinha 'combate'/
'estalagem' no CHECK (estendido); `monstros.drops->>'chance'` é texto
livre ("70%", "100% (Last Attack)", às vezes sem número nenhum) — parse
por regex com fallback 30%, não um cast direto.

**Não fiz** as 3 abas completas descritas no dolist original (por bioma /
todos com filtros avançados / relatório rico) — UI atual é uma lista só
com busca+filtro simples. Funcional, não é a versão polida da spec.
