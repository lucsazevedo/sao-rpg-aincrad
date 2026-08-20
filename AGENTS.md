# Instruções pra IA — SAO RPG (The Perfect Chaos)

> Espelha `.github/copilot-instructions.md` — se atualizar um, atualiza o
> outro. Convenção lida por várias IAs de código (Copilot, Cursor, Codex,
> Cline...), não só uma ferramenta específica.

Campanha de RPG de mesa (Sword Art Online, adaptado pra D&D 5e — d20,
atributos/proficiência/CA/PV padrão, ver `SAO_RPG_5e.md`; o sistema PBTA
original foi descontinuado, texto antigo só em `docs/guia_sistema_aincrad.md`
como histórico) **+** um site companion (Supabase + GitHub Pages) que a
mesa usa entre sessões. Leia isto antes de mexer em qualquer arquivo.

## As duas regras que mais importam

1. **`.env` nunca pode ser commitado.** Tem senha de banco e chave secreta
   do Supabase. Já está no `.gitignore` — não remova de lá, não crie outro
   arquivo de config com segredo em texto puro.
2. **O banco (Supabase) é a fonte de verdade do site, não o markdown.**
   `scripts/web/*.html` leem do banco, não mais de `dados_*.js` estático.
   Editar um `.md` de conteúdo **não** atualiza o site sozinho — isso só
   acontece rodando `scripts/migrar_para_supabase.py`, e esse script
   **sobrescreve** qualquer edição feita direto no banco (pelo
   `admin.html`) com o que estiver no `.md`. Se algo já foi editado pelo
   painel, edite pelo painel de novo — não pelo `.md` + re-rodar migração.
   Detalhe completo: `docs/pipeline.md` (aviso no topo do arquivo).

## Onde as coisas vivem

- **Regra do sistema de RPG**: `SAO_RPG_5e.md` (raiz do projeto) — fonte
  única de verdade da mecânica D&D 5e adaptada (atributos, perícias,
  armas/Sword Skills, profissões, PV/CA, condições, XP/nível, monstros).
  `docs/guia_sistema_aincrad.md` e `docs/regras_nucleares_campanha.md` são
  histórico do sistema PBTA descontinuado — não usar como regra vigente.
- **Conteúdo de campanha**: uma pasta por tipo — `npcs/`, `monstros/`,
  `armas/`, `equipamentos/`, `cenas/` (quests/crônicas), `cidades/`,
  `guias/` — um arquivo por item, com frontmatter YAML no topo. Cada pasta
  tem um `_modelo_*.md` de molde; siga o formato dele.
- **Banco de dados**: schema em `scripts/db/*.sql` (rode em ordem: `schema.sql` →
  `schema_papeis.sql` → `schema_views_seguras.sql` → `schema_rag.sql`).
  22+ tabelas espelhando o conteúdo estruturado, mais `documentos`/
  `documento_chunks` pra busca por significado (RAG, embeddings via Ollama
  local).
- **Site**: `scripts/web/` — `painel.html` é a porta de entrada,
  `compendio_andar1.html` é o compêndio de mesa, `admin.html` é o painel
  de edição (exige login de mestre), `personagens.html` são as fichas de
  jogador (login de jogador, cadastro livre).
- **Próxima fase, ainda não implementada**: pasta `dolist/` — um arquivo
  por ideia planejada, com esforço estimado e uma seção "Preciso saber"
  no fim. Antes de assumir que uma decisão de design está em aberto,
  confira lá — grande parte já foi decidida.

## Convenções

- Python: só stdlib, **exceto** `Pillow` (só em `gerar_mapa_infografico.py`)
  e `psycopg2` (só nos scripts que tocam o banco: `migrar_para_supabase.py`,
  `gerar_embeddings.py`, `servidor_rag.py`). Sem venv pro resto.
- Nomes de arquivo/variável em português, `snake_case`.
- Toda tabela de conteúdo no banco tem `visivel` (mestre liga/desliga —
  RLS de verdade, não é cosmético) e `excluido` (exclusão lógica — nunca
  vira `DELETE` de verdade).
- Segredo de mestre (campo `mestre`, `notas`, `verdade`) só existe em
  colunas separadas da tabela base, nunca junto com o resto — ver o padrão
  de view + `is_mestre()` em `scripts/db/schema_views_seguras.sql` antes
  de adicionar um campo secreto novo em qualquer tabela.

## Se for mexer no site

- `scripts/web/modo_mestre.js` tem o cliente Supabase, login/sessão, e o
  carregamento de dados — reaproveite `carregarLista()`, `estaLogado()`,
  `is_mestre()`/`pode_ver()` (lado banco) em vez de duplicar lógica de
  auth.
- `scripts/web/admin_schema.js` descreve os campos de cada tabela pro
  painel de edição — se criar coluna nova no banco, atualize aqui também,
  senão o painel não mostra o campo.

## Se não tiver certeza de uma decisão de design

Provavelmente já foi decidida em conversa anterior — confira
`dolist/00_indice.md` e os arquivos individuais antes de assumir ou
inventar uma regra nova.
