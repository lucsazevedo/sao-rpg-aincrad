-- Quarta migração: RAG. Documentos livres (markdown restante) + pedaços
-- com embedding, buscáveis por similaridade. Roda depois de schema.sql,
-- schema_papeis.sql e schema_views_seguras.sql (usa is_mestre()/pode_ver()).

create extension if not exists vector;

create table if not exists documentos (
  id text primary key,
  caminho text not null,
  titulo text,
  categoria text not null,                -- campanha | regras | receitas | guia | dev
  publico boolean not null default true,
  corpo text not null,
  visivel boolean not null default true,
  excluido boolean not null default false,
  updated_at timestamptz not null default now()
);

create table if not exists documento_chunks (
  id bigserial primary key,
  documento_id text not null references documentos(id) on delete cascade,
  ordem int not null,
  titulo_secao text,
  conteudo text not null,
  embedding vector(768),
  created_at timestamptz not null default now()
);

create index if not exists documento_chunks_embedding_idx
  on documento_chunks using ivfflat (embedding vector_cosine_ops);

alter table documentos enable row level security;
drop policy if exists "select_publico_ou_mestre" on documentos;
create policy "select_publico_ou_mestre" on documentos for select
  using ((visivel = true and excluido = false and publico = true)
         or is_mestre() or pode_ver('documentos', id::text));
drop policy if exists "escrita_mestre" on documentos;
create policy "escrita_mestre" on documentos for all
  using (is_mestre()) with check (is_mestre());

-- chunks nao sao consultados direto pelo REST -- so pela funcao
-- buscar_contexto() (security definer) ou pelo mestre editando.
alter table documento_chunks enable row level security;
drop policy if exists "so_mestre" on documento_chunks;
create policy "so_mestre" on documento_chunks for all
  using (is_mestre()) with check (is_mestre());

-- busca por similaridade, respeitando a mesma regra de visibilidade que
-- as outras 22 tabelas já usam.
create or replace function buscar_contexto(
  p_embedding vector(768),
  p_k int default 5,
  p_categoria text default null
)
returns table(
  documento_id text, titulo text, caminho text, categoria text,
  titulo_secao text, conteudo text, similaridade float
)
language sql stable security definer set search_path = public as $$
  select d.id, d.titulo, d.caminho, d.categoria, c.titulo_secao, c.conteudo,
         1 - (c.embedding <=> p_embedding) as similaridade
  from documento_chunks c
  join documentos d on d.id = c.documento_id
  where (d.visivel = true and d.excluido = false)
    and (d.publico = true or is_mestre() or pode_ver('documentos', d.id::text))
    and (p_categoria is null or d.categoria = p_categoria)
  order by c.embedding <=> p_embedding
  limit p_k;
$$;
