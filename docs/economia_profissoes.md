# Economia de profissões — Andar 1 (v2)

> **Atualizado pra D&D 5e.** A tabela de profissões e atributos abaixo foi
> corrigida pra bater com `SAO_RPG_5e.md`, Seção 19 ("Redistribuição desta
> etapa") — que é uma reatribuição posterior à conversão simples de
> atributo por atributo (Seção 65) e é o valor realmente usado por
> `mod_atributo_personagem` no jogo online. Além disso, a conversão pra
> D&D **fundiu 4 das 16 profissões originais em 2**: Bibliotecário +
> Cartógrafo + Diplomata → **Informante**; Coveiro → **Mercenário** (Seção
> 13/15). O sistema atual tem **15 profissões**, não 16 — a tabela abaixo
> mantém as linhas separadas (o conteúdo econômico de cada uma continua
> distinto e útil), mas marca quem se fundiu em quem.

## Princípio de design (corrigido)

**Não é cooperação simultânea — é cadeia de compra.** Uma profissão não
precisa de OUTRO JOGADOR presente e trabalhando ao mesmo tempo; ela precisa
de um **componente já processado** que essa outra profissão vende no
mercado. O Ferreiro processa minério cru em **Placas de Metal Refinado**
(um item, vendável, estocável) — o Costureiro compra essa placa de
qualquer Ferreiro, a qualquer hora, e usa junto com material próprio pra
fazer a armadura. Ninguém precisa estar "presente" pra receita funcionar.

Isso é economia de MMO de verdade: produção primária (caça/coleta) →
processamento (profissão intermediária) → produto final (profissão que
monta o item) → venda. As profissões estão em `SAO_RPG_5e.md`, Seções
30-44.

As habilidades de profissão (progressão por nível 1/5/10/15/20) vivem no
`SAO_RPG_5e.md` (Seções 20-26 e 30-44). Este documento existe para detalhar
economia, cadeia de produção, tabelas e mecânicas de mapa. Em caso de
conflito, use o rulebook como regra de mesa.

## As profissões — o que cada uma realmente faz

Atributo já corrigido conforme a redistribuição de `SAO_RPG_5e.md` Seção
19. Bibliotecário/Cartógrafo/Diplomata e Coveiro seguem listados abaixo
pelo valor econômico distinto que cada um cobre, mas mecanicamente já não
são profissões separadas — ver nota de fusão em cada linha.

| Profissão | Atributo | Produz/faz | Precisa comprar/obter de |
|---|---|---|---|
| **Caçador** | Sabedoria | Abate monstros e extrai **material de caça bônus** (só ele consegue, teste de Destreza no corpo do monstro) — ver tabela por monstro abaixo | Nada — é fonte primária |
| **Lenhador** | Força | Coleta Madeira e **Madeira Rara** (variante ocasional) na Floresta | Nada — fonte primária |
| **Domador** | Sabedoria | Amansa criaturas vivas (viram aliados/montarias) — precisa de petisco/item específico por criatura | Petiscos específicos, às vezes do Cozinheiro/Alquimista |
| **Ferreiro** | Força | Processa Minério Raro + Madeira em **Placas de Metal Refinado**, **Lâminas** — vende esses componentes; também forja armas/armaduras direto | Minério Raro (Caçador/mineração), Madeira (Lenhador) |
| **Costureiro** | Destreza | Faz roupas/armaduras leves — precisa de Pelagem/Couro (caça) + Placas de Metal Refinado (Ferreiro) pras partes reforçadas | Ferreiro |
| **Joalheiro** | Destreza | Acessórios com Escama Prateada/Ovule + fio de prata | Comerciante (fio, importado) |
| **Alquimista** | Inteligência | Poções/antídotos com Seiva/Ervas + frascos | Comerciante (frascos) |
| **Cozinheiro** | Inteligência | Pratos com bônus temporário, usa carne de caça + ervas | Caçador (carne), coleta própria (ervas) |
| **Médico** | Sabedoria | Trata status negativos com Ervas + um componente do Alquimista | Alquimista |
| **Comerciante** | Carisma | Importa frascos, fio de prata, tecido — capital pra financiar outros | Nada — importa de fora do andar |
| **Cartógrafo** *(fundido em Informante)* | Inteligência | Mapeia áreas — revela pontos ocultos no mapa mais rápido, indica rotas seguras | Nada — trabalha com exploração própria |
| **Bibliotecário** *(fundido em Informante)* | Inteligência | Pesquisa monstros/lore com antecedência — revela resistência/fraqueza antes do combate | Acesso a livros/pistas (às vezes do Coveiro) |
| **Diplomata** *(fundido em Informante)* | Inteligência | Negocia entre as guildas (Sindicato, LHUB, Dndalcin, iBarr's, Terraço Geek, Guilda de Nerds) — reduz tensão, abre acesso a recompensas de guilda | Nada — usa reputação/roleplay |
| **Coveiro** *(fundido em Mercenário)* | Sabedoria | Cuida do memorial dos jogadores que morreram — pode aprender segredos/pistas ligadas aos mortos | Nada — acesso ao memorial |
| **Mercenário** | Constituição | Escolta outras profissões até zonas perigosas (Montanhas, Labirinto) por uma parte do material coletado | Nada — vende força |
| **Músico** | Carisma | Toca na praça — afeta preços/moral, carrega pistas escondidas em cantigas (ver puzzle do mural) | Nada |

## Mecânicas concretas de mapa por profissão

Toda profissão precisa de algo jogável no mapa, não só uma frase de
descrição — mesmo padrão de "criaturas domáveis" acima, aplicado às
profissões de Conhecimento que ainda estavam só em prosa.

### Cartógrafo (hoje Informante — ver `SAO_RPG_5e.md` Seção 32)

Corresponde à habilidade de Nível 10 do Informante, **Mapa Vivo**.

**Ao entrar numa região do mapa** (`scripts/web/dados_mapa.js`) **ainda sem
nenhum ponto descoberto**, o Informante com esse foco pode parar, observar e
testar **d20+Inteligência** antes de explorar normalmente (graus de
sucesso, `SAO_RPG_5e.md` Seção 66):
- **Sucesso total** (bate a CD por 5+): revela de uma vez todos os pontos
  tipo `sempre` da região (os que não exigem `requer`) e o mestre deve
  indicar uma rota segura entre dois marcos óbvios da região.
- **Sucesso parcial** (bate a CD por menos de 5): revela metade desses
  pontos (arredondado pra cima, escolhidos pelo mestre ou por ordem de
  proximidade), mas isso cobra tempo ou exposição (o mestre escolhe).
- **Falha**: nenhum bônus — a região se explora do jeito normal.

Pontos de "vista alta" já existentes no mapa (Mirante das Colinas,
`bounty_04_vista_do_topo` nos Penhascos de Vaelor, o topo das Montanhas de
Grauvenn) dão **vantagem automática** (role com vantagem, ou +2, conforme
a mesa) nesse teste — é literalmente o tipo de lugar de onde um
Cartógrafo trabalha melhor.

**Venda de mapas**: uma região totalmente descoberta pelo Cartógrafo pode
ser vendida como mapa físico a outro grupo por Col (sugestão: 10 Col por
ponto revelado da região).

### Bibliotecário (hoje Informante — ver `SAO_RPG_5e.md` Seção 32)

Corresponde à habilidade de Nível 1 do Informante, **Rede de Informações**
(d20+Inteligência+proficiência vs. CD, Seção 29).

**Antes de um combate contra qualquer monstro do bestiário** (mesmo um já
enfrentado antes), o Informante com esse foco pode pesquisar com
antecedência — só funciona com acesso a uma fonte real, não em qualquer
lugar:
- **Torre de Aldric** (NPC Estudioso Obcecado, `npcs/estudioso_obcecado.md`)
  é a fonte principal — ele coopera de graça se o grupo já tiver
  construído alguma relação com ele.
- **Memorial de Voss** (NPC Zelador do Memorial) é fonte secundária pra
  monstros ligados a mortes de jogadores especificamente.

Teste **d20+Inteligência** (graus de sucesso, Seção 66):
- **Sucesso total**: revela a fraqueza principal e mais 1 detalhe útil
  (hábito, prioridade de alvo, medo, padrão de patrulha ou “o que ele
  nunca faz”).
- **Sucesso parcial**: revela só a fraqueza principal, mas a fonte cobra
  algo (tempo, favor, exposição, Col).
- **Falha**: nada, e consome o tempo de preparo mesmo assim.

### Mercenário

Já coberto por conteúdo de quest existente (`tolbana_e07_guarda_costas_por_um_dia`,
`bounty_06_caravana_emboscada`) — escoltar outra profissão até uma zona
perigosa (Montanhas de Grauvenn, Labirinto) rende uma parte do material
coletado pelo escoltado, além do pagamento em Col da própria quest.

## Cadeia de produção — exemplo completo

```
Caçador (campo)  ──► Minério Raro ──► Ferreiro ──► Placas de Metal Refinado
                                                          │
Caçador (campo) ──► Pelagem Azulada ──────────────────────┤
                                                          ▼
                                              Costureiro: Armadura de Couro Reforçada
```

Nenhum dos três precisa estar no mesmo lugar/hora — só precisa existir um
mercado (a Cidade do Início e Tolbana já cumprem esse papel) onde
comprar/vender.

## Material de caça por monstro (exclusivo do Caçador)

| Monstro | Material bônus de caça | Teste |
|---|---|---|
| Frenzy Boar | Presa completa (drop normal é só XP/Col; a presa intacta exige extração cuidadosa) | d20+Destreza |
| Stabbing Wasp | Glândula de veneno intacta | d20+Destreza |
| Little Nepenthes | Seiva pura sem contaminar (evita o spray) | d20+Destreza |
| Lacustre Vagador | Garras completas | d20+Força |
| Ruin Kobold Trooper/Sentinel | Fragmento de armadura sem amassar | d20+Destreza |

## Criaturas domáveis (Domador)

> **Mecânica de doma atualizada.** `SAO_RPG_5e.md` Seção 42 (Domador,
> Nível 1) substitui a antiga "barra de sucessos" por um **teste único**:
> **d20 + Sabedoria + proficiência (Adestrar Animais) vs. CD por
> criatura** (CDs padrão na Seção 29: Fácil 10, Moderada 12, Difícil 15,
> Muito difícil 18, Excepcional 20). A coluna "Sucessos p/ domar" abaixo
> foi convertida pra CD equivalente, preservando a régua relativa de
> dificuldade entre as criaturas; o petisco/item continua sendo pré-
> requisito narrativo pro teste valer, não algo que se gasta em várias
> tentativas.

Cobertura completa do bestiário do andar 1 — toda criatura tem status
explícito de doma, não só as que viraram quest.

| Nível de ameaça | CD de doma |
|---|---|
| Fraco | 10 (Fácil) |
| Comum | 12 (Moderada) |
| Forte | 15 (Difícil) |
| Elite/raro | 18 (Muito difícil) |
| Excepcional (Arauto) | 20 (Excepcional) |

| Criatura | Domável? | CD de doma | Petisco/item necessário | Resultado |
|---|---|---|---|---|
| Frenzy Boar | Sim | 10 | Ervas comuns oferecidas repetidamente (paciência, não item raro) | Montaria pequena/aliado de combate fraco |
| Toca na Raiz | Sim | 10 | Ervas comuns | Aliado de combate fraco, bom "primeiro bicho" |
| Libélula Cortante | Sim | 10 | Nenhum item — só paciência e um teste de Destreza pra acompanhar o voo | Batedor rápido, bônus em testes de percepção em área aberta |
| Morcego Ecoante | Sim | 10 | Nenhum item — silêncio total durante a aproximação | Batedor de caverna, ajuda a evitar emboscada em dungeon |
| Corvo das Ruínas | Sim | 10 | Item pequeno e brilhante como oferenda (qualquer bugiganga Comum) | Mensageiro/batedor aéreo de curto alcance |
| Lobo das Estepes | Sim | 12 | Carne crua de qualquer caça (Frenzy Boar serve) | Aliado de combate leal, ataca em conjunto com o dono |
| Fada da Poeira | Sim | 12 | Néctar de Flor Rara (Jardim de Fenwyth) | Aliado utilitário — ilumina áreas escuras, sem combate |
| Sombra de Mournhall | Sim | 15 | Isca com Musgo Luminoso (Alquimista) — ela é avessa à luz forte, a isca precisa ser fraca e constante | Aliado que enxerga no escuro, útil em dungeon |
| Stabbing Wasp | Sim | 15 | Feromônio calmante feito pelo Alquimista | Aliado de reconhecimento/vigilância, não de combate direto |
| Urso de Pedra | Sim | 15 | Grande quantidade de comida de uma vez (não repetida) | Aliado tanque, absorve dano por quem o domou |
| Águia de Pedra | Sim | 15 | Mesma lógica do Arauto, em escala menor | Montaria terrestre/curtos voos, alternativa mais rápida de conseguir que o Arauto |
| Serpente das Águas Rasas | Sim | 15 | Isca de peixe fresco deixada por 3 dias seguidos no mesmo ponto | Aliado aquático mais ágil (porém mais frágil) que o Lacustre Vagador |
| Lacustre Vagador | Sim | 18 | Isca feita com Ferrão de Vespa (ver receita) | Aliado que ajuda em terreno aquático |
| Arauto das Alturas | Sim | 20 | Ritual de oferenda de penas próprias (coletadas de outro Arauto) no topo das Montanhas de Grauvenn | Montaria voadora — a doma mais rara e valiosa do andar 1 |
| Little Nepenthes | Não — é planta, não forma vínculo | — | — | Alquimista pode replantar uma muda como armadilha estática, mas não é aliado |
| Trepadeira Estranguladora | Não — planta | — | — | — |
| Coruja das Sombras | Não — solitária e evasiva demais | — | — | Caçador ainda extrai material dela |
| Predador de Vaelor | Não — territorial e agressivo demais | — | — | — |
| Escorpião de Poeira | Não — instinto de ataque puro, sem vínculo possível | — | — | — |
| Rã Venenosa Gigante | Não — glândulas de veneno ativas demais pra aproximação seguir | — | — | — |
| Sanguessuga Gigante | Não — sem inteligência pra reconhecer um "dono" | — | — | — |
| Verme de Cristal | Não — reage só a vibração, não a presença | — | — | Guardião natural de veios de cristal — bom obstáculo de coleta |
| Gafanhoto Gigante | Não — praga, não indivíduo | — | — | Ameaça de `bounty_05_colheita_ameacada` |
| Enxame do Rio | Não — é cardume, não indivíduo | — | — | — |
| Espectro Sussurrante | Não — não-corpóreo | — | — | — |
| Sentinela Esquecida | Não — construto/anomalia, não animal | — | — | — |
| Armadura Animada | Não — construto | — | — | — |
| Ruin Kobold Trooper/Sentinel/Arqueiro | Não — muito hostil/estruturado (é tropa, não animal) | — | — | — |
| Guardião de Mournhall | Não — miniboss, força incompatível com vínculo | — | — | — |
| Illfang the Kobold Lord | Não — chefe de andar | — | — | — |

## Receitas revisadas

### Placas de Metal Refinado — Ferreiro (componente, não item final)
**Precisa**: Minério Raro + Madeira (combustível da forja).
**Efeito**: item vendável, ingrediente de outras receitas (armadura, armas melhores).

### Armadura de Couro Reforçada — Costureiro
**Precisa**: Pelagem Azulada (própria ou comprada de um Caçador) + Placas
de Metal Refinado (**comprada** de um Ferreiro, não precisa dele presente).

### Frasco de Antídoto — Alquimista
**Precisa**: Seiva de Nepenthes (limpa) + frasco vazio (comprado do Comerciante).

### Isca para Lacustre Vagador — Domador/Caçador
**Precisa**: Ferrão de Vespa + tempo de observação no lago.
**Efeito**: atrai ou amansa (ver tabela de doma) sem combate direto.

### Anel de Escama Prateada — Joalheiro
**Precisa**: Escama Prateada + fio de prata (comprado em Tolbana).

### Javali Assado — Cozinheiro
**Precisa**: Presa/carne de Frenzy Boar (comprada de um Caçador) + ervas comuns.

## Como isso gera interação (revisado)

O jogador não precisa de OUTRO JOGADOR no mesmo instante — precisa do
**mercado funcionando**, o que empurra pra: (1) alguém vender o que
produz, (2) alguém comprar o que falta, (3) preços/escassez virarem
assunto de roleplay real (um Ferreiro pode recusar vender Placas pra
alguém de guilda rival, por exemplo — aí sim vira interação direta).
