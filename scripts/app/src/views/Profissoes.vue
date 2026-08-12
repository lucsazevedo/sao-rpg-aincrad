<template>
  <div>
    <div v-if="!auth.logado" class="msg info">
      🔒 <a href="#" @click.prevent="$emit('pedir-login')">Entre</a> para ver
      suas receitas e seus materiais.
    </div>
    <div v-else-if="!auth.temPersonagem" class="msg warn">
      ⚠️ Sem ficha. Peça ao mestre pra criar.
    </div>
    <div v-else>
      <StatusBar />
      <!-- ITEM 6: HEADER = NOME DA PROFISSÃO DO USUÁRIO LOGADO -->
      <TituloHUD icone="🛠️" :titulo="tituloPagina" trilha="Sistema · Ofício" />
      <p
        v-if="descricaoProfissao"
        style="margin: 0 0 10px; color: var(--ink-dim); font-size: 13px"
      >
        {{ descricaoProfissao }}
      </p>
      <div class="tabs" style="margin: 8px 0">
        <div
          v-for="t in abas"
          :key="t.k"
          class="tab"
          :class="{ on: aba === t.k }"
          @click="aba = t.k"
        >
          {{ t.label }}
        </div>
      </div>

      <!-- Aba Minhas Receitas (NÃO TEM 'Todas as profissões' — regra do usuário) -->
      <div v-if="aba === 'minhas'">
        <div style="display: flex; gap: 10px; flex-wrap: wrap; margin: 10px 0">
          <input
            v-model="busca"
            placeholder="🔎 Buscar receita…"
            style="
              flex: 1 1 200px;
              background: var(--panel-3);
              border: 1px solid var(--line);
              color: var(--ink);
              padding: 9px 12px;
              border-radius: 6px;
              font: inherit;
            "
          />
          <select
            v-model="filtroNivel"
            style="
              background: var(--panel-3);
              border: 1px solid var(--line);
              color: var(--ink);
              padding: 9px 12px;
              border-radius: 6px;
              font: inherit;
            "
          >
            <option value="">Todos os níveis</option>
            <option v-for="n in [1, 2, 3, 4, 5]" :key="n" :value="String(n)">
              Nível {{ n }}
            </option>
            <option value="ref">Refino (estágio 2)</option>
          </select>
          <select
            v-model="filtroTipo"
            style="
              background: var(--panel-3);
              border: 1px solid var(--line);
              color: var(--ink);
              padding: 9px 12px;
              border-radius: 6px;
              font: inherit;
            "
          >
            <option value="">Item + Ferramenta</option>
            <option value="item">Apenas itens</option>
            <option value="ferramenta">Apenas ferramentas de ofício</option>
          </select>
          <!-- ITEM 12, revisto (11/08): toggle começa DESLIGADO agora. Ligado por
          padrão escondia receita que o jogador ainda não tem material pra
          fazer — inclusive a Incubadora do Domador, que ninguém achava porque
          ela só aparecia depois de já ter os materiais dela (impossível
          descobrir o que precisa juntar se a receita fica invisível até
          juntar). Melhor mostrar tudo do seu nível e deixar craftar
          desabilitado quando faltar material — dá pra ver o que precisa
          coletar. -->
          <label
            style="
              background: var(--panel-3);
              border: 1px solid var(--line);
              padding: 8px 12px;
              border-radius: 6px;
              display: inline-flex;
              gap: 6px;
              align-items: center;
              cursor: pointer;
            "
          >
            <input
              type="checkbox"
              v-model="soFaziveis"
              style="transform: scale(1.2)"
            />
            <span style="font-size: 13px; color: var(--ink)"
              >Mostrar
              <b style="color: var(--gold-bright)"
                >só receitas que eu consigo craftar</b
              ></span
            >
          </label>
        </div>
        <div v-if="carregando" class="msg info carregando">Carregando…</div>
        <div v-else-if="!receitas.length" class="msg warn">
          Ainda não há receitas para esta profissão no banco. Se for Domador, as
          receitas incluem também incubadoras.
        </div>
        <div class="grid">
          <div
            v-for="r in receitasFiltradas"
            :key="r.id"
            class="card"
            @click="abrir(r)"
          >
            <div class="ct">{{ r.nome_resultado || r.id }}</div>
            <div class="cs">
              {{ nomeProf }} · Nv {{ r.nivel_receita }} · {{ r.tipo }}
            </div>
            <p>
              {{
                r.efeitos
                  ? formatarEfeitos(r.efeitos)
                  : "Clique para ver detalhes de craft."
              }}
            </p>
            <div class="faixa">
              <span class="pill rar-comum">🌬️ -{{ r.folego_custo || 0 }}</span>
              <span class="pill rar-incomum"
                >⭐ {{ r.xp_recompensa || 0 }} XP</span
              >
              <span class="pill rar-raro"
                >PBTA {{ r.dificuldade_mod >= 0 ? "+" : ""
                }}{{ r.dificuldade_mod || 0 }}</span
              >
              <span
                :class="
                  'pill rar-' + (r.resultado_raridade || 'comum').toLowerCase()
                "
                >{{ r.resultado_raridade || "comum" }}</span
              >
              <span v-if="r.requer_ferramenta_id" class="pill" :class="temFerramentaExigida(r) ? 'on' : 'bad'">
                🔧 {{ temFerramentaExigida(r) ? "ferramenta ok" : "falta ferramenta" }}
              </span>
            </div>
          </div>
        </div>
      </div>

      <!-- Aba Meus Materiais (SÓ QUE TEM, NÃO MOSTRA CATÁLOGO TODO) -->
      <div v-if="aba === 'materiais'">
        <div v-if="carregandoMat" class="msg info carregando">
          Carregando seus materiais…
        </div>
        <div v-else-if="!meusMateriais.length" class="msg warn">
          Você não tem nenhum material ainda. Faça missões para obter drops!
        </div>
        <div v-else class="grid">
          <div v-for="m in meusMateriais" :key="m.id" class="card">
            <div class="ct">{{ m.nome || m.id }}</div>
            <div class="cs">
              {{ m.raridade || "comum" }} · {{ m.categoria || "material" }}
            </div>
            <p>{{ m.descricao || "—" }}</p>
            <div class="faixa">
              <span class="pill on">📦 x {{ m.qtd }}</span>
              <span class="pill">Nv. obtenção {{ m.nivel_obtencao || 1 }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Aba Pets/Incubando (se tiver ovos/pets) -->
      <div v-if="aba === 'pets'">
        <PetsTab @pedir-login="$emit('pedir-login')" />
      </div>
    </div>

    <div
      v-if="selecionada"
      class="modal-bg on"
      @click.self="selecionada = null"
    >
      <div class="modal">
        <div class="top">
          <h2>Craftar · {{ selecionada.nome_resultado || selecionada.id }}</h2>
          <button class="btn ghost" @click="selecionada = null">✕</button>
        </div>
        <div class="body">
          <div
            style="
              display: grid;
              grid-template-columns: 1fr 1fr;
              gap: 12px;
              margin-bottom: 12px;
            "
          >
            <div class="pill">Profissão: {{ selecionada.profissao }}</div>
            <div class="pill">Nível: {{ selecionada.nivel_receita }}</div>
            <div class="pill">Fôlego: -{{ selecionada.folego_custo || 0 }}</div>
            <div class="pill">XP: +{{ selecionada.xp_recompensa || 0 }}</div>
            <div class="pill">
              Raridade: {{ selecionada.resultado_raridade || "comum" }}
            </div>
            <div class="pill">Tipo: {{ selecionada.tipo }}</div>
          </div>
          <template v-if="selecionada.requer_ferramenta_id">
            <h4 style="margin: 10px 0 6px; color: var(--gold-bright)">
              Ferramenta exigida
            </h4>
            <div class="card" style="padding: 8px 12px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px">
              <b>{{ nomeFerramenta(selecionada.requer_ferramenta_id) }}</b>
              <span class="pill" :class="temFerramentaExigida(selecionada) ? 'on' : 'bad'">
                {{ temFerramentaExigida(selecionada) ? "✅ você tem" : "❌ falta craftar" }}
              </span>
            </div>
          </template>
          <h4 style="margin: 10px 0 6px; color: var(--gold-bright)">
            Materiais necessários
          </h4>
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 6px">
            <div
              v-for="mt in listaMat"
              :key="mt.mat_id"
              class="card"
              style="padding: 8px 12px"
            >
              <div
                style="
                  display: flex;
                  justify-content: space-between;
                  align-items: center;
                "
              >
                <div>
                  <b>{{ mt.mat_nome || mt.mat_id }}</b>
                </div>
                <div class="pill" :class="temMat(mt) ? 'on' : 'bad'">
                  {{ qtdMat(mt) }} / {{ mt.qtd }}
                </div>
              </div>
            </div>
          </div>
          <div
            style="
              margin-top: 14px;
              display: flex;
              gap: 10px;
              justify-content: flex-end;
            "
          >
            <button class="btn" @click="selecionada = null">Cancelar</button>
            <button
              class="btn primario"
              :disabled="!possoCraftar"
              @click="craftar"
            >
              ⚔️ Craftar
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useAuthStore } from "../stores/auth.js";
import { useSupa } from "../lib/supabase.js";
import StatusBar from "../components/StatusBar.vue";
import TituloHUD from "../components/TituloHUD.vue";
import PetsTab from "./PetsTab.vue";

const auth = useAuthStore();
defineEmits(["pedir-login"]);
const supa = useSupa();

const aba = ref("minhas");
const abas = [
  { k: "minhas", label: "🛠️ Minhas Receitas" },
  { k: "materiais", label: "🎒 Meus Materiais" },
  { k: "pets", label: "🐾 Pets / Ovos" },
];

const carregando = ref(false),
  carregandoMat = ref(false);
const busca = ref(""),
  filtroNivel = ref(""),
  filtroTipo = ref("");
const receitas = ref([]),
  catalogoMat = ref([]),
  meuInv = ref([]),
  minhasFerramentas = ref([]), // ids de ferramenta_id que o personagem já tem
  ferramentasCatalogo = ref([]); // ferramentas_oficio, pra mostrar nome bonito
const selecionada = ref(null);

// ===== ITEM 6: Título página = NOME da profissão do usuário =====
const nomeProf = computed(() => auth.personagem?.profissao || "");
const PROF_GANCHOS = {
  Ferreiro:   { desc: "Forja armas, armaduras e ferramentas de metal. Trabalha cobre, bronze, ferro e aço." },
  Alquimista: { desc: "Mistura ervas, óleos e compostos para poções, bálsamos e alquimia avançada." },
  Caçador:    { desc: "Rastreia, abate e prepara monstros e animais para obter peles, carnes e ossos." },
  Lenhador:   { desc: "Corta árvores, processa madeira e cria componentes de madeira nobre." },
  Costureiro: { desc: "Costura tecidos, peles e couros para roupas, armaduras leves e itens de tecido." },
  Coureiro:   { desc: "Cura, prepara e trabalha couros e peles para botas, braceletes e armaduras." },
  Joalheiro:  { desc: "Faz jóias, amuletos, anéis e encantamentos leves em metais e gemas preciosas." },
  Mineiro:    { desc: "Extrai minérios, gemas e pedras de minas e jazidas pelo mundo de Aincrad." },
  Cozinheiro: { desc: "Prepara pratos, comidas e bebidas restauradoras a partir de ingredientes crus." },
  Médico:     { desc: "Faz curativos, remédios, antídotos e cirurgias em campo de batalha." },
  FerreiroNegro:{ desc:"Forja itens finos e encantados com metais raros e acabamento de mestre." },
  Cartógrafo: { desc: "Desenha mapas, copia pergaminhos e registra rotas novas de Aincrad." },
  Escrivão:   { desc: "Transcreve documentos, cria pergaminhos, pinta tintas e faz encadernações." },
  Domador:    { desc: "Cuida, doma e treina bestas e montarias de Aincrad (ovos, pets)." },
  Diplomata:  { desc: "Negocia tratados, mediadores e relações públicas entre clãs e vilas." },
  Músico:     { desc: "Toca instrumentos, compõe canções e executa bardices em eventos da vila." },
  Carpinteiro:{ desc: "Fabrica móveis, estruturas de madeira e itens de madeira fina." },
  Bibliotecário:{ desc:"Copia, organiza e cataloga livros, grimórios e conhecimentos antigos." },
  Comerciante:{ desc: "Compra, vende, negocia e avalia mercadorias em feiras livres." },
  Coveiro:   { desc: "Prepara sepultamentos, velórios e lida com o além-caixão da vila." },
};
const tituloPagina = computed(() => {
  const n = nomeProf.value || "Sem profissão definida";
  return n.charAt(0).toUpperCase() + n.slice(1);
});
const descricaoProfissao = computed(() => {
  const n = nomeProf.value || "";
  if (!n) return "";
  const chave = Object.keys(PROF_GANCHOS).find(k => n.toLowerCase().includes(k.toLowerCase()));
  if (chave) return PROF_GANCHOS[chave].desc;
  return "Ofícios de sua profissão e receitas de craft para seu nível atual.";
});

// ===== ITEM 12: Mostrar apenas RECEITAS FAZÍVEIS (ligado por padrão) =====
const soFaziveis = ref(false);
function possoCraftarReceita(r) {
  if (r.requer_ferramenta_id && !minhasFerramentas.value.includes(r.requer_ferramenta_id)) return false;
  const mats = Array.isArray(r.materiais_com_nome) ? r.materiais_com_nome : (
    Array.isArray(r.materiais) ? r.materiais :
    (typeof r.materiais === "object" ? Object.keys(r.materiais).map(k => ({ mat_id: k, qtd: r.materiais[k] })) : [])
  );
  const somas = {};
  const inv = meuInv.value.filter(it => it.tipo === "material" && !it.excluido);
  inv.forEach(i => { somas[i.item_id] = (somas[i.item_id] || 0) + (i.qtd || 1); });
  return mats.every(m => (somas[m.mat_id] || 0) >= (m.qtd || 0));
}
function temFerramentaExigida(r) {
  return !r?.requer_ferramenta_id || minhasFerramentas.value.includes(r.requer_ferramenta_id);
}
function nomeFerramenta(id) {
  const f = ferramentasCatalogo.value.find(x => x.id === id);
  return f?.nome || id;
}

const receitasFiltradas = computed(() => {
  const prof = nomeProf.value;
  let lista = receitas.value.filter((r) => r.profissao === prof);
  // ITEM 12: Apenas receitas FAZÍVEIS (padrão)
  if (soFaziveis.value) lista = lista.filter(r => possoCraftarReceita(r));
  if (filtroNivel.value === "ref")
    lista = lista.filter((r) => r.receita_refino);
  else if (filtroNivel.value)
    lista = lista.filter((r) => String(r.nivel_receita) === filtroNivel.value);
  if (filtroTipo.value)
    lista = lista.filter((r) => r.tipo === filtroTipo.value);
  if (busca.value) {
    const s = busca.value.toLowerCase();
    lista = lista.filter(
      (r) =>
        [(r.nome_resultado||r.id), r.tipo, (r.efeitos? JSON.stringify(r.efeitos):"")].join(" ").toLowerCase().indexOf(s) >=
        0,
    );
  }
  return lista;
});

const meuInvPorMat = computed(() => {
  const somas = {};
  const inv = meuInv.value.filter(
    (it) => it.tipo === "material" && !it.excluido,
  );
  inv.forEach((i) => {
    somas[i.item_id] = (somas[i.item_id] || 0) + (i.qtd || 1);
  });
  return somas;
});
const meusMateriais = computed(() => {
  const ids = Object.keys(meuInvPorMat.value);
  return ids.map((id) => {
    const m = catalogoMat.value.find((x) => x.id === id) || { id, nome: id };
    return Object.assign({}, m, { qtd: meuInvPorMat.value[id] });
  });
});

const listaMat = computed(() => {
  if (!selecionada.value) return [];
  const mats = selecionada.value.materiais || [];
  // formato esperado: [{mat_id, qtd}] ou {mat_id: qtd}
  if (Array.isArray(mats)) return mats;
  if (typeof mats === "object")
    return Object.keys(mats).map((k) => ({ mat_id: k, qtd: mats[k] }));
  return [];
});
const possoCraftar = computed(() => temFerramentaExigida(selecionada.value) && listaMat.value.every((m) => temMat(m)));
function temMat(m) {
  return qtdMat(m) >= m.qtd;
}
function qtdMat(m) {
  return meuInvPorMat.value[m.mat_id] || 0;
}

async function carregar() {
  carregando.value = true;
  try {
    const [rReceitas, rMats, rInv, rFerr, rMinhasFerr] = await Promise.all([
      supa
        .from("receitas")
        .select("*")
        .eq("visivel", true)
        .eq("excluido", false),
      supa
        .from("materiais_basicos")
        .select("*")
        .eq("visivel", true)
        .eq("excluido", false),
      supa
        .from("inventario")
        .select("*")
        .eq("personagem_nome", auth.personagem.nome)
        .eq("excluido", false),
      supa.from("ferramentas_oficio").select("id,nome,profissao"),
      supa.from("personagem_ferramentas").select("ferramenta_id").eq("personagem_nome", auth.personagem.nome),
    ]);
    if (rReceitas.error) throw rReceitas.error;
    if (rMats.error) throw rMats.error;
    if (rInv.error) throw rInv.error;
    receitas.value = rReceitas.data || [];
    catalogoMat.value = rMats.data || [];
    ferramentasCatalogo.value = rFerr.data || [];
    minhasFerramentas.value = (rMinhasFerr.data || []).map((f) => f.ferramenta_id);
    // Completa nome_mat em receitas.materiais
    receitas.value.forEach((r) => {
      const lista = Array.isArray(r.materiais)
        ? r.materiais
        : typeof r.materiais === "object"
          ? Object.keys(r.materiais).map((k) => ({
              mat_id: k,
              qtd: r.materiais[k],
            }))
          : [];
      lista.forEach((m) => {
        const cat = catalogoMat.value.find((x) => x.id === m.mat_id);
        if (cat) m.mat_nome = cat.nome;
      });
      r.materiais_com_nome = lista;
    });
  } catch (e) {
    console.error(e);
  } finally {
    carregando.value = false;
  }
}

async function carregarMateriais() {
  carregandoMat.value = true;
  try {
    const [rMats, rInv] = await Promise.all([
      supa
        .from("materiais_basicos")
        .select("*")
        .eq("visivel", true)
        .eq("excluido", false),
      supa
        .from("inventario")
        .select("*")
        .eq("personagem_nome", auth.personagem.nome)
        .eq("excluido", false),
    ]);
    if (rMats.error) throw rMats.error;
    if (rInv.error) throw rInv.error;
    catalogoMat.value = rMats.data || [];
    meuInv.value = rInv.data || [];
  } catch (e) {
    console.error(e);
  } finally {
    carregandoMat.value = false;
  }
}

function formatarEfeitos(e) {
  if (!e) return "";
  if (typeof e === "object")
    return Object.keys(e)
      .map((k) => `${k}: ${e[k]}`)
      .join(" · ");
  return String(e);
}

function abrir(r) {
  // Trocar materiais já com nome
  selecionada.value = Object.assign({}, r, {
    materiais: r.materiais_com_nome || r.materiais,
  });
}

async function craftar() {
  const fn =
    selecionada.value.tipo === "ferramenta"
      ? "craftar_ferramenta"
      : "craftar_item";
  try {
    const r = await supa.rpc(fn, { p_receita_id: selecionada.value.id });
    if (r.error) throw r.error;
    const txt = typeof r.data === "string" ? r.data : JSON.stringify(r.data);
    alert("✅ Resultado do Craft:\n\n" + txt.slice(0, 1200));
    await auth.carregarPerfilEPersonagem();
    await carregar();
    await carregarMateriais();
    selecionada.value = null;
  } catch (e) {
    alert("Erro no craft: " + e.message);
  }
}

onMounted(async () => {
  if (!auth.ready) await auth.init();
  if (auth.temPersonagem) {
    await carregar();
    await carregarMateriais();
  }
});
</script>
