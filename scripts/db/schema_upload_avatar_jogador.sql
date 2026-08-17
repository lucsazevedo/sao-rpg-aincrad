-- Até aqui, upload de imagem (bucket compendio-imagens) era mestre-only
-- (schema_upload_imagens_e_recrutamento_cla.sql) — fazia sentido quando só
-- existia pro Compêndio. Pedido do usuário: os campos de foto de
-- personagem em telas de cadastro/edição (Cadastro.vue autocadastro,
-- "Criar Personagem" e ficha de jogador no Painel do Mestre) viram upload
-- de verdade em vez de colar URL.
--
-- Problema: em Cadastro.vue o upload precisa acontecer ANTES de
-- supa.auth.signUp() rodar (é assim que o formulário deixa escolher a foto
-- junto com o resto) — nesse momento o visitante ainda é `anon`, não
-- `authenticated`, e não existe personagem ainda pra restringir por dono.
-- Em vez de forçar um fluxo de 2 passos (criar conta, só depois trocar
-- foto), libera upload (só INSERT, nunca update/delete) pra qualquer
-- visitante — mas travado no prefixo "avatares/" do bucket, sem tocar nos
-- outros prefixos (monstros/npcs/armas/... continuam mestre-only pela
-- policy "for all" já existente). Risco aceito: base pequena/privada,
-- nome de arquivo sempre novo (timestamp), sem como sobrescrever nada.
drop policy if exists "compendio_imagens_avatares_upload_publico" on storage.objects;
create policy "compendio_imagens_avatares_upload_publico" on storage.objects for insert
  to anon, authenticated
  with check (bucket_id = 'compendio-imagens' and (storage.foldername(name))[1] = 'avatares');
