#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Pega o markdown que ainda não está no banco (docs/ de regra, receita,
serviço, história, segredo; mapas/andar_N.md; a introdução geral dos
guias/0N_*.md) e joga em `documentos`/`documento_chunks` no Supabase, com
embedding local via Ollama (`nomic-embed-text`) — vira a base do RAG.

Idempotente: upsert por id (slug do caminho). Rodar de novo depois de
editar um `.md` fonte atualiza o documento e recria os pedaços dele.

Uso:
    ollama pull nomic-embed-text   # uma vez só
    python scripts/gerar_embeddings.py
"""
import json
import os
import re
import sys
import urllib.request

import psycopg2

RAIZ = os.path.dirname(os.path.abspath(__file__)) + "/.."
RAIZ = os.path.normpath(RAIZ)
sys.path.insert(0, os.path.join(RAIZ, "scripts"))
from gerar_dados_web import frontmatter, slug, ler  # noqa: E402

OLLAMA_URL = "http://localhost:11434"
MODELO_EMBED = "nomic-embed-text"

# (caminho relativo, categoria, publico, somente_intro)
FONTES = [
    # --- GM-only / spoiler ---
    ("docs/misterio_andar2.md", "campanha", False, False),
    ("docs/interacoes_e_segredos.md", "campanha", False, False),
    ("docs/eventos_dinamicos_andar1.md", "campanha", False, False),
    ("docs/banco_npcs_apoio_andar1.md", "campanha", False, False),
    ("docs/balanceamento_armas_oficios.md", "campanha", False, False),
    ("docs/motor_de_episodios_andar1.md", "campanha", False, False),
    ("docs/operacao_campanha_multigrupo.md", "campanha", False, False),
    # --- dev/processo (não é conteúdo de campanha, mas "tudo" foi o pedido) ---
    ("docs/analise_experiencia.md", "dev", False, False),
    ("docs/pendencias.md", "dev", False, False),
    ("docs/pipeline.md", "dev", False, False),
    ("docs/visao_geral.md", "dev", False, False),
    ("docs/fontes.md", "dev", False, False),
    ("docs/guia_estilo_audio.md", "dev", False, False),
    ("docs/guia_estilo_visual.md", "dev", False, False),
    ("mapas/PROMPT_MAPA.md", "dev", False, False),
    # --- regras públicas ---
    ("docs/guia_publico_andar1.md", "regras", True, False),
    ("docs/regras_nucleares_campanha.md", "regras", True, False),
    ("docs/elementos_andar1.md", "regras", True, False),
    # --- receitas/serviços (catálogo de crafting, público) ---
    ("docs/catalogo_receitas_por_oficio.md", "receitas", True, False),
    ("docs/receitas_cacador.md", "receitas", True, False),
    ("docs/receitas_costureiro.md", "receitas", True, False),
    ("docs/receitas_coveiro.md", "receitas", True, False),
    ("docs/receitas_domador.md", "receitas", True, False),
    ("docs/receitas_ferreiro.md", "receitas", True, False),
    ("docs/receitas_joalheiro.md", "receitas", True, False),
    ("docs/receitas_lenhador.md", "receitas", True, False),
    ("docs/receitas_medico.md", "receitas", True, False),
    ("docs/servicos_bibliotecario.md", "receitas", True, False),
    ("docs/servicos_cartografo.md", "receitas", True, False),
    ("docs/servicos_comerciante.md", "receitas", True, False),
    ("docs/servicos_diplomata.md", "receitas", True, False),
    ("docs/servicos_mercenario.md", "receitas", True, False),
    ("docs/servicos_musico.md", "receitas", True, False),
    ("pocoes/00_catalogo_pocoes_alquimista.md", "receitas", True, False),
    ("Comidas/00_catalogo_receitas_cozinheiro.md", "receitas", True, False),
    # --- narrativa/lore, pública ---
    ("docs/historia_campanha.md", "campanha", True, False),
    ("docs/historia_campanha_andar2.md", "campanha", True, False),
    ("docs/guia_bestiario_andar1.md", "campanha", True, False),
    ("docs/economia_profissoes.md", "campanha", True, False),
    ("mapas/andar_1.md", "campanha", True, False),
    ("mapas/andar_2.md", "campanha", True, False),
    # --- guias de região: só a introdução geral, o resto já está no banco ---
    ("guias/00_como_usar.md", "guia", True, False),
    ("guias/01_coracao_do_andar.md", "guia", True, True),
    ("guias/02_oeste_e_sul.md", "guia", True, True),
    ("guias/03_leste_e_aguas.md", "guia", True, True),
    ("guias/04_norte_e_o_labirinto.md", "guia", True, True),
]


def embeddar(texto):
    body = json.dumps({"model": MODELO_EMBED, "prompt": texto}).encode("utf-8")
    req = urllib.request.Request(
        OLLAMA_URL + "/api/embeddings", data=body,
        headers={"Content-Type": "application/json"},
    )
    with urllib.request.urlopen(req, timeout=120) as r:
        return json.loads(r.read())["embedding"]


def vec_literal(v):
    return "[" + ",".join(repr(float(x)) for x in v) + "]"


def so_introducao(corpo):
    m = re.search(r"\n##+ ", corpo)
    return corpo[: m.start()] if m else corpo


def chunk_por_cabecalho(corpo, max_palavras=400):
    partes = re.split(r"\n(?=##+ )", corpo)
    chunks = []
    for parte in partes:
        parte = parte.strip()
        if not parte:
            continue
        m = re.match(r"^(#{2,6})\s+(.+)", parte)
        titulo_secao = m.group(2).strip() if m else None
        palavras = parte.split()
        if len(palavras) <= max_palavras:
            chunks.append((titulo_secao, parte))
            continue
        paragrafos = parte.split("\n\n")
        buffer, conta = [], 0
        for p in paragrafos:
            pw = len(p.split())
            if conta + pw > max_palavras and buffer:
                chunks.append((titulo_secao, "\n\n".join(buffer)))
                buffer, conta = [], 0
            buffer.append(p)
            conta += pw
        if buffer:
            chunks.append((titulo_secao, "\n\n".join(buffer)))
    return chunks


def carregar_env():
    env = {}
    with open(os.path.join(RAIZ, ".env"), encoding="utf-8") as f:
        for linha in f:
            linha = linha.strip()
            if linha and "=" in linha and not linha.startswith("#"):
                k, v = linha.split("=", 1)
                env[k] = v
    return env


def main():
    env = carregar_env()
    conn = psycopg2.connect(
        host=env["SUPABASE_DB_HOST"], port=env["SUPABASE_DB_PORT"],
        dbname=env["SUPABASE_DB_NAME"], user=env["SUPABASE_DB_USER"],
        password=env["SUPABASE_DB_PASSWORD"], sslmode="require",
    )
    conn.autocommit = True
    cur = conn.cursor()

    total_docs, total_chunks = 0, 0
    for caminho_rel, categoria, publico, intro_apenas in FONTES:
        caminho_abs = os.path.join(RAIZ, caminho_rel.replace("/", os.sep))
        if not os.path.exists(caminho_abs):
            print("  aviso: nao existe -- %s" % caminho_rel)
            continue
        fm, corpo = frontmatter(ler(caminho_abs))
        titulo = fm.get("titulo", os.path.basename(caminho_rel))
        if intro_apenas:
            corpo = so_introducao(corpo)
        corpo = corpo.strip()
        if not corpo:
            print("  vazio (so intro?) -- %s" % caminho_rel)
            continue

        doc_id = slug(caminho_rel)
        cur.execute(
            """insert into documentos (id,caminho,titulo,categoria,publico,corpo)
               values (%s,%s,%s,%s,%s,%s)
               on conflict (id) do update set
                 caminho=excluded.caminho, titulo=excluded.titulo,
                 categoria=excluded.categoria, publico=excluded.publico,
                 corpo=excluded.corpo, updated_at=now()""",
            (doc_id, caminho_rel, titulo, categoria, publico, corpo),
        )
        total_docs += 1

        cur.execute("delete from documento_chunks where documento_id = %s", (doc_id,))
        pedacos = chunk_por_cabecalho(corpo)
        for i, (titulo_secao, texto) in enumerate(pedacos):
            emb = embeddar(texto)
            cur.execute(
                """insert into documento_chunks (documento_id,ordem,titulo_secao,conteudo,embedding)
                   values (%s,%s,%s,%s,%s::vector)""",
                (doc_id, i, titulo_secao, texto, vec_literal(emb)),
            )
            total_chunks += 1
        print("  %s -> %d pedaço(s)" % (caminho_rel, len(pedacos)))

    cur.close()
    conn.close()
    print("Pronto: %d documentos, %d pedaços com embedding." % (total_docs, total_chunks))


if __name__ == "__main__":
    main()
