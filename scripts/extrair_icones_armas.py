"""
Extrai os 13 ícones de tipo de arma da planilha de referência que o usuário
colocou em equipamentos/*.jpeg (mesma grade de círculos, só a cor do
círculo muda por raridade — o desenho branco dentro é idêntico em todas).

Em vez de guardar 13 ícones x 6 cores (78 arquivos), extrai só a silhueta
branca de cada ícone (fundo transparente) uma única vez. A cor por
raridade fica pro CSS aplicar em tempo real (mask-image + background-color),
então trocar a paleta de raridade no futuro não exige gerar imagem de novo.

Uso: python scripts/extrair_icones_armas.py
Saída: imagens/armas_icones/<slug>.png (silhueta branca, fundo transparente)
"""
import numpy as np
from PIL import Image
from pathlib import Path
from scipy import ndimage

RAIZ = Path(__file__).resolve().parent.parent
ORIGEM = RAIZ / "equipamentos" / "cinza.jpeg"  # qualquer uma serve pra achar a posição dos círculos
DESTINO = RAIZ / "imagens" / "armas_icones"
DESTINO.mkdir(parents=True, exist_ok=True)

# ordem de leitura da planilha (linha 1: 5, linha 2: 5, linha 3: 3) -> slug do banco (ARMAS_TIPOS)
NOMES_EM_ORDEM = [
    ("Chakrams", "chakrams"),
    ("Escudo e Espada", "escudo_e_espada"),
    ("Espada Longa", "espada_longa"),
    ("Foice", "foice"),
    ("Katana", "katana"),
    ("Lança", "lanca"),
    ("Machado", "machado"),
    ("Martelo", "martelo"),
    ("Rapieira", "rapieira"),
    ("Bastão", "bastao"),
    ("Clava", "clava"),
    ("Corrente com Peso", "corrente_com_peso"),
    ("Leque", "leque"),
]

img = Image.open(ORIGEM).convert("RGB")
arr = np.asarray(img).astype(np.int16)
luminancia = arr.sum(axis=2)  # proxy simples de brilho

# 1) acha os círculos: qualquer pixel bem mais claro que o fundo escuro
mascara_circulo = luminancia > 220  # fundo navy escuro fica bem abaixo disso
rotulado, n = ndimage.label(mascara_circulo)
objetos = ndimage.find_objects(rotulado)
tamanhos = np.bincount(rotulado.ravel())  # nº de pixels de cada rótulo (índice = rótulo)
caixas = []
for i, sl in enumerate(objetos, start=1):
    if sl is None:
        continue
    y0, y1 = sl[0].start, sl[0].stop
    x0, x1 = sl[1].start, sl[1].stop
    largura, altura = x1 - x0, y1 - y0
    area_caixa = largura * altura
    if area_caixa < 3000:  # ignora ruído pequeno (linhas decorativas, hexágonos do fundo)
        continue
    razao = largura / altura
    if not (0.75 <= razao <= 1.3):  # descarta o texto do nome embaixo (largo e baixo), fica só o círculo
        continue
    densidade = tamanhos[i] / area_caixa  # disco preenchido ~0.78; anel fino (borda) bem menos
    if densidade < 0.5:
        continue
    caixas.append((y0, y1, x0, x1))

if len(caixas) != len(NOMES_EM_ORDEM):
    raise SystemExit(f"esperava {len(NOMES_EM_ORDEM)} círculos, achou {len(caixas)} — ajustar limiar")

# 2) ordena em ordem de leitura (linha por y, depois x dentro da linha)
caixas.sort(key=lambda c: c[0])
linhas = []
atual = [caixas[0]]
for c in caixas[1:]:
    if c[0] - atual[-1][0] > 80:  # nova linha
        linhas.append(atual)
        atual = [c]
    else:
        atual.append(c)
linhas.append(atual)
ordenado = []
for linha in linhas:
    ordenado.extend(sorted(linha, key=lambda c: c[2]))

# 3) pra cada círculo, extrai só a silhueta branca (o desenho do ícone) como alpha
for (y0, y1, x0, x1), (nome, slug) in zip(ordenado, NOMES_EM_ORDEM):
    pad = 6
    crop_rgb = arr[max(0, y0 - pad): y1 + pad, max(0, x0 - pad): x1 + pad]
    crop_lum = crop_rgb.sum(axis=2)
    # ícone é desenhado em branco puro sobre o círculo colorido -- limiar alto
    # pega só o traço branco, não o preenchimento do círculo (mais escuro que 720=255*3*.94)
    alpha = np.clip((crop_lum - 620) / (760 - 620) * 255, 0, 255).astype(np.uint8)
    rgba = np.zeros((*alpha.shape, 4), dtype=np.uint8)
    rgba[..., 0:3] = 255  # branco puro; a cor de verdade entra via CSS (mask-image)
    rgba[..., 3] = alpha
    out = Image.fromarray(rgba, mode="RGBA")

    # corta a margem transparente sobrando pra não ter padding desigual por ícone
    bbox = out.getbbox()
    if bbox:
        out = out.crop(bbox)

    out.save(DESTINO / f"{slug}.png")
    print(f"{nome:20s} -> {slug}.png  {out.size}")

print(f"\n{len(ordenado)} ícones salvos em {DESTINO}")
