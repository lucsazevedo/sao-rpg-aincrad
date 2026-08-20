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
   - imagem      upload real de arquivo (Storage do Supabase, bucket
                 "compendio-imagens") com preview ao vivo abaixo do campo.
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
const ATRIBUTOS_ABREV = ["COR", "REF", "TEC", "CON", "ESP"]; // histórico PBTA — não usar em campo novo
const ATRIBUTOS_DND = ["Força", "Destreza", "Constituição", "Inteligência", "Sabedoria", "Carisma"];
const RARIDADE_5 = ["Comum", "Incomum", "Raro", "Épico", "Lendário"];
const RARIDADE_4 = ["Comum", "Incomum", "Raro", "Épico"];
const RARIDADE_5_MIN = ["comum", "incomum", "raro", "epico", "lendario"];
// Reforma 12/08 (pedido do usuário): Bibliotecário + Diplomata unificaram
// em Informante; Coveiro saiu (funções foram pro Mercenário); entraram
// Mestre de Montarias e Minerador (Move Exclusivo pronto em
// SAO_PBTA_Profissoes_e_Moves.pdf). Continua em 16 profissões.
// Personagem já criado com profissão antiga (Bibliotecário/Diplomata/
// Coveiro) não quebra — profissao é texto livre, só some do dropdown de
// criação de personagem novo.
const PROFISSOES = ["Alquimista", "Caçador", "Cartógrafo", "Comerciante", "Costureiro", "Cozinheiro", "Domador", "Ferreiro", "Informante", "Joalheiro", "Lenhador", "Médico", "Mercenário", "Mestre de Montarias", "Minerador", "Músico"];
const ARMAS_TIPOS = ["Adagas", "Adagas de Arremesso", "Arco e Flecha", "Bastão", "Besta", "Chakrams", "Chicote", "Corrente com Peso", "Escudo e Espada", "Espada Longa", "Foice", "Katana", "Lança", "Leque", "Machado", "Manopla", "Martelo", "Pá", "Rapieira"];
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
// Hub de Aincrad (SAO_RPG_AINCRAD_SISTEMAS.md) — vocabulários = CHECK das tabelas em schema_hub_aincrad.sql
const NOTICIA_CATEGORIA = ["boss", "exploracao", "item_raro", "guilda", "evento", "sistema", "descoberta", "conquista"]; // = CHECK noticias_categoria_check
const ANDAR_STATUS = ["bloqueado", "em_exploracao", "boss_descoberto", "boss_derrotado", "concluido"]; // = CHECK andares_status_check
const BOSS_STATUS = ["nao_descoberto", "descoberto", "batalha_disponivel", "derrotado"]; // = CHECK andares_boss_status_check
const EVENTO_STATUS = ["em_breve", "ativo", "concluido", "fracassado"]; // = CHECK eventos_globais_status_check

// sub-schema reutilizado em receitas.materiais e ferramentas_oficio.receita
// (mesma forma: [{qtd, mat_id}, ...])
const ITEM_CAMPOS_MATERIAL = [
  { nome: "qtd", tipo: "number", rotulo: "Qtd" },
  { nome: "mat_id", tipo: "text", rotulo: "ID do material (ex: mat_couro_cru)" },
];

// Sub-schema de "ação testável" (bloco de teste PBTA: 2d6+atributo, 10+/7-9/6-)
// reusado em guias.acoes, oficios.acoes e pontos_detalhe.acoes — mesma forma
// nas 3 tabelas. Achado 16/08 (relato do usuário): essas 3 colunas são jsonb
// (array de objeto), mas estavam declaradas "lista-texto" (espera array de
// STRING) — cada linha virava "[object Object]" no formulário, e SALVAR
// gravava esse texto de volta no banco, apagando o dado de verdade. 29/30
// guias e 3/16 ofícios já tinham sido corrompidos assim; recuperados a
// partir de scripts/web/dados_conteudo.js (fonte original, nunca passou
// pelo editor quebrado) — ver histórico do chat 16-17/08. Tipo corrigido
// pra "lista" (sub-schema fixo) previne o mesmo acidente de novo.
const ITEM_CAMPOS_ACAO_TESTAVEL = [
  { nome: "acao", tipo: "text", rotulo: "Ação" },
  { nome: "teste", tipo: "text", rotulo: "Teste (ex: 2d6+Conhecimento)" },
  { nome: "sucesso", tipo: "text", rotulo: "10+ (sucesso)" },
  { nome: "parcial", tipo: "text", rotulo: "7-9 (parcial)" },
  { nome: "falha", tipo: "text", rotulo: "6- (falha)" },
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
      { nome: "skills", tipo: "lista-texto", rotulo: "Skills (nomes)" },
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
    rotulo: "Sword Skills de Arma",
    icone: "🗡️",
    // Conversão pra D&D 5e: sword_skills (array de {nivel,nome,descricao},
    // as 7 Sword Skills normais) + limit_break_novo ({nivel,nome,descricao})
    // são as colunas vivas agora — conteúdo real das Seções 55-59 do
    // SAO_RPG_5e.md, populado por scripts/db/_popular_moves_dnd5e.py.
    // move_a/move_b/golpe_2/golpe_3/limit_breaker (formato PBTA antigo:
    // gatilho + dez_mais/sete_nove/seis_menos) ficam só de histórico.
    campos: [
      { nome: "nome", tipo: "select", opcoes: ARMAS_TIPOS, rotulo: "Arma (precisa bater com armas.tipo)" },
      { nome: "atributo", tipo: "select", opcoes: ATRIBUTOS_DND },
      { nome: "marca", tipo: "textarea", rotulo: "Identidade da arma" },
      { nome: "sword_skills", tipo: "json", rotulo: "7 Sword Skills (array {nivel,nome,descricao})" },
      { nome: "limit_break_novo", tipo: "json", rotulo: "Limit Break — nível 5 ({nivel,nome,descricao})" },
      { nome: "move_a", tipo: "json", rotulo: "Move 1 (histórico PBTA)" },
      { nome: "golpe_2", tipo: "json", rotulo: "Move 2 (histórico PBTA)" },
      { nome: "limit_breaker", tipo: "json", rotulo: "Move 3 · LIMIT BREAK (histórico PBTA)" },
      { nome: "move_b", tipo: "json", rotulo: "Move B (histórico PBTA)" },
      { nome: "golpe_3", tipo: "json", rotulo: "Golpe 3 (histórico PBTA)" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  moves_profissao: {
    pk: "nome",
    rotulo: "Habilidades de Profissão",
    icone: "🛠️",
    // niveis: array de {nivel,nome,descricao} nos níveis 1/5/10/15/20
    // (Seções 30-44 do SAO_RPG_5e.md) — coluna viva. move_a/move_b/move_c
    // (PBTA) ficam de histórico.
    campos: [
      { nome: "nome", tipo: "select", opcoes: PROFISSOES },
      { nome: "atributo", tipo: "select", opcoes: ATRIBUTOS_DND },
      { nome: "marca", tipo: "textarea", rotulo: "Identidade da profissão" },
      { nome: "niveis", tipo: "json", rotulo: "Habilidades por nível (array {nivel,nome,descricao})" },
      { nome: "move_a", tipo: "json", rotulo: "Move A (histórico PBTA)" },
      { nome: "move_b", tipo: "json", rotulo: "Move B (histórico PBTA)" },
      { nome: "move_c", tipo: "json", rotulo: "Move C (histórico PBTA)" },
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
      { nome: "acoes", tipo: "lista", itemNome: "ação", itemCampos: ITEM_CAMPOS_ACAO_TESTAVEL },
      { nome: "mestre", tipo: "textarea", segredo: true },
      { nome: "demora", tipo: "textarea" },
      { nome: "evento", tipo: "textarea" },
      { nome: "locais", tipo: "lista", itemNome: "local", itemCampos: [
        { nome: "nome", tipo: "text" },
        { nome: "txt", tipo: "text", rotulo: "Descrição" },
      ] },
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
      { nome: "setores", tipo: "lista", itemNome: "setor", itemCampos: [
        { nome: "id", tipo: "text" },
        { nome: "nome", tipo: "text" },
        { nome: "subtitulo", tipo: "text" },
      ] },
      { nome: "salas", tipo: "lista", itemNome: "sala", itemCampos: [
        { nome: "id", tipo: "text" },
        { nome: "setor", tipo: "text", rotulo: "ID do setor" },
        { nome: "nome", tipo: "text" },
        { nome: "tipo", tipo: "text" },
        { nome: "x", tipo: "number" },
        { nome: "y", tipo: "number" },
        { nome: "txt", tipo: "text", rotulo: "Descrição" },
      ] },
      // "ligacoes" fica cru: é lista de PARES [ida, volta] (ex: [["L1","L2"]]),
      // não array de objeto — não cabe no sub-schema fixo de "lista".
      { nome: "ligacoes", tipo: "json", rotulo: "Ligações (pares [sala_a, sala_b] — formato especial, editar como JSON)" },
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
      { nome: "logo_url", tipo: "imagem", rotulo: "Logo" },
      { nome: "destaque", tipo: "bool" },
      { nome: "recrutando", tipo: "bool", rotulo: "Recrutando (aparece na aba de Recrutamento pros jogadores sem clã)" },
      { nome: "profissoes_aceitas", tipo: "lista-texto", rotulo: "Profissões aceitas (vazio = aceita qualquer uma)" },
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
      { nome: "reputacao", tipo: "lista", itemNome: "frente", itemCampos: [
        { nome: "frente", tipo: "text", rotulo: "Frente (ex: Cidade do Início)" },
        { nome: "estado", tipo: "text" },
      ] },
      { nome: "ganchos", tipo: "lista", segredo: true, itemNome: "gancho", itemCampos: [
        { nome: "tipo", tipo: "sugestao", opcoes: ["Favor", "Erro", "Rumor", "Oportunidade"] },
        { nome: "texto", tipo: "text" },
      ] },
      // Hub de Aincrad — item 4 (sistema de clã/guilda): liderança e
      // estatísticas exibidas na página pública /guildas. membros_count e
      // nivel_medio NÃO entram aqui — são computados na view clas_publico
      // (join com personagens/nivel_profissao), não são coluna editável.
      { nome: "lider_personagem", tipo: "sugestao", tabelaRef: "personagens", campoRef: "nome", rotulo: "Líder" },
      { nome: "vice_lider_personagem", tipo: "sugestao", tabelaRef: "personagens", campoRef: "nome", rotulo: "Vice-Líder" },
      { nome: "missoes_concluidas", tipo: "number", min: 0, rotulo: "Missões concluídas (contador manual)" },
      { nome: "bosses_derrotados", tipo: "number", min: 0, rotulo: "Bosses derrotados (some sozinho ao usar \"Marcar boss derrotado\" no andar)" },
      { nome: "conquistas", tipo: "lista-texto", rotulo: "Conquistas (ex: Primeiros Exploradores, Boss Slayers)" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  noticias: {
    pk: "id",
    rotulo: "Notícias de Aincrad",
    icone: "📰",
    campos: [
      { nome: "titulo", tipo: "text" },
      { nome: "categoria", tipo: "select", opcoes: NOTICIA_CATEGORIA },
      { nome: "andar", tipo: "number", min: 1, rotulo: "Andar (opcional)" },
      { nome: "dia_aincrad", tipo: "number", min: 1, rotulo: "Dia de Aincrad (opcional)" },
      { nome: "texto", tipo: "textarea" },
      { nome: "destaque", tipo: "bool", rotulo: "Destaque (banner SYSTEM ANNOUNCEMENT)" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  andares: {
    pk: "numero",
    rotulo: "Andares",
    icone: "🏯",
    campos: [
      { nome: "numero", tipo: "number", min: 1 },
      { nome: "nome", tipo: "text", rotulo: "Nome / Região", grupo: "🏯 Geral" },
      { nome: "status", tipo: "select", opcoes: ANDAR_STATUS, grupo: "🏯 Geral" },
      { nome: "exploracao_pct", tipo: "number", min: 0, max: 100, rotulo: "Exploração (%)", grupo: "🏯 Geral" },
      { nome: "info_descobertas", tipo: "textarea", rotulo: "Informações importantes descobertas", grupo: "🏯 Geral" },
      { nome: "monstros_conhecidos", tipo: "lista-texto", rotulo: "Monstros conhecidos", grupo: "🏯 Geral" },
      { nome: "mvp_personagem_nome", tipo: "sugestao", tabelaRef: "personagens", campoRef: "nome", rotulo: "MVP do andar", grupo: "🏅 MVP" },
      { nome: "mvp_feito", tipo: "text", rotulo: "Feito do MVP", grupo: "🏅 MVP" },
      { nome: "mvp_titulo", tipo: "text", rotulo: "Título conquistado pelo MVP", grupo: "🏅 MVP" },
      { nome: "boss_status", tipo: "select", opcoes: BOSS_STATUS, rotulo: "Status do Boss", grupo: "👹 Boss" },
      { nome: "boss_nome", tipo: "text", rotulo: "Nome do Boss", grupo: "👹 Boss" },
      { nome: "boss_img", tipo: "imagem", rotulo: "Imagem do Boss", grupo: "👹 Boss" },
      { nome: "boss_localizacao", tipo: "text", rotulo: "Localização do Boss", grupo: "👹 Boss" },
      { nome: "boss_info", tipo: "textarea", rotulo: "Informações conhecidas do Boss", grupo: "👹 Boss" },
      { nome: "boss_grupo_responsavel", tipo: "text", rotulo: "Grupo responsável pela derrota", grupo: "👹 Boss" },
      { nome: "boss_participantes", tipo: "lista-texto", rotulo: "Jogadores participantes da luta", grupo: "👹 Boss" },
      { nome: "boss_recompensas", tipo: "textarea", rotulo: "Recompensas", grupo: "👹 Boss" },
      { nome: "boss_drops", tipo: "textarea", rotulo: "Drops conhecidos", grupo: "👹 Boss" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  eventos_globais: {
    pk: "id",
    rotulo: "Eventos Globais",
    icone: "🌍",
    campos: [
      { nome: "nome", tipo: "text" },
      { nome: "descricao", tipo: "textarea" },
      { nome: "objetivo", tipo: "textarea" },
      { nome: "status", tipo: "select", opcoes: EVENTO_STATUS },
      { nome: "progresso_pct", tipo: "number", min: 0, max: 100, rotulo: "Progresso global (%)" },
      { nome: "participantes", tipo: "text" },
      { nome: "recompensa", tipo: "textarea", rotulo: "Recompensa Global" },
      { nome: "consequencia_fracasso", tipo: "textarea", rotulo: "Consequência em caso de fracasso" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  eventos_globais_objetivos: {
    pk: "id",
    // Renomeado (era "Objetivos de Evento Global"): ficava colado do
    // "Objetivo" (texto único) que eventos_globais já tem — duas coisas
    // chamadas quase igual lado a lado no /evento-global confundia (achado
    // do usuário: "vários objetivos, objetivos, acho que não tá certo").
    rotulo: "Metas de Evento Global",
    icone: "📋",
    campos: [
      { nome: "evento_id", tipo: "sugestao", tabelaRef: "eventos_globais", campoRef: "id", rotulo: "Evento" },
      { nome: "descricao", tipo: "text", rotulo: "Descrição (ex: Derrotar 100 Lobos Cinzentos)" },
      { nome: "meta", tipo: "number", min: 0 },
      { nome: "atual", tipo: "number", min: 0 },
    ],
  },
  diario_entradas: {
    pk: "id",
    rotulo: "Diário de Aincrad",
    icone: "📔",
    campos: [
      { nome: "dia", tipo: "number", min: 1, rotulo: "Dia de Aincrad" },
      { nome: "autor_tipo", tipo: "select", opcoes: ["mestre", "jogador"], rotulo: "Registro do..." },
      { nome: "autor_personagem_nome", tipo: "sugestao", tabelaRef: "personagens", campoRef: "nome", rotulo: "Personagem (se for registro de jogador)" },
      { nome: "titulo", tipo: "text" },
      { nome: "texto", tipo: "textarea" },
      { nome: "categoria", tipo: "text", rotulo: "Categoria (livre, ex: boss, descoberta, rumor)" },
      { nome: "visivel", tipo: "bool" },
    ],
  },
  estado_aincrad: {
    pk: "id",
    rotulo: "Estado de Aincrad",
    icone: "📊",
    campos: [
      { nome: "dia_atual", tipo: "number", min: 1 },
      { nome: "mortes", tipo: "number", min: 0 },
      { nome: "andar_atual", tipo: "number", min: 1, rotulo: "Andar atual (vazio = calcula sozinho pelo mais avançado destravado)" },
      { nome: "texto_extra", tipo: "textarea" },
    ],
  },
  feedback: {
    pk: "id",
    rotulo: "Bug Reports & Sugestões",
    icone: "🐛",
    campos: [
      { nome: "tipo", tipo: "select", opcoes: ["bug", "sugestao"] },
      { nome: "personagem_nome", tipo: "sugestao", tabelaRef: "personagens", campoRef: "nome", rotulo: "Enviado por" },
      { nome: "titulo", tipo: "text" },
      { nome: "descricao", tipo: "textarea" },
      { nome: "pagina", tipo: "text", rotulo: "Página de onde foi enviado" },
      { nome: "status", tipo: "select", opcoes: ["aberto", "em_analise", "resolvido", "recusado"] },
      { nome: "resposta_mestre", tipo: "textarea", rotulo: "Resposta (o jogador vê isso na própria lista de envios)" },
    ],
  },
  pontos: {
    pk: "id",
    rotulo: "Pontos do Mapa",
    icone: "📍",
    viewLeitura: "pontos_publico",
    // "grupo": divide a tela de criar/editar em seções (achado do usuário:
    // 18 campos soltos numa lista só ficava ruim de navegar). Puramente
    // visual — não muda nada no salvar.
    campos: [
      { nome: "id", tipo: "text" },
      { nome: "regiao", tipo: "text", grupo: "📍 Localização" },
      { nome: "nome", tipo: "text", grupo: "📍 Localização" },
      // trava: a cor/ícone no mapa (Compendio.vue CAT_INFO) depende
      // exatamente desses 9 valores — categoria errada vira ponto cinza
      // sem legenda no mapa.
      { nome: "categoria", tipo: "select", opcoes: PONTOS_CATEGORIA, grupo: "📍 Localização" },
      { nome: "x", tipo: "number", min: 0, max: 1536, rotulo: "X (0-1536, mesmo viewBox do mapa)", grupo: "📍 Localização" },
      { nome: "y", tipo: "number", min: 0, max: 1024, rotulo: "Y (0-1024, mesmo viewBox do mapa)", grupo: "📍 Localização" },
      { nome: "tipo", tipo: "select", opcoes: PONTOS_TIPO, grupo: "📍 Localização" },
      { nome: "ref", tipo: "text", grupo: "📍 Localização" },
      { nome: "descricao", tipo: "textarea", grupo: "📝 Conteúdo" },
      { nome: "respawn_horas", tipo: "number", grupo: "📝 Conteúdo" },
      {
        nome: "teste", tipo: "objeto", grupo: "⚔️ Combate / Teste",
        campos: [
          { nome: "atributo", tipo: "select", opcoes: ATRIBUTOS },
          { nome: "sucesso", tipo: "textarea" },
          { nome: "parcial", tipo: "textarea" },
          { nome: "falha", tipo: "textarea" },
        ],
      },
      { nome: "recompensa", tipo: "textarea", grupo: "⚔️ Combate / Teste" },
      { nome: "ameaca", tipo: "text", grupo: "⚔️ Combate / Teste" },
      { nome: "golpes", tipo: "text", grupo: "⚔️ Combate / Teste" },
      { nome: "atributo_fraqueza", tipo: "select", opcoes: ATRIBUTOS, grupo: "⚔️ Combate / Teste" },
      { nome: "fala", tipo: "textarea", grupo: "🗣️ NPC / Comércio" },
      { nome: "oferece", tipo: "text", grupo: "🗣️ NPC / Comércio" },
      { nome: "vende", tipo: "text", grupo: "🗣️ NPC / Comércio" },
      { nome: "obs", tipo: "textarea", grupo: "🔒 Notas & visibilidade" },
      { nome: "mestre", tipo: "textarea", segredo: true, grupo: "🔒 Notas & visibilidade" },
      { nome: "visivel", tipo: "bool", grupo: "🔒 Notas & visibilidade" },
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
      { nome: "acoes", tipo: "lista", itemNome: "ação", itemCampos: ITEM_CAMPOS_ACAO_TESTAVEL },
      { nome: "mestre", tipo: "textarea", segredo: true },
      { nome: "atalhos", tipo: "lista", itemNome: "atalho", itemCampos: [
        { nome: "id", tipo: "sugestao", tabelaRef: "pontos", campoRef: "id", rotulo: "ID (de outro ponto/entidade)" },
        { nome: "tipo", tipo: "text", rotulo: "Tipo (ex: regiao, monstro, npc)" },
      ] },
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
      { nome: "acoes", tipo: "lista", itemNome: "ação", itemCampos: ITEM_CAMPOS_ACAO_TESTAVEL },
      { nome: "postos", tipo: "lista", itemNome: "posto", itemCampos: [
        { nome: "ponto", tipo: "sugestao", tabelaRef: "pontos", campoRef: "id" },
        { nome: "txt", tipo: "text", rotulo: "Descrição" },
      ] },
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
      { nome: "itens", tipo: "lista", itemNome: "item", itemCampos: [
        { nome: "produz", tipo: "text" },
        { nome: "precisa", tipo: "text" },
        { nome: "teste", tipo: "text", rotulo: "Teste (ex: 2d6+Conhecimento)" },
        { nome: "sucesso", tipo: "text", rotulo: "10+ (sucesso)" },
        { nome: "parcial", tipo: "text", rotulo: "7-9 (parcial)" },
      ] },
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
      { nome: "efeitos", tipo: "chave-valor", rotulo: "Efeitos (chave livre, ex: bonus → +6%)" },
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
      { nome: "efeitos_padrao", tipo: "chave-valor", rotulo: "Efeitos padrão (chave livre, ex: bonus_caca → +3%)" },
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
      { nome: "efeitos", tipo: "chave-valor", rotulo: "Efeitos (chave livre)" },
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
    k: "hub",
    lbl: "Hub de Aincrad",
    ico: "🌐",
    tabelas: ["noticias", "andares", "eventos_globais", "eventos_globais_objetivos", "diario_entradas", "estado_aincrad", "feedback"],
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
