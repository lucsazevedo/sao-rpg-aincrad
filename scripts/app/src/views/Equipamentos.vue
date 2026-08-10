<template>
  <div>
    <StatusBar @pedir-login="$emit('pedir-login')" />
    <h2 style="color:var(--gold-bright);margin:10px 0 6px;font-size:24px">🎒 Equipamentos · Inventário</h2>
    <p style="margin:0 0 12px;color:var(--ink-dim);font-size:13px">
      Equipar/desequipar aqui não muda nada mecanicamente no jogo online — chance de sucesso é só Nível de
      Profissão (ver <code>dolist/12_sistema_de_poder.md</code>). Isto é coleção/vitrine e o que você leva pra
      mesa de RPG de verdade, onde o item vale com as regras normais.
    </p>
    <div v-if="!auth.logado" class="msg info">
      <button class="btn primario" @click="$emit('pedir-login')" style="margin-right:8px">🔑 Entrar</button>
      Faça login para ver seus equipamentos.
    </div>
    <div v-else-if="!auth.temPersonagem" class="msg warn">Sem ficha vinculada — fale com o mestre.</div>
    <div v-else>
      <div class="tabs" style="margin:8px 0">
        <div v-for="t in abas" :key="t.k" class="tab" :class="{on: aba===t.k}" @click="aba=t.k">{{ t.label }}</div>
      </div>

      <!-- ========== Aba 1: EQUIPADOS AGORA (paper doll, 10 slots decididos) ========== -->
      <div v-if="aba==='equipados'">
        <div v-if="carregando" class="msg info">Carregando…</div>
        <div v-else class="grid">
          <div v-for="e in paperDoll" :key="e.key" class="card">
            <div class="ct">{{ e.emoji }} {{ e.label }}</div>
            <div class="cs">{{ e.item ? e.item.nome : 'Nada equipado' }}</div>
            <div class="faixa">
              <span class="pill on" v-if="e.item && e.item.raridade">{{ e.item.raridade }}</span>
            </div>
            <div style="margin-top:10px;display:flex;gap:6px;justify-content:flex-end">
              <button v-if="e.item" class="btn" @click="desequipar(e)">👋 Desequipar</button>
            </div>
          </div>
        </div>
      </div>

      <!-- ========== Aba 2: INVENTÁRIO / MOCHILA (grid 8×8) ========== -->
      <div v-if="aba==='inventario'">
        <div v-if="carregando" class="msg info">Carregando inventário…</div>
        <div v-else-if="!mochila.length" class="msg warn">
          Mochila vazia. Use <router-link to="/tarefas" style="color:var(--gold-bright)">missões</router-link>,
          <router-link to="/combate" style="color:var(--gold-bright)">combate</router-link> e
          <router-link to="/profissoes" style="color:var(--gold-bright)">craft</router-link>
          pra ganhar item.
        </div>
        <div v-else>
          <div style="display:flex;gap:10px;flex-wrap:wrap;margin:6px 0 14px">
            <input v-model="busca" placeholder="🔎 Buscar item na mochila…"
              style="flex:1 1 200px;background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:9px 12px;border-radius:6px;font:inherit">
            <select v-model="filtroTipo" style="background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:9px 12px;border-radius:6px;font:inherit">
              <option value="">Todos os tipos</option>
              <option v-for="t in tiposPresentes" :key="t" :value="t">{{ tituloTipo(t) }}</option>
            </select>
            <div style="display:inline-flex;align-items:center;gap:6px;background:var(--panel-3);border:1px solid var(--line);padding:8px 14px;border-radius:6px;font-size:13px;color:var(--gold-bright)">
              📦 {{ inventarioFiltrado.length }} / 64 slots
            </div>
          </div>
          <div class="grid">
            <div v-for="it in inventarioFiltrado" :key="it.id" class="card" :style="{'border-left': tipoBorda(it.tipo)}">
              <div class="ct">{{ it.nome || it.item_id }}</div>
              <div class="cs">
                {{ tituloTipo(it.tipo) }}
                <span v-if="it.raridade"> · {{ it.raridade }}</span>
              </div>
              <div class="faixa">
                <span class="pill on">x {{ it.quantidade || 1 }}</span>
                <span v-if="it.equipado" class="pill">⚔️ equipado ({{ labelSlot(it.slot) }})</span>
              </div>
              <div style="margin-top:10px;display:flex;gap:6px;justify-content:flex-end;flex-wrap:wrap">
                <button v-if="podeEquipar(it) && !it.equipado" class="btn primario" @click="equipar(it)">⚔️ Equipar</button>
                <button v-if="it.equipado" class="btn" @click="desequiparItem(it)">👋 Desequipar</button>
                <button v-if="!it.equipado" class="btn" @click="mover(it,'stash')">🏦 Guardar no Baú</button>
                <router-link to="/mercado" class="btn ghost" style="text-decoration:none">🏪 Vender</router-link>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- ========== Aba 3: BAÚ / STASH ========== -->
      <div v-if="aba==='stash'">
        <div v-if="carregando" class="msg info">Carregando baú…</div>
        <div v-else-if="!stash.length" class="msg warn">
          Baú vazio. Guarde item da mochila aqui pra abrir espaço — não conta nos 64 slots da mochila.
        </div>
        <div v-else class="grid">
          <div v-for="it in stash" :key="it.id" class="card" :style="{'border-left': tipoBorda(it.tipo)}">
            <div class="ct">{{ it.nome || it.item_id }}</div>
            <div class="cs">{{ tituloTipo(it.tipo) }}</div>
            <div class="faixa"><span class="pill on">x {{ it.quantidade || 1 }}</span></div>
            <div style="margin-top:10px;display:flex;justify-content:flex-end">
              <button class="btn primario" @click="mover(it,'mochila')">⬅️ Levar pra mochila</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useAuthStore } from '../stores/auth.js'
import { useSupa } from '../lib/supabase.js'
import StatusBar from '../components/StatusBar.vue'

const auth = useAuthStore()
defineEmits(['pedir-login'])
const supa = useSupa()

const aba = ref('equipados')
const abas = [
  { k: 'equipados',  label: '⚔️ Equipados Agora' },
  { k: 'inventario', label: '🎒 Mochila' },
  { k: 'stash',      label: '🏦 Baú' },
]
const busca = ref(''), filtroTipo = ref('')
const carregando = ref(true)
const inventario = ref([])
const armasCatalogo = ref({}) // id -> nome, pro slot "arma" (personagens.arma não é linha de inventario)

// Os 10 slots decididos em dolist/08_equipamento_inventario.md.
const SLOTS = [
  { key: 'arma',           label: 'Arma',                emoji: '⚔️' },
  { key: 'mao_secundaria', label: 'Mão Secundária',      emoji: '🛡️' },
  { key: 'elmo',           label: 'Elmo / Capuz',         emoji: '🪖' },
  { key: 'armadura',       label: 'Armadura / Capa',      emoji: '🥋' },
  { key: 'luvas',          label: 'Luvas',                emoji: '🧤' },
  { key: 'acessorio1',     label: 'Acessório 1',          emoji: '💍' },
  { key: 'acessorio2',     label: 'Acessório 2',          emoji: '📿' },
  { key: 'botas',          label: 'Botas',                emoji: '👢' },
  { key: 'carta',          label: 'Carta Equipada',       emoji: '🃏' },
  { key: 'cristal',        label: 'Cristal Socket',       emoji: '💎' },
]
// De qual "slot" (categoria em equipamentos/cartas/cristais) pra qual paper-doll key.
// Acessórios cai no 1 ou no 2, o que estiver livre (ver equipar()).
const SLOT_PARA_KEY = {
  'Elmos': 'elmo', 'Capuz': 'elmo',
  'Armaduras': 'armadura', 'Parte de Cima': 'armadura',
  'Botas': 'botas', 'Parte de Baixo': 'botas',
  'Luvas': 'luvas',
  'Escudos': 'mao_secundaria',
  'Acessórios': 'acessorio',
  'Cristais de Uso': 'cristal',
}
// Tipos reais (constraint inventario_tipo_check no banco): arma, equipamento,
// consumivel, material, carta, cristal, ovo, pet. Não existe "ferramenta" nem
// "ouro" como item de inventário (ferramenta de ofício vive em
// personagem_ferramentas; Col é coluna em personagens, não item).
const TIPOS_NAO_EQUIPAVEIS = new Set(['material','consumivel','ovo','pet'])

function labelSlot(key){ return (SLOTS.find(s=>s.key===key)||{}).label || key || '—' }
function tituloTipo(t){
  return { material:'🌿 Material', arma:'⚔️ Arma', equipamento:'🥋 Equipamento',
    consumivel:'🍗 Consumível', pet:'🐾 Pet', ovo:'🥚 Ovo',
    carta:'🃏 Carta', cristal:'💎 Cristal' }[t] || '📦 Item'
}
function tipoBorda(t){
  return { arma:'4px solid var(--gold-bright)', equipamento:'4px solid #66aaff', material:'4px solid #88bb77',
    consumivel:'4px solid #cc9955' }[t] || '4px solid var(--line)'
}

// ========= paper doll =========
const paperDoll = computed(() => {
  const nomeArma = auth.personagem?.arma
    ? (armasCatalogo.value[auth.personagem.arma] || auth.personagem.arma)
    : null
  return SLOTS.map(s => {
    if (s.key === 'arma') {
      return { ...s, item: nomeArma ? { nome: nomeArma } : null }
    }
    const it = inventario.value.find(i => i.equipado && i.slot === s.key)
    return { ...s, item: it ? { nome: it.nome || it.item_id, raridade: it.raridade } : null }
  })
})

// ========= mochila vs baú (item 8, coluna "local") =========
const mochila = computed(() => inventario.value.filter(i => (i.local||'mochila') === 'mochila'))
const stash = computed(() => inventario.value.filter(i => i.local === 'stash'))
const tiposPresentes = computed(() => [...new Set(mochila.value.map(i=>i.tipo).filter(Boolean))].sort())
const inventarioFiltrado = computed(() => {
  let l = mochila.value
  if (filtroTipo.value) l = l.filter(i => i.tipo === filtroTipo.value)
  const q = busca.value.trim().toLowerCase()
  if (q) l = l.filter(i => (i.nome||i.item_id||'').toLowerCase().includes(q))
  return l
})
async function mover(it, destino){
  try {
    const r = await supa.rpc('mover_inventario', { p_inventario_id: it.id, p_para: destino })
    if (r.error) throw r.error
    const d = typeof r.data === 'string' ? JSON.parse(r.data) : r.data
    if (d.erro) { alert(d.erro); return }
    await carregarTudo()
  } catch(e){ alert('Erro: '+e.message) }
}
function podeEquipar(it){
  if (!it || it.excluido) return false
  if (it.tipo === 'arma') return true
  if (it.tipo === 'carta') return true
  if (it.tipo === 'cristal') return true
  if (TIPOS_NAO_EQUIPAVEIS.has(it.tipo)) return false
  // armadura/equipamento: usa o "slot" gravado na linha (categoria do catálogo equipamentos, ex. "Elmos")
  return !!(it.slot && SLOT_PARA_KEY[it.slot])
}
function slotAlvo(it){
  if (it.tipo === 'arma') return 'arma'
  if (it.tipo === 'carta') return 'carta'
  if (it.tipo === 'cristal') return 'cristal'
  const base = SLOT_PARA_KEY[it.slot]
  if (base !== 'acessorio') return base
  // acessório: usa o 1 se estiver livre, senão o 2
  const ocupado1 = inventario.value.some(i => i.equipado && i.slot === 'acessorio1')
  return ocupado1 ? 'acessorio2' : 'acessorio1'
}
async function equipar(it){
  if (!it || !auth.temPersonagem) return
  const alvo = slotAlvo(it)
  if (!alvo) return
  try {
    if (alvo === 'arma') {
      // arma principal mora em personagens.arma (mesmo campo usado desde a criação do personagem).
      await supa.from('personagens').update({ arma: it.item_id }).eq('nome', auth.personagem.nome)
      if (it.id) await supa.from('inventario').update({ equipado: true, slot: 'arma' }).eq('id', it.id)
    } else {
      // desequipa o que já estava nesse slot, depois equipa o novo
      const atual = inventario.value.find(i => i.equipado && i.slot === alvo)
      if (atual) await supa.from('inventario').update({ equipado: false, slot: null }).eq('id', atual.id)
      await supa.from('inventario').update({ equipado: true, slot: alvo }).eq('id', it.id)
    }
    await auth.carregarPerfilEPersonagem()
    await carregarTudo()
  } catch(e){ alert('Erro ao equipar: '+e.message) }
}
async function desequiparItem(it){
  if (!it || !it.id) return
  try {
    await supa.from('inventario').update({ equipado: false, slot: null }).eq('id', it.id)
    await carregarTudo()
  } catch(e){ alert('Erro: '+e.message) }
}
async function desequipar(slotInfo){
  if (!slotInfo?.item) return
  if (slotInfo.key === 'arma') {
    try {
      await supa.from('personagens').update({ arma: null }).eq('nome', auth.personagem.nome)
      const it = inventario.value.find(i => i.equipado && i.slot === 'arma')
      if (it) await supa.from('inventario').update({ equipado: false, slot: null }).eq('id', it.id)
      await auth.carregarPerfilEPersonagem()
      await carregarTudo()
    } catch(e){ alert('Erro: '+e.message) }
    return
  }
  const it = inventario.value.find(i => i.equipado && i.slot === slotInfo.key)
  if (it) await desequiparItem(it)
}

async function carregarTudo(){
  if (!auth.temPersonagem) return
  carregando.value = true
  try {
    const nome = auth.personagem.nome
    const [rInv, rArm] = await Promise.all([
      supa.from('inventario').select('*').eq('personagem_nome', nome).eq('excluido', false).order('obtido_em', {ascending:false}).limit(500),
      Object.keys(armasCatalogo.value).length ? Promise.resolve(null) : supa.from('armas').select('id,nome'),
    ])
    inventario.value = rInv.data || []
    if (rArm?.data) {
      const m = {}
      rArm.data.forEach(a => { m[a.id] = a.nome })
      armasCatalogo.value = m
    }
  } catch(e){ console.warn(e) }
  finally { carregando.value = false }
}

watch(()=>auth.ready, async v => { if (v) await carregarTudo() })
onMounted(async () => { if (!auth.ready) await auth.init(); await carregarTudo() })
</script>
