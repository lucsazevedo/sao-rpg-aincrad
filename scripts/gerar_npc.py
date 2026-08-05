"""
Uso: python gerar_npc.py "guarda veterano da cidade de Algade, andar 50" [opcoes]

Gera uma ficha completa de NPC pro Aincrad RPG a partir de uma ideia curta,
usando o Ollama local (qwen2.5:14b) com o guia de sistema em
docs/guia_sistema_aincrad.md como referencia. Salva o .md em npcs/.

Opcoes uteis:
  --andar 50               forca o andar
  --profissao Ferreiro     forca a profissao
  --arma "Espada Longa"    forca a arma
  --papel inimigo          aliado | inimigo | neutro | vendedor | chefe_de_andar
  --revisar                roda uma segunda passada com deepseek-r1:14b pra revisar coerencia
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

NPCS_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "npcs")

SCHEMA = """Responda APENAS com um objeto JSON valido, sem markdown, sem comentarios,
com exatamente estes campos:
{
  "nome": "string",
  "papel": "aliado | inimigo | neutro | vendedor | chefe_de_andar",
  "andar": numero inteiro ou null,
  "localizacao": "string (cidade/zona ou area)",
  "profissao": "uma das 16 profissoes do guia, ou 'nenhuma'",
  "arma": "uma das 22 armas do guia, ou 'nenhuma'",
  "guilda": "string, pode ser vazio",
  "atributos": {"corpo": int, "reflexo": int, "conhecimento": int, "espirito": int, "tecnica": int},
  "tags": ["string", ...],
  "aparencia": "string",
  "personalidade": "string",
  "historia": "string",
  "motivacoes": "string",
  "gancho_aventura": "string",
  "dialogo_exemplo": ["string", "string", "string"],
  "combate": "string (skills usadas, nivel de ameaca, recompensas ao derrotar -- vazio se nao for hostil)"
}"""


def montar_system(guia, historia):
    return f"""Voce e mestre e escritor de lore para a campanha "Sword Art Online: The
Perfect Chaos" (sistema Aincrad RPG, PBTA). Use este guia de sistema como referencia
canonica:

{guia}

Contexto atual da campanha (ponto de partida se o pedido nao especificar andar/momento):

{historia}

Dado o pedido do usuario (uma ideia curta de NPC, em portugues), gere uma ficha completa
e especifica, ancorada no tom de Sword Art Online (VRMMORPG, medo real de morte, guildas,
Col como moeda, level) -- evite cliches genericos de fantasia.

Os atributos seguem a distribuicao -2/-1/-1/-1/0 tipica de personagem jogador para NPCs
comuns; NPCs fortes (chefes de andar, veteranos) podem ter valores bem mais altos no
atributo principal (ate +3 ou +4). Use profissao e arma da lista do guia quando fizer
sentido pro conceito; use "nenhuma" se o pedido nao sugerir nada.

{SCHEMA}"""


def render_markdown(d):
    atrib = d.get("atributos", {}) or {}
    tags = d.get("tags") or []
    tags_str = "[" + ", ".join(tags) + "]" if tags else "[]"
    dialogo = d.get("dialogo_exemplo") or []
    dialogo_str = "\n".join(f"- {linha}" for linha in dialogo) if dialogo else "-"
    andar = d.get("andar")
    andar_str = "" if andar in (None, "") else str(andar)

    return f"""---
nome: {d.get('nome', '')}
andar: {andar_str}
localizacao: {d.get('localizacao', '')}
papel: {d.get('papel', '')}
profissao: {d.get('profissao', '')}
arma: {d.get('arma', '')}
guilda: {d.get('guilda', '')}
atributos:
  corpo: {atrib.get('corpo', '')}
  reflexo: {atrib.get('reflexo', '')}
  conhecimento: {atrib.get('conhecimento', '')}
  espirito: {atrib.get('espirito', '')}
  tecnica: {atrib.get('tecnica', '')}
tags: {tags_str}
imagem:
---

## Aparência

{d.get('aparencia', '')}

## Personalidade

{d.get('personalidade', '')}

## História

{d.get('historia', '')}

## Motivações

{d.get('motivacoes', '')}

## Gancho de aventura

{d.get('gancho_aventura', '')}

## Diálogo de exemplo

{dialogo_str}

## Combate (se aplicável)

{d.get('combate', '') or '-'}
"""


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("pedido", help="Ideia curta do NPC, em portugues")
    parser.add_argument("--andar", type=int)
    parser.add_argument("--profissao")
    parser.add_argument("--arma")
    parser.add_argument("--papel")
    parser.add_argument("--revisar", action="store_true", help="Segunda passada com deepseek-r1:14b")
    parser.add_argument("--model", default=MODELO_RAPIDO)
    args = parser.parse_args()

    print("Carregando guia de sistema...")
    guia = carregar_guia_sistema()
    historia = carregar_historia_campanha()
    system = montar_system(guia, historia)

    contexto_extra = []
    if args.andar is not None:
        contexto_extra.append(f"Andar: {args.andar}")
    if args.profissao:
        contexto_extra.append(f"Profissao forcada: {args.profissao}")
    if args.arma:
        contexto_extra.append(f"Arma forcada: {args.arma}")
    if args.papel:
        contexto_extra.append(f"Papel forcado: {args.papel}")
    pedido = args.pedido
    if contexto_extra:
        pedido += "\n\n" + "\n".join(contexto_extra)

    print(f"Perguntando ao Ollama ({args.model})...")
    dados = perguntar_json(system, pedido, model=args.model)

    if args.revisar:
        print(f"Revisando com {MODELO_REVISOR}...")
        dados = revisar_json(dados, "Verifique se profissao/arma/atributos batem com o guia de sistema.")

    nome = dados.get("nome") or args.pedido
    os.makedirs(NPCS_DIR, exist_ok=True)
    caminho = os.path.join(NPCS_DIR, f"{slugify(nome)}.md")
    with open(caminho, "w", encoding="utf-8") as f:
        f.write(render_markdown(dados))

    print(f"\nNPC salvo em: {caminho}")
    print("Proximo passo: quer uma trilha-tema pra ele? Rode em C:\\AI\\AudioCraft:")
    print(f'  venv\\Scripts\\python.exe gerar_sao.py "tema ambiente para o NPC {nome}"')


if __name__ == "__main__":
    main()
