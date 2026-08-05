/* Fonte resumida para o Compêndio. Regra completa: docs/regras_nucleares_campanha.md */
var SISTEMA_NUCLEO = {
  versao: "Campanha v1.1",
  moves: [
    {nome:"Enfrentar Perigo",atributo:"abordagem",quando:"age rápido diante de ameaça imediata",dez:"faz e mantém posição, protege algo ou cria abertura",sete:"faz, mas fica Exposto, perde recurso/tempo ou muda o alvo",seis:"o mestre avança a situação, mostrando o preço antes do irreversível"},
    {nome:"Ler a Situação",atributo:"Conhecimento",quando:"entende pessoa, lugar ou ameaça sob pressão",dez:"faça 3 perguntas úteis e honestas",sete:"faça 1 pergunta útil e honesta",seis:"a resposta vem incompleta ou denuncia sua investigação"},
    {nome:"Proteger",atributo:"Corpo ou Espírito",quando:"fica entre alguém e uma consequência",dez:"negue o efeito e mude posição, force recuo ou assuma condição menor",sete:"protege, mas assume Condição ou perde algo",seis:"a ameaça cobra um preço visível da barreira"},
    {nome:"Escapar",atributo:"Reflexo",quando:"o grupo sai antes de resolver o perigo",dez:"todos saem e levam algo, não deixam rastro ou chegam onde queriam",sete:"saem, mas deixam recurso, alguém fica Separado ou o inimigo ganha posição",seis:"a saída existe, mas cobra Condição do líder ou consequência pública"},
    {nome:"Convencer ou Firmar Termos",atributo:"Espírito",quando:"pede risco, mudança ou acordo",dez:"escolha 2: confiança, aceitação, condição real ou discrição",sete:"escolha 1",seis:"a resposta vem com preço, aliado ou condição"},
    {nome:"Recuperar Fôlego",atributo:"—",quando:"há abrigo, tempo e meios",dez:"remova Condição, repare item ou exponha verdade para ganhar Impulso",sete:"—",seis:"em dungeon, o descanso também avança a pressão do lugar"}
  ],
  condicoes: [
    {nome:"Exposto",efeito:"posição ruim, sem cobertura ou alvo visível"},
    {nome:"Ferido",efeito:"dor ou dano que limita; Médico, descanso e recurso tratam"},
    {nome:"Abalado",efeito:"medo, culpa ou foco quebrado; conversa e cuidado tratam"},
    {nome:"Separado",efeito:"isolado de grupo, rota ou suporte"},
    {nome:"Exaurido",efeito:"sem fôlego, alimento, ferramenta ou tempo"},
    {nome:"Comprometido",efeito:"nome, item, segredo ou relação em risco"}
  ],
  progresso: [
    "Mudamos algo concreto no andar.",
    "Escolhi um custo que revelou quem sou.",
    "Aprofundei vínculo, dívida ou rivalidade.",
    "Minha arma ou profissão resolveu algo de modo único."
  ],
  evolucoes: [
    "Aumentar atributo em +1 (máximo +2).",
    "Adquirir Move Avançado de arma ou profissão.",
    "Criar Especialidade: uma pergunta útil por sessão antes de rolar.",
    "Criar contato, receita, refúgio ou rota confiável.",
    "Transformar cicatriz, dívida ou fracasso em Move pessoal."
  ],
  raid: [
    {nome:"Reconhecimento",uso:"revelar rota, fraqueza ou saída"},
    {nome:"Suprimentos",uso:"remover Exaurido ou evitar perda de recurso"},
    {nome:"Equipamento",uso:"evitar rachadura ou absorver impacto"},
    {nome:"Saúde",uso:"remover Ferido ou Abalado de um aliado"},
    {nome:"Coesão",uso:"impedir pânico, deserção ou conflito de clã"},
    {nome:"Inteligência",uso:"declarar uma verdade preparada sobre o chefe"}
  ]
};
