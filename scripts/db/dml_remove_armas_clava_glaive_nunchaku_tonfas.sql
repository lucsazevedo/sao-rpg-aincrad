-- DML: remove os tipos de arma Clava, Glaive, Nunchaku e Tonfas do roster
-- (pedido do usuário, 14/08 — ver docs/guia_sistema_aincrad.md, agora "As
-- 19 armas de Aincrad"). Verificado antes: nenhum personagem possui item
-- desses tipos (inventario), nenhuma receita craft produz esses ids
-- (receitas.resultado_item_id), nenhum cla_inventario — remoção segura,
-- sem órfão.
--
-- Exceção: "Clava de Osso de Guardião" (drop do chefe Guardião de
-- Mournhall) não é apagada — vira "Machado de Osso de Guardião" (mesmo
-- material/craft, só troca o tipo de arma), então primeiro atualiza esse
-- item específico ANTES do delete em massa por tipo, senão ele cairia
-- junto.

update armas
   set id = 'machado_de_osso_de_guardiao',
       nome = 'Machado de Osso de Guardião',
       tipo = 'Machado'
 where id = 'clava_de_osso_de_guardiao';

delete from armas where tipo in ('Clava', 'Glaive', 'Nunchaku', 'Tonfas');
delete from moves_arma where nome in ('Clava', 'Glaive', 'Nunchaku', 'Tonfas');
delete from mercado_itens where item in ('Tonfas de Núcleo de Ferro', 'Glaive de Guarda de Portão');
