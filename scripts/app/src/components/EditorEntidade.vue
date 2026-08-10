<template>
  <div class="modal-bg on" @click.self="fechar">
    <div class="modal ee-modal">
      <div class="top">
        <h2>{{ config?.icone }} {{ config?.rotulo || tabela }}</h2>
        <button class="btn ghost" @click="fechar">✕</button>
      </div>
      <div class="body">
        <div v-if="!config" class="msg erro">Tabela "{{ tabela }}" não está cadastrada no Compêndio.</div>

        <!-- ========== LISTA ========== -->
        <template v-else-if="!itemAberto">
          <div class="ee-toolbar">
            <input v-model="busca" placeholder="🔎 Buscar…" class="ee-input" style="flex:1" />
            <label v-if="temCampo('excluido')" class="ee-check">
              <input type="checkbox" v-model="mostrarExcluidos" />
              Mostrar excluídos
            </label>
            <button class="btn" :disabled="carregando" @click="carregar">🔄 Atualizar</button>
            <button class="btn primario" @click="abrirNovo">➕ Novo</button>
          </div>

          <div v-if="carregando" class="msg info" style="margin-top:10px">Carregando…</div>
          <div v-else-if="erro" class="msg erro" style="margin-top:10px">Erro ao carregar: {{ erro }}</div>
          <div v-else-if="!linhasFiltradas.length" class="msg warn" style="margin-top:10px">Nada encontrado.</div>
          <div v-else class="ee-list">
            <div
              v-for="r in linhasFiltradas"
              :key="String(r[config.pk])"
              class="ee-row"
              :class="{ excl: r.excluido }"
              @click="abrirEdicao(r)"
            >
              <div style="flex:1;min-width:0">
                <div class="ee-row-titulo">
                  {{ tituloDe(r) }}
                  <span v-if="r.excluido" class="pill bad" style="margin-left:6px">excluído</span>
                  <span v-else-if="temCampo('visivel') && r.visivel === false" class="pill" style="margin-left:6px">oculto</span>
                </div>
                <div class="ee-row-sub">{{ subtituloDe(r) }}</div>
              </div>
              <button class="btn tiny ghost" @click.stop="abrirEdicao(r)">✏️ Editar</button>
            </div>
          </div>
          <div class="ee-count">{{ linhasFiltradas.length }} de {{ linhas.length }} registro(s)</div>
        </template>

        <!-- ========== FORM (criar/editar) ========== -->
        <template v-else>
          <div class="ee-form-head">
            <button class="btn ghost" @click="itemAberto = null">← Voltar pra lista</button>
            <span class="pill on">{{ modoNovo ? "Criando novo" : "Editando" }}</span>
          </div>

          <div class="ee-campo">
            <label>{{ config.pk }} <small>(chave primária)</small></label>
            <div style="display:flex;gap:8px">
              <input
                v-model="itemAberto[config.pk]"
                class="ee-input"
                :disabled="!modoNovo"
                :placeholder="modoNovo ? 'ex: mat_fibra_linho' : ''"
              />
              <button
                v-if="modoNovo && campoTitulo && campoTitulo !== config.pk"
                type="button"
                class="btn"
                @click="gerarIdDoNome"
              >
                🎲 Gerar do nome
              </button>
            </div>
            <small v-if="!modoNovo" class="ee-hint">A chave primária não pode ser alterada depois de criada (outras tabelas podem referenciá-la).</small>
          </div>

          <div class="ee-grid">
            <div
              v-for="c in camposFormulario"
              :key="c.nome"
              class="ee-campo"
              :class="{ full: c.tipo === 'textarea' || c.tipo === 'json' }"
            >
              <label>
                {{ c.nome }}
                <span v-if="c.segredo" class="ee-lock" title="Só o mestre vê esse valor — jogadores nunca recebem esse campo.">🔒 só mestre</span>
              </label>

              <input v-if="c.tipo === 'text'" v-model="itemAberto[c.nome]" class="ee-input" />
              <input v-else-if="c.tipo === 'number'" type="number" v-model="itemAberto[c.nome]" class="ee-input" />
              <textarea v-else-if="c.tipo === 'textarea'" v-model="itemAberto[c.nome]" rows="3" class="ee-input"></textarea>
              <label v-else-if="c.tipo === 'bool'" class="ee-check">
                <input type="checkbox" v-model="itemAberto[c.nome]" />
                {{ itemAberto[c.nome] ? "Sim" : "Não" }}
              </label>
              <template v-else-if="c.tipo === 'json'">
                <textarea v-model="camposJsonTexto[c.nome]" rows="4" class="ee-input ee-mono" placeholder="null, [], {} ou JSON válido"></textarea>
                <small class="ee-hint">Formato JSON cru — listas viram <code>["a","b"]</code>, objetos viram <code>{{ '{' }}"chave":"valor"{{ '}' }}</code>.</small>
              </template>
            </div>
          </div>

          <div v-if="erroSalvar" class="msg erro" style="margin-top:10px">⚠️ {{ erroSalvar }}</div>

          <div class="ee-footer">
            <button
              v-if="!modoNovo && temCampo('excluido') && itemAberto.excluido"
              class="btn"
              @click="restaurar(itemAberto)"
            >
              ♻️ Restaurar
            </button>
            <button v-if="!modoNovo" class="btn bad ghost" @click="excluir(itemAberto)">
              🗑️ {{ temCampo("excluido") ? "Excluir (lógico)" : "Excluir definitivamente" }}
            </button>
            <div style="flex:1"></div>
            <button class="btn" @click="itemAberto = null">Cancelar</button>
            <button class="btn primario" :disabled="salvando" @click="salvar">
              {{ salvando ? "💾 Salvando…" : "💾 Salvar" }}
            </button>
          </div>
        </template>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from "vue";
import { useSupa } from "../lib/supabase.js";
import { TABELAS_ADMIN } from "../lib/tabelasAdmin.js";

const props = defineProps({ tabela: { type: String, required: true } });
const emit = defineEmits(["fechar"]);
const supa = useSupa();

const config = TABELAS_ADMIN[props.tabela] || null;

const linhas = ref([]);
const carregando = ref(false);
const erro = ref("");
const busca = ref("");
const mostrarExcluidos = ref(false);

const itemAberto = ref(null);
const modoNovo = ref(false);
const camposJsonTexto = reactive({});
const salvando = ref(false);
const erroSalvar = ref("");

function temCampo(nome) {
  return !!config?.campos.find((c) => c.nome === nome);
}
const campoTitulo = computed(() => {
  const pref = ["nome", "titulo", "nome_resultado", "nome_pet"];
  const achado = pref.find((n) => temCampo(n));
  return achado || config?.pk;
});
const camposFormulario = computed(
  () => config?.campos.filter((c) => c.nome !== config.pk && !c.auto) || []
);

function tituloDe(r) {
  return r[campoTitulo.value] || r[config.pk] || "—";
}
function subtituloDe(r) {
  const candidatos = ["tipo", "categoria", "profissao", "raridade", "regiao", "zona", "slot"];
  const partes = candidatos.filter((n) => temCampo(n) && r[n]).map((n) => r[n]);
  partes.push(config.pk + ": " + r[config.pk]);
  return partes.join(" · ");
}

async function carregar() {
  if (!config) return;
  carregando.value = true;
  erro.value = "";
  try {
    // tabelas com coluna "só mestre" (monstros.notas, guias.mestre,
    // puzzles.verdade, clas.ganchos, pontos.mestre, pontos_detalhe.mestre)
    // nunca tiveram GRANT SELECT na tabela base pra "authenticated" — só a
    // view resolve com segurança (CASE WHEN is_mestre()). Escrita continua
    // sempre na tabela base (salvar/excluir/restaurar, mais abaixo).
    const r = await supa
      .from(config.viewLeitura || props.tabela)
      .select("*")
      .order(campoTitulo.value === config.pk ? config.pk : campoTitulo.value, { ascending: true })
      .limit(1000);
    if (r.error) throw r.error;
    linhas.value = r.data || [];
  } catch (e) {
    erro.value = e.message || String(e);
  } finally {
    carregando.value = false;
  }
}

const linhasFiltradas = computed(() => {
  let l = linhas.value;
  if (!mostrarExcluidos.value && temCampo("excluido")) l = l.filter((r) => !r.excluido);
  const s = busca.value.trim().toLowerCase();
  if (s) {
    l = l.filter((r) =>
      Object.values(r).some((v) => typeof v === "string" && v.toLowerCase().includes(s))
    );
  }
  return l;
});

function valorPadrao(c) {
  if (c.tipo === "bool") return c.nome === "visivel";
  return "";
}
function abrirNovo() {
  const obj = {};
  camposFormulario.value.forEach((c) => (obj[c.nome] = valorPadrao(c)));
  obj[config.pk] = "";
  itemAberto.value = obj;
  modoNovo.value = true;
  erroSalvar.value = "";
  camposFormulario.value
    .filter((c) => c.tipo === "json")
    .forEach((c) => (camposJsonTexto[c.nome] = ""));
}
function abrirEdicao(r) {
  itemAberto.value = JSON.parse(JSON.stringify(r));
  modoNovo.value = false;
  erroSalvar.value = "";
  camposFormulario.value
    .filter((c) => c.tipo === "json")
    .forEach((c) => {
      const v = r[c.nome];
      camposJsonTexto[c.nome] = v === null || v === undefined ? "" : JSON.stringify(v, null, 2);
    });
}
function gerarIdDoNome() {
  const base = String(itemAberto.value[campoTitulo.value] || "");
  const slug = base
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, "_")
    .replace(/^_+|_+$/g, "");
  if (slug) itemAberto.value[config.pk] = slug;
}

async function salvar() {
  erroSalvar.value = "";
  const payload = {};
  for (const c of camposFormulario.value) {
    if (c.tipo === "json") {
      const txt = (camposJsonTexto[c.nome] || "").trim();
      if (!txt) {
        payload[c.nome] = null;
        continue;
      }
      try {
        payload[c.nome] = JSON.parse(txt);
      } catch (e) {
        erroSalvar.value = `Campo "${c.nome}": JSON inválido — ${e.message}`;
        return;
      }
    } else if (c.tipo === "number") {
      const v = itemAberto.value[c.nome];
      payload[c.nome] = v === "" || v === null || v === undefined ? null : Number(v);
    } else {
      payload[c.nome] = itemAberto.value[c.nome];
    }
  }
  const pkAuto = config.campos.find((c) => c.nome === config.pk)?.auto;
  salvando.value = true;
  try {
    if (modoNovo.value) {
      if (!pkAuto) {
        const pkVal = itemAberto.value[config.pk];
        if (!pkVal) throw new Error(`Preencha o campo "${config.pk}" (chave primária).`);
        payload[config.pk] = pkVal;
      }
      const r = await supa.from(props.tabela).insert([payload]).select();
      if (r.error) throw r.error;
    } else {
      const r = await supa
        .from(props.tabela)
        .update(payload)
        .eq(config.pk, itemAberto.value[config.pk]);
      if (r.error) throw r.error;
    }
    await carregar();
    itemAberto.value = null;
  } catch (e) {
    erroSalvar.value = e.message || String(e);
  } finally {
    salvando.value = false;
  }
}

async function excluir(row) {
  try {
    if (temCampo("excluido")) {
      if (!confirm(`Excluir (lógico) "${tituloDe(row)}"? Some das listas públicas, mas continua no banco — dá pra restaurar.`))
        return;
      const upd = { excluido: true };
      if (temCampo("visivel")) upd.visivel = false;
      const r = await supa.from(props.tabela).update(upd).eq(config.pk, row[config.pk]);
      if (r.error) throw r.error;
    } else {
      if (!confirm(`EXCLUIR DEFINITIVAMENTE "${tituloDe(row)}"? Esta tabela não tem exclusão lógica — não tem como desfazer.`))
        return;
      const r = await supa.from(props.tabela).delete().eq(config.pk, row[config.pk]);
      if (r.error) throw r.error;
    }
    await carregar();
    itemAberto.value = null;
  } catch (e) {
    alert("Erro ao excluir: " + (e.message || e));
  }
}
async function restaurar(row) {
  try {
    const r = await supa.from(props.tabela).update({ excluido: false }).eq(config.pk, row[config.pk]);
    if (r.error) throw r.error;
    itemAberto.value.excluido = false;
    await carregar();
  } catch (e) {
    alert("Erro ao restaurar: " + (e.message || e));
  }
}

function fechar() {
  emit("fechar");
}

onMounted(carregar);
</script>

<style scoped>
.ee-modal {
  max-width: 900px;
  width: 100%;
}
.ee-modal :deep(.top),
.ee-modal :deep(.body) {
  background: #14121d;
}
.ee-toolbar {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  align-items: center;
  margin-bottom: 6px;
}
.ee-input {
  background: #1a1526;
  border: 1px solid #332a4d;
  color: #e6e2ff;
  padding: 9px 12px;
  border-radius: 6px;
  font: inherit;
  outline: none;
  width: 100%;
}
.ee-input:focus {
  border-color: #7a5ab8;
}
.ee-mono {
  font-family: var(--f-mono);
  font-size: 12.5px;
}
.ee-check {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 12.5px;
  color: #c5bbe6;
  cursor: pointer;
  white-space: nowrap;
}
.ee-list {
  display: flex;
  flex-direction: column;
  gap: 6px;
  max-height: 55vh;
  overflow-y: auto;
}
.ee-row {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 12px;
  border-radius: 8px;
  background: #0f0b19;
  border: 1px solid #251f39;
  cursor: pointer;
}
.ee-row:hover {
  background: #1a1526;
  border-color: #3a2f5e;
}
.ee-row.excl {
  opacity: 0.55;
}
.ee-row-titulo {
  color: #e6e2ff;
  font-weight: 700;
  font-size: 14px;
}
.ee-row-sub {
  color: #9d90c0;
  font-size: 11.5px;
  margin-top: 2px;
  font-family: var(--f-mono);
}
.ee-count {
  margin-top: 8px;
  font-size: 11.5px;
  color: #6d6199;
  text-align: right;
}
.ee-form-head {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 14px;
}
.ee-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
}
.ee-campo {
  display: grid;
  gap: 5px;
}
.ee-campo.full {
  grid-column: 1 / -1;
}
.ee-campo label {
  font-family: var(--f-mono);
  font-size: 11px;
  letter-spacing: 0.05em;
  text-transform: uppercase;
  color: #b8a8db;
  display: flex;
  align-items: center;
  gap: 8px;
}
.ee-campo label small {
  text-transform: none;
  letter-spacing: 0;
  color: #6d6199;
  font-family: var(--f-ui);
}
.ee-lock {
  font-size: 10px;
  color: #d9ad5e;
  text-transform: none;
  font-family: var(--f-ui);
  letter-spacing: 0;
}
.ee-hint {
  color: #6d6199;
  font-size: 11px;
}
.ee-footer {
  display: flex;
  gap: 10px;
  align-items: center;
  margin-top: 18px;
  padding-top: 14px;
  border-top: 1px dashed #332a4d;
  flex-wrap: wrap;
}
@media (max-width: 640px) {
  .ee-grid {
    grid-template-columns: 1fr;
  }
}
</style>
