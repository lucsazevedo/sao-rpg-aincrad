<template>
  <div>
    <StatusBar @pedir-login="$emit('pedir-login')" />
    <TituloHUD icone="⚔️" titulo="Combate Livre" trilha="Sistema · Encontro" />
    <p style="margin:0 0 12px;color:var(--ink-dim);font-size:13px">
      Ataque um monstro direto do quadro — sem missão no meio, XP/Col/drop na hora. Gasta Fôlego sempre;
      Vida só cai em sucesso parcial ou falha. Equipar arma/carta aqui não muda a chance — é a Mesa de
      verdade que usa a mecânica de equipamento.
    </p>
    <div v-if="!auth.logado" class="msg info">
      <button class="btn primario" @click="$emit('pedir-login')" style="margin-right:8px">🔑 Entrar</button>
      Faça login para combater.
    </div>
    <div v-else-if="!auth.temPersonagem" class="msg warn">Sem ficha vinculada — fale com o mestre.</div>
    <div v-else>
      <div class="card" style="margin-bottom:14px;display:flex;gap:18px;flex-wrap:wrap;align-items:center">
        <div style="flex:1;min-width:160px">
          <div class="cs">❤️ Vida</div>
          <div style="height:12px;background:var(--panel-3);border-radius:6px;overflow:hidden;margin-top:4px">
            <div :style="{width: pctVida+'%', height:'100%', background: pctVida>40?'linear-gradient(90deg,#2c6f92,#4ea5d9)':'linear-gradient(90deg,#b03d00,#ff5b3d)'}"></div>
          </div>
          <div style="font-size:12px;color:var(--ink-dim);margin-top:2px">{{ vidaAtual }} / {{ vidaMax }}</div>
        </div>
        <div style="flex:1;min-width:160px">
          <div class="cs">💨 Fôlego</div>
          <div style="height:12px;background:var(--panel-3);border-radius:6px;overflow:hidden;margin-top:4px">
            <div :style="{width: pctFolego+'%', height:'100%', background:'linear-gradient(90deg,#2c6f92,#4ea5d9)'}"></div>
          </div>
          <div style="font-size:12px;color:var(--ink-dim);margin-top:2px">{{ auth.personagem.folego ?? 0 }} / 20</div>
        </div>
        <div style="display:flex;gap:6px;flex-wrap:wrap">
          <button class="btn" :disabled="comprando||(auth.personagem.folego??0)>=20" @click="comprarFolego(1)">⚡ +1 Fôlego (5 Col)</button>
          <button class="btn" :disabled="comprando||(auth.personagem.folego??0)>=20" @click="comprarFolego(5)">⚡⚡ +5 Fôlego (~30 Col)</button>
          <button class="btn" :disabled="comprando||(auth.personagem.folego??0)>=20" @click="comprarFolego(20)">🔥 Encher Fôlego</button>
          <button class="btn primario" :disabled="curando || (vidaAtual>=vidaMax && (auth.personagem.folego??0)>=20)" @click="curar()">
            🛏️ Curar tudo (10 Col)
          </button>
        </div>
      </div>
      <p style="color:var(--ink-dim);font-size:11.5px;margin:-10px 0 14px">
        ⏱️ Fôlego regenera sozinho +1 a cada 30 min. Os botões são o atalho pago pra não esperar
        (mesmo preço de sempre: 5 Col a unidade avulsa, ~6 Col/un no pacote de 5, ~7 Col/un pra encher —
        "Curar tudo" também restaura a Vida, o resto só mexe no Fôlego).
      </p>

      <div v-if="ultimoResultado" class="msg" :class="corResultado(ultimoResultado.resultado)" style="margin-bottom:14px">
        <b>{{ tituloResultado(ultimoResultado.resultado) }}</b> contra {{ ultimoResultado.monstro_nome }} —
        dados {{ ultimoResultado.dados?.join('+') }} (mod incluso, soma {{ ultimoResultado.soma_com_mod }}).
        <template v-if="ultimoResultado.chefe_vida_max !== undefined">
          <span v-if="ultimoResultado.dano_causado">· {{ ultimoResultado.dano_causado }} de dano no chefe</span>
          <span> · {{ ultimoResultado.contribuintes_distintos }}/{{ ultimoResultado.min_contribuintes }} contribuintes</span>
          <span v-if="ultimoResultado.vida_perdida_jogador"> · −{{ ultimoResultado.vida_perdida_jogador }} sua Vida</span>
          <span v-if="ultimoResultado.chefe_derrotado"> · 🏆 CHEFE DERROTADO! +{{ ultimoResultado.xp_ganho }} XP · +{{ ultimoResultado.col_ganho }} Col pra todo mundo que contribuiu</span>
        </template>
        <template v-else>
          <span v-if="ultimoResultado.xp_ganho">+{{ ultimoResultado.xp_ganho }} XP</span>
          <span v-if="ultimoResultado.col_ganho"> · +{{ ultimoResultado.col_ganho }} Col</span>
          <span v-if="ultimoResultado.vida_perdida"> · −{{ ultimoResultado.vida_perdida }} Vida</span>
          <span v-if="ultimoResultado.derrotado"> · ⚠️ Vida chegou a 0 — cure na Estalagem antes de lutar de novo.</span>
          <div v-if="ultimoResultado.drops_todos?.length" style="margin-top:6px">
            📦 dropou:
            <span v-for="(d,i) in ultimoResultado.drops_todos" :key="i" class="pill on" style="margin:2px 4px 0 0;display:inline-block">
              {{ d.tipo==='ovo' ? '🥚' : '🌿' }} {{ d.item }}{{ d.qtd>1 ? ' x'+d.qtd : '' }}
            </span>
          </div>
          <div v-else-if="ultimoResultado.resultado !== 'falha'" style="margin-top:4px;color:var(--ink-dim);font-size:12.5px">
            📦 nenhum drop desta vez
          </div>
        </template>
      </div>

      <div style="display:flex;gap:10px;flex-wrap:wrap;margin:6px 0 14px">
        <input v-model="busca" placeholder="🔎 Buscar monstro…"
          style="flex:1 1 200px;background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:9px 12px;border-radius:6px;font:inherit">
        <select v-model="filtroAmeaca" style="background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:9px 12px;border-radius:6px;font:inherit">
          <option value="">Todas as ameaças</option>
          <option v-for="a in ameacasPresentes" :key="a" :value="a">{{ a }}</option>
        </select>
      </div>

      <div v-if="carregando" class="msg info carregando">Carregando bestiário…</div>
      <div v-else class="grid">
        <div v-for="m in monstrosFiltrados" :key="m.id" class="card" :class="{'rar-borda-lendario': ehChefe(m)}">
          <img v-if="m.img" :src="urlImagem(m.img)" :alt="m.nome" style="width:100%;aspect-ratio:4/3;object-fit:cover;border-radius:6px;margin-bottom:8px">
          <div class="ct">{{ m.nome }} <span v-if="ehChefe(m)" class="pill on" style="margin-left:4px">{{ m.ameaca==='chefe' ? '👑 CHEFE' : '🔶 MINIBOSS' }}</span></div>
          <div class="cs">Nv {{ nivelMonstro(m) }} · {{ m.ameaca || '?' }}</div>

          <!-- chefe/miniboss: HP compartilhado entre todos os jogadores, não é 1x1 -->
          <template v-if="ehChefe(m)">
            <div style="margin-top:8px">
              <div style="display:flex;justify-content:space-between;font-family:var(--f-mono);font-size:10.5px;color:var(--azul-bright)">
                <span>💥 VIDA DO CHEFE</span>
                <span>{{ chefesInfo[m.id]?.vida_atual ?? m.chefe_vida_max ?? '?' }} / {{ chefesInfo[m.id]?.vida_max ?? m.chefe_vida_max ?? '?' }}</span>
              </div>
              <div class="hv-barra" style="margin-top:3px">
                <div class="hv-fill hv-vida-baixa" :style="{width: Math.max(0, Math.min(100, 100*(chefesInfo[m.id]?.vida_atual ?? 1)/(chefesInfo[m.id]?.vida_max || m.chefe_vida_max || 1)))+'%'}"></div>
              </div>
              <div style="font-size:11px;color:var(--ink-dim);margin-top:4px">
                👥 {{ chefesInfo[m.id]?.contribuintes ?? 0 }} / {{ m.min_contribuintes }} jogadores diferentes já atacaram
                <span v-if="(chefesInfo[m.id]?.contribuintes ?? 0) < m.min_contribuintes">— precisa de mais gente pra derrubar de vez</span>
              </div>
            </div>
          </template>

          <div class="faixa" style="margin-top:8px">
            <span class="pill" :class="{on: chancePreview(m)>=50}">🎯 {{ chancePreview(m) }}% vitória</span>
            <span v-if="bateFraqueza(m)" class="pill on">⚡ sua arma bate a fraqueza (+1)</span>
            <span class="pill">💨 −{{ custoFolego(m) }}</span>
          </div>
          <div style="margin-top:10px;display:flex;justify-content:flex-end">
            <button class="btn primario" :disabled="atacando || vidaAtual<=0 || (auth.personagem.folego??0)<custoFolego(m)" @click="atacar(m)">
              {{ atacando===m.id ? 'Lutando…' : '⚔️ Atacar' }}
            </button>
          </div>
        </div>
      </div>

      <div class="card" style="margin-top:16px">
        <h4 style="margin:0 0 10px;color:var(--gold-bright)">🏆 Últimos combates</h4>
        <div v-if="!logs.length" class="msg warn">Nenhum combate ainda.</div>
        <div v-else style="display:grid;gap:6px">
          <div v-for="l in logs" :key="l.id" class="log-entry">
            <b>{{ tituloResultado(l.resultado) }}</b> vs {{ l.monstro_nome }}
            <span style="color:var(--ink-dim)"> · {{ new Date(l.criado_em).toLocaleString('pt-BR') }}</span>
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
import StatusBar from '../components/StatusBar.vue'
import { urlImagem } from '../lib/imagens.js'
import TituloHUD from '../components/TituloHUD.vue'

const auth = useAuthStore()
defineEmits(['pedir-login'])
const supa = useSupa()

const monstros = ref([])
const carregando = ref(true)
const busca = ref(''), filtroAmeaca = ref('')
const nivelProfissaoAtual = ref(1)
const minhaArmaAtributo = ref('')
const atacando = ref(null)
const curando = ref(false)
const comprando = ref(false)
const ultimoResultado = ref(null)
const logs = ref([])

const vidaAtual = computed(() => auth.personagem?.vida_atual ?? 0)
const vidaMax = computed(() => auth.personagem?.vida_max || 50)
const pctVida = computed(() => Math.max(0, Math.min(100, (vidaAtual.value / vidaMax.value) * 100)))
const pctFolego = computed(() => Math.max(0, Math.min(100, ((auth.personagem?.folego ?? 0) / 20) * 100)))

const chefesInfo = ref({}) // monstro_id -> {vida_atual, vida_max, contribuintes, min_contribuintes}

const ameacasPresentes = computed(() => [...new Set(monstros.value.map(m => m.ameaca).filter(Boolean))])
function ehChefe(m) { return m.ameaca === 'elite' || m.ameaca === 'chefe' }
function nivelMonstro(m) {
  const n = String(m.nivel_recomendado || '').match(/\d+/)
  return n ? Number(n[0]) : 1
}
function custoFolego(m) {
  return Math.max(1, Math.ceil(nivelMonstro(m) / 3))
}
function chancePreview(m) {
  const dif = nivelProfissaoAtual.value - nivelMonstro(m)
  const chanceVitoria = 50 + dif * 7
  const chanceParcial = 25 - Math.max(0, dif * 2)
  return Math.round(Math.max(5, Math.min(95, chanceVitoria + chanceParcial * 0.7)))
}
function bateFraqueza(m) {
  return !!(m.atributo_fraqueza && minhaArmaAtributo.value && m.atributo_fraqueza === minhaArmaAtributo.value)
}
const monstrosFiltrados = computed(() => {
  let l = monstros.value
  if (filtroAmeaca.value) l = l.filter(m => m.ameaca === filtroAmeaca.value)
  const q = busca.value.trim().toLowerCase()
  if (q) l = l.filter(m => (m.nome || '').toLowerCase().includes(q))
  return l
})
function tituloResultado(r) {
  return { sucesso_total: '✅ Vitória limpa', sucesso_parcial: '⚠️ Vitória com custo', falha: '❌ Derrota' }[r] || r
}
function corResultado(r) {
  return { sucesso_total: 'ok', sucesso_parcial: 'warn', falha: 'erro' }[r] || 'info'
}

async function carregarMonstros() {
  carregando.value = true
  try {
    // monstros_publico, não a tabela base: "monstros" nunca teve GRANT
    // SELECT pra "authenticated" (só INSERT/UPDATE/DELETE, pro editor do
    // mestre) — só a view resolve com segurança via RLS+CASE WHEN
    // is_mestre(). Bug achado 11/08: grade de monstros ficava vazia pra
    // qualquer jogador, silencioso (erro só aparecia no console).
    const r = await supa.from('monstros_publico').select('id,nome,img,nivel_recomendado,ameaca,zona,atributo_fraqueza,min_contribuintes').eq('visivel', true).order('nome')
    monstros.value = r.data || []
    await carregarChefes()
  } catch (e) { console.warn(e) }
  finally { carregando.value = false }
}
// chefe/miniboss tem HP compartilhado entre todo mundo (item 11) — busca
// o estado ativo (se tiver) + quantos personagens diferentes já bateram.
// Poucas linhas sempre (só 6 monstros são elite/chefe no Andar 1), então
// agrega no cliente em vez de criar view nova só pra isso.
async function carregarChefes() {
  const idsChefes = monstros.value.filter(ehChefe).map(m => m.id)
  if (!idsChefes.length) return
  const rAtivos = await supa.from('chefes_ativos').select('*').in('monstro_id', idsChefes).eq('derrotado', false)
  const ativos = rAtivos.data || []
  if (!ativos.length) { chefesInfo.value = {}; return }
  const rContrib = await supa.from('chefes_contribuicoes').select('chefe_ativo_id').in('chefe_ativo_id', ativos.map(a => a.id))
  const contagem = {}
  for (const c of (rContrib.data || [])) contagem[c.chefe_ativo_id] = (contagem[c.chefe_ativo_id] || 0) + 1
  const info = {}
  for (const a of ativos) {
    const m = monstros.value.find(x => x.id === a.monstro_id)
    info[a.monstro_id] = { vida_atual: a.vida_atual, vida_max: a.vida_max, contribuintes: contagem[a.id] || 0, min_contribuintes: m?.min_contribuintes || 1 }
  }
  chefesInfo.value = info
}
async function carregarNivelProfissao() {
  if (!auth.temPersonagem) return
  const r = await supa.from('nivel_profissao').select('nivel').eq('personagem_nome', auth.personagem.nome).order('nivel', { ascending: false }).limit(1).maybeSingle()
  nivelProfissaoAtual.value = r.data?.nivel || 1
}
async function carregarMinhaArma() {
  minhaArmaAtributo.value = ''
  if (!auth.personagem?.arma) return
  const r = await supa.from('armas').select('atributo').eq('id', auth.personagem.arma).maybeSingle()
  minhaArmaAtributo.value = r.data?.atributo || ''
}
async function carregarLogs() {
  if (!auth.temPersonagem) return
  const r = await supa.from('combate_log').select('*').eq('personagem_nome', auth.personagem.nome).order('criado_em', { ascending: false }).limit(5)
  logs.value = r.data || []
}
async function atacar(m) {
  if (atacando.value) return
  atacando.value = m.id
  try {
    const chefe = ehChefe(m)
    const r = await supa.rpc(chefe ? 'atacar_chefe' : 'combater_monstro', { p_monstro_id: m.id })
    if (r.error) throw r.error
    const d = typeof r.data === 'string' ? JSON.parse(r.data) : r.data
    if (d.erro) { alert(d.erro); return }
    ultimoResultado.value = d
    await auth.carregarPerfilEPersonagem()
    await carregarLogs()
    if (chefe) await carregarChefes()
  } catch (e) { alert('Erro no combate: ' + e.message) }
  finally { atacando.value = null }
}
async function curar() {
  curando.value = true
  try {
    const r = await supa.rpc('curar_estalagem')
    if (r.error) throw r.error
    const d = typeof r.data === 'string' ? JSON.parse(r.data) : r.data
    if (d.erro) { alert(d.erro); return }
    await auth.carregarPerfilEPersonagem()
  } catch (e) { alert('Erro: ' + e.message) }
  finally { curando.value = false }
}
async function comprarFolego(qtd) {
  comprando.value = true
  try {
    const r = await supa.rpc('comprar_folego', { p_qtd: qtd })
    if (r.error) throw r.error
    const d = typeof r.data === 'string' ? JSON.parse(r.data) : r.data
    if (d.erro) { alert(d.erro); return }
    await auth.carregarPerfilEPersonagem()
  } catch (e) { alert('Erro: ' + e.message) }
  finally { comprando.value = false }
}

onMounted(async () => {
  if (!auth.ready) await auth.init()
  await Promise.all([carregarMonstros(), carregarNivelProfissao(), carregarLogs(), carregarMinhaArma()])
})
</script>
