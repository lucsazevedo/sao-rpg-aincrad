"""
Uso: python gerar_mapa_infografico.py

Compoe o infografico completo do mapa do Andar 1 (estilo "manual de RPG"):
titulo, painel de info, tipos de missao, mapa principal com pontos numerados,
legenda, mapa detalhado da Cidade do Inicio, diagrama da masmorra, ficha do
chefe e vistas -- tudo com dados reais ja documentados em docs/ e monstros/,
NAO inventados.

Precisa de Pillow (`pip install Pillow`) -- diferente dos outros scripts/,
que sao so stdlib, porque aqui a saida e composicao de imagem, nao texto.

Os assets de arte (mapa de fundo, vistas, retrato do chefe) precisam ja ter
sido gerados por gerar_imagem.py e estar em imagens/ ou mapas/ -- este
script so COMPOE, nao gera arte nova.
"""
import os
import textwrap

from PIL import Image, ImageDraw, ImageFont

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
IMAGENS_DIR = os.path.join(PROJECT_DIR, "imagens")
MAPAS_DIR = os.path.join(PROJECT_DIR, "mapas")
FONTS_DIR = r"C:\Windows\Fonts"

W, H = 1800, 2500
PARCHMENT = (232, 221, 196)
PARCHMENT_DARK = (214, 199, 165)
INK = (35, 28, 20)
INK_SOFT = (80, 68, 52)
GOLD = (150, 115, 40)
RED = (140, 30, 30)
BLUE = (30, 70, 130)
GREEN = (40, 100, 55)
PURPLE = (90, 50, 120)


def font(name, size):
    return ImageFont.truetype(os.path.join(FONTS_DIR, name), size)


F_TITLE = font("georgiab.ttf", 64)
F_SUBTITLE = font("georgiai.ttf", 30)
F_HEADER = font("georgiab.ttf", 30)
F_BODY = font("georgia.ttf", 22)
F_BODY_B = font("georgiab.ttf", 22)
F_SMALL = font("georgia.ttf", 18)
F_SMALL_B = font("georgiab.ttf", 18)
F_PIN = font("georgiab.ttf", 22)


def wrap_draw(draw, xy, text, f, max_width, fill=INK, line_h=26):
    x, y = xy
    for paragraph in text.split("\n"):
        avg_char_w = draw.textlength("x", font=f) or 10
        wrap_chars = max(10, int(max_width / avg_char_w * 1.9))
        for line in textwrap.wrap(paragraph, width=wrap_chars) or [""]:
            draw.text((x, y), line, font=f, fill=fill)
            y += line_h
    return y


def panel(draw, xy, size, title=None, fill=PARCHMENT_DARK, border=GOLD, border_w=3):
    x0, y0 = xy
    x1, y1 = x0 + size[0], y0 + size[1]
    draw.rectangle([x0, y0, x1, y1], fill=fill, outline=border, width=border_w)
    inner_y = y0 + 14
    if title:
        draw.text((x0 + 18, inner_y), title, font=F_HEADER, fill=INK)
        inner_y += 44
        draw.line([(x0 + 18, inner_y - 6), (x1 - 18, inner_y - 6)], fill=border, width=2)
    return x0 + 18, inner_y, x1 - 18


def fit_cover(img, size):
    tw, th = size
    sw, sh = img.size
    scale = max(tw / sw, th / sh)
    nw, nh = int(sw * scale), int(sh * scale)
    img = img.resize((nw, nh), Image.LANCZOS)
    left = (nw - tw) // 2
    top = (nh - th) // 2
    return img.crop((left, top, left + tw, top + th))


def load_or_placeholder(path, size, label):
    if path and os.path.exists(path):
        return fit_cover(Image.open(path).convert("RGB"), size)
    ph = Image.new("RGB", size, (170, 160, 140))
    d = ImageDraw.Draw(ph)
    d.rectangle([0, 0, size[0] - 1, size[1] - 1], outline=INK, width=2)
    d.text((10, 10), f"[{label}]", font=F_SMALL, fill=INK)
    return ph


def pin(canvas_draw, xy, number, color=RED, r=22):
    x, y = xy
    canvas_draw.ellipse([x - r, y - r, x + r, y + r], fill=color, outline=(255, 255, 255), width=3)
    txt = str(number)
    bbox = canvas_draw.textbbox((0, 0), txt, font=F_PIN)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    canvas_draw.text((x - tw / 2, y - th / 2 - bbox[1]), txt, font=F_PIN, fill=(255, 255, 255))


LOCAIS = [
    (1, "Cidade do Início", "Praça do Portão de Teletransporte — zona segura, maior cidade do andar"),
    (2, "Portão Principal / Campos", "Planície de Verrun (oeste, mais fácil) e Estepes de Kaldan (leste, mais dura)"),
    (3, "Floresta + Horunka", "Vila-base de caça (10 construções) — segura contra paralisia/dano de equipamento"),
    (4, "Lago", "Pouco explorado — habitat do Lacustre Vagador"),
    (5, "Montanhas", "Ruínas e vales — monstros fortes demais pro início, não recomendado ainda"),
    (6, "Tolbana", "2ª maior cidade do andar — base natural pra encarar o Labirinto"),
    (7, "Entrada do Labirinto", "Torre de 300x100m que leva ao andar 2 — guardada por um Field Boss não identificado"),
    (8, "Sala do Chefe", "Illfang the Kobold Lord + Ruin Kobold Sentinels — 20º nível do Labirinto"),
]

LEGENDA = [
    ("T", BLUE, "Teleporte"),
    ("C", GREEN, "Cidade / Zona segura"),
    ("H", RED, "Área de Caça"),
    ("D", PURPLE, "Dungeon / Entrada"),
    ("B", (100, 20, 20), "Chefe de Andar"),
    ("R", (70, 130, 80), "Recursos / Coleta"),
    ("*", GOLD, "Ponto de Interesse"),
]

TIPOS_MISSAO = [
    ("Eliminação", "Derrotar monstros específicos (Toubatsu-kei)"),
    ("Coleta", "Reunir materiais no campo (Shūshū-kei)"),
    ("Escolta", "Proteger um NPC até um destino (Goei-kei)"),
    ("Investigação", "Busca/entrega — pode escalar até um chefe de andar (Otsukai-kei)"),
]


def main():
    img = Image.new("RGB", (W, H), PARCHMENT)
    draw = ImageDraw.Draw(img)
    draw.rectangle([0, 0, W - 1, H - 1], outline=INK, width=6)
    draw.rectangle([14, 14, W - 15, H - 15], outline=GOLD, width=3)

    # ---- titulo ----
    draw.text((W / 2, 50), "AINCRAD", font=F_TITLE, fill=INK, anchor="ma")
    draw.text((W / 2, 122), "ANDAR 1 — O COMEÇO DA JORNADA", font=F_SUBTITLE, fill=INK_SOFT, anchor="ma")
    y_top = 180

    # ---- info panel (esquerda) + tipos de missao (direita) ----
    info_w = 520
    x0, y0, x1 = panel(draw, (40, y_top), (info_w, 260), "Informações do Andar")
    texto_info = (
        "Terreno: campos, floresta, lago e montanhas\n"
        "Maior andar de Aincrad (~10km de diâmetro)\n"
        "Chefe: Illfang the Kobold Lord\n"
        "Ameaça: fraco a forte nos campos/floresta; chefe é\n"
        "conteúdo de raid, não pra grupo pequeno\n"
        "Sistema: PBTA — 2d6 + atributo, sem \"nível\" numérico"
    )
    wrap_draw(draw, (x0, y0), texto_info, F_BODY, x1 - x0, line_h=30)

    miss_x = 40 + info_w + 30
    miss_w = W - 40 - miss_x
    x0, y0, x1 = panel(draw, (miss_x, y_top), (miss_w, 260), "Tipos de Missão em Aincrad")
    for nome, desc in TIPOS_MISSAO:
        draw.text((x0, y0), f"• {nome}", font=F_BODY_B, fill=INK)
        y0 += 28
        y0 = wrap_draw(draw, (x0 + 20, y0), desc, F_SMALL, x1 - x0 - 20, fill=INK_SOFT, line_h=22) + 4

    # ---- mapa principal ----
    map_y = y_top + 280
    map_h = 900
    mapa_art = load_or_placeholder(os.path.join(MAPAS_DIR, "andar_1_mapa_arte.png"), (W - 460, map_h), "mapa do andar 1")
    img.paste(mapa_art, (40, map_y))
    draw.rectangle([40, map_y, 40 + mapa_art.width, map_y + map_h], outline=GOLD, width=3)

    # pinos aproximados (posicoes relativas dentro da arte do mapa)
    posicoes_pin = [
        (0.50, 0.78), (0.50, 0.60), (0.28, 0.35), (0.75, 0.30),
        (0.85, 0.10), (0.65, 0.55), (0.50, 0.15), (0.50, 0.05),
    ]
    for (num, nome, _desc), (rx, ry) in zip(LOCAIS, posicoes_pin):
        px = 40 + int(mapa_art.width * rx)
        py = map_y + int(map_h * ry)
        pin(draw, (px, py), num)

    # legenda (coluna direita do mapa)
    leg_x = 40 + mapa_art.width + 20
    leg_w = W - 40 - leg_x
    x0, y0, x1 = panel(draw, (leg_x, map_y), (leg_w, map_h), "Legenda")
    for letra, cor, nome in LEGENDA:
        r = 16
        cy = y0 + r
        draw.ellipse([x0, cy - r, x0 + 2 * r, cy + r], fill=cor, outline=(255, 255, 255), width=2)
        bbox = draw.textbbox((0, 0), letra, font=F_SMALL_B)
        draw.text((x0 + r - (bbox[2] - bbox[0]) / 2, cy - (bbox[3] - bbox[1]) / 2 - bbox[1]), letra, font=F_SMALL_B, fill=(255, 255, 255))
        draw.text((x0 + 2 * r + 12, y0 + 2), nome, font=F_SMALL, fill=INK)
        y0 += 2 * r + 14
    y0 += 20
    draw.line([(x0, y0), (x1, y0)], fill=GOLD, width=2)
    y0 += 16
    draw.text((x0, y0), "Locais", font=F_BODY_B, fill=INK)
    y0 += 32
    for num, nome, desc in LOCAIS:
        draw.text((x0, y0), f"{num}. {nome}", font=F_SMALL_B, fill=INK)
        y0 += 24
        y0 = wrap_draw(draw, (x0 + 14, y0), desc, F_SMALL, x1 - x0 - 14, fill=INK_SOFT, line_h=20) + 8

    # ---- linha inferior: cidade detalhada / dungeon / chefe ----
    bottom_y = map_y + map_h + 30
    bottom_h = 560
    col_w = (W - 40 * 2 - 30 * 2) // 3

    # Cidade do Inicio detalhada
    x0, y0, x1 = panel(draw, (40, bottom_y), (col_w, bottom_h), "Cidade do Início — Pontos de Interesse")
    cidade_pts = [
        "1. Praça do Portão de Teletransporte", "2. Portão Principal",
        "3. Loja de Armas", "4. Loja de Armaduras (Lynx)",
        "5. Igreja", "6. Lago pequeno",
        "7. Castelo de Ferro Negro (norte)", "8. Dungeon Oculta (lenda, nível muito acima)",
    ]
    for linha in cidade_pts:
        draw.text((x0, y0), linha, font=F_SMALL, fill=INK)
        y0 += 30

    # Dungeon do andar 1 -- diagrama de fluxo
    dun_x = 40 + col_w + 30
    x0, y0, x1 = panel(draw, (dun_x, bottom_y), (col_w, bottom_h), "Labirinto do Andar 1")
    wrap_draw(draw, (x0, y0), "20 sub-níveis de corredores e armadilhas entre a entrada e a sala do chefe.", F_SMALL, x1 - x0, fill=INK_SOFT, line_h=22)
    y0 += 70
    etapas = ["Entrada\n(Field Boss)", "Corredores\n(Ruin Kobold\nTrooper)", "...", "Sala do Chefe\n(Illfang +\nSentinels)"]
    box_w = (x1 - x0 - 3 * 16) // 4
    bx = x0
    for i, etapa in enumerate(etapas):
        by = y0
        cor = (100, 20, 20) if i == len(etapas) - 1 else PARCHMENT
        draw.rectangle([bx, by, bx + box_w, by + 110], fill=cor, outline=INK, width=2)
        txt_color = (255, 255, 255) if i == len(etapas) - 1 else INK
        ty = by + 10
        for linha in etapa.split("\n"):
            draw.text((bx + box_w / 2, ty), linha, font=F_SMALL, fill=txt_color, anchor="ma")
            ty += 22
        if i < len(etapas) - 1:
            ay = by + 55
            draw.line([(bx + box_w, ay), (bx + box_w + 16, ay)], fill=INK, width=3)
            draw.polygon([(bx + box_w + 16, ay - 6), (bx + box_w + 16, ay + 6), (bx + box_w + 22, ay)], fill=INK)
        bx += box_w + 16
    y0 += 140
    draw.text((x0, y0), "Ruin Kobold Sentinel: 3 no início + 3 a cada barra de HP do", font=F_SMALL, fill=INK_SOFT)
    y0 += 24
    draw.text((x0, y0), "chefe esvaziada (até 12 no total).", font=F_SMALL, fill=INK_SOFT)

    # Chefe do andar
    chefe_x = dun_x + col_w + 30
    x0, y0, x1 = panel(draw, (chefe_x, bottom_y), (col_w, bottom_h), "Chefe — Illfang the Kobold Lord", fill=(60, 30, 30))
    for letra_ajuste in []:
        pass
    draw.rectangle([chefe_x, bottom_y, chefe_x + col_w, bottom_y + bottom_h], fill=(60, 30, 30), outline=GOLD, width=3)
    draw.text((chefe_x + 18, bottom_y + 14), "Chefe — Illfang the Kobold Lord", font=F_HEADER, fill=(240, 225, 200))
    retrato = load_or_placeholder(os.path.join(IMAGENS_DIR, "monstro_illfang_the_kobold_lord.png"), (col_w - 36, 260), "Illfang")
    img.paste(retrato, (chefe_x + 18, bottom_y + 60))
    ty = bottom_y + 60 + 260 + 16
    stats = [
        "Golpes p/ derrotar: 4 barras x 6-8 (24-32 total)",
        "Fase 1: machado + escudo broquel",
        "Fase 2 (1/3 HP): nodachi, skills de katana",
        "Recompensas: Col, Nodachi de Illfang,",
        "acesso ao Labirinto do Andar 2",
    ]
    for linha in stats:
        draw.text((chefe_x + 18, ty), linha, font=F_SMALL, fill=(235, 220, 195))
        ty += 26

    # ---- vistas ----
    vistas_y = bottom_y + bottom_h + 30
    vistas_h = H - vistas_y - 40
    draw.text((40, vistas_y), "VISTAS DO ANDAR 1", font=F_HEADER, fill=INK)
    vistas_y += 44
    nomes_vistas = [
        ("vista_campos.png", "Campos"),
        ("vista_floresta_horunka.png", "Floresta / Horunka"),
        ("vista_cidade_do_inicio.png", "Cidade do Início"),
        ("vista_entrada_labirinto.png", "Entrada do Labirinto"),
    ]
    vw = (W - 40 * 2 - 3 * 20) // 4
    vx = 40
    for arquivo, legenda in nomes_vistas:
        vista = load_or_placeholder(os.path.join(IMAGENS_DIR, arquivo), (vw, vistas_h - 30), legenda)
        img.paste(vista, (vx, vistas_y))
        draw.rectangle([vx, vistas_y, vx + vw, vistas_y + (vistas_h - 30)], outline=GOLD, width=2)
        draw.text((vx + vw / 2, vistas_y + vistas_h - 26), legenda, font=F_SMALL_B, fill=INK, anchor="ma")
        vx += vw + 20

    os.makedirs(MAPAS_DIR, exist_ok=True)
    destino = os.path.join(MAPAS_DIR, "andar_1_infografico.png")
    img.save(destino)
    print(f"Salvo em: {destino}")


if __name__ == "__main__":
    main()
