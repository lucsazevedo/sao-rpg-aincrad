---
titulo: Backlog — reforma de profissões, minigames e balanceamento
tamanho: G
uso: mestre
---

# Backlog — reforma de profissões, minigames e balanceamento

Anotado em 12/08 durante a sessão de golpes de arma (item 02) — usuário
mandou uma sequência rápida de ideias/decisões pra profissões que não
cabem todas na mesma resposta. Registrado aqui pra não perder, cada item
ainda precisa de spec própria antes de virar código.

## ✅ Decidido (já sendo aplicado — ver commit de profissões)
- Bibliotecário + Diplomata → unificam em **Informante** (Conhecimento).
- Coveiro → sai do roster, funções absorvidas por **Mercenário**.
- "Pescador" (nunca foi profissão formal no roster, só NPC/lore) → fica
  confirmado que pesca é escopo do **Caçador** (o Move Exclusivo dele já
  cobre "pescar" explicitamente).
- Roster ganha 3 profissões novas com Move Exclusivo pronto (PDF
  `SAO_PBTA_Profissoes_e_Moves.pdf`): **Informante**, **Mestre de
  Montarias**, **Minerador**.

## ⏳ Em aberto — precisa de spec antes de mexer no código

- **Cartógrafo : Historiador** — usuário pediu "unificar mais cartógrafo:
  Historiador", mas não veio spec (Marca, Move de Ofício/Cena, Move
  Exclusivo) nem ficou claro se é **fundir um profissão nova chamada
  "Historiador" pra dentro do Cartógrafo** (Cartógrafo absorve pesquisa
  histórica) ou **renomear** Cartógrafo. Cartógrafo ficou de fora dessa
  rodada (mantido como está, sem Move Exclusivo ainda) até essa decisão
  ficar clara.

- **Mini game para Cartógrafo** — sem spec. Precisa decidir: mecânica
  (o que o jogador realmente faz — desenhar rota? adivinhar terreno?
  conectar pontos?), onde mora na UI, se dá recompensa em Col/XP/item, se
  usa 2d6+Conhecimento por trás ou é puramente lúdico.

- **Mini game para composição e buffs** (provavelmente Músico) — mesma
  situação: sem mecânica definida. Precisa decidir o "verbo" do jogo
  (compor uma sequência? ritmo tipo QTE?) e como o resultado vira buff de
  verdade pro grupo (duração, quem recebe, se gasta Fôlego).

- **Limitar classe por clã** — ambíguo: significa que cada clã só aceita
  certas profissões (trava na entrada/recrutamento, ver
  [[schema_upload_imagens_e_recrutamento_cla]])? Ou que profissão define
  quais clãs você pode entrar? Precisa de regra explícita por clã antes
  de mexer em `pedir_entrada_cla`/RLS.

- **Balancear profissões** — sem alvo definido (balancear o quê:
  economia de Col? XP por hora? poder de combate indireto via
  ferramenta/craft?). Precisa de critério de comparação antes de
  qualquer ajuste — mexer sem isso é chute.

- **Cuidar com o "farm" infinito** — relacionado ao ponto acima. Precisa
  mapear quais moves/recompensas hoje não têm limite por sessão/dia (ex:
  Alquimista rolando Mistura Perfeita repetidamente sem custo) e decidir
  o freio: limite diário (já existe padrão em outros sistemas do jogo,
  ver `limite_diario` em `transacoes`), custo de Fôlego, ou cooldown por
  narrativa (mestre decide quando cabe rolar de novo).

## Como retomar

Quando o usuário quiser destravar qualquer um desses, a pergunta certa é
"qual é a mecânica exata" — não dá pra implementar minigame ou trava de
balanceamento sem isso virar chute. Os itens "✅ Decidido" acima não têm
esse problema (vieram com texto pronto) e por isso já entraram nesta
sessão.
