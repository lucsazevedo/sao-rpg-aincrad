"""
Extrai os 5 ícones de slot de equipamento de "equips.png" (tema verde,
uma linha só — mesmo template/grade das outras duas planilhas, canvas
1448x1086, conferido por recorte de teste). Silhueta branca, fundo
transparente — a cor por raridade entra depois via CSS mask, igual
IconeArma.vue.

Mapeamento pro vocabulário de slot já usado em `equipamentos.slot`
(EQUIP_SLOTS em tabelasAdmin.js): Elmos, Armaduras, Botas, Acessórios.
"Capa" (4º ícone) não tem slot correspondente hoje — extraído mesmo
assim (fica pronto se um dia crescer um slot novo), mas o app ainda não
usa esse arquivo até existir esse slot.

Uso: python scripts/extrair_icones_equipamentos.py
Saída: imagens/equipamentos_icones/<slug>.png
"""
import numpy as np
from PIL import Image
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
ORIGEM = RAIZ / "equips.png"
DESTINO = RAIZ / "imagens" / "equipamentos_icones"
DESTINO.mkdir(parents=True, exist_ok=True)

COLS = [201, 464, 726, 985, 1252]
CY = 544
RAIO_CORTE = 100
RAIO_MASCARA = 82

NOMES_EM_ORDEM = [
    ("Parte Superior (Elmo)", "elmos"),
    ("Roupa/Armadura", "armaduras"),
    ("Calçados", "botas"),
    ("Capa", "capa"),  # sem slot correspondente ainda em EQUIP_SLOTS
    ("Acessório", "acessorios"),
]

img = Image.open(ORIGEM).convert("RGB")
arr = np.asarray(img).astype(np.int16)

yy, xx = np.mgrid[-RAIO_CORTE:RAIO_CORTE, -RAIO_CORTE:RAIO_CORTE]
mascara_circular = (xx * xx + yy * yy) <= (RAIO_MASCARA * RAIO_MASCARA)

for cx, (nome, slug) in zip(COLS, NOMES_EM_ORDEM):
    crop_rgb = arr[CY - RAIO_CORTE: CY + RAIO_CORTE, cx - RAIO_CORTE: cx + RAIO_CORTE]
    crop_lum = crop_rgb.sum(axis=2)
    alpha = np.clip((crop_lum - 620) / (760 - 620) * 255, 0, 255).astype(np.uint8)
    alpha[~mascara_circular] = 0

    rgba = np.zeros((*alpha.shape, 4), dtype=np.uint8)
    rgba[..., 0:3] = 255
    rgba[..., 3] = alpha
    out = Image.fromarray(rgba, mode="RGBA")

    bbox = out.getbbox()
    if bbox:
        out = out.crop(bbox)

    out.save(DESTINO / f"{slug}.png")
    print(f"{nome:24s} -> {slug}.png  {out.size}")

print(f"\n{len(COLS)} ícones salvos em {DESTINO}")
