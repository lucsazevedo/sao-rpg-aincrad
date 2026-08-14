import { createApp } from "vue";
import { createPinia } from "pinia";
import { createRouter, createWebHashHistory } from "vue-router";
import App from "./App.vue";
import { useAuthStore } from "./stores/auth.js";

import "./styles/main.css";

// Aba aberta durante um deploy novo: cada deploy troca o hash dos arquivos
// (build do Vite), então um chunk lazy (rota, ex. Equipamentos.vue) que a
// aba antiga tenta buscar já não existe mais no servidor -- 404 ->
// "Failed to fetch dynamically imported module". Vite dispara esse evento
// nesse caso específico; a correção padrão é recarregar a página inteira
// (busca o index.html novo, com os hashes certos). Guard de sessionStorage
// evita loop infinito se o erro for outra coisa (ex. offline de verdade).
window.addEventListener("vite:preloadError", () => {
  const chave = "sao-rpg-reload-apos-preload-error";
  if (sessionStorage.getItem(chave)) return; // já tentou recarregar nesta sessão, não repete
  sessionStorage.setItem(chave, "1");
  window.location.reload();
});

const router = createRouter({
  history: createWebHashHistory(),
  routes: [
    {
      // Hub de Aincrad, item 1 do doc: Notícias vira a primeira página do
      // site. A Home antiga (Craft em destaque) não some, só muda de rota.
      path: "/",
      component: () => import("./views/Noticias.vue"),
      meta: { title: "Notícias de Aincrad" },
    },
    {
      path: "/inicio",
      component: () => import("./views/Home.vue"),
      meta: { title: "Início" },
    },
    {
      path: "/estado",
      component: () => import("./views/EstadoAincrad.vue"),
      meta: { title: "Estado de Aincrad" },
    },
    {
      path: "/andares",
      component: () => import("./views/Andares.vue"),
      meta: { title: "Andares" },
    },
    {
      path: "/evento-global",
      component: () => import("./views/EventoGlobal.vue"),
      meta: { title: "Evento Global" },
    },
    {
      path: "/guildas",
      component: () => import("./views/Guildas.vue"),
      meta: { title: "Guildas & Clãs" },
    },
    {
      path: "/diario",
      component: () => import("./views/Diario.vue"),
      meta: { title: "Diário de Aincrad" },
    },
    {
      path: "/ficha",
      component: () => import("./views/Ficha.vue"),
      meta: { title: "Minha Ficha" },
    },
    {
      path: "/tarefas",
      component: () => import("./views/Tarefas.vue"),
      meta: { title: "Tarefas", requerJogador: true },
    },
    {
      path: "/profissoes",
      component: () => import("./views/Profissoes.vue"),
      meta: { title: "Profissões & Craft" },
    },
    {
      path: "/compendio",
      component: () => import("./views/Compendio.vue"),
      meta: { title: "Compêndio" },
    },
    {
      path: "/equipamentos",
      component: () => import("./views/Equipamentos.vue"),
      meta: { title: "Equipamentos · Stash" },
    },
    {
      path: "/combate",
      component: () => import("./views/Combate.vue"),
      meta: { title: "Combate Livre", requerJogador: true },
    },
    {
      path: "/cooperacao",
      component: () => import("./views/Cooperacao.vue"),
      meta: { title: "Cooperação", requerJogador: true },
    },
    {
      path: "/pets",
      component: () => import("./views/PetsTab.vue"),
      meta: { title: "Ovos & Pets", requerJogador: true },
    },
    {
      path: "/mercado",
      component: () => import("./views/Mercado.vue"),
      meta: { title: "Mercado" },
    },
    {
      path: "/mestre",
      component: () => import("./views/Mestre.vue"),
      meta: { title: "Painel do Mestre" },
    },
    {
      path: "/mestre-login",
      component: () => import("./views/MestreLogin.vue"),
      meta: { title: "Acesso do Mestre" },
    },
  ],
});

router.beforeEach(async (to) => {
  const auth = useAuthStore();
  if (!auth.ready) await auth.init();
  if (to.meta.requerJogador && !auth.logado) return { path: "/" };
  if (to.path === "/mestre" && !auth.logado) return { path: "/mestre-login" };
  document.title =
    (to.meta.title ? to.meta.title + " · " : "") + "SAO RPG · Aincrad";
});

const app = createApp(App);
app.use(createPinia());
app.use(router);
app.mount("#app");
// app montou com sucesso -> limpa o guard, senão um preload error futuro
// nesta mesma aba (outro deploy, mesma sessão) ficaria bloqueado pra sempre.
sessionStorage.removeItem("sao-rpg-reload-apos-preload-error");
