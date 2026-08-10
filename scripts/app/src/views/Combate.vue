<template>
  <div>
    <StatusBar @pedir-login="$emit('pedir-login')" />
    <h2 style="color:var(--gold-bright);margin:10px 0 6px;font-size:24px">⚔️ Combate Livre</h2>
    <p style="margin:0 0 12px;color:var(--ink-dim);font-size:13px">
      Ataque um monstro direto do quadro — sem missão no meio, XP/Col/drop na hora. Gasta Fôlego sempre;
      Vida só cai em sucesso parcial ou falha. Equipar arma/carta aqui não muda a chance — é a Mesa de
      verdade que usa a mecânica de equipamento.
    </p>
    <div v-if="!auth.logado" class="msg info">
      <button class="btn primario" @click="$emit('pedir-login')" style="margin-right:8px">🔑 Entrar</button>
      Faça login para combater.
    </div>
    <div v-else-if="!auth.temPersonagem" class="msg warn">Sem ficha vinculada — fale com o mestre.</div>
    <div v-else>
      <div class="card" style="margin-bottom:14px;display:flex;gap:18px;flex-wrap:wrap;align-items:center">
        <div style="flex:1;min-width:160px">
          <div class="cs">❤️ Vida</div>
          <div style="height:12px;background:var(--panel-3);border-radius:6px;overflow:hidden;margin-top:4px">
            <div :style="{width: pctVida+'%', height:'100%', background: pctVida>40?'linear-gradient(90deg,#5e9e5a,#8fd694)':'linear-gradient(90deg,#a35454,#e0887a)'}"></div>
          </div>
          <div style="font-size:12px;color:var(--ink-dim);margin-top:2px">{{ vidaAtual }} / {{ vidaMax }}</div>
        </div>
        <div style="flex:1;min-width:160px">
          <div class="cs">💨 Fôlego</div>
          <div style="height:12px;background:var(--panel-3);border-radius:6px;overflow:hidden;margin-top:4px">
            <div :style="{width: pctFolego+'%', height:'100%', background:'linear-gradient(90deg,#d9ad5e,#f2d18a)'}"></div>
          </div>
          <div style="font-size:12px;color:var(--ink-dim);margin-top:2px">{{ auth.personagem.folego ?? 0 }} / 20</div>
        </div>
        <div style="display:flex;gap:6px;flex-wrap:wrap">
          <button class="btn" :disabled="comprando||(auth.personagem.folego??0)>=20" @click="comprarFolego(1)">⚡ +1 Fôlego (5 Col)</button>
          <button class="btn" :disabled="comprando||(auth.personagem.folego??0)>=20" @click="comprarFolego(5)">⚡⚡ +5 Fôlego (~30 Col)</button>
          <button class="btn" :disabled="comprando||(auth.personagem.folego??0)>=20" @click="comprarFolego(20)">🔥 Encher Fôlego</button>
          <button class="btn primario" :disabled="curando || (vidaAtual>=vidaMax && (auth.personagem.folego??0)>=20)" @click="curar()">
            🛏️ Curar tudo (10 Col)
          </button>
        </div>
      </div>
      <p style="color:var(--ink-dim);font-size:11.5px;margin:-10px 0 14px">
        ⏱️ Fôlego regenera sozinho +1 a cada 30 min. Os botões são o atalho pago pra não esperar
        (mesmo preço de sempre: 5 Col a unidade avulsa, ~6 Col/un no pacote de 5, ~7 Col/un pra encher —
        "Curar tudo" também restaura a Vida, o resto só mexe no Fôlego).
      </p>

      <div v-if="ultimoResultado" class="msg" :class="corResultado(ultimoResultado.resultado)" style="margin-bottom:14px">
        <b>{{ tituloResultado(ultimoResultado.resultado) }}</b> contra {{ ultimoResultado.monstro_nome }} —
        dados {{ ultimoResultado.dados?.join('+') }} (mod incluso, soma {{ ultimoResultado.soma_com_mod }}).
        <span v-if="ultimoResultado.xp_ganho">+{{ ultimoResultado.xp_ganho }} XP</span>
        <span v-if="ultimoResultado.col_ganho"> · +{{ ultimoResultado.col_ganho }} Col</span>
        <span v-if="ultimoResultado.vida_perdida"> · −{{ ultimoResultado.vida_perdida }} Vida</span>
        <span v-if="ultimoResultado.drop_item"> · dropou: {{ ultimoResultado.drop_item }}</span>
        <span v-if="ultimoResultado.derrotado"> · ⚠️ Vida chegou a 0 — cure na Estalagem antes de lutar de novo.</span>
      </div>

      <div style="display:flex;gap:10px;flex-wrap:wrap;margin:6px 0 14px">
        <input v-model="busca" placeholder="🔎 Buscar monstro…"
          style="flex:1 1 200px;background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:9px 12px;border-radius:6px;font:inherit">
        <select v-model="filtroAmeaca" style="background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:9px 12px;border-radius:6px;font:inherit">
          <option value="">Todas as ameaças</option>
          <option v-for="a in ameacasPresentes" :key="a" :value="a">{{ a }}</option>
        </select>
      </div>

      <div v-if="carregando" class="msg info">Carregando bestiário…</div>
      <div v-else class="grid">
        <div v-for="m in monstrosFiltrados" :key="m.id" class="card">
          <img v-if="m.img" :src="m.img" style="width:100%;aspect-ratio:4/3;object-fit:cover;border-radius:6px;margin-bottom:8px">
          <div class="ct">{{ m.nome }}</div>
          <div class="cs">Nv {{ nivelMonstro(m) }} · {{ m.ameaca || '?' }}</div>
          <div class="faixa">
            <span class="pill" :class="{on: chancePreview(m)>=50}">🎯 {{ chancePreview(m) }}% vitória</span>
            <span v-if="bateFraqueza(m)" class="pill on">⚡ sua arma bate a fraqueza (+1)</span>
            <span class="pill">💨 −{{ custoFolego(m) }}</span>
          </div>
          <div style="margin-top:10px;display:flex;justify-content:flex-end">
            <button class="btn primario" :disabled="atacando || vidaAtual<=0 || (auth.personagem.folego??0)<custoFolego(m)" @click="atacar(m)">
              {{ atacando===m.id ? 'Lutando…' : '⚔️ Atacar' }}
            </button>
          </div>
        </div>
      </div>

      <div class="card" style="margin-top:16px">
        <h4 style="margin:0 0 10px;color:var(--gold-bright)">🏆 Últimos combates</h4>
        <div v-if="!logs.length" class="msg warn">Nenhum combate ainda.</div>
        <div v-else style="display:grid;gap:6px">
          <div v-for="l in logs" :key="l.id" class="log-entry">
            <b>{{ tituloResultado(l.resultado) }}</b> vs {{ l.monstro_nome }}
            <span style="color:var(--ink-dim)"> · {{ new Date(l.criado_em).toLocaleString('pt-BR') }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth.js'
import { useSupa } from '../lib/supabase.js'
import StatusBar from '../components/StatusBar.vue'

const auth = useAuthStore()
defineEmits(['pedir-login'])
const supa = useSupa()

const monstros = ref([])
const carregando = ref(true)
const busca = ref(''), filtroAmeaca = ref('')
const nivelProfissaoAtual = ref(1)
const minhaArmaAtributo = ref('')
const atacando = ref(null)
const curando = ref(false)
const comprando = ref(false)
const ultimoResultado = ref(null)
const logs = ref([])

const vidaAtual = computed(() => auth.personagem?.vida_atual ?? 0)
const vidaMax = computed(() => auth.personagem?.vida_max || 50)
const pctVida = computed(() => Math.max(0, Math.min(100, (vidaAtual.value / vidaMax.value) * 100)))
const pctFolego = computed(() => Math.max(0, Math.min(100, ((auth.personagem?.folego ?? 0) / 20) * 100)))

const ameacasPresentes = computed(() => [...new Set(monstros.value.map(m => m.ameaca).filter(Boolean))])
function nivelMonstro(m) {
  const n = String(m.nivel_recomendado || '').match(/\d+/)
  return n ? Number(n[0]) : 1
}
function custoFolego(m) {
  return Math.max(1, Math.ceil(nivelMonstro(m) / 3))
}
function chancePreview(m) {
  const dif = nivelProfissaoAtual.value - nivelMonstro(m)
  const chanceVitoria = 50 + dif * 7
  const chanceParcial = 25 - Math.max(0, dif * 2)
  return Math.round(Math.max(5, Math.min(95, chanceVitoria + chanceParcial * 0.7)))
}
function bateFraqueza(m) {
  return !!(m.atributo_fraqueza && minhaArmaAtributo.value && m.atributo_fraqueza === minhaArmaAtributo.value)
}
const monstrosFiltrados = computed(() => {
  let l = monstros.value
  if (filtroAmeaca.value) l = l.filter(m => m.ameaca === filtroAmeaca.value)
  const q = busca.value.trim().toLowerCase()
  if (q) l = l.filter(m => (m.nome || '').toLowerCase().includes(q))
  return l
})
function tituloResultado(r) {
  return { sucesso_total: '✅ Vitória limpa', sucesso_parcial: '⚠️ Vitória com custo', falha: '❌ Derrota' }[r] || r
}
function corResultado(r) {
  return { sucesso_total: 'ok', sucesso_parcial: 'warn', falha: 'erro' }[r] || 'info'
}

async function carregarMonstros() {
  carregando.value = true
  try {
    const r = await supa.from('monstros').select('id,nome,img,nivel_recomendado,ameaca,zona,atributo_fraqueza').eq('visivel', true).eq('excluido', false).order('nome')
    monstros.value = r.data || []
  } catch (e) { console.warn(e) }
  finally { carregando.value = false }
}
async function carregarNivelProfissao() {
  if (!auth.temPersonagem) return
  const r = await supa.from('nivel_profissao').select('nivel').eq('personagem_nome', auth.personagem.nome).order('nivel', { ascending: false }).limit(1).maybeSingle()
  nivelProfissaoAtual.value = r.data?.nivel || 1
}
async function carregarMinhaArma() {
  minhaArmaAtributo.value = ''
  if (!auth.personagem?.arma) return
  const r = await supa.from('armas').select('atributo').eq('id', auth.personagem.arma).maybeSingle()
  minhaArmaAtributo.value = r.data?.atributo || ''
}
async function carregarLogs() {
  if (!auth.temPersonagem) return
  const r = await supa.from('combate_log').select('*').eq('personagem_nome', auth.personagem.nome).order('criado_em', { ascending: false }).limit(5)
  logs.value = r.data || []
}
async function atacar(m) {
  if (atacando.value) return
  atacando.value = m.id
  try {
    const r = await supa.rpc('combater_monstro', { p_monstro_id: m.id })
    if (r.error) throw r.error
    const d = typeof r.data === 'string' ? JSON.parse(r.data) : r.data
    if (d.erro) { alert(d.erro); return }
    ultimoResultado.value = d
    await auth.carregarPerfilEPersonagem()
    await carregarLogs()
  } catch (e) { alert('Erro no combate: ' + e.message) }
  finally { atacando.value = null }
}
async function curar() {
  curando.value = true
  try {
    const r = await supa.rpc('curar_estalagem')
    if (r.error) throw r.error
    const d = typeof r.data === 'string' ? JSON.parse(r.data) : r.data
    if (d.erro) { alert(d.erro); return }
    await auth.carregarPerfilEPersonagem()
  } catch (e) { alert('Erro: ' + e.message) }
  finally { curando.value = false }
}
async function comprarFolego(qtd) {
  comprando.value = true
  try {
    const r = await supa.rpc('comprar_folego', { p_qtd: qtd })
    if (r.error) throw r.error
    const d = typeof r.data === 'string' ? JSON.parse(r.data) : r.data
    if (d.erro) { alert(d.erro); return }
    await auth.carregarPerfilEPersonagem()
  } catch (e) { alert('Erro: ' + e.message) }
  finally { comprando.value = false }
}

onMounted(async () => {
  if (!auth.ready) await auth.init()
  await Promise.all([carregarMonstros(), carregarNivelProfissao(), carregarLogs(), carregarMinhaArma()])
})
</script>
