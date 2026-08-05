---
andar: 2
nome: Aincrad — Andar 2
status: esboço inicial
---

# Mapa do Andar 2 (esboço)

**Aviso:** isto é um esboço de regiões, não um mapa jogável completo como
`mapas/andar_1.md` (que tem Compêndio interativo com 30 regiões e 273+
pontos). O andar 2 ainda não tem app próprio — quando houver conteúdo
suficiente, replicar o pipeline de `scripts/gerar_dados_web.py` +
`scripts/web/dados_mapa.js` pra este andar também.

## Geografia geral

Diferente do andar 1 (terreno misto, sem tema único), o andar 2 tem
identidade forte: **planalto árido e colinas secas**, cortado por um
sistema de aquedutos de pedra que traz água do Lago Sylvaine (andar 1)
andar abaixo. Onde a água dos aquedutos chega, a terra vira verde e fértil
numa faixa estreita — o resto é planalto seco, pastagem esparsa e pedra
exposta.

```
        COLINAS SECAS (norte)
        pastagem esparsa, poucos monstros
                    |
                    |         AQUEDUTO PRINCIPAL
                    |         (traz água do andar 1)
                    |________________
                    |                \
         URBUS ●----+                 \
      (cidade principal,               ● Fazendas da Faixa Verde
       ao redor do ponto de              (única agricultura real
       chegada da água)                   do andar 2)
                    |
                    |
              LABIRINTO DO ANDAR 2 (a definir)
              -> leva ao andar 3
              guardado por Baran, o Rei Touro
```
(Diagrama aproximado, só pra orientação de mesa — sem coordenadas de
Compêndio ainda.)

## Regiões conhecidas

### Urbus (cidade principal)
Construída ao redor do ponto onde o Aqueduto Principal despeja água vinda
do andar 1. Ver `cidades/urbus.md`. Zona segura.

### Colinas Secas
Planalto árido ao norte de Urbus — pastagem esparsa, pouca sombra, monstros
de território aberto. Primeiro terreno de combate do andar 2 (ver
`monstros/touro_das_colinas.md`, `monstros/aguia_do_planalto.md`).

### Faixa Verde (Fazendas)
Estreita faixa de terra fértil ao longo do curso visível do Aqueduto
Principal antes dele mergulhar de volta sob a rocha. Única agricultura real
do andar — e, por isso, ponto de tensão econômica e social (ver
`cenas/quests_andar2.md`).

### Aqueduto Principal
Estrutura de pedra que atravessa boa parte do andar, carregando água do
Lago Sylvaine do andar 1. Mecanismo de Cardinal, não fenômeno natural — os
moradores de Urbus sabem disso e preferem não pensar muito a respeito (ver
`npcs/engenheira_dos_aquedutos.md`).

### Labirinto do Andar 2 (a definir)
Ainda não desenvolvido — guardado por **Baran, o Rei Touro**
(`monstros/baran_o_rei_touro.md`), o chefe de andar. Nome e forma geral são
canônicos; layout interno é homebrew a construir quando o andar avançar
além do esqueleto inicial.

## O que falta (próximos blocos)

- Coordenadas reais e pontos nomeados (mesmo padrão de `dados_mapa.js`).
- Segunda cidade menor (se houver — a definir).
- Layout do Labirinto do Andar 2, sala a sala.
- Vistas de arte (`scripts/gerar_mapa_arte.py` já suporta gerar pra outros
  andares, só precisa do prompt de geografia certo).
