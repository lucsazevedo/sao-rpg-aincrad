"""
Uso: python gerar_monstro.py "predador nas ruinas cobertas de musgo perto da masmorra" [opcoes]

Gera uma ficha de monstro/criatura pro Aincrad RPG a partir de uma ideia curta,
usando o Ollama local (qwen2.5:14b), o guia de sistema
(docs/guia_sistema_aincrad.md) e, se existir, o bestiario canonico do andar
(docs/guia_bestiario_andarN.md -- feito com pesquisa real na SAO Fandom wiki
pro andar 1). Salva o .md em monstros/.

Para monstros CANONICOS (que existem na wiki/anime), prefira escrever a ficha
a mao usando a pesquisa real em vez de gerar por aqui -- o Ollama pode
inventar detalhes que nao batem com a fonte. Este gerador e pra criaturas
NOVAS/homebrew.

Opcoes uteis:
  --andar 1                usa o bestiario canonico desse andar como referencia extra, se existir
  --tipo "planta"           besta | planta | humanoide | morto-vivo | construto | chefe_de_andar
  --ameaca elite            fraco | comum | forte | elite | chefe
  --revisar                 segunda passada com deepseek-r1:14b pra revisar coerencia
  --model qwen2.5:14b       troca o modelo principal
"""
import argparse
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from ollama_client import (
    DOCS_DIR, MODELO_RAPIDO, MODELO_REVISOR, carregar_guia_sistema, carregar_historia_campanha,
    perguntar_json, revisar_json, slugify,
)

MONSTROS_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "monstros")

SCHEMA = """Responda APENAS com um objeto JSON valido, sem markdown, sem comentarios,
com exatamente estes campos:
{
  "nome": "string",
  "tipo": "besta | planta | humanoide | morto-vivo | construto | chefe_de_andar",
  "andar": numero inteiro ou null,
  "local": "campo | dungeon/labirinto | dungeon_oculta | cidade",
  "nivel_ameaca": "fraco | comum | forte | elite | chefe",
  "golpes_para_derrotar": "string ou numero (ex: 3, ou '4x6-8' pra chefe com barras -- ver tabela do guia)",
  "atributo_fraqueza": "string (ex: golpe preciso na nuca, garganta exposta)",
  "resistencias": ["string", ...],
  "vulnerabilidades": ["string", ...],
  "aparencia": "string",
  "comportamento": "string (passivo/agressivo, padrao de movimento e ataque)",
  "ataques": ["string", ...],
  "fraqueza": "string",
  "drops": [{"item": "string", "chance": "string (ex: '100%', '25%')"}],
  "notas_mestre": "string"
}"""


def montar_system(guia, historia, bestiario):
    extra = f"\n\nBestiario canonico de referencia (monstros que ja existem, use como padrao de tom/poder):\n\n{bestiario}" if bestiario else ""
    return f"""Voce e mestre e criador de criaturas para a campanha "Sword Art Online: The
Perfect Chaos" (sistema Aincrad RPG, PBTA). Use este guia de sistema como referencia
canonica:

{guia}

Contexto atual da campanha:

{historia}{extra}

Dado o pedido do usuario (uma ideia curta de monstro, em portugues), gere uma ficha
completa e especifica, ancorada no tom de Sword Art Online (bestiario de VRMMORPG,
com nivel de ameaca condizente com o andar) -- evite cliches genericos de fantasia.
Este e um monstro NOVO/homebrew, nao precisa corresponder a nenhuma criatura real do
anime, mas deve ter o mesmo "peso" e credibilidade dos exemplos canonicos. Use a escala
de "golpes_para_derrotar" do guia de sistema (fraco=1-2, comum=3-4, forte=5-7, elite=8-10,
chefe=4 barras de 6-8). Sempre preencha resistencias/vulnerabilidades e uma tabela de
drops com chance em % -- este RPG e jogado em stream e no Foundry VTT, entao a ficha
precisa ser jogavel direto na mesa, sem o mestre ter que inventar numeros na hora.

{SCHEMA}"""


def render_markdown(d):
    ataques = d.get("ataques") or []
    ataques_str = "\n".join(f"- {a}" for a in ataques) if ataques else "-"
    resistencias = d.get("resistencias") or []
    resistencias_str = "[" + ", ".join(resistencias) + "]" if resistencias else "[]"
    vulnerabilidades = d.get("vulnerabilidades") or []
    vulnerabilidades_str = "[" + ", ".join(vulnerabilidades) + "]" if vulnerabilidades else "[]"
    andar = d.get("andar")
    andar_str = "" if andar in (None, "") else str(andar)
    drops = d.get("drops") or []
    drops_str = "\n".join(f"| {dr.get('item', '')} | {dr.get('chance', '')} |" for dr in drops)
    if not drops_str:
        drops_str = "| Col (quantidade) | 100% |\n| XP (quantidade) | 100% |"

    return f"""---
nome: {d.get('nome', '')}
tipo: {d.get('tipo', '')}
andar: {andar_str}
local: {d.get('local', '')}
nivel_ameaca: {d.get('nivel_ameaca', '')}
golpes_para_derrotar: {d.get('golpes_para_derrotar', '')}
atributo_fraqueza: {d.get('atributo_fraqueza', '')}
resistencias: {resistencias_str}
vulnerabilidades: {vulnerabilidades_str}
imagem:
canonico: nao
fonte:
---

## Aparência

{d.get('aparencia', '')}

## Comportamento

{d.get('comportamento', '')}

## Ataques

{ataques_str}

## Fraqueza / ponto fraco

{d.get('fraqueza', '')}

## Tabela de drop

| Item | Chance |
|---|---|
{drops_str}

## Notas para o mestre

{d.get('notas_mestre', '')}
"""


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("pedido", help="Ideia curta do monstro, em portugues")
    parser.add_argument("--andar", type=int, default=1)
    parser.add_argument("--tipo")
    parser.add_argument("--ameaca")
    parser.add_argument("--revisar", action="store_true")
    parser.add_argument("--model", default=MODELO_RAPIDO)
    args = parser.parse_args()

    print("Carregando guia de sistema e historia da campanha...")
    guia = carregar_guia_sistema()
    historia = carregar_historia_campanha()

    bestiario = ""
    caminho_bestiario = os.path.join(DOCS_DIR, f"guia_bestiario_andar{args.andar}.md")
    if os.path.exists(caminho_bestiario):
        with open(caminho_bestiario, "r", encoding="utf-8") as f:
            bestiario = f.read()

    system = montar_system(guia, historia, bestiario)

    contexto_extra = [f"Andar: {args.andar}"]
    if args.tipo:
        contexto_extra.append(f"Tipo forcado: {args.tipo}")
    if args.ameaca:
        contexto_extra.append(f"Nivel de ameaca forcado: {args.ameaca}")
    pedido = args.pedido + "\n\n" + "\n".join(contexto_extra)

    print(f"Perguntando ao Ollama ({args.model})...")
    dados = perguntar_json(system, pedido, model=args.model)

    if args.revisar:
        print(f"Revisando com {MODELO_REVISOR}...")
        dados = revisar_json(dados, "Verifique se o nivel de ameaca e condizente com o andar e com o bestiario canonico de referencia.")

    nome = dados.get("nome") or args.pedido
    os.makedirs(MONSTROS_DIR, exist_ok=True)
    caminho = os.path.join(MONSTROS_DIR, f"{slugify(nome)}.md")
    with open(caminho, "w", encoding="utf-8") as f:
        f.write(render_markdown(dados))

    print(f"\nMonstro salvo em: {caminho}")


if __name__ == "__main__":
    main()
