#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Item 14 (ferramenta de ofício por profissão) + item 16 parte 2 (refino
2 estágios) juntos: até agora só o Domador tinha ferramenta própria
(Incubadora). Fecha as outras 15, cada uma com 2 tiers:

- Tier 1 (nivel_ferramenta=1, bonus_acao=+1): craft simples, 1 estágio.
- Tier 2 (nivel_ferramenta=3, bonus_acao=+2): cadeia de refino —
  estágio 1 (matéria-prima -> intermediário) + estágio 2 (intermediário
  -> ferramenta final), igual ao padrão que a Incubadora Sagrada/
  Primordial do Domador já usa. Estágio 1 nunca produz algo que já existe
  em armas/equipamentos (é só o intermediário), estágio 2 é a ferramenta.

Ferramenta dá bônus PLANO pra qualquer craft daquela profissão (mesmo
mecanismo já testado — craftar_item/craftar_ferramenta somam
max(bonus_acao) das ferramentas do personagem pra profissão da receita).
"""
import sys
import json

sys.path.insert(0, "scripts")
from migrar_para_supabase import conectar  # noqa: E402

ATRIBUTO_PROF = {
    "Caçador": "Reflexo", "Lenhador": "Reflexo",
    "Cartógrafo": "Conhecimento", "Comerciante": "Conhecimento", "Cozinheiro": "Conhecimento",
    "Diplomata": "Conhecimento", "Bibliotecário": "Conhecimento", "Alquimista": "Conhecimento",
    "Costureiro": "Técnica", "Ferreiro": "Técnica", "Joalheiro": "Técnica",
    "Coveiro": "Espírito", "Médico": "Espírito", "Músico": "Espírito",
    "Mercenário": "Corpo",
}

# profissao: (tier1_nome, tier1_materiais, tier2_intermediario_nome,
#             tier2_intermediario_materiais, tier2_final_nome, tier2_final_materiais)
FERRAMENTAS = {
    "Caçador": ("Armadilha de Rastreio", [(4, "Madeira Comum"), (2, "Fibra Vegetal")],
                "Gatilho Afiado", [(2, "Ferro Bruto"), (1, "Osso de Fera")],
                "Armadilha do Predador", [(1, "Gatilho Afiado"), (2, "Couro Grosso")]),
    "Lenhador": ("Machado de Poda", [(5, "Madeira Comum"), (2, "Ferro Bruto")],
                 "Lâmina Temperada", [(3, "Ferro Bruto"), (1, "Carvão")],
                 "Machado Robusto", [(1, "Lâmina Temperada"), (3, "Madeira Nodosa")]),
    "Cartógrafo": ("Bússola de Latão", [(3, "Latão em Pó"), (2, "Vidro Temperado")],
                   "Agulha Magnetizada", [(2, "Ferro Bruto"), (1, "Cristal Pequeno")],
                   "Bússola Astral", [(1, "Agulha Magnetizada"), (2, "Pergaminho Simples")]),
    "Comerciante": ("Livro-Caixa Simples", [(3, "Pergaminho Simples"), (2, "Tinta Preta")],
                    "Encadernação Reforçada", [(2, "Couro Curtido"), (1, "Linha Resistente")],
                    "Livro-Caixa Encadernado", [(1, "Encadernação Reforçada"), (2, "Pergaminho Simples")]),
    "Cozinheiro": ("Panela de Ferro", [(4, "Ferro Bruto"), (1, "Argila")],
                   "Liga Resistente ao Fogo", [(3, "Ferro Bruto"), (1, "Carvão")],
                   "Panela Encantada", [(1, "Liga Resistente ao Fogo"), (1, "Cristal Pequeno")]),
    "Diplomata": ("Selo de Cera", [(2, "Resina Natural"), (1, "Ouro Folha")],
                  "Molde Gravado", [(2, "Ferro Bruto"), (1, "Prata Bruta")],
                  "Selo de Autoridade", [(1, "Molde Gravado"), (1, "Ouro Folha")]),
    "Bibliotecário": ("Lupa Simples", [(2, "Vidro Temperado"), (1, "Ferro Bruto")],
                       "Lente Polida", [(2, "Vidro Temperado"), (1, "Cristal Pequeno")],
                       "Lupa Rúnica", [(1, "Lente Polida"), (2, "Pergaminho Simples")]),
    "Alquimista": ("Alambique Portátil", [(3, "Vidro Temperado"), (2, "Ferro Bruto")],
                   "Serpentina de Cobre", [(3, "Cobre Pepita"), (1, "Vidro Temperado")],
                   "Alambique de Cristal", [(1, "Serpentina de Cobre"), (1, "Cristal Branco")]),
    "Costureiro": ("Tesoura Comum", [(2, "Ferro Bruto"), (1, "Madeira Comum")],
                   "Lâmina Fina Polida", [(2, "Ferro Bruto"), (1, "Fio Prata")],
                   "Tesoura de Prata", [(1, "Lâmina Fina Polida"), (1, "Fio Prata")]),
    "Ferreiro": ("Martelo Comum", [(4, "Ferro Bruto"), (2, "Madeira Comum")],
                 "Cabeça Balanceada", [(3, "Aço Raro"), (1, "Carvão")],
                 "Martelo de Precisão", [(1, "Cabeça Balanceada"), (2, "Couro Curtido")]),
    "Joalheiro": ("Bigorna de Bancada", [(3, "Ferro Bruto"), (1, "Pedra Lascada")],
                  "Pinça de Precisão", [(2, "Prata Bruta"), (1, "Fio Aluminio")],
                  "Lapidadora de Precisão", [(1, "Pinça de Precisão"), (1, "Gema Branca")]),
    "Coveiro": ("Pá Reforçada", [(3, "Ferro Bruto"), (2, "Madeira Comum")],
                "Corrente Sagrada", [(2, "Ferro Bruto"), (1, "Runa Vida")],
                "Relicário", [(1, "Corrente Sagrada"), (1, "Osso de Chefe")]),
    "Médico": ("Kit de Primeiros Socorros", [(3, "Erva Comum"), (2, "Tecido Grosso")],
               "Bandagem Purificada", [(2, "Tecido Grosso"), (1, "Erva Ancestral")],
               "Kit Avançado", [(1, "Bandagem Purificada"), (2, "Erva Comum")]),
    "Músico": ("Flauta Simples", [(3, "Madeira Comum"), (1, "Fio Prata")],
               "Corda Encantada", [(2, "Fio Prata"), (1, "Néctar Lunar")],
               "Instrumento Encantado", [(1, "Corda Encantada"), (2, "Madeira Nodosa")]),
    "Mercenário": ("Amoladora de Lâmina", [(3, "Ferro Bruto"), (1, "Pedra Lascada")],
                   "Forja Compacta", [(3, "Aço Raro"), (1, "Carvão")],
                   "Forja de Campo", [(1, "Forja Compacta"), (2, "Couro Grosso")]),
}


def _slug(s):
    import re
    import unicodedata
    s = unicodedata.normalize("NFKD", s).encode("ascii", "ignore").decode("ascii").lower()
    return re.sub(r"[^a-z0-9]+", "_", s).strip("_")


def mats(pares):
    return [{"mat_id": "mat_" + _slug(n), "qtd": q} for q, n in pares]


def main():
    commit = "--commit" in sys.argv
    conn = conectar()
    cur = conn.cursor()

    ferramentas_rows = []
    receitas_rows = []

    for prof, (t1_nome, t1_mats, t2i_nome, t2i_mats, t2f_nome, t2f_mats) in FERRAMENTAS.items():
        atributo = ATRIBUTO_PROF[prof]
        slug_prof = _slug(prof)

        id_t1 = f"{slug_prof}_ferramenta_n1"
        id_t2i = f"{slug_prof}_ferramenta_n3_est1"
        id_t2f = f"{slug_prof}_ferramenta_n3_est2"

        ferramentas_rows.append((id_t1, prof, t1_nome, 1, 1,
            f"+1 no teste (2d6) em qualquer craft de {prof}.", "craft"))
        ferramentas_rows.append((id_t2f, prof, t2f_nome, 3, 2,
            f"+2 no teste (2d6) em qualquer craft de {prof}. Refino 2 estágios.", "craft (refino)"))

        receitas_rows.append((id_t1, prof, 1, "ferramenta", t1_nome, None, "comum", atributo, 0, 1, 20,
            mats(t1_mats), {}, False, 1, None, None, 1))
        receitas_rows.append((id_t2i, prof, 3, "ferramenta", t2i_nome, None, "incomum", atributo, 0, 2, 35,
            mats(t2i_mats), {}, False, 1, None, None, 1))
        receitas_rows.append((id_t2f, prof, 3, "ferramenta", t2f_nome, None, "raro", atributo, 0, 3, 55,
            mats(t2f_mats), {}, True, 2, id_t2i, None, 1))

    print(f"ferramentas: {len(ferramentas_rows)}  receitas: {len(receitas_rows)}")

    for r in ferramentas_rows:
        cur.execute(
            """insert into ferramentas_oficio (id, profissao, nome, nivel_ferramenta, bonus_acao, descricao, acao_afetada, visivel, excluido)
               values (%s,%s,%s,%s,%s,%s,%s,true,false)
               on conflict (id) do update set nome=excluded.nome, bonus_acao=excluded.bonus_acao, descricao=excluded.descricao""",
            r,
        )
    for r in receitas_rows:
        (rid, prof, nivel, tipo, nome_res, resultado_item_id, raridade, atributo, dif_mod, folego, xp,
         materiais, efeitos, refino, estagio, antecessora, requer_ferr, resultado_qtd) = r
        cur.execute(
            """insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, resultado_item_id,
                 resultado_raridade, atributo_teste, dificuldade_mod, folego_custo, xp_recompensa, materiais,
                 efeitos, receita_refino, receita_estagio, receita_antecessora_id, requer_ferramenta_id,
                 resultado_qtd, visivel, excluido)
               values (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,true,false)
               on conflict (id) do update set nome_resultado=excluded.nome_resultado, materiais=excluded.materiais,
                 receita_refino=excluded.receita_refino, receita_estagio=excluded.receita_estagio,
                 receita_antecessora_id=excluded.receita_antecessora_id""",
            (rid, prof, nivel, tipo, nome_res, resultado_item_id, raridade, atributo, dif_mod, folego, xp,
             json.dumps(materiais, ensure_ascii=False), json.dumps(efeitos, ensure_ascii=False),
             refino, estagio, antecessora, requer_ferr, resultado_qtd),
        )

    cur.execute("select count(*) from ferramentas_oficio")
    print("ferramentas_oficio total:", cur.fetchone())
    cur.execute("select count(*) from receitas where tipo='ferramenta'")
    print("receitas tipo=ferramenta total:", cur.fetchone())

    if commit:
        conn.commit()
        print("COMMITADO.")
    else:
        conn.rollback()
        print("dry-run (rollback) -- roda com --commit pra aplicar.")


if __name__ == "__main__":
    main()
