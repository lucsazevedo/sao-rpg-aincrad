---
titulo: Dolist 18 — Cooperação 30 jogadores (Baú de clã, Envios P2P, Metas globais do mestre)
uso: mestre
---

# 18. Cooperação 30 jogadores

> Inspirado na seção 4 do MD (Torn + KingsAge). Hoje temos 0 interação entre
> jogadores online — cada um tem seu inventário e vende na vitrine, mas não
> colabora. Esse item é toda a camada social assíncrona do online.

## Tamanho estimado

**GG** — é grande, dividido em 3 sub-módulos. Dá pra fazer um de cada vez, sem depender dos outros.

---

## Sub-módulo 18A — Envios P2P (jogador → jogador)

**O que é:** "mandar um item/col diretamente para outro jogador" (igual sistema de correio interno de Torn ou qualquer MMO).

**Funções RPC atômicas:**
1. **`enviar_col(p_destinatario text, p_valor int) returns text`:**
   - valida p_valor > 0
   - valida remetente tem `col_mao >= p_valor`
   - valida destinatário existe (é personagem válido, com dono_id)
   - tira `col_mao` remetente + adiciona `col_mao` destinatário
   - log em `transacoes` (tipo_check = 'transferencia')
   - retorna "✅ Enviado X Col para Nome"
2. **`enviar_item(p_destinatario text, p_inventario_id bigint, p_qtd int) returns text`:**
   - valida dono do item (remetente)
   - valida item não equipado
   - valida `p_qtd >= 1` e (item stack = true → `qtd_original >= p_qtd`)
   - cria novo registro em inventario (personagem_nome = destinatário; origem='envio') com qtd
   - se stack, reduz qtd do original ou apaga
   - log em `transacoes` (tipo_check = 'envio_item')

**UI:** Página nova `correio.html` ou aba no `painel.html`:
- Formulário "Enviar para:" (campo de texto com autocomplete de nome de personagem)
- 2 abas: 💸 Enviar Col · 📦 Enviar Item
- Histórico de envios recebidos/enviados

---

## Sub-módulo 18B — Baú / Cofre do Clã (Torn-style)

Hoje `cla` é só texto/descrição/reputação. **Adicionar inventário de clã:**

### Tabelas novas
```sql
create table cla_inventario (
  id bigserial primary key,
  cla_nome text not null references cla(nome) on delete cascade,
  item_id text not null,              -- referencia equipamentos/armas/ferramentas id
  nome text not null,
  tipo text,
  raridade text,
  qtd int not null default 1,
  depositado_por text,                -- personagem_nome que depositou
  depositado_em timestamptz default now(),
  excluido boolean default false
);

create table cla_autoridade (
  id bigserial primary key,
  cla_nome text not null references cla(nome) on delete cascade,
  personagem_nome text not null references personagens(nome) on delete cascade,
  cargo text not null check (cargo in ('lider','oficial','membro')),
  unique(cla_nome, personagem_nome)
);
```

### Regras de permissão
- **Membro:** pode depositar qualquer coisa; só pode RETIRAR se o item tiver `liberado_para_membros = true` (flag) ou se for um oficial/lider que liberou.
- **Oficial:** pode retirar tudo, pode criar metas (18C), pode enviar itens para membros pelo correio do clã.
- **Líder:** tudo, inclusive promover/rebaixar oficiais e dissolver clã.

### UI
Página `cla.html` com 3 abas:
1. 👥 **Membros:** lista de personagens + cargo + nível de profissão principal + reputação
2. 🧰 **Baú:** grid igual inventário 8×8, mas é do clã. Botões: "Depositar do meu inventário", "Retirar pro meu inventário" (se autorizado).
3. 🎯 **Metas Globais** (abaixo, 18C)

---

## Sub-módulo 18C — Metas Globais do Mestre (KingsAge-style)

> "Mestre cria uma meta de entrega, todos os 30 jogadores colaboram depositando materiais, quando bate 100% → recompensa global."

### Tabela nova
```sql
create table metas_globais (
  id bigserial primary key,
  titulo text not null,
  descricao text,
  meta_item text not null,                 -- ex.: "Barra de Bronze"
  meta_qtd int not null,                   -- ex.: 100
  progresso int not null default 0,        -- contador atual
  recompensa_col int,
  recompensa_xp int,
  recompensa_item text,                    -- item especial só quem participou ganha 1
  recompensa_reputacao_cla_nome text,      -- se for cla, reputacao+
  recompensa_reputacao_valor int,
  criado_por uuid references auth.users(id), -- id do mestre
  criado_em timestamptz default now(),
  finalizada boolean default false,
  finalizada_em timestamptz,
  visivel boolean default true,
  excluido boolean default false
);

create table metas_doacoes (
  id bigserial primary key,
  meta_id bigint not null references metas_globais(id) on delete cascade,
  personagem_nome text not null references personagens(nome) on delete cascade,
  qtd_doada int not null,
  doado_em timestamptz default now()
);
```

### Fluxo
1. **Mestre cria meta** pelo admin.html: "Precisamos de 100 Barras de Bronze para a Fortaleza. Recompensa: 500 Col p/ quem doar +20 reputação no clã Guerreiros da Espada."
2. **Jogadores veem metas** em `metas.html` (ou aba no painel.html / cla.html):
   - Barra de progresso: `[██████░░░░] 62/100 (62%)`
   - Botão: "Doar do meu inventário" → modal: seleciona qtd de Barra de Bronze que você tem, confirma.
   - Doação deduz qtd do inventário do jogador → soma em `progresso` + log em `metas_doacoes`
3. **Quando progresso >= meta_qtd:**
   - meta.finalizada = true
   - RPC `premiar_meta(p_meta_id bigint)` roda: para CADA jogador que doou, dá a recompensa de Col/XP/item/reputação
   - Mensagem global no topo do site: "🎉 Meta 'Fortaleza da Espada' concluída! 32 jogadores colaboraram. Sua recompensa caiu!"

### UI
- Página `metas.html`: lista de metas ativas (em cima), finalizadas recentes (embaixo)
- Cada meta: barra, botão doar, lista dos 10 que mais doaram (ranking público + transparentão)
- **Notificação:** quando usuário loga e tem meta finalizada onde ele doou, aparece modal: "Você ganhou 500 Col!".

---

## Integração com outros itens

- **Item 10 (Reputação):** metas globais premia reputação; clãs têm reputação.
- **Item 16 (Refino):** metas globais recebem itens de refino (ex: 100 Barras de Bronze).
- **Item 6 (Mapa de ações diárias):** doar para meta global também pode gastar Fôlego? Ou é Fôlego-free como o mercado? → **Pendente, em "Preciso saber"**.

## ✅ Resolvido (10/08) — os 3 submódulos construídos e testados

Usuário pediu "faça tudo, revisa depois". Decisões (todas seguindo
precedente já fechado no item 9/mercado — zero taxa — em vez de inventar
regra nova):

1. **Sem taxa** em Col enviado — 100% chega, igual mercado.
2. **Sem taxa** de postagem de item.
3. **Clã continua opcional** — não criei obrigatoriedade nova;
   `personagens.guilda` já era nullable, mantive assim.
4. **Máximo 3 metas abertas** (sugestão do próprio arquivo), travado no
   RPC `criar_meta_global`.
5. **Doar não gasta Fôlego** — mesmo raciocínio do mercado (mover recurso
   já ganho, não é produção nova).
6. **Recompensa só pra quem doou** qualquer quantidade (não é "todo mundo
   logado").

**18A (correio)**: RPCs `enviar_col`/`enviar_item`, atômicas, log em
`transacoes`. **18B (baú de clã)**: `cla_inventario` + `cla_autoridade`
(cargo lider/oficial/membro), depositar sempre livre, retirar travado até
oficial/líder liberar item por item. **18C (metas globais)**:
`metas_globais` + `metas_doacoes`, `criar_meta_global` (mestre-only,
trava em 3), `doar_para_meta` (valida item pedido bate, credita
progresso), `premiar_meta` (roda sozinho ao bater 100%: Col, XP, item,
reputação — reaproveitando `_ajustar_reputacao_interna` do item 10, sem
duplicar lógica).

Tudo em `scripts/db/schema_cooperacao.sql`, testado com rollback: envio
P2P de Col e item, depósito/retirada travada/liberada no baú, meta criada
→ doada em duas parcelas → completa sozinha → premia quem doou. Achado no
caminho: `transacoes.tipo` não tinha 'transferencia'/'meta_global' no
CHECK (estendido, cumulativo com o que o item 17 já tinha adicionado);
`inventario` não tem coluna `raridade` (só os catálogos têm — corrigido
no `depositar_no_cla`).

UI: `Cooperacao.vue` (nova, rota `/cooperacao`) com as 3 abas — Correio,
Baú do Clã, Metas Globais (doar). Criar meta é ferramenta de mestre —
formulário dentro de `Mestre.vue`, aba Mesa & Sessão.

**Não fiz**: página dedicada `correio.html`/`cla.html`/`metas.html`
separadas como a spec original sugeria — uma view só (`Cooperacao.vue`)
com abas, mais simples de manter. Ranking de doadores e notificação de
meta concluída (mencionados na spec) também não entraram — dá pra
adicionar depois sem mudar schema.
