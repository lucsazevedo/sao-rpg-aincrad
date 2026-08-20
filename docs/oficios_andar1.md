---
titulo: Ofícios do Andar 1 — o que cada profissão faz na prática
andar: 1
uso: jogador_e_mestre
oficios: 16
---

# Ofícios do Andar 1

O manual (`docs/guia_sistema_aincrad.md`) diz o que cada profissão **é** e dá
os Moves dela. Este arquivo diz o que ela **faz**, em lugares com nome, com
teste e com resultado.

## Por que este arquivo existe

Auditoria de agosto/2026 mediu a presença de cada profissão no conteúdo
jogável e achou uma diferença de **5 para 1** entre a mais servida (Ferreiro) e
a menos (Lenhador). Quem escolhesse Lenhador, Diplomata ou Médico passava
sessões inteiras sem que a escolha importasse — e profissão é a segunda decisão
que o jogador toma na criação.

Aqui as 16 recebem **exatamente a mesma estrutura**:

| Bloco | O que é |
|---|---|
| **Marca** | como o mundo lê essa pessoa, sem rolagem |
| **3 Ações de Ofício** | funcionam em qualquer lugar onde a ficção permitir. É o piso: nenhuma profissão fica sem o que fazer numa sessão |
| **3 Postos de trabalho** | pontos reais do mapa onde ela tem ação exclusiva |
| **Contato** | um NPC que já existe e que a procura ou é procurado |
| **Gancho recorrente** | a cena que o mestre puxa quando aquela profissão está parada há tempo demais |
| **Renda** | como ela ganha Col (detalhe em `docs/mercado_andar1.md`) |
| **Item assinatura** | a peça que só ela usa direito |

Equilíbrio é por construção: mesma contagem de ganchos para todas.

## Como usar na mesa

**Regra da vez do ofício.** Em toda sessão, cada personagem tem direito a
**uma cena onde a profissão dele é a resposta**. Não é bônus mecânico — é
tempo de tela. Se a sessão acabar e alguém não teve a vez, ela abre a próxima.

**Ação de Ofício não precisa de permissão.** O jogador declara e rola. O mestre
não precisa ter preparado nada; as três ações de cada ofício foram escritas pra
funcionar em qualquer região.

**7-9 sempre entrega alguma coisa.** Ofício não é combate: o preço de um
resultado parcial é tempo, quantidade, qualidade ou atenção — nunca "não
conseguiu".

---

## Caçador · Reflexo

**Marca:** você é quem volta com prova. Gente te procura quando precisa de
material e de verdade sobre o que tem lá fora.

**Ações de Ofício**

| Ação | Teste | 10+ | 7-9 | 6- |
|---|---|---|---|---|
| Extrair material bônus de um abatido | d20+Destreza | Material íntegro e você nota um traço útil (rota, toca, ninho) | Material sai imperfeito: metade do valor | Estraga a peça e o cheiro atrai algo |
| Ler o terreno por rastro | d20+Destreza | O mestre te diz o perigo mais próximo **e** a rota mais segura | Diz uma das duas; você escolhe qual | Você segue um rastro velho por uma hora |
| Armar espera silenciosa | d20+Destreza | A presa vem até vocês; primeiro golpe sem reação dela | Vem, mas traz companhia | O bicho fareja e some da região por um dia |

**Postos de trabalho**
- `campos_acampamento` — Acampamento de Caçadores: Erik compra material a 60%,
  o melhor preço do andar.
- `floresta_covil` — Covil Escondido: extração de material Incomum de miniboss.
- `terracos_plantacao` — Terraços de Solveig: caçar a praga é serviço pago em
  comida, não em Col.

**Contato:** Erik (`npcs/erik.md`) e Yara (`npcs/yara.md`).
**Gancho recorrente:** alguém precisa de uma peça específica **hoje**, e a
criatura certa só aparece de madrugada.
**Renda:** venda de material a 60% com Erik; material bônus exclusivo.
**Item assinatura:** `Luvas de Extração do Caçador`.
**Cardápio:** `docs/receitas_cacador.md`.

---

## Lenhador · Reflexo

**Marca:** você é a mão de obra do andar. Fogo, abrigo e madeira boa vêm de
você, e todo grupo que dormiu no frio sabe disso.

**Ações de Ofício**

| Ação | Teste | 10+ | 7-9 | 6- |
|---|---|---|---|---|
| Derrubar madeira boa | d20+Destreza | 2 unidades **e** chance de Madeira Nodosa | 1 unidade, e a queda faz barulho | Machado preso; o barulho chama algo |
| Montar acampamento que aguenta | d20+Destreza | Descanso seguro: o mestre remove uma pressão do caminho (frio, fome, medo) | Seguro, mas a noite cobra uma vigília | Fogo não pega; a noite inteira é desconfortável |
| Abrir caminho no mato fechado | d20+Destreza | Passagem aberta e ela continua aberta na volta | Abre, mas leva o dobro do tempo | Abre errado: saem num ponto pior |

**Postos de trabalho**
- `floresta_horunka_madeira` — Bosque de Coleta: a única fonte confiável de
  Madeira Nodosa do andar.
- `bosque_sussurrante` — Bosque de Ashwen: madeira pálida que o Costureiro usa
  pra tingir; cortar aqui tem custo social com a Voz Sem Corpo.
- `vale_moinho` — Moinho de Vento: o mecanismo torto precisa de eixo novo, e
  ninguém no vale sabe escolher a madeira certa.

**Contato:** Yara (`npcs/yara.md`), que vende as ferramentas, e Halden
(`npcs/halden.md`), que paga em hospedagem.
**Gancho recorrente:** um grupo inteiro depende de fogo hoje à noite e ninguém
além de você sabe achar lenha seca depois da chuva.
**Renda:** Madeira 6 Col, Madeira Nodosa 22 Col — o melhor recurso comum do
andar. Vender acampamento montado a outro grupo: 40 Col a noite.
**Item assinatura:** `Machado de Lenhador de Horunka`.
**Cardápio:** `docs/receitas_lenhador.md`.

---

## Cartógrafo · Conhecimento

**Marca:** você conhece o andar. Gente paga por caminho e por segurança, e
paga mais depois de se perder uma vez.

**Ações de Ofício**

| Ação | Teste | 10+ | 7-9 | 6- |
|---|---|---|---|---|
| Mapear região nova ao chegar | d20+Inteligência | Revela todos os pontos óbvios da região **e** uma rota segura | Revela metade, ou tudo cobrando tempo | Nada, e a tarde foi embora |
| Traçar rota por terreno perigoso | d20+Inteligência | Evitam uma ameaça prevista | Evitam, mas saem num lugar pior | A rota que você marcou some na próxima cheia |
| Vender mapa a outro grupo | d20+Inteligência | 10 Col por ponto revelado, e viram seus clientes | Metade do preço | Copiam seu traçado e revendem |

**Postos de trabalho**
- `colinas_mirante` — Mirante das Colinas: vantagem automática no mapeamento.
- `penhascos_vento_xvista_do_topo` — Vista do Topo: a única vista da face
  inferior de Aincrad.
- `cidade_guarita_norte` — Guarita dos Cartógrafos: o arquivo da Suri, com o
  sistema de três tintas.

**Contato:** Suri (`npcs/suri_cartografa.md`), Maelis
(`npcs/maelis_da_estepe.md`) e Vess (`npcs/vess.md`) — as três te procuram por
motivos diferentes.
**Gancho recorrente:** alguém sumiu numa região e a última pessoa que mapeou
aquilo foi você.
**Renda:** 10 Col por ponto revelado; rota vendida antes do raid vale mais.
**Item assinatura:** `Bússola de Latão Emperrada`.
**Cardápio:** `docs/servicos_cartografo.md`.

---

## Comerciante · Conhecimento

**Marca:** você é quem sabe o preço. Numa cidade onde ninguém confia em
ninguém, saber o valor das coisas é quase saber o valor das pessoas.

**Ações de Ofício**

| Ação | Teste | 10+ | 7-9 | 6- |
|---|---|---|---|---|
| Negociar preço | d20+Inteligência | 15% de desconto **e** o vendedor passa a te reconhecer | 10%, mas ele lembra que você pechinchou | Preço cheio e um comentário seco |
| Avaliar item ou farejar golpe | d20+Inteligência | Raridade real e a procedência | A raridade, sem a história | Você acredita na versão do vendedor |
| Importar o que não existe no andar | d20+Inteligência | Chega na próxima sessão, preço justo | Chega, com 30% de acréscimo | Não chega, e você pagou adiantado |

**Postos de trabalho**
- `tolbana_mercado` — Mercado de Tolbana: o giro mais alto do andar.
- `cidade_mercado_negro` — Ruela das Versões: onde o desconto tem risco escrito.
- `estrada_velha_xcaravana_de_passagem` — Caravana: preço de atacado pra quem
  compra na estrada.

**Contato:** Lynx (`npcs/lynx.md`), Vell (`npcs/vell.md`) e Nissa
(`npcs/nissa.md`).
**Gancho recorrente:** um item que ninguém quer hoje vai ser essencial na
véspera do raid — e só você percebeu.
**Renda:** compra e revenda; é a única profissão com acesso a importados.
**Item assinatura:** `Balança de Bolso do Comerciante`.
**Cardápio:** `docs/servicos_comerciante.md`.

---

## Cozinheiro · Conhecimento

**Marca:** você é quem faz o grupo parar e sentar. Comida quente no dia 10 é
quase uma declaração política.

**Ações de Ofício**

| Ação | Teste | 10+ | 7-9 | 6- |
|---|---|---|---|---|
| Preparar refeição com bônus | d20+Inteligência | Bônus temporário pro grupo na próxima expedição | Bônus só pra metade do grupo | Passou do ponto; ninguém come com vontade |
| Improvisar comida com o que tem | d20+Inteligência | Rende, e ninguém percebe a improvisação | Rende, mas alguém percebe | Estraga o material |
| Puxar conversa em volta da panela | d20+Sabedoria | Um NPC conta algo que não contaria em pé | Ele fala, mas cobra depois | O clima azeda |

**Postos de trabalho**
- `cidade_lago` — Pequeno Lago Central: a cozinha informal do Bren.
- `terracos_plantacao` — Terraços de Solveig: ingrediente fresco e a Perna
  Serrilhada de Gafanhoto, proteína barata e abundante.
- `vale_moinhos_xcolmeia_selvagem` — Colmeia Selvagem: mel, o único adoçante do
  andar.

**Contato:** Bren do Lago (`npcs/bren_do_lago.md`) e Orin (`npcs/orin.md`).
**Gancho recorrente:** a véspera de algo perigoso. Todo mundo come calado, e a
cena é sua.
**Renda:** 20-40 Col por prato; Orin compra material a preço justo.
**Item assinatura:** `Calça de Trabalho dos Terraços`.
**Cardápio:** `Comidas/00_catalogo_receitas_cozinheiro.md`.

---

## Diplomata · Conhecimento

**Marca:** você é quem entra na sala. Seis clãs, nenhuma autoridade central, e
alguém precisa fazer as pessoas se ouvirem.

**Ações de Ofício**

| Ação | Teste | 10+ | 7-9 | 6- |
|---|---|---|---|---|
| Mediar conflito antes do primeiro golpe | d20+Inteligência | Os dois lados baixam a arma e você define os termos | Baixam, mas alguém sai devendo | Escolhem um lado — e não é o seu |
| Conseguir audiência com quem não te recebe | d20+Inteligência | Entra hoje | Entra, mas com hora marcada e testemunha | A porta fecha por uma semana |
| Negociar passagem ou trégua | d20+Inteligência | Passagem livre e o acordo se sustenta | Passagem, mediante favor | Você vira o assunto da semana |

**Postos de trabalho**
- `posto_guilda_acampamento` — Acampamento de Kaldrin: onde as seis facções se
  cruzam sem entrar em cidade.
- `tolbana_guilda` — Posto de Guilda: recrutamento e contrato.
- `tolbana_anfiteatro` — Anfiteatro: quando o raid for convocado, quem organiza
  a sala é você.

**Contato:** Sargento Kolt (`npcs/sargento_kolt.md`) e Ivy (`npcs/ivy.md`).
**Gancho recorrente:** dois grupos querem o mesmo recurso e os dois estão
certos. Ver `docs/registro_clas_e_reputacao.md`.
**Renda:** comissão sobre acordo fechado; aval de clã destrava encomenda cara
no Costureiro de Tolbana.
**Item assinatura:** `Selo de Trégua` — e os dois sulcos vazios dele são a sua
carreira.
**Cardápio:** `docs/servicos_diplomata.md`.

---

## Bibliotecário · Conhecimento

**Marca:** você é quem já leu sobre isso. Chegar sabendo o nome da coisa muda
como a mesa inteira encara a coisa.

**Ações de Ofício**

| Ação | Teste | 10+ | 7-9 | 6- |
|---|---|---|---|---|
| Pesquisar criatura antes do combate | d20+Inteligência | Fraqueza, resistências e vulnerabilidades completas | Só a fraqueza principal | Nada, e o tempo de preparo foi gasto |
| Reconhecer símbolo, escrita ou heráldica | d20+Inteligência | Lê o suficiente pra mudar o rumo da cena | Sabe de onde vem, não o que diz | Confunde com outra coisa parecida |
| Cruzar duas fontes | d20+Inteligência | Descobre a contradição — e a contradição é a pista | Descobre que discordam | Acredita na fonte errada |

**Postos de trabalho**
- `torre_relogio_xestudioso_obcecado` — Torre de Aldric: a fonte principal.
- `necropole_xzelador_do_memorial` — Memorial de Voss: fonte secundária, só
  para o que envolve mortos.
- `colinas_pedra_xgravacao_antiga` — Gravação Antiga: oito metros de escrita
  que ninguém leu.

**Contato:** Wilbrand (`npcs/estudioso_obcecado.md`) e Nissa
(`npcs/nissa.md`), que separa o que viu do que ouviu.
**Gancho recorrente:** o grupo vai enfrentar algo amanhã e você tem uma noite
pra descobrir o que é.
**Renda:** vende pesquisa antes do raid; a tese de Wilbrand destrava pesquisa
fora da Torre.
**Item assinatura:** `Marcador de Página do Bibliotecário` — duas pesquisas
abertas ao mesmo tempo.
**Cardápio:** `docs/servicos_bibliotecario.md`.

---

## Alquimista · Conhecimento

**Marca:** você transforma. É a profissão que faz remédio de veneno, e a mesa
percebe a ironia sozinha.

**Ações de Ofício**

| Ação | Teste | 10+ | 7-9 | 6- |
|---|---|---|---|---|
| Destilar poção ou antídoto | d20+Inteligência | Fica pronto na mesma sessão | Pronto na próxima, e gasta um frasco a mais | Perde o material |
| Identificar substância desconhecida | d20+Inteligência | Sabe o que é, o que faz e o que neutraliza | Sabe o que faz | Testa em si mesmo |
| Estabilizar material volátil pra viagem | d20+Destreza | Chega inteiro | Chega, com metade da potência | Vaza dentro da mochila |

**Postos de trabalho**
- `jardim_ervas_raras` — Jardim de Fenwyth: Néctar de Flor Rara.
- `charco_ras_xlodo_fertil` — Charco de Grenna: veneno vivo, matéria-prima de
  cura.
- `pantano_sombrio_xmusgo_luminoso` — Musgo Luminoso, a isca da Sombra de
  Mournhall.

**Contato:** Talia (`npcs/talia.md`) e Nadia (`npcs/nadia.md`).
**Gancho recorrente:** alguém foi envenenado e o antídoto exige um ingrediente
que só existe num lugar ruim.
**Renda:** antídoto e pomada; melhor comprador de Seiva, Musgo e Pó Dourado.
**Item assinatura:** `Luvas de Seda do Boticário`.
**Cardápio:** `pocoes/00_catalogo_pocoes_alquimista.md`.

---

## Costureiro · Técnica

**Marca:** você veste o grupo. Roupa ruim mata mais gente que monstro forte, e
você é quem sabe disso.

**Ações de Ofício**

| Ação | Teste | 10+ | 7-9 | 6- |
|---|---|---|---|---|
| Confeccionar ou reforçar peça | d20+Destreza | Fica pronta e uma categoria acima do esperado | Pronta, no prazo dobrado | Estraga o material |
| Consertar equipamento rachado | d20+Destreza | Conserta em campo, sem oficina | Conserta, mas fica visível | Piora |
| Ler a roupa de alguém | d20+Inteligência | Sabe de onde a pessoa veio e quanto pagou | Sabe a origem | Erra feio e diz em voz alta |

**Postos de trabalho**
- `cidade_ateliê` — Ateliê de Mestra Sorrel: o Traje de Batedor sai daqui.
- `horunka_ferramentas` — Loja de Ferramentas de Horunka: material de campo.
- `necropole_xzelador_do_memorial` — Voss: o Casaco de Retalhos, costurado com
  roupa de quem não voltou.

**Contato:** Mestra Sorrel (`npcs/mestra_sorrel.md`).
**Gancho recorrente:** o grupo inteiro aparece com equipamento rachado pela
terceira vez e alguém precisa dar a bronca.
**Renda:** encomendas de 210-390 Col nas três cidades.
**Item assinatura:** `Coleto do Batedor de Horunka` (conjunto).
**Cardápio:** `docs/receitas_costureiro.md`.

---

## Domador · Técnica

**Marca:** você chega perto do que morde. A mesa inteira para de falar quando
você se agacha na frente de um bicho.

**Ações de Ofício**

| Ação | Teste | 10+ | 7-9 | 6- |
|---|---|---|---|---|
| Tentativa de doma | d20+Destreza | 1 sucesso limpo na barra | 1 sucesso, mas a criatura reage mal nesse turno | Sem sucesso; 2 falhas seguidas encerram |
| Acalmar animal agitado | d20+Destreza | Ele para e escuta — inclusive em combate | Para, e volta a agitar na rodada seguinte | Ele se assusta e chama atenção |
| Mandar o aliado domado fazer algo difícil | d20+Destreza | Faz, e volta | Faz, mas se machuca | Se recusa, e isso custa confiança |

**Postos de trabalho**
- `jardim_selvagem_xcampo_de_flores_raras` — Fenwyth: a Fada da Poeira, a doma
  utilitária que resolve escuridão sem gastar Cristal.
- `lago_margem` — Sylvaine: Lacustre Vagador (8 sucessos) e Serpente das Águas
  Rasas (6).
- `montanhas_fronteira` — Grauvenn: o Arauto das Alturas, a doma mais difícil
  do andar, e a escolha irreversível entre domar e abater.

**Contato:** Sela (`npcs/sela.md`), que mapeou a tabela de doma inteira sozinha.
**Gancho recorrente:** o grupo precisa atravessar um lugar onde um aliado
domado resolve e nenhuma arma resolve.
**Renda:** aliado domado vira serviço vendável — batedor, tanque, luz viva.
**Item assinatura:** `Coroa de Penas do Corvo`.
**Cardápio:** `docs/receitas_domador.md`.

---

## Ferreiro · Técnica

**Marca:** você é o gargalo da economia. Metade das receitas do andar passa
pela sua bigorna, e todo mundo sabe.

**Ações de Ofício**

| Ação | Teste | 10+ | 7-9 | 6- |
|---|---|---|---|---|
| Processar minério em componente | d20+Destreza | 2 Placas em vez de 1 | 1 Placa | Perde o minério |
| Forjar ou reforjar peça | d20+Destreza | Sai como encomendado, e cedo | Sai, com uma imperfeição visível | Racha na têmpera |
| Ler metal desconhecido | d20+Inteligência | Sabe a liga, a origem e o que dá pra fazer | Sabe se presta | Conclusão errada com convicção |

**Postos de trabalho**
- `cidade_ferreiro` — Forja de Kazuo.
- `montanhas_xveio_exposto` — Grauvenn: Minério Raro na fonte.
- `pedreira_xsucata_aproveitavel` — Dunhelm: sucata barata e o maquinário que
  não faz sentido.

**Contato:** Kazuo Tanaka (`npcs/kazuo_tanaka.md`) e Mestre Bram
(`npcs/mestre_bram.md`).
**Gancho recorrente:** alguém traz Fragmento de Armadura Kobold e a liga não
bate com nada que este andar deveria ter.
**Renda:** Placas a 90-100 Col, 5 por semana — a renda mais estável do andar.
**Item assinatura:** `Luvas de Forja Rachadas`.
**Cardápio:** `docs/receitas_ferreiro.md`.

---

## Joalheiro · Técnica

**Marca:** você trabalha o pequeno. Num mundo de espada grande, quem faz a
peça de dois centímetros é quem entende de detalhe.

**Ações de Ofício**

| Ação | Teste | 10+ | 7-9 | 6- |
|---|---|---|---|---|
| Engastar acessório | d20+Destreza | Sai perfeito e você economiza material | Sai, gastando o dobro | Racha a pedra |
| Avaliar cristal ou pedra | d20+Inteligência | Distingue bruto de cristal de sistema à distância | Sabe que são diferentes | Confunde os dois |
| Reparar peça delicada | d20+Destreza | Fica como nova | Funciona, com marca | Quebra de vez |

**Postos de trabalho**
- `gruta_veio_cristal` — Gruta de Lumis: Cristal Bruto na fonte, com o Contador
  de Vibração pesando.
- `rio_serpente_xbarranco_de_argila` — Coluber: argila, o material barato que
  todo aprendiz usa.
- `tolbana_mercado` — Tolbana: fio de prata, que não existe fora do comércio.

**Contato:** Tor (`npcs/tor.md`) — e a recusa dele em tocar no `Anel dos Cinco
Encaixes` é gancho, não recado.
**Gancho recorrente:** alguém precisa saber se o que achou é cristal de sistema
ou pedra bonita, e a resposta muda o plano do grupo.
**Renda:** Anel de Escama e Amuleto de Cristal, 300-350 Col.
**Item assinatura:** `Amuleto de Cristal Bruto` — o único detector de tesouro
do andar.
**Cardápio:** `docs/receitas_joalheiro.md`.

---

## Coveiro · Espírito

**Marca:** você é quem fica depois. A cidade inteira evita o assunto e você
mora nele.

**Ações de Ofício**

| Ação | Teste | 10+ | 7-9 | 6- |
|---|---|---|---|---|
| Cuidar de um morto e ler o que ficou | d20+Sabedoria | Descobre uma coisa que ninguém sabia sobre ele | Descobre algo vago | Só tristeza, e ela pesa |
| Dispensar presença não-corpórea | d20+Sabedoria | Dissolve sem luta, e ela deixa a pista | Dissolve, sem pista | Ela fica, e agora sabe seu nome |
| Coletar material de sepultura com respeito | d20+Sabedoria | 3 unidades e ninguém se ofende | 2 unidades, e o Zelador reparou | Profanação: perde acesso |

**Postos de trabalho**
- `necropole_portao` — Necrópole de Voss: a pergunta que ninguém responde —
  quem está enterrado aqui, se ninguém fica?
- `cidade_memorial` — Memorial dos Caídos: onde a lista cresce toda semana.
- `campo_batalha` — Campo de Ruyn: mortos que não são de jogador nenhum.

**Contato:** Zelador do Memorial (`npcs/zelador_do_memorial.md`) e Irmão Anselm
(`npcs/irmao_anselm.md`) — os dois se correspondem por bilhete.
**Gancho recorrente:** alguém morreu e o grupo precisa decidir o que contar
pra quem ficou.
**Renda:** Ossos Antigos e Resíduo Etéreo; o Terço só vale se você montar.
**Item assinatura:** `Terço de Ossos Antigos`.
**Cardápio:** `docs/receitas_coveiro.md`.

---

## Médico · Espírito

**Marca:** você é pra quem correm. Não pelo dano — o jogo cura dano. Pelo que
não passa sozinho.

**Ações de Ofício**

| Ação | Teste | 10+ | 7-9 | 6- |
|---|---|---|---|---|
| Tratar status negativo | d20+Sabedoria | Veneno, paralisia, sono ou confusão removidos sem gastar Cristal | Removido, mas leva a noite inteira | Precisa de material que você não tem |
| Estabilizar quem está à beira | d20+Sabedoria | De pé, com marca, sem sequela | De pé, com uma Condição no lugar | Você compra tempo, e só |
| Diagnosticar o que ninguém entendeu | d20+Inteligência | Nomeia a causa — e nomear muda o que dá pra fazer | Sabe o que não é | Trata a coisa errada |

**Postos de trabalho**
- `cidade_hospedaria` — Hospedaria da Porta Aberta: a porta escorada é decisão
  da Nadia, não descuido.
- `charco_ras_xlodo_fertil` — Grenna: onde nasce a matéria-prima da cura.
- `labirinto_acampamento` — Limiar do Labirinto: quem volta de lá volta com
  coisa que não é dano.

**Contato:** Nadia (`npcs/nadia.md`), a única que ensina a tratar status sem
Cristal.
**Gancho recorrente:** um NPC recorrente aparece com algo que não é ferimento,
e ninguém além de você percebe.
**Renda:** tratamento pago em Col ou favor; desconto de importado com o
Comerciante.
**Item assinatura:** `Máscara de Bico do Médico`.
**Cardápio:** `docs/receitas_medico.md`.

---

## Músico · Espírito

**Marca:** você faz o salão calar. Num andar onde ninguém confia em ninguém,
conseguir a atenção de trinta pessoas é poder de verdade.

**Ações de Ofício**

| Ação | Teste | 10+ | 7-9 | 6- |
|---|---|---|---|---|
| Tocar pra levantar o grupo | d20+Sabedoria | Todo aliado que falhou no teste anterior rola de novo | Um aliado rola de novo | Chama atenção de quem não devia ouvir |
| Ler a sala pela reação à música | d20+Sabedoria | Sabe quem está mentindo, quem está com medo e quem está sozinho | Sabe uma das três | Toca a música errada pra plateia errada |
| Aprender ou lembrar uma cantiga | d20+Sabedoria | Letra inteira, e você percebe o que ela carrega | A letra | O refrão e mais nada |

**Postos de trabalho**
- `cidade_taverna` — Taverna de Perim: a cantiga dos cinco cristais mora aqui.
- `tolbana_anfiteatro` — Anfiteatro: quem abre a reunião do raid define o tom
  dela.
- `bosque_eco` — Árvore dos Ecos: cantar aqui devolve a sua voz com a voz de
  outra pessoa.

**Contato:** Perim (`npcs/perim.md`) — e o sexto verso que ele solta só pra
outro Músico.
**Gancho recorrente:** o grupo precisa que uma multidão faça alguma coisa
junta, e ninguém consegue gritar mais alto que o medo.
**Renda:** toca na praça e afeta preço; 10% de desconto pro grupo enquanto
toca.
**Item assinatura:** `Diapasão de Prata Rachado`.
**Cardápio:** `docs/servicos_musico.md`.

---

## Mercenário · Corpo

**Marca:** você é a razão pela qual os outros conseguem trabalhar. Todo ofício
deste arquivo depende de chegar vivo no lugar.

**Ações de Ofício**

| Ação | Teste | 10+ | 7-9 | 6- |
|---|---|---|---|---|
| Escoltar alguém até uma zona perigosa | d20+Força | Chegam inteiros e você fica com parte do material | Chegam, mas o escoltado perde algo | Chegam machucados e a fama circula |
| Segurar a linha enquanto o grupo faz outra coisa | d20+Força | Ninguém passa por você | Passa um | A linha quebra e vocês ficam cercados |
| Avaliar se uma briga vale a pena | d20+Inteligência | Sabe quantos são, o que querem e se dá pra evitar | Sabe quantos são | Subestima |

**Postos de trabalho**
- `cidade_portao_oeste` — Portão Oeste: Daren pergunta por onde vocês voltam,
  e você é quem deveria ter a resposta.
- `posto_guilda_acampamento` — Kaldrin: contrato aberto, pagamento declarado,
  risco declarado.
- `estrada_velha_xponto_de_assalto_conhecido` — Ombric: todo mundo sabe onde é
  e ninguém resolveu.

**Contato:** Daren Vigília (`npcs/daren_vigilia.md`) e Sargento Kolt
(`npcs/sargento_kolt.md`).
**Gancho recorrente:** um ofício do grupo precisa ir a um lugar que ele não
sobrevive sozinho — e a conta é sua.
**Renda:** escolta paga por sessão, mais parte do material do escoltado.
**Item assinatura:** `Braçadeiras do Mercenário`.
**Cardápio:** `docs/servicos_mercenario.md`.

---

# Conferência de equilíbrio

Cada uma das 16 tem, por construção:

| Item | Quantidade |
|---|---|
| Ações de Ofício sempre disponíveis | **3** |
| Postos de trabalho no mapa | **3** |
| NPC de contato | **1 ou 2** |
| Gancho recorrente | **1** |
| Fonte de renda declarada | **1** |
| Item assinatura | **1** |

Isso são **48 ações de ofício** e **48 postos de trabalho** distribuídos por
28 das 30 regiões. Nenhuma profissão fica sem o que fazer numa sessão, e
nenhuma tem cinco vezes mais presença que outra.

**Ao criar conteúdo novo, mantenha a conta.** Se uma região nova ganhar três
ganchos de Ferreiro e nenhum de Lenhador, o desequilíbrio volta — e ele volta
sempre pelas mesmas seis: Lenhador, Diplomata, Médico, Domador, Bibliotecário
e Músico.
