<!-- Bug report + sugestão de melhoria — botão flutuante, só aparece
     logado com personagem (pedido do usuário: "após o usuário estar
     logado"). Um formulário só com um seletor de tipo, mais o histórico
     dos próprios envios (com a resposta do mestre, se já respondeu). -->
<template>
  <button v-if="auth.logado && auth.temPersonagem" class="fb-flutuante" @click="abrir()" title="Reportar bug ou sugerir melhoria">
    🐛
  </button>

  <div v-if="aberto" class="modal-bg on" @click.self="fechar()">
    <div class="modal" style="max-width:560px">
      <div class="top">
        <h2>🐛 Feedback</h2>
        <button class="btn ghost" @click="fechar()">✕</button>
      </div>
      <div class="body">
        <div class="tabs" style="margin-bottom:14px">
          <button type="button" class="tab" :class="{ on: tipo === 'bug' }" @click="tipo = 'bug'">🐛 Reportar bug</button>
          <button type="button" class="tab" :class="{ on: tipo === 'sugestao' }" @click="tipo = 'sugestao'">💡 Sugerir melhoria</button>
        </div>

        <div class="form">
          <div class="campo">
            <label>{{ tipo === 'bug' ? 'O que deu errado?' : 'Título da sugestão' }}</label>
            <input v-model.trim="titulo" :placeholder="tipo === 'bug' ? 'Ex: botão de X não funciona' : 'Ex: adicionar filtro na tela Y'">
          </div>
          <div class="campo">
            <label>Descrição</label>
            <textarea v-model.trim="descricao" rows="4" :placeholder="tipo === 'bug' ? 'O que você fez, o que esperava acontecer, o que aconteceu de fato…' : 'Descreva sua ideia com o máximo de detalhe que puder.'"></textarea>
          </div>
          <div v-if="erro" class="msg erro">{{ erro }}</div>
          <div v-if="enviado" class="msg ok">✅ Enviado! Obrigado — o mestre vai ver por aqui.</div>
          <div style="display:flex;justify-content:flex-end">
            <button class="btn primario" :disabled="enviando || !titulo || !descricao" @click="enviar()">
              {{ enviando ? 'Enviando…' : '📨 Enviar' }}
            </button>
          </div>
        </div>

        <div v-if="meusEnvios.length" style="margin-top:20px">
          <h4 style="margin:0 0 10px;color:var(--gold-bright)">Meus envios</h4>
          <div style="display:flex;flex-direction:column;gap:8px">
            <div v-for="f in meusEnvios" :key="f.id" class="card" style="background:var(--panel-3);padding:12px">
              <div style="display:flex;justify-content:space-between;gap:8px;align-items:start">
                <div class="ct" style="font-size:13.5px">{{ f.tipo === 'bug' ? '🐛' : '💡' }} {{ f.titulo }}</div>
                <span class="pill" :class="statusInfo(f.status).classe">{{ statusInfo(f.status).lbl }}</span>
              </div>
              <p style="margin:6px 0 0;font-size:13px;color:var(--ink-dim)">{{ f.descricao }}</p>
              <div v-if="f.resposta_mestre" class="msg info" style="margin-top:8px;font-size:12.5px">
                <b>🧙 Mestre:</b> {{ f.resposta_mestre }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref } from 'vue'
import { useRoute } from 'vue-router'
import { useAuthStore } from '../stores/auth.js'
import { useSupa } from '../lib/supabase.js'

const auth = useAuthStore()
const supa = useSupa()
const route = useRoute()

const aberto = ref(false)
const tipo = ref('bug')
const titulo = ref('')
const descricao = ref('')
const erro = ref('')
const enviando = ref(false)
const enviado = ref(false)
const meusEnvios = ref([])

const STATUS = {
  aberto: { lbl: 'Aberto', classe: '' },
  em_analise: { lbl: 'Em análise', classe: 'on' },
  resolvido: { lbl: 'Resolvido', classe: 'on' },
  recusado: { lbl: 'Recusado', classe: 'bad' },
}
function statusInfo(s) { return STATUS[s] || { lbl: s, classe: '' } }

async function carregarMeusEnvios() {
  if (!auth.temPersonagem) return
  try {
    const r = await supa.from('feedback').select('*').eq('personagem_nome', auth.personagem.nome).order('criado_em', { ascending: false }).limit(30)
    meusEnvios.value = r.data || []
  } catch (e) { console.warn(e) }
}
function abrir() {
  aberto.value = true
  erro.value = ''; enviado.value = false
  carregarMeusEnvios()
}
function fechar() { aberto.value = false }

async function enviar() {
  erro.value = ''; enviado.value = false
  if (!titulo.value || !descricao.value) return
  enviando.value = true
  try {
    const r = await supa.rpc('enviar_feedback', {
      p_tipo: tipo.value, p_titulo: titulo.value, p_descricao: descricao.value, p_pagina: route.fullPath,
    })
    if (r.error) throw r.error
    const d = JSON.parse(r.data)
    if (d.erro) { erro.value = d.erro; return }
    titulo.value = ''; descricao.value = ''
    enviado.value = true
    await carregarMeusEnvios()
  } catch (e) { erro.value = 'Erro: ' + e.message } finally { enviando.value = false }
}
</script>
<style scoped>
.fb-flutuante {
  position: fixed; right: 20px; bottom: 20px; z-index: 40;
  width: 52px; height: 52px; border-radius: 50%;
  background: linear-gradient(180deg, #b06600, #7a4600);
  border: 1px solid var(--laranja);
  color: #fff; font-size: 22px; cursor: pointer;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.5), 0 0 18px rgba(255, 153, 0, 0.18);
  display: grid; place-items: center;
  transition: transform 0.15s ease, box-shadow 0.15s ease;
}
.fb-flutuante:hover { transform: translateY(-2px); box-shadow: 0 10px 28px rgba(0, 0, 0, 0.55), 0 0 26px rgba(255, 153, 0, 0.32); }
@media (max-width: 680px) { .fb-flutuante { right: 14px; bottom: 14px; width: 46px; height: 46px; font-size: 19px; } }
</style>
