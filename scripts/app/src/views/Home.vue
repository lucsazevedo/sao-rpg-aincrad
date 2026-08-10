<template>
  <div>
    <section class="hero">
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
        <button
          v-if="!auth.logado"
          class="btn primario"
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
