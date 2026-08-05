/* Fichas de jogador da comunidade. Fonte: personagens/*.md
   Página que consome isto: scripts/web/personagens.html (independente do
   compendio_andar1.html — mestre e jogadores são públicos diferentes). */
var PERSONAGENS=[
  {
    nome:"Umbra",
    guilda:"Sindicato dos Ossos",
    arma:"Leque",
    profissao:"Domador",
    conceito:"Domadora que comanda sem tocar. Fala pouco, deixa o leque e o vínculo falarem por ela. Ninguém a leva a sério até a segunda vez que tenta.",
    referencias:"Motoko Kusanagi · Retsu Unohana · Madoka Kaname · Tatsumaki",
    aparencia:"Corpo atlético e cheio, presença física real — não frágil. Cabelo escuro, longo e ondulado, com uma trança fina de um lado e uma mecha branco-osso emoldurando o rosto. Cicatriz fina e antiga atravessando a sobrancelha direita. Roupa de couro funcional em tom violeta escuro e carvão com detalhes branco-osso, cobrindo o tronco por completo. Pequenos nós de osso amarrados no cabo de cada leque.",
    atributos:{tecnica:0,espirito:-1,conhecimento:-1,reflexo:-1,corpo:-2},
    arma_detalhe:{
      marca:"o leque passa elegância, controle de espaço e comando à distância — ela dirige a cena com um gesto, nunca com força.",
      combate:{nome:"Aceno que Comanda",teste:"2d6+Técnica",texto:"guia o golpe de um aliado sem tocar em ninguém. 10+ escolha 1: o aliado acerta sem sofrer reação, você redireciona o ataque de outra pessoa, ou nega a próxima reação do alvo. 7-9 acerta, mas você se expõe, é lida, ou o aliado sofre o troco."},
      utilitario:{nome:"Vento Que Guia",teste:"2d6+Técnica",texto:"usa o ar pra apagar rastro, espalhar fumaça, sinalizar à distância ou acalmar algo agitado. 10+ funciona limpo. 7-9 funciona, mas chama atenção extra."},
      item_inicial:"Leque de Guerra Simples (Comum, sem bônus)",
      progressao:"Leque de Brasa Viva (Incomum, +1 comandar vários aliados) → Leque das Mil Vozes (Raro, comando em grupo + custo de um segredo revelado)"
    },
    profissao_detalhe:{
      marca:"você chega perto do que morde. A mesa inteira para de falar quando você se agacha na frente de um bicho.",
      oficio:{nome:"Doma",teste:"2d6+Técnica",texto:"tenta amansar criando vínculo, não só controle. 10+ avança sem reação violenta e define o tom do vínculo."},
      cena:{nome:"Ordem Clara",teste:"2d6+Técnica",texto:"dá ordem ao aliado domado pra resolver algo. 10+ escolha 1: proteger alguém, abrir caminho, ou evitar uma ameaça."}
    },
    companheiro:[
      {fase:"Início",criatura:"Fada da Poeira",onde:"Fenwyth"},
      {fase:"Meio",criatura:"Lacustre Vagador ou Serpente das Águas Rasas",onde:"Sylvaine"},
      {fase:"Fim",criatura:"Arauto das Alturas — escolha irreversível",onde:"Grauvenn"}
    ],
    estado:{impulso:0,impulsoMax:3,marcos:0,marcosMax:4,condicoes:"nenhuma"},
    simbolo:"Dois fragmentos de osso rachados, cruzados e amarrados por um nó de corda — o mesmo símbolo do Sindicato dos Ossos: não um osso inteiro, um osso quebrado que foi consertado."
  }
];
