<!-- Hub de Aincrad, item 3: eventos que envolvem vários grupos/todos os
     jogadores, com objetivos globais e progresso. -->
<template>
  <div>
    <TituloHUD icone="🌍" titulo="Evento Global" trilha="O que está mudando o mundo de Aincrad agora" />

    <div v-if="carregando" class="msg info carregando">Carregando eventos…</div>
    <div v-else-if="!eventos.length" class="msg warn">Nenhum evento global no momento.</div>
    <div v-else style="display:grid;gap:16px">
      <div v-for="e in eventos" :key="e.id" class="card" style="cursor:default">
        <div class="ct">🌍 EVENTO GLOBAL — {{ e.nome }}</div>
        <div class="cs">
          <span class="pill" :class="statusInfo(e.status).classe">{{ statusInfo(e.status).ico }} {{ statusInfo(e.status).lbl }}</span>
          <span class="pill">Desde {{ formatarData(e.data_inicio) }}</span>
        </div>
        <p v-if="e.descricao">{{ e.descricao }}</p>
        <p v-if="e.objetivo"><b>Objetivo:</b> {{ e.objetivo }}</p>

        <div style="margin:10px 0">
          <div style="display:flex;justify-content:space-between;font-family:var(--f-mono);font-size:11px;letter-spacing:.06em;color:var(--azul-bright);margin-bottom:4px">
            <span>PROGRESSO GLOBAL</span><span>{{ e.progresso_pct || 0 }}%</span>
          </div>
          <div style="height:10px;background:rgba(0,0,0,.4);border-radius:3px;overflow:hidden;border:1px solid var(--line)">
            <div :style="{ width: (e.progresso_pct || 0) + '%', height: '100%', background: 'linear-gradient(90deg,#b06600,#ffb340)' }"></div>
          </div>
        </div>

        <div v-if="objetivosPorEvento[e.id]?.length" style="margin-top:10px">
          <h4 style="margin:0 0 8px;color:var(--azul-bright)">🎯 Objetivos globais</h4>
          <div v-for="o in objetivosPorEvento[e.id]" :key="o.id" style="margin-bottom:8px">
            <div style="display:flex;justify-content:space-between;font-size:13px;margin-bottom:3px">
              <span>{{ o.descricao }}</span>
              <span class="pill">{{ o.atual }}/{{ o.meta }}</span>
            </div>
            <div style="height:6px;background:rgba(0,0,0,.4);border-radius:3px;overflow:hidden;border:1px solid var(--line)">
              <div :style="{ width: pctObjetivo(o) + '%', height: '100%', background: 'var(--azul-bright)' }"></div>
            </div>
          </div>
        </div>

        <p v-if="e.participantes" style="margin-top:10px"><b>Participantes:</b> {{ e.participantes }}</p>
        <p v-if="e.status === 'concluido' && e.recompensa" class="msg ok" style="margin-top:10px"><b>🎁 Recompensa Global:</b> {{ e.recompensa }}</p>
        <p v-else-if="e.recompensa" style="margin-top:10px"><b>🎁 Recompensa Global (se concluído):</b> {{ e.recompensa }}</p>
        <p v-if="e.consequencia_fracasso" class="msg warn" style="margin-top:10px"><b>⚠️ Se fracassar:</b> {{ e.consequencia_fracasso }}</p>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import { useSupa } from '../lib/supabase.js'
import TituloHUD from '../components/TituloHUD.vue'

const supa = useSupa()
const carregando = ref(true)
const eventos = ref([])
const objetivosPorEvento = ref({})

const STATUS = {
  em_breve: { ico: '⏳', lbl: 'Em breve', classe: '' },
  ativo: { ico: '🔥', lbl: 'Ativo', classe: 'on' },
  concluido: { ico: '✅', lbl: 'Concluído', classe: 'on' },
  fracassado: { ico: '💥', lbl: 'Fracassado', classe: 'bad' },
}
function statusInfo(s) { return STATUS[s] || { ico: '❔', lbl: s, classe: '' } }
function pctObjetivo(o) { return o.meta > 0 ? Math.max(0, Math.min(100, Math.round((100 * o.atual) / o.meta))) : 0 }
function formatarData(iso) {
  if (!iso) return ''
  try { return new Date(iso).toLocaleDateString('pt-BR', { day: '2-digit', month: 'short', year: 'numeric' }) } catch { return '' }
}
// ordem: ativo primeiro, depois em_breve, depois concluído/fracassado
const ORDEM = { ativo: 0, em_breve: 1, concluido: 2, fracassado: 3 }

async function carregar() {
  carregando.value = true
  try {
    const r = await supa.from('eventos_globais').select('*').eq('visivel', true)
    if (r.error) throw r.error
    eventos.value = (r.data || []).sort((a, b) => (ORDEM[a.status] ?? 9) - (ORDEM[b.status] ?? 9) || new Date(b.data_inicio) - new Date(a.data_inicio))
    const ids = eventos.value.map(e => e.id)
    if (ids.length) {
      const ro = await supa.from('eventos_globais_objetivos').select('*').in('evento_id', ids).order('id')
      const agrupado = {}
      for (const o of (ro.data || [])) { (agrupado[o.evento_id] ||= []).push(o) }
      objetivosPorEvento.value = agrupado
    }
  } catch (e) { console.warn(e); eventos.value = [] } finally { carregando.value = false }
}
onMounted(carregar)
</script>
