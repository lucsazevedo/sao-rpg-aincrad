<template>
  <div class="modal-bg on" @click.self="$emit('fechar')">
    <div class="modal">
      <div class="top">
        <h2>Entrar</h2>
        <button class="btn ghost" @click="$emit('fechar')">✕</button>
      </div>
      <div class="body">
        <div class="form">
          <div class="c"><label for="em">Email</label><input id="em" type="email" v-model="email" placeholder="voce@exemplo.com" @keydown.enter="ok"/></div>
          <div class="c"><label for="pw">Senha</label><input id="pw" type="password" v-model="senha" @keydown.enter="ok"/></div>
          <div v-if="erro" class="msg erro">{{ erro }}</div>
          <div style="display:flex;gap:10px;justify-content:flex-end;margin-top:6px">
            <button class="btn" @click="$emit('fechar')">Cancelar</button>
            <button class="btn primario" :disabled="carregando" @click="ok">{{ carregando ? 'Entrando…' : 'Entrar' }}</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref } from 'vue'
import { useAuthStore } from '../stores/auth.js'
const auth = useAuthStore()
const emit = defineEmits(['fechar','ok'])
const email = ref('')
const senha = ref('')
const erro = ref('')
const carregando = ref(false)
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
</script>
