#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Dados estruturados das 19 armas / 152 Sword Skills (7+Limit Break cada),
espelhando o conteudo de SAO_RPG_5e.md Secoes 55-58. Fonte unica usada tanto
pela geracao do markdown quanto pela populacao do banco (moves_arma) --
editar aqui e regenerar os dois em vez de editar cada um separado."""

ARMAS = []

# ============================== TANK ==============================
ARMAS.append(dict(nome="Espada + Escudo", cat="Tank", attr="Força", dano="cortante",
    funcao="Tank de Guarda e Proteção",
    identidade="Segura a linha de frente, protege aliados e pune quem erra o ataque.",
    skills=[
        dict(nivel=1, nome="Guarda Férrea", lb=False, corpo="Postura defensiva. Concede +2 CA, vantagem contra ser empurrado ou derrubado e permite contra-atacar com Reação quando uma criatura errar um ataque corpo a corpo. O deslocamento fica reduzido pela metade enquanto a postura estiver ativa."),
        dict(nivel=1, nome="Interceptação", lb=False, corpo="Reação para proteger um aliado a até 10 ft. O usuário move-se sem provocar Ataques de Oportunidade, torna-se o alvo do ataque e recebe resistência ao dano se for atingido."),
        dict(nivel=2, nome="Golpe de Escudo", lb=False, corpo="Ataque corpo a corpo usando Força. Causa **2d8 + FOR**. O alvo realiza resistência de Força; falha: empurrado 10 ft e Caído. Sucesso: empurrado 5 ft."),
        dict(nivel=5, nome="Muralha de Aincrad", lb=True, corpo="Reação, 1/Descanso Longo, alcance 20 ft. Quando você ou um aliado seria reduzido a 0 PV por um ataque, você intercepta o golpe. O aliado não sofre o dano; você recebe o ataque com resistência. Se isso o reduzir a 0 PV, fica com 1 PV."),
        dict(nivel=6, nome="Muralha de Ferro", lb=False, corpo="Postura defensiva de grupo. Concede resistência contra ataques com armas, proteção contra empurrões/quedas e bônus de CA para aliados próximos."),
        dict(nivel=10, nome="Contra-Golpe", lb=False, corpo="Reação quando uma criatura erra um ataque corpo a corpo contra você. Realiza um ataque de Força e pode derrubar o alvo."),
        dict(nivel=14, nome="Sacrifício do Guardião", lb=False, corpo="Reação para interceptar um ataque destinado a um aliado a até 20 ft, tornando-se o alvo do ataque e recebendo resistência ao dano."),
        dict(nivel=18, nome="Último Bastião", lb=False, corpo="1/Descanso Longo. Forma defensiva máxima por 1 minuto. Concede resistência a ataques com armas, impede movimentação forçada comum e protege aliados próximos."),
    ]))

ARMAS.append(dict(nome="Martelo", cat="Tank", attr="Força", dano="contundente",
    funcao="Tank de Impacto",
    identidade="Impacto, atordoamento, interrupção e resistência.",
    skills=[
        dict(nivel=1, nome="Golpe Demolidor", lb=False, corpo="Ataque corpo a corpo usando Força. Causa **1d10 + FOR**. Se o alvo estiver usando escudo ou postura defensiva, esse bônus fica anulado até o fim do turno seguinte."),
        dict(nivel=1, nome="Martelada Descendente", lb=False, corpo="Ataque corpo a corpo. Causa **1d8 + FOR**. O alvo faz teste de Força; falha: fica **Caído**."),
        dict(nivel=2, nome="Abalo", lb=False, corpo="Golpe de área de 5 ft ao redor do usuário. Inimigos na área fazem resistência de Destreza; falha: **2d6 + FOR** de dano contundente e **Caído**. Sucesso: metade do dano."),
        dict(nivel=5, nome="Impacto de Aincrad", lb=True, corpo="1/Descanso Longo. Golpe de área de 10 ft de raio (alcance corpo a corpo). Inimigos fazem resistência de Constituição; falha: **3d10 + FOR** de dano contundente e **Atordoado** até o fim do próximo turno deles. Sucesso: metade do dano, sem atordoar."),
        dict(nivel=6, nome="Postura Inabalável", lb=False, corpo="Vantagem em testes de resistência contra ser empurrado ou derrubado; resistência a movimentação forçada comum enquanto a postura estiver ativa."),
        dict(nivel=10, nome="Quebra-Couraça", lb=False, corpo="Ataque corpo a corpo. Causa **2d10 + FOR** e reduz a CA do alvo em 2 até o fim da cena (não acumula com usos repetidos)."),
        dict(nivel=14, nome="Contra-Impacto", lb=False, corpo="Reação quando o usuário sofre dano corpo a corpo: reduz o dano em **2d8 + FOR** e, se isso zerar o dano, empurra o atacante 10 ft."),
        dict(nivel=18, nome="Colosso", lb=False, corpo="1/Descanso Longo. Forma suprema por 1 minuto: resistência a dano contundente, +2 CA, e todo ataque corpo a corpo do usuário nesse período força teste de Constituição do alvo (falha: Caído)."),
    ]))

ARMAS.append(dict(nome="Pá", cat="Tank", attr="Força", dano="contundente",
    funcao="Tank de Terreno",
    identidade="Controla o campo de batalha moldando o próprio terreno.",
    skills=[
        dict(nivel=1, nome="Postura Inabalável", lb=False, corpo="Postura defensiva: +2 CA, vantagem contra empurrão/queda e resistência a movimentação forçada comum enquanto ativa."),
        dict(nivel=1, nome="Golpe de Pá", lb=False, corpo="Ataque corpo a corpo usando Força. Causa **1d8 + FOR**. O alvo faz teste de Força; falha: empurrado 5 ft."),
        dict(nivel=2, nome="Cova Defensiva", lb=False, corpo="Cria uma área de 10 ft de terreno difícil ao redor de um ponto a até 10 ft, por 1 minuto. Concede meia cobertura a quem estiver dentro dela."),
        dict(nivel=5, nome="Muralha de Terra", lb=True, corpo="1/Descanso Longo. Cria uma barreira de 10 ft de comprimento e 5 ft de altura, alcance 15 ft. Aliados atrás dela recebem meia cobertura; ataques que a atravessam têm desvantagem."),
        dict(nivel=6, nome="Quebra-Postura", lb=False, corpo="Ataque corpo a corpo. Causa **2d8 + FOR** e o alvo faz teste de Força; falha: **Caído** e deslocamento reduzido pela metade até o fim do turno seguinte."),
        dict(nivel=10, nome="Parede Viva", lb=False, corpo="+2 CA e cria terreno difícil num raio de 10 ft ao redor do usuário por 1 minuto. Inimigos que tentam sair da área têm o deslocamento reduzido a 0 nessa tentativa."),
        dict(nivel=14, nome="Contra-Escavação", lb=False, corpo="Reação quando o usuário sofre dano: reduz o dano em **2d6 + FOR** e pode se reposicionar 5 ft."),
        dict(nivel=18, nome="Fortaleza do Escavador", lb=False, corpo="1/Descanso Longo. Forma suprema por 1 minuto: resistência a dano físico, imunidade a movimentação forçada comum, terreno difícil num raio de 15 ft e meia cobertura pra aliados dentro dele."),
    ]))

ARMAS.append(dict(nome="Lança", cat="Tank", attr="Destreza", dano="perfurante",
    funcao="Tank de Alcance e Interceptação",
    identidade="Controla distância e nega avanço — a ameaça de reação é constante.",
    skills=[
        dict(nivel=1, nome="Postura de Guarda", lb=False, corpo="Postura defensiva: +2 CA contra ataques corpo a corpo, alcance de Ataques de Oportunidade +5 ft enquanto ativa."),
        dict(nivel=1, nome="Estocada Defensiva", lb=False, corpo="Ataque de alcance 10 ft usando Destreza. Causa **1d8 + DES**. O alvo faz teste de Força; falha: empurrado 10 ft."),
        dict(nivel=2, nome="Guarda do Sentinela", lb=False, corpo="Reação: protege um aliado a até 10 ft, tornando-se o alvo de um ataque direcionado a ele."),
        dict(nivel=5, nome="Formação da Vanguarda", lb=True, corpo="1/Descanso Longo. Por 1 minuto, o alcance dos ataques da Lança aumenta em 5 ft e aliados a até 10 ft do usuário ganham +1 de CA."),
        dict(nivel=6, nome="Impacto da Lança", lb=False, corpo="Ataque de alcance 10 ft. Causa **2d8 + DES** e empurra o alvo 5 ft (teste de Força pra resistir)."),
        dict(nivel=10, nome="Círculo do Sentinela", lb=False, corpo="Área defensiva de 10 ft de raio por 1 minuto: inimigos que entram têm o deslocamento reduzido pela metade; o usuário pode usar Reação pra atacar um inimigo que termine o turno na área."),
        dict(nivel=14, nome="Interceptação Perfeita", lb=False, corpo="Reação: reduz em **2d10 + DES** o dano que um aliado a até 10 ft sofreria, e ataca automaticamente quem causou o dano."),
        dict(nivel=18, nome="Senhor da Vanguarda", lb=False, corpo="1/Descanso Longo. Forma suprema por 1 minuto: alcance de todos os ataques da Lança +10 ft, e todo Ataque de Oportunidade do usuário causa dano máximo."),
    ]))

# ============================== DPS ==============================
ARMAS.append(dict(nome="Arco e Flecha", cat="DPS", attr="Destreza", dano="perfurante",
    funcao="DPS de Alcance e Precisão",
    identidade="Dano concentrado à distância — recompensa ficar parado e mirar.",
    skills=[
        dict(nivel=1, nome="Tiro Preciso", lb=False, corpo="Ataque à distância (alcance 150/600 ft) usando Destreza. Causa **1d8 + DES**; se o usuário não se moveu neste turno antes de atirar, causa +1d6 extra."),
        dict(nivel=1, nome="Disparo Rápido", lb=False, corpo="Dois disparos no mesmo alvo ou em alvos diferentes a até 10 ft entre si, cada um causando **1d6 + DES**."),
        dict(nivel=2, nome="Passo do Caçador", lb=False, corpo="Move-se até 10 ft sem provocar Ataque de Oportunidade; o próximo disparo do turno ignora meia cobertura."),
        dict(nivel=5, nome="Chuva de Flechas", lb=True, corpo="1/Descanso Longo. Área de 10 ft de raio a até 150 ft de distância; inimigos na área sofrem **2d6 + DES** de dano perfurante."),
        dict(nivel=6, nome="Flecha Perfurante", lb=False, corpo="Ataque que atravessa o primeiro alvo em linha reta e atinge um segundo a até 30 ft dele, cada um sofrendo **1d8 + DES**."),
        dict(nivel=10, nome="Olho do Caçador", lb=False, corpo="Marca um alvo visível por 1 minuto (sem gastar ataque); enquanto marcado, os disparos do usuário contra ele têm vantagem."),
        dict(nivel=14, nome="Disparo Mortal", lb=False, corpo="Gasta o turno inteiro mirando sem se mover; no início do próximo turno, um disparo automático causa **4d8 + DES**."),
        dict(nivel=18, nome="Arco do Fim", lb=False, corpo="1/Descanso Longo. Por 1 minuto, um disparo por turno ignora resistência a dano perfurante e não pode errar contra um alvo Marcado por Olho do Caçador."),
    ]))

ARMAS.append(dict(nome="Espada Longa", cat="DPS", attr="Força", dano="cortante",
    funcao="DPS de Impacto e Combos",
    identidade="Recompensa sequência de ataques e manutenção de combo.",
    skills=[
        dict(nivel=1, nome="Corte Ascendente", lb=False, corpo="Ataque corpo a corpo usando Força. Causa **1d8 + FOR** e marca o início de um combo: o próximo ataque contra o mesmo alvo ganha +2 no dano."),
        dict(nivel=1, nome="Corte Duplo", lb=False, corpo="Dois ataques em sequência contra o mesmo alvo, cada um causando **1d6 + FOR**. Continua o combo se o Corte Ascendente foi usado antes."),
        dict(nivel=2, nome="Combo Ascendente", lb=False, corpo="Só pode ser usado com combo ativo (2+ acertos seguidos no mesmo alvo). Causa **2d8 + FOR** e mantém o combo em vez de reiniciar."),
        dict(nivel=5, nome="Tempestade de Lâminas", lb=True, corpo="Ação ou Reação, 1/Descanso Longo. Sequência de 4 golpes contra um único alvo, cada um causando **1d10 + FOR**; se todos acertarem, um 5º golpe automático causa dano máximo."),
        dict(nivel=6, nome="Quebra-Guarda", lb=False, corpo="Ataque que ignora bônus de CA de escudo/postura defensiva do alvo neste golpe. Causa **1d10 + FOR**."),
        dict(nivel=10, nome="Lâmina Implacável", lb=False, corpo="Enquanto o combo estiver ativo (2+ acertos seguidos), os ataques da Espada Longa causam +1d6 de dano extra."),
        dict(nivel=14, nome="Corte Devastador", lb=False, corpo="Golpe único de alto impacto: causa **3d8 + FOR**, mas encerra o combo ativo."),
        dict(nivel=18, nome="Lâmina Suprema", lb=False, corpo="1/Descanso Longo. Por 1 minuto, cada acerto consecutivo aumenta o dano do próximo ataque em +1 (sem teto), até o combo ser quebrado por um erro."),
    ]))

ARMAS.append(dict(nome="Rapieira", cat="DPS", attr="Destreza", dano="perfurante",
    funcao="DPS de Precisão e Contra-Ataque",
    identidade="Recompensa leitura do inimigo, criação de aberturas e contra-ataques.",
    skills=[
        dict(nivel=1, nome="Estocada Precisa", lb=False, corpo="Ataque corpo a corpo usando Destreza. Causa **1d8 + DES**; se o usuário não se moveu neste turno antes do ataque, causa +1d6."),
        dict(nivel=1, nome="Finta Rápida", lb=False, corpo="Ataque de baixo dano (**1d4 + DES**) que obriga o alvo a um teste de Sabedoria; falha: o próximo ataque do usuário contra ele tem vantagem."),
        dict(nivel=2, nome="Passo do Duelista", lb=False, corpo="Move-se até a velocidade sem provocar Ataques de Oportunidade e faz um ataque ao final do movimento."),
        dict(nivel=5, nome="Dança do Duelista", lb=True, corpo="1/Descanso Longo. Sequência de 3 estocadas contra até 3 alvos diferentes a até 10 ft entre si, cada uma causando **2d6 + DES**."),
        dict(nivel=6, nome="Ripostar", lb=False, corpo="Reação quando um inimigo erra um ataque corpo a corpo contra o usuário: um ataque de Destreza completo em resposta."),
        dict(nivel=10, nome="Ponto Fraco", lb=False, corpo="Ataque que, em caso de acerto, marca o alvo por 1 minuto — próximos ataques do usuário contra ele causam +1d6."),
        dict(nivel=14, nome="Estocada Perfeita", lb=False, corpo="Contra um alvo enganado por Finta Rápida neste combate, este ataque é automaticamente um acerto crítico."),
        dict(nivel=18, nome="Lâmina do Mestre", lb=False, corpo="1/Descanso Longo. Por 1 minuto, uma vez por turno um ataque que erraria vira automaticamente um acerto (rolagem tratada como natural 10)."),
    ]))

ARMAS.append(dict(nome="Katana", cat="DPS", attr="Sabedoria", dano="cortante",
    funcao="DPS de Postura e Golpe Decisivo",
    identidade="Recompensa preparação, concentração e espera pela abertura correta.",
    skills=[
        dict(nivel=1, nome="Corte Concentrado", lb=False, corpo="Ação de concentração (não ataca neste turno); no início do próximo turno, um ataque automático causa **2d8 + SAB**. Se o usuário for atingido enquanto concentra, o efeito é cancelado."),
        dict(nivel=1, nome="Saque Rápido", lb=False, corpo="Ataque imediato usando Sabedoria, sem preparação. Causa **1d8 + SAB**; só pode ser usado no primeiro turno de um combate ou depois de embainhar a katana (ação)."),
        dict(nivel=2, nome="Postura do Lobo", lb=False, corpo="Postura defensiva-ofensiva por 1 minuto: +1 CA, e o próximo ataque certeiro do usuário causa +1d6."),
        dict(nivel=5, nome="Iaijutsu Supremo", lb=True, corpo="1/Descanso Longo. Funciona como Saque Rápido turbinado: ataque imediato que causa **4d8 + SAB**, crítico automático se o alvo ainda não agiu neste combate."),
        dict(nivel=6, nome="Corte de Retaliação", lb=False, corpo="Reação quando um inimigo erra um ataque contra o usuário em Postura do Lobo: um ataque de Sabedoria completo em resposta."),
        dict(nivel=10, nome="Foco Absoluto", lb=False, corpo="Enquanto parado (sem se mover no turno), os ataques da Katana ganham +2 no teste de ataque."),
        dict(nivel=14, nome="Corte Lunar", lb=False, corpo="Ataque que causa **2d8 + SAB** e ignora resistência a dano cortante do alvo."),
        dict(nivel=18, nome="Lâmina do Vazio", lb=False, corpo="1/Descanso Longo. Por 1 minuto, Corte Concentrado deixa de exigir 1 turno de preparação — pode ser usado como ataque normal, mantendo o dano de 2d8+SAB."),
    ]))

ARMAS.append(dict(nome="Manopla", cat="DPS", attr="Força", dano="contundente",
    funcao="DPS de Pressão e Sequência",
    identidade="Recompensa permanecer próximo e manter uma sequência ofensiva.",
    skills=[
        dict(nivel=1, nome="Soco Demolidor", lb=False, corpo="Ataque corpo a corpo usando Força. Causa **1d8 + FOR**."),
        dict(nivel=1, nome="Rajada de Golpes", lb=False, corpo="Três socos rápidos contra o mesmo alvo, cada um causando **1d4 + FOR**; acertar os três dá +1 de dano nos ataques da Manopla até o fim do turno seguinte."),
        dict(nivel=2, nome="Passo Agressivo", lb=False, corpo="Move-se até 15 ft na direção de um inimigo sem provocar Ataques de Oportunidade e ataca ao chegar."),
        dict(nivel=5, nome="Punhos do Berserker", lb=True, corpo="1/Descanso Longo. Rajada de 5 golpes contra o mesmo alvo, cada um causando **1d8 + FOR**; cada acerto consecutivo adiciona +1 no próximo (1º normal, 2º +1, 3º +2...)."),
        dict(nivel=6, nome="Contra-Golpe", lb=False, corpo="Reação quando um inimigo erra um ataque corpo a corpo contra o usuário: um soco de Força completo em resposta."),
        dict(nivel=10, nome="Fúria Crescente", lb=False, corpo="Cada acerto seguido nesta cena (sem errar) aumenta o dano dos ataques da Manopla em +1, até um máximo de +5; um erro zera o contador."),
        dict(nivel=14, nome="Impacto Brutal", lb=False, corpo="Ataque que causa **2d8 + FOR** e obriga o alvo a um teste de Constituição; falha: fica **Atordoado** até o fim do próximo turno dele."),
        dict(nivel=18, nome="Punho Supremo", lb=False, corpo="1/Descanso Longo. Enquanto Fúria Crescente estiver no máximo (+5), os ataques da Manopla ignoram resistência a dano contundente, por 1 minuto."),
    ]))

# ============================== AoE ==============================
ARMAS.append(dict(nome="Bastão", cat="AoE", attr="Sabedoria", dano="contundente",
    funcao="AoE de Impacto e Controle de Terreno",
    identidade="Golpes largos e batidas de chão — sem cura, sem magia: um bastão pesado usado pra atingir e derrubar vários inimigos de uma vez.",
    skills=[
        dict(nivel=1, nome="Giro Amplo", lb=False, corpo="Ataque corpo a corpo usando Sabedoria, gira o bastão atingindo todos os inimigos adjacentes ao usuário (5 ft). Causa **1d6 + SAB** de dano contundente a cada um."),
        dict(nivel=1, nome="Investida do Bastão", lb=False, corpo="Ataque corpo a corpo. Causa **1d8 + SAB**. O alvo faz teste de Força; falha: empurrado 10 ft."),
        dict(nivel=2, nome="Bastão Rodopiante", lb=False, corpo="Gira o bastão duas vezes, atingindo até 4 inimigos num raio de 10 ft ao redor do usuário. Causa **1d4 + SAB** a cada um."),
        dict(nivel=5, nome="Terremoto do Bastão", lb=True, corpo="1/Descanso Longo. Bate o chão com força total: área de 15 ft de raio ao redor do usuário. Inimigos na área fazem teste de Força; falha: **2d8 + SAB** de dano contundente e **Caído**. Sucesso: metade do dano, sem cair."),
        dict(nivel=6, nome="Guarda Circular", lb=False, corpo="Reação: quando dois ou mais inimigos adjacentes atacam o usuário no mesmo turno, um giro de bastão contra-ataca todos eles, causando **1d6 + SAB** a cada um."),
        dict(nivel=10, nome="Campo de Impacto", lb=False, corpo="Cria uma área de 15 ft de raio por 1 minuto onde o chão treme. Inimigos que entram ou terminam o turno ali sofrem **1d6** de dano contundente e fazem teste de Força ou ficam **Caídos**."),
        dict(nivel=14, nome="Onda de Choque", lb=False, corpo="Ataque em linha de 15 ft de comprimento e 5 ft de largura. Todos na linha sofrem **2d6 + SAB** e são empurrados 10 ft na direção do golpe."),
        dict(nivel=18, nome="Guardião Imóvel", lb=False, corpo="1/Descanso Longo. Por 1 minuto, o usuário e aliados a até 10 ft ganham +2 de CA e resistência a dano de efeitos de área."),
    ]))

ARMAS.append(dict(nome="Chicote", cat="AoE", attr="Inteligência", dano="cortante",
    funcao="AoE de Controle e Posicionamento",
    identidade="Controla distância, puxa e empurra vários inimigos, reposiciona aliados.",
    skills=[
        dict(nivel=1, nome="Golpe Enlaçante", lb=False, corpo="Ataque à distância (alcance 15 ft) usando Inteligência. Causa **1d6 + INT** e puxa o alvo 5 ft na direção do usuário."),
        dict(nivel=1, nome="Laço Protetor", lb=False, corpo="Puxa um aliado a até 15 ft pra até 5 ft do usuário, tirando-o de uma área perigosa sem provocar Ataque de Oportunidade."),
        dict(nivel=2, nome="Puxão Violento", lb=False, corpo="Ataque que causa **1d8 + INT** e obriga o alvo a um teste de Força; falha: é puxado 15 ft e fica **Caído**."),
        dict(nivel=5, nome="Dança do Carrasco", lb=True, corpo="1/Descanso Longo. Prende até 2 inimigos a até 20 ft do usuário e os puxa 10 ft cada, causando **2d6 + INT** a cada um."),
        dict(nivel=6, nome="Chicote de Retaliação", lb=False, corpo="Reação quando um inimigo a até 15 ft se move: um ataque de Inteligência automático contra ele, causando **1d6 + INT**."),
        dict(nivel=10, nome="Corrente de Comando", lb=False, corpo="Reação: um aliado a até 15 ft pode se reposicionar 10 ft guiado pelo chicote, sem provocar Ataque de Oportunidade."),
        dict(nivel=14, nome="Domínio do Chicote", lb=False, corpo="O alcance de todas as Sword Skills do Chicote aumenta em 10 ft."),
        dict(nivel=18, nome="Prisão Absoluta", lb=False, corpo="1/Descanso Longo. Por 1 minuto, um inimigo puxado pelo Chicote fica **Restringido** até se soltar (teste de Força/Acrobacia), em vez de só ser puxado."),
    ]))

ARMAS.append(dict(nome="Chakram", cat="AoE", attr="Destreza", dano="cortante",
    funcao="AoE de Ricochete e Posicionamento",
    identidade="Ricochete, área e movimento forçado — atinge vários alvos com um só arremesso.",
    skills=[
        dict(nivel=1, nome="Lâmina Ricochete", lb=False, corpo="Ataque corpo a corpo ou à distância (alcance 20/60 ft) usando Destreza. Causa **1d6 + DES**. Se atingir, o chakram ricocheteia pra um segundo alvo a até 15 ft do primeiro, causando metade do dano."),
        dict(nivel=1, nome="Arco Cortante", lb=False, corpo="Ataque em arco de 90° a partir do usuário (alcance 10 ft), atingindo todos os inimigos na área. Causa **1d6 + DES** a cada um."),
        dict(nivel=2, nome="Chakram Enlaçante", lb=False, corpo="Ataque que causa **1d6 + DES** e obriga o alvo a um teste de Força; falha: fica **Restringido** por uma corrente fina presa ao chakram até se soltar (ação, teste de Força/Acrobacia)."),
        dict(nivel=5, nome="Dança do Chakram", lb=True, corpo="1/Descanso Longo. O usuário lança até 3 chakrams que ricocheteiam entre até 5 inimigos diferentes num raio de 30 ft, cada um causando **2d6 + DES**. Nenhum alvo é atingido mais de duas vezes."),
        dict(nivel=6, nome="Retorno Mortal", lb=False, corpo="Reação quando um inimigo se move pra dentro do alcance do chakram já lançado nesse turno: um ataque extra automático contra ele, causando **1d6 + DES**, sem gastar a ação."),
        dict(nivel=10, nome="Círculo de Lâminas", lb=False, corpo="Cria uma área de 15 ft de raio onde chakrams giram no ar por 1 minuto; qualquer inimigo que entre ou termine o turno ali sofre **1d6** de dano cortante."),
        dict(nivel=14, nome="Ricochete Devastador", lb=False, corpo="O ricochete da Lâmina Ricochete deixa de perder dano — o segundo alvo (e um terceiro, se houver) recebe o dano cheio, não metade."),
        dict(nivel=18, nome="Tempestade dos Chakrams", lb=False, corpo="1/Descanso Longo. Por 1 rodada, todo ataque com chakram ricocheteia automaticamente pra um alvo adicional, sem limite de vezes por turno."),
    ]))

ARMAS.append(dict(nome="Foice", cat="AoE", attr="Sabedoria", dano="cortante",
    funcao="AoE de Debuff, Derrubar e Execução",
    identidade="Enfraquece inimigos em área, derruba alvos e ganha eficiência contra feridos.",
    skills=[
        dict(nivel=1, nome="Corte Ceifador", lb=False, corpo="Ataque corpo a corpo em arco (alcance 10 ft, área de 90°) usando Sabedoria. Causa **1d8 + SAB** a cada inimigo na área."),
        dict(nivel=1, nome="Gancho da Morte", lb=False, corpo="Ataque que causa **1d6 + SAB**, puxa o alvo 15 ft na direção do usuário e reduz o deslocamento dele pela metade até o fim do turno seguinte."),
        dict(nivel=2, nome="Ceifa das Pernas", lb=False, corpo="Ataque baixo contra as pernas do alvo, causa **1d6 + SAB**: teste de Destreza; falha: fica **Caído**."),
        dict(nivel=5, nome="Colheita da Morte", lb=True, corpo="1/Descanso Longo. Corte amplo (alcance 15 ft, 120°) que causa **3d8 + SAB** e reduz a cura recebida pelos alvos atingidos pela metade até o fim da cena."),
        dict(nivel=6, nome="Ceifador Reverso", lb=False, corpo="Ataque de retorno logo após um golpe: se o Corte Ceifador ou a Ceifa das Pernas acertou, encadeia este ataque como parte da mesma ação, causando metade do dano a um alvo adicional na área."),
        dict(nivel=10, nome="Marca do Ceifador", lb=False, corpo="Marca um alvo por 1 minuto; enquanto marcado, ataques com a Foice contra ele ganham vantagem e causam +1d6."),
        dict(nivel=14, nome="Grande Ceifa", lb=False, corpo="Como Corte Ceifador, mas o alcance dobra (20 ft, 90°) e alvos já **Caídos** sofrem dano máximo em vez de rolado."),
        dict(nivel=18, nome="Última Colheita", lb=False, corpo="Contra um inimigo com menos de um terço do PV máximo, este ataque causa dano dobrado e, se reduzir o alvo a 0 PV, o usuário recupera PV igual ao dado de dano da arma."),
    ]))

ARMAS.append(dict(nome="Machado", cat="AoE", attr="Força", dano="cortante",
    funcao="AoE Pesado de Derrubar e Quebra de Postura",
    identidade="O AoE mais pesado: sacrifica mobilidade pra interromper, derrubar e quebrar a postura de vários inimigos.",
    skills=[
        dict(nivel=1, nome="Golpe Quebra-Guarda", lb=False, corpo="Ataque corpo a corpo usando Força. Causa **1d10 + FOR**. Se o alvo estiver usando escudo ou postura defensiva, esse bônus é anulado até o fim do turno seguinte."),
        dict(nivel=1, nome="Machado Derrubador", lb=False, corpo="Ataque pesado, causa **1d8 + FOR**; teste de Força do alvo; falha: fica **Caído**."),
        dict(nivel=2, nome="Corte de Impacto", lb=False, corpo="Ataque que causa **1d10 + FOR** e empurra o alvo 10 ft na direção do golpe (teste de Força pra resistir)."),
        dict(nivel=5, nome="Devastação do Machado", lb=True, corpo="1/Descanso Longo. Golpe massivo (alcance 10 ft, área de 5 ft à frente) que causa **3d10 + FOR** e deixa todos os alvos atingidos **Caídos**, sem direito a teste de resistência."),
        dict(nivel=6, nome="Contra-Golpe Brutal", lb=False, corpo="Reação quando um inimigo erra um ataque corpo a corpo contra o usuário: um ataque de Força completo em resposta."),
        dict(nivel=10, nome="Quebra-Postura", lb=False, corpo="Ataque que causa **2d10 + FOR** e reduz a CA do alvo em 2 até o fim da cena (não acumula com usos repetidos)."),
        dict(nivel=14, nome="Grande Cleave", lb=False, corpo="Ataque que atinge todos os inimigos num arco de 10 ft à frente, cada um sofrendo dano completo (não reduzido) de **2d8 + FOR**."),
        dict(nivel=18, nome="Execução do Colosso", lb=False, corpo="Contra um inimigo **Caído**, este ataque causa dano máximo automaticamente, sem rolar o dado."),
    ]))

ARMAS.append(dict(nome="Corrente com Peso", cat="AoE", attr="Destreza", dano="contundente",
    funcao="AoE de Alcance e Controle de Posição",
    identidade="Alcance, arrastar, prender e negar espaço — a única arma cuja função inteira é ditar onde o inimigo (não) pode estar.",
    skills=[
        dict(nivel=1, nome="Lançar Corrente", lb=False, corpo="Ataque à distância (alcance 15/30 ft) usando Destreza. Causa **1d6 + DES**. Em vez de recuar após o golpe, o usuário pode puxar o alvo 5 ft na sua direção."),
        dict(nivel=1, nome="Amarra de Ferro", lb=False, corpo="Ataque que causa **1d6 + DES** e força o alvo a um teste de resistência de Força; falha: fica **Restringido** até usar a ação para se soltar (teste de Força/Acrobacia)."),
        dict(nivel=2, nome="Puxão Brutal", lb=False, corpo="Reação quando um inimigo a até 15 ft tenta se afastar do usuário. Puxa o alvo de volta 10 ft e reduz o deslocamento dele pela metade até o fim do turno seguinte."),
        dict(nivel=5, nome="Grilhões de Aincrad", lb=True, corpo="Ação ou Reação, 1/Descanso Longo, alcance 30 ft. Prende um alvo com correntes que se materializam do chão: o alvo fica **Restringido** sem direito a teste de resistência inicial e sofre desvantagem no primeiro teste para se soltar. Enquanto restringido dessa forma, aliados do usuário têm vantagem em ataques corpo a corpo contra o alvo."),
        dict(nivel=6, nome="Corrente Serpenteante", lb=False, corpo="A corrente atinge e enreda dois alvos diferentes no mesmo ataque (golpe principal + golpe secundário de dano reduzido), cada um com seu próprio teste de resistência."),
        dict(nivel=10, nome="Prisão de Elos", lb=False, corpo="Cria uma área de 10 ft de raio onde a corrente serpenteia pelo chão; inimigos que entram ou terminam o turno ali fazem teste de Destreza ou ficam com o deslocamento reduzido a 5 ft até saírem da área."),
        dict(nivel=14, nome="Corrente Sangrenta", lb=False, corpo="Golpe pesado contra um alvo já Restringido pelo usuário: causa **2d8 + DES** e o alvo sofre uma condição extra (Caído ou Amedrontado, à escolha do usuário)."),
        dict(nivel=18, nome="Senhor das Correntes", lb=False, corpo="1/Descanso Longo. Por 1 minuto, o usuário mantém até três alvos Restringidos simultaneamente sem gastar ação extra por alvo, e pode arrastar qualquer um deles 5 ft por vez como parte de outra ação."),
    ]))

# ============================== SCOUTS ==============================
ARMAS.append(dict(nome="Adagas", cat="Scouts", attr="Destreza", dano="perfurante",
    funcao="Scout de Mobilidade e Infiltração",
    identidade="Entra, ataca e reposiciona antes que o inimigo perceba de onde veio o golpe.",
    skills=[
        dict(nivel=1, nome="Corte Veloz", lb=False, corpo="Ataque corpo a corpo usando Destreza. Causa **1d4 + DES** e permite mover-se 5 ft depois do golpe sem provocar Ataque de Oportunidade."),
        dict(nivel=1, nome="Dupla Estocada", lb=False, corpo="Dois ataques, cada um causando **1d4 + DES**; acertar os dois permite mover-se 5 ft extra imediatamente."),
        dict(nivel=2, nome="Passo da Sombra", lb=False, corpo="Ação bônus: move-se até a velocidade sem provocar Ataque de Oportunidade; o próximo ataque do usuário neste turno tem vantagem."),
        dict(nivel=5, nome="Dança das Lâminas", lb=True, corpo="1/Descanso Longo. Ataca até 3 inimigos diferentes a até 5 ft entre si, cada um sofrendo **1d8 + DES**."),
        dict(nivel=6, nome="Corte de Oportunidade", lb=False, corpo="Reação quando um inimigo sai do alcance corpo a corpo do usuário: um ataque extra, causando **1d6 + DES**."),
        dict(nivel=10, nome="Dança do Assassino", lb=False, corpo="Deslocamento +10 ft. Cada ataque bem-sucedido nesta cena concede +5 ft extra de deslocamento até o fim do turno."),
        dict(nivel=14, nome="Mil Cortes", lb=False, corpo="Três ataques contra o mesmo alvo, cada um causando **1d4 + DES**."),
        dict(nivel=18, nome="Passo Fantasma", lb=False, corpo="1/Descanso Longo. Por 1 minuto, Ataques de Oportunidade contra o usuário têm desvantagem."),
    ]))

ARMAS.append(dict(nome="Besta", cat="Scouts", attr="Destreza", dano="perfurante",
    funcao="Scout de Alcance e Marcação",
    identidade="Marca alvos, cobre aliados e mantém pressão à distância sem entrar em risco.",
    skills=[
        dict(nivel=1, nome="Disparo Preciso", lb=False, corpo="Ataque à distância (alcance 80/320 ft) usando Destreza. Causa **1d8 + DES**."),
        dict(nivel=1, nome="Marcar Alvo", lb=False, corpo="Ataque de dano reduzido (**1d4 + DES**) que marca o alvo por 1 minuto: aliados têm vantagem em ataques contra ele."),
        dict(nivel=2, nome="Disparo de Cobertura", lb=False, corpo="Reação: quando um aliado a até 30 ft é atacado, dispara contra o atacante, causando **1d6 + DES** e concedendo meia cobertura ao aliado contra esse ataque."),
        dict(nivel=5, nome="Chuva de Virolas", lb=True, corpo="1/Descanso Longo. Dispara contra todos os inimigos num raio de 20 ft (alcance 80 ft), cada um sofrendo **2d6 + DES**."),
        dict(nivel=6, nome="Tiro de Intervenção", lb=False, corpo="Reação: quando um inimigo marcado tenta fugir ou se aproximar de um aliado, um disparo automático o intercepta, causando **1d8 + DES**."),
        dict(nivel=10, nome="Marca do Caçador", lb=False, corpo="Contra um alvo marcado, os ataques da Besta causam +1d6 de dano extra."),
        dict(nivel=14, nome="Virola Perfurante", lb=False, corpo="Ataque que atravessa o primeiro alvo e atinge um segundo em linha, cada um sofrendo **1d8 + DES**."),
        dict(nivel=18, nome="Execução Perfeita", lb=False, corpo="1/Descanso Longo. Por 1 minuto, contra um alvo marcado com menos da metade do PV máximo, os disparos do usuário são automaticamente acerto crítico."),
    ]))

ARMAS.append(dict(nome="Leque", cat="Scouts", attr="Sabedoria", dano="cortante",
    funcao="Scout de Ritmo e Mobilidade",
    identidade="Movimentação constante, posicionamento e ataques fluidos — difícil de fixar. "
                "Passiva (Fluxo Cortante): sempre que o usuário tiver se movido pelo menos 10 ft "
                "no turno antes de um ataque do Leque, esse ataque causa +1d4 de dano extra "
                "(revisão de balanceamento).",
    skills=[
        dict(nivel=1, nome="Corte de Seda", lb=False, corpo="Ataque corpo a corpo usando Sabedoria. Causa **1d6 + SAB** e permite mover-se 5 ft (antes ou depois) sem provocar Ataque de Oportunidade."),
        dict(nivel=1, nome="Dança do Leque", lb=False, corpo="Ataque que combina movimento de até 10 ft com um golpe ao longo do trajeto, causando **1d6 + SAB** a um inimigo em qualquer ponto do caminho."),
        dict(nivel=2, nome="Rajada Cortante", lb=False, corpo="Ataque em leque contra até 2 inimigos adjacentes entre si, cada um sofrendo **1d8 + SAB**."),
        dict(nivel=5, nome="Mil Lâminas de Vento", lb=True, corpo="1/Descanso Longo. O usuário se move até a velocidade em linha reta atacando todos os inimigos no caminho, cada um sofrendo **2d6 + SAB**."),
        dict(nivel=6, nome="Vento Reverso", lb=False, corpo="Reação: quando um inimigo se move pra perto do usuário, reposiciona-se 10 ft mantendo distância e ataca de relance, causando metade do dano normal."),
        dict(nivel=10, nome="Dança das Correntes", lb=False, corpo="Cada movimento de pelo menos 10 ft antes de um ataque do Leque nesta cena concede +1 no teste de ataque (acumula até +3). No estágio máximo (+3), os ataques do Leque também causam +1d4 de dano extra, além do bônus de Fluxo Cortante."),
        dict(nivel=14, nome="Lâmina Tempestuosa", lb=False, corpo="A Rajada Cortante passa a atingir até 4 inimigos em vez de 2."),
        dict(nivel=18, nome="Festival das Cem Lâminas", lb=False, corpo="1/Descanso Longo. Por 1 minuto, o usuário pode se mover entre cada ataque de uma ação com múltiplos ataques, sem gastar deslocamento extra, e o primeiro ataque de cada ação nesse período causa dano dobrado."),
    ]))

ARMAS.append(dict(nome="Adagas de Arremesso", cat="Scouts", attr="Destreza", dano="perfurante",
    funcao="Scout de Controle à Distância e Marcação",
    identidade="Marca inimigos, reduz deslocamento, cria zonas perigosas e mantém o usuário sempre móvel.",
    skills=[
        dict(nivel=1, nome="Lâmina Marcadora", lb=False, corpo="Ataque à distância (alcance 30/90 ft) usando Destreza. Causa **1d4 + DES** e marca o alvo por 1 minuto — os próximos ataques do usuário contra o alvo marcado têm vantagem."),
        dict(nivel=1, nome="Rajada de Adagas", lb=False, corpo="Três adagas lançadas contra um único alvo ou até três alvos diferentes num raio de 10 ft, cada uma causando **1d4 + DES**."),
        dict(nivel=2, nome="Adaga Imobilizante", lb=False, corpo="Ataque que causa **1d4 + DES** e obriga o alvo a um teste de Destreza; falha: o deslocamento dele fica reduzido a 5 ft até o fim do turno seguinte."),
        dict(nivel=5, nome="Dança das Mil Lâminas", lb=True, corpo="1/Descanso Longo. Saraivada que atinge todos os inimigos num cone de 30 ft, cada um sofrendo **2d6 + DES** e um teste de Destreza; falha: **Restringido** por 1 rodada."),
        dict(nivel=6, nome="Adaga de Retorno", lb=False, corpo="Reação: quando um inimigo marcado se move, uma adaga extra o persegue automaticamente, causando **1d4 + DES**."),
        dict(nivel=10, nome="Campo de Lâminas", lb=False, corpo="Cria uma área de 15 ft de raio coberta de adagas fincadas por 1 minuto; inimigos que entram ou terminam o turno ali sofrem **1d6** de dano perfurante."),
        dict(nivel=14, nome="Chuva Perfurante", lb=False, corpo="A Rajada de Adagas passa de 3 pra 5 adagas, e cada uma que erra o primeiro alvo ricocheteia pra um segundo."),
        dict(nivel=18, nome="Arsenal Fantasma", lb=False, corpo="1/Descanso Longo. Por 1 minuto, o usuário pode se teleportar até 30 ft pra qualquer ponto onde tenha uma adaga fincada (de Campo de Lâminas ou Adaga Imobilizante) como parte de um ataque, sem gastar deslocamento."),
    ]))

