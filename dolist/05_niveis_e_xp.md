---
titulo: Sistema de Níveis e XP
tamanho: M
uso: mestre
---

# Sistema de Níveis e XP

> **Superado pela conversão pra D&D 5e.** A decisão registrada abaixo
> (Marco na mesa, XP só no jogo online) foi substituída pela tabela de
> XP/Nível padrão de D&D 5e — Seção 71 do `SAO_RPG_5e.md`, que agora vale
> tanto pra mesa quanto pro jogo online (nível de personagem de verdade,
> não mais nível de profissão fazendo essa vez). Texto abaixo mantido como
> histórico da decisão anterior.

## A tensão que isso cria

A regra atual (`docs/regras_nucleares_campanha.md`) é explícita: **"Não
existe XP por matar"** — progressão de personagem hoje é por **Marcos**
(momento narrativo: mudou algo no andar, escolheu um custo, aprofundou
vínculo, etc.), não por contagem de abate. Um sistema de Nível/XP tradicional
é o oposto filosófico disso.

## Decidido: leitura 1, e mais específico — é Nível de Profissão

Confirmado: XP/Nível existe **só no jogo online**, o personagem de mesa
continua evoluindo só por Marco (sem misturar os dois sistemas). E mais
fechado que a leitura original: **o XP do online é especificamente Nível
de Profissão** — não é um "nível de personagem" genérico. Cada uma das 16
profissões tem sua própria curva/XP, subindo com craft/missão daquele
ofício.

**Nível de Profissão desbloqueia/facilita craft** (receita nova, chance
melhor de sucesso — ver `01_domador_criador.md` pra exemplo de ferramenta
que também mexe nisso) **e agora também define a chance de sucesso em
combate/missão** — ver `12_sistema_de_poder.md`, que descartou o Poder por
equipamento e passou a usar Nível como única régua de risco.

## ✅ Fechado (10/08)

Perguntei direto: criar um "Nível de Personagem" novo, separado de Marcos
e Nível de Profissão? Resposta: **não criar nada novo** — confirma a
leitura que já estava decidida aqui. Nível de Profissão continua sendo a
única régua real online (é o que toda RPC de missão/combate/craft desta
sessão já usa) e Marcos continua sendo a da mesa. Item fechado, sem
mecanismo novo pra construir.

## Pendência aberta (resolvida na prática pelo código já escrito)

- Personagem com mais de uma profissão ativa: a chance de sucesso usa **a profissão RELACIONADA À AÇÃO** (ex: combate usa profissão de combate direto, craft usa a profissão do craft, social usa Diplomata). Se não tiver correspondência exata, usa o **Nível de Profissão mais alto** que o personagem tiver.
- 16 profissões, cada uma com Nível 1-10 (ver schema). Tabela de XP implementada no banco: `nivel_profissao_xp` (nível 2 = 100 XP, nível 3 = 250, nível 4 = 500, nível 5 = 1.000, nível 6 = 2.000, nível 7 = 3.500, nível 8 = 6.000, nível 9 = 10.000, nível 10 = 18.000). Craft bem-sucedido dá XP igual à dificuldade da receita; missão de ofício dá XP bônus fixo por andar.
