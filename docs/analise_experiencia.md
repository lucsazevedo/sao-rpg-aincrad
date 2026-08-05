---
titulo: Análise de Experiência — o que temos e o que falta
andar: 1
uso: direção de projeto
data: agosto 2026
---

# Análise de Experiência

Auditoria do projeto inteiro medida com script, não por impressão. Três
perguntas: **o que quem joga recebe**, **o que quem assiste recebe**, e **o que
quem mestra recebe**.

---

## O tamanho real do que existe

| Bloco | Números |
|---|---|
| Texto jogável | **140 mil palavras** em 148 arquivos `.md` |
| Mapa | 30 regiões · 241 pontos · terreno vetorial com 1.119 elementos |
| Elenco | 40 NPCs · 34 monstros |
| Itens | 50 armas · 66 equipamentos · 18 vendedores com preço |
| Aventura | 60 quests · 7 puzzles · 4 dungeons (47 salas) |
| Sistema | 22 Moves de arma · 16 Moves de profissão · Impulso, Marcos, Condições |
| Mídia | 183 imagens (275 MB) · 23 faixas (139 MB) |
| App | 14 abas, ficha completa em tela cheia, túnel pra compartilhar |

Cobertura de arte: **armas 100%**, **monstros 94%**, **NPCs 92%**,
**equipamentos 87%**.

Isso é, com folga, material suficiente pra rodar um andar inteiro por meses.
O problema não é volume. É **distribuição**.

---

# 1. Quem joga

## O buraco mais grave: não existe ficha de personagem

O sistema pede que o jogador acompanhe **cinco atributos, arma, profissão,
Impulso (0-3), Marcos (0-4), Condições (até 3), equipamento em 7 slots, Col e
material coletado**. Não existe **nenhum** arquivo onde escrever isso.

Hoje, pra jogar, a pessoa precisa de um caderno e de boa vontade. Isso é o que
mais atrapalha a primeira sessão de qualquer mesa nova.

**O que falta:** uma ficha de uma página, e uma versão preenchível no próprio
Compêndio (aba **Meu Personagem**) que salve no navegador — cada jogador abre
o link, monta o personagem em dez minutos e tem tudo à mão durante o jogo.

## Profissões — RESOLVIDO (agosto/2026)

O diagnóstico era: **5 para 1** entre a profissão mais servida (Ferreiro) e a
menos (Lenhador), medindo menções em conteúdo jogável. Pelo índice estrutural
(NPC próprio ×3 + ação de ofício ×2 + posto no mapa ×2 + quest), a diferença
real era **10,8x**.

**O que foi feito:**

1. **`docs/oficios_andar1.md`** — as 16 profissões com a **mesma estrutura por
   construção**: 3 Ações de Ofício que funcionam em qualquer lugar (o piso —
   ninguém fica sem o que fazer numa sessão), 3 postos de trabalho em pontos
   reais do mapa, contato, gancho recorrente, renda e item assinatura.
   Total: **48 ações e 48 postos** distribuídos por 24 das 30 regiões.
2. **`cenas/contratos_de_oficio.md`** — 16 trabalhos curtos, um por profissão,
   mesmo tamanho, com recompensa **nomeada** em todos. Diplomata, Médico,
   Bibliotecário e Mercenário tinham **zero** quests; agora nenhuma tem zero.
3. **`npcs/torv_machadeiro.md`** — o Lenhador era a única profissão sem NPC da
   própria área. Agora as 16 têm contato.
4. **Aba Ofícios no Compêndio**, e em **qualquer ponto do mapa** aparece
   "Ofícios que trabalham aqui", com atalho para a ficha da profissão.
5. **Regra da vez do ofício:** em toda sessão, cada personagem tem direito a
   uma cena onde a profissão dele é a resposta. Não é bônus — é tempo de tela.

**Resultado medido:**

| Métrica | Antes | Depois |
|---|---|---|
| Índice estrutural (razão maior/menor) | **10,8x** | **3,2x** |
| Presença em cena, sem itens de crafting | — | **2,3x** |
| Profissões sem NPC próprio | 1 | **0** |
| Profissões sem nenhuma quest | 4 | **0** |
| Profissões sem ação de ofício própria | 7 | **0** |

O resíduo de 3,2x vem quase inteiro da coluna de **itens**: Ferreiro aparece em
31 receitas e Costureiro em 22, porque **são** os artesãos do cenário. Isso é
fidelidade à ficção, não desequilíbrio de tempo de mesa — tirando essa coluna,
a razão cai para 2,3x, dentro do aceitável.

**Como não estragar:** ao criar região ou quest nova, mantenha a conta. O
desequilíbrio volta sempre pelas mesmas seis — Lenhador, Diplomata, Médico,
Domador, Bibliotecário e Músico.

## "Onde eu compro isso?" não tem resposta pra 31 armas

31 das 44 armas Comum/Incomum **não aparecem em nenhuma tabela de preço**. O
mercado diz "armas Comuns dos 22 tipos, 80-200 Col" — genérico. Quando o
jogador clica na `Katana Equilibrada` e pergunta onde compra, o app não sabe.

**O que falta:** regra de fallback por raridade (toda Comum está na Loja de
Armas; toda Incomum tem pelo menos um vendedor nomeado) e 6-8 itens Incomuns
espalhados nas lojas que hoje só vendem material.

## O jogador não tem mapa

O modo `?jogador=1` esconde o material de mestre, mas o jogador continua sem
**o mapa dele**: onde já esteve, o que ouviu falar, que quest aceitou. Hoje
isso vive na cabeça do mestre.

**O que falta:** no modo jogador, um bloco de anotação por região e uma lista
de quests aceitas — tudo salvo no navegador dele.

---

# 2. Quem assiste

Este é o lado **mais fraco do projeto**, e é o que você mais falou em querer.
Hoje existe direção editorial pra stream (as seções "Pontos de transmissão" e
"Uso em transmissão" que você escreveu), mas **nada visual**.

## Não existe tela do espectador

Todo o material é feito pro mestre olhar. Quem assiste vê a cara das pessoas e
ouve a narração — não vê o mundo. Temos **183 imagens, 30 regiões desenhadas e
um mapa vetorial** e nada disso chega na tela de quem assiste.

**O que falta:** uma **Tela do Espectador** — uma página separada, feita pra
entrar no OBS como fonte de navegador, que o mestre controla do Compêndio:

- o **mapa** com um marcador pulsando onde o grupo está agora;
- o **retrato** do NPC ou monstro em cena;
- o **nome do local** e uma linha de atmosfera;
- a **faixa tocando** e um relógio de tensão quando houver;
- zero informação de mestre.

Tecnicamente é barato: o Compêndio já tem os dados e as imagens, e as duas
páginas conversam por `localStorage` — o mestre clica num ponto, a tela do
espectador muda sozinha.

## As 23 faixas não sabem quando tocar

Existe trilha para abertura, cidade, taverna, dungeon, combate comum, combate
épico, chefe, vitória e momento emocional. **Nenhum documento diz qual faixa
toca em qual região ou cena.** Na prática o mestre esquece e a mesa roda em
silêncio, ou fica a mesma música a sessão toda.

**O que falta:** um mapa faixa→cena (cada região e cada tipo de sala de dungeon
já tem clima definido nos guias), e um botão de tocar direto no app.

## Quem chega no meio do episódio não entende nada

Não há recap, não há "quem é quem", não há placar de reputação de clã visível.
A campanha tem 6 clãs, 40 NPCs e um mistério de fundo — quem liga a stream no
minuto 40 está perdido.

**O que falta:** um **card de recap** de 20 segundos (o que aconteceu, onde
estão, o que está em jogo) gerado a partir do registro da sessão, e um terço
inferior com o nome de quem está falando.

---

# 3. Quem mestra

É o lado mais forte, e mesmo assim tem três buracos concretos.

## 223 dos 241 pontos ainda usam ficha automática

Só a Cidade do Início (18 pontos) tem texto próprio — leitura em voz alta,
ações com teste, notas de mestre e atalhos. O resto monta a ficha com o que
`dados_mapa.js` tem, que é uma descrição curta.

O padrão já está validado (`guias/pontos/cidade_inicio.md`). Falta produzir.
Ordem por onde o grupo pisa primeiro: **Verrun → Kaldan → Horunka → Tolbana →
Limiar do Labirinto**, e depois as regiões de puzzle.

## Bugs de dados corrigidos nesta auditoria

| Problema | Situação |
|---|---|
| **56 das 60 quests** apareciam sem tipo, dificuldade e NPC no app | corrigido — o parser lia o bloco errado |
| Ligações de guia apontando pra NPCs com id antigo (Barqueiro, Mulher Aflita, Garota do Arco) | corrigido — resolução tolerante |
| Cadeia de quests (`requer`/`desbloqueia`) existia no texto mas não no app | agora vira atalho clicável |

## Seis monstros estão rasos

Águia de Pedra, Coruja das Sombras, Corvo das Ruínas, Libélula Cortante, Lobo
das Estepes e Morcego Ecoante têm menos de 900 caracteres — só ficha técnica,
sem comportamento nem gancho. São justamente os bichos que o grupo encontra
**nas primeiras sessões**.

---

# Plano priorizado

Ordenado por **impacto na experiência ÷ esforço**.

### Faixa 1 — muda a mesa na próxima sessão

| # | O quê | Pra quem | Tamanho |
|---|---|---|---|
| 1 | ~~Ficha de personagem~~ — **fora do escopo**, será criada à parte | joga | — |
| 2 | ~~Tela do Espectador~~ — **fora do escopo**: o mestre resolve com Foundry + OBS | assiste | — |
| 3 | ~~Cue sheet de trilha~~ — **fora do escopo**, idem | assiste | — |
| 4 | Fichas de ponto de **Verrun e Kaldan** (a primeira saída do grupo) | mestra | médio |

### Faixa 2 — fecha os buracos que aparecem no uso

| # | O quê | Pra quem | Tamanho |
|---|---|---|---|
| 5 | Regra de vendedor por raridade + itens Incomuns nas lojas vazias | joga | pequeno |
| 6 | ~~Ganchos pras 6 profissões fracas~~ — **feito**: ver seção Profissões | joga | ✔ |
| 7 | Engordar os 6 monstros rasos | mestra | pequeno |
| 8 | Fichas de ponto de **Horunka, Tolbana e Limiar** | mestra | grande |

### Faixa 3 — profundidade

| # | O quê | Pra quem | Tamanho |
|---|---|---|---|
| 9 | Bloco de anotação e quests aceitas no modo jogador | joga | médio |
| 10 | Card de recap + terço inferior pro stream | assiste | médio |
| 11 | As 24 regiões de ponto restantes | mestra | grande |
| 12 | Andar 2 | todos | enorme |

---

## O que NÃO precisa mexer

Pra não gastar energia no que já está bom:

- **Sistema de regras** — Moves, Impulso, Marcos e Condições estão coerentes e
  balanceados; a regra "facilidade de obter define o teto" resolve os itens.
- **Os 7 puzzles** — têm entrada múltipla, etapas, estado de falha e recompensa
  nomeada. É o melhor conteúdo do projeto.
- **As 4 dungeons** — 47 salas com leitura, ação, tesouro nomeado e vestígio
  humano.
- **Economia** — 18 vendedores, cadeia de produção coerente, e as 16 profissões
  têm renda própria (o problema delas é presença em cena, não dinheiro).
- **Pipeline** — `gerar_dados_web.py` fecha o ciclo; o app não desatualiza mais.
