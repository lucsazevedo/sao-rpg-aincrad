-- Item 16 parte 1 (ferramenta obrigatória) — mecanismo pronto, mas OPCIONAL
-- por receita (`requer_ferramenta_id` nulo = sem trava, comportamento
-- IDÊNTICO ao de hoje pras 124 receitas que não têm ferramenta cadastrada
-- ainda). Só ativa a trava quando a receita apontar pra uma ferramenta
-- que existe — hoje isso é só as do Domador, as outras 15 profissões
-- ficam pra quando tiverem catálogo de ferramenta próprio (conteúdo, não
-- mecanismo — ver dolist/16).
alter table receitas add column if not exists requer_ferramenta_id text references ferramentas_oficio(id);
