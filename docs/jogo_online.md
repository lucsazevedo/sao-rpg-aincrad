---
titulo: Jogo online diário — regras completas
andar: 1
uso: jogador_e_mestre
versao: 1.0
---

# Jogo online diário — regras completas

Este arquivo é a regra de verdade do "jogo online" entre sessões (a fase 2 do
site, decidida na pasta `dolist/`). Ele consolida os itens 1, 5, 6, 7, 8, 9,
10, 11, 12 e 14 da dolist e registra **as respostas das seções "Preciso
saber"** de cada um — o que estava em aberto foi fechado aqui.

O que vale na **mesa** continua valendo (Marcos, Condições, Favor/Suspeita).
O jogo online é uma camada separada: o que acontece nele vira item, Col e
história pra mesa, mas **nenhum item do online dá bônus mecânico dentro do
online** — chance de sucesso ali é só Nível de Profissão (item 12).

## Vocabulário

- **Col**: a moeda. Duas bolsas por personagem: `col_mao` (o que carrega,
  perdível em Bug) e `col_guardado` (seguro, em cidade).
- **Fôlego**: a energia do dia. Toda ação custa Fôlego.
- **Bug**: o estado de punição (renomeado de "Desmaio" — tema VRMMO: o
  personagem "bugou"). Acumulativo.
- **Nível**: sempre **Nível de Profissão** (item 5). Não existe nível de
  personagem genérico, e a mesa continua evoluindo só por Marcos — os dois
  sistemas não se misturam.

## Fôlego (Estamina — ritmo casual, já decidido)

- Teto: **20 + 5 × Espírito** (mínimo 20). Barra enche do zero ao teto **a cada 6 horas**,
  regeneração calculada de forma preguiçosa a partir de `folego_atualizado_em`.
- Dá pra logar 1-2x ao dia sem grind de app.
- Fôlego é a **única restrição de volume por dia**. Não há teto de Col de craft
  nem de venda entre jogadores — só missão do sistema custa Fôlego.
- Custos: ação de ofício **3**, combate comum **4**, chocar ovo **5**,
  miniboss **10**, boss **15**. Ação arriscada (acima do seu Nível) exige Fôlego
  mínimo igual ao dobro do custo — não dá pra arriscar no osso.

## Estado de Bug (acumulativo por stack)

- Falhar numa tentativa arriscada: **+1 stack de Bug**. Cada stack multiplica
  o tempo de trava: **stack 1 = 2h, stack 2 = 4h, stack 3 = 8h, stack 4 = 16h
  (teto máximo)**. Além disso, perde **20% do Col da mão** (o guardado está seguro).
- Bug **não decai por hora**. A única forma de reduzir stack é:
  **passar um dia INTEIRO sem entrar em estado de Bug** (nenhuma falha nova,
  e o tempo de `bug_ate` já passou) → **−1 stack** no reset diário.
- Tempo que o personagem já está travado (dentro de `bug_ate`) **não conta**
  como dia passado — é preciso estar livre de Bug, sem falhar nada, durante
  um dia todo para reduzir 1 stack.
- Enquanto `bug_ate` não passou, nenhuma ação que custa Fôlego pode ser
  feita. Pagar **200 Col por stack** limpa tudo na hora (templo/Médico).

## Nível de Profissão e XP (item 5)

- **Um personagem = uma profissão** (decidido: sem múltiplas profissões por
  personagem). Tabela `nivel_profissao` registra XP e Nível da profissão
  única do personagem.
- Curva: pra subir do nível N pra N+1 custa **N × 100 XP**. Nível máximo
  10 no Andar 1 (mesma escala do `nivel_recomendado` dos monstros).
- Ganho: combate comum **10 XP**, contrato arriscado **25 XP**, boss
  **100 XP**, missão diária conforme o quadro (35-90), craft concluído
  **Comum 5 / Incomum 15 / Raro 40**.
- Incubadora (e ferramentas de ofício em geral) **têm receitas desbloqueadas
  por Nível de Profissão** — a cada 2 níveis, a ferramenta pode upar um
  degrau (nível 1/2 → ferramenta nível 2, nível 3/4 → ferramenta nível 3,
  etc.), sempre craftado pelo próprio ofício.

## Chance de sucesso (item 12 — sem Poder por equipamento)

Poder por equipamento foi **descartado** (item do online não tem efeito
online, então não há o que somar). A régua única é o Nível:

```
chance = 70%  quando Nível de Profissão == nivel_recomendado do alvo
       + 10%  por nível ACIMA (teto 95%)
       − 10%  por nível ABAIXO (piso 5%)
       + 20%  se a arma usada bate o atributo_fraqueza do monstro (item 13)
```

- **Acesso**: abaixo do `nivel_recomendado` − 2, a região/monstro nem
  aparece como opção (trava de visibilidade). Acima disso mas abaixo do
  recomendado, a tentativa é **arriscada**: falha ativa Bug.
- **Sucesso arriscado dá drop cheio** (decidido — vale arriscar de
  propósito quando o Bug é administrável). Mas cada item do drop tem sua
  própria chance — rola-se 1d100 por item: ex, carta de MVP = 1% (só cai
  em 100), material de Comum = 60% (cai até o 60). Se você tirar 90, leva
  todos os itens com chance ≤ 90% — por isso o drop "raspando" pode ser
  menor, mesmo que a tentativa em si tenha dado sucesso.
- Bônus de fraqueza de atributo é **fixo** (+20%), não escala.

## Fraqueza de atributo (item 13 — resumo; a migração do conteúdo é outra)

Fogo/Trovão/Gelo/Veneno **saíram do jogo inteiro**. Cada monstro tem agora
`atributo_fraqueza` (convertido pra **FOR/DES/INT/SAB** na conversão pra
D&D 5e — `SAO_RPG_5e.md` Seção 65; nunca CON/CAR).

- **Na mesa**: a mecânica de fraqueza mudou de natureza na conversão pra
  D&D — acertar a fraqueza não "anula a reação do monstro" mais, e sim
  soma **+1d6 de dano extra** no ataque (`SAO_RPG_5e.md` Seção 73). Ver
  `docs/elementos_andar1.md` (hoje redirect histórico com o detalhe da
  mudança).
- **No online**: +20% de chance, como acima — este bônus percentual
  continua sendo a tradução assíncrona da fraqueza, mesmo com a mecânica
  de mesa tendo mudado de "nega reação" pra "+1d6".

## O que dá pra fazer por dia (item 11)

- **Combate/exploração**: enfrentar monstro de região desbloqueada (comum,
  arriscado, miniboss/boss). **Sem PvP** (decidido). Boss e miniboss
  **exigem grupo de 2-3 jogadores** (decidido: não dá pra solo).
- **Ofício**: as mesmas 3 Ações de Ofício que cada uma das **16 profissões**
  já tem (todas entram na v1 — decidido), cada uma rendendo material, Col
  ou reputação.
- **Craft**: inicia (consome material), espera o tempo da raridade
  (**Comum ~10 min, Incomum 1-3h, Raro 6-12h**), coleta na `craft_fila`.
- **Social**: missão do quadro (3 por dia, sorteadas dos templates de
  `missoes_quadro`), ajudar outro jogador (alimenta reputação), comprar e
  vender nas vitrines.

## Inventário e equipado (item 8)

- Tabela `inventario` (tipo: arma, equipamento, consumivel, material,
  carta, cristal, ovo, pet). **Um personagem por conta** (decidido — a conta
  liga em `personagens.dono_id`, índice único — não dá pra ter mais de um).
- Equipar é vitrine/organização, não cálculo: slots em `personagens.equipado`
  (arma, armadura, escudo, capuz, acessorio, luvas, parte_cima,
  parte_baixo, **carta — só 1**). O que está equipado é o que o mestre
  considera "levado pra mesa".

## Drops estilo MMO (item 7)

| Categoria | Material | Equipável | Carta | Cristal       |
| --------- | -------- | --------- | ----- | ------------- |
| Comum     | ✓        |           |       |               |
| Mini Boss | ✓        | ✓         |       |               |
| MVP       | ✓        | ✓         | ✓     |               |
| Boss      | ✓        | ✓         | ✓     | ✓ (exclusivo) |

- **% de drop por item** (cada item rola independentemente no sucesso):
  - Material Comum: 60%, Incomum: 30%, Raro: 10%
  - Equipável de Mini Boss: 15% / MVP: 25%
  - **Carta de MVP: ~1%** (só cai se o d100 tirar 100) / **Carta de Boss: ~5%**
  - **Cristal de Boss: 100%** (sempre cai, exclusivo)
- **Carta**: efeito de **bônus de atributo, dano ou resistência** (decidido),
  valor definido carta a carta. Vale **apenas quando levada pra mesa** de
  RPG. Raridade efetiva igual a **Raro**. Um personagem só equipa **1 carta
  no total**.
- **Cristal de boss**: encaixa em equipamento como **socket** (bônus
  adicional), exclusivo de Boss. Registrado em `inventario.cristal_id`.
  Valor/efeito definido por cristal.
- **Ovo** (item 1): dropa de **qualquer monstro domável** (decidido: não é
  lista fechada). Chance de **~5% por abate bem sucedido**.

## Domador → Criador (item 1 — decisões fechadas)

- Ovo dropa de **qualquer fera domável** (não é lista fechada).
- **Ovo SUBSTITUI a doma de adulto** (decidido: a antiga Move de Ofício —
  Doma de adulto selvagem no campo — deixa de existir; todo pet agora vem
  por chocagem). A nova via é o **pet-item** via ovo, que é craft com
  raridade, regido pela régua de `armas/00_catalogo_expandido.md`.
- O efeito do pet escala **com a raridade E também com a espécie de
  origem** (decidido: ovo de Alfa Lupino Comum já é melhor que ovo de Slime
  Comum — a espécie dá um teto base, a raridade distribui dentro dele).
- **Incubadora** (ferramenta do Domador, item 14): 5 níveis, **receita
  desbloqueada por Nível de Profissão do Domador** (nível 1 → incubadora 1,
  nível 3 → incubadora 2, nível 5 → incubadora 3, nível 7 → incubadora 4,
  nível 9 → incubadora 5). **O próprio Domador crafta sua Incubadora**
  (decidido: cada ofício crafta a própria ferramenta, não é Ferreiro que
  faz). Cada nível melhora a chance de chocar (na mesa: o mestre sobe uma
  faixa de resultado; no online: +5% por nível).
- Rastreio na tabela `criaturas_domadas` (incubando → ativo), com
  cronômetro de chocagem igual craft Raro (6-12h).
- A habilidade "Domador — Ovo de Fera" (desenhada em `dolist/Domador.png`)
  está registrada em `SAO_RPG_5e.md` (Seção 42, Domador) e na
  `moves_profissao` (campo `move_c` da linha "Domador").

## Ferramentas de ofício (item 14 — decisões fechadas)

- **Uma ferramenta por profissão**, já no catálogo desde a v1 (16
  ferramentas em `ferramentas_oficio`).
- **Cada ofício crafta a própria ferramenta** (decidido: Domador faz a
  Incubadora, Ferreiro faz a Forja, Alquimista faz o Destilador, etc. —
  não é Ferreiro que faz tudo todo mundo).
- Ferramenta é **item único que upa** (não quebra, não é consumível): 5
  níveis, **receita de upgrade desbloqueada por Nível de Profissão** (a
  cada 2 níveis de profissão, libera o próximo degrau da ferramenta).
- Bônus: multiplicador **local**, só na ação que ela cobre — separado do
  Nível de Profissão geral. No online: **+3% de chance por nível** naquela
  ação (até +15% no nível 5). Na mesa: sobe uma faixa de resultado
  (ex: Falha vira Sucesso parcial, Sucesso parcial vira Sucesso total,
  `SAO_RPG_5e.md` Seção 66) a cada 2 níveis.

## Dinheiro e mercado (item 9 — decisões fechadas)

- Carteira: `col_mao` + `col_guardado` (guardar/resgatar é ação gratuita,
  mas **só em cidade** — na ficção, você deposita no banco da cidade).
- **Sem teto de Col para craft e para venda entre jogadores** (decidido).
  A única restrição de volume diário é o **Fôlego** (custa só em missão e
  combate do sistema). Vendas de jogador → jogador **não contam em nada**
  — a economia real gira entre pessoas.
- **Mercado por jogador** (decidido): cada jogador tem sua **vitrine**
  (lista item do inventário com preço livre). A página de mercado agrega
  todas as vitrines ativas — compra é um clique via `comprar_da_vitrine`.
- **Preço livre** (decidido: cada jogador define o preço que quiser), com
  o preço de referência do catálogo exibido ao lado como dica (o mestre
  audita pela `transacoes`; se algo desbalancear, ajusta na mão).
- Toda movimentação vira linha em `transacoes` (quem pagou quem, o quê,
  quando).

## Reputação de jogador (item 10 — decisões fechadas)

- Escala **−3 a +3**, mesma do Favor/Suspeita da mesa. Tabela
  `reputacao_personagem` (personagem × alvo: clã, cidade ou facção).
- Sobe com missão social, ajuda a clã, contrato cumprido; desce com
  falha pública, calote, ato contra o grupo. No online, muda no máximo
  **1 ponto por alvo por dia** (espelho da regra de sessão da mesa).
- O jogador tem reputação com **próprio clã e com cada frente** (cidades
  e facções) — mesmo desenho da tabela clã→cidade que já existe.
- **Mordomias (OS DOIS, decidido)**:
  - **Online**: +1 = desconto de 10% em compras de NPC/vitrine da frente;
    +2 = missões especiais extras no quadro; +3 = acesso a área/contrato
    exclusivo. Negativo: −1 = 10% mais caro, −2 = quadro só tem missão
    básica, −3 = boicote (não vende pra você).
  - **Na mesa**: o número de reputação do site **alimenta diretamente o
    Favor/Suspeita** da regra de mesa — é o mesmo idioma, não precisa
    anotar duas vezes. O mestre lê o número e aplica.

## Ordem de construção (registro)

1. `scripts/db/schema_jogo_online.sql` — tudo acima no banco.
2. `scripts/web/jogo.html` — o hub do jogador (status, ações, quadro,
   craft, inventário, vitrine, reputação).
3. Conteúdo: drops por monstro (item 7), cartas/cristais/ovos, ferramentas,
   moves novos (item 2), fraquezas de atributo (item 13).
4. Rodar `gerar_dados_web.py` + `migrar_para_supabase.py` (sobrescreve o
   banco com o md — ver o aviso de `docs/pipeline.md`).
