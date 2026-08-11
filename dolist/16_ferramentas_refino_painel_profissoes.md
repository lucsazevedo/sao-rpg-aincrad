---
titulo: Dolist 16 — Ferramentas obrigatórias + Refino (2 estágios) + Painel compacto de profissões
uso: mestre
---

# 16. Ferramentas obrigatórias + Refino + Painel compacto

> Inspirado na seção 2 do MD (Syrnia + Gates of Survival + Movoda).
> **Relacionado, mas NÃO é o mesmo que o item 14 do índice:** item 14 é
> **bônus de sucesso**, item 16 é **requisito duro obrigatório + 2 estágios
> de receita + UI melhor**.

## Tamanho estimado

**M-G** — 3 partes: (1) regras + schema; (2) UI painel profissões Gates of Survival-style; (3) refino nas receitas de `producao`.

---

## Parte 1 — Ferramenta como REQUISITO OBRIGATÓRIO

Hoje: tabela `ferramentas_oficio` + `personagem_ferramentas` existe, mas é só
"colecionável". **Não tem regra de bloqueio.**

**Novo comportamento proposto:**
Cada ação de ofício (ex: "Mineração: extrair minério", "Pesca: pescar") tem
**uma ferramenta associada OBRIGATÓRIA** — se o jogador não tem a ferramenta
no inventário OU em `personagem_ferramentas`, ele NÃO PODE clicar.

Exemplos:
- Picareta de Ferro → obrigatória para Mineração
- Vara de Pesca → obrigatória para Pesca
- Machado de Lenhador → obrigatório para Silvicultura
- etc. — 16 profissões → 16 ferramentas básicas + tier superior (picareta +1 etc.)

**Prioridade de check (ordem):**
1. Tem a ferramenta no inventário? (item tipo=ferramenta)
2. Ou tem a ferramenta em `personagem_ferramentas`? (se o mestre deu um item especial)
3. Nenhum → botão desabilitado: "❌ Você precisa de uma Picareta de Ferro."

**Integra item 14:** se tiver a ferramenta E a ferramenta tiver bônus (campo `bonus_sucesso` int ou float), soma no cálculo do 2d6 de sucesso.

---

## Parte 2 — Refino (2 estágios: Matéria-Prima → Intermediário → Final)

Hoje `producao` tem receita de 1 passo. **Adicionar flag `refino` boolean +
`estagio` int (1 ou 2):**

| Estágio | Exemplo | Entrada | Saída |
|---|---|---|---|
| 1 | Refino | 2 Minério de Cobre + 1 Carvão | 1 Barra de Bronze (item intermediário) |
| 2 | Fabricação | 2 Barras de Bronze + 1 Couro | 1 Espada Curta (item final) |

Regra: **receitas de estágio 1 NÃO PODEM produzir itens que já existem na tabela `armas`/`equipamentos`** (só "matérias-primas processadas / intermediários"). Receitas estágio 2 PODEM produzir armas/equipamentos.

A UI de produção mostra 2 abas: **"🧪 Refinar" (estágio 1)** e **⚒️ Fabricar (estágio 2)**.

---

## Parte 3 — Painel compacto de Profissões (Gates of Survival-style)

> "Dezenas de barras de nível lado a lado, sem poluir a tela."

Hoje o nível de profissão está espalhado — o jogador vê no inventário só a profissão PRINCIPAL dele. **Nova página `profissoes.html`:**
- 16 cards, um por profissão, em grid CSS 4×4.
- Cada card = `{Icone} · Nome · Nível X · [▓▓▓▓░░░░] 340/500 XP` (barra de progresso fina, estilo Gates of Survival)
- Clica no card → abre modal com (a) ações disponíveis da profissão; (b) receitas de refino/fabricação dela; (c) ferramenta obrigatória e se o jogador já tem.
- **Filtro rápido topo:** "Mostrar só as que eu já tenho nível ≥ 1" / "Mostrar todas".

---

## Integrações com outros itens do dolist

- **Item 14 (Ferramentas de ofício / bônus):** complementar, não concorrente. Item 14 = bônus; Item 16 = bloqueio obrigatório + refino + UI nova.
- **Item 6/11 (Mapa de ações diárias):** o painel de profissões é onde o jogador executa as 3 Ações de Ofício.
- **Item 5 (Nível de Profissão):** cada barra do painel usa os dados de `nivel_profissao` + curva `nivel_profissao_xp`.

## ⚠️ Avaliado (10/08), maior parte NÃO construída — dois bloqueios reais

- **Parte 1 (ferramenta obrigatória)**: mecanismo simples de fazer, mas só
  o Domador tem QUALQUER ferramenta cadastrada hoje (`ferramentas_oficio`
  tem 4 linhas, todas dele, criadas nesta sessão pro item 1). Tornar
  ferramenta obrigatória travaria craft de 15 profissões que não têm
  ferramenta nenhuma pra travar — precisa primeiro autorar um catálogo
  básico de ferramenta por profissão (conteúdo real, não mecanismo).
- **Parte 2 (refino 2 estágios)**: já existe e funciona — mas só pra
  `receitas.tipo='ferramenta'` (16 receitas, 1 por profissão, mesmo padrão
  da Incubadora do Domador). Pra equipamento/item comum (`tipo='item'`) o
  refino nunca foi usado — mesmo bloqueio de conteúdo da Parte 1.
- **Parte 3 (painel 4×4)**: achado que contraria isso — `Profissoes.vue`
  já tem um comentário explícito "NÃO TEM 'Todas as profissões' — regra do
  usuário" (decisão de sessão anterior: jogador só vê a própria profissão,
  não um catálogo das 16). Um painel de 16 barras lado a lado pro jogador
  contradiz essa regra já fechada — não construí sem confirmar se ela
  ainda vale. Se o painel for pro **mestre** (ver progresso de todos os
  jogadores nas 16 profissões, não o jogador vendo as 16), isso não
  contradiz nada e dá pra fazer — avisa se é essa a ideia.

## ✅ Fechado o que dava pra fechar sem inventar conteúdo (10/08)

- **Parte 1 (ferramenta obrigatória)**: mecanismo pronto —
  `receitas.requer_ferramenta_id` (opcional, nulo = sem trava, zero
  mudança de comportamento pras 128 receitas que ainda não têm
  ferramenta). `craftar_item`/`craftar_ferramenta` checam e bloqueiam
  quando setado. Testado com rollback (bloqueia sem a ferramenta, libera
  com ela). **Deixei desativado em produção** (nenhuma receita real com
  a trava ligada) — ativar pra valer é decisão de conteúdo seu, é só
  fazer um `update receitas set requer_ferramenta_id=...` pelo Compêndio
  do mestre.
- **Parte 3 (painel)**: construído do lado do **mestre**, não do jogador
  (não contraria a regra já decidida) — `Mestre.vue`, aba Mesa & Sessão,
  grid 4×4 das 16 profissões com quantos jogadores + nível máximo em cada.
- **Parte 2 (refino de item comum)** continua sem fazer — precisa de
  conteúdo intermediário pras 15 profissões sem ferramenta, mesmo
  bloqueio de sempre.

## ✅ Parte 2 fechada (10/08) — junto com o item 14

O bloqueio ("precisa de conteúdo pras 15 profissões") caiu junto com o
item 14: ao dar ferramenta própria pra cada profissão, o tier 2 de cada
uma **é** a cadeia de refino 2 estágios — estágio 1 (matéria-prima →
intermediário, ex: "Cabeça Balanceada" do Ferreiro) e estágio 2
(intermediário → ferramenta final, ex: "Martelo de Precisão"), exatamente
o padrão que a Incubadora Sagrada/Primordial do Domador já usava sozinha.
Item intermediário não ganhou tabela própria — fica só como
`nome_resultado` de uma receita com `receita_estagio=1`, sem entrar em
`equipamentos` (pergunta 3 do "Preciso saber" abaixo, resolvida assim: não
precisa de catálogo próprio, só existir como resultado de receita já
resolve pro caso de uso real).

## Preciso saber

1. **Ferramenta obrigatória = sim ou não?** MD propõe que sim (referência Syrnia). Queremos isso mesmo ou o jogador inicia sem ferramenta e mina "com a mão" mas com taxa de sucesso baixíssima (sucesso só em crítico)?
2. **Quantos estágios de refino** no máximo? MD propõe 2 (matéria → intermediário → final). OK? Ou mais?
3. **Item intermediário (Barra de Bronze, Tábua de Madeira etc.)** — entram em qual tabela? `equipamentos` (tipo=intermediário)? Ou nova tabela `materiais_processados` separada? Ou ficam SÓ como entrada/saída de `producao` sem existir no catálogo?
4. **UI das 16 profissões:** grid 4×4 na horizontal é ok, ou prefere uma lista vertical estilo "folha" que gaste menos largura (para quem joga no celular)?
