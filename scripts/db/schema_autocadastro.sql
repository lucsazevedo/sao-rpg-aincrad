-- Autocadastro de personagem: até aqui só o mestre criava conta+ficha
-- (Mestre.vue "Criar Personagem", RLS de personagens/perfis é mestre-only —
-- ver "ins_mestre_service" em schema_fecha_leitura_publica.sql e
-- "mestre_gerencia_perfis" em schema_papeis.sql). Pedido do usuário: abrir
-- pra qualquer visitante criar a própria conta (Cadastro.vue). Decisão
-- confirmada com o usuário: totalmente aberto, sem fila de aprovação.
--
-- A conta em si (auth.users) continua sendo criada pelo client normal
-- (supabase.auth.signUp, GoTrue) — não precisa de RPC pra isso. Esta RPC só
-- cuida da PARTE QUE PRECISA IGNORAR RLS: criar a linha em perfis e a ficha
-- em personagens pro usuário recém-autenticado, mesmo padrão de segurança
-- de pedir_entrada_cla/postar_diario_jogador (SECURITY DEFINER, sem policy
-- de insert direta pra authenticated).
create or replace function autocadastrar_personagem(
  p_nome text,
  p_discord_nome text,
  p_discord_email text,
  p_profissao text default null,
  p_arma text default null,
  p_guilda text default null,
  p_conceito text default null,
  p_aparencia text default null,
  p_foto_url text default null,
  p_atributos jsonb default null
)
returns text language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_nome text := trim(coalesce(p_nome, ''));
  v_discord_nome text := trim(coalesce(p_discord_nome, ''));
  v_discord_email text := trim(coalesce(p_discord_email, ''));
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

  insert into perfis (id, papel, nome, discord_nome, discord_email, foto_url)
    values (v_uid, 'jogador', v_nome, v_discord_nome, v_discord_email, nullif(p_foto_url, ''))
    on conflict (id) do update set
      nome = excluded.nome, discord_nome = excluded.discord_nome,
      discord_email = excluded.discord_email,
      foto_url = coalesce(excluded.foto_url, perfis.foto_url);

  insert into personagens (
    nome, dono_id, profissao, arma, guilda, atributos, conceito, aparencia,
    foto_url, discord_nome, discord_email, folego, col_mao, col_guardado, visivel, excluido
  ) values (
    v_nome, v_uid, nullif(p_profissao, ''), nullif(p_arma, ''), nullif(p_guilda, ''),
    coalesce(p_atributos, '{}'::jsonb), nullif(p_conceito, ''), nullif(p_aparencia, ''),
    nullif(p_foto_url, ''), v_discord_nome, v_discord_email,
    20, 2000, 1000, true, false
  );

  return '{"ok":true}';
end;
$$;
grant execute on function autocadastrar_personagem(text,text,text,text,text,text,text,text,text,jsonb) to authenticated;
