<!-- Hub de Aincrad, item 1 (SAO_RPG_AINCRAD_SISTEMAS.md): Notícias de
     Aincrad — primeira página do site (rota "/"), feed dos acontecimentos
     da campanha. Notícias "destaque" viram banner estilo SYSTEM ANNOUNCEMENT
     (o pop-up de sistema clássico de SAO). Publicadas pelo mestre no
     Compêndio (Hub de Aincrad → Notícias) ou automaticamente pela cascata
     de boss derrotado (RPC mestre_resolver_boss_andar). -->
<template>
  <div>
    <section class="hero">
      <svg class="hero-aincrad" viewBox="0 0 260 200" aria-hidden="true">
        <defs>
          <linearGradient id="aincradGradNoticias" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stop-color="var(--laranja)" stop-opacity=".9" />
            <stop offset="100%" stop-color="var(--azul)" stop-opacity=".5" />
          </linearGradient>
        </defs>
        <g fill="url(#aincradGradNoticias)">
          <polygon points="130,8 178,52 82,52" />
          <polygon points="118,58 190,96 46,96" />
          <polygon points="104,102 208,148 0,148" />
        </g>
        <ellipse cx="104" cy="160" rx="118" ry="9" fill="var(--azul)" opacity=".22" />
      </svg>
      <div>
        <h1>Notícias de Aincrad</h1>
        <p>Tudo que acontece no castelo flutuante — bosses, andares, guildas e a campanha em andamento.</p>
      </div>
      <div style="display:flex;gap:10px;flex-wrap:wrap;justify-content:flex-end">
        <router-link v-if="!auth.logado" to="/cadastro" class="btn primario">📝 Criar conta</router-link>
        <button v-if="!auth.logado" class="btn ghost" @click="$emit('pedir-login')">🔑 Entrar</button>
        <router-link to="/inicio" class="btn ghost">🧭 Painel</router-link>
      </div>
    </section>

    <div class="tabs" style="flex-wrap:wrap">
      <button type="button" class="tab" :class="{ on: categoriaFiltro === '' }" @click="categoriaFiltro = ''">Todas</button>
      <button v-for="c in CATEGORIAS" :key="c.k" type="button" class="tab" :class="{ on: categoriaFiltro === c.k }" @click="categoriaFiltro = c.k">
        {{ c.ico }} {{ c.lbl }}
      </button>
    </div>

    <div v-if="carregando" class="msg info carregando">Carregando notícias…</div>
    <div v-else-if="!noticiasFiltradas.length" class="msg warn">Nenhuma notícia por aqui ainda — volte depois.</div>
    <div v-else style="display:grid;gap:14px">
      <div v-for="n in destaques" :key="'d' + n.id" class="anuncio-sistema">
        <div class="anuncio-tag">⚠ SYSTEM ANNOUNCEMENT</div>
        <h3>{{ n.titulo }}</h3>
        <p v-if="n.texto">{{ n.texto }}</p>
        <div class="anuncio-meta">
          <span class="pill on">{{ categoriaInfo(n.categoria).ico }} {{ categoriaInfo(n.categoria).lbl }}</span>
          <span v-if="n.andar" class="pill">🏯 {{ n.andar }}º andar</span>
          <span v-if="n.dia_aincrad" class="pill">📅 Dia {{ n.dia_aincrad }}</span>
          <span class="pill">{{ formatarData(n.publicado_em) }}</span>
        </div>
      </div>

      <div v-for="n in comuns" :key="n.id" class="card" style="cursor:default">
        <div class="ct">{{ n.titulo }}</div>
        <div class="cs">{{ categoriaInfo(n.categoria).ico }} {{ categoriaInfo(n.categoria).lbl }}<span v-if="n.andar"> · {{ n.andar }}º andar</span></div>
        <p v-if="n.texto">{{ n.texto }}</p>
        <div style="display:flex;gap:8px;flex-wrap:wrap;margin-top:6px">
          <span v-if="n.dia_aincrad" class="pill">📅 Dia {{ n.dia_aincrad }}</span>
          <span class="pill">{{ formatarData(n.publicado_em) }}</span>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, computed, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth.js'
import { useSupa } from '../lib/supabase.js'

defineEmits(['pedir-login'])
const auth = useAuthStore()
const supa = useSupa()

const CATEGORIAS = [
  { k: 'boss', ico: '💀', lbl: 'Boss' },
  { k: 'exploracao', ico: '🗺️', lbl: 'Exploração' },
  { k: 'item_raro', ico: '💎', lbl: 'Item Raro' },
  { k: 'guilda', ico: '🛡️', lbl: 'Guilda' },
  { k: 'evento', ico: '🌍', lbl: 'Evento' },
  { k: 'sistema', ico: '📘', lbl: 'Sistema' },
  { k: 'descoberta', ico: '🔍', lbl: 'Descoberta' },
  { k: 'conquista', ico: '🏆', lbl: 'Conquista' },
]
function categoriaInfo(k) { return CATEGORIAS.find(c => c.k === k) || { ico: '📰', lbl: k || '—' } }

const carregando = ref(true)
const noticias = ref([])
const categoriaFiltro = ref('')

const noticiasFiltradas = computed(() => {
  let l = noticias.value
  if (categoriaFiltro.value) l = l.filter(n => n.categoria === categoriaFiltro.value)
  return l
})
const destaques = computed(() => noticiasFiltradas.value.filter(n => n.destaque))
const comuns = computed(() => noticiasFiltradas.value.filter(n => !n.destaque))

function formatarData(iso) {
  if (!iso) return ''
  try { return new Date(iso).toLocaleDateString('pt-BR', { day: '2-digit', month: 'short', year: 'numeric' }) } catch { return '' }
}

async function carregar() {
  carregando.value = true
  try {
    const r = await supa.from('noticias').select('*').eq('visivel', true).order('destaque', { ascending: false }).order('publicado_em', { ascending: false }).limit(100)
    if (r.error) throw r.error
    noticias.value = r.data || []
  } catch (e) { console.warn(e); noticias.value = [] } finally { carregando.value = false }
}
onMounted(async () => {
  if (!auth.ready) await auth.init()
  await carregar()
})
</script>
<style scoped>
.anuncio-sistema {
  border: 1px solid var(--laranja-dim);
  background: linear-gradient(135deg, #2a2512 0%, #1a1208 100%);
  border-radius: 4px;
  padding: 18px 20px;
  box-shadow: 0 0 24px rgba(255, 153, 0, 0.1);
}
.anuncio-tag {
  font-family: var(--f-mono);
  font-size: 11px;
  letter-spacing: 0.18em;
  color: var(--laranja-bright);
  margin-bottom: 6px;
}
.anuncio-sistema h3 { margin: 0 0 6px; color: var(--gold-bright); font-size: 19px }
.anuncio-sistema p { margin: 0 0 10px; color: var(--ink-dim) }
.anuncio-meta { display: flex; gap: 8px; flex-wrap: wrap }
</style>
