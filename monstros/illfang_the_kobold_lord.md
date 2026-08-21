---
nome: Illfang the Kobold Lord
epiteto: Boss do 1º Andar
tipo: chefe_de_andar
andar: 1
zona: Labirinto
local: dungeon/labirinto
regioes: [sala_chefe, labirinto_entrada]
nivel_recomendado: "8-10"
nivel_ameaca: chefe
ca: 16
pv: 165
dado_vida: 19d12+41  # 19d12 médio 124 + 41 = 165
bonus_ataque: +6
cd_resistencia: 15
abertura: previsibilidade — os golpes de machado têm tempo de leitura, e o nodachi não
atributo_fraqueza: Destreza
resistencias: [fase 1 — golpes frontais bloqueados pelo broquel, trovão]
vulnerabilidades: [fogo, fase 2 — perde a defesa do escudo ao trocar pro nodachi, isolamento dos Sentinels]
imagem: ../imagens/monstro_illfang_the_kobold_lord.png
carta: ../imagens/carta_illfang_the_kobold_lord.png
canonico: sim
fonte: https://swordartonline.fandom.com/wiki/Illfang_the_Kobold_Lord
---

## Habitat

Habita o acampamento kobold no vigésimo sub-nível do Labirinto, na sala do
chefe. Não sai de lá e não precisa: tudo que vive na torre trabalha para
manter o caminho até ele longo.

**Comportamento:** líder supremo dos kobolds do Andar 1. Comanda com astúcia e
crueldade, usa táticas de emboscada e desgaste antes de encarar pessoalmente,
e protege território e tesouro nessa ordem. Ambicioso — sonha em ser rei de
Aincrad, e age como quem tem tempo para isso.

## Aparência

Kobold gigante, escamas grossas e couraça de placas, coroa de ossos e um
estandarte com crânio fincado ao lado do trono. É a única criatura do andar
cuja postura em repouso já é uma ameaça.

## Leia em voz alta

> A sala é grande demais para qualquer coisa que vive nela. O teto some cedo,
> o ar parece limpo demais e o silêncio dura só até Illfang se mexer. Quando o
> escudo sobe e o machado ajusta no ombro, não parece que um chefe entrou em
> combate. Parece que a sala inteira decidiu lutar.

**Fala:** *"Hraaah! Este território é meu! Nenhum intruso sairá vivo!"*

## Sinal antes do ataque

Illfang quase nunca surpreende do nada — o aviso vem no peso. O escudo gira um
pouco antes do bloqueio bruto, o machado desce um ombro antes da varrida, e na
transição de fase o corpo inteiro muda de distância antes de o nodachi
aparecer.

## Ataques

- **Fase 1 — machado e broquel:** curto alcance, padrão de tanque, bloqueia
  tudo que vem de frente.
- **Fase 2 — nodachi:** gatilho é a última barra cair a um terço. Descarta
  machado e escudo, ganha alcance e velocidade e acesso a Skills de katana. O
  padrão muda por completo.
- **Convocar Sentinels:** 3 Ruin Kobold Sentinels no início e mais 3 a cada
  barra esvaziada — até 12 ao longo da luta.

## Fraquezas

- **Atributo — Destreza:** os golpes de machado têm tempo de leitura, e um ataque
  que usa Destreza vive nesse tempo — mesmo o nodachi abre janela entre um
  corte e outro. Esse golpe causa +1d6 de dano extra.
- Magia e ataque de área causam dano dobrado nos lacaios, nunca nele.
- Depende dos kobolds: isolá-lo enfraquece a defesa dele de verdade, e os
  golpes físicos dele são previsíveis o bastante para serem aparados.

## O que torna este encontro memorável

Muda de fase de um jeito que pune confiança preguiçosa. Obriga o grupo a
pensar em chefe **e** reforço ao mesmo tempo, transforma organização de raid
em mecânica real, e faz o último golpe parecer decisão, não matemática.

## Complicações úteis

- Um Sentinel atravessa a linha e força o grupo a dividir foco.
- Um grupo aliado quebra formação cedo demais.
- A troca para o nodachi acerta o personagem errado na posição errada.
- Illfang recua um passo só para abrir espaço de combo.
- O golpe final vira disputa entre necessidade e ego.

## Tabela de drop

| Item | Raridade | Qtd | Chance | Serve pra |
|---|---|---|---|---|
| Escama Dura | Comum | 4-6 | 100% | Ferreiro, Costureiro |
| Moeda Antiga de Aincrad | Incomum | 2-3 | 80% | Corretores, Bibliotecário |
| Coroa de Ossos de Illfang | Raro | 1 | 100% | Troféu de raid, 1 unidade |
| Cristal de Comando | Raro | 1 | 60% | Joalheiro |
| Nodachi de Illfang | Raro | 1 | 100% | Arma Única, só pro raid vencedor |
| Última Cravação | Raro | 1 | 15% | Item de bônus de atributo |
| Espada do Lorde Kobold | **Raro** | 1 | 60% | Arma (espada curta) para classe guerreiro |
| Couro Kobold Real | **Incomum** | 2 | 50% | Coureiro (armadura de chefe leve) |
| Cristal do Boss | **Raro** | 1 | 100% | Socket permanente de chefe em qualquer equipamento |
| Núcleo de Chefe | **Épico** | 1 | 100% | Craft de armas/armaduras de chefe nos andares altos |
| Carta "Illfang, o Lorde Kobold" | **Épico** | 1 | ~0.8% | Drop exclusivo do Boss de Andar; 1 carta equipável |
| Essência Kobold | **Épico** | 1 | 100% | Torna Raro em Único na bancada |
| Col | — | ~2000 dividido pelo raid | 100% | — |

**Também libera:** acesso ao Labirinto do Andar 2, para toda a guilda.

<!-- convertido-dnd5e -->

## Stat Block D&D 5e

Convertido automaticamente pela fórmula da Seção 73 do `SAO_RPG_5e.md` (Nível de Ameaça **chefe**, Andar 1). Os textos de "Ataques"/"Fraquezas" acima são flavor histórico (PBTA) — a mecânica real de jogo é esta:

- **CA:** 16
- **PV:** 165 (19d12+41)
- **Bônus de Ataque:** +6
- **CD de Resistência:** 15
- **Atributo de fraqueza:** Destreza — um ataque que usa Destreza contra esta criatura causa +1d6 de dano extra (Seção 73).

## Lore

Illfang é o líder supremo dos kobolds do Andar 1. Ambicioso e astuto, usa
táticas ardilosas e emboscadas para enfraquecer os inimigos antes de enfrentá-
los pessoalmente. Derrotá-lo enfraquece os kobolds e garante o controle da
região central. O que ninguém explica é por que uma criatura desenhada para
guardar uma porta desenvolveu hierarquia, insígnia, ordem de recuo e um
porta-estandarte que é substituído toda vez que morre.

*Ele não guarda a passagem. Ele a administra.*

## Notas para o mestre

- **Onde entra:** `chefe_illfang`, na Sala do Chefe.
- **Não é conteúdo de primeira sessão de grupo pequeno.** No anime é Diavel
  quem descobre a sala e convoca uma reunião geral com informação comprada de
  corretores — é assim que a luta é vencida. Trate como clímax de um arco de
  várias sessões: a primeira aventura deveria terminar com o grupo *perto* da
  porta, não *contra* ela.
- **Erro comum do grupo:** focar o chefe e ignorar o resto.
- **Como usar em transmissão:** guarde três imagens e volte a elas — a porta
  abrindo, o nodachi aparecendo, o silêncio depois do último golpe.
- **Ligação com o mistério:** a Essência Kobold e a linha interrompida da
  Câmara da Inscrição falam da mesma coisa. Ver `docs/misterio_andar2.md`.
