<template>
  <div>
    <StatusBar />
    <TituloHUD icone="📚" titulo="Compêndio do Andar 1" trilha="Sistema · Enciclopédia" />
    <p style="margin:0 0 12px;color:var(--ink-dim);font-size:13px">
      Migrado de <code>compendio_andar1.html</code> pro Vue — mesmo conteúdo, direto do banco. "Mesa" e
      "Só o Mestre" ficaram no <router-link to="/mestre" style="color:var(--gold-bright)">Painel do Mestre</router-link>,
      aba Mesa & Sessão.
    </p>
    <div class="tabs" style="margin:8px 0;flex-wrap:wrap">
      <button type="button" class="tab" :class="{on: abaAtiva==='mapa'}" @click="selecionar('mapa')">🗺️ Mapa</button>
      <button type="button" v-for="t in TABS" :key="t.k" class="tab" :class="{on: abaAtiva===t.k}" @click="selecionar(t.k)">{{ t.ico }} {{ t.label }}</button>
    </div>

    <!-- ===== Mapa (pontos reais, sem o terreno artístico do HTML legado) ===== -->
    <div v-if="abaAtiva==='mapa'">
      <div v-if="carregandoMapa" class="msg info carregando">Carregando mapa…</div>
      <div v-else>
        <div style="display:flex;gap:10px;flex-wrap:wrap;margin:0 0 10px;align-items:center">
          <select v-model="regiaoFiltro" style="background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:8px 10px;border-radius:6px;font:inherit">
            <option value="">Todas as regiões</option>
            <option v-for="r in regioesMapa" :key="r" :value="r">{{ r }}</option>
          </select>
          <select v-model="categoriaFiltro" style="background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:8px 10px;border-radius:6px;font:inherit">
            <option value="">Todas as categorias</option>
            <option v-for="c in categoriasMapa" :key="c" :value="c">{{ CAT_INFO[c]?.label || c }}</option>
          </select>
          <span class="pill">{{ pontosFiltrados.length }} pontos</span>
          <div style="display:flex;gap:4px;margin-left:auto">
            <button class="btn tiny" :class="{on: mostrarTerreno}" @click="mostrarTerreno=!mostrarTerreno" title="Terreno artístico desenhado por código (rios, montanhas, cidades…) por baixo dos marcadores">
              🖼️ Terreno {{ mostrarTerreno ? 'ligado' : 'desligado' }}
            </button>
            <button class="btn tiny" @click="zoom=Math.max(0.5,zoom-0.25)">➖</button>
            <button class="btn tiny" @click="zoom=1">100%</button>
            <button class="btn tiny" @click="zoom=Math.min(3,zoom+0.25)">➕</button>
          </div>
        </div>
        <div style="overflow:auto;border:1px solid var(--line);border-radius:8px;background:var(--panel-3);max-height:70vh">
          <svg :width="1536*zoom" :height="1024*zoom" viewBox="0 0 1536 1024" style="display:block">
            <rect x="0" y="0" width="1536" height="1024" fill="#070502"/>
            <g ref="gTerrenoRef"></g>
            <g v-for="p in pontosFiltrados" :key="p.id" :transform="`translate(${p.x},${p.y})`" style="cursor:pointer" @click="abrirPonto(p)">
              <circle r="9" :fill="CAT_INFO[p.categoria]?.cor || '#8888aa'" stroke="#0a0806" stroke-width="1.5"/>
              <text y="-13" text-anchor="middle" font-size="10" fill="#efe5d2" stroke="#0a0806" stroke-width="2.5px" paint-order="stroke" style="pointer-events:none">{{ p.nome }}</text>
            </g>
          </svg>
        </div>
        <div style="margin-top:10px;display:flex;gap:10px;flex-wrap:wrap">
          <span v-for="(info,cat) in CAT_INFO" :key="cat" class="pill" :style="{borderColor:info.cor}">
            <span :style="{display:'inline-block',width:'8px',height:'8px',borderRadius:'50%',background:info.cor,marginRight:'4px'}"></span>{{ info.label }}
          </span>
        </div>
      </div>

      <!-- ficha do ponto -->
      <div v-if="pontoAberto" class="modal-bg on" @click.self="pontoAberto=null">
        <div class="modal" style="max-width:640px">
          <div class="top">
            <h2>{{ pontoAberto.nome }}</h2>
            <button class="btn ghost" @click="pontoAberto=null">✕</button>
          </div>
          <div class="body">
            <div class="cs" style="margin-bottom:8px">{{ pontoAberto.regiao }} · {{ CAT_INFO[pontoAberto.categoria]?.label || pontoAberto.categoria }}</div>
            <p v-if="detalhePonto?.leitura" style="font-style:italic;color:var(--gold-bright)">{{ detalhePonto.leitura }}</p>
            <p v-if="pontoAberto.descricao">{{ pontoAberto.descricao }}</p>
            <p v-if="detalhePonto?.oque">{{ detalhePonto.oque }}</p>
            <p v-if="pontoAberto.recompensa"><b>Recompensa:</b> {{ pontoAberto.recompensa }}</p>
            <p v-if="pontoAberto.ameaca"><b>Ameaça:</b> {{ pontoAberto.ameaca }} · <b>golpes:</b> {{ pontoAberto.golpes }}</p>
            <div v-if="auth.ehMestre && (pontoAberto.mestre || detalhePonto?.mestre)" class="msg warn" style="margin-top:10px">
              <b>Só mestre:</b> {{ pontoAberto.mestre || detalhePonto?.mestre }}
            </div>
          </div>
        </div>
      </div>
    </div>

    <div v-else-if="carregando" class="msg info carregando">Carregando…</div>
    <div v-else-if="!itensFiltrados.length" class="msg warn">Nada encontrado.</div>
    <div v-else>
      <div style="display:flex;gap:10px;flex-wrap:wrap;margin:10px 0 14px">
        <input v-model="busca" placeholder="🔎 Buscar…"
          style="flex:1 1 220px;background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:9px 12px;border-radius:6px;font:inherit">
        <span class="pill">{{ itensFiltrados.length }} {{ itensFiltrados.length===1?'item':'itens' }}</span>
      </div>
      <div class="grid" :class="{ 'grid-icones': abaAtiva==='armas' }">
        <div v-for="it in itensFiltrados" :key="chave(it)" class="card" :class="[abaAtiva==='armas' ? '' : classeRaridade(it), { 'card-icone': abaAtiva==='armas' }]" role="button" tabindex="0"
          @click="abrir(it)" @keydown.enter="abrir(it)" @keydown.space.prevent="abrir(it)" style="cursor:pointer">
          <template v-if="abaAtiva==='armas'">
            <IconeArma :tipo="it.tipo" :raridade="it.raridade" :tamanho="64" />
            <div class="ct" style="text-align:center">{{ titulo(it) }}</div>
          </template>
          <template v-else>
            <img v-if="campo(it,'img')" :src="urlImagem(campo(it,'img'))" :alt="titulo(it)" style="width:100%;aspect-ratio:4/3;object-fit:cover;border-radius:6px;margin-bottom:8px">
            <div class="ct">{{ titulo(it) }}</div>
            <div class="cs" v-if="subtitulo(it)">{{ subtitulo(it) }}</div>
            <p v-if="resumo(it)">{{ resumo(it).slice(0,160) }}{{ resumo(it).length>160?'…':'' }}</p>
          </template>
        </div>
      </div>
    </div>

    <!-- modal de ficha completa -->
    <div v-if="aberto" class="modal-bg on" @click.self="aberto=null">
      <div class="modal" style="max-width:760px">
        <div class="top">
          <h2>{{ titulo(aberto) }}</h2>
          <button class="btn ghost" @click="aberto=null">✕</button>
        </div>
        <div class="body">
          <div v-if="abaAtiva==='armas'" style="display:flex;justify-content:center;margin-bottom:12px">
            <IconeArma :tipo="aberto.tipo" :raridade="aberto.raridade" :tamanho="120" />
          </div>
          <img v-else-if="campo(aberto,'img')" :src="urlImagem(campo(aberto,'img'))" :alt="titulo(aberto)" style="width:100%;max-height:320px;object-fit:cover;border-radius:8px;margin-bottom:12px">
          <div v-if="subtitulo(aberto)" class="cs" style="margin-bottom:8px">{{ subtitulo(aberto) }}</div>
          <div v-for="f in tabAtual.pills||[]" :key="f" style="display:inline-block;margin:0 6px 8px 0">
            <span v-if="campo(aberto,f)" class="pill on">{{ String(campo(aberto,f)) }}</span>
          </div>
          <p v-if="resumo(aberto)" style="color:var(--gold-bright);font-style:italic">{{ resumo(aberto) }}</p>
          <div v-for="f in tabAtual.corpo||[]" :key="f" style="margin-top:10px;white-space:pre-wrap;font-size:13.5px;line-height:1.6">
            <div v-if="campo(aberto,f)">
              <b v-if="tabAtual.corpo.length>1" style="color:var(--gold-dim);text-transform:uppercase;font-size:11px;letter-spacing:.08em">{{ f }}</b>
              <div>{{ formatarCampo(campo(aberto,f)) }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch, nextTick } from 'vue'
import { useAuthStore } from '../stores/auth.js'
import { useSupa } from '../lib/supabase.js'
import StatusBar from '../components/StatusBar.vue'
import { urlImagem } from '../lib/imagens.js'
import TituloHUD from '../components/TituloHUD.vue'
import IconeArma from '../components/IconeArma.vue'
import { desenharTerreno } from '../lib/mapaTerreno.js'

const auth = useAuthStore()
const supa = useSupa()

// Config por aba: tabela base, view pública (quando existe campo "só
// mestre" que quebraria o select inteiro pra jogador — RLS de coluna,
// não de linha, ver achado registrado em docs/pendencias.md 10/08),
// título/subtítulo/resumo/corpo mapeando os campos reais de cada tabela.
const TABS = [
  { k:'bestiario', ico:'💀', label:'Bestiário', tabela:'monstros', view:'monstros_publico',
    titulo:['nome'], subtitulo:['tipo','ameaca'], resumo:['resumo'], corpo:['habitat','comportamento','leitura','lore','corpo'], pills:['nivel_recomendado','atributo_fraqueza'] },
  { k:'npcs', ico:'🧑', label:'NPCs', tabela:'npcs',
    titulo:['nome'], subtitulo:['papel','profissao'], resumo:['resumo'], corpo:['gancho','corpo'], pills:['local'] },
  { k:'armas', ico:'⚔️', label:'Armas', tabela:'armas',
    titulo:['nome'], subtitulo:['tipo','raridade'], resumo:['resumo'], corpo:['efeito','obter'], pills:['atributo','preco_txt'] },
  { k:'equipamentos', ico:'🥋', label:'Equipamentos', tabela:'equipamentos',
    titulo:['nome'], subtitulo:['slot','raridade'], resumo:['resumo'], corpo:['efeito','obter'], pills:['preco_txt'] },
  { k:'quests', ico:'📜', label:'Quests', tabela:'quests',
    titulo:['titulo'], subtitulo:['tipo','dificuldade'], resumo:['resumo'], corpo:['corpo'], pills:['regiao','npc'] },
  { k:'cronicas', ico:'📖', label:'Crônicas', tabela:'cronicas',
    titulo:['titulo'], subtitulo:['ep_rotulo','tipo'], resumo:['resumo'], corpo:['corpo'], pills:['regiao','dificuldade'] },
  { k:'guias', ico:'🗺️', label:'Guia das Regiões', tabela:'guias', view:'guias_publico',
    titulo:['nome'], subtitulo:['bioma','nivel'], resumo:['chegada'], corpo:['leitura','cena','demora','evento'], pills:['nivel'] },
  { k:'puzzles', ico:'🧩', label:'Puzzles', tabela:'puzzles', view:'puzzles_publico',
    titulo:['nome'], subtitulo:['tipo','cadeia'], resumo:[], corpo:['corpo','recompensa'], pills:['regiao','duracao'] },
  { k:'dungeons', ico:'🏰', label:'Dungeons', tabela:'dungeons',
    titulo:['nome'], subtitulo:['regiao','nivel'], resumo:['perfil'], corpo:['nota'], pills:['nivel'] },
  { k:'cidades', ico:'🏙️', label:'Cidade do Início', tabela:'cidades',
    titulo:['nome'], subtitulo:['tipo_de_zona'], resumo:[], corpo:['corpo'], pills:['andar'] },
  { k:'oficios', ico:'🔨', label:'Ofícios', tabela:'oficios',
    titulo:['nome'], subtitulo:['atributo'], resumo:['marca'], corpo:['gancho','renda','item'], pills:['contato'] },
  { k:'mercado', ico:'🏪', label:'Mercado', tabela:'mercado',
    titulo:['nome'], subtitulo:['regiao'], resumo:['descricao'], corpo:[], pills:['desconto'] },
  { k:'sistema', ico:'📘', label:'Sistema', tabela:'sistema',
    titulo:['titulo'], subtitulo:[], resumo:[], corpo:['corpo'], pills:[] },
]

const abaAtiva = ref('bestiario')
const busca = ref('')
const carregando = ref(false)
const itens = ref([])
const aberto = ref(null)
const cache = {}

const tabAtual = computed(() => TABS.find(t => t.k === abaAtiva.value))

function campo(it, nome){ return it ? it[nome] : null }
// acento de raridade na borda do card — só decora quando a tabela tem
// campo "raridade" (armas/equipamentos hoje); vira classe rar-* já
// existente no main.css (era declarada mas nunca usada em lugar nenhum).
function classeRaridade(it){
  const r = it?.raridade
  if (!r) return ''
  const norm = String(r).normalize('NFD').replace(/[̀-ͯ]/g,'').toLowerCase()
  return ['comum','incomum','raro','epico','lendario'].includes(norm) ? 'rar-borda-'+norm : ''
}
function primeiro(it, lista){ for (const f of (lista||[])) { if (campo(it,f)) return campo(it,f) } return '' }
function titulo(it){ return primeiro(it, tabAtual.value.titulo) || '(sem nome)' }
function subtitulo(it){ return (tabAtual.value.subtitulo||[]).map(f=>campo(it,f)).filter(Boolean).join(' · ') }
function resumo(it){ return primeiro(it, tabAtual.value.resumo) }
function chave(it){ return it.id || it.titulo || it.nome }
function formatarCampo(v){
  if (v == null) return ''
  if (Array.isArray(v)) return v.map(x => typeof x === 'string' ? x : JSON.stringify(x)).join('\n')
  if (typeof v === 'object') return JSON.stringify(v, null, 1)
  return String(v)
}

function abrir(it){ aberto.value = it }
function selecionar(k){ abaAtiva.value = k; busca.value = '' }

const itensFiltrados = computed(() => {
  let l = itens.value
  const q = busca.value.trim().toLowerCase()
  if (q) l = l.filter(it => JSON.stringify(it).toLowerCase().includes(q))
  return l
})

// ===== ====== MAPA (pontos com x/y reais, sem o terreno artístico) ===== ======
const CAT_INFO = {
  npc:        { label:'NPC',         cor:'#57d9ff' },
  monstro:    { label:'Monstro',     cor:'#ff5f5f' },
  chefe:      { label:'Chefe',       cor:'#ff2b2b' },
  recurso:    { label:'Recurso',     cor:'#8fd694' },
  segredo:    { label:'Segredo',     cor:'#ffb454' },
  puzzle:     { label:'Puzzle',      cor:'#c98fff' },
  dungeon:    { label:'Dungeon',     cor:'#a86a3d' },
  cidade:     { label:'Cidade',      cor:'#f2d18a' },
  comerciante:{ label:'Comerciante', cor:'#d9ad5e' },
}
const carregandoMapa = ref(true)
const pontosMapa = ref([])
const pontosDetalheMapa = {}
const regiaoFiltro = ref(''), categoriaFiltro = ref('')
const zoom = ref(0.75)
const pontoAberto = ref(null)
const detalhePonto = ref(null)
// item "Mapa Artístico" do dolist: terreno vetorial procedural (rios,
// montanhas, cidades, florestas…) desenhado por baixo dos 246 pontos reais
// — mesmo viewBox 0 0 1536 1024, então nasce alinhado sem calibração.
// Porta de scripts/web/dados_terreno.js + mapa_limpo.html (só o modo
// "arte" — o modo referência/export PNG do legado era pra um fluxo manual
// de gerar arte por IA fora do jogo, fora de escopo aqui).
const mostrarTerreno = ref(true)
const gTerrenoRef = ref(null)
function redesenharTerreno(){
  if (!mostrarTerreno.value || !gTerrenoRef.value) {
    if (gTerrenoRef.value) gTerrenoRef.value.textContent = ''
    return
  }
  desenharTerreno(gTerrenoRef.value, pontosMapa.value)
}
watch(mostrarTerreno, redesenharTerreno)
watch(pontosMapa, () => nextTick(redesenharTerreno))

const regioesMapa = computed(() => [...new Set(pontosMapa.value.map(p=>p.regiao).filter(Boolean))].sort())
const categoriasMapa = computed(() => [...new Set(pontosMapa.value.map(p=>p.categoria).filter(Boolean))].sort())
const pontosFiltrados = computed(() => {
  let l = pontosMapa.value
  if (regiaoFiltro.value) l = l.filter(p => p.regiao === regiaoFiltro.value)
  if (categoriaFiltro.value) l = l.filter(p => p.categoria === categoriaFiltro.value)
  return l
})

async function carregarMapa(){
  if (pontosMapa.value.length) { carregandoMapa.value = false; nextTick(redesenharTerreno); return }
  carregandoMapa.value = true
  try {
    // Sempre a view: ela já resolve is_mestre() internamente (CASE WHEN,
    // ver schema) e devolve a coluna "mestre" de verdade pro mestre e null
    // pro jogador. Achado 10/08: usar a tabela base como mestre quebrava
    // com "permission denied" — a coluna "mestre" nunca teve GRANT SELECT
    // pra authenticated (só a view expõe isso com segurança).
    const r = await supa.from('pontos_publico').select('*').limit(500)
    if (r.error) throw r.error
    pontosMapa.value = (r.data || []).filter(p => p.x != null && p.y != null)
  } catch(e){ console.warn(e); pontosMapa.value = [] }
  finally { carregandoMapa.value = false; nextTick(redesenharTerreno) }
}
async function abrirPonto(p){
  pontoAberto.value = p
  detalhePonto.value = null
  if (pontosDetalheMapa[p.id] !== undefined) { detalhePonto.value = pontosDetalheMapa[p.id]; return }
  try {
    const r = await supa.from('pontos_detalhe_publico').select('*').eq('id', p.id).maybeSingle()
    pontosDetalheMapa[p.id] = r.data || null
    detalhePonto.value = pontosDetalheMapa[p.id]
  } catch(e){ console.warn(e) }
}

async function carregar(){
  if (abaAtiva.value === 'mapa') { await carregarMapa(); return }
  const t = tabAtual.value
  if (cache[t.k]) { itens.value = cache[t.k]; return }
  carregando.value = true
  try {
    // tabelas com coluna "só mestre" (monstros.notas, guias.mestre,
    // puzzles.verdade) SEMPRE usam a view, mestre incluído — a view resolve
    // is_mestre() internamente (CASE WHEN) e devolve o conteúdo real pro
    // mestre; a coluna nunca teve GRANT SELECT na tabela base pra
    // "authenticated" (nem pra mestre, já que jogador/mestre compartilham
    // esse role — GRANT de coluna não sabe diferenciar sessão). Achado
    // 10/08: consultar a tabela base como mestre quebrava com "permission
    // denied for table X" — corrigido usando sempre a view.
    const usaView = !!t.view
    const alvo = usaView ? t.view : t.tabela
    // as views _publico já filtram visivel=true internamente e nem
    // devolvem essa coluna — só filtra explicitamente na tabela base.
    let q = supa.from(alvo).select('*').limit(500)
    if (!usaView) q = q.eq('visivel', true)
    const r = await q
    if (r.error) throw r.error
    const dados = r.data || []
    cache[t.k] = dados
    itens.value = dados
  } catch (e) {
    console.warn(e)
    itens.value = []
  } finally { carregando.value = false }
}

watch(abaAtiva, carregar)
onMounted(async () => {
  if (!auth.ready) await auth.init()
  await carregar()
})
</script>
