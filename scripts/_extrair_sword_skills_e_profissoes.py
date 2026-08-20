#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Extrai as Sword Skills (Secoes 55-59) e as habilidades de profissao por
nivel (Secoes 30-44) do SAO_RPG_5e.md e devolve estruturas Python prontas
pra popular moves_arma/moves_profissao no banco.

Uso (importado por _popular_moves_dnd5e.py, nao roda standalone):
    from _extrair_sword_skills_e_profissoes import extrair_armas, extrair_profissoes
"""
import os
import re

RAIZ = os.path.dirname(os.path.abspath(__file__))
CAMINHO_MD = os.path.join(os.path.dirname(RAIZ), "SAO_RPG_5e.md")


def ler_md():
    with open(CAMINHO_MD, encoding="utf-8") as f:
        return f.read()


# --------------------------------------------------------------------------
# ARMAS (Secoes 55-59)
# --------------------------------------------------------------------------

def extrair_armas():
    texto = ler_md()
    # bloco geral: da Secao 55 ate a Secao 60 (RESUMO), que fecha a parte de armas
    ini = texto.index("# 55. SWORD SKILLS")
    fim = texto.index("# 60. RESUMO DAS SWORD SKILLS")
    bloco = texto[ini:fim]

    # cada arma comeca em "## NN.M Nome" (armas normais) ou em
    # "# 59. CORRENTE COM PESO" (caso especial, virou secao propria)
    partes = re.split(r"\n(?=## \d+\.\d+ )", bloco)
    # a Corrente com Peso (Secao 59) fica fora do split acima porque usa "#"
    # nao "##" -- localizamos ela separadamente dentro do texto completo.
    ini_corrente = texto.index("# 59. CORRENTE COM PESO")
    fim_corrente = texto.index("# 60. RESUMO")
    bloco_corrente = texto[ini_corrente:fim_corrente]

    armas = {}
    for parte in partes:
        m = re.match(r"## \d+\.\d+ (.+)", parte)
        if not m:
            continue
        nome = m.group(1).strip()
        armas[nome] = _parsear_bloco_arma(nome, parte)

    armas["Corrente com Peso"] = _parsear_bloco_arma("Corrente com Peso", bloco_corrente)
    return armas


def _parsear_bloco_arma(nome, bloco):
    # corta no proximo cabecalho de nivel 1 (# NN. ...), que marca ter saido
    # da subsecao da arma -- sem isso o ultimo bloco de cada categoria
    # (ex: Machado, ultima arma da Secao 58) engolia o resto do documento.
    m_prox_secao = re.search(r"\n# \d+\. ", bloco)
    if m_prox_secao:
        bloco = bloco[:m_prox_secao.start()]

    m_attr = re.search(r"\*\*Atributo:\*\*\s*(\S+)", bloco)
    atributo = m_attr.group(1).strip() if m_attr else None
    m_func = re.search(r"\*\*Função:\*\*\s*(.+)", bloco)
    funcao = m_func.group(1).strip() if m_func else None

    # tabela de niveis: "| 1 | Nome da Skill |" ou "| 5 | **Limit Break — Nome** |"
    linhas_tabela = re.findall(r"^\|\s*(\d+)\s*\|\s*(.+?)\s*\|$", bloco, re.M)
    niveis = []
    for nivel_str, texto_skill in linhas_tabela:
        nivel = int(nivel_str)
        m_lb = re.match(r"\*\*Limit Break\s*—\s*(.+?)\*\*", texto_skill)
        if m_lb:
            niveis.append((nivel, m_lb.group(1).strip(), True))
        else:
            niveis.append((nivel, texto_skill.strip(), False))

    # descricoes, 3 formatos usados no documento (por arma):
    #  (a) "### Nome da Skill\ntexto..." -- formato completo (Tank/CC/Corrente)
    #  (b) "- **Nome:** texto" dentro de um bloco (bullet list solta ou sob um
    #      "### Skills iniciais"/"### Skills exclusivas") -- Martelo/Adagas/Arco
    #  (c) nada -- so' o nome na tabela + uma linha de identidade geral (DPS/
    #      Suporte restantes); nesse caso a descricao fica vazia mesmo (nao
    #      inventa texto que nao existe no documento).
    descricoes = {}
    for titulo, corpo in re.findall(r"^### (.+?)\n(.*?)(?=^### |\Z)", bloco, re.M | re.S):
        titulo_limpo = re.sub(r"\s*—\s*Limit Break\s*$", "", titulo.strip())
        descricoes[titulo_limpo] = corpo.strip()
    for nome_bullet, texto_bullet in re.findall(r"^-\s*\*\*(.+?):\*\*\s*(.+)$", bloco, re.M):
        descricoes.setdefault(nome_bullet.strip(), texto_bullet.strip())

    skills = []
    limit_break = None
    for nivel, skill_nome, eh_lb in niveis:
        descricao = descricoes.get(skill_nome, "")
        if eh_lb:
            limit_break = {"nivel": nivel, "nome": skill_nome, "descricao": descricao}
        else:
            skills.append({"nivel": nivel, "nome": skill_nome, "descricao": descricao})

    return {"atributo": atributo, "funcao": funcao, "skills": skills, "limit_break": limit_break}


# --------------------------------------------------------------------------
# PROFISSOES (Secoes 30-44)
# --------------------------------------------------------------------------

PROFISSOES_SECOES = [
    "ALQUIMISTA", "CAÇADOR", "INFORMANTE", "COMERCIANTE", "COSTUREIRO",
    "COZINHEIRO", "FERREIRO", "LENHADOR", "MERCENÁRIO", "MÉDICO",
    "MINERADOR", "MESTRE DE MONTARIAS", "DOMADOR", "JOALHEIRO", "MÚSICO",
]


def extrair_profissoes():
    texto = ler_md()
    ini = texto.index("# 30. ALQUIMISTA")
    fim = texto.index("# 45. PRINCÍPIO DE UTILIDADE")
    bloco = texto[ini:fim]

    partes = re.split(r"\n(?=# \d+\. )", bloco)
    profissoes = {}
    for parte in partes:
        m = re.match(r"# \d+\. (.+)", parte)
        if not m:
            continue
        nome_secao = m.group(1).strip()
        profissoes[_normalizar_nome_profissao(nome_secao)] = _parsear_bloco_profissao(parte)
    return profissoes


def _normalizar_nome_profissao(nome_secao):
    # Titulo em CAIXA ALTA -> Capitalizado, preservando acentos.
    especiais = {
        "MESTRE DE MONTARIAS": "Mestre de Montarias",
    }
    if nome_secao in especiais:
        return especiais[nome_secao]
    return nome_secao.title()


def _parsear_bloco_profissao(bloco):
    m_attr = re.search(r"\*\*Atributo:\s*(\S+)\*\*", bloco)
    atributo = m_attr.group(1).strip() if m_attr else None

    secoes = re.findall(r"^## Nível (\d+) — (.+?)\n(.*?)(?=^## Nível |\Z)", bloco, re.M | re.S)
    niveis = []
    for nivel_str, titulo, corpo in secoes:
        niveis.append({"nivel": int(nivel_str), "nome": titulo.strip(), "descricao": corpo.strip()})
    return {"atributo": atributo, "niveis": niveis}


if __name__ == "__main__":
    import json
    armas = extrair_armas()
    print(f"{len(armas)} armas extraídas")
    for nome, dados in armas.items():
        n_skills = len(dados["skills"])
        n_desc = sum(1 for s in dados["skills"] if s["descricao"]) + (1 if dados["limit_break"] and dados["limit_break"]["descricao"] else 0)
        print(f"  {nome}: atributo={dados['atributo']} skills={n_skills} com_descricao={n_desc}/{n_skills+1}")

    profs = extrair_profissoes()
    print(f"\n{len(profs)} profissões extraídas")
    for nome, dados in profs.items():
        print(f"  {nome}: atributo={dados['atributo']} niveis={len(dados['niveis'])}")
