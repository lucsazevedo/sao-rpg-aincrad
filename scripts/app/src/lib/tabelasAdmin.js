/* Metadados de cada tabela do banco pro Compêndio do Mestre — nome da
   coluna, tipo de campo de formulário e qual é a chave primária.

   Espelha 1:1 scripts/web/admin_schema.js (fonte da verdade compartilhada
   com o painel legado admin.html). Se mudar uma coluna no banco, muda nos
   dois lugares.

   Tipos de campo:
   - text | textarea | number | bool         básicos
   - select      dropdown TRAVADO — só aceita um valor da lista `opcoes`.
                 Usado em campo com vocabulário fixo real (enum do banco,
                 ou taxonomia da qual outro código depende — ex: arma.tipo
                 é usado pra casar com moves_arma.nome).
   - sugestao    <input> com autocomplete (datalist) — sugere `opcoes` (ou
                 busca de outra tabela via tabelaRef/campoRef) mas deixa
                 digitar algo novo. Pra vocabulário "geralmente é um
                 desses, mas pode crescer".
   - imagem      URL de imagem com preview ao vivo abaixo do campo.
   - lista-texto array de strings — vira um repetidor de linhas (➕/🗑️).
   - lista       array de objetos com sub-schema fixo (itemCampos).
   - objeto      objeto de forma fixa e conhecida (campos).
   - json        fallback cru pra formato que ainda não ganhou
                 sub-formulário — tem botão de formatar + validação ao vivo.

   Campo extra "auto" = chave gerada pelo banco (bigserial), não editável
   na criação. Campo extra "segredo" = só o mestre vê o valor de verdade
   (a view pública devolve null pra jogador) — mostramos um aviso no form.
   Campo extra "rotulo" = texto mais amigável pro label (senão usa o nome
   cru da coluna). */

// ===== vocabulários compartilhados (revisão 10/08 — usabilidade dos CRUDs) =====
const ATRIBUTOS = ["Corpo", "Reflexo", "Técnica", "Conhecimento", "Espírito"];
const ATRIBUTOS_ABREV = ["COR", "REF", "TEC", "CON", "ESP"];
const RARIDADE_5 = ["Comum", "Incomum", "Raro", "Épico", "Lendário"];
const RARIDADE_4 = ["Comum", "Incomum", "Raro", "Épico"];
const RARIDADE_5_MIN = ["comum", "incomum", "raro", "epico", "lendario"];
const PROFISSOES = ["Alquimista", "Bibliotecário", "Caçador", "Cartógrafo", "Comerciante", "Costureiro", "Coveiro", "Cozinheiro", "Diplomata", "Domador", "Ferreiro", "Joalheiro", "Lenhador", "Médico", "Mercenário", "Músico"];
const ARMAS_TIPOS = ["Adagas", "Adagas de Arremesso", "Arco e Flecha", "Bastão", "Besta", "Chakrams", "Chicote", "Clava", "Corrente com Peso", "Escudo e Espada", "Espada Longa", "Foice", "Glaive", "Katana", "Lança", "Leque", "Machado", "Manopla", "Martelo", "Nunchaku", "Pá", "Rapieira", "Tonfas"];
const EQUIP_SLOTS = ["Acessórios", "Armaduras", "Botas", "Capuz", "Comidas", "Cristais de Uso", "Elmos", "Escudos", "Luvas", "Munições", "Parte de Baixo", "Parte de Cima", "Poções"];
const MONSTRO_TIPOS = ["aracnideo", "besta", "chefe_de_andar", "construto", "humanoide", "inseto", "nao-corporeo", "planta"];
const PONTOS_CATEGORIA = ["npc", "monstro", "chefe", "recurso", "segredo", "puzzle", "dungeon", "cidade", "comerciante"]; // bate 1:1 com CAT_INFO em Compendio.vue — não adicionar sem atualizar lá também
const PONTOS_TIPO = ["sempre", "respawn", "unico"];
const NPC_PAPEL = ["aliado", "neutro", "vendedor"];
const INVENTARIO_TIPO = ["arma", "equipamento", "consumivel", "material", "carta", "cristal", "ovo", "pet"]; // = CHECK inventario_tipo_check
const INVENTARIO_LOCAL = ["mochila", "stash"]; // = CHECK inventario_local_check
const RECEITAS_TIPO = ["ferramenta", "item", "ovo_especial"]; // = CHECK receitas_tipo_check
const TIPO_BONUS = ["atributo", "dano", "resist", "especial"]; // = CHECK cartas/cristais_tipo_bonus_check
const CLA_CARGO = ["lider", "oficial", "membro"]; // = CHECK cla_autoridade_cargo_check
const CRIATURA_STATUS = ["incubando", "ativo", "perdido"]; // = CHECK criaturas_domadas_status_check
const BESTIARIO_CATEGORIA = ["comum", "mini_boss", "mvp", "boss"]; // = CHECK bestiario_roster_categoria_check
const AMEACA = ["fraco", "comum", "forte", "elite", "chefe"]; // elite=miniboss e chefe=boss usam HP compartilhado (item 11)
const REPUTACAO_ALVO_TIPO = ["cla", "cidade", "vila", "npc", "faccao", "outro"]; // = CHECK reputacao/missoes
const TRANSACAO_TIPO = ["missao", "venda", "compra", "craft", "bug", "ajuste_mestre", "npc", "taxa", "limite_diario", "combate", "estalagem", "transferencia", "meta_global"]; // = CHECK transacoes_tipo_check

// sub-schema reutilizado em receitas.materiais e ferramentas_oficio.receita
// (mesma forma: [{qtd, mat_id}, ...])
const ITEM_CAMPOS_MATERIAL = [
  { nome: "qtd", tipo: "number", rotulo: "Qtd" },
  { nome: "mat_id", tipo: "text", rotulo: "ID do material (ex: mat_couro_cru)" },
];

export const TABELAS_ADMIN = {
  monstros: {
    pk: "id",
    rotulo: "Monstros",
    icone: "💀",
    // achado 10/08: "notas" nunca teve GRANT SELECT na tabela base pra
    // "authenticated" (nem pro mestre — jogador/mestre compartilham esse
    // role no Postgres, GRANT de coluna não sabe diferenciar sessão). Só a
    // view resolve com segurança (CASE WHEN is_mestre()). O editor lê daqui
    // mas escreve na tabela base normalmente (updateExcluido/insert/update
    // não usam viewLeitura).
    viewLeitura: "monstros_publico",
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "nome", tipo: "text" },
      { nome: "epiteto", tipo: "text" },
      { nome: "arquivo", tipo: "text" },
      { nome: "img", tipo: "imagem" },
      { nome: "carta", tipo: "sugestao", tabelaRef: "cartas", campoRef: "nome", rotulo: "Carta assinatura (opcional)" },
      { nome: "tipo", tipo: "sugestao", opcoes: MONSTRO_TIPOS },
      { nome: "zona", tipo: "text" },
      { nome: "regioes", tipo: "lista-texto" },
      { nome: "nivel_recomendado", tipo: "text", rotulo: "Nível recomendado (ex: 6-8)" },
      { nome: "ameaca", tipo: "select", opcoes: AMEACA },
      { nome: "golpes", tipo: "text" },
      { nome: "local", tipo: "text", rotulo: "Local/habitat (descrição livre)" },
      { nome: "canonico", tipo: "bool" },
      { nome: "fonte", tipo: "text" },
      {
        nome: "min_contribuintes", tipo: "number", min: 1,
        rotulo: "Jogadores diferentes p/ derrubar (só importa se ameaça = elite/chefe)",
      },
      {
        nome: "chefe_vida_max", tipo: "number", min: 1,
        rotulo: "HP compartilhado do chefe (só importa se ameaça = elite/chefe)",
      },
      { nome: "fraqueza", tipo: "textarea", rotulo: "Fraqueza (descrição narrativa)" },
      { nome: "atributo_fraqueza", tipo: "select", opcoes: ATRIBUTOS },
      { nome: "fraquezas", tipo: "lista-texto" },
      { nome: "resistencias", tipo: "lista-texto" },
      { nome: "vulnerabilidades", tipo: "lista-texto" },
      { nome: "resumo", tipo: "textarea" },
      { nome: "habitat", tipo: "textarea" },
      { nome: "comportamento", tipo: "textarea" },
      { nome: "leitura", tipo: "textarea" },
      { nome: "sinal", tipo: "textarea" },
      { nome: "lore", tipo: "textarea" },
      { nome: "notas", tipo: "textarea", segredo: true },
      {
        nome: "drops", tipo: "lista", itemNome: "drop",
        itemCampos: [
          { nome: "item", tipo: "text" },
          { nome: "qtd", tipo: "text", rotulo: "Qtd (aceita faixa, ex: 1-2)" },
          { nome: "chance", tipo: "text", rotulo: "Chance (ex: 30%)" },
          { nome: "raridade", tipo: "sugestao", opcoes: RARIDADE_5 },
          { nome: "serve", tipo: "text", rotulo: "Serve pra (opcional)" },
        ],
      },
      { nome: "corpo", tipo: "textarea" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  armas: {
    pk: "id",
    rotulo: "Armas (itens)",
    icone: "⚔️",
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "nome", tipo: "text" },
      { nome: "arquivo", tipo: "text" },
      { nome: "img", tipo: "imagem" },
      // trava importante: golpes/Limit Breaker (moves_arma) casam por NOME
      // com este tipo — um typo aqui quebra o moveset da arma inteira.
      { nome: "tipo", tipo: "select", opcoes: ARMAS_TIPOS },
      { nome: "atributo", tipo: "select", opcoes: ATRIBUTOS },
      { nome: "raridade", tipo: "select", opcoes: RARIDADE_5 },
      { nome: "requisito", tipo: "text" },
      { nome: "preco", tipo: "number" },
      { nome: "preco_txt", tipo: "text" },
      { nome: "resumo", tipo: "textarea" },
      { nome: "efeito", tipo: "textarea" },
      { nome: "obter", tipo: "textarea" },
      { nome: "skills", tipo: "json" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  equipamentos: {
    pk: "id",
    rotulo: "Equipamentos",
    icone: "🥋",
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "nome", tipo: "text" },
      { nome: "img", tipo: "imagem" },
      // sugestão, não select travado: slot novo já apareceu no item 3 sem
      // quebrar nada — travar demais aqui impediria isso de novo.
      { nome: "slot", tipo: "sugestao", opcoes: EQUIP_SLOTS },
      { nome: "raridade", tipo: "select", opcoes: RARIDADE_5 },
      { nome: "conjunto", tipo: "bool" },
      { nome: "arquivo", tipo: "text" },
      { nome: "requisito", tipo: "text" },
      { nome: "preco", tipo: "number" },
      { nome: "preco_txt", tipo: "text" },
      { nome: "resumo", tipo: "textarea" },
      { nome: "efeito", tipo: "textarea" },
      { nome: "obter", tipo: "textarea" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  moves_arma: {
    pk: "nome",
    rotulo: "Golpes de Arma",
    icone: "🗡️",
    campos: [
      { nome: "nome", tipo: "select", opcoes: ARMAS_TIPOS, rotulo: "Arma (precisa bater com armas.tipo)" },
      { nome: "atributo", tipo: "select", opcoes: ATRIBUTOS_ABREV },
      { nome: "marca", tipo: "textarea" },
      { nome: "move_a", tipo: "json" },
      { nome: "move_b", tipo: "json" },
      { nome: "golpe_2", tipo: "json" },
      { nome: "golpe_3", tipo: "json" },
      { nome: "limit_breaker", tipo: "json" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  moves_profissao: {
    pk: "nome",
    rotulo: "Golpes de Profissão",
    icone: "🛠️",
    campos: [
      { nome: "nome", tipo: "select", opcoes: PROFISSOES },
      { nome: "atributo", tipo: "select", opcoes: ATRIBUTOS_ABREV },
      { nome: "marca", tipo: "textarea" },
      { nome: "move_a", tipo: "json" },
      { nome: "move_b", tipo: "json" },
      { nome: "move_c", tipo: "json" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  cartas: {
    pk: "id",
    rotulo: "Cartas (catálogo)",
    icone: "🃏",
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "nome", tipo: "text" },
      { nome: "raridade", tipo: "select", opcoes: RARIDADE_5 },
      { nome: "tipo_bonus", tipo: "select", opcoes: TIPO_BONUS },
      { nome: "valor_bonus", tipo: "number", min: 0, max: 1, rotulo: "Valor do bônus (regra: máx. +1)" },
      { nome: "descricao", tipo: "textarea" },
      { nome: "drop_de", tipo: "text" },
      { nome: "chance_drop", tipo: "number" },
      { nome: "excluido", tipo: "bool" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  cristais: {
    pk: "id",
    rotulo: "Cristais (catálogo)",
    icone: "💎",
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "nome", tipo: "text" },
      { nome: "tipo_bonus", tipo: "select", opcoes: TIPO_BONUS },
      { nome: "valor_bonus", tipo: "number", min: 0, max: 1, rotulo: "Valor do bônus (regra: máx. +1)" },
      { nome: "descricao", tipo: "textarea" },
      { nome: "drop_de", tipo: "text" },
      { nome: "excluido", tipo: "bool" },
      { nome: "visivel", tipo: "bool" },
    ],
  },

  npcs: {
    pk: "id",
    rotulo: "NPCs",
    icone: "🧑",
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "nome", tipo: "text" },
      { nome: "arquivo", tipo: "text" },
      { nome: "img", tipo: "imagem" },
      { nome: "papel", tipo: "select", opcoes: NPC_PAPEL },
      { nome: "profissao", tipo: "sugestao", opcoes: PROFISSOES },
      { nome: "arma", tipo: "sugestao", opcoes: ARMAS_TIPOS },
      { nome: "local", tipo: "text" },
      { nome: "atributos", tipo: "json" },
      { nome: "resumo", tipo: "textarea" },
      { nome: "gancho", tipo: "textarea" },
      { nome: "falas", tipo: "lista-texto" },
      { nome: "corpo", tipo: "textarea" },
      { nome: "canonico", tipo: "bool" },
      { nome: "fonte", tipo: "text" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  quests: {
    pk: "id",
    rotulo: "Quests (narrativa)",
    icone: "📜",
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "titulo", tipo: "text" },
      { nome: "cadeia", tipo: "text" },
      // tipo/dificuldade aqui usam combinações tipo "Coleta/Investigação" —
      // sugestão (não trava) pra não impedir esse padrão já em uso.
      { nome: "tipo", tipo: "sugestao", opcoes: ["Caça", "Coleta", "Combate", "Diplomacia", "Doma", "Eliminação", "Entrega", "Escolta", "Defesa", "Comércio", "Diálogo"] },
      { nome: "dificuldade", tipo: "sugestao", opcoes: ["Fácil", "Médio", "Difícil", "Muito Difícil", "Chefe (fora da escala normal)", "— (sem teste obrigatório)"] },
      { nome: "regiao", tipo: "text" },
      { nome: "npc", tipo: "sugestao", tabelaRef: "npcs", campoRef: "nome" },
      { nome: "requer", tipo: "lista-texto", rotulo: "Requer (ids de outra quest)" },
      { nome: "desbloqueia", tipo: "lista-texto", rotulo: "Desbloqueia (ids de outra quest)" },
      { nome: "resumo", tipo: "textarea" },
      { nome: "corpo", tipo: "textarea" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  cronicas: {
    pk: "id",
    rotulo: "Crônicas",
    icone: "📖",
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "numero", tipo: "number" },
      { nome: "ep_rotulo", tipo: "text" },
      { nome: "titulo", tipo: "text" },
      { nome: "arquivo", tipo: "text" },
      { nome: "tipo", tipo: "sugestao", opcoes: ["Coleta", "Defesa", "Eliminação", "Escolta", "Exploração", "Investigação", "Puzzle", "Social", "Fenômeno", "Finale"] },
      { nome: "dificuldade", tipo: "sugestao", opcoes: ["Fácil", "Médio", "Difícil", "Muito Difícil"] },
      { nome: "regiao", tipo: "text" },
      { nome: "conexoes", tipo: "text" },
      { nome: "elenco", tipo: "text" },
      { nome: "resumo", tipo: "textarea" },
      { nome: "corpo", tipo: "textarea" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  guias: {
    pk: "id",
    rotulo: "Guias de Região",
    icone: "🗺️",
    viewLeitura: "guias_publico",
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "nome", tipo: "text" },
      { nome: "arquivo", tipo: "text" },
      { nome: "bioma", tipo: "text" },
      { nome: "nivel", tipo: "text" },
      { nome: "chegada", tipo: "text" },
      { nome: "leitura", tipo: "textarea" },
      { nome: "cena", tipo: "textarea" },
      { nome: "acoes", tipo: "lista-texto" },
      { nome: "mestre", tipo: "textarea", segredo: true },
      { nome: "demora", tipo: "textarea" },
      { nome: "evento", tipo: "textarea" },
      { nome: "locais", tipo: "lista-texto" },
      { nome: "ligado", tipo: "lista-texto", rotulo: "Ligado (ids de outro guia/ponto)" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  puzzles: {
    pk: "id",
    rotulo: "Puzzles",
    icone: "🧩",
    viewLeitura: "puzzles_publico",
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "n", tipo: "number" },
      { nome: "nome", tipo: "text" },
      { nome: "arquivo", tipo: "text" },
      { nome: "regiao", tipo: "text" },
      { nome: "tipo", tipo: "text" },
      { nome: "cadeia", tipo: "text" },
      { nome: "duracao", tipo: "text" },
      { nome: "verdade", tipo: "textarea", segredo: true },
      { nome: "recompensa", tipo: "textarea" },
      { nome: "corpo", tipo: "textarea" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  dungeons: {
    pk: "id",
    rotulo: "Dungeons",
    icone: "🏰",
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "nome", tipo: "text" },
      { nome: "regiao", tipo: "text" },
      { nome: "nivel", tipo: "text" },
      { nome: "perfil", tipo: "textarea" },
      { nome: "nota", tipo: "textarea" },
      { nome: "setores", tipo: "json" },
      { nome: "salas", tipo: "json" },
      { nome: "ligacoes", tipo: "json" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  salas_dungeon: {
    pk: "id",
    rotulo: "Salas de Dungeon",
    icone: "🚪",
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "dungeon_id", tipo: "sugestao", tabelaRef: "dungeons", campoRef: "id" },
      { nome: "nome", tipo: "text" },
      { nome: "tipo", tipo: "text" },
      { nome: "leitura", tipo: "textarea" },
      { nome: "corpo", tipo: "textarea" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  cidades: {
    pk: "id",
    rotulo: "Cidades",
    icone: "🏙️",
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "nome", tipo: "text" },
      { nome: "andar", tipo: "text" },
      { nome: "tipo_de_zona", tipo: "sugestao", opcoes: ["zona segura"] },
      { nome: "guildas_presentes", tipo: "lista-texto" },
      { nome: "canonico", tipo: "bool" },
      { nome: "fonte", tipo: "text" },
      { nome: "corpo", tipo: "textarea" },
      { nome: "arquivo", tipo: "text" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  clas: {
    pk: "nome",
    rotulo: "Clãs",
    icone: "🛡️",
    viewLeitura: "clas_publico",
    campos: [
      { nome: "nome", tipo: "text" },
      { nome: "destaque", tipo: "bool" },
      { nome: "forca", tipo: "text" },
      { nome: "necessidade", tipo: "text" },
      { nome: "rival", tipo: "sugestao", tabelaRef: "clas", campoRef: "nome" },
      { nome: "rumor", tipo: "text" },
      { nome: "status", tipo: "text" },
      { nome: "resumo", tipo: "textarea" },
      { nome: "bons", tipo: "textarea" },
      { nome: "precisa", tipo: "textarea" },
      { nome: "nao_admitem", tipo: "textarea" },
      { nome: "proximo", tipo: "textarea" },
      { nome: "atravessado", tipo: "textarea" },
      { nome: "quests", tipo: "textarea" },
      { nome: "aparecem", tipo: "textarea" },
      { nome: "simbolo", tipo: "textarea" },
      { nome: "reputacao", tipo: "json" },
      { nome: "ganchos", tipo: "json", segredo: true },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  pontos: {
    pk: "id",
    rotulo: "Pontos do Mapa",
    icone: "📍",
    viewLeitura: "pontos_publico",
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "regiao", tipo: "text" },
      { nome: "nome", tipo: "text" },
      // trava: a cor/ícone no mapa (Compendio.vue CAT_INFO) depende
      // exatamente desses 9 valores — categoria errada vira ponto cinza
      // sem legenda no mapa.
      { nome: "categoria", tipo: "select", opcoes: PONTOS_CATEGORIA },
      { nome: "x", tipo: "number", min: 0, max: 1536, rotulo: "X (0-1536, mesmo viewBox do mapa)" },
      { nome: "y", tipo: "number", min: 0, max: 1024, rotulo: "Y (0-1024, mesmo viewBox do mapa)" },
      { nome: "tipo", tipo: "select", opcoes: PONTOS_TIPO },
      { nome: "ref", tipo: "text" },
      { nome: "descricao", tipo: "textarea" },
      { nome: "respawn_horas", tipo: "number" },
      {
        nome: "teste", tipo: "objeto",
        campos: [
          { nome: "atributo", tipo: "select", opcoes: ATRIBUTOS },
          { nome: "sucesso", tipo: "textarea" },
          { nome: "parcial", tipo: "textarea" },
          { nome: "falha", tipo: "textarea" },
        ],
      },
      { nome: "recompensa", tipo: "textarea" },
      { nome: "ameaca", tipo: "text" },
      { nome: "golpes", tipo: "text" },
      { nome: "atributo_fraqueza", tipo: "select", opcoes: ATRIBUTOS },
      { nome: "fala", tipo: "textarea" },
      { nome: "oferece", tipo: "text" },
      { nome: "vende", tipo: "text" },
      { nome: "obs", tipo: "textarea" },
      { nome: "mestre", tipo: "textarea", segredo: true },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  pontos_detalhe: {
    pk: "id",
    rotulo: "Pontos — Detalhe",
    icone: "📌",
    viewLeitura: "pontos_detalhe_publico",
    campos: [
      { nome: "id", tipo: "sugestao", tabelaRef: "pontos", campoRef: "id" },
      { nome: "nome", tipo: "text" },
      { nome: "regiao", tipo: "text" },
      { nome: "arquivo", tipo: "text" },
      { nome: "leitura", tipo: "textarea" },
      { nome: "oque", tipo: "textarea" },
      { nome: "acoes", tipo: "lista-texto" },
      { nome: "mestre", tipo: "textarea", segredo: true },
      { nome: "atalhos", tipo: "lista-texto" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  sistema: {
    pk: "titulo",
    rotulo: "Regras (Sistema)",
    icone: "📘",
    campos: [
      { nome: "titulo", tipo: "text" },
      { nome: "corpo", tipo: "textarea" },
      { nome: "visivel", tipo: "bool" },
    ],
  },

  oficios: {
    pk: "nome",
    rotulo: "Ofícios",
    icone: "🔨",
    campos: [
      { nome: "nome", tipo: "select", opcoes: PROFISSOES },
      { nome: "atributo", tipo: "select", opcoes: ATRIBUTOS },
      { nome: "arquivo", tipo: "text" },
      { nome: "marca", tipo: "textarea" },
      { nome: "acoes", tipo: "lista-texto" },
      { nome: "postos", tipo: "json" },
      { nome: "contato", tipo: "text" },
      { nome: "gancho", tipo: "textarea" },
      { nome: "renda", tipo: "text" },
      { nome: "item", tipo: "text" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  producao: {
    pk: "profissao",
    rotulo: "Produção (crafting)",
    icone: "⚙️",
    campos: [
      { nome: "profissao", tipo: "select", opcoes: PROFISSOES },
      { nome: "moeda", tipo: "text" },
      { nome: "itens", tipo: "json" },
      { nome: "vale", tipo: "textarea" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  materiais_basicos: {
    pk: "id",
    rotulo: "Materiais de Craft",
    icone: "🌿",
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "nome", tipo: "text" },
      { nome: "raridade", tipo: "select", opcoes: RARIDADE_5_MIN },
      { nome: "nivel_obtencao", tipo: "number", min: 1, max: 10 },
      { nome: "categoria", tipo: "text" },
      { nome: "peso_uso_esperado", tipo: "number", min: 1, max: 10 },
      { nome: "descricao", tipo: "textarea" },
      { nome: "fonte", tipo: "textarea" },
      { nome: "excluido", tipo: "bool" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  receitas: {
    pk: "id",
    rotulo: "Receitas de Craft",
    icone: "📜",
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "profissao", tipo: "select", opcoes: PROFISSOES },
      { nome: "nivel_receita", tipo: "number", min: 1, max: 10 },
      { nome: "tipo", tipo: "select", opcoes: RECEITAS_TIPO },
      { nome: "nome_resultado", tipo: "text" },
      { nome: "resultado_item_id", tipo: "sugestao", tabelaRef: "equipamentos", campoRef: "id", rotulo: "Item resultado (se for equipamento — vazio pra consumível)" },
      { nome: "resultado_raridade", tipo: "select", opcoes: RARIDADE_5_MIN },
      { nome: "atributo_teste", tipo: "select", opcoes: ATRIBUTOS },
      { nome: "dificuldade_mod", tipo: "number" },
      { nome: "folego_custo", tipo: "number", min: 0, max: 10 },
      { nome: "xp_recompensa", tipo: "number" },
      { nome: "materiais", tipo: "lista", itemNome: "material", itemCampos: ITEM_CAMPOS_MATERIAL },
      { nome: "efeitos", tipo: "json" },
      { nome: "receita_refino", tipo: "bool" },
      { nome: "receita_estagio", tipo: "number", min: 1, max: 2 },
      { nome: "receita_antecessora_id", tipo: "sugestao", tabelaRef: "receitas", campoRef: "id" },
      { nome: "requer_ferramenta_id", tipo: "sugestao", tabelaRef: "ferramentas_oficio", campoRef: "id" },
      { nome: "resultado_qtd", tipo: "number", min: 1 },
      { nome: "excluido", tipo: "bool" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  ferramentas_oficio: {
    pk: "id",
    rotulo: "Ferramentas de Ofício",
    icone: "🧰",
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "profissao", tipo: "select", opcoes: PROFISSOES },
      { nome: "nome", tipo: "text" },
      { nome: "nivel_ferramenta", tipo: "number", min: 1, max: 5 },
      { nome: "bonus_acao", tipo: "number", rotulo: "Bônus de ação (mod PBTA pequeno, ex: +1)" },
      { nome: "descricao", tipo: "textarea" },
      { nome: "receita", tipo: "lista", itemNome: "material", itemCampos: ITEM_CAMPOS_MATERIAL },
      { nome: "excluido", tipo: "bool" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  ovos_catalogo: {
    pk: "id",
    rotulo: "Catálogo de Ovos (Pets)",
    icone: "🥚",
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "nome", tipo: "text" },
      { nome: "especie", tipo: "text" },
      { nome: "monstro_id", tipo: "sugestao", tabelaRef: "monstros", campoRef: "id" },
      { nome: "raridade", tipo: "select", opcoes: RARIDADE_5_MIN },
      { nome: "nivel_min", tipo: "number", min: 1, max: 10 },
      { nome: "tempo_chocagem_horas", tipo: "number", min: 1, max: 72 },
      { nome: "incubadora_min", tipo: "number", min: 1, max: 5 },
      { nome: "efeitos_padrao", tipo: "json" },
      { nome: "como_obter", tipo: "textarea" },
      { nome: "descricao", tipo: "textarea" },
      { nome: "excluido", tipo: "bool" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  nivel_profissao_xp: {
    pk: "nivel",
    rotulo: "Curva de XP de Profissão",
    icone: "📈",
    campos: [
      { nome: "nivel", tipo: "number", min: 2, max: 10 },
      { nome: "xp_necessario", tipo: "number" },
    ],
  },
  mercado: {
    pk: "id",
    rotulo: "Lojas do Mapa (NPC)",
    icone: "🏪",
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "nome", tipo: "text" },
      { nome: "regiao", tipo: "text" },
      { nome: "descricao", tipo: "textarea" },
      { nome: "desconto", tipo: "text" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  mercado_itens: {
    pk: "id",
    rotulo: "Itens à venda (loja NPC)",
    icone: "🛒",
    campos: [
      { nome: "id", tipo: "number", auto: true },
      { nome: "mercado_id", tipo: "sugestao", tabelaRef: "mercado", campoRef: "id" },
      { nome: "item", tipo: "text" },
      { nome: "col", tipo: "text" },
      { nome: "obs", tipo: "text" },
    ],
  },
  compra_materiais: {
    pk: "id",
    rotulo: "Compra de Materiais (NPC)",
    icone: "💰",
    campos: [
      { nome: "id", tipo: "number", auto: true },
      { nome: "material", tipo: "text" },
      { nome: "col", tipo: "text" },
      { nome: "quem", tipo: "text" },
      { nome: "visivel", tipo: "bool" },
    ],
  },

  missoes_quadro: {
    pk: "id",
    rotulo: "Missões (Quadro)",
    icone: "⚔️",
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "titulo", tipo: "text" },
      { nome: "tipo", tipo: "sugestao", opcoes: ["caca", "coleta", "combate", "entrega", "contrato_arriscado"] },
      { nome: "descricao", tipo: "textarea" },
      { nome: "regiao", tipo: "text" },
      { nome: "alvo", tipo: "text" },
      { nome: "alvo_qtd", tipo: "number" },
      { nome: "raridade", tipo: "select", opcoes: RARIDADE_5_MIN },
      { nome: "custo_folego", tipo: "number", min: 0, max: 10 },
      { nome: "recompensa_xp", tipo: "number" },
      { nome: "recompensa_col_min", tipo: "number" },
      { nome: "recompensa_col_max", tipo: "number" },
      { nome: "drop_item_id", tipo: "text" },
      { nome: "drop_chance", tipo: "number", min: 0, max: 1 },
      { nome: "drop_tabela", tipo: "sugestao", opcoes: ["monstros_comuns", "monstros_elite"] },
      { nome: "reputacao_cla_nome", tipo: "sugestao", tabelaRef: "clas", campoRef: "nome" },
      { nome: "reputacao_delta", tipo: "number" },
      { nome: "penalidade_col_falha", tipo: "number" },
      { nome: "penalidade_folego_falha", tipo: "number" },
      { nome: "nivel_min", tipo: "number", min: 1, max: 10 },
      { nome: "requer_grupo", tipo: "bool" },
      { nome: "excluido", tipo: "bool" },
      { nome: "visivel", tipo: "bool" },
    ],
  },

  transacoes: {
    pk: "id",
    rotulo: "Transações (Col)",
    icone: "🧾",
    campos: [
      { nome: "id", tipo: "number", auto: true },
      { nome: "de_personagem", tipo: "sugestao", tabelaRef: "personagens", campoRef: "nome" },
      { nome: "para_personagem", tipo: "sugestao", tabelaRef: "personagens", campoRef: "nome" },
      { nome: "tipo", tipo: "select", opcoes: TRANSACAO_TIPO },
      { nome: "valor", tipo: "number" },
      { nome: "item_id", tipo: "text" },
      { nome: "observacao", tipo: "text" },
    ],
  },
  vitrine: {
    pk: "id",
    rotulo: "Vitrine (Mercado Jogador)",
    icone: "🏷️",
    campos: [
      { nome: "id", tipo: "number", auto: true },
      { nome: "vendedor_nome", tipo: "sugestao", tabelaRef: "personagens", campoRef: "nome" },
      { nome: "inventario_id", tipo: "number" },
      { nome: "preco_col", tipo: "number", min: 1 },
      { nome: "expira_em", tipo: "text" },
      { nome: "vendido", tipo: "bool" },
      { nome: "comprador_nome", tipo: "sugestao", tabelaRef: "personagens", campoRef: "nome" },
    ],
  },
  inventario: {
    pk: "id",
    rotulo: "Inventário / Stash",
    icone: "🎒",
    campos: [
      { nome: "id", tipo: "number", auto: true },
      { nome: "personagem_nome", tipo: "sugestao", tabelaRef: "personagens", campoRef: "nome" },
      { nome: "tipo", tipo: "select", opcoes: INVENTARIO_TIPO },
      { nome: "item_id", tipo: "text" },
      { nome: "nome", tipo: "text" },
      { nome: "quantidade", tipo: "number", min: 1 },
      { nome: "equipado", tipo: "bool" },
      { nome: "slot", tipo: "sugestao", opcoes: EQUIP_SLOTS },
      { nome: "cristal_id", tipo: "sugestao", tabelaRef: "cristais", campoRef: "id" },
      { nome: "origem", tipo: "text" },
      { nome: "local", tipo: "select", opcoes: INVENTARIO_LOCAL },
      { nome: "excluido", tipo: "bool" },
    ],
  },
  criaturas_domadas: {
    pk: "id",
    rotulo: "Pets / Criaturas Domadas",
    icone: "🐾",
    campos: [
      { nome: "id", tipo: "number", auto: true },
      { nome: "personagem_nome", tipo: "sugestao", tabelaRef: "personagens", campoRef: "nome" },
      { nome: "especie", tipo: "text" },
      { nome: "monstro_id", tipo: "sugestao", tabelaRef: "monstros", campoRef: "id" },
      { nome: "nome_pet", tipo: "text" },
      { nome: "raridade", tipo: "select", opcoes: RARIDADE_4 },
      { nome: "status", tipo: "select", opcoes: CRIATURA_STATUS },
      { nome: "incubadora_nivel", tipo: "number", min: 1, max: 5 },
      { nome: "efeitos", tipo: "json" },
      { nome: "choca_em", tipo: "text" },
      { nome: "nascido_em", tipo: "text" },
      { nome: "excluido", tipo: "bool" },
    ],
  },
  nivel_profissao: {
    pk: "personagem_nome",
    rotulo: "Nível de Profissão (jogador)",
    icone: "🎓",
    campos: [
      { nome: "personagem_nome", tipo: "sugestao", tabelaRef: "personagens", campoRef: "nome" },
      { nome: "profissao", tipo: "select", opcoes: PROFISSOES },
      { nome: "nivel", tipo: "number", min: 1, max: 10 },
      { nome: "xp", tipo: "number" },
      { nome: "ultima_acao", tipo: "text" },
    ],
  },
  reputacao_personagem: {
    pk: "personagem_nome",
    rotulo: "Reputação (universal)",
    icone: "🤝",
    campos: [
      { nome: "personagem_nome", tipo: "sugestao", tabelaRef: "personagens", campoRef: "nome" },
      { nome: "alvo_nome", tipo: "text" },
      { nome: "alvo_tipo", tipo: "select", opcoes: REPUTACAO_ALVO_TIPO },
      { nome: "nivel", tipo: "number", min: -3, max: 3 },
      { nome: "motivo", tipo: "text" },
    ],
  },
  bestiario_roster: {
    pk: "id",
    rotulo: "Bestiário — Roster (até andar 50)",
    icone: "📖",
    campos: [
      { nome: "id", tipo: "number", auto: true },
      { nome: "andar", tipo: "number", min: 1, max: 50 },
      { nome: "bioma", tipo: "text" },
      { nome: "categoria", tipo: "select", opcoes: BESTIARIO_CATEGORIA },
      { nome: "nome", tipo: "text" },
      { nome: "emoji", tipo: "text" },
      { nome: "materiais", tipo: "lista-texto" },
      { nome: "cristais", tipo: "lista-texto" },
      { nome: "cartas", tipo: "lista-texto" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  combate_log: {
    pk: "id",
    rotulo: "Log de Combate (item 17)",
    icone: "⚔️",
    campos: [
      { nome: "id", tipo: "number", auto: true },
      { nome: "personagem_nome", tipo: "sugestao", tabelaRef: "personagens", campoRef: "nome" },
      { nome: "monstro_nome", tipo: "sugestao", tabelaRef: "monstros", campoRef: "nome" },
      { nome: "resultado", tipo: "sugestao", opcoes: ["sucesso_total", "sucesso_parcial", "falha"] },
      { nome: "vida_perdida", tipo: "number" },
      { nome: "xp_ganho", tipo: "number" },
      { nome: "col_ganho", tipo: "number" },
      { nome: "drop_item_id", tipo: "text" },
    ],
  },
  chefes_ativos: {
    pk: "id",
    rotulo: "Chefes/Minibosses Ativos (item 11)",
    icone: "👑",
    campos: [
      { nome: "id", tipo: "number", auto: true },
      { nome: "monstro_id", tipo: "sugestao", tabelaRef: "monstros", campoRef: "id" },
      { nome: "vida_max", tipo: "number" },
      { nome: "vida_atual", tipo: "number" },
      { nome: "derrotado", tipo: "bool" },
    ],
  },
  chefes_contribuicoes: {
    pk: "id",
    rotulo: "Contribuições em Chefe (item 11)",
    icone: "🗡️",
    campos: [
      { nome: "id", tipo: "number", auto: true },
      { nome: "chefe_ativo_id", tipo: "number" },
      { nome: "personagem_nome", tipo: "sugestao", tabelaRef: "personagens", campoRef: "nome" },
      { nome: "dano_total", tipo: "number" },
      { nome: "ataques", tipo: "number" },
    ],
  },
  cla_inventario: {
    pk: "id",
    rotulo: "Baú de Clã (item 18B)",
    icone: "🧰",
    campos: [
      { nome: "id", tipo: "number", auto: true },
      { nome: "cla_nome", tipo: "sugestao", tabelaRef: "clas", campoRef: "nome" },
      { nome: "nome", tipo: "text" },
      { nome: "tipo", tipo: "select", opcoes: INVENTARIO_TIPO },
      { nome: "qtd", tipo: "number", min: 1 },
      { nome: "liberado_para_membros", tipo: "bool" },
      { nome: "depositado_por", tipo: "sugestao", tabelaRef: "personagens", campoRef: "nome" },
      { nome: "excluido", tipo: "bool" },
    ],
  },
  cla_autoridade: {
    pk: "id",
    rotulo: "Cargos de Clã (item 18B)",
    icone: "👑",
    campos: [
      { nome: "id", tipo: "number", auto: true },
      { nome: "cla_nome", tipo: "sugestao", tabelaRef: "clas", campoRef: "nome" },
      { nome: "personagem_nome", tipo: "sugestao", tabelaRef: "personagens", campoRef: "nome" },
      { nome: "cargo", tipo: "select", opcoes: CLA_CARGO },
    ],
  },
  metas_globais: {
    pk: "id",
    rotulo: "Metas Globais (item 18C)",
    icone: "🎯",
    campos: [
      { nome: "id", tipo: "number", auto: true },
      { nome: "titulo", tipo: "text" },
      { nome: "descricao", tipo: "textarea" },
      { nome: "meta_item", tipo: "text" },
      { nome: "meta_qtd", tipo: "number", min: 1 },
      { nome: "progresso", tipo: "number" },
      { nome: "recompensa_col", tipo: "number" },
      { nome: "recompensa_xp", tipo: "number" },
      { nome: "recompensa_item", tipo: "text" },
      { nome: "recompensa_reputacao_alvo_nome", tipo: "sugestao", tabelaRef: "clas", campoRef: "nome" },
      { nome: "recompensa_reputacao_valor", tipo: "number", min: -3, max: 3 },
      { nome: "finalizada", tipo: "bool" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  metas_doacoes: {
    pk: "id",
    rotulo: "Doações de Meta (item 18C)",
    icone: "📥",
    campos: [
      { nome: "id", tipo: "number", auto: true },
      { nome: "meta_id", tipo: "sugestao", tabelaRef: "metas_globais", campoRef: "titulo" },
      { nome: "personagem_nome", tipo: "sugestao", tabelaRef: "personagens", campoRef: "nome" },
      { nome: "qtd_doada", tipo: "number", min: 1 },
    ],
  },
};

/* Agrupamento pra sidebar do Compêndio. "avancado" fica escondido atrás de
   um "mostrar mais" — são tabelas técnicas/estado-ao-vivo que o mestre
   raramente precisa editar linha a linha (a maior parte já tem tela própria
   no painel: Jogadores cuida de personagens, Mercado cuida de vitrine). */
export const GRUPOS_COMPENDIO = [
  {
    k: "bestiario",
    lbl: "Bestiário & Combate",
    ico: "💀",
    tabelas: ["monstros", "armas", "equipamentos", "moves_arma", "moves_profissao", "cartas", "cristais", "bestiario_roster", "combate_log"],
  },
  {
    k: "mundo",
    lbl: "Mundo & Narrativa",
    ico: "🗺️",
    tabelas: ["npcs", "quests", "cronicas", "guias", "puzzles", "dungeons", "salas_dungeon", "cidades", "clas", "pontos", "pontos_detalhe", "sistema"],
  },
  {
    k: "missoes",
    lbl: "Missões",
    ico: "⚔️",
    tabelas: ["missoes_quadro"],
  },
  {
    k: "oficios",
    lbl: "Ofícios & Craft",
    ico: "🔨",
    tabelas: ["oficios", "producao", "materiais_basicos", "receitas", "ferramentas_oficio", "ovos_catalogo", "nivel_profissao_xp"],
  },
  {
    k: "comercio",
    lbl: "Comércio",
    ico: "🏪",
    tabelas: ["mercado", "mercado_itens", "compra_materiais"],
  },
  {
    k: "avancado",
    lbl: "Avançado · estado ao vivo",
    ico: "🧪",
    colapsavel: true,
    tabelas: ["transacoes", "vitrine", "inventario", "criaturas_domadas", "nivel_profissao", "reputacao_personagem",
      "cla_inventario", "cla_autoridade", "metas_globais", "metas_doacoes", "chefes_ativos", "chefes_contribuicoes"],
  },
];
