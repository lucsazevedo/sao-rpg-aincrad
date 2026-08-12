# -*- coding: utf-8 -*-
"""
Funções e dados compartilhados entre os dois manuais públicos
(_gerar_manual_jogador.py e _gerar_manual_mestre.py) — leitura do
conteúdo vivo do banco, escape/slug, ícones em data URI, e os
geradores de card de arma/profissão (idênticos nos dois manuais).
"""
import base64
import html
import json
import os
import unicodedata

RAIZ = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
AQUI = os.path.dirname(os.path.abspath(__file__))
CONTEUDO_PATH = os.path.join(AQUI, "_conteudo_livro.json")
IMAGENS_PROF = os.path.join(RAIZ, "imagens", "profissoes_icones")
IMAGENS_ARMA = os.path.join(RAIZ, "imagens", "armas_icones")

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

ATRIBUTO_CLASSE = {"Corpo": "cor", "Reflexo": "ref", "Técnica": "tec", "Conhecimento": "con", "Espírito": "esp"}
SIGLA_PARA_NOME = {"COR": "Corpo", "REF": "Reflexo", "TEC": "Técnica", "CON": "Conhecimento", "ESP": "Espírito"}

# "Faz" — resumo de uma linha por profissão (usuário pediu: "detalhado o
# que cada uma faz"). Mesmo texto da tabela em docs/guia_sistema_aincrad.md;
# Cartógrafo/Informante/Mestre de Montarias/Minerador atualizados pra
# reforma de roster de 12/08.
FAZ_PROFISSAO = {
    "Alquimista": "Cria poções e itens especiais usando misturas e reações químicas.",
    "Caçador": "Rastreia, caça, pesca e coleta materiais de criaturas e monstros.",
    "Cartógrafo": "Explora e revela mapas, descobre rotas e locais escondidos — e agora também documenta a história do andar (absorveu o papel de Historiador).",
    "Comerciante": "Negocia, compra e vende itens e informações.",
    "Costureiro": "Cria e aprimora roupas e itens de tecido.",
    "Cozinheiro": "Prepara refeições que recuperam energia e concedem bônus temporários.",
    "Domador": "Treina e cria laços com criaturas; comanda aliados em batalha.",
    "Ferreiro": "Forja armas, armaduras e ferramentas; domina fogo e metal.",
    "Informante": "Reúne pesquisa, contatos, rumores e leitura social — sabe onde procurar e com quem falar.",
    "Joalheiro": "Cria, repara e aprimora anéis, colares, pedras preciosas e acessórios.",
    "Lenhador": "Coleta madeira e recursos da natureza com agilidade.",
    "Médico": "Cuida de ferimentos, doenças e efeitos negativos; especialista em cura.",
    "Mercenário": "Guerreiro de aluguel; combate corpo a corpo, escolta e trabalho perigoso — inclusive o que era do Coveiro (recuperação de corpos).",
    "Mestre de Montarias": "Aproxima, doma e conduz criaturas usadas como montaria.",
    "Minerador": "Escava túneis e extrai minérios das regiões mais perigosas e profundas.",
    "Músico": "Usa música para inspirar aliados, fortalecer o moral e influenciar emoções.",
}

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

def carregar_dados():
    with open(CONTEUDO_PATH, encoding="utf-8") as f:
        return json.load(f)

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
    faz = FAZ_PROFISSAO.get(p["nome"], "")
    faz_html = f'<p class="entrada-faz"><b>Faz:</b> {esc(faz)}</p>' if faz else ""
    return f'''<section class="entrada entrada-prof attr-{classe_attr}" id="prof-{sid}">
      <header class="entrada-head">
        <div class="entrada-head-nome">
          {icone}
          <h3>{esc(p["nome"])}</h3>
        </div>
        <span class="pill-attr">{esc(atributo)}</span>
      </header>
      <p class="entrada-marca">{esc(p.get("marca", ""))}</p>
      {faz_html}
      <div class="moves-grid">{moves_html}</div>
    </section>'''

def chip_indice(nome, alvo, atributo_nome):
    classe_attr = ATRIBUTO_CLASSE.get(atributo_nome, "")
    return f'<a class="chip attr-{classe_attr}" href="#{alvo}-{slug(nome)}"><span class="chip-dot"></span>{esc(nome)}</a>'

def montar_armas_e_profissoes(dados):
    armas_ordenadas = sorted(dados["armas"], key=lambda a: a["nome"])
    profissoes_ordenadas = sorted(dados["profissoes"], key=lambda p: p["nome"])
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
    return indice_armas, indice_profissoes, armas_html, profissoes_html
