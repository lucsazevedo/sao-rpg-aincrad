# Como deixar outra pessoa acessar o Compêndio

Nada é enviado pra nuvem. Os 468 MB continuam na sua máquina — o túnel só
encaminha o tráfego pra quem você mandar o link.

---

## O caminho rápido

**1. Instale o cloudflared** (uma vez só). No PowerShell:

```
winget install --id Cloudflare.cloudflared
```

Se o winget não achar, baixe o `.exe` em
<https://github.com/cloudflare/cloudflared/releases/latest>
(arquivo `cloudflared-windows-amd64.exe`), renomeie para `cloudflared.exe` e
jogue dentro da pasta `SAO RPG` — o script acha sozinho.

**2. Suba o túnel:**

```
cd "%USERPROFILE%\OneDrive\Área de Trabalho\SAO RPG"
python scripts\servir.py --publico
```

Ele imprime algo assim:

```
==================================================================
  LINK PUBLICO (temporario, morre quando voce fechar):
  https://algo-aleatorio.trycloudflare.com/scripts/web/compendio_andar1.html
==================================================================
```

**3. Mande esse link.** A pessoa abre no navegador dela, de qualquer lugar, e
vê o Compêndio inteiro — mapa, fichas, mercado, tudo. **Modo mestre completo.**

Pra encerrar: `Ctrl+C` no terminal. O link morre junto.

---

## Sem instalar nada

Se não quiser instalar o cloudflared, o Windows 10/11 já tem `ssh`. Abra
**duas** janelas de terminal:

**Janela 1** — sobe o servidor:
```
cd "%USERPROFILE%\OneDrive\Área de Trabalho\SAO RPG"
python scripts\servir.py
```

**Janela 2** — cria o túnel:
```
ssh -R 80:localhost:8000 localhost.run
```

Ele responde com um endereço `https://...lhr.life`. O link do app é esse
endereço + `/scripts/web/compendio_andar1.html`.

---

## Só pra quem está na sua casa

Se a pessoa está na mesma rede (mesmo wifi), nem precisa de túnel:

```
python scripts\servir.py
```

Ele imprime o endereço da rede, tipo `http://192.168.0.15:8000/...`. É só
mandar. Mais rápido e não depende de serviço nenhum.

Se não abrir na outra máquina, é o Firewall do Windows: na primeira vez ele
pergunta se libera o Python — responda **Permitir em redes privadas**.

---

## O que o servidor entrega (e o que ele bloqueia)

Por padrão, só o que o app precisa pra funcionar:

| Liberado | Bloqueado (403) |
|---|---|
| `scripts/web/` | `docs/` |
| `imagens/` | `npcs/`, `monstros/`, `armas/`, `equipamentos/` |
| `mapas/` | `guias/`, `cenas/`, `cidades/` |
| `musicas/`, `efeitos_sonoros/` | `base/`, `scripts/` (fora de `web/`) |

Ou seja: ninguém lê o material de mestre chutando URL. Testado — os `.md`
respondem **403**.

Se quiser liberar tudo mesmo assim: `python scripts\servir.py --publico --tudo`.

---

## Modo jogador (opcional)

Se um dia você quiser mandar pra um **jogador** em vez de outro mestre,
acrescente `?jogador=1` no fim do link:

```
https://...trycloudflare.com/scripts/web/compendio_andar1.html?jogador=1
```

Nesse modo o app:

- esconde as abas **Só o Mestre**, **Sistema**, **Mesa**, **Puzzles** e **Dungeons**;
- remove toda caixa "Só o mestre", "A verdade" e "Notas para o mestre" de
  dentro das fichas;
- marca o cabeçalho como *Modo jogador*.

Sobram 9 abas: Mapa, Cidade do Início, Guia das Regiões, NPCs, Bestiário,
Armas, Equipamentos, Mercado e Quests.

> É uma cortina, não um cofre: o conteúdo continua indo pro navegador da
> pessoa e alguém determinado consegue ver pelo DevTools. Serve pra evitar
> spoiler acidental, não pra guardar segredo de alguém que vai caçar.

---

## Opções do script

```
python scripts\servir.py                 só na sua máquina + rede local
python scripts\servir.py --publico       cria o link público (cloudflared)
python scripts\servir.py --porta 8080    troca a porta
python scripts\servir.py --tudo          entrega o projeto inteiro
python scripts\servir.py --sem-navegador não abre o navegador sozinho
```

---

## Problemas comuns

| Sintoma | Causa |
|---|---|
| `Nao consegui abrir a porta 8000` | Já tem algo usando. Use `--porta 8080` |
| `--publico` reclama que falta cloudflared | Instale, ou use o caminho do `ssh` acima |
| A pessoa vê a página mas sem imagens | Você rodou o script de dentro de `scripts\web`. Rode da pasta do projeto |
| Link parou de funcionar | Túnel gratuito é temporário — feche e rode de novo, o endereço muda |
| Muito lento pra outra pessoa | São 269 MB de imagem. A primeira carga é pesada; depois o navegador dela cacheia |
