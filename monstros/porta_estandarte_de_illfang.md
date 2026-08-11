---
nome: Porta-Estandarte de Illfang
epiteto: 
tipo: humanoide
andar: 1
zona: Labirinto
local: campo
regioes: [labirinto_entrada]
nivel_recomendado: "6-7"
nivel_ameaca: forte
golpes_para_derrotar: 7
abertura: derrubar o estandarte antes de encarar o portador
atributo_fraqueza: Espírito
resistencias: [impacto, intimidação]
vulnerabilidades: [ataque ao mastro, flanco esquerdo]
imagem: ../imagens/monstro_porta_estandarte_de_illfang.png
canonico: nao
fonte: 
---

## Habitat

O descampado na base da torre, no Limiar do Labirinto. Patrulha em linha reta, ida e volta, sempre o mesmo trajeto.

**Comportamento:** vigia, não caça. Ao avistar intrusos finca o estandarte no chão primeiro e só depois pega o machado — e enquanto o pano estiver de pé, Ruin Kobold Troopers chegam do escuro em duplas, sem fim. Ele não tenta vencer sozinho: tenta fazer a luta durar.

## Aparência

Um Ruin Kobold de cabeça e meia a mais que os outros, com couraça de placas
mal ajustadas tiradas de três armaduras diferentes. Na mão esquerda carrega
um mastro de dois metros e meio com um pano vermelho-escuro preso no alto —
pesado, malfeito, e obviamente importante para ele.

Na mão direita, um machado curto que ele quase não usa.

## Leia em voz alta

> Ele vê vocês antes de vocês o verem. Não corre, não grita. Enfia o mastro
> no chão com as duas mãos, com o cuidado de quem já fez isso mil vezes, e
> o pano vermelho abre no vento. Só então ele pega o machado. Atrás dele, no
> escuro da base da torre, alguma coisa responde — muitos pés, ainda longe.

## Sinal antes do ataque

O pano. Ele para de tremular e fica reto por um instante, apontando, um
segundo antes de os primeiros Troopers aparecerem. Quem estiver olhando o
estandarte em vez do machado ganha o aviso.

## Ataques

- **Chamado** — finca o estandarte. Não causa dano; convoca.
- **Machadada de guarda** — golpe curto, defensivo, para segurar posição.
- **Empurrão de mastro** — usa o estandarte deitado como barra e empurra o
  grupo para longe do mastro. Ele protege o objeto, não a si mesmo.

## Fraquezas

- **Atributo — Espírito:** a ligação dele com o estandarte é devoção, não tática — arma de Espírito bate na determinação que sustenta o chamado. Em 10+ o chamado morre pelo resto da cena e os reforços param de chegar.
- O mastro está fincado, não segurado: é alvo parado, e derrubá-lo é teste de **Técnica**.
- O flanco esquerdo fica descoberto o tempo todo, porque a mão esquerda nunca solta o mastro.

## O que torna este encontro memorável

Ele ensina, sem nenhuma linha de diálogo, que **objetivo não é a mesma coisa
que inimigo**. Grupos que atacam o kobold ganham uma luta que não acaba;
grupos que atacam um pedaço de pano ganham a cena em dois turnos.

E é o primeiro monstro do andar que deixa claro que os Kobolds do Labirinto
têm hierarquia, ordens e alguém no topo dando as ordens.

## Complicações úteis

- O grupo derruba o estandarte, mas os Troopers que já chegaram continuam ali.
- Ele arranca o mastro do chão e sai correndo com ele em vez de lutar — a
  notícia da presença do grupo chega antes deles no Limiar do Labirinto.
- Alguém pega o estandarte caído. Agora carrega uma coisa que outros kobolds
  reconhecem de longe.
- O grupo vence rápido demais e volta em quatro horas achando que será igual.
  Não é: o cargo aprendeu, e o novo portador finca o mastro atrás de cobertura.

## Tabela de drop

| Item | Raridade | Qtd | Chance | Serve pra |
|---|---|---|---|---|
| Placa Remendada | Incomum | 1-2 | 100% | Ferreiro |
| Pano do Estandarte | Incomum | 1 | 60% | Corretores de Tolbana — ver Notas |
| Machado Curto de Kobold | Comum | 1 | 35% | Arma Comum, sucata de Ferreiro |
| Col | — | 700-1100 | 100% | — |

## Lore

Some quatro horas depois de morto, e nunca é o mesmo indivíduo: é o cargo que volta, com outro kobold dentro da couraça e o mesmo pano remendado de novo. É a primeira prova concreta de que o Labirinto tem hierarquia, e os Corretores de Tolbana pagam bem por uma descrição precisa do estandarte.

*Ele ensina, sem uma linha de diálogo, que objetivo não é a mesma coisa que inimigo.*

## Notas para o mestre

**Onde entra:** `labirinto_fieldboss` — Field Boss do Limiar do Labirinto,
respawn de 4 horas. É o degrau entre os mobs de corredor e Illfang: mostra
que existe comando sem ainda mostrar o comandante.

**O Pano do Estandarte** não é um item de status. Quem o carrega à vista é
tratado por Ruin Kobolds como provocação — eles atacam esse alvo primeiro e
ignoram os outros. Isso é uma ferramenta tática ótima e um problema social
péssimo, e o grupo deve descobrir os dois na prática.

**Como usar em transmissão:** o mastro sendo fincado. É o gesto de abertura
do encontro e funciona como cortina subindo — dá para cortar a música ali.

**Erro comum do grupo:** tratar como luta de atrito e gastar Impulso cedo.
Os reforços são infinitos de propósito. Se a mesa não perceber em três ou
quatro rodadas, deixe um Trooper tropeçar no mastro e quase derrubá-lo — é
dica suficiente sem entregar de graça.

**Ligações:** revela `labirinto_entrada_xmarca_de_garras_na_parede`. Os
Corretores de Informação de Tolbana pagam por uma descrição precisa do
estandarte — é a primeira prova concreta de que o Labirinto é organizado, e
`docs/misterio_andar2.md` depende disso ser público antes do dia 10.
