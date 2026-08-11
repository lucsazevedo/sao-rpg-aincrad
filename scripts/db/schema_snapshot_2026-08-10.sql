-- Snapshot completo do schema public — gerado automaticamente
-- (scripts/db/_gerar_snapshot_schema.py) em 2026-08-10.
-- Não é pra rodar como migração — é referência de "como o banco
-- está agora", já que os schema_*.sql incrementais desta sessão
-- não foram todos mesclados de volta no schema_jogo_online.sql
-- original. Pra recriar um banco do zero, ainda é mais seguro rodar
-- os schema_*.sql na ordem cronológica (ver docs/pendencias.md).

-- ========== EXTENSÕES ==========
create extension if not exists "pg_cron";
create extension if not exists "pg_stat_statements";
create extension if not exists "pgcrypto";
create extension if not exists "supabase_vault";
create extension if not exists "uuid-ossp";
create extension if not exists "vector";

-- ========== TABELAS ==========
create table if not exists "armas" (
  "id" text not null,
  "nome" text not null,
  "arquivo" text,
  "img" text,
  "tipo" text,
  "atributo" text,
  "raridade" text,
  "requisito" text,
  "preco" numeric,
  "preco_txt" text,
  "resumo" text,
  "efeito" text,
  "obter" text,
  "skills" _text,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null
);
create table if not exists "bestiario_roster" (
  "id" bigint default nextval('bestiario_roster_id_seq'::regclass) not null,
  "andar" integer not null,
  "bioma" text,
  "categoria" text not null,
  "nome" text not null,
  "emoji" text,
  "materiais" jsonb default '[]'::jsonb not null,
  "cristais" jsonb default '[]'::jsonb not null,
  "cartas" jsonb default '[]'::jsonb not null,
  "visivel" boolean default true not null,
  "excluido" boolean default false not null,
  "updated_at" timestamp with time zone default now() not null
);
create table if not exists "cartas" (
  "id" text not null,
  "nome" text not null,
  "raridade" text not null,
  "tipo_bonus" text not null,
  "valor_bonus" integer default 0 not null,
  "descricao" text,
  "drop_de" text,
  "chance_drop" numeric default 0 not null,
  "img" text,
  "visivel" boolean default true not null,
  "excluido" boolean default false not null,
  "updated_at" timestamp with time zone default now() not null
);
create table if not exists "cidades" (
  "id" text not null,
  "nome" text not null,
  "andar" text,
  "tipo_de_zona" text,
  "guildas_presentes" _text,
  "canonico" boolean default false,
  "fonte" text,
  "corpo" text,
  "arquivo" text,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null
);
create table if not exists "cla_autoridade" (
  "id" bigint default nextval('cla_autoridade_id_seq'::regclass) not null,
  "cla_nome" text not null,
  "personagem_nome" text not null,
  "cargo" text not null
);
create table if not exists "cla_inventario" (
  "id" bigint default nextval('cla_inventario_id_seq'::regclass) not null,
  "cla_nome" text not null,
  "item_id" text not null,
  "nome" text not null,
  "tipo" text,
  "raridade" text,
  "qtd" integer default 1 not null,
  "liberado_para_membros" boolean default false not null,
  "depositado_por" text,
  "depositado_em" timestamp with time zone default now() not null,
  "excluido" boolean default false not null
);
create table if not exists "clas" (
  "nome" text not null,
  "destaque" boolean default false,
  "forca" text,
  "necessidade" text,
  "rival" text,
  "rumor" text,
  "status" text,
  "resumo" text,
  "bons" text,
  "precisa" text,
  "nao_admitem" text,
  "proximo" text,
  "atravessado" text,
  "quests" text,
  "aparecem" text,
  "simbolo" text,
  "reputacao" jsonb,
  "ganchos" jsonb,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null
);
create table if not exists "combate_log" (
  "id" bigint default nextval('combate_log_id_seq'::regclass) not null,
  "personagem_nome" text not null,
  "monstro_id" text not null,
  "monstro_nome" text not null,
  "resultado" text not null,
  "dados" _int4 not null,
  "vida_perdida" integer default 0 not null,
  "xp_ganho" integer default 0 not null,
  "col_ganho" integer default 0 not null,
  "folego_gasto" integer default 0 not null,
  "drop_item_id" text,
  "drop_inventario_id" bigint,
  "criado_em" timestamp with time zone default now() not null
);
create table if not exists "compra_materiais" (
  "id" bigint default nextval('compra_materiais_id_seq'::regclass) not null,
  "material" text not null,
  "col" text,
  "quem" text,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null
);
create table if not exists "conteudo_liberado" (
  "id" bigint default nextval('conteudo_liberado_id_seq'::regclass) not null,
  "jogador_id" uuid not null,
  "tabela" text not null,
  "registro_id" text not null,
  "liberado_em" timestamp with time zone default now() not null
);
create table if not exists "craft_fila" (
  "id" bigint default nextval('craft_fila_id_seq'::regclass) not null,
  "personagem_nome" text not null,
  "profissao" text not null,
  "receita_id" text not null,
  "quantidade" integer default 1 not null,
  "iniciado_em" timestamp with time zone default now() not null,
  "pronto_em" timestamp with time zone not null,
  "status" text default 'fabricando'::text not null,
  "resultado" jsonb
);
create table if not exists "criaturas_domadas" (
  "id" bigint default nextval('criaturas_domadas_id_seq'::regclass) not null,
  "personagem_nome" text not null,
  "especie" text,
  "monstro_id" text,
  "nome_pet" text not null,
  "raridade" text default 'Comum'::text not null,
  "status" text default 'incubando'::text not null,
  "incubadora_nivel" integer default 1 not null,
  "efeitos" jsonb default '{}'::jsonb not null,
  "choca_em" timestamp with time zone,
  "nascido_em" timestamp with time zone,
  "obtido_em" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null
);
create table if not exists "cristais" (
  "id" text not null,
  "nome" text not null,
  "tipo_bonus" text not null,
  "valor_bonus" integer default 0 not null,
  "descricao" text,
  "drop_de" text,
  "img" text,
  "visivel" boolean default true not null,
  "excluido" boolean default false not null,
  "updated_at" timestamp with time zone default now() not null
);
create table if not exists "cronicas" (
  "id" text not null,
  "numero" integer,
  "ep_rotulo" text,
  "titulo" text not null,
  "arquivo" text,
  "tipo" text,
  "dificuldade" text,
  "regiao" text,
  "conexoes" text,
  "elenco" text,
  "resumo" text,
  "corpo" text,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null
);
create table if not exists "documento_chunks" (
  "id" bigint default nextval('documento_chunks_id_seq'::regclass) not null,
  "documento_id" text not null,
  "ordem" integer not null,
  "titulo_secao" text,
  "conteudo" text not null,
  "embedding" vector,
  "created_at" timestamp with time zone default now() not null
);
create table if not exists "documentos" (
  "id" text not null,
  "caminho" text not null,
  "titulo" text,
  "categoria" text not null,
  "publico" boolean default true not null,
  "corpo" text not null,
  "visivel" boolean default true not null,
  "excluido" boolean default false not null,
  "updated_at" timestamp with time zone default now() not null
);
create table if not exists "dungeons" (
  "id" text not null,
  "nome" text not null,
  "regiao" text,
  "nivel" text,
  "perfil" text,
  "nota" text,
  "setores" jsonb,
  "salas" jsonb,
  "ligacoes" jsonb,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null
);
create table if not exists "equipamentos" (
  "id" text not null,
  "nome" text not null,
  "img" text,
  "slot" text,
  "raridade" text,
  "conjunto" boolean default false,
  "arquivo" text,
  "requisito" text,
  "preco" numeric,
  "preco_txt" text,
  "resumo" text,
  "efeito" text,
  "obter" text,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null
);
create table if not exists "ferramentas_oficio" (
  "id" text not null,
  "profissao" text not null,
  "nome" text not null,
  "nivel_ferramenta" integer not null,
  "bonus_acao" integer default 0 not null,
  "descricao" text,
  "receita" jsonb,
  "acao_afetada" text,
  "como_sobe" text default 'craft via profissão'::text,
  "visivel" boolean default true not null,
  "excluido" boolean default false not null,
  "updated_at" timestamp with time zone default now() not null
);
create table if not exists "guias" (
  "id" text not null,
  "nome" text not null,
  "arquivo" text,
  "bioma" text,
  "nivel" text,
  "chegada" text,
  "leitura" text,
  "cena" text,
  "acoes" jsonb,
  "mestre" text,
  "demora" text,
  "evento" text,
  "locais" jsonb,
  "ligado" _text,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null
);
create table if not exists "inventario" (
  "id" bigint default nextval('inventario_id_seq'::regclass) not null,
  "personagem_nome" text not null,
  "tipo" text not null,
  "item_id" text not null,
  "nome" text not null,
  "quantidade" integer default 1 not null,
  "equipado" boolean default false not null,
  "slot" text,
  "cristal_id" text,
  "origem" text,
  "obtido_em" timestamp with time zone default now() not null,
  "excluido" boolean default false not null,
  "local" text default 'mochila'::text not null
);
create table if not exists "limit_breaker_contador" (
  "personagem_nome" text not null,
  "arma_tipo" text not null,
  "contador" integer default 0 not null,
  "updated_at" timestamp with time zone default now() not null
);
create table if not exists "materiais_basicos" (
  "id" text not null,
  "nome" text not null,
  "raridade" text not null,
  "nivel_obtencao" integer not null,
  "categoria" text not null,
  "peso_uso_esperado" integer default 4 not null,
  "descricao" text,
  "fonte" text,
  "visivel" boolean default true not null,
  "excluido" boolean default false not null,
  "updated_at" timestamp with time zone default now() not null
);
create table if not exists "mercado" (
  "id" text not null,
  "nome" text not null,
  "regiao" text,
  "descricao" text,
  "desconto" text,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null
);
create table if not exists "mercado_itens" (
  "id" bigint default nextval('mercado_itens_id_seq'::regclass) not null,
  "mercado_id" text not null,
  "item" text,
  "col" text,
  "obs" text
);
create table if not exists "mesa_combate" (
  "id" bigint default nextval('mesa_combate_id_seq'::regclass) not null,
  "monstro_id" text,
  "monstro_nome" text not null,
  "nivel_ameaca" text,
  "golpes_alvo" text,
  "golpes_atual" integer default 0 not null,
  "ativo" boolean default true not null,
  "criado_em" timestamp with time zone default now() not null
);
create table if not exists "mesa_raid_prep" (
  "categoria" text not null,
  "uso" text,
  "marcado" boolean default false not null,
  "updated_at" timestamp with time zone default now() not null
);
create table if not exists "mesa_relacoes" (
  "nome" text not null,
  "valor" integer default 0 not null,
  "nota" text,
  "updated_at" timestamp with time zone default now() not null
);
create table if not exists "mesa_relogios" (
  "id" text not null,
  "nome" text not null,
  "descricao" text,
  "valor" integer default 0 not null,
  "updated_at" timestamp with time zone default now() not null
);
create table if not exists "mesa_sessoes" (
  "id" bigint default nextval('mesa_sessoes_id_seq'::regclass) not null,
  "titulo" text,
  "trio" text,
  "fato" text,
  "rumor" text,
  "pressao" text,
  "criado_em" timestamp with time zone default now() not null
);
create table if not exists "metas_doacoes" (
  "id" bigint default nextval('metas_doacoes_id_seq'::regclass) not null,
  "meta_id" bigint not null,
  "personagem_nome" text not null,
  "qtd_doada" integer not null,
  "doado_em" timestamp with time zone default now() not null
);
create table if not exists "metas_globais" (
  "id" bigint default nextval('metas_globais_id_seq'::regclass) not null,
  "titulo" text not null,
  "descricao" text,
  "meta_item" text not null,
  "meta_qtd" integer not null,
  "progresso" integer default 0 not null,
  "recompensa_col" integer,
  "recompensa_xp" integer,
  "recompensa_item" text,
  "recompensa_reputacao_alvo_nome" text,
  "recompensa_reputacao_valor" integer,
  "criado_por" uuid,
  "criado_em" timestamp with time zone default now() not null,
  "finalizada" boolean default false not null,
  "finalizada_em" timestamp with time zone,
  "visivel" boolean default true not null,
  "excluido" boolean default false not null
);
create table if not exists "missao_diaria" (
  "id" bigint default nextval('missao_diaria_id_seq'::regclass) not null,
  "personagem_nome" text not null,
  "missao_id" text not null,
  "status" text default 'oferecida'::text not null,
  "oferecida_em" timestamp with time zone default now() not null,
  "aceita_em" timestamp with time zone,
  "concluida_em" timestamp with time zone,
  "resultado" jsonb
);
create table if not exists "missoes_quadro" (
  "id" text not null,
  "titulo" text not null,
  "tipo" text,
  "descricao" text,
  "custo_folego" integer default 5 not null,
  "nivel_min" integer default 1 not null,
  "requer_grupo" boolean default false not null,
  "recompensa_xp" integer default 40 not null,
  "recompensa_col_min" integer default 30 not null,
  "recompensa_col_max" integer default 80 not null,
  "drop_tabela" text,
  "visivel" boolean default true not null,
  "excluido" boolean default false not null,
  "updated_at" timestamp with time zone default now() not null,
  "regiao" text default 'Andar 1 - Início'::text,
  "alvo" text,
  "alvo_qtd" integer default 1,
  "raridade" text default 'comum'::text,
  "drop_item_id" text,
  "drop_chance" real default 0.35,
  "reputacao_alvo_nome" text,
  "reputacao_delta" integer default 0,
  "penalidade_col_falha" integer default 0,
  "penalidade_folego_falha" integer default 0,
  "reputacao_alvo_tipo" text default 'outro'::text
);
create table if not exists "monstros" (
  "id" text not null,
  "nome" text not null,
  "epiteto" text,
  "arquivo" text,
  "img" text,
  "carta" text,
  "tipo" text,
  "zona" text,
  "regioes" _text,
  "nivel_recomendado" text,
  "ameaca" text,
  "golpes" text,
  "local" text,
  "canonico" boolean default false,
  "fonte" text,
  "fraqueza" text,
  "fraquezas" _text,
  "resistencias" _text,
  "vulnerabilidades" _text,
  "domavel" text,
  "doma_sucessos" text,
  "doma_requisito" text,
  "resumo" text,
  "habitat" text,
  "comportamento" text,
  "leitura" text,
  "sinal" text,
  "lore" text,
  "notas" text,
  "drops" jsonb,
  "corpo" text,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null,
  "atributo_fraqueza" text
);
create table if not exists "moves_arma" (
  "nome" text not null,
  "atributo" text,
  "marca" text,
  "move_a" jsonb,
  "move_b" jsonb,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null,
  "golpe_2" jsonb,
  "golpe_3" jsonb,
  "limit_breaker" jsonb
);
create table if not exists "moves_profissao" (
  "nome" text not null,
  "atributo" text,
  "marca" text,
  "move_a" jsonb,
  "move_b" jsonb,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null,
  "move_c" jsonb
);
create table if not exists "nivel_profissao" (
  "personagem_nome" text not null,
  "profissao" text not null,
  "nivel" integer default 1 not null,
  "xp" integer default 0 not null,
  "ultima_acao" text,
  "updated_at" timestamp with time zone default now() not null
);
create table if not exists "nivel_profissao_xp" (
  "nivel" integer not null,
  "xp_necessario" integer not null
);
create table if not exists "npcs" (
  "id" text not null,
  "nome" text not null,
  "arquivo" text,
  "img" text,
  "papel" text,
  "profissao" text,
  "arma" text,
  "local" text,
  "atributos" jsonb,
  "resumo" text,
  "gancho" text,
  "falas" _text,
  "corpo" text,
  "canonico" boolean default false,
  "fonte" text,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null
);
create table if not exists "oficios" (
  "nome" text not null,
  "atributo" text,
  "arquivo" text,
  "marca" text,
  "acoes" jsonb,
  "postos" jsonb,
  "contato" text,
  "gancho" text,
  "renda" text,
  "item" text,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null
);
create table if not exists "ovos_catalogo" (
  "id" text not null,
  "nome" text not null,
  "especie" text,
  "monstro_id" text,
  "raridade" text not null,
  "nivel_min" integer default 1 not null,
  "tempo_chocagem_horas" integer not null,
  "incubadora_min" integer default 1 not null,
  "efeitos_padrao" jsonb default '{}'::jsonb not null,
  "como_obter" text default 'drop em monstro especifico'::text not null,
  "descricao" text,
  "visivel" boolean default true not null,
  "excluido" boolean default false not null,
  "updated_at" timestamp with time zone default now() not null
);
create table if not exists "perfis" (
  "id" uuid not null,
  "papel" text not null,
  "nome" text,
  "criado_em" timestamp with time zone default now() not null,
  "discord_nome" text,
  "discord_email" text,
  "foto_url" text
);
create table if not exists "personagem_ferramentas" (
  "personagem_nome" text not null,
  "ferramenta_id" text not null,
  "nivel_atual" integer default 1 not null,
  "obtido_em" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null
);
create table if not exists "personagens" (
  "nome" text not null,
  "guilda" text,
  "arma" text,
  "profissao" text,
  "conceito" text,
  "referencias" text,
  "aparencia" text,
  "atributos" jsonb,
  "arma_detalhe" jsonb,
  "profissao_detalhe" jsonb,
  "companheiro" jsonb,
  "estado" jsonb,
  "simbolo" text,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null,
  "dono_id" uuid,
  "col_mao" integer default 0 not null,
  "col_guardado" integer default 0 not null,
  "col_ganho_hoje" integer default 0 not null,
  "col_reset_dia" date,
  "folego" integer default 20 not null,
  "folego_atualizado_em" timestamp with time zone default now() not null,
  "bug" integer default 0 not null,
  "bug_ate" timestamp with time zone,
  "carga_limit" integer default 0 not null,
  "equipado" jsonb default '{}'::jsonb not null,
  "foto_url" text,
  "discord_nome" text,
  "discord_email" text,
  "condicoes" jsonb default '[]'::jsonb not null,
  "vida_max" integer default 50 not null,
  "vida_atual" integer default 50 not null,
  "vida_atualizada_em" timestamp with time zone default now() not null
);
create table if not exists "pontos" (
  "id" text not null,
  "regiao" text,
  "nome" text not null,
  "categoria" text,
  "x" integer,
  "y" integer,
  "tipo" text,
  "ref" text,
  "descricao" text,
  "respawn_horas" integer,
  "teste" jsonb,
  "recompensa" text,
  "ameaca" text,
  "golpes" text,
  "atributo_fraqueza" text,
  "fala" text,
  "oferece" text,
  "vende" text,
  "obs" text,
  "mestre" text,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null
);
create table if not exists "pontos_detalhe" (
  "id" text not null,
  "nome" text,
  "regiao" text,
  "arquivo" text,
  "leitura" text,
  "oque" text,
  "acoes" jsonb,
  "mestre" text,
  "atalhos" jsonb,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null
);
create table if not exists "producao" (
  "profissao" text not null,
  "moeda" text,
  "itens" jsonb,
  "vale" text,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null
);
create table if not exists "puzzles" (
  "id" text not null,
  "n" integer,
  "nome" text not null,
  "arquivo" text,
  "regiao" text,
  "tipo" text,
  "cadeia" text,
  "duracao" text,
  "verdade" text,
  "recompensa" text,
  "corpo" text,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null
);
create table if not exists "quests" (
  "id" text not null,
  "titulo" text not null,
  "cadeia" text,
  "tipo" text,
  "dificuldade" text,
  "regiao" text,
  "npc" text,
  "requer" _text,
  "desbloqueia" _text,
  "resumo" text,
  "corpo" text,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null
);
create table if not exists "receitas" (
  "id" text not null,
  "profissao" text not null,
  "nivel_receita" integer not null,
  "tipo" text not null,
  "nome_resultado" text not null,
  "resultado_item_id" text,
  "resultado_raridade" text,
  "atributo_teste" text not null,
  "dificuldade_mod" integer default 0 not null,
  "folego_custo" integer default 1 not null,
  "xp_recompensa" integer default 0 not null,
  "materiais" jsonb not null,
  "efeitos" jsonb default '{}'::jsonb not null,
  "receita_refino" boolean default false not null,
  "receita_estagio" integer default 1 not null,
  "receita_antecessora_id" text,
  "visivel" boolean default true not null,
  "excluido" boolean default false not null,
  "updated_at" timestamp with time zone default now() not null,
  "requer_ferramenta_id" text
);
create table if not exists "reputacao_personagem" (
  "personagem_nome" text not null,
  "alvo_nome" text not null,
  "nivel" integer default 0 not null,
  "ultima_alteracao" timestamp with time zone default now() not null,
  "motivo" text,
  "updated_at" timestamp with time zone default now() not null,
  "alvo_tipo" text default 'outro'::text not null
);
create table if not exists "salas_dungeon" (
  "id" text not null,
  "dungeon_id" text,
  "nome" text,
  "tipo" text,
  "leitura" text,
  "corpo" text,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null
);
create table if not exists "sistema" (
  "titulo" text not null,
  "corpo" text,
  "visivel" boolean default true not null,
  "updated_at" timestamp with time zone default now() not null,
  "excluido" boolean default false not null
);
create table if not exists "transacoes" (
  "id" bigint default nextval('transacoes_id_seq'::regclass) not null,
  "criado_em" timestamp with time zone default now() not null,
  "de_personagem" text,
  "para_personagem" text,
  "tipo" text not null,
  "valor" integer not null,
  "item_id" text,
  "observacao" text
);
create table if not exists "vitrine" (
  "id" bigint default nextval('vitrine_id_seq'::regclass) not null,
  "vendedor_nome" text not null,
  "inventario_id" bigint not null,
  "preco_col" integer not null,
  "criado_em" timestamp with time zone default now() not null,
  "vendido" boolean default false not null,
  "comprador_nome" text,
  "vendido_em" timestamp with time zone,
  "expira_em" timestamp with time zone,
  "item_nome" text,
  "item_tipo" text
);

-- ========== CONSTRAINTS ==========
do $$ begin
  alter table "armas" add constraint "armas_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "bestiario_roster" add constraint "bestiario_roster_categoria_check" CHECK ((categoria = ANY (ARRAY['comum'::text, 'mini_boss'::text, 'mvp'::text, 'boss'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "bestiario_roster" add constraint "bestiario_roster_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "cartas" add constraint "cartas_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "cartas" add constraint "cartas_raridade_check" CHECK ((raridade = ANY (ARRAY['Comum'::text, 'Incomum'::text, 'Raro'::text, 'Épico'::text, 'Lendário'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "cartas" add constraint "cartas_tipo_bonus_check" CHECK ((tipo_bonus = ANY (ARRAY['atributo'::text, 'dano'::text, 'resist'::text, 'especial'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "cidades" add constraint "cidades_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "cla_autoridade" add constraint "cla_autoridade_cargo_check" CHECK ((cargo = ANY (ARRAY['lider'::text, 'oficial'::text, 'membro'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "cla_autoridade" add constraint "cla_autoridade_cla_nome_fkey" FOREIGN KEY (cla_nome) REFERENCES clas(nome) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "cla_autoridade" add constraint "cla_autoridade_cla_nome_personagem_nome_key" UNIQUE (cla_nome, personagem_nome);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "cla_autoridade" add constraint "cla_autoridade_personagem_nome_fkey" FOREIGN KEY (personagem_nome) REFERENCES personagens(nome) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "cla_autoridade" add constraint "cla_autoridade_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "cla_inventario" add constraint "cla_inventario_cla_nome_fkey" FOREIGN KEY (cla_nome) REFERENCES clas(nome) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "cla_inventario" add constraint "cla_inventario_depositado_por_fkey" FOREIGN KEY (depositado_por) REFERENCES personagens(nome) ON DELETE SET NULL;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "cla_inventario" add constraint "cla_inventario_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "clas" add constraint "clas_pkey" PRIMARY KEY (nome);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "combate_log" add constraint "combate_log_personagem_nome_fkey" FOREIGN KEY (personagem_nome) REFERENCES personagens(nome) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "combate_log" add constraint "combate_log_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "compra_materiais" add constraint "compra_materiais_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "conteudo_liberado" add constraint "conteudo_liberado_jogador_id_fkey" FOREIGN KEY (jogador_id) REFERENCES auth.users(id) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "conteudo_liberado" add constraint "conteudo_liberado_jogador_id_tabela_registro_id_key" UNIQUE (jogador_id, tabela, registro_id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "conteudo_liberado" add constraint "conteudo_liberado_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "craft_fila" add constraint "craft_fila_personagem_nome_fkey" FOREIGN KEY (personagem_nome) REFERENCES personagens(nome) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "craft_fila" add constraint "craft_fila_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "craft_fila" add constraint "craft_fila_profissao_fkey" FOREIGN KEY (profissao) REFERENCES oficios(nome);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "craft_fila" add constraint "craft_fila_status_check" CHECK ((status = ANY (ARRAY['fabricando'::text, 'pronto'::text, 'coletado'::text, 'falhou'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "criaturas_domadas" add constraint "criaturas_domadas_personagem_nome_fkey" FOREIGN KEY (personagem_nome) REFERENCES personagens(nome) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "criaturas_domadas" add constraint "criaturas_domadas_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "criaturas_domadas" add constraint "criaturas_domadas_raridade_check" CHECK ((raridade = ANY (ARRAY['Comum'::text, 'Incomum'::text, 'Raro'::text, 'Épico'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "criaturas_domadas" add constraint "criaturas_domadas_status_check" CHECK ((status = ANY (ARRAY['incubando'::text, 'ativo'::text, 'perdido'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "cristais" add constraint "cristais_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "cristais" add constraint "cristais_tipo_bonus_check" CHECK ((tipo_bonus = ANY (ARRAY['atributo'::text, 'dano'::text, 'resist'::text, 'especial'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "cronicas" add constraint "cronicas_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "documento_chunks" add constraint "documento_chunks_documento_id_fkey" FOREIGN KEY (documento_id) REFERENCES documentos(id) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "documento_chunks" add constraint "documento_chunks_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "documentos" add constraint "documentos_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "dungeons" add constraint "dungeons_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "equipamentos" add constraint "equipamentos_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "ferramentas_oficio" add constraint "ferramentas_oficio_nivel_ferramenta_check" CHECK (((nivel_ferramenta >= 1) AND (nivel_ferramenta <= 5)));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "ferramentas_oficio" add constraint "ferramentas_oficio_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "ferramentas_oficio" add constraint "ferramentas_oficio_profissao_fkey" FOREIGN KEY (profissao) REFERENCES oficios(nome);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "guias" add constraint "guias_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "inventario" add constraint "inventario_cristal_id_fkey" FOREIGN KEY (cristal_id) REFERENCES cristais(id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "inventario" add constraint "inventario_local_check" CHECK ((local = ANY (ARRAY['mochila'::text, 'stash'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "inventario" add constraint "inventario_personagem_nome_fkey" FOREIGN KEY (personagem_nome) REFERENCES personagens(nome) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "inventario" add constraint "inventario_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "inventario" add constraint "inventario_tipo_check" CHECK ((tipo = ANY (ARRAY['arma'::text, 'equipamento'::text, 'consumivel'::text, 'material'::text, 'carta'::text, 'cristal'::text, 'ovo'::text, 'pet'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "limit_breaker_contador" add constraint "limit_breaker_contador_arma_tipo_fkey" FOREIGN KEY (arma_tipo) REFERENCES moves_arma(nome) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "limit_breaker_contador" add constraint "limit_breaker_contador_contador_check" CHECK (((contador >= 0) AND (contador <= 10)));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "limit_breaker_contador" add constraint "limit_breaker_contador_personagem_nome_fkey" FOREIGN KEY (personagem_nome) REFERENCES personagens(nome) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "limit_breaker_contador" add constraint "limit_breaker_contador_pkey" PRIMARY KEY (personagem_nome, arma_tipo);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "materiais_basicos" add constraint "materiais_basicos_nivel_obtencao_check" CHECK (((nivel_obtencao >= 1) AND (nivel_obtencao <= 10)));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "materiais_basicos" add constraint "materiais_basicos_nome_key" UNIQUE (nome);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "materiais_basicos" add constraint "materiais_basicos_peso_uso_esperado_check" CHECK (((peso_uso_esperado >= 1) AND (peso_uso_esperado <= 10)));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "materiais_basicos" add constraint "materiais_basicos_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "materiais_basicos" add constraint "materiais_basicos_raridade_check" CHECK ((raridade = ANY (ARRAY['comum'::text, 'incomum'::text, 'raro'::text, 'epico'::text, 'lendario'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "mercado" add constraint "mercado_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "mercado_itens" add constraint "mercado_itens_mercado_id_fkey" FOREIGN KEY (mercado_id) REFERENCES mercado(id) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "mercado_itens" add constraint "mercado_itens_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "mesa_combate" add constraint "mesa_combate_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "mesa_raid_prep" add constraint "mesa_raid_prep_pkey" PRIMARY KEY (categoria);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "mesa_relacoes" add constraint "mesa_relacoes_pkey" PRIMARY KEY (nome);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "mesa_relacoes" add constraint "mesa_relacoes_valor_check" CHECK (((valor >= '-3'::integer) AND (valor <= 3)));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "mesa_relogios" add constraint "mesa_relogios_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "mesa_relogios" add constraint "mesa_relogios_valor_check" CHECK (((valor >= 0) AND (valor <= 6)));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "mesa_sessoes" add constraint "mesa_sessoes_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "metas_doacoes" add constraint "metas_doacoes_meta_id_fkey" FOREIGN KEY (meta_id) REFERENCES metas_globais(id) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "metas_doacoes" add constraint "metas_doacoes_personagem_nome_fkey" FOREIGN KEY (personagem_nome) REFERENCES personagens(nome) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "metas_doacoes" add constraint "metas_doacoes_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "metas_doacoes" add constraint "metas_doacoes_qtd_doada_check" CHECK ((qtd_doada > 0));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "metas_globais" add constraint "metas_globais_criado_por_fkey" FOREIGN KEY (criado_por) REFERENCES auth.users(id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "metas_globais" add constraint "metas_globais_meta_qtd_check" CHECK ((meta_qtd > 0));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "metas_globais" add constraint "metas_globais_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "missao_diaria" add constraint "missao_diaria_missao_id_fkey" FOREIGN KEY (missao_id) REFERENCES missoes_quadro(id) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "missao_diaria" add constraint "missao_diaria_personagem_nome_fkey" FOREIGN KEY (personagem_nome) REFERENCES personagens(nome) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "missao_diaria" add constraint "missao_diaria_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "missao_diaria" add constraint "missao_diaria_status_check" CHECK ((status = ANY (ARRAY['oferecida'::text, 'aceita'::text, 'concluida'::text, 'expirou'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "missoes_quadro" add constraint "missoes_quadro_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "missoes_quadro" add constraint "missoes_quadro_raridade_check" CHECK ((raridade = ANY (ARRAY['comum'::text, 'incomum'::text, 'raro'::text, 'epico'::text, 'lendario'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "missoes_quadro" add constraint "missoes_quadro_reputacao_alvo_tipo_check" CHECK ((reputacao_alvo_tipo = ANY (ARRAY['cla'::text, 'cidade'::text, 'vila'::text, 'npc'::text, 'faccao'::text, 'outro'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "monstros" add constraint "monstros_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "moves_arma" add constraint "moves_arma_pkey" PRIMARY KEY (nome);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "moves_profissao" add constraint "moves_profissao_pkey" PRIMARY KEY (nome);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "nivel_profissao" add constraint "nivel_profissao_nivel_check" CHECK (((nivel >= 1) AND (nivel <= 10)));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "nivel_profissao" add constraint "nivel_profissao_personagem_nome_fkey" FOREIGN KEY (personagem_nome) REFERENCES personagens(nome) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "nivel_profissao" add constraint "nivel_profissao_pkey" PRIMARY KEY (personagem_nome, profissao);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "nivel_profissao" add constraint "nivel_profissao_profissao_fkey" FOREIGN KEY (profissao) REFERENCES oficios(nome);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "nivel_profissao_xp" add constraint "nivel_profissao_xp_nivel_check" CHECK (((nivel >= 2) AND (nivel <= 10)));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "nivel_profissao_xp" add constraint "nivel_profissao_xp_pkey" PRIMARY KEY (nivel);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "npcs" add constraint "npcs_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "oficios" add constraint "oficios_pkey" PRIMARY KEY (nome);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "ovos_catalogo" add constraint "ovos_catalogo_incubadora_min_check" CHECK (((incubadora_min >= 1) AND (incubadora_min <= 5)));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "ovos_catalogo" add constraint "ovos_catalogo_nivel_min_check" CHECK (((nivel_min >= 1) AND (nivel_min <= 10)));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "ovos_catalogo" add constraint "ovos_catalogo_nome_key" UNIQUE (nome);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "ovos_catalogo" add constraint "ovos_catalogo_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "ovos_catalogo" add constraint "ovos_catalogo_raridade_check" CHECK ((raridade = ANY (ARRAY['comum'::text, 'incomum'::text, 'raro'::text, 'epico'::text, 'lendario'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "ovos_catalogo" add constraint "ovos_catalogo_tempo_chocagem_horas_check" CHECK (((tempo_chocagem_horas >= 1) AND (tempo_chocagem_horas <= 72)));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "perfis" add constraint "perfis_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "perfis" add constraint "perfis_papel_check" CHECK ((papel = ANY (ARRAY['mestre'::text, 'jogador'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "perfis" add constraint "perfis_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "personagem_ferramentas" add constraint "personagem_ferramentas_ferramenta_id_fkey" FOREIGN KEY (ferramenta_id) REFERENCES ferramentas_oficio(id) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "personagem_ferramentas" add constraint "personagem_ferramentas_nivel_atual_check" CHECK (((nivel_atual >= 1) AND (nivel_atual <= 5)));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "personagem_ferramentas" add constraint "personagem_ferramentas_personagem_nome_fkey" FOREIGN KEY (personagem_nome) REFERENCES personagens(nome) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "personagem_ferramentas" add constraint "personagem_ferramentas_pkey" PRIMARY KEY (personagem_nome, ferramenta_id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "personagens" add constraint "personagens_dono_id_fkey" FOREIGN KEY (dono_id) REFERENCES auth.users(id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "personagens" add constraint "personagens_pkey" PRIMARY KEY (nome);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "pontos" add constraint "pontos_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "pontos_detalhe" add constraint "pontos_detalhe_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "producao" add constraint "producao_pkey" PRIMARY KEY (profissao);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "puzzles" add constraint "puzzles_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "quests" add constraint "quests_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "receitas" add constraint "receitas_atributo_teste_check" CHECK ((atributo_teste = ANY (ARRAY['Reflexo'::text, 'Conhecimento'::text, 'Técnica'::text, 'Espírito'::text, 'Corpo'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "receitas" add constraint "receitas_folego_custo_check" CHECK (((folego_custo >= 0) AND (folego_custo <= 10)));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "receitas" add constraint "receitas_nivel_receita_check" CHECK (((nivel_receita >= 1) AND (nivel_receita <= 10)));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "receitas" add constraint "receitas_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "receitas" add constraint "receitas_profissao_fkey" FOREIGN KEY (profissao) REFERENCES oficios(nome) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "receitas" add constraint "receitas_receita_antecessora_id_fkey" FOREIGN KEY (receita_antecessora_id) REFERENCES receitas(id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "receitas" add constraint "receitas_receita_estagio_check" CHECK (((receita_estagio >= 1) AND (receita_estagio <= 2)));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "receitas" add constraint "receitas_requer_ferramenta_id_fkey" FOREIGN KEY (requer_ferramenta_id) REFERENCES ferramentas_oficio(id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "receitas" add constraint "receitas_resultado_raridade_check" CHECK ((resultado_raridade = ANY (ARRAY['comum'::text, 'incomum'::text, 'raro'::text, 'epico'::text, 'lendario'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "receitas" add constraint "receitas_tipo_check" CHECK ((tipo = ANY (ARRAY['ferramenta'::text, 'item'::text, 'ovo_especial'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "reputacao_personagem" add constraint "reputacao_personagem_alvo_tipo_check" CHECK ((alvo_tipo = ANY (ARRAY['cla'::text, 'cidade'::text, 'vila'::text, 'npc'::text, 'faccao'::text, 'outro'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "reputacao_personagem" add constraint "reputacao_personagem_nivel_check" CHECK (((nivel >= '-3'::integer) AND (nivel <= 3)));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "reputacao_personagem" add constraint "reputacao_personagem_personagem_nome_fkey" FOREIGN KEY (personagem_nome) REFERENCES personagens(nome) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "reputacao_personagem" add constraint "reputacao_personagem_pkey" PRIMARY KEY (personagem_nome, alvo_nome);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "salas_dungeon" add constraint "salas_dungeon_dungeon_id_fkey" FOREIGN KEY (dungeon_id) REFERENCES dungeons(id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "salas_dungeon" add constraint "salas_dungeon_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "sistema" add constraint "sistema_pkey" PRIMARY KEY (titulo);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "transacoes" add constraint "transacoes_de_personagem_fkey" FOREIGN KEY (de_personagem) REFERENCES personagens(nome);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "transacoes" add constraint "transacoes_para_personagem_fkey" FOREIGN KEY (para_personagem) REFERENCES personagens(nome);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "transacoes" add constraint "transacoes_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "transacoes" add constraint "transacoes_tipo_check" CHECK ((tipo = ANY (ARRAY['missao'::text, 'venda'::text, 'compra'::text, 'craft'::text, 'bug'::text, 'ajuste_mestre'::text, 'npc'::text, 'taxa'::text, 'limite_diario'::text, 'combate'::text, 'estalagem'::text, 'transferencia'::text, 'meta_global'::text])));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "vitrine" add constraint "vitrine_comprador_nome_fkey" FOREIGN KEY (comprador_nome) REFERENCES personagens(nome);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "vitrine" add constraint "vitrine_inventario_id_fkey" FOREIGN KEY (inventario_id) REFERENCES inventario(id) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "vitrine" add constraint "vitrine_pkey" PRIMARY KEY (id);
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "vitrine" add constraint "vitrine_preco_col_check" CHECK ((preco_col > 0));
exception when duplicate_object then null; when others then null; end $$;
do $$ begin
  alter table "vitrine" add constraint "vitrine_vendedor_nome_fkey" FOREIGN KEY (vendedor_nome) REFERENCES personagens(nome) ON DELETE CASCADE;
exception when duplicate_object then null; when others then null; end $$;

-- ========== VIEWS ==========
create or replace view "clas_publico" as  SELECT nome,
    destaque,
    forca,
    necessidade,
    rival,
    rumor,
    status,
    resumo,
    bons,
    precisa,
    nao_admitem,
    proximo,
    atravessado,
    quests,
    aparecem,
    simbolo,
    reputacao,
    visivel,
    updated_at,
        CASE
            WHEN is_mestre() THEN ganchos
            ELSE NULL::jsonb
        END AS ganchos
   FROM clas
  WHERE (((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('clas'::text, nome));
create or replace view "guias_publico" as  SELECT id,
    nome,
    arquivo,
    bioma,
    nivel,
    chegada,
    leitura,
    cena,
    acoes,
    demora,
    evento,
    locais,
    ligado,
    visivel,
    updated_at,
        CASE
            WHEN is_mestre() THEN mestre
            ELSE NULL::text
        END AS mestre
   FROM guias
  WHERE (((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('guias'::text, id));
create or replace view "monstros_publico" as  SELECT id,
    nome,
    epiteto,
    arquivo,
    img,
    carta,
    tipo,
    zona,
    regioes,
    nivel_recomendado,
    ameaca,
    golpes,
    local,
    canonico,
    fonte,
    fraqueza,
    atributo_fraqueza,
    fraquezas,
    resistencias,
    vulnerabilidades,
    resumo,
    habitat,
    comportamento,
    leitura,
    sinal,
    lore,
    drops,
    corpo,
    visivel,
    updated_at,
        CASE
            WHEN is_mestre() THEN notas
            ELSE NULL::text
        END AS notas
   FROM monstros
  WHERE (((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('monstros'::text, id));
create or replace view "pontos_detalhe_publico" as  SELECT id,
    nome,
    regiao,
    arquivo,
    leitura,
    oque,
    acoes,
    atalhos,
    visivel,
    updated_at,
        CASE
            WHEN is_mestre() THEN mestre
            ELSE NULL::text
        END AS mestre
   FROM pontos_detalhe
  WHERE (((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('pontos_detalhe'::text, id));
create or replace view "pontos_publico" as  SELECT id,
    regiao,
    nome,
    categoria,
    x,
    y,
    tipo,
    ref,
    descricao,
    respawn_horas,
    teste,
    recompensa,
    ameaca,
    golpes,
    atributo_fraqueza,
    fala,
    oferece,
    vende,
    obs,
    visivel,
    updated_at,
        CASE
            WHEN is_mestre() THEN mestre
            ELSE NULL::text
        END AS mestre
   FROM pontos
  WHERE (((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('pontos'::text, id));
create or replace view "puzzles_publico" as  SELECT id,
    n,
    nome,
    arquivo,
    regiao,
    tipo,
    cadeia,
    duracao,
    recompensa,
    corpo,
    visivel,
    updated_at,
        CASE
            WHEN is_mestre() THEN verdade
            ELSE NULL::text
        END AS verdade
   FROM puzzles
  WHERE (((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('puzzles'::text, id));

-- ========== FUNÇÕES ==========
CREATE OR REPLACE FUNCTION public._ajustar_reputacao_interna(p_personagem_nome text, p_alvo_nome text, p_delta integer, p_alvo_tipo text DEFAULT 'outro'::text, p_motivo text DEFAULT NULL::text)
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare v_novo int;
begin
  insert into reputacao_personagem (personagem_nome, alvo_nome, alvo_tipo, nivel, motivo)
    values (p_personagem_nome, p_alvo_nome, coalesce(p_alvo_tipo,'outro'),
            greatest(-3, least(3, p_delta)), p_motivo)
  on conflict (personagem_nome, alvo_nome) do update
    set nivel = greatest(-3, least(3, reputacao_personagem.nivel + p_delta)),
        alvo_tipo = coalesce(excluded.alvo_tipo, reputacao_personagem.alvo_tipo),
        motivo = coalesce(p_motivo, reputacao_personagem.motivo),
        ultima_alteracao = now(),
        updated_at = now()
  returning nivel into v_novo;
  return v_novo;
end;
$function$
;

CREATE OR REPLACE FUNCTION public._cargo_do_personagem(p_cla_nome text, p_personagem_nome text)
 RETURNS text
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select cargo from cla_autoridade where cla_nome = p_cla_nome and personagem_nome = p_personagem_nome;
$function$
;

CREATE OR REPLACE FUNCTION public._recalcular_vida_max()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare v_melhor int;
begin
  select coalesce(max(nivel),1) into v_melhor from nivel_profissao where personagem_nome = new.personagem_nome;
  update personagens set vida_max = 50 + (v_melhor - 1) * 5 where nome = new.personagem_nome;
  return new;
end;
$function$
;

CREATE OR REPLACE FUNCTION public._regenerar_folego_todos()
 RETURNS void
 LANGUAGE sql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  update personagens set folego = least(20, folego + 1), updated_at = now()
    where folego < 20 and excluido = false;
$function$
;

CREATE OR REPLACE FUNCTION public.aceitar_e_resolver_missao(p_missao_id text)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_personagem text;
  v_m missoes_quadro%rowtype;
  v_nivel int;
  v_xp_atual int;
  v_dados int[];
  v_soma int;
  v_dif int;
  v_resultado text;      -- sucesso_total / sucesso_parcial / falha
  v_col_ganho int;
  v_xp_ganho int;
  v_droppou boolean;
  v_drop_novo_id bigint;
  v_novo_nivel int;
  v_xp_subiu_nivel boolean;
  v_folego_gasto int;
  v_nova_md_id bigint;
  v_resp jsonb;
  v_drops_mat_ids bigint[];  -- ids dos drops de material adicionados (para resposta)
  v_novo_mat_id bigint;
begin
  -- 0) validar sessão
  select nome into v_personagem from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  -- 1) validar missão existe, visível, nível mínimo ok
  select * into v_m from missoes_quadro where id = p_missao_id and visivel=true and excluido=false;
  if not found then return '{"erro":"missao invalida"}'; end if;

  select nivel, xp into v_nivel, v_xp_atual
    from nivel_profissao where personagem_nome = v_personagem
    order by nivel desc limit 1;
  if v_nivel is null then v_nivel := 1; v_xp_atual := 0; end if;

  if v_m.nivel_min > v_nivel then
    return format('{"erro":"nivel minimo %s necessario (voce=%s)"}', v_m.nivel_min, v_nivel);
  end if;

  -- 2) validar fôlego
  if not exists (select 1 from personagens where nome = v_personagem and folego >= v_m.custo_folego) then
    return format('{"erro":"folego insuficiente: precisa %s"}', v_m.custo_folego);
  end if;

  -- 3) gastar fôlego
  update personagens
     set folego = folego - v_m.custo_folego, updated_at = now()
     where nome = v_personagem;
  v_folego_gasto := v_m.custo_folego;

  -- 4) calcular nível de dificuldade vs personagem → rolar 2d6 + modificador PBTA
  -- Fórmula de chance base (dif = personagem nivel - missao nivel_min):
  --   dif ≥ +2 → mod = +3
  --   dif = +1 → mod = +1
  --   dif = 0  → mod = 0
  --   dif = -1 → mod = -1
  --   dif ≤ -2 → mod = -3
  v_dif := v_nivel - v_m.nivel_min;
  declare v_mod int; begin
    v_mod := case
      when v_dif >= 2 then 3
      when v_dif = 1  then 1
      when v_dif = 0  then 0
      when v_dif = -1 then -1
      else -3
    end;
    v_dados := array[(1 + floor(random()*6))::int, (1 + floor(random()*6))::int];
    v_soma := v_dados[1] + v_dados[2] + v_mod;
  end;

  -- 5) aplicar resultado (PBTA 3 vias)
  if v_soma >= 10 then
    v_resultado := 'sucesso_total';
    v_xp_ganho := v_m.recompensa_xp;
    v_col_ganho := v_m.recompensa_col_min +
      floor(random() * (v_m.recompensa_col_max - v_m.recompensa_col_min + 1));
  elsif v_soma >= 7 then
    v_resultado := 'sucesso_parcial';
    v_xp_ganho := (v_m.recompensa_xp * 0.7)::int;
    v_col_ganho := ((v_m.recompensa_col_min + v_m.recompensa_col_max) / 2 * 0.8)::int;
  else
    v_resultado := 'falha';
    v_xp_ganho := 0;
    v_col_ganho := 0;
    if v_m.penalidade_col_falha > 0 then
      update personagens
        set col_mao = greatest(0, col_mao - v_m.penalidade_col_falha), updated_at = now()
        where nome = v_personagem;
    end if;
    if v_m.penalidade_folego_falha > 0 then
      update personagens
        set folego = greatest(0, folego - v_m.penalidade_folego_falha), updated_at = now()
        where nome = v_personagem;
    end if;
  end if;

  -- 6) DROPS: (a) especifico da missao + (b) generico de materiais SEMPRE (100% obtencao via drop, sem NPCs)
  v_drop_novo_id := null;
  v_drops_mat_ids := array[]::bigint[];

  -- (a) drop ESPECÍFICO (se a missao tem drop_item_id definido — arma/equip/carta etc)
  if v_resultado <> 'falha' and v_m.drop_item_id is not null then
    v_droppou := random() < v_m.drop_chance;
    if v_droppou then
      declare
        v_drop_nome text;
        v_drop_tipo text;
      begin
        select nome, coalesce(tipo, 'arma') into v_drop_nome, v_drop_tipo
          from armas where id = v_m.drop_item_id;
        if not found then
          -- equipamentos NAO tem coluna "tipo" (tem "slot") -- ler coalesce(tipo,...)
          -- daqui quebrava a funcao inteira com "column tipo does not exist"
          -- sempre que um drop de missao caia nesse ramo (achado 10/08).
          select nome, 'equipamento' into v_drop_nome, v_drop_tipo
            from equipamentos where id = v_m.drop_item_id;
        end if;
        if not found then
          select nome, 'carta' into v_drop_nome, v_drop_tipo
            from cartas where id = v_m.drop_item_id;
        end if;
        if not found then
          select nome, 'ovo' into v_drop_nome, v_drop_tipo
            from ovos_catalogo where id = v_m.drop_item_id;
        end if;
        if not found then
          select nome, 'cristal' into v_drop_nome, v_drop_tipo
            from cristais where id = v_m.drop_item_id;
        end if;
        if v_drop_nome is null then
          -- se nao existir em nenhum catalogo, interpreta como material de craft (fallback)
          v_drop_nome := coalesce((select nome from materiais_basicos where id = v_m.drop_item_id), v_m.drop_item_id);
          v_drop_tipo := 'material';
        end if;
        insert into inventario
          (personagem_nome, item_id, nome, tipo, quantidade, origem)
          values (v_personagem, v_m.drop_item_id, v_drop_nome, v_drop_tipo, 1, 'missao')
          returning id into v_drop_novo_id;
        if v_drop_tipo = 'material' then
          v_drops_mat_ids := array_append(v_drops_mat_ids, v_drop_novo_id);
        end if;
      end;
    end if;
  end if;

  -- (b) drop GENÉRICO DE MATERIAIS DE CRAFT — sempre rola quando sucesso/parcial,
  --     garantindo regra #2: "só drop obtém TUDO, nenhuma dependência de NPC".
  --     Regras de roll:
  --       · Nível missão → raridade permitida (escala suave)
  --       · Tipo missão  → categoria preferencial (caca=animal, coleta=vegetal/mineral etc)
  --       · 1-3 materiais por missão (2 padrão, 1 em parcial, 3 só total alto nivel)
  --       · qtd por material: comum 3-8 / incomum 2-5 / raro 1-3 / épico 1-2 / lendário 1
  if v_resultado <> 'falha' then
    declare
      v_qtd_mats int;
      v_rar_allowed text[];
      v_cats_pref text[];
      v_roll_rar text;
      v_roll_cat text;
      v_roll_mat_id text;
      v_roll_mat_nome text;
      v_roll_qtd int;
      v_cont int;
      v_chance_rar_alta numeric;
    begin
      -- qtd de materiais a sortear: parcial = 1-2 / total = 2-3
      if v_resultado = 'sucesso_total' then
        v_qtd_mats := 2 + case when v_m.nivel_min >= 6 then 1 else 0 end;  -- +1 a partir de nv6 total
      else
        v_qtd_mats := 1 + case when v_m.nivel_min >= 8 then 1 else 0 end;  -- parcial = 1 ou 2
      end if;

      -- raridade permitida baseada em nivel_min da missao (escala progressiva, sem saltos)
      -- chance de raridade ALTA aumenta com sucesso_total (até 25%)
      v_chance_rar_alta := case v_resultado
        when 'sucesso_total' then 0.25 else 0.08 end;
      case
        when v_m.nivel_min <= 2 then
          v_rar_allowed := case when random() < v_chance_rar_alta
            then array['comum','incomum'] else array['comum'] end;
        when v_m.nivel_min between 3 and 4 then
          v_rar_allowed := case when random() < v_chance_rar_alta
            then array['incomum','raro'] else array['comum','incomum'] end;
        when v_m.nivel_min between 5 and 6 then
          v_rar_allowed := case when random() < v_chance_rar_alta
            then array['raro','epico'] else array['incomum','raro'] end;
        when v_m.nivel_min between 7 and 8 then
          v_rar_allowed := case when random() < v_chance_rar_alta
            then array['epico','lendario'] else array['raro','epico'] end;
        else  -- nv 9-10
          v_rar_allowed := case when random() < v_chance_rar_alta
            then array['lendario'] else array['epico','lendario'] end;
      end case;

      -- categorias preferidas por TIPO de missão (categoria exata → mais provável)
      case coalesce(v_m.tipo, 'combate')
        when 'caca'                then v_cats_pref := array['animal','mineral','exotico'];
        when 'coleta'              then v_cats_pref := array['vegetal','mineral','quimico'];
        when 'oficio'              then v_cats_pref := array['mineral','tecido','quimico','vegetal'];
        when 'entrega'             then v_cats_pref := array['tecido','nobre','quimico'];
        when 'social'              then v_cats_pref := array['tecido','nobre','quimico','vegetal'];
        when 'contrato_arriscado'  then v_cats_pref := array['exotico','nobre','animal','lendario'];
        else                             v_cats_pref := array['mineral','animal','vegetal'];
      end case;

      -- loop para dropar cada material (não repete material na mesma missão)
      v_cont := 0;
      declare
        v_ja_usados text[] := array[]::text[];
      begin
        while v_cont < v_qtd_mats loop
          -- (i) escolhe uma raridade do pool permitido
          v_roll_rar := v_rar_allowed[1 + floor(random() * array_length(v_rar_allowed, 1))::int];

          -- (ii) 60% chance de usar categoria preferida, 40% qualquer outra
          if random() < 0.60 then
            v_roll_cat := v_cats_pref[1 + floor(random() * array_length(v_cats_pref, 1))::int];
            -- escolhe material com essa raridade E categoria preferida OU só raridade se não tiver
            select id, nome into v_roll_mat_id, v_roll_mat_nome
              from materiais_basicos
              where raridade = v_roll_rar and categoria = v_roll_cat
                and visivel and not excluido
                and id <> all (v_ja_usados)
              order by random() limit 1;
          else
            v_roll_cat := null;
          end if;
          -- fallback: só raridade, qualquer categoria
          if v_roll_mat_id is null then
            select id, nome into v_roll_mat_id, v_roll_mat_nome
              from materiais_basicos
              where raridade = v_roll_rar and visivel and not excluido
                and id <> all (v_ja_usados)
              order by random() limit 1;
          end if;

          if v_roll_mat_id is not null then
            -- quantidade baseada em raridade
            v_roll_qtd := case v_roll_rar
              when 'comum'    then 3 + floor(random() * 6)::int   -- 3..8
              when 'incomum'  then 2 + floor(random() * 4)::int   -- 2..5
              when 'raro'     then 1 + floor(random() * 3)::int   -- 1..3
              when 'epico'    then 1 + (random() < 0.4)::int      -- 1..2
              else 1                                              -- lendario = 1
            end;
            -- sucesso_total dá +50% na qtd (round up)
            if v_resultado = 'sucesso_total' then
              v_roll_qtd := ceil(v_roll_qtd * 1.5)::int;
            end if;

            insert into inventario
              (personagem_nome, item_id, nome, tipo, quantidade, origem)
              values (v_personagem, v_roll_mat_id, v_roll_mat_nome, 'material', v_roll_qtd, 'missao')
              returning id into v_novo_mat_id;
            v_drops_mat_ids := array_append(v_drops_mat_ids, v_novo_mat_id);
            v_ja_usados := array_append(v_ja_usados, v_roll_mat_id);
          end if;

          v_cont := v_cont + 1;
          -- evita loop infinito se faltar material
          exit when v_cont > 10;
        end loop;
      end;
    end;
  end if;

  -- 7) recompensas col e xp + subir nível
  if v_xp_ganho > 0 or v_col_ganho > 0 then
    if v_col_ganho > 0 then
      update personagens set col_mao = col_mao + v_col_ganho, updated_at = now()
        where nome = v_personagem;
    end if;
    if v_xp_ganho > 0 then
      declare
        v_prof text;
        v_xp_novo int;
        v_prox_nivel_xp int;
      begin
        select profissao into v_prof from personagens where nome = v_personagem;
        if v_prof is null then v_prof := 'Aventureiro'; end if;
        if not exists (select 1 from nivel_profissao
                        where personagem_nome = v_personagem and profissao = v_prof) then
          insert into nivel_profissao (personagem_nome, profissao, nivel, xp)
            values (v_personagem, v_prof, 1, 0);
        end if;
        update nivel_profissao
           set xp = xp + v_xp_ganho, updated_at = now()
         where personagem_nome = v_personagem and profissao = v_prof
         returning xp into v_xp_novo;
        v_novo_nivel := null;
        <<sobe_nivel>> loop
          v_xp_subiu_nivel := false;
          select coalesce(max(nivel), 1) into v_nivel from nivel_profissao
            where personagem_nome = v_personagem;
          select xp_necessario into v_prox_nivel_xp from nivel_profissao_xp
            where nivel = v_nivel + 1;
          exit sobe_nivel when v_prox_nivel_xp is null;
          if v_xp_novo >= v_prox_nivel_xp then
            update nivel_profissao
               set nivel = nivel + 1,
                   xp = xp - v_prox_nivel_xp,
                   updated_at = now()
             where personagem_nome = v_personagem and profissao = v_prof
             returning xp into v_xp_novo;
            v_xp_subiu_nivel := true;
            v_novo_nivel := coalesce(v_novo_nivel, v_nivel + 1);
          end if;
          exit sobe_nivel when not v_xp_subiu_nivel;
        end loop sobe_nivel;
      end;
    end if;
  end if;

  -- 8) inserir transação log
  if v_col_ganho > 0 then
    insert into transacoes (de_personagem, para_personagem, tipo, valor, item_id, observacao)
      values (null, v_personagem, 'missao', v_col_ganho, v_m.drop_item_id,
              format('missao %s %s (xp=%s)', v_m.id, v_resultado, v_xp_ganho));
  end if;

  -- 9) salvar no histórico missao_diaria
  v_resp := jsonb_build_object(
    'resultado', v_resultado,
    'dados', v_dados,
    'soma_com_mod', v_soma,
    'xp', v_xp_ganho,
    'col', v_col_ganho,
    'drop_item_id', v_m.drop_item_id,
    'drop_inventario_id', v_drop_novo_id,
    'drops_materiais_inventario_ids', v_drops_mat_ids,
    'folego_gasto', v_folego_gasto,
    'novo_nivel', v_novo_nivel,
    'missao_titulo', v_m.titulo,
    'missao_tipo', v_m.tipo,
    'missao_nivel_min', v_m.nivel_min
  );
  insert into missao_diaria (personagem_nome, missao_id, status, aceita_em, concluida_em, resultado)
    values (v_personagem, p_missao_id,
            case when v_resultado='falha' then 'expirou' else 'concluida' end::text,
            now(), now(), v_resp)
    returning id into v_nova_md_id;

  return v_resp::text;
end $function$
;

CREATE OR REPLACE FUNCTION public.buscar_contexto(p_embedding vector, p_k integer DEFAULT 5, p_categoria text DEFAULT NULL::text)
 RETURNS TABLE(documento_id text, titulo text, caminho text, categoria text, titulo_secao text, conteudo text, similaridade double precision)
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select d.id, d.titulo, d.caminho, d.categoria, c.titulo_secao, c.conteudo,
         1 - (c.embedding <=> p_embedding) as similaridade
  from documento_chunks c
  join documentos d on d.id = c.documento_id
  where (d.visivel = true and d.excluido = false)
    and (d.publico = true or is_mestre() or pode_ver('documentos', d.id::text))
    and (p_categoria is null or d.categoria = p_categoria)
  order by c.embedding <=> p_embedding
  limit p_k;
$function$
;

CREATE OR REPLACE FUNCTION public.chance_combate_preview(p_nivel_jogador integer, p_nivel_monstro integer)
 RETURNS jsonb
 LANGUAGE sql
 IMMUTABLE
AS $function$
  select jsonb_build_object(
    'chance_vitoria', greatest(5, least(95,
      (50 + (p_nivel_jogador - p_nivel_monstro) * 7)
      + (25 - greatest(0, (p_nivel_jogador - p_nivel_monstro) * 2)) * 0.7
    )),
    'dif', p_nivel_jogador - p_nivel_monstro
  );
$function$
;

CREATE OR REPLACE FUNCTION public.chocar_ovo(p_inventario_ovo_id bigint)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_personagem text;
  v_prof text;
  v_inv inventario%rowtype;
  v_ovo ovos_catalogo%rowtype;
  v_ferramenta_nivel int;
  v_tempo_horas int;
  v_mult numeric;
  v_choca_em timestamptz;
  v_novo_cd_id bigint;
  v_resp jsonb;
begin
  select nome, profissao into v_personagem, v_prof from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  select * into v_inv from inventario
    where id = p_inventario_ovo_id and personagem_nome = v_personagem
      and tipo = 'ovo' and not excluido;
  if not found then return '{"erro":"ovo nao encontrado no seu inventario"}'; end if;

  select * into v_ovo from ovos_catalogo
    where id = v_inv.item_id and visivel=true and excluido=false;
  if not found then
    -- fallback: usa defaults se ovo não está no catálogo
    v_ovo.id := v_inv.item_id;
    v_ovo.nome := coalesce(v_inv.nome, v_inv.item_id);
    v_ovo.raridade := 'comum';
    v_ovo.tempo_chocagem_horas := 12;
    v_ovo.incubadora_min := 1;
    v_ovo.efeitos_padrao := '{}';
  end if;

  -- verifica incubadora mínima: se for Domador, usa maior nível de ferramenta que ele tiver
  v_ferramenta_nivel := 1;
  if v_prof = 'Domador' then
    select coalesce(max(f.nivel_ferramenta), 1) into v_ferramenta_nivel
      from personagem_ferramentas pf
      join ferramentas_oficio f on f.id = pf.ferramenta_id
      where pf.personagem_nome = v_personagem and f.profissao = 'Domador';
  end if;
  if v_ferramenta_nivel < v_ovo.incubadora_min then
    return format('{"erro":"precisa incubadora nivel %s (voce tem %s)"}',
                  v_ovo.incubadora_min, v_ferramenta_nivel);
  end if;

  -- aceleração: cada nível de incubadora ACIMA do mínimo = -10% no tempo
  -- mínimo garantido: 25% do tempo original (nunca mais rápido que isso)
  v_mult := 1.0 - (0.10 * (v_ferramenta_nivel - v_ovo.incubadora_min));
  if v_mult < 0.25 then v_mult := 0.25; end if;
  v_tempo_horas := ceil(v_ovo.tempo_chocagem_horas * v_mult)::int;
  v_choca_em := now() + (v_tempo_horas || ' hours')::interval;

  -- remove ovo do inventário (exclusão lógica)
  update inventario set excluido = true where id = v_inv.id;

  -- cria entrada em criaturas_domadas
  insert into criaturas_domadas
    (personagem_nome, especie, monstro_id, nome_pet, raridade, status,
     incubadora_nivel, efeitos, choca_em, obtido_em)
    values (v_personagem, v_ovo.especie, v_ovo.monstro_id,
            'Filhote de ' || coalesce(v_ovo.nome, v_ovo.id),
            case v_ovo.raridade
              when 'comum' then 'Comum' when 'incomum' then 'Incomum'
              when 'raro' then 'Raro' when 'epico' then 'Épico' else 'Comum' end,
            'incubando', v_ferramenta_nivel, v_ovo.efeitos_padrao, v_choca_em, now())
  returning id into v_novo_cd_id;

  insert into transacoes (de_personagem, para_personagem, tipo, valor, item_id, observacao)
    values (null, v_personagem, 'craft', 0, v_ovo.id,
            format('chocar_ovo %s (tempo=%sh)', v_ovo.id, v_tempo_horas));

  v_resp := jsonb_build_object(
    'criatura_domada_id', v_novo_cd_id,
    'ovo_id', v_ovo.id,
    'ovo_nome', v_ovo.nome,
    'raridade', v_ovo.raridade,
    'incubadora_nivel_usada', v_ferramenta_nivel,
    'tempo_horas_original', v_ovo.tempo_chocagem_horas,
    'tempo_horas_acelerado', v_tempo_horas,
    'choca_em', to_char(v_choca_em, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'),
    'efeitos', v_ovo.efeitos_padrao
  );
  return v_resp::text;
end $function$
;

CREATE OR REPLACE FUNCTION public.combater_monstro(p_monstro_id text)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_personagem text;
  v_m monstros%rowtype;
  v_nivel_jog int;
  v_nivel_monstro int;
  v_custo_folego int;
  v_dif int;
  v_mod int;
  v_dados int[];
  v_soma int;
  v_resultado text;
  v_vida_perdida int;
  v_xp_ganho int;
  v_col_ganho int;
  v_drop jsonb;
  v_drop_item text;
  v_drop_nome text;
  v_drop_qtd int;
  v_drop_inv_id bigint;
  v_vida_nova int;
  v_resp jsonb;
  v_arma_atributo text;
  v_bonus_fraqueza int := 0;
begin
  select nome into v_personagem from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  select * into v_m from monstros where id = p_monstro_id and visivel=true and excluido=false;
  if not found then return '{"erro":"monstro invalido"}'; end if;

  select vida_atual into v_vida_nova from personagens where nome = v_personagem;
  if v_vida_nova <= 0 then
    return '{"erro":"sem vida — cure na Estalagem antes de lutar de novo"}';
  end if;

  v_nivel_monstro := coalesce(nullif(substring(v_m.nivel_recomendado from '\d+'), '')::int, 1);
  v_custo_folego := greatest(1, ceil(v_nivel_monstro / 3.0)::int);

  if not exists (select 1 from personagens where nome = v_personagem and folego >= v_custo_folego) then
    return format('{"erro":"folego insuficiente: precisa %s"}', v_custo_folego);
  end if;

  select coalesce(max(nivel), 1) into v_nivel_jog from nivel_profissao where personagem_nome = v_personagem;

  update personagens set folego = folego - v_custo_folego, updated_at = now() where nome = v_personagem;

  v_dif := v_nivel_jog - v_nivel_monstro;
  v_mod := case when v_dif >= 2 then 3 when v_dif = 1 then 1 when v_dif = 0 then 0 when v_dif = -1 then -1 else -3 end;

  -- bônus de fraqueza (item 12, decisão do usuário: FIXO) — leva arma cujo
  -- atributo bate a fraqueza do monstro. Só dá pra calcular agora que
  -- monstros.atributo_fraqueza está populado (migração rodada 10/08).
  if v_m.atributo_fraqueza is not null then
    select a.atributo into v_arma_atributo from personagens p
      join armas a on a.id = p.arma where p.nome = v_personagem;
    if v_arma_atributo = v_m.atributo_fraqueza then
      v_bonus_fraqueza := 1;
      v_mod := v_mod + v_bonus_fraqueza;
    end if;
  end if;

  v_dados := array[(1 + floor(random()*6))::int, (1 + floor(random()*6))::int];
  v_soma := v_dados[1] + v_dados[2] + v_mod;

  if v_soma >= 10 then
    v_resultado := 'sucesso_total'; v_vida_perdida := 0;
    v_xp_ganho := 10 + v_nivel_monstro * 4;
    v_col_ganho := 5 + v_nivel_monstro * 3;
  elsif v_soma >= 7 then
    v_resultado := 'sucesso_parcial'; v_vida_perdida := 3 + v_nivel_monstro;
    v_xp_ganho := (10 + v_nivel_monstro * 4) / 2;
    v_col_ganho := (5 + v_nivel_monstro * 3) / 2;
  else
    v_resultado := 'falha'; v_vida_perdida := 8 + v_nivel_monstro * 2;
    v_xp_ganho := 0; v_col_ganho := 0;
  end if;

  if v_vida_perdida > 0 then
    update personagens set vida_atual = greatest(0, vida_atual - v_vida_perdida), vida_atualizada_em = now()
      where nome = v_personagem
      returning vida_atual into v_vida_nova;
  else
    select vida_atual into v_vida_nova from personagens where nome = v_personagem;
  end if;

  if v_xp_ganho > 0 then
    if not exists (select 1 from personagens p where p.nome = v_personagem) then null; end if;
    declare v_prof text; v_xp_novo int; v_prox int; v_subiu boolean; v_nv int; begin
      select profissao into v_prof from personagens where nome = v_personagem;
      v_prof := coalesce(v_prof, 'Aventureiro');
      if not exists (select 1 from nivel_profissao where personagem_nome=v_personagem and profissao=v_prof) then
        insert into nivel_profissao (personagem_nome, profissao, nivel, xp) values (v_personagem, v_prof, 1, 0);
      end if;
      update nivel_profissao set xp = xp + v_xp_ganho, updated_at = now()
        where personagem_nome=v_personagem and profissao=v_prof returning xp into v_xp_novo;
      <<sobe>> loop
        v_subiu := false;
        select nivel into v_nv from nivel_profissao where personagem_nome=v_personagem and profissao=v_prof;
        select xp_necessario into v_prox from nivel_profissao_xp where nivel = v_nv + 1;
        exit sobe when v_prox is null;
        if v_xp_novo >= v_prox then
          update nivel_profissao set nivel=nivel+1, xp=xp-v_prox, updated_at=now()
            where personagem_nome=v_personagem and profissao=v_prof returning xp into v_xp_novo;
          v_subiu := true;
        end if;
        exit sobe when not v_subiu;
      end loop sobe;
    end;
  end if;

  if v_col_ganho > 0 then
    update personagens set col_mao = col_mao + v_col_ganho, updated_at = now() where nome = v_personagem;
    insert into transacoes (de_personagem, para_personagem, tipo, valor, item_id, observacao)
      values (null, v_personagem, 'combate', v_col_ganho, p_monstro_id, format('combate %s (%s)', v_m.nome, v_resultado));
  end if;

  -- drop: usa monstros.drops jsonb (já tem qtd/item/chance por entrada) —
  -- só em sucesso (total ou parcial), rola cada entrada pela própria chance.
  if v_resultado <> 'falha' and v_m.drops is not null then
    for v_drop in select * from jsonb_array_elements(v_m.drops) loop
      -- monstros.drops->>'chance' e' texto livre ("70%", "100% (Last Attack)",
      -- "só se efetivamente cercado" sem número nenhum) — extrai o primeiro
      -- número e trata como percentual; sem número achável, usa 30% default.
      if random() < coalesce(nullif(substring(v_drop->>'chance' from '\d+\.?\d*'), '')::numeric / 100.0, 0.3) then
        v_drop_nome := v_drop->>'item';
        v_drop_qtd := coalesce(nullif(substring(v_drop->>'qtd' from '\d+'), '')::int, 1);
        v_drop_item := coalesce('mat_' || lower(regexp_replace(v_drop_nome, '[^a-zA-Z0-9]+', '_', 'g')), v_drop_nome);
        insert into inventario (personagem_nome, item_id, nome, tipo, quantidade, origem)
          values (v_personagem, v_drop_item, v_drop_nome, 'material', v_drop_qtd, 'combate')
          returning id into v_drop_inv_id;
        exit; -- só o primeiro drop que rolar, pra nao chover item por clique
      end if;
    end loop;
  end if;

  insert into combate_log (personagem_nome, monstro_id, monstro_nome, resultado, dados, vida_perdida, xp_ganho, col_ganho, folego_gasto, drop_item_id, drop_inventario_id)
    values (v_personagem, p_monstro_id, v_m.nome, v_resultado, v_dados, v_vida_perdida, v_xp_ganho, v_col_ganho, v_custo_folego, v_drop_item, v_drop_inv_id);

  v_resp := jsonb_build_object(
    'resultado', v_resultado, 'dados', v_dados, 'soma_com_mod', v_soma,
    'monstro_nome', v_m.nome, 'vida_perdida', v_vida_perdida, 'vida_atual', v_vida_nova, 'vida_max', (select vida_max from personagens where nome=v_personagem),
    'xp_ganho', v_xp_ganho, 'col_ganho', v_col_ganho, 'folego_gasto', v_custo_folego,
    'drop_item', v_drop_nome, 'derrotado', (v_vida_nova <= 0), 'bonus_fraqueza', v_bonus_fraqueza
  );
  return v_resp::text;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.comprar_da_vitrine(p_vitrine_id bigint)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v vitrine%rowtype;
  v_comprador text;
  v_item inventario%rowtype;
  v_col int;
begin
  select nome into v_comprador from personagens where dono_id = auth.uid();
  if v_comprador is null then return 'sem personagem'; end if;
  select * into v from vitrine where id = p_vitrine_id and not vendido;
  if not found then return 'oferta nao existe mais'; end if;
  if v.vendedor_nome = v_comprador then return 'nao da pra comprar de voce mesmo'; end if;
  select * into v_item from inventario where id = v.inventario_id;
  if not found then return 'item sumiu'; end if;
  select col_mao into v_col from personagens where nome = v_comprador;
  if v_col < v.preco_col then return 'Col insuficiente na mao'; end if;

  update personagens set col_mao = col_mao - v.preco_col, updated_at = now()
    where nome = v_comprador;
  update personagens set col_mao = col_mao + v.preco_col, updated_at = now()
    where nome = v.vendedor_nome;
  update inventario set personagem_nome = v_comprador, origem = 'compra'
    where id = v.inventario_id;
  update vitrine set vendido = true, comprador_nome = v_comprador, vendido_em = now()
    where id = v.id;
  insert into transacoes (de_personagem, para_personagem, tipo, valor, item_id, observacao)
    values (v_comprador, v.vendedor_nome, 'compra', v.preco_col, v_item.item_id,
            'vitrine #' || v.id);
  return null;
end $function$
;

CREATE OR REPLACE FUNCTION public.comprar_folego(p_qtd integer)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_personagem text;
  v_col_mao int;
  v_folego_atual int;
  v_preco_por int;
  v_preco int;
  v_qtd_real int;
  v_resp jsonb;
begin
  select nome, col_mao, folego into v_personagem, v_col_mao, v_folego_atual
    from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  -- limita qtd máxima (não deixa passar de 20)
  v_qtd_real := least(p_qtd, 20 - coalesce(v_folego_atual, 0));
  if v_qtd_real <= 0 then
    return format('{"erro":"folego ja esta cheio (voce tem %s/20)"}', coalesce(v_folego_atual, 0));
  end if;

  -- tabela de preço fixa (3 faixas: 1un = 5Col, 5un = 6Col/un, 20un = 7.5Col/un)
  -- mestre pode mudar depois colocando em sistema.campo_json
  if v_qtd_real <= 1 then v_preco_por := 5;
  elsif v_qtd_real <= 5 then v_preco_por := 6;
  else v_preco_por := 7; end if;
  v_preco := v_qtd_real * v_preco_por;

  if v_col_mao < v_preco then
    return format('{"erro":"col insuficiente: precisa %s (tem %s). preco por unidade = %s Col"}', v_preco, v_col_mao, v_preco_por);
  end if;

  update personagens
     set col_mao = col_mao - v_preco,
         folego = folego + v_qtd_real,
         updated_at = now()
   where nome = v_personagem;

  insert into transacoes (de_personagem, para_personagem, tipo, valor, observacao)
    values (v_personagem, null, 'estalagem', v_preco,
            format('comprou +%s folego por %s Col (preco_un=%s)', v_qtd_real, v_preco, v_preco_por));

  v_resp := jsonb_build_object(
    'ok', true,
    'folego_gasto_col', v_preco,
    'folego_ganho_qtd', v_qtd_real,
    'preco_unidade', v_preco_por,
    'folego_agora', coalesce(v_folego_atual, 0) + v_qtd_real
  );
  return v_resp::text;
end $function$
;

CREATE OR REPLACE FUNCTION public.craftar_ferramenta(p_receita_id text)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_personagem text;
  v_nivel int;
  v_xp_atual int;
  v_rec receitas%rowtype;
  v_mats jsonb;
  v_mat_elem jsonb;
  v_mat_id text;
  v_mat_qtd int;
  v_tem int;
  v_dados int[];
  v_soma int;
  v_mod int;
  v_dif int;
  v_resultado text;
  v_xp_ganho int;
  v_folego_gasto int;
  v_perda_mat numeric;
  v_consumiu int;
  v_ja_consumidos text[];
  v_novo_nivel int;
  v_resp jsonb;
  v_materiais_usados jsonb[];
  v_ferramenta_danificada boolean := false;
  v_bonus_ferramenta int := 0;
begin
  select nome into v_personagem from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  select * into v_rec from receitas where id = p_receita_id and visivel=true and excluido=false;
  if not found then return '{"erro":"receita invalida"}'; end if;
  if v_rec.tipo <> 'ferramenta' then return '{"erro":"use craftar_item para itens"}'; end if;

  -- se for estágio 2 de refino, precisa ter o estágio 1 já craftado
  if v_rec.receita_refino and v_rec.receita_estagio = 2 then
    if v_rec.receita_antecessora_id is not null then
      if not exists (select 1 from personagem_ferramentas
                      where personagem_nome = v_personagem
                        and ferramenta_id = v_rec.receita_antecessora_id) then
        return format('{"erro":"precisa craftar %s (estagio 1) antes"}', v_rec.receita_antecessora_id);
      end if;
    end if;
  end if;

  select nivel, xp into v_nivel, v_xp_atual
    from nivel_profissao where personagem_nome = v_personagem and profissao = v_rec.profissao;
  if v_nivel is null then v_nivel := 1; v_xp_atual := 0; end if;

  if v_nivel < v_rec.nivel_receita then
    return format('{"erro":"nivel profissao %s necessita %s (voce=%s)"}', v_rec.profissao, v_rec.nivel_receita, v_nivel);
  end if;

  if not exists (select 1 from personagens where nome = v_personagem and folego >= v_rec.folego_custo) then
    return format('{"erro":"folego insuficiente: precisa %s"}', v_rec.folego_custo);
  end if;

  -- item 16 parte 1: ferramenta obrigatoria, so trava quando a receita
  -- apontar pra uma (a maioria ainda nao tem, sem mudanca de comportamento).
  if v_rec.requer_ferramenta_id is not null then
    if not exists (select 1 from personagem_ferramentas where personagem_nome = v_personagem and ferramenta_id = v_rec.requer_ferramenta_id) then
      return (select format('{"erro":"precisa da ferramenta: %s"}', nome) from ferramentas_oficio where id = v_rec.requer_ferramenta_id);
    end if;
  end if;

  v_mats := v_rec.materiais;
  for v_mat_elem in select * from jsonb_array_elements(v_mats) loop
    v_mat_id := v_mat_elem->>'mat_id';
    v_mat_qtd := (v_mat_elem->>'qtd')::int;
    select coalesce(sum(quantidade),0) into v_tem
      from inventario where personagem_nome = v_personagem
        and tipo='material' and item_id = v_mat_id and not excluido;
    if v_tem < v_mat_qtd then
      return format('{"erro":"material %s faltando: tem %s precisa %s"}', v_mat_id, v_tem, v_mat_qtd);
    end if;
  end loop;

  update personagens set folego = folego - v_rec.folego_custo, updated_at = now()
    where nome = v_personagem;
  v_folego_gasto := v_rec.folego_custo;

  v_dif := v_nivel - v_rec.nivel_receita;
  v_mod := case
    when v_dif >= 2 then 3
    when v_dif = 1  then 1
    when v_dif = 0  then 0
    when v_dif = -1 then -1
    else -3
  end + coalesce(v_rec.dificuldade_mod, 0);

  -- item 14 do dolist: ferramenta de oficio da bonus de sucesso real (nao so
  -- "colecionavel"). Pega o maior bonus_acao entre as ferramentas que o
  -- personagem possui pra essa profissao.
  select coalesce(max(f.bonus_acao), 0) into v_bonus_ferramenta
    from personagem_ferramentas pf join ferramentas_oficio f on f.id = pf.ferramenta_id
    where pf.personagem_nome = v_personagem and f.profissao = v_rec.profissao;
  v_mod := v_mod + v_bonus_ferramenta;

  v_dados := array[(1 + floor(random()*6))::int, (1 + floor(random()*6))::int];
  v_soma := v_dados[1] + v_dados[2] + v_mod;

  if v_soma >= 10 then
    v_resultado := 'sucesso_total';
    v_xp_ganho := v_rec.xp_recompensa;
    v_perda_mat := 0.0;
  elsif v_soma >= 7 then
    v_resultado := 'sucesso_parcial';
    v_xp_ganho := (v_rec.xp_recompensa * 0.75)::int;
    v_perda_mat := 0.15;
    if random() < 0.05 then v_ferramenta_danificada := true; end if;
  else
    v_resultado := 'falha';
    v_xp_ganho := (v_rec.xp_recompensa * 0.15)::int;
    v_perda_mat := 0.45;
    if random() < 0.15 then v_ferramenta_danificada := true; end if;
  end if;

  v_materiais_usados := array[]::jsonb[];
  v_ja_consumidos := array[]::text[];
  for v_mat_elem in select * from jsonb_array_elements(v_mats) loop
    v_mat_id := v_mat_elem->>'mat_id';
    if v_mat_id = any(v_ja_consumidos) then continue; end if;
    v_ja_consumidos := array_append(v_ja_consumidos, v_mat_id);
    v_mat_qtd := 0;
    for v_mat_elem in select * from jsonb_array_elements(v_mats) loop
      if v_mat_elem->>'mat_id' = v_mat_id then
        v_mat_qtd := v_mat_qtd + (v_mat_elem->>'qtd')::int;
      end if;
    end loop;
    if v_resultado = 'sucesso_total' then
      v_consumiu := v_mat_qtd;
    else
      v_consumiu := ceil(v_mat_qtd * (1.0 + v_perda_mat))::int;
    end if;
    declare
      v_restante int := v_consumiu;
      v_cur cursor for select id, quantidade from inventario
        where personagem_nome = v_personagem and tipo='material' and item_id = v_mat_id
          and not excluido order by id for update;
      v_linha record;
      v_tirar int;
    begin
      open v_cur;
      loop
        fetch v_cur into v_linha;
        exit when not found or v_restante <= 0;
        v_tirar := least(v_linha.quantidade, v_restante);
        if v_tirar = v_linha.quantidade then
          update inventario set excluido = true where id = v_linha.id;
        else
          update inventario set quantidade = quantidade - v_tirar where id = v_linha.id;
        end if;
        v_restante := v_restante - v_tirar;
      end loop;
      close v_cur;
    end;
    v_materiais_usados := array_append(v_materiais_usados,
      jsonb_build_object('mat_id', v_mat_id, 'qtd_usada', v_consumiu));
  end loop;

  -- resultado: sucesso/parcial = upsert em personagem_ferramentas
  if v_resultado <> 'falha' then
    insert into personagem_ferramentas
      (personagem_nome, ferramenta_id, obtido_em, updated_at)
      values (v_personagem, v_rec.id, now(), now())
    on conflict (personagem_nome, ferramenta_id) do update
      set updated_at = now();
    -- refino estágio 2: exclui a antecessora (estágio 1 foi substituído)
    if v_rec.receita_refino and v_rec.receita_estagio = 2 and v_rec.receita_antecessora_id is not null then
      delete from personagem_ferramentas
        where personagem_nome = v_personagem and ferramenta_id = v_rec.receita_antecessora_id;
    end if;
  end if;

  v_novo_nivel := null;
  if v_xp_ganho > 0 then
    declare
      v_xp_novo int;
      v_prox_xp int;
      v_subiu boolean;
    begin
      if not exists (select 1 from nivel_profissao
                      where personagem_nome = v_personagem and profissao = v_rec.profissao) then
        insert into nivel_profissao (personagem_nome, profissao, nivel, xp)
          values (v_personagem, v_rec.profissao, 1, 0);
      end if;
      update nivel_profissao
         set xp = xp + v_xp_ganho, updated_at = now()
       where personagem_nome = v_personagem and profissao = v_rec.profissao
       returning xp into v_xp_novo;
      <<sobe>> loop
        v_subiu := false;
        select nivel into v_nivel from nivel_profissao
          where personagem_nome = v_personagem and profissao = v_rec.profissao;
        select xp_necessario into v_prox_xp from nivel_profissao_xp
          where nivel = v_nivel + 1;
        exit sobe when v_prox_xp is null;
        if v_xp_novo >= v_prox_xp then
          update nivel_profissao
             set nivel = nivel + 1, xp = xp - v_prox_xp, updated_at = now()
           where personagem_nome = v_personagem and profissao = v_rec.profissao
           returning xp into v_xp_novo;
          v_subiu := true;
          v_novo_nivel := coalesce(v_novo_nivel, v_nivel + 1);
        end if;
        exit sobe when not v_subiu;
      end loop sobe;
    end;
  end if;

  insert into transacoes (de_personagem, para_personagem, tipo, valor, item_id, observacao)
    values (null, v_personagem, 'craft', 0, v_rec.id,
            format('craft_ferramenta %s %s (xp=%s soma=%s)', v_rec.id, v_resultado, v_xp_ganho, v_soma));

  v_resp := jsonb_build_object(
    'resultado', v_resultado,
    'dados', v_dados,
    'soma_com_mod', v_soma,
    'mod_pbta', v_mod, 'bonus_ferramenta', v_bonus_ferramenta,
    'xp', v_xp_ganho,
    'folego_gasto', v_folego_gasto,
    'materiais_consumidos', to_jsonb(v_materiais_usados),
    'ferramenta_id', v_rec.id,
    'ferramenta_nome', v_rec.nome_resultado,
    'ferramenta_raridade', v_rec.resultado_raridade,
    'novo_nivel_profissao', v_novo_nivel,
    'ferramenta_danificada', v_ferramenta_danificada,
    'efeitos', v_rec.efeitos,
    'refino_substituiu_antecessora',
      (v_rec.receita_refino and v_rec.receita_estagio = 2)
  );
  return v_resp::text;
end $function$
;

CREATE OR REPLACE FUNCTION public.craftar_item(p_receita_id text)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_personagem text;
  v_prof text;
  v_nivel int;
  v_xp_atual int;
  v_rec receitas%rowtype;
  v_mats jsonb;
  v_mat_elem jsonb;
  v_mat_id text;
  v_mat_qtd int;
  v_tem int;
  v_inv_id bigint;
  v_dados int[];
  v_soma int;
  v_mod int;
  v_dif int;
  v_resultado text;
  v_xp_ganho int;
  v_folego_gasto int;
  v_perda_mat numeric;
  v_consumiu int;
  v_ja_consumidos text[];
  v_novo_nivel int;
  v_novo_item_inv_id bigint;
  v_resp jsonb;
  v_materiais_usados jsonb[];
  v_ferramenta_danificada boolean := false;
  v_bonus_ferramenta int := 0;
begin
  select nome, profissao into v_personagem, v_prof from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  select * into v_rec from receitas where id = p_receita_id and visivel=true and excluido=false;
  if not found then return '{"erro":"receita invalida"}'; end if;
  if v_rec.tipo <> 'item' then return '{"erro":"use craftar_ferramenta para ferramentas"}'; end if;

  select nivel, xp into v_nivel, v_xp_atual
    from nivel_profissao where personagem_nome = v_personagem and profissao = v_rec.profissao;
  if v_nivel is null then v_nivel := 1; v_xp_atual := 0; end if;

  if v_nivel < v_rec.nivel_receita then
    return format('{"erro":"nivel profissao %s necessita %s (voce=%s)"}', v_rec.profissao, v_rec.nivel_receita, v_nivel);
  end if;

  if not exists (select 1 from personagens where nome = v_personagem and folego >= v_rec.folego_custo) then
    return format('{"erro":"folego insuficiente: precisa %s"}', v_rec.folego_custo);
  end if;

  -- item 16 parte 1: ferramenta obrigatoria, so trava quando a receita
  -- apontar pra uma (a maioria ainda nao tem, sem mudanca de comportamento).
  if v_rec.requer_ferramenta_id is not null then
    if not exists (select 1 from personagem_ferramentas where personagem_nome = v_personagem and ferramenta_id = v_rec.requer_ferramenta_id) then
      return (select format('{"erro":"precisa da ferramenta: %s"}', nome) from ferramentas_oficio where id = v_rec.requer_ferramenta_id);
    end if;
  end if;

  -- PASSO 1: verificar TODOS os materiais necessários ANTES de consumir
  v_mats := v_rec.materiais;
  for v_mat_elem in select * from jsonb_array_elements(v_mats) loop
    v_mat_id := v_mat_elem->>'mat_id';
    v_mat_qtd := (v_mat_elem->>'qtd')::int;
    select coalesce(sum(quantidade),0) into v_tem
      from inventario where personagem_nome = v_personagem
        and tipo='material' and item_id = v_mat_id and not excluido;
    if v_tem < v_mat_qtd then
      return format('{"erro":"material %s faltando: tem %s precisa %s"}', v_mat_id, v_tem, v_mat_qtd);
    end if;
  end loop;

  -- PASSO 2: gastar fôlego
  update personagens set folego = folego - v_rec.folego_custo, updated_at = now()
    where nome = v_personagem;
  v_folego_gasto := v_rec.folego_custo;

  -- PASSO 3: calcular modificador PBTA (diferença nível personagem vs nível receita)
  -- + bônus de ferramenta de ofício se equipada
  v_dif := v_nivel - v_rec.nivel_receita;
  v_mod := case
    when v_dif >= 2 then 3
    when v_dif = 1  then 1
    when v_dif = 0  then 0
    when v_dif = -1 then -1
    else -3
  end + coalesce(v_rec.dificuldade_mod, 0);

  -- item 14 do dolist: ferramenta de oficio da bonus de sucesso real (nao so
  -- "colecionavel"). Pega o maior bonus_acao entre as ferramentas que o
  -- personagem possui pra essa profissao.
  select coalesce(max(f.bonus_acao), 0) into v_bonus_ferramenta
    from personagem_ferramentas pf join ferramentas_oficio f on f.id = pf.ferramenta_id
    where pf.personagem_nome = v_personagem and f.profissao = v_rec.profissao;
  v_mod := v_mod + v_bonus_ferramenta;

  -- PASSO 4: rolar 2d6
  v_dados := array[(1 + floor(random()*6))::int, (1 + floor(random()*6))::int];
  v_soma := v_dados[1] + v_dados[2] + v_mod;

  -- PASSO 5: aplicar resultado PBTA
  if v_soma >= 10 then
    v_resultado := 'sucesso_total';
    v_xp_ganho := v_rec.xp_recompensa;
    v_perda_mat := 0.0;
  elsif v_soma >= 7 then
    v_resultado := 'sucesso_parcial';
    v_xp_ganho := (v_rec.xp_recompensa * 0.7)::int;
    v_perda_mat := 0.2;
    if random() < 0.08 then v_ferramenta_danificada := true; end if;
  else
    v_resultado := 'falha';
    v_xp_ganho := (v_rec.xp_recompensa * 0.1)::int;
    v_perda_mat := 0.5;
    if random() < 0.2 then v_ferramenta_danificada := true; end if;
  end if;

  -- PASSO 6: consumir materiais (100% em sucesso; (1+perda)% em parcial/falha;
  --          arredonda pra cima: "mais risco = mais desperdício")
  v_materiais_usados := array[]::jsonb[];
  v_ja_consumidos := array[]::text[];
  for v_mat_elem in select * from jsonb_array_elements(v_mats) loop
    v_mat_id := v_mat_elem->>'mat_id';
    if v_mat_id = any(v_ja_consumidos) then continue; end if;
    v_ja_consumidos := array_append(v_ja_consumidos, v_mat_id);

    -- soma qtd total necessária DAS VEZES que esse material aparece
    v_mat_qtd := 0;
    for v_mat_elem in select * from jsonb_array_elements(v_mats) loop
      if v_mat_elem->>'mat_id' = v_mat_id then
        v_mat_qtd := v_mat_qtd + (v_mat_elem->>'qtd')::int;
      end if;
    end loop;

    if v_resultado = 'sucesso_total' then
      v_consumiu := v_mat_qtd;
    else
      v_consumiu := ceil(v_mat_qtd * (1.0 + v_perda_mat))::int;
    end if;

    -- consome por ordem de inventário (menores IDs primeiro)
    declare
      v_restante int := v_consumiu;
      v_cur cursor for select id, quantidade from inventario
        where personagem_nome = v_personagem and tipo='material' and item_id = v_mat_id
          and not excluido order by id for update;
      v_linha record;
      v_tirar int;
    begin
      open v_cur;
      loop
        fetch v_cur into v_linha;
        exit when not found or v_restante <= 0;
        v_tirar := least(v_linha.quantidade, v_restante);
        if v_tirar = v_linha.quantidade then
          update inventario set excluido = true where id = v_linha.id;
        else
          update inventario set quantidade = quantidade - v_tirar where id = v_linha.id;
        end if;
        v_restante := v_restante - v_tirar;
      end loop;
      close v_cur;
    end;

    v_materiais_usados := array_append(v_materiais_usados,
      jsonb_build_object('mat_id', v_mat_id, 'qtd_usada', v_consumiu));
  end loop;

  -- PASSO 7: sucesso/parcial = item vai pro inventário
  v_novo_item_inv_id := null;
  if v_resultado <> 'falha' then
    insert into inventario
      (personagem_nome, item_id, nome, tipo, quantidade, origem)
      values (v_personagem, v_rec.id, v_rec.nome_resultado, 'consumivel', 1, 'craft')
      returning id into v_novo_item_inv_id;
  end if;

  -- PASSO 8: XP + subir nível profissão
  v_novo_nivel := null;
  if v_xp_ganho > 0 then
    declare
      v_xp_novo int;
      v_prox_xp int;
      v_subiu boolean;
    begin
      if not exists (select 1 from nivel_profissao
                      where personagem_nome = v_personagem and profissao = v_rec.profissao) then
        insert into nivel_profissao (personagem_nome, profissao, nivel, xp)
          values (v_personagem, v_rec.profissao, 1, 0);
      end if;
      update nivel_profissao
         set xp = xp + v_xp_ganho, updated_at = now()
       where personagem_nome = v_personagem and profissao = v_rec.profissao
       returning xp into v_xp_novo;

      <<sobe>> loop
        v_subiu := false;
        select nivel into v_nivel from nivel_profissao
          where personagem_nome = v_personagem and profissao = v_rec.profissao;
        select xp_necessario into v_prox_xp from nivel_profissao_xp
          where nivel = v_nivel + 1;
        exit sobe when v_prox_xp is null;
        if v_xp_novo >= v_prox_xp then
          update nivel_profissao
             set nivel = nivel + 1, xp = xp - v_prox_xp, updated_at = now()
           where personagem_nome = v_personagem and profissao = v_rec.profissao
           returning xp into v_xp_novo;
          v_subiu := true;
          v_novo_nivel := coalesce(v_novo_nivel, v_nivel + 1);
        end if;
        exit sobe when not v_subiu;
      end loop sobe;
    end;
  end if;

  -- PASSO 9: log transação
  insert into transacoes (de_personagem, para_personagem, tipo, valor, item_id, observacao)
    values (null, v_personagem, 'craft', 0, v_rec.id,
            format('craft_item %s %s (xp=%s soma=%s)', v_rec.id, v_resultado, v_xp_ganho, v_soma));

  v_resp := jsonb_build_object(
    'resultado', v_resultado,
    'dados', v_dados,
    'soma_com_mod', v_soma,
    'mod_pbta', v_mod, 'bonus_ferramenta', v_bonus_ferramenta,
    'xp', v_xp_ganho,
    'folego_gasto', v_folego_gasto,
    'materiais_consumidos', to_jsonb(v_materiais_usados),
    'item_inventario_id', v_novo_item_inv_id,
    'item_nome', v_rec.nome_resultado,
    'item_raridade', v_rec.resultado_raridade,
    'novo_nivel_profissao', v_novo_nivel,
    'ferramenta_danificada', v_ferramenta_danificada,
    'efeitos', v_rec.efeitos
  );
  return v_resp::text;
end $function$
;

CREATE OR REPLACE FUNCTION public.criar_meta_global(p_titulo text, p_descricao text, p_meta_item text, p_meta_qtd integer, p_recompensa_col integer DEFAULT NULL::integer, p_recompensa_xp integer DEFAULT NULL::integer, p_recompensa_item text DEFAULT NULL::text, p_recompensa_reputacao_alvo_nome text DEFAULT NULL::text, p_recompensa_reputacao_valor integer DEFAULT NULL::integer)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare v_abertas int;
begin
  if not is_mestre() then return '{"erro":"só o mestre cria meta global"}'; end if;
  select count(*) into v_abertas from metas_globais where finalizada = false and excluido = false;
  if v_abertas >= 3 then return '{"erro":"máximo 3 metas abertas ao mesmo tempo"}'; end if;
  insert into metas_globais (titulo, descricao, meta_item, meta_qtd, recompensa_col, recompensa_xp,
      recompensa_item, recompensa_reputacao_alvo_nome, recompensa_reputacao_valor, criado_por)
    values (p_titulo, p_descricao, p_meta_item, p_meta_qtd, p_recompensa_col, p_recompensa_xp,
      p_recompensa_item, p_recompensa_reputacao_alvo_nome, p_recompensa_reputacao_valor, auth.uid());
  return '{"ok":true}';
end;
$function$
;

CREATE OR REPLACE FUNCTION public.criar_usuario_mestre(p_email text, p_senha text, p_nome text)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'auth', 'extensions'
AS $function$
declare
  v_uid uuid;
  v_existe uuid;
begin
  if not is_mestre() then
    raise exception 'só o mestre pode criar contas de jogador';
  end if;
  select id into v_existe from auth.users where email = lower(trim(p_email));
  if v_existe is not null then
    raise exception 'já existe uma conta com esse e-mail';
  end if;

  v_uid := gen_random_uuid();

  insert into auth.users (
    instance_id, id, aud, role, email, encrypted_password,
    email_confirmed_at, confirmation_token, recovery_token,
    raw_app_meta_data, raw_user_meta_data, created_at, updated_at
  ) values (
    '00000000-0000-0000-0000-000000000000', v_uid, 'authenticated', 'authenticated',
    lower(trim(p_email)), crypt(p_senha, gen_salt('bf')),
    now(), '', '',
    '{"provider":"email","providers":["email"]}'::jsonb,
    jsonb_build_object('nome', p_nome),
    now(), now()
  );

  -- "email" de auth.identities e' coluna gerada (a partir de identity_data
  -- ->> 'email'), nao entra na lista de insert.
  insert into auth.identities (
    id, provider_id, user_id, identity_data, provider,
    last_sign_in_at, created_at, updated_at
  ) values (
    gen_random_uuid(), v_uid::text, v_uid,
    jsonb_build_object('sub', v_uid::text, 'email', lower(trim(p_email)), 'email_verified', true),
    'email', now(), now(), now()
  );

  return json_build_object('uid', v_uid);
end;
$function$
;

CREATE OR REPLACE FUNCTION public.curar_estalagem()
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare v_personagem text; v_col int;
begin
  select nome, col_mao into v_personagem, v_col from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;
  if v_col < 10 then return '{"erro":"precisa de 10 Col"}'; end if;
  update personagens set col_mao = col_mao - 10, folego = 20, vida_atual = vida_max,
    vida_atualizada_em = now(), updated_at = now()
    where nome = v_personagem;
  insert into transacoes (de_personagem, para_personagem, tipo, valor, observacao)
    values (v_personagem, null, 'estalagem', 10, 'curou fôlego e vida na estalagem');
  return '{"ok":true,"folego":20,"vida":"cheia"}';
end;
$function$
;

CREATE OR REPLACE FUNCTION public.depositar_no_cla(p_inventario_id bigint)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare v_personagem text; v_cla text; v_it inventario%rowtype;
begin
  select nome, guilda into v_personagem, v_cla from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;
  if v_cla is null then return '{"erro":"você não tem clã"}'; end if;

  select * into v_it from inventario where id = p_inventario_id and personagem_nome = v_personagem and not excluido;
  if not found then return '{"erro":"item não encontrado"}'; end if;
  if v_it.equipado then return '{"erro":"desequipe antes de depositar"}'; end if;

  if v_it.quantidade <= 1 then update inventario set excluido = true where id = v_it.id;
  else update inventario set quantidade = quantidade - 1 where id = v_it.id; end if;

  -- inventario nao tem coluna "raridade" (fica nos catalogos armas/equipamentos/etc, nao na linha do jogador)
  insert into cla_inventario (cla_nome, item_id, nome, tipo, qtd, depositado_por)
    values (v_cla, v_it.item_id, v_it.nome, v_it.tipo, 1, v_personagem);
  return '{"ok":true}';
end;
$function$
;

CREATE OR REPLACE FUNCTION public.doar_para_meta(p_meta_id bigint, p_inventario_id bigint, p_qtd integer)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare v_personagem text; v_meta metas_globais%rowtype; v_it inventario%rowtype; v_novo_progresso int;
begin
  if p_qtd < 1 then return '{"erro":"quantidade tem que ser >= 1"}'; end if;
  select nome into v_personagem from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  select * into v_meta from metas_globais where id = p_meta_id and visivel and not excluido;
  if not found then return '{"erro":"meta não encontrada"}'; end if;
  if v_meta.finalizada then return '{"erro":"meta já concluída"}'; end if;

  select * into v_it from inventario where id = p_inventario_id and personagem_nome = v_personagem and not excluido;
  if not found then return '{"erro":"item não encontrado no seu inventário"}'; end if;
  if v_it.nome <> v_meta.meta_item and v_it.item_id <> v_meta.meta_item then
    return format('{"erro":"essa meta pede %s"}', v_meta.meta_item);
  end if;
  if v_it.quantidade < p_qtd then return format('{"erro":"tem só %s"}', v_it.quantidade); end if;

  if v_it.quantidade = p_qtd then update inventario set excluido = true where id = v_it.id;
  else update inventario set quantidade = quantidade - p_qtd where id = v_it.id; end if;

  insert into metas_doacoes (meta_id, personagem_nome, qtd_doada) values (p_meta_id, v_personagem, p_qtd);
  update metas_globais set progresso = least(meta_qtd, progresso + p_qtd) where id = p_meta_id
    returning progresso into v_novo_progresso;

  if v_novo_progresso >= v_meta.meta_qtd then
    perform premiar_meta(p_meta_id);
  end if;
  return format('{"ok":true,"progresso":%s,"meta_qtd":%s}', v_novo_progresso, v_meta.meta_qtd);
end;
$function$
;

CREATE OR REPLACE FUNCTION public.e_dono_personagem(p_personagem_nome text)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select exists(select 1 from personagens where nome = p_personagem_nome and dono_id = auth.uid());
$function$
;

CREATE OR REPLACE FUNCTION public.enviar_col(p_destinatario text, p_valor integer)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare v_remetente text; v_col_mao int;
begin
  if p_valor <= 0 then return '{"erro":"valor tem que ser positivo"}'; end if;
  select nome, col_mao into v_remetente, v_col_mao from personagens where dono_id = auth.uid();
  if v_remetente is null then return '{"erro":"sem personagem"}'; end if;
  if v_remetente = p_destinatario then return '{"erro":"não dá pra enviar pra si mesmo"}'; end if;
  if not exists (select 1 from personagens where nome = p_destinatario and excluido = false) then
    return '{"erro":"destinatário não existe"}';
  end if;
  if v_col_mao < p_valor then return format('{"erro":"col insuficiente: tem %s, precisa %s"}', v_col_mao, p_valor); end if;

  update personagens set col_mao = col_mao - p_valor, updated_at = now() where nome = v_remetente;
  update personagens set col_mao = col_mao + p_valor, updated_at = now() where nome = p_destinatario;
  insert into transacoes (de_personagem, para_personagem, tipo, valor, observacao)
    values (v_remetente, p_destinatario, 'transferencia', p_valor, 'envio P2P de Col');
  return format('{"ok":true,"mensagem":"Enviado %s Col para %s"}', p_valor, p_destinatario);
end;
$function$
;

CREATE OR REPLACE FUNCTION public.enviar_item(p_destinatario text, p_inventario_id bigint, p_qtd integer)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare v_remetente text; v_it inventario%rowtype;
begin
  if p_qtd < 1 then return '{"erro":"quantidade tem que ser >= 1"}'; end if;
  select nome into v_remetente from personagens where dono_id = auth.uid();
  if v_remetente is null then return '{"erro":"sem personagem"}'; end if;
  if v_remetente = p_destinatario then return '{"erro":"não dá pra enviar pra si mesmo"}'; end if;
  if not exists (select 1 from personagens where nome = p_destinatario and excluido = false) then
    return '{"erro":"destinatário não existe"}';
  end if;

  select * into v_it from inventario where id = p_inventario_id and personagem_nome = v_remetente and not excluido;
  if not found then return '{"erro":"item não encontrado no seu inventário"}'; end if;
  if v_it.equipado then return '{"erro":"desequipe o item antes de enviar"}'; end if;
  if v_it.quantidade < p_qtd then return format('{"erro":"tem só %s, tentou enviar %s"}', v_it.quantidade, p_qtd); end if;

  if v_it.quantidade = p_qtd then
    update inventario set excluido = true where id = v_it.id;
  else
    update inventario set quantidade = quantidade - p_qtd where id = v_it.id;
  end if;
  insert into inventario (personagem_nome, item_id, nome, tipo, quantidade, slot, cristal_id, origem)
    values (p_destinatario, v_it.item_id, v_it.nome, v_it.tipo, p_qtd, null, v_it.cristal_id, 'envio');
  insert into transacoes (de_personagem, para_personagem, tipo, valor, item_id, observacao)
    values (v_remetente, p_destinatario, 'transferencia', p_qtd, v_it.item_id, format('envio de item: %s x%s', v_it.nome, p_qtd));
  return format('{"ok":true,"mensagem":"Enviado %s x%s para %s"}', v_it.nome, p_qtd, p_destinatario);
end;
$function$
;

CREATE OR REPLACE FUNCTION public.is_mestre()
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select exists(select 1 from perfis where id = auth.uid() and papel = 'mestre');
$function$
;

CREATE OR REPLACE FUNCTION public.limpar_anuncios_expirados()
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_cont int := 0;
  r record;
begin
  for r in select * from vitrine where not vendido and expira_em < now() loop
    delete from vitrine where id = r.id;
    v_cont := v_cont + 1;
  end loop;
  return v_cont;
end $function$
;

CREATE OR REPLACE FUNCTION public.mestre_ajustar_reputacao(p_personagem_nome text, p_alvo_nome text, p_delta integer, p_alvo_tipo text DEFAULT 'outro'::text, p_motivo text DEFAULT NULL::text)
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  if not is_mestre() then
    raise exception 'só o mestre ajusta reputação diretamente';
  end if;
  return _ajustar_reputacao_interna(p_personagem_nome, p_alvo_nome, p_delta, p_alvo_tipo, p_motivo);
end;
$function$
;

CREATE OR REPLACE FUNCTION public.mover_inventario(p_inventario_id bigint, p_para text)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare v_personagem text; v_it inventario%rowtype;
begin
  if p_para not in ('mochila', 'stash') then return '{"erro":"destino invalido"}'; end if;
  select nome into v_personagem from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  select * into v_it from inventario where id = p_inventario_id and personagem_nome = v_personagem and not excluido;
  if not found then return '{"erro":"item nao encontrado"}'; end if;
  if v_it.equipado and p_para = 'stash' then return '{"erro":"desequipe antes de guardar no bau"}'; end if;

  update inventario set local = p_para where id = p_inventario_id;
  return '{"ok":true}';
end;
$function$
;

CREATE OR REPLACE FUNCTION public.pode_ver(p_tabela text, p_registro_id text)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select exists(
    select 1 from conteudo_liberado
    where jogador_id = auth.uid() and tabela = p_tabela and registro_id = p_registro_id
  );
$function$
;

CREATE OR REPLACE FUNCTION public.premiar_meta(p_meta_id bigint)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare v_meta metas_globais%rowtype; v_doador record;
begin
  select * into v_meta from metas_globais where id = p_meta_id;
  if not found or v_meta.finalizada then return '{"erro":"nada a premiar"}'; end if;

  for v_doador in select distinct personagem_nome from metas_doacoes where meta_id = p_meta_id loop
    if v_meta.recompensa_col > 0 then
      update personagens set col_mao = col_mao + v_meta.recompensa_col, updated_at = now() where nome = v_doador.personagem_nome;
      insert into transacoes (de_personagem, para_personagem, tipo, valor, observacao)
        values (null, v_doador.personagem_nome, 'meta_global', v_meta.recompensa_col, 'recompensa meta: ' || v_meta.titulo);
    end if;
    if v_meta.recompensa_xp > 0 then
      declare v_prof text; begin
        select profissao into v_prof from personagens where nome = v_doador.personagem_nome;
        v_prof := coalesce(v_prof, 'Aventureiro');
        if not exists (select 1 from nivel_profissao where personagem_nome = v_doador.personagem_nome and profissao = v_prof) then
          insert into nivel_profissao (personagem_nome, profissao, nivel, xp) values (v_doador.personagem_nome, v_prof, 1, 0);
        end if;
        update nivel_profissao set xp = xp + v_meta.recompensa_xp, updated_at = now()
          where personagem_nome = v_doador.personagem_nome and profissao = v_prof;
      end;
    end if;
    if v_meta.recompensa_item is not null then
      insert into inventario (personagem_nome, item_id, nome, tipo, quantidade, origem)
        values (v_doador.personagem_nome, v_meta.recompensa_item, v_meta.recompensa_item, 'material', 1, 'meta_global');
    end if;
    if v_meta.recompensa_reputacao_alvo_nome is not null and coalesce(v_meta.recompensa_reputacao_valor,0) <> 0 then
      perform _ajustar_reputacao_interna(v_doador.personagem_nome, v_meta.recompensa_reputacao_alvo_nome,
        v_meta.recompensa_reputacao_valor, 'outro', 'recompensa meta: ' || v_meta.titulo);
    end if;
  end loop;

  update metas_globais set finalizada = true, finalizada_em = now() where id = p_meta_id;
  return '{"ok":true}';
end;
$function$
;

CREATE OR REPLACE FUNCTION public.publicar_anuncio(p_inventario_id bigint, p_preco integer)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_item inventario%rowtype;
  v_dono text;
  v_vid bigint;
begin
  if p_preco is null or p_preco <= 0 then return 'preco invalido'; end if;
  select nome into v_dono from personagens where dono_id = auth.uid();
  if v_dono is null then return 'sem personagem'; end if;
  select * into v_item from inventario where id = p_inventario_id;
  if not found then return 'item nao existe'; end if;
  if v_item.personagem_nome <> v_dono then return 'nao e seu item'; end if;
  if v_item.equipado then return 'item equipado, desequipue antes'; end if;
  insert into vitrine (vendedor_nome, inventario_id, preco_col)
    values (v_dono, p_inventario_id, p_preco) returning id into v_vid;
  return v_vid::text;
end $function$
;

CREATE OR REPLACE FUNCTION public.remover_anuncio(p_vitrine_id bigint)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v vitrine%rowtype;
  v_dono text;
begin
  select nome into v_dono from personagens where dono_id = auth.uid();
  select * into v from vitrine where id = p_vitrine_id;
  if not found then return 'oferta nao existe'; end if;
  if v.vendido then return 'oferta ja vendida'; end if;
  if v.vendedor_nome <> v_dono and not is_mestre() then return 'nao e sua oferta'; end if;
  delete from vitrine where id = v.id;
  return null;
end $function$
;

CREATE OR REPLACE FUNCTION public.resetar_senha_usuario(p_email text, p_nova_senha text)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'auth', 'extensions'
AS $function$
declare
  v_uid uuid;
begin
  if not is_mestre() then
    raise exception 'só o mestre pode resetar senha de jogador';
  end if;

  select id into v_uid from auth.users where email = lower(trim(p_email));
  if v_uid is null then
    raise exception 'nenhuma conta com esse e-mail';
  end if;

  update auth.users
    set encrypted_password = crypt(p_nova_senha, gen_salt('bf')), updated_at = now()
    where id = v_uid;

  return json_build_object('uid', v_uid);
end;
$function$
;

CREATE OR REPLACE FUNCTION public.retirar_do_cla(p_cla_inventario_id bigint)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare v_personagem text; v_cla text; v_cargo text; v_it cla_inventario%rowtype;
begin
  select nome, guilda into v_personagem, v_cla from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  select * into v_it from cla_inventario where id = p_cla_inventario_id and not excluido;
  if not found then return '{"erro":"item não encontrado no baú"}'; end if;
  if v_it.cla_nome <> v_cla then return '{"erro":"esse baú não é do seu clã"}'; end if;

  v_cargo := coalesce(_cargo_do_personagem(v_cla, v_personagem), 'membro');
  if v_cargo = 'membro' and not v_it.liberado_para_membros then
    return '{"erro":"item travado — só oficial/líder retira (ou libera pra membros)"}';
  end if;

  update cla_inventario set excluido = true where id = v_it.id;
  insert into inventario (personagem_nome, item_id, nome, tipo, quantidade, origem)
    values (v_personagem, v_it.item_id, v_it.nome, coalesce(v_it.tipo,'material'), v_it.qtd, 'bau_cla');
  return '{"ok":true}';
end;
$function$
;

CREATE OR REPLACE FUNCTION public.salvar_estado_online(p jsonb)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_nome text;
  v_campo text;
begin
  select nome into v_nome from personagens where dono_id = auth.uid();
  if v_nome is null then
    raise exception 'nenhum personagem ligado a esta conta';
  end if;
  -- colunas numericas: so atualiza se a chave veio no payload
  foreach v_campo in array array[
    'col_mao','col_guardado','col_ganho_hoje','folego','bug','carga_limit'
  ]
  loop
    if p ? v_campo then
      execute format(
        'update personagens set %I = $1, updated_at = now() where nome = $2',
        v_campo
      ) using (p ->> v_campo)::int, v_nome;
    end if;
  end loop;
  -- data/timestamp e jsonb, um a um
  if p ? 'col_reset_dia' then
    update personagens set col_reset_dia = (p ->> 'col_reset_dia')::date, updated_at = now()
      where nome = v_nome;
  end if;
  if p ? 'bug_ate' then
    update personagens set bug_ate = (p ->> 'bug_ate')::timestamptz, updated_at = now()
      where nome = v_nome;
  end if;
  if p ? 'folego_atualizado_em' then
    update personagens set folego_atualizado_em = (p ->> 'folego_atualizado_em')::timestamptz,
      updated_at = now() where nome = v_nome;
  end if;
  if p ? 'equipado' then
    update personagens set equipado = (p -> 'equipado'), updated_at = now()
      where nome = v_nome;
  end if;
end $function$
;

CREATE OR REPLACE FUNCTION public.sortear_missoes_do_dia()
 RETURNS SETOF missoes_quadro
 LANGUAGE sql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  with me as (
    select coalesce(max(nivel), 1) as n
    from nivel_profissao
    where personagem_nome = (select nome from personagens where dono_id = auth.uid())
  )
  select q.*
  from missoes_quadro q, me
  where q.visivel and not q.excluido
    and q.nivel_min between greatest(1, me.n - 2) and me.n + 2
  order by random()
  limit 5;
$function$
;

CREATE OR REPLACE FUNCTION public.trg_reputacao_por_missao()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare v_m missoes_quadro%rowtype;
begin
  if new.status <> 'concluida' then return new; end if;
  select * into v_m from missoes_quadro where id = new.missao_id;
  if v_m.reputacao_alvo_nome is not null and coalesce(v_m.reputacao_delta,0) <> 0 then
    perform _ajustar_reputacao_interna(
      new.personagem_nome, v_m.reputacao_alvo_nome, v_m.reputacao_delta,
      coalesce(v_m.reputacao_alvo_tipo,'outro'),
      'missão: ' || coalesce(v_m.titulo, v_m.id)
    );
  end if;
  return new;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.verificar_chocagem(p_criatura_domada_id bigint)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_personagem text;
  v_cd criaturas_domadas%rowtype;
  v_resp jsonb;
begin
  select nome into v_personagem from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;

  select * into v_cd from criaturas_domadas
    where id = p_criatura_domada_id and personagem_nome = v_personagem and not excluido;
  if not found then return '{"erro":"criatura nao encontrada"}'; end if;

  if v_cd.status <> 'incubando' then
    return format('{"erro":"status atual: %s (nao esta incubando)"}', v_cd.status);
  end if;

  if v_cd.choca_em > now() then
    return jsonb_build_object(
      'erro', 'ainda nao chocou',
      'choca_em', to_char(v_cd.choca_em, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'),
      'faltam_segundos',
        greatest(0, round(extract(epoch from (v_cd.choca_em - now())))::int)
    )::text;
  end if;

  -- concluído: muda status
  update criaturas_domadas
     set status = 'ativo', nascido_em = now(), updated_at = now()
   where id = v_cd.id;

  v_resp := jsonb_build_object(
    'ok', true,
    'criatura_domada_id', v_cd.id,
    'nome_pet', v_cd.nome_pet,
    'raridade', v_cd.raridade,
    'status_novo', 'ativo',
    'nascido_em', to_char(now(), 'YYYY-MM-DD"T"HH24:MI:SS"Z"'),
    'efeitos', v_cd.efeitos
  );
  return v_resp::text;
end $function$
;


-- ========== RLS ==========
alter table "armas" enable row level security;
alter table "bestiario_roster" enable row level security;
alter table "cartas" enable row level security;
alter table "cidades" enable row level security;
alter table "cla_autoridade" enable row level security;
alter table "cla_inventario" enable row level security;
alter table "clas" enable row level security;
alter table "combate_log" enable row level security;
alter table "compra_materiais" enable row level security;
alter table "conteudo_liberado" enable row level security;
alter table "craft_fila" enable row level security;
alter table "criaturas_domadas" enable row level security;
alter table "cristais" enable row level security;
alter table "cronicas" enable row level security;
alter table "documento_chunks" enable row level security;
alter table "documentos" enable row level security;
alter table "dungeons" enable row level security;
alter table "equipamentos" enable row level security;
alter table "ferramentas_oficio" enable row level security;
alter table "guias" enable row level security;
alter table "inventario" enable row level security;
alter table "limit_breaker_contador" enable row level security;
alter table "materiais_basicos" enable row level security;
alter table "mercado" enable row level security;
alter table "mercado_itens" enable row level security;
alter table "mesa_combate" enable row level security;
alter table "mesa_raid_prep" enable row level security;
alter table "mesa_relacoes" enable row level security;
alter table "mesa_relogios" enable row level security;
alter table "mesa_sessoes" enable row level security;
alter table "metas_doacoes" enable row level security;
alter table "metas_globais" enable row level security;
alter table "missao_diaria" enable row level security;
alter table "missoes_quadro" enable row level security;
alter table "monstros" enable row level security;
alter table "moves_arma" enable row level security;
alter table "moves_profissao" enable row level security;
alter table "nivel_profissao" enable row level security;
alter table "npcs" enable row level security;
alter table "oficios" enable row level security;
alter table "ovos_catalogo" enable row level security;
alter table "perfis" enable row level security;
alter table "personagem_ferramentas" enable row level security;
alter table "personagens" enable row level security;
alter table "pontos" enable row level security;
alter table "pontos_detalhe" enable row level security;
alter table "producao" enable row level security;
alter table "puzzles" enable row level security;
alter table "quests" enable row level security;
alter table "receitas" enable row level security;
alter table "reputacao_personagem" enable row level security;
alter table "salas_dungeon" enable row level security;
alter table "sistema" enable row level security;
alter table "transacoes" enable row level security;
alter table "vitrine" enable row level security;
drop policy if exists "escrita_mestre" on "armas";
create policy "escrita_mestre" on "armas" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "armas";
create policy "select_publico_ou_mestre" on "armas" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('armas'::text, id)));
drop policy if exists "escrita_mestre" on "bestiario_roster";
create policy "escrita_mestre" on "bestiario_roster" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "bestiario_roster";
create policy "select_publico_ou_mestre" on "bestiario_roster" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre()));
drop policy if exists "escrita_mestre" on "cartas";
create policy "escrita_mestre" on "cartas" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "cartas";
create policy "select_publico_ou_mestre" on "cartas" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre()));
drop policy if exists "escrita_mestre" on "cidades";
create policy "escrita_mestre" on "cidades" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "cidades";
create policy "select_publico_ou_mestre" on "cidades" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('cidades'::text, id)));
drop policy if exists "leitura_publica" on "cla_autoridade";
create policy "leitura_publica" on "cla_autoridade" for select using (true);
drop policy if exists "so_mestre_escreve" on "cla_autoridade";
create policy "so_mestre_escreve" on "cla_autoridade" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "membros_leem_mestre_tudo" on "cla_inventario";
create policy "membros_leem_mestre_tudo" on "cla_inventario" for select using ((is_mestre() OR (EXISTS ( SELECT 1
   FROM personagens p
  WHERE ((p.dono_id = auth.uid()) AND (p.guilda = cla_inventario.cla_nome))))));
drop policy if exists "so_rpc_escreve" on "cla_inventario";
create policy "so_rpc_escreve" on "cla_inventario" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "escrita_mestre" on "clas";
create policy "escrita_mestre" on "clas" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "clas";
create policy "select_publico_ou_mestre" on "clas" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('clas'::text, nome)));
drop policy if exists "dono_ve" on "combate_log";
create policy "dono_ve" on "combate_log" for select using ((e_dono_personagem(personagem_nome) OR is_mestre()));
drop policy if exists "so_sistema_insere" on "combate_log";
create policy "so_sistema_insere" on "combate_log" for insert with check (is_mestre());
drop policy if exists "escrita_mestre" on "compra_materiais";
create policy "escrita_mestre" on "compra_materiais" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "compra_materiais";
create policy "select_publico_ou_mestre" on "compra_materiais" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('compra_materiais'::text, (id)::text)));
drop policy if exists "jogador_ve_proprias_liberacoes" on "conteudo_liberado";
create policy "jogador_ve_proprias_liberacoes" on "conteudo_liberado" for select using (((jogador_id = auth.uid()) OR is_mestre()));
drop policy if exists "mestre_gerencia_liberacoes" on "conteudo_liberado";
create policy "mestre_gerencia_liberacoes" on "conteudo_liberado" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "dono_gerencia" on "craft_fila";
create policy "dono_gerencia" on "craft_fila" for all using ((e_dono_personagem(personagem_nome) OR is_mestre())) with check ((e_dono_personagem(personagem_nome) OR is_mestre()));
drop policy if exists "leitura_publica" on "craft_fila";
create policy "leitura_publica" on "craft_fila" for select using (true);
drop policy if exists "dono_gerencia" on "criaturas_domadas";
create policy "dono_gerencia" on "criaturas_domadas" for all using ((e_dono_personagem(personagem_nome) OR is_mestre())) with check ((e_dono_personagem(personagem_nome) OR is_mestre()));
drop policy if exists "leitura_publica" on "criaturas_domadas";
create policy "leitura_publica" on "criaturas_domadas" for select using (true);
drop policy if exists "escrita_mestre" on "cristais";
create policy "escrita_mestre" on "cristais" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "cristais";
create policy "select_publico_ou_mestre" on "cristais" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre()));
drop policy if exists "escrita_mestre" on "cronicas";
create policy "escrita_mestre" on "cronicas" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "cronicas";
create policy "select_publico_ou_mestre" on "cronicas" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('cronicas'::text, id)));
drop policy if exists "so_mestre" on "documento_chunks";
create policy "so_mestre" on "documento_chunks" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "escrita_mestre" on "documentos";
create policy "escrita_mestre" on "documentos" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "documentos";
create policy "select_publico_ou_mestre" on "documentos" for select using ((((visivel = true) AND (excluido = false) AND (publico = true)) OR is_mestre() OR pode_ver('documentos'::text, id)));
drop policy if exists "escrita_mestre" on "dungeons";
create policy "escrita_mestre" on "dungeons" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "dungeons";
create policy "select_publico_ou_mestre" on "dungeons" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('dungeons'::text, id)));
drop policy if exists "escrita_mestre" on "equipamentos";
create policy "escrita_mestre" on "equipamentos" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "equipamentos";
create policy "select_publico_ou_mestre" on "equipamentos" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('equipamentos'::text, id)));
drop policy if exists "escrita_mestre" on "ferramentas_oficio";
create policy "escrita_mestre" on "ferramentas_oficio" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "ferramentas_oficio";
create policy "select_publico_ou_mestre" on "ferramentas_oficio" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre()));
drop policy if exists "escrita_mestre" on "guias";
create policy "escrita_mestre" on "guias" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "guias";
create policy "select_publico_ou_mestre" on "guias" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('guias'::text, id)));
drop policy if exists "dono_gerencia" on "inventario";
create policy "dono_gerencia" on "inventario" for all using ((e_dono_personagem(personagem_nome) OR is_mestre())) with check ((e_dono_personagem(personagem_nome) OR is_mestre()));
drop policy if exists "leitura_publica" on "inventario";
create policy "leitura_publica" on "inventario" for select using (true);
drop policy if exists "dono_gerencia" on "limit_breaker_contador";
create policy "dono_gerencia" on "limit_breaker_contador" for all using ((e_dono_personagem(personagem_nome) OR is_mestre())) with check ((e_dono_personagem(personagem_nome) OR is_mestre()));
drop policy if exists "leitura_publica" on "limit_breaker_contador";
create policy "leitura_publica" on "limit_breaker_contador" for select using (true);
drop policy if exists "escrita_mestre" on "materiais_basicos";
create policy "escrita_mestre" on "materiais_basicos" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "materiais_basicos";
create policy "select_publico_ou_mestre" on "materiais_basicos" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre()));
drop policy if exists "escrita_mestre" on "mercado";
create policy "escrita_mestre" on "mercado" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "mercado";
create policy "select_publico_ou_mestre" on "mercado" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('mercado'::text, id)));
drop policy if exists "escrita_mestre" on "mercado_itens";
create policy "escrita_mestre" on "mercado_itens" for all using ((auth.role() = 'authenticated'::text)) with check ((auth.role() = 'authenticated'::text));
drop policy if exists "select_livre" on "mercado_itens";
create policy "select_livre" on "mercado_itens" for select using (true);
drop policy if exists "so_mestre" on "mesa_combate";
create policy "so_mestre" on "mesa_combate" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "so_mestre" on "mesa_raid_prep";
create policy "so_mestre" on "mesa_raid_prep" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "so_mestre" on "mesa_relacoes";
create policy "so_mestre" on "mesa_relacoes" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "so_mestre" on "mesa_relogios";
create policy "so_mestre" on "mesa_relogios" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "so_mestre" on "mesa_sessoes";
create policy "so_mestre" on "mesa_sessoes" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "leitura_publica" on "metas_doacoes";
create policy "leitura_publica" on "metas_doacoes" for select using (true);
drop policy if exists "so_rpc_escreve" on "metas_doacoes";
create policy "so_rpc_escreve" on "metas_doacoes" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "leitura_publica" on "metas_globais";
create policy "leitura_publica" on "metas_globais" for select using (((visivel = true) OR is_mestre()));
drop policy if exists "so_mestre_escreve" on "metas_globais";
create policy "so_mestre_escreve" on "metas_globais" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "dono_gerencia" on "missao_diaria";
create policy "dono_gerencia" on "missao_diaria" for all using ((e_dono_personagem(personagem_nome) OR is_mestre())) with check ((e_dono_personagem(personagem_nome) OR is_mestre()));
drop policy if exists "leitura_publica" on "missao_diaria";
create policy "leitura_publica" on "missao_diaria" for select using (true);
drop policy if exists "escrita_mestre" on "missoes_quadro";
create policy "escrita_mestre" on "missoes_quadro" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "missoes_quadro";
create policy "select_publico_ou_mestre" on "missoes_quadro" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre()));
drop policy if exists "escrita_mestre" on "monstros";
create policy "escrita_mestre" on "monstros" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "monstros";
create policy "select_publico_ou_mestre" on "monstros" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('monstros'::text, id)));
drop policy if exists "escrita_mestre" on "moves_arma";
create policy "escrita_mestre" on "moves_arma" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "moves_arma";
create policy "select_publico_ou_mestre" on "moves_arma" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('moves_arma'::text, nome)));
drop policy if exists "escrita_mestre" on "moves_profissao";
create policy "escrita_mestre" on "moves_profissao" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "moves_profissao";
create policy "select_publico_ou_mestre" on "moves_profissao" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('moves_profissao'::text, nome)));
drop policy if exists "dono_gerencia" on "nivel_profissao";
create policy "dono_gerencia" on "nivel_profissao" for all using ((e_dono_personagem(personagem_nome) OR is_mestre())) with check ((e_dono_personagem(personagem_nome) OR is_mestre()));
drop policy if exists "leitura_publica" on "nivel_profissao";
create policy "leitura_publica" on "nivel_profissao" for select using (true);
drop policy if exists "escrita_mestre" on "npcs";
create policy "escrita_mestre" on "npcs" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "npcs";
create policy "select_publico_ou_mestre" on "npcs" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('npcs'::text, id)));
drop policy if exists "escrita_mestre" on "oficios";
create policy "escrita_mestre" on "oficios" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "oficios";
create policy "select_publico_ou_mestre" on "oficios" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('oficios'::text, nome)));
drop policy if exists "escrita_mestre" on "ovos_catalogo";
create policy "escrita_mestre" on "ovos_catalogo" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "ovos_catalogo";
create policy "select_publico_ou_mestre" on "ovos_catalogo" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre()));
drop policy if exists "jogador_se_registra" on "perfis";
create policy "jogador_se_registra" on "perfis" for insert with check (((id = auth.uid()) AND (papel = 'jogador'::text)));
drop policy if exists "mestre_gerencia_perfis" on "perfis";
create policy "mestre_gerencia_perfis" on "perfis" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "ve_proprio_perfil" on "perfis";
create policy "ve_proprio_perfil" on "perfis" for select using ((id = auth.uid()));
drop policy if exists "dono_gerencia" on "personagem_ferramentas";
create policy "dono_gerencia" on "personagem_ferramentas" for all using ((e_dono_personagem(personagem_nome) OR is_mestre())) with check ((e_dono_personagem(personagem_nome) OR is_mestre()));
drop policy if exists "leitura_publica" on "personagem_ferramentas";
create policy "leitura_publica" on "personagem_ferramentas" for select using (true);
drop policy if exists "del_dono_ou_mestre" on "personagens";
create policy "del_dono_ou_mestre" on "personagens" for delete using (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM perfis
  WHERE ((perfis.id = auth.uid()) AND (perfis.papel = 'mestre'::text)))) OR (dono_id = auth.uid())));
drop policy if exists "ins_mestre_service" on "personagens";
create policy "ins_mestre_service" on "personagens" for insert with check (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM perfis
  WHERE ((perfis.id = auth.uid()) AND (perfis.papel = 'mestre'::text))))));
drop policy if exists "sel_publico_ou_privado_dono_mestre" on "personagens";
create policy "sel_publico_ou_privado_dono_mestre" on "personagens" for select using (((visivel = true) OR (auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM perfis
  WHERE ((perfis.id = auth.uid()) AND (perfis.papel = 'mestre'::text)))) OR (dono_id = auth.uid())));
drop policy if exists "upd_dono_ou_mestre" on "personagens";
create policy "upd_dono_ou_mestre" on "personagens" for update using (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM perfis
  WHERE ((perfis.id = auth.uid()) AND (perfis.papel = 'mestre'::text)))) OR (dono_id = auth.uid()))) with check (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM perfis
  WHERE ((perfis.id = auth.uid()) AND (perfis.papel = 'mestre'::text)))) OR (dono_id = auth.uid())));
drop policy if exists "escrita_mestre" on "pontos";
create policy "escrita_mestre" on "pontos" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "pontos";
create policy "select_publico_ou_mestre" on "pontos" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('pontos'::text, id)));
drop policy if exists "escrita_mestre" on "pontos_detalhe";
create policy "escrita_mestre" on "pontos_detalhe" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "pontos_detalhe";
create policy "select_publico_ou_mestre" on "pontos_detalhe" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('pontos_detalhe'::text, id)));
drop policy if exists "escrita_mestre" on "producao";
create policy "escrita_mestre" on "producao" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "producao";
create policy "select_publico_ou_mestre" on "producao" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('producao'::text, profissao)));
drop policy if exists "escrita_mestre" on "puzzles";
create policy "escrita_mestre" on "puzzles" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "puzzles";
create policy "select_publico_ou_mestre" on "puzzles" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('puzzles'::text, id)));
drop policy if exists "escrita_mestre" on "quests";
create policy "escrita_mestre" on "quests" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "quests";
create policy "select_publico_ou_mestre" on "quests" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('quests'::text, id)));
drop policy if exists "escrita_mestre" on "receitas";
create policy "escrita_mestre" on "receitas" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "receitas";
create policy "select_publico_ou_mestre" on "receitas" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre()));
drop policy if exists "leitura_publica" on "reputacao_personagem";
create policy "leitura_publica" on "reputacao_personagem" for select using (true);
drop policy if exists "so_mestre_escreve" on "reputacao_personagem";
create policy "so_mestre_escreve" on "reputacao_personagem" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "escrita_mestre" on "salas_dungeon";
create policy "escrita_mestre" on "salas_dungeon" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "salas_dungeon";
create policy "select_publico_ou_mestre" on "salas_dungeon" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('salas_dungeon'::text, id)));
drop policy if exists "escrita_mestre" on "sistema";
create policy "escrita_mestre" on "sistema" for all using (is_mestre()) with check (is_mestre());
drop policy if exists "select_publico_ou_mestre" on "sistema";
create policy "select_publico_ou_mestre" on "sistema" for select using ((((visivel = true) AND (excluido = false)) OR is_mestre() OR pode_ver('sistema'::text, titulo)));
drop policy if exists "dono_insere" on "transacoes";
create policy "dono_insere" on "transacoes" for insert with check ((e_dono_personagem(de_personagem) OR is_mestre()));
drop policy if exists "partes_leem" on "transacoes";
create policy "partes_leem" on "transacoes" for select using ((e_dono_personagem(de_personagem) OR e_dono_personagem(para_personagem) OR is_mestre()));
drop policy if exists "dono_gerencia" on "vitrine";
create policy "dono_gerencia" on "vitrine" for all using ((e_dono_personagem(vendedor_nome) OR is_mestre())) with check ((e_dono_personagem(vendedor_nome) OR is_mestre()));
drop policy if exists "leitura_publica" on "vitrine";
create policy "leitura_publica" on "vitrine" for select using (true);

-- ========== PG_CRON ==========
select cron.unschedule(jobid) from cron.job where jobname = 'regen_folego_30min';
select cron.schedule('regen_folego_30min', '*/30 * * * *', $$select _regenerar_folego_todos()$$);
