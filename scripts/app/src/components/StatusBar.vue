<template>
  <div class="stbar">
    <div v-if="pers">
      <div class="k">🌬️ Fôlego</div>
      <div class="v">{{ pers.folego || 0 }} / 20</div>
      <div class="bar"><div :style="{ width: pctFg + '%' }"></div></div>
    </div>
    <div v-if="pers">
      <div class="k">💰 Col (na mão)</div>
      <div class="v">{{ nf.format(pers.col_mao || 0) }}</div>
    </div>
    <div v-if="pers">
      <div class="k">🏦 Col (Stash)</div>
      <div class="v">{{ nf.format(pers.col_guardado || 0) }}</div>
    </div>
    <div>
      <div class="k">🧑‍🏭 Profissão</div>
      <div class="v">{{ pers && pers.profissao ? pers.profissao : "—" }}</div>
    </div>
    <div>
      <div class="k">🗡️ Arma</div>
      <div class="v" v-if="pers && pers.arma">{{ nomeArma(pers.arma) }}</div>
      <div class="v" v-else>—</div>
    </div>
  </div>
</template>
<script setup>
import { computed } from "vue";
import { useAuthStore } from "../stores/auth.js";
const auth = useAuthStore();
const pers = computed(() => auth.personagem);
const pctFg = computed(() =>
  Math.max(
    0,
    Math.min(100, Math.round(100 * ((pers.value?.folego || 0) / 20))),
  ),
);
const nf = new Intl.NumberFormat("pt-BR");

// MAP de armas conhecidas → nome humano (sem _)
const ARMAS_NOMES = {
  foice_de_ferro: "Foice de Ferro",
  foice_de_fero: "Foice de Ferro",
  espada_curta: "Espada Curta",
  espada_long: "Espada Longa",
  espada_longa: "Espada Longa",
  espada_maos_duas: "Espadão de Duas Mãos",
  cajado_curto: "Cajado Curto",
  adaga: "Adaga",
  machado_batalha: "Machado de Batalha",
  arco_curto: "Arco Curto",
  arco_longo: "Arco Longo",
  funda: "Funda",
  lanca_curta: "Lança Curta",
  cimitarra: "Cimitarra",
  clava: "Clava",
  martelo_guerra: "Martelo de Guerra",
  foice_ferro: "Foice de Ferro",
  rapieira: "Rapieira",
  punhal: "Punhal",
  florete: "Florete",
  bastao: "Bastão",
  mace: "Maça",
  katana: "Katana",
};
function nomeArma(id) {
  if (!id) return "—";
  if (ARMAS_NOMES[id]) return ARMAS_NOMES[id];
  // Fallback: remove _ e Title Case
  return String(id)
    .replace(/[-_]+/g, " ")
    .trim()
    .replace(/\b\w/g, (l) => l.toUpperCase());
}
</script>
