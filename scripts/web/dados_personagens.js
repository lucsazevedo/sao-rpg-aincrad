/* Fichas de jogador da comunidade. Fonte: personagens/*.md
   Página que consome isto: scripts/web/personagens.html (independente do
   compendio_andar1.html — mestre e jogadores são públicos diferentes). */
var PERSONAGENS=[
  {
    nome:"Umbra",
    guilda:"Sindicato dos Ossos",
    arma:"Leque",
    profissao:"Domador",
    nivel:1,
    conceito:"Domadora que comanda sem tocar. Fala pouco, deixa o leque e o vínculo falarem por ela. Ninguém a leva a sério até a segunda vez que tenta.",
    referencias:"Motoko Kusanagi · Retsu Unohana · Madoka Kaname · Tatsumaki",
    aparencia:"Corpo atlético e cheio, presença física real — não frágil. Cabelo escuro, longo e ondulado, com uma trança fina de um lado e uma mecha branco-osso emoldurando o rosto. Cicatriz fina e antiga atravessando a sobrancelha direita. Roupa de couro funcional em tom violeta escuro e carvão com detalhes branco-osso, cobrindo o tronco por completo. Pequenos nós de osso amarrados no cabo de cada leque.",
    atributos_dnd:{forca:6,destreza:10,constituicao:6,inteligencia:8,sabedoria:8,carisma:8},
    arma_detalhe:{
      marca:"o leque passa elegância, controle de espaço e comando à distância — ela dirige a cena com um gesto, nunca com força.",
      atributo:"Sabedoria",
      referencia:"SAO_RPG_5e.md, Seção 58.3 — Corte de Seda, Dança do Leque, Rajada Cortante, Limit Break Mil Lâminas de Vento, Vento Reverso, Dança das Correntes, Lâmina Tempestuosa, Festival das Cem Lâminas, passiva Fluxo Cortante",
      item_inicial:"Leque de Guerra Simples (Comum, sem bônus)",
      progressao:"Leque de Brasa Viva (Incomum) → Leque das Mil Vozes (Raro) — ver armas/00_catalogo_expandido.md"
    },
    profissao_detalhe:{
      marca:"você chega perto do que morde. A mesa inteira para de falar quando você se agacha na frente de um bicho.",
      atributo:"Sabedoria",
      referencia:"SAO_RPG_5e.md, Seção 42 — Domar Criatura + Vínculo de Combate (nível 1), Comando Instintivo (5), Guarda Mútua (10), Vínculo Perfeito + Troca Instintiva (15), Mestre Domador + Comando Duplo + Vínculo Inquebrável (20)"
    },
    companheiro:[
      {fase:"Início",criatura:"Fada da Poeira",onde:"Fenwyth"},
      {fase:"Meio",criatura:"Lacustre Vagador ou Serpente das Águas Rasas",onde:"Sylvaine"},
      {fase:"Fim",criatura:"Arauto das Alturas — escolha irreversível",onde:"Grauvenn"}
    ],
    estado:{nivel:1,ca:10,pvMax:50,pvAtual:50,bonusProficiencia:2,condicoes:"nenhuma"},
    simbolo:"Dois fragmentos de osso rachados, cruzados e amarrados por um nó de corda — o mesmo símbolo do Sindicato dos Ossos: não um osso inteiro, um osso quebrado que foi consertado."
  }
];
