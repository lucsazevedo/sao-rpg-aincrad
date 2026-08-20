<!-- Autocadastro público: qualquer visitante cria a própria conta + ficha
     de personagem, sem depender do mestre (antes só existia via Painel do
     Mestre). Mesmos campos/orçamento de atributos daquele formulário —
     só troca "mestre gera senha" por "você escolhe a sua". -->
<template>
  <div>
    <TituloHUD icone="📝" titulo="Criar Personagem" trilha="Sua conta e sua ficha em Aincrad" />

    <div v-if="jaLogadoComPersonagem" class="msg info">
      Você já tem um personagem — <router-link to="/ficha" style="color:var(--gold-bright)">vá pra sua ficha</router-link>.
    </div>
    <div v-else-if="aguardandoConfirmacao" class="msg ok">
      ✅ Conta criada! Enviamos um link de confirmação pro seu e-mail — assim que confirmar e entrar de novo,
      sua ficha termina de ser criada sozinha (guardamos os dados que você preencheu).
    </div>
    <template v-else>
      <div class="msg info" style="margin-bottom:14px">
        Nome no Discord e e-mail são obrigatórios — é como o mestre te encontra e você recupera acesso depois.
      </div>
      <div class="card">
        <div class="form">
          <div style="grid-column:1 / -1">
            <div class="campo foto-campo">
              <label>Foto do personagem</label>
              <CampoImagem v-model="F.foto_url" pasta="avatares">
                <template #extra>
                  <button class="btn tiny ghost" type="button" @click="aleatorioFoto()">🎲 Usar avatar aleatório</button>
                </template>
              </CampoImagem>
            </div>
          </div>

          <div class="campo"><label>Nome no Discord <span style="color:#e05050">*</span></label>
            <input v-model.trim="F.discord_nome" placeholder="Ex: Shen#1234"></div>
          <div class="campo"><label>E-mail <span style="color:#e05050">*</span></label>
            <input v-model.trim="F.email" type="email" placeholder="voce@exemplo.com"></div>
          <div class="campo"><label>Senha <span style="color:#e05050">*</span></label>
            <input v-model="F.senha" type="password" placeholder="Mínimo 6 caracteres"></div>
          <div class="campo"><label>Confirmar senha <span style="color:#e05050">*</span></label>
            <input v-model="F.senha2" type="password" @keydown.enter="cadastrar"></div>

          <div class="campo"><label>Nome do personagem <span style="color:#e05050">*</span></label>
            <input v-model.trim="F.nome" placeholder="Ex: Shen Kurenai"></div>
          <div class="campo"><label>Profissão</label>
            <select v-model="F.profissao">
              <option value="">-- Sem profissão --</option>
              <option v-for="o in oficios" :key="o.nome" :value="o.nome">{{ o.nome }} · {{ o.atributo || '—' }}</option>
            </select></div>
          <div class="campo"><label>Arma inicial (Comum)</label>
            <select v-model="F.arma">
              <option value="">-- Sem arma --</option>
              <option v-for="a in armasComuns" :key="a.id" :value="a.id">{{ a.nome }}</option>
            </select></div>
          <div class="campo"><label>Clã / Guilda</label>
            <select v-model="F.guilda">
              <option value="">-- Independente --</option>
              <option v-for="g in clas" :key="g.nome" :value="g.nome">{{ g.nome }}</option>
            </select></div>

          <div style="grid-column:1 / -1;margin-top:6px">
            <h4 style="margin:0 0 8px;color:var(--azul-bright)">
              Atributos · distribua 6, 8, 8, 10, 10, 12 entre os seis — cada valor só pode ser usado uma vez
            </h4>
            <div class="atributos">
              <div v-for="a in listaAtributos" :key="a.k" class="atrib">
                <label>{{ a.nome }}</label>
                <select v-model.number="a.v">
                  <option v-for="opt in VALORES_BASE_UNICOS" :key="opt" :value="opt">
                    {{ opt }} ({{ opt >= 10 ? '+' : '' }}{{ Math.floor((opt - 10) / 2) }})
                  </option>
                </select>
              </div>
            </div>
            <div class="sum-box" :style="somaBoxEstilo">
              {{ distribuicaoCompleta ? '✅ Distribuição completa' : `Faltam usar: ${valoresRestantes.join(', ')}` }}
            </div>
          </div>

          <div class="campo" style="grid-column:1 / -1"><label>Conceito</label><textarea v-model="F.conceito" rows="2"></textarea></div>
          <div class="campo" style="grid-column:1 / -1"><label>Aparência</label><textarea v-model="F.aparencia" rows="2"></textarea></div>

          <div v-if="erro" class="msg erro" style="grid-column:1 / -1">{{ erro }}</div>
          <div style="grid-column:1 / -1;display:flex;justify-content:flex-end">
            <button class="btn primario" :disabled="enviando" @click="cadastrar">
              {{ enviando ? 'Criando…' : '✨ Criar minha conta e personagem' }}
            </button>
          </div>
        </div>
      </div>
      <p style="margin-top:10px;color:var(--ink-dim);font-size:13px">
        Já tem conta? <a href="#" @click.prevent="$emit('pedir-login')" style="color:var(--gold-bright)">Entrar</a>
      </p>
    </template>
  </div>
</template>
<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth.js'
import { useSupa } from '../lib/supabase.js'
import TituloHUD from '../components/TituloHUD.vue'
import CampoImagem from '../components/CampoImagem.vue'

const auth = useAuthStore()
const supa = useSupa()
defineEmits(['pedir-login'])

const CHAVE_RASCUNHO = 'sao-rpg-cadastro-pendente'

const F = reactive({
  foto_url: '', discord_nome: '', email: '', senha: '', senha2: '',
  nome: '', profissao: '', arma: '', guilda: '', conceito: '', aparencia: '',
})
// Distribuição inicial D&D 5e (Seção 5 do SAO_RPG_5e.md): 6/8/8/10/10/12,
// um valor por atributo, sem repetir a MESMA posição na lista (8 e 10
// aparecem duas vezes cada, isso é esperado).
const VALORES_BASE = [6, 8, 8, 10, 10, 12]
const VALORES_BASE_UNICOS = [...new Set(VALORES_BASE)]
const listaAtributos = reactive([
  { k: 'forca', nome: 'Força', v: 8 },
  { k: 'destreza', nome: 'Destreza', v: 8 },
  { k: 'constituicao', nome: 'Constituição', v: 10 },
  { k: 'inteligencia', nome: 'Inteligência', v: 10 },
  { k: 'sabedoria', nome: 'Sabedoria', v: 12 },
  { k: 'carisma', nome: 'Carisma', v: 6 },
])
function contagem(valores) {
  const c = {}
  valores.forEach(v => { c[v] = (c[v] || 0) + 1 })
  return c
}
const valoresRestantes = computed(() => {
  const base = contagem(VALORES_BASE)
  const usada = contagem(listaAtributos.map(a => a.v))
  const restantes = []
  Object.entries(base).forEach(([v, n]) => {
    const falta = n - (usada[v] || 0)
    for (let i = 0; i < falta; i++) restantes.push(v)
  })
  return restantes
})
const distribuicaoCompleta = computed(() => valoresRestantes.value.length === 0)
const somaBoxEstilo = computed(() => distribuicaoCompleta.value
  ? { background: 'linear-gradient(135deg,#1e3a25,#0a0806)', color: '#62c56a', border: '1px solid #62c56a' }
  : { background: 'linear-gradient(135deg,#3a1212,#0a0806)', color: '#e05050', border: '1px solid #e05050' })
function aleatorioFoto() {
  const seed = (F.nome || F.discord_nome || 'avatar').replace(/\s+/g, '').slice(0, 12) || Math.random().toString(36).slice(2, 10)
  F.foto_url = `https://api.dicebear.com/9.x/thumbs/png?seed=${encodeURIComponent(seed)}&backgroundColor=2d3748,3a3a6a,3a5a3a`
}

const oficios = ref([]), armasComuns = ref([]), clas = ref([])
const erro = ref('')
const enviando = ref(false)
const aguardandoConfirmacao = ref(false)
const jaLogadoComPersonagem = computed(() => auth.logado && auth.temPersonagem)

async function carregarListas() {
  // views próprias (não as tabelas base) — quem preenche este formulário
  // ainda é anon nesse momento (é o fluxo que leva de visitante pra
  // logado), e oficios/armas exigem "authenticated" na RLS pro resto do
  // Compêndio. Ver schema_views_publicas_cadastro.sql.
  const [rOf, rAr, rCl] = await Promise.all([
    supa.from('oficios_signup_publico').select('nome, atributo'),
    supa.from('armas_comuns_signup_publico').select('id, nome'),
    supa.from('clas_publico').select('nome'),
  ])
  oficios.value = (rOf.data || []).sort((a, b) => a.nome.localeCompare(b.nome, 'pt-BR'))
  armasComuns.value = (rAr.data || []).sort((a, b) => (a.nome || '').localeCompare(b.nome || '', 'pt-BR'))
  clas.value = (rCl.data || []).sort((a, b) => a.nome.localeCompare(b.nome, 'pt-BR'))
}

function validar() {
  if (!F.discord_nome) return 'Informe o nome no Discord.'
  if (!F.email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(F.email)) return 'Informe um e-mail válido.'
  if (!F.senha || F.senha.length < 6) return 'A senha precisa ter pelo menos 6 caracteres.'
  if (F.senha !== F.senha2) return 'As senhas não são iguais.'
  if (!F.nome) return 'Informe o nome do personagem.'
  if (!distribuicaoCompleta.value) return 'Distribua os 6 valores de atributo (6/8/8/10/10/12) antes de continuar.'
  return ''
}
function montarAtributos() {
  const atributos = {}
  listaAtributos.forEach(a => atributos[a.k] = a.v)
  return atributos
}
function payloadPersonagem() {
  return {
    p_nome: F.nome, p_discord_nome: F.discord_nome, p_discord_email: F.email,
    p_profissao: F.profissao || null, p_arma: F.arma || null, p_guilda: F.guilda || null,
    p_conceito: F.conceito || null, p_aparencia: F.aparencia || null, p_foto_url: F.foto_url || null,
    p_atributos_dnd: montarAtributos(),
  }
}
async function finalizarPersonagem(payload) {
  const r = await supa.rpc('autocadastrar_personagem', payload)
  if (r.error) throw new Error(r.error.message)
  const d = JSON.parse(r.data)
  if (d.erro) throw new Error(d.erro)
  await auth.carregarPerfilEPersonagem()
}

async function cadastrar() {
  erro.value = ''
  const msg = validar()
  if (msg) { erro.value = msg; return }
  enviando.value = true
  try {
    const email = F.email.trim()
    // emailRedirectTo = raiz do site, sem rota hash — mesmo padrão do
    // "esqueci a senha" (ver LoginModal.vue/auth.js). Sem isso o link do
    // e-mail de confirmação cai no Site URL padrão do projeto Supabase
    // (geralmente localhost, de quando foi criado em dev) e a pessoa cai
    // numa página que recusa conexão em vez de voltar pro site de verdade.
    const emailRedirectTo = window.location.origin + window.location.pathname
    const rSign = await supa.auth.signUp({
      email, password: F.senha,
      options: { data: { nome: F.nome, discord_nome: F.discord_nome }, emailRedirectTo },
    })
    if (rSign.error) throw new Error(rSign.error.message)
    const payload = payloadPersonagem()
    if (rSign.data?.session) {
      // sessão já ativa (confirmação de e-mail desligada no projeto) — termina agora.
      await finalizarPersonagem(payload)
      location.hash = '#/ficha'
    } else {
      // precisa confirmar e-mail antes de ter sessão pra chamar a RPC —
      // guarda o rascunho, Cadastro.vue termina sozinho quando ela voltar logada.
      localStorage.setItem(CHAVE_RASCUNHO, JSON.stringify(payload))
      aguardandoConfirmacao.value = true
    }
  } catch (e) {
    erro.value = e.message?.includes('already registered') || e.message?.includes('já')
      ? 'Já existe uma conta com esse e-mail — tente entrar em vez de cadastrar.'
      : ('Erro: ' + e.message)
  } finally {
    enviando.value = false
  }
}

async function retomarRascunhoSeExistir() {
  if (!auth.logado || auth.temPersonagem) return
  const bruto = localStorage.getItem(CHAVE_RASCUNHO)
  if (!bruto) return
  try {
    await finalizarPersonagem(JSON.parse(bruto))
    localStorage.removeItem(CHAVE_RASCUNHO)
    location.hash = '#/ficha'
  } catch (e) {
    erro.value = 'Não consegui terminar seu cadastro sozinho: ' + e.message + ' — preencha o formulário de novo.'
    localStorage.removeItem(CHAVE_RASCUNHO)
  }
}

onMounted(async () => {
  if (!auth.ready) await auth.init()
  await Promise.all([carregarListas(), retomarRascunhoSeExistir()])
})
</script>
