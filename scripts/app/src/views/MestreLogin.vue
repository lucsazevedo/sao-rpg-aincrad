<template>
  <div class="ml-shell">
    <div class="ml-card">
      <div class="ml-brand">
        <div class="ml-crest">👑</div>
        <div>
          <h1>Portal do Mestre</h1>
          <p>Acesso restrito · Aincrad · Andar 1</p>
        </div>
      </div>

      <!-- já logado, mas não é mestre -->
      <div v-if="auth.logado && !auth.ehMestre" class="ml-body">
        <div class="msg erro">
          ⛔ A conta <b>{{ auth.user?.email }}</b> está logada, mas não tem papel de mestre nesta mesa.
        </div>
        <div class="ml-actions">
          <button class="btn" @click="trocarConta">🔁 Entrar com outra conta</button>
          <router-link class="btn ghost" to="/inicio">🏠 Voltar para Início</router-link>
        </div>
      </div>

      <!-- formulário -->
      <form v-else class="ml-body" @submit.prevent="entrar">
        <div class="c">
          <label for="ml-em">E-mail do mestre</label>
          <input
            id="ml-em"
            ref="campoEmail"
            v-model.trim="email"
            type="email"
            autocomplete="username"
            placeholder="mestre@exemplo.com"
            :disabled="carregando"
          />
        </div>
        <div class="c">
          <label for="ml-pw">Senha</label>
          <div class="ml-pw-wrap">
            <input
              id="ml-pw"
              v-model="senha"
              :type="mostrarSenha ? 'text' : 'password'"
              autocomplete="current-password"
              placeholder="••••••••"
              :disabled="carregando"
            />
            <button
              type="button"
              class="ml-eye"
              :aria-label="mostrarSenha ? 'Ocultar senha' : 'Mostrar senha'"
              @click="mostrarSenha = !mostrarSenha"
            >
              {{ mostrarSenha ? "🙈" : "👁️" }}
            </button>
          </div>
        </div>
        <label class="ml-remember">
          <input type="checkbox" v-model="lembrar" />
          Lembrar meu e-mail neste dispositivo
        </label>

        <div v-if="erro" class="msg erro">⚠️ {{ erro }}</div>

        <button class="btn primario ml-submit" type="submit" :disabled="carregando || !email || !senha">
          {{ carregando ? "Entrando…" : "🔑 Entrar como Mestre" }}
        </button>

        <div class="ml-foot">
          <router-link to="/">← Voltar para a área do jogador</router-link>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from "../stores/auth.js";

const auth = useAuthStore();
const router = useRouter();

const CHAVE_LEMBRAR = "sao-rpg:ultimo-email-mestre";

const email = ref("");
const senha = ref("");
const erro = ref("");
const carregando = ref(false);
const mostrarSenha = ref(false);
const lembrar = ref(true);
const campoEmail = ref(null);

onMounted(async () => {
  if (!auth.ready) await auth.init();
  if (auth.logado && auth.ehMestre) {
    router.replace("/mestre");
    return;
  }
  const salvo = localStorage.getItem(CHAVE_LEMBRAR);
  if (salvo) email.value = salvo;
  await nextTick();
  campoEmail.value?.focus();
});

async function entrar() {
  erro.value = "";
  if (!email.value || !senha.value) {
    erro.value = "Preencha e-mail e senha.";
    return;
  }
  carregando.value = true;
  try {
    await auth.login(email.value, senha.value);
    if (!auth.ehMestre) {
      erro.value = "Login feito, mas essa conta não tem papel de mestre nesta mesa.";
      await auth.logout();
      return;
    }
    if (lembrar.value) localStorage.setItem(CHAVE_LEMBRAR, email.value);
    else localStorage.removeItem(CHAVE_LEMBRAR);
    router.replace("/mestre");
  } catch (e) {
    erro.value = "Credenciais inválidas. Confira e-mail e senha.";
  } finally {
    carregando.value = false;
  }
}

async function trocarConta() {
  await auth.logout();
  senha.value = "";
  erro.value = "";
  await nextTick();
  campoEmail.value?.focus();
}
</script>

<style scoped>
.ml-shell {
  min-height: 70vh;
  display: grid;
  place-items: center;
  padding: 24px 12px;
}
.ml-card {
  width: 100%;
  max-width: 420px;
  background: linear-gradient(180deg, #1a1030 0%, #0c0818 100%);
  border: 1px solid #332a4d;
  border-radius: 14px;
  box-shadow: 0 30px 90px rgba(0, 0, 0, 0.5);
  overflow: hidden;
}
.ml-brand {
  display: flex;
  gap: 14px;
  align-items: center;
  padding: 26px 26px 20px;
  border-bottom: 1px solid #332a4d;
  background: rgba(122, 90, 184, 0.1);
}
.ml-crest {
  font-size: 40px;
  line-height: 1;
  filter: drop-shadow(0 0 10px rgba(217, 173, 94, 0.4));
}
.ml-brand h1 {
  margin: 0;
  font-size: 20px;
  color: #e6e2ff;
}
.ml-brand p {
  margin: 3px 0 0;
  font-size: 12px;
  color: #9d90c0;
  font-family: var(--f-mono);
  letter-spacing: 0.05em;
}
.ml-body {
  padding: 24px 26px 26px;
  display: grid;
  gap: 14px;
}
.ml-body .c {
  display: grid;
  gap: 6px;
}
.ml-body label {
  font-family: var(--f-mono);
  font-size: 11px;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #b8a8db;
}
.ml-body input[type="email"],
.ml-body input[type="password"],
.ml-body input[type="text"] {
  width: 100%;
  background: #1a1526;
  border: 1px solid #332a4d;
  color: #e6e2ff;
  padding: 11px 12px;
  border-radius: 8px;
  font: inherit;
  outline: none;
}
.ml-body input:focus {
  border-color: #7a5ab8;
}
.ml-pw-wrap {
  position: relative;
  display: flex;
}
.ml-pw-wrap input {
  flex: 1;
  padding-right: 42px !important;
}
.ml-eye {
  position: absolute;
  right: 4px;
  top: 4px;
  bottom: 4px;
  width: 34px;
  border: none;
  background: transparent;
  cursor: pointer;
  font-size: 15px;
  border-radius: 6px;
}
.ml-eye:hover {
  background: rgba(122, 90, 184, 0.2);
}
.ml-remember {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 12.5px;
  color: #b8a8db;
  cursor: pointer;
  user-select: none;
}
.ml-submit {
  justify-content: center;
  font-size: 13px;
  padding: 12px 14px;
}
.ml-foot {
  text-align: center;
  font-size: 12.5px;
  margin-top: 4px;
}
.ml-foot a {
  color: #9d90c0;
  text-decoration: none;
}
.ml-foot a:hover {
  color: #c9b8ff;
}
.ml-actions {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}
.msg.erro {
  border-color: #a35454;
  color: #e0887a;
  background: rgba(163, 84, 84, 0.12);
  padding: 10px 12px;
  border-radius: 8px;
  font-size: 13px;
  border-width: 1px;
  border-style: solid;
}
</style>
