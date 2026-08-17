<template>
  <div>
    <section class="hero">
      <!-- Aincrad — o castelo-ilha flutuante cônico, a silhueta mais
           reconhecível da obra. Decorativo, aria-hidden. -->
      <svg class="hero-aincrad" viewBox="0 0 260 200" aria-hidden="true">
        <defs>
          <linearGradient id="aincradGrad" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stop-color="var(--laranja)" stop-opacity=".9"/>
            <stop offset="100%" stop-color="var(--azul)" stop-opacity=".5"/>
          </linearGradient>
        </defs>
        <g fill="url(#aincradGrad)">
          <polygon points="130,8 178,52 82,52" />
          <polygon points="118,58 190,96 46,96" />
          <polygon points="104,102 208,148 0,148" />
        </g>
        <ellipse cx="104" cy="160" rx="118" ry="9" fill="var(--azul)" opacity=".22" />
      </svg>
      <div>
        <h1>Seja bem-vindo a Aincrad</h1>
        <!-- ITEM 9: Home principal só mostra CRAFT como opção principal -->
        <p>
          Use o Craft para criar itens, ferramentas e equipamentos. Faça missões
          primeiro para juntar materiais — eles são a base de tudo no Andar 1.
        </p>
      </div>
      <div
        style="
          display: flex;
          gap: 10px;
          flex-wrap: wrap;
          justify-content: flex-end;
        "
      >
        <router-link v-if="!auth.logado" to="/cadastro" class="btn primario"
          >📝 Criar conta</router-link
        >
        <button
          v-if="!auth.logado"
          class="btn ghost"
          @click="$emit('pedir-login')"
        >
          🔑 Entrar
        </button>
        <router-link v-if="auth.logado" to="/profissoes" class="btn primario"
          >🛠️ Ir para o Craft</router-link
        >
      </div>
    </section>
    <section v-if="auth.logado">
      <StatusBar />
    </section>
    <section style="margin-top: 18px">
      <h3 style="color: var(--gold-bright); margin: 4px 0 12px">
        O que fazer agora
      </h3>
      <div class="grid">
        <router-link
          v-if="auth.ready && !auth.temPersonagem"
          to="/cadastro"
          class="card"
          style="
            text-decoration: none;
            color: inherit;
            border-color: var(--gold-bright);
            border-width: 2px;
            background: linear-gradient(135deg, #2a2512 0%, #1a1208 100%);
            grid-column: 1 / -1;
          "
        >
          <div class="ct" style="color: var(--gold-bright); font-size: 22px">
            📝 Criar Personagem
          </div>
          <div class="cs">Comece agora · autocadastro aberto</div>
          <p>
            Crie sua conta e sua ficha de aventureiro — nome, profissão, arma
            e atributos. Leva menos de dois minutos.
          </p>
        </router-link>
        <!-- PRINCIPAL (ITEM 9): SÓ CRAFT fica em DESTAQUE GRANDE -->
        <router-link
          to="/profissoes"
          class="card"
          style="
            text-decoration: none;
            color: inherit;
            border-color: var(--gold-bright);
            border-width: 2px;
            background: linear-gradient(135deg, #2a2512 0%, #1a1208 100%);
            grid-column: 1 / -1;
          "
        >
          <div class="ct" style="color: var(--gold-bright); font-size: 22px">
            🛠️ Oficina de Craft · Profissões
          </div>
          <div class="cs">
            Funcionalidade principal · 16 profissões · 128 receitas
          </div>
          <p>
            Todas as suas receitas, materiais no inventário e pets/ovos ficam
            aqui. Por padrão, só aparecem as receitas que você consegue craftar
            no momento.
          </p>
        </router-link>
        <!-- Outros (menores, complementares) -->
        <router-link
          to="/tarefas"
          class="card"
          style="text-decoration: none; color: inherit"
        >
          <div class="ct">⚔️ Missões Diárias</div>
          <div class="cs">4 tipos · de Coleta a Contratos</div>
          <p>
            Junte materiais, ganhe XP de profissão e Col para sobreviver no
            início do Andar 1.
          </p>
        </router-link>
        <router-link
          to="/equipamentos"
          class="card"
          style="text-decoration: none; color: inherit"
        >
          <div class="ct">🎒 Equipamentos · Stash</div>
          <div class="cs">Inventário pessoal · Baú geral</div>
          <p>
            Gerencie armas, armaduras equipadas, itens na mochila e materiais
            guardados no Stash da vila.
          </p>
        </router-link>
        <router-link
          to="/ficha"
          class="card"
          style="text-decoration: none; color: inherit"
        >
          <div class="ct">👤 Minha Ficha</div>
          <div class="cs">Atributos · Arma · Profissão</div>
          <p>
            Seu personagem, atributos, fôlego, conceito e aparência do
            aventureiro.
          </p>
        </router-link>
        <router-link
          v-if="auth.ehMestre"
          to="/mestre"
          class="card"
          style="
            text-decoration: none;
            color: inherit;
            border-color: var(--gold-dim);
          "
        >
          <div class="ct" style="color: var(--gold-bright)">
            🧙 Painel do Mestre
          </div>
          <div class="cs">Criar personagens</div>
          <p>
            Cadastre um jogador: nome, foto, discord, email e profissão — o
            sistema gera uma senha forte e mostra pra você copiar e colar no
            Discord.
          </p>
        </router-link>
      </div>
    </section>
  </div>
</template>
<script setup>
import { onMounted } from "vue";
import { useAuthStore } from "../stores/auth.js";
import StatusBar from "../components/StatusBar.vue";
const auth = useAuthStore();
defineEmits(["pedir-login"]);
onMounted(async () => {
  if (!auth.ready) await auth.init();
});
</script>
