#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Gera o PDF "sistema inteiro" -- rulebook (SAO_RPG_5e.md) + Bestiário
(monstros/*.md) + Equipamentos (equipamentos/*.md) + NPCs notáveis
(npcs/*.md) + Regiões de Aincrad (cidades/*.md), tudo num livro só, com
stat block visual estilo D&D 5e (caixa com barra colorida, atributo em
grade, etc.) em vez de só texto corrido.

Reaproveita o parser markdown->HTML de _gerar_pdf_rulebook.py (mesmo
subconjunto: #/##/### headers, tabelas, **negrito**, `código`, listas,
blockquote, ---, links) e a mesma renderização via Chrome/Edge headless.

Uso:
    python scripts/_gerar_pdf_completo.py
"""
import glob
import html
import os
import re
import subprocess
import sys

RAIZ = os.path.dirname(os.path.abspath(__file__))
RAIZ_PROJETO = os.path.dirname(RAIZ)
sys.path.insert(0, RAIZ)

from _gerar_pdf_rulebook import (  # noqa: E402
    slugify, inline_md, md_para_html, RE_EMOJI, achar_navegador,
)

CAMINHO_MD_RULEBOOK = os.path.join(RAIZ_PROJETO, "SAO_RPG_5e.md")
DIR_MONSTROS = os.path.join(RAIZ_PROJETO, "monstros")
DIR_EQUIPAMENTOS = os.path.join(RAIZ_PROJETO, "equipamentos")
DIR_NPCS = os.path.join(RAIZ_PROJETO, "npcs")
DIR_CIDADES = os.path.join(RAIZ_PROJETO, "cidades")
DIR_IMAGENS = os.path.join(RAIZ_PROJETO, "imagens")
DIR_CACHE_IMG = os.path.join(RAIZ_PROJETO, "entregas", "_cache_imagens_pdf")
CAMINHO_HTML = os.path.join(RAIZ_PROJETO, "entregas", "_sao_rpg_5e_sistema_completo.html")
CAMINHO_PDF = os.path.join(RAIZ_PROJETO, "entregas", "SAO_RPG_5e_Sistema_Completo.pdf")

try:
    from PIL import Image
    _TEM_PIL = True
except ImportError:
    _TEM_PIL = False

_CACHE_REDIMENSIONADO = {}


def url_imagem(nome_arquivo, lado_max=260):
    """nome_arquivo tipo 'monstro_abelha_gigante.png' -> file:// URL de uma
    COPIA redimensionada/comprimida (as artes originais tem ~1-2 MB cada em
    PNG; embutir ~150 delas em resolucao total no PDF gerava um arquivo de
    270+ MB -- o CSS so' redimensiona visualmente, nao reduz o peso real).
    Devolve None se o arquivo nao existir."""
    caminho_original = os.path.join(DIR_IMAGENS, nome_arquivo)
    if not os.path.exists(caminho_original):
        return None
    if not _TEM_PIL:
        return "file:///" + caminho_original.replace("\\", "/")

    chave = (nome_arquivo, lado_max)
    if chave in _CACHE_REDIMENSIONADO:
        return _CACHE_REDIMENSIONADO[chave]

    os.makedirs(DIR_CACHE_IMG, exist_ok=True)
    nome_cache = f"{lado_max}_" + os.path.splitext(nome_arquivo)[0] + ".jpg"
    caminho_cache = os.path.join(DIR_CACHE_IMG, nome_cache)
    if not os.path.exists(caminho_cache):
        with Image.open(caminho_original) as im:
            im = im.convert("RGB")
            im.thumbnail((lado_max, lado_max), Image.LANCZOS)
            im.save(caminho_cache, "JPEG", quality=78, optimize=True)
    url = "file:///" + caminho_cache.replace("\\", "/")
    _CACHE_REDIMENSIONADO[chave] = url
    return url


def url_imagem_frontmatter(valor):
    """campo 'imagem:' do frontmatter, tipo '../imagens/monstro_x.png'."""
    if not valor:
        return None
    nome = os.path.basename(valor)
    return url_imagem(nome)


# --------------------------------------------------------------------------
# frontmatter YAML simples (so' o subconjunto usado nesses arquivos --
# chave: valor, chave: [lista, de, itens], chave:\n  sub: valor)
# --------------------------------------------------------------------------

def ler_frontmatter(texto):
    m = re.match(r"^---\n(.*?)\n---\n(.*)$", texto, re.S)
    if not m:
        return {}, texto
    bloco, corpo = m.group(1), m.group(2)
    dados = {}
    chave_atual = None
    for linha in bloco.split("\n"):
        if re.match(r"^\s+\S", linha) and chave_atual:
            m2 = re.match(r"^\s+(\S+):\s*(.*)$", linha)
            if m2:
                if not isinstance(dados.get(chave_atual), dict):
                    dados[chave_atual] = {}
                dados[chave_atual][m2.group(1)] = m2.group(2).strip()
            continue
        m3 = re.match(r"^(\w+):\s*(.*)$", linha)
        if m3:
            chave_atual = m3.group(1)
            valor = m3.group(2).strip()
            if valor.startswith("[") and valor.endswith("]"):
                itens = [x.strip().strip('"') for x in valor[1:-1].split(",") if x.strip()]
                dados[chave_atual] = itens
            elif valor:
                dados[chave_atual] = valor.strip('"')
            else:
                dados[chave_atual] = None
    return dados, corpo


def secao_corpo(corpo, titulo, nivel=2):
    """Extrai o texto de uma secao '## Titulo' ate a proxima do mesmo nivel."""
    marca = "#" * nivel
    m = re.search(rf"^{marca} {re.escape(titulo)}\s*\n(.*?)(?=^{marca} |\Z)", corpo, re.M | re.S)
    return m.group(1).strip() if m else ""


# --------------------------------------------------------------------------
# Bestiário
# --------------------------------------------------------------------------

def gerar_stat_block_monstro(caminho):
    with open(caminho, encoding="utf-8") as f:
        texto = f.read()
    fm, corpo = ler_frontmatter(texto)
    if not fm.get("nome"):
        return None

    nome = fm.get("nome", "?")
    epiteto = fm.get("epiteto") or ""
    tipo = fm.get("tipo", "?")
    andar = fm.get("andar", "?")
    ameaca = fm.get("nivel_ameaca", "?")
    ca = fm.get("ca", "?")
    pv = fm.get("pv", "?")
    dado_vida = re.sub(r"\s*#.*$", "", fm.get("dado_vida", "") or "").strip()
    bonus_ataque = fm.get("bonus_ataque", "?")
    cd = fm.get("cd_resistencia", "?")
    atributo_fraq = fm.get("atributo_fraqueza", "?")
    resistencias = fm.get("resistencias") or []
    vulnerabilidades = fm.get("vulnerabilidades") or []
    if isinstance(resistencias, str):
        resistencias = [resistencias]
    if isinstance(vulnerabilidades, str):
        vulnerabilidades = [vulnerabilidades]

    habitat = secao_corpo(corpo, "Habitat")
    aparencia = secao_corpo(corpo, "Aparência")
    ataques = secao_corpo(corpo, "Ataques")
    fraquezas = secao_corpo(corpo, "Fraquezas")
    lore = secao_corpo(corpo, "Lore")

    ataques_html, _ = md_para_html(ataques) if ataques else ("", [])
    fraquezas_html, _ = md_para_html(fraquezas) if fraquezas else ("", [])
    aparencia_html, _ = md_para_html(aparencia) if aparencia else ("", [])
    lore_html, _ = md_para_html(lore) if lore else ("", [])

    slug = slugify(nome)
    sub = f"{tipo.capitalize()} · Andar {andar} · Ameaça {ameaca}"
    if epiteto:
        sub = f'"{epiteto}" · ' + sub

    url_carta = url_imagem(f"carta_{slug.replace('-', '_')}.png")
    url_retrato = url_imagem_frontmatter(fm.get("imagem")) or url_imagem(f"monstro_{slug.replace('-', '_')}.png")
    url_arte = url_carta or url_retrato
    classe_bloco = "statblock" + (" statblock-com-arte" if url_arte else "")

    partes = [f'<div class="{classe_bloco}" id="mob-{slug}">']
    if url_arte:
        partes.append(f'<img class="sb-retrato" src="{url_arte}" alt="{html.escape(nome)}">')
    partes.append('<div class="sb-conteudo">')
    partes.append(f'<div class="sb-barra"></div>')
    partes.append(f'<h3 class="sb-nome">{html.escape(nome)}</h3>')
    partes.append(f'<div class="sb-sub">{html.escape(sub)}</div>')
    partes.append('<div class="sb-barra"></div>')
    partes.append('<div class="sb-linha">'
                   f'<b>CA</b> {html.escape(str(ca))} &nbsp;·&nbsp; '
                   f'<b>PV</b> {html.escape(str(pv))}' + (f' ({html.escape(dado_vida)})' if dado_vida else '') +
                   f' &nbsp;·&nbsp; <b>Bônus de Ataque</b> {html.escape(str(bonus_ataque))} '
                   f'&nbsp;·&nbsp; <b>CD de Resistência</b> {html.escape(str(cd))}</div>')
    partes.append(f'<div class="sb-linha"><b>Fraqueza de atributo</b> {html.escape(str(atributo_fraq))} '
                   '(ataque com esse atributo causa +1d6 de dano extra)</div>')
    if resistencias:
        partes.append(f'<div class="sb-linha"><b>Resistências</b> {html.escape(", ".join(resistencias))}</div>')
    if vulnerabilidades:
        partes.append(f'<div class="sb-linha"><b>Vulnerabilidades</b> {html.escape(", ".join(vulnerabilidades))}</div>')
    partes.append('<div class="sb-barra"></div>')
    if aparencia_html:
        partes.append(f'<div class="sb-texto">{aparencia_html}</div>')
    if ataques_html:
        partes.append('<div class="sb-secao">Ataques</div>')
        partes.append(f'<div class="sb-texto">{ataques_html}</div>')
    if fraquezas_html:
        partes.append('<div class="sb-secao">Fraquezas e aberturas</div>')
        partes.append(f'<div class="sb-texto">{fraquezas_html}</div>')
    if lore_html:
        partes.append('<div class="sb-secao">Lore</div>')
        partes.append(f'<div class="sb-texto sb-lore">{lore_html}</div>')
    partes.append('</div>')  # fecha sb-conteudo
    partes.append('</div>')  # fecha statblock
    return andar, ameaca, nome, "\n".join(partes)


ORDEM_AMEACA = {"fraco": 0, "comum": 1, "forte": 2, "elite": 3, "chefe": 4}


def gerar_bestiario_html():
    entradas = []
    for caminho in sorted(glob.glob(os.path.join(DIR_MONSTROS, "*.md"))):
        if os.path.basename(caminho).startswith("_modelo"):
            continue
        r = gerar_stat_block_monstro(caminho)
        if r:
            entradas.append(r)

    def chave(e):
        andar, ameaca, nome, _ = e
        try:
            andar_num = int(re.match(r"\d+", str(andar)).group())
        except Exception:
            andar_num = 0
        return (andar_num, ORDEM_AMEACA.get(str(ameaca).lower(), 9), nome)

    entradas.sort(key=chave)
    blocos = [e[3] for e in entradas]
    return (
        '<h1 id="bestiario">Bestiário de Aincrad</h1>\n'
        '<p>Stat blocks completos das criaturas já catalogadas, ordenadas por andar e '
        'Nível de Ameaça. Fórmulas de CA/PV/Dado de Vida seguem a Seção 73 do sistema base. '
        'A fraqueza de atributo concede +1d6 de dano extra a um ataque que a explore — '
        'ela é descoberta em jogo, nunca informação de graça (ver Seção 73).</p>\n'
        f'<div class="bestiario-grid">{"".join(blocos)}</div>',
        len(entradas),
    )


# --------------------------------------------------------------------------
# Equipamentos
# --------------------------------------------------------------------------

RE_ITEM_EQUIP = re.compile(
    r"^## (?P<nome>.+?) — (?P<raridade>\S+)\s*\n"
    r"(?P<corpo>.*?)(?=^## |\Z)",
    re.M | re.S,
)
RE_CAMPO = re.compile(r"\*\*([^*:]+):\*\*\s*(.+?)(?=\n\*\*|\Z)", re.S)

ORDEM_RARIDADE = {"comum": 0, "incomum": 1, "raro": 2, "épico": 3, "épica": 3, "lendário": 4, "lendária": 4, "único": 5, "única": 5}


def parsear_arquivo_equipamento(caminho):
    with open(caminho, encoding="utf-8") as f:
        texto = f.read()
    fm, corpo = ler_frontmatter(texto)
    slot = fm.get("slot", os.path.basename(caminho)[:-3].replace("_", " ").title())
    itens = []
    for m in RE_ITEM_EQUIP.finditer(corpo):
        nome = m.group("nome").strip()
        raridade = m.group("raridade").strip()
        corpo_item = m.group("corpo")
        requisito = ""
        preco = ""
        m_req = re.search(r"\*\*Requisito:\*\*\s*(.+?)\s*·\s*\*\*Preço base:\*\*\s*(.+)", corpo_item)
        if m_req:
            requisito, preco = m_req.group(1).strip(), m_req.group(2).strip()
        m_efeito = re.search(r"\*\*Efeito:\*\*\s*(.+?)(?=\n\*\*Como (?:obter|conseguir)|\Z)", corpo_item, re.S)
        efeito = m_efeito.group(1).strip() if m_efeito else ""
        efeito = re.sub(r"\s*\n\s*", " ", efeito)
        itens.append((nome, raridade, requisito, preco, efeito))
    return slot, itens


def gerar_equipamentos_html():
    arquivos = sorted(glob.glob(os.path.join(DIR_EQUIPAMENTOS, "*.md")))
    total = 0
    blocos = []
    for caminho in arquivos:
        base = os.path.basename(caminho)
        if base.startswith("00_indice"):
            continue
        slot, itens = parsear_arquivo_equipamento(caminho)
        if not itens:
            continue
        itens.sort(key=lambda it: (ORDEM_RARIDADE.get(it[1].lower(), 9), it[0]))
        total += len(itens)
        linhas = []
        for nome, raridade, requisito, preco, efeito in itens:
            url_icone = url_imagem(f"equip_{slugify(nome).replace('-', '_')}.png")
            icone_html = f'<img class="eq-icone" src="{url_icone}" alt="">' if url_icone else ""
            linhas.append(
                "<tr>"
                f'<td class="eq-icone-cel">{icone_html}</td>'
                f'<td class="eq-nome">{inline_md(html.escape(nome))}</td>'
                f'<td class="eq-rar eq-rar-{slugify(raridade)}">{html.escape(raridade)}</td>'
                f"<td>{inline_md(html.escape(requisito)) or '—'}</td>"
                f"<td>{inline_md(html.escape(preco))}</td>"
                f"<td>{inline_md(html.escape(efeito))}</td>"
                "</tr>"
            )
        blocos.append(
            f'<h3>{html.escape(slot)}</h3>'
            '<div class="tabela-wrap"><table class="eq-tabela">'
            "<thead><tr><th></th><th>Item</th><th>Raridade</th><th>Requisito</th><th>Preço</th><th>Efeito</th></tr></thead>"
            f"<tbody>{''.join(linhas)}</tbody></table></div>"
        )
    return (
        '<h1 id="equipamentos-catalogo">Catálogo de Equipamentos</h1>\n'
        '<p>Todos os itens vestíveis e consumíveis já catalogados, por slot. Bônus numérico '
        'segue a escala de raridade da Seção 51/72 (Comum +0, Incomum +1, Raro +2, Épico +3, '
        'Lendário +3 e efeito único) — só um item ofensivo por personagem soma bônus de '
        'ataque/dano ao mesmo tempo.</p>\n' + "\n".join(blocos),
        total,
    )


# --------------------------------------------------------------------------
# NPCs notáveis
# --------------------------------------------------------------------------

def gerar_npc_card(caminho):
    with open(caminho, encoding="utf-8") as f:
        texto = f.read()
    fm, corpo = ler_frontmatter(texto)
    nome = fm.get("nome")
    if not nome:
        return None
    andar = fm.get("andar", "?")
    localizacao = fm.get("localizacao", "")
    papel = fm.get("papel", "")
    profissao = fm.get("profissao", "")
    arma = fm.get("arma", "")
    guilda = fm.get("guilda", "")
    atributos = fm.get("atributos") or fm.get("atributos_dnd") or {}

    corpo_html, _ = md_para_html(corpo)
    slug = slugify(nome)

    linha_ficha = []
    if localizacao:
        linha_ficha.append(f"<b>Onde:</b> {html.escape(localizacao)}")
    if papel:
        linha_ficha.append(f"<b>Papel:</b> {html.escape(papel)}")
    if profissao and profissao.lower() not in ("nenhuma", ""):
        linha_ficha.append(f"<b>Profissão:</b> {html.escape(profissao)}")
    if arma and arma.lower() not in ("nenhuma", ""):
        linha_ficha.append(f"<b>Arma:</b> {html.escape(arma)}")
    if guilda:
        linha_ficha.append(f"<b>Guilda:</b> {html.escape(guilda)}")

    attr_html = ""
    if isinstance(atributos, dict) and atributos:
        pares = " · ".join(f"{k.upper()[:3]} {v}" for k, v in atributos.items())
        attr_html = f'<div class="npc-attrs">{html.escape(pares)}</div>'

    url_retrato = url_imagem_frontmatter(fm.get("imagem")) or url_imagem(f"npc_{slug.replace('-', '_')}.png")
    retrato_html = f'<img class="npc-retrato" src="{url_retrato}" alt="{html.escape(nome)}">' if url_retrato else ""
    classe = "npc-card" + (" npc-card-com-arte" if url_retrato else "")

    return andar, nome, (
        f'<div class="{classe}" id="npc-{slug}">'
        f'{retrato_html}'
        f'<div class="npc-corpo">'
        f'<h3 class="npc-nome">{html.escape(nome)} <span class="npc-andar">Andar {html.escape(str(andar))}</span></h3>'
        f'<div class="npc-ficha">{" &nbsp;·&nbsp; ".join(linha_ficha)}</div>'
        f'{attr_html}'
        f'<div class="npc-texto">{corpo_html}</div>'
        f'</div>'
        '</div>'
    )


def gerar_npcs_html():
    entradas = []
    for caminho in sorted(glob.glob(os.path.join(DIR_NPCS, "*.md"))):
        if os.path.basename(caminho).startswith("_modelo"):
            continue
        r = gerar_npc_card(caminho)
        if r:
            entradas.append(r)
    entradas.sort(key=lambda e: (str(e[0]), e[1]))
    blocos = [e[2] for e in entradas]
    return (
        '<h1 id="npcs-notaveis">NPCs Notáveis</h1>\n'
        '<p>Personagens recorrentes de Aincrad — comerciantes, guias, contatos de guilda e '
        'ganchos de aventura. Atributos já convertidos pra D&amp;D 5e onde catalogados.</p>\n'
        + "\n".join(blocos),
        len(entradas),
    )


# --------------------------------------------------------------------------
# Galeria de armas (arte das 19 armas oficiais + variantes catalogadas)
# --------------------------------------------------------------------------

DIR_ARMAS = os.path.join(RAIZ_PROJETO, "armas")


def gerar_galeria_armas_html():
    cartas = []
    for caminho in sorted(glob.glob(os.path.join(DIR_ARMAS, "*.md"))):
        base = os.path.basename(caminho)
        if base.startswith("_modelo") or base.startswith("00_"):
            continue
        with open(caminho, encoding="utf-8") as f:
            fm, _ = ler_frontmatter(f.read())
        nome = fm.get("nome")
        if not nome:
            continue
        slug = slugify(nome).replace("-", "_")
        url = url_imagem(f"arma_{slug}.png", lado_max=220)
        if not url:
            continue
        tipo = fm.get("tipo", "")
        raridade = fm.get("raridade", "")
        legenda = " · ".join(x for x in (tipo, raridade) if x)
        cartas.append(
            '<div class="arma-carta">'
            f'<img src="{url}" alt="{html.escape(nome)}">'
            f'<div class="arma-carta-nome">{html.escape(nome)}</div>'
            f'<div class="arma-carta-legenda">{html.escape(legenda)}</div>'
            '</div>'
        )
    if not cartas:
        return "", 0
    return (
        '<h1 id="galeria-armas">Galeria de Armas</h1>\n'
        '<p>Instâncias de arma já catalogadas em Aincrad — cada uma segue as Sword Skills '
        'da sua categoria (Seções 55–58 do sistema base) e a escala de raridade da Seção 51.</p>\n'
        f'<div class="arma-galeria">{"".join(cartas)}</div>',
        len(cartas),
    )


# --------------------------------------------------------------------------
# Regiões de Aincrad
# --------------------------------------------------------------------------

def gerar_regiao_card(caminho):
    with open(caminho, encoding="utf-8") as f:
        texto = f.read()
    fm, corpo = ler_frontmatter(texto)
    nome = fm.get("nome")
    if not nome:
        return None
    andar = fm.get("andar", "?")
    tipo_zona = fm.get("tipo_de_zona", "")
    guildas = fm.get("guildas_presentes") or []
    if isinstance(guildas, str):
        guildas = [guildas]

    corpo_html, _ = md_para_html(corpo)
    slug = slugify(nome)

    cabecalho = f"Andar {andar}"
    if tipo_zona:
        cabecalho += f" · {tipo_zona}"
    guildas_html = f'<div class="regiao-guildas"><b>Guildas presentes:</b> {html.escape(", ".join(guildas))}</div>' if guildas else ""

    return andar, nome, (
        f'<div class="regiao-card" id="regiao-{slug}">'
        f'<h2 class="regiao-nome">{html.escape(nome)}</h2>'
        f'<div class="regiao-sub">{html.escape(cabecalho)}</div>'
        f'{guildas_html}'
        f'<div class="regiao-texto">{corpo_html}</div>'
        '</div>'
    )


def gerar_regioes_html():
    entradas = []
    for caminho in sorted(glob.glob(os.path.join(DIR_CIDADES, "*.md"))):
        if os.path.basename(caminho).startswith("_modelo"):
            continue
        r = gerar_regiao_card(caminho)
        if r:
            entradas.append(r)
    entradas.sort(key=lambda e: (str(e[0]), e[1]))
    blocos = [e[2] for e in entradas]

    with open(CAMINHO_MD_RULEBOOK, encoding="utf-8") as f:
        rulebook = f.read()
    m = re.search(r"# 77\. ANDARES CONHECIDOS.*?\n(.*?)(?=^# 78\. )", rulebook, re.M | re.S)
    andares_html = ""
    if m:
        conteudo, _ = md_para_html(m.group(1).strip())
        andares_html = f'<h2>Andares conhecidos de Aincrad (referência canônica)</h2>\n{conteudo}'

    return (
        '<h1 id="regioes">Regiões de Aincrad</h1>\n'
        '<p>Cidades e zonas já detalhadas pra jogo, seguidas da referência canônica de '
        'todos os 100 andares conhecidos (nomes e locais confirmados no cânone, mesmo pros '
        'ainda não desenvolvidos em detalhe).</p>\n'
        + "\n".join(blocos) + "\n" + andares_html,
        len(entradas),
    )


# --------------------------------------------------------------------------
# CSS adicional (stat block / cartas de item / npc / regiao)
# --------------------------------------------------------------------------

CSS_EXTRA = """
.statblock {
  break-inside: avoid; page-break-inside: avoid;
  border: 1.5pt solid #8a1f11; background: #fbf6ea; border-radius: 3pt;
  padding: 10pt 12pt; margin: 0 0 14pt;
}
.statblock-com-arte { display: flex; gap: 10pt; align-items: flex-start; }
.sb-retrato {
  width: 90pt; height: 90pt; object-fit: cover; border-radius: 3pt;
  border: 1.5pt solid #8a1f11; flex-shrink: 0;
}
.sb-conteudo { flex: 1; min-width: 0; }
.bestiario-grid { display: block; }
.sb-barra { height: 3pt; background: linear-gradient(90deg, #8a1f11, #c9552f, #8a1f11); margin: 4pt 0; border-radius: 2pt; }
.sb-nome { font-size: 13pt; color: #6a1810; margin: 4pt 0 0; }
.sb-sub { font-style: italic; color: #6b5738; font-size: 9.5pt; margin-bottom: 2pt; }
.sb-linha { font-size: 10pt; margin: 3pt 0; }
.sb-secao { font-weight: bold; color: #6a1810; margin: 8pt 0 2pt; font-size: 10.5pt; border-bottom: 1pt solid #d8c9a3; }
.sb-texto { font-size: 10pt; }
.sb-texto p { margin: 0 0 5pt; }
.sb-lore { font-style: italic; }

.eq-tabela { font-size: 9pt; }
.eq-icone-cel { width: 20pt; padding: 2pt 3pt !important; }
.eq-icone { width: 18pt; height: 18pt; object-fit: contain; display: block; }
.eq-nome { font-weight: bold; color: #4a3d28; white-space: nowrap; }
.eq-rar { font-size: 8.5pt; font-weight: bold; text-transform: uppercase; white-space: nowrap; }
.eq-rar-comum { color: #5b5b5b; }
.eq-rar-incomum { color: #2e7d32; }
.eq-rar-raro { color: #1565c0; }
.eq-rar-épico, .eq-rar-épica { color: #7b1fa2; }
.eq-rar-lendário, .eq-rar-lendária { color: #b8860b; }
.eq-rar-único, .eq-rar-única { color: #8a1f11; }

.npc-card { break-inside: avoid; page-break-inside: avoid; margin: 0 0 14pt; padding-bottom: 10pt; border-bottom: 1pt solid #d8c9a3; }
.npc-card-com-arte { display: flex; gap: 10pt; align-items: flex-start; }
.npc-retrato {
  width: 70pt; height: 70pt; object-fit: cover; border-radius: 50%;
  border: 2pt solid #8a1f11; flex-shrink: 0;
}
.npc-corpo { flex: 1; min-width: 0; }
.npc-nome { color: #6a1810; margin: 0 0 2pt; }
.npc-andar { font-size: 9pt; color: #8a7350; font-weight: normal; }
.npc-ficha { font-size: 9.5pt; color: #4a3d28; margin-bottom: 4pt; }
.npc-attrs { font-size: 9pt; color: #6b5738; font-family: Consolas, monospace; margin-bottom: 4pt; }
.npc-texto { font-size: 10pt; }
.npc-texto p { margin: 0 0 5pt; }
.npc-texto h2, .npc-texto h3 { font-size: 10pt; color: #6a1810; margin: 8pt 0 3pt; border: none; text-transform: uppercase; letter-spacing: .3pt; }
.regiao-texto h2, .regiao-texto h3 { font-size: 11pt; color: #6a1810; margin: 10pt 0 4pt; border: none; }

.arma-galeria { display: flex; flex-wrap: wrap; gap: 10pt; justify-content: center; }
.arma-carta { width: 100pt; text-align: center; break-inside: avoid; }
.arma-carta img {
  width: 100pt; height: 100pt; object-fit: cover; border-radius: 4pt;
  border: 1.5pt solid #8a1f11; background: #fff;
}
.arma-carta-nome { font-size: 8.5pt; color: #4a3d28; margin-top: 3pt; font-weight: bold; }
.arma-carta-legenda { font-size: 7.5pt; color: #8a7350; }

.capa-arte {
  position: relative; min-height: 240mm; display: flex; flex-direction: column;
  align-items: center; justify-content: flex-end; text-align: center;
  padding: 0 20mm 30mm; background-size: cover; background-position: center 20%;
  background-color: #1a1410;
}
.capa-arte::before {
  content: ""; position: absolute; inset: 0;
  background: linear-gradient(180deg, rgba(10,8,6,.15) 0%, rgba(10,8,6,.55) 55%, rgba(10,8,6,.92) 100%);
}
.capa-arte > * { position: relative; z-index: 1; }
.capa-arte h1 {
  font-size: 44pt; letter-spacing: 4pt; margin: 0 0 4pt; color: #f4ecd8;
  text-transform: uppercase; border: none; text-shadow: 0 2pt 8pt rgba(0,0,0,.8);
}
.capa-arte .subtitulo { font-size: 14pt; letter-spacing: 2pt; color: #e0a85a; margin-bottom: 10pt; text-shadow: 0 1pt 4pt rgba(0,0,0,.8); }
.capa-arte .linha { width: 140pt; height: 1pt; background: #8a1f11; margin: 10pt auto; }
.capa-arte .versao { font-size: 11pt; color: #d8c9a3; font-weight: bold; margin-bottom: 8pt; letter-spacing: 1pt; }
.capa-arte .rodape-capa { font-size: 9.5pt; color: #c9b78f; }

.regiao-card { margin: 0 0 20pt; }
.regiao-nome { color: #6a1810; margin-bottom: 2pt; }
.regiao-sub { font-style: italic; color: #6b5738; margin-bottom: 6pt; }
.regiao-guildas { font-size: 10pt; margin-bottom: 8pt; }
.regiao-texto p { text-align: justify; }
"""


# --------------------------------------------------------------------------
# montagem final
# --------------------------------------------------------------------------

def montar_sumario_html(toc):
    linhas = []
    for nivel, titulo, slug in toc:
        classe = "nivel-1" if nivel == 1 else "nivel-2"
        linhas.append(
            f'<div class="sumario-item {classe}"><a href="#{slug}">{html.escape(titulo)}</a>'
            f'<span class="pontos"></span></div>'
        )
    return "\n".join(linhas)


def gerar_html():
    with open(CAMINHO_MD_RULEBOOK, encoding="utf-8") as f:
        md_rulebook = f.read()
    md_rulebook = RE_EMOJI.sub("", md_rulebook)
    rulebook_html, toc = md_para_html(md_rulebook)

    print("Montando Bestiário...")
    bestiario_html, n_monstros = gerar_bestiario_html()
    print(f"  {n_monstros} monstros")

    print("Montando Equipamentos...")
    equipamentos_html, n_itens = gerar_equipamentos_html()
    print(f"  {n_itens} itens")

    print("Montando NPCs...")
    npcs_html, n_npcs = gerar_npcs_html()
    print(f"  {n_npcs} NPCs")

    print("Montando Galeria de Armas...")
    galeria_armas_html, n_armas_arte = gerar_galeria_armas_html()
    print(f"  {n_armas_arte} armas com arte")

    print("Montando Regiões...")
    regioes_html, n_regioes = gerar_regioes_html()
    print(f"  {n_regioes} regiões detalhadas")

    toc_extra = [
        (1, "Bestiário de Aincrad", "bestiario"),
        (1, "Catálogo de Equipamentos", "equipamentos-catalogo"),
        (1, "NPCs Notáveis", "npcs-notaveis"),
    ]
    if galeria_armas_html:
        toc_extra.append((1, "Galeria de Armas", "galeria-armas"))
    toc_extra.append((1, "Regiões de Aincrad", "regioes"))
    sumario_html = montar_sumario_html(toc + toc_extra)

    url_capa = url_imagem("carta_illfang_the_kobold_lord.png", lado_max=900)
    estilo_capa_bg = f' style="background-image: url(\'{url_capa}\')"' if url_capa else ""
    classe_capa = "capa-arte" if url_capa else "capa"

    from _gerar_pdf_rulebook import CSS as CSS_BASE  # noqa: E402

    doc = f"""<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<title>SAO RPG 5e — Sistema Completo</title>
<style>{CSS_BASE}
{CSS_EXTRA}</style>
</head>
<body>

<div class="pagina {classe_capa}"{estilo_capa_bg}>
  {'' if url_capa else '<div class="emblema">⚔ ✦ ⚔</div>'}
  <h1>SAO RPG 5e</h1>
  <div class="subtitulo">SWORD ART ONLINE · SISTEMA COMPLETO</div>
  <div class="linha"></div>
  <div class="versao">REGRAS · BESTIÁRIO · EQUIPAMENTOS · NPCS · REGIÕES</div>
  <div class="rodape-capa">
    Aincrad adaptado pra estrutura mecânica de D&amp;D 5e — d20, atributos,<br>
    proficiência, Sword Skills, profissões, progressão por nível,<br>
    criaturas, itens, personagens e andares catalogados até aqui.<br><br>
    Uso de mesa — material de campanha, não comercial.
  </div>
</div>

<div class="pagina pb sumario">
  <h1>Sumário</h1>
  <div class="sumario-lista">
    {sumario_html}
  </div>
</div>

<div class="pagina pb">
{rulebook_html}
</div>

<div class="pagina pb">
{bestiario_html}
</div>

<div class="pagina pb">
{equipamentos_html}
</div>

<div class="pagina pb">
{npcs_html}
</div>

{f'<div class="pagina pb">{galeria_armas_html}</div>' if galeria_armas_html else ''}

<div class="pagina pb">
{regioes_html}
<div class="rodape-final">SAO RPG 5e — Sistema Completo · gerado a partir de SAO_RPG_5e.md, monstros/, equipamentos/, npcs/ e cidades/</div>
</div>

</body>
</html>
"""
    os.makedirs(os.path.dirname(CAMINHO_HTML), exist_ok=True)
    with open(CAMINHO_HTML, "w", encoding="utf-8") as f:
        f.write(doc)
    return CAMINHO_HTML


def gerar_pdf(caminho_html):
    navegador = achar_navegador()
    url = "file:///" + caminho_html.replace("\\", "/")
    cmd = [
        navegador, "--headless", "--disable-gpu", "--no-pdf-header-footer",
        f"--print-to-pdf={CAMINHO_PDF}", url,
    ]
    resultado = subprocess.run(
        cmd, capture_output=True, text=True, timeout=240,
        encoding="utf-8", errors="replace",
    )
    if resultado.returncode != 0:
        print(resultado.stdout)
        print(resultado.stderr)
        raise RuntimeError("Falha ao gerar PDF")
    print(resultado.stdout.strip() or f"PDF escrito em {CAMINHO_PDF}")


if __name__ == "__main__":
    caminho_html = gerar_html()
    print(f"HTML intermediário: {caminho_html}")
    gerar_pdf(caminho_html)
    tamanho = os.path.getsize(CAMINHO_PDF)
    print(f"PDF final: {CAMINHO_PDF} ({tamanho} bytes)")
