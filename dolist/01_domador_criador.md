---
titulo: Domador vira Criador — ovos e chocagem
tamanho: M
uso: mestre
---

# Domador → Criador (ovos)

## A ideia

O Domador deixa de só amansar criatura viva no campo — passa a poder
**obter ovo de monstro** (drop, achado, recompensa) e **chocar** ele, criando
um vínculo desde o nascimento em vez de domar um adulto selvagem.

## O que já existe

A Move está desenhada por inteiro em `dolist/Domador.png`: "Domador — Ovo de
Fera", rola **+Técnica**, com Complicou/Sucesso Parcial/Sucesso Total (5
opções cada), no mesmo formato de todas as outras Moves do sistema. Isso
poupa a parte mais cara (design da regra).

## Ajuste importante: o pet é um item craftado, não um bicho à parte

O que sai do ovo não é uma entidade solta com ficha própria — é o **craft
do Domador**, no mesmo molde que Ferreiro crafta arma e Alquimista crafta
poção: tem **raridade**, e a raridade define o efeito ("bate, dá dano,
enfim" — igual qualquer item do catálogo). Isso significa:

- O pet segue a mesma régua de `armas/00_catalogo_expandido.md` ("a
  facilidade de obter define o teto" — Comum sem bônus, Incomum um +1
  situacional, Raro +1 mais efeito único que cobra um preço).
- A Move do ovo (`Domador.png`) continua sendo o **processo** (como se
  consegue); o pet resultante é o **produto**, com ficha curta que cabe no
  mesmo formato de item que já existe — não precisa de sistema de "bicho
  com stats próprios" à parte.
- Reaproveita a tabela `producao`/`PRODUCAO` que já existe pra outros
  ofícios (`docs/producao_por_oficio.md`) — Domador ganha uma linha lá
  igual às outras 15 profissões.

## Decidido: ferramenta de ofício — Incubadora com nível

Novo conceito, nasce aqui mas é pensado pra se repetir em outras
profissões (ver `14_ferramentas_de_oficio.md`): o Domador tem uma
**Incubadora**, que sobe de nível (craft/compra/upgrade, a definir), e
quanto maior o nível dela, **maior a chance do ovo chocar com sucesso**.
Isso é separado de Nível de Profissão (item 5) — Nível de Profissão mede
progresso geral do Domador; nível de Incubadora é um multiplicador
específico só pra essa ação (chocar ovo), preso a um item/ferramenta que
o jogador pode upar independente do próprio nível.

## O que falta

1. **De onde vem o ovo** — decidir quais monstros (de quais) passam a ter
   "ovo" na tabela de drop, e com que raridade. Isso é decisão de conteúdo,
   monstro por monstro (hoje só o Andar 1 tem ~50).
2. **Rastrear a incubação** — schema novo: um jogador "carregando" um ovo
   precisa de estado (tempo/condição de choco, sucesso ou não). Cabe dentro
   de `personagens.estado` (já é jsonb) ou uma tabela própria
   `criaturas_domadas` se quiser histórico de mais de uma criatura por
   personagem — recomendo a tabela própria, fica mais fácil de listar no
   painel do mestre.
3. Registrar a Move em `docs/guia_sistema_aincrad.md` (seção Domador) e na
   tabela `moves_profissao` do banco.
4. Atualizar a ficha de Domador em `docs/oficios_andar1.md` mencionando a
   nova via de vínculo.

## ✅ Resolvido (10/08) — achado que a mecânica já estava quase toda construída

Varredura encontrou: `chocar_ovo`/`verificar_chocagem` (RPCs), `ovos_catalogo`
(12 ovos já curados: Rato Gigante → Fênix Bebê, raridade/nível/incubadora_min
progressivos), 4 receitas de Incubadora já escritas (Pequena→Média→Sagrada→
Primordial, a última em refino 2 estágios), e `PetsTab.vue` inteiro
funcional (3 abas: Meus Ovos → Chocar → Incubando com timer ao vivo →
Ativos). Isso **já responde as perguntas antigas** sem eu ter que inventar:

- **Ovo é curado, não "qualquer bicho"** — 12 espécies específicas hoje.
- **Substitui, não convive** — Doma (bicho adulto) já estava marcada
  removida em `docs/visao_geral.md`; não tem "os dois". A Move de Ofício
  do Domador em `moves_profissao` ainda estava com o texto antigo de Doma
  (nunca atualizada) — troquei pelo texto real de "Ovo de Fera"
  (`dolist/Domador.png`, PBTA +Técnica, Complicou/Parcial/Total).
- **Escala só por raridade** — `ovos_catalogo.efeitos_padrao` por ovo,
  sem termo de "espécie mais forte = pet melhor" fora da raridade.
- **Incubadora sobe por craft**, 4 estágios (curva curta) — já decidido
  nas receitas existentes.

**O que estava genuinamente quebrado (corrigido em
`scripts/db/schema_incubadora_e_ovos.sql`):**

1. `ferramentas_oficio` (de onde `chocar_ovo` lê o nível da incubadora)
   não tinha **nenhuma linha** — craftar a Incubadora "funcionava"
   (upsert em `personagem_ferramentas`) mas o nível nunca existia em
   lugar nenhum pra ler; todo Domador ficava travado em nível 1 pra
   sempre. Criadas as 4 linhas (níveis 1/2/3/5 — pulei o 4 de propósito,
   os nomes Sagrada→Primordial já eram um salto direto nas receitas
   originais).
2. `criaturas_domadas.monstro_id` tinha **FK pra `monstros`**, mas 10 dos
   12 `ovos_catalogo.monstro_id` são espécie "roster" do item 4 (nome
   existe, ficha jogável completa ainda não foi escrita — projeto GG à
   parte). Isso quebrava `chocar_ovo` com erro de FK pra 10 de 12 ovos.
   FK removida — pet não deveria depender de o monstro de origem já ter
   ficha de combate completa.
3. ✅ **Nenhuma missão tinha `drop_item_id` apontando pra um ovo** —
   fechado numa rodada seguinte. `n1-caca-ratos`→`ovo_ratogig` já casava
   com missão existente; as outras 11 espécies ganharam missão de caça
   nova cada (decisão do usuário: "escrever missão de caça nova pra cada
   espécie"), em `scripts/db/_seed_missoes_ovos.py`. **12 de 12 ovos com
   fonte real agora.**
4. ✅ Achado testando as missões novas: `aceitar_e_resolver_missao`
   quebrava (erro de SQL cru) sempre que o drop de qualquer missão
   não-arma realmente caía — bug preexistente que afetava **80 das 100
   missões do jogo**, não só as de ovo. Corrigido — detalhe em
   `docs/pendencias.md`.

Testado de ponta a ponta com rollback: chocar sem incubadora suficiente
bloqueia com a mensagem certa, craftar/possuir a ferramenta libera o
nível certo, chocar com sucesso cria a criatura "incubando", e
`verificar_chocagem` depois do tempo passar vira "ativo".
