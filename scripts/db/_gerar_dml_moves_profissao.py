"""
Aplica o Move Exclusivo (SAO_PBTA_Profissoes_e_Moves.pdf, "1 move
exclusivo" por profissão, 10+ escolha 2 / 7-9 escolha 1 / 6- narrado)
em moves_profissao.move_c — slot que docs/guia_sistema_aincrad.md já
reservava ("cada profissão... concede um Move Exclusivo", além do Move
de Ofício e Move de Cena que já moram em move_a/move_b).

Reforma de roster pedida pelo usuário (12/08):
  - Bibliotecário + Diplomata unificam em Informante (Conhecimento) —
    linhas antigas ficam visivel=false (retiradas do roster ativo, não
    apagadas: personagem que já tem essa profissão não quebra).
  - Coveiro sai (funções vão pro Mercenário) — visivel=false também.
  - Entram Mestre de Montarias (Técnica) e Minerador (Corpo), linhas
    novas via INSERT ... ON CONFLICT (upsert) com Marca + Move de
    Ofício + Move de Cena escritos no mesmo formato do resto do doc
    (2d6+Atributo, resultado simples de 10+ e de 7-9, sem lista/6-)
    já que o PDF só trouxe o Move Exclusivo, não o move set completo.

12 profissões que já existiam e o PDF cobre (Alquimista, Caçador,
Comerciante, Costureiro, Cozinheiro, Domador, Ferreiro, Joalheiro,
Lenhador, Médico, Mercenário, Músico) só recebem UPDATE de move_c —
nome/atributo/marca/move_a/move_b ficam como já estavam no banco.

Rode: python scripts/db/_gerar_dml_moves_profissao.py scripts/db/dml_moves_profissao_pbta.sql
"""
import json
import sys

def mv(nome, atributo, gatilho, dez_mais, sete_nove, seis_menos):
    return {
        "nome": nome, "atributo": atributo, "gatilho": gatilho,
        "dez_mais": dez_mais, "sete_nove": sete_nove, "seis_menos": seis_menos,
    }

def mv_simples(nome, atributo, gatilho, dez_mais, sete_nove):
    # Move de Ofício / Move de Cena — formato mais simples já usado no
    # resto do doc canônico (resultado em prosa, sem lista nem 6-).
    return {"nome": nome, "atributo": atributo, "gatilho": gatilho, "dez_mais": dez_mais, "sete_nove": sete_nove}

# ================================================================
# 12 profissões existentes — só move_c (Move Exclusivo do PDF)
# ================================================================
MOVE_C = {}

MOVE_C["Alquimista"] = mv(
    "Mistura Perfeita", "Conhecimento",
    "Quando você combinar ingredientes e seguir uma fórmula para criar um preparado alquímico, descreva o efeito desejado e role +Conhecimento.",
    ["Você produz duas doses do preparado em vez de uma.", "O efeito é mais potente ou dura mais tempo que o normal.",
     "Você utiliza menos ingredientes e preserva parte dos materiais.",
     "O preparado remove uma condição apropriada, como Ferido, Amedrontado, Paralisado, Exausto ou Sob Pressão.",
     "Você descobre uma melhoria para a fórmula e recebe +1 na próxima vez que produzir esse preparado."],
    ["Você cria uma dose com o efeito desejado.", "O preparado funciona, mas possui duração reduzida.",
     "Você cria o item, mas consome ingredientes adicionais.", "O efeito é mais fraco, porém não apresenta riscos ao usuário.",
     "Você identifica um ingrediente que pode melhorar essa fórmula futuramente."],
    ["A mistura produz um efeito diferente ou imprevisível.", "Os ingredientes são desperdiçados durante o processo.",
     "O preparado funciona, mas causa uma condição ou complicação temporária.",
     "A reação alquímica chama atenção, produz fumaça ou provoca uma pequena explosão.",
     "A fórmula exige um ingrediente raro, uma ferramenta específica ou conhecimento ainda desconhecido."],
)

MOVE_C["Caçador"] = mv(
    "Mestre da Caçada", "Reflexo",
    "Quando você rastrear uma criatura, pescar, preparar uma armadilha ou procurar recursos naturais, descreva sua abordagem e role +Reflexo.",
    ["Você encontra rapidamente a criatura, recurso ou local que estava procurando.",
     "Você obtém uma quantidade adicional de carne, peixe, pele, madeira, ervas ou outro recurso apropriado.",
     "Você encontra uma espécie, ingrediente ou material raro.",
     "Você identifica um perigo, fraqueza ou padrão de comportamento antes que ele se torne uma ameaça.",
     "Você prepara uma armadilha ou abordagem que lhe concede +1 na próxima ação contra a presa."],
    ["Você encontra o que procura, mas demora mais do que esperava.",
     "Você consegue recursos suficientes, porém gasta ou danifica parte de seu equipamento.",
     "Você encontra a presa, mas ela percebe sua presença.", "Sua armadilha funciona, mas apenas por alguns instantes.",
     "Você encontra algo raro, mas recuperá-lo exige entrar em uma posição perigosa."],
    ["Você segue rastros falsos e entra no território de outra criatura.", "Sua linha, armadilha ou equipamento quebra ou fica preso.",
     "A presa percebe você primeiro e prepara uma emboscada.", "Você encontra o recurso desejado, mas ele está protegido por uma criatura perigosa.",
     "Você se perde, fica isolado ou acaba Sob Pressão em uma região selvagem."],
)

MOVE_C["Comerciante"] = mv(
    "Negociação Perfeita", "Conhecimento",
    "Quando você negociar a compra, venda ou troca de um item, serviço ou informação, explique sua proposta e role +Conhecimento.",
    ["Você consegue um preço muito melhor do que o inicialmente oferecido.", "O acordo inclui um item, serviço ou benefício adicional.",
     "Você descobre o verdadeiro valor ou a raridade da mercadoria negociada.", "O vendedor ou comprador passa a considerá-lo um contato confiável.",
     "Você percebe uma intenção escondida, golpe ou informação importante durante a negociação."],
    ["Você consegue um pequeno desconto ou lucro adicional.", "O acordo é concluído, mas exige uma condição ou favor.",
     "Você descobre uma informação útil sobre o mercado ou sobre a mercadoria.", "Você evita ser enganado, embora não consiga melhorar o preço.",
     "Você cria uma oportunidade para negociar novamente com essa pessoa no futuro."],
    ["A outra parte aumenta o preço ou diminui o valor oferecido.", "Você aceita uma condição desfavorável sem perceber imediatamente.",
     "A mercadoria apresenta um defeito, falsificação ou problema oculto.", "A negociação ofende alguém influente ou chama atenção indesejada.",
     "O acordo só será possível mediante um pagamento adicional, missão ou favor perigoso."],
)

MOVE_C["Costureiro"] = mv(
    "Mestre dos Tecidos", "Técnica",
    "Quando você confeccionar, reparar ou aprimorar uma peça de roupa, armadura leve ou equipamento de tecido, descreva o resultado desejado e role +Técnica.",
    ["A peça concede +1 em uma situação específica, definida durante a criação.", "A roupa protege seu usuário de uma condição apropriada uma vez.",
     "Você adiciona um compartimento oculto capaz de guardar um item pequeno.",
     "A peça fica especialmente resistente e ignora a primeira vez que seria rasgada ou danificada.",
     "Você utiliza os materiais com eficiência e preserva parte deles para outro trabalho."],
    ["Você cria ou repara completamente a peça desejada.", "A roupa oferece uma pequena vantagem narrativa em uma situação específica.",
     "Você adiciona um bolso ou suporte para carregar um item pequeno.", "A peça fica resistente, mas exige manutenção após uma situação perigosa.",
     "Você identifica o material necessário para realizar um aprimoramento melhor futuramente."],
    ["A peça fica com um ponto frágil que pode se romper no pior momento.", "Você desperdiça parte dos tecidos ou materiais utilizados.",
     "O equipamento fica desconfortável e deixa seu usuário Sob Pressão durante uma situação exigente.",
     "O trabalho exige um material raro, ferramenta especial ou molde específico.",
     "A peça funciona, mas apresenta uma característica indesejada escolhida pelo Mestre."],
)

MOVE_C["Cozinheiro"] = mv(
    "Banquete Revigorante", "Conhecimento",
    "Quando você preparar uma refeição completa para o grupo usando ingredientes adequados, descreva o prato e role +Conhecimento.",
    ["Todos que participarem da refeição recuperam 1 PV.", "Cada participante pode remover uma condição entre Amedrontado, Exausto ou Sob Pressão.",
     "Os participantes recebem +1 na próxima ação relacionada ao desafio para o qual a refeição foi preparada.",
     "A comida rende porções adicionais que podem ser guardadas para depois.",
     "Você utiliza os ingredientes com eficiência e preserva parte dos materiais usados."],
    ["Um participante recupera 1 PV.", "Cada participante pode remover a condição Exausto ou Sob Pressão.",
     "Os participantes recebem uma pequena vantagem narrativa na próxima jornada ou combate.",
     "A refeição rende uma porção adicional para ser consumida depois.", "Você identifica um ingrediente capaz de melhorar essa receita futuramente."],
    ["A refeição não produz o efeito revigorante esperado.", "Parte dos ingredientes é desperdiçada ou estraga durante o preparo.",
     "A comida causa desconforto e deixa alguém Sob Pressão.", "O cheiro do banquete atrai monstros, jogadores ou visitantes indesejados.",
     "A receita exige um ingrediente raro, utensílio especial ou conhecimento ainda desconhecido."],
)

MOVE_C["Domador"] = mv(
    "Ovo de Fera", "Técnica",
    "Quando você encontrar, cuidar ou tentar chocar um ovo de criatura, descreva como prepara o ambiente e role +Técnica.",
    ["O ovo choca com segurança e a criatura nasce saudável.", "A fera reconhece você como seu cuidador e cria um vínculo imediato.",
     "Você descobre uma habilidade, necessidade ou característica especial da criatura.",
     "A criatura nasce com uma qualidade incomum, definida junto ao Mestre.",
     "Você preserva os materiais e recursos utilizados durante os cuidados."],
    ["O ovo choca, mas a criatura exige cuidados constantes por algum tempo.",
     "A fera aceita sua presença, porém ainda precisa conquistar sua confiança.",
     "Você identifica o alimento, ambiente ou tratamento necessário para o ovo.",
     "A criatura nasce saudável, mas assustada ou difícil de controlar.",
     "Você consegue estabilizar o ovo, impedindo que ele seja perdido ou danificado."],
    ["O ovo não choca e precisa de um local, item ou condição especial.", "A criatura nasce agressiva, assustada ou desconfiada.",
     "O processo chama a atenção da mãe da fera ou de outros monstros.", "O ovo apresenta uma doença, maldição ou característica inesperada.",
     "A criatura cria vínculo com outra pessoa ou foge logo após nascer."],
)

MOVE_C["Ferreiro"] = mv(
    "Forja Suprema", "Técnica",
    "Quando você forjar, reparar ou aprimorar uma arma, armadura ou equipamento metálico, descreva o resultado desejado e role +Técnica.",
    ["O equipamento recebe +1 em uma situação específica, definida durante a criação.",
     "O item fica reforçado e ignora a primeira vez que seria quebrado ou danificado.",
     "A arma atravessa uma proteção ou guarda resistente uma vez.", "A armadura protege seu usuário de uma condição apropriada uma vez.",
     "Você trabalha com eficiência e preserva parte dos materiais utilizados."],
    ["Você cria ou repara completamente o equipamento desejado.", "O item recebe uma pequena vantagem narrativa relacionada à sua função.",
     "O equipamento fica reforçado, mas precisará de manutenção após uma situação perigosa.",
     "Você conclui o trabalho, mas consome materiais ou tempo adicionais.",
     "Você identifica o material necessário para realizar um aprimoramento superior futuramente."],
    ["O equipamento fica com um ponto frágil que pode falhar no pior momento.", "Parte dos metais ou materiais é perdida durante a forja.",
     "O item fica pesado, desconfortável ou difícil de manusear.", "O trabalho exige um minério raro, ferramenta especial ou forja mais avançada.",
     "O equipamento funciona, mas possui uma falha ou característica indesejada escolhida pelo Mestre."],
)

MOVE_C["Joalheiro"] = mv(
    "Lapidação Encantada", "Técnica",
    "Quando você trabalhar uma pedra preciosa ou joia para criar, reparar ou aprimorar um acessório, descreva o resultado desejado e role +Técnica.",
    ["O acessório concede +1 em uma situação específica, definida durante a criação.",
     "A joia pode armazenar o efeito de um cristal consumível para ser ativado uma vez.",
     "O acessório protege seu usuário de uma condição específica uma vez.", "A criação possui grande valor e pode ser vendida por um preço elevado.",
     "O acessório revela uma propriedade especial ou oculta do material utilizado."],
    ["O acessório funciona, mas seu efeito pode ser usado apenas uma vez.",
     "A criação concede uma pequena vantagem narrativa em uma situação específica.",
     "O item fica valioso, embora não possua nenhum efeito especial.", "Você repara completamente uma joia ou acessório danificado.",
     "Você identifica o material necessário para concluir o aprimoramento desejado."],
    ["A pedra preciosa quebra ou perde parte de seu valor.", "O acessório funciona de maneira instável ou imprevisível.",
     "Você precisa de um material raro para terminar o trabalho.", "A criação fica marcada por uma falha que pode aparecer no pior momento.",
     "O processo consome mais materiais, dinheiro ou tempo do que o esperado."],
)

MOVE_C["Lenhador"] = mv(
    "Força da Floresta", "Reflexo",
    "Quando você explorar uma área florestal, derrubar uma árvore ou coletar madeira usando movimentos rápidos e precisos, descreva seu método e role +Reflexo.",
    ["Você obtém uma quantidade adicional de madeira ou materiais vegetais.",
     "Você encontra madeira rara, resistente ou apropriada para uma criação especial.",
     "Você conclui o trabalho rapidamente, antes que algum perigo se aproxime.",
     "Você realiza cortes precisos e preserva completamente suas ferramentas.",
     "Você identifica um caminho seguro, abrigo natural ou recurso útil nas proximidades."],
    ["Você obtém a quantidade de madeira necessária.", "Você termina o trabalho rapidamente, mas faz bastante barulho.",
     "Você encontra um material especial, porém em pequena quantidade.", "Você preserva a qualidade da madeira, mas desgasta sua ferramenta.",
     "Você percebe um perigo próximo antes que ele alcance o grupo."],
    ["A árvore cai em uma direção perigosa ou bloqueia uma passagem importante.",
     "O barulho atrai monstros, jogadores ou criaturas territoriais.", "A madeira coletada está podre, infestada ou possui qualidade inferior.",
     "Sua ferramenta fica presa, perde o fio ou sofre algum dano.",
     "Você encontra uma árvore rara, mas ela está em um local perigoso ou protegida por uma criatura."],
)

MOVE_C["Médico"] = mv(
    "O Salva-Vidas", "Espírito",
    "Quando você prestar atendimento imediato a alguém ferido, inconsciente ou em estado crítico, descreva como realiza o tratamento e role +Espírito.",
    ["O paciente recupera 1 PV.",
     "Você remove uma condição entre Ferido, Abalado, Paralisado, Exausto ou Sob Pressão, desde que o tratamento seja adequado.",
     "Você estabiliza completamente o paciente, impedindo que sua situação piore.",
     "Você identifica a causa do ferimento, doença ou condição e descobre como tratá-la definitivamente.",
     "O paciente recebe +1 na próxima ação após recuperar-se do atendimento."],
    ["O paciente recupera 1 PV, mas você consome materiais médicos.",
     "Você remove uma condição apropriada, mas o paciente fica Exausto após o tratamento.",
     "Você estabiliza o paciente, porém ele ainda precisa de repouso ou cuidados posteriores.",
     "Você reduz os efeitos do ferimento ou condição temporariamente.",
     "Você identifica o tratamento necessário, mas precisa de um remédio, ferramenta ou ingrediente específico."],
    ["O estado do paciente piora durante o atendimento.", "Você interrompe o perigo imediato, mas uma nova condição aparece.",
     "Seus medicamentos ou materiais acabam no pior momento.", "O tratamento exige um item raro, cirurgia ou ajuda especializada.",
     "A pressão da situação deixa você Abalado ou Sob Pressão."],
)

MOVE_C["Mercenário"] = mv(
    "Profissional da Missão", "Corpo",
    "Quando você assumir um trabalho perigoso, proteger alguém, recuperar um corpo ou pertences, ou enfrentar um obstáculo diretamente ligado a um contrato, descreva sua abordagem e role +Corpo.",
    ["Você avança diretamente em direção ao objetivo da missão.", "Você protege um aliado das consequências imediatas da ação.",
     "Você neutraliza uma ameaça ou obstáculo durante o avanço.", "Você recupera com segurança um corpo, equipamento ou item importante.",
     "Você examina a cena e descobre uma pista importante sobre o que aconteceu ali."],
    ["Você conclui uma parte importante da missão, mas surge uma nova complicação.",
     "Você protege alguém, porém fica exposto no lugar dele.",
     "Você recupera o corpo ou item desejado, mas precisa abandonar outra coisa para carregá-lo.",
     "Você identifica uma pista sobre a morte ou desaparecimento, mas ela aponta para um perigo maior.",
     "Você supera o obstáculo, mas consome equipamento, tempo ou recursos importantes."],
    ["O contratante escondeu uma informação importante sobre o trabalho.", "O corpo ou item que você procura não está onde deveria estar.",
     "Algo relacionado aos mortos revela uma ameaça inesperada.", "Você fica cercado, isolado ou Sob Pressão durante a missão.",
     "Cumprir o contrato exige uma escolha difícil entre o objetivo, sua segurança ou a de um aliado."],
)

MOVE_C["Músico"] = mv(
    "A Melodia Inspiradora", "Espírito",
    "Quando você tocar ou cantar para inspirar seus companheiros antes ou durante uma situação perigosa, descreva sua apresentação e role +Espírito.",
    ["Um aliado que ouvir a melodia recebe +1 na próxima ação.", "Você remove a condição Amedrontado, Abalado ou Sob Pressão de um aliado.",
     "Você inspira todo o grupo, permitindo que cada aliado escolha quem agirá primeiro na próxima troca.",
     "Um aliado recupera a coragem e pode agir imediatamente apesar do medo ou hesitação.",
     "Sua apresentação chama a atenção para você, permitindo que um aliado se reposicione sem ser percebido."],
    ["Um aliado recebe +1 na próxima ação, mas o benefício deve ser usado imediatamente.",
     "Você reduz temporariamente os efeitos de Amedrontado, Abalado ou Sob Pressão.",
     "Você encoraja um aliado a continuar, impedindo que ele recue ou desista naquele momento.",
     "Você distrai um inimigo por alguns instantes e cria uma abertura para o grupo.",
     "Você fortalece o moral do grupo, mas fica Sob Pressão ao sustentar a apresentação."],
    ["Sua música atrai monstros, jogadores ou visitantes indesejados.", "A apresentação não combina com o momento e aumenta a tensão do grupo.",
     "Um inimigo percebe sua importância e passa a considerá-lo o principal alvo.", "Seu instrumento sofre algum dano ou precisa de manutenção.",
     "Você absorve as emoções negativas da situação e fica Abalado ou Sob Pressão."],
)

# ================================================================
# 3 profissões novas — linha completa (Marca + Ofício + Cena + Exclusivo)
# ================================================================
NOVAS = {}

NOVAS["Informante"] = {
    "atributo_abrev": "CON",
    "marca": "Você é rede e memória ao mesmo tempo; gente te procura por nome, por rumor e por dívida a cobrar.",
    "move_a": mv_simples(
        "Pesquisa com Fonte", "Conhecimento",
        "Quando você pesquisa um monstro, item, pessoa ou evento com fonte real (registro, arquivo, testemunha), role +Conhecimento.",
        "o mestre revela um detalhe crítico e útil.",
        "revela uma parte, mas cobra tempo, favor ou exposição.",
    ),
    "move_b": mv_simples(
        "Contato Certo", "Conhecimento",
        "Quando você aciona um contato ou puxa conversa pra conseguir algo que só gente por dentro sabe, role +Conhecimento.",
        "o mestre te dá a pessoa, o lugar ou a informação certa.",
        "te dá, mas o contato cobra favor, silêncio ou exposição.",
    ),
    "move_c": mv(
        "Rede de Informações", "Conhecimento",
        "Quando você pesquisar registros, consultar contatos, ouvir rumores ou negociar por uma informação importante, diga o que deseja descobrir e role +Conhecimento.",
        ["Você descobre exatamente a informação que estava procurando.", "Você descobre uma informação adicional relacionada ao assunto.",
         "Você identifica quem está escondendo algo, mentindo ou manipulando a situação.",
         "Você descobre onde encontrar uma pessoa, item, local ou objetivo relacionado.",
         "Você estabelece um contato útil e recebe +1 na próxima interação relacionada à informação obtida."],
        ["Você consegue uma informação útil, mas incompleta.", "Você descobre quem possui a resposta completa.",
         "Você consegue a informação, mas precisa pagar, prometer um favor ou oferecer algo em troca.",
         "Você encontra uma pista importante, embora ainda precise investigá-la.",
         "Você evita ser enganado, mas percebe que alguém está observando suas perguntas."],
        ["A informação recebida está errada, desatualizada ou foi plantada de propósito.",
         "Suas perguntas chamam a atenção de alguém perigoso.", "Seu contato exige um favor complicado antes de ajudar.",
         "Você descobre algo importante, mas a informação coloca você ou seus aliados em perigo.",
         "A pessoa que possui a resposta desapareceu, foi capturada ou está em um local de difícil acesso."],
    ),
}

NOVAS["Mestre de Montarias"] = {
    "atributo_abrev": "TEC",
    "marca": "Você anda lado a lado com uma fera maior que você; isso muda como o mundo te vê — respeito, medo ou cobiça.",
    "move_a": mv_simples(
        "Doma de Montaria", "Técnica",
        "Quando você tenta acalmar, domesticar ou treinar uma criatura pra servir como montaria, role +Técnica.",
        "a criatura aceita você e obedece um comando simples.",
        "aceita, mas exige alimento, cuidado ou paciência antes de confiar de verdade.",
    ),
    "move_b": mv_simples(
        "Conduzir na Pressão", "Técnica",
        "Quando sua montaria precisa atravessar perigo, terreno ruim ou pânico sem quebrar a formação, role +Técnica.",
        "ela atravessa firme e o grupo não perde tempo nem recurso.",
        "atravessa, mas o esforço cobra — ela se cansa, se machuca ou assusta.",
    ),
    "move_c": mv(
        "O Domesticador", "Técnica",
        "Quando você tentar acalmar, domesticar ou treinar uma criatura para servir como montaria, descreva sua abordagem e role +Técnica.",
        ["A criatura aceita você como cavaleiro e permite ser montada.",
         "Você ensina a montaria um comando simples, como avançar, parar, seguir ou proteger.",
         "Você identifica as necessidades, medos e preferências da criatura.",
         "A montaria permanece calma mesmo diante de perigos ou ambientes difíceis.",
         "Você cria um vínculo forte e recebe +1 na próxima ação realizada junto da montaria."],
        ["A criatura permite ser montada, mas apenas por você.", "A montaria obedece a um comando simples, porém ainda demonstra resistência.",
         "Você acalma a criatura, mas precisa oferecer alimento, cuidado ou descanso.",
         "Você descobre o que é necessário para conquistar definitivamente sua confiança.",
         "A criatura acompanha o grupo, mas foge caso seja muito assustada ou ferida."],
        ["A criatura se assusta, reage agressivamente ou tenta fugir.", "A montaria aceita outra pessoa como cavaleiro em vez de você.",
         "O processo chama a atenção de uma criatura dominante ou de seu antigo dono.",
         "A criatura exige uma sela, alimento raro ou treinamento especial antes de ser montada.",
         "A montaria parece domesticada, mas perde o controle no pior momento."],
    ),
}

NOVAS["Minerador"] = {
    "atributo_abrev": "COR",
    "marca": "Você é o que desce onde os outros não vão; gente confia em você pra achar o que está fundo demais pra ser fácil.",
    "move_a": mv_simples(
        "Escavação", "Corpo",
        "Quando você escava rocha, abre um túnel ou extrai minério usando força e resistência, role +Corpo.",
        "você extrai o que precisa sem desgastar ferramenta nem se expor.",
        "extrai, mas perde tempo, desgasta a ferramenta ou desperta algo.",
    ),
    "move_b": mv_simples(
        "Leitura de Veio", "Corpo",
        "Quando você examina uma parede rochosa, mina ou formação antes de decidir onde cavar, role +Corpo.",
        "o mestre te diz onde está o melhor material e o perigo mais próximo.",
        "diz uma das duas coisas, não as duas.",
    ),
    "move_c": mv(
        "Escavador das Profundezas", "Corpo",
        "Quando você escavar uma parede rochosa, explorar uma mina ou extrair minério usando sua força e resistência, descreva seu método e role +Corpo.",
        ["Você encontra uma quantidade adicional de minério ou pedra útil.", "Você descobre um minério raro, cristal ou material especial.",
         "Você abre uma passagem segura para o grupo atravessar.", "Você conclui a escavação sem desgastar suas ferramentas.",
         "Você identifica antecipadamente uma ameaça subterrânea, como desabamento, gás ou criatura escondida."],
        ["Você consegue extrair a quantidade de minério necessária.", "Você encontra um material especial, mas em pequena quantidade.",
         "Você abre uma passagem estreita ou instável.", "Você evita um perigo imediato, mas perde tempo ou recursos.",
         "Você conclui o trabalho, porém sua ferramenta fica desgastada e precisará de manutenção."],
        ["A escavação provoca um desabamento ou bloqueia a passagem.", "O barulho desperta monstros ou criaturas subterrâneas.",
         "Sua ferramenta quebra, fica presa ou perde sua utilidade.", "Você encontra uma região com gás, calor ou outro perigo natural.",
         "Você descobre um minério valioso, mas ele está em uma área instável, profunda ou protegida."],
    ),
}

# ================================================================
def sql_str(text):
    return "'" + text.replace("'", "''") + "'"

linhas = []
linhas.append("-- DML: reforma de profissões (12/08) — Move Exclusivo (PDF) +")
linhas.append("-- unificação de roster. Ver dolist/19_backlog_profissoes_e_balanceamento.md")
linhas.append("-- e docs/guia_sistema_aincrad.md (seção Profissões, atualizada junto).")
linhas.append("")
linhas.append("-- 1) 12 profissões existentes: só ganham o Move Exclusivo (move_c).")
linhas.append("--    nome/atributo/marca/move_a/move_b ficam como já estavam no banco.")
linhas.append("")

for nome, move_c in MOVE_C.items():
    linhas.append(f"UPDATE moves_profissao SET move_c = {sql_str(json.dumps(move_c, ensure_ascii=False))}::jsonb, "
                  f"visivel = true, updated_at = now() WHERE nome = {sql_str(nome)};")
linhas.append("")

linhas.append("-- 2) Bibliotecário, Diplomata e Coveiro saem do roster ativo (visivel=false).")
linhas.append("--    Não apaga — personagem que já tem essa profissão continua com a ficha")
linhas.append("--    intacta, só some do dropdown de personagem novo (ver PROFISSOES em")
linhas.append("--    tabelasAdmin.js) e do compêndio público.")
for nome in ["Bibliotecário", "Diplomata", "Coveiro"]:
    linhas.append(f"UPDATE moves_profissao SET visivel = false, updated_at = now() WHERE nome = {sql_str(nome)};")
linhas.append("")

linhas.append("-- 3) 3 profissões novas: linha completa (upsert — não deve existir ainda,")
linhas.append("--    mas por segurança não quebra se alguém já tiver criado a linha).")
for nome, dados in NOVAS.items():
    linhas.append(f"-- {'='*60}")
    linhas.append(f"-- {nome}")
    linhas.append(f"-- {'='*60}")
    linhas.append("INSERT INTO moves_profissao (nome, atributo, marca, move_a, move_b, move_c, visivel, updated_at)")
    linhas.append("VALUES (")
    linhas.append(f"  {sql_str(nome)},")
    linhas.append(f"  {sql_str(dados['atributo_abrev'])},")
    linhas.append(f"  {sql_str(dados['marca'])},")
    linhas.append(f"  {sql_str(json.dumps(dados['move_a'], ensure_ascii=False))}::jsonb,")
    linhas.append(f"  {sql_str(json.dumps(dados['move_b'], ensure_ascii=False))}::jsonb,")
    linhas.append(f"  {sql_str(json.dumps(dados['move_c'], ensure_ascii=False))}::jsonb,")
    linhas.append("  true, now()")
    linhas.append(")")
    linhas.append("ON CONFLICT (nome) DO UPDATE SET")
    linhas.append("  atributo = excluded.atributo, marca = excluded.marca,")
    linhas.append("  move_a = excluded.move_a, move_b = excluded.move_b, move_c = excluded.move_c,")
    linhas.append("  visivel = true, updated_at = now();")
    linhas.append("")

saida = "\n".join(linhas)
if len(sys.argv) > 1:
    with open(sys.argv[1], "w", encoding="utf-8") as f:
        f.write(saida + "\n")
else:
    sys.stdout.buffer.write(saida.encode("utf-8"))
