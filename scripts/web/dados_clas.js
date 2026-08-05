/* Registro de Clãs e Reputação. Fonte completa: docs/registro_clas_e_reputacao.md
   Regra de mesa: depois de cada sessão, atualize só "ganhou", "perdeu", "quem
   ficou devendo" e "como o povo está falando deles". */
var CLAS=[
  {
    nome:"Sindicato dos Ossos",
    destaque:true,
    forca:"sobrevivência, extração e resgate sem bandeira",
    necessidade:"crescer sem virar propaganda",
    rival:"Dndalcin",
    rumor:"ninguém sabe quem manda, e isso assusta mais que saber",
    status:"ativo",
    resumo:"sobrevivência antes de bandeira — e uma liderança que ninguém nunca viu perder o controle.",
    bons:"extração sob pressão, leitura de risco, resgate de gente cercada, fechar o que sobra de quem não voltou.",
    precisa:"crescer sem virar propaganda — cada resgate vira história contada errado.",
    naoAdmitem:"desconfiam que a própria liderança sabe fazer sozinha o que jurou nunca pedir a ninguém do clã.",
    proximo:"sobreviventes de guildas que explodiram por dentro, ex-beta testers com culpa, quem só quer voltar vivo — muitos recrutados pessoalmente depois de serem recusados por outro clã.",
    atravessado:"Dndalcin (os dois clãs \"resolvem sozinhos\" e acabam competindo pelo mesmo problema); LHUB (lealdade jurada vs. autonomia radical).",
    quests:"extração sob prazo, resgate sem apoio institucional, decisão às cegas onde confiar errado mata, \"limpar\" algo que a cidade finge não ver.",
    aparecem:"sem uniforme fixo — reconhecidos por um pequeno emblema de ossos cruzados amarrados por um nó, entalhado no cabo da arma ou costurado discreto na roupa. Ninguém do clã fica sempre no centro do grupo; estão um passo atrás, olhando a saída.",
    simbolo:"Dois fragmentos de osso rachados, cruzados e amarrados por um nó de corda — não um osso inteiro, um osso quebrado que foi consertado.",
    reputacao:[
      {frente:"Cidade do Início",estado:"temidos e respeitados — ninguém sabe ao certo quem manda"},
      {frente:"Tolbana",estado:"usados como último recurso, ninguém confia de primeira"},
      {frente:"Kaldrin",estado:"disputam o vácuo de poder sem querer virar governo"},
      {frente:"Mercado",estado:"pagam em item, não em Col"},
      {frente:"Labirinto",estado:"os primeiros a saber quando algo deu errado lá dentro"},
      {frente:"Outros clãs",estado:"necessários, mas incômodos"}
    ],
    ganchos:[
      {tipo:"Favor",texto:"tiraram alguém de uma emboscada e nunca cobraram na hora — ninguém sabe até onde essa dívida vai"},
      {tipo:"Erro",texto:"recusaram salvar alguém \"que não valia o risco\" — a família está em Kaldrin agora, perguntando por nome"},
      {tipo:"Rumor",texto:"um Orange conhecido sumiu do mapa sem luta registrada — ninguém do clã assume, ninguém nega"},
      {tipo:"Oportunidade",texto:"o grupo descobre, ao vivo, que alguém do clã fez algo que contraria tudo que eles pregam em público"}
    ]
  },
  {
    nome:"LHUB",
    forca:"lealdade interna e confiabilidade",
    necessidade:"manter coesão sem ficar lento",
    rival:"iBarr's",
    rumor:"são chatos, mas cumprem",
    status:"ativo",
    resumo:"laço forte, lealdade e espírito de família.",
    bons:"cooperação, suporte entre membros, sustentação de grupo e confiança em campo.",
    precisa:"provar que laço forte não significa lentidão nem excesso de sentimentalismo.",
    naoAdmitem:"que estão começando a sentir o peso de proteger gente demais.",
    proximo:"jogadores que preferem segurança humana a brilho; parte do Sindicato dos Ossos em operações sérias.",
    atravessado:"iBarr's, quando a impressão é de improviso irresponsável.",
    quests:"resgate, defesa de vila, escolta humana, recuperação, apoio pós-crise.",
    aparecem:"gente se chama pelo nome, divide carga, fecha círculo e percebe ausência rápido.",
    reputacao:[
      {frente:"Cidade do Início",estado:"queridos por novatos assustados"},
      {frente:"Tolbana",estado:"vistos como confiáveis, não como glamourosos"},
      {frente:"Kaldrin",estado:"respeitados"},
      {frente:"Mercado",estado:"honestos, pouco agressivos"},
      {frente:"Labirinto",estado:"seguros, conservadores"},
      {frente:"Outros clãs",estado:"bons aliados, difíceis de dobrar"}
    ],
    ganchos:[
      {tipo:"Favor",texto:"acolhimento dado num momento ruim"},
      {tipo:"Erro",texto:"salvaram a pessoa errada para a política do momento"},
      {tipo:"Rumor",texto:"protegem tanto os seus que escondem falha interna"},
      {tipo:"Oportunidade",texto:"resgate ou proteção onde outro clã falharia por ego"}
    ]
  },
  {
    nome:"Dndalcin",
    forca:"exploração de alto risco e combate",
    necessidade:"garantir supremacia em conteúdo perigoso",
    rival:"Sindicato dos Ossos",
    rumor:"já estão olhando longe demais para o norte",
    status:"ativo",
    resumo:"temidos, respeitados e perigosamente competentes.",
    bons:"exploração de alto risco, combate duro, avanço em área acima da média.",
    precisa:"manter o topo do prestígio sem começar a perder gente em silêncio.",
    naoAdmitem:"que a fama deles cobra um preço humano que nem todos estão pagando bem.",
    proximo:"quem quer resultado rápido e estômago para bancar o custo.",
    atravessado:"Sindicato dos Ossos, disputa por quem resolve sozinho o conteúdo mais perigoso; Guilda de Nerds quando teoria trava ação.",
    quests:"incursão arriscada, ruína funda, prova de valor, ninho, elite.",
    aparecem:"equipamento melhor, voz baixa, pouco sorriso e muita certeza de onde pisar.",
    reputacao:[
      {frente:"Cidade do Início",estado:"admirados e evitados"},
      {frente:"Tolbana",estado:"fortes demais para ignorar"},
      {frente:"Kaldrin",estado:"inspiram e intimidam"},
      {frente:"Mercado",estado:"pagam bem quando precisam, somem quando não"},
      {frente:"Labirinto",estado:"elite emergente"},
      {frente:"Outros clãs",estado:"alvo de inveja e cautela"}
    ],
    ganchos:[
      {tipo:"Favor",texto:"cobertura em área perigosa"},
      {tipo:"Erro",texto:"entraram onde não deviam e agora não contam tudo"},
      {tipo:"Rumor",texto:"estão escolhendo quem vive para manter a fama alta"},
      {tipo:"Oportunidade",texto:"conteúdo que ninguém mais quer assumir em público"}
    ]
  },
  {
    nome:"iBarr's",
    forca:"mobilidade, carisma e improviso",
    necessidade:"provar que entregam tanto quanto prometem",
    rival:"LHUB",
    rumor:"falam bonito e chegam sorrindo demais",
    status:"ativo",
    resumo:"diversão, amizade e improviso com sorriso no rosto.",
    bons:"mobilidade, espírito de grupo, leitura rápida de oportunidade e adaptação.",
    precisa:"provar que o charme deles entrega resultado e não só boa presença.",
    naoAdmitem:"às vezes prometem antes de medir direito o custo.",
    proximo:"grupos menores, jogadores carismáticos, gente cansada do peso dos outros clãs.",
    atravessado:"LHUB, quando o assunto é disciplina e confiança.",
    quests:"corrida, interceptação, busca, infiltração leve, improviso social.",
    aparecem:"chegam falando, puxam energia para cima e parecem mais soltos do que deveriam.",
    reputacao:[
      {frente:"Cidade do Início",estado:"populares"},
      {frente:"Tolbana",estado:"bons para rumor e contato, menos para comando"},
      {frente:"Kaldrin",estado:"vistos com desconfiança divertida"},
      {frente:"Mercado",estado:"negociam bem, pagam mal se deixarem"},
      {frente:"Labirinto",estado:"talentosos, pouco estáveis"},
      {frente:"Outros clãs",estado:"agradáveis até atrapalharem um plano"}
    ],
    ganchos:[
      {tipo:"Favor",texto:"cobertura social ou ajuda em rota rápida"},
      {tipo:"Erro",texto:"venderam confiança cedo demais"},
      {tipo:"Rumor",texto:"estavam no lugar errado antes da confusão certa"},
      {tipo:"Oportunidade",texto:"missão veloz em que timing importa mais que força"}
    ]
  },
  {
    nome:"Terraço Geek",
    forca:"criatividade, tática e clima de grupo",
    necessidade:"parar de ser subestimado fora da própria bolha",
    rival:"Dndalcin",
    rumor:"riem muito até a hora de ganhar",
    status:"ativo",
    resumo:"táticos, criativos e mais perigosos do que a fachada faz parecer.",
    bons:"plano não óbvio, sinergia de grupo, leitura de sistema e solução fora do padrão.",
    precisa:"respeito de clã \"grande\" fora do círculo deles.",
    naoAdmitem:"que transformam piada em escudo quando a tensão aperta.",
    proximo:"gente inteligente demais para gostar de hierarquia rígida; Orin ajuda a aproximar.",
    atravessado:"Dndalcin, quando prestígio de elite atropela solução criativa.",
    quests:"puzzle, rota alternativa, logística criativa, contenção elegante, adaptação de terreno.",
    aparecem:"mesa improvisada, peças de jogo, comida boa, humor interno e plano saindo do lado errado do papel.",
    reputacao:[
      {frente:"Cidade do Início",estado:"subestimados por quem olha pouco"},
      {frente:"Tolbana",estado:"úteis, mas nem sempre levados a sério cedo"},
      {frente:"Kaldrin",estado:"atrito aberto com o Dndalcin"},
      {frente:"Mercado",estado:"compram com propósito, vendem pouco"},
      {frente:"Labirinto",estado:"melhores do que a fama antiga dizia"},
      {frente:"Outros clãs",estado:"amados ou descartados rápido demais"}
    ],
    ganchos:[
      {tipo:"Favor",texto:"solução criativa que salvou operação de outro clã"},
      {tipo:"Erro",texto:"fizeram piada na hora errada com a pessoa errada"},
      {tipo:"Rumor",texto:"sabem de algo do castelo e estão guardando"},
      {tipo:"Oportunidade",texto:"missão onde \"o jeito normal\" não funciona"}
    ]
  },
  {
    nome:"Guilda de Nerds",
    forca:"informação, leitura e planejamento",
    necessidade:"transformar conhecimento em influência real",
    rival:"Dndalcin",
    rumor:"sabem mais do que deviam, fazem menos do que podiam",
    status:"ativo",
    resumo:"intelecto, estratégia, informação e planejamento.",
    bons:"leitura, pesquisa, decifração, preparação e memória de detalhe.",
    precisa:"converter conhecimento em prestígio visível antes que outro clã use melhor o que eles descobriram.",
    naoAdmitem:"às vezes sabem demais para agir e agem de menos para serem lembrados.",
    proximo:"bibliotecários, cartógrafos, corretores, gente que prefere pista a bravata.",
    atravessado:"Dndalcin, quando ação rápida atropela prudência; qualquer um que roube crédito intelectual.",
    quests:"investigação, decifração, busca de documento, ruína escrita, mapa, rumor técnico.",
    aparecem:"caderno, debate, observação lateral, gente anotando o que o resto esqueceria.",
    reputacao:[
      {frente:"Cidade do Início",estado:"discretos, úteis para quem sabe procurar"},
      {frente:"Tolbana",estado:"fontes boas, pouca presença de palco"},
      {frente:"Kaldrin",estado:"respeitados em teoria, pouco temidos"},
      {frente:"Mercado",estado:"bons de valor, fracos de pressão"},
      {frente:"Labirinto",estado:"dependem de companhia para capitalizar o que sabem"},
      {frente:"Outros clãs",estado:"cobiçados por informação, não por força"}
    ],
    ganchos:[
      {tipo:"Favor",texto:"leitura de símbolo, rota ou fraqueza que ajudou outro grupo"},
      {tipo:"Erro",texto:"confiaram na pessoa errada com uma informação certa"},
      {tipo:"Rumor",texto:"estão guardando algo sobre o mural ou o Labirinto"},
      {tipo:"Oportunidade",texto:"prova escrita, marca antiga, sequência de pistas ou preparação de raid"}
    ]
  }
];
