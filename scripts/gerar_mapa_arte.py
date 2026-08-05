"""
Uso: python gerar_mapa_arte.py [variante] [opcoes]

Gera as PLACAS DE ARTE do mapa do Andar 1 via ComfyUI -- so o terreno, sem
texto, sem moldura, sem legenda, sem marcador. Todo o resto (moldura dourada,
paineis, numeros, legenda, icones) e desenhado por cima em HTML/SVG pelo
Compendio (scripts/web/compendio_andar1.html), que fica nitido em qualquer
zoom -- ao contrario de texto gerado por IA, que sempre sai borrado/ilegivel.

Por que separar: o modelo de imagem e bom em TERRENO e pessimo em TIPOGRAFIA.
Pedir "um poster de mapa com legenda" pra IA sempre produz rabiscos no lugar
das letras. Entao a IA faz a pintura e o navegador faz o layout.

Variantes disponiveis (rode uma de cada vez):

  andar        placa principal -- o Andar 1 inteiro visto de cima (2048x1408)
  cidade       inset da Cidade do Inicio, planta circular murada (1024x1024)
  labirinto    textura de pedra do Labirinto, pra fundo do diagrama (1536x1024)
  vista_cidade vista de nivel do chao da Cidade do Inicio (1216x832)
  vista_campo  vista dos campos abertos (1216x832)
  vista_floresta vista da Floresta de Horunka (1216x832)
  vista_lago   vista do Lago Sylvaine (1216x832)
  vista_dungeon vista do interior do Labirinto (1216x832)
  todas        roda todas as variantes em sequencia

Exemplos:
  python scripts/gerar_mapa_arte.py andar
  python scripts/gerar_mapa_arte.py andar --seed 777 --tentativas 4
  python scripts/gerar_mapa_arte.py todas

Precisa do ComfyUI rodando em http://127.0.0.1:8188 (run_nvidia_gpu.bat em
C:\\AI\\ComfyUI). So usa a stdlib -- nao precisa de venv.

DICA DE CHECKPOINT: o Animagine XL (default do projeto) e treinado em
personagem de anime, nao em cartografia -- ele da conta do terreno, mas se
voce tiver (ou baixar) um checkpoint de paisagem/ilustracao tipo
"Juggernaut XL", "DreamShaper XL" ou "SDXL base", passe --checkpoint
"nome_do_arquivo.safetensors" que a qualidade do mapa sobe bastante.
"""
import argparse
import json
import os
import random
import sys
import time
import urllib.error
import urllib.request

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MAPAS_DIR = os.path.join(PROJECT_DIR, "mapas")
IMAGENS_DIR = os.path.join(PROJECT_DIR, "imagens")
WORKFLOW_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "comfyui", "workflow_txt2img.json")
COMFYUI_URL = "http://127.0.0.1:8188"

# Negativo comum a toda placa de mapa. O ponto critico e BLOQUEAR TEXTO:
# qualquer letra que a IA desenhar vira rabisco e estraga a placa, porque o
# texto de verdade vem do HTML por cima.
NEG_MAPA = (
    "text, letters, words, title, caption, label, watermark, signature, logo, "
    "legend box, compass rose with text, ui frame, border, ornate frame, "
    "1girl, 1boy, person, people, character, face, portrait, anime character, "
    "lowres, blurry, jpeg artifacts, worst quality, low quality, "
    "photo, photorealistic, 3d render, cluttered, oversaturated"
)

NEG_VISTA = (
    "text, letters, watermark, signature, logo, ui, hud, map, minimap, "
    "1girl, 1boy, people, crowd, character, face, portrait, "
    "lowres, blurry, worst quality, low quality, bad anatomy, extra limbs"
)

# ---------------------------------------------------------------------------
# Prompts. Escritos a mao (--prompt-bruto equivalente): nao passam pelo Ollama
# de proposito, porque a traducao automatica perde os termos de cartografia.
# A geografia descrita bate com mapas/andar_1.md e scripts/web/dados_mapa.js:
# cidade murada no centro, labirinto ao norte, floresta a noroeste, lago a
# sudeste/nordeste, rio a oeste, montanhas no anel externo, Tolbana a nordeste.
# ---------------------------------------------------------------------------
VARIANTES = {
    "andar": {
        "arquivo": "andar_1_placa",
        "dir": MAPAS_DIR,
        "largura": 2048,
        "altura": 1408,
        "steps": 40,
        "cfg": 6.5,
        "negativo": NEG_MAPA,
        "prompt": (
            "no humans, fantasy world map illustration, top down bird's eye view of an entire "
            "circular floating continent, hand painted rpg game map, "
            "large walled medieval city with circular plaza at the center, black iron castle "
            "spire rising north of the plaza, "
            "stone roads radiating outward from the city gates like spokes, "
            "dense dark forest in the northwest corner with a tiny village clearing, "
            "wide green plains and farmland with terraced fields to the east and south, "
            "large blue lake with a small island in the southeast, "
            "winding river along the western edge with a waterfall, "
            "jagged grey mountain range along the northern and outer rim, "
            "a second smaller walled town on the northeast plateau, "
            "an enormous ominous stone labyrinth tower at the far north edge, "
            "swamp and quarry ruins in the far east, "
            "scattered ancient ruins and standing stones across the fields, "
            "muted parchment color palette, deep greens and slate greys and warm ochre, "
            "soft painterly shading, ghibli inspired background art, aerial perspective haze, "
            "clean uncluttered composition, empty margins around the landmass, "
            "masterpiece, best quality, highly detailed, absurdres"
        ),
    },
    "cidade": {
        "arquivo": "cidade_do_inicio_planta",
        "dir": MAPAS_DIR,
        "largura": 1024,
        "altura": 1024,
        "steps": 40,
        "cfg": 6.5,
        "negativo": NEG_MAPA,
        "prompt": (
            "no humans, top down aerial view of a circular walled medieval fantasy city, "
            "perfectly round stone curtain wall, four gates at the compass points, "
            "concentric rings of red tiled rooftops, radial cobblestone streets, "
            "wide circular central plaza with a teleport gate monolith, "
            "tall black gothic castle at the north side of the plaza, "
            "small church with a bell tower, a tiny pond, market stalls, "
            "hand painted rpg city map, muted parchment palette, warm terracotta roofs, "
            "soft painterly shading, aerial haze, clean composition, "
            "masterpiece, best quality, highly detailed, absurdres"
        ),
    },
    "labirinto": {
        "arquivo": "labirinto_textura",
        "dir": MAPAS_DIR,
        "largura": 1536,
        "altura": 1024,
        "steps": 32,
        "cfg": 6.0,
        "negativo": NEG_MAPA,
        "prompt": (
            "no humans, seamless dark stone dungeon wall texture, ancient carved granite blocks, "
            "cracks and moss, faint torch light gradient, deep shadow, "
            "top down flat lighting, muted charcoal and slate palette, "
            "game background texture, no objects, no doors, "
            "masterpiece, best quality, highly detailed"
        ),
    },
    "vista_cidade": {
        "arquivo": "vista_cidade_do_inicio",
        "dir": IMAGENS_DIR,
        "largura": 1216,
        "altura": 832,
        "steps": 32,
        "cfg": 7.0,
        "negativo": NEG_VISTA,
        "prompt": (
            "no humans, wide establishing shot, medieval fantasy town square at golden hour, "
            "circular stone plaza, teleport gate monolith, black iron castle spire in the "
            "background, market stalls closing, long shadows, "
            "anime background art, ghibli inspired, soft warm light, subdued mood, "
            "masterpiece, best quality, highly detailed, absurdres"
        ),
    },
    "vista_campo": {
        "arquivo": "vista_campos_abertos",
        "dir": IMAGENS_DIR,
        "largura": 1216,
        "altura": 832,
        "steps": 32,
        "cfg": 7.0,
        "negativo": NEG_VISTA,
        "prompt": (
            "no humans, wide establishing shot, rolling green plains under a huge sky, "
            "dirt road splitting in two directions, scattered boulders and wildflowers, "
            "distant walled city on the horizon, an impossibly vast floating stone ceiling "
            "far above the landscape, "
            "anime background art, ghibli inspired, midday light, "
            "masterpiece, best quality, highly detailed, absurdres"
        ),
    },
    "vista_floresta": {
        "arquivo": "vista_floresta_horunka",
        "dir": IMAGENS_DIR,
        "largura": 1216,
        "altura": 832,
        "steps": 32,
        "cfg": 7.0,
        "negativo": NEG_VISTA,
        "prompt": (
            "no humans, wide establishing shot, dense old growth forest, thick moss covered "
            "trunks, shafts of green light through the canopy, narrow overgrown trail, "
            "a carved symbol scarred into one tall tree, ferns and fallen logs, "
            "anime background art, ghibli inspired, humid quiet atmosphere, "
            "masterpiece, best quality, highly detailed, absurdres"
        ),
    },
    "vista_lago": {
        "arquivo": "vista_lago_sylvaine",
        "dir": IMAGENS_DIR,
        "largura": 1216,
        "altura": 832,
        "steps": 32,
        "cfg": 7.0,
        "negativo": NEG_VISTA,
        "prompt": (
            "no humans, wide establishing shot, calm freshwater lake at dusk, mirror still "
            "surface, small wooded island in the middle distance, wooden fishing pier, "
            "reeds in the foreground, faint whirlpool disturbing the water, "
            "anime background art, ghibli inspired, cool blue and violet palette, "
            "masterpiece, best quality, highly detailed, absurdres"
        ),
    },
    "vista_dungeon": {
        "arquivo": "vista_labirinto_interior",
        "dir": IMAGENS_DIR,
        "largura": 1216,
        "altura": 832,
        "steps": 32,
        "cfg": 7.0,
        "negativo": NEG_VISTA,
        "prompt": (
            "no humans, wide establishing shot, vast ancient stone labyrinth corridor, "
            "enormous carved pillars, blue crystal torches on the walls, "
            "cracked flagstone floor, oppressive darkness ahead, cold blue light, "
            "anime background art, dramatic perspective, ominous atmosphere, "
            "masterpiece, best quality, highly detailed, absurdres"
        ),
    },
}

ORDEM_TODAS = ["andar", "cidade", "labirinto", "vista_cidade", "vista_campo",
               "vista_floresta", "vista_lago", "vista_dungeon"]


def carregar_workflow():
    with open(WORKFLOW_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def no(workflow, class_type):
    for node in workflow.values():
        if node["class_type"] == class_type:
            return node
    raise KeyError(f"Nenhum node do tipo {class_type} no workflow")


def enviar(workflow):
    payload = {"prompt": workflow, "client_id": "sao_rpg_gerar_mapa_arte"}
    req = urllib.request.Request(
        f"{COMFYUI_URL}/prompt",
        data=json.dumps(payload).encode("utf-8"),
        headers={"Content-Type": "application/json"},
    )
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            return json.loads(resp.read().decode("utf-8"))
    except urllib.error.URLError as e:
        raise RuntimeError(
            f"Nao consegui falar com o ComfyUI em {COMFYUI_URL} ({e}). "
            "Confira se ele esta rodando (run_nvidia_gpu.bat em C:\\AI\\ComfyUI)."
        ) from e


def esperar(prompt_id, timeout=600):
    t0 = time.time()
    while time.time() - t0 < timeout:
        with urllib.request.urlopen(f"{COMFYUI_URL}/history/{prompt_id}", timeout=30) as resp:
            hist = json.loads(resp.read().decode("utf-8"))
        if prompt_id in hist:
            for saida in hist[prompt_id].get("outputs", {}).values():
                if "images" in saida:
                    return saida["images"]
        time.sleep(2)
    raise TimeoutError(f"ComfyUI nao terminou em {timeout}s (prompt_id={prompt_id})")


def baixar(info, destino):
    params = (f"filename={info['filename']}&subfolder={info.get('subfolder', '')}"
              f"&type={info.get('type', 'output')}")
    with urllib.request.urlopen(f"{COMFYUI_URL}/view?{params}", timeout=120) as resp:
        dados = resp.read()
    with open(destino, "wb") as f:
        f.write(dados)


def gerar(chave, args):
    v = VARIANTES[chave]
    os.makedirs(v["dir"], exist_ok=True)
    tentativas = max(1, args.tentativas)

    for i in range(tentativas):
        seed = args.seed if args.seed is not None else random.randint(0, 2 ** 31 - 1)
        if args.seed is not None:
            seed += i

        workflow = carregar_workflow()
        for node in workflow.values():
            if node["class_type"] != "CLIPTextEncode":
                continue
            if node["inputs"]["text"].startswith("lowres"):
                node["inputs"]["text"] = v["negativo"]
            else:
                node["inputs"]["text"] = v["prompt"]
        latente = no(workflow, "EmptyLatentImage")["inputs"]
        latente["width"] = args.largura or v["largura"]
        latente["height"] = args.altura or v["altura"]
        sampler = no(workflow, "KSampler")["inputs"]
        sampler["seed"] = seed
        sampler["steps"] = v["steps"]
        sampler["cfg"] = v["cfg"]
        if args.checkpoint:
            no(workflow, "CheckpointLoaderSimple")["inputs"]["ckpt_name"] = args.checkpoint

        sufixo = "" if tentativas == 1 else f"_s{seed}"
        print(f"\n[{chave}] seed={seed} {latente['width']}x{latente['height']} "
              f"steps={v['steps']} cfg={v['cfg']}")
        resposta = enviar(workflow)
        prompt_id = resposta["prompt_id"]
        print(f"  prompt_id={prompt_id} -- gerando (mapa grande demora, seja paciente)...")
        imagens = esperar(prompt_id)
        for j, info in enumerate(imagens):
            nome = f"{v['arquivo']}{sufixo}" + ("" if j == 0 else f"_{j}") + ".png"
            destino = os.path.join(v["dir"], nome)
            baixar(info, destino)
            print(f"  salvo: {destino}")


def main():
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("variante", nargs="?", default="andar",
                        choices=list(VARIANTES) + ["todas"])
    parser.add_argument("--seed", type=int, help="Fixa a seed (com --tentativas, incrementa a partir dela)")
    parser.add_argument("--tentativas", type=int, default=1,
                        help="Gera N versoes com seeds diferentes pra voce escolher a melhor")
    parser.add_argument("--largura", type=int, help="Sobrescreve a largura da variante")
    parser.add_argument("--altura", type=int, help="Sobrescreve a altura da variante")
    parser.add_argument("--checkpoint", help="Troca o checkpoint (ex: um SDXL de paisagem)")
    parser.add_argument("--mostrar-prompt", action="store_true",
                        help="So imprime o prompt da variante e sai, sem gerar nada")
    args = parser.parse_args()

    alvos = ORDEM_TODAS if args.variante == "todas" else [args.variante]

    if args.mostrar_prompt:
        for chave in alvos:
            v = VARIANTES[chave]
            print(f"\n===== {chave} -> {v['dir']}\\{v['arquivo']}.png "
                  f"({v['largura']}x{v['altura']}) =====")
            print("POSITIVO:\n" + v["prompt"])
            print("\nNEGATIVO:\n" + v["negativo"])
        return

    for chave in alvos:
        gerar(chave, args)

    print("\nPronto. Escolha a melhor versao, renomeie pro nome sem sufixo de seed "
          "(ex: mapas/andar_1_placa.png) e abra scripts/web/compendio_andar1.html -- "
          "ele usa a placa automaticamente se o arquivo existir.")


if __name__ == "__main__":
    main()
