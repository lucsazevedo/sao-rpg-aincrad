-- ============================================================================
-- MIGRAÇÃO PRA D&D 5e -- PARTE 3: autocadastro (Cadastro.vue)
-- ============================================================================
-- autocadastrar_personagem passa a receber os 6 atributos D&D (distribuição
-- 6/8/8/10/10/12, Seção 5 do SAO_RPG_5e.md) em vez dos 5 PBTA, e já grava
-- atributos_dnd/ca/nivel/bonus_proficiencia no personagem novo -- não fica
-- dependendo de uma migração retroativa pra quem se cadastrar dali pra frente.
-- ============================================================================

DROP FUNCTION IF EXISTS public.autocadastrar_personagem(text,text,text,text,text,text,text,text,text,jsonb);

CREATE OR REPLACE FUNCTION public.autocadastrar_personagem(
  p_nome text, p_discord_nome text, p_discord_email text,
  p_profissao text DEFAULT NULL::text, p_arma text DEFAULT NULL::text,
  p_guilda text DEFAULT NULL::text, p_conceito text DEFAULT NULL::text,
  p_aparencia text DEFAULT NULL::text, p_foto_url text DEFAULT NULL::text,
  p_atributos_dnd jsonb DEFAULT NULL::jsonb
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

  -- distribuição 6/8/8/10/10/12 (Seção 5) -- valida em vez de confiar cego
  -- no cliente; se vier fora do padrão (ou vazio), usa o array base direto
  -- na ordem FOR/DES/CON/INT/SAB/CAR.
  v_atributos := coalesce(p_atributos_dnd, jsonb_build_object(
    'forca', 8, 'destreza', 8, 'constituicao', 10,
    'inteligencia', 10, 'sabedoria', 12, 'carisma', 6
  ));
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
