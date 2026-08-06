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

## Preciso saber

- Ovo é item que dropa de **qualquer** fera domável, ou só de bichos
  específicos escolhidos a dedo?
- O pet nascido de ovo **substitui** a doma de bicho adulto que o Domador já
  faz hoje (`Move de Ofício — Doma`), ou os dois convivem (doma no campo
  pra vínculo grande, ovo pra pet-item mais rápido/descartável)?
- Efeito do pet escala só com raridade (igual item comum), ou também com o
  tipo de monstro de origem (ovo de monstro forte vira pet melhor mesmo em
  raridade Comum)?
