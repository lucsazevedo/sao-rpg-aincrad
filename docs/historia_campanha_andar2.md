---
titulo: História da campanha — Andar 2 (abertura)
andar: 2
uso: mestre
status: esqueleto inicial
---

# Andar 2 — Abertura da campanha

**Aviso de escopo:** isto é o **esqueleto inicial** do andar 2, não o andar
inteiro. Cobre a abertura narrativa, uma cidade principal (Urbus), 4
monstros, 6 NPCs e 9 quests de entrada — o suficiente pra rodar as
primeiras sessões. O andar 1 levou dezenas de arquivos (30 regiões, 45
monstros, 44 NPCs, mais de 60 quests) construídos ao longo de várias
rodadas; o andar 2 deve crescer do mesmo jeito, sob demanda.

## Como o andar 2 abre (mecânica)

Ver `docs/misterio_andar2.md` — **isto continua sendo a única verdade
sobre o mecanismo**, e não muda com este documento. Resumo pro contexto:
matar Illfang não abre o andar 2 sozinho. Quem desfere o **Last Attack**
contra o chefe de andar recebe um **Cristal de Ascensão** — item nunca
visto antes, que abre caminho pro andar 2 quando usado junto ao corpo do
chefe derrotado (ou num ponto ainda não identificado da sala do chefe).

Isso significa que a chegada ao andar 2 **não é simultânea pra todo mundo**.
O jogador (ou grupo) que desferiu o Last Attack decide quando — e se —
compartilha essa descoberta. Use isso dramaticamente: os primeiros grupos a
chegar no andar 2 podem chegar sozinhos, sem saber ainda como o resto da
força-tarefa vai seguir.

## Estado no início do andar 2

- **Clima social:** a notícia de que Illfang caiu se espalha rápido pela
  Cidade do Início e por Tolbana — é a primeira prova real de que os 100
  andares são vencíveis, não só teoria de Kayaba. Isso rende esperança
  genuína, mas também uma corrida: quem sobe primeiro guarda vantagem de
  recurso, informação e prestígio.
- **Transição física:** o Cristal de Ascensão, usado no ponto certo da sala
  do chefe, abre uma passagem de luz — sem cerimônia, sem efeito
  espetacular de sistema. Quem atravessa sente o mesmo tipo de "clique" de
  ± um segundo que marca troca de andar em Aincrad; do outro lado, luz
  natural, ar diferente, o som da Cidade do Início já sumiu de vez.
- **Geografia:** o andar 2 é hills/planalto árido, bem menos verde que o
  andar 1 — o contraste deve ser sentido de imediato (ver `mapas/andar_2.md`).
  Ao contrário do andar 1 (terreno misto sem tema único), o andar 2 tem um
  problema concreto compartilhado por toda a população: **falta de água
  natural**. O suprimento vem de um sistema de aquedutos que canaliza água
  do Lago Sylvaine (andar 1) andar abaixo — mecanismo de Cardinal, não
  força da natureza, e ninguém sabe dizer com certeza se ele vai continuar
  funcionando pra sempre.
- **Cidade principal:** **Urbus** (canônico — ver `cidades/urbus.md`),
  construída ao redor do ponto de chegada dos aquedutos.
- **Chefe do andar:** **Baran, o Rei Touro** (canônico — nome e forma geral
  de minotauro/besta cornígera com martelo; detalhes de combate são
  homebrew, marcados como tal na ficha).

## O que NÃO muda

- O mistério de Cardinal (arco B de `cenas/cronicas_de_aincrad_indice.md`)
  continua em aberto — ele não pertence a um andar específico. Se o grupo
  que chega no andar 2 é o mesmo que investigou a Porta do Andar Zero
  (`EP.45`), isso é ótimo gancho de continuidade, mas não obrigatório.
- Sistema de regras (`docs/regras_nucleares_campanha.md`,
  `docs/guia_sistema_aincrad.md`) vale igual em qualquer andar.

## Ganchos de abertura (escolha um ou combine)

1. **Sozinhos no topo.** O grupo que abriu o andar 2 chega sem ninguém
   mais — decide sozinho o que contar pra força-tarefa lá embaixo.
2. **Corrida silenciosa.** Outro grupo descobriu o mecanismo por conta
   própria (ou por acaso) e já está alguns dias à frente — o grupo dos
   jogadores chega em segundo lugar, tendo que negociar informação em vez
   de descobrir tudo do zero.
3. **A cidade já sabe.** Tempo suficiente já passou (semanas de jogo) pra
   Urbus estar estabelecida como ponto de apoio — o grupo chega como mais
   um entre vários, sem holofote, e precisa construir reputação do zero.

## Próximos blocos (quando for hora de expandir)

- Mais regiões além de Urbus (o andar 2 tem colinas, aquedutos, e
  provavelmente uma segunda cidade menor — nome e conteúdo a definir).
- Mais monstros e NPCs além dos 4+6 iniciais.
- A masmorra/labirinto do andar 2 e o confronto completo com Baran.
- Integração ao Compêndio (`scripts/gerar_dados_web.py` já lê `monstros/`,
  `npcs/` e `cenas/` de forma genérica — os arquivos novos do andar 2
  aparecem no app assim que forem criados, sem trabalho extra de pipeline).
