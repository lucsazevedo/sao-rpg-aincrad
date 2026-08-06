#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Uso: python scripts/subir_github.py [opcoes]

Junta tudo que voce criou/mudou no projeto, comita e manda pro GitHub --
sem precisar lembrar `git add` / `git commit` / `git push` toda vez.

Detalhes:
  - So sobe o que o .gitignore ja deixa passar (musicas/, efeitos_sonoros/,
    __pycache__/, *.bak, .env etc. continuam de fora, como sempre).
  - Antes de comitar, escaneia o que foi staged procurando por cara de
    segredo (senha, chave, token, .env). Se achar, para e avisa -- nao
    manda nada pro publico sem voce confirmar.
  - Mensagem de commit e' gerada sozinha (lista o que mudou por pasta), a
    nao ser que voce passe --mensagem "sua mensagem".

Opcoes:
  --mensagem "texto"   usa essa mensagem em vez da automatica
  --dry-run            so mostra o que seria comitado, nao faz nada
  --sem-push           comita local mas nao manda pro GitHub
  --forcar             ignora o alerta de possivel segredo (use com cuidado)
"""
import argparse
import datetime
import os
import re
import subprocess
import sys

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

PADROES_SUSPEITOS = [
    re.compile(r"(?i)service_role"),
    re.compile(r"(?i)\bpassword\s*=\s*['\"]?[^\s'\"]{4,}"),
    re.compile(r"(?i)\bsecret\s*=\s*['\"]?[^\s'\"]{4,}"),
    re.compile(r"-----BEGIN [A-Z ]*PRIVATE KEY-----"),
    re.compile(r"\bsk-[A-Za-z0-9]{16,}"),
    re.compile(r"\bghp_[A-Za-z0-9]{20,}"),
    re.compile(r"\bAKIA[0-9A-Z]{16}\b"),
]


def rodar(args, **kw):
    return subprocess.run(
        args, cwd=RAIZ, text=True, encoding="utf-8", errors="replace",
        capture_output=True, **kw,
    )


def git(*args, checar=True):
    r = rodar(["git"] + list(args))
    if checar and r.returncode != 0:
        print(f"Erro rodando: git {' '.join(args)}\n{r.stderr}", file=sys.stderr)
        sys.exit(1)
    return r.stdout.strip()


def branch_atual():
    return git("rev-parse", "--abbrev-ref", "HEAD")


def agrupar_por_pasta(linhas_status):
    """linhas_status: saida de `git status --porcelain`. Agrupa por pasta de
    topo pra gerar uma mensagem de commit legivel."""
    grupos = {}
    novos, apagados = [], []
    for linha in linhas_status:
        if not linha.strip():
            continue
        estado, caminho = linha[:2], linha[3:].strip()
        if "->" in caminho:  # rename
            caminho = caminho.split("->")[-1].strip()
        pasta = caminho.split("/")[0] if "/" in caminho else "(raiz)"
        grupos.setdefault(pasta, 0)
        grupos[pasta] += 1
        if "A" in estado or "?" in estado:
            novos.append(caminho)
        elif "D" in estado:
            apagados.append(caminho)
    return grupos, novos, apagados


def montar_mensagem(grupos, novos, apagados):
    agora = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    resumo = ", ".join(f"{pasta} ({n})" for pasta, n in sorted(grupos.items()))
    linhas = [f"Atualizacao automatica -- {agora}", "", f"Mudou em: {resumo}"]
    if novos:
        linhas.append("")
        linhas.append("Novos:")
        linhas += [f"  - {c}" for c in novos[:20]]
        if len(novos) > 20:
            linhas.append(f"  ... e mais {len(novos) - 20}")
    if apagados:
        linhas.append("")
        linhas.append("Removidos:")
        linhas += [f"  - {c}" for c in apagados[:20]]
    return "\n".join(linhas)


def escanear_segredos():
    """Roda no diff ja staged. Devolve lista de (arquivo, padrao) suspeitos."""
    diff = git("diff", "--cached", "-U0")
    achados = []
    arquivo_atual = None
    for linha in diff.splitlines():
        if linha.startswith("+++ b/"):
            arquivo_atual = linha[6:]
            continue
        if not linha.startswith("+") or linha.startswith("+++"):
            continue
        for padrao in PADROES_SUSPEITOS:
            if padrao.search(linha):
                achados.append((arquivo_atual or "?", padrao.pattern))
    return achados


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--mensagem", "-m", help="mensagem de commit (senao gera automatica)")
    ap.add_argument("--dry-run", action="store_true", help="so mostra o que seria feito")
    ap.add_argument("--sem-push", action="store_true", help="comita mas nao empurra pro GitHub")
    ap.add_argument("--forcar", action="store_true", help="ignora alerta de possivel segredo")
    args = ap.parse_args()

    status = git("status", "--porcelain").splitlines()
    if not status:
        print("Nada mudou desde o ultimo commit. Nada a subir.")
        return

    if any(re.match(r"^.. \.env($| )", l) or l.strip().endswith(".env") for l in status if ".env" in l):
        print("PAROU: o .env apareceu no `git status`. Ele deveria estar no .gitignore.")
        print("Confira antes de continuar -- nao vou arriscar subir isso.")
        sys.exit(1)

    grupos, novos, apagados = agrupar_por_pasta(status)
    mensagem = args.mensagem or montar_mensagem(grupos, novos, apagados)

    print("Vai subir:")
    for l in status:
        print(f"  {l}")
    print()
    print("Mensagem do commit:")
    print("  " + mensagem.replace("\n", "\n  "))

    if args.dry_run:
        print("\n(dry-run: nada foi feito)")
        return

    git("add", "-A")

    achados = escanear_segredos()
    if achados and not args.forcar:
        print("\nPAROU antes de comitar -- isso aqui parece segredo/credencial:")
        for arquivo, padrao in achados[:10]:
            print(f"  {arquivo}  (bateu com: {padrao})")
        print("\nSe for falso positivo, rode de novo com --forcar. Se nao for,")
        print("tira isso do arquivo (ou joga pro .env) antes de subir.")
        git("reset", checar=False)
        sys.exit(1)

    git("commit", "-m", mensagem)
    print("\nCommit feito.")

    if args.sem_push:
        print("(--sem-push: fica so local por enquanto)")
        return

    branch = branch_atual()
    r = rodar(["git", "push", "origin", branch])
    if r.returncode != 0:
        print(f"Commit ok, mas o push falhou:\n{r.stderr}", file=sys.stderr)
        sys.exit(1)
    print(f"Subiu pro GitHub (origin/{branch}).")


if __name__ == "__main__":
    main()
