#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Item 1 do dolist — as 11 missões de caça novas (uma por espécie de ovo
sem par ainda), decidido pelo usuário: 'escrever missão de caça nova pra
cada espécie'. Roda uma vez (idempotente via ON CONFLICT DO NOTHING)."""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "scripts") if False else os.path.dirname(os.path.dirname(__file__)))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.dirname(__file__)), "scripts"))
from migrar_para_supabase import conectar

MISSOES = [
    dict(id="n1-caca-javali", titulo="Javali Jovem na Planície", tipo="caca",
         descricao="Um javali jovem virou praga nas plantações da Colina. Afaste 3 sem machucar a manada toda.",
         regiao="Andar 1 - Planície Ocidental", alvo="Javali Jovem", nivel_min=1,
         custo_folego=2, recompensa_xp=20, recompensa_col_min=8, recompensa_col_max=20,
         drop_item_id="ovo_jovali_jovem", drop_chance=0.30, requer_grupo=False),
    dict(id="n2-caca-lobo", titulo="Alcateia na Floresta do Lobo", tipo="caca",
         descricao="Lobos cinzentos estão caçando perto da trilha. Afugente 4 antes que ataquem viajantes.",
         regiao="Andar 1 - Floresta do Lobo", alvo="Lobo Cinzento", nivel_min=2,
         custo_folego=2, recompensa_xp=30, recompensa_col_min=12, recompensa_col_max=30,
         drop_item_id="ovo_lobo_cinza", drop_chance=0.30, requer_grupo=False),
    dict(id="n2-caca-urso", titulo="Urso Territorial da Floresta do Leste", tipo="caca",
         descricao="Um urso derrubou duas barracas de caçadores. Espante-o antes que ele volte.",
         regiao="Andar 1 - Floresta do Leste", alvo="Urso de Floresta", nivel_min=2,
         custo_folego=3, recompensa_xp=35, recompensa_col_min=14, recompensa_col_max=35,
         drop_item_id="ovo_urso", drop_chance=0.28, requer_grupo=False),
    dict(id="n2-caca-avestruz", titulo="Avestruzes de Batalha no Planalto", tipo="caca",
         descricao="Avestruzes de batalha, treinadas por alguém, atacam quem passa pelo Planalto. Descubra por quê e afaste 3.",
         regiao="Planalto do Vento", alvo="Avestruz de Batalha", nivel_min=2,
         custo_folego=2, recompensa_xp=30, recompensa_col_min=12, recompensa_col_max=30,
         drop_item_id="ovo_arauto", drop_chance=0.30, requer_grupo=False),
    dict(id="n3-caca-lobo-alfa", titulo="O Alfa da Floresta do Lobo", tipo="caca",
         descricao="A alcateia comum não é o problema — o Alfa que a comanda é. Derrote-o e a matilha se dispersa.",
         regiao="Andar 1 - Floresta do Lobo", alvo="Lobo Alfa", nivel_min=3,
         custo_folego=3, recompensa_xp=55, recompensa_col_min=22, recompensa_col_max=55,
         drop_item_id="ovo_lobo_alfa", drop_chance=0.22, requer_grupo=False),
    dict(id="n3-caca-corvo-sombrio", titulo="Corvo Sombrio nas Ruínas", tipo="caca",
         descricao="Um corvo maior e mais escuro que os outros lidera os bandos das Ruínas do Portal. Ele carrega mais que penas.",
         regiao="Andar 1 - Ruínas do Portal", alvo="Corvo Sombrio", nivel_min=3,
         custo_folego=3, recompensa_xp=50, recompensa_col_min=20, recompensa_col_max=50,
         drop_item_id="ovo_corvo_sombrio", drop_chance=0.22, requer_grupo=False),
    dict(id="n4-caca-javali-frenzy", titulo="Frenzy Boar Fora de Controle", tipo="caca",
         descricao="Um javali entrou em frenesi e está destruindo tudo no caminho. Contenha-o antes que alcance a estrada.",
         regiao="Andar 1 - Planície Ocidental", alvo="Frenzy Boar", nivel_min=4,
         custo_folego=3, recompensa_xp=65, recompensa_col_min=24, recompensa_col_max=65,
         drop_item_id="ovo_javali_selvagem", drop_chance=0.20, requer_grupo=False),
    dict(id="n5-caca-aranha-sombra", titulo="Ninho na Caverna Mana", tipo="caca",
         descricao="Um ninho de aranhas das sombras cresceu fundo na Caverna Mana. Limpe a entrada sem acordar tudo.",
         regiao="Caverna Mana", alvo="Aranha das Sombras", nivel_min=5,
         custo_folego=4, recompensa_xp=90, recompensa_col_min=36, recompensa_col_max=90,
         drop_item_id="ovo_aranha_sombra", drop_chance=0.15, requer_grupo=False),
    dict(id="n6-caca-coruja-sabia", titulo="A Coruja Sábia da Biblioteca Antiga", tipo="caca",
         descricao="Uma coruja antiga demais pra ser normal guarda um canto da Biblioteca Antiga. Ela sabe coisas — e não gosta de visitas.",
         regiao="Biblioteca Antiga", alvo="Coruja Sombria (sábia)", nivel_min=6,
         custo_folego=5, recompensa_xp=130, recompensa_col_min=52, recompensa_col_max=130,
         drop_item_id="ovo_coruja_sombria", drop_chance=0.15, requer_grupo=False),
    dict(id="n7-caca-dragao-bebe", titulo="O Filhote do Covil de Obsidiana", tipo="caca",
         descricao="Um dragão bebê sozinho no Covil de Obsidiana ainda é perigoso — e a mãe pode não estar longe. Vá em grupo.",
         regiao="Covil de Obsidiana", alvo="Dragão Bebê Obsidiana", nivel_min=7,
         custo_folego=5, recompensa_xp=180, recompensa_col_min=72, recompensa_col_max=180,
         drop_item_id="ovo_dragao_bebe", drop_chance=0.10, requer_grupo=True),
    dict(id="n9-caca-fenix-bebe", titulo="Rumor de Fênix na Sala do Chefe do Andar 10", tipo="caca",
         descricao="Perto da sala do chefe do andar 10, viajantes juram ter visto uma fênix recém-nascida. Poucos voltaram pra confirmar.",
         regiao="Sala do Chefe do andar 10", alvo="Fênix Bebê", nivel_min=9,
         custo_folego=8, recompensa_xp=380, recompensa_col_min=150, recompensa_col_max=380,
         drop_item_id="ovo_fenix_bebe", drop_chance=0.05, requer_grupo=True),
]

def main():
    conn = conectar()
    cur = conn.cursor()
    cols = ["id","titulo","tipo","descricao","regiao","alvo","nivel_min","custo_folego",
            "recompensa_xp","recompensa_col_min","recompensa_col_max","drop_item_id",
            "drop_chance","requer_grupo","visivel","excluido"]
    for m in MISSOES:
        vals = [m[c] if c in m else (True if c == "visivel" else False) for c in cols]
        placeholders = ",".join(["%s"] * len(cols))
        cur.execute(
            f"insert into missoes_quadro ({','.join(cols)}) values ({placeholders}) "
            f"on conflict (id) do nothing",
            vals,
        )
    conn.commit()
    print(f"OK — {len(MISSOES)} missões inseridas (idempotente).")

if __name__ == "__main__":
    main()
