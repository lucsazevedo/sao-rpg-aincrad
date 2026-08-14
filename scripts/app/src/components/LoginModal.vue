<template>
  <div class="modal-bg on" @click.self="$emit('fechar')">
    <div class="modal">
      <div class="top">
        <h2>{{ modo === 'recuperar' ? 'Esqueci a senha' : 'Entrar' }}</h2>
        <button class="btn ghost" @click="$emit('fechar')">✕</button>
      </div>
      <div class="body">
        <div v-if="modo === 'login'" class="form">
          <div class="c"><label for="em">Email</label><input id="em" type="email" v-model="email" placeholder="voce@exemplo.com" @keydown.enter="ok"/></div>
          <div class="c"><label for="pw">Senha</label><input id="pw" type="password" v-model="senha" @keydown.enter="ok"/></div>
          <div v-if="erro" class="msg erro">{{ erro }}</div>
          <div style="display:flex;justify-content:space-between;align-items:center;margin-top:2px;flex-wrap:wrap;gap:6px">
            <a href="#" @click.prevent="modo = 'recuperar'; erro = ''" style="font-size:12.5px;color:var(--azul-bright)">Esqueci a senha</a>
            <router-link to="/cadastro" @click="$emit('fechar')" style="font-size:12.5px;color:var(--gold-bright)">Criar conta</router-link>
          </div>
          <div style="display:flex;gap:10px;justify-content:flex-end;margin-top:6px">
            <button class="btn" @click="$emit('fechar')">Cancelar</button>
            <button class="btn primario" :disabled="carregando" @click="ok">{{ carregando ? 'Entrando…' : 'Entrar' }}</button>
          </div>
        </div>

        <div v-else class="form">
          <p style="margin:0;color:var(--ink-dim);font-size:13px">Informe o e-mail da conta — mandamos um link pra você escolher uma senha nova.</p>
          <div class="c"><label for="em2">Email</label><input id="em2" type="email" v-model="email" placeholder="voce@exemplo.com" @keydown.enter="enviarRecuperacao"/></div>
          <div v-if="erro" class="msg erro">{{ erro }}</div>
          <div v-if="enviado" class="msg ok">📧 Se esse e-mail tiver conta, o link chegou lá — confira a caixa de entrada (e o spam).</div>
          <div style="display:flex;justify-content:space-between;align-items:center;margin-top:2px">
            <a href="#" @click.prevent="modo = 'login'; erro = ''; enviado = false" style="font-size:12.5px;color:var(--azul-bright)">← Voltar pro login</a>
            <button class="btn primario" :disabled="carregando" @click="enviarRecuperacao">{{ carregando ? 'Enviando…' : 'Enviar link' }}</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref } from 'vue'
import { useAuthStore } from '../stores/auth.js'
import { useSupa } from '../lib/supabase.js'
const auth = useAuthStore()
const supa = useSupa()
const emit = defineEmits(['fechar','ok'])
const modo = ref('login') // 'login' | 'recuperar'
const email = ref('')
const senha = ref('')
const erro = ref('')
const carregando = ref(false)
const enviado = ref(false)
async function ok(){
  erro.value = ''
  if(!email.value || !senha.value){ erro.value = 'Preencha email e senha.'; return }
  carregando.value = true
  try{
    await auth.login(email.value, senha.value)
    emit('ok')
  }catch(e){
    erro.value = 'Credenciais inválidas. Confira email e senha.'
  }finally{
    carregando.value = false
  }
}
async function enviarRecuperacao(){
  erro.value = ''; enviado.value = false
  if(!email.value){ erro.value = 'Informe o e-mail.'; return }
  carregando.value = true
  try{
    // redirectTo = raiz do site, sem rota hash — precisa ficar limpo pro
    // GoTrue conseguir ler o token de recuperação da URL (ver auth.js).
    const redirectTo = window.location.origin + window.location.pathname
    const r = await supa.auth.resetPasswordForEmail(email.value, { redirectTo })
    if (r.error) throw r.error
    enviado.value = true
  }catch(e){
    erro.value = 'Erro: ' + e.message
  }finally{
    carregando.value = false
  }
}
</script>
