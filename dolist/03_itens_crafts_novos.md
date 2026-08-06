---
titulo: Itens e receitas de craft novas
tamanho: P–M
uso: mestre
---

# Itens/crafts novos

## A ideia

Você mencionou já ter uma série de itens e receitas de craft pensados —
ainda não sei o volume nem o formato (lista solta, imagem, rascunho em
outro lugar).

## Por que o tamanho está em aberto

O caminho pra integrar já existe e é barato de rodar por item: ficha em
`.md` (seguindo `armas/_modelo_arma.md` ou `equipamentos/00_indice.md`) →
`gerar_dados_web.py` → `migrar_para_supabase.py`. O custo real depende só
de **quantos itens** e se já estão em formato perto do que o sistema espera
(nome, raridade, requisito, efeito, obter) ou se precisam ser escritos do
zero a partir de uma ideia solta.

## Preciso saber

- Onde está esse material? (Cola aqui, joga na pasta `dolist/`, ou descreve
  um por um?)
- É item de fato novo (arma/equipamento tipo já existente com efeito novo),
  ou introduz mecânica nova (tipo carta — ver item 7 — ou algo sem
  equivalente hoje)?
