"""
Uso: python scripts/gerar_dados_web.py

Le os arquivos .md do projeto (monstros/, npcs/, armas/, equipamentos/,
docs/mercado_andar1.md, cenas/quests_andar1.md,
cenas/cronicas_de_aincrad_ep01_25.md, cenas/cronicas_de_aincrad_ep26_50.md)
e gera scripts/web/dados_conteudo.js -- a fonte de dados que o Compendio
(scripts/web/compendio_andar1.html) usa pras abas Bestiario, NPCs, Armas,
Equipamentos, Mercado, Quests e Crônicas.

Por que existe: antes, os arrays NPCS/MONSTROS/ARMAS viviam colados dentro
do HTML e desatualizavam toda vez que um .md novo era escrito (o bestiario
mostrava 7 de 32 por meses). Agora o .md e a unica fonte de verdade: escreveu
uma ficha nova, roda este script, o app atualiza sozinho -- inclusive os
contadores das abas.

So usa a stdlib. Rode de qualquer lugar; os caminhos sao resolvidos a partir
da posicao deste arquivo.
"""
import json
import os
import re
import unicodedata

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SAIDA = os.path.join(RAIZ, "scripts", "web", "dados_conteudo.js")


# ---------------------------------------------------------------- utilidades

def slug(txt):
    txt = unicodedata.normalize("NFKD", txt).encode("ascii", "ignore").decode("ascii")
    txt = re.sub(r"[^a-zA-Z0-9]+", "_", txt).strip("_").lower()
    return txt


def ler(caminho):
    with open(caminho, "r", encoding="utf-8") as f:
        return f.read()


def frontmatter(texto):
    """Le o bloco --- ... --- do topo. Suporta escalares, listas [a, b] e
    um nivel de aninhamento (usado por 'atributos:' nos NPCs)."""
    if not texto.startswith("---"):
        return {}, texto
    fim = texto.find("\n---", 3)
    if fim == -1:
        return {}, texto
    bloco = texto[3:fim].strip("\n")
    corpo = texto[fim + 4:]
    dados, pai = {}, None
    for linha in bloco.split("\n"):
        if not linha.strip() or linha.strip().startswith("#"):
            continue
        indentado = linha.startswith(("  ", "\t"))
        if ":" not in linha:
            continue
        chave, _, valor = linha.partition(":")
        chave = chave.strip()
        valor = valor.split(" #")[0].strip().strip('"')
        if indentado and pai:
            dados[pai][chave] = valor
        elif valor == "":
            pai = chave
            dados[chave] = {}
        else:
            pai = None
            if valor.startswith("[") and valor.endswith("]"):
                itens = [v.strip() for v in valor[1:-1].split(",") if v.strip()]
                dados[chave] = itens
            else:
                dados[chave] = valor
    for k, v in list(dados.items()):
        if isinstance(v, dict) and not v:
            dados[k] = ""
    return dados, corpo


def secoes(corpo, nivel="## "):
    """Divide o corpo em {titulo: texto} pelos cabecalhos do nivel dado."""
    out, atual, buf = {}, None, []
    for linha in corpo.split("\n"):
        if linha.startswith(nivel) and not linha.startswith(nivel + "#"):
            if atual:
                out[atual] = "\n".join(buf).strip()
            atual, buf = linha[len(nivel):].strip(), []
        elif atual is not None:
            buf.append(linha)
    if atual:
        out[atual] = "\n".join(buf).strip()
    return out


def primeiro_paragrafo(txt, limite=320):
    for bloco in (txt or "").split("\n\n"):
        bloco = " ".join(l.strip() for l in bloco.split("\n")).strip()
        if bloco and not bloco.startswith(("|", "-", "*", ">", "#")):
            return bloco if len(bloco) <= limite else bloco[:limite - 1].rsplit(" ", 1)[0] + "…"
    return ""


def linhas_tabela(txt):
    """Devolve as linhas de dados de todas as tabelas markdown do trecho."""
    out = []
    for linha in (txt or "").split("\n"):
        linha = linha.strip()
        if not linha.startswith("|"):
            continue
        celulas = [c.strip() for c in linha.strip("|").split("|")]
        if not celulas or set("".join(celulas)) <= set("-: "):
            continue
        out.append(celulas)
    return out


def limpa_md(txt):
    txt = re.sub(r"`([^`]*)`", r"\1", txt or "")
    txt = re.sub(r"\*\*([^*]*)\*\*", r"\1", txt)
    return txt.strip()


def existe_img(rel):
    return os.path.exists(os.path.join(RAIZ, rel.replace("/", os.sep)))


# ---------------------------------------------------------------- monstros

def carregar_monstros():
    dir_ = os.path.join(RAIZ, "monstros")
    saida = []
    for nome_arq in sorted(os.listdir(dir_)):
        if not nome_arq.endswith(".md") or nome_arq.startswith("_"):
            continue
        fm, corpo = frontmatter(ler(os.path.join(dir_, nome_arq)))
        s = secoes(corpo)
        ident = slug(fm.get("nome", nome_arq[:-3]))
        img_rel = "imagens/monstro_%s.png" % ident
        carta_rel = "imagens/carta_%s.png" % ident

        # Tabela de drop no padrao oficial: Item | Raridade | Qtd | Chance | Serve pra.
        # As fichas antigas tinham so Item | Chance -- ainda leem, com os campos vazios.
        drops = []
        for c in linhas_tabela(s.get("Tabela de drop", "")):
            if not c or c[0].lower() in ("item", ""):
                continue
            if len(c) >= 5:
                # "**Épico**" vem em negrito no md; os dados guardam so o nome
                drops.append({"item": c[0], "raridade": c[1].replace("*", "").strip(),
                              "qtd": c[2], "chance": c[3], "serve": c[4]})
            elif len(c) >= 2:
                drops.append({"item": c[0], "raridade": "", "qtd": "",
                              "chance": c[-1], "serve": ""})

        # "## Habitat" tem dois blocos: onde vive, e o **Comportamento:** em negrito.
        habitat_txt = s.get("Habitat", "")
        comportamento = primeiro_paragrafo(s.get("Comportamento", ""))
        if not comportamento and "**Comportamento:**" in habitat_txt:
            comportamento = habitat_txt.split("**Comportamento:**", 1)[1].strip()
        habitat = habitat_txt.split("**Comportamento:**", 1)[0].strip()

        fraquezas = [l.strip("-* ").strip()
                     for l in s.get("Fraquezas", "").split("\n")
                     if l.strip().startswith("-")]

        saida.append({
            "id": ident,
            "nome": fm.get("nome", ""),
            "epiteto": fm.get("epiteto", "") or "",
            "arquivo": "monstros/" + nome_arq,
            "img": img_rel if existe_img(img_rel) else "",
            "carta": carta_rel if existe_img(carta_rel) else "",
            "tipo": fm.get("tipo", ""),
            "zona": fm.get("zona", ""),
            "regioes": fm.get("regioes", []) or [],
            "nivelRecomendado": str(fm.get("nivel_recomendado", "") or ""),
            "ameaca": fm.get("nivel_ameaca", ""),
            "golpes": str(fm.get("golpes_para_derrotar", "")),
            "local": fm.get("local", ""),
            "canonico": fm.get("canonico", "nao"),
            "fonte": fm.get("fonte", ""),
            "fraqueza": fm.get("atributo_fraqueza", "") or primeiro_paragrafo(s.get("Fraqueza / ponto fraco", "")),
            "elementoFraqueza": fm.get("elemento_fraqueza", "") or "",
            "elementoResistencia": fm.get("elemento_resistencia", "") or "",
            "fraquezas": fraquezas,
            "resistencias": fm.get("resistencias", []) or [],
            "vulnerabilidades": fm.get("vulnerabilidades", []) or [],
            "domavel": fm.get("domavel", ""),
            "domaSucessos": str(fm.get("doma_sucessos", "") or ""),
            "domaRequisito": fm.get("doma_requisito", ""),
            "resumo": primeiro_paragrafo(s.get("Aparência", "")),
            "habitat": habitat,
            "comportamento": comportamento,
            "leitura": primeiro_paragrafo(s.get("Leia em voz alta", "")),
            "sinal": primeiro_paragrafo(s.get("Sinal antes do ataque", "")),
            "lore": primeiro_paragrafo(s.get("Lore", ""), 700),
            "notas": primeiro_paragrafo(s.get("Notas para o mestre", ""), 600),
            "drops": drops,
            "corpo": corpo.strip(),
        })
    return saida


# ---------------------------------------------------------------- npcs

def carregar_npcs():
    dir_ = os.path.join(RAIZ, "npcs")
    saida = []
    for nome_arq in sorted(os.listdir(dir_)):
        if not nome_arq.endswith(".md") or nome_arq.startswith("_"):
            continue
        fm, corpo = frontmatter(ler(os.path.join(dir_, nome_arq)))
        s = secoes(corpo)
        ident = slug(fm.get("nome", nome_arq[:-3]))
        img_fm = (fm.get("imagem") or "").replace("../", "")
        img = img_fm if img_fm and existe_img(img_fm) else ""
        if not img:
            for tentativa in ("imagens/npc_%s.png" % ident,):
                if existe_img(tentativa):
                    img = tentativa
        atr = fm.get("atributos", {}) or {}
        falas = [limpa_md(l).lstrip("- ").strip('"')
                 for l in (s.get("Diálogo de exemplo", "") or "").split("\n")
                 if l.strip().startswith("-")]
        saida.append({
            "id": ident,
            "nome": fm.get("nome", ""),
            "arquivo": "npcs/" + nome_arq,
            "img": img,
            "papel": fm.get("papel", ""),
            "profissao": fm.get("profissao", ""),
            "arma": fm.get("arma", ""),
            "local": fm.get("localizacao", ""),
            "canonico": fm.get("canonico", "nao"),
            "atributos": {k.capitalize(): v for k, v in atr.items()},
            "resumo": primeiro_paragrafo(s.get("Personalidade", "")) or primeiro_paragrafo(s.get("Aparência", "")),
            "gancho": primeiro_paragrafo(s.get("Gancho de aventura", ""), 500),
            "falas": falas[:3],
            "corpo": corpo.strip(),
        })
    return saida


# ---------------------------------------------------------------- armas

RE_CAT_ARMA = re.compile(
    r"^## (?P<nome>.+?) — (?P<raridade>Comum|Incomum|Raro|Épico|Lendário)"
    r"(?: · (?P<tipo>[^·]+?) · (?P<atributo>[^·\n]+?))?\s*$", re.M)
RE_REQ_PRECO = re.compile(r"\*\*Requisito:\*\*\s*(?P<req>[^·\n]*)"
                          r"(?:·\s*\*\*Preço(?: base)?:\*\*\s*(?P<preco>[^·\n]*))?")


def _campo(txt, rotulo):
    m = re.search(r"\*\*%s:?\*\*\s*(.+?)(?=\n\*\*|\n\n|$)" % rotulo, txt, re.S)
    return limpa_md(" ".join(m.group(1).split())) if m else ""


def _preco_num(txt):
    m = re.search(r"(\d[\d.]*)\s*Col", txt or "")
    return int(m.group(1).replace(".", "")) if m else 0


def _fatiar_catalogo(texto, regex):
    """Devolve [(match, corpo_do_item)] pra qualquer arquivo de catalogo."""
    achados = list(regex.finditer(texto))
    for i, m in enumerate(achados):
        fim = achados[i + 1].start() if i + 1 < len(achados) else len(texto)
        yield m, texto[m.end():fim]


def carregar_armas():
    saida = []
    dir_ = os.path.join(RAIZ, "armas")
    # 1) fichas individuais (uma por arquivo)
    for nome_arq in sorted(os.listdir(dir_)):
        if not nome_arq.endswith(".md") or nome_arq.startswith(("_", "00")):
            continue
        fm, corpo = frontmatter(ler(os.path.join(dir_, nome_arq)))
        s = secoes(corpo)
        ident = slug(fm.get("nome", nome_arq[:-3]))
        img_rel = "imagens/arma_%s.png" % nome_arq[:-3]
        skills = [limpa_md(l).lstrip("- ") for l in (s.get("Skills exclusivas do tipo", "") or "").split("\n")
                  if l.strip().startswith("-")]
        saida.append({
            "id": ident, "nome": fm.get("nome", ""), "arquivo": "armas/" + nome_arq,
            "img": img_rel if existe_img(img_rel) else "",
            "tipo": fm.get("tipo", ""), "atributo": fm.get("atributo_principal", ""),
            "raridade": fm.get("raridade", "Comum"), "requisito": fm.get("requisito_atributo", "") or "",
            "preco": 0, "precoTxt": "",
            "resumo": primeiro_paragrafo(s.get("Aparência", "")),
            "efeito": primeiro_paragrafo(s.get("Efeito especial", "")).strip("-").strip(),
            "obter": primeiro_paragrafo(s.get("Como obter", "")),
            "skills": skills,
        })
    # 2) catalogo expandido (varios itens num arquivo so)
    cat = os.path.join(dir_, "00_catalogo_expandido.md")
    if os.path.exists(cat):
        texto = ler(cat)
        for m, corpo in _fatiar_catalogo(texto, RE_CAT_ARMA):
            if not m.group("tipo"):
                continue
            rp = RE_REQ_PRECO.search(corpo)
            preco_txt = (rp.group("preco") or "").strip() if rp else ""
            ident = slug(m.group("nome"))
            img_cat = "imagens/arma_%s.png" % ident
            saida.append({
                "id": ident, "nome": m.group("nome").strip(),
                "arquivo": "armas/00_catalogo_expandido.md",
                "img": img_cat if existe_img(img_cat) else "",
                "tipo": (m.group("tipo") or "").strip(),
                "atributo": (m.group("atributo") or "").strip(),
                "raridade": m.group("raridade"),
                "requisito": (rp.group("req").strip() if rp else ""),
                "preco": _preco_num(preco_txt), "precoTxt": preco_txt,
                "resumo": primeiro_paragrafo(corpo),
                "efeito": _campo(corpo, "Efeito"),
                "obter": _campo(corpo, "Como obter"),
                "skills": [],
            })
    return saida


def carregar_skills_arma():
    cat = os.path.join(RAIZ, "armas", "00_catalogo_expandido.md")
    if not os.path.exists(cat):
        return []
    bloco = secoes(ler(cat)).get("Skills provisórias por tipo de arma", "")
    out = []
    for c in linhas_tabela(bloco):
        if len(c) >= 4 and c[0].lower() != "tipo":
            out.append({"tipo": c[0], "atributo": c[1], "skill": limpa_md(c[2]), "efeito": c[3]})
    return out


# ---------------------------------------------------------------- equipamentos

RE_CAT_EQUIP = re.compile(
    r"^## (?P<nome>.+?) — (?P<raridade>Comum|Incomum|Raro|Épico|Lendário)"
    r"(?P<sufixo>[^\n]*)$", re.M)


def carregar_equipamentos():
    dir_ = os.path.join(RAIZ, "equipamentos")
    if not os.path.isdir(dir_):
        return []
    saida = []
    for nome_arq in sorted(os.listdir(dir_)):
        if not nome_arq.endswith(".md") or nome_arq.startswith("00"):
            continue
        texto = ler(os.path.join(dir_, nome_arq))
        fm, _ = frontmatter(texto)
        slot = fm.get("slot", nome_arq[:-3].replace("_", " ").title())
        for m, corpo in _fatiar_catalogo(texto, RE_CAT_EQUIP):
            rp = RE_REQ_PRECO.search(corpo)
            preco_txt = (rp.group("preco") or "").strip() if rp else ""
            ident = slug(m.group("nome"))
            img_eq = "imagens/equip_%s.png" % ident
            saida.append({
                "id": ident, "nome": m.group("nome").strip(),
                "img": img_eq if existe_img(img_eq) else "",
                "slot": slot, "raridade": m.group("raridade"),
                "conjunto": "conjunto" in (m.group("sufixo") or ""),
                "arquivo": "equipamentos/" + nome_arq,
                "requisito": (rp.group("req").strip() if rp else "") or "—",
                "preco": _preco_num(preco_txt), "precoTxt": preco_txt or "—",
                "resumo": primeiro_paragrafo(corpo),
                "efeito": _campo(corpo, "Efeito"),
                "obter": _campo(corpo, "Como obter"),
            })
    return saida


# ---------------------------------------------------------------- mercado

def carregar_mercado():
    caminho = os.path.join(RAIZ, "docs", "mercado_andar1.md")
    if not os.path.exists(caminho):
        return []
    texto = ler(caminho)
    regiao_atual = ""
    vendedores, atual = [], None
    for linha in texto.split("\n"):
        if linha.startswith("# ") and not linha.startswith("##"):
            regiao_atual = linha[2:].strip()
            atual = None
            continue
        if linha.startswith("## "):
            atual = {"nome": linha[3:].strip(), "regiao": regiao_atual,
                     "desc": "", "desconto": "", "itens": []}
            vendedores.append(atual)
            continue
        if not atual:
            continue
        if "**Desconto:**" in linha:
            cabeca, _, cauda = linha.partition("**Desconto:**")
            atual["desconto"] = limpa_md(cauda.strip())
            cabeca = cabeca.strip()
            if cabeca.startswith("*") and not atual["desc"]:
                atual["desc"] = limpa_md(cabeca.strip("*").strip())
        elif linha.startswith("*") and not linha.startswith("**") and not atual["desc"]:
            atual["desc"] = limpa_md(linha.strip("*").strip())
        elif linha.strip().startswith("|"):
            c = [x.strip() for x in linha.strip().strip("|").split("|")]
            if len(c) >= 2 and c[0].lower() not in ("item", "coisa", "material", "profissão") \
                    and not set("".join(c)) <= set("-: "):
                atual["itens"].append({
                    "item": limpa_md(c[0]), "col": limpa_md(c[1]),
                    "obs": limpa_md(c[2]) if len(c) > 2 else ""})
    # so vale como vendedor quem tem tabela de preco
    vendedores = [v for v in vendedores if v["itens"]]
    ignorar = ("Como o dinheiro funciona", "As quatro regras", "Tabela de compra",
               "Nota de balanceamento")
    return [v for v in vendedores if not v["nome"].startswith(ignorar)]


def carregar_compra_materiais():
    caminho = os.path.join(RAIZ, "docs", "mercado_andar1.md")
    if not os.path.exists(caminho):
        return []
    bloco = secoes(ler(caminho), "# ").get(
        "Tabela de compra de materiais (quanto os NPCs pagam)", "")
    return [{"material": c[0], "col": c[1], "quem": c[2] if len(c) > 2 else ""}
            for c in linhas_tabela(bloco) if len(c) >= 2 and c[0].lower() != "material"]


# ---------------------------------------------------------------- cronicas

RE_CRONICA = re.compile(r"^### EP\.(?P<n>\d+) — (?P<titulo>.+)$", re.M)


def carregar_cronicas():
    """Cronicas de Aincrad -- 50 one-shots em
    cenas/cronicas_de_aincrad_ep01_25.md e cenas/cronicas_de_aincrad_ep26_50.md.
    Mesmo truque de secoes() usado em carregar_quests() pra extrair o resumo:
    'secoes(corpo, "**Gancho**")' fatia o corpo bruto na linha literal
    "**Gancho**" e devolve tudo que vem depois sob a chave "" -- daí o
    primeiro paragrafo disso ser exatamente o texto do Gancho."""
    arquivos = ["cronicas_de_aincrad_ep01_25.md", "cronicas_de_aincrad_ep26_50.md"]
    saida = []
    for nome_arq in arquivos:
        caminho = os.path.join(RAIZ, "cenas", nome_arq)
        if not os.path.exists(caminho):
            continue
        texto = ler(caminho)
        for m, corpo in _fatiar_catalogo(texto, RE_CRONICA):
            # corpo comeca logo apos a linha "### EP.NN -- Titulo", ou seja com
            # "\n\n" sobrando antes do paragrafo de metadados -- por isso o
            # strip() antes de fatiar, senao o primeiro split vem vazio.
            meta_bruta = corpo.strip().split("\n\n", 1)[0]
            meta = " ".join(meta_bruta.split())  # junta quebra de linha do word-wrap

            def pega(rot, ate_fim=False):
                padrao = r"\*\*%s:\*\*\s*(.+)$" % rot if ate_fim else r"\*\*%s:\*\*\s*([^·]+)" % rot
                mm = re.search(padrao, meta)
                return limpa_md(mm.group(1)).strip() if mm else ""

            conexoes_completo = pega("Conexões", ate_fim=True)
            partes = conexoes_completo.split("·", 1)
            conexoes = partes[0].strip()
            elenco = partes[1].strip() if len(partes) > 1 else ""

            saida.append({
                "id": "ep%02d" % int(m.group("n")),
                "numero": int(m.group("n")),
                "epRotulo": "EP.%02d" % int(m.group("n")),
                "titulo": m.group("titulo").strip(),
                "arquivo": "cenas/" + nome_arq,
                "tipo": pega("Tipo"),
                "dificuldade": pega("Dificuldade"),
                "regiao": pega("Região"),
                "conexoes": conexoes,
                "elenco": elenco,
                "resumo": primeiro_paragrafo(secoes(corpo, "**Gancho**").get("", "") or corpo),
                "corpo": corpo.strip(),
            })
    saida.sort(key=lambda x: x["numero"])
    return saida


# ---------------------------------------------------------------- quests

RE_QUEST = re.compile(r"^### `(?P<id>[^`]+)` — (?P<titulo>.+)$", re.M)


def carregar_quests():
    caminho = os.path.join(RAIZ, "cenas", "quests_andar1.md")
    quests = []
    if os.path.exists(caminho):
        texto = ler(caminho)
        cadeia = ""
        for linha in texto.split("\n"):
            if linha.startswith("## Cadeia"):
                cadeia = linha[3:].strip()
        for m, corpo in _fatiar_catalogo(texto, RE_QUEST):
            # a linha de metadados vem depois de uma linha em branco, então
            # olhar só o "primeiro parágrafo" pegava vazio — daí 56 de 60
            # quests aparecerem sem tipo/dificuldade/NPC no app.
            meta = corpo[:700]
            def pega(rot):
                mm = re.search(r"\*\*%s:\*\*\s*([^·\n]+)" % rot, meta)
                return limpa_md(mm.group(1)) if mm else ""
            # a cadeia e o ultimo "## Cadeia X" antes desta quest
            antes = texto[:m.start()]
            cad = re.findall(r"^## (Cadeia .+)$", antes, re.M)
            cadeia = cad[-1] if cad else ""
            quests.append({
                "id": m.group("id"), "titulo": m.group("titulo").strip(),
                "cadeia": cadeia, "tipo": pega("Tipo"),
                "dificuldade": pega("Dificuldade"), "regiao": pega("Região"),
                "npc": pega("NPC"),
                "requer": [x.strip(" `") for x in pega("Requer").split(",")
                           if x.strip(" `—-")],
                "desbloqueia": [x.strip(" `") for x in pega("Desbloqueia").split(",")
                                if x.strip(" `—-")],
                "resumo": primeiro_paragrafo(secoes(corpo, "**Gancho**") .get("", "") or corpo),
                "corpo": corpo.strip(),
            })
    # contratos de oficio: um por profissao, mesmo formato de cabecalho
    cam_of = os.path.join(RAIZ, "cenas", "contratos_de_oficio.md")
    if os.path.exists(cam_of):
        texto = ler(cam_of)
        for m, corpo in _fatiar_catalogo(texto, RE_QUEST):
            meta = corpo[:700]
            def pega2(rot):
                mm = re.search(r"\*\*%s:\*\*\s*([^·\n]+)" % rot, meta)
                return limpa_md(mm.group(1)) if mm else ""
            quests.append({
                "id": m.group("id"), "titulo": m.group("titulo").strip(),
                "cadeia": "Contratos de Ofício", "tipo": "Ofício · " + pega2("Ofício"),
                "dificuldade": pega2("Dificuldade"), "regiao": pega2("Região"),
                "npc": pega2("NPC"), "requer": [], "desbloqueia": [],
                "resumo": primeiro_paragrafo(corpo),
                "corpo": corpo.strip(),
            })

    # as 4 quests com prosa completa vivem em arquivos proprios
    dir_cenas = os.path.join(RAIZ, "cenas")
    for nome_arq in sorted(os.listdir(dir_cenas)):
        if not re.match(r"^0[1-9]_", nome_arq):
            continue
        fm, corpo = frontmatter(ler(os.path.join(dir_cenas, nome_arq)))
        quests.insert(0, {
            "id": nome_arq[:-3], "titulo": fm.get("titulo", nome_arq[:-3]),
            "cadeia": "Cadeia A — Primeiros Passos (prosa completa)",
            "tipo": fm.get("tipo", ""), "dificuldade": fm.get("dificuldade", "Fácil"),
            "regiao": fm.get("local", ""), "npc": "",
            "requer": [], "desbloqueia": [],
            "resumo": primeiro_paragrafo(corpo),
            "corpo": corpo.strip(),
        })
    return quests






# ---------------------------------------------------------------- moves (manual)

RE_MOVE = re.compile(r"^### (?P<nome>.+?) \((?P<atr>[A-Z]{3})\)\s*$", re.M)


def _moves_da_secao(texto, titulo_secao):
    """Le um bloco '## <titulo>' do manual e devolve os '### Nome (ATR)' dele."""
    m = re.search(r"^## %s.*?$(?P<corpo>.*?)(?=^## |\Z)" % re.escape(titulo_secao),
                  texto, re.M | re.S)
    if not m:
        return []
    corpo = m.group("corpo")
    achados = list(RE_MOVE.finditer(corpo))
    out = []
    for i, mm in enumerate(achados):
        fim = achados[i + 1].start() if i + 1 < len(achados) else len(corpo)
        bloco = corpo[mm.end():fim]

        def campo(rotulo):
            r = re.search(r"\*\*%s(?P<sub>[^:*]*):\*\*\s*(?P<txt>.+?)(?=\n\*\*|\n\n|\Z)"
                          % rotulo, bloco, re.S)
            if not r:
                return {"nome": "", "txt": ""}
            return {"nome": r.group("sub").strip(" —-"),
                    "txt": " ".join(r.group("txt").split())}

        marca = campo("Marca")
        combate = campo("Move de Combate")
        util = campo("Move Utilitário")
        oficio = campo("Move de Ofício")
        cena = campo("Move de Cena")
        out.append({
            "nome": mm.group("nome").strip(),
            "atributo": mm.group("atr"),
            "marca": marca["txt"],
            "moveA": {"titulo": (combate["nome"] or oficio["nome"]),
                      "txt": (combate["txt"] or oficio["txt"]),
                      "rotulo": "Move de Combate" if combate["txt"] else "Move de Ofício"},
            "moveB": {"titulo": (util["nome"] or cena["nome"]),
                      "txt": (util["txt"] or cena["txt"]),
                      "rotulo": "Move Utilitário" if util["txt"] else "Move de Cena"},
        })
    return out


def carregar_moves_arma():
    caminho = os.path.join(RAIZ, "docs", "guia_sistema_aincrad.md")
    if not os.path.exists(caminho):
        return []
    return _moves_da_secao(ler(caminho), "Moves de Arma")


def carregar_moves_profissao():
    caminho = os.path.join(RAIZ, "docs", "guia_sistema_aincrad.md")
    if not os.path.exists(caminho):
        return []
    return _moves_da_secao(ler(caminho), "Moves de Profissão")


def carregar_sistema():
    """Blocos de regra que o app mostra na aba Sistema."""
    caminho = os.path.join(RAIZ, "docs", "guia_sistema_aincrad.md")
    if not os.path.exists(caminho):
        return []
    texto = ler(caminho)
    out = []
    for titulo in ["Sistema (PBTA — Powered by the Apocalypse)", "Protagonismo (regra de mesa)",
                   "Atributos (os 5)", "Criando um personagem", "Equipamentos",
                   "Cristais (6 tipos)", "Crafting",
                   "Combate contra monstros — HP e resistências", "Guildas"]:
        m = re.search(r"^## %s\s*$(?P<corpo>.*?)(?=^## |\Z)" % re.escape(titulo),
                      texto, re.M | re.S)
        if m:
            out.append({"titulo": titulo, "corpo": m.group("corpo").strip()})
    return out


# ---------------------------------------------------------------- guias / puzzles / dungeons

def _md_para_blocos(texto, regex_titulo, sub_nivel="### "):
    """Fatia um arquivo por um regex de titulo e devolve (match, {secao: texto})."""
    achados = list(regex_titulo.finditer(texto))
    for i, m in enumerate(achados):
        fim = achados[i + 1].start() if i + 1 < len(achados) else len(texto)
        yield m, texto[m.end():fim]


RE_GUIA = re.compile(r"^## (?P<id>[a-z_0-9]+) · (?P<nome>.+)$", re.M)


def carregar_guias():
    dir_ = os.path.join(RAIZ, "guias")
    if not os.path.isdir(dir_):
        return []
    saida = []
    for nome_arq in sorted(os.listdir(dir_)):
        if not nome_arq.endswith(".md") or nome_arq.startswith("00"):
            continue
        texto = ler(os.path.join(dir_, nome_arq))
        for m, corpo in _md_para_blocos(texto, RE_GUIA):
            s = secoes(corpo, "### ")
            cab = corpo.split("\n")[1] if len(corpo.split("\n")) > 1 else ""
            def meta(rot):
                mm = re.search(r"\*\*%s:?\*\*\s*([^·\n]+)" % rot, cab)
                return limpa_md(mm.group(1)) if mm else ""
            acoes = []
            for c in linhas_tabela(s.get("O que dá pra fazer aqui", "")):
                if len(c) >= 2 and c[0].lower() != "ação":
                    acoes.append({"acao": limpa_md(c[0]), "teste": limpa_md(c[1]),
                                  "sucesso": limpa_md(c[2]) if len(c) > 2 else "",
                                  "parcial": limpa_md(c[3]) if len(c) > 3 else "",
                                  "falha": limpa_md(c[4]) if len(c) > 4 else ""})
            locais = []
            for bloco in (s.get("Locais", "") or "").split("\n\n"):
                bloco = " ".join(l.strip() for l in bloco.split("\n")).strip()
                mm = re.match(r"\*\*(.+?)\*\*\s*[—-]\s*(.+)", bloco)
                if mm:
                    locais.append({"nome": mm.group(1).strip(), "txt": limpa_md(mm.group(2))})
            ligado = []
            for l in (s.get("Ligado a", "") or "").split("\n"):
                l = l.strip()
                if l.startswith("- "):
                    ligado.append(limpa_md(l[2:]))
            saida.append({
                "id": m.group("id"), "nome": m.group("nome").strip(),
                "arquivo": "guias/" + nome_arq,
                "bioma": meta("Bioma"), "nivel": meta("Nível"), "chegada": meta("Como se chega"),
                "leitura": limpa_md(re.sub(r"^> ?", "", s.get("Leia em voz alta", ""), flags=re.M)),
                "cena": s.get("A cena", ""),
                "acoes": acoes,
                "mestre": s.get("Só o mestre", ""),
                "demora": s.get("Se o grupo demorar", ""),
                "evento": s.get("Evento vivo", ""),
                "locais": locais,
                "ligado": ligado,
            })
    return saida


RE_PUZZLE = re.compile(r"^# (?P<n>\d+)\. (?P<nome>.+)$", re.M)


def carregar_puzzles():
    caminho = os.path.join(RAIZ, "docs", "puzzles_andar1.md")
    if not os.path.exists(caminho):
        return []
    texto = ler(caminho)
    saida = []
    for m, corpo in _md_para_blocos(texto, RE_PUZZLE):
        s = secoes(corpo, "## ")
        cab = "\n".join(corpo.split("\n")[1:4])
        def meta(rot):
            mm = re.search(r"\*\*%s:?\*\*\s*([^·\n]+)" % rot, cab)
            return limpa_md(mm.group(1)) if mm else ""
        verdade = ""
        for k in s:
            if k.startswith("A verdade"):
                verdade = s[k]
        recomp = ""
        for k in s:
            if k.startswith("Recompensa"):
                recomp = s[k]
        saida.append({
            "n": int(m.group("n")), "nome": m.group("nome").strip(),
            "arquivo": "docs/puzzles_andar1.md",
            "regiao": meta("Região"), "tipo": meta("Tipo"),
            "cadeia": meta("Cadeia"), "duracao": meta("Duração"),
            "verdade": verdade, "recompensa": recomp,
            "corpo": corpo.strip(),
        })
    return saida


RE_SALA = re.compile(r"^### (?P<id>[A-Z]+-\d+) · (?P<nome>.+?) — `(?P<tipo>\w+)`(?: / `\w+`)?$", re.M)


def carregar_salas_dungeon():
    caminho = os.path.join(RAIZ, "mapas", "dungeons_andar1.md")
    if not os.path.exists(caminho):
        return {}
    texto = ler(caminho)
    out = {}
    for m, corpo in _md_para_blocos(texto, RE_SALA):
        leitura = "\n".join(l[2:] if l.startswith("> ") else l
                            for l in corpo.split("\n") if l.startswith(">"))
        resto = "\n".join(l for l in corpo.split("\n") if not l.startswith(">")).strip()
        out[m.group("id").replace("-", "")] = {
            "nome": m.group("nome").strip(), "tipo": m.group("tipo"),
            "leitura": " ".join(leitura.split()),
            "corpo": resto,
        }
    return out


def corpo_completo(rel):
    """Markdown inteiro de um arquivo, sem o frontmatter."""
    caminho = os.path.join(RAIZ, rel.replace("/", os.sep))
    if not os.path.exists(caminho):
        return ""
    _, corpo = frontmatter(ler(caminho))
    return corpo.strip()




# ---------------------------------------------------------------- pontos do mapa

RE_PONTO = re.compile(r"^### (?P<id>[^\s·]+) · (?P<nome>.+)$", re.M)


def carregar_pontos_detalhe():
    """guias/pontos/<regiao>.md -> {id_do_ponto: {...}}.

    Um arquivo por região. É o que faz cada marcador do mapa ter conteúdo
    próprio (leitura em voz alta, ações com teste, notas e atalhos) em vez da
    descrição curta que vive em dados_mapa.js."""
    dir_ = os.path.join(RAIZ, "guias", "pontos")
    if not os.path.isdir(dir_):
        return {}
    out = {}
    for nome_arq in sorted(os.listdir(dir_)):
        if not nome_arq.endswith(".md"):
            continue
        texto = ler(os.path.join(dir_, nome_arq))
        fm, _ = frontmatter(texto)
        regiao = fm.get("regiao", nome_arq[:-3])
        achados = list(RE_PONTO.finditer(texto))
        for i, m in enumerate(achados):
            fim = achados[i + 1].start() if i + 1 < len(achados) else len(texto)
            corpo = texto[m.end():fim]

            leitura = " ".join(l[2:].strip() if l.startswith("> ") else l.strip("> ")
                               for l in corpo.split("\n") if l.startswith(">"))
            acoes = []
            for c in linhas_tabela(corpo):
                if len(c) >= 2 and c[0].lower() not in ("ação", "acao"):
                    acoes.append({"acao": limpa_md(c[0]), "teste": limpa_md(c[1]),
                                  "sucesso": limpa_md(c[2]) if len(c) > 2 else "",
                                  "parcial": limpa_md(c[3]) if len(c) > 3 else "",
                                  "falha": limpa_md(c[4]) if len(c) > 4 else ""})

            def campo(rot):
                r = re.search(r"\*\*%s:?\*\*\s*(.+?)(?=\n\n|\n\*\*|\Z)" % rot, corpo, re.S)
                return " ".join(r.group(1).split()) if r else ""

            atalhos = []
            for bruto in campo("Atalhos").split("·"):
                bruto = limpa_md(bruto).strip()
                if ":" in bruto:
                    k, _, v = bruto.partition(":")
                    atalhos.append({"tipo": k.strip(), "id": v.strip()})

            out[m.group("id")] = {
                "nome": m.group("nome").strip(),
                "regiao": regiao,
                "arquivo": "guias/pontos/" + nome_arq,
                "leitura": leitura.strip(),
                "oque": campo("O que é"),
                "acoes": acoes,
                "mestre": campo("Só o mestre"),
                "atalhos": atalhos,
            }
    return out




# ---------------------------------------------------------------- oficios

RE_OFICIO = re.compile(r"^## (?P<nome>[^·\n]+) · (?P<atr>Corpo|Reflexo|Conhecimento|Espírito|Técnica)\s*$", re.M)


def carregar_oficios():
    """docs/oficios_andar1.md -> uma entrada por profissão, com as ações de
    ofício, os postos de trabalho no mapa, contato, gancho, renda e item."""
    caminho = os.path.join(RAIZ, "docs", "oficios_andar1.md")
    if not os.path.exists(caminho):
        return []
    texto = ler(caminho)
    achados = list(RE_OFICIO.finditer(texto))
    out = []
    for i, m in enumerate(achados):
        fim = achados[i + 1].start() if i + 1 < len(achados) else len(texto)
        corpo = texto[m.end():fim]
        corte = corpo.find("\n# ")          # o bloco final de conferência não é do ofício
        if corte > 0:
            corpo = corpo[:corte]

        acoes = []
        for c in linhas_tabela(corpo):
            if len(c) >= 2 and c[0].lower() not in ("ação", "acao", "item"):
                acoes.append({"acao": limpa_md(c[0]), "teste": limpa_md(c[1]),
                              "sucesso": limpa_md(c[2]) if len(c) > 2 else "",
                              "parcial": limpa_md(c[3]) if len(c) > 3 else "",
                              "falha": limpa_md(c[4]) if len(c) > 4 else ""})

        postos = []
        bloco = re.search(r"\*\*Postos de trabalho\*\*(.*?)(?=\n\*\*|\Z)", corpo, re.S)
        if bloco:
            for l in bloco.group(1).split("\n"):
                mm = re.match(r"\s*-\s*`(?P<id>[^`]+)`\s*[—-]\s*(?P<txt>.+)", l)
                if mm:
                    postos.append({"ponto": mm.group("id").strip(),
                                   "txt": limpa_md(mm.group("txt"))})

        def campo(rot):
            r = re.search(r"\*\*%s:?\*\*\s*(.+?)(?=\n\*\*|\n\n|\Z)" % rot, corpo, re.S)
            return " ".join(r.group(1).split()) if r else ""

        out.append({
            "nome": m.group("nome").strip(),
            "atributo": m.group("atr"),
            "arquivo": "docs/oficios_andar1.md",
            "marca": limpa_md(campo("Marca")),
            "acoes": acoes,
            "postos": postos,
            "contato": limpa_md(campo("Contato")),
            "gancho": limpa_md(campo("Gancho recorrente")),
            "renda": limpa_md(campo("Renda")),
            "item": limpa_md(campo("Item assinatura")),
        })
    return out




# ---------------------------------------------------------------- producao

RE_PROD = re.compile(r"^## (?P<nome>[^—\n]+) — (?P<moeda>Matéria|Serviço|Conhecimento)\s*$", re.M)


def carregar_producao():
    """docs/producao_por_oficio.md -> {profissão: {moeda, itens[]}}.
    É o que garante que as 16 profissões produzam alguma coisa — não só as 4
    que craftam objeto físico."""
    caminho = os.path.join(RAIZ, "docs", "producao_por_oficio.md")
    if not os.path.exists(caminho):
        return {}
    texto = ler(caminho)
    achados = list(RE_PROD.finditer(texto))
    out = {}
    for i, m in enumerate(achados):
        fim = achados[i + 1].start() if i + 1 < len(achados) else len(texto)
        corpo = texto[m.end():fim]
        corte = corpo.find("\n# ")
        if corte > 0:
            corpo = corpo[:corte]
        itens = []
        for c in linhas_tabela(corpo):
            if len(c) >= 4 and c[0].lower() != "produz":
                itens.append({"produz": limpa_md(c[0]), "precisa": limpa_md(c[1]),
                              "teste": limpa_md(c[2]), "sucesso": limpa_md(c[3]),
                              "parcial": limpa_md(c[4]) if len(c) > 4 else ""})
        vale = re.search(r"\*\*Vale:\*\*\s*(.+?)(?=\n\n|\n---|\Z)", corpo, re.S)
        out[m.group("nome").strip()] = {
            "moeda": m.group("moeda"),
            "itens": itens,
            "vale": " ".join(vale.group(1).split()) if vale else "",
        }
    return out


# ---------------------------------------------------------------- saida

def main():
    blocos = {
        "MONSTROS": carregar_monstros(),
        "NPCS": carregar_npcs(),
        "ARMAS": carregar_armas(),
        "MOVES_ARMA": carregar_moves_arma(),
        "MOVES_PROFISSAO": carregar_moves_profissao(),
        "SISTEMA": carregar_sistema(),
        "EQUIPAMENTOS": carregar_equipamentos(),
        "MERCADO": carregar_mercado(),
        "COMPRA_MATERIAIS": carregar_compra_materiais(),
        "QUESTS": carregar_quests(),
        "CRONICAS": carregar_cronicas(),
        "GUIAS": carregar_guias(),
        "PUZZLES": carregar_puzzles(),
        "OFICIOS": carregar_oficios(),
    }
    blocos_dict = {"SALAS_DUNGEON": carregar_salas_dungeon(),
                   "PRODUCAO": carregar_producao(),
                   "PONTOS_DETALHE": carregar_pontos_detalhe()}
    partes = ["/* GERADO POR scripts/gerar_dados_web.py -- NAO EDITE A MAO.",
              "   Fonte de verdade: os .md em monstros/, npcs/, armas/, equipamentos/,",
              "   docs/mercado_andar1.md e cenas/quests_andar1.md.",
              "   Escreveu ficha nova? Rode: python scripts/gerar_dados_web.py */", ""]
    for nome, dados in blocos.items():
        partes.append("var %s = %s;" % (nome, json.dumps(dados, ensure_ascii=False, indent=1)))
        partes.append("")
    for nome, dados in blocos_dict.items():
        partes.append("var %s = %s;" % (nome, json.dumps(dados, ensure_ascii=False, indent=1)))
        partes.append("")
    os.makedirs(os.path.dirname(SAIDA), exist_ok=True)
    with open(SAIDA, "w", encoding="utf-8") as f:
        f.write("\n".join(partes))

    print("Gerado: %s" % SAIDA)
    for nome, dados in list(blocos.items()) + list(blocos_dict.items()):
        print("  %-18s %d" % (nome, len(dados)))
    sem_img = [m["nome"] for m in blocos["MONSTROS"] if not m["img"]]
    if sem_img:
        print("\nMonstros ainda sem imagem (%d): %s" % (len(sem_img), ", ".join(sem_img)))
    for rotulo, chave in [("NPCs", "NPCS"), ("Armas", "ARMAS"), ("Equipamentos", "EQUIPAMENTOS")]:
        falta = [x["nome"] for x in blocos[chave] if not x.get("img")]
        if falta:
            print("%s ainda sem imagem (%d)" % (rotulo, len(falta)))
    print("\nPra gerar tudo que falta de uma vez:  python scripts/gerar_faltantes.py tudo")


if __name__ == "__main__":
    main()
