#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Item 7 — troca o placeholder "efeito ainda não definido" por efeito de
verdade, formulaico (não é 200+ textos únicos de criação livre, é uma
fórmula por tipo_bonus x raridade, parametrizada pelo nome do monstro de
origem). Vale só na mesa (regra já decidida: item do site não tem efeito
mecânico online)."""
import sys
sys.path.insert(0, "scripts")
from migrar_para_supabase import conectar  # noqa: E402

# Regra dura do sistema (docs/regras_nucleares_campanha.md): nenhum teste
# recebe mais de +1 numérico externo, e equipamento usa ESSE único espaço
# — bônus iguais não somam. Por isso o número aqui é sempre +1, nunca
# escala com raridade; o que escala com raridade é o alcance/frequência do
# efeito (ver FREQ_POR_RARIDADE), igual já vale pra armas Raras no
# catálogo (+1 + efeito único, não +2/+3).
FREQ_POR_RARIDADE = {
    "Incomum": "uma vez por cena",
    "Raro": "uma vez por cena — mas cobra um preço ou chama atenção, à escolha do mestre",
    "Épico": "até duas vezes por sessão",
}

TEXTO_POR_TIPO = {
    "atributo": "Na mesa: enquanto equipada, dá +1 (o único bônus numérico do teste, não soma com outro) num teste do atributo que combinar com {origem}, {freq}.",
    "dano": "Na mesa: enquanto equipada, dá +1 de efeito num golpe inspirado em {origem}, {freq} — mesmo espaço de bônus do equipamento, não empilha com outro numérico.",
    "resist": "Na mesa: enquanto equipada, {freq}, tira uma Condição menor ligada a algo que lembre {origem} sem precisar do custo normal de removê-la.",
    "especial": "Na mesa: enquanto equipada, {freq}, você pode invocar uma vantagem narrativa ligada a {origem} — o mestre decide o efeito exato na hora, dentro do espírito da criatura. Não é bônus numérico, não disputa o espaço do +1 de equipamento.",
}


def efeito(tipo_bonus, raridade, drop_de):
    modelo = TEXTO_POR_TIPO.get(tipo_bonus, TEXTO_POR_TIPO["dano"])
    freq = FREQ_POR_RARIDADE.get(raridade, "uma vez por cena")
    return modelo.format(origem=drop_de or "a criatura de origem", freq=freq)


VALOR_PARA_RARIDADE = {1: "Incomum", 2: "Raro", 3: "Épico", 4: "Épico"}


def main():
    conn = conectar()
    cur = conn.cursor()
    # cartas tem coluna raridade de verdade
    cur.execute("select id, tipo_bonus, raridade, drop_de from cartas")
    linhas = cur.fetchall()
    for id_, tipo_bonus, raridade, drop_de in linhas:
        novo = efeito(tipo_bonus, raridade, drop_de)
        cur.execute("update cartas set descricao = %s, valor_bonus = 1 where id = %s", (novo, id_))
    print(f"cartas: {len(linhas)} descrições reescritas.")

    # cristais nao tem coluna raridade — usa o valor_bonus (1/2/3) que a
    # importação já tinha gravado com base na categoria de origem, só pra
    # decidir a frequência do efeito; depois fixa o valor_bonus em 1.
    cur.execute("select id, tipo_bonus, valor_bonus, drop_de from cristais")
    linhas = cur.fetchall()
    for id_, tipo_bonus, valor_bonus, drop_de in linhas:
        raridade = VALOR_PARA_RARIDADE.get(valor_bonus, "Incomum")
        novo = efeito(tipo_bonus, raridade, drop_de)
        cur.execute("update cristais set descricao = %s, valor_bonus = 1 where id = %s", (novo, id_))
    print(f"cristais: {len(linhas)} descrições reescritas.")

    conn.commit()
    print("commit ok.")


if __name__ == "__main__":
    main()
