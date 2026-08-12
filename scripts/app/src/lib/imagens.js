import { useSupa } from "./supabase.js";

// As colunas "img" (monstros/armas/equipamentos/npcs...) guardam caminho
// relativo do site estático antigo (ex: "imagens/monstro_slime.png"), que
// só resolvia porque aquele HTML rodava direto da raiz do repo. O app Vue
// mora em GitHub Pages, com base path próprio — o caminho relativo não
// aponta pra lugar nenhum lá. As imagens continuam commitadas no repo
// (pasta imagens/, 223 arquivos, ~340MB — pesado demais pra rebundlar no
// build do Vite), então servimos direto do GitHub via raw.githubusercontent.
//
// Se algum dia um campo "img" vier com URL já absoluta (http/https — ex:
// upload novo, ver enviarImagem() abaixo), essa função não mexe nela, só
// resolve o caminho relativo legado.
const BASE_RAW = "https://raw.githubusercontent.com/lucsazevedo/sao-rpg-aincrad/main/";

export function urlImagem(caminho) {
  if (!caminho) return "";
  if (/^https?:\/\//i.test(caminho)) return caminho;
  return BASE_RAW + caminho.replace(/^\/+/, "");
}

// Upload real pro Storage do Supabase — usado por qualquer campo tipo
// "imagem" do Compêndio do mestre (logo de clã, "img" de npcs/monstros/
// armas/equipamentos). Bucket público pra leitura, escrita só mestre
// (RLS, ver scripts/db/schema_upload_imagens_e_recrutamento_cla.sql).
// Devolve a URL pública pronta pra salvar direto na coluna.
export const BUCKET_IMAGENS = "compendio-imagens";

function slugArquivo(nome) {
  return (
    String(nome || "arquivo")
      .normalize("NFD")
      .replace(/[̀-ͯ]/g, "")
      .toLowerCase()
      .trim()
      .replace(/[^a-z0-9]+/g, "-")
      .replace(/^-+|-+$/g, "") || "arquivo"
  );
}

export async function enviarImagem(file, pasta) {
  if (!file) throw new Error("nenhum arquivo selecionado");
  if (!file.type || !file.type.startsWith("image/")) throw new Error("escolha um arquivo de imagem");
  const supa = useSupa();
  const ext = (file.name.split(".").pop() || "png").toLowerCase();
  const base = slugArquivo(file.name.replace(/\.[^.]+$/, ""));
  const caminho = `${pasta || "geral"}/${Date.now()}-${base}.${ext}`;
  const up = await supa.storage.from(BUCKET_IMAGENS).upload(caminho, file, {
    cacheControl: "3600",
    upsert: false,
  });
  if (up.error) throw up.error;
  const { data } = supa.storage.from(BUCKET_IMAGENS).getPublicUrl(up.data.path);
  return data.publicUrl;
}
