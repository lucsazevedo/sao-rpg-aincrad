<template>
  <div>
    <StatusBar v-if="auth.temPersonagem"/>
    <TituloHUD icone="🏪" titulo="Mercado" trilha="Sistema · Comércio entre Jogadores e NPCs" />
    <div class="tabs" style="margin:12px 0">
      <button type="button" class="tab" :class="{on:tab=='npcs'}" @click="tab='npcs'">🏛️ Lojas NPC</button>
      <button type="button" class="tab" :class="{on:tab=='vitrine'}" @click="tab='vitrine'">📦 Vitrine</button>
      <button type="button" class="tab" :class="{on:tab=='meus'}" @click="tab='meus'">📢 Meus Anúncios</button>
      <button type="button" v-if="auth.temPersonagem" class="tab" :class="{on:tab=='meuinv'}" @click="tab='meuinv'">🎒 Meu inventário</button>
    </div>

    <!-- Lojas NPC (preço fixo de catálogo, estoque infinito) -->
    <div v-if="tab==='npcs'">
      <p style="margin:0 0 12px;color:var(--ink-dim);font-size:13px">
        Preço de catálogo, sem regatear — os NPCs de mesa (descontos por reputação, encomenda,
        mercado negro) só existem na sessão presencial com o mestre. Aqui é o preço fixo, sempre disponível.
      </p>
      <div v-if="carregandoNpc" class="msg info carregando">Carregando lojas…</div>
      <div v-else v-for="loja in lojasNpc" :key="loja.chave" class="card" style="margin-bottom:14px">
        <h4 style="margin:0 0 4px;color:var(--gold-bright)">{{ loja.icone }} {{ loja.nome }}</h4>
        <p style="margin:0 0 10px;color:var(--ink-dim);font-size:12.5px">{{ loja.descricao }} · {{ loja.regiao }}</p>
        <div v-if="!loja.itens.length" class="msg warn">Nada à venda aqui pro seu nível ainda.</div>
        <div v-else class="grid">
          <div v-for="it in loja.itens" :key="it.id" class="card">
            <IconeArma v-if="loja.tabela==='armas'" :tipo="it.tipo" :raridade="it.raridade" :tamanho="48" style="margin-bottom:4px" />
            <div class="ct">{{ it.nome }}</div>
            <div class="cs">{{ it.raridade || 'comum' }}{{ it.slot ? ' · '+it.slot : '' }}</div>
            <div class="faixa">
              <span class="pill on">💰 {{ it.preco }} Col</span>
            </div>
            <button v-if="auth.temPersonagem" class="btn primario" style="margin-top:auto"
              :disabled="comprandoNpc===it.id" @click="comprarDeNpc(loja.tabela, it)">
              🛒 {{ comprandoNpc===it.id ? 'Comprando…' : 'Comprar' }}
            </button>
            <div v-else class="msg info" style="margin:6px 0 0">🔒 Entrar para comprar.</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Vitrine -->
    <div v-if="tab==='vitrine'">
      <div v-if="carregandoV" class="msg info carregando">Carregando vitrine…</div>
      <div v-else-if="!vitrine.length" class="msg warn">Nenhum anúncio publicado no momento.</div>
      <div v-else class="grid">
        <div v-for="a in vitrine" :key="a.id" class="card">
          <IconeArma v-if="a.inventario?.tipo==='arma'" :tipo="armaTipoDe(a.inventario.item_id)" :raridade="a.raridade" :tamanho="48" style="margin-bottom:4px" />
          <div class="ct">{{ a.inventario && a.inventario.item_id ? a.inventario.item_id : ('Item #' + a.inventario_id) }}</div>
          <div class="cs">{{ a.inventario && a.inventario.tipo ? a.inventario.tipo : 'item' }} · {{ a.raridade || 'comum' }}</div>
          <p>{{ a.descricao || 'Clique para comprar.' }}</p>
          <div class="faixa">
            <span class="pill on">💰 {{ a.preco_col }} Col</span>
            <span class="pill">Qtd. {{ a.inventario && a.inventario.qtd ? a.inventario.qtd : 1 }}</span>
            <span class="pill">⏳ Expira em {{ diasFaltam(a.expira_em) }}d</span>
          </div>
          <button v-if="auth.temPersonagem" class="btn primario" style="margin-top:auto" :disabled="comprando===a.id" @click="comprar(a)">🛒 Comprar ({{ a.preco_col }} Col)</button>
          <div v-else class="msg info" style="margin:6px 0 0">🔒 Entrar para comprar.</div>
        </div>
      </div>
    </div>

    <!-- Meus anuncios -->
    <div v-if="tab==='meus'">
      <div v-if="!auth.temPersonagem" class="msg info">🔒 <a href="#" @click.prevent="$emit('pedir-login')">Entra</a> pra ver seus anúncios.</div>
      <div v-else-if="carregandoM" class="msg info carregando">Carregando…</div>
      <div v-else-if="!meus.length" class="msg warn">Você não publicou nenhum anúncio ainda. Vá em "Meu inventário" → "Publicar".</div>
      <div v-else class="grid">
        <div v-for="a in meus" :key="a.id" class="card">
          <IconeArma v-if="a.inventario?.tipo==='arma'" :tipo="armaTipoDe(a.inventario.item_id)" :raridade="a.raridade" :tamanho="48" style="margin-bottom:4px" />
          <div class="ct">{{ a.inventario && a.inventario.item_id ? a.inventario.item_id : 'Item' }}</div>
          <div class="cs">Preço: {{ a.preco_col }} Col · Status {{ a.status || 'ativo' }}</div>
          <p>{{ a.descricao || '—' }}</p>
          <button class="btn" @click="remover(a)">❌ Cancelar anúncio</button>
        </div>
      </div>
    </div>

    <!-- Meu inventário (publicação) -->
    <div v-if="tab==='meuinv'">
      <div v-if="carregandoI" class="msg info carregando">Carregando inventário…</div>
      <div v-else-if="!meuInv.length" class="msg warn">Inventário vazio. Faça missões para obter itens e materiais.</div>
      <div v-else class="grid">
        <div v-for="it in meuInv" :key="it.id" class="card">
          <IconeArma v-if="it.tipo==='arma'" :tipo="armaTipoDe(it.item_id)" :raridade="it.raridade" :tamanho="48" style="margin-bottom:4px" />
          <div class="ct">{{ it.item_id }} · x{{ it.qtd||1 }}</div>
          <div class="cs">{{ it.tipo }} · {{ it.raridade || 'comum' }}</div>
          <div style="display:grid;gap:6px;margin-top:6px">
            <label style="font-family:var(--f-mono);font-size:11px;text-transform:uppercase;color:var(--gold-dim);letter-spacing:.1em">Preço Col</label>
            <input type="number" v-model.number="precos[it.id]" style="background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:7px 10px;border-radius:6px;font:inherit" min="1"/>
            <textarea v-model="descricoes[it.id]" placeholder="Breve descrição (opcional)" rows="2" style="background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:7px 10px;border-radius:6px;font:inherit;font-size:13px"></textarea>
            <button class="btn primario" :disabled="publicando===it.id" @click="publicar(it)">📢 Publicar na Vitrine</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, reactive, computed } from 'vue'
import { useAuthStore } from '../stores/auth.js'
import { useSupa } from '../lib/supabase.js'
import StatusBar from '../components/StatusBar.vue'
import TituloHUD from '../components/TituloHUD.vue'
import IconeArma from '../components/IconeArma.vue'
const auth = useAuthStore()
defineEmits(['pedir-login'])
const supa = useSupa()

const tab = ref('npcs')
const vitrine = ref([]), meus = ref([]), meuInv = ref([])
const carregandoV = ref(false), carregandoM = ref(false), carregandoI = ref(false)
const lojasNpc = ref([]), carregandoNpc = ref(false), comprandoNpc = ref(null)
const armasTipoPorId = ref({}) // item_id -> tipo (ARMAS_TIPOS), pro ícone colorido por raridade em vitrine/meus/meuinv
function armaTipoDe(itemId){ return armasTipoPorId.value[itemId] }
const comprando = ref(null), publicando = ref(null)
const precos = reactive({}), descricoes = reactive({})

async function carregarVitrine(){
  carregandoV.value = true
  try{
    const r = await supa.from('vitrine').select(`*, inventario: inventario_id (*)`).eq('status','ativo').lt('expira_em','9999-12-31').order('criado_em',{ascending:false})
    if (r.error) throw r.error
    vitrine.value = r.data || []
  }finally{ carregandoV.value = false }
}
async function carregarMeus(){
  if (!auth.temPersonagem) return
  carregandoM.value = true
  try{
    const r = await supa.from('vitrine').select(`*, inventario: inventario_id (*)`).eq('personagem_nome', auth.personagem.nome).order('criado_em',{ascending:false})
    if (r.error) throw r.error
    meus.value = r.data || []
  }finally{ carregandoM.value = false }
}
async function carregarMeuInv(){
  if (!auth.temPersonagem) return
  carregandoI.value = true
  try{
    const r = await supa.from('inventario').select('*').eq('personagem_nome', auth.personagem.nome).eq('excluido',false).order('obtido_em',{ascending:false})
    if (r.error) throw r.error
    meuInv.value = (r.data||[]).filter(i => !i.vitrine_id || i.na_vitrine===false)
    meuInv.value.forEach(i => { if (!precos[i.id]) precos[i.id] = 50; if (!descricoes[i.id]) descricoes[i.id]='' })
  }finally{ carregandoI.value = false }
}
function diasFaltam(d){
  if (!d) return 0
  return Math.max(0, Math.ceil((new Date(d).getTime() - Date.now()) / 86400000))
}
async function comprar(a){
  if (!auth.temPersonagem) { $emit('pedir-login'); return }
  comprando.value = a.id
  try{
    const r = await supa.rpc('comprar_da_vitrine', { p_vitrine_id: a.id })
    if (r.error) throw r.error
    alert('✅ Compra concluída!\n\n' + (typeof r.data==='string'?r.data:JSON.stringify(r.data,null,2)).slice(0,800))
    await auth.carregarPerfilEPersonagem()
    await carregarVitrine(); await carregarMeus(); await carregarMeuInv()
  }catch(e){ alert('Erro na compra: ' + e.message) }
  finally { comprando.value = null }
}
async function publicar(it){
  const preco = Number(precos[it.id]||0)
  if (!preco || preco<=0){ alert('Informe um preço válido em Col.'); return }
  publicando.value = it.id
  try{
    const r = await supa.rpc('publicar_anuncio', { p_inventario_id: it.id, p_preco: preco })
    if (r.error) throw r.error
    alert('✅ Anúncio publicado! Expira em 7 dias.\n\n' + (typeof r.data==='string'?r.data:JSON.stringify(r.data,null,2)).slice(0,600))
    await carregarVitrine(); await carregarMeus(); await carregarMeuInv()
  }catch(e){ alert('Erro ao publicar: ' + e.message) }
  finally { publicando.value = null }
}
async function remover(a){
  try{
    const r = await supa.rpc('remover_anuncio', { p_vitrine_id: a.id })
    if (r.error) throw r.error
    alert('Anúncio removido.')
    await carregarVitrine(); await carregarMeus(); await carregarMeuInv()
  }catch(e){ alert('Erro: ' + e.message) }
}

// Lojas NPC: preço/estoque de armas+equipamentos vêm do catálogo real
// (100%/74% das linhas já têm preço, nunca inventado). Os NPCs em si (nome,
// bairro, flavor) são os de mesa de verdade (tabela mercado) — só o
// desconto/condição narrativa deles (que é texto solto pro mestre
// interpretar, não dado limpo) fica de fora daqui.
const GRUPOS_NPC = [
  { chave: 'armas', nomeNpc: 'Loja de Armas', icone: '⚔️', tabela: 'armas', filtro: () => true },
  { chave: 'armadura_leve', nomeNpc: 'Forja do Ferreiro', icone: '🔨', tabela: 'equipamentos',
    filtro: it => ['Armaduras','Elmos','Botas','Luvas','Escudos'].includes(it.slot) && ['Comum','Incomum'].includes(it.raridade) },
  { chave: 'armadura_pesada', nomeNpc: 'Loja de Armaduras — Lynx', icone: '🛡️', tabela: 'equipamentos',
    filtro: it => ['Armaduras','Elmos','Botas','Luvas','Escudos'].includes(it.slot) && !['Comum','Incomum'].includes(it.raridade) },
  { chave: 'consumiveis', nomeNpc: 'Comerciante da Praça (importados)', icone: '🧪', tabela: 'equipamentos',
    filtro: it => ['Cristais de Uso','Poções','Munições','Comidas'].includes(it.slot) },
  { chave: 'roupas', nomeNpc: 'Ateliê do Costureiro', icone: '🧵', tabela: 'equipamentos',
    filtro: it => ['Parte de Cima','Parte de Baixo','Capuz','Acessórios'].includes(it.slot) },
]
async function carregarLojasNpc(){
  carregandoNpc.value = true
  try{
    const [rArmas, rEquip, rMercado] = await Promise.all([
      supa.from('armas').select('id,nome,preco,raridade,tipo').not('preco','is',null),
      supa.from('equipamentos').select('id,nome,preco,raridade,slot').not('preco','is',null),
      supa.from('mercado').select('nome,regiao,descricao').in('nome', GRUPOS_NPC.map(g=>g.nomeNpc)),
    ])
    const armas = rArmas.data || [], equip = rEquip.data || []
    armasTipoPorId.value = Object.fromEntries(armas.map(a => [a.id, a.tipo]))
    lojasNpc.value = GRUPOS_NPC.map(g => {
      const catalogo = g.tabela === 'armas' ? armas : equip
      const m = (rMercado.data||[]).find(x => x.nome === g.nomeNpc)
      return {
        chave: g.chave, tabela: g.tabela, icone: g.icone,
        nome: g.nomeNpc,
        descricao: m?.descricao || 'Vendedor de Aincrad.',
        regiao: m?.regiao || '—',
        itens: catalogo.filter(g.filtro).sort((a,b)=>(a.preco||0)-(b.preco||0)),
      }
    })
  } catch(e){ console.warn(e) }
  finally { carregandoNpc.value = false }
}
async function comprarDeNpc(tabela, it){
  if (!auth.temPersonagem) { return }
  comprandoNpc.value = it.id
  try{
    const r = await supa.rpc('comprar_de_npc', { p_tabela: tabela, p_item_id: it.id })
    if (r.error) throw r.error
    const d = typeof r.data === 'string' ? JSON.parse(r.data) : r.data
    if (d.erro) { alert(d.erro); return }
    alert(`✅ Comprou ${d.item_nome} por ${d.preco_pago} Col. Col restante: ${d.col_restante}`)
    await auth.carregarPerfilEPersonagem()
  }catch(e){ alert('Erro na compra: ' + e.message) }
  finally { comprandoNpc.value = null }
}

onMounted(async () => {
  if (!auth.ready) await auth.init()
  await carregarLojasNpc()
  await carregarVitrine()
  if (auth.temPersonagem) { await carregarMeus(); await carregarMeuInv() }
})
</script>
