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
              <img v-if="campoImagem && r[campoImagem]" :src="urlImagem(r[campoImagem])" :alt="tituloDe(r)" class="ee-thumb" @error="e => e.target.style.visibility='hidden'" />
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
            <template v-for="(c, i) in camposFormulario" :key="c.nome">
              <!-- Divisor de seção — opcional (propriedade "grupo" no
                   TABELAS_ADMIN). Formulários genéricos com muitos campos
                   soltos (ex: pontos do mapa, ~18 campos numa tela só)
                   ficavam sem nenhuma hierarquia visual. -->
              <div v-if="c.grupo && c.grupo !== camposFormulario[i-1]?.grupo" class="ee-grupo-label">{{ c.grupo }}</div>
              <div
                class="ee-campo"
                :class="{ full: ['textarea','json','lista','lista-texto','objeto','imagem'].includes(c.tipo) }"
              >
              <label>
                {{ c.rotulo || c.nome }}
                <span v-if="c.segredo" class="ee-lock" title="Só o mestre vê esse valor — jogadores nunca recebem esse campo.">🔒 só mestre</span>
              </label>

              <!-- texto simples -->
              <input v-if="c.tipo === 'text'" v-model="itemAberto[c.nome]" class="ee-input" />
              <input v-else-if="c.tipo === 'number'" type="number" v-model="itemAberto[c.nome]" class="ee-input" :min="c.min" :max="c.max" />
              <textarea v-else-if="c.tipo === 'textarea'" v-model="itemAberto[c.nome]" rows="3" class="ee-input"></textarea>
              <label v-else-if="c.tipo === 'bool'" class="ee-check">
                <input type="checkbox" v-model="itemAberto[c.nome]" />
                {{ itemAberto[c.nome] ? "Sim" : "Não" }}
              </label>

              <!-- select travado: só aceita valor da lista, impossível digitar errado -->
              <select v-else-if="c.tipo === 'select'" v-model="itemAberto[c.nome]" class="ee-input">
                <option value="">— selecione —</option>
                <option v-for="op in c.opcoes" :key="op" :value="op">{{ op }}</option>
              </select>

              <!-- sugestão (datalist): guia com valores comuns mas deixa digitar algo novo -->
              <template v-else-if="c.tipo === 'sugestao'">
                <input v-model="itemAberto[c.nome]" class="ee-input" :list="`dl-${tabela}-${c.nome}`" placeholder="digite ou escolha uma sugestão" />
                <datalist :id="`dl-${tabela}-${c.nome}`">
                  <option v-for="op in (c.opcoes || opcoesReferencia[c.nome] || [])" :key="op" :value="op" />
                </datalist>
              </template>

              <!-- imagem: upload real pro Storage (sem colar URL) + preview ao vivo -->
              <template v-else-if="c.tipo === 'imagem'">
                <div v-if="itemAberto[c.nome]" class="ee-preview">
                  <img :src="urlImagem(itemAberto[c.nome])" alt="Pré-visualização da imagem" @load="e => e.target.classList.remove('erro')" @error="e => e.target.classList.add('erro')" />
                </div>
                <div class="ee-upload-linha">
                  <label class="btn tiny" :class="{ disabled: enviandoImagem[c.nome] }">
                    {{ enviandoImagem[c.nome] ? "⏳ Enviando…" : itemAberto[c.nome] ? "🔄 Trocar imagem" : "📤 Enviar imagem" }}
                    <input type="file" accept="image/*" style="display:none" :disabled="enviandoImagem[c.nome]" @change="(e) => enviarArquivoImagem(c, e)" />
                  </label>
                  <button v-if="itemAberto[c.nome]" type="button" class="btn tiny bad ghost" @click="itemAberto[c.nome] = ''">🗑️ Remover</button>
                </div>
                <small v-if="erroImagem[c.nome]" class="ee-hint" style="color:#e0887a">⚠️ {{ erroImagem[c.nome] }}</small>
              </template>

              <!-- lista de texto simples: array de strings -->
              <template v-else-if="c.tipo === 'lista-texto'">
                <div class="ee-lista">
                  <div v-for="(_, i) in (camposListaTexto[c.nome] || [])" :key="i" class="ee-lista-linha">
                    <textarea v-model="camposListaTexto[c.nome][i]" rows="1" class="ee-input"></textarea>
                    <button type="button" class="btn tiny bad ghost" @click="camposListaTexto[c.nome].splice(i, 1)">🗑️</button>
                  </div>
                  <button type="button" class="btn tiny" @click="(camposListaTexto[c.nome] ||= []).push('')">➕ Adicionar linha</button>
                </div>
              </template>

              <!-- lista de objetos: array de {campo1, campo2, ...} com sub-schema fixo -->
              <template v-else-if="c.tipo === 'lista'">
                <div class="ee-lista">
                  <div v-for="(item, i) in (camposLista[c.nome] || [])" :key="i" class="ee-lista-obj">
                    <div class="ee-lista-obj-campos">
                      <div v-for="ic in c.itemCampos" :key="ic.nome" class="ee-campo">
                        <label>{{ ic.rotulo || ic.nome }}</label>
                        <select v-if="ic.tipo === 'select'" v-model="item[ic.nome]" class="ee-input">
                          <option value="">—</option>
                          <option v-for="op in ic.opcoes" :key="op" :value="op">{{ op }}</option>
                        </select>
                        <template v-else-if="ic.tipo === 'sugestao'">
                          <input v-model="item[ic.nome]" class="ee-input" :list="`dl-${tabela}-${c.nome}-${ic.nome}`" />
                          <datalist :id="`dl-${tabela}-${c.nome}-${ic.nome}`">
                            <option v-for="op in (ic.opcoes || opcoesReferencia[c.nome + '.' + ic.nome] || [])" :key="op" :value="op" />
                          </datalist>
                        </template>
                        <input v-else-if="ic.tipo === 'number'" type="number" v-model="item[ic.nome]" class="ee-input" />
                        <input v-else v-model="item[ic.nome]" class="ee-input" />
                      </div>
                    </div>
                    <button type="button" class="btn tiny bad ghost" @click="camposLista[c.nome].splice(i, 1)">🗑️ Remover linha</button>
                  </div>
                  <button type="button" class="btn tiny" @click="adicionarLinhaLista(c)">➕ Adicionar {{ c.itemNome || 'item' }}</button>
                </div>
              </template>

              <!-- objeto de forma fixa: {campo1, campo2, ...} -->
              <template v-else-if="c.tipo === 'objeto'">
                <div class="ee-lista ee-objeto">
                  <div v-for="ic in c.campos" :key="ic.nome" class="ee-campo">
                    <label>{{ ic.rotulo || ic.nome }}</label>
                    <select v-if="ic.tipo === 'select'" v-model="(camposObjeto[c.nome] ||= {})[ic.nome]" class="ee-input">
                      <option value="">—</option>
                      <option v-for="op in ic.opcoes" :key="op" :value="op">{{ op }}</option>
                    </select>
                    <textarea v-else-if="ic.tipo === 'textarea'" v-model="(camposObjeto[c.nome] ||= {})[ic.nome]" rows="2" class="ee-input"></textarea>
                    <input v-else v-model="(camposObjeto[c.nome] ||= {})[ic.nome]" class="ee-input" />
                  </div>
                </div>
              </template>

              <!-- fallback: JSON cru, com botão de formatar e indicador de validade -->
              <template v-else-if="c.tipo === 'json'">
                <textarea
                  v-model="camposJsonTexto[c.nome]"
                  rows="4"
                  class="ee-input ee-mono"
                  :class="{ 'ee-invalido': jsonValido(c.nome) === false }"
                  placeholder="null, [], {} ou JSON válido"
                ></textarea>
                <div class="ee-json-barra">
                  <small class="ee-hint" v-if="jsonValido(c.nome) === false">⚠️ JSON inválido — não vai salvar assim.</small>
                  <small class="ee-hint" v-else-if="jsonValido(c.nome) === true">✓ JSON válido</small>
                  <small class="ee-hint" v-else>Formato JSON cru — sem sub-formulário pronto pra esse campo ainda.</small>
                  <button type="button" class="btn tiny" @click="formatarJson(c.nome)">🧹 Formatar</button>
                </div>
              </template>
              </div>
            </template>
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
import { urlImagem, enviarImagem } from "../lib/imagens.js";

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
const camposListaTexto = reactive({});
const camposLista = reactive({});
const camposObjeto = reactive({});
const opcoesReferencia = reactive({});
const salvando = ref(false);
const erroSalvar = ref("");
const enviandoImagem = reactive({});
const erroImagem = reactive({});

function temCampo(nome) {
  return !!config?.campos.find((c) => c.nome === nome);
}
const campoTitulo = computed(() => {
  const pref = ["nome", "titulo", "nome_resultado", "nome_pet"];
  const achado = pref.find((n) => temCampo(n));
  return achado || config?.pk;
});
const campoImagem = computed(() => config?.campos.find((c) => c.tipo === "imagem")?.nome || null);
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

// ===== campos de referência (datalist alimentado por outra tabela) =====
async function carregarOpcoesReferencia() {
  const alvos = [];
  for (const c of camposFormulario.value) {
    if (c.tipo === "sugestao" && c.tabelaRef && !opcoesReferencia[c.nome]) alvos.push(c);
    if (c.tipo === "lista") {
      for (const ic of c.itemCampos || []) {
        if (ic.tipo === "sugestao" && ic.tabelaRef && !opcoesReferencia[c.nome + "." + ic.nome]) {
          alvos.push({ chave: c.nome + "." + ic.nome, tabelaRef: ic.tabelaRef, campoRef: ic.campoRef });
        }
      }
    }
  }
  for (const a of alvos) {
    try {
      const r = await supa.from(a.tabelaRef).select(a.campoRef || "nome").limit(500);
      const valores = [...new Set((r.data || []).map((row) => row[a.campoRef || "nome"]).filter(Boolean))].sort();
      opcoesReferencia[a.chave || a.nome] = valores;
    } catch (e) {
      console.warn("referência", a, e);
    }
  }
}

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
  inicializarCamposEstruturados({});
  carregarOpcoesReferencia();
}
function abrirEdicao(r) {
  itemAberto.value = JSON.parse(JSON.stringify(r));
  modoNovo.value = false;
  erroSalvar.value = "";
  inicializarCamposEstruturados(r);
  carregarOpcoesReferencia();
}
function inicializarCamposEstruturados(r) {
  for (const c of camposFormulario.value) {
    if (c.tipo === "json") {
      const v = r[c.nome];
      camposJsonTexto[c.nome] = v === null || v === undefined ? "" : JSON.stringify(v, null, 2);
    } else if (c.tipo === "lista-texto") {
      const v = r[c.nome];
      camposListaTexto[c.nome] = Array.isArray(v) ? [...v] : [];
    } else if (c.tipo === "lista") {
      const v = r[c.nome];
      camposLista[c.nome] = Array.isArray(v) ? v.map((o) => ({ ...o })) : [];
    } else if (c.tipo === "objeto") {
      const v = r[c.nome];
      camposObjeto[c.nome] = v && typeof v === "object" ? { ...v } : {};
    }
  }
}
function adicionarLinhaLista(c) {
  const nova = {};
  for (const ic of c.itemCampos) nova[ic.nome] = ic.tipo === "number" ? null : "";
  (camposLista[c.nome] ||= []).push(nova);
}
function jsonValido(nome) {
  const txt = (camposJsonTexto[nome] || "").trim();
  if (!txt) return null;
  try {
    JSON.parse(txt);
    return true;
  } catch {
    return false;
  }
}
function formatarJson(nome) {
  try {
    const obj = JSON.parse((camposJsonTexto[nome] || "").trim() || "null");
    camposJsonTexto[nome] = JSON.stringify(obj, null, 2);
  } catch {
    /* deixa como está, o indicador de inválido já avisa */
  }
}

async function enviarArquivoImagem(campo, evento) {
  const file = evento.target.files?.[0];
  evento.target.value = ""; // deixa escolher o mesmo arquivo de novo depois, se precisar
  if (!file) return;
  erroImagem[campo.nome] = "";
  enviandoImagem[campo.nome] = true;
  try {
    const pasta = props.tabela + "/" + (itemAberto.value[config.pk] || "novo");
    itemAberto.value[campo.nome] = await enviarImagem(file, pasta);
  } catch (e) {
    erroImagem[campo.nome] = e.message || String(e);
  } finally {
    enviandoImagem[campo.nome] = false;
  }
}

function gerarIdDoNome() {
  const base = String(itemAberto.value[campoTitulo.value] || "");
  const slug = base
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
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
    } else if (c.tipo === "lista-texto") {
      payload[c.nome] = (camposListaTexto[c.nome] || []).map((s) => String(s).trim()).filter(Boolean);
    } else if (c.tipo === "lista") {
      // parte de { ...item } (não só os itemCampos) pra não apagar em
      // silêncio uma chave que já existia no dado real mas não entrou no
      // sub-schema — achado 10/08: receitas.materiais tem "_nome" em 635
      // linhas (do import do item 3) e o sub-schema só conhece qtd/mat_id.
      payload[c.nome] = (camposLista[c.nome] || []).map((item) => {
        const o = { ...item };
        for (const ic of c.itemCampos) {
          const v = item[ic.nome];
          o[ic.nome] = ic.tipo === "number" ? (v === "" || v == null ? null : Number(v)) : v;
        }
        return o;
      });
    } else if (c.tipo === "objeto") {
      payload[c.nome] = camposObjeto[c.nome] && Object.keys(camposObjeto[c.nome]).length ? camposObjeto[c.nome] : {};
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
      // sem .select(): pedir o registro de volta faria um "select *" na
      // tabela base, que quebra pras 6 tabelas com coluna "só mestre" (a
      // mesma causa do "permission denied" corrigido em 10/08 — a coluna
      // nunca teve GRANT SELECT direto, só a view resolve). Não precisa do
      // retorno mesmo: `carregar()` já busca a lista de novo em seguida.
      const r = await supa.from(props.tabela).insert([payload]);
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
.ee-input.ee-invalido {
  border-color: #d9534f;
}
select.ee-input {
  cursor: pointer;
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
.ee-thumb {
  width: 40px;
  height: 40px;
  object-fit: cover;
  border-radius: 6px;
  border: 1px solid #332a4d;
  flex-shrink: 0;
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
.ee-grupo-label {
  grid-column: 1 / -1;
  margin-top: 10px;
  padding-top: 10px;
  border-top: 1px solid #332a4d;
  font-family: var(--f-mono);
  font-size: 11px;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: #a08fd6;
}
.ee-grid > .ee-grupo-label:first-child {
  margin-top: 0;
  padding-top: 0;
  border-top: none;
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
.ee-preview {
  margin-top: 4px;
}
.ee-preview img {
  max-width: 160px;
  max-height: 160px;
  object-fit: cover;
  border-radius: 8px;
  border: 1px solid #332a4d;
  display: block;
}
.ee-preview img.erro {
  display: none;
}
.ee-upload-linha {
  display: flex;
  gap: 8px;
  align-items: center;
  flex-wrap: wrap;
}
.ee-upload-linha .btn.disabled {
  opacity: 0.4;
  pointer-events: none;
}
.ee-json-barra {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  margin-top: 2px;
}
.ee-lista {
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.ee-lista-linha {
  display: flex;
  gap: 8px;
  align-items: flex-start;
}
.ee-lista-linha .ee-input {
  flex: 1;
}
.ee-lista-obj {
  border: 1px solid #251f39;
  border-radius: 8px;
  padding: 10px;
  background: #0f0b19;
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.ee-lista-obj-campos {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
  gap: 8px;
}
.ee-objeto {
  border: 1px solid #251f39;
  border-radius: 8px;
  padding: 10px;
  background: #0f0b19;
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
