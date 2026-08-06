/* Sessao de mestre (Supabase Auth) + carregamento dos dados do banco.
   Chame `await carregarDadosSupabase()` antes de usar NPCS, MONSTROS, etc. —
   essa funcao popula as MESMAS variaveis globais que os dados_*.js estaticos
   populavam antes, entao o resto do compendio nao precisa mudar.

   Visibilidade real: quem decide se um NPC/monstro/clã/etc. aparece pro
   jogador e' a coluna `visivel` no banco (RLS aplica sozinho). Editar isso
   hoje: painel do Supabase (Table Editor) -> marca/desmarca a caixinha
   `visivel` na linha. O botao "Modo Mestre" aqui embaixo serve pra logar e
   ver o que esta escondido direto no compendio, pra conferir antes de
   liberar — nao e' (ainda) um editor completo. */

var TABELAS_COM_VIEW_PUBLICA = {
  monstros: "monstros_publico",
  guias: "guias_publico",
  puzzles: "puzzles_publico",
  pontos: "pontos_publico",
  pontos_detalhe: "pontos_detalhe_publico",
  clas: "clas_publico",
};

var _sb = null;
function supaClient() {
  if (!_sb) _sb = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
  return _sb;
}

var _sessao = null;

async function iniciarSessao() {
  var r = await supaClient().auth.getSession();
  _sessao = r.data.session;
  supaClient().auth.onAuthStateChange(function (_evt, session) {
    _sessao = session;
  });
  return _sessao;
}

function estaLogado() {
  return !!_sessao;
}

async function fazerLogin(email, senha) {
  var r = await supaClient().auth.signInWithPassword({ email: email, password: senha });
  if (r.error) throw r.error;
  _sessao = r.data.session;
  return true;
}

async function fazerLogout() {
  await supaClient().auth.signOut();
  _sessao = null;
}

async function carregarLista(tabela) {
  var viewPublica = TABELAS_COM_VIEW_PUBLICA[tabela];
  var alvo = viewPublica && !estaLogado() ? viewPublica : tabela;
  var r = await supaClient().from(alvo).select("*");
  if (r.error) {
    console.error("Falha ao carregar " + tabela + ":", r.error.message);
    return [];
  }
  return r.data || [];
}

function paraDict(lista, chave) {
  var out = {};
  lista.forEach(function (item) {
    out[item[chave]] = item;
  });
  return out;
}

/* ---------------- bootstrap principal ---------------- */

async function carregarDadosSupabase() {
  await iniciarSessao();

  var [
    npcs, monstros, armas, movesArma, movesProfissao, sistema, equipamentos,
    mercado, mercadoItens, compraMateriais, quests, cronicas, guias, puzzles,
    oficios, salasDungeon, producao, pontosDetalhe, pontos, dungeons, clas,
  ] = await Promise.all([
    carregarLista("npcs"),
    carregarLista("monstros"),
    carregarLista("armas"),
    carregarLista("moves_arma"),
    carregarLista("moves_profissao"),
    carregarLista("sistema"),
    carregarLista("equipamentos"),
    carregarLista("mercado"),
    supaClient().from("mercado_itens").select("*").then(function (r) { return r.data || []; }),
    carregarLista("compra_materiais"),
    carregarLista("quests"),
    carregarLista("cronicas"),
    carregarLista("guias"),
    carregarLista("puzzles"),
    carregarLista("oficios"),
    carregarLista("salas_dungeon"),
    carregarLista("producao"),
    carregarLista("pontos_detalhe"),
    carregarLista("pontos"),
    carregarLista("dungeons"),
    carregarLista("clas"),
  ]);

  // recompoe mercado[].itens a partir da tabela filha
  var itensPorLoja = {};
  mercadoItens.forEach(function (it) {
    (itensPorLoja[it.mercado_id] = itensPorLoja[it.mercado_id] || []).push(it);
  });
  mercado.forEach(function (m) { m.itens = itensPorLoja[m.id] || []; });

  window.NPCS = npcs;
  window.MONSTROS = monstros;
  window.ARMAS = armas;
  window.MOVES_ARMA = movesArma;
  window.MOVES_PROFISSAO = movesProfissao;
  window.SISTEMA = sistema;
  window.EQUIPAMENTOS = equipamentos;
  window.MERCADO = mercado;
  window.COMPRA_MATERIAIS = compraMateriais;
  window.QUESTS = quests;
  window.CRONICAS = cronicas;
  window.GUIAS = guias;
  window.PUZZLES = puzzles;
  window.OFICIOS = oficios;
  window.SALAS_DUNGEON = paraDict(salasDungeon, "id");
  window.PRODUCAO = paraDict(producao, "profissao");
  window.PONTOS_DETALHE = paraDict(pontosDetalhe, "id");
  window.PONTOS = pontos; // sobrescreve o PONTOS estatico de dados_mapa.js
  window.DUNGEONS = dungeons; // sobrescreve o DUNGEONS estatico de dados_dungeons.js
  window.CLAS = clas; // sobrescreve dados_clas.js
}

/* versao leve pra paginas que so precisam de uma coleção (personagens.html
   nao precisa puxar bestiario, mercado, etc. inteiro) */
async function carregarPersonagens() {
  await iniciarSessao();
  window.PERSONAGENS = await carregarLista("personagens");
}

/* ---------------- botao "Modo Mestre" (login) ---------------- */

function montarBotaoMestre(container) {
  var btn = document.createElement("span");
  btn.className = "pill";
  btn.style.cursor = "pointer";
  btn.textContent = estaLogado() ? "🔓 Modo Mestre" : "🔒 Entrar como mestre";
  btn.addEventListener("click", async function () {
    if (estaLogado()) {
      await fazerLogout();
      location.reload();
      return;
    }
    var email = prompt("E-mail do mestre:");
    if (!email) return;
    var senha = prompt("Senha mestra:");
    if (!senha) return;
    try {
      await fazerLogin(email, senha);
      alert("Logado como mestre — recarregando com os itens escondidos visíveis.");
      location.reload();
    } catch (e) {
      alert("Não deu: " + e.message);
    }
  });
  container.appendChild(btn);
}
