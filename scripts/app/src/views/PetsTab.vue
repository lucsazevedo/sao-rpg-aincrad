<template>
  <div>
    <StatusBar v-if="auth.temPersonagem" />
    <TituloHUD icone="🥚" titulo="Incubadora do Domador" trilha="Sistema · Pets" />
    <div class="tabs" style="margin:0 0 12px">
      <button type="button" class="tab" :class="{on:tab==='ativos'}" @click="tab='ativos'">🐾 Ativos</button>
      <button type="button" class="tab" :class="{on:tab==='incub'}" @click="tab='incub'">🥚 Incubando <span v-if="incubando.length">({{ incubando.length }})</span></button>
      <button type="button" class="tab" :class="{on:tab==='ovos'}" @click="tab='ovos'">🎒 Meus Ovos</button>
    </div>
    <div v-if="tab==='ovos'">
      <div v-if="!meusOvos.length" class="msg info">Você não tem nenhum ovo. Consiga ovos em missões, drops ou crie no Mercado.</div>
      <div v-else class="grid">
        <div v-for="o in meusOvos" :key="o.id" class="card">
          <div class="ct">{{ o.nome || ('Ovo #' + o.id) }}</div>
          <div class="cs">{{ o.raridade || 'comum' }} · Nv {{ o.nivel_min||1 }}</div>
          <p>{{ o.como_obter || '—' }}</p>
          <div class="faixa">
            <span class="pill">Tempo choc: {{ o.tempo_chocagem_horas||'?' }}h</span>
            <span class="pill on">Qtd {{ o.qtd || 1 }}</span>
          </div>
          <button class="btn primario" style="margin-top:auto" @click="chocar(o)">🥚 Chocar Ovo</button>
        </div>
      </div>
    </div>
    <div v-if="tab==='incub'">
      <div v-if="!incubando.length" class="msg info">Nenhuma criatura incubando no momento.</div>
      <div v-else class="grid">
        <div v-for="p in incubando" :key="p.id" class="card">
          <div class="ct">{{ p.nome_especie || p.especie || ('Criatura #' + p.id) }}</div>
          <div class="cs">Nascendo em…</div>
          <div style="font-family:var(--f-mono);font-size:20px;text-align:center;color:var(--gold-bright);padding:10px 0">{{ formatarTempo(p._faltam) }}</div>
          <button class="btn" :disabled="p._faltam>0" @click="verificar(p)">Verificar chocagem</button>
        </div>
      </div>
    </div>
    <div v-if="tab==='ativos'">
      <div v-if="!ativos.length" class="msg info">Você não tem pets ativos ainda.</div>
      <div v-else class="grid">
        <div v-for="p in ativos" :key="p.id" class="card">
          <div class="ct">{{ p.nome_especie || p.especie || ('Pet #' + p.id) }}</div>
          <div class="cs">Status: {{ p.status || 'ativo' }}</div>
          <p>{{ p.efeitos ? JSON.stringify(p.efeitos) : '—' }}</p>
          <div class="faixa">
            <span class="pill">Nv {{ p.nivel||1 }}</span>
            <span class="pill on">Nascido: {{ dataCurta(p.nascido_em) }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted, onBeforeUnmount, computed, watch } from 'vue'
import { useAuthStore } from '../stores/auth.js'
import { useSupa } from '../lib/supabase.js'
import StatusBar from '../components/StatusBar.vue'
import TituloHUD from '../components/TituloHUD.vue'
const auth = useAuthStore()
defineEmits(['pedir-login'])
const supa = useSupa()

const tab = ref('ovos')
const meusOvos = ref([])
const pets = ref([])
let tick = null

const incubando = computed(() => pets.value.filter(p => p.status==='incubando'))
const ativos = computed(() => pets.value.filter(p => p.status==='ativo'))

async function carregar(){
  const nomePers = auth.personagem && auth.personagem.nome
  if (!nomePers) return
  try{
    const [rInv, rCat, rPet] = await Promise.all([
      supa.from('inventario').select('*').eq('personagem_nome', nomePers).eq('tipo','ovo').eq('excluido',false),
      supa.from('ovos_catalogo').select('*').eq('excluido',false),
      supa.from('criaturas_domadas').select('*').eq('personagem_nome', nomePers).eq('excluido',false)
    ])
    const inv = rInv.data||[]; const cat = rCat.data||[]
    meusOvos.value = inv.map(it => {
      const c = cat.find(x => x.id === it.item_id) || {}
      return Object.assign({}, it, c, { qtd: it.qtd || 1 })
    })
    const agora = new Date().getTime()
    pets.value = (rPet.data||[]).map(p => {
      const falta = Math.max(0, Math.round((new Date(p.choca_em).getTime() - agora)/1000))
      return Object.assign({}, p, { _faltam: falta })
    })
  }catch(e){ console.error(e) }
}
function atualizarTimers(){
  const agora = new Date().getTime()
  pets.value = pets.value.map(p => {
    if (p.status !== 'incubando') return p
    const falta = Math.max(0, Math.round((new Date(p.choca_em).getTime() - agora)/1000))
    return Object.assign({}, p, { _faltam: falta })
  })
}
onMounted(async () => {
  if (!auth.ready) await auth.init()
  if (auth.temPersonagem) await carregar()
  tick = setInterval(atualizarTimers, 1000)
})
onBeforeUnmount(() => { if (tick) clearInterval(tick) })

function pad(n){ return String(n).padStart(2,'0') }
function formatarTempo(s){
  s = Math.max(0, s|0)
  const h = Math.floor(s/3600), m = Math.floor((s%3600)/60), seg = s%60
  return `${pad(h)}:${pad(m)}:${pad(seg)}`
}
function dataCurta(d){ if (!d) return '—'; const dt=new Date(d); return dt.toLocaleDateString('pt-BR') }

async function chocar(o){
  try{
    const r = await supa.rpc('chocar_ovo', { p_inventario_ovo_id: o.id })
    if (r.error) throw r.error
    alert('✅ Ovo colocado para incubar:\n\n' + (typeof r.data==='string'?r.data:JSON.stringify(r.data,null,2)).slice(0,800))
    await carregar()
  }catch(e){ alert('Erro ao chocar ovo: ' + e.message) }
}
async function verificar(p){
  try{
    const r = await supa.rpc('verificar_chocagem', { p_criatura_domada_id: p.id })
    if (r.error) throw r.error
    alert('Verificar chocagem:\n\n' + (typeof r.data==='string'?r.data:JSON.stringify(r.data,null,2)).slice(0,800))
    await carregar()
  }catch(e){ alert('Erro: ' + e.message) }
}
watch(() => auth.temPersonagem, async v => { if (v) await carregar() })
</script>
