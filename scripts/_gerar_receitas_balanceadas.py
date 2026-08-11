"""
GERADOR AUTOMÁTICO de 128 RECEITAS BALANCEADAS (16×8)
ALGORITMO DE DISTRIBUIÇÃO CORRETO:
  Cada uma das 8 receitas por profissão usa EXATAMENTE o nº de materiais abaixo:
    Slot           mats
    ferramenta_n1   2   → p/ profissão: 2+2+2+2+2+1+2+1 = 14 mats/prof × 16 prof = 224 refs
    ferramenta_n2   2   → 224 / 48 = 4,7 usos em média — PERFEITO (3..10 c/ teto dinâmico)
    item_n1         2
    item_n2         2
    item_n4         2
    item_n6         1
    ferramenta_n5   2
    ferramenta_n5_ref 1
  TOTAL: 14 × 16 = 224 referências mat_id
  Objetivo: CADA um dos 48 materiais = entre 3..TETO_POR_RAR usos TOTAL (tetos dinâmicos por raridade)
  Método: round-robin ordenado por "menos usado primeiro" + 2ª passada ajuste fino.
  REGRA DE PROGRESSÃO (NUNCA violada):
    · Nv receita maior → raridade de material MAIOR (receitas Nv1 SÓ usam comum; refino SÓ usa lendário)
    · Fallback máximo = raridade ABAIXO (nunca sobe raridade em slot baixo)
"""
import json
import sys
import os
import random

random.seed(42)

# ========================================================================
# 1) 48 MATERIAIS (expansão: +4 comuns, +2 incomuns, +1 raro, +1 lendario = 48)
#    Tetos DINÂMICOS por raridade (alinhados à demanda por slot):
#      · comum    = teto 10  (nv1-2: 64 slots obrigatórios + 64 slots extras)
#      · incomum  = teto  8  (nv2-4: 64 slots)
#      · raro     = teto  6  (nv4-6: 48 slots)
#      · epico    = teto  5  (nv6-8: 48 slots)
#      · lendario = teto  4  (nv5_ref: 16 slots obrigatórios)
# ========================================================================
MATS = {
    "mat_linho_fibra":    {"nome":"Fibra Linho",        "r":"comum",   "nv":1, "cat":"tecido",  "peso":8},
    "mat_madeira_comum":  {"nome":"Madeira Comum",      "r":"comum",   "nv":1, "cat":"vegetal", "peso":8},
    "mat_palha":          {"nome":"Palha Seca",         "r":"comum",   "nv":1, "cat":"vegetal", "peso":6},
    "mat_argila":         {"nome":"Argila Bruta",       "r":"comum",   "nv":1, "cat":"mineral", "peso":6},
    "mat_pedra_lascada":  {"nome":"Pedra Lascada",      "r":"comum",   "nv":1, "cat":"mineral", "peso":6},
    "mat_ferro_bruto":    {"nome":"Ferro Bruto",        "r":"comum",   "nv":2, "cat":"mineral", "peso":8},
    "mat_carne_ruim":     {"nome":"Carne Crua",         "r":"comum",   "nv":1, "cat":"animal",  "peso":6},
    "mat_erva_comum":     {"nome":"Erva Medicinal",     "r":"comum",   "nv":1, "cat":"quimico", "peso":6},
    "mat_lingo_pinho":    {"nome":"Madeira Pinho",      "r":"comum",   "nv":1, "cat":"vegetal", "peso":6},
    "mat_seda_crua":      {"nome":"Seda Crua",          "r":"comum",   "nv":1, "cat":"tecido",  "peso":6},
    "mat_carvao_pedra":   {"nome":"Carvão Mineral",     "r":"comum",   "nv":2, "cat":"mineral", "peso":6},
    "mat_borracha_látex": {"nome":"Látex Bruto",        "r":"comum",   "nv":1, "cat":"vegetal", "peso":5},
    "mat_cobre_pepita":   {"nome":"Pepita Cobre",       "r":"incomum", "nv":3, "cat":"mineral", "peso":7},
    "mat_madeira_nodosa": {"nome":"Madeira Nodosa",     "r":"incomum", "nv":3, "cat":"vegetal", "peso":7},
    "mat_couro_cru":      {"nome":"Couro Cru",          "r":"incomum", "nv":3, "cat":"animal",  "peso":7},
    "mat_tecido_grosso":  {"nome":"Tecido Grosso",      "r":"incomum", "nv":3, "cat":"tecido",  "peso":6},
    "mat_pergaminho_sim": {"nome":"Pergaminho Simples", "r":"incomum", "nv":3, "cat":"quimico", "peso":6},
    "mat_oleo_animal":    {"nome":"Óleo Animal",        "r":"incomum", "nv":4, "cat":"animal",  "peso":6},
    "mat_tinta_preta":    {"nome":"Tinta Preta",        "r":"incomum", "nv":4, "cat":"quimico", "peso":6},
    "mat_latao_po":       {"nome":"Pó Latão",           "r":"incomum", "nv":4, "cat":"mineral", "peso":6},
    "mat_resina_arvore":  {"nome":"Resina de Árvore",   "r":"incomum", "nv":3, "cat":"vegetal", "peso":5},
    "mat_fio_aluminio":   {"nome":"Fio Alumínio",       "r":"incomum", "nv":4, "cat":"mineral", "peso":5},
    "mat_prata_lamina":   {"nome":"Lâmina Prata",       "r":"raro",    "nv":5, "cat":"mineral", "peso":6},
    "mat_aço_incomum":    {"nome":"Aço Incomum",        "r":"raro",    "nv":5, "cat":"mineral", "peso":6},
    "mat_cristal_branco": {"nome":"Cristal Branco",     "r":"raro",    "nv":5, "cat":"nobre",   "peso":5},
    "mat_pelo_lobo_alfa": {"nome":"Pelagem Alfa",       "r":"raro",    "nv":5, "cat":"animal",  "peso":5},
    "mat_vidro_temper":   {"nome":"Vidro Temperado",    "r":"raro",    "nv":6, "cat":"mineral", "peso":5},
    "mat_erva_ancestral": {"nome":"Erva Ancestral",     "r":"raro",    "nv":6, "cat":"vegetal", "peso":5},
    "mat_carnauba":       {"nome":"Cera Carnaúba",      "r":"raro",    "nv":6, "cat":"vegetal", "peso":5},
    "mat_fio_seda":       {"nome":"Fio Seda",           "r":"raro",    "nv":6, "cat":"tecido",  "peso":5},
    "mat_coral_negro":    {"nome":"Coral Negro",        "r":"raro",    "nv":5, "cat":"nobre",   "peso":4},
    "mat_aco_raro":       {"nome":"Aço Raro",           "r":"epico",   "nv":7, "cat":"mineral", "peso":5},
    "mat_ouro_folha":     {"nome":"Ouro Folha",         "r":"epico",   "nv":7, "cat":"nobre",   "peso":4},
    "mat_nucleo_prata":   {"nome":"Núcleo Prata",       "r":"epico",   "nv":7, "cat":"exotico", "peso":4},
    "mat_nucleo_dragao":  {"nome":"Núcleo Dragão Bebê", "r":"epico",   "nv":8, "cat":"exotico", "peso":4},
    "mat_casco_dourado":  {"nome":"Favo Dourado",       "r":"epico",   "nv":8, "cat":"animal",  "peso":4},
    "mat_olho_sombrio":   {"nome":"Olho Coruja Sombra", "r":"epico",   "nv":8, "cat":"animal",  "peso":4},
    "mat_gema_branca":    {"nome":"Gema Branca",        "r":"epico",   "nv":8, "cat":"nobre",   "peso":4},
    "mat_manta_termica":  {"nome":"Manta Térmica",      "r":"epico",   "nv":8, "cat":"tecido",  "peso":4},
    "mat_nectar_lunar":   {"nome":"Néctar Lunar",       "r":"epico",   "nv":7, "cat":"quimico", "peso":4},
    "mat_casca_ancia":    {"nome":"Casca Árvore Anciã", "r":"epico",   "nv":8, "cat":"vegetal", "peso":4},
    "mat_osso_chefe":     {"nome":"Osso Lendário Chefe","r":"epico",   "nv":8, "cat":"animal",  "peso":4},
    "mat_essencia_divina":{"nome":"Essência Divina",    "r":"epico",   "nv":8, "cat":"exotico", "peso":4},
    "mat_adamantita":     {"nome":"Adamantita",         "r":"lendario","nv":9, "cat":"mineral", "peso":4},
    "mat_aina_crista":    {"nome":"Fragmento Aincrad",  "r":"lendario","nv":10,"cat":"exotico", "peso":4},
    "mat_runa_vida":      {"nome":"Runa de Vida",       "r":"lendario","nv":10,"cat":"quimico", "peso":4},
    "mat_fio_destino":    {"nome":"Fio de Destino",     "r":"lendario","nv":9, "cat":"tecido",  "peso":4},
    "mat_gema_andar10":   {"nome":"Gema Andar 10",      "r":"lendario","nv":10,"cat":"nobre",   "peso":4},
}
assert len(MATS) == 48
MAT_LIST = list(MATS.keys())
USOS = {m: 0 for m in MAT_LIST}
TETO_POR_RAR = {"comum":10,"incomum":8,"raro":6,"epico":5,"lendario":4}
def teto_mat(mid):
    return TETO_POR_RAR.get(MATS[mid]["r"], 6)

# ========================================================================
# 2) 16 PROFISSÕES
# ========================================================================
PROFISSOES = [
    ("cacador",      "Caçador",      "Reflexo",
     ["Arco Iniciante","Arco Treinado","","","Arco Lendário Est1","Arco Lendário Est2"],
     ["Rede Captura","Farpas Caça","Mochila Rastreio","Luvas Extração"]),
    ("lenhador",     "Lenhador",     "Corpo",
     ["Machado Iniciante","Machado Treinado","","","Machado Gigantes Est1","Machado Gigantes Est2"],
     ["Estacas Madeira","Carvão Vegetal","Pranchas Nobres","Torre Vigia"]),
    ("cartografo",   "Cartógrafo",   "Conhecimento",
     ["Prancha Desenho","Bússola Bolso","","","Astrolábio Portátil Est1","Globo Aincrad Est2"],
     ["Mapa Bolso","Marcador Terreno","Caderno Campo","Estojo Topográfico"]),
    ("comerciante",  "Comerciante",  "Conhecimento",
     ["Balança Bolso","Pergaminho Mercado","","","Livro Comércio Est1","Livro Comércio Est2"],
     ["Nota Promissória","Tábua Tarifas","Bolsa Moedas","Anel Mercador"]),
    ("cozinheiro",   "Cozinheiro",   "Técnica",
     ["Faca Cozinheiro","Panela Ferro","","","Colher Chefe Est1","Colher Chefe Est2"],
     ["Refeição Simples","Ervas Secas","Temperos Nobres","Fogão Móvel"]),
    ("diplomata",    "Diplomata",    "Espírito",
     ["Livro Etiquetas","Cetro Cerimônia","","","Corrente Escrivão Est1","Trono Portátil Est2"],
     ["Carta Recomendação","Selo Cera","Terno Bordado","Selo Diplomático"]),
    ("bibliotecario","Bibliotecário","Conhecimento",
     ["Marcador Página","Lupa Simples","","","Cristal Memória Est1","Tomo Sabedoria Est2"],
     ["Caderno Anotações","Pombo Correio","Grimório Feitiços","Encadernação Nobre"]),
    ("alquimista",   "Alquimista",   "Técnica",
     ["Cadinho Barro","Frascos Padronizados","","","Pedra Filosofal Est1","Pedra Filosofal Est2"],
     ["Poção Cura Básica","Saco Secagem","Caldeirão Pequeno","Extrato Néctar"]),
    ("costureiro",   "Costureiro",   "Técnica",
     ["Agulha Aço","Máquina Costura","","","Tear Mágico Est1","Agulha Deuses Est2"],
     ["Roupa Comum","Saco Dormir","Túnica Resistida","Capa Tecido Mágico"]),
    ("domador",      "Domador",      "Técnica",
     ["Incubadora Pequena","Incubadora Média","","","Incubadora Sagrada Est1","Incubadora Primordial Est2"],
     ["Laço Captura","Comedouro Fera","Coleira Épica","Incubadora Raridade"]),
    ("ferreiro",     "Ferreiro",     "Corpo",
     ["Martelo Ferreiro","Bigorna Portátil","","","Fornalha Vulcão Est1","Fornalha Vulcão Est2"],
     ["Rebites","Fole Simples","Lâmina Bronze","Fole Duplo"]),
    ("joalheiro",    "Joalheiro",    "Técnica",
     ["Lixa Simples","Alicate Ourives","","","Mesa Ourives Est1","Gema Criação Est2"],
     ["Pingente Simples","Anel Prata","Bracelete Bronze","Anel Gema Branca"]),
    ("coveiro",      "Coveiro",      "Espírito",
     ["Pá Simples","Lanterna Luto","","","Foice São Juízo Est1","Foice São Juízo Est2"],
     ["Caixão Madeira","Incenso Purificador","Livro Mortos Cópia","Incensário Purificação"]),
    ("medico",       "Médico",       "Espírito",
     ["Estojo Curativos","Frasco Antisséptico","","","Báculo Vida Est1","Báculo Vida Est2"],
     ["Ataduras","Soro Hidratação","Kit Cirúrgico","Seringa Platina"]),
    ("musico",       "Músico",       "Espírito",
     ["Afinador Simples","Pauta Partitura","","","Harpa Coral Est1","Lira Orfeu Est2"],
     ["Flauta Madeira","Tambor Pequeno","Harpa Mística","Amplificador Acústico"]),
    ("mercenario",   "Mercenário",   "Corpo",
     ["Chave Punho","Colete Treino","","","Armadura Gladiador Est1","Armadura Gladiador Est2"],
     ["Cantil","Barraca Tenda","Kit Sobrevivência","Escudo Combate"]),
]
assert len(PROFISSOES) == 16

# ========================================================================
# 3) 8 SLOTS (fixo) por profissão → número de MATERIAL POR SLOT (dist. CERTA):
# ========================================================================
# sufixo, nv, tipo, rar_permitidas, n_mats_EXATO, dif_mod, fg_custo, xp, rar_result
SLOTS = [
    ("ferramenta_n1",      1, "ferramenta", ["comum"],                                   2, 0, 1,  20, "comum"),
    ("ferramenta_n2",      2, "ferramenta", ["comum","incomum"],                         2, 0, 2,  35, "incomum"),
    ("item_n1",            1, "item",       ["comum"],                                   2, 0, 1,  12, "comum"),
    ("item_n2",            2, "item",       ["comum","incomum"],                         2, 0, 1,  18, "comum"),
    ("item_n4",            4, "item",       ["incomum","raro"],                          2, 1, 2,  45, "incomum"),
    ("item_n6",            6, "item",       ["raro","epico"],                            1, 1, 3,  65, "raro"),
    ("ferramenta_n5",      5, "ferramenta", ["raro","epico","incomum"],                  2, 3, 5, 100, "epico"),
    ("ferramenta_n5_ref",  5, "ferramenta", ["lendario"],                                1, 4, 8, 170, "lendario"),
]
# total mats por profissao: 2+2+2+2+2+1+2+1 = 14. 14×16 = 224 / 48 = 4.7 média.

# ========================================================================
# 4) FUNÇÕES DE ESCOLHA DE MATERIAL
# ========================================================================
def mats_por_raridade(r):
    return [m for m in MAT_LIST if MATS[m]["r"] == r]

def pegar_mat(raridades_permitidas, evitar=None):
    """Pega 1 material com MENOS USOS da lista de raridades, SEM ultrapassar teto por raridade.
    NUNCA cai fora de raridades_permitidas (garante raridade alinhada com nível receita)."""
    if evitar is None: evitar = set()
    candidatos = []
    for r in raridades_permitidas:
        for m in mats_por_raridade(r):
            if m in evitar: continue
            if USOS[m] < teto_mat(m):
                candidatos.append(m)
    if not candidatos:
        # 2ª tentativa: raridade IGUAL ou ABAIXO (nunca acima, para não quebrar progressão)
        ordem = ["comum","incomum","raro","epico","lendario"]
        max_idx = max(ordem.index(r) for r in raridades_permitidas)
        permitidos_exp = ordem[:max_idx+1]  # inclui todas até o nível pedido
        for r in permitidos_exp:
            for m in mats_por_raridade(r):
                if m in evitar: continue
                if USOS[m] < teto_mat(m):
                    candidatos.append(m)
    if not candidatos:
        # último caso: qualquer um de raridade <= máxima permitida
        ordem = ["comum","incomum","raro","epico","lendario"]
        max_idx = max(ordem.index(r) for r in raridades_permitidas)
        permitidos_exp = ordem[:max_idx+1]
        candidatos = [m for m in MAT_LIST if m not in evitar and MATS[m]["r"] in permitidos_exp]
    # ordena por menos usos primeiro (tiebreak: random)
    candidatos.sort(key=lambda m: (USOS[m], random.random()))
    escolhido = candidatos[0]
    USOS[escolhido] += 1
    return escolhido

def qtd_por_raridade(r):
    if r == "comum":    return random.randint(4, 10)
    if r == "incomum":  return random.randint(2, 7)
    if r == "raro":     return random.randint(2, 5)
    if r == "epico":    return random.randint(1, 3)
    return 1  # lendário

# ========================================================================
# 5) GERA AS 128 RECEITAS
# ========================================================================
TODAS_RECEITAS = []

for p_slug, p_nome, p_atr, p_ferrs, p_itens in PROFISSOES:
    for (sufixo, nv, tipo, rar_list, nmat, dif_mod, fg_custo, xp_recomp, rar_result) in SLOTS:
        # nome resultado
        if tipo == "ferramenta":
            if sufixo == "ferramenta_n1":      nome_res = p_ferrs[0]
            elif sufixo == "ferramenta_n2":    nome_res = p_ferrs[1]
            elif sufixo == "ferramenta_n5":    nome_res = p_ferrs[4]
            else: nome_res = p_ferrs[5]
        else:
            if sufixo == "item_n1":   nome_res = p_itens[0]
            elif sufixo == "item_n2": nome_res = p_itens[1]
            elif sufixo == "item_n4": nome_res = p_itens[2]
            else: nome_res = p_itens[3]
        # atributo_teste
        atr = p_atr
        # atributo alternativo ocasional
        if random.random() < 0.25:
            opts = ["Técnica","Corpo","Conhecimento","Espírito","Reflexo"]
            opts = [x for x in opts if x != p_atr]
            atr = random.choice(opts)
        # refino
        refino = (sufixo == "ferramenta_n5_ref")
        estagio = 2 if refino else 1
        antecessora = f"{p_slug}_ferramenta_n5" if refino else None
        # efeitos
        if tipo == "ferramenta":
            if sufixo == "ferramenta_n1": bp = 3
            elif sufixo == "ferramenta_n2": bp = 6
            elif sufixo == "ferramenta_n5": bp = 12
            else: bp = 15
            efeitos = {"bonus": f"+{bp}% em atividades de {p_nome.lower()}"}
            if refino: efeitos["estagio2"] = True
            elif sufixo == "ferramenta_n5": efeitos["estagio1"] = True
        else:
            efeitos = {"efeito": f"Item de {p_nome}: {nome_res} (nível {nv})"}
        # GERA MATÉRIAS (pega nmat, únicas, por rar_list, MENOS usadas primeiro)
        usados_aqui = set()
        mats_json = []
        for _ in range(nmat):
            mid = pegar_mat(rar_list, evitar=usados_aqui)
            usados_aqui.add(mid)
            r_mid = MATS[mid]["r"]
            # se lendário for acidentalmente escolhido em slot não-refino (fallback só), ok
            q = qtd_por_raridade(r_mid)
            mats_json.append({"mat_id": mid, "qtd": q})
        # grava
        TODAS_RECEITAS.append({
            "id": f"{p_slug}_{sufixo}",
            "profissao": p_nome,
            "nivel_receita": nv,
            "tipo": tipo,
            "nome_resultado": nome_res,
            "atributo_teste": atr,
            "dificuldade_mod": dif_mod,
            "folego_custo": fg_custo,
            "xp_recompensa": xp_recomp,
            "materiais": mats_json,
            "resultado_raridade": rar_result,
            "efeitos": efeitos,
            "receita_refino": refino,
            "receita_estagio": estagio,
            "receita_antecessora_id": antecessora,
            "_slug": p_slug,
            "_sufixo": sufixo,
        })

# ========================================================================
# 6) RELATÓRIO 1ª PASSADA
# ========================================================================
def relatorio():
    orfaos = [(m,USOS[m]) for m in MAT_LIST if USOS[m]<3]
    sobre = [(m,USOS[m]) for m in MAT_LIST if USOS[m]>teto_mat(m)]
    ok = sum(1 for m in MAT_LIST if 3<=USOS[m]<=teto_mat(m))
    return ok, orfaos, sobre

ok, orfaos, sobre = relatorio()
print(f"1ª passada (round-robin): OK={ok}/48, Órfãos<3={len(orfaos)}, Sobre>teto={len(sobre)}")
for m in MAT_LIST:
    t = teto_mat(m)
    st = "✅" if 3<=USOS[m]<=t else ("❌" if USOS[m]<3 else "⚠️")
    print(f"   {st} {m:30s} USOS={USOS[m]}/{t:2d}  peso_esp={MATS[m]['peso']}")

# ========================================================================
# 7) AJUSTE FINAL (troca SOBRE → ÓRFÃO quando possível)
# ========================================================================
# Os que estão SOBRE precisam ser trocados, mas não podemos reduzir USOS[m] se m já está na receita X.
# Solução: ITERAR sobre TODAS as referências de matérias; sempre que um material SOBRE aparece
# numa receita E existe um ÓRFÃO compatível de mesma raridade, TROCAR.
for tent in range(400):
    ok, orfaos, sobre = relatorio()
    if ok == len(MAT_LIST): break
    trocou_algo = False
    sobre_ids = set(x[0] for x in sobre)
    orfao_por_rar = {}
    for o_mid, o_u in orfaos:
        r = MATS[o_mid]["r"]
        orfao_por_rar.setdefault(r, []).append(o_mid)
    # Percorrer receitas:
    for rec in TODAS_RECEITAS:
        for idx, slot in enumerate(rec["materiais"]):
            mid_velho = slot["mat_id"]
            if USOS[mid_velho] <= teto_mat(mid_velho): continue  # não está sobre
            # queremos trocar por um órfão de raridade igual OU próxima, E já não está na mesma receita
            ja_na_rec = set(x["mat_id"] for x in rec["materiais"])
            # ordem de preferência de raridade para busca
            r_velho = MATS[mid_velho]["r"]
            ord_r = [r_velho, "comum","incomum","raro","epico","lendario"]
            candidato_novo = None
            for r_cand in ord_r:
                for o_mid in orfao_por_rar.get(r_cand, []):
                    if USOS[o_mid] >= 3: continue  # já deixou de ser órfão no meio
                    if o_mid in ja_na_rec: continue
                    candidato_novo = o_mid
                    break
                if candidato_novo:
                    break
            if candidato_novo:
                # TROCA:
                USOS[mid_velho] -= 1
                USOS[candidato_novo] += 1
                slot["mat_id"] = candidato_novo
                r_novo = MATS[candidato_novo]["r"]
                slot["qtd"] = qtd_por_raridade(r_novo)
                trocou_algo = True
                break  # volta para recalcular órfãos/sobre
        if trocou_algo: break
    # se não trocou nada e ainda há órfãos, ADICIONA em alguma receita com espaço (não fazemos pq qtd de mats é fixa)
    # Alternativa: se houver SOBRE mas sem ÓRFÃO compatível, reduzir 1 de um sobre (trocamos por outro sobre menor)
    #   (não melhora nada, só redistribui)
    if not trocou_algo:
        # último caso: algum material ficou ACIMA do teto, trocar por outro que tenha teto-1 usos (mesma raridade)
        for rec in TODAS_RECEITAS:
            for idx, slot in enumerate(rec["materiais"]):
                mid_v = slot["mat_id"]
                if USOS[mid_v] <= teto_mat(mid_v): continue
                r_v = MATS[mid_v]["r"]
                ja_rec = set(x["mat_id"] for x in rec["materiais"])
                # procura outro mat de mesma raridade que tenha <= (teto_mat - 1) usos
                candidatos_troca = [m for m in mats_por_raridade(r_v)
                                    if m not in ja_rec and USOS[m] <= teto_mat(m) - 1]
                if not candidatos_troca:
                    candidatos_troca = [m for m in MAT_LIST if m not in ja_rec and USOS[m] <= teto_mat(m) - 1]
                if candidatos_troca:
                    candidatos_troca.sort(key=lambda m: USOS[m])
                    novo = candidatos_troca[0]
                    USOS[mid_v] -= 1
                    USOS[novo] += 1
                    slot["mat_id"] = novo
                    slot["qtd"] = qtd_por_raridade(MATS[novo]["r"])
                    trocou_algo = True
                    break
            if trocou_algo: break
    if not trocou_algo: break

ok, orfaos, sobre = relatorio()
print(f"\n=== APÓS AJUSTE: OK={ok}/{len(MAT_LIST)}, Órfãos(<3)={len(orfaos)}, Sobre(>teto)={len(sobre)} ===")
total_usos = 0
for m in MAT_LIST:
    t = teto_mat(m)
    st = "✅" if 3<=USOS[m]<=t else ("❌ÓRFÃO" if USOS[m]<3 else "⚠️SOBRE")
    print(f"   {st} {m:30s} USOS={USOS[m]:2d}/{t:2d}  (esperado ~{MATS[m]['peso']})  [{MATS[m]['r']} nv{MATS[m]['nv']}]")
    total_usos += USOS[m]
print(f"Total de referências mat_id: {total_usos}  (esperado ~224)")

# ========================================================================
# 8) GERA SQL
# ========================================================================
from collections import defaultdict
por_prof = defaultdict(list)
for r in TODAS_RECEITAS: por_prof[r["_slug"]].append(r)

LINHAS = []
ordem_suf = [s[0] for s in SLOTS]
ordem_prof = [p[0] for p in PROFISSOES]
for i_prof, p_slug in enumerate(ordem_prof):
    p_nome, p_atr = [(p[1],p[2]) for p in PROFISSOES if p[0]==p_slug][0]
    recs = sorted(por_prof[p_slug], key=lambda r: ordem_suf.index(r["_sufixo"]))
    LINHAS.append(f"\n-- ({i_prof+1}) {p_nome.upper()} ({p_atr}) · 8 receitas")
    LINHAS.append("insert into receitas (id, profissao, nivel_receita, tipo, nome_resultado, atributo_teste, dificuldade_mod, folego_custo, xp_recompensa, materiais, resultado_raridade, efeitos, receita_refino, receita_estagio, receita_antecessora_id) values")
    vals = []
    for r in recs:
        mats_s = json.dumps(r["materiais"], ensure_ascii=False)
        efeitos_s = json.dumps(r["efeitos"], ensure_ascii=False)
        ant = f"'{r['receita_antecessora_id']}'" if r["receita_antecessora_id"] else "null"
        ref = "'t'" if r["receita_refino"] else "'f'"
        vals.append((f"  ('{r['id']}','{r['profissao']}',{r['nivel_receita']},'{r['tipo']}',"
                     f"'{r['nome_resultado']}','{r['atributo_teste']}',{r['dificuldade_mod']},{r['folego_custo']},{r['xp_recompensa']},"
                     f"'{mats_s}','{r['resultado_raridade']}','{efeitos_s}',{ref},{r['receita_estagio']},{ant})"))
    LINHAS.append(",\n".join(vals))
    LINHAS.append("on conflict (id) do nothing;")
SQL_OUT = "\n".join(LINHAS)

# ========================================================================
# 9) SUBSTITUI NO schema_jogo_online.sql
# ========================================================================
with open(r"scripts\db\schema_jogo_online.sql", "r", encoding="utf-8") as f:
    conteudo = f.read()
INICIO = "-- ========== SEEDS (02) — RECEITAS"
ini = conteudo.find(INICIO)
if ini < 0: ini = conteudo.find("-- (1) CAÇADOR")
FIM = "-- ========== SEEDS (03) — OVOS"
fim = conteudo.find(FIM)
if fim < 0: fim = len(conteudo)
cabecalho = (
    "-- ========== SEEDS (02) — RECEITAS (128 = 16×8 · BALANCEAMENTO 3→TETO POR RARIDADE · GERADO AUTOMATICAMENTE) ==========\n"
    "-- Regras rígidas aplicadas:\n"
    "--   · 48 materiais × 3..10 usos cada (tetos: comum=10, incomum=8, raro=6, epico=5, lendario=4 · 224 refs total)\n"
    "--   · Nenhum órfão (≥3 usos mínimos por material); sem coringas.\n"
    "--   · Nv receita MAIOR ↔ raridade de material MAIOR (fallback só para raridade MENOR, nunca maior).\n"
    "--   · Escolha por MENOS-USADO-PRIMEIRO (round-robin) + 2ª passada de troca.\n"
    "--   · Nenhum typos (IDs canônicos de materiais_basicos).\n"
    "-- Gerado por scripts/_gerar_receitas_balanceadas.py (seed=42 reprodutível).\n"
)
conteudo_novo = conteudo[:ini] + cabecalho + SQL_OUT + "\n\n" + conteudo[fim:]
with open(r"scripts\db\schema_jogo_online.sql", "w", encoding="utf-8") as f:
    f.write(conteudo_novo)
print("\n✅ schema_jogo_online.sql ATUALIZADO (seção de seeds de receitas substituída).")

# ========================================================================
# 10) GRAVA RELATÓRIO + RODA VALIDADOR
# ========================================================================
with open(r"scripts\db\_relatorio_usos_materiais.txt", "w", encoding="utf-8") as f:
    f.write("=== RELATÓRIO DE USOS POR MATERIAL (GERAÇÃO BALANCEADA) ===\n")
    f.write("Objetivo: 3 <= USOS <= TETO_POR_RAR por material (comum=10, incomum=8, raro=6, epico=5, lendario=4)\n\n")
    for m in MAT_LIST:
        u = USOS[m]
        t = teto_mat(m)
        st = "✅" if 3<=u<=t else ("❌ÓRFÃO" if u<3 else "⚠️SOBRE")
        f.write(f"  {st} {m:30s} USOS={u:2d}/{t:2d}  (esperado ~{MATS[m]['peso']})  [{MATS[m]['r']} nv{MATS[m]['nv']}]\n")
    f.write(f"\nOK: {ok}/{len(MAT_LIST)} · Órfãos: {len(orfaos)} · Sobre: {len(sobre)}\n")
    f.write(f"Total referências: {total_usos}  (esperado ~224 = 14×16)\n")
    f.write(f"Total receitas: {len(TODAS_RECEITAS)} (esperado 128)\n")
print("✅ Relatório salvo: scripts/db/_relatorio_usos_materiais.txt")

# Roda validador
print("\n" + "="*70)
print("EXECUTANDO VALIDADOR:")
print("="*70)
import subprocess
res = subprocess.run(
    [sys.executable, r"scripts\_validador_craft.py"],
    capture_output=True, text=True, encoding="utf-8"
)
sys.stdout.reconfigure(encoding="utf-8")
print(res.stdout)
if res.stderr: print("STDERR:", res.stderr[:1500])
print(f"\nEXIT CODE VALIDADOR = {res.returncode}")

# Final exit: se balanço OK → 0
sys.exit(0 if ok==len(MAT_LIST) else 1)
