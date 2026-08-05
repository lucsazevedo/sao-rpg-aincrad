"""
Uso: python gerar_imagem.py "retrato da NPC Lynx, comerciante de armaduras" [opcoes]

Gera uma imagem estilo anime via ComfyUI (checkpoint Animagine XL 4.0 opt)
a partir de um pedido em portugues. Usa o Ollama local (qwen2.5:14b) pra
montar as tags de prompt (formato que o Animagine espera: assunto, depois
tags soltas, terminando com tags de qualidade) e negativo padrao, envia
pra API do ComfyUI (precisa estar rodando -- ver run_nvidia_gpu.bat em
C:\\AI\\ComfyUI) e salva o resultado em imagens/ (ou mapas/ com --mapa).

So usa a stdlib (urllib/json) -- nao precisa de venv especial. O ComfyUI
PRECISA estar rodando em http://127.0.0.1:8188 antes de usar este script.

Opcoes uteis:
  --largura 832 --altura 1216   resolucao (default: retrato 832x1216)
  --mapa                         salva em mapas/ em vez de imagens/
  --seed 12345                   fixa a seed (default: aleatoria)
  --referencia caminho.png       usa IPAdapter FaceID pra manter a MESMA cara
                                  de um personagem que ja tem imagem gerada --
                                  use a imagem de referencia (ex: o retrato
                                  ja existente de um NPC) pra consistencia
                                  entre aparicoes
  --model qwen2.5:14b            troca o modelo do Ollama
"""
import argparse
import json
import os
import random
import re
import shutil
import sys
import time
import urllib.error
import urllib.request

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from ollama_client import MODELO_RAPIDO, carregar_guia_sistema, perguntar_json, slugify

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
IMAGENS_DIR = os.path.join(PROJECT_DIR, "imagens")
MAPAS_DIR = os.path.join(PROJECT_DIR, "mapas")
COMFYUI_DIR = r"C:\AI\ComfyUI\ComfyUI"
COMFYUI_INPUT_DIR = os.path.join(COMFYUI_DIR, "input")
WORKFLOW_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "comfyui")
WORKFLOW_PATH = os.path.join(WORKFLOW_DIR, "workflow_txt2img.json")
WORKFLOW_FACEID_PATH = os.path.join(WORKFLOW_DIR, "workflow_txt2img_faceid.json")

COMFYUI_URL = "http://127.0.0.1:8188"

SCHEMA = """Responda APENAS com um objeto JSON valido, sem markdown, sem comentarios,
com exatamente estes campos:
{
  "positivo": "string em ingles, tags separadas por virgula no formato do Animagine XL: comece com o sujeito (1girl/1boy/1other/no humans), depois caracteristicas visuais soltas (roupa, cabelo, expressao, cenario, iluminacao), termine com tags de qualidade tipo 'masterpiece, best quality, highly detailed'",
  "nome_arquivo": "slug curto em snake_case, sem acentos"
}"""


def montar_system(guia):
    return f"""Voce e prompt engineer para o Animagine XL (modelo de texto-pra-imagem estilo
anime, usado na campanha "Sword Art Online: The Perfect Chaos"). Use este guia de sistema
como referencia de tom/estetica (nao repita ele no prompt, so use pra calibrar o estilo):

{guia}

Dado o pedido do usuario em portugues (retrato de NPC, cena, monstro, mapa etc.), gere
tags de prompt em ingles no formato que o Animagine XL espera. Nao inclua nomes proprios
de personagens de anime existentes (ex: nao escreva "Kirito", descreva visualmente em vez
disso). Estetica: anime, mundo de Aincrad (VRMMORPG medieval fantasia), andar 1 (dia 10
da campanha -- equipamento simples, nada muito ornamentado a menos que pedido).

{SCHEMA}"""


# ---------------------------------------------------------------------------
# Modo --item: armas e equipamentos. Existe como schema/system PROPRIO (nao o
# generico de personagem) porque o generico, na pratica, gerava gente
# segurando/vestindo o item em vez do item isolado -- o Ollama tende a
# interpretar "descricao de arma" como "descricao de guerreiro com a arma".
# Ver docs/guia_estilo_visual.md, secao "Itens".
# ---------------------------------------------------------------------------
SCHEMA_ITEM = """Responda APENAS com um objeto JSON valido, sem markdown, sem comentarios,
com exatamente estes campos:
{
  "positivo": "string em ingles, tags separadas por virgula, DESCREVENDO APENAS O OBJETO (nunca uma pessoa segurando/vestindo/usando ele): comece com as caracteristicas fisicas do item (material, cor, forma, marcas de uso/dano, detalhe distintivo), NUNCA inclua 1girl/1boy/1other/personagem/mao/punho/vestindo, termine com 'no humans, product shot, game item render, masterpiece, best quality, highly detailed'",
  "nome_arquivo": "slug curto em snake_case, sem acentos"
}"""

NEG_ITEM_BASE = ("1girl, 1boy, 1other, multiple girls, multiple boys, humans, person, human, "
                 "character, portrait, face, human face, human skin, hands, fingers, arm, "
                 "holding, wielding, wearing, worn by person, human body, knight, warrior, "
                 "full body, close-up of a person")


def montar_system_item(guia):
    return f"""Voce e prompt engineer para o Animagine XL (modelo de texto-pra-imagem estilo
anime, usado na campanha "Sword Art Online: The Perfect Chaos"), especializado em ITENS DE
JOGO (arma ou peca de equipamento) -- NUNCA personagens. Use este guia de sistema como
referencia de tom/estetica (nao repita ele no prompt, so use pra calibrar o estilo):

{guia}

Dado o pedido do usuario em portugues (nome e descricao de uma arma ou equipamento), gere
tags de prompt em ingles descrevendo **somente o objeto**, como uma foto de produto ou
icone de inventario de jogo: item sozinho, isolado, sem ninguem segurando, vestindo ou
empunhando ele, sem parte de corpo humano visivel. Pense em "item icon renderizado em alta
qualidade", nao em "personagem equipado". Nao inclua nomes proprios de personagens de anime
existentes. Estetica: mundo de Aincrad (VRMMORPG medieval fantasia), andar 1 (dia 10 da
campanha -- equipamento simples, nada muito ornamentado a menos que pedido).

{SCHEMA_ITEM}"""


def montar_prompt_ollama(pedido):
    guia = carregar_guia_sistema()
    system = montar_system(guia)
    return perguntar_json(system, pedido, model=MODELO_RAPIDO)


def montar_prompt_item_ollama(pedido):
    guia = carregar_guia_sistema()
    system = montar_system_item(guia)
    return perguntar_json(system, pedido, model=MODELO_RAPIDO)


def carregar_workflow(caminho):
    with open(caminho, "r", encoding="utf-8") as f:
        return json.load(f)


def no(workflow, class_type):
    """Acha o (unico) no de um certo class_type no workflow -- mais robusto
    que depender do numero da chave, que muda entre os dois arquivos de workflow."""
    for node in workflow.values():
        if node["class_type"] == class_type:
            return node
    raise KeyError(f"Nenhum node do tipo {class_type} encontrado no workflow")


def enviar_para_comfyui(workflow):
    payload = {"prompt": workflow, "client_id": "sao_rpg_gerar_imagem"}
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


def esperar_resultado(prompt_id, timeout=180):
    t0 = time.time()
    while time.time() - t0 < timeout:
        with urllib.request.urlopen(f"{COMFYUI_URL}/history/{prompt_id}", timeout=30) as resp:
            historico = json.loads(resp.read().decode("utf-8"))
        if prompt_id in historico:
            outputs = historico[prompt_id].get("outputs", {})
            for node_out in outputs.values():
                if "images" in node_out:
                    return node_out["images"]
        time.sleep(2)
    raise TimeoutError(f"ComfyUI nao terminou a geracao em {timeout}s (prompt_id={prompt_id})")


def baixar_imagem(info, destino):
    params = f"filename={info['filename']}&subfolder={info.get('subfolder', '')}&type={info.get('type', 'output')}"
    with urllib.request.urlopen(f"{COMFYUI_URL}/view?{params}", timeout=60) as resp:
        dados = resp.read()
    with open(destino, "wb") as f:
        f.write(dados)


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("pedido", help="Descreva a imagem, em portugues")
    parser.add_argument("--largura", type=int, default=832)
    parser.add_argument("--altura", type=int, default=1216)
    parser.add_argument("--mapa", action="store_true", help="Salva em mapas/ em vez de imagens/")
    parser.add_argument("--seed", type=int)
    parser.add_argument("--nome", help="Forca o nome do arquivo (sem extensao)")
    parser.add_argument("--referencia", help="Caminho de uma imagem de referencia (IPAdapter FaceID, mesma cara)")
    parser.add_argument("--prompt-bruto", dest="prompt_bruto", action="store_true",
                         help="Usa 'pedido' como o prompt final em ingles direto, sem passar pelo Ollama "
                              "(mais controle -- use quando o Ollama estiver perdendo detalhes importantes)")
    parser.add_argument("--item", action="store_true",
                         help="Modo arma/equipamento: usa o schema/negativo especializado em ITEM "
                              "(sem pessoa segurando/vestindo) em vez do schema generico de personagem. "
                              "Ignorado se --prompt-bruto for usado junto.")
    parser.add_argument("--negativo", help="Acrescenta termos extras ao prompt negativo padrao")
    parser.add_argument("--model", default=MODELO_RAPIDO)
    args = parser.parse_args()

    if args.prompt_bruto:
        positivo = args.pedido
        nome = args.nome or slugify(args.pedido)
    elif args.item:
        print("Perguntando ao Ollama como montar o prompt de imagem (modo item)...")
        plano = montar_prompt_item_ollama(args.pedido)
        positivo = plano["positivo"]
        # Nao confia so no Ollama pra lembrar "no humans" -- forca no codigo.
        if "no humans" not in positivo.lower():
            positivo = "no humans, solo, " + positivo
        args.negativo = (NEG_ITEM_BASE + ", " + args.negativo) if args.negativo else NEG_ITEM_BASE
        nome = args.nome or plano.get("nome_arquivo") or slugify(args.pedido)
    else:
        print("Perguntando ao Ollama como montar o prompt de imagem...")
        plano = montar_prompt_ollama(args.pedido)
        positivo = plano["positivo"]
        nome = args.nome or plano.get("nome_arquivo") or slugify(args.pedido)
    seed = args.seed if args.seed is not None else random.randint(0, 2**31 - 1)

    print(f"Prompt: {positivo}\nSeed: {seed}\nResolucao: {args.largura}x{args.altura}")

    if args.referencia:
        print(f"Usando referencia de personagem (IPAdapter FaceID): {args.referencia}")
        workflow = carregar_workflow(WORKFLOW_FACEID_PATH)
        os.makedirs(COMFYUI_INPUT_DIR, exist_ok=True)
        nome_ref = f"ref_{slugify(nome)}{os.path.splitext(args.referencia)[1]}"
        shutil.copy(args.referencia, os.path.join(COMFYUI_INPUT_DIR, nome_ref))
        no(workflow, "LoadImage")["inputs"]["image"] = nome_ref
    else:
        workflow = carregar_workflow(WORKFLOW_PATH)

    # identifica os nodes positivo/negativo pelo texto default (negativo sempre comeca com "lowres")
    for node in workflow.values():
        if node["class_type"] != "CLIPTextEncode":
            continue
        if node["inputs"]["text"].startswith("lowres"):
            if args.negativo:
                node["inputs"]["text"] = node["inputs"]["text"] + ", " + args.negativo
        else:
            node["inputs"]["text"] = positivo
    no(workflow, "EmptyLatentImage")["inputs"]["width"] = args.largura
    no(workflow, "EmptyLatentImage")["inputs"]["height"] = args.altura
    no(workflow, "KSampler")["inputs"]["seed"] = seed

    print("Enviando pro ComfyUI...")
    resposta = enviar_para_comfyui(workflow)
    prompt_id = resposta["prompt_id"]
    print(f"prompt_id={prompt_id} -- aguardando geracao...")

    imagens = esperar_resultado(prompt_id)
    destino_dir = MAPAS_DIR if args.mapa else IMAGENS_DIR
    os.makedirs(destino_dir, exist_ok=True)

    for i, info in enumerate(imagens):
        ext = os.path.splitext(info["filename"])[1] or ".png"
        nome_final = f"{nome}.png" if i == 0 else f"{nome}_{i}{ext}"
        destino = os.path.join(destino_dir, nome_final)
        baixar_imagem(info, destino)
        print(f"Salvo em: {destino}")


if __name__ == "__main__":
    main()
