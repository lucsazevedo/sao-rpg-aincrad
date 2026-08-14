-- Seed ÚNICO (não reexecute — noticias/diario_entradas não têm chave natural
-- pra deduplicar, rodar de novo duplica as linhas). Povoamento inicial do
-- Hub de Aincrad, só pro Andar 1 — pedido do usuário
-- ("vamos fazer tudo apenas para o andar 1"). Tudo aqui é ancorado no que já
-- está documentado no repo (docs/historia_campanha.md = "Dia 10, ninguém
-- achou/derrotou o chefe do andar 1"; mapas/andar_1.md = geografia e
-- monstros reais da região; docs/registro_clas_e_reputacao.md = os 6 clãs).
-- De propósito, NÃO preenche: boss_nome/boss_img/boss_info (Illfang segue
-- não-descoberto na ficção — colocar o nome no banco vazaria spoiler pro
-- jogador via devtools, mesmo com a UI escondendo), MVP do andar (nada
-- heróico documentado ainda) e liderança/conquista dos 5 clãs sem membro
-- jogável hoje (só "Sindicato dos Ossos" tem PJ de verdade: Shen e Umbra).

-- ======================================================================
-- 1) Andar 1 — estado de exploração
-- ======================================================================
update andares set
  nome = 'Cidade do Início',
  status = 'em_exploracao',
  exploracao_pct = 30,
  info_descobertas = 'O andar mais extenso de Aincrad (~10km de diâmetro), terreno misto sem tema único. ' ||
    'A Cidade do Início concentra quem ainda tem medo de sair. Nos arredores, a Planície de Verrun (oeste, ' ||
    'mais tranquila) e as Estepes de Kaldan (leste, mais dura) levam a Tolbana, a segunda maior cidade — ' ||
    'base natural de quem for atrás da masmorra. Rumor consistente: a entrada do Labirinto fica na borda ' ||
    'norte, guardada por um Field Boss ainda sem nome confirmado. Ninguém chegou lá ainda.',
  monstros_conhecidos = array['Frenzy Boar','Stabbing Wasp','Slime','Lobo da Alcateia','Little Nepenthes'],
  boss_status = 'nao_descoberto',
  updated_at = now()
where numero = 1;

-- ======================================================================
-- 2) Liderança real do único clã com personagem jogável hoje — Umbra
-- decide sozinha quem entra no Sindicato dos Ossos (registro_clas_e_reputacao.md)
-- ======================================================================
update clas set lider_personagem = 'Umbra', updated_at = now() where nome = 'Sindicato dos Ossos';
insert into cla_autoridade (cla_nome, personagem_nome, cargo)
  values ('Sindicato dos Ossos', 'Umbra', 'lider')
  on conflict (cla_nome, personagem_nome) do update set cargo = 'lider';
insert into cla_autoridade (cla_nome, personagem_nome, cargo)
  values ('Sindicato dos Ossos', 'Shen', 'membro')
  on conflict (cla_nome, personagem_nome) do nothing;

-- ======================================================================
-- 3) Notícias — só o que já é fato documentado em Dia 10
-- ======================================================================
insert into noticias (titulo, categoria, andar, dia_aincrad, texto, destaque) values
  ('O ANÚNCIO DE KAYABA', 'sistema', 1, 1,
   'Não existe mais a opção de sair do jogo. A única forma de recuperar a liberdade é explorar Aincrad, ' ||
   'derrotar os chefes de cada um dos cem andares e alcançar o topo. Dentro do jogo, não existem vidas extras.',
   true),
  ('SEIS GUILDAS JÁ DISPUTAM ESPAÇO NA CIDADE DO INÍCIO', 'guilda', 1, 10,
   'Dez dias após o anúncio, Sindicato dos Ossos, LHUB, Dndalcin, iBarr''s, Terraço Geek e Guilda de Nerds ' ||
   'já são nomes conhecidos entre quem decidiu não ficar trancado. Cada uma disputa reputação à sua maneira.',
   false),
  ('MEMORIAL GANHA NOVOS NOMES', 'sistema', 1, 10,
   'Os monstros do primeiro andar já cobraram as primeiras vidas. Na Cidade do Início, o Memorial recebeu ' ||
   'placas novas — e o clima entre quem ainda não saiu das zonas seguras piorou.',
   false),
  ('A MASMORRA DO ANDAR 1 SEGUE SEM CONFIRMAÇÃO', 'exploracao', 1, 10,
   'Grupos de exploração relatam uma torre gigantesca na borda norte, possível entrada do Labirinto — mas ' ||
   'ninguém confirmou o que guarda a passagem, nem chegou perto o bastante pra saber.',
   false);

-- ======================================================================
-- 4) Diário de Aincrad — registro do mestre pro Dia 10 (o espaço do
--    jogador fica em branco de propósito: é o jogador real quem escreve)
-- ======================================================================
insert into diario_entradas (dia, autor_tipo, titulo, texto, categoria) values
  (10, 'mestre', 'Dez dias depois do anúncio',
   'A Cidade do Início já não é mais a mesma. Parte dos jogadores perdeu a esperança e se tranca nas zonas ' ||
   'seguras; outra parte formou guildas e grupos de exploração, determinados a encontrar a masmorra do ' ||
   'primeiro andar. Suprimentos ganham valor rápido, informação vale tanto quanto Col, e a confiança entre ' ||
   'desconhecidos é rara. Ninguém ainda encontrou — muito menos derrotou — o chefe do andar 1.',
   'sistema');
