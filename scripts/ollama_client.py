"""Helper compartilhado pelos scripts gerar_npc.py / gerar_arma.py / gerar_cena.py.

So usa a stdlib (urllib/json/re) -- nenhuma dependencia extra, roda com
qualquer Python instalado (nao precisa da venv do AudioCraft nem de nada
do ComfyUI). Requer o Ollama local rodando em http://localhost:11434.
"""
import json
import os
import re
import time
import unicodedata
import urllib.error
import urllib.request

OLLAMA_URL = "http://localhost:11434/api/generate"
MODELO_RAPIDO = "qwen2.5:14b"
MODELO_REVISOR = "deepseek-r1:14b"

DOCS_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "docs")


def carregar_guia_sistema():
    caminho = os.path.join(DOCS_DIR, "guia_sistema_aincrad.md")
    with open(caminho, "r", encoding="utf-8") as f:
        return f.read()


def carregar_historia_campanha():
    caminho = os.path.join(DOCS_DIR, "historia_campanha.md")
    with open(caminho, "r", encoding="utf-8") as f:
        return f.read()


def carregar_bestiario(andar=1):
    caminho = os.path.join(DOCS_DIR, f"guia_bestiario_andar{andar}.md")
    with open(caminho, "r", encoding="utf-8") as f:
        return f.read()


def chamar_ollama(system, user, model=MODELO_RAPIDO, temperature=0.6, timeout=240):
    payload = {
        "model": model,
        "system": system,
        "prompt": user,
        "stream": False,
        "options": {"temperature": temperature},
    }
    req = urllib.request.Request(
        OLLAMA_URL,
        data=json.dumps(payload).encode("utf-8"),
        headers={"Content-Type": "application/json"},
    )
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            data = json.loads(resp.read().decode("utf-8"))
    except urllib.error.URLError as e:
        raise RuntimeError(
            f"Nao consegui falar com o Ollama em {OLLAMA_URL} ({e}). "
            "Confira se o Ollama esta rodando (`ollama list` no terminal)."
        ) from e
    return data["response"]


def extrair_json(texto):
    # deepseek-r1 costuma prefixar a resposta com um bloco <think>...</think>
    sem_think = re.sub(r"<think>.*?</think>", "", texto, flags=re.DOTALL).strip()
    sem_cercas = re.sub(r"^```(json)?|```$", "", sem_think, flags=re.MULTILINE).strip()
    match = re.search(r"\{.*\}", sem_cercas, re.DOTALL)
    if not match:
        raise ValueError(f"Ollama nao retornou JSON valido:\n{texto}")
    return json.loads(match.group(0))


def perguntar_json(system, user, model=MODELO_RAPIDO, temperature=0.6):
    t0 = time.time()
    texto = chamar_ollama(system, user, model=model, temperature=temperature)
    dados = extrair_json(texto)
    print(f"  ({model}: {time.time()-t0:.1f}s)")
    return dados


def revisar_json(dados, instrucoes_revisao, model=MODELO_REVISOR):
    """Segunda passada de revisao/coerencia com o modelo de raciocinio.
    Recebe o JSON ja gerado e pede a mesma estrutura de volta, corrigida."""
    system = (
        "Voce e um revisor de lore e consistencia para uma mesa de RPG de Sword Art "
        "Online (sistema Aincrad RPG). Recebera uma ficha em JSON e deve revisa-la: "
        "corrija inconsistencias com o guia de sistema, melhore a coerencia interna "
        "e o tom (VRMMORPG, medo real de morte, sem cliches genericos de fantasia), "
        "mas mantenha a mesma estrutura de campos e a mesma lingua (portugues). "
        f"{instrucoes_revisao}\n\n"
        "Responda APENAS com o objeto JSON revisado, sem markdown, sem comentarios, "
        "sem explicar o que mudou."
    )
    user = json.dumps(dados, ensure_ascii=False, indent=2)
    return perguntar_json(system, user, model=model, temperature=0.4)


def slugify(texto):
    sem_acento = unicodedata.normalize("NFKD", texto).encode("ascii", "ignore").decode("ascii")
    texto = re.sub(r"[^a-zA-Z0-9]+", "_", sem_acento.strip().lower()).strip("_")
    return texto[:50] or "sem_nome"


def escrever_lista_yaml(valores):
    if not valores:
        return "[]"
    return "\n" + "\n".join(f"  - {v}" for v in valores)
