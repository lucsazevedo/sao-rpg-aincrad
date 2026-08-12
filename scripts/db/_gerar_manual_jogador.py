# -*- coding: utf-8 -*-
"""
Gera o Manual do Jogador (scripts/db/_manual_jogador_template.html +
conteúdo vivo do banco). Rode _extrair_conteudo_livro.py antes.

Rode: python scripts/db/_gerar_manual_jogador.py <saida.html>
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _livro_comum import RAIZ, carregar_dados, montar_armas_e_profissoes

dados = carregar_dados()
indice_armas, indice_profissoes, armas_html, profissoes_html = montar_armas_e_profissoes(dados)

AQUI = os.path.dirname(os.path.abspath(__file__))
with open(os.path.join(AQUI, "_manual_jogador_template.html"), encoding="utf-8") as f:
    template = f.read()

saida_html = (
    template
    .replace("__INDICE_ARMAS__", indice_armas)
    .replace("__INDICE_PROFISSOES__", indice_profissoes)
    .replace("__ARMAS__", armas_html)
    .replace("__PROFISSOES__", profissoes_html)
)

destino = sys.argv[1] if len(sys.argv) > 1 else os.path.join(RAIZ, "scripts", "_manual_jogador.html")
with open(destino, "w", encoding="utf-8") as f:
    f.write(saida_html)
print("gravado em", destino)
