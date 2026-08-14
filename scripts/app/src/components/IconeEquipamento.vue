<template>
  <img v-if="urlIcone" :src="urlIcone" :alt="slot" class="icone-equip" :style="{ width: tamanho + 'px', height: tamanho + 'px' }" />
  <span v-else class="icone-equip-fallback" :style="{ width: tamanho + 'px', height: tamanho + 'px', fontSize: tamanho * 0.62 + 'px', color: cor }" :title="slot">🥋</span>
</template>

<script setup>
// Ícone de slot de equipamento — badges oficiais que o usuário colocou em
// Imagens_atualizar/Equipamentos/<Cor>/<slot>.png (desenho pronto por
// raridade, sem precisar tingir via CSS), movidos pra
// imagens/equipamentos_icones/<cor>/<slug>.png. 5 dos 13 slots
// (EQUIP_SLOTS em tabelasAdmin.js) têm badge hoje: Elmos/Capuz,
// Armaduras/Parte de Cima, Botas/Parte de Baixo, Acessórios e Capa (esta
// última sem slot correspondente em EQUIP_SLOTS ainda). Comidas,
// Cristais de Uso, Escudos, Luvas, Munições e Poções caem no fallback
// 🥋 tingido pela raridade até chegar o desenho deles.
import { computed } from "vue";
import { urlImagem } from "../lib/imagens.js";

const props = defineProps({
  slot: { type: String, default: "" },
  raridade: { type: String, default: "" },
  tamanho: { type: Number, default: 56 },
});

const SLUG_POR_SLOT = {
  // categorias do catálogo (equipamentos.slot / EQUIP_SLOTS)
  Elmos: "parte_superior",
  Capuz: "parte_superior",
  Armaduras: "roupa_armadura",
  "Parte de Cima": "roupa_armadura",
  Botas: "calcados",
  "Parte de Baixo": "calcados",
  Acessórios: "acessorio",
  // chaves do paper doll (Equipamentos.vue SLOTS) — mesmo ícone
  elmo: "parte_superior",
  armadura: "roupa_armadura",
  botas: "calcados",
  acessorio1: "acessorio",
  acessorio2: "acessorio",
};

// mesma escala do IconeArma.vue — comum cinza, incomum verde, raro azul,
// épico roxo, lendário vermelho, escada alta junto com lendário.
const PASTA_POR_RARIDADE = {
  comum: "cinza",
  incomum: "verde",
  raro: "azul",
  epico: "roxo",
  lendario: "vermelho",
  reliquia: "vermelho",
  ancestral: "vermelho",
  mitico: "vermelho",
};

// só usada pro fallback de emoji.
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

const raridadeSlug = computed(() => slug(props.raridade) || "comum");
const cor = computed(() => COR_POR_RARIDADE[raridadeSlug.value] || COR_POR_RARIDADE.comum);
const pastaCor = computed(() => PASTA_POR_RARIDADE[raridadeSlug.value] || PASTA_POR_RARIDADE.comum);

const urlIcone = computed(() => {
  const slugSlot = SLUG_POR_SLOT[props.slot];
  return slugSlot ? urlImagem(`imagens/equipamentos_icones/${pastaCor.value}/${slugSlot}.png`) : "";
});
</script>

<style scoped>
.icone-equip {
  display: inline-block;
  flex-shrink: 0;
  object-fit: contain;
  filter: drop-shadow(0 0 4px rgba(0, 0, 0, 0.5));
}
.icone-equip-fallback {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  filter: drop-shadow(0 0 6px rgba(0, 0, 0, 0.45));
}
</style>
