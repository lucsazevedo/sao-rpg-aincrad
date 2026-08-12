-- DML: substitui golpe_2, move_a e limit_breaker das 13 armas cobertas
-- pelo SAO_PBTA_Armas_e_Moves_Atualizado.pdf (transcrição fiel do PDF).
-- move_b e golpe_3 são zerados nessas 13: o PDF define só 3 golpes por
-- arma (2 normais + Limit Break), as outras 2 colunas eram do rascunho
-- antigo (Ollama, dml_moves_armas_golpes.sql) que este PDF substitui.
-- Fora dessas 13 armas (Adagas, Adagas de Arremesso, Arco e Flecha, Besta,
-- Chicote, Glaive, Manopla, Nunchaku, Pá, Tonfas) nada muda.

-- Leque: já existia como linha (golpes genéricos antigos) — vira Técnica
-- com o conteúdo oficial do PDF (pedido do usuário).

-- ============================================================
-- Chakrams
-- ============================================================
UPDATE moves_arma SET
  atributo = 'REF',
  marca = 'Arma de precisão, ricochete, controle de distância e ataques imprevisíveis.',
  move_a = '{"nome": "Arremesso Circular", "atributo": "Reflexo", "gatilho": "Quando você lançar seu Chakram em um arco amplo para atingir, pressionar ou cercar um inimigo, role +Reflexo.", "dez_mais": ["Você causa dano no alvo.", "O chakram retorna para sua mão sem complicações.", "Você atinge um segundo alvo próximo.", "Você força o alvo a recuar ou perder posição.", "Você deixa o alvo Sob Pressão."], "sete_nove": ["Você causa dano no alvo.", "Você força o alvo a levantar a guarda.", "Você recupera o chakram logo após o arremesso.", "Você cria uma abertura para um aliado agir.", "Você empurra o alvo para uma posição desfavorável."], "seis_menos": ["O chakram erra o alvo e vai parar longe.", "O inimigo lê a trajetória e contra-ataca.", "Seu arremesso acerta algo inesperado no cenário.", "Você perde o controle do retorno da arma.", "Um segundo inimigo aproveita sua abertura."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Eclipse Cortante", "atributo": "Reflexo", "gatilho": "Quando você executar um ataque veloz e agressivo com o Chakram, girando e cortando em sequência para dominar a troca, role +Reflexo.", "dez_mais": ["Você causa dano aumentado.", "Você acerta um ponto vulnerável e deixa o alvo Ferido.", "Você evita a retaliação imediata do inimigo.", "Você se reposiciona para um local vantajoso.", "Você abre completamente a guarda do alvo."], "sete_nove": ["Você causa dano.", "Você evita o pior da resposta inimiga.", "Você obriga o alvo a focar na defesa.", "Você muda de posição sem perder a iniciativa.", "Você cria uma abertura curta para o próximo ataque."], "seis_menos": ["Seu avanço fica previsível.", "O alvo atravessa sua ofensiva e encurta a distância.", "Você se expõe ao tentar manter a pressão.", "O golpe perde força ou precisão.", "Você perde a iniciativa da troca."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Trajetória Impossível", "atributo": "Reflexo", "gatilho": "Quando você lançar o Chakram em uma rota improvável, usando ricochetes, ângulos e movimento para acertar um alvo de forma inesperada, role +Reflexo +2.", "dez_mais": ["Você causa dano ignorando cobertura simples ou guarda parcial.", "Você atinge o alvo de surpresa, impondo Abalado.", "Você pode atingir um alvo escondido, protegido ou em posição difícil.", "O chakram retorna para você em segurança.", "Você revela uma fraqueza, rota de fuga ou abertura no cenário."], "sete_nove": ["Você causa dano no alvo.", "Você força o alvo a sair da cobertura.", "Você atinge o alvo, mas o chakram cai em outro ponto.", "Você descobre a posição real de um inimigo oculto.", "Você cria uma oportunidade para um aliado atacar."], "seis_menos": ["O ricochete sai errado e entrega sua posição.", "O chakram fica preso, cai longe ou some de vista.", "Você acerta algo que complica a cena.", "O inimigo antecipa a rota improvável.", "Sua manobra deixa você Sob Pressão ou sem defesa imediata."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Chakrams';

-- ============================================================
-- Escudo e Espada
-- ============================================================
UPDATE moves_arma SET
  atributo = 'COR',
  marca = 'Arma de resistência, pressão frontal, proteção e domínio de espaço.',
  move_a = '{"nome": "Fortaleza Inquebrável", "atributo": "Corpo", "gatilho": "Quando você firmar seu Escudo e Espada para suportar o ataque inimigo e manter sua posição, role +Corpo.", "dez_mais": ["Você bloqueia completamente o ataque inimigo.", "Você protege um aliado próximo do mesmo ataque.", "Você mantém sua posição sem ser empurrado ou derrubado.", "Você causa dano no inimigo ao responder imediatamente.", "Você deixa o alvo Sob Pressão ao frustrar sua ofensiva."], "sete_nove": ["Você reduz bastante o dano ou impacto recebido.", "Você protege um aliado próximo.", "Você mantém sua posição.", "Você força o inimigo a recuar um pouco.", "Você ganha tempo para reorganizar a linha de frente."], "seis_menos": ["Sua defesa é quebrada pelo impacto.", "Você é empurrado ou derrubado.", "Seu aliado continua exposto apesar da tentativa.", "O inimigo encontra uma abertura na sua guarda.", "Você fica Exausto ou Sob Pressão com a colisão."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Golpe Defensivo", "atributo": "Corpo", "gatilho": "Quando você usar o Escudo e Espada para bloquear e atacar no mesmo movimento, role +Corpo.", "dez_mais": ["Você bloqueia o golpe inimigo.", "Você causa dano no contra-ataque.", "Você abre a guarda do alvo.", "Você empurra o inimigo para trás.", "Você se mantém em posição vantajosa após a troca."], "sete_nove": ["Você causa dano no alvo.", "Você reduz o impacto do ataque inimigo.", "Você força o alvo a recuar.", "Você mantém a iniciativa da troca.", "Você cria uma abertura para um aliado agir."], "seis_menos": ["Seu contra-ataque sai lento demais.", "O inimigo rompe sua defesa antes da resposta.", "Você causa pouco efeito e fica exposto.", "Sua espada ou escudo sai da linha ideal de defesa.", "O inimigo toma a iniciativa da luta."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Muralha Avançada", "atributo": "Corpo", "gatilho": "Quando você avançar com Escudo e Espada para empurrar a linha inimiga e abrir espaço para seus aliados, role +Corpo +2.", "dez_mais": ["Você empurra o alvo para trás.", "Você causa dano no alvo durante o avanço.", "Você abre caminho para um aliado avançar com segurança.", "Você derruba ou desequilibra o inimigo.", "Você mantém a pressão sem sofrer retaliação imediata."], "sete_nove": ["Você empurra o inimigo alguns passos.", "Você causa dano.", "Você abre espaço na linha inimiga.", "Você protege seus aliados enquanto avança.", "Você obriga o inimigo a focar em você."], "seis_menos": ["Seu avanço para antes do esperado.", "O inimigo trava sua investida.", "Você avança demais e fica isolado.", "Um flanco fica aberto durante a manobra.", "Você vira o alvo principal da resposta inimiga."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Escudo e Espada';

-- ============================================================
-- Espada Longa
-- ============================================================
UPDATE moves_arma SET
  atributo = 'COR',
  marca = 'Arma de força, alcance médio, pressão ofensiva e golpes firmes.',
  move_a = '{"nome": "Corte Preciso", "atributo": "Corpo", "gatilho": "Quando você atacar com sua Espada Longa buscando um golpe direto, firme e bem colocado, role +Corpo.", "dez_mais": ["Você causa dano no alvo.", "Você acerta um ponto vulnerável e deixa o alvo Ferido.", "Você rompe a guarda do inimigo.", "Você evita a retaliação imediata.", "Você se mantém em posição vantajosa após o golpe."], "sete_nove": ["Você causa dano no alvo.", "Você força o inimigo a recuar.", "Você abre uma pequena brecha na guarda do alvo.", "Você mantém a pressão ofensiva.", "Você prepara o terreno para o próximo ataque."], "seis_menos": ["Seu golpe erra por pouco.", "O inimigo desvia e responde com um contra-ataque.", "Sua espada perde a linha ideal do corte.", "Você fica exposto após a investida.", "O alvo lê seu movimento com facilidade."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Lâmina Ascendente", "atributo": "Corpo", "gatilho": "Quando você desferir um golpe de baixo para cima com sua Espada Longa para quebrar postura, lançar ou desequilibrar o inimigo, role +Corpo.", "dez_mais": ["Você causa dano aumentado.", "Você derruba ou desequilibra o alvo.", "Você interrompe a ação inimiga.", "Você empurra o inimigo para trás.", "Você deixa o alvo Abalado."], "sete_nove": ["Você causa dano no alvo.", "Você impede a próxima ação ofensiva do inimigo.", "Você desequilibra o alvo por um instante.", "Você abre espaço para um aliado agir.", "Você força o inimigo a levantar a guarda."], "seis_menos": ["O golpe sobe fora do tempo.", "O inimigo sai da linha do ataque.", "Você perde equilíbrio ao executar o corte.", "Sua abertura permite um contra-ataque perigoso.", "Você fica Sob Pressão após a tentativa."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Estrela Cadente", "atributo": "Corpo", "gatilho": "Quando você erguer sua Espada Longa e descer um golpe poderoso de cima para baixo, buscando finalizar ou esmagar a defesa inimiga, role +Corpo +2.", "dez_mais": ["Você causa dano aumentado.", "Você quebra a guarda ou defesa do alvo.", "Você derruba o alvo no chão.", "Você impõe a condição Amedrontado no alvo.", "Você mantém a iniciativa da luta após o impacto."], "sete_nove": ["Você causa dano no alvo.", "Você empurra o inimigo para trás.", "Você força o alvo a defender em vez de atacar.", "Você chama a atenção do inimigo para você.", "Você abre uma brecha para um aliado."], "seis_menos": ["Seu golpe desce lento demais.", "O alvo evita o impacto principal.", "Você acerta o cenário e fica travado por um instante.", "Sua guarda fica totalmente aberta após o ataque.", "O inimigo aproveita o peso do golpe contra você."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Espada Longa';

-- ============================================================
-- Foice
-- ============================================================
UPDATE moves_arma SET
  atributo = 'TEC',
  marca = 'Arma de alcance curvo, puxões, cortes amplos e controle do ritmo da luta.',
  move_a = '{"nome": "Ceifador Sombrio", "atributo": "Técnica", "gatilho": "Quando você usar sua Foice para atacar com precisão cruel, explorando aberturas e ângulos difíceis, role +Técnica.", "dez_mais": ["Você causa dano no alvo.", "Você acerta um ponto vulnerável e deixa o alvo Ferido.", "Você puxa o alvo para uma posição desfavorável.", "Você evita a retaliação imediata.", "Você deixa o alvo Sob Pressão."], "sete_nove": ["Você causa dano no alvo.", "Você força o alvo a recuar.", "Você puxa levemente a guarda ou arma do inimigo para fora de posição.", "Você cria uma abertura para um aliado agir.", "Você mantém a iniciativa por um instante."], "seis_menos": ["Seu golpe passa no vazio.", "A foice fica fora de posição após o ataque.", "O inimigo lê seu movimento e responde.", "Você se expõe ao tentar encaixar o corte.", "Sua investida o coloca em uma posição ruim."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Colheita Final", "atributo": "Técnica", "gatilho": "Quando você executar um golpe decisivo de Foice, tentando encerrar a troca com um corte brutal e bem calculado, role +Técnica.", "dez_mais": ["Você causa dano aumentado.", "Você derruba o alvo.", "Você rompe completamente a guarda inimiga.", "Você impõe a condição Amedrontado no alvo.", "Você pode se reposicionar após o golpe sem sofrer retaliação imediata."], "sete_nove": ["Você causa dano no alvo.", "Você força o alvo a defender em vez de atacar.", "Você desequilibra o inimigo.", "Você abre espaço para um aliado avançar.", "Você mantém a pressão ofensiva."], "seis_menos": ["O golpe sai pesado demais e lento.", "O alvo evita o impacto principal.", "Você perde o equilíbrio durante a execução.", "A foice prende ou raspa em algo do cenário.", "O inimigo aproveita a abertura para contra-atacar."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Corte Circular", "atributo": "Técnica", "gatilho": "Quando você girar a Foice em um arco amplo para controlar espaço, atingir mais de um inimigo ou afastar quem estiver perto, role +Técnica +2.", "dez_mais": ["Você causa dano em até dois alvos próximos.", "Você afasta os inimigos ao redor.", "Você protege sua área imediata contra aproximação.", "Você derruba ou desequilibra um alvo atingido.", "Você termina a manobra em posição vantajosa."], "sete_nove": ["Você causa dano em um alvo.", "Você afasta um inimigo próximo.", "Você impede aproximação por um instante.", "Você cria espaço para recuar ou avançar.", "Você protege um aliado ao seu lado."], "seis_menos": ["Seu giro abre demais a guarda.", "Um inimigo entra no seu alcance interno.", "Você perde o controle total da rotação.", "Seu golpe acerta algo inconveniente no cenário.", "Você fica Exausto ou Sob Pressão com a manobra."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Foice';

-- ============================================================
-- Katana
-- ============================================================
UPDATE moves_arma SET
  atributo = 'ESP',
  marca = 'Arma de foco, precisão, serenidade e cortes executados no momento perfeito.',
  move_a = '{"nome": "Corte Iai", "atributo": "Espírito", "gatilho": "Quando você sacar e golpear com sua Katana em um único movimento fluido e preciso, role +Espírito.", "dez_mais": ["Você causa dano no alvo.", "Você acerta antes que o inimigo consiga reagir.", "Você evita a retaliação imediata.", "Você deixa o alvo Abalado.", "Você termina o golpe em posição vantajosa."], "sete_nove": ["Você causa dano no alvo.", "Você força o inimigo a interromper sua ação.", "Você se reposiciona após o saque.", "Você obriga o alvo a focar na defesa.", "Você prepara o terreno para o próximo golpe."], "seis_menos": ["Seu saque sai no tempo errado.", "O inimigo percebe sua intenção antes do golpe.", "Você falha em manter a postura após o corte.", "Sua abertura permite uma resposta perigosa.", "Você perde a iniciativa da troca."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Lua Crescente", "atributo": "Espírito", "gatilho": "Quando você executar um corte amplo e elevado com sua Katana, buscando fluxo, alcance e domínio da troca, role +Espírito.", "dez_mais": ["Você causa dano no alvo.", "Você atinge um segundo alvo próximo.", "Você afasta os inimigos ao redor.", "Você rompe a guarda do alvo.", "Você mantém o controle da cena sem sofrer retaliação imediata."], "sete_nove": ["Você causa dano no alvo.", "Você afasta um inimigo próximo.", "Você abre uma brecha na defesa adversária.", "Você protege seu espaço imediato.", "Você cria uma abertura para um aliado agir."], "seis_menos": ["Seu arco de corte abre demais sua guarda.", "O inimigo entra na curta distância.", "O golpe perde força ou precisão no meio do movimento.", "Você se posiciona mal ao concluir a técnica.", "Você fica Sob Pressão após a manobra."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Mil Pétalas", "atributo": "Espírito", "gatilho": "Quando você liberar uma sequência refinada e veloz de cortes com sua Katana, como uma chuva de lâminas, role +Espírito +2.", "dez_mais": ["Você causa dano aumentado.", "Você impede a reação imediata do alvo.", "Você deixa o alvo Ferido.", "Você cria uma abertura clara para um aliado atacar.", "Você encerra a sequência sem se expor."], "sete_nove": ["Você causa dano no alvo.", "Você pressiona o alvo e impede seu avanço.", "Você força o inimigo a defender em vez de atacar.", "Você mantém a iniciativa da luta.", "Você deixa o alvo hesitante por um instante."], "seis_menos": ["Sua sequência perde o ritmo.", "O inimigo resiste à pressão e contra-ataca.", "Você se expõe ao insistir no combo.", "Seu foco se quebra no meio da técnica.", "Você fica Exausto ou Sob Pressão ao final do movimento."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Katana';

-- ============================================================
-- Lança
-- ============================================================
UPDATE moves_arma SET
  atributo = 'TEC',
  marca = 'Arma de alcance, perfuração, controle de espaço e ataques executados com precisão.',
  move_a = '{"nome": "Muralha de Pontas", "atributo": "Técnica", "gatilho": "Quando você movimentar sua Lança rapidamente para bloquear passagens, proteger aliados ou impedir a aproximação dos inimigos, role +Técnica.", "dez_mais": ["Você impede completamente o avanço dos inimigos.", "Você causa dano em um inimigo que tente atravessar sua defesa.", "Você protege um aliado próximo de um ataque.", "Você força os adversários a recuar ou mudar de direção.", "Você mantém sua posição sem sofrer retaliação imediata."], "sete_nove": ["Você impede o avanço de um inimigo.", "Você causa dano em quem tentar se aproximar.", "Você protege parcialmente um aliado próximo.", "Você ganha tempo para o grupo se reposicionar.", "Você mantém os inimigos afastados por alguns instantes."], "seis_menos": ["Um inimigo atravessa sua defesa e encurta a distância.", "Sua lança é desviada, travada ou agarrada.", "Você deixa um dos lados da formação desprotegido.", "Um aliado fica exposto durante sua tentativa de defesa.", "Você fica Sob Pressão ao ser cercado pelos inimigos."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Investida Longa", "atributo": "Técnica", "gatilho": "Quando você avançar com sua Lança estendida para atravessar a defesa inimiga e atingir um alvo distante, role +Técnica.", "dez_mais": ["Você causa dano aumentado no alvo.", "Você atravessa ou rompe a guarda inimiga.", "Você empurra o alvo para trás ou o derruba.", "Você alcança o alvo antes que ele consiga reagir.", "Você termina a investida em uma posição vantajosa."], "sete_nove": ["Você causa dano no alvo.", "Você força o inimigo a recuar.", "Você interrompe a ação que o alvo estava realizando.", "Você abre uma brecha para um aliado avançar.", "Você mantém o alvo distante após o impacto."], "seis_menos": ["O alvo desvia e você avança para uma posição perigosa.", "Sua lança atinge uma proteção ou obstáculo do cenário.", "Você passa pelo inimigo e fica cercado.", "O adversário segura ou desvia a haste da arma.", "Sua investida deixa sua retaguarda completamente exposta."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Dragão Celestial", "atributo": "Técnica", "gatilho": "Quando você combinar giros, saltos e estocadas em uma técnica avançada de Lança, atacando de um ângulo inesperado, role +Técnica +2.", "dez_mais": ["Você causa dano aumentado.", "Você atinge até dois inimigos próximos durante a sequência.", "Você deixa o alvo Ferido com uma perfuração precisa.", "Você evita todos os contra-ataques imediatos durante a técnica.", "Você aterrissa ou encerra o movimento em uma posição vantajosa."], "sete_nove": ["Você causa dano no alvo.", "Você atinge um segundo inimigo, mas causa apenas dano normal a um deles.", "Você força os inimigos ao redor a recuar.", "Você evita o pior da resposta inimiga.", "Você deixa o alvo Abalado pela velocidade da técnica."], "seis_menos": ["Você perde o equilíbrio durante o salto ou giro.", "O inimigo prevê sua trajetória e prepara um contra-ataque.", "Sua lança fica fora de posição ao terminar a técnica.", "Você aterrissa em um local perigoso ou desfavorável.", "O esforço da sequência deixa você Exausto ou Sob Pressão."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Lança';

-- ============================================================
-- Machado
-- ============================================================
UPDATE moves_arma SET
  atributo = 'COR',
  marca = 'Arma de força, impacto, rompimento de defesa e golpes devastadores.',
  move_a = '{"nome": "Execução do Titã", "atributo": "Corpo", "gatilho": "Quando você erguer seu Machado para desferir um golpe esmagador e decisivo, role +Corpo.", "dez_mais": ["Você causa dano aumentado.", "Você derruba o alvo no chão.", "Você quebra ou atravessa a guarda inimiga.", "Você impõe a condição Amedrontado no alvo.", "Você mantém a iniciativa após o impacto."], "sete_nove": ["Você causa dano no alvo.", "Você empurra o inimigo para trás.", "Você força o alvo a defender em vez de atacar.", "Você abala a postura do inimigo.", "Você abre uma brecha para um aliado agir."], "seis_menos": ["Seu golpe sai lento demais.", "O alvo evita o impacto principal.", "Você fica exposto após o ataque.", "O peso do golpe o desequilibra.", "O inimigo aproveita sua abertura para contra-atacar."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Golpe Brutal", "atributo": "Corpo", "gatilho": "Quando você atacar com seu Machado usando força pura para esmagar, romper ou intimidar, role +Corpo.", "dez_mais": ["Você causa dano no alvo.", "Você empurra o alvo para uma posição desfavorável.", "Você interrompe a ação inimiga com o impacto.", "Você deixa o alvo Abalado.", "Você chama a atenção do inimigo para você, protegendo um aliado."], "sete_nove": ["Você causa dano no alvo.", "Você empurra o inimigo alguns passos.", "Você atrapalha a próxima ação do alvo.", "Você mantém a pressão ofensiva.", "Você impede o avanço imediato do inimigo."], "seis_menos": ["Seu golpe perde força ou direção.", "O inimigo resiste ao impacto e avança.", "Você abre demais sua guarda.", "O ataque acerta algo do cenário e complica a cena.", "O esforço o deixa Sob Pressão ou Exausto."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Quebra-Guarda", "atributo": "Corpo", "gatilho": "Quando você usar seu Machado para romper defesa, escudo, postura ou formação inimiga, role +Corpo +2.", "dez_mais": ["Você quebra completamente a guarda do alvo.", "Você causa dano no inimigo.", "Você desarma ou desloca a arma do alvo.", "Você derruba ou desequilibra o inimigo.", "Você cria uma abertura clara para um aliado atacar."], "sete_nove": ["Você abre uma brecha na defesa do alvo.", "Você causa dano no inimigo.", "Você força o alvo a recuar.", "Você atrapalha a próxima defesa do alvo.", "Você ganha posição vantajosa na troca."], "seis_menos": ["A defesa inimiga resiste ao impacto.", "Seu machado fica fora de posição após a tentativa.", "O inimigo lê seu ataque e responde.", "Você rompe a guarda, mas se expõe demais.", "Outro inimigo aproveita sua abertura."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Machado';

-- ============================================================
-- Martelo
-- ============================================================
UPDATE moves_arma SET
  atributo = 'COR',
  marca = 'Arma de esmagamento, controle de impacto, ruptura de postura e força avassaladora.',
  move_a = '{"nome": "Impacto Devastador", "atributo": "Corpo", "gatilho": "Quando você erguer seu Martelo e desferir um golpe brutal para esmagar o alvo, role +Corpo.", "dez_mais": ["Você causa dano aumentado.", "Você derruba o alvo no chão.", "Você quebra a guarda ou defesa do inimigo.", "Você empurra o alvo para longe.", "Você deixa o alvo Abalado."], "sete_nove": ["Você causa dano no alvo.", "Você empurra o inimigo alguns passos.", "Você desequilibra o alvo por um instante.", "Você impede o avanço imediato do inimigo.", "Você chama a atenção do alvo para você."], "seis_menos": ["Seu golpe sai lento demais.", "O inimigo evita o impacto principal.", "O peso do ataque o desequilibra.", "Você abre a guarda ao terminar o golpe.", "O impacto acerta o cenário e complica a cena."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Julgamento de Ferro", "atributo": "Corpo", "gatilho": "Quando você usar seu Martelo para aplicar um golpe firme e implacável, punindo um inimigo exposto ou vulnerável, role +Corpo.", "dez_mais": ["Você causa dano no alvo.", "Você acerta um ponto crítico e deixa o alvo Ferido.", "Você interrompe a ação inimiga.", "Você impõe a condição Amedrontado no alvo.", "Você mantém a iniciativa da troca."], "sete_nove": ["Você causa dano no alvo.", "Você atrapalha a próxima ação do inimigo.", "Você força o alvo a defender em vez de atacar.", "Você abre uma brecha para um aliado agir.", "Você abala a postura do alvo."], "seis_menos": ["O inimigo percebe sua intenção e reage antes.", "Seu golpe perde precisão no último instante.", "Você se expõe ao tentar forçar o impacto.", "O alvo resiste e contra-ataca.", "Você fica Sob Pressão após a tentativa."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Tremor de Guerra", "atributo": "Corpo", "gatilho": "Quando você bater seu Martelo com violência para espalhar impacto, quebrar formação ou desestabilizar inimigos ao redor, role +Corpo +2.", "dez_mais": ["Você causa dano em até dois alvos próximos.", "Você derruba ou desequilibra um alvo atingido.", "Você quebra a formação inimiga.", "Você afasta os inimigos ao redor.", "Você abre espaço seguro para seus aliados avançarem."], "sete_nove": ["Você causa dano em um alvo.", "Você afasta um inimigo próximo.", "Você desorganiza momentaneamente a linha inimiga.", "Você cria espaço para recuar ou avançar.", "Você protege um aliado ao chamar a pressão para si."], "seis_menos": ["O impacto não gera o efeito esperado.", "Você fica travado na animação do golpe por um instante.", "Um inimigo entra na sua guarda enquanto você ataca.", "O terreno ou cenário piora a situação.", "O esforço o deixa Exausto ou Sob Pressão."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Martelo';

-- ============================================================
-- Rapieira
-- ============================================================
UPDATE moves_arma SET
  atributo = 'REF',
  marca = 'Arma de velocidade, precisão, mobilidade e estocadas executadas em aberturas rápidas.',
  move_a = '{"nome": "Mil Rosas", "atributo": "Reflexo", "gatilho": "Quando você realizar uma sequência veloz de estocadas com sua Rapieira, pressionando o inimigo sem permitir que ele acompanhe seus movimentos, role +Reflexo.", "dez_mais": ["Você causa dano aumentado.", "Você impede a retaliação imediata do alvo.", "Você deixa o inimigo Sob Pressão.", "Você encontra uma abertura e deixa o alvo Ferido.", "Você encerra a sequência em uma posição segura e vantajosa."], "sete_nove": ["Você causa dano no alvo.", "Você obriga o inimigo a permanecer na defensiva.", "Você interrompe o movimento que o alvo estava realizando.", "Você cria uma abertura para um aliado agir.", "Você se reposiciona após a sequência."], "seis_menos": ["Sua sequência perde o ritmo e deixa sua guarda aberta.", "O inimigo acompanha seus movimentos e contra-ataca.", "Você avança demais e fica cercado ou isolado.", "A lâmina é desviada, presa ou afastada da linha de ataque.", "O esforço deixa você Exausto ou Sob Pressão."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Estrela Cadente", "atributo": "Reflexo", "gatilho": "Quando você avançar repentinamente com sua Rapieira, atravessando o espaço entre você e o inimigo em uma estocada fulminante, role +Reflexo.", "dez_mais": ["Você causa dano aumentado.", "Você atinge o alvo antes que ele consiga reagir.", "Você atravessa ou ignora uma guarda parcial.", "Você deixa o alvo Abalado pelo ataque inesperado.", "Você passa pelo inimigo e termina fora do alcance de retaliação."], "sete_nove": ["Você causa dano no alvo.", "Você interrompe a ação do inimigo.", "Você atravessa a defesa, mas termina próximo do alvo.", "Você força o inimigo a recuar.", "Você mantém a iniciativa após a investida."], "seis_menos": ["O inimigo prevê sua trajetória e prepara um contra-ataque.", "Você passa pelo alvo sem acertar e termina em posição desfavorável.", "Sua estocada é desviada no último instante.", "Você colide com um obstáculo ou entra em uma área perigosa.", "Seu avanço deixa um aliado ou sua retaguarda desprotegidos."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Estocada Precisa", "atributo": "Reflexo", "gatilho": "Quando você observar atentamente o inimigo e atacar uma abertura específica com sua Rapieira, role +Reflexo +2.", "dez_mais": ["Você causa dano no alvo.", "Você acerta um ponto vulnerável e deixa o inimigo Ferido.", "Você desarma ou desloca a arma do alvo.", "Você evita completamente o contra-ataque imediato.", "Você recebe +1 na próxima ação contra esse mesmo inimigo."], "sete_nove": ["Você causa dano no alvo.", "Você abre uma pequena brecha na defesa inimiga.", "Você atrapalha a próxima ação do alvo.", "Você descobre uma fraqueza ou padrão de combate do inimigo.", "Você recua para uma distância segura após a estocada."], "seis_menos": ["A abertura era uma armadilha preparada pelo inimigo.", "Sua estocada não alcança o ponto vulnerável.", "O alvo prende ou desvia sua lâmina.", "Você se concentra demais no ataque e ignora outra ameaça.", "O inimigo percebe seu padrão e ganha vantagem sobre você."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Rapieira';

-- ============================================================
-- Bastão
-- ============================================================
UPDATE moves_arma SET
  atributo = 'ESP',
  marca = 'Arma de foco, disciplina, defesa e controle de campo.',
  move_a = '{"nome": "Postura Serena", "atributo": "Espírito", "gatilho": "Quando você entrar em postura com seu Bastão, buscando equilíbrio, defesa e precisão, role +Espírito.", "dez_mais": ["Você causa dano no alvo.", "Você evita o contra-ataque imediato.", "Você afasta o inimigo para fora do seu alcance.", "Você protege um aliado próximo do próximo ataque.", "Você impõe a condição Abalado no alvo."], "sete_nove": ["Você causa dano no alvo.", "Você cria espaço entre você e o inimigo.", "Você concede cobertura a um aliado.", "Você reposiciona sem perder a guarda.", "Você força o inimigo a hesitar por um instante."], "seis_menos": ["Sua postura é quebrada.", "O inimigo atravessa sua defesa.", "Você fica Sob Pressão.", "Um aliado fica exposto por sua falha.", "Você perde terreno ou é cercado."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Círculo de Defesa", "atributo": "Espírito", "gatilho": "Quando você girar o Bastão para conter múltiplas ameaças ou segurar uma linha, role +Espírito.", "dez_mais": ["Você impede que os inimigos avancem.", "Você protege todos os aliados próximos de um ataque.", "Você causa dano em até dois alvos ao redor.", "Você força os inimigos a recuar.", "Você mantém a posição sem sofrer dano."], "sete_nove": ["Você segura a posição.", "Você protege um aliado próximo.", "Você causa dano em um alvo.", "Você reduz a ofensiva inimiga momentaneamente.", "Você se mantém firme até receber ajuda."], "seis_menos": ["Sua rotação abre uma brecha perigosa.", "Você é atingido por mais de um lado.", "Seu bastão é travado ou preso.", "Os inimigos rompem sua linha de defesa.", "Você fica Exausto pela pressão."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Impacto Interior", "atributo": "Espírito", "gatilho": "Quando você concentrar sua energia em um golpe curto, pesado e preciso com o Bastão, role +Espírito +2.", "dez_mais": ["Você causa dano aumentado.", "Você derruba o alvo.", "Você interrompe uma ação ou habilidade inimiga.", "Você deixa o alvo Amedrontado.", "Você recupera o controle total da cena."], "sete_nove": ["Você causa dano.", "Você interrompe a ação do alvo.", "Você empurra o alvo alguns passos.", "Você ganha uma abertura para um aliado agir.", "Você força o alvo a recuar."], "seis_menos": ["Seu golpe passa no vazio.", "O inimigo contra-ataca antes do impacto.", "Você perde o timing e a postura.", "Seu foco se quebra no pior momento.", "Você fica vulnerável a um ataque forte."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Bastão';

-- ============================================================
-- Clava
-- ============================================================
UPDATE moves_arma SET
  atributo = 'COR',
  marca = 'Arma bruta e pesada, focada em força pura e impacto esmagador.',
  move_a = '{"nome": "Golpe Brutal", "atributo": "Corpo", "gatilho": "Quando você desferir um golpe pesado de Clava usando força e agressividade, role +Corpo.", "dez_mais": ["Você causa dano aumentado.", "Você derruba o alvo no chão.", "Você quebra a guarda ou defesa improvisada do alvo.", "Você empurra o alvo para longe.", "Você deixa o alvo Amedrontado."], "sete_nove": ["Você causa dano.", "Você empurra o alvo.", "Você abala a postura do alvo.", "Você impede o avanço inimigo.", "Você chama a atenção de todos para você."], "seis_menos": ["Seu golpe é lento demais.", "O alvo esquiva e você perde o equilíbrio.", "Sua clava acerta algo indesejado no cenário.", "Você fica aberto para um contra-ataque.", "O impacto excessivo deixa você Exausto."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Investida Demolidora", "atributo": "Corpo", "gatilho": "Quando você avançar com a Clava para atropelar a linha inimiga, role +Corpo.", "dez_mais": ["Você atravessa a defesa inimiga.", "Você causa dano em um alvo e o joga para trás.", "Você derruba um segundo alvo próximo.", "Você abre caminho para seus aliados avançarem.", "Você permanece firme no centro da confusão."], "sete_nove": ["Você abre caminho.", "Você derruba um alvo.", "Você empurra os inimigos para trás.", "Você ganha posição dominante.", "Você protege seus aliados ao avançar."], "seis_menos": ["Você avança demais e fica isolado.", "Um inimigo lateral o intercepta.", "Sua carga para antes do esperado.", "Você tropeça ou é travado.", "Você se torna o foco de todos os ataques."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Terror do Colosso", "atributo": "Corpo", "gatilho": "Quando você erguer a Clava de modo intimidador para quebrar o moral inimigo, role +Corpo +2.", "dez_mais": ["O alvo hesita e perde sua próxima ação ofensiva.", "O alvo fica Amedrontado.", "Um segundo inimigo recua.", "Você causa dano ao aproveitar a hesitação.", "Seus aliados recebem +1 para agir contra os alvos intimidados."], "sete_nove": ["O alvo hesita.", "O alvo recua alguns passos.", "Você força um inimigo a mudar de alvo.", "Você intimida um grupo menor.", "Você impõe respeito imediato na cena."], "seis_menos": ["Sua intimidação falha.", "O inimigo ri e provoca você.", "Você revela sua intenção cedo demais.", "Um inimigo corajoso avança sem medo.", "Você fica Sob Pressão para provar sua força."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Clava';

-- ============================================================
-- Corrente com Peso
-- ============================================================
UPDATE moves_arma SET
  atributo = 'TEC',
  marca = 'Arma de controle, tração, área, desarme e domínio de movimento.',
  move_a = '{"nome": "Laço de Ferro", "atributo": "Técnica", "gatilho": "Quando você usar a Corrente com Peso para prender, travar ou limitar um alvo, role +Técnica.", "dez_mais": ["Você prende o alvo.", "Você causa dano ao enrolar ou impactar.", "Você derruba o alvo.", "Você desarma o alvo.", "Você puxa o alvo para uma posição desfavorável."], "sete_nove": ["Você reduz a mobilidade do alvo.", "Você causa dano leve.", "Você atrapalha a próxima ação do alvo.", "Você força o alvo a recuar ou se expor.", "Você cria abertura para um aliado."], "seis_menos": ["A corrente falha e perde o alvo.", "Ela se prende em algo do cenário.", "O inimigo puxa você junto.", "Você perde o controle da distância.", "Sua arma vira uma complicação imediata."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Órbita de Aço", "atributo": "Técnica", "gatilho": "Quando você girar a Corrente com Peso ao redor do corpo para controlar a área e impedir aproximação, role +Técnica.", "dez_mais": ["Você mantém todos os inimigos próximos afastados.", "Você causa dano em um alvo que tente atravessar sua área.", "Você protege um aliado atrás de você.", "Você força um inimigo a mudar de rota ou recuar.", "Você mantém o controle total do espaço imediato."], "sete_nove": ["Você afasta um inimigo.", "Você protege um aliado.", "Você controla a área por alguns instantes.", "Você causa dano em quem avança.", "Você recupera fôlego e iniciativa."], "seis_menos": ["Sua órbita sai do controle.", "Você deixa um flanco aberto.", "O peso da corrente atrapalha seu próprio movimento.", "Um inimigo entra no seu alcance interno.", "Você se coloca em risco ao manter o giro."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Puxão Implacável", "atributo": "Técnica", "gatilho": "Quando você acertar a Corrente com Peso e usar a tração para reposicionar brutalmente o alvo, role +Técnica +2.", "dez_mais": ["Você puxa o alvo até você.", "Você arremessa o alvo para longe.", "Você joga o alvo no chão.", "Você causa dano aumentado com o impacto.", "Você coloca o alvo ao alcance de um aliado."], "sete_nove": ["Você move o alvo alguns metros.", "Você derruba o alvo.", "Você causa dano.", "Você quebra a formação inimiga.", "Você separa o alvo de seus aliados."], "seis_menos": ["O alvo resiste e puxa você no lugar.", "A corrente escapa na hora errada.", "Você perde o equilíbrio no puxão.", "O alvo usa sua força contra você.", "Você abre espaço para um contra-ataque perigoso."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Corrente com Peso';

-- ============================================================
-- Leque
-- ============================================================
UPDATE moves_arma SET
  atributo = 'TEC',
  marca = 'Armas de combate elegantes e imprevisíveis, usadas em pares para desviar ataques, executar cortes rápidos e confundir o adversário.',
  move_a = '{"nome": "Dança das Lâminas", "atributo": "Técnica", "gatilho": "Quando você avançar com seus Leques, alternando cortes rápidos e movimentos imprevisíveis, role +Técnica.", "dez_mais": ["Você causa dano no alvo.", "Você evita a retaliação imediata.", "Você deixa o inimigo Sob Pressão.", "Você se reposiciona para um ponto vantajoso.", "Você cria uma abertura para um aliado agir."], "sete_nove": ["Você causa dano no alvo.", "Você força o inimigo a recuar.", "Você mantém a iniciativa.", "Você dificulta a próxima ação do alvo.", "Você consegue se afastar após o ataque."], "seis_menos": ["Sua sequência perde o ritmo.", "O inimigo consegue atravessar seus movimentos.", "Um dos leques fica preso, desviado ou fora de posição.", "Você termina a técnica em uma posição perigosa.", "O adversário percebe seu padrão e prepara um contra-ataque."]}'::jsonb,
  move_b = null,
  golpe_2 = '{"nome": "Véu Cortante", "atributo": "Técnica", "gatilho": "Quando você usar seus Leques para desviar um ataque e responder no mesmo movimento, role +Técnica.", "dez_mais": ["Você anula o ataque recebido.", "Você causa dano no contra-ataque.", "Você desarma ou desloca a arma do adversário.", "Você protege um aliado próximo.", "Você deixa o inimigo Abalado pela velocidade da resposta."], "sete_nove": ["Você reduz ou evita o pior do ataque.", "Você causa dano no contra-ataque.", "Você afasta o inimigo.", "Você protege parcialmente um aliado.", "Você se reposiciona para uma distância segura."], "seis_menos": ["O ataque atravessa sua defesa.", "Sua tentativa de desvio deixa sua guarda aberta.", "Um dos leques é arrancado de sua mão.", "Você protege alguém, mas recebe o impacto no lugar dele.", "O inimigo usa seu próprio movimento para desequilibrá-lo."]}'::jsonb,
  golpe_3 = null,
  limit_breaker = '{"nome": "Tempestade das Mil Lâminas", "atributo": "Técnica", "gatilho": "Quando você liberar toda sua habilidade com os Leques, avançando em uma sequência quase impossível de acompanhar, role +Técnica +2.", "dez_mais": ["Você causa dano aumentado.", "Você atinge até dois inimigos próximos durante a sequência.", "Você deixa um alvo Ferido.", "Você evita qualquer retaliação imediata durante a técnica.", "Você encerra o Limit Break em qualquer posição próxima que seja vantajosa."], "sete_nove": ["Você causa dano aumentado.", "Você atinge um segundo inimigo, causando dano normal nele.", "Você deixa o alvo Abalado.", "Você atravessa a defesa e mantém a iniciativa.", "Você escapa da retaliação, mas termina Sob Pressão."], "seis_menos": ["A sequência sai do controle e você termina exposto.", "Um inimigo acompanha seus movimentos e interrompe o Limit Break.", "Um dos leques é lançado ou fica preso longe de você.", "Você termina a técnica Exausto.", "Você atinge o alvo, mas acaba cercado ou em uma posição extremamente perigosa."], "bonus_acerto": "+2"}'::jsonb,
  visivel = true,
  updated_at = now()
WHERE nome = 'Leque';

