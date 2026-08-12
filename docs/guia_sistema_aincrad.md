# Guia de sistema — SAO Aincrad RPG (Manual do Jogador v1.0)

Transcrição condensada do manual em `base/` (12 páginas exportadas: capa +
capítulos 1, 2, 3, 4, 6, 7, 8, 9 (Cristais), 9 (Crafting — numeração duplicada
no original), 10). Os capítulos 5 (não fotografado), 12 (Evolução/XP) e 13
(Mestre) ainda não foram enviados — quando chegarem, atualize este arquivo.

Este arquivo é a fonte única de verdade injetada nos prompts de
`scripts/gerar_npc.py`, `scripts/gerar_arma.py`, `scripts/gerar_cena.py` e
`C:\AI\AudioCraft\gerar_sao.py`. Editar aqui atualiza todos os geradores.

## Mundo

Sword Art Online — NerveGear lançado em 6/11/2022. Jogadores presos dentro de
Aincrad, uma torre de 100 andares. Morrer no jogo = morrer na vida real
(NerveGear destrói o corpo). Para escapar, é preciso conquistar os 100 andares
e derrotar todos os chefes de andar.

Cada andar tem: um chefe, monstros e tesouros únicos, dungeons (masmorras com
armadilhas e inimigos fortes), zonas seguras (cidades — descanso, comércio,
missões) e campos abertos (monstros, recursos, perigo).

## Sistema (PBTA — Powered by the Apocalypse)

Ação arriscada ou incerta → **role 2d6 + atributo correspondente**.

- **10+**: sucesso completo — o personagem faz o que quer e ainda tira algo bom.
- **7-9**: sucesso parcial — consegue, mas com custo ou complicação.
- **6-**: complicou — o mestre narra o revés.

Foco em história, ação e escolhas, não em regras complicadas. Perigo está
sempre presente; a sombra da morte é a única regra e o maior medo.

> **Complemento de campanha v1.1:** enquanto os capítulos oficiais 12
> (Evolução/XP) e 13 (Mestre) não forem incorporados, use
> `docs/regras_nucleares_campanha.md` como regra vinculante para Moves Núcleo,
> Condições, morte, progresso, downtime, reputação e preparação de raid.

## Protagonismo (regra de mesa)

Nesta mesa, arma e profissão não existem pra dizer quem bate mais forte. Elas
existem pra dizer **como você é protagonista**.

### Impulso

Quando você **escolhe** uma complicação, custo ou risco real que nasce da sua
arma, da sua profissão ou do jeito que você interpreta seu personagem, marque
**1 Impulso** (máximo 3).

Você pode gastar 1 Impulso para:

- **Rolar de novo** um teste (2d6) depois de ver o resultado, aceitando o novo.
- **Converter um 7-9 em sucesso limpo** removendo o custo/complicação, mas
  deixando a cena mais exposta (o mestre deve introduzir uma consequência
  social/ambiental em vez do custo mecânico).

## Atributos (os 5)

| Atributo     | Sigla | Representa                                  | Use quando                                                                                  |
| ------------ | ----- | ------------------------------------------- | ------------------------------------------------------------------------------------------- |
| Corpo        | COR   | Força física, resistência, vitalidade       | Levantar/carregar peso, resistir dano físico, forçar portas/quebrar objetos                 |
| Reflexo      | REF   | Agilidade, velocidade, reação               | Esquivar, agir rápido sob perigo, ataques à distância/precisão                              |
| Conhecimento | CON   | Inteligência, memória, compreensão          | Lembrar informações, identificar fraquezas/segredos, decifrar enigmas/armadilhas            |
| Espírito     | ESP   | Força mental, vontade, equilíbrio emocional | Resistir medo/ilusão/controle mental, manter calma, inspirar aliados                        |
| Técnica      | TEC   | Treinamento, domínio de armas/técnicas      | Skills especiais de arma/classe, manobras técnicas, consertar/criar itens, usar ferramentas |

Criação de personagem distribui os valores **-2, -1, -1, -1, 0** entre os 5
atributos, um valor por atributo, sem repetir.

## Criando um personagem

1. Escolher arma (ver lista de 22 armas).
2. Escolher profissão (ver lista de 16 profissões).
3. Dar um nome.
4. Criar a aparência do avatar.
5. Ter em mãos: arma, profissão, atributos, nome, imagem.

**Arma e profissão são escolhas independentes** — não precisam compartilhar
atributo principal. Um personagem de Espírito alto pode perfeitamente usar
Machado (Corpo) e ser Coveiro (Espírito); o Move de Arma rola no atributo da
arma, o Move de Ofício rola no atributo da profissão, e o resto dos testes
usa o atributo que a ficção pedir. Ver `docs/balanceamento_armas_oficios.md`
pra por que isso importa: armas e profissões não estão distribuídas de
forma igual entre os 5 atributos, e misturar é o que resolve isso na mesa.

## As 22 armas de Aincrad

Cada arma tem um **atributo principal**, somado à rolagem de ação sempre que
ela for usada, e concede dois Moves do tipo:

- **Move de Combate** (como você vence trocas).
- **Move Utilitário** (como você cria cena fora de combate).

| #   | Arma                | Atributo principal |
| --- | ------------------- | ------------------ |
| 01  | Arco e Flecha       | Reflexo            |
| 02  | Adagas              | Técnica            |
| 03  | Adagas de Arremesso | Reflexo            |
| 04  | Besta               | Reflexo            |
| 05  | Chakrams            | Técnica            |
| 06  | Chicote             | Conhecimento       |
| 07  | Escudo e Espada     | Corpo              |
| 08  | Espada Longa        | Corpo              |
| 09  | Foice               | Técnica            |
| 10  | Katana              | Espírito           |
| 11  | Lança               | Técnica            |
| 12  | Machado             | Corpo              |
| 13  | Martelo             | Corpo              |
| 14  | Pá                  | Conhecimento       |
| 15  | Rapieira            | Reflexo            |
| 16  | Bastão              | Espírito           |
| 17  | Tonfas              | Técnica            |
| 18  | Clava               | Corpo              |
| 19  | Nunchaku            | Técnica            |
| 20  | Glaive              | Reflexo            |
| 21  | Corrente com Peso   | Técnica            |
| 22  | Manopla             | Corpo              |
| 23  | Leque               | Técnica            |

## Moves de Arma (todas Tier S em protagonismo)

Cada arma abaixo tem:

- **Marca** (como o mundo te lê; sem rolagem).
- **Move de Combate** (role 2d6 + atributo da arma).
- **Move Utilitário** (role 2d6 + atributo da arma).

### Arco e Flecha (REF)

**Marca:** arco e flecha passam distância, precisão e leitura de terreno; a cena te coloca naturalmente em pontos de visão, cobertura e vigilância.
**Move de Combate — Linha de Tiro:** quando você atira mantendo distância e escolhendo um alvo antes dele te alcançar, role 2d6+Reflexo. 10+ escolha 1: interrompa a ação dele, impeça que feche distância com você nesta troca, ou dispare sem revelar sua posição exata. 7-9 você acerta e escolhe 1, mas o mestre escolhe 1: você é localizado, a flecha fica presa/perdida, ou um terceiro percebe o disparo.
**Move Utilitário — Marcar o Horizonte:** quando você usa disparos, marcas ou sinais à distância para guiar, avisar ou coordenar um grupo, role 2d6+Reflexo. 10+ o grupo entende e ganha um caminho/decisão clara sem se perder. 7-9 funciona, mas alguém além do grupo também percebe o sinal.

### Adagas (TEC)

**Marca:** adagas passam proximidade, precisão curta e perigo imediato; elas mudam a cena quando tudo fica perto demais.
**Move de Combate — Dentro da Guarda:** quando você entra colado e tenta vencer sem dar espaço pra reação do alvo, role 2d6+Técnica. 10+ escolha 1: negue a próxima reação do alvo, desarme um item pequeno, ou mude de posição ficando fora do alcance imediato. 7-9 você consegue, mas escolha 1 custo: você fica preso na troca, se expõe a um segundo inimigo, ou deixa uma marca evidente (sangue, rasgo, prova).
**Move Utilitário — Mão Leve:** quando você invade, destranca, corta correias ou recupera algo sem ser notado, role 2d6+Técnica. 10+ você faz sem deixar rastro. 7-9 você faz, mas deixa um sinal que alguém pode seguir.

### Adagas de Arremesso (REF)

**Marca:** adagas de arremesso passam prontidão, alcance curto e ameaça espalhada; a cena tende a abrir espaço para marcação, aviso e pressão rápida.
**Move de Combate — Primeira Chuva:** quando você abre uma troca contra um grupo antes que ele se organize, role 2d6+Reflexo. 10+ escolha 1: acerte dois alvos (um golpe em cada), impeça avanço (ninguém fecha distância sem pagar), ou force dispersão (o grupo inimigo se separa). 7-9 você consegue, mas suas lâminas ficam no chão, presas ou longe demais até você recuperar.
**Move Utilitário — Sinal no Lugar Certo:** quando você usa uma lâmina para marcar caminho, deixar mensagem ou criar um ponto de encontro que só o seu grupo reconhece, role 2d6+Reflexo. 10+ a marca funciona e passa despercebida. 7-9 funciona, mas alguém interpreta errado ou você marca forte demais.

### Besta (REF)

**Marca:** besta passa impacto, interrupção e decisão à distância; quando ela entra em cena, alguém sente que uma ação vai ser parada.
**Move de Combate — Tiro de Interrupção:** quando alguém vai fugir, acionar algo, chamar reforço ou completar uma ação perigosa e você dispara para impedir, role 2d6+Reflexo. 10+ você interrompe e escolhe 1: derrube, desarme, ou force recuo imediato. 7-9 você interrompe, mas o barulho/tempo de recarga cria uma nova pressão na cena.
**Move Utilitário — Cabo e Gancho:** quando você usa virote, corda ou gancho para criar travessia, puxar algo ou alcançar um lugar, role 2d6+Reflexo. 10+ cria acesso seguro. 7-9 cria acesso, mas é instável ou expõe o grupo.

### Chakrams (TEC)

**Marca:** chakrams passam movimento, retorno e imprevisibilidade; a cena fica mais dinâmica e menos frontal quando eles aparecem.
**Move de Combate — Órbita:** quando você luta girando e mantendo o alvo sempre fora do ponto confortável, role 2d6+Técnica. 10+ escolha 1: mude sua posição sem sofrer reação, acerte e force recuo, ou acerte e mantenha distância. 7-9 você acerta, mas perde o disco por um momento ou abre um flanco.
**Move Utilitário — Espetáculo:** quando você usa os discos para distrair, entreter, criar abertura social ou tirar foco de alguém, role 2d6+Técnica. 10+ você consegue o acesso/informação/atenção que queria. 7-9 você consegue, mas alguém te reconhece, te cobra ou leva a sério demais.

### Chicote (CON)

**Marca:** chicote passa alcance, controle e limite; ele transforma espaço aberto em território disputado.
**Move de Combate — Domínio de Alcance:** quando você usa alcance para puxar, prender ou derrubar sem se aproximar, role 2d6+Conhecimento. 10+ escolha 1: puxe o alvo para um ponto ruim, derrube, ou prenda por uma troca (ele não reage até se soltar). 7-9 você consegue, mas o chicote enrosca, te puxa junto ou chama atenção imediata.
**Move Utilitário — Linha no Chão:** quando você impõe limite sem ferir (controlar multidão, separar briga, impedir aproximação), role 2d6+Conhecimento. 10+ a cena desacelera e o conflito não escala por enquanto. 7-9 funciona, mas você vira o foco (alguém te desafia, te grava ou te denuncia).

### Escudo e Espada (COR)

**Marca:** escudo e espada passam defesa ativa, presença e contenção; a cena naturalmente gira em torno de quem segura a pressão.
**Move de Combate — Linha Fechada:** quando você segura a frente para abrir espaço ao grupo, role 2d6+Corpo. 10+ escolha 1: proteja um aliado (ele age sem sofrer reação nesta troca), force recuo, ou negue a próxima reação contra você. 7-9 você segura, mas sua peça racha, você fica encurralado ou vira o alvo prioritário.
**Move Utilitário — Presença de Guarda:** quando você se posiciona visivelmente para impedir violência, abrir passagem ou conduzir uma evacuação, role 2d6+Corpo. 10+ as pessoas cedem e o grupo atravessa/escapa sem confusão. 7-9 atravessa, mas alguém se perde, algo se quebra, ou você cria uma inimizade.

### Espada Longa (COR)

**Marca:** espada longa passa alcance médio, presença e domínio de espaço; ela fica mais forte quando há área para impor ritmo.
**Move de Combate — Corte de Zona:** quando você ameaça espaço e tenta separar ou controlar avanço, role 2d6+Corpo. 10+ escolha 1: separe dois inimigos, force recuo, ou impeça aproximação até a cena mudar. 7-9 você consegue, mas fica aberto e a reação vem com força.
**Move Utilitário — Abrir Caminho:** quando você corta obstáculo, vegetação densa, madeira fraca ou improvisa ferramenta de abertura, role 2d6+Corpo. 10+ abre rápido sem travar. 7-9 abre, mas faz barulho, deixa rastro ou prende a lâmina.

### Foice (TEC)

**Marca:** foice passa a impressão de precisão estranha e alcance incômodo; é uma arma de puxar, prender e mexer no que está fora da linha reta.
**Move de Combate — Gancho Cego:** quando você usa a curva da lâmina para puxar, prender ou arrancar alguém de posição sem entrar numa troca limpa, role 2d6+Técnica. 10+ escolha 1: separe o alvo dos aliados dele, negue a próxima reação prendendo roupa/arma/membro por uma troca, ou arraste o alvo para cobertura/sombra/ponto ruim. 7-9 você consegue, mas escolha 1 custo: chega perto demais, deixa uma abertura, ou o alvo entende exatamente como você luta.
**Move Utilitário — Alcance Indireto:** quando você usa a foice para mexer no que seria perigoso tocar de frente — abrir mato, puxar objeto, testar terreno, alcançar uma alavanca, trazer algo das sombras ou mover um corpo sem se expor inteiro — role 2d6+Técnica. 10+ você consegue com controle e sem se comprometer. 7-9 você consegue, mas deixa rastro, faz ruído ou precisa se expor por um instante.

### Katana (ESP)

**Marca:** katana passa intenção, economia de movimento e corte limpo; quando ela aparece, a cena tende a ficar mais tensa e precisa.
**Move de Combate — Corte do Silêncio:** quando você ataca com intenção única para decidir a troca de forma limpa, role 2d6+Espírito. 10+ escolha 1: negue a próxima reação do alvo, force recuo sem barulho, ou imponha respeito (ele hesita antes de agir de novo). 7-9 você consegue, mas perde o silêncio, sua lâmina prende por um instante, ou alguém te toma como ameaça maior.
**Move Utilitário — Código do Duelo:** quando você desafia alguém ou estabelece termos para impedir que a situação vire chacina, role 2d6+Espírito. 10+ o outro precisa aceitar termos, recuar ou perder face. 7-9 ele aceita, mas alguém adiciona condição, testemunha ou aposta.

### Lança (TEC)

**Marca:** lança passa distância segura, linha e controle de aproximação; ela faz a cena pensar em posição antes de pensar em dano.
**Move de Combate — Segunda Fileira:** quando você ataca protegido por aliado/cobertura para manter distância e segurança, role 2d6+Técnica. 10+ escolha 1: negue a próxima reação, mantenha distância, ou empurre o alvo para fora de posição. 7-9 você acerta, mas a formação quebra, o alvo fecha distância ou você precisa recuar.
**Move Utilitário — Medir o Chão:** quando você testa profundidade, armadilha, lama, água ou “lugar errado” antes do grupo pisar, role 2d6+Técnica. 10+ você descobre o risco a tempo e define a rota segura. 7-9 você descobre, mas algo reage ao toque.

### Machado (COR)

**Marca:** machado passa quebra, peso e resolução direta; ele entra melhor em cenas onde algo precisa ceder.
**Move de Combate — Quebrar a Guarda:** quando você bate onde dói (escudo, placa, casca, estrutura), role 2d6+Corpo. 10+ você abre uma brecha: o próximo golpe aliado contra esse alvo não sofre reação ou resistência. 7-9 você abre, mas sua arma pesa, prende ou você perde ritmo.
**Move Utilitário — Golpe de Trabalho:** quando você arromba, derruba, corta madeira ou abre passagem em coisa teimosa, role 2d6+Corpo. 10+ você abre com controle. 7-9 você abre, mas o barulho ou a marca chama atenção.

### Martelo (COR)

**Marca:** martelo passa impacto, estrutura e ruptura; ele muda a cena quando o importante é parar, fixar ou quebrar.
**Move de Combate — Selo de Impacto:** quando você acerta algo grande/duro para mudar o ritmo da luta, role 2d6+Corpo. 10+ escolha 1: derrube, interrompa a próxima ação, ou negue a próxima reação. 7-9 você consegue, mas a vibração te cobra (dano leve, perda de fôlego, arma escorrega).
**Move Utilitário — Quebrar ou Fixar:** quando você abre rocha fraca, crava apoio, conserta algo improvisando ou “faz funcionar”, role 2d6+Corpo. 10+ fica firme e seguro. 7-9 funciona, mas é temporário, barulhento ou exige manutenção.

### Pá (CON)

**Marca:** pá passa improviso, terreno e preparação; ela faz a cena olhar para o chão, para o abrigo e para o que pode ser montado ali.
**Move de Combate — Terreno é Arma:** quando você usa chão, areia, água rasa ou entulho para criar vantagem tática, role 2d6+Conhecimento. 10+ escolha 1: crie cobertura, derrube/cegue por um instante, ou force recuo. 7-9 você cria a vantagem, mas perde posição ou deixa rastro óbvio.
**Move Utilitário — Abrigo e Rastro:** quando você cava, esconde, enterra, apaga pegadas ou prepara um ponto seguro, role 2d6+Conhecimento. 10+ você cria um lugar seguro e discreto; o mestre deve te dar 1 detalhe útil sobre a área. 7-9 funciona, mas fica rastreável ou cobra tempo.

### Rapieira (REF)

**Marca:** rapieira passa precisão, timing e leitura de abertura; ela brilha quando a cena oferece um ponto exato para agir.
**Move de Combate — Ponto Único:** quando há uma abertura real (fraqueza conhecida, abertura criada por aliado ou descuido visível) e você a explora, role 2d6+Reflexo. 10+ escolha 1: interrompa a ação, force recuo, ou marque o alvo (o próximo golpe aliado contra ele não sofre reação). 7-9 você acerta, mas a lâmina prende, você perde equilíbrio ou vira foco.
**Move Utilitário — Corte Cirúrgico:** quando você corta algo delicado sem destruir o resto (trava, correia, costura, corda certa), role 2d6+Reflexo. 10+ você resolve sem deixar evidência. 7-9 você resolve, mas deixa sinal ou leva tempo.

### Bastão (ESP)

**Marca:** bastão passa ritmo, equilíbrio e condução; ele reorganiza a cena sem precisar ocupar o centro dela.
**Move de Combate — Ritmo de Grupo:** quando você dita o ritmo da troca para manter o grupo junto, role 2d6+Espírito. 10+ escolha 1: negue a próxima reação contra um aliado que você chamar, force recuo, ou abra espaço para diálogo. 7-9 você consegue, mas se expõe e vira o alvo.
**Move Utilitário — Vara de Peregrino:** quando você guia travessia, acalma pânico ou mantém alguém de pé sem gastar Cristal, role 2d6+Espírito. 10+ a pessoa/grupo atravessa e mantém a cabeça fria; o mestre remove uma escalada emocional da cena. 7-9 atravessa, mas alguém paga com cansaço, dor ou dívida social.

### Tonfas (TEC)

**Marca:** tonfas passam defesa curta, giro e resposta imediata; elas ficam mais fortes quando o espaço aperta.
**Move de Combate — Trancar Reação:** quando você luta colado ou em espaço apertado para negar contra-ataque, role 2d6+Técnica. 10+ escolha 1: negue a próxima reação, desarme, ou force recuo curto. 7-9 você consegue, mas sua guarda abre para outro perigo.
**Move Utilitário — Alavanca Curta:** quando você força mecanismo, abre grade, empurra tampa ou improvisa ferramenta precisa, role 2d6+Técnica. 10+ abre sem quebrar. 7-9 abre, mas entorta/quebra algo e isso vira problema.

### Clava (COR)

**Marca:** clava passa peso, pressão e imposição de espaço; quando ela entra, a cena tende a responder.
**Move de Combate — Pressão Bruta:** quando você tenta impor recuo, rendição ou quebra de moral, role 2d6+Corpo. 10+ escolha 1: force recuo, desarme, ou capture sem matar. 7-9 você consegue, mas vira rivalidade imediata ou chama reforço.
**Move Utilitário — Autoridade do Peso:** quando você entra em uma cena tensa e tenta impedir que a violência escale, role 2d6+Corpo. 10+ a cena desacelera e você define a regra do lugar por enquanto. 7-9 desacelera, mas alguém te desafia depois.

### Nunchaku (TEC)

**Marca:** nunchaku passam fluxo, cadência e mudança rápida de direção; a cena ganha velocidade e imprevisibilidade.
**Move de Combate — Fluxo:** quando você luta com ritmo para vencer sem matar, role 2d6+Técnica. 10+ escolha 1: capture sem matar, desarme, ou force recuo. 7-9 você consegue, mas vira espetáculo: alguém comenta, filma, aposta ou espalha boato.
**Move Utilitário — Truque de Cordão:** quando você usa corda curta, amarra, prende, puxa ou faz um truque para distrair, role 2d6+Técnica. 10+ funciona e não parece ameaça. 7-9 funciona, mas alguém interpreta como provocação.

### Glaive (REF)

**Marca:** glaive passa alcance amplo, linha de passagem e domínio de área; ele reorganiza como os corpos se movem no espaço.
**Move de Combate — Passo de Pique:** quando você mantém inimigos fora do alcance e tenta controlar espaço amplo, role 2d6+Reflexo. 10+ escolha 1: mantenha distância, force recuo, ou impeça que alguém atravesse um ponto. 7-9 você consegue, mas o cabo enrosca, o chão te trai ou você fica preso em espaço curto.
**Move Utilitário — Estandarte de Passagem:** quando você usa o glaive como símbolo de escolta, patrulha ou “formação” para atravessar uma área com gente, role 2d6+Reflexo. 10+ as pessoas assumem ordem e abrem passagem. 7-9 abrem, mas cobram favor, informação ou aval de guilda.

### Corrente com Peso (TEC)

**Marca:** corrente com peso passa contenção, travamento e risco compartilhado; ela muda a cena quando prender importa mais do que ferir.
**Move de Combate — Laço:** quando você tenta prender alguém sem matar para forçar escolha, role 2d6+Técnica. 10+ escolha 1: capture sem matar, desarme, ou impeça fuga. 7-9 você prende, mas fica preso junto ou cria um dilema moral imediato.
**Move Utilitário — Ancoragem:** quando você fixa, segura, puxa ou trava uma porta/ponte com a corrente, role 2d6+Técnica. 10+ segura firme. 7-9 segura, mas range, escorrega ou dura pouco.

### Manopla (COR)

**Marca:** manopla passa contato direto, aderência e controle físico; ela fica forte quando a cena vira disputa de pegada e proximidade.
**Move de Combate — Pegada:** quando você decide que a troca vira corpo a corpo para controlar e não para matar, role 2d6+Corpo. 10+ escolha 1: capture sem matar, desarme, ou negue a próxima reação. 7-9 você controla, mas apanha junto (dano leve ou você fica preso).
**Move Utilitário — Aderência:** quando você escala, segura, levanta alguém ou impede uma queda, role 2d6+Corpo. 10+ você salva sem se machucar. 7-9 você salva, mas paga com dor, ferimento ou exposição.

### Leque (TEC)

**Marca:** o leque passa elegância, controle de espaço e comando à distância; ela dirige a cena com um gesto, nunca com força.
**Move de Combate — Aceno que Comanda:** quando você usa um gesto do leque para guiar o golpe de um aliado no meio da luta, role 2d6+Técnica. 10+ escolha 1: o aliado acerta sem sofrer reação, você redireciona o ataque de outra pessoa pra um alvo diferente, ou nega a próxima reação do alvo. 7-9 o aliado acerta, mas escolha 1: você se expõe, o inimigo passa a ler seus gestos, ou o aliado sofre o troco.
**Move Utilitário — Vento Que Guia:** quando você usa o leque pra criar um efeito com o ar — apagar rastro, espalhar fumaça, mandar um sinal à distância, acalmar algo agitado — role 2d6+Técnica. 10+ funciona limpo, sem chamar atenção indevida. 7-9 funciona, mas chama atenção extra ou é mal-interpretado.

## As 16 profissões de Aincrad

> **Reforma 12/08**: Bibliotecário + Diplomata unificaram em
> **Informante**; **Coveiro** saiu (funções foram pro Mercenário);
> entraram **Mestre de Montarias** e **Minerador**. Continua em 16
> profissões — só a lineup mudou. Personagem que já tinha a profissão
> antiga não quebra (o campo é texto livre), só some do dropdown de
> personagem novo. Seções antigas de Bibliotecário/Diplomata/Coveiro
> ficam marcadas "descontinuada" abaixo, não apagadas — servem de
> referência caso algum personagem legado ainda use.

Cada profissão está ligada a um atributo principal e concede um **Move
Exclusivo**. Nesta mesa, cada profissão concede:

- **Move de Ofício** (o que só você faz).
- **Move de Cena** (como você garante protagonismo em jogo).
- **Move Exclusivo** (o golpe de assinatura da profissão — formato PBTA
  10+ escolha 2 / 7-9 escolha 1 / 6- o Mestre narra; ver
  `SAO_PBTA_Profissoes_e_Moves.pdf`).
- **Marca** (como o mundo te lê; sem rolagem).

| Profissão           | Atributo     | Faz                                                                         |
| ------------------- | ------------ | --------------------------------------------------------------------------- |
| Caçador             | Reflexo      | Rastreia, caça, pesca e coleta materiais de criaturas e monstros            |
| Lenhador            | Reflexo      | Coleta madeira e recursos da natureza com agilidade                         |
| Cartógrafo          | Conhecimento | Explora e revela mapas, descobre rotas e locais escondidos                  |
| Comerciante         | Conhecimento | Negocia, compra e vende itens e informações                                 |
| Cozinheiro          | Conhecimento | Prepara refeições que recuperam energia e concedem bônus temporários        |
| Informante          | Conhecimento | Pesquisa registros, cultiva contatos, ouve rumores e vende informação       |
| Alquimista          | Conhecimento | Cria poções e itens especiais usando misturas e reações químicas            |
| Costureiro          | Técnica      | Cria e aprimora roupas, armas e itens de tecido                             |
| Domador             | Técnica      | Treina e cria laços com criaturas; comanda aliados em batalha               |
| Ferreiro            | Técnica      | Forja armas, armaduras e ferramentas; domina fogo e metal                   |
| Joalheiro           | Técnica      | Cria, repara e aprimora anéis, colares, pedras preciosas e acessórios       |
| Mestre de Montarias | Técnica      | Aproxima, doma e conduz criaturas usadas como montaria                      |
| Médico              | Espírito     | Cuida de ferimentos, doenças e efeitos negativos; especialista em cura      |
| Músico              | Espírito     | Usa música para inspirar aliados, fortalecer o moral, influenciar emoções   |
| Mercenário          | Corpo        | Guerreiro de aluguel; combate corpo a corpo, escolta e recuperação          |
| Minerador           | Corpo        | Escava túneis e extrai minérios das regiões mais perigosas e profundas      |

## Moves de Profissão (todas Tier S em protagonismo)

### Caçador (REF)

**Marca:** você é “o que volta com prova”; gente te procura quando precisa de material e verdade.
**Move de Ofício — Extração:** quando você extrai material raro/bônus de uma criatura recém-abatida, role 2d6+Reflexo. 10+ você consegue e escolhe 1: encontra um traço útil (rastro, toca, rota), ou mantém a cena limpa (sem atrair atenção). 7-9 você consegue, mas cria uma pressão (barulho, cheiro, predador, discussão moral).
**Move de Cena — Olho de Caça:** quando você entra em região selvagem e para para ler sinais (pegadas, vento, fezes, silêncio), role 2d6+Reflexo. 10+ o mestre deve te dizer o perigo mais próximo e a rota mais segura. 7-9 ele diz, mas você escolhe: risco, tempo ou exposição.
**Move Exclusivo — Mestre da Caçada:** quando você rastrear uma criatura, pescar, preparar uma armadilha ou procurar recursos naturais, descreva sua abordagem e role 2d6+Reflexo. 10+ escolha 2 / 7-9 escolha 1 entre: encontra rápido o que procurava, obtém recurso adicional, encontra algo raro, identifica um perigo/fraqueza antes da hora, ou prepara uma vantagem pra próxima ação contra a presa. 6- o mestre narra: rastro falso leva a território alheio, equipamento quebra ou fica preso, a presa percebe você primeiro, o recurso está protegido por algo perigoso, ou você se perde/isola/fica Sob Pressão.

### Lenhador (REF)

**Marca:** você é o “mão de obra do andar”; gente respeita quem sabe fazer fogo e abrigo.
**Move de Ofício — Corte Certo:** quando você coleta madeira boa ou rara em lugar onde não é seguro perder tempo, role 2d6+Reflexo. 10+ você coleta sem desperdício e sem marca. 7-9 você coleta, mas deixa rastro, se machuca levemente ou atrai gente.
**Move de Cena — Acampamento que Aguenta:** quando o grupo para para descansar e você assume o acampamento (fogo, abrigo, silêncio), role 2d6+Reflexo. 10+ o descanso é seguro e o mestre deve remover uma pressão do caminho (frio, fome, medo). 7-9 é seguro, mas a noite cobra (barulho, rastros, visita).
**Move Exclusivo — Força da Floresta:** quando você explorar uma área florestal, derrubar uma árvore ou coletar madeira usando movimentos rápidos e precisos, descreva seu método e role 2d6+Reflexo. 10+ escolha 2 / 7-9 escolha 1 entre: madeira adicional, material raro/resistente, conclui rápido antes de um perigo, preserva as ferramentas, ou identifica caminho seguro/recurso próximo. 6- o mestre narra: a árvore cai em direção perigosa, o barulho atrai algo, a madeira é de má qualidade, a ferramenta prende ou quebra, ou a árvore rara está protegida.

### Cartógrafo (CON)

**Marca:** você “conhece o andar”; gente te paga por caminho e por segurança.
**Move de Ofício — Mapa Vivo:** quando você entra em uma região ainda desconhecida e observa antes de explorar, role 2d6+Conhecimento. 10+ o mestre revela pontos fáceis/óbvios e uma rota segura. 7-9 revela parte, mas cobra tempo ou risco.
**Move de Cena — Rota Segura:** quando o grupo decide atravessar um caminho perigoso e você traça o plano, role 2d6+Conhecimento. 10+ vocês evitam uma ameaça prevista. 7-9 vocês evitam, mas aparecem em um lugar pior (mais longe, mais visível, mais hostil).

### Comerciante (CON)

**Marca:** você é rede; todo mundo tem uma opinião sobre você.
**Move de Ofício — Negociação:** quando você tenta comprar, vender ou trocar algo importante, role 2d6+Conhecimento. 10+ você consegue um acordo justo e escolhe 1: reduz o risco social, garante estoque, ou obtém uma informação verdadeira. 7-9 você consegue, mas cria dívida, rumor ou rival.
**Move de Cena — Ouvir a Praça:** quando você passa alguns minutos ouvindo, perguntando e juntando nomes, role 2d6+Conhecimento. 10+ o mestre te dá uma oportunidade real. 7-9 te dá, mas vem com dono e cobrança.
**Move Exclusivo — Negociação Perfeita:** quando você negociar a compra, venda ou troca de um item, serviço ou informação, explique sua proposta e role 2d6+Conhecimento. 10+ escolha 2 / 7-9 escolha 1 entre: preço muito melhor, benefício adicional no acordo, descobre o valor/raridade real, a outra parte passa a confiar em você, ou percebe uma intenção escondida/golpe. 6- o mestre narra: preço piora, você aceita condição ruim sem perceber, a mercadoria tem defeito oculto, você ofende alguém influente, ou o acordo exige pagamento/favor extra.

### Cozinheiro (CON)

**Marca:** você é conforto em Aincrad; gente te protege porque você alimenta.
**Move de Ofício — Refeição de Campo:** quando você cozinha antes de uma saída com recursos limitados, role 2d6+Conhecimento. 10+ a comida muda o humor do grupo e remove uma pressão de viagem (cansaço, medo, frio). 7-9 remove, mas cria outra (barulho, cheiro, gente pedindo).
**Move de Cena — Mesa e Conversa:** quando você transforma uma pausa em conversa real (taverna, acampamento, beira de estrada), role 2d6+Conhecimento. 10+ o mestre revela um boato útil verdadeiro. 7-9 revela, mas alguém ouve também.
**Move Exclusivo — Banquete Revigorante:** quando você preparar uma refeição completa para o grupo usando ingredientes adequados, descreva o prato e role 2d6+Conhecimento. 10+ escolha 2 / 7-9 escolha 1 entre: todos recuperam 1 PV, cada um remove Amedrontado/Exausto/Sob Pressão, +1 na próxima ação do desafio, porções extras guardadas, ou você preserva ingredientes. 6- o mestre narra: a refeição não revigora, ingredientes desperdiçados, causa desconforto, o cheiro atrai algo indesejado, ou a receita exige ingrediente/utensílio raro.

### Diplomata (CON) — descontinuada 12/08, ver Informante

**Marca:** você é política; as guildas te observam, gostando ou não.
**Move de Ofício — Mediar:** quando você negocia passagem, trégua ou termo entre grupos, role 2d6+Conhecimento. 10+ você fecha acordo e escolhe 1: evita violência nesta cena, abre acesso, ou conquista aval. 7-9 fecha, mas você assume obrigação concreta.
**Move de Cena — Antes da Lâmina:** quando a tensão vai virar combate entre pessoas e você entra no meio, role 2d6+Conhecimento. 10+ todo mundo para e escuta, e a cena vira diálogo por enquanto. 7-9 para, mas alguém exige prova, pagamento ou humilhação.

### Bibliotecário (CON) — descontinuada 12/08, ver Informante

**Marca:** você é memória; gente te procura por nome, fraqueza e história.
**Move de Ofício — Pesquisa com Fonte:** quando você pesquisa um monstro, item ou evento com fonte real, role 2d6+Conhecimento. 10+ o mestre revela fraqueza e um detalhe útil de comportamento. 7-9 revela uma parte, mas cobra tempo, favor ou exposição.
**Move de Cena — Ler o que Ninguém Lê:** quando você para para ler inscrições, listas, diários, placas ou registros, role 2d6+Conhecimento. 10+ você acha a pista que move a cena. 7-9 você acha, mas ativa atenção indesejada (guardas, NPC, guilda, anomalia).

### Informante (CON)

**Marca:** você é rede e memória ao mesmo tempo; gente te procura por nome, por rumor e por dívida a cobrar.
**Move de Ofício — Pesquisa com Fonte:** quando você pesquisa um monstro, item, pessoa ou evento com fonte real (registro, arquivo, testemunha), role 2d6+Conhecimento. 10+ o mestre revela um detalhe crítico e útil. 7-9 revela uma parte, mas cobra tempo, favor ou exposição.
**Move de Cena — Contato Certo:** quando você aciona um contato ou puxa conversa pra conseguir algo que só gente por dentro sabe, role 2d6+Conhecimento. 10+ o mestre te dá a pessoa, o lugar ou a informação certa. 7-9 te dá, mas o contato cobra favor, silêncio ou exposição.
**Move Exclusivo — Rede de Informações:** quando você pesquisar registros, consultar contatos, ouvir rumores ou negociar por uma informação importante, diga o que deseja descobrir e role 2d6+Conhecimento. 10+ escolha 2 / 7-9 escolha 1 entre: descobre exatamente o que procurava, descobre algo adicional, identifica quem está mentindo/escondendo algo, descobre onde encontrar algo relacionado, ou estabelece um contato útil (+1 na próxima interação). 6- o mestre narra: informação errada ou plantada, atenção de alguém perigoso, favor complicado exigido, informação perigosa, ou a fonte é inacessível.

### Alquimista (CON)

**Marca:** você é “o que faz funcionar”; gente te vê como solução e como risco.
**Move de Ofício — Mistura:** quando você prepara antídoto, isca ou pomada com ingredientes do andar, role 2d6+Conhecimento. 10+ funciona limpo. 7-9 funciona, mas tem efeito colateral (cheiro, fumaça, irritação, marca).
**Move de Cena — Improviso:** quando você tenta usar o ambiente para criar um efeito rápido (feromônio, fumaça, solvente, neutralização), role 2d6+Conhecimento. 10+ você cria o efeito sem piorar a cena. 7-9 cria, mas escala o perigo.
**Move Exclusivo — Mistura Perfeita:** quando você combinar ingredientes e seguir uma fórmula para criar um preparado alquímico, descreva o efeito desejado e role 2d6+Conhecimento. 10+ escolha 2 / 7-9 escolha 1 entre: duas doses em vez de uma, efeito mais potente/duradouro, usa menos ingredientes, remove uma condição apropriada, ou descobre melhoria pra próxima vez (+1). 6- o mestre narra: efeito imprevisível, ingredientes desperdiçados, causa condição/complicação temporária, chama atenção (fumaça, explosão), ou exige ingrediente/ferramenta/conhecimento raro.

### Costureiro (TEC)

**Marca:** você é cuidado; quem usa peça sua “vira gente”.
**Move de Ofício — Remendo:** quando você repara uma peça rachada ou adapta roupa para a cena (frio, lama, silêncio), role 2d6+Técnica. 10+ fica firme e discreto. 7-9 fica firme, mas limita movimento ou deixa marca.
**Move de Cena — Disfarce:** quando você usa tecido, capuz, corte ou detalhe para mudar como NPCs te leem, role 2d6+Técnica. 10+ você passa como quer. 7-9 você passa, mas alguém te reconhece depois.
**Move Exclusivo — Mestre dos Tecidos:** quando você confeccionar, reparar ou aprimorar uma peça de roupa, armadura leve ou equipamento de tecido, descreva o resultado desejado e role 2d6+Técnica. 10+ escolha 2 / 7-9 escolha 1 entre: +1 numa situação específica, protege de uma condição uma vez, compartimento oculto, resistente (ignora primeiro dano), ou preserva materiais. 6- o mestre narra: ponto frágil que pode romper, materiais desperdiçados, fica desconfortável (Sob Pressão em situação exigente), exige material/ferramenta raro, ou ganha característica indesejada.

### Domador (TEC)

**Marca:** você anda com vida ao lado; isso atrai curiosidade, inveja e medo.
**Move de Ofício — Ovo de Fera** (substitui a antiga "Doma" — amansar bicho adulto foi removido, o vínculo agora nasce do ovo): quando você encontra, cuida ou tenta chocar um ovo de criatura, descreva como prepara o ambiente e role 2d6+Técnica. 10+ escolha 2: o ovo choca com segurança e a fera nasce saudável, ela reconhece você como cuidador e cria vínculo imediato, você descobre uma característica especial dela, ou preserva os materiais usados no cuidado. 7-9 escolha 1: choca mas exige cuidados constantes por um tempo, a fera ainda precisa de confiança antes de aceitar você, ou nasce saudável só que assustada e difícil de controlar. 6- o mestre escolhe: o ovo não choca sem um local/item/condição especial, a criatura nasce agressiva ou desconfiada, o processo chama atenção da mãe da fera ou de outros monstros, ou o ovo tem doença/maldição/característica inesperada.
**Move de Cena — Ordem Clara:** quando você dá uma ordem ao aliado domado para resolver um obstáculo ou mudar uma cena, role 2d6+Técnica. 10+ escolha 1: proteger alguém, abrir caminho, ou evitar uma ameaça. 7-9 ele faz, mas cria consequência (barulho, risco, ciúme, custo).
**Move Exclusivo — Ovo de Fera:** quando você encontrar, cuidar ou tentar chocar um ovo de criatura, descreva como prepara o ambiente e role 2d6+Técnica. 10+ escolha 2 / 7-9 escolha 1 entre: o ovo choca com segurança, a fera cria vínculo imediato, você descobre uma característica especial, ela nasce com qualidade incomum, ou você preserva os materiais usados. 6- o mestre narra: o ovo não choca sem condição especial, a criatura nasce agressiva/desconfiada, chama atenção da mãe ou de outros monstros, o ovo tem doença/maldição/característica inesperada, ou a criatura vincula com outra pessoa e foge.

### Ferreiro (TEC)

**Marca:** você é escassez; gente tenta te puxar pra guilda ou te pressionar.
**Move de Ofício — Forjar/Consertar:** quando você trabalha metal para transformar material do andar em componente útil ou segurar equipamento até a próxima cidade, role 2d6+Técnica. 10+ fica bom e não racha nesta sessão. 7-9 fica, mas você paga (material extra, tempo, rumor).
**Move de Cena — Avaliar Liga:** quando você examina arma/equipamento/material e diz o que está errado, role 2d6+Técnica. 10+ o mestre te diz a verdade e como resolver. 7-9 diz, mas a solução cobra algo difícil.
**Move Exclusivo — Forja Suprema:** quando você forjar, reparar ou aprimorar uma arma, armadura ou equipamento metálico, descreva o resultado desejado e role 2d6+Técnica. 10+ escolha 2 / 7-9 escolha 1 entre: +1 numa situação específica, reforçado (ignora primeiro dano), a arma atravessa uma guarda resistente uma vez, a armadura protege de uma condição uma vez, ou você preserva materiais. 6- o mestre narra: ponto frágil que pode falhar, material perdido na forja, fica pesado/desconfortável, exige minério/ferramenta/forja melhor, ou ganha falha indesejada.

### Joalheiro (TEC)

**Marca:** joia é status; gente te mede por detalhe.
**Move de Ofício — Lapidar:** quando você transforma um material raro em acessório com significado (não magia), role 2d6+Técnica. 10+ fica desejável e útil, e o mestre deve dizer quem vai querer isso. 7-9 fica, mas atrai cobiça ou suspeita.
**Move de Cena — Ler Gente:** quando você observa alguém pelo que usa e pelo que finge não valorizar, role 2d6+Técnica. 10+ o mestre te dá a motivação real daquela pessoa. 7-9 te dá, mas você cria um inimigo por ter “enxergado demais”.
**Move Exclusivo — Lapidação Encantada:** quando você trabalhar uma pedra preciosa ou joia para criar, reparar ou aprimorar um acessório, descreva o resultado desejado e role 2d6+Técnica. 10+ escolha 2 / 7-9 escolha 1 entre: +1 numa situação específica, armazena efeito de cristal consumível, protege de uma condição uma vez, grande valor de venda, ou revela propriedade especial do material. 6- o mestre narra: a pedra quebra ou perde valor, funciona de forma instável, exige material raro pra terminar, fica marcada por falha, ou consome mais recurso/tempo que o esperado.

### Coveiro (ESP) — descontinuada 12/08, funções foram pro Mercenário

**Marca:** você anda perto da morte; algumas pessoas se afastam, outras procuram consolo.
**Move de Ofício — Rito:** quando você realiza rito no Memorial/Necrópole com respeito para lidar com presença, culpa ou silêncio, role 2d6+Espírito. 10+ o mestre responde 1 verdade sobre um morto ou uma presença. 7-9 você recebe sinal, mas fica marcado (peso, visita, cobrança social).
**Move de Cena — Ouvir o Que Fica:** quando alguém morre, desaparece ou a cidade comenta um nome, role 2d6+Espírito. 10+ você encontra a pessoa certa ou o lugar certo para a próxima cena. 7-9 encontra, mas chega tarde ou deve algo.

### Mestre de Montarias (TEC)

**Marca:** você anda lado a lado com uma fera maior que você; isso muda como o mundo te vê — respeito, medo ou cobiça.
**Move de Ofício — Doma de Montaria:** quando você tenta acalmar, domesticar ou treinar uma criatura pra servir como montaria, role 2d6+Técnica. 10+ a criatura aceita você e obedece um comando simples. 7-9 aceita, mas exige alimento, cuidado ou paciência antes de confiar de verdade.
**Move de Cena — Conduzir na Pressão:** quando sua montaria precisa atravessar perigo, terreno ruim ou pânico sem quebrar a formação, role 2d6+Técnica. 10+ ela atravessa firme e o grupo não perde tempo nem recurso. 7-9 atravessa, mas o esforço cobra — ela se cansa, se machuca ou assusta.
**Move Exclusivo — O Domesticador:** quando você tentar acalmar, domesticar ou treinar uma criatura para servir como montaria, descreva sua abordagem e role 2d6+Técnica. 10+ escolha 2 / 7-9 escolha 1 entre: a criatura aceita ser montada, aprende um comando simples, você identifica suas necessidades/medos/preferências, ela permanece calma sob pressão, ou você cria um vínculo forte (+1 na próxima ação junto dela). 6- o mestre narra: a criatura se assusta ou foge, aceita outra pessoa em vez de você, chama atenção de uma criatura dominante ou do antigo dono, exige algo especial antes de ser montada, ou perde o controle no pior momento.

### Médico (ESP)

**Marca:** você carrega responsabilidade; quando dá errado, ninguém esquece.
**Move de Ofício — Triagem:** quando você trata status/ferimento sem gastar Cristal, role 2d6+Espírito. 10+ remove e estabiliza sem deixar rastro. 7-9 remove, mas deixa fraqueza temporária ou exige insumo/repouso.
**Move de Cena — Manter Alguém Vivo:** quando alguém está em pânico, choque ou prestes a desabar e você assume, role 2d6+Espírito. 10+ a pessoa volta ao controle e a cena não escala. 7-9 volta, mas você absorve parte do peso (cansaço, culpa, cobrança).
**Move Exclusivo — O Salva-Vidas:** quando você prestar atendimento imediato a alguém ferido, inconsciente ou em estado crítico, descreva como realiza o tratamento e role 2d6+Espírito. 10+ escolha 2 / 7-9 escolha 1 entre: recupera 1 PV, remove Ferido/Abalado/Paralisado/Exausto/Sob Pressão, estabiliza completamente, identifica a causa e como tratá-la de vez, ou +1 na próxima ação do paciente. 6- o mestre narra: o estado piora durante o atendimento, uma nova condição aparece, os materiais acabam, exige item raro/cirurgia/ajuda especializada, ou a pressão te deixa Abalado/Sob Pressão.

### Músico (ESP)

**Marca:** você mexe com humor; gente te ama, te odeia ou te usa.
**Move de Ofício — Cadência:** quando você toca para mudar emoção de grupo (acalmar, inspirar, impor ritmo), role 2d6+Espírito. 10+ escolha 1: reduza tensão social, dê coragem para atravessar um medo, ou transforme pausa em conversa. 7-9 você consegue, mas atrai atenção inevitável.
**Move de Cena — A Praça Ouve:** quando você toca em lugar público e pede algo em troca (informação, abrigo, silêncio), role 2d6+Espírito. 10+ alguém responde com algo verdadeiro. 7-9 alguém responde, mas com interesse e cobrança.
**Move Exclusivo — A Melodia Inspiradora:** quando você tocar ou cantar para inspirar seus companheiros antes ou durante uma situação perigosa, descreva sua apresentação e role 2d6+Espírito. 10+ escolha 2 / 7-9 escolha 1 entre: um aliado recebe +1 na próxima ação, remove Amedrontado/Abalado/Sob Pressão de alguém, o grupo inteiro escolhe ordem de ação na próxima troca, um aliado age apesar do medo, ou você distrai o suficiente pra um aliado se reposicionar. 6- o mestre narra: a música atrai algo indesejado, a apresentação aumenta a tensão em vez de aliviar, um inimigo passa a te considerar alvo principal, seu instrumento sofre dano, ou você absorve as emoções e fica Abalado/Sob Pressão.

### Mercenário (COR)

**Marca:** você é segurança; gente te contrata e também te teme. Desde 12/08 também absorve o que era do Coveiro: recuperação de corpos e trabalho sujo em zona perigosa.
**Move de Ofício — Escolta:** quando você escolta alguém por zona perigosa, role 2d6+Corpo. 10+ vocês chegam sem incidente e o grupo mantém recursos. 7-9 chegam, mas o mestre cobra em tempo, dano leve ou perseguição.
**Move de Cena — Postura de Guarda:** quando a cena fica perigosa e você toma a frente para ler ameaça e definir posição, role 2d6+Corpo. 10+ o mestre te diz de onde vem o perigo e como evitar o pior. 7-9 diz, mas você paga ficando exposto.
**Move Exclusivo — Profissional da Missão:** quando você assumir um trabalho perigoso, proteger alguém, recuperar um corpo ou pertences, ou enfrentar um obstáculo ligado a um contrato, descreva sua abordagem e role 2d6+Corpo. 10+ escolha 2 / 7-9 escolha 1 entre: avança direto ao objetivo, protege um aliado das consequências imediatas, neutraliza uma ameaça no avanço, recupera com segurança o que procurava, ou descobre uma pista importante na cena. 6- o mestre narra: o contratante escondeu algo, o alvo não está onde deveria, algo revela uma ameaça maior, você fica cercado/isolado/Sob Pressão, ou o contrato exige uma escolha difícil.

### Minerador (COR)

**Marca:** você é o que desce onde os outros não vão; gente confia em você pra achar o que está fundo demais pra ser fácil.
**Move de Ofício — Escavação:** quando você escava rocha, abre um túnel ou extrai minério usando força e resistência, role 2d6+Corpo. 10+ você extrai o que precisa sem desgastar ferramenta nem se expor. 7-9 extrai, mas perde tempo, desgasta a ferramenta ou desperta algo.
**Move de Cena — Leitura de Veio:** quando você examina uma parede rochosa, mina ou formação antes de decidir onde cavar, role 2d6+Corpo. 10+ o mestre te diz onde está o melhor material e o perigo mais próximo. 7-9 diz uma das duas coisas, não as duas.
**Move Exclusivo — Escavador das Profundezas:** quando você escavar uma parede rochosa, explorar uma mina ou extrair minério usando sua força e resistência, descreva seu método e role 2d6+Corpo. 10+ escolha 2 / 7-9 escolha 1 entre: encontra minério ou pedra útil adicional, descobre um minério raro/cristal especial, abre uma passagem segura, conclui sem desgastar ferramentas, ou identifica antecipadamente uma ameaça subterrânea. 6- o mestre narra: desabamento ou passagem bloqueada, barulho desperta algo, ferramenta quebra ou fica presa, região com gás/calor/perigo natural, ou o minério valioso está numa área instável, profunda ou protegida.

## Equipamentos

Tipos de slot: **Armaduras**, **Escudos**, **Capuz**, **Acessórios**, **Luvas**,
**Parte de Cima**, **Parte de Baixo**. Cada equipamento tem requisito de nível
e, em alguns casos, requisito de atributo.

**Itens mágicos**: raros, podem conceder efeitos únicos e aumentar os
atributos principais além dos limites comuns.

## Cristais (6 tipos)

| Cristal   | Efeito                                                                                |
| --------- | ------------------------------------------------------------------------------------- |
| Teleporte | Transporta instantaneamente para qualquer cidade/ponto de teleporte já registrado     |
| Cura      | Restaura instantaneamente uma grande quantidade de HP, dentro ou fora de combate      |
| Antídoto  | Remove venenos, doenças e efeitos negativos (paralisia, sono, confusão)               |
| Luz       | Ilumina a área ao redor, revela caminhos ocultos, afasta criaturas que temem luz      |
| Barreira  | Cria barreira mágica que reduz/anula dano recebido por um curto período               |
| Outros    | Raros — aumento temporário de atributos, convocação de criaturas, abertura de portais |

Cristais são encontrados em baús, recompensas de missões, monstros raros ou
eventos especiais; alguns têm tempo de recarga.

## Crafting

Processo em 4 etapas: coletar materiais → levar a um artesão/usar profissão →
fabricar o equipamento → qualidade final (depende do nível da profissão,
materiais usados e sorte).

**Raridade/qualidade dos itens** (usar esta escala para armas, equipamentos e
itens mágicos):

| Raridade | Descrição                                                                          |
| -------- | ---------------------------------------------------------------------------------- |
| Comum    | Básico, fácil de produzir, sem bônus adicionais — ideal para iniciantes            |
| Incomum  | Pequenos bônus nos atributos principais, maior durabilidade                        |
| Raro     | Bônus significativos, pode ter efeitos especiais                                   |
| Épico    | Grandes bônus, efeitos especiais poderosos ou únicos, criado por artesãos mestres  |
| Lendário | Bônus máximos, efeitos lendários que podem mudar o rumo de uma batalha, raríssimos |

Nem todo item pode ser criado por crafting comum — alguns são únicos e só
vêm de missões, baús ou chefes derrotados.

## Combate contra monstros — HP e resistências

O PBTA normalmente resolve combate de forma narrativa (sucesso/complicação),
mas pra jogo em stream/Foundry com raids grandes, cada monstro também tem um
número simples de **golpes bons pra derrotar** (não é "HP" em pontos, é
literalmente quantos acertos bem-sucedidos — 7+ no teste — o monstro aguenta
antes de cair). Escala por nível de ameaça:

| Nível de ameaça | Golpes pra derrotar                      | Exemplo                            |
| --------------- | ---------------------------------------- | ---------------------------------- |
| fraco           | 1-2                                      | Frenzy Boar                        |
| comum           | 3-4                                      | Ruin Kobold Trooper, Stabbing Wasp |
| forte           | 5-7                                      | Ruin Kobold Sentinel               |
| elite           | 8-10                                     | (miniboss de campo/dungeon)        |
| chefe           | 4 barras x 6-8 golpes cada (24-32 total) | Illfang the Kobold Lord            |

Um "golpe" conta em qualquer sucesso (7-9 ou 10+) num teste de ataque
2d6+atributo; a diferença entre sucesso parcial e completo pode ser dano
extra, efeito adicional, ou custo pro atacante, a critério do mestre.

Cada monstro pode ter:

- **Resistências**: tipo de dano que causa menos golpes de efeito (ex:
  armadura pesada ignora ataques sem ser em ponto fraco)
- **Vulnerabilidades**: tipo de dano/situação que conta em dobro ou garante
  sucesso automático (ex: fogo contra criatura-planta)
- **Tabela de drop**: cada item tem uma % de chance de cair, independente
  do Col/XP fixo

## PvP, Duelos e Player Killing (cap. 5 do manual — ainda não fotografado)

> **Nota de proveniência:** o capítulo 5 do manual físico ainda não foi
> fotografado — não sabemos o tema real dele. O texto abaixo é **homebrew de
> campanha**, escrito pra fechar uma lacuna que já aparecia em várias cenas
> (`cenas/quests_andar1.md`, `cenas/cronicas_de_aincrad_ep01_25.md` e
> `..._ep26_50.md` citam "regras de duelo/PvP" sem elas existirem em lugar
> nenhum). Usa só mecânica já estabelecida — Moves Núcleo e Condições de
> `docs/regras_nucleares_campanha.md` — sem inventar matemática nova. **Se as
> páginas reais do capítulo 5 aparecerem, este texto deve ser revisado ou
> substituído.**

### Zona segura bloqueia tudo

Dentro de zona segura de sistema (Cidade do Início, Tolbana, Horunka,
Brenmoor — ver tabela de `guias/00_como_usar.md`), **o próprio jogo impede
qualquer ataque contra outro jogador**. Não é regra de conduta, é trava de
sistema: a interface simplesmente recusa o comando. Todo conflito de PvP
desta seção só é possível fora dessas zonas.

### Duelo consensual

Dois jogadores podem declarar um duelo a qualquer momento fora de zona
segura, com testemunhas ou não. Antes de rolar:

1. **Aposta.** Col, item, informação, reputação pública ou nada além de
   orgulho — declare antes do primeiro golpe.
2. **Tipo.**
   - **Duelo Selado** (padrão): usa Condições normalmente, mas **para** com
     3 Condições no perdedor — sem rolagem de À Beira. Ninguém morre num
     duelo selado, mesmo em fracasso feio.
   - **Duelo de Sangue** (raro, os dois lados precisam concordar
     explicitamente): À Beira passa a valer normalmente com 3 Condições —
     risco de morte real. Use só quando a ficção realmente pedir (vingança,
     honra, um julgamento que exige risco genuíno — ver `EP.44 — O
     Julgamento`).
3. **Resolução.** Cada participante age por vez usando **Enfrentar Perigo**
   (ver Moves Núcleo); o outro é o "perigo imediato" daquela rolagem. Sem
   iniciativa especial — quem declara a ação primeiro rola primeiro, como em
   qualquer combate deste sistema.

Duelos públicos atraem plateia, apostas de terceiros e interesse de guildas
— ver `EP.25 — Duelo ao Pôr do Sol` (`cenas/cronicas_de_aincrad_ep01_25.md`)
pra uma cena pronta em cima disso.

### Player Killing (PK) — ataque não consensual

Fora de zona segura, um jogador pode atacar outro sem aviso nem
consentimento. Mecanicamente é um **Duelo de Sangue forçado**: a vítima não
escolheu o risco, então ela sempre tem direito a reagir com **Escapar** ou
**Proteger** antes de qualquer golpe valer — o sistema nunca tira a rolagem
da vítima, mesmo numa emboscada (mesma regra geral de "o dado continua
sempre na mão do jogador" de `guias/00_como_usar.md`).

**Consequências automáticas pra quem é confirmado como PK** (testemunha,
confissão ou prova concreta — ver `EP.36 — O Primeiro PK`):

- **Suspeita cai direto pra -3** (Bloqueado) com qualquer facção que soube do
  ato — sem gradação; matar deliberadamente é o tipo de coisa que zera
  confiança de uma vez, não aos poucos (ver tabela de Favor/Suspeita em
  `docs/regras_nucleares_campanha.md`).
- **Bounty**: guildas ou o Sindicato podem oferecer recompensa por captura —
  ver `EP.13 — Caçadores de Recompensa`.
- **Acesso restrito**: cidades/guildas hostis a PK podem recusar serviço,
  informação ou entrada em espaços que não sejam zona segura de sistema
  (zona segura continua acessível a todos, PK incluído — o sistema não
  bane, só a comunidade julga).

### Julgamento comunitário

Sem sistema judicial formal em Aincrad, casos graves (morte deliberada,
acusação de traição) são resolvidos por **julgamento improvisado entre
guildas** — ver `EP.44 — O Julgamento`. O mestre não decide a sentença
sozinho: apresente evidência, deixe as guildas presentes pesarem, e registre
o resultado como mudança de Favor/Suspeita, não como punição narrada à
força.

## Guildas

Hierarquia: **Líder** (decisões estratégicas, responsável máximo) → **Vice-Líder**
(auxilia, assume o comando na ausência do líder) → **Membros** (base da
guilda). Benefícios: compartilhar recursos/informações, formar grupos pra
dungeons/missões difíceis, organizar caçadas a chefes, proteção/cooperação,
armazenamento compartilhado (se a mesa usar). Romper laços com uma guilda
pode custar reputação; guildas podem ter alianças ou rivalidades históricas.

Guildas de exemplo já em uso nesta mesa (usar como inspiração de tom, não
reinventar): Sindicato dos Ossos, LHUB, Dndalcin, iBarr's, Terraço Geek, Guilda
de Nerds.

## Categorias de trilha sonora já estabelecidas (ver `musicas/`)

`01_abertura`, `02_ambiente`, `03_combate`, `04_combate_epico`,
`05_combate_boss`, `06_cidade`. Ao sugerir humor musical para uma cena/NPC,
prefira uma dessas categorias quando fizer sentido; só crie uma nova categoria
quando a cena pedir algo claramente distinto (ex: tema de guilda específica).
