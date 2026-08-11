-- Achado junto com schema_fix_drops_combate_ovo.sql: metade dos
-- ovos_catalogo.monstro_id apontava pra um id que não existe em monstros —
-- por isso "parece que [incubadora e ovo] não são relacionados": mesmo com
-- a chance de drop de ovo corrigida, esses 6 nunca cairiam de combate
-- porque o monstro_id nunca batia com nenhuma linha real.
--
-- Corrigidos (nome bate com um monstro real do bestiário, id ajustado):
--   urso_floresta        -> urso_de_pedra        (único urso do bestiário)
--   corvo_sombrio         -> corvo_das_ruinas      (único corvo)
--   coruja_sombria        -> coruja_das_sombras    (único coruja)
--   lobo_cinza, lobo_alfa -> lobo_da_alcateia      (único lobo no bestiário;
--     as DUAS raridades de ovo (comum/incomum) apontam pro mesmo monstro
--     por falta de um segundo monstro-lobo — aproximação, não é 1:1 perfeito)
--   aranha_sombra         -> aranha_sombria        (nome mais próximo; existe
--     também 'aranha_de_luz_velada' mas o nome não bate tão bem)
--
-- NÃO corrigidos (gap real de conteúdo — não existe NENHUM monstro
-- correspondente no bestiário de 53 monstros, então inventar um id aqui
-- seria só trocar "quebrado" por "silenciosamente errado"; fica sem
-- caminho de combate até o mestre cadastrar o monstro ou decidir outra
-- fonte pro ovo, ex. drop de missão/quest específica):
--   javali_jovem, avestruz_batalha, dragao_bebe_obsidiana, fenix_bebe

update ovos_catalogo set monstro_id = 'urso_de_pedra'     where id = 'ovo_urso';
update ovos_catalogo set monstro_id = 'corvo_das_ruinas'  where id = 'ovo_corvo_sombrio';
update ovos_catalogo set monstro_id = 'coruja_das_sombras' where id = 'ovo_coruja_sombria';
update ovos_catalogo set monstro_id = 'lobo_da_alcateia'  where id in ('ovo_lobo_cinza','ovo_lobo_alfa');
update ovos_catalogo set monstro_id = 'aranha_sombria'    where id = 'ovo_aranha_sombra';
