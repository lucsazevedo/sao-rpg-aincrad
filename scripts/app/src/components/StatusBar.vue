<template>
  <div class="hud-vitals" v-if="pers">
    <div class="hv-nome">
      <span class="hv-tag">{{ auth.ehMestre ? "🧙 MESTRE" : "⚔️ JOGADOR" }}</span>
      <b>{{ pers.nome }}</b>
    </div>

    <div class="hv-medidor" :class="{ 'hv-critico': pctVida <= 20 }">
      <div class="hv-rotulo"><span>❤️ VIDA<span v-if="pctVida<=20" class="hv-alerta"> · CRÍTICO</span></span><span>{{ vidaAtual }}/{{ vidaMax }}</span></div>
      <div class="hv-barra"><div class="hv-fill" :class="pctVida > 40 ? 'hv-vida-alta' : 'hv-vida-baixa'" :style="{ width: pctVida + '%' }"></div></div>
    </div>

    <div class="hv-medidor">
      <div class="hv-rotulo"><span>🌬️ FÔLEGO</span><span>{{ pers.folego || 0 }}/20</span></div>
      <div class="hv-barra"><div class="hv-fill hv-folego" :style="{ width: pctFg + '%' }"></div></div>
    </div>

    <div class="hv-stat"><small>💰 COL</small><span>{{ nf.format(pers.col_mao || 0) }}<em v-if="pers.col_guardado">+{{ nf.format(pers.col_guardado) }} guardado</em></span></div>
    <div class="hv-stat" style="flex-direction:row;align-items:center;gap:6px">
      <IconeProfissao v-if="pers.profissao" :profissao="pers.profissao" :tamanho="24" />
      <div><small>🧑‍🏭 OFÍCIO</small><span>{{ pers.profissao || "—" }}</span></div>
    </div>
    <div class="hv-stat"><small>🗡️ ARMA</small><span>{{ pers.arma ? nomeArma(pers.arma) : "—" }}</span></div>

    <div v-if="buffsAtivos.length" class="hv-buffs">
      <span v-for="b in buffsAtivos" :key="b.id" class="pill on" :title="b.descricao">✨ {{ b.titulo }}</span>
    </div>
  </div>
</template>
<script setup>
import { computed, onMounted, ref } from "vue";
import { useAuthStore } from "../stores/auth.js";
import { useSupa } from "../lib/supabase.js";
import IconeProfissao from "./IconeProfissao.vue";
const auth = useAuthStore();
const supa = useSupa();
const pers = computed(() => auth.personagem);

// Buffs de grupo ativos (ex: Composição Viva do Músico) — visível pra
// todo mundo, some sozinho quando expira (RLS de leitura pública).
const buffsAtivos = ref([]);
async function carregarBuffs() {
  try {
    const r = await supa.from("buffs_grupo").select("*").gt("expira_em", new Date().toISOString()).order("criado_em", { ascending: false }).limit(5);
    buffsAtivos.value = r.data || [];
  } catch (e) {
    console.warn(e);
  }
}
onMounted(carregarBuffs);
const vidaMax = computed(() => pers.value?.vida_max || 50);
const vidaAtual = computed(() => pers.value?.vida_atual ?? vidaMax.value);
const pctVida = computed(() =>
  Math.max(0, Math.min(100, Math.round((100 * vidaAtual.value) / (vidaMax.value || 1)))),
);
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
<style scoped>
/* HUD de vitais — a barra que no jogo fica sempre visível, não só na
   tela de combate (achado 10/08: vida só aparecia em Combate.vue). */
.hud-vitals{
  display:flex;flex-wrap:wrap;align-items:center;gap:16px 22px;
  padding:12px 16px;margin-bottom:14px;
  background:var(--panel);backdrop-filter:blur(8px);-webkit-backdrop-filter:blur(8px);
  border:1px solid var(--line);border-left:3px solid var(--laranja);
}
.hv-nome{display:flex;flex-direction:column;gap:2px;min-width:96px}
.hv-tag{font-family:var(--f-mono);font-size:9.5px;letter-spacing:.14em;color:var(--laranja-bright)}
.hv-nome b{font-family:var(--f-titulo);font-size:15px;color:var(--ink)}
.hv-medidor{flex:1;min-width:150px;max-width:230px}
.hv-rotulo{display:flex;justify-content:space-between;font-family:var(--f-mono);font-size:10.5px;letter-spacing:.06em;color:var(--azul-bright);margin-bottom:4px}
.hv-barra{height:8px;background:rgba(0,0,0,.4);border-radius:2px;overflow:hidden;border:1px solid rgba(255,255,255,.06)}
.hv-fill{height:100%;transition:width .3s ease}
.hv-vida-alta{background:linear-gradient(90deg,#2c6f92,#4ea5d9);box-shadow:0 0 6px var(--azul-glow)}
.hv-vida-baixa{background:linear-gradient(90deg,#b03d00,#ff5b3d);box-shadow:0 0 6px rgba(255,91,61,.45)}
.hv-folego{background:linear-gradient(90deg,#2c6f92,#4ea5d9);box-shadow:0 0 6px var(--azul-glow)}
.hv-stat{display:flex;flex-direction:column;gap:2px}
.hv-stat small{font-family:var(--f-mono);font-size:9.5px;letter-spacing:.1em;color:var(--ink-faint)}
.hv-stat span{font-size:13.5px;color:var(--ink);font-weight:600}
.hv-stat em{display:block;font-style:normal;font-size:10px;color:var(--ink-faint);font-weight:400}
.hv-buffs{flex-basis:100%;display:flex;gap:8px;flex-wrap:wrap;margin-top:2px}
/* HP crítico — o alerta visual clássico de vida baixa do HUD do jogo:
   pulso vermelho na barra + rótulo piscando */
.hv-alerta{color:#ff5b3d;animation:hvPiscar 1s ease-in-out infinite}
.hv-critico .hv-barra{animation:hvPulso 1.1s ease-in-out infinite}
@keyframes hvPiscar{0%,100%{opacity:1}50%{opacity:.35}}
@keyframes hvPulso{0%,100%{box-shadow:0 0 0 0 rgba(255,91,61,.5)}50%{box-shadow:0 0 0 4px rgba(255,91,61,0)}}
@media (max-width:640px){.hud-vitals{gap:10px 16px;padding:10px 12px}.hv-medidor{max-width:none;flex-basis:100%}}
</style>
