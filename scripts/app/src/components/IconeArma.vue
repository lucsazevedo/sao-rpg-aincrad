<template>
  <span v-if="urlIcone" class="icone-arma" :style="estiloMascara" :title="tipo"></span>
  <span v-else class="icone-arma icone-arma-fallback" :style="{ width: tamanho + 'px', height: tamanho + 'px', fontSize: (tamanho * 0.62) + 'px', color: cor }" :title="tipo">⚔️</span>
</template>

<script setup>
// Ícone de tipo de arma, colorido conforme a raridade (sem imagem de item
// por arma — só o glifo do tipo + cor). Os 13 tipos com ícone próprio
// vieram das planilhas equipamentos/*.jpeg que o usuário mandou (mesmo
// desenho branco, círculo de cor diferente por raridade — extraído uma
// vez em scripts/extrair_icones_armas.py pra não guardar 13×6 imagens).
// Tipo sem ícone ainda (Adagas, Arco e Flecha, Besta, Chicote, Glaive,
// Manopla, Nunchaku, Pá, Tonfas, Adagas de Arremesso) cai no emoji ⚔️
// tingido da cor da raridade, até chegar o desenho dele.
import { computed } from "vue";
import { urlImagem } from "../lib/imagens.js";

const props = defineProps({
  tipo: { type: String, default: "" },
  raridade: { type: String, default: "" },
  tamanho: { type: Number, default: 56 },
});

const ICONE_POR_TIPO = {
  Chakrams: "chakrams",
  "Escudo e Espada": "escudo_e_espada",
  "Espada Longa": "espada_longa",
  Foice: "foice",
  Katana: "katana",
  Lança: "lanca",
  Machado: "machado",
  Martelo: "martelo",
  Rapieira: "rapieira",
  Bastão: "bastao",
  Clava: "clava",
  "Corrente com Peso": "corrente_com_peso",
  Leque: "leque",
};

// Comum=branco, Incomum=verde, Raro=azul, Épico=roxo, Lendário=dourado —
// Relíquia/Ancestral/Mítico (acima do andar 1, ainda não liberados pro
// mestre escolher) todos em vermelho, já preparados.
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
const slugIcone = computed(() => ICONE_POR_TIPO[props.tipo] || null);
const urlIcone = computed(() => (slugIcone.value ? urlImagem(`imagens/armas_icones/${slugIcone.value}.png`) : ""));

const estiloMascara = computed(() => ({
  width: props.tamanho + "px",
  height: props.tamanho + "px",
  backgroundColor: cor.value,
  WebkitMaskImage: `url(${urlIcone.value})`,
  maskImage: `url(${urlIcone.value})`,
}));
</script>

<style scoped>
.icone-arma {
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
.icone-arma-fallback {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  filter: drop-shadow(0 0 6px rgba(0, 0, 0, 0.45));
}
</style>
