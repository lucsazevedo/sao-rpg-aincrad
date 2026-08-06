"""
Uso: python scripts/servir.py [opcoes]

Sobe o Compendio num servidor local e, com --publico, cria um tunel HTTPS
temporario pra outra pessoa abrir de qualquer lugar. Nada e enviado pra
nuvem: os arquivos continuam na sua maquina, o tunel so encaminha o trafego.

  python scripts/servir.py                 so na sua maquina + rede local
  python scripts/servir.py --publico       cria o link publico (cloudflared)
  python scripts/servir.py --porta 8080    troca a porta
  python scripts/servir.py --tudo          libera o projeto inteiro (cuidado)

Sem --tudo, o servidor so entrega o que o app precisa:
  scripts/web/, imagens/, mapas/, efeitos_sonoros/, musicas/
Todo o resto (docs/, npcs/, monstros/, cenas/, guias/, base/) fica BLOQUEADO,
entao ninguem le o material de mestre chutando URL.

Link pra mandar pro jogador (esconde a aba Só o Mestre e as caixas de segredo):
  <link>/scripts/web/compendio_andar1.html?jogador=1

So usa a stdlib. Pra parar, Ctrl+C.
"""
import argparse
import http.server
import os
import posixpath
import shutil
import socket
import socketserver
import subprocess
import sys
import threading
import time
import urllib.parse
import webbrowser

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# pastas liberadas quando NAO se usa --tudo
PERMITIDAS = ("scripts/web", "imagens", "mapas", "efeitos_sonoros", "musicas")
INDEX = "/scripts/web/painel.html"


class Handler(http.server.SimpleHTTPRequestHandler):
    liberar_tudo = False

    def translate_path(self, path):
        path = urllib.parse.urlparse(path).path
        path = posixpath.normpath(urllib.parse.unquote(path)).lstrip("/")
        partes = [p for p in path.split("/") if p not in ("", ".", "..")]
        return os.path.join(RAIZ, *partes)

    def permitido(self, caminho):
        if self.liberar_tudo:
            return True
        rel = os.path.relpath(caminho, RAIZ).replace(os.sep, "/")
        if rel in (".", ""):
            return True
        return any(rel == p or rel.startswith(p + "/") for p in PERMITIDAS)

    def do_GET(self):
        if self.path in ("/", "/index.html"):
            self.send_response(302)
            self.send_header("Location", INDEX)
            self.end_headers()
            return
        if not self.permitido(self.translate_path(self.path)):
            self.send_error(403, "Fora do que este servidor entrega")
            return
        return super().do_GET()

    def end_headers(self):
        self.send_header("Cache-Control", "no-store")
        super().end_headers()

    def log_message(self, fmt, *args):
        codigo = str(args[1]) if len(args) > 1 else ""
        if codigo.startswith(("4", "5")):
            sys.stderr.write("  %s %s\n" % (codigo, args[0]))


def ip_da_rede():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except Exception:
        return "127.0.0.1"


def achar_cloudflared():
    caminho = shutil.which("cloudflared")
    if caminho:
        return caminho
    for tentativa in (
        r"C:\Program Files (x86)\cloudflared\cloudflared.exe",
        r"C:\Program Files\cloudflared\cloudflared.exe",
        os.path.expanduser(r"~\cloudflared.exe"),
        os.path.join(RAIZ, "cloudflared.exe"),
    ):
        if os.path.exists(tentativa):
            return tentativa
    return None


def abrir_tunel(porta):
    """Sobe o cloudflared com um supervisor: se o processo cair (queda de
    rede, PC dormiu, hiccup do lado do Cloudflare), reinicia sozinho em vez
    de deixar o link morto. Retorna um dict com o Event de parada e o
    processo atual (pra dar terminate() no encerramento)."""
    exe = achar_cloudflared()
    if not exe:
        print("""
  --publico precisa do cloudflared, e ele nao foi encontrado.

  Instale com UM destes (escolha o que preferir):

    winget install --id Cloudflare.cloudflared
    choco install cloudflared

  Ou baixe o .exe e deixe do lado deste projeto:
    https://github.com/cloudflare/cloudflared/releases/latest
    (arquivo cloudflared-windows-amd64.exe -> renomeie pra cloudflared.exe)

  Alternativa sem instalar nada, numa segunda janela do terminal:
    ssh -R 80:localhost:%d localhost.run
""" % porta)
        return None

    estado = {"proc": None, "parar": threading.Event()}

    def imprimir_link(url):
        print("\n" + "=" * 66)
        print("  LINK PUBLICO (temporario, muda se o tunel reconectar):")
        print("  " + url + INDEX)
        print("\n  Pra mandar pro JOGADOR (esconde o material de mestre):")
        print("  " + url + INDEX + "?jogador=1")
        print("=" * 66 + "\n")

    def supervisor():
        tentativa = 0
        while not estado["parar"].is_set():
            tentativa += 1
            if tentativa == 1:
                print("  abrindo tunel com cloudflared...")
            else:
                print("\n  [tunel caiu -- reconectando automaticamente (tentativa %d)...]" % tentativa)
            proc = subprocess.Popen(
                [exe, "tunnel", "--url", "http://localhost:%d" % porta,
                 "--no-autoupdate"],
                stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                text=True, encoding="utf-8", errors="replace", bufsize=1,
            )
            estado["proc"] = proc
            for linha in proc.stdout:
                if "trycloudflare.com" in linha:
                    for pedaco in linha.split():
                        if pedaco.startswith("https://") and "trycloudflare" in pedaco:
                            imprimir_link(pedaco.strip().rstrip(".,"))
            proc.wait()
            if estado["parar"].is_set():
                break
            # processo caiu sozinho -> espera um pouco e sobe de novo
            time.sleep(3)

    threading.Thread(target=supervisor, daemon=True).start()
    return estado


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--porta", type=int, default=8000)
    ap.add_argument("--publico", action="store_true", help="cria o link publico via cloudflared")
    ap.add_argument("--tudo", action="store_true", help="entrega o projeto inteiro, sem bloqueio")
    ap.add_argument("--sem-navegador", dest="sem_nav", action="store_true")
    args = ap.parse_args()

    Handler.liberar_tudo = args.tudo
    socketserver.TCPServer.allow_reuse_address = True

    try:
        servidor = socketserver.ThreadingTCPServer(("0.0.0.0", args.porta), Handler)
    except OSError as e:
        print("Nao consegui abrir a porta %d (%s). Tente --porta 8080." % (args.porta, e))
        return

    local = "http://localhost:%d%s" % (args.porta, INDEX)
    rede = "http://%s:%d%s" % (ip_da_rede(), args.porta, INDEX)

    print("\n  Servindo: %s" % RAIZ)
    print("  Liberado: %s" % ("TUDO (--tudo)" if args.tudo else ", ".join(PERMITIDAS)))
    print("\n  Nesta maquina:   " + local)
    print("  Na sua rede:     " + rede + "   (mesma casa/wifi)")
    print("  Modo jogador:    " + local + "?jogador=1")

    tunel = abrir_tunel(args.porta) if args.publico else None
    if not args.sem_nav:
        threading.Thread(target=lambda: (time.sleep(1), webbrowser.open(local)), daemon=True).start()

    print("\n  Ctrl+C para parar.\n")
    try:
        servidor.serve_forever()
    except KeyboardInterrupt:
        print("\n  parando...")
    finally:
        servidor.shutdown()
        if tunel:
            tunel["parar"].set()
            if tunel["proc"]:
                tunel["proc"].terminate()


if __name__ == "__main__":
    main()
