<!-- Barra de título "janela de sistema" — troca o padrão antigo de
     <h2 style="color:var(--gold-bright)"> espalhado em cada view por um
     único componente: ícone + título + trilha mono opcional (tipo
     "SISTEMA · COMBATE"), acento lateral laranja, igual a barra de topo
     de uma janela do menu do jogo. -->
<template>
  <div class="titulo-hud">
    <span v-if="icone" class="ico">{{ icone }}</span>
    <div>
      <h2>{{ titulo }}</h2>
      <small v-if="trilha">{{ trilha }}</small>
    </div>
  </div>
</template>
<script setup>
defineProps({ icone: { type: String, default: "" }, titulo: { type: String, required: true }, trilha: { type: String, default: "" } });
</script>
<style scoped>
.titulo-hud{
  display:flex;align-items:center;gap:12px;
  margin:6px 0 16px;padding:10px 6px 10px 14px;
  border-left:3px solid var(--laranja);
  background:linear-gradient(90deg, rgba(255,153,0,0.09), transparent 65%);
}
.titulo-hud .ico{font-size:23px;line-height:1;filter:drop-shadow(0 0 8px rgba(255,153,0,0.35))}
.titulo-hud h2{margin:0;font-size:21px;color:var(--ink)}
.titulo-hud small{
  display:block;font-family:var(--f-mono);font-size:10.5px;letter-spacing:.18em;
  text-transform:uppercase;color:var(--azul-bright);margin-top:3px;
}
</style>
