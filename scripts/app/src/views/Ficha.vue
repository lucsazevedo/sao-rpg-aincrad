<template>
  <div v-if="!auth.logado" class="msg info">
    🔒
    <router-link @click="() => $emit('pedir-login')" to="#">Entra</router-link>
    pra ver sua ficha.
  </div>
  <div v-else-if="!auth.temPersonagem" class="msg warn">
    ⚠️ Você ainda não tem personagem. Avise o mestre pra criar sua ficha.
  </div>
  <div v-else>
    <StatusBar />
    <TituloHUD icone="🧑" titulo="Ficha do Jogador" trilha="Sistema · Personagem" />
    <div
      style="
        display: grid;
        grid-template-columns: 220px 1fr;
        gap: 14px;
        margin-top: 14px;
      "
    >
      <div class="card" style="padding: 16px; text-align: center">
        <img
          v-if="foto"
          :src="foto"
          :alt="'Retrato de ' + (auth.personagem?.nome || 'personagem')"
          style="
            width: 100%;
            aspect-ratio: 1/1;
            object-fit: cover;
            border-radius: 10px;
            border: 2px solid var(--gold-dim);
          "
        />
        <div
          v-else
          style="
            width: 100%;
            aspect-ratio: 1/1;
            border-radius: 10px;
            border: 2px dashed var(--line);
            display: grid;
            place-items: center;
            color: var(--ink-faint);
            font-size: 60px;
          "
        >
          👤
        </div>
        <div style="margin-top: 10px">
          <div
            style="font-weight: 700; color: var(--gold-bright); font-size: 18px"
          >
            {{ auth.personagem.nome }}
          </div>
          <div
            style="
              font-family: var(--f-mono);
              font-size: 11px;
              letter-spacing: 0.1em;
              text-transform: uppercase;
              color: var(--violet);
              margin-top: 3px;
            "
          >
            {{ auth.personagem.guilda || "Independente" }}
          </div>
          <div
            style="
              margin-top: 10px;
              display: grid;
              gap: 4px;
              font-size: 12.5px;
              color: var(--ink-dim);
            "
          >
            <div v-if="auth.personagem.discord_nome">
              💬 Discord: {{ auth.personagem.discord_nome }}
            </div>
            <div v-if="auth.personagem.discord_email">
              📧 Discord Email: {{ auth.personagem.discord_email }}
            </div>
          </div>
        </div>
      </div>
      <div class="card">
        <h3 style="margin: 0 0 10px; color: var(--gold-bright)">Atributos</h3>
        <div
          class="form"
          style="padding: 0; border: none; background: transparent"
        >
          <div class="atributos">
            <div
              v-for="a in atributos"
              :key="a.k"
              class="atrib"
              :class="a.v > 0 ? 'pos' : a.v < 0 ? 'neg' : ''"
            >
              <b>{{ a.nome }}</b>
              <div class="v">{{ a.v > 0 ? "+" : "" }}{{ a.v }}</div>
            </div>
          </div>
        </div>
        <div
          style="
            margin-top: 14px;
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
          "
        >
          <div style="display: flex; gap: 6px; flex-wrap: wrap; align-items: center">
            <span class="pill on" style="display: inline-flex; align-items: center; gap: 6px">
              <IconeArma v-if="armaDetalhe" :tipo="armaDetalhe.tipo" :raridade="armaDetalhe.raridade" :tamanho="18" />
              <template v-else>⚔️</template>
              {{ armaAtual }}
            </span>
            <span class="pill" style="display: inline-flex; align-items: center; gap: 6px">
              <IconeProfissao v-if="auth.personagem.profissao" :profissao="auth.personagem.profissao" :tamanho="18" />
              <template v-else>🛠️</template>
              {{ auth.personagem.profissao || "Sem profissão" }}
            </span>
            <span class="pill rar-comum"
              >💨 Fôlego {{ auth.personagem.folego ?? 0 }} / 20</span
            >
            <span class="pill rar-raro">💵 {{ totalCol }} Col</span>
          </div>
          <router-link
            to="/equipamentos"
            class="btn primario"
            style="text-decoration: none"
            >🎒 Equipamentos · Stash</router-link
          >
        </div>
        <h3 style="margin: 18px 0 10px; color: var(--gold-bright)">Sobre</h3>
        <div
          style="
            display: grid;
            gap: 8px;
            font-size: 13.5px;
            color: var(--ink-dim);
          "
        >
          <div>
            <b style="color: var(--ink)">Conceito:</b>
            {{ auth.personagem.conceito || "—" }}
          </div>
          <div>
            <b style="color: var(--ink)">Aparência:</b>
            {{ auth.personagem.aparencia || "—" }}
          </div>
        </div>
        <h3 style="margin: 18px 0 10px; color: var(--gold-bright)">Reputação</h3>
        <div v-if="carregandoRep" class="msg info carregando">Carregando…</div>
        <div v-else-if="!reputacoes.length" class="msg warn">
          Nenhuma reputação registrada ainda — sobe conforme você ajuda cidades, vilas, NPCs e o mestre reconhece.
        </div>
        <div v-else style="display:flex;gap:8px;flex-wrap:wrap">
          <span v-for="r in reputacoes" :key="r.alvo_nome" class="pill" :class="{on: r.nivel>0, bad: r.nivel<0}">
            {{ r.alvo_nome }} · {{ r.nivel }} ({{ statusRep(r.nivel) }})
          </span>
        </div>
        <h3 style="margin: 18px 0 10px; color: var(--gold-bright)">🗡️ Golpes da Arma · {{ armaDetalhe?.tipo || armaAtual }}</h3>
        <div v-if="carregandoGolpes" class="msg info carregando">Carregando…</div>
        <div v-else-if="!golpesArma.length" class="msg warn">Sem arma equipada ou sem golpes cadastrados ainda.</div>
        <div v-else style="display:flex;flex-direction:column;gap:8px">
          <div v-for="g in golpesArma" :key="g.nome" class="card" style="background:var(--panel);border:none">
            <div class="ct">{{ g.nome }} <span v-if="g.bonus" class="pill on">{{ g.bonus }}</span></div>
            <p style="font-style:italic;color:var(--ink-dim);margin:4px 0">{{ g.gatilho }}</p>
            <div v-if="g.dezMais.length" style="font-size:13px;margin-top:4px"><b style="color:#62c56a">10+</b> {{ g.dezMais.join(" · ") }}</div>
            <div v-if="g.seteNove.length" style="font-size:13px;margin-top:4px"><b style="color:#d9ad5e">7-9</b> {{ g.seteNove.join(" · ") }}</div>
            <div v-if="g.seisMenos.length" style="font-size:13px;margin-top:4px"><b style="color:#e0887a">6-</b> {{ g.seisMenos.join(" · ") }}</div>
          </div>
        </div>

        <h3 style="margin: 18px 0 10px; color: var(--gold-bright)">🛠️ Golpes de Profissão · {{ auth.personagem?.profissao || "—" }}</h3>
        <div v-if="carregandoGolpes" class="msg info carregando">Carregando…</div>
        <div v-else-if="!golpesProfissao.length" class="msg warn">Sem profissão definida ou sem golpes cadastrados ainda.</div>
        <div v-else style="display:flex;flex-direction:column;gap:8px">
          <div v-for="g in golpesProfissao" :key="g.nome" class="card" style="background:var(--panel);border:none">
            <div class="ct">{{ g.nome }} <span v-if="g.bonus" class="pill on">{{ g.bonus }}</span></div>
            <p style="font-style:italic;color:var(--ink-dim);margin:4px 0">{{ g.gatilho }}</p>
            <div v-if="g.dezMais.length" style="font-size:13px;margin-top:4px"><b style="color:#62c56a">10+</b> {{ g.dezMais.join(" · ") }}</div>
            <div v-if="g.seteNove.length" style="font-size:13px;margin-top:4px"><b style="color:#d9ad5e">7-9</b> {{ g.seteNove.join(" · ") }}</div>
            <div v-if="g.seisMenos.length" style="font-size:13px;margin-top:4px"><b style="color:#e0887a">6-</b> {{ g.seisMenos.join(" · ") }}</div>
          </div>
        </div>

        <h3 style="margin: 18px 0 10px; color: var(--gold-bright)">Limit Breaker</h3>
        <p style="margin:0 0 8px;color:var(--ink-dim);font-size:12.5px">Contador por arma — ferramenta de mesa, o mestre marca durante o jogo.</p>
        <div v-if="!limitBreakers.length" class="msg warn">Nenhum contador ainda.</div>
        <div v-else style="display:flex;gap:8px;flex-wrap:wrap">
          <span v-for="lb in limitBreakers" :key="lb.arma_tipo" class="pill" :class="{on: lb.contador>=10}">
            {{ lb.arma_tipo }} · {{ lb.contador }}/10{{ lb.contador>=10 ? ' ⚡' : '' }}
          </span>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { computed, onMounted, ref } from "vue";
import { useAuthStore } from "../stores/auth.js";
import { useSupa } from "../lib/supabase.js";
import StatusBar from "../components/StatusBar.vue";
import TituloHUD from "../components/TituloHUD.vue";
import IconeArma from "../components/IconeArma.vue";
import IconeProfissao from "../components/IconeProfissao.vue";
const auth = useAuthStore();
const supa = useSupa();
defineEmits(["pedir-login"]);
const reputacoes = ref([]);
const carregandoRep = ref(true);
function statusRep(v) {
  return v >= 3 ? "Protegido" : v >= 1 ? "Favor" : v <= -3 ? "Bloqueado" : v <= -1 ? "Suspeita" : "Neutro";
}
async function carregarReputacoes() {
  if (!auth.temPersonagem) return;
  carregandoRep.value = true;
  try {
    const r = await supa
      .from("reputacao_personagem")
      .select("*")
      .eq("personagem_nome", auth.personagem.nome)
      .order("alvo_nome");
    reputacoes.value = r.data || [];
  } catch (e) {
    console.warn(e);
  } finally {
    carregandoRep.value = false;
  }
}
const limitBreakers = ref([]);
async function carregarLimitBreakers() {
  if (!auth.temPersonagem) return;
  try {
    const r = await supa
      .from("limit_breaker_contador")
      .select("*")
      .eq("personagem_nome", auth.personagem.nome)
      .order("arma_tipo");
    limitBreakers.value = r.data || [];
  } catch (e) {
    console.warn(e);
  }
}
const ATTR = {
  tecnica: "Técnica",
  espirito: "Espírito",
  conhecimento: "Conhecimento",
  reflexo: "Reflexo",
  corpo: "Corpo",
};
const atributos = computed(() =>
  Object.keys(ATTR).map((k) => ({
    k,
    nome: ATTR[k],
    v:
      auth.personagem && auth.personagem.atributos
        ? auth.personagem.atributos[k] || 0
        : 0,
  })),
);
const foto = computed(
  () => auth.personagem?.foto_url || auth.perfil?.foto_url || "",
);
const totalCol = computed(
  () => (auth.personagem?.col_mao || 0) + (auth.personagem?.col_guardado || 0),
);
const ARMAS_NOMES = {
  foice_de_ferro: "Foice de Ferro",
  foice_de_fero: "Foice de Ferro",
  espada_curta: "Espada Curta",
  espada_long: "Espada Longa",
  espada_longa: "Espada Longa",
  espada_dupla_mao: "Espada de Duas Mãos",
  espada_grande: "Espada Grande",
  cajado_curto: "Cajado Curto",
  cajado_longo: "Cajado Longo",
  cajado_arcano: "Cajado Arcano",
  machado_batalha: "Machado de Batalha",
  machado_grande: "Machado Grande",
  arco_curto: "Arco Curto",
  arco_longo: "Arco Longo",
  besta: "Besta",
  katana: "Katana",
  katana_bastarda: "Katana Bastarda",
  martelo_guerra: "Martelo de Guerra",
  martelo_grande: "Martelo Grande",
  lanca_curta: "Lança Curta",
  lanca_longa: "Lança Longa",
  adaga: "Adaga",
  adaga_dupla: "Adaga Dupla",
  chicote: "Chicote",
  lanca_harpoa: "Lança Harpão",
  lamina_verde: "Lâmina Verde",
  foice_prateada: "Foice Prateada",
  cajado_rubi: "Cajado de Rubi",
  espada_de_ferro: "Espada de Ferro",
  espada_de_madeira: "Espada de Madeira",
  bastao_carvao_verde: "Bastão de Carvão Verde",
};
const armaAtual = computed(() => {
  const i = auth.personagem?.arma;
  if (!i) return "Mão vazia";
  if (ARMAS_NOMES[i]) return ARMAS_NOMES[i];
  return String(i)
    .replace(/[-_]+/g, " ")
    .trim()
    .replace(/\b\w/g, (l) => l.toUpperCase());
});
const armaDetalhe = ref(null); // {tipo,raridade} da arma equipada — pro ícone colorido junto do pill
async function carregarArmaDetalhe() {
  armaDetalhe.value = null;
  const id = auth.personagem?.arma;
  if (!id) return;
  try {
    const r = await supa.from("armas").select("tipo,raridade").eq("id", id).maybeSingle();
    armaDetalhe.value = r.data || null;
  } catch (e) {
    console.warn(e);
  }
}

// ===== Golpes (arma + profissão) — normaliza os dois formatos de JSON
// que moves_arma/moves_profissao usam (lista de 5 opções nas armas e nas
// 15 profissões com Move Exclusivo; texto corrido no Move de Ofício/Cena
// mais antigo) num shape só pra exibir. =====
const carregandoGolpes = ref(true);
const golpesArma = ref([]);
const golpesProfissao = ref([]);
function normalizarGolpe(g) {
  if (!g || !g.nome) return null;
  const paraLista = (v) => (Array.isArray(v) ? v : v ? [v] : []);
  return {
    nome: g.nome,
    gatilho: g.gatilho || "",
    bonus: g.bonus_acerto || "",
    dezMais: paraLista(g.dez_mais),
    seteNove: paraLista(g.sete_nove),
    seisMenos: paraLista(g.seis_menos),
  };
}
async function carregarGolpes() {
  carregandoGolpes.value = true;
  try {
    const [rArma, rProf] = await Promise.all([
      armaDetalhe.value?.tipo
        ? supa.from("moves_arma").select("move_a,golpe_2,limit_breaker").eq("nome", armaDetalhe.value.tipo).eq("visivel", true).maybeSingle()
        : Promise.resolve({ data: null }),
      auth.personagem?.profissao
        ? supa.from("moves_profissao").select("move_a,move_b,move_c").eq("nome", auth.personagem.profissao).eq("visivel", true).maybeSingle()
        : Promise.resolve({ data: null }),
    ]);
    golpesArma.value = rArma.data
      ? [normalizarGolpe(rArma.data.move_a), normalizarGolpe(rArma.data.golpe_2), normalizarGolpe(rArma.data.limit_breaker)].filter(Boolean)
      : [];
    golpesProfissao.value = rProf.data
      ? [normalizarGolpe(rProf.data.move_a), normalizarGolpe(rProf.data.move_b), normalizarGolpe(rProf.data.move_c)].filter(Boolean)
      : [];
  } catch (e) {
    console.warn(e);
  } finally {
    carregandoGolpes.value = false;
  }
}

onMounted(async () => {
  if (!auth.ready) await auth.init();
  await Promise.all([carregarReputacoes(), carregarLimitBreakers(), carregarArmaDetalhe()]);
  await carregarGolpes(); // depende de armaDetalhe já carregado
});
</script>
