/* Layouts internos das dungeons do Andar 1.
   Fonte narrativa: mapas/dungeons_andar1.md -- os dois devem contar a mesma
   coisa; mudar um sem mudar o outro cria contradicao.

   Formato:
   DUNGEONS = [{
     id, nome, regiao, nivel, perfil, nota,
     setores: [{id, nome, subtitulo}],           // colunas do desenho
     salas:  [{id, setor, nome, tipo, x, y, txt}],
     ligacoes: [[idA, idB], ...]                 // arestas nao direcionadas
   }]
   x/y sao coordenadas dentro de um viewBox de 1000x520 (o HTML escala).
   tipo: entrada|corredor|patrulha|armadilha|tesouro|descanso|puzzle|miniboss|chefe|segredo
*/

var TIPOS_SALA = {
  entrada:   {cor:"#8fd694", icone:"▶", label:"Entrada"},
  corredor:  {cor:"#7b8794", icone:"≡", label:"Corredor"},
  patrulha:  {cor:"#ff5f5f", icone:"⚔", label:"Patrulha"},
  armadilha: {cor:"#ffb454", icone:"⚠", label:"Armadilha"},
  tesouro:   {cor:"#ffd85c", icone:"◆", label:"Tesouro"},
  descanso:  {cor:"#57d9ff", icone:"⚑", label:"Descanso"},
  puzzle:    {cor:"#c98fff", icone:"?", label:"Puzzle"},
  miniboss:  {cor:"#ff2e2e", icone:"☠", label:"Miniboss"},
  chefe:     {cor:"#ff2e2e", icone:"♚", label:"Chefe"},
  segredo:   {cor:"#a05fff", icone:"✲", label:"Segredo"}
};

var DUNGEONS = [
  {
    id: "labirinto",
    nome: "Labirinto do Andar 1",
    regiao: "Limiar do Labirinto → Covil de Illfang",
    nivel: "7-18",
    perfil: "20 sub-níveis canônicos agrupados em 5 trechos de 4. Cada trecho " +
            "é uma sessão razoável de exploração.",
    nota: "Regra de fôlego: no máximo DOIS trechos por incursão antes de sair ou " +
          "usar um ponto de descanso. É isso que transforma o Labirinto em campanha " +
          "em vez de corrida.",
    setores: [
      {id:"I",   nome:"Trecho I",   subtitulo:"Sub 1-4 · As Galerias Abertas"},
      {id:"II",  nome:"Trecho II",  subtitulo:"Sub 5-8 · Os Corredores Falsos"},
      {id:"III", nome:"Trecho III", subtitulo:"Sub 9-12 · A Descida Molhada"},
      {id:"IV",  nome:"Trecho IV",  subtitulo:"Sub 13-16 · O Ninho"},
      {id:"V",   nome:"Trecho V",   subtitulo:"Sub 17-20 · A Antessala"}
    ],
    salas: [
      {id:"I1", setor:"I", nome:"Portal de Entrada", tipo:"entrada", x:100, y:70,
       txt:"Arco de 30 metros de vão. Marco está sentado do lado de fora, esperando um grupo que não volta."},
      {id:"I2", setor:"I", nome:"Galeria Longa", tipo:"corredor", x:100, y:150,
       txt:"200m retos, teto alto, luz de cristal azul. Ecoa tudo — impossível se aproximar em silêncio."},
      {id:"I3", setor:"I", nome:"Posto Avançado", tipo:"descanso", x:100, y:230,
       txt:"Acampamento de outros jogadores. Boato, comércio informal, um lugar pra respirar."},
      {id:"I4", setor:"I", nome:"Ronda Baixa", tipo:"patrulha", x:100, y:310,
       txt:"Ruin Kobold Trooper x2. Respawn em 3h."},
      {id:"I5", setor:"I", nome:"Nicho Rachado", tipo:"tesouro", x:100, y:390,
       txt:"Baú simples: 80-150 Col e 1 Cristal (Luz ou Antídoto)."},
      {id:"I6", setor:"I", nome:"Escada Descendente", tipo:"corredor", x:100, y:460,
       txt:"Liga ao Trecho II. O ar muda de temperatura no meio da escada."},

      {id:"II1", setor:"II", nome:"Trifurcação", tipo:"puzzle", x:280, y:70,
       txt:"Três corredores idênticos. Conhecimento 10+: acha o certo. 7-9: acha, mas dispara alarme. 6-: beco."},
      {id:"II2", setor:"II", nome:"Beco da Lâmina", tipo:"armadilha", x:230, y:160,
       txt:"Placa de pressão → lâmina lateral. Grevas de Verme-Cristal ignoram a placa."},
      {id:"II3", setor:"II", nome:"Beco do Teto Baixo", tipo:"armadilha", x:330, y:160,
       txt:"O teto desce devagar. Corpo pra escorar, ou Técnica pra travar o mecanismo."},
      {id:"II4", setor:"II", nome:"Corredor Verdadeiro", tipo:"corredor", x:280, y:250,
       txt:"Marcas de giz de quem passou antes. Algumas foram deixadas falsas de propósito."},
      {id:"II5", setor:"II", nome:"Depósito Esquecido", tipo:"tesouro", x:280, y:330,
       txt:"Fragmento de Armadura Kobold x3, Placas de Metal Refinado x1."},
      {id:"II6", setor:"II", nome:"Sala do Sino", tipo:"patrulha", x:280, y:420,
       txt:"Ruin Kobold Arqueiro x2 num nicho alto. Se o sino tocar, vêm mais dois."},

      {id:"III1", setor:"III", nome:"Escadaria Escorregadia", tipo:"armadilha", x:460, y:70,
       txt:"Reflexo pra descer sem cair. Botas Cravejadas dispensam o teste."},
      {id:"III2", setor:"III", nome:"Cisterna", tipo:"patrulha", x:460, y:150,
       txt:"Sanguessuga Gigante x3 na água parada. Calça Encerada impede que grudem nas pernas."},
      {id:"III3", setor:"III", nome:"Passarela Estreita", tipo:"corredor", x:460, y:230,
       txt:"Fila indiana obrigatória. Glaive e Espada Longa não funcionam aqui."},
      {id:"III4", setor:"III", nome:"Alcova Seca", tipo:"descanso", x:460, y:310,
       txt:"Um dos dois únicos pontos seguros do Labirinto inteiro."},
      {id:"III5", setor:"III", nome:"Câmara do Ralo", tipo:"segredo", x:390, y:390,
       txt:"Grade solta no chão — atalho direto pro Trecho V. Conhecimento 10+ pra notar."},
      {id:"III6", setor:"III", nome:"Guarita Inundada", tipo:"miniboss", x:520, y:400,
       txt:"Ruin Kobold Sentinel solitário (forte, 6 golpes). Guarda a passagem."},

      {id:"IV1", setor:"IV", nome:"Barricada", tipo:"patrulha", x:660, y:90,
       txt:"Trooper x3 atrás de tapume. Pavês de Portão e Lança de Parede de Escudos brilham aqui."},
      {id:"IV2", setor:"IV", nome:"Fogueira Central", tipo:"patrulha", x:660, y:190,
       txt:"Trooper x2 + Arqueiro x1. Dá pra atravessar sem lutar com furtividade 10+."},
      {id:"IV3", setor:"IV", nome:"Depósito de Espólio", tipo:"tesouro", x:590, y:290,
       txt:"200-400 Col, uma arma Incomum aleatória, 1 Cristal de Cura."},
      {id:"IV4", setor:"IV", nome:"Cela Vazia", tipo:"segredo", x:730, y:290,
       txt:"O equipamento do grupo do Marco. Fio que amarra Memorial, entrada do Labirinto e cadeia H."},
      {id:"IV5", setor:"IV", nome:"Passagem Guardada", tipo:"miniboss", x:660, y:400,
       txt:"Sentinel x2. O encontro que decide se o grupo está pronto pro chefe."},

      {id:"V1", setor:"V", nome:"Salão dos Estandartes", tipo:"corredor", x:880, y:110,
       txt:"Estandartes kobold rasgados. Um Bibliotecário lê a heráldica e descobre a história do andar."},
      {id:"V2", setor:"V", nome:"Última Alcova", tipo:"descanso", x:880, y:220,
       txt:"O segundo e último ponto seguro. É aqui que o raid se organiza."},
      {id:"V3", setor:"V", nome:"Porta do Chefe", tipo:"puzzle", x:880, y:330,
       txt:"Não abre sozinha: precisa de quatro pessoas empurrando. Mecânica social, não teste."},
      {id:"V4", setor:"V", nome:"Sala de Illfang", tipo:"chefe", x:880, y:440,
       txt:"Illfang the Kobold Lord — 4 barras x 6-8 golpes. Fase 2 na última barra: larga o broquel, saca o nodachi."}
    ],
    ligacoes: [
      ["I1","I2"],["I2","I3"],["I3","I4"],["I4","I5"],["I5","I6"],["I6","II1"],
      ["II1","II2"],["II1","II3"],["II1","II4"],["II4","II5"],["II5","II6"],["II6","III1"],
      ["III1","III2"],["III2","III3"],["III3","III4"],["III4","III6"],["III4","III5"],
      ["III6","IV1"],["III5","V1"],
      ["IV1","IV2"],["IV2","IV3"],["IV2","IV4"],["IV2","IV5"],["IV5","V1"],
      ["V1","V2"],["V2","V3"],["V3","V4"]
    ]
  },

  {
    id: "mournhall",
    nome: "Caverna de Mournhall",
    regiao: "Caverna de Mournhall (noroeste)",
    nivel: "8-13",
    perfil: "Dungeon menor opcional, 8 salas, uma incursão só.",
    nota: "Escuridão total é a mecânica central: sem fonte de luz, todo teste sofre " +
          "complicação e a Sombra de Mournhall ataca com vantagem. Uma Fada da Poeira " +
          "domada resolve isso sem gastar Cristal de Luz.",
    setores: [{id:"M", nome:"Caverna de Mournhall", subtitulo:"8 salas · escuridão total"}],
    salas: [
      {id:"M1", setor:"M", nome:"Boca da Caverna", tipo:"entrada", x:90, y:260,
       txt:"A luz do dia chega até aqui e não passa disso. Do lado de dentro, o contraste cega por alguns segundos."},
      {id:"M2", setor:"M", nome:"Galeria de Estalactites", tipo:"patrulha", x:230, y:260,
       txt:"Morcego Ecoante em bando. Barulho alto os solta do teto de uma vez."},
      {id:"M3", setor:"M", nome:"Fenda Estreita", tipo:"armadilha", x:360, y:260,
       txt:"Passagem de lado. Quem usa Armadura pesada ou Pavês precisa tirar e empurrar na frente."},
      {id:"M4", setor:"M", nome:"Poço de Ecos", tipo:"puzzle", x:490, y:260,
       txt:"Falar alto derruba pedra do teto. O grupo atravessa em silêncio combinado — sem rolagem, só acordo."},
      {id:"M5", setor:"M", nome:"Veio de Musgo Luminoso", tipo:"tesouro", x:620, y:160,
       txt:"Musgo Luminoso (Alquimista) — a isca de doma da Sombra de Mournhall."},
      {id:"M6", setor:"M", nome:"Câmara Cega", tipo:"patrulha", x:620, y:360,
       txt:"Sombra de Mournhall (forte, 5 golpes). Vulnerável a luz intensa; um Cristal de Luz vira arma aqui."},
      {id:"M7", setor:"M", nome:"Nicho Seco", tipo:"descanso", x:760, y:360,
       txt:"Pequeno e seguro, atrás de uma coluna. Só aparece pra quem procurar."},
      {id:"M8", setor:"M", nome:"Sala do Guardião", tipo:"miniboss", x:890, y:360,
       txt:"Guardião de Mournhall (elite, 9 golpes). Pelagem Grisalha → Cota do Guardião, o melhor Raro de Armadura do andar."}
    ],
    ligacoes: [["M1","M2"],["M2","M3"],["M3","M4"],["M4","M5"],["M4","M6"],["M6","M7"],["M7","M8"]]
  },

  {
    id: "lumis",
    nome: "Gruta de Lumis",
    regiao: "Gruta de Lumis (leste)",
    nivel: "6-11",
    perfil: "Dungeon de COLETA, não de combate. 7 salas. Dá pra sair rico sem lutar " +
            "nenhuma vez — se souberem parar na hora.",
    nota: "Contador de Vibração: +1 por extração, +1 por combate, +1 por queda ou barulho " +
          "alto. Ao chegar em 3, um Verme de Cristal emerge. Zera quando o verme cai ou o " +
          "grupo sai. O grupo SABE disso depois da primeira vez — a tensão é escolher " +
          "parar ou pegar mais um.",
    setores: [{id:"L", nome:"Gruta de Lumis", subtitulo:"7 salas · dungeon de coleta"}],
    salas: [
      {id:"L1", setor:"L", nome:"Entrada Iluminada", tipo:"entrada", x:100, y:260,
       txt:"Os cristais das paredes acendem sozinhos quando alguém entra. Zona segura."},
      {id:"L2", setor:"L", nome:"Corredor Azul", tipo:"corredor", x:250, y:260,
       txt:"Chão coberto de lascas. Correr aqui custa +1 no Contador de Vibração."},
      {id:"L3", setor:"L", nome:"Veio Menor", tipo:"tesouro", x:400, y:150,
       txt:"Cristal Bruto x2. Cada extração custa +1 de vibração."},
      {id:"L4", setor:"L", nome:"Câmara dos Reflexos", tipo:"puzzle", x:400, y:370,
       txt:"Paredes espelhadas de cristal. Sem Conhecimento 10+, o grupo anda em círculo e não percebe."},
      {id:"L5", setor:"L", nome:"Veio Maior", tipo:"tesouro", x:570, y:370,
       txt:"Cristal Bruto x4 + chance de Cristal de sistema (Luz ou Barreira)."},
      {id:"L6", setor:"L", nome:"Galeria do Verme", tipo:"patrulha", x:730, y:370,
       txt:"Verme de Cristal (comum, 4 golpes). A carapaça vira Grevas de Verme-Cristal e Manoplas de Casco."},
      {id:"L7", setor:"L", nome:"Fenda Fria", tipo:"segredo", x:880, y:370,
       txt:"Ar gelado saindo de uma fenda fina demais pra passar. Ninguém sabe o que tem atrás — gancho em aberto."}
    ],
    ligacoes: [["L1","L2"],["L2","L3"],["L2","L4"],["L4","L5"],["L5","L6"],["L6","L7"]]
  },

  {
    id: "oculta",
    nome: "Dungeon Oculta sob o Castelo de Ferro Negro",
    regiao: "Castelo de Ferro Negro",
    nivel: "MUITO acima do andar 1",
    perfil: "5 salas conhecidas. O mestre não deve deixar o grupo passar da terceira.",
    nota: "Função narrativa: estabelecer que existe algo maior, não recompensar. Se o " +
          "grupo insistir e morrer, foi avisado três vezes — o boato em Tolbana, a nota " +
          "de Lynx, e a sala D-3. Se recuar, ganha uma pista de verdade.",
    setores: [{id:"D", nome:"Dungeon Oculta", subtitulo:"lenda urbana jogável"}],
    salas: [
      {id:"D1", setor:"D", nome:"Escada Atrás da Coluna", tipo:"entrada", x:120, y:260,
       txt:"Maldisfarçada. Só aparece pra quem já descobriu o Pátio do Castelo."},
      {id:"D2", setor:"D", nome:"Descida Longa", tipo:"corredor", x:320, y:260,
       txt:"Oitenta degraus. O ar fica mais frio e mais parado a cada dez."},
      {id:"D3", setor:"D", nome:"Antecâmara Alagada", tipo:"armadilha", x:520, y:260,
       txt:"Água gelada até o tornozelo. Aqui o mestre dá o último aviso claro, em voz alta, fora de personagem se precisar."},
      {id:"D4", setor:"D", nome:"Salão do Scavenge Toad", tipo:"miniboss", x:700, y:260,
       txt:"Ameaça incompatível com o andar 1. Fugir é a jogada certa e o mestre deve garantir que seja possível."},
      {id:"D5", setor:"D", nome:"Porta Que Não Abre", tipo:"segredo", x:890, y:260,
       txt:"Sem fechadura, sem mecanismo, sem dobradiça. É a mesma pedra da Câmara da Inscrição — e o Martelo do Mural soa diferente nela."}
    ],
    ligacoes: [["D1","D2"],["D2","D3"],["D3","D4"],["D4","D5"]]
  }
];
