<template>
  <div class="shell">
    <nav class="nav" aria-label="Navegação principal">
      <router-link to="/" class="brand" aria-label="Início — SAO RPG Aincrad">
        🗡️ SAO RPG
        <small>Aincrad · Andar 1</small>
      </router-link>
      <div class="nav-links">
        <!-- Hub de Aincrad (SAO_RPG_AINCRAD_SISTEMAS.md, item 8 — estrutura do menu).
             Notícias já é a marca (link "/"), por isso não repete aqui. -->
        <router-link to="/estado" class="nav-link"><span class="ico">📊</span>Estado</router-link>
        <router-link to="/andares" class="nav-link"><span class="ico">🏯</span>Andares</router-link>
        <router-link to="/evento-global" class="nav-link"><span class="ico">🌍</span>Evento Global</router-link>
        <router-link to="/guildas" class="nav-link"><span class="ico">🛡️</span>Guildas</router-link>
        <router-link to="/diario" class="nav-link"><span class="ico">📔</span>Diário</router-link>
        <router-link to="/inicio" class="nav-link"><span class="ico">🧭</span>Painel</router-link>
        <router-link to="/compendio" class="nav-link"><span class="ico">📚</span>Compêndio</router-link>
        <router-link to="/ficha" class="nav-link"><span class="ico">🧑</span>Ficha</router-link>
        <router-link to="/tarefas" class="nav-link"><span class="ico">📋</span>Tarefas</router-link>
        <router-link to="/combate" class="nav-link"><span class="ico">⚔️</span>Combate</router-link>
        <router-link to="/cooperacao" class="nav-link"><span class="ico">🤝</span>Cooperação</router-link>
        <router-link to="/pets" class="nav-link"><span class="ico">🥚</span>Pets</router-link>
        <router-link to="/profissoes" class="nav-link"><span class="ico">🛠️</span>Craft</router-link>
        <router-link to="/equipamentos" class="nav-link"
          ><span class="ico">🎒</span>Equipamentos</router-link
        >
        <router-link to="/mercado" class="nav-link"><span class="ico">🏪</span>Mercado</router-link>
        <router-link v-if="auth.ready && !auth.temPersonagem" to="/cadastro" class="nav-link"
          ><span class="ico">📝</span>Criar Personagem</router-link
        >
        <router-link to="/mestre" v-if="auth.ehMestre" class="nav-link"
          ><span class="ico">🧙</span>Mestre</router-link
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
        <router-link
          v-else-if="auth.logado && !auth.temPersonagem && !auth.ehMestre"
          to="/cadastro"
          class="pill bad"
        >
          ⚠️ Sem ficha · criar agora
        </router-link>
        <span v-else-if="auth.ehMestre" class="pill on">🧙 Mestre</span>
        <button v-if="auth.logado" class="btn ghost" @click="sair">Sair</button>
      </template>
    </nav>
    <div v-if="impersonando && auth.logado" class="msg warn" style="margin:0;border-radius:0;text-align:center">
      🎭 Modo pré-visualização — vendo como <b>{{ impersonando.personagem }}</b>.
      <button class="btn tiny ghost" @click="voltarASerMestre" style="margin-left:10px">🔙 Sair e voltar a logar como Mestre</button>
    </div>
    <LoginModal
      v-if="mostrarLogin"
      @fechar="mostrarLogin = false"
      @ok="mostrarLogin = false"
    />
    <main>
      <router-view v-slot="{ Component }">
        <keep-alive>
          <component :is="Component" @pedir-login="mostrarLogin = true" />
        </keep-alive>
      </router-view>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useAuthStore } from "./stores/auth.js";
import LoginModal from "./components/LoginModal.vue";
const auth = useAuthStore();
const mostrarLogin = ref(false);
// Banner de "modo pré-visualização" — ver Mestre.vue verComoJogador(). A
// flag mora em sessionStorage (sobrevive ao logout/login que a troca de
// conta faz) só pra essa aba, não vaza pra outras sessões/dispositivos.
const CHAVE_IMPERSONANDO = "sao-rpg-impersonando";
const impersonando = ref(null);
onMounted(async () => {
  const bruto = sessionStorage.getItem(CHAVE_IMPERSONANDO);
  if (bruto) { try { impersonando.value = JSON.parse(bruto); } catch (_) {} }
  await auth.init();
});
async function sair() {
  sessionStorage.removeItem(CHAVE_IMPERSONANDO);
  impersonando.value = null;
  await auth.logout();
  location.hash = "#/";
}
async function voltarASerMestre() {
  sessionStorage.removeItem(CHAVE_IMPERSONANDO);
  impersonando.value = null;
  await auth.logout();
  location.hash = "#/mestre-login";
}
</script>
