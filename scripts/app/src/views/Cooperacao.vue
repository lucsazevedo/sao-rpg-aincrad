<template>
  <div>
    <StatusBar @pedir-login="$emit('pedir-login')" />
    <TituloHUD icone="🤝" titulo="Cooperação" trilha="Sistema · Clã" />
    <p style="margin:0 0 12px;color:var(--ink-dim);font-size:13px">
      Correio entre jogadores, baú do clã e metas globais do mestre — sem taxa em nenhum envio (mesmo padrão do mercado).
    </p>
    <div v-if="!auth.logado" class="msg info">
      <button class="btn primario" @click="$emit('pedir-login')" style="margin-right:8px">🔑 Entrar</button>
      Faça login para usar.
    </div>
    <div v-else-if="!auth.temPersonagem" class="msg warn">Sem ficha vinculada — fale com o mestre.</div>
    <div v-else>
      <div class="tabs" style="margin:8px 0">
        <button type="button" v-for="t in abas" :key="t.k" class="tab" :class="{on: aba===t.k}" @click="aba=t.k">{{ t.label }}</button>
      </div>

      <!-- ===== Correio (18A) ===== -->
      <div v-if="aba==='correio'">
        <div class="card">
          <h4 style="margin:0 0 10px;color:var(--gold-bright)">💸 Enviar Col</h4>
          <div class="admin-toolbar" style="display:flex;gap:8px;flex-wrap:wrap">
            <input v-model="destCol" placeholder="Nome do personagem destinatário"
              style="flex:1;background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:9px 12px;border-radius:6px;font:inherit">
            <input type="number" min="1" v-model.number="valorCol" style="width:120px;background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:9px 12px;border-radius:6px;font:inherit">
            <button class="btn primario" :disabled="!destCol.trim()||!valorCol" @click="enviarCol()">Enviar</button>
          </div>
        </div>
        <div class="card" style="margin-top:12px">
          <h4 style="margin:0 0 10px;color:var(--gold-bright)">📦 Enviar Item</h4>
          <div class="admin-toolbar" style="display:flex;gap:8px;flex-wrap:wrap">
            <input v-model="destItem" placeholder="Nome do personagem destinatário"
              style="flex:1 1 160px;background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:9px 12px;border-radius:6px;font:inherit">
            <select v-model="itemEscolhido" style="flex:1 1 200px;background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:9px 12px;border-radius:6px;font:inherit">
              <option value="">-- Escolher item da mochila --</option>
              <option v-for="it in meuInventario" :key="it.id" :value="it.id">{{ it.nome }} (x{{ it.quantidade }})</option>
            </select>
            <input type="number" min="1" v-model.number="qtdItem" style="width:90px;background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:9px 12px;border-radius:6px;font:inherit">
            <button class="btn primario" :disabled="!destItem.trim()||!itemEscolhido" @click="enviarItemFn()">Enviar</button>
          </div>
        </div>
      </div>

      <!-- ===== Baú do clã (18B) ===== -->
      <div v-if="aba==='bau'">
        <div v-if="!meuCla" class="msg warn">Você não tem clã — não há baú pra mostrar.</div>
        <div v-else>
          <div class="card">
            <h4 style="margin:0 0 10px;color:var(--gold-bright)">🧰 Baú de {{ meuCla }}</h4>
            <div class="admin-toolbar">
              <select v-model="itemDepositar" style="flex:1;background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:9px 12px;border-radius:6px;font:inherit">
                <option value="">-- Depositar item da mochila --</option>
                <option v-for="it in meuInventario" :key="it.id" :value="it.id">{{ it.nome }} (x{{ it.quantidade }})</option>
              </select>
              <button class="btn primario" :disabled="!itemDepositar" @click="depositar()">Depositar 1</button>
            </div>
            <div v-if="!bauItens.length" class="msg warn" style="margin-top:10px">Baú vazio.</div>
            <div v-else class="admin-list" style="margin-top:10px">
              <div v-for="it in bauItens" :key="it.id" class="admin-row">
                <div style="flex:1">
                  <div class="row-nome">{{ it.nome }} <span v-if="!it.liberado_para_membros" class="pill bad">travado</span></div>
                  <div class="row-sub">x{{ it.qtd }} · depositado por {{ it.depositado_por }}</div>
                </div>
                <button class="btn tiny" @click="retirar(it)">⬅️ Retirar</button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- ===== Metas globais (18C) ===== -->
      <div v-if="aba==='metas'">
        <div v-if="!metas.length" class="msg warn">Nenhuma meta ativa no momento.</div>
        <div v-else class="grid">
          <div v-for="m in metas" :key="m.id" class="card">
            <div class="ct">{{ m.titulo }}</div>
            <p>{{ m.descricao }}</p>
            <div style="height:12px;background:var(--panel-3);border-radius:6px;overflow:hidden;margin:8px 0">
              <div :style="{width: Math.min(100,(m.progresso/m.meta_qtd)*100)+'%', height:'100%', background:'linear-gradient(90deg,#d9ad5e,#f2d18a)'}"></div>
            </div>
            <div class="cs">{{ m.progresso }}/{{ m.meta_qtd }} × {{ m.meta_item }}</div>
            <div class="admin-toolbar" style="margin-top:8px">
              <select v-model="doacaoItem[m.id]" style="flex:1;background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:8px 10px;border-radius:6px;font:inherit">
                <option value="">-- Item da mochila --</option>
                <option v-for="it in meuInventario.filter(i=>i.nome===m.meta_item)" :key="it.id" :value="it.id">{{ it.nome }} (x{{ it.quantidade }})</option>
              </select>
              <input type="number" min="1" v-model.number="doacaoQtd[m.id]" style="width:70px;background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:8px 10px;border-radius:6px;font:inherit">
              <button class="btn primario" :disabled="!doacaoItem[m.id]" @click="doar(m)">Doar</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth.js'
import { useSupa } from '../lib/supabase.js'
import StatusBar from '../components/StatusBar.vue'
import TituloHUD from '../components/TituloHUD.vue'

const auth = useAuthStore()
defineEmits(['pedir-login'])
const supa = useSupa()

const aba = ref('correio')
const abas = [
  { k: 'correio', label: '✉️ Correio' },
  { k: 'bau', label: '🧰 Baú do Clã' },
  { k: 'metas', label: '🎯 Metas Globais' },
]

const destCol = ref(''), valorCol = ref(50)
const destItem = ref(''), itemEscolhido = ref(''), qtdItem = ref(1)
const meuInventario = ref([])
const meuCla = ref('')
const bauItens = ref([])
const itemDepositar = ref('')
const metas = ref([])
const doacaoItem = ref({}), doacaoQtd = ref({})

async function carregarInventario() {
  if (!auth.temPersonagem) return
  const r = await supa.from('inventario').select('*').eq('personagem_nome', auth.personagem.nome).eq('excluido', false).eq('equipado', false)
  meuInventario.value = r.data || []
}
async function carregarBau() {
  meuCla.value = auth.personagem?.guilda || ''
  if (!meuCla.value) return
  const r = await supa.from('cla_inventario').select('*').eq('cla_nome', meuCla.value).eq('excluido', false).order('depositado_em', { ascending: false })
  bauItens.value = r.data || []
}
async function carregarMetas() {
  const r = await supa.from('metas_globais').select('*').eq('finalizada', false).eq('visivel', true).order('criado_em', { ascending: false })
  metas.value = r.data || []
}

async function enviarCol() {
  try {
    const r = await supa.rpc('enviar_col', { p_destinatario: destCol.value.trim(), p_valor: valorCol.value })
    if (r.error) throw r.error
    const d = JSON.parse(r.data)
    if (d.erro) { alert(d.erro); return }
    alert(d.mensagem)
    destCol.value = ''
    await auth.carregarPerfilEPersonagem()
  } catch (e) { alert('Erro: ' + e.message) }
}
async function enviarItemFn() {
  try {
    const r = await supa.rpc('enviar_item', { p_destinatario: destItem.value.trim(), p_inventario_id: itemEscolhido.value, p_qtd: qtdItem.value })
    if (r.error) throw r.error
    const d = JSON.parse(r.data)
    if (d.erro) { alert(d.erro); return }
    alert(d.mensagem)
    destItem.value = ''; itemEscolhido.value = ''
    await carregarInventario()
  } catch (e) { alert('Erro: ' + e.message) }
}
async function depositar() {
  try {
    const r = await supa.rpc('depositar_no_cla', { p_inventario_id: itemDepositar.value })
    if (r.error) throw r.error
    const d = JSON.parse(r.data)
    if (d.erro) { alert(d.erro); return }
    itemDepositar.value = ''
    await Promise.all([carregarInventario(), carregarBau()])
  } catch (e) { alert('Erro: ' + e.message) }
}
async function retirar(it) {
  try {
    const r = await supa.rpc('retirar_do_cla', { p_cla_inventario_id: it.id })
    if (r.error) throw r.error
    const d = JSON.parse(r.data)
    if (d.erro) { alert(d.erro); return }
    await Promise.all([carregarInventario(), carregarBau()])
  } catch (e) { alert('Erro: ' + e.message) }
}
async function doar(m) {
  try {
    const r = await supa.rpc('doar_para_meta', { p_meta_id: m.id, p_inventario_id: doacaoItem.value[m.id], p_qtd: doacaoQtd.value[m.id] || 1 })
    if (r.error) throw r.error
    const d = JSON.parse(r.data)
    if (d.erro) { alert(d.erro); return }
    alert(`Progresso: ${d.progresso}/${d.meta_qtd}`)
    await Promise.all([carregarInventario(), carregarMetas()])
  } catch (e) { alert('Erro: ' + e.message) }
}

onMounted(async () => {
  if (!auth.ready) await auth.init()
  await Promise.all([carregarInventario(), carregarBau(), carregarMetas()])
})
</script>
