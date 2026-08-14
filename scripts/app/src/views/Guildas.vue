<!-- Hub de Aincrad, item 4: página de cada clã — emblema, liderança,
     membros, nível médio, missões/bosses e conquistas. Pedir entrada de
     verdade (mensagem, aprovação) continua em Cooperação → Recrutamento;
     aqui é o diretório/perfil público dos clãs. -->
<template>
  <div>
    <TituloHUD icone="🛡️" titulo="Guildas & Clãs" trilha="Quem já deixou sua marca em Aincrad" />

    <div v-if="carregando" class="msg info carregando">Carregando clãs…</div>
    <div v-else-if="!clas.length" class="msg warn">Nenhum clã cadastrado ainda.</div>
    <div v-else class="grid">
      <div v-for="c in clas" :key="c.nome" class="card" role="button" tabindex="0"
        style="cursor:pointer" @click="abrir(c)" @keydown.enter="abrir(c)">
        <img v-if="c.logo_url" :src="urlImagem(c.logo_url)" :alt="c.nome" style="width:100%;aspect-ratio:16/9;object-fit:cover;border-radius:6px;margin-bottom:8px">
        <div class="ct">{{ c.nome }}</div>
        <div class="cs">👥 {{ c.membros_count || 0 }} membros<span v-if="c.nivel_medio"> · Nível médio {{ c.nivel_medio }}</span></div>
        <p v-if="c.lider_personagem">👑 Líder: {{ c.lider_personagem }}</p>
        <div style="display:flex;gap:6px;flex-wrap:wrap">
          <span class="pill">💀 {{ c.bosses_derrotados || 0 }} bosses</span>
          <span class="pill">📜 {{ c.missoes_concluidas || 0 }} missões</span>
          <span v-if="c.recrutando" class="pill cta">🚪 recrutando</span>
        </div>
      </div>
    </div>

    <div v-if="aberto" class="modal-bg on" @click.self="aberto = null">
      <div class="modal" style="max-width:720px">
        <div class="top">
          <h2>{{ aberto.nome }}</h2>
          <button class="btn ghost" @click="aberto = null">✕</button>
        </div>
        <div class="body">
          <img v-if="aberto.logo_url" :src="urlImagem(aberto.logo_url)" :alt="aberto.nome" style="width:100%;max-height:260px;object-fit:cover;border-radius:8px;margin-bottom:12px">

          <div style="display:flex;gap:8px;flex-wrap:wrap;margin-bottom:10px">
            <span class="pill on">👥 {{ aberto.membros_count || 0 }} membros</span>
            <span v-if="aberto.nivel_medio" class="pill">📈 Nível médio {{ aberto.nivel_medio }}</span>
            <span class="pill">💀 {{ aberto.bosses_derrotados || 0 }} bosses derrotados</span>
            <span class="pill">📜 {{ aberto.missoes_concluidas || 0 }} missões concluídas</span>
          </div>
          <p v-if="aberto.lider_personagem">👑 <b>Líder:</b> {{ aberto.lider_personagem }}</p>
          <p v-if="aberto.vice_lider_personagem">🎖️ <b>Vice-Líder:</b> {{ aberto.vice_lider_personagem }}</p>

          <p v-if="aberto.resumo" style="color:var(--gold-bright);font-style:italic;margin-top:10px">{{ aberto.resumo }}</p>
          <p v-if="aberto.forca"><b>Força:</b> {{ aberto.forca }}</p>
          <p v-if="aberto.necessidade"><b>Necessidade:</b> {{ aberto.necessidade }}</p>

          <div v-if="aberto.conquistas?.length" style="margin-top:14px">
            <h4 style="margin:0 0 8px;color:var(--azul-bright)">🏆 Conquistas</h4>
            <div style="display:flex;flex-wrap:wrap;gap:6px">
              <span v-for="conq in aberto.conquistas" :key="conq" class="pill on">🏆 {{ conq }}</span>
            </div>
          </div>

          <div v-if="aberto.recrutando" class="msg info" style="margin-top:14px">
            🚪 Esse clã está recrutando.
            <router-link to="/cooperacao" style="color:var(--gold-bright)">Peça entrada em Cooperação → Recrutamento.</router-link>
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
const clas = ref([])
const aberto = ref(null)
function abrir(c) { aberto.value = c }

async function carregar() {
  carregando.value = true
  try {
    const r = await supa.from('clas_publico').select('*').order('destaque', { ascending: false }).order('nome')
    if (r.error) throw r.error
    clas.value = r.data || []
  } catch (e) { console.warn(e); clas.value = [] } finally { carregando.value = false }
}
onMounted(carregar)
</script>
