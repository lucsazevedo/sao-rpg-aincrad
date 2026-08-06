-- Terceira migração: exclusão lógica + views que só revelam o campo de
-- mestre pra quem é mestre de verdade (não por cargo de role do Postgres,
-- que "jogador" e "mestre" compartilham — por is_mestre()/pode_ver()).
-- Roda depois de schema.sql e schema_papeis.sql.

-- exclusão lógica em todo mundo
do $$
declare t text;
begin
  foreach t in array array[
    'npcs','monstros','armas','equipamentos','moves_arma','moves_profissao',
    'sistema','mercado','compra_materiais','quests','cronicas','guias',
    'puzzles','oficios','dungeons','salas_dungeon','producao','pontos',
    'pontos_detalhe','clas','personagens','cidades'
  ]
  loop
    execute format('alter table %I add column if not exists excluido boolean not null default false', t);
  end loop;
end $$;

-- policies de leitura/escrita: linha publica OU mestre OU liberado pro
-- jogador especifico; escrita so mestre.
do $$
declare
  t text;
  pk text;
  pks jsonb := '{
    "npcs":"id","monstros":"id","armas":"id","equipamentos":"id",
    "moves_arma":"nome","moves_profissao":"nome","sistema":"titulo",
    "mercado":"id","compra_materiais":"id","quests":"id","cronicas":"id",
    "guias":"id","puzzles":"id","oficios":"nome","dungeons":"id",
    "salas_dungeon":"id","producao":"profissao","pontos":"id",
    "pontos_detalhe":"id","clas":"nome","personagens":"nome","cidades":"id"
  }'::jsonb;
begin
  for t, pk in select key, value#>>'{}' from jsonb_each(pks)
  loop
    execute format('drop policy if exists "select_publico_ou_mestre" on %I', t);
    execute format(
      'create policy "select_publico_ou_mestre" on %I for select using ' ||
      '((visivel = true and excluido = false) or is_mestre() or pode_ver(%L, %I::text))',
      t, t, pk
    );
    execute format('drop policy if exists "escrita_mestre" on %I', t);
    execute format(
      'create policy "escrita_mestre" on %I for all using (is_mestre()) with check (is_mestre())',
      t
    );
  end loop;
end $$;

-- as 6 tabelas com campo de mestre: ninguem le a coluna secreta direto na
-- tabela base (nem "authenticated" — jogador tambem e' authenticated),
-- só a view abaixo, que decide por is_mestre() se revela o valor real.
revoke select on monstros from anon, authenticated;
grant select (id,nome,epiteto,arquivo,img,carta,tipo,zona,regioes,nivel_recomendado,
  ameaca,golpes,local,canonico,fonte,fraqueza,elemento_fraqueza,elemento_resistencia,
  fraquezas,resistencias,vulnerabilidades,domavel,doma_sucessos,doma_requisito,resumo,
  habitat,comportamento,leitura,sinal,lore,drops,corpo,visivel,excluido,updated_at)
  on monstros to anon, authenticated;

revoke select on guias from anon, authenticated;
grant select (id,nome,arquivo,bioma,nivel,chegada,leitura,cena,acoes,demora,evento,
  locais,ligado,visivel,excluido,updated_at) on guias to anon, authenticated;

revoke select on puzzles from anon, authenticated;
grant select (id,n,nome,arquivo,regiao,tipo,cadeia,duracao,recompensa,corpo,visivel,
  excluido,updated_at) on puzzles to anon, authenticated;

revoke select on pontos from anon, authenticated;
grant select (id,regiao,nome,categoria,x,y,tipo,ref,descricao,respawn_horas,teste,
  recompensa,ameaca,golpes,atributo_fraqueza,fala,oferece,vende,obs,visivel,excluido,
  updated_at) on pontos to anon, authenticated;

revoke select on pontos_detalhe from anon, authenticated;
grant select (id,nome,regiao,arquivo,leitura,oque,acoes,atalhos,visivel,excluido,
  updated_at) on pontos_detalhe to anon, authenticated;

revoke select on clas from anon, authenticated;
grant select (nome,destaque,forca,necessidade,rival,rumor,status,resumo,bons,precisa,
  nao_admitem,proximo,atravessado,quests,aparecem,simbolo,reputacao,visivel,excluido,
  updated_at) on clas to anon, authenticated;

-- views: SEM security_invoker de propósito — rodam com privilégio do dono
-- (conseguem ler a coluna secreta por baixo dos panos), e o CASE com
-- is_mestre() decide se devolve o valor de verdade ou null pra quem pediu.
drop view if exists monstros_publico;
create view monstros_publico as
  select id,nome,epiteto,arquivo,img,carta,tipo,zona,regioes,nivel_recomendado,ameaca,
    golpes,local,canonico,fonte,fraqueza,elemento_fraqueza,elemento_resistencia,
    fraquezas,resistencias,vulnerabilidades,domavel,doma_sucessos,doma_requisito,
    resumo,habitat,comportamento,leitura,sinal,lore,drops,corpo,visivel,updated_at,
    case when is_mestre() then notas else null end as notas
  from monstros
  where (visivel = true and excluido = false) or is_mestre() or pode_ver('monstros', id::text);
grant select on monstros_publico to anon, authenticated;

drop view if exists guias_publico;
create view guias_publico as
  select id,nome,arquivo,bioma,nivel,chegada,leitura,cena,acoes,demora,evento,locais,
    ligado,visivel,updated_at,
    case when is_mestre() then mestre else null end as mestre
  from guias
  where (visivel = true and excluido = false) or is_mestre() or pode_ver('guias', id::text);
grant select on guias_publico to anon, authenticated;

drop view if exists puzzles_publico;
create view puzzles_publico as
  select id,n,nome,arquivo,regiao,tipo,cadeia,duracao,recompensa,corpo,visivel,updated_at,
    case when is_mestre() then verdade else null end as verdade
  from puzzles
  where (visivel = true and excluido = false) or is_mestre() or pode_ver('puzzles', id::text);
grant select on puzzles_publico to anon, authenticated;

drop view if exists pontos_publico;
create view pontos_publico as
  select id,regiao,nome,categoria,x,y,tipo,ref,descricao,respawn_horas,teste,recompensa,
    ameaca,golpes,atributo_fraqueza,fala,oferece,vende,obs,visivel,updated_at,
    case when is_mestre() then mestre else null end as mestre
  from pontos
  where (visivel = true and excluido = false) or is_mestre() or pode_ver('pontos', id::text);
grant select on pontos_publico to anon, authenticated;

drop view if exists pontos_detalhe_publico;
create view pontos_detalhe_publico as
  select id,nome,regiao,arquivo,leitura,oque,acoes,atalhos,visivel,updated_at,
    case when is_mestre() then mestre else null end as mestre
  from pontos_detalhe
  where (visivel = true and excluido = false) or is_mestre() or pode_ver('pontos_detalhe', id::text);
grant select on pontos_detalhe_publico to anon, authenticated;

drop view if exists clas_publico;
create view clas_publico as
  select nome,destaque,forca,necessidade,rival,rumor,status,resumo,bons,precisa,
    nao_admitem,proximo,atravessado,quests,aparecem,simbolo,reputacao,visivel,updated_at,
    case when is_mestre() then ganchos else null end as ganchos
  from clas
  where (visivel = true and excluido = false) or is_mestre() or pode_ver('clas', nome::text);
grant select on clas_publico to anon, authenticated;

-- jogador pode criar o proprio perfil, mas so como 'jogador' (RLS barra
-- quem tentar se auto-promover a mestre por aqui).
drop policy if exists "jogador_se_registra" on perfis;
create policy "jogador_se_registra" on perfis for insert
  with check (id = auth.uid() and papel = 'jogador');
