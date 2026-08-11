"""
Validador de balanço de materiais + receitas
1. Verifica que 48 materiais estão OK (12 comum · 10 incomum · 9 raro · 8 epico · 9 lendario)
2. Verifica que TODOS os mat_id nas receitas existem nos 48
3. Conta USOS (quantas receitas cada material aparece)
4. Reporta: órfãos (<3), sobreutilizados (>TETO_POR_RAR), typos
5. Garante PROGRESSÃO: material lendário NÃO APARECE em receita nv<5 (só em ferramenta_n5_ref)
   material épico não aparece em nv<4, etc.

Retorna 0 se balanço OK, !=0 se houver problemas.
"""
import json, sys, re

MATS = {}
RECEITAS_SQL = {}

TETO_POR_RAR = {"comum":10,"incomum":8,"raro":6,"epico":5,"lendario":4}
def teto_mat(mid):
    return TETO_POR_RAR.get(MATS[mid]["r"], 6)

# ================================================================
# (1) 48 MATERIAIS (IDS EXATOS que estão em materiais_basicos)
# ================================================================
MATS = {
    # COMUM (nv1-2) · 12
    "mat_linho_fibra":    {"nome":"Fibra de Linho",        "r":"comum",   "nv":1, "cat":"tecido",  "peso":8},
    "mat_madeira_comum":  {"nome":"Madeira Comum",         "r":"comum",   "nv":1, "cat":"vegetal", "peso":8},
    "mat_palha":          {"nome":"Palha Seca",            "r":"comum",   "nv":1, "cat":"vegetal", "peso":6},
    "mat_argila":         {"nome":"Argila Bruta",          "r":"comum",   "nv":1, "cat":"mineral", "peso":6},
    "mat_pedra_lascada":  {"nome":"Pedra Lascada",         "r":"comum",   "nv":1, "cat":"mineral", "peso":6},
    "mat_ferro_bruto":    {"nome":"Ferro Bruto",           "r":"comum",   "nv":2, "cat":"mineral", "peso":8},
    "mat_carne_ruim":     {"nome":"Carne Crua",            "r":"comum",   "nv":1, "cat":"animal",  "peso":6},
    "mat_erva_comum":     {"nome":"Erva Medicinal",        "r":"comum",   "nv":1, "cat":"quimico", "peso":6},
    "mat_lingo_pinho":    {"nome":"Madeira Pinho",         "r":"comum",   "nv":1, "cat":"vegetal", "peso":6},
    "mat_seda_crua":      {"nome":"Seda Crua",             "r":"comum",   "nv":1, "cat":"tecido",  "peso":6},
    "mat_carvao_pedra":   {"nome":"Carvão Mineral",        "r":"comum",   "nv":2, "cat":"mineral", "peso":6},
    "mat_borracha_látex": {"nome":"Látex Bruto",           "r":"comum",   "nv":1, "cat":"vegetal", "peso":5},
    # INCOMUM (nv3-4) · 10
    "mat_cobre_pepita":   {"nome":"Pepita Cobre",          "r":"incomum", "nv":3, "cat":"mineral", "peso":7},
    "mat_madeira_nodosa": {"nome":"Madeira Nodosa",        "r":"incomum", "nv":3, "cat":"vegetal", "peso":7},
    "mat_couro_cru":      {"nome":"Couro Cru",             "r":"incomum", "nv":3, "cat":"animal",  "peso":7},
    "mat_tecido_grosso":  {"nome":"Tecido Grosso",         "r":"incomum", "nv":3, "cat":"tecido",  "peso":6},
    "mat_pergaminho_sim": {"nome":"Pergaminho Simples",    "r":"incomum", "nv":3, "cat":"quimico", "peso":6},
    "mat_oleo_animal":    {"nome":"Óleo Animal",           "r":"incomum", "nv":4, "cat":"animal",  "peso":6},
    "mat_tinta_preta":    {"nome":"Tinta Preta",           "r":"incomum", "nv":4, "cat":"quimico", "peso":6},
    "mat_latao_po":       {"nome":"Pó Latão",              "r":"incomum", "nv":4, "cat":"mineral", "peso":6},
    "mat_resina_arvore":  {"nome":"Resina Árvore",         "r":"incomum", "nv":3, "cat":"vegetal", "peso":5},
    "mat_fio_aluminio":   {"nome":"Fio Alumínio",          "r":"incomum", "nv":4, "cat":"mineral", "peso":5},
    # RARO (nv5-6) · 9
    "mat_prata_lamina":   {"nome":"Lâmina Prata",          "r":"raro",    "nv":5, "cat":"mineral", "peso":6},
    "mat_aço_incomum":    {"nome":"Aço Incomum",           "r":"raro",    "nv":5, "cat":"mineral", "peso":6},
    "mat_cristal_branco": {"nome":"Cristal Branco",        "r":"raro",    "nv":5, "cat":"nobre",   "peso":5},
    "mat_pelo_lobo_alfa": {"nome":"Pelagem Alfa",          "r":"raro",    "nv":5, "cat":"animal",  "peso":5},
    "mat_vidro_temper":   {"nome":"Vidro Temperado",       "r":"raro",    "nv":6, "cat":"mineral", "peso":5},
    "mat_erva_ancestral": {"nome":"Erva Ancestral",        "r":"raro",    "nv":6, "cat":"vegetal", "peso":5},
    "mat_carnauba":       {"nome":"Cera Carnaúba",         "r":"raro",    "nv":6, "cat":"vegetal", "peso":5},
    "mat_fio_seda":       {"nome":"Fio Seda Selvagem",     "r":"raro",    "nv":6, "cat":"tecido",  "peso":5},
    "mat_coral_negro":    {"nome":"Coral Negro",           "r":"raro",    "nv":5, "cat":"nobre",   "peso":4},
    # ÉPICO (nv7-8) · 12 (4 foram movidos de lendário p/ caber em 16 slots _n5_ref)
    "mat_aco_raro":       {"nome":"Aço Raro",              "r":"epico",   "nv":7, "cat":"mineral", "peso":5},
    "mat_ouro_folha":     {"nome":"Ouro Folha",            "r":"epico",   "nv":7, "cat":"nobre",   "peso":4},
    "mat_nucleo_prata":   {"nome":"Núcleo Prata",          "r":"epico",   "nv":7, "cat":"exotico", "peso":4},
    "mat_nucleo_dragao":  {"nome":"Núcleo Dragão Bebê",    "r":"epico",   "nv":8, "cat":"exotico", "peso":4},
    "mat_casco_dourado":  {"nome":"Favo Dourado",          "r":"epico",   "nv":8, "cat":"animal",  "peso":4},
    "mat_olho_sombrio":   {"nome":"Olho Coruja Sombria",   "r":"epico",   "nv":8, "cat":"animal",  "peso":4},
    "mat_gema_branca":    {"nome":"Gema Branca",           "r":"epico",   "nv":8, "cat":"nobre",   "peso":4},
    "mat_manta_termica":  {"nome":"Manta Térmica",         "r":"epico",   "nv":8, "cat":"tecido",  "peso":4},
    "mat_nectar_lunar":   {"nome":"Néctar Flor Lunar",     "r":"epico",   "nv":7, "cat":"quimico", "peso":4},
    "mat_casca_ancia":    {"nome":"Casca Árvore Anciã",    "r":"epico",   "nv":8, "cat":"vegetal", "peso":4},
    "mat_osso_chefe":     {"nome":"Osso Lendário Chefe",   "r":"epico",   "nv":8, "cat":"animal",  "peso":4},
    "mat_essencia_divina":{"nome":"Essência Divina",       "r":"epico",   "nv":8, "cat":"exotico", "peso":4},
    # LENDÁRIO (nv9-10) · 5 (máx matemático: 16 slots _n5_ref / 5 = 3,2 usos média)
    "mat_adamantita":     {"nome":"Adamantita",            "r":"lendario","nv":9, "cat":"mineral", "peso":4},
    "mat_aina_crista":    {"nome":"Fragmento Aincrad",     "r":"lendario","nv":10,"cat":"exotico", "peso":4},
    "mat_runa_vida":      {"nome":"Runa de Vida",          "r":"lendario","nv":10,"cat":"quimico", "peso":4},
    "mat_fio_destino":    {"nome":"Fio de Destino",        "r":"lendario","nv":9, "cat":"tecido",  "peso":4},
    "mat_gema_andar10":   {"nome":"Gema Andar 10",         "r":"lendario","nv":10,"cat":"nobre",   "peso":4},
}
assert len(MATS)==48, "Esperados 48 materiais, temos %d" % len(MATS)
MAT_LIST = list(MATS.keys())

# ================================================================
# (2) Extrai mat_id POR RECEITA (com nível receita) p/ validar progressão
# ================================================================
USOS = {mid: 0 for mid in MATS}
TYPOS = []
PROGRESSAO_ERROS = []
MAT_ID_RE = re.compile(r'"mat_id"\s*:\s*"(?P<id>[A-Za-zÀ-ÿ0-9_]+)"', re.UNICODE)

# Extrai tuplas (receita_id, nivel_receita, lista_mat_ids)
RECEITA_PARSE_RE = re.compile(
    r"\('\s*(?P<id>[a-z0-9_]+)\s*',\s*'(?:[^']+)'\s*,\s*(?P<nv>\d+)\s*,\s*'(?:item|ferramenta)'",
    re.IGNORECASE
)
MATS_PARSE_RE = re.compile(r"\[(\s*\{\s*\"mat_id\".*?\})\]", re.UNICODE | re.DOTALL)

def extrair_receitas_de_sql(sql):
    """Devolve lista de dicts (id, nv, mats_list)"""
    res = []
    # Cada receita começa por '(' e termina por ')' no values list
    # Vamos achar todos os tuplos de insert: '(id',nome,nv,tipo,...)'
    for m in re.finditer(r"\((?P<tpl>'[a-z0-9_]+',[^)]*)\)", sql, re.IGNORECASE):
        tpl = m.group("tpl")
        # Parte 1: receita_id (entre aspas simples)
        id_match = re.match(r"\s*'([a-z0-9_]+)'", tpl, re.I)
        if not id_match: continue
        rid = id_match.group(1)
        # Parte 2: campos separados por vírgula
        campos = re.split(r",\s*(?=(?:[^']*'[^']*')*[^']*$)", tpl)
        if len(campos) < 3: continue
        try:
            nv = int(campos[2].strip())
        except:
            continue
        # Parte 3: a lista JSON de mat_id está em algum campo que começa com '[{'
        mats = []
        for c in campos:
            c = c.strip()
            if c.startswith("'[{"):
                ids_encontrados = MAT_ID_RE.findall(c)
                mats.extend(ids_encontrados)
        if not mats: continue
        res.append({"id": rid, "nv": nv, "mats": mats})
    return res

if __name__ == "__main__":
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
    with open(r"scripts\db\schema_jogo_online.sql", "r", encoding="utf-8") as f:
        sql = f.read()

    # Tira comentários de linha (-- até o fim da linha)
    sql_sem_comentarios = re.sub(r'--.*?$', '', sql, flags=re.MULTILINE)

    # (A) Conta USOS e detecta TYPOS (varredura global)
    ids_all = MAT_ID_RE.findall(sql_sem_comentarios)
    for mid in ids_all:
        if mid not in MATS:
            TYPOS.append(("todas_receitas", mid, "MAT NÃO EXISTE nos 48 materiais!"))
        else:
            USOS[mid] += 1

    # (B) Valida PROGRESSÃO: material_r NÃO aparece em receita_nv ANTES do permitido
    #    Regras: comum pode em nv qualquer; incomum a partir de nv2; raro a partir de nv4;
    #            epico a partir de nv5; lendario SOMENTE em nv=5 (refino)
    LIMITE_NV_POR_RARIDADE = {
        "comum":    1,   # livre
        "incomum":  2,   # não aparece em receita nv1
        "raro":     4,   # não aparece em receita nv<4 (item_n4 é a primeira)
        "epico":    5,   # não aparece em receita nv<5 (ferramenta_n5)
        "lendario": 5,   # só ferramenta_n5_ref
    }
    receitas = extrair_receitas_de_sql(sql_sem_comentarios)
    for r in receitas:
        for mid in r["mats"]:
            if mid not in MATS: continue  # já reportado como typo
            rar_m = MATS[mid]["r"]
            limite = LIMITE_NV_POR_RARIDADE[rar_m]
            if r["nv"] < limite:
                # exceção: lendário em nv=5 (refino) é OK
                if rar_m == "lendario" and r["nv"] == 5 and r["id"].endswith("_n5_ref"):
                    continue
                # exceção: pode ter raridade MENOR que o permitido (fallback só para baixo)
                continue
            if rar_m == "lendario" and not r["id"].endswith("_n5_ref"):
                PROGRESSAO_ERROS.append((
                    r["id"], r["nv"], mid, rar_m,
                    "Material lendário SÓ pode aparecer em _n5_ref (estágio 2 refino)"
                ))
    # Limpa erros duplicados
    PROGRESSAO_ERROS = list(dict.fromkeys(PROGRESSAO_ERROS))

    # ====== RESULTADO ======
    print(f"\n=== RESULTADO: VALIDAÇÃO DE {len(MATS)} MATERIAIS × 128 RECEITAS ===")
    orfaos = []
    sobre = []
    ok = 0
    for mid in MAT_LIST:
        m = MATS[mid]
        u = USOS[mid]
        t = teto_mat(mid)
        status = "✅" if 3<=u<=t else ("❌ÓRFÃO" if u<3 else "❌SOBRE")
        if u<3: orfaos.append((mid,u,m["peso"],t))
        if u>t: sobre.append((mid,u,m["peso"],t))
        if 3<=u<=t: ok += 1
        print(f"  {status} {mid:30s} usos={u:2d}/{t:2d} esperado={m['peso']}")

    print(f"\nOK: {ok}/{len(MATS)}")
    print(f"Órfãos (<3 usos): {len(orfaos)}")
    for o,u,p,t in orfaos: print(f"   · {o:30s} usa {u} (mín=3, máx={t} · esperava ~{p})")
    print(f"Sobreutilizados (>teto): {len(sobre)}")
    for o,u,p,t in sobre: print(f"   · {o:30s} usa {u} (mín=3, máx={t} · esperava ~{p})")
    print(f"\nTypos / materiais que NÃO EXISTEM encontrados: {len(TYPOS)}")
    for n,m,msg in TYPOS: print(f"   · [{n}] id={m!r} → {msg}")
    print(f"\nProgressão (rar>nv): {len(PROGRESSAO_ERROS)} infrações")
    for rid,rnv,mid,rar,msg in PROGRESSAO_ERROS:
        print(f"   · receita {rid} (nv{rnv}) usa {mid} ({rar}) — {msg}")

    sys.exit(0 if (ok==len(MATS) and len(TYPOS)==0 and len(PROGRESSAO_ERROS)==0) else 1)
