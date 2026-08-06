---
titulo: 3 ataques por arma + Limit Breaker
tamanho: G
uso: mestre
---

# 3 ataques por arma (2 normais + Limit Breaker)

## A ideia

Cada uma das 23 armas ganha **3 golpes nomeados** em vez de 1 Move de
Combate só:
- 2 ataques "normais", cada um usando um **atributo diferente** (ex: foice
  hoje só usa Técnica — um segundo golpe dela usaria Corpo, um terceiro
  Reflexo, por exemplo).
- 1 **Limit Breaker**: um golpe especial destravado por um **contador de
  sucesso/erro** — ao bater 10, o jogador pode usar.

## Por que isso é o maior item da lista

Isso não é "adicionar uma regra" — é redesenhar **69 movesets** (23 armas ×
3), cada um precisando de: nome, atributo, gatilho, resultado em 10+/7-9/6-,
e cuidado pra não duplicar o que a Move de Combate atual já cobre. É
comparável, em volume de design, a ter feito as 23 armas originais de novo.

Além disso precisa de:
- **Mecanismo de contador**: onde ele mora (por personagem? por arma
  equipada? zera ao trocar de arma?), como sobe (todo teste conta, só
  combate conta, só uma arma específica soma), e onde fica salvo — schema
  novo, provavelmente uma coluna em `personagens.estado` ou tabela própria
  se for por-arma.
- **Retrofit** no que já existe: `moves_arma` no banco hoje tem só
  `move_a`/`move_b` — vira `move_a`/`move_b`/`move_c`, e o painel
  `admin.html` + `admin_schema.js` precisam do campo novo.
- Balanceamento: dois golpes "normais" por arma não podem competir demais
  com o golpe já existente, nem tornar irrelevante a escolha de atributo
  principal da arma.

## Preciso saber

- O Limit Breaker é **um contador por personagem** (qualquer teste soma) ou
  **por arma equipada** (só rolagem daquela arma soma)?
- Zera depois de usado, ou depois de uma sessão, ou nunca (só sobe)?
- Quer que eu comece desenhando **uma arma só** como modelo (pra você
  aprovar o formato antes de eu repetir 22 vezes), ou já tenta as 23 de
  uma vez?
