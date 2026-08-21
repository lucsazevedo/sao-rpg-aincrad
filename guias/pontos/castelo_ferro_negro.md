---
titulo: Pontos — Castelo de Ferro Negro
regiao: castelo_ferro_negro
andar: 1
pontos: 5
---

# Pontos do Castelo de Ferro Negro

Mesmo molde de `guias/pontos/cidade_inicio.md`. Guia geral da região em
`guias/01_coracao_do_andar.md`. Cadeia G de `cenas/quests_andar1.md`
("O Mural do Castelo") expande tudo aqui em prosa completa — este arquivo é
o resumo por ponto pro Compêndio.

---

### castelo_patio · Pátio do Castelo

> Um mural de pedra com 5 encaixes vazios, cada um com o contorno de um
> tipo de cristal. Ninguém carrega os 5 tipos sozinho normalmente —
> Teleporte e Cura são comuns, Antídoto um pouco menos, Luz e Barreira são
> raros de verdade. O mural não parece trancado. Parece paciente.

**O que é:** o puzzle central do castelo — ver `castelo_02_cinco_cristais`
em `cenas/quests_andar1.md` pra sequência completa (Teleporte → Cura →
Antídoto → Luz → Barreira).

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Examinar o mural | d20+Inteligência | Confirma a sequência antes de tentar encaixar | Suspeita da ordem, sem certeza | Nenhuma pista nova |
| Encaixar os cristais | d20+Destreza | Encaixe físico preciso | Encaixe funciona, mas com hesitação visível | Erro ativa alarme sonoro leve |

**Só o mestre:** reunir os 5 cristais é a verdadeira sub-quest — Luz e
Barreira exigem negociação real, não só Col. Ver `docs/mercado_andar1.md`.

**Atalhos:** regiao:castelo_ferro_negro · quest:castelo_02_cinco_cristais

---

### castelo_dungeon_oculta · Entrada da Dungeon Oculta

> Uma escada descendente maldisfarçada atrás de uma coluna do castelo.
> Ninguém confirmou publicamente que ela existe, e quem já viu não
> esquece: os degraus são bem-feitos demais e descem mais do que o castelo
> tem altura. O que vive lá embaixo está muito acima do Andar 1 — não é
> conteúdo de primeira aventura, e o andar não avisa isso de nenhuma outra
> forma.

**O que é:** acesso à Dungeon Oculta (Scavenge Toad e afins) — fora da
escala normal do andar 1. Ver `docs/misterio_andar2.md` pra por que ela
importa sem precisar ser vencida.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Descer alguns degraus com cautela | d20+Destreza | Entende a escala pelo eco e volta antes de ser notado | Volta, mas algo lá embaixo mudou de posição enquanto o grupo estava na escada | O grupo desce um lance a mais do que devia — a subida deixa de ser tranquila |

**Só o mestre:** **nunca** transforme isso em dungeon completa pra um grupo
de nível andar 1. O valor é sentir a escala e recuar — igual ao design de
`castelo_02` (acesso parcial sem enfrentar o monstro de frente).

**Atalhos:** regiao:castelo_ferro_negro

---

### castelo_camara · Câmara da Inscrição

> Sala de três por três metros atrás do mural, seca e sem poeira — o que é
> errado. Uma parede inteira coberta de escrita miúda, no mesmo alfabeto de
> Verrun, Kaldan, Pemberton e Braxhold, feita com algo parecido com giz que
> não sai quando se passa o dedo. Não é antiga: é recente. Na altura do
> peito, a escrita para no meio de uma linha, como se quem escrevia tivesse
> sido interrompido e nunca voltado. No chão, um anel de ferro com cinco
> depressões; na parede, um martelo com as mesmas cinco.

**O que é:** a primeira pista concreta e real do mistério do andar 2 (ver
`docs/misterio_andar2.md`) — sem precisar enfrentar o Scavenge Toad.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Ler a inscrição | d20+Inteligência | Lê a linha interrompida inteira — entende que fala do golpe final e de verificar algo antes do próximo andar | Lê o suficiente pra saber do que se trata, sem reproduzir de memória | A letra é regular e pequena demais — leva tempo, e alguém vai notar a demora |

**Só o mestre:** o Anel dos Cinco Encaixes (+1 Conhecimento pra decifrar) e
o Martelo do Mural (+1 Corpo contra estrutura/construto, revela vazio atrás
de pedra gravada) são recompensa física real, além da informação. Guarde
esta cena como a mais importante da cadeia G.

**Atalhos:** regiao:castelo_ferro_negro · quest:castelo_02_cinco_cristais

---

### castelo_ferro_negro_xrachadura_na_muralha · Rachadura na Muralha

> Fenda fina na pedra, escondida atrás de uma trepadeira — fácil de chamar
> de desgaste comum se ninguém estiver olhando com a cabeça certa.

**O que é:** ponto fraco possível na defesa do castelo — ver
`castelo_03_rachadura_na_muralha` em `cenas/quests_andar1.md`.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Investigar sem ser notado | d20+Destreza | Encontra um ponto fraco real na defesa — guarda em segredo | Encontra, mas é visto por um guarda de longe | Não acha nada, parede só velha mesmo |

**Só o mestre:** se o grupo for visto (sucesso parcial), planta desconfiança que
`castelo_04_guarda_insone` cobra depois — não revele a consequência na hora.

**Atalhos:** regiao:castelo_ferro_negro · quest:castelo_03_rachadura_na_muralha

---

### castelo_ferro_negro_xguarda_insone · Guarda Insone

> Sempre no mesmo posto, mesmo fora do turno dele — os outros guardas acham
> estranho e preferem não comentar.

**O que é:** o Guarda Insone (`npcs/guarda_insone.md`) — ponte entre
suspeita e confirmação sobre a muralha. Ver `castelo_04_guarda_insone`.

**O que dá pra fazer:**

| Ação | Teste | Sucesso total (CD+5) | Sucesso parcial | Falha |
|---|---|---|---|---|
| Conversar à noite | d20+Sabedoria | Confirmação com detalhes | Confirmação parcial e desconfiada | Negação total, mesmo sabendo — mas o grupo percebe a mentira |

**Só o mestre:** se `castelo_03` teve falha (foi visto), esta conversa
começa em desvantagem — ele já está de guarda alta antes mesmo de começar.

**Atalhos:** npc:guarda_insone · regiao:castelo_ferro_negro · quest:castelo_04_guarda_insone

---
