#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Popula moves_arma.sword_skills/limit_break_novo e moves_profissao.niveis
com o conteudo real de Sword Skills / habilidades por nivel do
SAO_RPG_5e.md (extraido por _extrair_sword_skills_e_profissoes.py).

Pre-requisito: scripts/db/schema_migracao_dnd5e_moves.sql ja aplicado
(colunas existem).

Uso:
    python scripts/db/_popular_moves_dnd5e.py
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from migrar_para_supabase import conectar  # noqa: E402
from _extrair_sword_skills_e_profissoes import extrair_profissoes, extrair_armas  # noqa: E402

# nome no SAO_RPG_5e.md -> nome na coluna moves_arma.nome (banco)
MAPA_NOME_ARMA = {
    "Espada + Escudo": "Escudo e Espada",
    "Chakram": "Chakrams",
}

# profissoes pre-fusao (ainda em moves_profissao) -> profissao pos-fusao
# cujo conteudo do SAO_RPG_5e.md deve ser usado (Secao 17 do documento).
MAPA_PROFISSAO_PREFUSAO = {
    "Bibliotecário": "Informante",
    "Cartógrafo": "Informante",
    "Diplomata": "Informante",
    "Coveiro": "Mercenário",
}


def main():
    conn = conectar()
    cur = conn.cursor()

    armas = extrair_armas()
    atualizados_armas = 0
    for nome_md, arma in armas.items():
        nome_banco = MAPA_NOME_ARMA.get(nome_md, nome_md)
        skills_normais = [
            {"nivel": s["nivel"], "nome": s["nome"], "descricao": s["descricao"]}
            for s in arma["skills"]
        ]
        lb = arma["limit_break"]
        limit_break = json.dumps(
            {"nivel": lb["nivel"], "nome": lb["nome"], "descricao": lb["descricao"]}, ensure_ascii=False
        ) if lb else None
        sword_skills = json.dumps(skills_normais, ensure_ascii=False)
        cur.execute(
            "update moves_arma set sword_skills = %s::jsonb, limit_break_novo = %s::jsonb, "
            "atributo = %s, marca = %s, updated_at = now() where nome = %s",
            (sword_skills, limit_break, arma["atributo"], arma["identidade"], nome_banco),
        )
        if cur.rowcount == 0:
            print(f"AVISO: nenhuma linha em moves_arma pra '{nome_banco}' (de '{nome_md}')")
        else:
            atualizados_armas += cur.rowcount
        if len(skills_normais) != 7 or not lb:
            print(f"AVISO: '{nome_md}' tem {len(skills_normais)} skills normais (esperado 7) e LB={'ok' if lb else 'FALTANDO'}")

    profs = extrair_profissoes()
    atualizados_profs = 0
    for nome_md, dados in profs.items():
        niveis = json.dumps(dados["niveis"], ensure_ascii=False)
        cur.execute(
            "update moves_profissao set niveis = %s::jsonb, updated_at = now() where nome = %s",
            (niveis, nome_md),
        )
        if cur.rowcount == 0:
            print(f"AVISO: nenhuma linha em moves_profissao pra '{nome_md}'")
        else:
            atualizados_profs += cur.rowcount

    # profissoes pre-fusao: reaproveita o conteudo da profissao que as absorveu
    for nome_prefusao, nome_pos in MAPA_PROFISSAO_PREFUSAO.items():
        dados = profs.get(nome_pos)
        if not dados:
            print(f"AVISO: profissao pos-fusao '{nome_pos}' nao encontrada pra '{nome_prefusao}'")
            continue
        niveis = json.dumps(dados["niveis"], ensure_ascii=False)
        cur.execute(
            "update moves_profissao set niveis = %s::jsonb, updated_at = now() where nome = %s",
            (niveis, nome_prefusao),
        )
        if cur.rowcount:
            atualizados_profs += cur.rowcount
            print(f"'{nome_prefusao}' preenchido com o conteudo de '{nome_pos}' (fusao, Secao 17 do SAO_RPG_5e.md)")

    conn.commit()
    print(f"\nmoves_arma atualizadas: {atualizados_armas}")
    print(f"moves_profissao atualizadas: {atualizados_profs}")


if __name__ == "__main__":
    main()
