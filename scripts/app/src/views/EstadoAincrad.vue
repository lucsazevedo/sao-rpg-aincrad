<!-- Hub de Aincrad, item 6: painel com a situação atual da campanha —
     dia, andar, jogadores, mortes, bosses, guildas, evento ativo e
     economia. Números vêm de estado_aincrad_resumo() (RPC), que agrega
     em tempo real (personagens, andares, clas, transacoes). -->
<template>
  <div>
    <TituloHUD icone="📊" titulo="Estado de Aincrad" trilha="Como o mundo está agora" />

    <div v-if="carregando" class="msg info carregando">Carregando estado de Aincrad…</div>
    <div v-else-if="!resumo" class="msg erro">Não foi possível carregar o estado de Aincrad.</div>
    <template v-else>
      <div class="grid">
        <div class="card"><div class="cs">📅 Dia dentro do jogo</div><div class="ct" style="font-size:26px">Dia {{ resumo.dia_atual }}</div></div>
        <div class="card"><div class="cs">🏯 Andar atual</div><div class="ct" style="font-size:26px">{{ resumo.andar_atual }}º</div></div>
        <div class="card"><div class="cs">⚔️ Jogadores</div><div class="ct" style="font-size:26px">{{ resumo.jogadores_ativos }}</div></div>
        <div class="card"><div class="cs">💀 Mortes</div><div class="ct" style="font-size:26px">{{ resumo.mortes }}</div></div>
        <div class="card"><div class="cs">👹 Bosses derrotados</div><div class="ct" style="font-size:26px">{{ resumo.bosses_derrotados }}</div></div>
        <div class="card"><div class="cs">🛡️ Guildas</div><div class="ct" style="font-size:26px">{{ resumo.quantidade_guildas }}</div></div>
      </div>

      <div style="margin-top:16px" class="card">
        <div class="cs" style="margin-bottom:8px">🌍 Evento ativo</div>
        <div v-if="!resumo.eventos_ativos?.length" style="color:var(--ink-dim)">Nenhum evento global ativo no momento.</div>
        <div v-else style="display:flex;gap:8px;flex-wrap:wrap">
          <router-link v-for="e in resumo.eventos_ativos" :key="e.id" to="/evento-global" class="pill on">🔥 {{ e.nome }}</router-link>
        </div>
      </div>

      <div style="margin-top:16px" class="card">
        <h4 style="margin:0 0 12px;color:var(--laranja-bright)">💰 Economia</h4>
        <div class="grid">
          <div class="card" style="background:var(--panel-3)"><div class="cs">Col em circulação</div><div class="ct">{{ nf(resumo.economia.col_em_circulacao) }}</div></div>
          <div class="card" style="background:var(--panel-3)"><div class="cs">Col gasto em lojas</div><div class="ct">{{ nf(resumo.economia.col_gasto_em_lojas) }}</div></div>
          <div class="card" style="background:var(--panel-3)"><div class="cs">Col recebido em missões</div><div class="ct">{{ nf(resumo.economia.col_recebido_em_missoes) }}</div></div>
          <div class="card" style="background:var(--panel-3)"><div class="cs">Item mais comercializado</div><div class="ct">{{ resumo.economia.item_mais_comercializado || '—' }}</div></div>
          <div class="card" style="background:var(--panel-3)">
            <div class="cs">Item mais caro vendido</div>
            <div class="ct">{{ resumo.economia.item_mais_caro_vendido || '—' }}</div>
            <p v-if="resumo.economia.item_mais_caro_valor">{{ nf(resumo.economia.item_mais_caro_valor) }} Col</p>
          </div>
          <div class="card" style="background:var(--panel-3)"><div class="cs">Guilda mais rica</div><div class="ct">{{ resumo.economia.guilda_mais_rica || '—' }}</div></div>
        </div>
      </div>
    </template>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import { useSupa } from '../lib/supabase.js'
import TituloHUD from '../components/TituloHUD.vue'

const supa = useSupa()
const carregando = ref(true)
const resumo = ref(null)
const nfFormat = new Intl.NumberFormat('pt-BR')
function nf(v) { return nfFormat.format(v || 0) }

async function carregar() {
  carregando.value = true
  try {
    const r = await supa.rpc('estado_aincrad_resumo')
    if (r.error) throw r.error
    resumo.value = JSON.parse(r.data)
  } catch (e) { console.warn(e); resumo.value = null } finally { carregando.value = false }
}
onMounted(carregar)
</script>
