"""
Extrai os 15 ícones de profissão de "Profissões.jpeg". Diferente da
planilha de armas (círculo com FUNDO colorido — dava pra detectar a
posição pelo blob sólido), esta planilha tem fundo do círculo preto e
só um anel decorativo brilhante na borda — não tem blob sólido pra
detectar. Solução: a planilha usa o mesmíssimo template/grade da
planilha de armas (mesmas dimensões 1448x1086, mesmos centros de
coluna/linha, conferido visualmente recortando na mesma grade) —
reaproveita as posições em vez de redetectar, e usa uma máscara circular
(não quadrada) pra cortar o anel fora do recorte final.

Sem variação de cor aqui (usuário pediu: "mantém branco").

Uso: python scripts/extrair_icones_profissoes.py
Saída: imagens/profissoes_icones/<slug>.png (silhueta branca, fundo transparente)
"""
import numpy as np
from PIL import Image
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
ORIGEM = RAIZ / "Profissões.jpeg"
DESTINO = RAIZ / "imagens" / "profissoes_icones"
DESTINO.mkdir(parents=True, exist_ok=True)

# grade 5 colunas x 3 linhas, mesmos centros da planilha de armas
# (equipamentos/cinza.jpeg) — conferido por recorte de teste.
COLS = [201, 464, 726, 985, 1252]
ROWS = [232, 537, 836]
RAIO_CORTE = 100  # metade do recorte quadrado (folga generosa)
RAIO_MASCARA = 82  # além disso é anel decorativo — descartado

NOMES_EM_ORDEM = [
    ("Alquimista", "alquimista"), ("Caçador", "cacador"), ("Comerciante", "comerciante"),
    ("Costureiro", "costureiro"), ("Cozinheiro", "cozinheiro"),
    ("Domador", "domador"), ("Ferreiro", "ferreiro"), ("Informante", "informante"),
    ("Lenhador", "lenhador"), ("Mercenário", "mercenario"),
    ("Médico", "medico"), ("Mestre de Montarias", "mestre_de_montarias"), ("Minerador", "minerador"),
    ("Músico", "musico"), ("Joalheiro", "joalheiro"),
]

img = Image.open(ORIGEM).convert("RGB")
arr = np.asarray(img).astype(np.int16)

centros = [(cx, cy) for cy in ROWS for cx in COLS]

yy, xx = np.mgrid[-RAIO_CORTE:RAIO_CORTE, -RAIO_CORTE:RAIO_CORTE]
mascara_circular = (xx * xx + yy * yy) <= (RAIO_MASCARA * RAIO_MASCARA)

for (cx, cy), (nome, slug) in zip(centros, NOMES_EM_ORDEM):
    crop_rgb = arr[cy - RAIO_CORTE: cy + RAIO_CORTE, cx - RAIO_CORTE: cx + RAIO_CORTE]
    crop_lum = crop_rgb.sum(axis=2)
    alpha = np.clip((crop_lum - 620) / (760 - 620) * 255, 0, 255).astype(np.uint8)
    alpha[~mascara_circular] = 0  # descarta o anel decorativo fora do raio útil

    rgba = np.zeros((*alpha.shape, 4), dtype=np.uint8)
    rgba[..., 0:3] = 255
    rgba[..., 3] = alpha
    out = Image.fromarray(rgba, mode="RGBA")

    bbox = out.getbbox()
    if bbox:
        out = out.crop(bbox)

    out.save(DESTINO / f"{slug}.png")
    print(f"{nome:20s} -> {slug}.png  {out.size}")

print(f"\n{len(centros)} ícones salvos em {DESTINO}")
