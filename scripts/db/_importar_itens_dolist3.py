#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Item 3 do dolist: importa os catalogos de itens craftaveis descritos nos
arquivos dolist/*.txt (Armaduras, Botas, Luvas, Elmos, Acessorios, Comidas,
Pocoes e Consumiveis, Municoes e Itens de Combate, Cristais de SAO).

Duas familias de saida:
- GEAR (Armaduras/Botas/Luvas/Elmos/Acessorios): ganham uma linha nova em
  `equipamentos` (catalogo, slot ja existente no schema) + uma `receitas`
  linha (tipo='item', resultado_item_id aponta pro equipamentos.id) -- pra
  isso funcionar direito, `craftar_item` precisa aprender a colocar
  tipo='equipamento' no inventario quando resultado_item_id resolve num
  equipamentos (hoje sempre grava 'consumivel', mesmo bug-pattern que
  `aceitar_e_resolver_missao` ja tinha e foi corrigido nesta sessao).
- CONSUMIVEL (Comidas/Pocoes/Municoes/Cristais de SAO): so `receitas` nova,
  resultado_item_id NULL -- mesmo padrao das 128 receitas ja existentes.
  Municoes que "Produzem 10x" usam a coluna nova `receitas.resultado_qtd`
  (nao existia; craftar_item sempre inseria quantidade=1).

Mapeamento de profissao (as 16 oficiais estao em docs/guia_sistema_aincrad.md):
  Coureiro/Artesao -> Costureiro (Tecnica)   [nomes do rascunho nao sao oficiais]
  Ferreiro         -> Ferreiro (Tecnica)
  Joalheiro        -> Joalheiro (Tecnica)
  Cristalista/Alquimista -> Alquimista (Conhecimento)
  Arqueiro/Flecheiro     -> Cacador (Reflexo)  [tematico: cacador usa arco]
  Cozinheiro       -> Cozinheiro (Conhecimento)

Cristais de SAO: existe uma tabela `cristais` separada (57 linhas, drop do
bestiario) mas ela e outra mecanica -- bonus PASSIVO enquanto equipado
("+1 num golpe"). Os cristais craftaveis deste arquivo sao consumo-unico
("quebra o cristal") -- ficam como receita tipo='item' comum, sem tocar na
tabela `cristais`.

Fantasia elemental (fogo/gelo/raio) que aparece em alguns itens (Flecha
Elemental, Cristal Elemental etc.) e mantida como TEXTO DE SABOR do efeito
do item craftado -- o item 13 (removido no dolist) foi sobre fraqueza de
MONSTRO, nao sobre o jogador escolher elemento pra um efeito temporario.

Roda em transacao com dry-run (rollback) primeiro; so aplica de verdade com
--commit.
"""
import sys
import re
import json
import unicodedata

sys.path.insert(0, "scripts")
from migrar_para_supabase import conectar  # noqa: E402


def slug(txt):
    s = unicodedata.normalize("NFKD", txt).encode("ascii", "ignore").decode("ascii")
    s = s.lower()
    s = re.sub(r"[^a-z0-9]+", "_", s).strip("_")
    return s


# tier -> (nivel_receita, folego_custo, xp_recompensa, raridade)
TIER_GEAR = {
    1: (2, 1, 18, "Comum"),
    2: (6, 3, 65, "Raro"),
    3: (8, 4, 90, "Épico"),        # item 14 de cada categoria de gear (10+)
    4: (10, 5, 120, "Lendário"),   # item 15 "... Lendário de Aincrad"
}
TIER_CONSUMIVEL = {
    1: (2, 1, 18, "comum"),
    2: (6, 3, 65, "raro"),
    3: (8, 4, 90, "epico"),
    4: (10, 5, 120, "lendario"),
}

PROFISSAO_MAP = {
    "Coureiro": ("Costureiro", "Técnica"),
    "Coureiro/Ferreiro": ("Costureiro", "Técnica"),
    "Artesão": ("Costureiro", "Técnica"),
    "Ferreiro": ("Ferreiro", "Técnica"),
    "Joalheiro": ("Joalheiro", "Técnica"),
    "Cristalista/Alquimista": ("Alquimista", "Conhecimento"),
    "Alquimista": ("Alquimista", "Conhecimento"),
    "Arqueiro/Flecheiro": ("Caçador", "Reflexo"),
    "Cozinheiro": ("Cozinheiro", "Conhecimento"),
}


def mats(pairs):
    """[(qtd, nome), ...] -> jsonb materiais (mat_id gerado por slug)."""
    out = []
    for qtd, nome in pairs:
        out.append({"mat_id": "mat_" + slug(nome), "qtd": qtd, "_nome": nome})
    return out


# ---------------------------------------------------------------------------
# GEAR: Armaduras, Botas, Luvas, Elmos, Acessórios (15 itens cada, tiers
# 1-10 = tier1, 11-13 = tier2, 14 = tier3, 15 = tier4)
# ---------------------------------------------------------------------------

ARMADURAS = [
    (1, "Vestimenta de Aventureiro", "Coureiro", [(3,"Couro Cru"),(1,"Fibra Vegetal"),(1,"Linha Resistente")], 1),
    (2, "Armadura de Couro Simples", "Coureiro", [(5,"Couro Curtido"),(1,"Linha Reforçada"),(1,"Resina Natural")], 1),
    (3, "Armadura de Couro Reforçado", "Coureiro", [(6,"Couro Grosso"),(2,"Placa de Ferro Pequena"),(1,"Linha Resistente")], 1),
    (4, "Colete do Caçador", "Coureiro", [(4,"Couro de Lobo"),(1,"Pena de Ave Grande"),(1,"Fibra Forte")], 1),
    (5, "Armadura de Ferro Leve", "Ferreiro", [(4,"Barra de Ferro"),(2,"Couro Curtido"),(1,"Rebite de Ferro")], 1),
    (6, "Armadura do Soldado", "Ferreiro", [(5,"Barra de Ferro"),(2,"Couro Reforçado"),(1,"Placa de Ferro")], 1),
    (7, "Armadura Escamada", "Ferreiro", [(4,"Escama de Monstro"),(2,"Barra de Ferro"),(1,"Couro Grosso")], 1),
    (8, "Armadura do Guarda", "Ferreiro", [(6,"Barra de Ferro"),(1,"Couro Nobre"),(1,"Placa Reforçada")], 1),
    (9, "Armadura do Mercenário", "Coureiro/Ferreiro", [(3,"Couro Grosso"),(3,"Barra de Ferro"),(1,"Tecido Resistente")], 1),
    (10, "Armadura de Batalha Inicial", "Ferreiro", [(7,"Barra de Ferro"),(2,"Couro Reforçado"),(1,"Pedra de Amolar")], 1),
    (11, "Armadura de Aço", "Ferreiro", [(8,"Barra de Aço"),(2,"Couro Nobre"),(1,"Carvão Refinado")], 2),
    (12, "Armadura do Cavaleiro", "Ferreiro", [(8,"Placa de Aço"),(2,"Couro Reforçado"),(1,"Cristal de Defesa")], 2),
    (13, "Armadura do Guardião", "Ferreiro", [(6,"Placa de Aço"),(2,"Cristal de Defesa"),(1,"Núcleo de Monstro")], 2),
    (14, "Armadura Celestial", "Ferreiro", [(8,"Liga de Mithril"),(2,"Cristal Luminoso"),(1,"Núcleo de Guardião"),(1,"Essência Divina")], 3,
        ("Luz Protetora", "A armadura reage ao perigo antes que o usuário perceba. Quando sofrer uma ameaça extrema: pode criar uma proteção inesperada, pode revelar a origem de um ataque, pode permitir uma reação defensiva impossível.")),
    (15, "Armadura Lendária de Aincrad", "Ferreiro", [(10,"Liga de Mithril"),(3,"Cristal Prismático"),(1,"Núcleo de Chefe"),(1,"Essência Lendária")], 4,
        ("Vontade Inquebrável", "Uma armadura criada para aqueles que recusam cair. Quando o usuário proteger alguém ou enfrentar uma situação impossível: pode permanecer lutando mesmo sob grande pressão, pode transformar resistência em vantagem, pode inspirar aliados próximos.")),
]

BOTAS = [
    (1, "Botas Simples", "Coureiro", [(3,"Couro Cru"),(1,"Linha Resistente"),(1,"Fibra Vegetal")], 1),
    (2, "Botas de Couro", "Coureiro", [(4,"Couro Curtido"),(1,"Linha Reforçada"),(1,"Resina Natural")], 1),
    (3, "Botas do Viajante", "Coureiro", [(3,"Couro Grosso"),(1,"Fibra Forte"),(1,"Tecido Resistente")], 1),
    (4, "Botas do Caçador", "Coureiro", [(4,"Couro de Lobo"),(1,"Pena Rara"),(1,"Linha Reforçada")], 1),
    (5, "Botas Reforçadas", "Artesão", [(3,"Couro Grosso"),(2,"Placa de Ferro Pequena"),(1,"Linha de Aço")], 1),
    (6, "Botas de Ferro Leve", "Ferreiro", [(3,"Barra de Ferro"),(2,"Couro Curtido"),(1,"Rebite de Ferro")], 1),
    (7, "Botas do Soldado", "Ferreiro", [(3,"Barra de Ferro"),(1,"Couro Reforçado"),(1,"Tecido Resistente")], 1),
    (8, "Botas Escamadas", "Artesão", [(4,"Escama de Monstro"),(2,"Couro Grosso"),(1,"Linha Resistente")], 1),
    (9, "Botas do Explorador", "Artesão", [(3,"Couro Nobre"),(1,"Cristal de Detecção"),(1,"Fibra Forte")], 1),
    (10, "Botas de Batalha", "Ferreiro", [(4,"Barra de Ferro"),(2,"Couro Reforçado"),(1,"Pedra de Amolar")], 1),
    (11, "Botas de Aço", "Ferreiro", [(5,"Barra de Aço"),(2,"Couro Nobre"),(1,"Carvão Refinado")], 2),
    (12, "Botas do Cavaleiro", "Ferreiro", [(5,"Placa de Aço"),(1,"Cristal de Defesa"),(1,"Couro Reforçado")], 2),
    (13, "Botas do Assassino", "Coureiro", [(5,"Couro Sombrio"),(1,"Cristal de Furtividade"),(1,"Seda Rara")], 2),
    (14, "Botas do Vento Celestial", "Artesão", [(5,"Liga de Mithril"),(2,"Cristal de Vento"),(1,"Essência Elemental")], 3,
        ("Passo do Vendaval", "As botas respondem aos movimentos do usuário. Quando realizar ações de movimento: pode atravessar rapidamente uma área, pode mudar sua posição de forma inesperada, pode criar vantagens usando velocidade.")),
    (15, "Botas Lendárias de Aincrad", "Artesão", [(6,"Liga de Mithril"),(2,"Cristal Prismático"),(1,"Núcleo de Chefe"),(1,"Essência Lendária")], 4,
        ("Caminho Impossível", "Um equipamento criado para aventureiros que desafiam limites. Quando explorar ou enfrentar perigos: pode encontrar caminhos alternativos, pode superar obstáculos difíceis, pode realizar movimentos que parecem impossíveis.")),
]

LUVAS = [
    (1, "Luvas Simples", "Coureiro", [(2,"Couro Cru"),(1,"Linha Resistente"),(1,"Fibra Vegetal")], 1),
    (2, "Luvas de Couro", "Coureiro", [(3,"Couro Curtido"),(1,"Linha Reforçada"),(1,"Resina Natural")], 1),
    (3, "Luvas do Trabalhador", "Artesão", [(2,"Couro Grosso"),(1,"Tecido Resistente"),(1,"Fibra Forte")], 1),
    (4, "Luvas do Caçador", "Coureiro", [(3,"Couro de Lobo"),(1,"Garra de Fera"),(1,"Linha Reforçada")], 1),
    (5, "Luvas Reforçadas", "Artesão", [(3,"Couro Grosso"),(1,"Placa de Ferro Pequena"),(1,"Linha de Aço")], 1),
    (6, "Luvas de Ferro Leve", "Ferreiro", [(2,"Barra de Ferro"),(2,"Couro Curtido"),(1,"Rebite de Ferro")], 1),
    (7, "Luvas do Soldado", "Ferreiro", [(3,"Barra de Ferro"),(1,"Couro Reforçado"),(1,"Placa de Ferro")], 1),
    (8, "Luvas Escamadas", "Artesão", [(4,"Escama de Monstro"),(2,"Couro Grosso"),(1,"Linha Resistente")], 1),
    (9, "Luvas do Ladrão", "Coureiro", [(3,"Couro Fino"),(1,"Seda Resistente"),(1,"Linha Reforçada")], 1),
    (10, "Luvas de Batalha", "Ferreiro", [(4,"Barra de Ferro"),(2,"Couro Reforçado"),(1,"Pedra de Amolar")], 1),
    (11, "Luvas de Aço", "Ferreiro", [(5,"Barra de Aço"),(2,"Couro Nobre"),(1,"Carvão Refinado")], 2),
    (12, "Luvas do Duelista", "Ferreiro", [(4,"Barra de Aço"),(1,"Cristal de Precisão"),(1,"Couro Reforçado")], 2),
    (13, "Luvas do Guardião", "Ferreiro", [(5,"Placa de Aço"),(1,"Cristal de Defesa"),(1,"Núcleo de Monstro")], 2),
    (14, "Luvas do Titã", "Ferreiro", [(5,"Liga de Mithril"),(2,"Cristal de Força"),(1,"Núcleo de Gigante")], 3,
        ("Força Colossal", "As luvas amplificam a força física do usuário. Quando realizar uma ação de força: pode superar limitações normais, pode manipular objetos muito pesados, pode transformar esforço bruto em uma grande vantagem.")),
    (15, "Luvas Lendárias de Aincrad", "Artesão", [(6,"Liga de Mithril"),(2,"Cristal Prismático"),(1,"Núcleo de Chefe"),(1,"Essência Lendária")], 4,
        ("Domínio Perfeito", "Uma criação feita para mestres de qualquer arma. Quando utilizar técnica ou habilidade: pode executar movimentos com precisão extrema, pode reduzir erros em ações delicadas, pode transformar conhecimento em vantagem.")),
]

ELMOS = [
    (1, "Elmo Simples", "Ferreiro", [(2,"Barra de Ferro"),(1,"Couro Curtido"),(1,"Tecido Resistente")], 1),
    (2, "Capuz de Couro", "Coureiro", [(3,"Couro Cru"),(1,"Linha Reforçada"),(1,"Fibra Vegetal")], 1),
    (3, "Elmo de Bronze", "Ferreiro", [(3,"Minério de Bronze"),(1,"Couro Curtido"),(1,"Rebite de Ferro")], 1),
    (4, "Elmo do Soldado", "Ferreiro", [(3,"Barra de Ferro"),(2,"Couro Reforçado"),(1,"Placa de Ferro")], 1),
    (5, "Elmo do Caçador", "Coureiro", [(4,"Couro de Lobo"),(1,"Pena Rara"),(1,"Fibra Forte")], 1),
    (6, "Elmo Reforçado", "Ferreiro", [(4,"Barra de Ferro"),(1,"Couro Grosso"),(1,"Placa de Ferro")], 1),
    (7, "Elmo de Guarda", "Ferreiro", [(3,"Barra de Ferro"),(1,"Couro Nobre"),(1,"Cristal de Defesa")], 1),
    (8, "Elmo Escamado", "Ferreiro", [(4,"Escama de Monstro"),(2,"Barra de Ferro"),(1,"Couro Curtido")], 1),
    (9, "Elmo do Mercenário", "Artesão", [(3,"Couro Grosso"),(2,"Barra de Ferro"),(1,"Tecido Resistente")], 1),
    (10, "Elmo de Batalha", "Ferreiro", [(5,"Barra de Ferro"),(1,"Couro Reforçado"),(1,"Pedra de Amolar")], 1),
    (11, "Elmo de Aço", "Ferreiro", [(4,"Barra de Aço"),(1,"Couro Nobre"),(1,"Carvão Refinado")], 2),
    (12, "Elmo do Cavaleiro", "Ferreiro", [(5,"Placa de Aço"),(1,"Cristal de Defesa"),(1,"Couro Reforçado")], 2),
    (13, "Elmo do Guardião", "Ferreiro", [(4,"Placa de Aço"),(2,"Cristal de Defesa"),(1,"Núcleo de Monstro")], 2),
    (14, "Elmo do Dragão Ancestral", "Ferreiro", [(5,"Liga de Mithril"),(2,"Escama de Dragão"),(1,"Cristal Flamejante"),(1,"Núcleo de Criatura Ancestral")], 3,
        ("Instinto Dracônico", "O usuário sente o perigo antes que ele aconteça. Quando estiver em combate: pode perceber ameaças escondidas, pode reagir melhor contra ataques surpresa, pode intimidar criaturas inferiores.")),
    (15, "Elmo Lendário de Aincrad", "Ferreiro", [(6,"Liga de Mithril"),(2,"Cristal Prismático"),(1,"Núcleo de Chefe"),(1,"Essência Lendária")], 4,
        ("Visão do Herói", "Um equipamento criado para líderes e guerreiros lendários. Quando comandar ou proteger aliados: pode identificar pontos fracos do inimigo, pode coordenar ações do grupo, pode transformar uma decisão difícil em uma vantagem.")),
]

ACESSORIOS = [
    (1, "Anel de Ferro Simples", "Joalheiro", [(2,"Barra de Ferro"),(1,"Pedra Comum")], 1),
    (2, "Colar de Couro", "Artesão", [(2,"Couro Curtido"),(1,"Linha Resistente"),(1,"Cristal Pequeno")], 1),
    (3, "Pulseira de Ferro", "Ferreiro", [(2,"Barra de Ferro"),(1,"Couro Cru")], 1),
    (4, "Pingente de Proteção", "Joalheiro", [(1,"Cristal de Defesa"),(1,"Barra de Bronze"),(1,"Corrente Simples")], 1),
    (5, "Anel do Viajante", "Joalheiro", [(1,"Prata Bruta"),(1,"Cristal Claro"),(1,"Couro Fino")], 1),
    (6, "Brinco de Cristal", "Joalheiro", [(2,"Cristal Pequeno"),(1,"Prata Bruta")], 1),
    (7, "Medalhão do Explorador", "Artesão", [(1,"Cristal de Detecção"),(2,"Barra de Ferro"),(1,"Couro Nobre")], 1),
    (8, "Cinto Reforçado", "Coureiro", [(3,"Couro Grosso"),(1,"Fivela de Ferro"),(1,"Linha Reforçada")], 1),
    (9, "Broche do Guerreiro", "Ferreiro", [(1,"Barra de Ferro"),(1,"Cristal de Impacto"),(1,"Couro Curtido")], 1),
    (10, "Amuleto Simples", "Joalheiro", [(1,"Cristal Natural"),(1,"Madeira Nobre"),(1,"Linha Mística")], 1),
    (11, "Anel do Cavaleiro", "Joalheiro", [(2,"Prata Refinada"),(1,"Cristal de Defesa"),(1,"Barra de Aço")], 2),
    (12, "Colar Elemental", "Joalheiro", [(2,"Cristal Elemental"),(1,"Ouro Refinado"),(1,"Corrente de Aço")], 2),
    (13, "Bracelete do Guardião", "Joalheiro", [(2,"Barra de Aço"),(1,"Cristal de Defesa"),(1,"Núcleo de Monstro")], 2),
    (14, "Anel do Infinito", "Joalheiro", [(2,"Liga de Mithril"),(2,"Cristal Prismático"),(1,"Essência Elemental")], 3,
        ("Energia Inesgotável", "O anel mantém uma conexão constante com a energia do usuário. Quando realizar uma ação importante: pode recuperar concentração rapidamente, pode manter uma técnica por mais tempo, pode superar limitações momentâneas.")),
    (15, "Colar Lendário de Aincrad", "Joalheiro", [(3,"Liga de Mithril"),(2,"Cristal Prismático"),(1,"Núcleo de Chefe"),(1,"Essência Lendária")], 4,
        ("Herança dos Heróis", "Um símbolo carregado pelas maiores lendas de Aincrad. Quando enfrentar desafios decisivos: pode fortalecer uma escolha importante, pode proteger contra consequências graves, pode inspirar aliados próximos.")),
]

GEAR_CATEGORIAS = [
    ("armadura", "Armaduras", ARMADURAS),
    ("botas", "Botas", BOTAS),
    ("luvas", "Luvas", LUVAS),
    ("elmo", "Elmos", ELMOS),
    ("acessorio", "Acessórios", ACESSORIOS),
]

# ---------------------------------------------------------------------------
# CONSUMÍVEIS: Comidas, Poções, Munições, Cristais de SAO
# tupla: (nome, profissao_raw, materiais, tier, efeito_texto, produz_qtd)
# ---------------------------------------------------------------------------

COMIDAS = [
    ("Carne Assada de Monstro", "Cozinheiro", [(1,"Carne de Monstro"),(1,"Sal"),(1,"Erva Aromática")], 1,
     "Buff: Resistência Física — durante uma cena, o usuário suporta melhor esforços físicos e recebe vantagem em ações de resistência corporal.", 1),
    ("Pão do Aventureiro", "Cozinheiro", [(2,"Trigo"),(1,"Mel Natural"),(1,"Erva Doce")], 1,
     "Buff: Energia Renovada — durante uma cena, reduz efeitos de fadiga e ajuda em viagens longas.", 1),
    ("Sopa de Ervas Curativas", "Cozinheiro", [(3,"Ervas Medicinais"),(1,"Água Limpa"),(1,"Tempero Natural")], 1,
     "Buff: Recuperação — pequena recuperação após descanso, melhora efeitos de cura recebida.", 1),
    ("Espetinho de Caça", "Cozinheiro", [(1,"Carne de Animal"),(1,"Madeira de Carvalho"),(1,"Tempero Simples")], 1,
     "Buff: Instinto de Caçador — durante uma cena, melhora rastreamento e ajuda a encontrar criaturas.", 1),
    ("Frutas Cristalizadas", "Cozinheiro", [(3,"Frutas Raras"),(1,"Açúcar Natural")], 1,
     "Buff: Foco Mental — durante uma cena, melhora concentração e ajuda no uso de técnicas.", 1),
    ("Leite Fortificado", "Cozinheiro", [(1,"Leite Fresco"),(1,"Erva Forte")], 1,
     "Buff: Vitalidade — durante uma cena, melhora resistência contra cansaço.", 1),
    ("Biscoito de Energia", "Cozinheiro", [(2,"Farinha"),(1,"Mel"),(1,"Cristal Pequeno")], 1,
     "Buff: Recuperação de Energia — durante uma cena, ajuda a manter habilidades.", 1),
    ("Chá Calmante", "Cozinheiro", [(2,"Ervas Tranquilas"),(1,"Água Pura")], 1,
     "Buff: Controle — durante uma cena, ajuda em ações de concentração e precisão.", 1),
    ("Bife do Guerreiro", "Cozinheiro", [(2,"Carne de Monstro Raro"),(1,"Tempero Especial"),(1,"Erva Forte")], 2,
     "Buff: Poder Físico — durante uma cena, aumenta impacto de ataques e melhora ações de força.", 1),
    ("Prato do Mestre Espadachim", "Cozinheiro", [(1,"Peixe Raro"),(2,"Ervas Especiais"),(1,"Molho Raro")], 2,
     "Buff: Precisão Absoluta — durante uma cena, melhora ataques técnicos e ajuda em golpes precisos.", 1),
    ("Ensopado do Guardião", "Cozinheiro", [(2,"Carne Resistente"),(1,"Cristal de Defesa"),(1,"Erva Vital")], 2,
     "Buff: Defesa Superior — durante uma cena, reduz impactos recebidos e aumenta resistência.", 1),
    ("Bolo de Cristal", "Cozinheiro", [(2,"Açúcar Raro"),(1,"Cristal Pequeno"),(1,"Fruta Rara")], 2,
     "Buff: Recuperação Mental — durante uma cena, melhora foco e ajuda no uso de habilidades.", 1),
    ("Prato do Explorador", "Cozinheiro", [(1,"Carne de Caça Rara"),(1,"Ervas Selvagens"),(1,"Cogumelo Especial")], 2,
     "Buff: Sobrevivência — durante uma cena, facilita exploração e ajuda contra ambientes perigosos.", 1),
    ("Banquete dos Heróis", "Cozinheiro", [(3,"Carne Lendária"),(2,"Ervas Ancestrais"),(1,"Essência Vital")], 3,
     "Efeito — Espírito de Herói: durante uma cena, o grupo recebe coragem extra, permite enfrentar grandes ameaças sem hesitação e fortalece ações em equipe.", 1),
    ("Carne do Monstro Supremo", "Cozinheiro", [(2,"Carne de Chefe"),(2,"Tempero Lendário"),(1,"Cristal Vital")], 3,
     "Efeito — Instinto Supremo: durante uma cena, melhora percepção de batalha, permite reagir rapidamente a ameaças e aumenta eficiência em combate.", 1),
    ("Néctar de Aincrad", "Cozinheiro", [(3,"Frutas Lendárias"),(2,"Cristais Puros"),(1,"Essência Ancestral")], 4,
     "Efeito — Harmonia Perfeita: durante uma cena, corpo e mente entram em equilíbrio, melhorando qualquer tipo de ação importante.", 1),
    ("Prato Lendário do Cozinheiro", "Cozinheiro", [(1,"Ingrediente Único"),(2,"Cristal Prismático"),(1,"Núcleo de Chefe")], 4,
     "Efeito — Sabor da Vitória: durante uma cena, escolha um atributo (Corpo/Reflexo/Conhecimento/Técnica/Espírito) — o prato fortalece temporariamente esse aspecto.", 1),
]

POCOES = [
    ("Poção Pequena de HP", "Alquimista", [(2,"Erva Curativa"),(1,"Água Purificada"),(1,"Frasco Vazio")], 1,
     "Recupera uma pequena quantidade de vida.", 1),
    ("Poção Pequena de Regeneração", "Alquimista", [(2,"Erva Vital"),(1,"Mel Natural"),(1,"Frasco Vazio")], 1,
     "Recupera vida aos poucos durante uma cena.", 1),
    ("Poção de Energia", "Alquimista", [(2,"Erva Azul"),(1,"Cristal Pequeno"),(1,"Frasco")], 1,
     "Recupera energia para uso de técnicas.", 1),
    ("Poção Média de HP", "Alquimista", [(3,"Erva Curativa Rara"),(1,"Cristal Vital"),(1,"Frasco Reforçado")], 2,
     "Recupera grande quantidade de vida.", 1),
    ("Poção de Velocidade", "Alquimista", [(2,"Planta Veloz"),(1,"Cristal de Vento"),(1,"Frasco Reforçado")], 2,
     "Aumenta movimentação durante uma cena.", 1),
    ("Poção de Força", "Alquimista", [(2,"Raiz Gigante"),(1,"Sangue de Monstro"),(1,"Frasco Reforçado")], 2,
     "Melhora ataques físicos temporariamente.", 1),
    ("Poção de Resistência", "Alquimista", [(2,"Cristal de Defesa"),(2,"Erva Forte")], 2,
     "Reduz efeitos de dano recebido.", 1),
    ("Elixir da Vida", "Alquimista", [(5,"Erva Lendária"),(2,"Cristal Vital"),(1,"Essência Lendária")], 4,
     "Recupera completamente o potencial físico do usuário.", 1),
    ("Elixir Elemental Supremo", "Alquimista", [(3,"Cristal Elemental"),(1,"Essência Ancestral"),(1,"Núcleo de Guardião")], 4,
     "Efeito — Domínio Elemental: escolha um elemento (Fogo/Gelo/Raio/Vento/Terra) — o usuário ganha afinidade temporária com ele pela cena.", 1),
]

MUNICOES = [
    ("Flecha Simples", "Arqueiro/Flecheiro", [(1,"Madeira Leve"),(1,"Pena de Ave"),(1,"Ponta de Ferro")], 1,
     "Munição básica para arco.", 10),
    ("Flecha Perfurante", "Arqueiro/Flecheiro", [(1,"Madeira Resistente"),(1,"Ponta de Ferro Afiada"),(1,"Pena")], 1,
     "Melhor contra armaduras leves.", 10),
    ("Flecha Incendiária", "Arqueiro/Flecheiro", [(10,"Flechas Simples"),(1,"Óleo"),(1,"Cristal de Fogo Pequeno")], 1,
     "Pode causar queimadura ou incendiar objetos ao acertar.", 10),
    ("Virote Simples", "Arqueiro/Flecheiro", [(1,"Madeira Leve"),(1,"Ponta de Ferro"),(1,"Pena Pequena")], 1,
     "Munição básica para besta.", 10),
    ("Virote Perfurante", "Arqueiro/Flecheiro", [(1,"Madeira Resistente"),(1,"Ponta de Aço"),(1,"Pedra de Amolar")], 1,
     "Munição de besta melhor contra armaduras.", 10),
    ("Bomba de Fumaça", "Arqueiro/Flecheiro", [(1,"Carvão"),(1,"Erva Escura"),(1,"Frasco Vazio")], 1,
     "Cria uma área de fumaça — útil para fugir, esconder aliados ou criar oportunidade.", 1),
    ("Bomba Cegante", "Arqueiro/Flecheiro", [(1,"Cristal Luminoso"),(1,"Pó Mineral"),(1,"Frasco Vazio")], 1,
     "Libera uma luz intensa que cega temporariamente.", 1),
    ("Armadilha Simples", "Arqueiro/Flecheiro", [(1,"Madeira"),(1,"Corda"),(1,"Ferro")], 1,
     "Prende criaturas pequenas.", 1),
    ("Óleo Escorregadio", "Arqueiro/Flecheiro", [(1,"Óleo Natural"),(1,"Erva Lubrificante")], 1,
     "Cria uma área difícil de atravessar.", 1),
    ("Flecha Elemental", "Arqueiro/Flecheiro", [(10,"Flechas Perfurantes"),(1,"Cristal Elemental"),(1,"Essência Mágica")], 2,
     "Escolha um elemento (Fogo/Gelo/Raio/Vento) — a flecha recebe essa propriedade elemental pela cena.", 10),
    ("Flecha Rastreadora", "Arqueiro/Flecheiro", [(1,"Flecha Perfeita"),(1,"Cristal de Localização"),(1,"Essência de Monstro")], 2,
     "Ao atingir um alvo, permite acompanhar sua localização e facilita perseguições.", 5),
    ("Virote Explosivo", "Arqueiro/Flecheiro", [(1,"Virote de Aço"),(1,"Pólvora"),(1,"Cristal de Fogo")], 2,
     "Ao atingir, causa impacto em área pequena.", 5),
    ("Bomba Congelante", "Arqueiro/Flecheiro", [(1,"Cristal de Gelo"),(1,"Água Cristalizada"),(1,"Frasco Reforçado")], 2,
     "Pode reduzir movimento de inimigos na área.", 1),
    ("Veneno de Monstro", "Arqueiro/Flecheiro", [(1,"Veneno Natural"),(1,"Ervas Sombras"),(1,"Frasco Especial")], 2,
     "Aplica efeito negativo temporário no alvo atingido.", 1),
    ("Armadilha do Caçador", "Arqueiro/Flecheiro", [(1,"Ferro Reforçado"),(1,"Corda Forte"),(1,"Presa de Monstro")], 2,
     "Prende criaturas médias.", 1),
    ("Flecha do Dragão Celestial", "Arqueiro/Flecheiro", [(10,"Flechas Perfeitas"),(2,"Escama de Dragão"),(1,"Cristal Elemental Supremo")], 3,
     "Efeito — Chama Celestial: ao atingir, libera energia elemental, pode atravessar defesas e causa uma grande abertura no inimigo.", 10),
    ("Flecha Fantasma", "Arqueiro/Flecheiro", [(1,"Madeira Ancestral"),(1,"Cristal Sombrio"),(1,"Essência Espiritual")], 3,
     "Efeito — Disparo Invisível: a flecha é difícil de detectar, pode surpreender inimigos e ignora algumas proteções.", 5),
    ("Bomba do Caos", "Arqueiro/Flecheiro", [(1,"Cristal Prismático"),(1,"Essência Elemental"),(1,"Núcleo de Monstro Chefe")], 3,
     "Efeito — Explosão Variável: ao explodir, escolha um efeito (Fogo/Gelo/Raio/Trevas/Vento).", 1),
    ("Armadilha do Predador Ancestral", "Arqueiro/Flecheiro", [(1,"Metal Lendário"),(1,"Cristal de Controle"),(1,"Núcleo de Chefe")], 3,
     "Efeito — Prisão Absoluta: quando ativada, pode impedir o movimento de uma criatura poderosa e cria uma grande vantagem estratégica.", 1),
]

CRISTAIS = [
    ("Cristal de Cura", "Cristalista/Alquimista", [(1,"Cristal Verde"),(2,"Erva Curativa"),(1,"Essência Vital")], 1,
     "Ao quebrar: recupera vida imediatamente, pode ser usado em aliados próximos.", 1),
    ("Cristal de Purificação", "Cristalista/Alquimista", [(1,"Cristal Branco"),(2,"Erva Purificadora"),(1,"Água Sagrada")], 1,
     "Remove veneno comum, doenças simples e efeitos negativos leves.", 1),
    ("Cristal de Luz", "Cristalista/Alquimista", [(1,"Cristal Luminoso"),(1,"Fragmento Mágico")], 1,
     "Cria uma luz intensa durante uma cena — útil em exploração, cidades e cavernas.", 1),
    ("Cristal de Mensagem", "Cristalista/Alquimista", [(1,"Cristal Azul"),(1,"Fragmento Mágico")], 1,
     "Permite comunicação à distância.", 1),
    ("Cristal de Visão", "Cristalista/Alquimista", [(1,"Cristal Claro"),(1,"Essência Lunar")], 1,
     "Melhora percepção — permite enxergar no escuro, encontrar rastros e observar detalhes ocultos.", 1),
    ("Cristal de Respiração", "Cristalista/Alquimista", [(1,"Cristal Azul"),(1,"Erva Aquática")], 1,
     "Permite respirar em ambientes difíceis.", 1),
    ("Cristal de Calor", "Cristalista/Alquimista", [(1,"Cristal Vermelho"),(1,"Essência Flamejante")], 1,
     "Protege contra frio extremo.", 1),
    ("Cristal de Água", "Cristalista/Alquimista", [(1,"Cristal Azul"),(1,"Essência Aquática")], 1,
     "Cria água limpa para consumo.", 1),
    ("Cristal de Armazenamento", "Cristalista/Alquimista", [(1,"Cristal Pequeno"),(1,"Fragmento Dimensional")], 1,
     "Permite guardar pequenos itens.", 1),
    ("Cristal de Retorno", "Cristalista/Alquimista", [(1,"Cristal Azul"),(1,"Essência Espacial")], 1,
     "Retorna o usuário para um ponto seguro registrado.", 1),
    ("Cristal de Teleporte", "Cristalista/Alquimista", [(2,"Cristal Azul"),(1,"Fragmento Dimensional"),(1,"Essência Espacial")], 2,
     "Permite teleportar para cidades, áreas registradas ou pontos de encontro.", 1),
    ("Cristal de Teleporte em Grupo", "Cristalista/Alquimista", [(3,"Cristal Azul"),(1,"Cristal de Retorno"),(1,"Essência Espacial")], 2,
     "Transporta o usuário e aliados próximos.", 1),
    ("Cristal de Detecção", "Cristalista/Alquimista", [(2,"Cristal Claro"),(1,"Cristal de Visão"),(1,"Essência Mística")], 2,
     "Revela criaturas próximas, armadilhas e objetos escondidos.", 1),
    ("Cristal de Barreira", "Cristalista/Alquimista", [(2,"Cristal de Defesa"),(1,"Essência Protetora")], 2,
     "Cria uma proteção temporária.", 1),
    ("Cristal de Camuflagem", "Cristalista/Alquimista", [(2,"Cristal Sombrio"),(1,"Essência Oculta")], 2,
     "Dificulta ser encontrado.", 1),
    ("Cristal Elemental", "Cristalista/Alquimista", [(2,"Cristal Elemental"),(1,"Fragmento Mágico")], 2,
     "Libera energia elemental — escolha Fogo, Gelo, Raio ou Vento.", 1),
    ("Cristal de Ressurreição", "Cristalista/Alquimista", [(3,"Cristal Prismático"),(1,"Essência da Vida"),(1,"Núcleo de Chefe")], 4,
     "Efeito — Última Esperança: um cristal extremamente raro. Permite evitar uma consequência fatal e salvar alguém em situação crítica. Uso extremamente limitado.", 1),
    ("Cristal Supremo de Teleporte", "Cristalista/Alquimista", [(4,"Cristal Azul Perfeito"),(2,"Essência Espacial"),(1,"Núcleo Ancestral")], 4,
     "Efeito — Portal Supremo: permite teleportar grandes grupos, alcançar locais extremamente distantes e criar rotas estratégicas.", 1),
    ("Cristal do Administrador", "Cristalista/Alquimista", [(3,"Cristal Prismático"),(1,"Núcleo de Chefe"),(1,"Essência do Sistema")], 4,
     "Efeito — Controle do Sistema: um cristal quase impossível de existir. Permite interagir com sistemas especiais, ativar mecanismos antigos e revelar informações ocultas.", 1),
    ("Cristal da Alma", "Cristalista/Alquimista", [(3,"Cristal Espiritual"),(2,"Cristal Prismático"),(1,"Essência Lendária")], 4,
     "Efeito — Espírito Inquebrável: quando ativado, fortalece a determinação do usuário, protege contra efeitos mentais e permite superar limitações.", 1),
    ("Cristal do Herói de Aincrad", "Cristalista/Alquimista", [(5,"Cristal Prismático"),(1,"Núcleo de Chefe Final"),(1,"Essência Lendária")], 4,
     "Efeito — Legado do Jogador: o cristal guarda a vontade de grandes aventureiros. Quando usado, concede uma grande vantagem em uma cena decisiva e pode mudar o rumo de uma batalha.", 1),
]

CONSUMIVEL_CATEGORIAS = [
    ("comida", "Cozinheiro", COMIDAS),
    ("pocao", "Alquimista", POCOES),
    ("municao", "Caçador", MUNICOES),
    ("cristal", "Alquimista", CRISTAIS),
]


def build_gear_rows():
    equip_rows = []
    receita_rows = []
    for prefixo, slot, itens in GEAR_CATEGORIAS:
        for item in itens:
            if len(item) == 5:
                num, nome, prof_raw, materiais, tier = item
                efeito = None
            else:
                num, nome, prof_raw, materiais, tier, efeito = item
            eid = f"{prefixo}_{slug(nome)}"
            nivel, folego, xp, raridade_equip = TIER_GEAR[tier]
            prof_canonica, atributo = PROFISSAO_MAP[prof_raw]
            resumo = f"{slot} craftável — {prof_canonica}, dificuldade {'6-' if tier==1 else '7-9' if tier==2 else '10+'}."
            efeito_txt = efeito[1] if efeito else None
            equip_rows.append({
                "id": eid, "nome": nome, "slot": slot,
                "raridade": raridade_equip, "resumo": resumo, "efeito": efeito_txt,
            })
            raridade_receita = raridade_equip.lower().replace("é", "e").replace("á", "a")
            # normaliza pro enum de receitas.resultado_raridade (comum/incomum/raro/epico/lendario)
            raridade_receita = {"comum": "comum", "raro": "raro", "epico": "epico", "lendario": "lendario"}[raridade_receita]
            receita_rows.append({
                "id": f"rec_{eid}", "profissao": prof_canonica, "nivel_receita": nivel,
                "tipo": "item", "nome_resultado": nome, "resultado_item_id": eid,
                "resultado_raridade": raridade_receita, "atributo_teste": atributo,
                "dificuldade_mod": 0, "folego_custo": folego, "xp_recompensa": xp,
                "materiais": mats(materiais), "efeitos": {"efeito": efeito_txt} if efeito_txt else {},
                "resultado_qtd": 1,
            })
    return equip_rows, receita_rows


def build_consumivel_rows():
    receita_rows = []
    for prefixo, _prof_default, itens in CONSUMIVEL_CATEGORIAS:
        for nome, prof_raw, materiais, tier, efeito_txt, produz_qtd in itens:
            rid = f"rec_{prefixo}_{slug(nome)}"
            nivel, folego, xp, raridade = TIER_CONSUMIVEL[tier]
            prof_canonica, atributo = PROFISSAO_MAP[prof_raw]
            receita_rows.append({
                "id": rid, "profissao": prof_canonica, "nivel_receita": nivel,
                "tipo": "item", "nome_resultado": nome, "resultado_item_id": None,
                "resultado_raridade": raridade, "atributo_teste": atributo,
                "dificuldade_mod": 0, "folego_custo": folego, "xp_recompensa": xp,
                "materiais": mats(materiais), "efeitos": {"efeito": efeito_txt},
                "resultado_qtd": produz_qtd,
            })
    return receita_rows


def main():
    commit = "--commit" in sys.argv
    equip_rows, gear_receita_rows = build_gear_rows()
    consumivel_receita_rows = build_consumivel_rows()
    all_receitas = gear_receita_rows + consumivel_receita_rows

    print(f"equipamentos novos: {len(equip_rows)}")
    print(f"receitas novas (gear): {len(gear_receita_rows)}")
    print(f"receitas novas (consumivel): {len(consumivel_receita_rows)}")
    print(f"total receitas: {len(all_receitas)}")

    # sanity: ids unicos
    eids = [e["id"] for e in equip_rows]
    assert len(eids) == len(set(eids)), "id de equipamentos duplicado"
    rids = [r["id"] for r in all_receitas]
    assert len(rids) == len(set(rids)), "id de receitas duplicado"

    conn = conectar()
    cur = conn.cursor()

    # 0) coluna nova: resultado_qtd (idempotente)
    cur.execute("alter table receitas add column if not exists resultado_qtd integer not null default 1")

    # 0b) 'Épico' como raridade de equipamentos (coluna e' texto livre, sem check -- so documentando o uso)

    for e in equip_rows:
        cur.execute(
            """insert into equipamentos (id, nome, slot, raridade, resumo, efeito, visivel, excluido)
               values (%s,%s,%s,%s,%s,%s,true,false)
               on conflict (id) do update set nome=excluded.nome, slot=excluded.slot,
                 raridade=excluded.raridade, resumo=excluded.resumo, efeito=excluded.efeito""",
            (e["id"], e["nome"], e["slot"], e["raridade"], e["resumo"], e["efeito"]),
        )

    for r in all_receitas:
        cur.execute(
            """insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado,
                 resultado_item_id, resultado_raridade, atributo_teste, dificuldade_mod,
                 folego_custo, xp_recompensa, materiais, efeitos, resultado_qtd, visivel, excluido)
               values (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,true,false)
               on conflict (id) do update set nivel_receita=excluded.nivel_receita,
                 nome_resultado=excluded.nome_resultado, resultado_item_id=excluded.resultado_item_id,
                 resultado_raridade=excluded.resultado_raridade, atributo_teste=excluded.atributo_teste,
                 folego_custo=excluded.folego_custo, xp_recompensa=excluded.xp_recompensa,
                 materiais=excluded.materiais, efeitos=excluded.efeitos, resultado_qtd=excluded.resultado_qtd""",
            (r["id"], r["profissao"], r["nivel_receita"], r["tipo"], r["nome_resultado"],
             r["resultado_item_id"], r["resultado_raridade"], r["atributo_teste"], r["dificuldade_mod"],
             r["folego_custo"], r["xp_recompensa"], json.dumps(r["materiais"], ensure_ascii=False),
             json.dumps(r["efeitos"], ensure_ascii=False), r["resultado_qtd"]),
        )

    cur.execute("select count(*) from equipamentos")
    print("equipamentos total agora:", cur.fetchone())
    cur.execute("select count(*) from receitas")
    print("receitas total agora:", cur.fetchone())

    if commit:
        conn.commit()
        print("COMMITADO.")
    else:
        conn.rollback()
        print("DRY-RUN (rollback) -- roda com --commit pra aplicar de verdade.")


if __name__ == "__main__":
    main()
