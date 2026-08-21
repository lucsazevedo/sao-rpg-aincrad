---
titulo: Pontos — Planície de Verrun
regiao: campos_oeste
andar: 1
pontos: 11
---

# Pontos da Planície de Verrun

Conteúdo próprio de cada ponto clicável da região. O guia
(`guias/01_coracao_do_andar.md`) dá o clima geral; aqui está o que o mestre
precisa quando o grupo para num ponto específico. Mesmo molde de
`guias/pontos/cidade_inicio.md`.

---

### campos_acampamento · Acampamento de Caçadores

> Três barracas de lona puxada, uma fogueira baixa que nunca apaga de todo e
> Erik limpando uma flecha com o mesmo cuidado de quem limpa uma dívida. Os
> outros caçadores nem levantam a cabeça — forasteiro na planície não é
> notícia, é só mais gente que ainda não aprendeu o tamanho do risco.

**O que é:** ponto de apoio informal de caçadores independentes, sem vínculo
de guilda. Funciona como posto avançado da Cidade do Início — última parada
confortável antes do campo aberto de verdade.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Pedir esboço do terreno a Erik | d20+Sabedoria | Rota segura + aviso sobre o Alfa Lupino desperto (ver `campos_leste`) | Rota segura, sem aviso extra | Rota genérica, igual a qualquer mapa comprado |
| Trocar material de caça | — | Sem teste — troca justa por item de caça comum | | |
| Perguntar sobre os javalis da região | d20+Inteligência | Sabe exatamente onde evitar filhotes de Frenzy Boar | Sabe que existem, não onde | Nenhuma informação nova |

**Só o mestre:** Erik desconfia mais do que aparenta — ele é a mesma fonte
usada (ou não) em `EP.23 — O Falso Guia`. Se o grupo já viveu aquela cena,
ele comenta de passagem sobre o "guia" desmascarado, sem alarde.

**Atalhos:** npc:erik · regiao:campos_oeste

---

### campos_ruinas · Ruína de Superfície

> O bloco de pedra cinza não devia estar ali — destoa do chão marrom da
> planície como um dente errado. Metade enterrado, sem musgo, com uma face
> lisa demais pra erosão comum. Alguém talhou aquilo antes de virar ruína.

**O que é:** fragmento de estrutura antiga, mais velha que qualquer coisa que
Aincrad deveria ter no andar 1 — uma das pedras rúnicas espalhadas (ver
irmãs em Kaldan, Pemberton e Braxhold, citadas na descrição do Rei das
Planícies).

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Examinar o símbolo talhado | d20+Inteligência | Reconhece parte do símbolo — é mais antigo que o andar em si | Reconhece só que é estranho, sem mais detalhes | Não nota nada de especial |

**Só o mestre:** não force conexão com o mistério de Cardinal
(`cenas/cronicas_de_aincrad_indice.md`) na primeira visita — deixe como
curiosidade solta. Só puxe o fio se o grupo já tiver visto outra pedra igual
em outra região.

**Atalhos:** regiao:campos_oeste

---

### chefe_rei_planicies · Rei das Planícies (field boss)

> Grande como uma carroça, atravessa o descampado num passo só, sem pressa, e
> para de frente pro grupo a uns quarenta metros. A galhada tem três metros
> de envergadura e não é simétrica de nenhum jeito natural — os galhos
> crescem em ângulos que repetem, e o padrão que repetem é escrita. A
> pelagem também está escrita. É uma frase só, e ela dá a volta nele inteiro.

**O que é:** o chefe de campo da Planície de Verrun — ver ficha completa em
`monstros/rei_das_planicies.md` e a cena dedicada em
`EP.43 — A Coroa do Rei das Planícies`.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Ler a galhada antes da luta | d20+Inteligência | Reconhece a mesma escrita das pedras de Verrun, Kaldan, Pemberton e Braxhold | Reconhece que é escrita e que já viu igual, sem lembrar onde | Parece marca de pelagem comum — perde a única chance de ler com ele parado |
| Enfrentar (combate) | d20+Força | Ver `monstros/rei_das_planicies.md` | | |

**Só o mestre:** respawn de 24h — trate como evento de região, não farm
solo. O texto "escrito" na pelagem é o mesmo tipo de pista fragmentada usada
no arco Cardinal; não precisa decifrar aqui, só plantar.

**Atalhos:** monstro:rei_das_planicies · regiao:campos_oeste · quest:campos_oeste_boar2

---

### campos_oeste_boar1 · Frenzy Boar (spawn)

> Um montículo de terra remexida cava fundo demais pra ser coincidência, e o
> zumbido baixo que vem de dentro não é de inseto — é respiração de bicho
> irritado.

**O que é:** spawn comum de Frenzy Boar — primeiro combate típico de quem
sai pela primeira vez da Cidade do Início (ver `01_javalis_na_pastagem.md`).

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Enfrentar | d20+Força | Golpe limpo, sem reação | Acerta, mas o boar reage | Boar ataca primeiro |
| Rastrear antes de engajar | d20+Destreza | Percebe o boar antes dele perceber o grupo | Percebe no limite | Estumbra em cima dele |

**Só o mestre:** ameaça fraca (1-2 golpes) — não escale sem motivo. Serve
melhor como tutorial de combate do que como desafio real.

**Atalhos:** monstro:frenzy_boar · regiao:campos_oeste

---

### campos_oeste_boar2 · Frenzy Boar (spawn)

> Outro montículo, mais fundo na planície — este perto o bastante da ruína
> de pedra pra sugerir que o javali também sentiu que ali tem algo errado.

**O que é:** segundo spawn de Frenzy Boar, liberado depois de examinar
`campos_ruinas` — mesma criatura, contexto levemente mais tenso por causa da
proximidade com a ruína.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Enfrentar | d20+Força | Golpe limpo, sem reação | Acerta, mas o boar reage | Boar ataca primeiro |

**Só o mestre:** este spawn libera o Batedor Solitário e a Pedra Rúnica
Solitária adiante na cadeia de descoberta — não é obrigatório derrotá-lo pra
seguir, só serve de sinal de progresso no mapa.

**Atalhos:** monstro:frenzy_boar · regiao:campos_oeste

---

### campos_oeste_ervas · Ervas Comuns

> Moita baixa, folhas ásperas, espalhada nas bordas do caminho de terra —
> fácil de colher, fácil de machucar a mão se a pressa for maior que o
> cuidado.

**O que é:** ponto de coleta básico de Ervas Comuns, o material mais
acessível da região — bom pra Alquimista ou Cozinheiro de baixo nível.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Colher | d20+Destreza | Colhe 2 unidades sem se sujar | Colhe 1 unidade e se arranha em espinhos (marca leve) | Nada aproveitável |

**Só o mestre:** respawn rápido (6h) — bom ponto pra downtime de coleta
entre sessões (ver "Downtime entre sessões" em
`docs/regras_nucleares_campanha.md`).

**Atalhos:** regiao:campos_oeste

---

### campos_oeste_xtouceira_de_ervas · Touceira de Ervas

> A segunda moita fica mais perto da ruína — as folhas aqui têm uma tonalidade
> mais escura, quase cinza na base, como se tivessem absorvido um pouco da
> pedra ao lado.

**O que é:** segundo ponto de coleta de Ervas Comuns da região, revelado
depois de examinar `campos_ruinas`.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Colher | d20+Destreza | Colhe 2 unidades sem se sujar | Colhe 1 unidade e se arranha em espinhos (marca leve) | Nada aproveitável |

**Só o mestre:** puramente mecânico — use a variação de cor (mais escura,
perto da ruína) só se quiser plantar mais uma migalha ambiental do arco
Cardinal sem custo nenhum.

**Atalhos:** regiao:campos_oeste

---

### campos_oeste_xninho_de_insetos · Ninho de Insetos

> O zumbido aqui é mais agudo que o dos javalis — vespas, não porcos — e o
> ninho fica mais alto, preso na forquilha de um arbusto seco.

**O que é:** spawn de Stabbing Wasp — ameaça fraca, ataque à distância
curta, boa pra ensinar que nem toda ameaça do campo é corpo a corpo.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Enfrentar | d20+Força ou Reflexo | Golpe limpo | Acerta, mas a vespa pica de volta | Vespa acerta primeiro |

**Só o mestre:** liberado só depois de `campos_ruinas` — use isso pra
reforçar que a ruína "atraiu" atenção de mais bichos pra perto, não é
coincidência de mapa.

**Atalhos:** monstro:stabbing_wasp · regiao:campos_oeste

---

### campos_oeste_xpedra_runica_solitaria · Pedra Rúnica Solitária

> Igual à primeira ruína, só que menor e mais isolada — como se tivesse sido
> deixada de propósito longe da outra, pra quem procurasse com atenção real.

**O que é:** segunda pedra rúnica da região, liberada depois de derrotar
`campos_oeste_boar2` — reforça o padrão junto com `campos_ruinas`.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Examinar o símbolo | d20+Inteligência | Reconhece parte do símbolo — é mais antigo que o andar em si | Reconhece só que é estranho | Não nota nada de especial |

**Só o mestre:** duas pedras na mesma região começam a formar padrão — se o
grupo comentar sobre isso, é o gancho perfeito pra `EP.07 — O Mapa
Incompleto` (`cenas/cronicas_de_aincrad_ep01_25.md`).

**Atalhos:** regiao:campos_oeste

---

### campos_oeste_xbatedor_solitario · Batedor Solitário

> Sentado numa pedra alta o bastante pra ver boa parte do campo, ele observa
> mais do que fala — o tipo de gente que prefere saber tudo antes de decidir
> se vale a pena se apresentar.

**O que é:** NPC de apoio secundário, liberado depois de colher em
`campos_oeste_ervas` — vende informação de terreno equivalente a uma dica de
Cartógrafo.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Pedir esboço do terreno | — | Sem teste — vende de memória um esboço equivalente a uma dica de Cartógrafo | | |

**Só o mestre:** reaproveite como voz neutra caso o grupo precise de um
segundo ponto de vista sobre Erik ou sobre o Rei das Planícies — ele viu os
dois de longe, nunca de perto.

**Atalhos:** regiao:campos_oeste · npc:suri_cartografa

---

### campos_oeste_xpoco_raso · Poço Raso

> Uma depressão rasa no terreno junta água de chuva por dias — o suficiente
> pra atrair um tipo diferente de erva, mais suculenta, ao redor da borda.

**O que é:** terceiro ponto de coleta de Ervas Comuns da região, o mais
distante da entrada — recompensa a exploração completa da Planície de
Verrun.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Colher | d20+Destreza | Colhe 2 unidades sem se sujar | Colhe 1 unidade e se arranha em espinhos (marca leve) | Nada aproveitável |

**Só o mestre:** último ponto da cadeia de descoberta da região — bom marco
pra avisar o grupo (fora de ficção) que já viram tudo que a Planície de
Verrun tem pra mostrar nesta passada.

**Atalhos:** regiao:campos_oeste

---
