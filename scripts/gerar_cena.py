"""
Uso: python gerar_cena.py "grupo encontra a entrada da masmorra do andar 1" [opcoes]

Gera uma cena/quest completa pro Aincrad RPG a partir de uma ideia curta,
usando o Ollama local (qwen2.5:14b), com o guia de sistema
(docs/guia_sistema_aincrad.md) e o estado atual da campanha
(docs/historia_campanha.md -- dia 10, andar 1, pre-chefe) como referencia.
Salva o .md em cenas/.

Opcoes uteis:
  --andar 1                forca o andar (default: segue o estado atual da campanha)
  --local "Cidade do Inicio"
  --tipo combate           exploracao | combate | social | chefe
  --npcs "Fulano, Beltrano" NPCs ja existentes envolvidos
  --revisar                segunda passada com deepseek-r1:14b pra revisar coerencia
  --model qwen2.5:14b      troca o modelo principal
"""
import argparse
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from ollama_client import (
    MODELO_RAPIDO, MODELO_REVISOR, carregar_guia_sistema, carregar_historia_campanha,
    perguntar_json, revisar_json, slugify,
)

CENAS_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "cenas")

CATEGORIAS_MUSICA = ["01_abertura", "02_ambiente", "03_combate", "04_combate_epico", "05_combate_boss", "06_cidade"]

SCHEMA = """Responda APENAS com um objeto JSON valido, sem markdown, sem comentarios,
com exatamente estes campos:
{
  "titulo": "string",
  "andar": numero inteiro ou null,
  "local": "string (cidade/zona segura, campo ou dungeon especifico)",
  "tipo": "exploracao | combate | social | chefe",
  "npcs_envolvidos": ["string", ...],
  "objetivo": "string",
  "gancho": "string",
  "beats": ["string", ...] (3 a 6 passos narrativos em ordem),
  "testes_sugeridos": [{"atributo": "Corpo|Reflexo|Conhecimento|Espirito|Tecnica", "contexto": "string"}],
  "encontro": "string (monstros, dificuldade -- vazio se nao houver combate)",
  "recompensas": "string (Col, cristais, itens, XP)",
  "humor_musical": "uma das categorias: 01_abertura, 02_ambiente, 03_combate, 04_combate_epico, 05_combate_boss, 06_cidade -- ou um nome livre se nenhuma servir",
  "prompt_trilha": "string em ingles, prompt pronto pro MusicGen (instrumental, no vocals)",
  "prompt_visual": "string em ingles, prompt pronto pra geracao de imagem/video (Wan2.1 i2v), descrevendo cena, iluminacao, camera"
}"""


def montar_system(guia, historia):
    return f"""Voce e mestre de RPG para a campanha "Sword Art Online: The Perfect Chaos"
(sistema Aincrad RPG, PBTA). Use este guia de sistema como referencia canonica:

{guia}

Contexto atual da campanha (ponto de partida se o pedido nao especificar andar/momento):

{historia}

Dado o pedido do usuario (uma ideia curta de cena/quest, em portugues), gere uma cena
jogavel completa, ancorada no tom de Sword Art Online (medo real de morte, tensao,
guildas, escassez de recursos) -- evite cliches genericos de fantasia. Os
"testes_sugeridos" devem usar o sistema 2d6+atributo do guia. "humor_musical" deve
preferir uma das categorias ja existentes em musicas/ quando fizer sentido.

{SCHEMA}"""


def render_markdown(d):
    npcs = d.get("npcs_envolvidos") or []
    npcs_str = "[" + ", ".join(npcs) + "]" if npcs else "[]"
    beats = d.get("beats") or []
    beats_str = "\n".join(f"{i}. {b}" for i, b in enumerate(beats, 1)) if beats else "1. "
    testes = d.get("testes_sugeridos") or []
    testes_str = "\n".join(f"- 2d6 + {t.get('atributo', '')} — {t.get('contexto', '')}" for t in testes) if testes else "-"
    andar = d.get("andar")
    andar_str = "" if andar in (None, "") else str(andar)

    return f"""---
titulo: {d.get('titulo', '')}
andar: {andar_str}
local: {d.get('local', '')}
tipo: {d.get('tipo', '')}
npcs_envolvidos: {npcs_str}
humor_musical: {d.get('humor_musical', '')}
---

## Objetivo

{d.get('objetivo', '')}

## Gancho

{d.get('gancho', '')}

## Estrutura em beats

{beats_str}

## Testes sugeridos

{testes_str}

## Encontro (se aplicável)

{d.get('encontro', '') or '-'}

## Recompensas

{d.get('recompensas', '')}

## Prompt sugerido — trilha sonora

{d.get('prompt_trilha', '')}

## Prompt sugerido — visual/vídeo (ComfyUI)

{d.get('prompt_visual', '')}
"""


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("pedido", help="Ideia curta da cena/quest, em portugues")
    parser.add_argument("--andar", type=int)
    parser.add_argument("--local")
    parser.add_argument("--tipo", choices=["exploracao", "combate", "social", "chefe"])
    parser.add_argument("--npcs", help="Lista separada por virgula de NPCs ja existentes")
    parser.add_argument("--revisar", action="store_true")
    parser.add_argument("--model", default=MODELO_RAPIDO)
    args = parser.parse_args()

    print("Carregando guia de sistema e historia da campanha...")
    guia = carregar_guia_sistema()
    historia = carregar_historia_campanha()
    system = montar_system(guia, historia)

    contexto_extra = []
    if args.andar is not None:
        contexto_extra.append(f"Andar: {args.andar}")
    if args.local:
        contexto_extra.append(f"Local: {args.local}")
    if args.tipo:
        contexto_extra.append(f"Tipo forcado: {args.tipo}")
    if args.npcs:
        contexto_extra.append(f"NPCs ja existentes envolvidos: {args.npcs}")
    pedido = args.pedido
    if contexto_extra:
        pedido += "\n\n" + "\n".join(contexto_extra)

    print(f"Perguntando ao Ollama ({args.model})...")
    dados = perguntar_json(system, pedido, model=args.model)

    if args.revisar:
        print(f"Revisando com {MODELO_REVISOR}...")
        dados = revisar_json(dados, "Verifique coerencia com o estado atual da campanha (andar/momento) e com o sistema 2d6+atributo.")

    titulo = dados.get("titulo") or args.pedido
    os.makedirs(CENAS_DIR, exist_ok=True)
    caminho = os.path.join(CENAS_DIR, f"{slugify(titulo)}.md")
    with open(caminho, "w", encoding="utf-8") as f:
        f.write(render_markdown(dados))

    print(f"\nCena salva em: {caminho}")
    prompt_trilha = dados.get("prompt_trilha")
    if prompt_trilha:
        print("\nProximo passo: gerar a trilha/SFX sugerida, em C:\\AI\\AudioCraft:")
        print(f'  venv\\Scripts\\python.exe gerar_sao.py "{prompt_trilha}"')


if __name__ == "__main__":
    main()
