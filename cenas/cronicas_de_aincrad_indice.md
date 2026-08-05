---
titulo: Sword Art Online — Crônicas de Aincrad (Temporada 1, 50 Aventuras)
andar: 1
local: Cidade do Início e todo o mapa do andar 1
tipo: exploracao
uso: mestre
---

# Crônicas de Aincrad — Temporada 1

Coletânea de **50 one-shots** ambientadas no **dia 10** depois do anúncio de
Kayaba (mesmo ponto de partida de `docs/historia_campanha.md`), pré-chefe do
andar 1. Cada episódio pode ser jogado por um trio diferente de jogadores —
não é uma cadeia linear como `quests_andar1.md` (que usa `requer`/
`desbloqueia` rígido). Aqui a lógica é outra: **os episódios se tocam por
NPCs, rumores, objetos e acontecimentos**, não por pré-requisito. Qualquer
episódio pode ser a primeira sessão de um grupo novo.

Cada entrada em `cronicas_de_aincrad_ep01_25.md` e `cronicas_de_aincrad_ep26_50.md`
segue o mesmo padrão de profundidade das cadeias de `quests_andar1.md`: gancho,
leia em voz alta, o que está em jogo, estrutura em beats, testes sugeridos,
NPCs na cena, encontro (quando houver), complicações úteis, recompensas,
gancho pra próxima cena e gancho visual/de transmissão.

## Como isto se encaixa no que já existe

- **Mesmo dia, mesmo andar.** Nada aqui contradiz `docs/historia_campanha.md`.
  Illfang continua vivo, ninguém abriu o andar 2, a cidade ainda está dividida
  entre quem se tranca e quem já formou grupo de exploração.
- **`docs/misterio_andar2.md` continua sendo a única verdade sobre como o
  andar 2 abre** (Last Attack Bonus + Cristal de Ascensão). O arco Cardinal
  desta temporada (ver abaixo) é um mistério **paralelo e não-excludente**:
  fala sobre a natureza de Aincrad e do sistema que o administra, não sobre o
  mecanismo de progressão entre andares. Os dois segredos não devem se
  explicar um pelo outro na mesa — mantenha ambos como informação do mestre,
  liberada aos poucos.
- **Elenco reaproveitado.** Sempre que um NPC já catalogado (`npcs/`) encaixa
  no papel pedido pelo PDF original, o episódio usa esse NPC em vez de criar
  um novo — mantém `npcs/lynx.md`, `npcs/diavel.md`, `npcs/suri_cartografa.md`
  etc. como os mesmos rostos que os jogadores já podem ter visto nas quests
  principais. Personagens exclusivos de um único episódio são descritos
  inline (mesmo padrão de "crie na hora" usado em `quests_andar1.md`).
- **Monstros existentes primeiro.** `monstros/alfa_lupino.md`,
  `rei_das_planicies.md`, `lacustre_vagador.md`, `espectro_sussurrante.md` e
  outros já catalogados são reaproveitados quando o tema bate. Poucas
  criaturas novas (ex.: os slimes de EP.29) são descritas inline, sem ficha
  própria — se algum mestre quiser rodar o episódio com frequência, vale
  promovê-las a arquivo próprio em `monstros/` depois.

## Os dois arcos da temporada

### Arco A — Vida em Aincrad (episódios standalone)

A maioria dos episódios. Cada um funciona sozinho: uma escolta, uma investigação
pequena, uma disputa comercial, um resgate. Servem de "menu" — o mestre escolhe
o que combina com o grupo do dia. Muitos citam de passagem elementos do arco B
(uma marca vermelha, um boato sobre um homem de capuz cinza, um sino à meia-noite)
sem obrigar o grupo a persegui-los.

### Arco B — Cardinal (a espinha dorsal da temporada)

Um fio de mistério que atravessa a temporada inteira e fecha em EP.50. A ordem
abaixo é a sugerida, mas nenhum episódio exige o anterior — um grupo pode
esbarrar em qualquer ponto do fio e ainda fazer sentido, porque cada pista é
autocontida.

1. **EP.03 — A Casa de Porta Azul** · primeiro sinal: um imóvel que o sistema
   não deveria reconhecer.
2. **EP.09 — O Jogador que Não Dorme** · um avatar que não segue as regras do
   cliente do jogo.
3. **EP.10 — O Sino da Meia-Noite** · um som sem fonte física, ligado a
   comportamento de monstro.
4. **EP.12 — A Caverna dos Ecos** · vozes de jogadores mortos vindas de um
   lugar novo demais para ter história.
5. **EP.18 — A Espada de um Morto** · objetos "voltando" depois da morte do
   dono, fora da regra conhecida de drop.
6. **EP.24 — A Criança da Floresta** · uma NPC que conhece lugares que ainda
   não existem no mapa dos jogadores.
7. **EP.28 — A Guilda Fantasma** · um símbolo anterior ao lançamento oficial
   do jogo.
8. **EP.31 — O Túmulo sem Nome** · uma missão sem descrição, disparada por
   contato físico.
9. **EP.34 — A Canção que Ninguém Conhece** · uma melodia ligada a "outro
   lugar" de Aincrad.
10. **EP.37 — A Torre Enterrada** · uma estrutura que existia antes do
    servidor subir.
11. **EP.38 — O Mercador de Memórias** · um NPC repetindo histórias que
    ninguém contou a ele.
12. **EP.41 — A Sala 404** · um erro de acesso literal, com nome de erro de
    sistema.
13. **EP.42 — Os Sem-Cor** · avatares sem metadado de jogador.
14. **EP.45 — A Porta do Andar Zero** · a primeira coordenada concreta.
15. **EP.46 — Cardinal** · o nome do sistema aparece pela primeira vez.
16. **EP.47 — A Lista dos Quarenta** · nomes com eventos futuros anexados.
17. **EP.48 — O Dia em que Aincrad Parou** · o mundo trava por segundos.
18. **EP.49 — A Chave do Primeiro Andar** · o objeto que decide se o segredo
    vira público.
19. **EP.50 — Ecos de Aincrad** · o fechamento — não uma resposta completa,
    um ponto de virada.

O mestre nunca precisa entregar a explicação de Cardinal (é literalmente o
programa de administração de mundo de SAO, corrompido/incompleto e "vazando"
comportamento fora do previsto por Kayaba). Trate cada pista como fragmento —
o valor está na sensação de mundo vivo demais para ser só um jogo, não numa
palestra final.

## Tabela completa (arquivo onde está cada episódio)

| Ep. | Título | Tipo | Região principal | Arco |
|---|---|---|---|---|
| 01 | O Décimo Dia | Resgate/Escolha | Planície de Verrun | A |
| 02 | A Última Caravana | Escolta | Estrada de Ombric | A |
| 03 | A Casa de Porta Azul | Investigação | Cidade do Início | B |
| 04 | Caçada ao Alfa | Eliminação | Planícies (Verrun/Kaldan) | A |
| 05 | O Ferreiro sem Martelo | Investigação | Cidade do Início / mina | A |
| 06 | Flores para os Mortos | Investigação | Necrópole de Voss | A/B leve |
| 07 | O Mapa Incompleto | Exploração | Bordas do mapa conhecido | A |
| 08 | A Colheita de Mel | Coleta | Floresta de Horunka | A |
| 09 | O Jogador que Não Dorme | Investigação | Cidade do Início | B |
| 10 | O Sino da Meia-Noite | Investigação | Vila de Ashwen | B |
| 11 | O Preço da Cura | Investigação/Social | Tolbana | A |
| 12 | A Caverna dos Ecos | Investigação | Montanhas de Grauvenn | B |
| 13 | Caçadores de Recompensa | Investigação/Social | Posto de Kaldrin | A |
| 14 | O Banquete de Tolbana | Social | Tolbana | A |
| 15 | A Ponte Quebrada | Defesa/Investigação | Rio Coluber | A |
| 16 | O Homem de Capuz Cinza | Investigação/Social | Trilha de Corvain | A/B leve |
| 17 | O Lago sem Reflexo | Investigação | Lago Sylvaine | A/B leve |
| 18 | A Espada de um Morto | Investigação | Tolbana | B |
| 19 | A Trilha Vermelha | Investigação | Estrada entre Tolbana e Kaldrin | A |
| 20 | O Festival das Lanternas | Social | Vila de Brenmoor | A |
| 21 | A Mina Silenciosa | Investigação | Montanhas de Grauvenn | A |
| 22 | Sete Minutos | Exploração/Puzzle | Ruínas (dungeon secreta) | A |
| 23 | O Falso Guia | Investigação/Social | Campos ao redor da Cidade do Início | A |
| 24 | A Criança da Floresta | Investigação | Floresta de Horunka | B |
| 25 | Duelo ao Pôr do Sol | Social | Tolbana | A |
| 26 | A Receita Perdida | Coleta/Social | Espalhada (Tolbana/Horunka/Voss) | A |
| 27 | O Monstro que Fugiu | Eliminação | Perto do Labirinto | A |
| 28 | A Guilda Fantasma | Investigação | Necrópole de Voss / cavernas | B |
| 29 | A Noite dos Slimes | Defesa | Vale de Molwyn | A |
| 30 | Contrato de Mercenários | Escolta | Estradas do andar 1 | A |
| 31 | O Túmulo sem Nome | Investigação | Ruínas antigas | B |
| 32 | Os Três Portões | Puzzle/Exploração | Ruína isolada | A |
| 33 | Mercado Negro | Investigação/Social | Tolbana (submundo) | A/B leve |
| 34 | A Canção que Ninguém Conhece | Investigação | Tolbana | B |
| 35 | O Labirinto Vivo | Puzzle/Exploração | Dungeon pequena | A |
| 36 | O Primeiro PK | Investigação/Social | Posto de Kaldrin | A |
| 37 | A Torre Enterrada | Exploração/Investigação | Planície de Verrun | B |
| 38 | O Mercador de Memórias | Investigação | Torre de Aldric | B |
| 39 | A Caçada Dourada | Eliminação/Competição | Espalhado pelo mapa | A |
| 40 | O Cerco de Pedra | Defesa | Vila isolada (Molwyn) | A |
| 41 | A Sala 404 | Investigação | Hospedaria (Tolbana) | B |
| 42 | Os Sem-Cor | Investigação | Espalhado pelo mapa | B |
| 43 | A Coroa do Rei das Planícies | Eliminação/Chefe de campo | Planície de Verrun | A |
| 44 | O Julgamento | Social/Investigação | Tolbana | A |
| 45 | A Porta do Andar Zero | Investigação | Sob a Cidade do Início | B |
| 46 | Cardinal | Investigação | Sob a Cidade do Início | B |
| 47 | A Lista dos Quarenta | Investigação | Torre de Aldric | B |
| 48 | O Dia em que Aincrad Parou | Fenômeno | Cidade do Início | B |
| 49 | A Chave do Primeiro Andar | Investigação/Social | Espalhado pelo mapa | B |
| 50 | Ecos de Aincrad | Finale | Cidade do Início | B |

EP.01–25 estão em `cronicas_de_aincrad_ep01_25.md`; EP.26–50 em
`cronicas_de_aincrad_ep26_50.md`.

## Uso na mesa / transmissão

Mesma regra de `quests_andar1.md`: abertura forte, decisão visível,
complicação que avança em vez de travar, e um ponto de corte bom pra fim de
bloco. Episódios do arco B devem terminar sempre com **mais pergunta do que
resposta** — não resolva Cardinal antes de EP.50.
