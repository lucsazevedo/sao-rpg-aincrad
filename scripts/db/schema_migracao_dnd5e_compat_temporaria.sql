-- ============================================================================
-- COMPATIBILIDADE -- autocadastrar_personagem aceita os dois formatos
-- ============================================================================
-- Histórico: quando `dnd5e-migration` ainda não tinha sido mergeada em
-- `main`, o site publicado (GitHub Pages) rodava o Cadastro.vue ANTIGO,
-- que chama autocadastrar_personagem com `p_atributos` (5 chaves PBTA) --
-- e a branch nova já tinha trocado a função pra `p_atributos_dnd` (6
-- chaves D&D), quebrando o cadastro no site ainda não atualizado.
--
-- MERGE E DEPLOY JÁ CONFIRMADOS (main, 2026-08-20) -- o Cadastro.vue no ar
-- manda `p_atributos_dnd`. Este parâmetro extra (`p_atributos`) NÃO
-- precisa mais ser removido: é opcional, sem custo, e funciona como rede
-- de segurança pra qualquer aba com o JS antigo ainda em cache do
-- navegador. Mantido por decisão, não por pendência esquecida.
--
-- Postgres não permite dois overloads com a MESMA lista de tipos (9x text +
-- 1x jsonb) só com nome de parâmetro diferente -- então em vez de overload,
-- isto ADICIONA um parâmetro opcional extra (`p_atributos`, jsonb, default
-- null) na função existente. PostgREST casa por nome de chave no corpo JSON;
-- caller antigo manda só `p_atributos` (bate o parâmetro novo, ignora
-- `p_atributos_dnd` que fica no default), caller novo manda só
-- `p_atributos_dnd` (ignora este). CREATE OR REPLACE aceita adicionar
-- parâmetro opcional no fim sem precisar DROP.
-- ============================================================================

CREATE OR REPLACE FUNCTION public.autocadastrar_personagem(
  p_nome text, p_discord_nome text, p_discord_email text,
  p_profissao text DEFAULT NULL::text, p_arma text DEFAULT NULL::text,
  p_guilda text DEFAULT NULL::text, p_conceito text DEFAULT NULL::text,
  p_aparencia text DEFAULT NULL::text, p_foto_url text DEFAULT NULL::text,
  p_atributos_dnd jsonb DEFAULT NULL::jsonb,
  p_atributos jsonb DEFAULT NULL::jsonb
)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  v_uid uuid := auth.uid();
  v_nome text := trim(coalesce(p_nome, ''));
  v_discord_nome text := trim(coalesce(p_discord_nome, ''));
  v_discord_email text := trim(coalesce(p_discord_email, ''));
  v_atributos jsonb;
  v_ca int;
  v_corpo int := coalesce((p_atributos->>'corpo')::int, 0);
  v_reflexo int := coalesce((p_atributos->>'reflexo')::int, 0);
  v_tecnica int := coalesce((p_atributos->>'tecnica')::int, 0);
  v_conhecimento int := coalesce((p_atributos->>'conhecimento')::int, 0);
  v_espirito int := coalesce((p_atributos->>'espirito')::int, 0);
begin
  if v_uid is null then return '{"erro":"não autenticado — confirme seu login e tente de novo"}'; end if;
  if v_nome = '' then return '{"erro":"informe o nome do personagem"}'; end if;
  if v_discord_nome = '' then return '{"erro":"informe o nome no Discord"}'; end if;
  if v_discord_email = '' then return '{"erro":"informe o e-mail"}'; end if;

  if exists (select 1 from personagens where dono_id = v_uid) then
    return '{"erro":"essa conta já tem um personagem cadastrado"}';
  end if;
  if exists (select 1 from personagens where nome = v_nome) then
    return '{"erro":"já existe um personagem com esse nome — escolha outro"}';
  end if;

  -- prioridade: p_atributos_dnd (Cadastro.vue novo) > converter p_atributos
  -- (Cadastro.vue antigo, ainda no ar até o merge) > distribuição padrão.
  v_atributos := coalesce(
    p_atributos_dnd,
    case when p_atributos is not null then jsonb_build_object(
      'forca', greatest(3, least(20, 10 + 2 * v_corpo)),
      'constituicao', greatest(3, least(20, 10 + 2 * v_corpo)),
      'destreza', greatest(3, least(20, 10 + 2 * greatest(v_reflexo, v_tecnica))),
      'inteligencia', greatest(3, least(20, 10 + 2 * v_conhecimento)),
      'sabedoria', greatest(3, least(20, 10 + 2 * v_espirito)),
      'carisma', greatest(3, least(20, 10 + 2 * v_espirito))
    ) end,
    jsonb_build_object('forca', 8, 'destreza', 8, 'constituicao', 10, 'inteligencia', 10, 'sabedoria', 12, 'carisma', 6)
  );
  v_ca := 10 + floor((coalesce((v_atributos->>'destreza')::int, 10) - 10) / 2.0)::int;

  insert into perfis (id, papel, nome, discord_nome, discord_email, foto_url)
    values (v_uid, 'jogador', v_nome, v_discord_nome, v_discord_email, nullif(p_foto_url, ''))
    on conflict (id) do update set
      nome = excluded.nome, discord_nome = excluded.discord_nome,
      discord_email = excluded.discord_email,
      foto_url = coalesce(excluded.foto_url, perfis.foto_url);

  insert into personagens (
    nome, dono_id, profissao, arma, guilda, atributos_dnd, nivel, ca,
    bonus_proficiencia, conceito, aparencia,
    foto_url, discord_nome, discord_email, folego, col_mao, col_guardado,
    vida_max, vida_atual, visivel, excluido
  ) values (
    v_nome, v_uid, nullif(p_profissao, ''), nullif(p_arma, ''), nullif(p_guilda, ''),
    v_atributos, 1, v_ca, 2, nullif(p_conceito, ''), nullif(p_aparencia, ''),
    nullif(p_foto_url, ''), v_discord_nome, v_discord_email,
    20, 2000, 1000, 50, 50, true, false
  );

  return '{"ok":true}';
end;
$function$
;
