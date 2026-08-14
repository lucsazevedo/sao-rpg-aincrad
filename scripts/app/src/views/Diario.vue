<!-- Hub de Aincrad, item 5: registro cronológico da campanha, começa no
     Dia 10, dois espaços por dia (Registro do Mestre / Registro dos
     Jogadores). Mestre escreve pelo Compêndio (Hub de Aincrad → Diário);
     jogador com personagem posta a própria entrada aqui mesmo. -->
<template>
  <div>
    <TituloHUD icone="📔" titulo="Diário de Aincrad" trilha="O registro cronológico da campanha" />

    <div v-if="auth.logado && auth.temPersonagem" class="card" style="margin-bottom:16px">
      <h4 style="margin:0 0 10px;color:var(--gold-bright)">✍️ Registrar no diário</h4>
      <div class="form">
        <div class="campo">
          <label>Dia de Aincrad</label>
          <input type="number" min="1" v-model.number="novoDia">
        </div>
        <div class="campo">
          <label>Título (opcional)</label>
          <input v-model.trim="novoTitulo" placeholder="Ex: A trilha que ninguém tinha visto">
        </div>
        <div class="campo">
          <label>Categoria (opcional)</label>
          <input v-model.trim="novaCategoria" placeholder="Ex: aventura, descoberta, rumor, momento memorável">
        </div>
        <div class="campo">
          <label>O que aconteceu</label>
          <textarea v-model.trim="novoTexto" rows="3" placeholder="Aventuras, descobertas, teorias, encontros…"></textarea>
        </div>
        <div style="display:flex;justify-content:flex-end">
          <button class="btn primario" :disabled="postando || !novoTexto.trim()" @click="postar()">
            {{ postando ? 'Enviando…' : '📔 Publicar no diário' }}
          </button>
        </div>
      </div>
    </div>
    <div v-else-if="auth.ready" class="msg info">🔑 Entre com um personagem pra registrar suas próprias aventuras no diário.</div>

    <div v-if="carregando" class="msg info carregando">Carregando diário…</div>
    <div v-else-if="!dias.length" class="msg warn">O diário ainda não tem registros.</div>
    <div v-else style="display:grid;gap:20px">
      <div v-for="d in dias" :key="d.dia">
        <h3 style="margin:0 0 10px;color:var(--laranja-bright);font-family:var(--f-titulo)">DIA {{ d.dia }}</h3>
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px" class="diario-colunas">
          <div>
            <div class="cs" style="margin-bottom:8px">🧙 Registro do Mestre</div>
            <div v-if="!d.mestre.length" class="msg warn" style="font-size:12.5px">Sem registro do mestre nesse dia.</div>
            <div v-for="e in d.mestre" :key="e.id" class="card" style="margin-bottom:10px">
              <div class="ct" v-if="e.titulo">{{ e.titulo }}</div>
              <div class="cs" v-if="e.categoria">{{ e.categoria }}</div>
              <p style="white-space:pre-wrap">{{ e.texto }}</p>
            </div>
          </div>
          <div>
            <div class="cs" style="margin-bottom:8px">⚔️ Registro dos Jogadores</div>
            <div v-if="!d.jogador.length" class="msg warn" style="font-size:12.5px">Ninguém registrou nada nesse dia ainda.</div>
            <div v-for="e in d.jogador" :key="e.id" class="card" style="margin-bottom:10px">
              <div class="ct" v-if="e.titulo">{{ e.titulo }}</div>
              <div class="cs">{{ e.autor_personagem_nome || 'Anônimo' }}<span v-if="e.categoria"> · {{ e.categoria }}</span></div>
              <p style="white-space:pre-wrap">{{ e.texto }}</p>
            </div>
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
import TituloHUD from '../components/TituloHUD.vue'

const auth = useAuthStore()
const supa = useSupa()

const carregando = ref(true)
const entradas = ref([])
const novoDia = ref(10)
const novoTitulo = ref('')
const novaCategoria = ref('')
const novoTexto = ref('')
const postando = ref(false)

const dias = computed(() => {
  const porDia = {}
  for (const e of entradas.value) {
    (porDia[e.dia] ||= { dia: e.dia, mestre: [], jogador: [] })
    porDia[e.dia][e.autor_tipo === 'mestre' ? 'mestre' : 'jogador'].push(e)
  }
  return Object.values(porDia).sort((a, b) => b.dia - a.dia)
})

async function carregar() {
  carregando.value = true
  try {
    const r = await supa.from('diario_entradas').select('*').eq('visivel', true).order('dia', { ascending: false }).order('criado_em', { ascending: false }).limit(300)
    if (r.error) throw r.error
    entradas.value = r.data || []
    if (entradas.value.length) novoDia.value = Math.max(...entradas.value.map(e => e.dia))
  } catch (e) { console.warn(e); entradas.value = [] } finally { carregando.value = false }
}
async function postar() {
  if (!novoTexto.value.trim()) return
  postando.value = true
  try {
    const r = await supa.rpc('postar_diario_jogador', {
      p_dia: novoDia.value, p_titulo: novoTitulo.value || null, p_texto: novoTexto.value, p_categoria: novaCategoria.value || null,
    })
    if (r.error) throw r.error
    const d = JSON.parse(r.data)
    if (d.erro) { alert(d.erro); return }
    novoTitulo.value = ''; novaCategoria.value = ''; novoTexto.value = ''
    await carregar()
  } catch (e) { alert('Erro: ' + e.message) } finally { postando.value = false }
}
onMounted(async () => {
  if (!auth.ready) await auth.init()
  await carregar()
})
</script>
<style scoped>
@media (max-width: 720px) { .diario-colunas { grid-template-columns: 1fr !important } }
</style>
