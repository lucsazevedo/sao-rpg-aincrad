<template>
  <img v-if="urlIcone" :src="urlIcone" :alt="profissao" class="icone-profissao" :style="{ width: tamanho + 'px', height: tamanho + 'px' }" />
  <span v-else class="icone-profissao-fallback" :style="{ width: tamanho + 'px', height: tamanho + 'px', fontSize: tamanho * 0.6 + 'px' }" :title="profissao">🛠️</span>
</template>

<script setup>
// Ícone de profissão — sem variação de cor (pedido do usuário: "mantém
// branco"), diferente do IconeArma que tinge por raridade. 15 dos 16
// perfis têm ícone próprio (extraídos de Profissões.jpeg via
// scripts/extrair_icones_profissoes.py); Cartógrafo ainda não tem
// planilha — cai no fallback 🛠️ genérico até chegar o desenho dele.
import { computed } from "vue";
import { urlImagem } from "../lib/imagens.js";

const props = defineProps({
  profissao: { type: String, default: "" },
  tamanho: { type: Number, default: 48 },
});

const SLUG_POR_PROFISSAO = {
  Alquimista: "alquimista",
  Caçador: "cacador",
  Comerciante: "comerciante",
  Costureiro: "costureiro",
  Cozinheiro: "cozinheiro",
  Domador: "domador",
  Ferreiro: "ferreiro",
  Informante: "informante",
  Lenhador: "lenhador",
  Mercenário: "mercenario",
  Médico: "medico",
  "Mestre de Montarias": "mestre_de_montarias",
  Minerador: "minerador",
  Músico: "musico",
  Joalheiro: "joalheiro",
};

const urlIcone = computed(() => {
  const slug = SLUG_POR_PROFISSAO[props.profissao];
  return slug ? urlImagem(`imagens/profissoes_icones/${slug}.png`) : "";
});
</script>

<style scoped>
.icone-profissao {
  display: inline-block;
  flex-shrink: 0;
  object-fit: contain;
  filter: drop-shadow(0 0 4px rgba(0, 0, 0, 0.5));
}
.icone-profissao-fallback {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  filter: drop-shadow(0 0 4px rgba(0, 0, 0, 0.5));
}
</style>
