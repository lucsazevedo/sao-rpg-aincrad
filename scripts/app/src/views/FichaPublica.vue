<!-- Ficha pública — qualquer personagem visível pode ser visto por qualquer
     visitante (mesmo dado que já era selecionável via RLS pra visivel=true;
     isso só dá uma tela de verdade em vez de precisar consultar a API na
     unha). Usado como link compartilhável e também pelo resto do Hub de
     Aincrad (MVP do andar, liderança de clã) pra apontar pro jogador. -->
<template>
  <div>
    <div v-if="carregando" class="msg info carregando">Carregando ficha…</div>
    <div v-else-if="!personagem" class="msg warn">Personagem não encontrado (ou a ficha está oculta).</div>
    <template v-else>
      <TituloHUD icone="🧑" :titulo="personagem.nome" trilha="Ficha pública · Aincrad" />
      <div class="ficha-layout" style="display:grid;grid-template-columns:220px 1fr;gap:16px">
        <div class="card" style="padding:16px;text-align:center">
          <img v-if="foto" :src="foto" :alt="'Retrato de ' + personagem.nome"
            style="width:100%;aspect-ratio:1/1;object-fit:cover;border-radius:10px;border:2px solid var(--gold-dim)">
          <div v-else style="width:100%;aspect-ratio:1/1;border-radius:10px;border:2px dashed var(--line);display:grid;place-items:center;color:var(--ink-faint);font-size:60px">👤</div>
          <div style="margin-top:10px;font-weight:700;color:var(--gold-bright);font-size:18px">{{ personagem.nome }}</div>
          <router-link v-if="personagem.guilda" :to="`/guildas`" class="pill on" style="margin-top:6px;display:inline-block">🛡️ {{ personagem.guilda }}</router-link>
          <div v-else class="pill" style="margin-top:6px">Independente</div>
        </div>
        <div class="card" style="padding:16px">
          <div style="display:flex;gap:8px;flex-wrap:wrap;margin-bottom:10px">
            <span v-if="personagem.profissao" class="pill">🧑‍🏭 {{ personagem.profissao }}</span>
            <span v-if="armaNome" class="pill">🗡️ {{ armaNome }}</span>
          </div>
          <p v-if="personagem.conceito"><b>Conceito:</b> {{ personagem.conceito }}</p>
          <p v-if="personagem.aparencia"><b>Aparência:</b> {{ personagem.aparencia }}</p>

          <div v-if="atributosLista.length" style="margin-top:14px">
            <h4 style="margin:0 0 8px;color:var(--azul-bright)">Atributos</h4>
            <div class="atributos">
              <div v-for="a in atributosLista" :key="a.k" class="atrib" :class="{ pos: a.v > 0, neg: a.v < 0 }">
                <label>{{ a.nome }}</label>
                <div class="v">{{ a.v > 0 ? '+' : '' }}{{ a.v }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>
<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useSupa } from '../lib/supabase.js'
import { urlImagem } from '../lib/imagens.js'
import TituloHUD from '../components/TituloHUD.vue'

const route = useRoute()
const supa = useSupa()
const carregando = ref(true)
const personagem = ref(null)
const armaNome = ref('')

const NOMES_ATRIBUTOS = { tecnica: 'Técnica', espirito: 'Espírito', conhecimento: 'Conhecimento', reflexo: 'Reflexo', corpo: 'Corpo' }
const atributosLista = computed(() => {
  const at = personagem.value?.atributos || {}
  return Object.keys(NOMES_ATRIBUTOS).filter(k => at[k] !== undefined).map(k => ({ k, nome: NOMES_ATRIBUTOS[k], v: at[k] }))
})
const foto = computed(() => personagem.value?.foto_url ? urlImagem(personagem.value.foto_url) : '')

async function carregar() {
  carregando.value = true
  personagem.value = null
  armaNome.value = ''
  try {
    const r = await supa.from('personagens')
      .select('nome, guilda, profissao, arma, atributos, conceito, aparencia, foto_url')
      .eq('nome', route.params.nome).eq('visivel', true).eq('excluido', false).maybeSingle()
    if (r.error) throw r.error
    personagem.value = r.data
    if (personagem.value?.arma) {
      const ra = await supa.from('armas').select('nome').eq('id', personagem.value.arma).maybeSingle()
      armaNome.value = ra.data?.nome || ''
    }
  } catch (e) { console.warn(e); personagem.value = null } finally { carregando.value = false }
}
watch(() => route.params.nome, carregar)
onMounted(carregar)
</script>
