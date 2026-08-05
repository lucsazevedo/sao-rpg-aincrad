# Guia de estilo — música e efeitos sonoros (MusicGen)

Tudo é gerado pelo mesmo modelo (MusicGen-medium, via `C:\AI\AudioCraft`) —
só muda o estilo do prompt entre música e efeito sonoro. Prompts são sempre
em inglês (convenção já usada em `gerar.py`/`gerar_trilhas_sao.py`); o
conteúdo de lore (NPCs, cenas) é gerado em português, só o prompt de áudio
em si vai em inglês.

**Regra geral do projeto**: toda decisão criativa (música, visual, tom de
NPC, o que for) se ancora na obra real de Sword Art Online, não em
fantasia genérica — evita a mesa parecer "RPG medieval qualquer com nome
de SAO em cima".

## O som real de SAO (referência, sem copiar — usar como vocabulário)

A trilha original é da **Yuki Kajiura** (mesma compositora de .hack//,
Fate/Zero, Madoka Magica). Características que valem reproduzir em prompt:

- **Combate**: híbrido orquestral + eletrônico — cordas em **ostinato**
  (padrão curto repetido, cria tensão), batida eletrônica por baixo do
  orquestral, às vezes coral/vocalise (aqui GERAMOS SEM VOCAIS por
  decisão do projeto — ver abaixo).
- **Exploração/Aincrad**: etéreo e um pouco melancólico — piano, cordas
  sustentadas, clima "bonito mas triste" (é gente presa lutando pela vida
  disfarçado de RPG bonito, não uma aventura despreocupada).
  - **Aberturas**: J-rock/pop direto (referência: "Crossing Field",
    "INNOCENCE", ambas da LiSA) — guitarra elétrica, bateria animada,
    energia heroica. É o único bloco que foge do "orquestral Kajiura" de
    propósito, igual no anime.

Sempre terminar prompts de música com `instrumental, no vocals, no singing`
— decisão consciente do projeto: o som de Kajiura usa muito coral/vocalise,
mas colocar vocais no MusicGen tende a sair como letra falsa/robótica
(problema já visto), então preferimos abrir mão do coral a arriscar isso.

## Categorias de música já estabelecidas (`musicas/`)

| Categoria | Uso | Vocabulário típico |
|---|---|---|
| `01_abertura` | tema de abertura da campanha/sessão | anime opening theme, J-rock/pop, bright synth brass, driving rock drums, heroic (referência: Crossing Field/INNOCENCE) |
| `02_ambiente` | exploração de campo aberto | orchestral strings ostinato, ethereal, bittersweet, electronic texture underneath, cinematic anime score |
| `03_combate` | combate comum | driving string ostinato, electronic pulse under orchestral, tense, fast paced, cinematic |
| `04_combate_epico` | combate contra monstro forte/elite | huge orchestral strings ostinato, aggressive electronic beat, relentless, epic |
| `05_combate_boss` | chefe de andar | dark orchestral hybrid, heavy electronic pulse, dissonant strings, menacing, epic scale |
| `06_cidade` | zona segura (Cidade do Início etc.) | warm strings and piano, gentle, bittersweet undertone, cinematic anime score, cozy but not fully carefree |

Sempre terminar prompts de música com `instrumental, no vocals, no singing`
a menos que o pedido explicitamente peça vocais.

## Tom específico do momento atual da campanha (dia 10, andar 1)

A Cidade do Início ainda tem um clima dividido: parte de alívio/aconchego
(zona segura) e parte de tensão latente (medo, jogadores que não saem mais
de casa). Ambientes de `02_ambiente` e `06_cidade` neste ponto da história
podem usar termos como `bittersweet`, `uneasy calm`, `quiet dread beneath
a peaceful town` em vez de só "cheerful" — ainda não é uma vitória, é
sobrevivência.

## Vocabulário de efeitos sonoros (SFX) específicos de SAO

Efeitos sonoros vão para `efeitos_sonoros/`, sempre com prompts objetivos e
físicos (o que o som É, não o que ele "representa"):

| Efeito | Prompt sugerido |
|---|---|
| Menu de sistema (abrir/fechar) | `soft digital UI chime, clean synth blip, futuristic interface sound, short` |
| Ativação de Sword Skill | `whoosh with a sharp metallic ring, energy charge up, short powerful blade swing` |
| Item/Col coletado | `bright short chime, pickup notification sound, satisfying and light` |
| Cristal de teleporte ativando | `crystalline shimmer, rising magical sparkle, glass resonance, teleport activation` |
| Cristal de cura | `warm soft chime, gentle healing sparkle, short magical shimmer` |
| Cristal se estilhaçando (quebra) | `glass shattering, crystal breaking, sharp bright shatter, short` |
| Level up / fanfarra curta | `short triumphant fanfare, bright synth and brass hit, rewarding` |
| Passos em masmorra | `footsteps on stone corridor, echoing, slow cautious walking, dungeon ambience` |
| Ambiente de masmorra | `dark dungeon ambience, distant dripping water, stone corridor reverb, tense quiet` |
| Rugido de monstro (andar 1) | `low guttural monster growl, threatening creature roar, close range` |
| Impacto de espada/metal | `metal sword clash, sharp steel impact, quick two-hit clang` |
| Praça de cidade (ambiente) | `town plaza ambience, distant chatter, light footsteps, calm marketplace` |

Use esta tabela como ponto de partida em `gerar_sao.py`, mas deixe o Ollama
adaptar o prompt ao pedido específico do usuário.
