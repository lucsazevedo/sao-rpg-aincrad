#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Gera um PDF do SAO_RPG_5e.md inteiro, no estilo "livro de regras" (capa +
sumário + capítulos numerados, papel claro, tipografia serifada) parecido
com o "Sword Art Online 5e Conversion v1.0.pdf" que o usuário trouxe como
referência -- mas com o conteúdo completo do nosso próprio rulebook.

Conversor de markdown->HTML é escrito na mão (so' stdlib, convenção do
projeto) porque cobre só o subconjunto usado no SAO_RPG_5e.md: #/##
headers, tabelas, **negrito**, `código`, listas com/sem número,
blockquote (>), regra horizontal (---), links.

Renderização final pra PDF via Chrome/Edge headless --print-to-pdf (sem
dependência de lib de PDF -- usa o navegador já instalado na máquina).

Uso:
    python scripts/_gerar_pdf_rulebook.py
"""
import html
import os
import re
import subprocess
import sys

RAIZ = os.path.dirname(os.path.abspath(__file__))
RAIZ_PROJETO = os.path.dirname(RAIZ)
CAMINHO_MD = os.path.join(RAIZ_PROJETO, "SAO_RPG_5e.md")
CAMINHO_HTML = os.path.join(RAIZ_PROJETO, "entregas", "_sao_rpg_5e_gerado.html")
CAMINHO_PDF = os.path.join(RAIZ_PROJETO, "entregas", "SAO_RPG_5e_Documento_Completo.pdf")

NAVEGADORES = [
    r"C:\Program Files\Google\Chrome\Application\chrome.exe",
    r"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
    r"C:\Program Files\Microsoft\Edge\Application\msedge.exe",
    r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
]


# --------------------------------------------------------------------------
# markdown -> HTML (subconjunto usado no documento)
# --------------------------------------------------------------------------

def slugify(txt):
    txt = re.sub(r"[^\w\s-]", "", txt, flags=re.UNICODE).strip().lower()
    return re.sub(r"[\s_]+", "-", txt)


def inline_md(texto):
    """negrito, código inline, links -- dentro de uma linha/parágrafo já
    escapado de HTML."""
    texto = re.sub(r"\*\*(.+?)\*\*", r"<b>\1</b>", texto)
    texto = re.sub(r"`(.+?)`", r"<code>\1</code>", texto)
    texto = re.sub(r"\[(.+?)\]\((.+?)\)", r'<a href="\2">\1</a>', texto)
    return texto


def eh_linha_tabela(linha):
    return linha.strip().startswith("|") and linha.strip().endswith("|")


def eh_separador_tabela(linha):
    return bool(re.match(r"^\|[\s:|-]+\|$", linha.strip()))


def parsear_tabela(linhas, i):
    """linhas[i] é o cabeçalho da tabela. Devolve (html, proximo_i)."""
    def celulas(linha):
        partes = linha.strip().strip("|").split("|")
        return [inline_md(html.escape(p.strip())) for p in partes]

    cab = celulas(linhas[i])
    i += 1
    if i < len(linhas) and eh_separador_tabela(linhas[i]):
        i += 1
    corpo = []
    while i < len(linhas) and eh_linha_tabela(linhas[i]):
        corpo.append(celulas(linhas[i]))
        i += 1

    out = ['<table>', '<thead><tr>']
    for c in cab:
        out.append(f'<th>{c}</th>')
    out.append('</tr></thead><tbody>')
    for linha in corpo:
        out.append('<tr>')
        for c in linha:
            out.append(f'<td>{c}</td>')
        out.append('</tr>')
    out.append('</tbody></table>')
    return "\n".join(out), i


def md_para_html(texto):
    linhas = texto.split("\n")
    out = []
    toc = []  # [(nivel, titulo, slug)]
    i = 0
    buffer_paragrafo = []
    lista_atual = None  # 'ul' | 'ol' | None

    def fecha_paragrafo():
        if buffer_paragrafo:
            # markdown "hard break": linha original terminava em 2+ espaços
            # -> essas juntam com <br>, as demais só com espaço normal.
            partes = []
            for j, (texto_linha, forca_quebra) in enumerate(buffer_paragrafo):
                if j > 0:
                    partes.append("<br>" if buffer_paragrafo[j - 1][1] else " ")
                partes.append(inline_md(html.escape(texto_linha)))
            out.append("<p>" + "".join(partes) + "</p>")
            buffer_paragrafo.clear()

    def fecha_lista():
        nonlocal lista_atual
        if lista_atual:
            out.append(f"</{lista_atual}>")
            lista_atual = None

    while i < len(linhas):
        linha = linhas[i]
        s = linha.strip()

        if not s:
            fecha_paragrafo()
            fecha_lista()
            i += 1
            continue

        m_h = re.match(r"^(#{1,3})\s+(.+)$", s)
        if m_h:
            fecha_paragrafo()
            fecha_lista()
            nivel = len(m_h.group(1))
            titulo = m_h.group(2).strip()
            slug = slugify(titulo)
            tag = f"h{nivel}"
            out.append(f'<{tag} id="{slug}">{inline_md(html.escape(titulo))}</{tag}>')
            if nivel <= 2:
                toc.append((nivel, titulo, slug))
            i += 1
            continue

        if s == "---":
            fecha_paragrafo()
            fecha_lista()
            out.append("<hr>")
            i += 1
            continue

        if s.startswith(">"):
            fecha_paragrafo()
            fecha_lista()
            bloco = []
            while i < len(linhas) and linhas[i].strip().startswith(">"):
                bloco.append(linhas[i].strip().lstrip(">").strip())
                i += 1
            texto_bloco = " ".join(b for b in bloco if b)
            out.append(f'<blockquote>{inline_md(html.escape(texto_bloco))}</blockquote>')
            continue

        if eh_linha_tabela(s):
            fecha_paragrafo()
            fecha_lista()
            tabela_html, i = parsear_tabela(linhas, i)
            out.append(f'<div class="tabela-wrap">{tabela_html}</div>')
            continue

        m_li_ul = re.match(r"^[-*]\s+(.+)$", s)
        m_li_ol = re.match(r"^\d+\.\s+(.+)$", s)
        if m_li_ul or m_li_ol:
            fecha_paragrafo()
            tipo = "ul" if m_li_ul else "ol"
            if lista_atual != tipo:
                fecha_lista()
                out.append(f"<{tipo}>")
                lista_atual = tipo
            conteudo = (m_li_ul or m_li_ol).group(1)
            out.append(f"<li>{inline_md(html.escape(conteudo))}</li>")
            i += 1
            continue

        fecha_lista()
        buffer_paragrafo.append((s, linha.endswith("  ")))
        i += 1

    fecha_paragrafo()
    fecha_lista()
    return "\n".join(out), toc


# --------------------------------------------------------------------------
# HTML final (capa + sumário + conteúdo), estilo "livro de regras"
# --------------------------------------------------------------------------

CSS = """
@page {
  size: A4;
  margin: 22mm 20mm 20mm;
  @bottom-center { content: counter(page); font-family: 'Georgia', serif; font-size: 10pt; color: #6b5738; }
}
* { box-sizing: border-box; }
body {
  font-family: Georgia, 'Times New Roman', serif;
  font-size: 11.5pt;
  line-height: 1.5;
  color: #2b2115;
  background: #f4ecd8;
  margin: 0;
}
.pagina {
  background: #f4ecd8;
  background-image:
    radial-gradient(ellipse at top left, rgba(255,255,255,.25), transparent 60%),
    radial-gradient(ellipse at bottom right, rgba(0,0,0,.05), transparent 60%);
  padding: 0;
}
.pb { page-break-before: always; }

/* ===== capa ===== */
.capa {
  min-height: 240mm;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: 40mm 20mm;
}
.capa .emblema { font-size: 54pt; margin-bottom: 18pt; letter-spacing: 8pt; color: #8a1f11; }
.capa h1 {
  font-size: 46pt; letter-spacing: 4pt; margin: 0 0 6pt; color: #2b2115;
  text-transform: uppercase; border: none;
}
.capa .subtitulo { font-size: 15pt; letter-spacing: 2pt; color: #6b5738; margin-bottom: 40pt; }
.capa .versao { font-size: 12pt; color: #8a1f11; font-weight: bold; margin-bottom: 60pt; }
.capa .rodape-capa { font-size: 11pt; color: #6b5738; margin-top: auto; }
.capa .linha { width: 140pt; height: 1pt; background: #8a1f11; margin: 18pt auto; }

/* ===== sumário ===== */
.sumario h1 { text-align: center; margin-bottom: 24pt; }
.sumario-lista { columns: 1; }
.sumario-item { display: flex; align-items: baseline; margin: 3pt 0; font-size: 10.5pt; }
.sumario-item.nivel-1 { font-weight: bold; margin-top: 8pt; }
.sumario-item.nivel-2 { padding-left: 14pt; color: #4a3d28; font-size: 9.8pt; }
.sumario-item .pontos { flex: 1; border-bottom: 1px dotted #8a7350; margin: 0 4pt 2pt; }
.sumario-item a { color: inherit; text-decoration: none; }

/* ===== conteúdo ===== */
h1 {
  font-size: 18pt; color: #6a1810; border-bottom: 2pt solid #8a1f11; padding-bottom: 4pt;
  margin: 26pt 0 10pt; page-break-after: avoid;
}
h2 { font-size: 14pt; color: #6a1810; margin: 18pt 0 8pt; page-break-after: avoid; }
h3 { font-size: 12pt; color: #4a3d28; margin: 14pt 0 6pt; page-break-after: avoid; }
p { margin: 0 0 8pt; text-align: justify; }
b { color: #4a3d28; }
code { background: #e8dcc0; padding: 1pt 4pt; border-radius: 2pt; font-family: 'Consolas', monospace; font-size: 10pt; }
blockquote {
  margin: 10pt 0; padding: 8pt 14pt; border-left: 3pt solid #8a1f11;
  background: #ece0c4; font-style: italic; color: #4a3d28;
}
hr { border: none; border-top: 1pt solid #c9b78f; margin: 16pt 0; }
ul, ol { margin: 6pt 0 10pt; padding-left: 22pt; }
li { margin-bottom: 3pt; }
.tabela-wrap { overflow-x: auto; margin: 10pt 0; }
table { border-collapse: collapse; width: 100%; font-size: 10pt; }
th, td { border: 1pt solid #c9b78f; padding: 5pt 7pt; text-align: left; vertical-align: top; }
thead th { background: #e8dcc0; color: #4a3d28; }
tbody tr:nth-child(even) { background: rgba(0,0,0,.02); }
a { color: #6a1810; }

.rodape-final { text-align: center; color: #6b5738; font-size: 9.5pt; margin-top: 30pt; padding-top: 12pt; border-top: 1pt solid #c9b78f; }
"""


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
    with open(CAMINHO_MD, encoding="utf-8") as f:
        md = f.read()

    conteudo_html, toc = md_para_html(md)

    sumario_html = montar_sumario_html(toc)

    doc = f"""<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<title>SAO RPG 5e — Documento Completo</title>
<style>{CSS}</style>
</head>
<body>

<div class="pagina capa">
  <div class="emblema">⚔ ✦ ⚔</div>
  <h1>SAO RPG 5e</h1>
  <div class="subtitulo">SWORD ART ONLINE · CONVERSÃO PARA D&amp;D 5e</div>
  <div class="linha"></div>
  <div class="versao">DOCUMENTO COMPLETO — v1.0</div>
  <div class="rodape-capa">
    Aincrad adaptado pra estrutura mecânica de D&amp;D 5e — d20, atributos,<br>
    proficiência, Sword Skills, profissões e progressão por nível.<br><br>
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
{conteudo_html}
<div class="rodape-final">SAO RPG 5e — Documento Completo · gerado a partir de SAO_RPG_5e.md</div>
</div>

</body>
</html>
"""
    os.makedirs(os.path.dirname(CAMINHO_HTML), exist_ok=True)
    with open(CAMINHO_HTML, "w", encoding="utf-8") as f:
        f.write(doc)
    return CAMINHO_HTML


def achar_navegador():
    for caminho in NAVEGADORES:
        if os.path.exists(caminho):
            return caminho
    raise RuntimeError("Nenhum Chrome/Edge encontrado nos caminhos padrão.")


def gerar_pdf(caminho_html):
    navegador = achar_navegador()
    url = "file:///" + caminho_html.replace("\\", "/")
    cmd = [
        navegador, "--headless", "--disable-gpu", "--no-pdf-header-footer",
        f"--print-to-pdf={CAMINHO_PDF}", url,
    ]
    resultado = subprocess.run(
        cmd, capture_output=True, text=True, timeout=120,
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
