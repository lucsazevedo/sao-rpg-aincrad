-- Duas RPCs que scripts/app/src/views/Mestre.vue já chamava mas nunca
-- tinham sido criadas no banco (achado numa varredura desta rodada:
-- "criar personagem" e "resetar senha" no painel do mestre estavam 100%
-- quebrados — a UI existia, a função no banco não). Web app não pode ter a
-- service_role key no bundle do navegador, então isso é a forma correta de
-- deixar SÓ o mestre criar conta/resetar senha de jogador: SECURITY DEFINER
-- + checagem de is_mestre() por dentro, grant só pra authenticated.
--
-- Usa pgcrypto (já habilitado no projeto) pra gerar o mesmo hash bcrypt que
-- o GoTrue (auth do Supabase) espera em auth.users.encrypted_password.
-- Modelo de linha copiado de auth.users/auth.identities já existentes no
-- banco (usuários criados via signUp normal) pra não inventar formato.

create or replace function criar_usuario_mestre(p_email text, p_senha text, p_nome text)
returns json language plpgsql security definer set search_path = public, auth, extensions as $$
declare
  v_uid uuid;
  v_existe uuid;
begin
  if not is_mestre() then
    raise exception 'só o mestre pode criar contas de jogador';
  end if;
  select id into v_existe from auth.users where email = lower(trim(p_email));
  if v_existe is not null then
    raise exception 'já existe uma conta com esse e-mail';
  end if;

  v_uid := gen_random_uuid();

  insert into auth.users (
    instance_id, id, aud, role, email, encrypted_password,
    email_confirmed_at, confirmation_token, recovery_token,
    raw_app_meta_data, raw_user_meta_data, created_at, updated_at
  ) values (
    '00000000-0000-0000-0000-000000000000', v_uid, 'authenticated', 'authenticated',
    lower(trim(p_email)), crypt(p_senha, gen_salt('bf')),
    now(), '', '',
    '{"provider":"email","providers":["email"]}'::jsonb,
    jsonb_build_object('nome', p_nome),
    now(), now()
  );

  -- "email" de auth.identities e' coluna gerada (a partir de identity_data
  -- ->> 'email'), nao entra na lista de insert.
  insert into auth.identities (
    id, provider_id, user_id, identity_data, provider,
    last_sign_in_at, created_at, updated_at
  ) values (
    gen_random_uuid(), v_uid::text, v_uid,
    jsonb_build_object('sub', v_uid::text, 'email', lower(trim(p_email)), 'email_verified', true),
    'email', now(), now(), now()
  );

  return json_build_object('uid', v_uid);
end;
$$;

grant execute on function criar_usuario_mestre(text, text, text) to authenticated;

create or replace function resetar_senha_usuario(p_email text, p_nova_senha text)
returns json language plpgsql security definer set search_path = public, auth, extensions as $$
declare
  v_uid uuid;
begin
  if not is_mestre() then
    raise exception 'só o mestre pode resetar senha de jogador';
  end if;

  select id into v_uid from auth.users where email = lower(trim(p_email));
  if v_uid is null then
    raise exception 'nenhuma conta com esse e-mail';
  end if;

  update auth.users
    set encrypted_password = crypt(p_nova_senha, gen_salt('bf')), updated_at = now()
    where id = v_uid;

  return json_build_object('uid', v_uid);
end;
$$;

grant execute on function resetar_senha_usuario(text, text) to authenticated;
