-- Reforma "modo Cellbit" (12/08) — decisões tomadas pelo usuário como
-- "resolve você, o que achar interessante": Cartógrafo absorve
-- Historiador, clã pode travar profissão na entrada, e dois minigames
-- de profissão (Cartógrafo e Músico) com recompensa de verdade e freio
-- anti-farm embutido (fôlego + limite diário, mesmo padrão já usado em
-- craft). Ver dolist/19_backlog_profissoes_e_balanceamento.md.

-- ======================================================================
-- 1) Cartógrafo absorve Historiador — Marca nova + Move Exclusivo
-- ======================================================================
UPDATE moves_profissao SET
  marca = 'Você conhece o andar e a história dele; gente te paga por caminho, por segurança e por saber o que já aconteceu ali.',
  move_c = '{"nome": "Crônica do Andar", "atributo": "Conhecimento", "gatilho": "Quando você documentar, catalogar ou estudar um local, evento, ruína ou capítulo já vivido do andar, role +Conhecimento.", "dez_mais": ["Você registra o local/evento com uma precisão que outros exploradores vão usar depois.", "Você identifica um padrão histórico que revela onde algo importante deve estar.", "Você descobre uma conexão entre esse lugar/evento e outro já registrado.", "Seu registro vira referência — você recebe +1 na próxima vez que consultar esse mesmo tema.", "Você não se expõe durante o levantamento — ninguém percebe o que você estava fazendo."], "sete_nove": ["Você registra o essencial, mas o resto exige mais tempo.", "Você encontra a conexão, mas ela aponta pra algo perigoso.", "Seu registro atrai atenção — alguém quer saber o que você anotou.", "Você descobre parte da história; o resto ficou perdido ou incompleto.", "Levantar os dados custa tempo, suprimento ou exposição."], "seis_menos": ["O registro está errado ou incompleto e alguém confia nele mesmo assim.", "Você desperta algo que devia ficar esquecido.", "Uma facção rival de exploradores ou guilda reivindica sua descoberta.", "O local muda ou é destruído antes de você terminar de registrar.", "Você fica Sob Pressão ou isolado tentando confirmar um dado."]}'::jsonb,
  visivel = true, updated_at = now()
WHERE nome = 'Cartógrafo';

-- ======================================================================
-- 2) Limitar profissão por clã — clas.profissoes_aceitas (null/vazio =
--    aceita qualquer profissão). Trava dentro de pedir_entrada_cla, não
--    é RLS de tabela (é regra de negócio, precisa de mensagem clara).
-- ======================================================================
alter table clas add column if not exists profissoes_aceitas text[];

drop view if exists clas_publico;
create view clas_publico as
  select nome, destaque, forca, necessidade, rival, rumor, status, resumo, bons,
         precisa, nao_admitem, proximo, atravessado, quests, aparecem, simbolo,
         logo_url, recrutando, profissoes_aceitas, reputacao, updated_at,
         case when is_mestre() then ganchos else null end as ganchos
  from clas
  where (visivel = true and excluido = false) or is_mestre() or pode_ver('clas', nome);

create or replace function pedir_entrada_cla(p_cla_nome text, p_mensagem text default null)
returns text language plpgsql security definer set search_path = public as $$
declare v_personagem text; v_guilda text; v_prof text; v_cla clas%rowtype;
begin
  select nome, guilda, profissao into v_personagem, v_guilda, v_prof from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;
  if v_guilda is not null and v_guilda <> '' then return '{"erro":"você já tem clã"}'; end if;

  select * into v_cla from clas where nome = p_cla_nome and visivel = true and excluido = false;
  if not found then return '{"erro":"clã não encontrado"}'; end if;
  if not coalesce(v_cla.recrutando, false) then return '{"erro":"esse clã não está recrutando no momento"}'; end if;
  if v_cla.profissoes_aceitas is not null and array_length(v_cla.profissoes_aceitas, 1) > 0
     and not (v_prof = any(v_cla.profissoes_aceitas)) then
    return format('{"erro":"esse clã só aceita: %s"}', array_to_string(v_cla.profissoes_aceitas, ', '));
  end if;

  if exists (select 1 from cla_pedidos where cla_nome = p_cla_nome and personagem_nome = v_personagem and status = 'pendente') then
    return '{"erro":"você já tem um pedido pendente pra esse clã"}';
  end if;

  insert into cla_pedidos (cla_nome, personagem_nome, mensagem) values (p_cla_nome, v_personagem, nullif(trim(p_mensagem), ''));
  return '{"ok":true,"mensagem":"Pedido enviado — aguarde aprovação do mestre ou da liderança do clã."}';
end;
$$;
grant execute on function pedir_entrada_cla(text, text) to authenticated;

-- ======================================================================
-- 3) Minigame do Cartógrafo — "Névoa do Andar"
--    Grade de 9 áreas por dia, revela até 3, cada uma dá Col, XP de
--    Cartógrafo ou nada. Freio anti-farm = 3/dia (reseta à meia-noite,
--    current_date do servidor).
-- ======================================================================
create table if not exists cartografo_nevoa (
  id bigserial primary key,
  personagem_nome text not null references personagens(nome) on delete cascade,
  data date not null default current_date,
  grade jsonb not null,
  revelados_hoje int not null default 0,
  unique (personagem_nome, data)
);
alter table cartografo_nevoa enable row level security;
drop policy if exists "dono_ve_e_mestre" on cartografo_nevoa;
create policy "dono_ve_e_mestre" on cartografo_nevoa for select using (
  is_mestre() or exists (select 1 from personagens p where p.dono_id = auth.uid() and p.nome = cartografo_nevoa.personagem_nome)
);
drop policy if exists "so_rpc_escreve" on cartografo_nevoa;
create policy "so_rpc_escreve" on cartografo_nevoa for all using (is_mestre()) with check (is_mestre());

create or replace function _grade_nevoa_nova()
returns jsonb language sql as $$
  select jsonb_agg(jsonb_build_object('revelado', false)) from generate_series(1, 9);
$$;

create or replace function cartografo_revelar(p_index int)
returns text language plpgsql security definer set search_path = public as $$
declare
  v_personagem text; v_prof text; v_linha cartografo_nevoa%rowtype;
  v_grade jsonb; v_tile jsonb; v_sorte numeric; v_tipo text; v_valor int; v_hoje date := current_date;
begin
  if p_index < 0 or p_index > 8 then return '{"erro":"índice inválido (0-8)"}'; end if;
  select nome, profissao into v_personagem, v_prof from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;
  if v_prof is distinct from 'Cartógrafo' then return '{"erro":"só o Cartógrafo revela a névoa do andar"}'; end if;

  select * into v_linha from cartografo_nevoa where personagem_nome = v_personagem and data = v_hoje;
  if not found then
    insert into cartografo_nevoa (personagem_nome, data, grade)
      values (v_personagem, v_hoje, _grade_nevoa_nova())
      returning * into v_linha;
  end if;

  if v_linha.revelados_hoje >= 3 then return '{"erro":"você já revelou 3 áreas hoje — a névoa volta amanhã"}'; end if;

  v_grade := v_linha.grade;
  v_tile := v_grade -> p_index;
  if v_tile is null then return '{"erro":"índice inválido"}'; end if;
  if (v_tile->>'revelado')::boolean then return '{"erro":"essa área já foi revelada hoje"}'; end if;

  v_sorte := random();
  if v_sorte < 0.5 then
    v_tipo := 'col'; v_valor := 10 + floor(random() * 31)::int;
    update personagens set col_mao = col_mao + v_valor, updated_at = now() where nome = v_personagem;
    insert into transacoes (para_personagem, tipo, valor, observacao) values (v_personagem, 'missao', v_valor, 'Névoa do Andar (Cartógrafo)');
  elsif v_sorte < 0.8 then
    v_tipo := 'xp'; v_valor := 5 + floor(random() * 11)::int;
    if not exists (select 1 from nivel_profissao where personagem_nome = v_personagem and profissao = 'Cartógrafo') then
      insert into nivel_profissao (personagem_nome, profissao, nivel, xp) values (v_personagem, 'Cartógrafo', 1, 0);
    end if;
    update nivel_profissao set xp = xp + v_valor, updated_at = now() where personagem_nome = v_personagem and profissao = 'Cartógrafo';
  else
    v_tipo := 'nada'; v_valor := 0;
  end if;

  v_grade := jsonb_set(v_grade, array[p_index::text], jsonb_build_object('revelado', true, 'tipo', v_tipo, 'valor', v_valor));
  update cartografo_nevoa set grade = v_grade, revelados_hoje = revelados_hoje + 1 where id = v_linha.id;

  return jsonb_build_object('ok', true, 'tipo', v_tipo, 'valor', v_valor, 'revelados_hoje', v_linha.revelados_hoje + 1)::text;
end;
$$;
grant execute on function cartografo_revelar(int) to authenticated;

-- ======================================================================
-- 4) Minigame do Músico — "Composição Viva"
--    Sequência tipo Simon (gerada e validada no cliente — mesa
--    cooperativa, não PvP competitivo). O RPC só aplica consequência:
--    custa 2 Fôlego sempre, só cria buff se sucesso=true, e trava em
--    2 buffs bem-sucedidos por dia (freio anti-farm).
-- ======================================================================
create table if not exists buffs_grupo (
  id bigserial primary key,
  personagem_nome text references personagens(nome) on delete set null,
  titulo text not null,
  descricao text,
  criado_em timestamptz not null default now(),
  expira_em timestamptz not null
);
alter table buffs_grupo enable row level security;
drop policy if exists "leitura_publica" on buffs_grupo;
create policy "leitura_publica" on buffs_grupo for select using (true);
drop policy if exists "so_rpc_escreve" on buffs_grupo;
create policy "so_rpc_escreve" on buffs_grupo for all using (is_mestre()) with check (is_mestre());

create or replace function musico_compor(p_sucesso boolean)
returns text language plpgsql security definer set search_path = public as $$
declare v_personagem text; v_prof text; v_folego int; v_hoje date := current_date; v_buffs_hoje int;
begin
  select nome, profissao, folego into v_personagem, v_prof, v_folego from personagens where dono_id = auth.uid();
  if v_personagem is null then return '{"erro":"sem personagem"}'; end if;
  if v_prof is distinct from 'Músico' then return '{"erro":"só o Músico compõe"}'; end if;
  if v_folego < 2 then return format('{"erro":"fôlego insuficiente: precisa 2, você tem %s"}', v_folego); end if;

  update personagens set folego = folego - 2, updated_at = now() where nome = v_personagem;

  if not p_sucesso then
    return '{"ok":true,"sucesso":false,"mensagem":"A composição desafinou — 2 de fôlego gasto, sem buff dessa vez."}';
  end if;

  select count(*) into v_buffs_hoje from buffs_grupo where personagem_nome = v_personagem and criado_em::date = v_hoje;
  if v_buffs_hoje >= 2 then
    update personagens set folego = folego + 2, updated_at = now() where nome = v_personagem; -- devolve o fôlego, a tentativa nem rola
    return '{"erro":"você já inspirou o grupo 2 vezes hoje — o resto vira só música bonita, sem efeito extra"}';
  end if;

  insert into buffs_grupo (personagem_nome, titulo, descricao, expira_em)
    values (v_personagem, 'Melodia Inspiradora',
      v_personagem || ' tocou uma composição perfeita — o grupo ganha +1 na próxima rolagem importante desta cena.',
      now() + interval '2 hours');

  return '{"ok":true,"sucesso":true,"mensagem":"Composição perfeita! O grupo ganha +1 na próxima rolagem importante (vale por 2h de sessão)."}';
end;
$$;
grant execute on function musico_compor(boolean) to authenticated;
