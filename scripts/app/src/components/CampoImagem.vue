<!-- Upload real de imagem (Storage do Supabase, bucket compendio-imagens)
     com preview — mesmo mecanismo já usado no Compêndio (EditorEntidade.vue,
     tipo "imagem"), extraído aqui pra reusar fora dele: Cadastro.vue (foto
     do próprio jogador, autocadastro) e Mestre.vue (Criar Personagem + ficha
     de jogador), que até aqui só tinham um <input> de colar URL. -->
<template>
  <div class="ci-campo">
    <div v-if="modelValue" class="ci-preview">
      <img :src="urlImagem(modelValue)" alt="Pré-visualização" @load="e => e.target.classList.remove('erro')" @error="e => e.target.classList.add('erro')" />
    </div>
    <div class="ci-linha">
      <label class="btn tiny" :class="{ disabled: enviando }">
        {{ enviando ? "⏳ Enviando…" : modelValue ? "🔄 Trocar imagem" : "📤 Enviar do meu PC" }}
        <input type="file" accept="image/*" style="display:none" :disabled="enviando" @change="enviarArquivo" />
      </label>
      <button v-if="modelValue" type="button" class="btn tiny bad ghost" @click="$emit('update:modelValue', '')">🗑️ Remover</button>
      <slot name="extra" />
    </div>
    <small v-if="erro" class="ci-hint erro">⚠️ {{ erro }}</small>
  </div>
</template>
<script setup>
import { ref } from 'vue'
import { urlImagem, enviarImagem } from '../lib/imagens.js'

const props = defineProps({
  modelValue: { type: String, default: '' },
  pasta: { type: String, default: 'geral' }, // vira o prefixo do caminho no Storage
})
const emit = defineEmits(['update:modelValue'])
const enviando = ref(false)
const erro = ref('')

async function enviarArquivo(evento) {
  const file = evento.target.files?.[0]
  evento.target.value = '' // deixa escolher o mesmo arquivo de novo depois, se precisar
  if (!file) return
  erro.value = ''
  enviando.value = true
  try {
    const url = await enviarImagem(file, props.pasta)
    emit('update:modelValue', url)
  } catch (e) {
    erro.value = e.message || String(e)
  } finally {
    enviando.value = false
  }
}
</script>
<style scoped>
.ci-campo{display:flex;flex-direction:column;gap:6px}
.ci-preview{margin-top:2px}
.ci-preview img{max-width:160px;max-height:160px;object-fit:cover;border-radius:8px;border:1px solid var(--line);display:block}
.ci-preview img.erro{display:none}
.ci-linha{display:flex;gap:8px;align-items:center;flex-wrap:wrap}
.ci-linha .btn.disabled{opacity:.4;pointer-events:none}
.ci-hint{font-size:11px}
.ci-hint.erro{color:#e0887a}
</style>
