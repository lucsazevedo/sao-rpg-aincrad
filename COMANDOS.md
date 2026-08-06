# Comandos — SAO RPG: The Perfect Chaos

Tudo que dá pra rodar no projeto, na ordem em que faz sentido rodar.
Abra o **Prompt de Comando** ou **PowerShell** e entre na pasta primeiro:

```
cd "%USERPROFILE%\OneDrive\Área de Trabalho\SAO RPG"
```

---

## 0. Compartilhar com outra pessoa

```
python scripts\servir.py --publico
```

Sobe um servidor local e cria um link HTTPS temporário — a pessoa abre de
qualquer lugar, em modo mestre completo. Nada sobe pra nuvem. Passo a passo,
alternativa sem instalar nada e o que fica bloqueado: `COMO_COMPARTILHAR.md`.

## 0.1 Só quero ver o que já existe

Não precisa de comando nenhum. Dê duplo clique em:

```
scripts\web\compendio_andar1.html
```

Abre no navegador direto do arquivo. É o Compêndio inteiro — mapa, guias das
30 regiões, dungeons, 34 NPCs, 32 monstros, 50 armas, 66 equipamentos, mercado,
60 quests e os 7 puzzles.

---

## 1. Antes de gerar qualquer imagem — ligar as IAs

**ComfyUI** (obrigatório pra toda imagem):

```
C:\AI\ComfyUI\run_nvidia_gpu.bat
```

Espere abrir e aparecer `http://127.0.0.1:8188`. Deixe essa janela aberta.

**Ollama** (obrigatório pra NPC, arma e equipamento — monstro não usa):

```
ollama list
```

Se listar `qwen2.5:14b`, está pronto. Se não abrir nada, rode `ollama serve`
numa janela e deixe aberta.

---

## 2. A placa de arte do mapa (a prioridade)

Gera **só o terreno**, sem texto — a moldura, os painéis e os 233 marcadores
são desenhados pelo Compêndio por cima, em vetor.

```
python scripts\gerar_mapa_arte.py andar --tentativas 4
```

Sai em `mapas\andar_1_placa_s<seed>.png` (4 versões). Escolha a melhor e
renomeie para exatamente:

```
mapas\andar_1_placa.png
```

O Compêndio detecta sozinho na próxima vez que abrir. Enquanto não existir,
ele usa a arte antiga.

**Só quero ver o prompt antes de gastar GPU:**

```
python scripts\gerar_mapa_arte.py andar --mostrar-prompt
```

**Depois, o resto da arte de mapa** (planta da cidade, textura do labirinto e
as 5 vistas do rodapé):

```
python scripts\gerar_mapa_arte.py todas
```

**Se você tiver um checkpoint SDXL de paisagem** (fica muito melhor que o
Animagine pra mapa):

```
python scripts\gerar_mapa_arte.py andar --tentativas 4 --checkpoint juggernautXL.safetensors
```

---

## 3. As 149 imagens que faltam — um comando só

Primeiro veja a fila sem gerar nada:

```
python scripts\gerar_faltantes.py --listar
```

Depois gere. Ele pula tudo que já tem imagem, então dá pra parar no meio
(Ctrl+C) e continuar depois — é só rodar de novo.

```
python scripts\gerar_faltantes.py monstros        (25 · ~11 min)
python scripts\gerar_faltantes.py npcs            (30 · ~13 min)
python scripts\gerar_faltantes.py armas           (28 · ~12 min)
python scripts\gerar_faltantes.py equipamentos    (66 · ~28 min)
```

Ou tudo de uma vez (~1h05 numa 4070 Ti):

```
python scripts\gerar_faltantes.py tudo
```

**Testar o estilo antes de rodar as 149:**

```
python scripts\gerar_faltantes.py monstros --limite 3
```

**Refazer alguma que ficou ruim:** apague o `.png` e rode de novo, ou:

```
python scripts\gerar_faltantes.py monstros --refazer --limite 1
```

> Monstro usa prompt em inglês escrito à mão (`--prompt-bruto`), porque deixar
> o Ollama traduzir faz o bicho virar cavaleiro humano genérico. Os 25 prompts
> estão dentro de `scripts\gerar_faltantes.py`, no dicionário
> `PROMPTS_MONSTRO` — edite lá se quiser mudar a cara de alguma criatura.

---

## 4. Sincronizar o Compêndio — rode SEMPRE depois de mexer em conteúdo

Este é o comando que fecha o ciclo. Ele lê os `.md` e reescreve os dados do
app, inclusive os contadores das abas.

```
python scripts\gerar_dados_web.py
```

Rode depois de: gerar imagem, escrever ficha nova, editar quest, editar guia
de região, mudar preço no mercado, mexer nos puzzles. **Se você não rodar, o
app continua mostrando o conteúdo antigo.**

Ele imprime no fim quantos de cada coisa existem e o que ainda está sem
imagem — serve como checklist.

---

## 5. Criar conteúdo novo (geradores por Ollama)

**NPC:**

```
python scripts\gerar_npc.py "guarda veterano da cidade do inicio" --revisar
```

Opções: `--andar`, `--profissao`, `--arma`, `--papel aliado|inimigo|neutro|vendedor|chefe_de_andar`

**Arma / item:**

```
python scripts\gerar_arma.py "rapieira de um mestre de esgrima do andar 1"
```

Opções: `--tipo "Katana"`, `--raridade Incomum`, `--andar 1`

**Cena / quest:**

```
python scripts\gerar_cena.py "grupo encontra a entrada da masmorra do andar 1" --revisar
```

Opções: `--local`, `--tipo exploracao|combate|social|chefe`, `--npcs "Fulano,Beltrano"`

**Imagem avulsa (qualquer coisa):**

```
python scripts\gerar_imagem.py "retrato da NPC Lynx, comerciante de armaduras" --nome npc_lynx
```

Opções: `--largura 832 --altura 1216`, `--seed 12345`, `--mapa` (salva em
`mapas\`), `--referencia caminho.png` (mesma cara do personagem, via IPAdapter
FaceID), `--prompt-bruto` (usa seu texto em inglês direto, sem Ollama).

Depois de qualquer um desses: **rode o comando do item 4.**

**Chat com a IA direto do navegador:** `scripts\web\assistente_ia.html` — fala
com o mesmo Ollama local (dá duplo clique pra abrir). Serve pra rascunhar
texto, pedir revisão, ou analisar uma imagem que você anexa (precisa de um
modelo de visão instalado, tipo `qwen2.5vl:7b`, pro upload de imagem — modelo
de texto normal ignora a imagem). Não substitui os geradores acima: eles
escrevem o `.md` certinho em `npcs/`/`armas/`/etc. e já rodam a revisão; o
chat é pra conversa livre. Copie a resposta pro arquivo final na mão.

**Modo Agente (a IA edita os arquivos sozinha, com sua aprovação):**

```
python scripts\servidor_agente.py
```

Liga um servidor local (porta 8787) que dá ao Ollama a capacidade de explorar
o projeto (listar pasta, ler arquivo, buscar texto) e propor mudanças reais
em arquivos — vários de uma vez, se o pedido pedir isso. Depois de rodar,
abra `scripts\web\assistente_ia.html`, aba **"🛠️ Agente"**, escreva o que
você quer (ex: *"adicione um campo X em todo monstro do tipo Y"*) e clique em
Executar. Modelo padrão `qwen2.5:14b` — é o único dos instalados aqui com
suporte a *tool calling* confirmado (`ollama list` mostra a capability
`tools`); outro modelo sem isso simplesmente não vai chamar ferramenta
nenhuma.

**Nada é salvo sozinho.** Cada proposta aparece como diff na tela — você
marca quais aceita e clica em "Aplicar selecionadas" pra ir pro disco de
verdade. É um modelo de 14B rodando local, bem menor que uma IA de ponta:
revise os diffs, principalmente em pedidos que tocam muitos arquivos. Depois
de aplicar: `python scripts\gerar_dados_web.py` pra sincronizar o Compêndio,
e `python scripts\subir_github.py` quando quiser subir pro GitHub.

---

## 6. Áudio (roda em outra pasta, com outra venv)

```
cd C:\AI\AudioCraft
venv\Scripts\python.exe gerar_sao.py "ambiente da praca da cidade do inicio, dia 10"
```

Ele detecta sozinho se é música ou efeito e salva em `musicas\` ou
`efeitos_sonoros\` do projeto. Vocabulário e categorias em
`docs\guia_estilo_audio.md`.

---

## Sequência recomendada pra hoje

```
1)  C:\AI\ComfyUI\run_nvidia_gpu.bat                        (deixa aberto)
2)  ollama list                                             (confere)
3)  python scripts\gerar_mapa_arte.py andar --tentativas 4
4)  renomeia a melhor pra mapas\andar_1_placa.png
5)  python scripts\gerar_faltantes.py monstros --limite 3   (confere o estilo)
6)  python scripts\gerar_faltantes.py tudo                  (~1h)
7)  python scripts\gerar_dados_web.py
8)  abre scripts\web\compendio_andar1.html
```

---

## 7. Subir tudo pro GitHub

```
python scripts\subir_github.py
```

Faz `git add` + `commit` (mensagem automática, listando o que mudou por
pasta) + `push` num comando só. Antes de comitar, escaneia o que vai subir
procurando cara de senha/chave/token e para se achar algo suspeito (passe
`--forcar` se for falso positivo). `--dry-run` só mostra o que sairia, sem
fazer nada. `--sem-push` comita local sem mandar pro GitHub. `--mensagem "..."`
troca a mensagem automática pela sua.

> O repositório é **público** — isso é só pra automatizar o `git push` de
> conteúdo normal do projeto, não uma licença pra subir qualquer coisa sem
> olhar. Segredo de verdade (chave do Supabase, senha de banco) vive só no
> `.env`, que nunca é commitado.

---

## 8. Banco de dados, painel do mestre e busca por significado (RAG)

O site (`scripts/web/painel.html`) não lê mais `dados_conteudo.js` direto —
lê do banco (Supabase). Ver `docs/pipeline.md` (seção do topo) pra saber
quando editar `.md` ainda vale e quando editar direto no painel.

```
python scripts/migrar_para_supabase.py    # .md/.js -> banco (conteúdo estruturado)
python scripts/gerar_embeddings.py        # .md restante -> banco, com embedding (RAG)
python scripts/servidor_rag.py            # servidor local de busca por significado, porta 8788
```

- `migrar_para_supabase.py` pergunta antes de rodar — ele sobrescreve
  edição feita só no banco com o que estiver no `.md`. Use pra conteúdo
  **novo**, não pra atualizar algo que já existe (isso é o painel).
- `gerar_embeddings.py` precisa do modelo `nomic-embed-text` no Ollama:
  `ollama pull nomic-embed-text` (uma vez só, ~274MB). Cobre o que ainda
  só existe em markdown solto — regras, receitas, história, segredos —
  quebrado em pedaços com embedding, buscável por significado (não só por
  palavra exata).
- `servidor_rag.py` é a peça que um agente de IA (local, tipo
  `assistente_ia.html`) chama em vez de colar um arquivo inteiro no
  prompt: `POST localhost:8788/buscar` com `{"pergunta": "...", "k": 5}`
  devolve só os pedaços relevantes.
- **Painel do mestre**: `scripts/web/admin.html` — login de mestre, CRUD
  completo (criar/editar/**excluir só logicamente**, nunca apaga de
  verdade) em qualquer uma das 23 tabelas, incluindo `documentos` (o texto
  bruto por trás do RAG — editar aqui não recria o embedding sozinho,
  rode `gerar_embeddings.py` de novo depois).

---

## Se der erro

| Erro | O que é |
|---|---|
| `Nao consegui falar com o ComfyUI` | O ComfyUI não está rodando, ou não está na porta 8188 |
| `Connection refused` no Ollama | Rode `ollama serve` numa janela separada |
| `ModuleNotFoundError: PIL` | Só o `gerar_mapa_infografico.py` precisa: `pip install Pillow` |
| Imagem de monstro virou pessoa | Prompt caiu no Ollama. Use `gerar_faltantes.py`, que já força `--prompt-bruto` |
| O Compêndio mostra contagem errada | Faltou rodar `python scripts\gerar_dados_web.py` |
| Marcadores fora do lugar no mapa | A arte nova saiu com geografia diferente da descrita no prompt |

Os demais scripts só usam a biblioteca padrão do Python — não precisa de venv
nem de `pip install` pra nada, exceto o Pillow acima.
