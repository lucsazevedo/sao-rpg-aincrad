# Interações de chegada e segredos — Andar 1

Interações que disparam quando o grupo **chega** num local, antes de
qualquer objetivo formal — o mundo reage à presença deles, em vez de
esperar que perguntem. Foco em roleplay, não combate.

## Como usar este arquivo para deixar a campanha mais viva

Este documento funciona melhor quando o mestre trata cada entrada como um
**microepisódio**, não como nota lateral.

Checklist rápido:
- alguém quer alguma coisa do grupo,
- o grupo sente que chegou num lugar que já estava em movimento,
- a interação deixa um rastro (rumor, dívida, rosto conhecido, desconforto),
- e o segredo associado não depende de “ter a ideia certa do nada”.

## Regra de ouro dos segredos

Segredo bom no Andar 1 não é “coisa escondida porque sim”. É sempre uma destas:
- alguém viu e não entendeu,
- alguém entendeu e não contou,
- algo está à vista, mas falta contexto,
- ou o mundo está reagindo de um jeito que só jogador atento percebe.

## Interações de chegada

### Cidade do Início — "Você tem um minuto?"
Sempre que o grupo retorna à praça depois de uma expedição, um NPC
aleatório (ou a Mulher Aflita, se ela ainda não tiver pedido nada) se
aproxima com um pedido pequeno e imediato — não uma quest formal, só uma
interação de 2-3 falas. Ex: "Vocês vieram dos campos? Viram alguma
Nepenthes por lá? Preciso de seiva, pago bem." Se ignorado, ela tenta de
novo na próxima vez.

**Para render cena:** o pedido precisa parecer pequeno, mas revelar ansiedade
real. O grupo ainda não deve saber se está vendo carência, oportunismo ou medo.

### Horunka — "Vocês não são daqui"
Primeira vez que o grupo entra em Horunka, o dono da pousada os encara com
desconfiança educada antes de qualquer outra coisa — Horunka vive de
caçadores que já a conhecem, forasteiros chamam atenção. Ele pergunta o
que os traz ali antes de oferecer preços justos (se a resposta for
hostil/evasiva, cobra mais caro; se for sincera, relaxa e dá uma dica
sobre a floresta).

**Para render cena:** deixe o silêncio antes da resposta pesar. Horunka começa
avaliando caráter antes de vender ajuda.

### Tolbana — "Informação tem preço"
Ao entrar em Tolbana pela primeira vez, um corretor de informação aborda o
grupo direto: "Vocês são do andar 1? Novidade sobre o Labirinto sai R$
Col fixo — quer ouvir?" — gancho direto pro mistério do andar 2
(`docs/misterio_andar2.md`), mas o que ele vende é sempre misturado com
teoria falsa (ver seção de red herrings no documento do mistério).

**Para render cena:** não faça o corretor soar como expositor; faça soar como
alguém vendendo confiança em varejo.

### Entrada do Labirinto — "Vocês viram o Marco?"
Um jogador solitário (NPC, "Marco") está sentado perto da entrada,
claramente abalado, esperando um grupo que nunca voltou. Não pede ajuda
diretamente — só está ali, e reage se o grupo perguntar. Bom gancho
emocional antes de entrar no Labirinto pela primeira vez (estabelece risco
real sem precisar de combate).

**Para render cena:** Marco não precisa chorar nem pedir socorro. Basta estar
ali cedo demais, quieto demais, por tempo demais.

## Segredo — Entrada Oculta do Castelo de Ferro Negro

**Não é a Dungeon Oculta inteira** (isso continua nível muito acima do
andar 1) — é um acesso parcial, só até um ponto com uma pista sobre o
mistério do andar 2.

**O puzzle**: no pátio do Castelo de Ferro Negro existe um mural de pedra
com 5 encaixes vazios, cada um com o contorno de um tipo de cristal
(Teleporte, Cura, Antídoto, Luz, Barreira — ver `docs/guia_sistema_aincrad.md`).
Colocar os 5 cristais nos encaixes na ordem certa abre uma passagem parcial.

**A pista da ordem certa** não fica no mural — fica espalhada:
- Um Músico busker na Cidade do Início canta uma cantiga infantil cuja
  letra, prestando atenção, descreve a ordem — recompensa jogadores com
  profissão Músico ou que parem pra ouvir de verdade.
- Alternativa: um verso quase idêntico está rabiscado na parede da
  Dungeon Oculta.

**A cantiga** ("Verso da Viagem do Peregrino Perdido"):

> *Azul foi o primeiro passo, que o levou pra longe de casa,*
> *Verde a folha que curou seu pé cansado,*
> *Roxo o fruto que tirou o mal do corpo,*
> *Dourada a luz que guiou seu caminho na noite,*
> *Prata o escudo que o protegeu até o fim.*

Cada verso corresponde a uma cor de cristal, na ordem certa de encaixe:
**Teleporte (azul) → Cura (verde) → Antídoto (roxo) → Luz (dourado) →
Barreira (prata)**. Ver cadeia G (`cenas/quests_andar1.md`) pra estrutura
completa das quests que levam até aqui.

**Por que isso promove interação**: nenhum jogador carrega os 5 tipos de
cristal sozinho normalmente — Cura e Antídoto vêm de drop/loja, Teleporte é
comum, Luz e Barreira são mais raros. Reunir os 5 exige comprar, trocar ou
pedir emprestado de outros jogadores/grupos.

**Recompensa ao resolver**: acesso a uma câmara pequena (não à Dungeon
Oculta principal) com a inscrição cifrada citando "recompensa do golpe
final" — a primeira pista real e concreta do mistério do andar 2, sem
precisar enfrentar o Scavenge Toad.

**O que muda no mundo:** depois que o grupo abre a Câmara, o Guarda Insone
deixa de parecer paranoico e passa a parecer certo.

## Segredo — O Código da Floresta (Floresta de Horunka)

**Mecanismo**: as marcas entalhadas em troncos espalhados pela floresta
(ver ponto "Marca no Tronco" no mapa, e as quests `horunka_02`/`horunka_04`/
`horunka_08` em `cenas/quests_andar1.md`) não são decoração nem mensagem
de monstro — são um código informal que os caçadores de Horunka usavam
entre si antes do dia 1, indicando direção e distância até esconderijos de
suprimento de emergência. O **Eremita da Floresta** conhece o código
porque ele mesmo era caçador antes de se isolar.

**Como se resolve**: cada marca encontrada (há pelo menos 3 espalhadas pela
região) registra um símbolo. Sozinhas não dizem nada; só fazem sentido
depois que o Eremita ensina a "gramática" do código (teste de Espírito em
`horunka_04` — sucesso total ensina o código completo). Com o código em
mãos, as marcas já vistas apontam pra **um** esconderijo específico: o
próprio, abandonado quando ele parou de caçar.

**Recompensa**: um diário de caçador preservado (explica, em poucas linhas
e sem melodrama, por que ele parou — motivo pessoal, não uma conspiração)
e um kit de caça Incomum bem conservado, um dos primeiros feitos na vila,
de antes de todo mundo perceber que o jogo era real. Ítem de sabor, não
arma poderosa — o valor é narrativo.

**Por que promove interação**: exige tanto exploração (achar as marcas)
quanto construir confiança com um NPC específico (o Eremita não ensina o
código pra quem não demonstrou respeito antes) — combina bem com
`horunka_01` como pré-requisito social informal.

**O que muda no mundo:** Horunka deixa de tratar o grupo como visita e passa a
tratá-lo como gente que sabe voltar da floresta com mais do que carne.

## Segredo — O Nome Apagado (Necrópole de Voss)

**Mecanismo**: uma lápide no memorial teve o nome raspado de propósito
(ver `necropole_01` a `necropole_05`). Não é um mistério sinistro — é
pessoal: a pessoa enterrada ali morreu numa forma que envergonhava alguém
próximo (uma dívida não paga, uma covardia num momento de pânico, algo
banalmente humano), e esse alguém — que ainda visita o memorial sob
anonimato, sempre em horários diferentes — pediu ao **Zelador do
Memorial** pra apagar o nome, temendo julgamento dos outros jogadores.

**Como se resolve**: não tem "combinação certa" — é investigação social.
O grupo precisa (1) ganhar a confiança do Zelador (`necropole_02`), que só
solta a história se convencido de que o grupo não vai usar isso pra
humilhar ninguém; e (2) reconhecer, cruzando datas/comportamento, quem é o
visitante anônimo (pode ser um NPC já estabelecido em outra região, à
escolha do mestre — boa oportunidade de reciclar um NPC existente e dar
profundidade a ele).

**Recompensa**: não é item — é peso narrativo e uma escolha real
(`necropole_05`): confrontar o visitante anônimo, guardar segredo, ou
ajudar a reconciliar a situação sem expor ninguém. Bom gancho de roleplay
puro, sem risco de combate.

**O que muda no mundo:** uma decisão nesta linha deve ecoar em outra região.
Se Talia for NPC já conhecido, a relação com ela nunca mais volta ao neutro.

## Segredo — O Que o Redemoinho Esconde (Lago Sylvaine)

**Mecanismo**: o redemoinho no lago (ponto "Redemoinho Estranho",
`lago_02`/`lago_06`) só se comporta de forma anômala em certas condições —
não é hostil, é um artefato visual de como o motor do jogo renderiza uma
correnteza artificial mal ajustada nesse trecho específico do andar (um
"glitch" sutil de design, não sobrenatural). Ele **só fica visível** durante
uma janela (ao entardecer, ou depois de o grupo já ter perturbado a água
da região em outra quest — critério do mestre) — fora dessa janela, parece
só uma correnteza comum.

**Como se resolve**: não tem "quebra-cabeça" de peças — é um puzzle de
observação e timing. Quem presta atenção (teste de Conhecimento) percebe o
padrão de quando ele aparece; o Barqueiro (`lago_06`) confirma isso se
convencido a falar. Investigar de perto na janela certa (teste de Corpo
pra não ser puxado) revela o efeito de perto.

**Recompensa**: não é um item de poder — é uma peça real, mas incompleta,
do quebra-cabeça maior do andar 2 (mesmo princípio de fragmento parcial
que `docs/misterio_andar2.md` já estabelece pras outras fontes — beta
tester, corretores, Dungeon Oculta, Lynx). O mestre decide quanto revelar;
o efeito narrativo é reforçar que **existem imperfeições no mundo** que
jogadores atentos notam antes de qualquer NPC confirmar algo.

**O que muda no mundo:** depois de ver isso de perto, água “normal” do andar
deveria parecer um pouco suspeita para o grupo por algumas sessões.

## Próximos segredos a criar (fora de escopo por agora)

- Um miniboss opcional na floresta, não ligado ao mistério, só pra
  recompensa de exploração
- Um segredo em Tolbana estruturado como puzzle numérico/lógico (não
  social) — ainda não desenhado
