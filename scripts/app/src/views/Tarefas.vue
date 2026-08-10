<template>
  <div>
    <div v-if="!auth.logado" class="msg info">
      🔒 <a href="#" @click.prevent="$emit('pedir-login')">Entrar</a> pra
      acessar as tarefas.
    </div>
    <div v-else-if="!auth.temPersonagem" class="msg warn">
      ⚠️ Sem ficha criada. Avise o mestre.
    </div>
    <div v-else>
      <StatusBar />
      <div class="tabs" style="margin: 12px 0 6px">
        <div
          v-for="a in abas"
          :key="a.k"
          class="tab"
          :class="{ on: abaTarefa === a.k }"
          @click="abaTarefa = a.k"
        >
          {{ a.label }}
        </div>
      </div>

      <!-- ITEM 11: Histórico dinâmico de drops por monstro (abaixo das abas) -->
      <div
        v-if="temHistoricoDrops"
        class="card"
        style="
          padding: 12px 14px;
          margin: 4px 0 14px;
          border-color: var(--gold-dim);
        "
      >
        <div
          style="
            display: flex;
            gap: 8px;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
            flex-wrap: wrap;
          "
        >
          <h3 style="margin: 0; color: var(--gold-bright); font-size: 16px">
            📜 Histórico de drops por monstro
            <small
              style="color: var(--ink-dim); font-weight: 400; font-size: 12px"
            >
              atualiza em tempo real conforme você derrota monstros
            </small>
          </h3>
          <button
            class="btn ghost"
            @click="limparHistoricoDrops"
            style="padding: 4px 10px; font-size: 12px"
          >
            🧹 Limpar
          </button>
        </div>
        <div
          class="grid"
          style="
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 8px;
          "
        >
          <div
            v-for="(hist, monstroKey) in historicoDrops"
            :key="monstroKey"
            class="card"
            style="padding: 8px 10px; margin: 0"
          >
            <div class="ct" style="font-size: 14px; margin-bottom: 4px">
              💀 {{ hist.nomeMonstro }}
            </div>
            <div class="cs" style="margin-bottom: 6px">
              <span class="pill on" style="background: #2a2512"
                >🏆 {{ hist.abates }} abate{{
                  hist.abates === 1 ? "" : "s"
                }}</span
              >
            </div>
            <div
              style="
                display: flex;
                flex-direction: column;
                gap: 3px;
                font-size: 12.5px;
              "
            >
              <div
                v-for="(d, dk) in hist.drops"
                :key="dk"
                style="
                  display: flex;
                  justify-content: space-between;
                  padding: 2px 4px;
                  background: var(--panel-3);
                  border-radius: 4px;
                "
              >
                <span>{{ d.nome }}</span>
                <span style="color: var(--gold-bright); font-weight: 700"
                  >📦 ×{{ d.qtd }}</span
                >
              </div>
              <div
                v-if="!hist.drops || !hist.drops.length"
                style="color: var(--ink-faint); font-size: 12px"
              >
                Nenhum drop registrado ainda.
              </div>
            </div>
          </div>
        </div>
      </div>

      <div
        style="
          display: flex;
          gap: 8px;
          flex-wrap: wrap;
          justify-content: space-between;
          align-items: center;
          margin: 8px 0 14px;
        "
      >
        <h2 style="margin: 0; color: var(--gold-bright)">
          ⚔️ {{ tituloPagina }}
        </h2>
        <div style="display: flex; gap: 8px; flex-wrap: wrap">
          <input
            v-model="busca"
            placeholder="🔎 Buscar tarefa…"
            style="
              background: var(--panel-3);
              border: 1px solid var(--line);
              color: var(--ink);
              padding: 9px 12px;
              border-radius: 6px;
              font: inherit;
              outline: none;
            "
          />
          <select
            v-model="fRar"
            style="
              background: var(--panel-3);
              border: 1px solid var(--line);
              color: var(--ink);
              padding: 9px 12px;
              border-radius: 6px;
              font: inherit;
            "
          >
            <option value="">Todas as raridades</option>
            <option value="comum">Comum</option>
            <option value="incomum">Incomum</option>
            <option value="raro">Raro</option>
            <option value="epico">Épico</option>
            <option value="lendario">Lendário</option>
          </select>
          <button
            class="btn"
            :disabled="carregando"
            @click="carregarTodasMissoes"
          >
            🔄 Recarregar todas
          </button>
        </div>
      </div>

      <!-- ITEM 11: Histórico de drops de monstros DINÂMICO (atualiza toda vez que resolver missão de caça/contrato) -->
      <div
        v-if="
          abaTarefa === 'contrato' ||
          abaTarefa === 'todas' ||
          abaTarefa === 'coleta'
        "
        style="
          margin: 4px 0 14px;
          background: #0f0b19;
          border-color: #251f39;
          padding: 12px 14px;
        "
        class="card"
      >
        <div
          style="
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 8px;
          "
        >
          <h4 style="margin: 0; color: #c9b8ff; font-size: 14px">
            📦 Meu histórico de drops ({{ totalDropsHistorico }} itens ·
            {{ monstrosDiferentes }} monstros)
          </h4>
          <div style="display: flex; gap: 6px; flex-wrap: wrap">
            <select
              v-model="filtroHistoricoMonstro"
              style="
                background: #1a1526;
                border: 1px solid #332a4d;
                color: #e6e2ff;
                padding: 6px 10px;
                border-radius: 6px;
                font: inherit;
                font-size: 12.5px;
              "
            >
              <option value="">Todos os monstros</option>
              <option
                v-for="m in listaMonstrosHistorico"
                :key="m.k"
                :value="m.k"
              >
                {{ m.nome }} ({{ m.qtd }} kills)
              </option>
            </select>
            <button
              class="btn"
              style="padding: 6px 10px; font-size: 12.5px"
              @click="limparHistoricoDrops()"
            >
              🗑️ Limpar histórico
            </button>
          </div>
        </div>
        <div
          v-if="!historicoDropsList.length"
          class="msg info"
          style="margin: 8px 0 0; font-size: 13px"
        >
          Nenhum drop registrado ainda. 🎯 Resolva missões de caça/contrato que
          o histórico vai acumulando aqui automaticamente!
        </div>
        <div v-else class="admin-list" style="margin-top: 6px">
          <div
            v-for="h in historicoDropsFiltrados"
            :key="h.monstro + '|' + h.item"
            class="admin-row"
            style="padding: 8px 12px; background: #14121d"
          >
            <div style="min-width: 60px; text-align: center">
              <span class="pill" style="background: #1a1526">×{{ h.qtd }}</span>
            </div>
            <div style="flex: 1">
              <div class="row-nome" style="color: #e6e2ff">
                {{ h.nomeItem || h.item }}
              </div>
              <div class="row-sub" style="color: #9d90c0">
                💀 Drop de
                <b style="color: #e6e2ff">{{ h.nomeMonstro || h.monstro }}</b> ·
                última vez: {{ fmtData(h.ultimaData) }} · raridade:
                {{ h.raridade || "comum" }}
              </div>
            </div>
            <div style="display: flex; gap: 4px; flex-wrap: wrap">
              <span
                v-for="n in Math.min(h.qtd, 8)"
                :key="n"
                style="font-size: 14px"
                >✨</span
              >
              <span v-if="h.qtd > 8" class="pill" style="background: #1a1526"
                >+{{ h.qtd - 8 }}x</span
              >
            </div>
          </div>
        </div>
      </div>

      <div v-if="carregando" class="msg info">Carregando tarefas…</div>
      <div v-else-if="!tarefas.length" class="msg info">
        Nenhuma tarefa no quadro. Clique em "🎲 Sortear 5".
      </div>
      <div v-else class="grid">
        <div
          v-for="t in tarefas"
          :key="t.id"
          class="card"
          :style="estiloRar(t.raridade)"
        >
          <div class="ct">{{ tituloTarefa(t) }}</div>
          <div class="cs">
            {{ bonitoRar(t.raridade) }} · Nv {{ t.nivel_min }} ·
            {{ bonitoTipo(t.tipo) }}
          </div>
          <p>{{ t.descricao }}</p>
          <div
            v-if="t.drop_item_id || t.alvo"
            class="faixa"
            style="border-top: 1px dashed var(--line); margin-top: 0"
          >
            <span v-if="t.alvo" class="pill"
              >🎯 Alvo:
              {{
                String(t.alvo)
                  .replace(/[-_]+/g, " ")
                  .replace(/\b\w/g, (l) => l.toUpperCase())
              }}<span v-if="t.alvo_qtd"> ×{{ t.alvo_qtd }}</span></span
            >
            <span v-if="t.drop_item_id" class="pill rar-raro"
              >📦 Drop: {{ nomeMaterial(t.drop_item_id)
              }}<span v-if="t.drop_chance">
                ({{ Math.round(100 * (t.drop_chance || 0)) }}%)</span
              ></span
            >
          </div>
          <div class="faixa">
            <span v-if="t.col_recompensa" class="pill"
              >💰 {{ t.col_recompensa }} Col</span
            >
            <span v-if="t.xp_recompensa" class="pill"
              >⭐ {{ t.xp_recompensa }} XP</span
            >
            <span v-if="t.folego_custo" class="pill"
              >🌬️ -{{ t.folego_custo }}</span
            >
            <span class="pill on">🎯 {{ pctSucesso(t) }}% sucesso</span>
          </div>
          <div class="faixa" style="margin-top: auto">
            <b style="font-size: 12px; color: var(--gold-dim)">% 3 vias:</b>
            <span class="pill rar-comum" style="font-size: 10.5px"
              >{{ pctSoma(t, "sucesso_total") }}% total</span
            >
            <span class="pill rar-incomum" style="font-size: 10.5px"
              >{{ pctSoma(t, "sucesso_parcial") }}% parcial</span
            >
            <span class="pill bad" style="font-size: 10.5px"
              >{{ pctSoma(t, "falha") }}% falha</span
            >
          </div>
          <div style="margin-top: 10px">
            <button
              class="btn primario"
              style="width: 100%"
              @click="resolver(t)"
            >
              ⚔️ Resolver
            </button>
          </div>
        </div>
      </div>

      <!-- Modal resultado 2d6 PBTA -->
      <div v-if="resultado" class="modal-bg on" @click.self="resultado = null">
        <div class="modal">
          <div class="top">
            <h2>{{ resultado.titulo }}</h2>
            <button class="btn ghost" @click="resultado = null">✕</button>
          </div>
          <div class="body">
            <div class="dados">
              <div
                class="dado"
                :class="[
                  'animate',
                  resultado.d1 === 1 || resultado.d1 === 2
                    ? 'vermelho'
                    : 'verde',
                ]"
                :key="resAnimK1"
              >
                {{ resultado.d1 }}
              </div>
              <div
                class="dado"
                :class="[
                  'animate',
                  resultado.d2 === 1 || resultado.d2 === 2
                    ? 'vermelho'
                    : 'verde',
                ]"
                :key="resAnimK2"
              >
                {{ resultado.d2 }}
              </div>
            </div>
            <div class="soma">
              Soma + mod = {{ resultado.soma }} + {{ resultado.mod }} =
              <b>{{ resultado.soma + resultado.mod }}</b>
            </div>
            <div class="resumo" v-html="resultado.resumo"></div>
            <div style="text-align: right">
              <button class="btn primario" @click="resultado = null">
                Fechar
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from "vue";
import { useAuthStore } from "../stores/auth.js";
import { useSupa } from "../lib/supabase.js";
import StatusBar from "../components/StatusBar.vue";

const auth = useAuthStore();
defineEmits(["pedir-login"]);
const supa = useSupa();
const carregando = ref(false);
const tarefas = ref([]);
const busca = ref("");
const fRar = ref("");
const resultado = ref(null);
const resAnimK1 = ref(0),
  resAnimK2 = ref(0);
// ====== Item 10: ABAS de tipos de tarefa ======
const abaTarefa = ref("todas");
const abas = [
  { k: "todas", label: "⚔️ Todas as Missões" },
  { k: "coleta", label: "🌿 Missões de Coleta / Ofício / Entrega" },
  { k: "contrato", label: "💀 Contratos de Caça / Monstros" },
  { k: "social", label: "🤝 Missões Sociais" },
];
const TIPOS_COLETA = ["coleta", "oficio", "entrega"];
const TIPOS_CONTRATO = ["caca", "combate", "contrato", "contrato_arriscado"];
const TIPOS_SOCIAL = ["social"];
const tituloPagina = computed(() => {
  const a = abas.find((x) => x.k === abaTarefa.value) || abas[0];
  return a.label.replace(/^\S+\s*/, "");
});

const ATTR = { tecnica: 0, espirito: 0, conhecimento: 0, reflexo: 0, corpo: 0 };
// ===== Helpers de formatação HUMANA (esconde _ e - para o usuário) =====
function limparId(s) {
  if (!s) return "";
  return String(s)
    .replace(/^mat_/, "")
    .replace(/^n\d+-/g, "")
    .replace(/^v\d+-/g, "")
    .replace(/^caca-/, "")
    .replace(/^coleta-/, "")
    .replace(/^oficio-/, "")
    .replace(/^servico-/, "")
    .replace(/^contrato-/, "")
    .replace(/^mao-/, "")
    .replace(/^entrega-/, "")
    .replace(/^social-/, "")
    .replace(/[-_]+/g, " ")
    .trim()
    .replace(/\b\w/g, (l) => l.toUpperCase());
}
const TIPOS_BONITOS = {
  caca: "Caça",
  combate: "Combate",
  coleta: "Coleta",
  oficio: "Ofício",
  entrega: "Entrega",
  social: "Social",
  contrato: "Contrato",
  contrato_arriscado: "Contrato",
  geral: "Geral",
};
const RARIDADES_BONITAS = {
  comum: "Comum",
  incomum: "Incomum",
  raro: "Raro",
  epico: "Épico",
  lendario: "Lendário",
};
function bonitoTipo(v) {
  const k = (v || "geral").toLowerCase();
  return TIPOS_BONITOS[k] || limparId(v);
}
function bonitoRar(v) {
  const k = (v || "comum").toLowerCase();
  return RARIDADES_BONITAS[k] || limparId(v);
}
function tituloTarefa(t) {
  // Preferência: 1) titulo da coluna da tabela; 2) campo nome; 3) último recurso formatando ID.
  if (t && t.titulo && String(t.titulo).trim()) return String(t.titulo).trim();
  if (t && t.nome && String(t.nome).trim()) return String(t.nome).trim();
  return limparId(t && t.id);
}
function nomeMaterial(id) {
  if (!id) return "";
  // materiais_basicos na tabela: id = mat_xyz — limpa o prefixo e Title Case.
  // Melhor ainda: lista dos materiais comuns conhecidos.
  const MAP = {
    mat_argila: "Argila Bruta",
    mat_carne_ruim: "Carne Crua Comum",
    mat_carvao_pedra: "Carvão Mineral",
    mat_erva_comum: "Erva Medicinal Comum",
    mat_ferro_bruto: "Ferro Bruto (sucata)",
    mat_linho_fibra: "Fibra de Linho",
    mat_borracha_látex: "Látex Bruto",
    mat_madeira_comum: "Madeira Comum",
    mat_lingo_pinho: "Madeira de Pinho",
    mat_palha: "Palha Seca",
    mat_pedra_lascada: "Pedra Lascada",
    mat_seda_crua: "Seda Crua (fios)",
    mat_aco_raro: "Aço Raro (lingote)",
    mat_casca_ancia: "Casca de Árvore Anciã",
    mat_essencia_divina: "Essência Divina (gota)",
    mat_casco_dourado: "Favo Dourado Completo",
    mat_gema_branca: "Gema Branca Lapidada",
    mat_manta_termica: "Manta Térmica (peça)",
    mat_nectar_lunar: "Néctar de Flor Lunar",
    mat_nucleo_dragao: "Núcleo de Dragão Bebê",
    mat_nucleo_prata: "Núcleo de Prata",
    mat_olho_sombrio: "Olho de Coruja Sombria",
    mat_osso_chefe: "Osso Lendário de Chefe",
    mat_ouro_folha: "Ouro Folha (24k)",
    mat_couro_cru: "Couro Cru",
    mat_fio_aluminio: "Fio de Alumínio",
    mat_madeira_nodosa: "Madeira Nodosa",
    mat_oleo_animal: "Óleo Animal (banha)",
    mat_cobre_pepita: "Pepita de Cobre",
    mat_pergaminho_sim: "Pergaminho Simples",
    mat_latao_po: "Pó de Latão (esmeril)",
    mat_resina_arvore: "Resina de Árvore",
    mat_tecido_grosso: "Tecido Grosso",
    mat_tinta_preta: "Tinta Preta",
    mat_fio_destino: "Fio de Destino (1 metro)",
    mat_adamantita: "Fragmento de Adamantita",
    mat_aina_crista: "Fragmento de Aincrad",
    mat_gema_andar10: "Gema do Andar 10",
    mat_runa_vida: "Runa de Vida (cópia)",
    mat_aço_incomum: "Aço Incomum (lingote)",
    mat_carnauba: "Cera de Carnaúba",
    mat_coral_negro: "Coral Negro (pedaço)",
    mat_cristal_branco: "Cristal Branco (pequeno)",
    mat_erva_ancestral: "Erva Ancestral",
    mat_fio_seda: "Fio de Seda Selvagem",
    mat_prata_lamina: "Lâmina de Prata (1mm)",
    mat_pelo_lobo_alfa: "Pelagem Grisalha Alfa",
    mat_vidro_temper: "Vidro Temperado",
    // materiais não começados com mat_ (drops antigos):
    "ingrediente-carne-ruim": "Carne Crua Comum",
    "erva-medicinal": "Erva Medicinal Comum",
    "corda-basica": "Corda Básica",
    "pelo-lobo": "Pelo de Lobo",
    "nucleo-cobre": "Núcleo de Cobre",
    "fio-seda": "Fio de Seda",
    "tora-madeira-dura": "Tora de Madeira Dura",
    "lingote-bronze": "Lingote de Bronze",
    "carne-seca": "Carne Seca",
    "semente-anciao": "Semente do Ancião",
    "adaga-kobold": "Adaga de Kobold",
    "peixe-prateado": "Peixe Prateado",
    "pocao-cura-basica": "Poção de Cura Básica",
    "ilfang-adaga": "Adaga do Ilfang",
    "mel-gigante": "Mel de Abelha Gigante",
    "cristal-mana-fragmentado": "Fragmento de Cristal de Mana",
    "armadura-couro-reforcada": "Armadura de Couro Reforçada",
    "incubadora-pequena": "Incubadora Básica",
    "peitoral-animado": "Peitoral Animado",
    "olho-sombrio": "Olho Sombrio",
    "nectar-lunar": "Néctar Lunar",
    "espada-longa-boa": "Espada Longa (Boa)",
    "pele-alfa": "Pele de Alfa Lupino",
    "favo-dourado": "Favo Dourado",
    "casca-arvore-ancia": "Casca de Árvore Anciã",
    "armadura-placas-mestra": "Armadura de Placas Mestra",
    "escama-obsidiana": "Escama de Obsidiana",
    "escama-lagarto": "Escama de Lagarto",
    "gema-bruta": "Gema Bruta",
    "anel-protecao-mestra": "Anel de Proteção Mestra",
  };
  return MAP[String(id)] || limparId(id);
}
const atributosPers = computed(() => {
  const p = auth.personagem;
  return Object.assign({}, ATTR, (p && p.atributos) || {});
});

function raroMod(rar) {
  // Punição EXTREMAMENTE leve — raridade não pune quase nada
  return (
    { comum: 0, incomum: 0, raro: 0, epico: -1, lendario: -2 }[
      rar && rar.toLowerCase()
    ] || 0
  );
}
function pegarModTarefa(t) {
  // Usa atributo PRINCIPAL por TIPO de tarefa (regra imersiva):
  //   caca / combate → Reflexo OU Corpo (o maior)
  //   coleta → Conhecimento OU Corpo (o maior)
  //   oficio → Técnica OU Conhecimento (o maior)
  //   entrega → Reflexo OU Espírito (o maior)
  //   social → Espírito OU Conhecimento (o maior)
  //   contrato_arriscado → MELHOR atributo do personagem (sorte/determinação)
  const a = atributosPers.value;
  const tipo = (t.tipo || "").toLowerCase();
  const max2 = (x, y) => Math.max(Number(a[x] || 0), Number(a[y] || 0));
  if (tipo === "caca" || tipo === "combate") return max2("reflexo", "corpo");
  if (tipo === "coleta") return max2("conhecimento", "corpo");
  if (tipo === "oficio") return max2("tecnica", "conhecimento");
  if (tipo === "entrega") return max2("reflexo", "espirito");
  if (tipo === "social") return max2("espirito", "conhecimento");
  if (tipo === "contrato" || tipo === "contrato_arriscado") {
    return Math.max(
      Number(a.tecnica || 0),
      Number(a.espirito || 0),
      Number(a.conhecimento || 0),
      Number(a.reflexo || 0),
      Number(a.corpo || 0),
    );
  }
  // fallback: atributo_teste se existir, senão Nível de Profissão / 3 (bônus pequeno por experiência)
  if (t.atributo_teste && a[t.atributo_teste] != null)
    return Number(a[t.atributo_teste] || 0);
  const nv = Math.max(1, nivelProfissaoAtual.value);
  return Math.floor(nv / 3);
}
function modTotal(t) {
  // "nivel do personagem" nao existe como coluna — quem trava dificuldade/chance
  // de verdade e' o Nivel de Profissao (mesma fonte que aceitar_e_resolver_missao()
  // usa no servidor pra rolar o resultado real; isto aqui e' só a prévia mostrada
  // antes do clique).
  const nv = nivelProfissaoAtual.value;
  const nivTarefa = t.nivel_min || 1;
  const nivDif = nivTarefa - nv;
  // ===== ITEM 2: PROGRESSÃO de dificuldade POR NÍVEL DA TAREFA (DIFERENTE nv2 vs nv3!) =====
  // Tarefa de nível MAIOR é MAIOR a chance de falha (nd menor).
  // Curva padrão PBTA mas com degrau progressivo, NÃO IGUAL entre nv2 e nv3:
  let nd = 0;
  // Degrau base por nível ALVO da tarefa (nivel_min):
  const degrauPorNivel = {
    1: +2, // nível 1 é MELHOR (iniciante)
    2: +1, // nível 2 é intermediário → 1 degrau MENOS que nv1
    3: 0, // nível 3 é DIFÍCIL → 2 degraus MENOS que nv1 (DIFERENTE de nv2 agora!)
    4: -1, // nível 4 +
    5: -2, // nível 5 +
  };
  const base = degrauPorNivel[nivTarefa] ?? -3;
  if (nivDif >= 2)
    nd = base - 1; // Muito acima do nível → penalisado 1
  else if (nivDif === 1)
    nd = base; // 1 nível acima → base
  else if (nivDif === 0)
    nd = base; // No nível → base (diferenciado!)
  else if (nivDif === -1)
    nd = base + 1; // Abaixo → +1
  else if (nivDif <= -2) nd = base + 2; // Muito abaixo → +2
  const rar = raroMod(t.raridade);
  // BÔNUS GLOBAL: +3 (ajuda extra do sistema para nv1 jogadores sempre terem chance)
  return pegarModTarefa(t) + rar + nd + 3;
}

function countSomas2d6() {
  // distribuições 2d6: 2=1,3=2,4=3,5=4,6=5,7=6,8=5,9=4,10=3,11=2,12=1
  const c = {
    2: 1,
    3: 2,
    4: 3,
    5: 4,
    6: 5,
    7: 6,
    8: 5,
    9: 4,
    10: 3,
    11: 2,
    12: 1,
  };
  let st = 0,
    sp = 0,
    fl = 0;
  for (let s = 2; s <= 12; s++) {
    if (s >= 10) st += c[s];
    else if (s >= 7) sp += c[s];
    else fl += c[s];
  }
  return { c, st, sp, fl, total: st + sp + fl }; // =36
}
const DS = countSomas2d6();
function pctSoma(t, tipo) {
  const mod = modTotal(t);
  // sucesso_total = (soma + mod) >= 10 → soma >= 10 - mod
  // sucesso parcial = 7 <= soma+mod <=9 → 7-mod <= soma <=9-mod
  // falha: soma+mod <=6
  let st = 0,
    sp = 0,
    fl = 0;
  for (let s = 2; s <= 12; s++) {
    const r = s + mod;
    if (r >= 10) st += DS.c[s];
    else if (r >= 7) sp += DS.c[s];
    else fl += DS.c[s];
  }
  const k =
    tipo === "sucesso_total" ? st : tipo === "sucesso_parcial" ? sp : fl;
  return Math.round((100 * k) / DS.total);
}
function pctSucesso(t) {
  return pctSoma(t, "sucesso_total") + pctSoma(t, "sucesso_parcial");
}

const filtradas = computed(() => {
  const t = tarefas.value;
  // ITEM 10: Filtrar por tipo via ABA
  const filt = t.filter(function (m) {
    const tipo = (m.tipo || "").toLowerCase();
    if (abaTarefa.value === "coleta" && !TIPOS_COLETA.includes(tipo))
      return false;
    if (abaTarefa.value === "contrato" && !TIPOS_CONTRATO.includes(tipo))
      return false;
    if (abaTarefa.value === "social" && !TIPOS_SOCIAL.includes(tipo))
      return false;
    if (busca.value) {
      const s = busca.value.toLowerCase();
      const texto = [
        tituloTarefa(m),
        m.descricao,
        bonitoTipo(m.tipo),
        bonitoRar(m.raridade),
        m.alvo,
        nomeMaterial(m.drop_item_id),
      ]
        .join(" ")
        .toLowerCase();
      if (texto.indexOf(s) < 0) return false;
    }
    if (
      fRar.value &&
      (m.raridade || "").toLowerCase() !== fRar.value.toLowerCase()
    )
      return false;
    return true;
  });
  return filt;
});

async function carregarTodasMissoes() {
  carregando.value = true;
  try {
    // NÃO queremos sorteio — queremos TUDO disponível para o jogador escolher
    const r = await supa
      .from("missoes_quadro")
      .select("*")
      .eq("visivel", true)
      .eq("excluido", false)
      .order("nivel_min", { ascending: true })
      .order("tipo", { ascending: true })
      .order("titulo", { ascending: true });
    if (r.error) throw r.error;
    tarefas.value = (r.data || []).map((t) => Object.assign({}, t));
  } catch (e) {
    alert("Erro ao carregar missões: " + e.message);
  } finally {
    carregando.value = false;
  }
}

async function resolver(t) {
  resultado.value = null;
  try {
    const r = await supa.rpc("aceitar_e_resolver_missao", { p_missao_id: t.id });
    if (r.error) throw r.error;
    const js = typeof r.data === "string" ? JSON.parse(r.data) : r.data || {};
    const d1 = (js.dados && js.dados[0]) || Math.floor(Math.random() * 6) + 1;
    const d2 = (js.dados && js.dados[1]) || Math.floor(Math.random() * 6) + 1;
    const mod = modTotal(t);
    (resAnimK1.value++, resAnimK2.value++);
    let tit = "❌ Falha";
    if (js.resultado === "sucesso_total") tit = "🟢 Sucesso Total!";
    else if (js.resultado === "sucesso_parcial") tit = "🟡 Sucesso Parcial";
    resultado.value = {
      titulo: tit,
      d1,
      d2,
      soma: d1 + d2,
      mod,
      resumo:
        (js.mensagem ? `<p>${js.mensagem}</p>` : "") +
        (js.xp ? `<p>⭐ +${js.xp} XP de profissão</p>` : "") +
        (js.col ? `<p>💰 +${js.col} Col</p>` : "") +
        (js.folego_gasto
          ? `<p>🌬️ Gasto ${js.folego_gasto} de fôlego.</p>`
          : "") +
        (js.drop_item_id && !js.drops
          ? `<p>📦 Item recebido: <b>${nomeMaterial(js.drop_item_id)}${js.drop_qtd ? " ×" + js.drop_qtd : ""}</b></p>`
          : "") +
        (js.drops && js.drops.length
          ? `<p>📦 Itens recebidos: <b>${js.drops.map((d) => `${nomeMaterial(d.id || d.item_id || d.nome)}${d.nome && !d.id ? "" : ""} ×${d.qtd || 1}`).join(", ")}</b></p>`
          : ""),
    };
    // ITEM 11: Registrar drops no HISTÓRICO DINÂMICO
    if (js.resultado !== null) {
      registrarDropsHistorico(t, js);
    }
    if (auth.logado) await auth.carregarPerfilEPersonagem();
  } catch (e) {
    alert("Erro ao resolver tarefa: " + e.message);
  }
}

// ===== ITEM 11: Histórico DINÂMICO de drops (persiste em localStorage por usuário) =====
const filtroHistoricoMonstro = ref("");
const LS_KEY = computed(() => {
  const uid =
    auth.perfil?.id ||
    auth.personagem?.dono_id ||
    auth.personagem?.id ||
    "anon";
  return `sao_rpg_historico_drops_${uid}`;
});
function _carregarHistoricoBruto() {
  try {
    const raw = localStorage.getItem(LS_KEY.value) || "[]";
    return JSON.parse(raw);
  } catch (_) {
    return [];
  }
}
function _salvarHistoricoBruto(arr) {
  try {
    localStorage.setItem(LS_KEY.value, JSON.stringify(arr));
  } catch (_) {}
}
const historicoBruto = ref([]);
function limparIdSimples(s) {
  return String(s || "")
    .replace(/[-_]+/g, " ")
    .trim()
    .replace(/\b\w/g, (l) => l.toUpperCase());
}
function nomeMatHist(id) {
  const n = nomeMaterial(id);
  if (n && n !== id) return n;
  return limparIdSimples(id);
}
function registrarDropsHistorico(t, js) {
  if (!t) return;
  const tipoTarefa = (t.tipo || "").toLowerCase();
  const monstro = t.alvo || t.monstro_alvo || t.id || "missao_geral";
  const rar = (t.raridade || "comum").toLowerCase();
  const dropsParaRegistrar = [];
  // Caso 1: único drop
  if (js.drop_item_id && !js.drops) {
    dropsParaRegistrar.push({
      id: js.drop_item_id,
      qtd: js.drop_qtd || 1,
      rar: js.drop_raridade || rar,
    });
  }
  // Caso 2: array de drops (padrão novo)
  if (Array.isArray(js.drops) && js.drops.length) {
    js.drops.forEach((d) =>
      dropsParaRegistrar.push({
        id: d.id || d.item_id || d.nome,
        qtd: d.qtd || 1,
        rar: d.raridade || rar,
      }),
    );
  }
  // Caso 3: tarefa de coleta com sucesso — material da própria tarefa drop_item_id é garantido
  if (
    !dropsParaRegistrar.length &&
    t.drop_item_id &&
    js.resultado !== "falha"
  ) {
    dropsParaRegistrar.push({
      id: t.drop_item_id,
      qtd: js.drop_qtd || t.drop_qtd || 1,
      rar: t.raridade || "comum",
    });
  }
  if (!dropsParaRegistrar.length) return;
  const agora = new Date().toISOString();
  const lista = _carregarHistoricoBruto();
  dropsParaRegistrar.forEach((d) => {
    if (!d || !d.id) return;
    lista.push({
      monstro: String(monstro),
      nomeMonstro: limparIdSimples(monstro),
      item: String(d.id),
      nomeItem: nomeMatHist(d.id),
      qtd: Number(d.qtd || 1),
      raridade: d.rar || rar,
      tipoTarefa,
      data: agora,
    });
  });
  _salvarHistoricoBruto(lista);
  historicoBruto.value = lista;
}
function limparHistoricoDrops() {
  if (!confirm("Limpar TODO o histórico de drops? Essa ação é irreversível."))
    return;
  _salvarHistoricoBruto([]);
  historicoBruto.value = [];
}
const totalDropsHistorico = computed(() =>
  historicoBruto.value.reduce((a, b) => a + (b.qtd || 1), 0),
);
const monstrosDiferentes = computed(
  () => new Set(historicoBruto.value.map((x) => x.monstro)).size,
);
const listaMonstrosHistorico = computed(() => {
  const h = {};
  historicoBruto.value.forEach((x) => {
    const k = x.monstro;
    h[k] = h[k] || { k, nome: x.nomeMonstro || limparIdSimples(k), qtd: 0 };
    h[k].qtd += 1;
  });
  return Object.values(h).sort((a, b) => b.qtd - a.qtd);
});
const historicoDropsList = computed(() => {
  const h = {};
  historicoBruto.value.forEach((x) => {
    const chave = `${x.monstro}|${x.item}`;
    if (!h[chave]) {
      h[chave] = {
        monstro: x.monstro,
        nomeMonstro: x.nomeMonstro,
        item: x.item,
        nomeItem: x.nomeItem,
        qtd: 0,
        ultimaData: x.data,
        raridade: x.raridade,
      };
    }
    h[chave].qtd += Number(x.qtd || 1);
    if (new Date(x.data) > new Date(h[chave].ultimaData))
      h[chave].ultimaData = x.data;
  });
  return Object.values(h).sort(
    (a, b) => new Date(b.ultimaData) - new Date(a.ultimaData),
  );
});
const historicoDropsFiltrados = computed(() => {
  if (!filtroHistoricoMonstro.value) return historicoDropsList.value;
  return historicoDropsList.value.filter(
    (x) => x.monstro === filtroHistoricoMonstro.value,
  );
});
function _fmtData(s) {
  if (!s) return "—";
  try {
    return new Date(s).toLocaleString("pt-BR", {
      day: "2-digit",
      month: "2-digit",
      hour: "2-digit",
      minute: "2-digit",
    });
  } catch (_) {
    return s;
  }
}
function fmtData(s) {
  return _fmtData(s);
}
// Wrap para usar no template (definido depois, por ordem de declaração — template usa h.ultimaData que é crua por simplicidade)

function estiloRar(r) {
  const c =
    {
      comum: "--borderC:#d5c9a8",
      incomum: "--borderC:#62c56a",
      raro: "--borderC:#5fa0e8",
      epico: "--borderC:#c185ff",
      lendario: "--borderC:#f19b5a",
    }[(r || "").toLowerCase()] || "--borderC:var(--line)";
  return `border:2px solid var(${c.split(":")[0].slice(2)});`;
}

const nivelProfissaoAtual = ref(1);
async function carregarNivelProfissao() {
  if (!auth.temPersonagem) return;
  try {
    const r = await supa
      .from("nivel_profissao")
      .select("nivel")
      .eq("personagem_nome", auth.personagem.nome)
      .eq("profissao", auth.personagem.profissao || "")
      .maybeSingle();
    nivelProfissaoAtual.value = r.data?.nivel || 1;
  } catch (e) {
    console.warn(e);
  }
}

onMounted(async () => {
  if (!auth.ready) await auth.init();
  // ITEM 11: Carrega histórico de drops do localStorage
  historicoBruto.value = _carregarHistoricoBruto();
  if (auth.temPersonagem) {
    await Promise.all([carregarTodasMissoes(), carregarNivelProfissao()]);
  }
});
</script>
