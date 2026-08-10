<template>
  <div class="shell">
    <nav class="nav">
      <router-link to="/" class="brand">
        🗡️ SAO RPG
        <small>Aincrad · Andar 1</small>
      </router-link>
      <div class="nav-links">
        <router-link to="/compendio" class="nav-link">Compêndio</router-link>
        <router-link to="/ficha" class="nav-link">Ficha</router-link>
        <router-link to="/tarefas" class="nav-link">Tarefas</router-link>
        <router-link to="/combate" class="nav-link">Combate</router-link>
        <router-link to="/cooperacao" class="nav-link">Cooperação</router-link>
        <router-link to="/pets" class="nav-link">Pets</router-link>
        <router-link to="/profissoes" class="nav-link">Profissões</router-link>
        <router-link to="/equipamentos" class="nav-link"
          >Equipamentos</router-link
        >
        <router-link to="/mercado" class="nav-link">Mercado</router-link>
        <router-link to="/mestre" v-if="auth.ehMestre" class="nav-link"
          >Mestre</router-link
        >
      </div>
      <div class="spacer"></div>
      <span v-if="!auth.ready" class="pill">⏳ carregando…</span>
      <template v-else>
        <span v-if="auth.logado && auth.temPersonagem" class="pill on">
          <img
            v-if="auth.foto"
            :src="auth.foto"
            alt=""
            style="
              width: 20px;
              height: 20px;
              border-radius: 50%;
              border: 1px solid var(--gold-dim);
              object-fit: cover;
            "
          />
          👤 {{ auth.nomeMostrar }}
        </span>
        <span
          v-else-if="auth.logado && !auth.temPersonagem && !auth.ehMestre"
          class="pill bad"
        >
          ⚠️ Sem ficha · fale com mestre
        </span>
        <span v-else-if="auth.ehMestre" class="pill on">🧙 Mestre</span>
        <button v-if="auth.logado" class="btn ghost" @click="sair">Sair</button>
      </template>
    </nav>
    <LoginModal
      v-if="mostrarLogin"
      @fechar="mostrarLogin = false"
      @ok="mostrarLogin = false"
    />
    <router-view v-slot="{ Component }">
      <keep-alive>
        <component :is="Component" @pedir-login="mostrarLogin = true" />
      </keep-alive>
    </router-view>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useAuthStore } from "./stores/auth.js";
import LoginModal from "./components/LoginModal.vue";
const auth = useAuthStore();
const mostrarLogin = ref(false);
onMounted(async () => {
  await auth.init();
});
async function sair() {
  await auth.logout();
  location.hash = "#/";
}
</script>
