"""
Uso: python gerar_arma.py "rapieira lendaria de um mestre de esgrima do andar 30" [opcoes]

Gera uma ficha de arma/item pro Aincrad RPG a partir de uma ideia curta,
usando o Ollama local (qwen2.5:14b) com o guia de sistema em
docs/guia_sistema_aincrad.md (as 19 armas, raridade de crafting). Salva o
.md em armas/.

Opcoes uteis:
  --tipo Katana            forca o tipo de arma (uma das 19)
  --raridade Epico         Comum | Incomum | Raro | Epico | Lendario
  --andar 30               andar recomendado
  --revisar                segunda passada com deepseek-r1:14b pra revisar coerencia
  --model qwen2.5:14b      troca o modelo principal
"""
import argparse
import os
import sys
import unicodedata

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from ollama_client import (
    MODELO_RAPIDO, MODELO_REVISOR, carregar_guia_sistema, carregar_historia_campanha,
    perguntar_json, revisar_json, slugify,
)

ARMAS_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "armas")

# Atributo principal de cada uma das 19 armas (SAO_RPG_5e.md, Secao 7) --
# fixo aqui pra corrigir determinaticamente qualquer erro do LLM, em vez de
# confiar nele pra cruzar a tabela sozinho toda vez.
# Atualizado na conversao pra D&D 5e (era Corpo/Reflexo/Conhecimento/
# Espirito/Tecnica -- ver Secao 66 do SAO_RPG_5e.md pra regra de conversao).
ATRIBUTO_POR_ARMA = {
    "arco e flecha": "Destreza",
    "adagas": "Destreza",
    "adagas de arremesso": "Destreza",
    "besta": "Destreza",
    "chakrams": "Destreza",
    "chicote": "Inteligencia",
    "escudo e espada": "Forca",
    "espada longa": "Forca",
    "foice": "Sabedoria",
    "katana": "Sabedoria",
    "lanca": "Destreza",
    "machado": "Forca",
    "martelo": "Forca",
    "pa": "Forca",
    "rapieira": "Destreza",
    "bastao": "Sabedoria",
    "corrente com peso": "Destreza",
    "manopla": "Forca",
    "leque": "Sabedoria",
}


def normalizar(texto):
    sem_acento = unicodedata.normalize("NFKD", texto).encode("ascii", "ignore").decode("ascii")
    return sem_acento.strip().lower()

SCHEMA = """Responda APENAS com um objeto JSON valido, sem markdown, sem comentarios,
com exatamente estes campos:
{
  "nome": "string",
  "tipo": "uma das 22 armas do guia (ex: Espada Longa, Katana, Chakrams...)",
  "atributo_principal": "Corpo | Reflexo | Conhecimento | Espirito | Tecnica (o mesmo do tipo, conforme o guia)",
  "raridade": "Comum | Incomum | Raro | Epico | Lendario",
  "andar_recomendado": numero inteiro ou null,
  "requisito_nivel": numero inteiro ou null,
  "requisito_atributo": "string, ex: 'Corpo 2+', ou vazio",
  "aparencia": "string",
  "lore": "string (origem, quem forjou, historia)",
  "skills_exclusivas": ["string", ...],
  "efeito_especial": "string, vazio se raridade for Comum ou Incomum",
  "como_obter": "string (drop de monstro, crafting, missao, chefe...)"
}"""


def montar_system(guia, historia):
    return f"""Voce e mestre e criador de itens para a campanha "Sword Art Online: The
Perfect Chaos" (sistema Aincrad RPG, PBTA). Use este guia de sistema como referencia
canonica (preste atencao especial na lista das 22 armas com seus atributos principais,
e na escala de raridade de crafting):

{guia}

Contexto atual da campanha (se o pedido nao especificar andar, assuma equipamento
condizente com este momento):

{historia}

Dado o pedido do usuario (uma ideia curta de arma/item, em portugues), gere uma
ficha completa e especifica, ancorada no tom de Sword Art Online -- evite
cliches genericos de fantasia. O "atributo_principal" DEVE corresponder ao tipo
de arma escolhido, conforme a tabela do guia. Quanto maior a raridade, maior o
efeito especial (Comum/Incomum praticamente sem efeito magico; Raro+ pode
alterar atributos ou conceder efeitos unicos). Itens Epico/Lendario devem ser
raros mesmo no andar 1 -- a maioria dos jogadores ainda usa equipamento Comum/Incomum
neste ponto da historia.

{SCHEMA}"""


def render_markdown(d):
    skills = d.get("skills_exclusivas") or []
    skills_str = "\n".join(f"- {s}" for s in skills) if skills else "-"

    return f"""---
nome: {d.get('nome', '')}
tipo: {d.get('tipo', '')}
atributo_principal: {d.get('atributo_principal', '')}
raridade: {d.get('raridade', '')}
andar_recomendado: {d.get('andar_recomendado', '') if d.get('andar_recomendado') is not None else ''}
requisito_nivel: {d.get('requisito_nivel', '') if d.get('requisito_nivel') is not None else ''}
requisito_atributo: {d.get('requisito_atributo', '')}
---

## Aparência

{d.get('aparencia', '')}

## Lore / Origem

{d.get('lore', '')}

## Skills exclusivas do tipo

{skills_str}

## Efeito especial

{d.get('efeito_especial', '') or '-'}

## Como obter

{d.get('como_obter', '')}
"""


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("pedido", help="Ideia curta da arma/item, em portugues")
    parser.add_argument("--tipo")
    parser.add_argument("--raridade")
    parser.add_argument("--andar", type=int)
    parser.add_argument("--revisar", action="store_true")
    parser.add_argument("--model", default=MODELO_RAPIDO)
    args = parser.parse_args()

    print("Carregando guia de sistema...")
    guia = carregar_guia_sistema()
    historia = carregar_historia_campanha()
    system = montar_system(guia, historia)

    contexto_extra = []
    if args.tipo:
        contexto_extra.append(f"Tipo forcado: {args.tipo}")
    if args.raridade:
        contexto_extra.append(f"Raridade forcada: {args.raridade}")
    if args.andar is not None:
        contexto_extra.append(f"Andar recomendado: {args.andar}")
    pedido = args.pedido
    if contexto_extra:
        pedido += "\n\n" + "\n".join(contexto_extra)

    print(f"Perguntando ao Ollama ({args.model})...")
    dados = perguntar_json(system, pedido, model=args.model)

    correto = ATRIBUTO_POR_ARMA.get(normalizar(dados.get("tipo", "")))
    if correto and dados.get("atributo_principal") != correto:
        print(f"  corrigindo atributo_principal: '{dados.get('atributo_principal')}' -> '{correto}' (tabela do guia)")
        dados["atributo_principal"] = correto

    if args.revisar:
        print(f"Revisando com {MODELO_REVISOR}...")
        dados = revisar_json(dados, "Verifique se atributo_principal bate com o tipo de arma, conforme o guia de sistema.")

    nome = dados.get("nome") or args.pedido
    os.makedirs(ARMAS_DIR, exist_ok=True)
    caminho = os.path.join(ARMAS_DIR, f"{slugify(nome)}.md")
    with open(caminho, "w", encoding="utf-8") as f:
        f.write(render_markdown(dados))

    print(f"\nArma salva em: {caminho}")


if __name__ == "__main__":
    main()
