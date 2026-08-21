---
titulo: Guia do Mestre — Andar 1
andar: 1
---

# Guia do Mestre — Andar 1

Isto é um **escudo do mestre**, não um mapa de jogador. Tudo está visível
desde o primeiro minuto: você abre a região onde o grupo está, lê a caixa em
voz alta, e tem à mão tudo que dá pra fazer ali, o que acontece se demorarem,
e o que só você sabe.

Para informação **pública** de mesa — o que personagens sabem, o que podem
perguntar sem teste e o que costuma pedir rolagem — ver
`docs/guia_publico_andar1.md`.

Os quatro arquivos de região:

| Arquivo                     | Regiões                                                                                                                                                  |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `01_coracao_do_andar.md`    | Cidade do Início, Castelo de Ferro Negro, Planície de Verrun, Estepes de Kaldan, Posto de Kaldrin, Estrada de Ombric, Torre de Aldric, Jardim de Fenwyth |
| `02_oeste_e_sul.md`         | Floresta de Horunka, Bosque de Ashwen, Rio Coluber, Vila de Brenmoor, Caverna de Mournhall, Necrópole de Voss, Campo de Ruyn, Trilha de Corvain          |
| `03_leste_e_aguas.md`       | Lago Sylvaine, Ilha de Pemberton, Charco de Grenna, Vale de Molwyn, Terraços de Solveig, Pântano de Kavir, Gruta de Lumis, Pedreira de Dunhelm           |
| `04_norte_e_o_labirinto.md` | Montanhas de Grauvenn, Colinas de Braxhold, Penhascos de Vaelor, Tolbana, Limiar do Labirinto, Covil de Illfang                                          |

Tudo isso aparece no Compêndio (`scripts/web/compendio_andar1.html`), aba
**Mapa** → clicar numa região. O `.md` é a fonte; rodar
`python scripts/gerar_dados_web.py` atualiza o app.

## Como cada região está montada

**Leia em voz alta** — o parágrafo de chegada. Escrito pra ser lido literal,
sem adaptar. Curto de propósito: dá o clima e devolve a palavra aos jogadores.

**A cena** — o que existe ali de verdade, pra você improvisar em cima:
luz, som, cheiro, quem passa, o que está fora do lugar.

**O que dá pra fazer aqui** — a tabela de ações com o teste de cada uma e os
três resultados. É a parte que você mais vai consultar. Um jogador que
pergunta "posso...?" quase sempre tem a resposta nessa tabela.

**Só o mestre** — o que os jogadores não sabem e como isso se paga depois.

**Se o grupo demorar** — o que o mundo faz quando ninguém faz nada. Use pra
manter a região viva sem inventar do zero.

**Locais** — os pontos nomeados da região, um a um.

**Ligado a** — quests, NPCs, monstros e itens que puxam pra essa região.

## Como puxar uma região para nível S

Se A+ é "boa de narrar", nível S é "ninguém esquece depois". Para isso, a
região precisa entregar pelo menos três destas quatro coisas na mesma visita:

- **imagem forte** — algo que a mesa consiga ver na cabeça,
- **pressão humana** — alguém quer, esconde, mede ou evita alguma coisa,
- **decisão de custo real** — tempo, recurso, reputação, risco ou vínculo,
- **mudança perceptível** — o lugar não está igual quando o grupo volta.

Perguntas boas para o mestre antes da cena:

- O que quem assiste vai lembrar deste lugar amanhã?
- O que neste lugar faz o grupo falar entre si, e não só rolar dado?
- Que detalhe muda se o grupo demorar?
- Quem neste lugar reage ao grupo antes de ser procurado?

## Três regras de condução

**1. Toda rolagem responde uma pergunta que já foi feita.** Não peça teste
antes do jogador declarar o que quer. Se a ação não está na tabela, escolha o
atributo pelo _como_, não pelo _o quê_: arrombar com o ombro é Força, com uma
gazua é Destreza, convencendo o guarda a abrir é Inteligência.

**2. sucesso parcial sempre custa alguma coisa.** Se você não achar o custo, use um
destes: gasta tempo (o mundo avança), gasta recurso, chama atenção, o
resultado vem incompleto, ou a informação vem certa mas atrasada.

**3. falha nunca é "nada acontece".** É complicação. Prefira mover a história a
tirar pontos — o inimigo chega, o item some, o NPC muda de ideia, o barulho
atrai algo. Só quebre equipamento (ver `equipamentos/00_indice.md`) quando não
tiver nada melhor a cobrar.

## Regra de ouro para transmissão

Quando a cena estiver boa, não explique demais. Dê:

- uma imagem,
- uma escolha,
- uma reação,
- e um corte.

Quase toda cena memorável do andar 1 cabe nessa sequência.

## Como o combate corre (leia antes de rodar a primeira luta)

**Quem age é o jogador. O monstro reage.** Não existe iniciativa, não existe
turno do inimigo, não existe rolagem de ataque do monstro. O jogador declara o
que faz, rola d20+atributo, e o resultado decide o que o monstro consegue
fazer a respeito:

| Resultado | O que acontece                                                                                        |
| --------- | ----------------------------------------------------------------------------------------------------- |
| **Sucesso total**   | O golpe entra limpo. O monstro **não reage** — nenhum contra-ataque, nenhum custo                     |
| **Sucesso parcial**   | O golpe entra **e** o monstro reage: contra-ataque, mordida, você fica exposto, o barulho chama outro |
| **Falha**    | O golpe não entra e o monstro faz o que quiser. Aqui é onde o mestre narra o dano                     |

Consequência prática: **bônus de "atacar primeiro" não existem neste sistema** —
o grupo sempre age primeiro. O que tem valor é o oposto: **negar a reação**.
Todo item ou Skill que parecia dar iniciativa foi reescrito nesses termos
(a `Lança da Vigília` e a Skill **Tiro Suspenso** são os dois exemplos).

Quando um monstro tiver que agir sem ninguém ter atacado — emboscada, um bicho
que aparece do nada, uma armadilha viva — **não role por ele**. Narre o que
ele fez e peça ao jogador um teste pra reagir (Reflexo pra desviar, Corpo pra
aguentar, Espírito pra não travar). O dado continua sempre na mão do jogador.

## Escala de perigo do andar

| Faixa          | Regiões                                                                   | Perfil                                                    |
| -------------- | ------------------------------------------------------------------------- | --------------------------------------------------------- |
| Segura         | Cidade do Início, Tolbana, Horunka, Brenmoor                              | Zona segura de sistema — não dá pra atacar ninguém dentro |
| Nível 1-4      | Verrun, Fenwyth, Molwyn, Cidade do Início, Brenmoor, Tolbana              | Onde se aprende a jogar                                   |
| Nível 3-6      | Kaldan, Ombric, Kaldrin, Coluber, Horunka, Solveig, Sylvaine              | O andar começa a cobrar                                   |
| Nível 5-7      | Ashwen, Grenna, Pemberton, Aldric, Braxhold, Corvain, Voss, Ruyn, Dunhelm | Exploração com risco real                                 |
| Nível 6-9      | Lumis, Kavir, Mournhall, Grauvenn, Vaelor, Labirinto I-III                | Precisa de grupo e preparo                                |
| Nível 8-10     | Labirinto IV-V, Covil de Illfang                                          | Conteúdo de raid                                          |
| Fora da escala | Dungeon Oculta sob o Castelo                                              | Não é pra vencer. É pra assustar                          |
