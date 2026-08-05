# Guia de estilo — visual/vídeo (ComfyUI)

Ainda **não há automação** pra essa parte (ver `docs/pipeline.md` — motivo:
nenhum workflow Wan2.1 do projeto SAO foi exportado ainda). Este guia serve
pra montar o prompt na mão, na UI do ComfyUI, usando o pipeline que já existe:

`Wan2.1 i2v 480p 14B` (imagem → vídeo) → `Real-ESRGAN x2plus` (upscale) →
`RIFE` (interpolação de frames). Para consistência facial entre cenas de um
mesmo personagem, usar `InsightFace (buffalo_l)` + `IPAdapter-Plus`.

## Mapas e placas de arte — `scripts/gerar_mapa_arte.py`

**Regra central: a IA pinta o terreno, o navegador desenha o texto.** Todo
pedido de "pôster de mapa com legenda/título/moldura" feito direto pra IA
volta com rabisco no lugar das letras — modelo de difusão não sabe escrever.
Então o pipeline do mapa é dividido em duas camadas:

1. **Placa de arte (IA)** — só o terreno visto de cima, sem texto, sem
   moldura, sem número, sem legenda. Gerada por
   `python scripts/gerar_mapa_arte.py andar`.
2. **Camada de interface (HTML/SVG)** — moldura dourada, painéis laterais,
   marcadores numerados, legenda, inset da cidade, diagrama do labirinto.
   Vive em `scripts/web/compendio_andar1.html` e fica nítida em qualquer
   zoom, porque é vetor/texto de verdade.

O negativo das placas de mapa **sempre** carrega o bloco anti-texto
(`text, letters, words, title, caption, label, watermark, signature, logo,
legend box, ui frame, border, ornate frame`) — sem isso a IA inventa uma
legenda ilegível e a placa vira lixo.

### Variantes já prontas no script

| Variante | Sai em | Pra que serve |
|---|---|---|
| `andar` | `mapas/andar_1_placa.png` | Placa principal do Andar 1 (2048x1408) |
| `cidade` | `mapas/cidade_do_inicio_planta.png` | Inset circular da Cidade do Início |
| `labirinto` | `mapas/labirinto_textura.png` | Textura de pedra pro diagrama da dungeon |
| `vista_cidade` / `vista_campo` / `vista_floresta` / `vista_lago` / `vista_dungeon` | `imagens/vista_*.png` | Faixa de "Vistas do Andar" no rodapé do Compêndio |
| `todas` | — | Roda tudo em sequência |

Fluxo recomendado: `python scripts/gerar_mapa_arte.py andar --tentativas 4`,
escolher a melhor, renomear pro nome sem sufixo de seed. O Compêndio detecta
o arquivo sozinho e cai de volta na arte antiga (`andar_1_mapa_arte.png`) se
a placa nova ainda não existir.

**Geografia que o prompt precisa respeitar** (bate com `mapas/andar_1.md` e
`scripts/web/dados_mapa.js`): cidade murada circular no centro, castelo
preto ao norte da praça, floresta a noroeste, lago a sudeste com ilhota,
rio a oeste, montanhas no anel norte/externo, segunda cidade (Tolbana) a
nordeste, torre do labirinto na borda norte, pântano e pedreira a leste.
Mudar a geografia da arte sem mudar as coordenadas em `dados_mapa.js`
desalinha todos os 305 marcadores.

**Checkpoint:** o Animagine XL é treinado em personagem de anime — dá conta
do terreno mas não brilha. Se tiver um SDXL de paisagem/ilustração
(Juggernaut XL, DreamShaper XL, SDXL base), passe
`--checkpoint nome.safetensors` que a qualidade sobe bastante.

## Monstros — use SEMPRE `--prompt-bruto` (não o Ollama automático)

Descoberto na prática: o Ollama, ao "traduzir" um pedido de monstro em
português pro formato de tags do Animagine, tende a perder as
características de criatura e o resultado sai como um cavaleiro humano
genérico. Pior: termos como "orelhas compridas" fazem o modelo confundir
com o arquétipo de "garota coelho" (kemonomimi) do anime e gerar DOIS
personagens em vez de um monstro.

**Fórmula que funcionou** (`scripts/gerar_imagem.py ... --prompt-bruto --negativo "..."`):

```
solo, single monster creature, [nome/tipo da criatura], [cor/textura de pele-pelo],
[focinho/boca com detalhe de dentes], [orelhas -- descreva formato sem comparar com
coelho], [cauda], [corpo], [armadura OU "no armor, bare chest"], [arma], [olhos],
monstrous non-human creature, not a person, [cenário], anime fantasy monster
concept art, full body shot
```

Negativo extra sempre: `2girls, multiple girls, multiple characters, human girl,
bunny girl, kemonomimi, humanoid woman, second character, cute girl, human face,
human skin` (+ `knight, human warrior` se o monstro tiver armadura, pra não puxar
pra "cavaleiro genérico").

Pra manter a mesma "espécie" visualmente entre variantes (ex: Ruin Kobold Trooper
sem armadura vs. Sentinel com armadura vs. Illfang gigante), repita a MESMA
descrição de pelagem/focinho/orelhas/cauda entre os prompts, só mudando
armadura/arma/porte.

## Itens (armas/equipamentos) — use SEMPRE `--item` (não o Ollama genérico)

Descoberto na prática (varredura de qualidade): o schema genérico de
personagem, mesmo recebendo descrição de "arma"/"equipamento", interpretava
boa parte dos pedidos como "descrição de guerreiro empunhando isso" e
devolvia gente — às vezes até fora do estilo anime esperado. Igual ao caso
dos monstros, mas com uma causa ligeiramente diferente: aqui o problema não
era o Ollama confundir espécie, era ele confundir "item" com "personagem
usando o item".

**Correção estrutural** (não depende de o Ollama "lembrar" nada):
`scripts/gerar_imagem.py --item` troca pro schema `SCHEMA_ITEM` (que instrui
"descreva só o objeto, nunca gente segurando/vestindo") e, no código — não
só no prompt —, força `"no humans, solo, "` no início do positivo se faltar
e mescla um negativo dedicado (`NEG_ITEM_BASE`: humanos, mãos, dedos,
segurando, empunhando, vestindo, corpo humano, guerreiro, cavaleiro) que
não depende do `--negativo` manual. `scripts/gerar_faltantes.py` já chama
`--item` sozinho pras filas de armas e equipamentos.

```
python scripts/gerar_imagem.py "Chicote de Raiz-Mãe, chicote de Aincrad andar 1. <aparência>" --item --nome arma_chicote_de_raiz_mae --largura 1024 --altura 1024
```

Se mesmo assim sair gente na imagem, o próximo degrau de controle é
`--prompt-bruto` com um prompt 100% escrito à mão (mesmo formato de
monstro, adaptado): `no humans, solo, [item], [material/cor], [forma],
[marca de uso/dano], [detalhe distintivo], product shot, game item render,
isolated on simple dark background, masterpiece, best quality, highly
detailed`.

## Monstros — variação grande entre criaturas: o que fazer quando acontecer

Mesmo seguindo a fórmula de `--prompt-bruto` acima, criaturas diferentes
ainda podem sair com "intensidade" de estilo bem diferente entre si (uma
sai como pintura dramática de fantasia realista, outra sai mais leve/lisa)
— isso vem da quantidade de palavras de atmosfera/drama que o prompt de
cada criatura carrega, não da fórmula em si. **Prática pra reduzir a
variação:** manter os prompts o mais "secos" possível — só as tags de
formula (tipo, textura, boca, orelha, cauda, corpo, armadura, arma, olhos,
cenário) — e evitar adjetivos de humor/drama extras (`ominous`, `epic`,
`dramatic lighting`, `glowing`) a menos que a criatura realmente precise
disso pra ler bem (ex: um chefe de andar pode justificar mais drama que um
bicho comum de campo). Isso não elimina 100% a variação (o checkpoint tem
vontade própria), mas reduz a maior fonte controlável dela.

## Fórmula de prompt por tipo de cena

**Close de personagem** (ficha de NPC, retrato):
`[descrição física], [expressão/emoção], [roupa/armadura], anime style,
detailed face, cinematic lighting, [ambiente de fundo desfocado], SAO
Aincrad aesthetic, high detail`

**Plano de ambiente** (estabelecer local — cidade, campo, masmorra):
`wide establishing shot, [nome do local], anime background art style,
[atmosfera/hora do dia], floating fantasy tower in the distance (se aplicável
o andar estiver visível), detailed environment, cinematic composition`

**Ação/batalha**:
`dynamic action shot, [personagem] using [arma/skill], motion blur, sparks
and energy effect, dramatic angle, anime fight scene, intense lighting`

## Negativo sugerido (comum às três)

`low quality, blurry, deformed hands, extra limbs, bad anatomy, watermark,
text, worst quality`

## Tom do momento atual da campanha (andar 1, dia 10)

Equipamentos ainda são simples/iniciais (raridade Comum/Incomum na maioria);
evite armaduras muito ornamentadas ou brilho mágico exagerado a menos que a
cena peça um item raro específico. A Cidade do Início mistura conforto
(arquitetura europeia medieval, praças) com uma tensão de fundo (poucos
sorrisos largos, olhares cansados).

## Próximo passo (automação real, ainda não feito)

1. Montar manualmente na UI do ComfyUI um workflow de image-to-video com
   Wan2.1 + upscale + RIFE que funcione bem pro estilo do projeto.
2. Exportar via **"Save (API Format)"** para
   `scripts/comfyui/workflow_i2v.json`.
3. Só então vale escrever um `gerar_cena_video.py` que carregue esse JSON,
   troque prompt/seed/imagem de entrada, e submeta via API HTTP do ComfyUI
   (`POST http://127.0.0.1:8188/prompt`). Escrever esse JSON à mão, sem um
   workflow validado como referência, tem alta chance de errar nomes de nó
   do WanVideoWrapper e simplesmente falhar.
