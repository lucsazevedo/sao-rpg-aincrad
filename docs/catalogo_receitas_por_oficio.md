---
titulo: Catálogo de Receitas por Ofício — o cardápio concreto de cada profissão
andar: 1
uso: jogador_e_mestre
status: completo — 16 de 16 profissões formalizadas
---

# Catálogo de Receitas por Ofício

## De onde isso vem

`docs/producao_por_oficio.md` e `docs/oficios_andar1.md` dão às 16 profissões
uma **regra abstrata** de produção: role d20+atributo, olhe a faixa de
resultado, narre o que sai. Isso garante que nenhuma profissão fique sem
fazer nada — mas "role e narre" não é a mesma coisa que abrir um cardápio e
escolher **o Bife do Guerreiro** em vez da **Sopa Revigorante**.

`Comidas/` fechou esse cardápio pro Cozinheiro: 17 receitas nomeadas,
organizadas em 3 dificuldades, cada uma com materiais concretos e um efeito
de cena. Isso é bom demais pra ficar só com uma profissão — as outras 15
ficam pra trás na hora de escolher personagem se só o Cozinheiro tem prato
com nome. Este arquivo generaliza o padrão pras 16.

## O padrão — igual pra todas

Toda profissão que produz **Matéria** (ver a tabela de moedas em
`producao_por_oficio.md`) ganha um catálogo com **exatamente 17 receitas**,
na mesma proporção do Cozinheiro:

| Faixa | Quantidade | Nome da faixa | Equivale à raridade de item (`armas/00_catalogo_expandido.md`) |
|---|---|---|---|
| **Dificuldade: Falha** | 8 receitas | Básicas | Comum |
| **Dificuldade: Sucesso parcial** | 5 receitas | Especiais | Incomum |
| **Dificuldade: Sucesso total (CD+5)** | 4 receitas | Lendárias | Raro / Único |

O nome da faixa **não é o resultado do dado** — é o **piso de teste** que a
receita pede pra sair boa. Isso encaixa direto na faixa de resultado que já
existe na Ação de Ofício de cada profissão (`oficios_andar1.md`): quem tira
**sucesso total** na ação "produzir com bônus" pode escolher qualquer receita das três
faixas (se tiver o material); quem tira **sucesso parcial** só destrava até Especial;
quem tira **falha** ainda sai com uma Básica — porque "produção nunca é 'não
saiu'", regra que já vale pro sistema inteiro.

Cada receita segue este formato:

```
### Nome da Receita — Dificuldade X

**Materiais:** lista curta, real, com origem no mapa
**Efeito:** o que muda numa cena/expedição — narrativo, não numérico,
exceto nas Lendárias (ver abaixo)
**Como conseguir os materiais:** onde no andar 1, de preferência ligado a
um posto de trabalho que já existe em `oficios_andar1.md`
```

## Onde a regra de raridade entra

A regra de `armas/00_catalogo_expandido.md` ("facilidade de obter define o
teto") vale igual aqui:

- **Básicas (falha):** zero bônus numérico. Só utilidade estreita — vantagem
  narrativa numa situação específica, nunca em teste de combate direto.
- **Especiais (sucesso parcial):** um efeito situacional mais forte, ainda sem número
  fixo — pode tocar teste de combate (ex: "vantagem no primeiro ataque"),
  mas nunca +1 permanente, e nunca dois efeitos ao mesmo tempo.
- **Lendárias (sucesso total):** aqui sim pode quebrar a curva — efeito de grupo,
  escolha de atributo, remoção de Condição sem gastar Cristal — porque o
  material exige quest de cadeia, drop de chefe ou coisa que só existe uma
  vez. **Não é vendida.** Se sua mesa quiser vender mesmo assim, use o preço
  de um Raro (não se compra, se conquista).

## Sobre o preço — por que não copiei o número das imagens

As imagens que você colocou em `armas/` (`ChatGPT_Image_..._1.png` a `_4.png`,
mais `ff813c9f...png`, `30a5a3f4...jpg`, `33e57a94...jpg`, `40e3c5b8...jpg`)
têm duas famílias de número:

1. **Loja Geral / Empório / Recursos** (armas 90-320, armadura 80-500,
   ferramenta 15-220, ingrediente cru 2-12 Col): isso **já bate** com
   `docs/mercado_andar1.md` — inclusive "Cristal Pequeno 80 Col" é o mesmo
   valor nas duas fontes. Usei esses direto.
2. **Relicário, Cristalaria, Oficina de Aincrad** (acessório 3000 Col fixo,
   cristal até 3000 Col, prato/arma craftado 1500-4000 Col): esses números
   são **10 a 40x** a renda de uma quest (`mercado_andar1.md` diz que um
   grupo de 4 no dia 10 tem 300-800 Col **juntos**). Copiar isso ao pé da
   letra quebraria a régua de "Incomum não se compra fácil, Raro não se
   compra" que o resto do catálogo já respeita.

**O que eu fiz:** usei a **ideia** das imagens — nome, categoria, a
progressão de raridade em 3 degraus, cristal/acessório/receita como
famílias de item — e encaixei o **valor de referência** na régua que já
existe: Básica 20-40 Col (mesmo número que `mercado_andar1.md` já usa pra
"Refeição preparada por um Cozinheiro"), Especial 150-300 Col (mesma faixa
de "Quest Importante"), Lendária sem preço. Se você quiser mesmo os números
das imagens ao pé da letra, é só falar — mas isso exige subir a renda de
quest/monstro em todo o andar junto, senão ninguém nunca junta Col pra usar
o próprio catálogo.

## Roteiro — as 16 profissões

| # | Profissão | Moeda | Domínio da receita | Pasta/arquivo | Status |
|---|---|---|---|---|---|
| 1 | Cozinheiro | Matéria | Comida | `Comidas/00_catalogo_receitas_cozinheiro.md` | ✅ feito |
| 2 | Alquimista | Matéria | Poções & Cristais | `pocoes/00_catalogo_pocoes_alquimista.md` | ✅ feito |
| 3 | Ferreiro | Matéria | Componentes & Reforjas | `docs/receitas_ferreiro.md` | ✅ feito |
| 4 | Costureiro | Matéria | Costuras & Reforços | `docs/receitas_costureiro.md` | ✅ feito |
| 5 | Joalheiro | Matéria | Engastes & Lapidação | `docs/receitas_joalheiro.md` | ✅ feito |
| 6 | Coveiro | Matéria | Relíquias & Rituais | `docs/receitas_coveiro.md` | ✅ feito |
| 7 | Caçador | Matéria | Preparo de Caça | `docs/receitas_cacador.md` | ✅ feito |
| 8 | Lenhador | Matéria | Construções & Ferramentas | `docs/receitas_lenhador.md` | ✅ feito |
| 9 | Domador | Serviço | Petiscos & Rituais de Doma | `docs/receitas_domador.md` | ✅ feito |
| 10 | Médico | Serviço | Tratamentos & Kits | `docs/receitas_medico.md` | ✅ feito |
| 11 | Cartógrafo | Conhecimento | Cartas & Rotas especiais | `docs/servicos_cartografo.md` | ✅ feito |
| 12 | Comerciante | Conhecimento | Contratos & Avaliações | `docs/servicos_comerciante.md` | ✅ feito |
| 13 | Diplomata | Conhecimento | Acordos & Selos | `docs/servicos_diplomata.md` | ✅ feito |
| 14 | Bibliotecário | Conhecimento | Compêndios & Dossiês | `docs/servicos_bibliotecario.md` | ✅ feito |
| 15 | Músico | Serviço | Composições | `docs/servicos_musico.md` | ✅ feito |
| 16 | Mercenário | Serviço | Táticas & Contratos | `docs/servicos_mercenario.md` | ✅ feito |

Ferreiro, Costureiro e Joalheiro **já têm** catálogo concreto de item
pronto (`armas/`, `equipamentos/`) — o catálogo novo deles cobre só
**componente/reforço/serviço de oficina**, sem duplicar as 50 armas e 66
equipamentos que já existem.

Serviço e Conhecimento (Cartógrafo, Comerciante, Diplomata, Bibliotecário,
Músico, Mercenário, Domador, Médico) não craftam objeto — a "receita" deles
vira **serviço com 3 tiers**, mesma proporção 8/5/4, mesma lógica de preço,
mas o "material" é tempo/reputação/informação em vez de item físico.

## Conferência

| | Antes | Depois |
|---|---|---|
| Profissões com cardápio concreto | 1 (Cozinheiro, só em imagem) | **16** |
| Receitas/serviços nomeados | 17 (não formalizados) | **272** (17 × 16) |
| Profissões sem nada nomeado além do abstrato | 15 | **0** |

Cada arquivo segue **exatamente** 8 Básicas / 5 Especiais / 4 Lendárias —
conferido item a item na hora de escrever. Se alguma sessão futura
adicionar receita nova a uma profissão, adicione o par em outra pra manter
a conta 17-17, do jeito que `docs/oficios_andar1.md` já protege a conta de
3 Ações de Ofício por profissão.
