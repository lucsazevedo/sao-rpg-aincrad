# Fontes de referência externas

## SAO Fandom Wiki (anime/light novel) — fonte principal
https://swordartonline.fandom.com/wiki/Sword_Art_Online_Wiki

Base canônica principal da campanha (é o que o anime/light novel realmente
mostra). Usar como primeira fonte sempre que possível.

## SAO Integral Factor Wiki — fonte secundária (jogo mobile oficial)
https://saointegralfactor.fandom.com/wiki/Sword_Art_Online:_Integral_Factor_Wiki

MMORPG mobile oficial da franquia, com história/personagens/chefes
**próprios** (não é o mesmo enredo do anime) — mas geograficamente ambientado
no mesmo Aincrad, então serve como material extra rico quando o anime não
detalha algo (NPCs de quest genéricos, monstros de campo adicionais, layout
de área). Wiki grande (~6.500 artigos: história principal, quests de
personagem, quests de evento, chefes, sistema de skills por arma, pesca
etc.) — **não vale a pena importar tudo de uma vez**; melhor consultar sob
demanda quando precisar de algo específico (ex: "como é o chefe X" ou
"tem alguma NPC pra tipo de quest Y").

### Já aproveitado de lá nesta sessão
- Monstro **Stabbing Wasp** (`monstros/stabbing_wasp.md`)
- NPCs **Troubled Woman** e **Bow-Lover Girl** (Praça do Portão de Teletransporte)
- Nomes de sub-região dos campos: Quest Plains / Rivalry Plains, vila-dungeon
  Horunka Woods — usados como "nomes alternativos" no mapa, sem substituir a
  geografia do anime (floresta/Horunka vila, lago, montanhas)

### Ainda não explorado (bom pra pedir depois, sob demanda)
História principal do jogo, quests de personagem, categoria de chefes
(`Category:Boss`), sistema de skills por tipo de arma, minigame de pesca.

## "Sword Art Online 5e Conversion v1.0" (Cableguy 5e Content) — referência de conversão pra D&D 5e

`Sword Art Online 5e Conversion v1.0.pdf` (fornecido pelo usuário, também
disponível em https://www.scribd.com/document/440084451/Sword-Art-Online-5e-Conversion-v1-0-pdf).
Conversão fanmade completa de SAO pra D&D 5e (classes = arma, Sword Skills
disparadas por acerto crítico, Cor como moeda, cores de cursor/Player
Killer, lista de andares canônicos 1-100, cristais consumíveis, culinária).

Usada como referência na etapa de conversão pra `SAO_RPG_5e.md` — não
copiada 1:1 (nosso sistema já tinha uma estrutura de arma/Sword Skill mais
desenvolvida, com 19 armas × 8 Skills cada). O que foi aproveitado de lá:

- **Ações de Equipe** (Troca/Provocar/Ajudar) — adaptado quase que
  diretamente, é terminologia canônica do anime (`<<Switch>>` etc.), não
  invenção do autor do PDF.
- **Cores de cursor / Player Killers** — sistema canônico do anime,
  ausente do nosso documento até esta etapa; adicionado.
- **Lista de andares conhecidos** (1-100, nomes de cidade/local por andar)
  — cruzado contra `cidades/cidade_do_inicio.md` (andar 1) e
  `cidades/urbus.md` (andar 2), que já batem com essa lista; usado como
  referência canônica pra desenvolver andares futuros.

O que **não** foi aproveitado (o nosso sistema já resolve melhor ou de
forma incompatível com decisões já tomadas): classes via subclasse de D&D
tradicional (nosso sistema usa arma + Sword Skills próprias, não
reaproveita subclasses prontas), Sword Skill disparada só em crítico
(nosso sistema trata Sword Skill como substituta do ataque básico, sem
depender de sorte de dado), sistema de upgrade +1..+10 de arma (nosso
crafting já é mais desenvolvido, ver `docs/economia_profissoes.md` e
`scripts/db/schema_*.sql`), efeitos de status ligados a elemento
(Fogo/Veneno) — o sistema já removeu elementos deliberadamente
(`dolist/13_remover_elementos.md`), Beast Tamer com "magia" (contraria o
princípio de "sem magia tradicional" da Seção 3 do `SAO_RPG_5e.md`).

## Fórum "Sword Art Online Plus (a Pathfinder Campaign Journal)" — giantitp.com

https://forums.giantitp.com/showthread.php?423757 — indicado pelo usuário,
mas **inacessível** (bloqueia fetch automatizado, 403). Pela busca, é um
actual-play de Pathfinder ambientado num Aincrad homebrew **com magia**
("individual twist with the inclusion of magic") — o que já contraria o
princípio central desta conversão (sem magia tradicional). Não usado nesta
etapa; se o usuário quiser algo específico de lá, precisa colar o
conteúdo diretamente (fetch automatizado não funciona nesse fórum).

## Material próprio do usuário — ideias de aventura

`SAO_Cronicas_de_Aincrad_50_Aventuras.pdf` (fornecido pelo usuário): 50
loglines de uma linha para uma "Temporada 1" de one-shots. Aprofundadas
integralmente em `cenas/cronicas_de_aincrad_indice.md` +
`cenas/cronicas_de_aincrad_ep01_25.md` + `cenas/cronicas_de_aincrad_ep26_50.md`,
seguindo o mesmo padrão de `quests_andar1.md` e ancoradas no elenco/bestiário
já catalogado (`npcs/`, `monstros/`).
