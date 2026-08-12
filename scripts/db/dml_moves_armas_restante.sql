-- DML: continuação de dml_moves_armas_pdf_pbta.sql — mesmo formato PBTA,
-- agora pras 10 armas que o PDF do usuário não cobria. Fonte de Marca +
-- atributo + Move de Combate original: docs/guia_sistema_aincrad.md.
-- Move 1 = reformatação fiel do Move de Combate canônico pro molde
-- 10+/7-9/6-; Move 2 = segundo ângulo de combate novo (mesmo atributo,
-- padrão do PDF); Limit Break = golpe de assinatura novo, +2 no acerto.
-- Mesmo mapeamento de schema do arquivo anterior: move_a/golpe_2/
-- limit_breaker preenchidos, move_b/golpe_3 zerados.

-- ============================================================
-- Arco e Flecha
-- ============================================================
UPDATE moves_arma SET
  atributo = 'REF',
  marca = 'Arma de distância, precisão e leitura de terreno; a cena te coloca naturalmente em pontos de visão, cobertura e vigilância.',
  move_a = '{"nome": "Linha de Tiro", "atributo": "Reflexo", "gatilho": "Quando você mantiver distância e disparar contra um alvo antes que ele consiga te alcançar, role +Reflexo.", "dez_mais": ["Você causa dano no alvo.", "Você interrompe a ação que o alvo estava prestes a realizar.", "Você impede que o alvo feche distância nesta troca.", "Você dispara sem revelar sua posição.", "Você deixa o alvo Sob Pressão."], "sete_nove": ["Você causa dano no alvo.", "Você atrasa a ação do alvo por um instante.", "Você mantém alguma distância do alvo.", "Você cria uma abertura para um aliado agir.", "Você força o alvo a buscar cobertura."], "seis_menos": ["Sua posição é revelada.", "A flecha se perde ou fica presa longe.", "O alvo fecha distância rapidamente.", "Um terceiro percebe o disparo e reage.", "Você fica Sob Pressão ao ser encontrado."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Chuva Dirigida", "atributo": "Reflexo", "gatilho": "Quando você disparar uma sequência rápida de flechas contra um grupo ou área para negar avanço, role +Reflexo.", "dez_mais": ["Você causa dano em até dois alvos próximos.", "Você afasta os inimigos ao redor.", "Você impede o avanço de quem está na área.", "Você deixa um alvo Ferido.", "Você mantém munição suficiente para o próximo disparo."], "sete_nove": ["Você causa dano em um alvo.", "Você afasta um inimigo próximo.", "Você atrasa o avanço da linha inimiga.", "Você cria espaço para recuar ou se reposicionar.", "Você protege um aliado com a cobertura de flechas."], "seis_menos": ["Você fica sem flechas no pior momento.", "Um inimigo atravessa a chuva de flechas.", "Seu disparo acerta algo ou alguém errado.", "Você se expõe ao manter o ritmo de disparos.", "Você fica Exausto pelo esforço."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Tiro do Horizonte", "atributo": "Reflexo", "gatilho": "Quando você mirar com calma absoluta e disparar um único tiro decisivo através de qualquer obstáculo no caminho, role +Reflexo +2.", "dez_mais": ["Você causa dano ignorando cobertura simples ou guarda parcial.", "Você atinge o alvo antes que qualquer reação seja possível.", "Você acerta um ponto vulnerável e deixa o alvo Ferido.", "Você revela a posição real de um inimigo oculto.", "Você mantém sua posição em segredo mesmo após o disparo."], "sete_nove": ["Você causa dano no alvo.", "Você força o alvo a sair da cobertura.", "Você atinge o alvo, mas revela sua posição.", "Você descobre uma fraqueza do inimigo.", "Você cria uma abertura clara para um aliado."], "seis_menos": ["O tiro erra o ponto exato que você mirava.", "Sua posição é entregue no pior momento.", "A flecha se perde ou atinge outra coisa.", "O inimigo antecipa sua mira.", "Você fica Sob Pressão ou exposto após o disparo."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Arco e Flecha';

-- ============================================================
-- Adagas
-- ============================================================
UPDATE moves_arma SET
  atributo = 'TEC',
  marca = 'Arma de proximidade, precisão curta e perigo imediato; elas mudam a cena quando tudo fica perto demais.',
  move_a = '{"nome": "Dentro da Guarda", "atributo": "Técnica", "gatilho": "Quando você entrar colado no inimigo, negando espaço para qualquer reação, role +Técnica.", "dez_mais": ["Você causa dano no alvo.", "Você nega a próxima reação do alvo.", "Você desarma um item pequeno do inimigo.", "Você muda de posição, ficando fora do alcance imediato.", "Você evita a retaliação imediata."], "sete_nove": ["Você causa dano no alvo.", "Você nega parte da reação do alvo.", "Você fica preso na troca, mas causa dano mesmo assim.", "Você se expõe a um segundo inimigo.", "Você deixa uma marca evidente no alvo."], "seis_menos": ["Você entra na guarda errada e leva o troco.", "O inimigo prevê sua aproximação.", "Sua adaga escorrega ou erra o ângulo.", "Você fica preso perto demais do inimigo.", "Um segundo inimigo aproveita sua abertura."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Corte de Sombra", "atributo": "Técnica", "gatilho": "Quando você explorar uma abertura já criada para cravar as adagas num ponto exato, role +Técnica.", "dez_mais": ["Você causa dano aumentado.", "Você acerta um ponto vulnerável e deixa o alvo Ferido.", "Você evita qualquer retaliação imediata.", "Você corta ou rouba algo preso ao alvo.", "Você se reposiciona sem perder o controle da troca."], "sete_nove": ["Você causa dano no alvo.", "Você força o alvo a recuar.", "Você mantém a iniciativa da troca.", "Você cria uma abertura para um aliado agir.", "Você consegue se afastar após o golpe."], "seis_menos": ["Sua lâmina desliza sem penetrar.", "O inimigo fecha a abertura antes de você.", "Você se expõe ao insistir no corte.", "Um dos golpes te deixa exposto no lugar errado.", "O inimigo lê seu padrão e se prepara."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Execução Silenciosa", "atributo": "Técnica", "gatilho": "Quando você concentrar toda sua velocidade numa sequência final de cortes rápidos e certeiros contra um alvo já comprometido, role +Técnica +2.", "dez_mais": ["Você causa dano aumentado.", "Você deixa o alvo Ferido.", "Você impede qualquer reação do alvo durante a sequência.", "Você encerra os cortes sem se expor.", "Você descobre um segundo ponto vulnerável para explorar depois."], "sete_nove": ["Você causa dano no alvo.", "Você força o alvo a defender em vez de atacar.", "Você mantém a iniciativa da luta.", "Você deixa o alvo hesitante por um instante.", "Você recua para uma posição mais segura."], "seis_menos": ["Sua sequência perde o ritmo no meio do golpe.", "O inimigo resiste e contra-ataca.", "Você se expõe demais ao insistir.", "Uma das lâminas escapa da sua mão.", "Você fica Exausto ao final da sequência."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Adagas';

-- ============================================================
-- Adagas de Arremesso
-- ============================================================
UPDATE moves_arma SET
  atributo = 'REF',
  marca = 'Arma de prontidão, alcance curto e ameaça espalhada; a cena tende a abrir espaço para marcação, aviso e pressão rápida.',
  move_a = '{"nome": "Primeira Chuva", "atributo": "Reflexo", "gatilho": "Quando você abrir a troca contra um grupo antes que ele se organize, arremessando suas lâminas, role +Reflexo.", "dez_mais": ["Você causa dano em até dois alvos próximos.", "Você impede que qualquer um do grupo feche distância sem pagar por isso.", "Você força a dispersão do grupo inimigo.", "Você deixa um alvo Sob Pressão.", "Você recupera parte das lâminas na hora."], "sete_nove": ["Você causa dano em um alvo.", "Você atrasa o avanço do grupo.", "Você força um inimigo a recuar.", "Você cria uma abertura para um aliado agir.", "Você mantém a iniciativa por um instante."], "seis_menos": ["Suas lâminas ficam no chão, presas ou longe demais.", "O grupo se organiza mais rápido do que você esperava.", "Você fica sem nada em mãos no pior momento.", "Um inimigo avança direto sobre você.", "Você se expõe ao gastar todas as lâminas de uma vez."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Marcação Cruzada", "atributo": "Reflexo", "gatilho": "Quando você arremessar lâminas para marcar, prender roupa ou travar a movimentação de um alvo específico, role +Reflexo.", "dez_mais": ["Você causa dano no alvo.", "Você prende o alvo por uma troca (roupa, arma ou membro).", "Você reduz drasticamente a mobilidade do alvo.", "Você deixa o alvo marcado — o próximo golpe de um aliado contra ele não sofre reação.", "Você evita a retaliação imediata."], "sete_nove": ["Você causa dano no alvo.", "Você reduz a mobilidade do alvo por um instante.", "Você atrapalha a próxima ação do alvo.", "Você força o alvo a se expor tentando se soltar.", "Você cria uma abertura curta para um aliado."], "seis_menos": ["A lâmina erra o ponto de prender.", "O alvo se solta antes do esperado.", "Você fica sem lâminas de sobra.", "O alvo usa sua prisão contra você.", "Você se expõe ao tentar acertar o ponto certo."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Tempestade de Lâminas", "atributo": "Reflexo", "gatilho": "Quando você arremessar todas as lâminas que tem numa saraivada final contra tudo que estiver ao seu alcance, role +Reflexo +2.", "dez_mais": ["Você causa dano em até dois alvos próximos.", "Você deixa um alvo Ferido.", "Você impede qualquer aproximação durante a saraivada.", "Você mantém uma lâmina de reserva para o próximo golpe.", "Você encerra a manobra em posição vantajosa."], "sete_nove": ["Você causa dano aumentado em um alvo.", "Você atinge um segundo alvo com dano normal.", "Você força os inimigos ao redor a recuar.", "Você deixa o alvo Abalado.", "Você fica sem lâminas até recuperá-las."], "seis_menos": ["Você fica completamente desarmado no pior momento.", "A saraivada acerta algo ou alguém errado.", "Um inimigo atravessa a chuva de lâminas.", "Você se expõe ao gastar tudo de uma vez.", "Você fica Exausto pelo esforço."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Adagas de Arremesso';

-- ============================================================
-- Besta
-- ============================================================
UPDATE moves_arma SET
  atributo = 'REF',
  marca = 'Arma de impacto, interrupção e decisão à distância; quando ela entra em cena, alguém sente que uma ação vai ser parada.',
  move_a = '{"nome": "Tiro de Interrupção", "atributo": "Reflexo", "gatilho": "Quando alguém tentar fugir, ativar algo ou completar uma ação perigosa e você disparar para impedir, role +Reflexo.", "dez_mais": ["Você interrompe a ação do alvo.", "Você causa dano no alvo.", "Você derruba o alvo.", "Você desarma o alvo.", "Você força um recuo imediato."], "sete_nove": ["Você interrompe a ação do alvo.", "Você causa dano no alvo.", "O barulho ou o tempo de recarga chama atenção extra para a cena.", "Você cria uma abertura para um aliado agir.", "Você mantém o alvo sob mira."], "seis_menos": ["O virote erra o alvo por pouco.", "Você não consegue recarregar a tempo.", "O alvo completa a ação antes do disparo.", "Sua posição fica exposta.", "Um segundo inimigo aproveita a distração."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Golpe de Rearme", "atributo": "Reflexo", "gatilho": "Quando você disparar à queima-roupa ou usar a besta como arma de impacto num inimigo já perto, role +Reflexo.", "dez_mais": ["Você causa dano aumentado.", "Você derruba o alvo.", "Você empurra o alvo para longe.", "Você deixa o alvo Abalado.", "Você recarrega a tempo do próximo disparo."], "sete_nove": ["Você causa dano no alvo.", "Você empurra o alvo alguns passos.", "Você atrapalha a próxima ação do alvo.", "Você mantém distância mínima segura.", "Você chama a atenção do alvo para você."], "seis_menos": ["Seu disparo sai fraco demais.", "A besta emperra no pior momento.", "O alvo resiste ao impacto e avança.", "Você fica sem munição.", "Você se expõe ao ficar perto demais."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Rajada Final", "atributo": "Reflexo", "gatilho": "Quando você disparar uma sequência rápida de virotes contra um único alvo para encerrar a troca de vez, role +Reflexo +2.", "dez_mais": ["Você causa dano aumentado.", "Você acerta um ponto crítico e deixa o alvo Ferido.", "Você interrompe qualquer ação do alvo durante a sequência.", "Você derruba o alvo.", "Você mantém munição para o próximo disparo."], "sete_nove": ["Você causa dano no alvo.", "Você atrapalha a próxima ação do alvo.", "Você força o alvo a recuar.", "Você mantém a iniciativa da troca.", "Você deixa o alvo hesitante."], "seis_menos": ["A besta emperra no meio da sequência.", "Você fica sem virotes no pior momento.", "O alvo resiste e avança sobre você.", "Seu disparo acerta algo errado.", "Você fica Exausto ao final da rajada."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Besta';

-- ============================================================
-- Chicote
-- ============================================================
UPDATE moves_arma SET
  atributo = 'CON',
  marca = 'Arma de alcance, controle e limite; ela transforma espaço aberto em território disputado.',
  move_a = '{"nome": "Domínio de Alcance", "atributo": "Conhecimento", "gatilho": "Quando você usar o alcance do chicote para puxar, prender ou derrubar um alvo sem se aproximar, role +Conhecimento.", "dez_mais": ["Você puxa o alvo para um ponto ruim.", "Você derruba o alvo.", "Você prende o alvo por uma troca — ele não reage até se soltar.", "Você causa dano no alvo.", "Você mantém distância segura durante toda a manobra."], "sete_nove": ["Você causa dano no alvo.", "Você reduz a mobilidade do alvo.", "Você atrapalha a próxima ação do alvo.", "Você cria uma abertura para um aliado.", "Você mantém alguma distância do alvo."], "seis_menos": ["O chicote enrosca em algo do cenário.", "O alvo puxa você junto.", "Você perde o controle da distância.", "Sua arma vira uma complicação imediata.", "Você fica Sob Pressão ao errar a manobra."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Corte de Limite", "atributo": "Conhecimento", "gatilho": "Quando você estalar o chicote com precisão para acertar um ponto exato à distância, role +Conhecimento.", "dez_mais": ["Você causa dano aumentado.", "Você acerta um ponto vulnerável e deixa o alvo Ferido.", "Você desarma o alvo à distância.", "Você evita a retaliação imediata.", "Você mantém o alvo dentro do seu alcance."], "sete_nove": ["Você causa dano no alvo.", "Você força o alvo a recuar.", "Você atrapalha a próxima ação do alvo.", "Você mantém a iniciativa da troca.", "Você cria espaço entre você e o alvo."], "seis_menos": ["O estalo erra o ponto exato.", "O chicote se enrola em você mesmo.", "O alvo entra na sua distância mínima.", "Você perde o timing do golpe.", "Você fica Sob Pressão após a tentativa."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Território Disputado", "atributo": "Conhecimento", "gatilho": "Quando você tomar toda a área ao seu redor com o chicote, prendendo, puxando e derrubando tudo que estiver ao alcance, role +Conhecimento +2.", "dez_mais": ["Você causa dano em até dois alvos próximos.", "Você prende um alvo por toda a cena, não só uma troca.", "Você derruba ou desequilibra um alvo atingido.", "Você mantém todos os outros inimigos fora do seu alcance.", "Você termina a manobra em posição vantajosa."], "sete_nove": ["Você causa dano em um alvo.", "Você prende um alvo por uma troca.", "Você afasta um inimigo próximo.", "Você cria espaço para recuar ou avançar.", "Você protege um aliado ao seu lado."], "seis_menos": ["O chicote se enrosca em você mesmo.", "Um inimigo atravessa sua área de controle.", "Você perde o controle total da manobra.", "Seu golpe acerta algo inconveniente no cenário.", "Você fica Exausto ou Sob Pressão com o esforço."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Chicote';

-- ============================================================
-- Pá
-- ============================================================
UPDATE moves_arma SET
  atributo = 'CON',
  marca = 'Arma de improviso, terreno e preparação; ela faz a cena olhar para o chão, para o abrigo e para o que pode ser montado ali.',
  move_a = '{"nome": "Terreno é Arma", "atributo": "Conhecimento", "gatilho": "Quando você usar chão, areia, água rasa ou entulho com sua Pá para criar vantagem tática, role +Conhecimento.", "dez_mais": ["Você causa dano no alvo.", "Você cria cobertura útil para você ou um aliado.", "Você cega ou derruba o alvo por um instante.", "Você força um recuo.", "Você não deixa rastro da manobra."], "sete_nove": ["Você causa dano no alvo.", "Você cria a vantagem, mas perde posição.", "Você atrapalha a próxima ação do alvo.", "Você cria uma abertura para um aliado agir.", "Você deixa um rastro óbvio da manobra."], "seis_menos": ["O terreno não coopera como esperado.", "Você mesmo fica em desvantagem com a manobra.", "O alvo antecipa seu truque.", "Sua Pá prende ou emperra no chão.", "Você fica exposto ao tentar a manobra."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Golpe de Pá", "atributo": "Conhecimento", "gatilho": "Quando você golpear com o peso e a borda da Pá para causar impacto direto, role +Conhecimento.", "dez_mais": ["Você causa dano aumentado.", "Você derruba o alvo.", "Você empurra o alvo para longe.", "Você deixa o alvo Abalado.", "Você mantém a iniciativa após o golpe."], "sete_nove": ["Você causa dano no alvo.", "Você empurra o alvo alguns passos.", "Você atrapalha a próxima ação do alvo.", "Você força o alvo a recuar.", "Você chama a atenção do alvo para você."], "seis_menos": ["Seu golpe sai lento demais.", "O alvo evita o impacto.", "A Pá prende no chão ou em algo do cenário.", "Você fica exposto após o ataque.", "O esforço te deixa Sob Pressão."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Terra Revolta", "atributo": "Conhecimento", "gatilho": "Quando você revirar completamente o terreno ao seu redor, transformando o chão inteiro numa armadilha, role +Conhecimento +2.", "dez_mais": ["Você causa dano em até dois alvos próximos.", "Você derruba ou prende todos os alvos atingidos.", "Você cria cobertura ampla para todo o grupo.", "Você cega ou desorienta os inimigos ao redor.", "Você não fica exposto durante a manobra."], "sete_nove": ["Você causa dano em um alvo.", "Você derruba um alvo.", "Você cria alguma cobertura.", "Você atrapalha o avanço de um grupo pequeno.", "Você deixa rastro óbvio da manobra."], "seis_menos": ["O terreno vira contra você também.", "Você fica preso no próprio buraco ou armadilha.", "Um inimigo evita a manobra por completo.", "Sua Pá quebra ou fica presa.", "Você fica Exausto pelo esforço."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Pá';

-- ============================================================
-- Tonfas
-- ============================================================
UPDATE moves_arma SET
  atributo = 'TEC',
  marca = 'Arma de defesa curta, giro e resposta imediata; elas ficam mais fortes quando o espaço aperta.',
  move_a = '{"nome": "Trancar Reação", "atributo": "Técnica", "gatilho": "Quando você lutar colado ou em espaço apertado para negar o contra-ataque do inimigo, role +Técnica.", "dez_mais": ["Você causa dano no alvo.", "Você nega a próxima reação do alvo.", "Você desarma o alvo.", "Você força um recuo curto.", "Você evita a retaliação imediata."], "sete_nove": ["Você causa dano no alvo.", "Você atrapalha a próxima ação do alvo.", "Você mantém a posição na troca.", "Você cria uma abertura para um aliado.", "Sua guarda abre para outro perigo."], "seis_menos": ["O inimigo rompe seu travamento.", "Você fica preso demais na troca.", "Sua guarda abre por completo.", "Um segundo inimigo aproveita a abertura.", "Você fica Sob Pressão no espaço apertado."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Giro Curto", "atributo": "Técnica", "gatilho": "Quando você girar as tonfas para desviar um golpe e responder no mesmo movimento, role +Técnica.", "dez_mais": ["Você anula o ataque recebido.", "Você causa dano no contra-ataque.", "Você desarma o alvo.", "Você deixa o alvo Abalado pela resposta rápida.", "Você se mantém em posição vantajosa após a troca."], "sete_nove": ["Você reduz o impacto do ataque recebido.", "Você causa dano no contra-ataque.", "Você força o alvo a recuar.", "Você mantém a iniciativa da troca.", "Você fica exposto por um instante."], "seis_menos": ["O ataque atravessa sua defesa.", "Sua tentativa de desvio deixa a guarda aberta.", "Uma das tonfas escapa da sua mão.", "Você recebe o impacto completo.", "O inimigo usa seu próprio giro contra você."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Tempestade Curta", "atributo": "Técnica", "gatilho": "Quando você liberar uma sequência fechada e brutal de golpes de tonfa, sem dar nenhum espaço para o inimigo respirar, role +Técnica +2.", "dez_mais": ["Você causa dano aumentado.", "Você nega qualquer reação do alvo durante a sequência.", "Você desarma o alvo.", "Você deixa o alvo Ferido.", "Você encerra a sequência sem se expor."], "sete_nove": ["Você causa dano no alvo.", "Você força o alvo a defender em vez de atacar.", "Você mantém a iniciativa da luta.", "Você deixa o alvo hesitante.", "Sua guarda fica parcialmente aberta ao final."], "seis_menos": ["Sua sequência perde o ritmo.", "O inimigo resiste e contra-ataca.", "Você se expõe ao insistir na sequência.", "Uma das tonfas escorrega da sua mão.", "Você fica Exausto ao final do combo."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Tonfas';

-- ============================================================
-- Nunchaku
-- ============================================================
UPDATE moves_arma SET
  atributo = 'TEC',
  marca = 'Armas de fluxo, cadência e mudança rápida de direção; a cena ganha velocidade e imprevisibilidade.',
  move_a = '{"nome": "Fluxo", "atributo": "Técnica", "gatilho": "Quando você lutar em fluxo contínuo, mudando de direção sem perder o ritmo, role +Técnica.", "dez_mais": ["Você causa dano no alvo.", "Você captura o alvo sem matar.", "Você desarma o alvo.", "Você força um recuo.", "Você mantém o ritmo sem sofrer retaliação imediata."], "sete_nove": ["Você causa dano no alvo.", "Você atrapalha a próxima ação do alvo.", "Você mantém a iniciativa da troca.", "Você vira espetáculo — alguém comenta, filma ou aposta.", "Você perde o ritmo por um instante."], "seis_menos": ["Seu fluxo quebra no meio do movimento.", "O inimigo lê seu ritmo e contra-ataca.", "Um dos nunchakus escapa da sua mão.", "Você se expõe ao tentar manter a cadência.", "Você fica Sob Pressão pela perda de ritmo."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Mudança de Direção", "atributo": "Técnica", "gatilho": "Quando você mudar de direção no meio de um golpe para pegar o inimigo de um ângulo que ele não esperava, role +Técnica.", "dez_mais": ["Você causa dano aumentado.", "Você atinge o alvo antes que ele consiga reagir.", "Você se reposiciona para um ponto vantajoso.", "Você deixa o alvo Abalado.", "Você evita a retaliação imediata."], "sete_nove": ["Você causa dano no alvo.", "Você força o alvo a recuar.", "Você mantém a iniciativa da troca.", "Você cria uma abertura curta para um aliado.", "Você fica exposto após a mudança de direção."], "seis_menos": ["Você perde o equilíbrio na mudança de direção.", "O inimigo antecipa seu ângulo.", "Um dos nunchakus bate em você mesmo.", "Sua abertura permite um contra-ataque perigoso.", "Você fica Sob Pressão após a tentativa."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Redemoinho de Cadência", "atributo": "Técnica", "gatilho": "Quando você entrar num fluxo ininterrupto de golpes, mudando de direção tão rápido que o inimigo não consegue prever o próximo, role +Técnica +2.", "dez_mais": ["Você causa dano aumentado.", "Você atinge até dois inimigos próximos durante a sequência.", "Você impede qualquer reação do alvo durante a técnica.", "Você deixa o alvo Ferido.", "Você encerra a sequência em qualquer posição vantajosa."], "sete_nove": ["Você causa dano no alvo.", "Você atinge um segundo alvo com dano normal.", "Você mantém a iniciativa da luta.", "Você deixa o alvo Abalado.", "Você termina Sob Pressão pelo esforço."], "seis_menos": ["Sua cadência quebra no pior momento.", "O inimigo acompanha seus movimentos e interrompe a sequência.", "Um dos nunchakus é arrancado da sua mão.", "Você termina a técnica Exausto.", "Você acerta o alvo, mas fica cercado."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Nunchaku';

-- ============================================================
-- Glaive
-- ============================================================
UPDATE moves_arma SET
  atributo = 'REF',
  marca = 'Arma de alcance amplo, linha de passagem e domínio de área; ela reorganiza como os corpos se movem no espaço.',
  move_a = '{"nome": "Passo de Pique", "atributo": "Reflexo", "gatilho": "Quando você manter inimigos fora do seu alcance e tentar controlar um espaço amplo com o Glaive, role +Reflexo.", "dez_mais": ["Você mantém distância de todos os inimigos próximos.", "Você causa dano em quem tentar atravessar.", "Você impede que alguém atravesse um ponto específico.", "Você força um recuo geral.", "Você mantém sua posição sem sofrer retaliação imediata."], "sete_nove": ["Você mantém distância de um inimigo.", "Você causa dano em quem se aproxima.", "Você impede a passagem por um instante.", "O cabo enrosca ou o chão te trai por um momento.", "Você fica preso em espaço curto por um instante."], "seis_menos": ["O Glaive fica preso ou enroscado.", "Um inimigo atravessa sua linha de controle.", "Você fica preso em espaço curto demais para a arma.", "O chão ou o cenário te atrapalha.", "Você fica Sob Pressão ao ser cercado."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Corte de Linha", "atributo": "Reflexo", "gatilho": "Quando você varrer o Glaive numa linha ampla para atingir tudo que estiver no caminho, role +Reflexo.", "dez_mais": ["Você causa dano em até dois alvos na linha do golpe.", "Você afasta os inimigos atingidos.", "Você derruba ou desequilibra um alvo.", "Você mantém o alcance da arma para o próximo golpe.", "Você termina o movimento em posição vantajosa."], "sete_nove": ["Você causa dano em um alvo.", "Você afasta um inimigo da linha.", "Você cria espaço para recuar ou avançar.", "Você protege um aliado próximo.", "Você fica exposto ao final do movimento."], "seis_menos": ["Seu golpe varre o vazio.", "Um inimigo entra no seu alcance interno.", "O Glaive perde a linha ideal do corte.", "Você se desequilibra com o próprio peso da arma.", "Você fica Sob Pressão após a tentativa."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Círculo Impossível", "atributo": "Reflexo", "gatilho": "Quando você girar o Glaive num círculo amplo e ininterrupto, negando por completo qualquer aproximação, role +Reflexo +2.", "dez_mais": ["Você causa dano em até dois alvos ao redor.", "Você mantém todos os inimigos próximos completamente afastados.", "Você derruba ou desequilibra um alvo atingido.", "Você protege todos os aliados ao seu redor.", "Você mantém o controle total do espaço sem se expor."], "sete_nove": ["Você causa dano em um alvo.", "Você afasta os inimigos próximos.", "Você protege um aliado ao seu lado.", "Você controla a área por alguns instantes.", "Você fica exposto ao manter o giro."], "seis_menos": ["Seu giro sai do controle.", "Você deixa um flanco aberto.", "O peso do Glaive atrapalha seu próprio movimento.", "Um inimigo entra no seu alcance interno.", "Você fica Exausto ou Sob Pressão com o esforço."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Glaive';

-- ============================================================
-- Manopla
-- ============================================================
UPDATE moves_arma SET
  atributo = 'COR',
  marca = 'Arma de contato direto, aderência e controle físico; ela fica forte quando a cena vira disputa de pegada e proximidade.',
  move_a = '{"nome": "Pegada", "atributo": "Corpo", "gatilho": "Quando você decidir que a troca vira corpo a corpo para controlar o inimigo, não para matar, role +Corpo.", "dez_mais": ["Você captura o alvo sem matar.", "Você causa dano no alvo.", "Você desarma o alvo.", "Você nega a próxima reação do alvo.", "Você mantém o controle sem sofrer dano."], "sete_nove": ["Você causa dano no alvo.", "Você controla o alvo, mas apanha junto.", "Você atrapalha a próxima ação do alvo.", "Você mantém a pegada por um instante.", "Você fica preso na troca."], "seis_menos": ["O alvo escapa da sua pegada.", "Você apanha mais do que consegue controlar.", "O inimigo usa sua proximidade contra você.", "Você fica preso numa posição ruim.", "Um segundo inimigo aproveita a abertura."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Golpe de Aderência", "atributo": "Corpo", "gatilho": "Quando você golpear segurando firme o inimigo para não deixar ele se soltar do impacto, role +Corpo.", "dez_mais": ["Você causa dano aumentado.", "Você derruba o alvo.", "Você impede o alvo de recuar.", "Você deixa o alvo Abalado.", "Você mantém a pegada firme para o próximo golpe."], "sete_nove": ["Você causa dano no alvo.", "Você impede parcialmente o recuo do alvo.", "Você atrapalha a próxima ação do alvo.", "Você mantém a pressão física.", "Você fica exposto ao manter a pegada."], "seis_menos": ["O alvo se solta antes do golpe.", "Seu golpe perde força.", "Você fica preso numa posição desfavorável.", "O inimigo usa a proximidade para revidar.", "Você fica Sob Pressão pelo esforço físico."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Domínio Absoluto", "atributo": "Corpo", "gatilho": "Quando você usar toda sua força física para imobilizar completamente o inimigo, sem deixar nenhuma chance de reação, role +Corpo +2.", "dez_mais": ["Você imobiliza o alvo por completo.", "Você causa dano aumentado no alvo.", "Você desarma o alvo.", "Você nega qualquer reação do alvo durante a manobra.", "Você mantém o controle sem sofrer dano."], "sete_nove": ["Você causa dano no alvo.", "Você imobiliza o alvo por um instante.", "Você controla o alvo, mas apanha junto.", "Você atrapalha a próxima ação do alvo.", "Você fica preso na troca."], "seis_menos": ["O alvo escapa da imobilização.", "Você gasta toda sua força e fica Exausto.", "O inimigo vira a manobra contra você.", "Você fica preso numa posição perigosa.", "Um segundo inimigo aproveita a abertura."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Manopla';

