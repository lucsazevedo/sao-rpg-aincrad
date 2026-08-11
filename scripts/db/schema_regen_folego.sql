-- Fecha uma pendência real (achada nos itens 9/17): Fôlego "regenera +1 a
-- cada 30 minutos" era só descrição, nenhum mecanismo existia. Sem isso,
-- testar o jogo por mais de alguns cliques trava sem jeito de continuar
-- (só via comprar_folego, que gasta Col).
--
-- pg_cron real (não é "regen calculado na leitura") — roda de verdade a
-- cada 30 min, soma +1 fôlego pra quem estiver abaixo do teto (20). Vida
-- continua SEM regen passiva, por decisão já registrada no item 17 (só
-- cura na Estalagem) — não mexi nisso agora.
create extension if not exists pg_cron;

create or replace function _regenerar_folego_todos() returns void
language sql security definer set search_path = public as $$
  update personagens set folego = least(20, folego + 1), updated_at = now()
    where folego < 20 and excluido = false;
$$;

select cron.unschedule(jobid) from cron.job where jobname = 'regen_folego_30min';
select cron.schedule('regen_folego_30min', '*/30 * * * *', $$select _regenerar_folego_todos()$$);
