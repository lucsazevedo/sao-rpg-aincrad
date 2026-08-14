<template>
  <img v-if="urlIcone" :src="urlIcone" :alt="tipo" class="icone-arma" :style="{ width: tamanho + 'px', height: tamanho + 'px' }" />
  <span v-else class="icone-arma-fallback" :style="{ width: tamanho + 'px', height: tamanho + 'px', fontSize: (tamanho * 0.62) + 'px', color: cor }" :title="tipo">⚔️</span>
</template>

<script setup>
// Ícone de tipo de arma — badges oficiais que o usuário colocou em
// Imagens_atualizar/Armas/<Cor>/<tipo>.png (desenho pronto por raridade,
// sem precisar tingir via CSS), movidos pra
// imagens/armas_icones/<cor>/<slug>.png. Os 19 tipos de arma do sistema
// (ARMAS_TIPOS em tabelasAdmin.js) têm badge oficial — Clava, Glaive,
// Nunchaku e Tonfas saíram do roster em 14/08 (ver docs/guia_sistema_aincrad.md),
// então não sobrou tipo sem ícone hoje. O fallback de emoji fica pronto
// pra um tipo novo que ainda não tenha badge.
import { computed } from "vue";
import { urlImagem } from "../lib/imagens.js";

const props = defineProps({
  tipo: { type: String, default: "" },
  raridade: { type: String, default: "" },
  tamanho: { type: Number, default: 56 },
});

const SLUG_POR_TIPO = {
  Adagas: "adagas",
  "Adagas de Arremesso": "adagas_de_arremesso",
  "Arco e Flecha": "arco_e_flecha",
  Bastão: "bastao",
  Besta: "besta",
  Chakrams: "chakram",
  Chicote: "chicote",
  "Corrente com Peso": "corrente_com_peso",
  "Escudo e Espada": "espada_e_escudo",
  "Espada Longa": "espada",
  Foice: "foice",
  Katana: "katana",
  Lança: "lanca",
  Leque: "leque",
  Machado: "machado",
  Manopla: "manopla",
  Martelo: "martelo",
  Pá: "pa",
  Rapieira: "rapieira",
};

// Comum=cinza, Incomum=verde, Raro=azul, Épico=roxo, Lendário=vermelho —
// mesma escala das pastas de cor dos badges oficiais. Relíquia/Ancestral/
// Mítico (acima do andar 1, ainda não liberados pro mestre escolher) até
// aparecer badge próprio caem junto com Lendário/vermelho.
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
  const slugTipo = SLUG_POR_TIPO[props.tipo];
  return slugTipo ? urlImagem(`imagens/armas_icones/${pastaCor.value}/${slugTipo}.png`) : "";
});
</script>

<style scoped>
.icone-arma {
  display: inline-block;
  flex-shrink: 0;
  object-fit: contain;
  filter: drop-shadow(0 0 4px rgba(0, 0, 0, 0.5));
}
.icone-arma-fallback {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  filter: drop-shadow(0 0 6px rgba(0, 0, 0, 0.45));
}
</style>
