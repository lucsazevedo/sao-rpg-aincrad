---
titulo: Prompts do mapa do Andar 1 — Nano Banana / Gemini / SDXL
andar: 1
uso: geração de arte
---

# Prompts do mapa do Andar 1

Como usar: abra `scripts/web/mapa_limpo.html`, escolha o modo, baixe o PNG no
maior tamanho, e leve a imagem + um dos prompts abaixo.

**A regra que não pode ser quebrada:** o resultado tem que sair em **3:2** e ser
salvo como `mapas/andar_1_placa.png`. As coordenadas dos 241 marcadores do
Compêndio são fixas — se a proporção mudar, tudo desalinha.

**Nada de texto na imagem.** Nem nome, nem legenda, nem moldura, nem rosa dos
ventos. Modelo de imagem não escreve; vira rabisco. Todo texto e todo marcador
são desenhados por cima, em vetor, pelo Compêndio.

---

## 0. Antes de exportar: clique em "Preparar pra IA"

O botão dourado no `mapa_limpo.html` desliga os nomes, desliga os marcos e vai
pro modo referência de uma vez só. **Se exportar com os nomes ligados, o gerador
copia o texto e erra a grafia** — foi assim que saiu "Tolbang", "Terruços de
Solveig", "Mantanhas de Grudecan" e "Bosque de Áshweñ" na primeira tentativa.

Os nomes na tela existem só pra *você* se localizar. Quem escreve no mapa final
é o Compêndio, em vetor, por cima da arte.

---

## 1. Prompt principal — com a imagem de referência (o melhor caminho)

Suba o PNG do **modo referência** (blocos chapados) e mande isto:

```
Repaint this reference map as a beautiful hand-painted fantasy world map of a
single floating island. Keep the EXACT geography of the reference: every
coastline, lake, river, forest, mountain range, city and road must stay in the
same position, the same size and the same proportion. Do not move, add or
remove any landmass or feature.

Do not draw any text, letters, labels, legend, compass rose, border, frame,
scale bar, icon or map pin. No writing of any kind anywhere in the image. The
result must be pure painted terrain — all labels are added separately later.

Style: hand-painted parchment RPG world map seen from directly above, muted
natural palette of deep greens, slate greys and warm ochre, soft painterly
shading with gentle aerial haze, subtle brush texture, Studio Ghibli inspired
background art, clean uncluttered composition. The island floats: leave the
area outside the coastline as dark empty void, with a soft rim of light along
the coast.

Aspect ratio 3:2. Highly detailed, masterpiece quality.
```

## 2. Se ele mexer na geografia — corrija assim

```
Too much has changed. Go back to the reference image and keep the silhouette
of the island and the position of every feature exactly as they are. Only
change the painting style — the shapes must match the reference one to one.
```

## 3. Se ele escrever texto na imagem — corrija assim

```
Remove every piece of text from this image. No place names, no letters, no
words, no labels of any kind. Paint over each removed label with the terrain
that belongs underneath it — grass, forest canopy, rock, water — so the
surface looks continuous and no blank patches or ghost outlines remain.

Change nothing else. The coastline, the mountains, the lake, the roads, the
cities and every other feature must stay pixel-for-pixel where they are.
```

## 3b. Se o mapa ficou cortado nas bordas

```
Zoom out slightly so the entire island fits inside the frame with a small
margin of empty void on all four sides. Nothing may touch or cross the edge
of the image. Keep the composition centred and the aspect ratio at 3:2, and
do not change the shape or the internal layout of the island.
```

---

## 4. Prompt sem imagem de referência (só texto)

Use se quiser começar do zero. É mais bonito e menos preciso — provavelmente
vai desalinhar os marcadores, e aí me chame pra recalibrar as coordenadas.

```
A hand-painted fantasy world map of one floating island, seen from directly
above, 3:2 aspect ratio.

Layout, precisely:
- CENTER: a large circular walled city with a stone curtain wall, four gates,
  concentric rings of red-tiled rooftops and radial streets meeting a round
  central plaza.
- Immediately NORTH of that city: a black stone castle with three towers, and
  above it, touching the top edge, an enormous rectangular labyrinth tower of
  dark stone.
- ALONG THE NORTH RIM: a long snow-capped mountain range spanning most of the
  width, with a smaller range at the upper-left corner.
- NORTHEAST: rolling green stone hills, and at the far corner the island is
  cut by a sheer cliff edge.
- EAST: a second, smaller walled town on a plateau; terraced farmland on a
  slope; rectangular cultivated fields with furrows; a cave mouth glowing
  faint blue; a dark green swamp; a flooded quarry pit.
- SOUTHEAST: a large blue lake with one small wooded island in it, and
  shallow reedy marshland just west of the lake.
- SOUTH: a wide open plain scattered with ancient broken ruins, fallen
  standing stones and half-buried walls.
- SOUTHWEST: an old necropolis — rows of grey headstones in a shallow valley.
- WEST: a winding river running from the top edge to the bottom along the
  western side; a small village of stilted houses on its bank.
- NORTHWEST: a dense dark old-growth forest with a tiny village clearing
  inside it; a pale misty grove of thin light-coloured trees; a cave mouth in
  the rock face.
- Pale dirt roads radiate from the central city to the eastern town, to the
  forest village, to the river village and north to the labyrinth tower.

Style: hand-painted parchment RPG map, muted natural palette, deep greens,
slate greys, warm ochre roads, soft painterly shading, aerial haze, subtle
brush texture, Ghibli inspired background art, clean uncluttered composition,
dark empty void outside the coastline so the island reads as floating.

No text, no letters, no labels, no legend, no compass rose, no border, no
frame, no icons, no map pins. Highly detailed, masterpiece quality.
```

---

## 5. Negativo (pra SDXL / ComfyUI)

```
text, letters, words, title, caption, label, watermark, signature, logo,
legend box, compass rose, ui frame, border, frame, scale bar, map pin, marker,
icon, 1girl, 1boy, person, people, character, face, portrait, photo,
photorealistic, 3d render, cluttered, oversaturated, lowres, blurry,
jpeg artifacts, worst quality, low quality
```

---

## 6. Variações de clima, se quiser testar

Troque só o bloco de estilo, mantendo o resto:

**Pergaminho clássico**
```
aged parchment map, sepia and umber palette, ink outlines, watercolour wash,
hand-drawn cartography, warm paper texture
```

**Anime / SAO**
```
anime game world map, clean saturated colours, crisp shapes, soft gradient
shading, JRPG overworld map aesthetic, bright and readable
```

**Sombrio (dia 10)**
```
overcast and subdued, desaturated greens and cold greys, low sun, long
shadows, a world that stopped being pretty, muted and heavy atmosphere
```

**Noturno**
```
night map, deep blue and violet palette, moonlight rim on the coast, warm
pinpoints of light in the cities, cool mist over the lake and swamp
```

---

## Depois de gerar

1. Escolha a melhor e redimensione para **1536 × 1024** (ou qualquer múltiplo
   exato de 3:2).
2. Salve em `mapas/andar_1_placa.png`.
3. Abra `scripts/web/compendio_andar1.html`, clique em **Fundo: vetor** pra
   alternar para **arte**.
4. Se os marcadores não baterem com a arte, **não conserte na mão** — me avise
   e eu recalibro `dados_terreno.js` ou as coordenadas de `dados_mapa.js`.
