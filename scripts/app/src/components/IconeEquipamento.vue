<template>
  <span v-if="urlIcone" class="icone-equip" :style="estiloMascara" :title="slot"></span>
  <span v-else class="icone-equip icone-equip-fallback" :style="{ width: tamanho + 'px', height: tamanho + 'px', fontSize: tamanho * 0.62 + 'px', color: cor }" :title="slot">🥋</span>
</template>

<script setup>
// Ícone de slot de equipamento, colorido por raridade — mesmo mecanismo
// do IconeArma.vue (mask-image + background-color), só que aqui o
// "tipo" é o slot (Elmos/Armaduras/Botas/Acessórios). 4 dos 13 slots
// têm ícone próprio hoje (extraídos de equips.png via
// scripts/extrair_icones_equipamentos.py); os outros caem no fallback
// 🥋 tingido pela raridade até chegar o desenho deles. "Capa" foi
// extraída mas não tem slot correspondente em EQUIP_SLOTS ainda, não é
// usada aqui.
import { computed } from "vue";
import { urlImagem } from "../lib/imagens.js";

const props = defineProps({
  slot: { type: String, default: "" },
  raridade: { type: String, default: "" },
  tamanho: { type: Number, default: 56 },
});

const SLUG_POR_SLOT = {
  // categorias do catálogo (equipamentos.slot / EQUIP_SLOTS)
  Elmos: "elmos",
  Capuz: "elmos",
  Armaduras: "armaduras",
  "Parte de Cima": "armaduras",
  Botas: "botas",
  "Parte de Baixo": "botas",
  Acessórios: "acessorios",
  // chaves do paper doll (Equipamentos.vue SLOTS) — mesmo ícone
  elmo: "elmos",
  armadura: "armaduras",
  botas: "botas",
  acessorio1: "acessorios",
  acessorio2: "acessorios",
};

// mesma paleta do IconeArma.vue — comum branco, incomum verde, raro
// azul, épico roxo, lendário dourado, escada alta em vermelho.
const COR_POR_RARIDADE = {
  comum: "#eceaf5",
  incomum: "#43d16b",
  raro: "#4aa3f2",
  epico: "#b262f2",
  lendario: "#f3c73f",
  reliquia: "#e6423f",
  ancestral: "#e6423f",
  mitico: "#e6423f",
};

function slug(v) {
  return String(v || "")
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .toLowerCase()
    .trim();
}

const cor = computed(() => COR_POR_RARIDADE[slug(props.raridade)] || COR_POR_RARIDADE.comum);
const slugIcone = computed(() => SLUG_POR_SLOT[props.slot] || null);
const urlIcone = computed(() => (slugIcone.value ? urlImagem(`imagens/equipamentos_icones/${slugIcone.value}.png`) : ""));

const estiloMascara = computed(() => ({
  width: props.tamanho + "px",
  height: props.tamanho + "px",
  backgroundColor: cor.value,
  WebkitMaskImage: `url(${urlIcone.value})`,
  maskImage: `url(${urlIcone.value})`,
}));
</script>

<style scoped>
.icone-equip {
  display: inline-block;
  flex-shrink: 0;
  -webkit-mask-size: contain;
  mask-size: contain;
  -webkit-mask-repeat: no-repeat;
  mask-repeat: no-repeat;
  -webkit-mask-position: center;
  mask-position: center;
  filter: drop-shadow(0 0 6px rgba(0, 0, 0, 0.45));
}
.icone-equip-fallback {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  filter: drop-shadow(0 0 6px rgba(0, 0, 0, 0.45));
}
</style>
