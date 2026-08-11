---
titulo: Chance de sucesso por Nível (Poder por equipamento removido)
tamanho: M
uso: mestre
---

# Chance de sucesso por Nível

## Decisão — Poder por equipamento SAI do jogo

A ideia original deste item (Poder = soma de pontos de cada equipamento,
travando risco) foi **descartada**. Motivo, direto da decisão do usuário:
equipamento no jogo online não carrega efeito mecânico nenhum (ver
`08_equipamento_inventario.md` — item craftado/dropado ali só vale nas
aventuras de mesa, não no site). Sem efeito de equipamento, não faz
sentido somar "pontos de Poder" por peça equipada — a trava inteira teria
que vir de outro lugar.

**Chance de sucesso contra monstro (matar, sobreviver a uma missão, etc.)
passa a ser definida só pelo Nível** — o mesmo Nível de Profissão que o
item 5 define (ver `05_niveis_e_xp.md`). Não existe mais uma segunda
variável ("Poder") competindo com o Nível pra decidir risco.

## O que continua da versão antiga

- **Nível trava acesso** (decisão já fechada em `06_jogo_online_diario.md`):
  abaixo do nível, a região/monstro nem aparece como opção.
- **Nível agora também define chance de sucesso** dentro do que já está
  acessível: quanto mais alto o Nível de Profissão em relação ao
  `nivelRecomendado` do monstro/missão, melhor a chance. Fica **uma única
  alavanca** fazendo os dois papéis (acesso e risco), não duas.
- **Falhar aciona o estado de Bug** (renomeado de "Desmaio" — ver
  `06_jogo_online_diario.md`), tempo travado escalando com quanto de "bug"
  o personagem acumulou.

## Fraqueza por atributo — continua valendo, agora ajusta o Nível efetivo

A parte de fraqueza por atributo de arma (ver `13_remover_elementos.md`)
não dependia de Poder de verdade — só usava "reduzir o déficit" como
metáfora. Sem Poder, o mesmo bônus vale direto sobre a chance de sucesso:
levar a arma cujo atributo bate com a fraqueza do monstro melhora a
chance, como um ajuste sobre o Nível efetivo pra aquela tentativa
específica. Continua incentivando trocar de arma pro monstro certo, só
que a régua agora é Nível, não Poder.

## O que precisa

- Fórmula: chance de sucesso como função de (Nível de Profissão do
  personagem − `nivelRecomendado` do monstro/missão), com ajuste positivo
  se a arma usada bate a fraqueza de atributo do monstro.
- Campo `nivelRecomendado` nos monstros/quests já existe — não precisa de
  `poder_recomendado` novo (era do sistema antigo).
- Campo `atributo_fraqueza` em `monstros` (um dos 5 atributos, separado do
  `elemento_fraqueza` de mesa) — mesma pendência já registrada em
  `13_remover_elementos.md`.
- **Não depende mais do item 8 (inventário) pra existir** — antes a ordem
  travava nisso porque Poder somava equipamento; Nível de Profissão já
  existe independente de inventário.

## Preciso saber — respondido (10/08)

- **Degrau fixo por ponto** de diferença de Nível (escolhido) — e, achado
  numa varredura desta rodada: **isso já existe no servidor.** A RPC
  `aceitar_e_resolver_missao` já calcula `v_dif = nivel_profissao -
  missao.nivel_min` e converte num modificador de 2d6 em degrau (≥+2→+3,
  +1→+1, 0→0, -1→-1, ≤-2→-3), rola de verdade no banco (não é decorativo)
  e resolve em sucesso_total/parcial/falha — o mesmo padrão PBTA da mesa.
  Não escrevi essa parte porque já estava certa; só corrigi o que exibia
  errado (ver abaixo).
- ✅ **Bônus de fraqueza de atributo: fixo (+1 no mod de 2d6), implementado
  e testado.** A migração rodou (confirmada por você), `atributo_fraqueza`
  ficou 54/54 preenchido. Implementado em `combater_monstro` (item 17):
  compara `armas.atributo` da arma equipada com `monstros.atributo_fraqueza`
  do alvo, soma +1 ao mod se bater. UI mostra "⚡ sua arma bate a fraqueza"
  no card do monstro em `/combate`. **Escopo**: só no combate assíncrono
  (item 17), que já tem `monstro_id` de verdade — não implementado em
  `aceitar_e_resolver_missao` (item 6), cujo `alvo` é texto livre
  (`missoes_quadro.alvo`, ex. "Guerreiro Kobold") sem link direto pra
  `monstros`; casar os dois por nome seria mais frágil e exigiria editar de
  novo uma função já grande — deixei de fora por segurança, não por
  esquecimento.
- Achado extra no caminho: `armas.atributo` tinha grafia inconsistente
  (`Tecnica`/`Espirito` sem acento em 9 linhas, coexistindo com
  `Técnica`/`Espírito` acentuado no resto) — o bônus de fraqueza nunca ia
  bater pra essas 9 armas. Corrigido, todas as 22 usam a mesma grafia agora.
- **Sucesso acima do nível recomendado → drop cheio** (escolhido) — já é
  o comportamento de fato: a RPC não tem regra especial pra "acima do
  nível", só resolve pela soma de 2d6+mod normalmente (sucesso_total =
  prêmio cheio, sucesso_parcial = reduzido, não há terceira categoria
  "raspando acima do nível").

## Corrigido nesta rodada — prévia de chance no site mentia

`Tarefas.vue` mostrava uma % de chance pro jogador **antes** de clicar
numa missão, calculada com `personagens.nivel` — coluna que não existe
(sempre 1). A rolagem de verdade no servidor sempre usou o Nível de
Profissão certo; só a prévia no navegador estava presa em "nível 1 pra
sempre", ficando cada vez mais pessimista conforme o jogador evoluía.
Corrigido: busca `nivel_profissao` real do personagem/profissão ao montar
a tela e usa isso na prévia.
