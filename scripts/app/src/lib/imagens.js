// As colunas "img" (monstros/armas/equipamentos/npcs...) guardam caminho
// relativo do site estático antigo (ex: "imagens/monstro_slime.png"), que
// só resolvia porque aquele HTML rodava direto da raiz do repo. O app Vue
// mora em GitHub Pages, com base path próprio — o caminho relativo não
// aponta pra lugar nenhum lá. As imagens continuam commitadas no repo
// (pasta imagens/, 223 arquivos, ~340MB — pesado demais pra rebundlar no
// build do Vite), então servimos direto do GitHub via raw.githubusercontent.
//
// Se algum dia um campo "img" vier com URL já absoluta (http/https —
// ex: se trocar pra Supabase Storage no futuro), essa função não mexe
// nela, só resolve o caminho relativo legado.
const BASE_RAW = "https://raw.githubusercontent.com/lucsazevedo/sao-rpg-aincrad/main/";

export function urlImagem(caminho) {
  if (!caminho) return "";
  if (/^https?:\/\//i.test(caminho)) return caminho;
  return BASE_RAW + caminho.replace(/^\/+/, "");
}
