# -*- coding: utf-8 -*-
"""
Gera o livro de regras público (HTML) a partir de:
  - scripts/db/_conteudo_livro.json (23 armas + 16 profissões, puxado do
    banco ao vivo por _extrair_conteudo_livro.py)
  - texto curado à mão pras seções de mundo/mecânica (abaixo), baseado em
    docs/guia_sistema_aincrad.md e docs/regras_nucleares_campanha.md

Rode: python scripts/db/_gerar_livro_regras.py <caminho_saida.html>
"""
import base64
import html
import json
import os
import sys
import unicodedata

RAIZ = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CONTEUDO_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "_conteudo_livro.json")
IMAGENS_PROF = os.path.join(RAIZ, "imagens", "profissoes_icones")
IMAGENS_ARMA = os.path.join(RAIZ, "imagens", "armas_icones")

# Artifact tem CSP estrita — nada de <img src="caminho relativo"> ou URL
# externa (nem raw.githubusercontent). Os ícones (pequenos, ~220KB no
# total) entram embutidos como data URI.
_cache_datauri = {}
def datauri_png(caminho):
    if caminho not in _cache_datauri:
        if not os.path.exists(caminho):
            _cache_datauri[caminho] = ""
        else:
            with open(caminho, "rb") as f:
                b64 = base64.b64encode(f.read()).decode("ascii")
            _cache_datauri[caminho] = f"data:image/png;base64,{b64}"
    return _cache_datauri[caminho]

with open(CONTEUDO_PATH, encoding="utf-8") as f:
    DADOS = json.load(f)

def esc(s):
    return html.escape(str(s or ""), quote=True)

def slug(s):
    s = unicodedata.normalize("NFD", str(s))
    s = "".join(c for c in s if unicodedata.category(c) != "Mn")
    s = s.lower().strip()
    s = "".join(c if c.isalnum() else "-" for c in s)
    while "--" in s:
        s = s.replace("--", "-")
    return s.strip("-")

ATRIBUTO_SIGLA = {"Corpo": "COR", "Reflexo": "REF", "Técnica": "TEC", "Conhecimento": "CON", "Espírito": "ESP"}
ATRIBUTO_CLASSE = {"Corpo": "cor", "Reflexo": "ref", "Técnica": "tec", "Conhecimento": "con", "Espírito": "esp"}
SIGLA_PARA_NOME = {"COR": "Corpo", "REF": "Reflexo", "TEC": "Técnica", "CON": "Conhecimento", "ESP": "Espírito"}

def lista_ou_paragrafo(v):
    """dez_mais/sete_nove vêm como lista (armas + move exclusivo de profissão)
    ou string única (move de ofício/cena mais antigo). Normaliza pra <ul>/<p>."""
    if v is None:
        return ""
    if isinstance(v, list):
        if not v:
            return ""
        itens = "".join(f"<li>{esc(i)}</li>" for i in v)
        return f"<ul>{itens}</ul>"
    return f"<p>{esc(v)}</p>"

def bloco_move(move, rotulo, variante=""):
    if not move or not move.get("nome"):
        return ""
    atributo = move.get("atributo", "")
    bonus = move.get("bonus_acerto", "")
    dez = lista_ou_paragrafo(move.get("dez_mais"))
    sete = lista_ou_paragrafo(move.get("sete_nove"))
    seis = lista_ou_paragrafo(move.get("seis_menos"))
    resultados = ""
    if dez:
        resultados += f'<div class="resultado r-dez"><span class="r-tag">10+</span><div class="r-corpo">{dez}</div></div>'
    if sete:
        resultados += f'<div class="resultado r-sete"><span class="r-tag">7–9</span><div class="r-corpo">{sete}</div></div>'
    if seis:
        resultados += f'<div class="resultado r-seis"><span class="r-tag">6−</span><div class="r-corpo">{seis}</div></div>'
    bonus_html = f'<span class="move-bonus">{esc(bonus)}</span>' if bonus else ""
    return f'''<article class="move {esc(variante)}">
      <div class="move-eyebrow">{esc(rotulo)}</div>
      <header class="move-head">
        <h4>{esc(move["nome"])}</h4>
        <span class="move-attr">+{esc(atributo)}{bonus_html}</span>
      </header>
      <p class="move-gatilho">{esc(move.get("gatilho", ""))}</p>
      <div class="move-resultados">{resultados}</div>
    </article>'''

ICONE_PROF = {
    "Alquimista": "alquimista", "Caçador": "cacador", "Comerciante": "comerciante",
    "Costureiro": "costureiro", "Cozinheiro": "cozinheiro", "Domador": "domador",
    "Ferreiro": "ferreiro", "Informante": "informante", "Lenhador": "lenhador",
    "Mercenário": "mercenario", "Médico": "medico", "Mestre de Montarias": "mestre_de_montarias",
    "Minerador": "minerador", "Músico": "musico", "Joalheiro": "joalheiro",
}
ICONE_ARMA = {
    "Chakrams": "chakrams", "Escudo e Espada": "escudo_e_espada", "Espada Longa": "espada_longa",
    "Foice": "foice", "Katana": "katana", "Lança": "lanca", "Machado": "machado", "Martelo": "martelo",
    "Rapieira": "rapieira", "Bastão": "bastao", "Clava": "clava", "Corrente com Peso": "corrente_com_peso",
    "Leque": "leque",
}

def icone_img_html(pasta, slug_map, chave, classe):
    slug_arq = slug_map.get(chave)
    if not slug_arq:
        return ""
    uri = datauri_png(os.path.join(pasta, f"{slug_arq}.png"))
    if not uri:
        return ""
    return f'<img class="{classe}" src="{uri}" alt="">'

def card_arma(a):
    sid = slug(a["nome"])
    atributo = a.get("move_a", {}).get("atributo") or SIGLA_PARA_NOME.get(a.get("atributo", ""), a.get("atributo", ""))
    classe_attr = ATRIBUTO_CLASSE.get(atributo, "")
    moves_html = (
        bloco_move(a.get("move_a"), "Move I")
        + bloco_move(a.get("golpe_2"), "Move II")
        + bloco_move(a.get("limit_breaker"), "LIMIT BREAK", variante="move-limitbreak")
    )
    icone = icone_img_html(IMAGENS_ARMA, ICONE_ARMA, a["nome"], "entrada-icone")
    return f'''<section class="entrada entrada-arma attr-{classe_attr}" id="arma-{sid}">
      <header class="entrada-head">
        <div class="entrada-head-nome">
          {icone}
          <h3>{esc(a["nome"])}</h3>
        </div>
        <span class="pill-attr">{esc(atributo)}</span>
      </header>
      <p class="entrada-marca">{esc(a.get("marca", ""))}</p>
      <div class="moves-grid">{moves_html}</div>
    </section>'''

def card_profissao(p):
    sid = slug(p["nome"])
    atributo = p.get("move_c", {}).get("atributo") or p.get("move_a", {}).get("atributo") or SIGLA_PARA_NOME.get(p.get("atributo", ""), p.get("atributo", ""))
    classe_attr = ATRIBUTO_CLASSE.get(atributo, "")
    moves_html = (
        bloco_move(p.get("move_a"), "Move de Ofício")
        + bloco_move(p.get("move_b"), "Move de Cena")
        + bloco_move(p.get("move_c"), "Move Exclusivo", variante="move-exclusivo")
    )
    icone = icone_img_html(IMAGENS_PROF, ICONE_PROF, p["nome"], "entrada-icone")
    return f'''<section class="entrada entrada-prof attr-{classe_attr}" id="prof-{sid}">
      <header class="entrada-head">
        <div class="entrada-head-nome">
          {icone}
          <h3>{esc(p["nome"])}</h3>
        </div>
        <span class="pill-attr">{esc(atributo)}</span>
      </header>
      <p class="entrada-marca">{esc(p.get("marca", ""))}</p>
      <div class="moves-grid">{moves_html}</div>
    </section>'''

def chip_indice(nome, alvo, atributo_nome):
    classe_attr = ATRIBUTO_CLASSE.get(atributo_nome, "")
    return f'<a class="chip attr-{classe_attr}" href="#{alvo}-{slug(nome)}"><span class="chip-dot"></span>{esc(nome)}</a>'

armas_ordenadas = sorted(DADOS["armas"], key=lambda a: a["nome"])
profissoes_ordenadas = sorted(DADOS["profissoes"], key=lambda p: p["nome"])

indice_armas = "".join(
    chip_indice(a["nome"], "arma", a.get("move_a", {}).get("atributo") or SIGLA_PARA_NOME.get(a.get("atributo", ""), ""))
    for a in armas_ordenadas
)
indice_profissoes = "".join(
    chip_indice(p["nome"], "prof", p.get("move_c", {}).get("atributo") or p.get("move_a", {}).get("atributo") or SIGLA_PARA_NOME.get(p.get("atributo", ""), ""))
    for p in profissoes_ordenadas
)

armas_html = "".join(card_arma(a) for a in armas_ordenadas)
profissoes_html = "".join(card_profissao(p) for p in profissoes_ordenadas)

print(f"armas: {len(armas_ordenadas)}  profissoes: {len(profissoes_ordenadas)}")

# ============================================================ template
TEMPLATE_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "_livro_template.html")
with open(TEMPLATE_PATH, encoding="utf-8") as f:
    template = f.read()

saida_html = (
    template
    .replace("__INDICE_ARMAS__", indice_armas)
    .replace("__INDICE_PROFISSOES__", indice_profissoes)
    .replace("__ARMAS__", armas_html)
    .replace("__PROFISSOES__", profissoes_html)
)

destino = sys.argv[1] if len(sys.argv) > 1 else os.path.join(RAIZ, "scripts", "_livro_regras.html")
with open(destino, "w", encoding="utf-8") as f:
    f.write(saida_html)
print("gravado em", destino)
