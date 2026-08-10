import { createApp } from "vue";
import { createPinia } from "pinia";
import { createRouter, createWebHashHistory } from "vue-router";
import App from "./App.vue";
import { useAuthStore } from "./stores/auth.js";

import "./styles/main.css";

const router = createRouter({
  history: createWebHashHistory(),
  routes: [
    {
      path: "/",
      component: () => import("./views/Home.vue"),
      meta: { title: "Início" },
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
