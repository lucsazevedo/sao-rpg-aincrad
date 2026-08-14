---
titulo: Mercado do Andar 1 — quem vende o quê, por quanto
andar: 1
---

# Mercado do Andar 1

Lista de preço e estoque **por vendedor**, cobrindo o roster completo: 50
armas (`armas/`), 66 equipamentos (`equipamentos/`), materiais
(`docs/economia_profissoes.md`), consumíveis e Cristais. Cada vendedor
corresponde a um ponto de categoria `comerciante` que já existe em
`scripts/web/dados_mapa.js` — nenhum vendedor novo foi inventado.

## Como o dinheiro funciona nesta mesa

**Col** é a moeda. Referências pra calibrar qualquer preço que você precise
improvisar:

| Coisa | Col |
|---|---|
| Frenzy Boar abatido | ~30 |
| Noite de estalagem | 15 |
| Refeição preparada por um Cozinheiro | 20-40 |
| Quest Fácil | 20-50 |
| Quest Média | 50-120 |
| Quest Difícil | 120-250 |
| Quest Muito Difícil | 250-500 |
| Raid contra Illfang | ~2000, dividido entre todos |

Um grupo de 4 no dia 10 tem, junto, entre 300 e 800 Col. Isso significa que
**um item Incomum é uma decisão coletiva** e um Raro simplesmente não se
compra — se conquista. O catálogo foi precificado pra manter isso verdadeiro.

## As quatro regras de comércio

**1. Vender devolve 40%.** Qualquer item vendido a um NPC rende 40% do preço
base. Vender pra outro **jogador** não tem tabela — é negociação, e é onde o
Comerciante ganha a vida.

**2. Reputação move o preço, não o dado.** Cada vendedor tem uma condição de
desconto declarada abaixo (concluir uma quest, ser da vila, usar a roupa
certa). Um teste de Conhecimento 10+ do Comerciante move **mais 10%**, e só
uma vez por vendedor por sessão — pra negociação não virar farm de rolagem.

**3. Estoque é finito e visível.** Cada vendedor lista quantas unidades tem
por semana de jogo. Comprou as três Placas de Metal Refinado da Forja? Não
tem mais até a semana virar. Isso é o que faz o mercado ser assunto de mesa
em vez de menu.

**4. Ninguém vende Raro.** Os 7 equipamentos e 6 armas Raras do andar não
têm vitrine. Se um jogador aparecer com um, todo NPC comerciante do andar
comenta.

---

# Cidade do Início

## Loja de Armas
*Barracão de madeira perto da igreja.* **Desconto:** nenhum — é loja de
sistema, preço fixo, e o dono não negocia com ninguém.

| Item | Col | Estoque/semana |
|---|---|---|
| Armas Comuns dos 17 tipos (`armas/*.md`) | 80-200 conforme o tipo | ilimitado |
| Flechas / virotes (lote de 20) | 15 | ilimitado |
| Broquel de Tábua | 50 | 6 |
| Escudo Redondo de Ferro | 140 | 3 |
| Gibão de Estopa | 40 | ilimitado |

**Não vende:** nada Incomum. Quem quiser subir de qualidade procura um
Ferreiro que processe material — e essa frase é o motor da economia inteira.

## Forja do Ferreiro
*Bigorna a céu aberto perto do muro interno.* **Desconto:** 15% pra quem
trouxer o próprio Minério Raro. **Recusa** vender Placas pra membro de guilda
com quem esteja em atrito — o mestre decide quando isso vale a pena.

| Item | Col | Estoque/semana |
|---|---|---|
| Placas de Metal Refinado | 90 cada | 3 |
| Lâmina Reforçada | 180 | 1 |
| Conserto de peça rachada | 1/5 do preço base do item | ilimitado |
| Elmo Aberto de Ferro | 300 | 2 |
| Luvas de Forja Rachadas | 310 | 1 (as antigas dele) |
| Botas Cravejadas de Montanha | 290 | 2 |

## Ateliê do Costureiro
*Mesa de costura e retalhos organizados por tipo.* **Desconto:** 20% pra
quem trouxer a própria Pelagem Azulada.

| Item | Col | Estoque/semana |
|---|---|---|
| Camisa de Linho Padrão / Calça de Sarja Padrão | 30 cada | ilimitado |
| Peitoral de Couro Cru | 90 | 4 |
| Túnica de Viagem | 90 | 4 |
| Camisa da Praça | 110 | 3 |
| Perneiras de Couro Batido | 85 | 4 |
| Capuz de Lã Puída | 40 | ilimitado |
| Armadura de Couro Reforçada (sob encomenda, 1 sessão de espera) | 260 | 2 |
| Luvas de Trabalho de Couro | 70 | 5 |

## Loja de Armaduras — Lynx
*`npcs/lynx.md`. À direita da praça.* **Desconto:** 10% permanente pra quem
já a ajudou; ela lembra de todo mundo. Vende pronto e caro, sem exigir
material — é o atalho pra quem tem Col e não tem tempo.

| Item | Col | Estoque/semana |
|---|---|---|
| Armadura de Couro Reforçada (pronta) | 340 | 2 |
| Cota de Malha Curta | 380 | 1 |
| Peitoral de Placas Kobold (quando aparece) | 420 | 0-1 |
| Braçadeiras do Mercenário | 300 | 2 |
| Saiote de Placas | 350 | 2 |
| Dica sobre o Labirinto / rota até Tolbana | grátis | — |

## Mercado Negro
*Beco fora da praça.* **Desconto:** não existe desconto — existe **risco**.
Todo item aqui custa 30% menos e tem uma chance real de problema, declarada
na coluna. O mestre rola escondido.

| Item | Col | Risco |
|---|---|---|
| Katana de Punho Envolto (Incomum) | 300 (de 430) | Procedência não explicada. Alguém vai reconhecê-la |
| Sobretudo do Contrabandista | 370 | Nenhum — é o produto legítimo da casa |
| Camisa da Praça (cópia) | 40 | Desbota em 1 semana de jogo e o desconto social some |
| Balança de Bolso (adulterada) | 120 | Mostra a raridade errada 1 vez em 3, e não avisa qual |
| Cristal de Cura "recuperado" | 200 (de 350) | 20% de chance de ser um Cristal de Luz repintado |
| Informação sobre outro jogador | 50-150 | Metade é verdade |

**Consequência de comprar aqui:** guildas evitam ser vistas no beco. Um
Diplomata pego comprando perde o efeito do Selo de Trégua até reparar isso.

## Comerciante da Praça (importados)
*Ponto do Comerciante — o único que traz coisa de fora do andar.*
**Desconto:** 15% pra Alquimistas e Médicos registrados no quadro de missões.

| Item | Col | Estoque/semana |
|---|---|---|
| Frasco Vazio Lacrado (lote de 3) | 60 | 10 lotes |
| Fio de prata (unidade) | 40 | 8 |
| Tecido fino (unidade) | 35 | 8 |
| Luvas de Seda do Boticário | 130 | 2 |
| Bússola de Latão Emperrada | 280 | 1 |
| Cristal de Teleporte | 500 | 1 |
| Cristal de Antídoto | 250 | 2 |
| Cristal de Luz | 180 | 3 |
| Cristal de Cura | 350 | 2 |
| Cristal de Barreira | 400 | 1 |

**Cristais são o teto de preço do andar de propósito.** Um Cristal de
Teleporte custa mais que quase toda arma Incomum — comprar um é escolher não
comprar equipamento, e é assim que a mesa aprende que fuga tem custo.

---

# Tolbana

## Mercado de Tolbana
*A praça comercial mais movimentada do andar; onde as guildas se cruzam.*
**Desconto:** 10% pra quem usa a Túnica Bordada do Diplomata ou tem aval de
guilda.

| Item | Col | Estoque/semana |
|---|---|---|
| Balança de Bolso do Comerciante | 320 | 1 |
| Marcador de Página do Bibliotecário | 150 | 2 |
| Pá de Trincheira de Ruyn | 300 | 3 |
| Amuleto de Cristal Bruto | 350 | 1 |
| Fio de prata / tecido / frascos | mesmos preços da praça, +10% | 5 cada |
| Mapa de região (vendido por Cartógrafos) | 10 Col por ponto revelado | variável |
| Informação de corretor sobre o Labirinto | 80 | sempre misturada com teoria falsa |

## Loja de Armas de Tolbana
*A melhor vitrine de arma do andar, e a mais cara.* **Desconto:** 15% depois
de `tolbana_e05`.

| Item | Col | Estoque/semana |
|---|---|---|
| Par de Guarda de Tolbana | 400 | 2 |
| Rapieira de Copo Fechado | 410 | 1 |
| Lança de Parede de Escudos | 350 | 3 |
| Punhais de Lastro | 280 | 3 |
| Dedeiras de Arqueiro | 250 | 3 |
| Armas Comuns dos 17 tipos | 100-240 (mais caro que na capital) | ilimitado |

## Ferreiro de Tolbana
*Forja grande, dois aprendizes, fila.* **Desconto:** 20% pra quem trouxer
Fragmento de Armadura Kobold — ele está obcecado com a liga.

| Item | Col | Estoque/semana |
|---|---|---|
| Placas de Metal Refinado | 100 cada | 5 |
| Cota de Malha Curta | 380 | 2 |
| Peitoral de Pedra-Viva (precisa do seu Minério Raro x2) | 450 | 1 |
| Pavês de Portão | 430 | 2 |
| Rodela do Vigia | 250 | 3 |
| Besta de Manivela de Grauvenn | 380 | 1 |
| Marreta de Pedreira | 390 | 2 |
| Espada Longa de Aço Kobold (sob encomenda) | 420 | 1 |
| Luvas de Malha Fina | 340 | 1 |

## Costureiro de Tolbana
**Desconto:** só atende encomenda grande com aval de guilda — é o gargalo
narrativo da cadeia E, não um problema de Col.

| Item | Col | Estoque/semana |
|---|---|---|
| Túnica Bordada do Diplomata | 390 | sob encomenda, 1 |
| Máscara de Bico do Médico | 320 | 1 |
| Casaco Encerado do Pântano | 220 | 2 |
| Perneiras de Casca de Escorpião (traga a Carapaça x3) | 330 | 2 |

---

# Horunka

## Loja de Ferramentas de Horunka
*De frente pra pousada. Estoque simples, preço justo — pra quem é bem-visto.*
**Desconto:** 25% depois de `horunka_01_primeira_cacada`; **+30% de acréscimo**
pra forasteiro que respondeu mal ao dono da pousada na chegada.

| Item | Col | Estoque/semana |
|---|---|---|
| Ferramentas de coleta básicas | 20-60 | ilimitado |
| Coleto do Batedor de Horunka | 240 | 2 |
| Capuz de Musgo | 200 | 2 |
| Botas de Sola Macia | 230 | 2 |
| Manto Verde de Horunka | 210 | 3 |
| Machado de Lenhador de Horunka | 330 | 2 |
| Túnica de Viagem / Perneiras de Couro | 90 / 85 | 3 cada |
| Bandana de Trabalho | 45 | ilimitado |
| Mitenes de Lã | 15 (é o preço de vila) | ilimitado |

## Pousada de Horunka
| Item | Col |
|---|---|
| Noite (quarto compartilhado) | 10 |
| Noite (quarto privado) | 25 |
| Refeição quente | 12 |
| Boato sobre a floresta | grátis, se ele gostar de você |

---

# Vendedores de campo

## Acampamento de Caçadores — Erik
*`npcs/erik.md`. Planície de Verrun.* **Desconto:** nenhum, mas ele
**compra** material de caça a 60% em vez de 40% — o melhor comprador do
andar.

| Item | Col |
|---|---|
| Luvas de Extração do Caçador | 300 |
| Presa de Javali / Pelagem Azulada (unidade) | 25 / 30 |
| Esboço do terreno próximo (dica de Cartógrafo) | 40 |
| **Compra** qualquer material de caça | 60% do valor |

## Provisões de Campanha (4 pontos espalhados)
*Barracas de estrada, ambulantes. Mesma tabela em qualquer um deles.*

| Item | Col |
|---|---|
| Ração de viagem (3 dias) | 20 |
| Odre de água | 10 |
| Corda (15m) | 25 |
| Tocha (lote de 5) | 15 |
| Ervas Comuns (unidade) | 12 |
| Frasco Vazio (unidade) | 25 |
| Bandagem simples | 18 |

## Peixaria Local (4 pontos: Lago Sylvaine, Rio Coluber, Vila de Brenmoor, Ilha de Pemberton)
**Desconto:** o Pescador Veterano zera o preço da isca pra quem concluiu
`sylvaine_02`.

| Item | Col |
|---|---|
| Peixe fresco (unidade) | 8 |
| Isca (lote) | 10 |
| Calça Encerada de Pescador | 210 |
| Aluguel de barco a remo (dia) | 30 |
| Escama Prateada (quando alguém traz) | 45 |

## Doca da Vila — Barqueiro
*`npcs/barqueiro.md`. Rio Coluber.* Ele prefere troca a Col e diz isso toda vez.

| Item | Col |
|---|---|
| Travessia do rio (grupo) | 40 |
| Capuz Encharcado do Barqueiro | 120 |
| Corrente de Âncora do Rio | 360 |
| Argila (unidade) | 6 |

## Banca de Ferramentas (Pedreira de Dunhelm / Vale de Molwyn)
| Item | Col |
|---|---|
| Sucata Aproveitável (unidade) | 10 |
| Marreta de Pedreira | 390 |
| Calça de Trabalho dos Terraços | 100 |
| Picareta / pé de cabra | 45 |

## Trilha de Corvain — contato sem nome
*Não é uma banca. Ele aparece quando quer.* Prefere **troca**: aceita Col só
com 25% de acréscimo, "por incômodo".

| Item | Col |
|---|---|
| Sobretudo do Contrabandista | 370 (ou uma peça Incomum em troca) |
| Passagem por rota não vigiada | 100 |
| Item sem procedência | varia — sempre 30% abaixo, sempre com história |

---

# Tabela de compra de materiais (quanto os NPCs pagam)

Vale pra qualquer comerciante da categoria certa. Um Comerciante jogador
compra abaixo disso e revende acima — é literalmente a profissão.

| Material | NPC paga | Quem quer comprar |
|---|---|---|
| Ervas Comuns | 5 | Alquimista, Médico, Cozinheiro |
| Madeira | 6 | Ferreiro, Costureiro |
| Madeira Nodosa | 22 | Ferreiro, Joalheiro |
| Peixe | 4 | Cozinheiro |
| Argila | 3 | Joalheiro |
| Sucata Aproveitável | 5 | Ferreiro |
| Presa de Javali | 15 | Cozinheiro, Costureiro |
| Pelagem Azulada | 18 | Costureiro |
| Ferrão de Vespa | 20 | Alquimista, Domador |
| Seiva de Nepenthes | 22 | Alquimista |
| Ossos Antigos | 14 | Coveiro, Alquimista |
| Carapaça de Areia | 20 | Costureiro |
| Escama Prateada | 45 | Joalheiro, Costureiro |
| Pó Dourado | 40 | Alquimista, Joalheiro |
| Minério Raro | 55 | Ferreiro, Joalheiro |
| Cristal Bruto | 70 | Joalheiro, Alquimista |
| Fragmento de Armadura Kobold | 60 | Ferreiro |
| Little Nepenthes's Ovule | 80 | Alquimista, Joalheiro |
| Pelagem Grisalha (Raro) | 250 | Ferreiro + Costureiro |
| Musgo Luminoso | 35 | Alquimista |
| Néctar de Flor Rara | 50 | Alquimista, Domador |

---

# Mercearia — insumos de cozinha e poções

Preço de compra (não de venda) pra ingredientes que não tinham linha aqui
antes de `Comidas/00_catalogo_receitas_cozinheiro.md` e
`pocoes/00_catalogo_pocoes_alquimista.md` existirem. Estoque ilimitado, sem
vendedor nomeado — qualquer mercearia das três cidades.

| Item | Col |
|---|---|
| Pão | 5 |
| Água | 2 |
| Leite Fresco | 4 |
| Sal | 3 |
| Trigo (unidade) | 8 |
| Mel Natural | 15 |
| Farinha | 6 |
| Açúcar Natural | 10 |
| Tempero Simples/Natural | 5 |
| Queijo | 8 |
| Carvão (unidade) | 10 |
| Erva Vital | 18 |
| Erva Ancestral | 30 (só Necrópole de Voss ou Torre de Aldric) |

---

# Nota de balanceamento entre profissões

Conferido item a item, pra manter o princípio de `docs/pendencias.md` (item
7). Cada uma das 16 tem pelo menos uma linha de renda própria nesta tabela:

| Profissão | Onde ganha dinheiro aqui |
|---|---|
| Caçador | Vende material a 60% pro Erik; único que extrai material de caça |
| Lenhador | Madeira e Madeira Nodosa (22 Col é o melhor recurso de coleta comum) |
| Cartógrafo | Vende mapa por ponto revelado no Mercado de Tolbana |
| Comerciante | Compra e revende tudo; único com acesso a importados |
| Cozinheiro | Refeição 20-40 Col; fonte barata via Perna Serrilhada de Gafanhoto |
| Diplomata | Aval de guilda destrava encomenda no Costureiro de Tolbana (gargalo pago) |
| Bibliotecário | Vende resistência/fraqueza de monstro antes do raid; Marcador dobra a capacidade |
| Alquimista | Antídoto e pomada; melhor comprador de Seiva, Musgo e Pó Dourado |
| Costureiro | Encomendas de 210-390 Col nas três cidades |
| Domador | Aliado domado vira serviço vendável (batedor, tanque, luz) |
| Ferreiro | Placas a 90-100 Col x5/semana é a renda mais estável do andar |
| Joalheiro | Anel de Escama e Amuleto de Cristal, 300-350 Col |
| Coveiro | Terço (só ele monta) e material da Necrópole |
| Médico | Desconto de importados + Máscara de Bico; trata status sem gastar Cristal |
| Músico | Afeta preço na praça: 10% de desconto pro grupo enquanto toca |
| Mercenário | Escolta paga por sessão (cadeia E) + parte do material do escoltado |
