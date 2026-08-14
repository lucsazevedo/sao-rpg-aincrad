<!-- Landing do link de "esqueci a senha" (e-mail enviado por
     supa.auth.resetPasswordForEmail em LoginModal.vue). Quando o link é
     clicado, o GoTrue já autentica a sessão de recuperação sozinho (ver
     auth.js, evento PASSWORD_RECOVERY) — aqui só falta pedir a senha nova. -->
<template>
  <div style="max-width:420px;margin:0 auto">
    <TituloHUD icone="🔑" titulo="Redefinir Senha" trilha="Sistema · Conta" />
    <div v-if="!auth.ready" class="msg info carregando">Carregando…</div>
    <div v-else-if="!auth.logado" class="msg warn">
      Esse link de recuperação expirou ou já foi usado. Peça um novo em "Esqueci a senha" na tela de entrar.
    </div>
    <div v-else-if="feito" class="msg ok">
      ✅ Senha alterada! <router-link to="/ficha" style="color:var(--gold-bright)">Ir pra minha ficha</router-link>.
    </div>
    <div v-else class="card">
      <p style="color:var(--ink-dim);font-size:13px;margin:0 0 12px">Conta: <b>{{ auth.user?.email }}</b></p>
      <div class="form">
        <div class="c"><label>Nova senha</label><input type="password" v-model="senha" placeholder="Mínimo 6 caracteres"></div>
        <div class="c"><label>Confirmar nova senha</label><input type="password" v-model="senha2" @keydown.enter="salvar"></div>
        <div v-if="erro" class="msg erro">{{ erro }}</div>
        <div style="display:flex;justify-content:flex-end">
          <button class="btn primario" :disabled="salvando" @click="salvar">{{ salvando ? 'Salvando…' : 'Salvar nova senha' }}</button>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth.js'
import { useSupa } from '../lib/supabase.js'
import TituloHUD from '../components/TituloHUD.vue'

const auth = useAuthStore()
const supa = useSupa()
const senha = ref(''), senha2 = ref('')
const erro = ref('')
const salvando = ref(false)
const feito = ref(false)

async function salvar() {
  erro.value = ''
  if (!senha.value || senha.value.length < 6) { erro.value = 'A senha precisa ter pelo menos 6 caracteres.'; return }
  if (senha.value !== senha2.value) { erro.value = 'As senhas não são iguais.'; return }
  salvando.value = true
  try {
    const r = await supa.auth.updateUser({ password: senha.value })
    if (r.error) throw r.error
    feito.value = true
  } catch (e) { erro.value = 'Erro: ' + e.message } finally { salvando.value = false }
}
onMounted(async () => { if (!auth.ready) await auth.init() })
</script>
