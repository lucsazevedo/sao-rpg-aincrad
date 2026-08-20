# Análise de balanceamento — SAO RPG 5e v1.1

> Feita após integrar o "Master Document v1.1" ao `SAO_RPG_5e.md` (Seções 79-88 novas +
> reforços nas Seções 41/42/43/72/73). Este documento é uma leitura **realista** de mesa —
> a "Regra de Ouro" (Seção 86) diz que tudo deveria ser A+; aqui eu registro onde isso é
> verdade na prática e onde não é, pra servir de referência de ajuste fino contínuo.

---

## 1. Saúde geral do sistema

**Pontos fortes:**
- As 19 armas estão de fato próximas do "A+ em algum nicho" que o design pede — não achei
  nenhuma arma estruturalmente fraca (D/C). A maior variação é de **teto de dano**, não de
  "arma inútil".
- A camada nova (guildas/contratos/propriedades/mercado/PK, Seções 81-85) preenche uma
  lacuna real que existia: antes só tinha a cor do cursor solta (Seção 75), sem risco/
  recompensa em volta. Agora PK é escolha de estilo de jogo, não só punição.
- Passivas de categoria (Seção 80: Interposição/Exploit/Primeira Abertura) dão identidade
  de **papel** além da identidade de **arma** — um Tank de Lança e um Tank de Pá agora têm
  algo em comum mecanicamente, não só narrativo.

**Tensões reais (não são bugs, mas valem registro):**
1. **Domador é a profissão mais forte por uma margem grande.** É a única que efetivamente
   dobra a economia de ação ofensiva do personagem (criatura ataca junto, quase todo nível
   soma dano ou mitiga dano). Isso foi uma decisão deliberada desta sessão (documentada,
   Seção 42) — mas o efeito colateral é que ela deixa as outras 14 profissões parecendo
   mais fracas por comparação **quando o critério é combate**.
2. **Profissões de crafting puro (Lenhador, Minerador, Costureiro, Joalheiro) só brilham
   se a mesa usa a economia de verdade.** Numa campanha combat-heavy sem loja/crafting em
   jogo, elas contribuem ~zero numa sessão de dungeon. Isso é esperado (são profissões de
   suporte econômico, não de combate) mas é bom o Mestre saber disso antes de um jogador
   escolher uma delas esperando utilidade em toda sessão.
3. **Leque, pós-revisão de balanceamento desta sessão, é a arma com o maior teto de dano
   sustentado do jogo** — a combinação de Fluxo Cortante (passiva) + Dança das Correntes
   (stacking) + Festival das Cem Lâminas (dano dobrado por 1 minuto) supera qualquer outra
   arma Scout e rivaliza com o pico de burst de Espada Longa/Katana, mas de forma sustentada
   em vez de só no primeiro golpe. Combinado com Domador (mesmo atributo, SAB), é hoje o
   build de maior dano contínuo do sistema.
4. **Pá segue sendo a Tank com menor dano direto** das 4 (nenhuma Skill dela passa de
   2d8+FOR, contra até 3d10+FOR do Martelo). Isso é coerente com a identidade dela
   (controle de terreno, não dano), mas é o caso mais próximo de "abaixo de A+" se o
   critério for só DPR.

---

## 2. Tier list — Armas (19)

> Tier aqui = desempenho real esperado de mesa (PvE geral + Boss + PvP), não a aspiração
> de design. "S" = acima do teto pretendido pelo próprio sistema; "A+/A/A-" = dentro do
> teto pretendido, com variação de nicho.

### S — acima do teto pretendido
- **Leque** (Scout/SAB) — maior dano sustentado do jogo pós-revisão desta sessão. Ver nota 3 acima.

### A+ — excelente em seu nicho, sem fraqueza séria
- **Espada + Escudo** (Tank/FOR) — melhor "protetor de grupo" puro; Limit Break literalmente evita uma morte.
- **Lança** (Tank/DES) — melhor equilíbrio ataque/defesa entre os Tanks; reação constante.
- **Arco e Flecha** (DPS/DES) — melhor DPS confiável à distância.
- **Espada Longa** (DPS/FOR) — maior teto de burst corpo a corpo (stacking sem limite em Lâmina Suprema), mas frágil a erro.
- **Katana** (DPS/SAB) — melhor alpha strike (Iaijutsu Supremo pode ser crítico automático no 1º turno).
- **Chakram** (AoE/DES) — melhor dano puro contra grupos (ricochete sem limite no Limit Break).
- **Foice** (AoE/SAB) — melhor "executor"; forte contra fights longos com curas inimigas.
- **Machado** (AoE/FOR) — melhor combo autossuficiente (derruba e depois executa o próprio derrubado).
- **Besta** (Scout/DES) — melhor "habilitador de time" (marca + crítico automático em alvo ferido).

### A — muito forte, mas com trade-off claro
- **Martelo** (Tank/FOR) — dano/controle ótimos, mas menos "protege aliado" que Espada+Escudo.
- **Rapieira** (DPS/DES) — ótima consistência (Lâmina do Mestre), teto menor que Espada Longa/Katana.
- **Manopla** (DPS/FOR) — pressão sustentada forte, mas frágil a ser interrompido (perde o stack).
- **Bastão** (AoE/SAB) — sólido e direto, sem mecânica de nicho tão marcante quanto as outras 5 AoE.
- **Corrente com Peso** (AoE/DES) — melhor controle puro (Grilhões sem teste), dano modesto por conta própria.
- **Adagas de Arremesso** (Scout/DES) — ótima mobilidade/reposicionamento (teleporte no Limit Break).

### A- — bom, mas o mais fraco da própria categoria
- **Pá** (Tank/FOR) — melhor controle de terreno, menor dano direto dos 4 Tanks.
- **Chicote** (AoE/INT) — melhor controle de puxão/reposicionamento, dano mais baixo do que as outras AoE.
- **Adagas** (Scout/DES) — melhor mobilidade pura, menor dano por golpe (1d4 base) de todo o jogo.

---

## 3. Tier list — Profissões (15)

> Critério: impacto médio numa sessão típica (mistura de combate + exploração + economia).
> Profissões de crafting puro **sobem de tier automaticamente** numa mesa que usa a economia
> a sério — a nota abaixo assume uso moderado disso, não zero nem obcecado.

### S — impacto de combate muito acima das demais
- **Domador** (SAB) — na prática, dobra a economia ofensiva do personagem. Ver nota 1 da Seção 1.

### A- / A — forte em quase qualquer mesa
- **Médico** (SAB) — única profissão com cura direta e confiável em combate; preenche o vácuo de "não existe classe curandeira".
- **Ferreiro** (FOR) — hub da economia de equipamento; alto valor se crafting é usado.
- **Músico** (CAR) — buff de grupo que escala bem até nível 20 (remove Exaustão no topo).

### B+ — boa utilidade, mas nem sempre em toda sessão
- **Caçador** (SAB) — ótimo em exploração/rastreio, zero em combate puro.
- **Cozinheiro** (INT) — bom buff pré-luta, mas de curta duração (1h).
- **Mercenário** (CON) — utilidade real de perícia + pequena vantagem tática (nível 10).
- **Alquimista** (INT) — poções fortes, mas depende de tempo de preparo fora de combate.

### B — situacional, depende do estilo da campanha
- **Informante** (INT) — brilha em campanha social/investigativa, indiferente em dungeon crawl puro.
- **Comerciante** (CAR) — excelente pra quem quer jogar a economia, irrelevante em combate.
- **Mestre de Montarias** (DES) — divertida, mas só existe se a mesa usa montaria de verdade; a nova regra de equilíbrio (Seção 41) também limita o quanto ela pode ser abusada.

### B- — narrow, quase puramente crafting de apoio
- **Costureiro** (DES) — a mais "coadjuvante" das profissões de crafting.
- **Lenhador** (FOR) — alimenta outras profissões, fraco sozinho.
- **Minerador** (CON) — mesmo perfil do Lenhador, mas pra metal/gema.
- **Joalheiro** (DES) — nicho mais estreito de todos (só brilha com Cristal reutilizável em jogo).

---

## 4. Recomendações de acompanhamento (não aplicadas ainda, ficam registradas)

- Se o Domador continuar destacando demais em mesa real (não só no papel), o ponto de
  ajuste mais cirúrgico é o **Comando Duplo** (nível 20, +2d6 uma vez por turno) — é o único
  número que ainda não passou por teste de jogo real.
- Se a Pá continuar parecendo fraca em jogo, o ajuste mais natural é dar a ela uma Skill de
  nível 10 ou 14 com dano comparável ao 2d10+FOR que Martelo/Machado já têm nesses níveis,
  sem tirar a identidade de controle de terreno.
- Vale considerar, numa campanha combat-heavy, dar às profissões de crafting puro (Lenhador/
  Minerador/Costureiro/Joalheiro) pelo menos uma habilidade de nível 15/20 com efeito em
  combate (mesmo que pequeno) — não pra competir com Domador/Médico, só pra elas nunca
  ficarem 100% invisíveis numa sessão sem crafting.
