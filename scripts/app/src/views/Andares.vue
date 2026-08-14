<!-- Hub de Aincrad, item 2: informações por andar — exploração, monstros
     conhecidos, MVP e ficha do boss (ou "BOSS: ???" antes de descoberto). -->
<template>
  <div>
    <TituloHUD icone="🏯" titulo="Andares de Aincrad" trilha="O que já foi descoberto, andar a andar" />

    <div v-if="carregando" class="msg info carregando">Carregando andares…</div>
    <div v-else-if="!andares.length" class="msg warn">Nenhum andar cadastrado ainda.</div>
    <div v-else class="grid">
      <div v-for="a in andares" :key="a.numero" class="card" role="button" tabindex="0"
        style="cursor:pointer" @click="abrir(a)" @keydown.enter="abrir(a)">
        <div class="ct">{{ a.numero }}º Andar<span v-if="a.nome"> — {{ a.nome }}</span></div>
        <div class="cs">
          <span class="pill" :class="statusInfo(a.status).classe">{{ statusInfo(a.status).ico }} {{ statusInfo(a.status).lbl }}</span>
        </div>
        <p>
          Exploração: <b>{{ a.exploracao_pct || 0 }}%</b> ·
          Boss: <b>{{ a.boss_status === 'nao_descoberto' ? '???' : (a.boss_nome || bossStatusInfo(a.boss_status).lbl) }}</b>
        </p>
      </div>
    </div>

    <div v-if="aberto" class="modal-bg on" @click.self="aberto = null">
      <div class="modal" style="max-width:720px">
        <div class="top">
          <h2>{{ aberto.numero }}º Andar<span v-if="aberto.nome"> — {{ aberto.nome }}</span></h2>
          <button class="btn ghost" @click="aberto = null">✕</button>
        </div>
        <div class="body">
          <span class="pill on" :class="statusInfo(aberto.status).classe">{{ statusInfo(aberto.status).ico }} {{ statusInfo(aberto.status).lbl }}</span>
          <span class="pill" style="margin-left:8px">🧭 Exploração: {{ aberto.exploracao_pct || 0 }}%</span>

          <p v-if="aberto.info_descobertas" style="margin-top:12px;white-space:pre-wrap">{{ aberto.info_descobertas }}</p>

          <div v-if="aberto.monstros_conhecidos?.length" style="margin-top:14px">
            <h4 style="margin:0 0 8px;color:var(--azul-bright)">👹 Monstros conhecidos</h4>
            <div style="display:flex;flex-wrap:wrap;gap:6px">
              <span v-for="m in aberto.monstros_conhecidos" :key="m" class="pill">{{ m }}</span>
            </div>
          </div>

          <div v-if="aberto.mvp_personagem_nome" style="margin-top:16px" class="msg ok">
            <b>🏅 MVP do Andar:</b> {{ aberto.mvp_personagem_nome }}
            <div v-if="aberto.mvp_feito" style="margin-top:4px">{{ aberto.mvp_feito }}</div>
            <div v-if="aberto.mvp_titulo" style="margin-top:4px;font-style:italic">Título: "{{ aberto.mvp_titulo }}"</div>
          </div>

          <div style="margin-top:16px;padding:14px;border:1px solid var(--line);border-radius:6px;background:var(--panel-3)">
            <h4 style="margin:0 0 8px;color:var(--laranja-bright)">👹 Boss</h4>
            <div v-if="aberto.boss_status === 'nao_descoberto'" style="font-family:var(--f-mono);font-size:20px;letter-spacing:.06em">BOSS: ???</div>
            <template v-else>
              <img v-if="aberto.boss_img" :src="urlImagem(aberto.boss_img)" :alt="aberto.boss_nome" style="width:100%;max-height:220px;object-fit:cover;border-radius:6px;margin-bottom:10px">
              <div class="ct">{{ aberto.boss_nome || '(sem nome)' }}</div>
              <div class="cs" style="margin:4px 0 8px">{{ bossStatusInfo(aberto.boss_status).ico }} {{ bossStatusInfo(aberto.boss_status).lbl }}</div>
              <p v-if="aberto.boss_localizacao"><b>Localização:</b> {{ aberto.boss_localizacao }}</p>
              <p v-if="aberto.boss_info">{{ aberto.boss_info }}</p>
              <template v-if="aberto.boss_status === 'derrotado'">
                <p v-if="aberto.boss_grupo_responsavel"><b>Grupo responsável:</b> {{ aberto.boss_grupo_responsavel }}</p>
                <p v-if="aberto.boss_participantes?.length"><b>Participantes:</b> {{ aberto.boss_participantes.join(', ') }}</p>
                <p v-if="aberto.boss_data_derrota"><b>Derrotado em:</b> {{ formatarData(aberto.boss_data_derrota) }}</p>
                <p v-if="aberto.boss_recompensas"><b>Recompensas:</b> {{ aberto.boss_recompensas }}</p>
                <p v-if="aberto.boss_drops"><b>Drops conhecidos:</b> {{ aberto.boss_drops }}</p>
              </template>
            </template>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import { useSupa } from '../lib/supabase.js'
import { urlImagem } from '../lib/imagens.js'
import TituloHUD from '../components/TituloHUD.vue'

const supa = useSupa()
const carregando = ref(true)
const andares = ref([])
const aberto = ref(null)

const STATUS = {
  bloqueado: { ico: '🔒', lbl: 'Bloqueado', classe: 'bad' },
  em_exploracao: { ico: '🧭', lbl: 'Em exploração', classe: '' },
  boss_descoberto: { ico: '👁️', lbl: 'Boss descoberto', classe: '' },
  boss_derrotado: { ico: '⚔️', lbl: 'Boss derrotado', classe: 'on' },
  concluido: { ico: '✅', lbl: 'Concluído', classe: 'on' },
}
const BOSS_STATUS = {
  nao_descoberto: { ico: '❔', lbl: 'Não descoberto' },
  descoberto: { ico: '👁️', lbl: 'Descoberto' },
  batalha_disponivel: { ico: '⚔️', lbl: 'Batalha disponível' },
  derrotado: { ico: '💀', lbl: 'Derrotado' },
}
function statusInfo(s) { return STATUS[s] || { ico: '❔', lbl: s, classe: '' } }
function bossStatusInfo(s) { return BOSS_STATUS[s] || { ico: '❔', lbl: s || '???' } }
function formatarData(iso) {
  if (!iso) return ''
  try { return new Date(iso).toLocaleDateString('pt-BR', { day: '2-digit', month: 'short', year: 'numeric' }) } catch { return '' }
}
function abrir(a) { aberto.value = a }

async function carregar() {
  carregando.value = true
  try {
    const r = await supa.from('andares').select('*').eq('visivel', true).order('numero')
    if (r.error) throw r.error
    andares.value = r.data || []
  } catch (e) { console.warn(e); andares.value = [] } finally { carregando.value = false }
}
onMounted(carregar)
</script>
