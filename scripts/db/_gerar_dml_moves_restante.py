"""
Continuação de scripts/db/_gerar_dml_moves_pdf.py — mesmo formato PBTA
(2 golpes normais + Limit Break, gatilho + 10+ escolha 2 / 7-9 escolha 1 /
6- o Mestre narra com 5 ideias cada), agora pras 10 armas que o PDF do
usuário não cobria: Arco e Flecha, Adagas, Adagas de Arremesso, Besta,
Chicote, Pá, Tonfas, Nunchaku, Glaive, Manopla.

Fonte de verdade pra atributo, Marca e o "Move de Combate" original de
cada arma: docs/guia_sistema_aincrad.md (tabela de atributo principal +
seção "Moves de Arma"). Move 1 de cada arma abaixo é uma reformatação
fiel desse Move de Combate canônico pro molde de 10+/7-9/6-; Move 2 é um
segundo ângulo de combate novo, mesma arma e mesmo atributo (padrão do
PDF: as 2 moves normais de uma arma sempre usam o mesmo atributo — só o
Limit Break soma +2); Limit Break é o golpe de assinatura novo.

Rode: python scripts/db/_gerar_dml_moves_restante.py scripts/db/dml_moves_armas_restante.sql
"""
import json
import sys

def mv(nome, atributo, gatilho, dez_mais, sete_nove, seis_menos, bonus=None):
    d = {
        "nome": nome, "atributo": atributo, "gatilho": gatilho,
        "dez_mais": dez_mais, "sete_nove": sete_nove, "seis_menos": seis_menos,
    }
    if bonus:
        d["bonus_acerto"] = bonus
    return d

ARMAS = {}

# ============================================================ ARCO E FLECHA
ARMAS["Arco e Flecha"] = {
    "atributo_abrev": "REF",
    "marca": "Arma de distância, precisão e leitura de terreno; a cena te coloca naturalmente em pontos de visão, cobertura e vigilância.",
    "move_a": mv(
        "Linha de Tiro", "Reflexo",
        "Quando você mantiver distância e disparar contra um alvo antes que ele consiga te alcançar, role +Reflexo.",
        ["Você causa dano no alvo.", "Você interrompe a ação que o alvo estava prestes a realizar.",
         "Você impede que o alvo feche distância nesta troca.", "Você dispara sem revelar sua posição.", "Você deixa o alvo Sob Pressão."],
        ["Você causa dano no alvo.", "Você atrasa a ação do alvo por um instante.", "Você mantém alguma distância do alvo.",
         "Você cria uma abertura para um aliado agir.", "Você força o alvo a buscar cobertura."],
        ["Sua posição é revelada.", "A flecha se perde ou fica presa longe.", "O alvo fecha distância rapidamente.",
         "Um terceiro percebe o disparo e reage.", "Você fica Sob Pressão ao ser encontrado."],
    ),
    "golpe_2": mv(
        "Chuva Dirigida", "Reflexo",
        "Quando você disparar uma sequência rápida de flechas contra um grupo ou área para negar avanço, role +Reflexo.",
        ["Você causa dano em até dois alvos próximos.", "Você afasta os inimigos ao redor.", "Você impede o avanço de quem está na área.",
         "Você deixa um alvo Ferido.", "Você mantém munição suficiente para o próximo disparo."],
        ["Você causa dano em um alvo.", "Você afasta um inimigo próximo.", "Você atrasa o avanço da linha inimiga.",
         "Você cria espaço para recuar ou se reposicionar.", "Você protege um aliado com a cobertura de flechas."],
        ["Você fica sem flechas no pior momento.", "Um inimigo atravessa a chuva de flechas.", "Seu disparo acerta algo ou alguém errado.",
         "Você se expõe ao manter o ritmo de disparos.", "Você fica Exausto pelo esforço."],
    ),
    "limit_breaker": mv(
        "Tiro do Horizonte", "Reflexo",
        "Quando você mirar com calma absoluta e disparar um único tiro decisivo através de qualquer obstáculo no caminho, role +Reflexo +2.",
        ["Você causa dano ignorando cobertura simples ou guarda parcial.", "Você atinge o alvo antes que qualquer reação seja possível.",
         "Você acerta um ponto vulnerável e deixa o alvo Ferido.", "Você revela a posição real de um inimigo oculto.",
         "Você mantém sua posição em segredo mesmo após o disparo."],
        ["Você causa dano no alvo.", "Você força o alvo a sair da cobertura.", "Você atinge o alvo, mas revela sua posição.",
         "Você descobre uma fraqueza do inimigo.", "Você cria uma abertura clara para um aliado."],
        ["O tiro erra o ponto exato que você mirava.", "Sua posição é entregue no pior momento.", "A flecha se perde ou atinge outra coisa.",
         "O inimigo antecipa sua mira.", "Você fica Sob Pressão ou exposto após o disparo."],
        bonus="+2",
    ),
}

# ============================================================ ADAGAS
ARMAS["Adagas"] = {
    "atributo_abrev": "TEC",
    "marca": "Arma de proximidade, precisão curta e perigo imediato; elas mudam a cena quando tudo fica perto demais.",
    "move_a": mv(
        "Dentro da Guarda", "Técnica",
        "Quando você entrar colado no inimigo, negando espaço para qualquer reação, role +Técnica.",
        ["Você causa dano no alvo.", "Você nega a próxima reação do alvo.", "Você desarma um item pequeno do inimigo.",
         "Você muda de posição, ficando fora do alcance imediato.", "Você evita a retaliação imediata."],
        ["Você causa dano no alvo.", "Você nega parte da reação do alvo.", "Você fica preso na troca, mas causa dano mesmo assim.",
         "Você se expõe a um segundo inimigo.", "Você deixa uma marca evidente no alvo."],
        ["Você entra na guarda errada e leva o troco.", "O inimigo prevê sua aproximação.", "Sua adaga escorrega ou erra o ângulo.",
         "Você fica preso perto demais do inimigo.", "Um segundo inimigo aproveita sua abertura."],
    ),
    "golpe_2": mv(
        "Corte de Sombra", "Técnica",
        "Quando você explorar uma abertura já criada para cravar as adagas num ponto exato, role +Técnica.",
        ["Você causa dano aumentado.", "Você acerta um ponto vulnerável e deixa o alvo Ferido.", "Você evita qualquer retaliação imediata.",
         "Você corta ou rouba algo preso ao alvo.", "Você se reposiciona sem perder o controle da troca."],
        ["Você causa dano no alvo.", "Você força o alvo a recuar.", "Você mantém a iniciativa da troca.",
         "Você cria uma abertura para um aliado agir.", "Você consegue se afastar após o golpe."],
        ["Sua lâmina desliza sem penetrar.", "O inimigo fecha a abertura antes de você.", "Você se expõe ao insistir no corte.",
         "Um dos golpes te deixa exposto no lugar errado.", "O inimigo lê seu padrão e se prepara."],
    ),
    "limit_breaker": mv(
        "Execução Silenciosa", "Técnica",
        "Quando você concentrar toda sua velocidade numa sequência final de cortes rápidos e certeiros contra um alvo já comprometido, role +Técnica +2.",
        ["Você causa dano aumentado.", "Você deixa o alvo Ferido.", "Você impede qualquer reação do alvo durante a sequência.",
         "Você encerra os cortes sem se expor.", "Você descobre um segundo ponto vulnerável para explorar depois."],
        ["Você causa dano no alvo.", "Você força o alvo a defender em vez de atacar.", "Você mantém a iniciativa da luta.",
         "Você deixa o alvo hesitante por um instante.", "Você recua para uma posição mais segura."],
        ["Sua sequência perde o ritmo no meio do golpe.", "O inimigo resiste e contra-ataca.", "Você se expõe demais ao insistir.",
         "Uma das lâminas escapa da sua mão.", "Você fica Exausto ao final da sequência."],
        bonus="+2",
    ),
}

# ============================================================ ADAGAS DE ARREMESSO
ARMAS["Adagas de Arremesso"] = {
    "atributo_abrev": "REF",
    "marca": "Arma de prontidão, alcance curto e ameaça espalhada; a cena tende a abrir espaço para marcação, aviso e pressão rápida.",
    "move_a": mv(
        "Primeira Chuva", "Reflexo",
        "Quando você abrir a troca contra um grupo antes que ele se organize, arremessando suas lâminas, role +Reflexo.",
        ["Você causa dano em até dois alvos próximos.", "Você impede que qualquer um do grupo feche distância sem pagar por isso.",
         "Você força a dispersão do grupo inimigo.", "Você deixa um alvo Sob Pressão.", "Você recupera parte das lâminas na hora."],
        ["Você causa dano em um alvo.", "Você atrasa o avanço do grupo.", "Você força um inimigo a recuar.",
         "Você cria uma abertura para um aliado agir.", "Você mantém a iniciativa por um instante."],
        ["Suas lâminas ficam no chão, presas ou longe demais.", "O grupo se organiza mais rápido do que você esperava.",
         "Você fica sem nada em mãos no pior momento.", "Um inimigo avança direto sobre você.",
         "Você se expõe ao gastar todas as lâminas de uma vez."],
    ),
    "golpe_2": mv(
        "Marcação Cruzada", "Reflexo",
        "Quando você arremessar lâminas para marcar, prender roupa ou travar a movimentação de um alvo específico, role +Reflexo.",
        ["Você causa dano no alvo.", "Você prende o alvo por uma troca (roupa, arma ou membro).", "Você reduz drasticamente a mobilidade do alvo.",
         "Você deixa o alvo marcado — o próximo golpe de um aliado contra ele não sofre reação.", "Você evita a retaliação imediata."],
        ["Você causa dano no alvo.", "Você reduz a mobilidade do alvo por um instante.", "Você atrapalha a próxima ação do alvo.",
         "Você força o alvo a se expor tentando se soltar.", "Você cria uma abertura curta para um aliado."],
        ["A lâmina erra o ponto de prender.", "O alvo se solta antes do esperado.", "Você fica sem lâminas de sobra.",
         "O alvo usa sua prisão contra você.", "Você se expõe ao tentar acertar o ponto certo."],
    ),
    "limit_breaker": mv(
        "Tempestade de Lâminas", "Reflexo",
        "Quando você arremessar todas as lâminas que tem numa saraivada final contra tudo que estiver ao seu alcance, role +Reflexo +2.",
        ["Você causa dano em até dois alvos próximos.", "Você deixa um alvo Ferido.", "Você impede qualquer aproximação durante a saraivada.",
         "Você mantém uma lâmina de reserva para o próximo golpe.", "Você encerra a manobra em posição vantajosa."],
        ["Você causa dano aumentado em um alvo.", "Você atinge um segundo alvo com dano normal.", "Você força os inimigos ao redor a recuar.",
         "Você deixa o alvo Abalado.", "Você fica sem lâminas até recuperá-las."],
        ["Você fica completamente desarmado no pior momento.", "A saraivada acerta algo ou alguém errado.",
         "Um inimigo atravessa a chuva de lâminas.", "Você se expõe ao gastar tudo de uma vez.", "Você fica Exausto pelo esforço."],
        bonus="+2",
    ),
}

# ============================================================ BESTA
ARMAS["Besta"] = {
    "atributo_abrev": "REF",
    "marca": "Arma de impacto, interrupção e decisão à distância; quando ela entra em cena, alguém sente que uma ação vai ser parada.",
    "move_a": mv(
        "Tiro de Interrupção", "Reflexo",
        "Quando alguém tentar fugir, ativar algo ou completar uma ação perigosa e você disparar para impedir, role +Reflexo.",
        ["Você interrompe a ação do alvo.", "Você causa dano no alvo.", "Você derruba o alvo.",
         "Você desarma o alvo.", "Você força um recuo imediato."],
        ["Você interrompe a ação do alvo.", "Você causa dano no alvo.", "O barulho ou o tempo de recarga chama atenção extra para a cena.",
         "Você cria uma abertura para um aliado agir.", "Você mantém o alvo sob mira."],
        ["O virote erra o alvo por pouco.", "Você não consegue recarregar a tempo.", "O alvo completa a ação antes do disparo.",
         "Sua posição fica exposta.", "Um segundo inimigo aproveita a distração."],
    ),
    "golpe_2": mv(
        "Golpe de Rearme", "Reflexo",
        "Quando você disparar à queima-roupa ou usar a besta como arma de impacto num inimigo já perto, role +Reflexo.",
        ["Você causa dano aumentado.", "Você derruba o alvo.", "Você empurra o alvo para longe.",
         "Você deixa o alvo Abalado.", "Você recarrega a tempo do próximo disparo."],
        ["Você causa dano no alvo.", "Você empurra o alvo alguns passos.", "Você atrapalha a próxima ação do alvo.",
         "Você mantém distância mínima segura.", "Você chama a atenção do alvo para você."],
        ["Seu disparo sai fraco demais.", "A besta emperra no pior momento.", "O alvo resiste ao impacto e avança.",
         "Você fica sem munição.", "Você se expõe ao ficar perto demais."],
    ),
    "limit_breaker": mv(
        "Rajada Final", "Reflexo",
        "Quando você disparar uma sequência rápida de virotes contra um único alvo para encerrar a troca de vez, role +Reflexo +2.",
        ["Você causa dano aumentado.", "Você acerta um ponto crítico e deixa o alvo Ferido.", "Você interrompe qualquer ação do alvo durante a sequência.",
         "Você derruba o alvo.", "Você mantém munição para o próximo disparo."],
        ["Você causa dano no alvo.", "Você atrapalha a próxima ação do alvo.", "Você força o alvo a recuar.",
         "Você mantém a iniciativa da troca.", "Você deixa o alvo hesitante."],
        ["A besta emperra no meio da sequência.", "Você fica sem virotes no pior momento.", "O alvo resiste e avança sobre você.",
         "Seu disparo acerta algo errado.", "Você fica Exausto ao final da rajada."],
        bonus="+2",
    ),
}

# ============================================================ CHICOTE
ARMAS["Chicote"] = {
    "atributo_abrev": "CON",
    "marca": "Arma de alcance, controle e limite; ela transforma espaço aberto em território disputado.",
    "move_a": mv(
        "Domínio de Alcance", "Conhecimento",
        "Quando você usar o alcance do chicote para puxar, prender ou derrubar um alvo sem se aproximar, role +Conhecimento.",
        ["Você puxa o alvo para um ponto ruim.", "Você derruba o alvo.", "Você prende o alvo por uma troca — ele não reage até se soltar.",
         "Você causa dano no alvo.", "Você mantém distância segura durante toda a manobra."],
        ["Você causa dano no alvo.", "Você reduz a mobilidade do alvo.", "Você atrapalha a próxima ação do alvo.",
         "Você cria uma abertura para um aliado.", "Você mantém alguma distância do alvo."],
        ["O chicote enrosca em algo do cenário.", "O alvo puxa você junto.", "Você perde o controle da distância.",
         "Sua arma vira uma complicação imediata.", "Você fica Sob Pressão ao errar a manobra."],
    ),
    "golpe_2": mv(
        "Corte de Limite", "Conhecimento",
        "Quando você estalar o chicote com precisão para acertar um ponto exato à distância, role +Conhecimento.",
        ["Você causa dano aumentado.", "Você acerta um ponto vulnerável e deixa o alvo Ferido.", "Você desarma o alvo à distância.",
         "Você evita a retaliação imediata.", "Você mantém o alvo dentro do seu alcance."],
        ["Você causa dano no alvo.", "Você força o alvo a recuar.", "Você atrapalha a próxima ação do alvo.",
         "Você mantém a iniciativa da troca.", "Você cria espaço entre você e o alvo."],
        ["O estalo erra o ponto exato.", "O chicote se enrola em você mesmo.", "O alvo entra na sua distância mínima.",
         "Você perde o timing do golpe.", "Você fica Sob Pressão após a tentativa."],
    ),
    "limit_breaker": mv(
        "Território Disputado", "Conhecimento",
        "Quando você tomar toda a área ao seu redor com o chicote, prendendo, puxando e derrubando tudo que estiver ao alcance, role +Conhecimento +2.",
        ["Você causa dano em até dois alvos próximos.", "Você prende um alvo por toda a cena, não só uma troca.",
         "Você derruba ou desequilibra um alvo atingido.", "Você mantém todos os outros inimigos fora do seu alcance.",
         "Você termina a manobra em posição vantajosa."],
        ["Você causa dano em um alvo.", "Você prende um alvo por uma troca.", "Você afasta um inimigo próximo.",
         "Você cria espaço para recuar ou avançar.", "Você protege um aliado ao seu lado."],
        ["O chicote se enrosca em você mesmo.", "Um inimigo atravessa sua área de controle.", "Você perde o controle total da manobra.",
         "Seu golpe acerta algo inconveniente no cenário.", "Você fica Exausto ou Sob Pressão com o esforço."],
        bonus="+2",
    ),
}

# ============================================================ PÁ
ARMAS["Pá"] = {
    "atributo_abrev": "CON",
    "marca": "Arma de improviso, terreno e preparação; ela faz a cena olhar para o chão, para o abrigo e para o que pode ser montado ali.",
    "move_a": mv(
        "Terreno é Arma", "Conhecimento",
        "Quando você usar chão, areia, água rasa ou entulho com sua Pá para criar vantagem tática, role +Conhecimento.",
        ["Você causa dano no alvo.", "Você cria cobertura útil para você ou um aliado.", "Você cega ou derruba o alvo por um instante.",
         "Você força um recuo.", "Você não deixa rastro da manobra."],
        ["Você causa dano no alvo.", "Você cria a vantagem, mas perde posição.", "Você atrapalha a próxima ação do alvo.",
         "Você cria uma abertura para um aliado agir.", "Você deixa um rastro óbvio da manobra."],
        ["O terreno não coopera como esperado.", "Você mesmo fica em desvantagem com a manobra.", "O alvo antecipa seu truque.",
         "Sua Pá prende ou emperra no chão.", "Você fica exposto ao tentar a manobra."],
    ),
    "golpe_2": mv(
        "Golpe de Pá", "Conhecimento",
        "Quando você golpear com o peso e a borda da Pá para causar impacto direto, role +Conhecimento.",
        ["Você causa dano aumentado.", "Você derruba o alvo.", "Você empurra o alvo para longe.",
         "Você deixa o alvo Abalado.", "Você mantém a iniciativa após o golpe."],
        ["Você causa dano no alvo.", "Você empurra o alvo alguns passos.", "Você atrapalha a próxima ação do alvo.",
         "Você força o alvo a recuar.", "Você chama a atenção do alvo para você."],
        ["Seu golpe sai lento demais.", "O alvo evita o impacto.", "A Pá prende no chão ou em algo do cenário.",
         "Você fica exposto após o ataque.", "O esforço te deixa Sob Pressão."],
    ),
    "limit_breaker": mv(
        "Terra Revolta", "Conhecimento",
        "Quando você revirar completamente o terreno ao seu redor, transformando o chão inteiro numa armadilha, role +Conhecimento +2.",
        ["Você causa dano em até dois alvos próximos.", "Você derruba ou prende todos os alvos atingidos.",
         "Você cria cobertura ampla para todo o grupo.", "Você cega ou desorienta os inimigos ao redor.",
         "Você não fica exposto durante a manobra."],
        ["Você causa dano em um alvo.", "Você derruba um alvo.", "Você cria alguma cobertura.",
         "Você atrapalha o avanço de um grupo pequeno.", "Você deixa rastro óbvio da manobra."],
        ["O terreno vira contra você também.", "Você fica preso no próprio buraco ou armadilha.", "Um inimigo evita a manobra por completo.",
         "Sua Pá quebra ou fica presa.", "Você fica Exausto pelo esforço."],
        bonus="+2",
    ),
}

# ============================================================ TONFAS
ARMAS["Tonfas"] = {
    "atributo_abrev": "TEC",
    "marca": "Arma de defesa curta, giro e resposta imediata; elas ficam mais fortes quando o espaço aperta.",
    "move_a": mv(
        "Trancar Reação", "Técnica",
        "Quando você lutar colado ou em espaço apertado para negar o contra-ataque do inimigo, role +Técnica.",
        ["Você causa dano no alvo.", "Você nega a próxima reação do alvo.", "Você desarma o alvo.",
         "Você força um recuo curto.", "Você evita a retaliação imediata."],
        ["Você causa dano no alvo.", "Você atrapalha a próxima ação do alvo.", "Você mantém a posição na troca.",
         "Você cria uma abertura para um aliado.", "Sua guarda abre para outro perigo."],
        ["O inimigo rompe seu travamento.", "Você fica preso demais na troca.", "Sua guarda abre por completo.",
         "Um segundo inimigo aproveita a abertura.", "Você fica Sob Pressão no espaço apertado."],
    ),
    "golpe_2": mv(
        "Giro Curto", "Técnica",
        "Quando você girar as tonfas para desviar um golpe e responder no mesmo movimento, role +Técnica.",
        ["Você anula o ataque recebido.", "Você causa dano no contra-ataque.", "Você desarma o alvo.",
         "Você deixa o alvo Abalado pela resposta rápida.", "Você se mantém em posição vantajosa após a troca."],
        ["Você reduz o impacto do ataque recebido.", "Você causa dano no contra-ataque.", "Você força o alvo a recuar.",
         "Você mantém a iniciativa da troca.", "Você fica exposto por um instante."],
        ["O ataque atravessa sua defesa.", "Sua tentativa de desvio deixa a guarda aberta.", "Uma das tonfas escapa da sua mão.",
         "Você recebe o impacto completo.", "O inimigo usa seu próprio giro contra você."],
    ),
    "limit_breaker": mv(
        "Tempestade Curta", "Técnica",
        "Quando você liberar uma sequência fechada e brutal de golpes de tonfa, sem dar nenhum espaço para o inimigo respirar, role +Técnica +2.",
        ["Você causa dano aumentado.", "Você nega qualquer reação do alvo durante a sequência.", "Você desarma o alvo.",
         "Você deixa o alvo Ferido.", "Você encerra a sequência sem se expor."],
        ["Você causa dano no alvo.", "Você força o alvo a defender em vez de atacar.", "Você mantém a iniciativa da luta.",
         "Você deixa o alvo hesitante.", "Sua guarda fica parcialmente aberta ao final."],
        ["Sua sequência perde o ritmo.", "O inimigo resiste e contra-ataca.", "Você se expõe ao insistir na sequência.",
         "Uma das tonfas escorrega da sua mão.", "Você fica Exausto ao final do combo."],
        bonus="+2",
    ),
}

# ============================================================ NUNCHAKU
ARMAS["Nunchaku"] = {
    "atributo_abrev": "TEC",
    "marca": "Armas de fluxo, cadência e mudança rápida de direção; a cena ganha velocidade e imprevisibilidade.",
    "move_a": mv(
        "Fluxo", "Técnica",
        "Quando você lutar em fluxo contínuo, mudando de direção sem perder o ritmo, role +Técnica.",
        ["Você causa dano no alvo.", "Você captura o alvo sem matar.", "Você desarma o alvo.",
         "Você força um recuo.", "Você mantém o ritmo sem sofrer retaliação imediata."],
        ["Você causa dano no alvo.", "Você atrapalha a próxima ação do alvo.", "Você mantém a iniciativa da troca.",
         "Você vira espetáculo — alguém comenta, filma ou aposta.", "Você perde o ritmo por um instante."],
        ["Seu fluxo quebra no meio do movimento.", "O inimigo lê seu ritmo e contra-ataca.", "Um dos nunchakus escapa da sua mão.",
         "Você se expõe ao tentar manter a cadência.", "Você fica Sob Pressão pela perda de ritmo."],
    ),
    "golpe_2": mv(
        "Mudança de Direção", "Técnica",
        "Quando você mudar de direção no meio de um golpe para pegar o inimigo de um ângulo que ele não esperava, role +Técnica.",
        ["Você causa dano aumentado.", "Você atinge o alvo antes que ele consiga reagir.", "Você se reposiciona para um ponto vantajoso.",
         "Você deixa o alvo Abalado.", "Você evita a retaliação imediata."],
        ["Você causa dano no alvo.", "Você força o alvo a recuar.", "Você mantém a iniciativa da troca.",
         "Você cria uma abertura curta para um aliado.", "Você fica exposto após a mudança de direção."],
        ["Você perde o equilíbrio na mudança de direção.", "O inimigo antecipa seu ângulo.", "Um dos nunchakus bate em você mesmo.",
         "Sua abertura permite um contra-ataque perigoso.", "Você fica Sob Pressão após a tentativa."],
    ),
    "limit_breaker": mv(
        "Redemoinho de Cadência", "Técnica",
        "Quando você entrar num fluxo ininterrupto de golpes, mudando de direção tão rápido que o inimigo não consegue prever o próximo, role +Técnica +2.",
        ["Você causa dano aumentado.", "Você atinge até dois inimigos próximos durante a sequência.", "Você impede qualquer reação do alvo durante a técnica.",
         "Você deixa o alvo Ferido.", "Você encerra a sequência em qualquer posição vantajosa."],
        ["Você causa dano no alvo.", "Você atinge um segundo alvo com dano normal.", "Você mantém a iniciativa da luta.",
         "Você deixa o alvo Abalado.", "Você termina Sob Pressão pelo esforço."],
        ["Sua cadência quebra no pior momento.", "O inimigo acompanha seus movimentos e interrompe a sequência.",
         "Um dos nunchakus é arrancado da sua mão.", "Você termina a técnica Exausto.", "Você acerta o alvo, mas fica cercado."],
        bonus="+2",
    ),
}

# ============================================================ GLAIVE
ARMAS["Glaive"] = {
    "atributo_abrev": "REF",
    "marca": "Arma de alcance amplo, linha de passagem e domínio de área; ela reorganiza como os corpos se movem no espaço.",
    "move_a": mv(
        "Passo de Pique", "Reflexo",
        "Quando você manter inimigos fora do seu alcance e tentar controlar um espaço amplo com o Glaive, role +Reflexo.",
        ["Você mantém distância de todos os inimigos próximos.", "Você causa dano em quem tentar atravessar.",
         "Você impede que alguém atravesse um ponto específico.", "Você força um recuo geral.", "Você mantém sua posição sem sofrer retaliação imediata."],
        ["Você mantém distância de um inimigo.", "Você causa dano em quem se aproxima.", "Você impede a passagem por um instante.",
         "O cabo enrosca ou o chão te trai por um momento.", "Você fica preso em espaço curto por um instante."],
        ["O Glaive fica preso ou enroscado.", "Um inimigo atravessa sua linha de controle.", "Você fica preso em espaço curto demais para a arma.",
         "O chão ou o cenário te atrapalha.", "Você fica Sob Pressão ao ser cercado."],
    ),
    "golpe_2": mv(
        "Corte de Linha", "Reflexo",
        "Quando você varrer o Glaive numa linha ampla para atingir tudo que estiver no caminho, role +Reflexo.",
        ["Você causa dano em até dois alvos na linha do golpe.", "Você afasta os inimigos atingidos.", "Você derruba ou desequilibra um alvo.",
         "Você mantém o alcance da arma para o próximo golpe.", "Você termina o movimento em posição vantajosa."],
        ["Você causa dano em um alvo.", "Você afasta um inimigo da linha.", "Você cria espaço para recuar ou avançar.",
         "Você protege um aliado próximo.", "Você fica exposto ao final do movimento."],
        ["Seu golpe varre o vazio.", "Um inimigo entra no seu alcance interno.", "O Glaive perde a linha ideal do corte.",
         "Você se desequilibra com o próprio peso da arma.", "Você fica Sob Pressão após a tentativa."],
    ),
    "limit_breaker": mv(
        "Círculo Impossível", "Reflexo",
        "Quando você girar o Glaive num círculo amplo e ininterrupto, negando por completo qualquer aproximação, role +Reflexo +2.",
        ["Você causa dano em até dois alvos ao redor.", "Você mantém todos os inimigos próximos completamente afastados.",
         "Você derruba ou desequilibra um alvo atingido.", "Você protege todos os aliados ao seu redor.",
         "Você mantém o controle total do espaço sem se expor."],
        ["Você causa dano em um alvo.", "Você afasta os inimigos próximos.", "Você protege um aliado ao seu lado.",
         "Você controla a área por alguns instantes.", "Você fica exposto ao manter o giro."],
        ["Seu giro sai do controle.", "Você deixa um flanco aberto.", "O peso do Glaive atrapalha seu próprio movimento.",
         "Um inimigo entra no seu alcance interno.", "Você fica Exausto ou Sob Pressão com o esforço."],
        bonus="+2",
    ),
}

# ============================================================ MANOPLA
ARMAS["Manopla"] = {
    "atributo_abrev": "COR",
    "marca": "Arma de contato direto, aderência e controle físico; ela fica forte quando a cena vira disputa de pegada e proximidade.",
    "move_a": mv(
        "Pegada", "Corpo",
        "Quando você decidir que a troca vira corpo a corpo para controlar o inimigo, não para matar, role +Corpo.",
        ["Você captura o alvo sem matar.", "Você causa dano no alvo.", "Você desarma o alvo.",
         "Você nega a próxima reação do alvo.", "Você mantém o controle sem sofrer dano."],
        ["Você causa dano no alvo.", "Você controla o alvo, mas apanha junto.", "Você atrapalha a próxima ação do alvo.",
         "Você mantém a pegada por um instante.", "Você fica preso na troca."],
        ["O alvo escapa da sua pegada.", "Você apanha mais do que consegue controlar.", "O inimigo usa sua proximidade contra você.",
         "Você fica preso numa posição ruim.", "Um segundo inimigo aproveita a abertura."],
    ),
    "golpe_2": mv(
        "Golpe de Aderência", "Corpo",
        "Quando você golpear segurando firme o inimigo para não deixar ele se soltar do impacto, role +Corpo.",
        ["Você causa dano aumentado.", "Você derruba o alvo.", "Você impede o alvo de recuar.",
         "Você deixa o alvo Abalado.", "Você mantém a pegada firme para o próximo golpe."],
        ["Você causa dano no alvo.", "Você impede parcialmente o recuo do alvo.", "Você atrapalha a próxima ação do alvo.",
         "Você mantém a pressão física.", "Você fica exposto ao manter a pegada."],
        ["O alvo se solta antes do golpe.", "Seu golpe perde força.", "Você fica preso numa posição desfavorável.",
         "O inimigo usa a proximidade para revidar.", "Você fica Sob Pressão pelo esforço físico."],
    ),
    "limit_breaker": mv(
        "Domínio Absoluto", "Corpo",
        "Quando você usar toda sua força física para imobilizar completamente o inimigo, sem deixar nenhuma chance de reação, role +Corpo +2.",
        ["Você imobiliza o alvo por completo.", "Você causa dano aumentado no alvo.", "Você desarma o alvo.",
         "Você nega qualquer reação do alvo durante a manobra.", "Você mantém o controle sem sofrer dano."],
        ["Você causa dano no alvo.", "Você imobiliza o alvo por um instante.", "Você controla o alvo, mas apanha junto.",
         "Você atrapalha a próxima ação do alvo.", "Você fica preso na troca."],
        ["O alvo escapa da imobilização.", "Você gasta toda sua força e fica Exausto.", "O inimigo vira a manobra contra você.",
         "Você fica preso numa posição perigosa.", "Um segundo inimigo aproveita a abertura."],
        bonus="+2",
    ),
}

# ================================================================
def sql_str(text):
    return "'" + text.replace("'", "''") + "'"

linhas = []
linhas.append("-- DML: continuação de dml_moves_armas_pdf_pbta.sql — mesmo formato PBTA,")
linhas.append("-- agora pras 10 armas que o PDF do usuário não cobria. Fonte de Marca +")
linhas.append("-- atributo + Move de Combate original: docs/guia_sistema_aincrad.md.")
linhas.append("-- Move 1 = reformatação fiel do Move de Combate canônico pro molde")
linhas.append("-- 10+/7-9/6-; Move 2 = segundo ângulo de combate novo (mesmo atributo,")
linhas.append("-- padrão do PDF); Limit Break = golpe de assinatura novo, +2 no acerto.")
linhas.append("-- Mesmo mapeamento de schema do arquivo anterior: move_a/golpe_2/")
linhas.append("-- limit_breaker preenchidos, move_b/golpe_3 zerados.")
linhas.append("")

for nome, dados in ARMAS.items():
    linhas.append(f"-- {'='*60}")
    linhas.append(f"-- {nome}")
    linhas.append(f"-- {'='*60}")
    linhas.append("UPDATE moves_arma SET")
    linhas.append(f"  atributo = {sql_str(dados['atributo_abrev'])},")
    linhas.append(f"  marca = {sql_str(dados['marca'])},")
    linhas.append(f"  move_a = {sql_str(json.dumps(dados['move_a'], ensure_ascii=False))}::jsonb,")
    linhas.append(f"  move_b = null,")
    linhas.append(f"  golpe_2 = {sql_str(json.dumps(dados['golpe_2'], ensure_ascii=False))}::jsonb,")
    linhas.append(f"  golpe_3 = null,")
    linhas.append(f"  limit_breaker = {sql_str(json.dumps(dados['limit_breaker'], ensure_ascii=False))}::jsonb,")
    linhas.append("  visivel = true,")
    linhas.append("  updated_at = now()")
    linhas.append(f"WHERE nome = {sql_str(nome)};")
    linhas.append("")

saida = "\n".join(linhas)
if len(sys.argv) > 1:
    with open(sys.argv[1], "w", encoding="utf-8") as f:
        f.write(saida + "\n")
else:
    sys.stdout.buffer.write(saida.encode("utf-8"))
