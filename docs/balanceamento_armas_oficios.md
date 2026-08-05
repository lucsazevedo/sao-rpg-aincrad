---
titulo: Balanceamento — Armas x Ofícios (auditoria)
andar: 1
uso: mestre
data: rodada de varredura final
---

# Balanceamento — Armas x Ofícios

Auditoria pedida numa rodada de "varredura geral" antes de fechar o
projeto: comparar as 22 armas e as 16 profissões, achar desequilíbrio real
(não cosmético) e corrigir o que for corrigível sem reescrever o sistema.
Números levantados programaticamente a partir de
`docs/guia_sistema_aincrad.md`, `armas/00_catalogo_expandido.md` e
`equipamentos/`.

## Achado 1 — distribuição por atributo é desigual, mas de dois jeitos que se compensam parcialmente

| Atributo | Armas (de 22) | Profissões (de 16) | Total combinado |
|---|---|---|---|
| Corpo | 6 | 1 | 7 |
| Reflexo | 5 | 2 | 7 |
| Técnica | 7 | 4 | 11 |
| Conhecimento | 2 | 6 | 8 |
| Espírito | 2 | 3 | 5 |

**Leitura:** Corpo é forte em armas (Escudo e Espada, Espada Longa, Machado,
Martelo, Clava, Manopla) e quase sozinho em profissão (só Mercenário).
Conhecimento é o oposto: fraquíssimo em arma (só Chicote e Pá) mas o mais
forte em profissão (6 das 16). Técnica é a combinação mais robusta (7 armas
+ 4 profissões = 11). **Espírito é o atributo com menos opções totais (5)**
— só Katana/Bastão como arma e Coveiro/Médico/Músico como profissão.

**Isto é bug?** Não necessariamente. `docs/guia_sistema_aincrad.md` ("Criando
um personagem") não exige que arma e profissão compartilhem atributo — são
duas escolhas independentes. Um personagem de Espírito alto pode perfeitamente
usar Machado (Corpo) e ser Coveiro (Espírito), por exemplo. **Mas** vale
deixar isso explícito pro mestre, porque um jogador novo tende a presumir
que arma e profissão "devem" combinar. Adicionada uma nota nesse sentido em
`docs/guia_sistema_aincrad.md` (ver "Criando um personagem").

**Ação:** nenhuma mudança estrutural — mudar isso significaria inventar arma
23 ou profissão 17, fora do escopo canônico do sistema. Documentado aqui
pra constar, e a nota de esclarecimento foi adicionada ao manual.

## Achado 2 — corrigido: Conhecimento não tinha nenhum item Raro

Contagem de `armas/00_catalogo_expandido.md` (antes da correção): 22
Incomuns (um por tipo) + 6 Raros — mas os 6 Raros cobriam Reflexo (Arco e
Flecha, Rapieira), Corpo (Escudo e Espada, Martelo), Espírito (Katana) e
Técnica (Lança). **Conhecimento (Chicote e Pá) ficou de fora — o único
atributo sem nenhum item Raro no andar inteiro.**

**Corrigido nesta rodada:** adicionado **Chicote de Raiz-Mãe** (Raro,
Conhecimento), com fonte concreta (drop da Mãe-Raiz de Horunka,
`monstros/mae_raiz_de_horunka.md`, craftado por Ferreiro + Costureiro —
mesma lógica de dois-ofícios já usada no Arco do Arauto). Catálogo agora:
29 itens novos (22 Incomum + 7 Raro), 51 armas no total. Ver
`armas/00_catalogo_expandido.md`.

## Achado 3 — equipamentos (7 slots, 66 itens): já bem distribuído, sem ação necessária

| Slot | Itens | Raros |
|---|---|---|
| Acessórios | 12 | 1 |
| Armaduras | 10 | 1 |
| Capuz | 9 | 1 |
| Luvas | 9 | 1 |
| Parte de Baixo | 9 | 1 |
| Parte de Cima | 9 | 1 |
| Escudos | 8 | 1 |

Todos os 7 slots têm exatamente 1 item Raro e uma quantidade de itens
próxima (8-12). Isto já estava balanceado — nenhuma mudança feita.

## Achado 4 — renda por profissão: já verificado numa rodada anterior, reconfirmado

`docs/mercado_andar1.md` (seção final, "Nota de balanceamento entre
profissões") já lista uma fonte de renda concreta e nomeada pra cada uma
das 16 profissões (Ferreiro, Joalheiro, Costureiro etc. com preço real;
Diplomata/Coveiro/Músico — historicamente as mais "magras" — com peça de
equipamento dedicada). Reconferido nesta rodada: continua válido, nenhuma
profissão ficou sem mecânica de renda. Nenhuma mudança necessária.

## Achado 5 — fraqueza elemental: Veneno é raro por design, não por erro

Contagem de `elemento_fraqueza` nos 49 monstros: Fogo 23, Trovão 13, Gelo 8,
Veneno 4. Parece desequilibrado à primeira vista, mas
`docs/elementos_andar1.md` já explica a intenção: Fogo é "o mais comum e o
mais fácil de improvisar", Veneno é "o elemento de quem não pode vencer no
golpe" — deliberadamente nichado, e explicitamente **não funciona** contra
construto/morto-vivo/planta. Distribuição consistente com o próprio texto de
design. **Nenhuma mudança feita** — isto não é desequilíbrio, é a curva
pretendida.

## Resumo do que mudou nesta auditoria

- ✅ Adicionado 1 item Raro de Conhecimento (Chicote de Raiz-Mãe) — único
  fix estrutural necessário.
- ✅ Nota explicativa adicionada ao manual sobre arma/profissão serem
  escolhas independentes.
- ✅ Confirmado (sem mudança): equipamentos, renda por profissão, curva de
  elementos — já estavam corretos.
- 📝 Documentado, sem ação: a assimetria arma/profissão por atributo
  (Corpo forte em arma e fraco em profissão; Conhecimento o oposto) — é
  estrutural ao sistema de 22 armas + 16 profissões fixas, não há correção
  sem alterar o número canônico de armas ou profissões.
