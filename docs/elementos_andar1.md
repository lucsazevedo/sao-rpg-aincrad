---
titulo: Fraquezas de Atributo
andar: 1
uso: regra de sistema
---

> **Este arquivo foi superado.** A partir da conversão do sistema pra D&D
> 5e, a fonte única de verdade da mecânica é **`SAO_RPG_5e.md`** (raiz do
> projeto). A mecânica de fraqueza mudou de natureza, não só de nome — o
> texto abaixo descreve um mecanismo **narrativo** ("acertar a fraqueza
> nega a reação do monstro"), que não existe mais assim:
>
> | Este arquivo (PBTA, histórico) | D&D 5e (`SAO_RPG_5e.md`) |
> |---|---|
> | Fraqueza = nega a reação do monstro (7-9 vira 10+ funcional) | Fraqueza = **+1d6 de dano extra** no ataque que usa o atributo certo (Seção 73) |
> | `atributo_fraqueza`: Corpo/Reflexo/Conhecimento/Espírito/Técnica | `atributo_fraqueza` convertido pra **FOR/DES/INT/SAB** (Seção 65 — Técnica e Espírito não têm conversão 1:1, então nunca sobra CON/CAR num monstro) |
> | Raridade de equipamento em 4 degraus: Comum/Incomum/Raro/**Único** | Raridade de equipamento em 5 degraus: Comum/Incomum/Raro/Épico/**Lendário** (Seção 51/72) |
> | Raridade de material (drop) em 4 degraus: Comum/Incomum/Raro/**Épico** | Segue existindo como conceito, mas a escala de equipamento já não é mais a mesma (ver acima) |
> | "O mestre deve dizer a fraqueza. Não esconda." | Fraqueza continua sendo **descoberta em jogo**, não informação de graça — mas agora com regra explícita de como descobrir (observação, teste de Sistema, habilidades de Caçador/Mercenário/Informante) — ver Seção 73, "Fraqueza é ferramenta de descoberta" |
>
> O texto abaixo é mantido só como registro histórico de como a fraqueza
> funcionava no sistema PBTA (2d6, escada 10+/7-9/6-) — **não é mais regra
> vinculante**. Não use pra gerar conteúdo novo nem pra tirar dúvida de
> regra; use `SAO_RPG_5e.md`, Seção 73.

# Fraquezas de Atributo (histórico, pré-D&D 5e)

O sistema elemental (Fogo/Trovão/Gelo/Veneno) foi descontinuado — esta
regra o substitui.

Fraqueza de atributo **não é um número**. A regra de teto continua valendo:
nenhum teste recebe mais de **+1 numérico externo**, e a fraqueza nunca
ocupa esse espaço.

Fraqueza muda **o que acontece** — e o que ela compra é a coisa mais cara
do sistema: **negar a reação do monstro**.

---

## Por que isso importa neste sistema

Aqui o monstro só reage. O jogador sempre bate primeiro, e a diferença entre
um resultado bom e um ruim não é dano — é se a criatura consegue responder.

| Resultado | Sem acertar a fraqueza | **Acertando a fraqueza de atributo** |
|---|---|---|
| **10+** | Acerta limpo, sem reação | Acerta limpo **e a criatura perde uma capacidade listada pelo resto da cena** |
| **7-9** | Acerta, mas a criatura reage | Acerta **e a criatura não reage** — o 7-9 vira um 10+ funcional |
| **6-** | O mestre narra a complicação | O mesmo — complicação normal |

O 7-9 é onde a mesa vai sentir. A arma certa na mão certa transforma metade
das rolagens ruins em rolagens boas, e isso é enorme.

## Como se acerta a fraqueza

Cada monstro tem um `atributo_fraqueza` na ficha — um dos cinco: **Corpo,
Reflexo, Conhecimento, Espírito, Técnica**. Você acerta a fraqueza atacando
com uma arma **cujo atributo principal é esse**. A tabela de arma →
atributo está em `docs/guia_sistema_aincrad.md`.

Não custa preparo, não gasta carga e não acaba no meio da cena: custa a
arma que você escolheu empunhar. Trocar de arma pro monstro certo é a
decisão tática que ocupa o lugar do antigo "qual elemento carregar" — e é
por isso que reconhecimento continua valendo ouro. Um grupo que sabe o que
vai enfrentar chega com a arma certa na mão. Um grupo que não sabe gasta a
vez trocando.

Tocha, óleo, cristal de descarga e afins viraram flavor: continuam
existindo no mundo, mas **não têm mais efeito mecânico** sobre a fraqueza.

**O mestre deve dizer a fraqueza.** Não esconda: descreva. A investida que
deixa o flanco aberto, o padrão mecânico da armadura, o uivo que expõe a
garganta. A graça não é adivinhar qual é — é ter trazido a arma certa.

## O que o 10+ tira

A capacidade perdida está escrita na ficha do monstro, na primeira bala de
**Fraquezas** — o mergulho da águia, a investida do touro, a coordenação
da matilha, o agarrão da trepadeira. É sempre concreta e sempre pelo resto
da cena. Se a ficha não disser, o mestre tira a capacidade mais icônica
da criatura, na hora.

---

## Raridade: as duas escalas

Elas não são a mesma coisa e a ficha sempre diz qual está usando.

| Escala | Valores | Onde aparece |
|---|---|---|
| **Material** (drop) | Comum · Incomum · Raro · **Épico** | Tabela de drop dos monstros |
| **Equipamento** | Comum · Incomum · Raro · **Único** | Armas, armaduras, acessórios |

**Épico** é material que só chefe larga — Essência Kobold, Núcleo Selvagem,
Cristal de Comando. Não se compra, não se produz, e é o que transforma um
item Raro em Único na bancada de um artesão.

**Único** continua sendo a única categoria de equipamento autorizada a
quebrar a curva, e continua tendo que pagar por isso.

---

## Tabela rápida para o mestre

A ficha de cada monstro do Andar 1 já traz o atributo certo. Esta tabela é
pra quando você improvisar uma criatura nova:

| Se a criatura é... | O atributo que morde tende a ser |
|---|---|
| Rápida, voadora, de investida | **Reflexo** |
| Grande, pesada, de força bruta | **Corpo** |
| Enganadora, ilusória, mecânica | **Conhecimento** |
| Mental, aterradora, fanática | **Espírito** |
| Perita, precisa, especializada | **Técnica** |

## O erro que você vai cometer

Tratar a fraqueza como curiosidade de ficha em vez de preparo. Quem sabe
que vai enfrentar o Rei Touro e não leva uma arma de Reflexo escolheu a
luta dura — e a ficha estava pública antes da luta começar.
