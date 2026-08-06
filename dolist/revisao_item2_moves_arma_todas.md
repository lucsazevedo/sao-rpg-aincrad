---
titulo: Revisão — golpes novos pras 23 armas (item 2)
uso: mestre
---

# Proposta do Ollama — 2 golpes extra + Limit Breaker por arma

Gerado automaticamente (modelo: devstral:24b). **Nada aplicado ainda** — proposta arma por arma, pra revisar antes de somar aos moves já existentes em `MOVES_ARMA`/banco.

## Arco e Flecha
- arma: `Arco e Flecha`
- atributo principal: Reflexo
```json
{
 "golpe_2": {
  "nome": "Tiro de Precisão",
  "atributo": "Conhecimento",
  "teste": "2d6+Conhecimento",
  "dez_mais": [
   "Você acerta um ponto crítico, causando dano adicional e desativando temporariamente uma habilidade específica do alvo."
  ],
  "sete_nove": [
   "Você acerta o alvo, mas a flecha fica presa em sua armadura ou equipamento, impedindo-o de usar essa peça por uma rodada."
  ]
 },
 "golpe_3": {
  "nome": "Tiro Explosivo",
  "atributo": "Espírito",
  "teste": "2d6+Espírito",
  "dez_mais": [
   "A flecha explode ao atingir o alvo, causando dano em área e lançando inimigos próximos para trás."
  ],
  "sete_nove": [
   "Você causa um pequeno impacto explosivo, mas a força da explosão é menor do que o esperado, causando apenas metade do dano em área."
  ]
 },
 "limit_breaker": {
  "nome": "Tiro de Luz",
  "atributo": "Corpo",
  "efeito": [
   "Você concentra toda sua energia no tiro, disparando uma flecha de luz que atravessa qualquer barreira e causa um dano devastador ao alvo. Além disso, a luz cega temporariamente inimigos próximos."
  ]
 }
}
```

## Adagas
- arma: `Adagas`
- atributo principal: Técnica
```json
{
 "golpe_2": {
  "nome": "Golpe de Agilidade",
  "atributo": "Reflexo",
  "teste": "2d6+Reflexo",
  "dez_mais": [
   "Você desvia do ataque inimigo e realiza um contra-ataque rápido, causando dano extra."
  ],
  "sete_nove": [
   "Você consegue evitar o ataque inimigo, mas sua posição é comprometida."
  ]
 },
 "golpe_3": {
  "nome": "Golpe de Oportunidade",
  "atributo": "Conhecimento",
  "teste": "2d6+Conhecimento",
  "dez_mais": [
   "Você identifica um ponto fraco no inimigo e realiza um ataque preciso, causando dano crítico."
  ],
  "sete_nove": [
   "Você consegue causar algum dano, mas o inimigo percebe seu movimento e se defende melhor."
  ]
 },
 "limit_breaker": {
  "nome": "Dança das Adagas",
  "atributo": "Corpo",
  "efeito": [
   "Você entra em um estado de fúria intensa, realizando uma série de ataques rápidos e precisos. Todos os inimigos próximos sofrem dano significativo.",
   "Seu corpo é sobrecarregado pela intensidade do ataque, causando um pequeno dano a si mesmo."
  ]
 }
}
```

## Adagas de Arremesso
- arma: `Adagas de Arremesso`
- atributo principal: Reflexo
```json
{
 "golpe_2": {
  "nome": "Golpe Sombrio",
  "atributo": "Espírito",
  "teste": "2d6+Espírito",
  "dez_mais": "Você golpeia seu inimigo com uma precisão mortal, causando grande dano. Escolha entre causar um dano extra ou aplicar um efeito de status.",
  "sete_nove": "Seu ataque é parcialmente bloqueado, mas você ainda consegue ferir o inimigo. Causa dano normal."
 },
 "golpe_3": {
  "nome": "Golpe de Precisão",
  "atributo": "Técnica",
  "teste": "2d6+Técnica",
  "dez_mais": "Você golpeia um ponto fraco do inimigo, causando dano crítico. Escolha entre causar um dano extra ou aplicar um efeito de status.",
  "sete_nove": "Seu ataque é preciso, mas não causa dano crítico. Causa dano normal."
 },
 "limit_breaker": {
  "nome": "Explosão de Adagas",
  "atributo": "Corpo",
  "efeito": "Você canaliza toda sua força e precisão em um único ataque devastador, lançando uma chuva de adagas que causa dano massivo a todos os inimigos próximos. Todos os inimigos na área sofrem dano crítico."
 }
}
```

## Besta
- arma: `Besta`
- atributo principal: Reflexo
```json
{
 "golpe_2": {
  "nome": "Disparo Explosivo",
  "atributo": "Corpo",
  "teste": "2d6+Corpo",
  "dez_mais": "A bala explode ao atingir o alvo, causando dano adicional e empurrando-o para trás.",
  "sete_nove": "A bala explode, mas causa menos dano e empurra o alvo apenas um pouco."
 },
 "golpe_3": {
  "nome": "Mirada de Precisão",
  "atributo": "Conhecimento",
  "teste": "2d6+Conhecimento",
  "dez_mais": "Você acerta um ponto vital do alvo, causando dano crítico e temporariamente paralisando-o.",
  "sete_nove": "Você acerta um ponto fraco do alvo, causando dano adicional, mas o alvo não é paralisado."
 },
 "limit_breaker": {
  "nome": "Salva de Fogo",
  "atributo": "Espírito",
  "efeito": "Após atingir o contador de sucesso/erro, você dispara uma salva de flechas em rápida sucessão. Cada flecha causa dano significativo e pode acertar múltiplos alvos."
 }
}
```

## Chakrams
- arma: `Chakrams`
- atributo principal: Técnica
```json
{
 "golpe_2": {
  "nome": "Giro de Vento",
  "atributo": "Reflexo",
  "teste": "2d6+Reflexo",
  "dez_mais": "Você realiza uma série de golpes rápidos que atingem múltiplos inimigos, causando dano adicional a todos os alvos atingidos.",
  "sete_nove": "Você consegue desequilibrar um dos seus oponentes, ganhando vantagem no próximo ataque contra ele."
 },
 "golpe_3": {
  "nome": "Corte de Precisão",
  "atributo": "Corpo",
  "teste": "2d6+Corpo",
  "dez_mais": "Você realiza um corte extremamente preciso, ignorando a armadura do inimigo e causando dano crítico.",
  "sete_nove": "Você consegue cortar uma parte não essencial da armadura do inimigo, reduzindo sua eficácia defensiva."
 },
 "limit_breaker": {
  "nome": "Tempestade de Chakrams",
  "atributo": "Técnica",
  "efeito": "Depois de acumular 10 sucessos consecutivos com os golpes dos chakrams, você destrava a Tempestade de Chakrams. Realize um teste '2d6+Técnica'. Em caso de sucesso (10+), todos os inimigos ao seu redor sofrem dano massivo e são atordoados por um turno completo. Em caso de sucesso com custo (7-9), você consegue atordar apenas um dos inimigos, mas fica temporariamente vulnerável a ataques."
 }
}
```

## Chicote
- arma: `Chicote`
- atributo principal: Conhecimento
```json
{
 "golpe_2": {
  "nome": "Lança de Agilidade",
  "atributo": "Reflexo",
  "teste": "2d6+Reflexo",
  "dez_mais": [
   "Você enrosca o chicote ao redor do alvo, arrastando-o para mais perto e causando dano adicional.",
   "O alvo é desequilibrado, perdendo sua próxima ação."
  ],
  "sete_nove": [
   "Você consegue acertar o alvo, mas ele consegue se esquivar de parte do golpe, sofrendo menos dano.",
   "O chicote fica preso em algum obstáculo, deixando você vulnerável por um turno."
  ]
 },
 "golpe_3": {
  "nome": "Golpe Esmagador",
  "atributo": "Corpo",
  "teste": "2d6+Corpo",
  "dez_mais": [
   "Você usa toda a sua força para desferir um golpe devastador, causando dano crítico.",
   "O impacto do chicote causa um estremecimento no chão, prejudicando todos os inimigos ao redor."
  ],
  "sete_nove": [
   "Você consegue acertar o alvo, mas o impacto é menor que o esperado, causando menos dano.",
   "O chicote se enrola em si mesmo, causando uma pequena lesão a você."
  ]
 },
 "limit_breaker": {
  "nome": "Dança da Destruição",
  "atributo": "Técnica",
  "efeito": [
   "Depois de acumular 10 sucessos consecutivos com golpes normais, você destrava a Dança da Destruição.",
   "Você realiza uma série de golpes rápidos e precisos, causando dano massivo ao alvo principal e prejudicando todos os inimigos ao redor.",
   "Após o uso do Limit Breaker, você fica exausto e não pode realizar mais nenhuma Move por um turno."
  ]
 }
}
```

## Escudo e Espada
- arma: `Escudo e Espada`
- atributo principal: Corpo
```json
{
 "golpe_2": {
  "nome": "Golpe de Reflexo",
  "atributo": "Reflexo",
  "teste": "2d6+Reflexo",
  "dez_mais": "Você acerta um ponto fraco do inimigo, causando dano extra e ganhando uma vantagem na próxima ação.",
  "sete_nove": "Você consegue acertar o inimigo, mas ele bloqueia parte do ataque, reduzindo o dano causado."
 },
 "golpe_3": {
  "nome": "Golpe de Técnica",
  "atributo": "Técnica",
  "teste": "2d6+Técnica",
  "dez_mais": "Você executa uma combinação de golpes precisos, desarmando o inimigo e ganhando a posse da sua arma.",
  "sete_nove": "Você consegue acertar o inimigo com um golpe técnico, mas ele consegue se recuperar rapidamente."
 },
 "limit_breaker": {
  "nome": "Limit Breaker: Golpe Definitivo",
  "atributo": "Corpo",
  "efeito": "Quando você atinge a marca de 10 sucessos consecutivos em golpes básicos, você pode usar este Limit Breaker. Faça um teste de 2d6+Corpo. Em um resultado de 10+, você realiza um ataque devastador que causa dano crítico e desorienta o inimigo por uma rodada. Em um resultado de 7-9, você ainda causa dano significativo, mas o inimigo consegue se recuperar rapidamente."
 }
}
```

## Espada Longa
- arma: `Espada Longa`
- atributo principal: Corpo
```json
{
 "golpe_2": {
  "nome": "Lance de Luz",
  "atributo": "Reflexo",
  "teste": "2d6+Reflexo",
  "dez_mais": "O inimigo é atingido com um golpe rápido e preciso, causando dano adicional.",
  "sete_nove": "Você desvia do contra-ataque do inimigo, mas não causa dano extra."
 },
 "golpe_3": {
  "nome": "Corte de Espírito",
  "atributo": "Espírito",
  "teste": "2d6+Espírito",
  "dez_mais": "Você inspira seus aliados, aumentando sua moral e resistência.",
  "sete_nove": "Seus aliados ganham um breve momento de coragem, mas você está exausto."
 },
 "limit_breaker": {
  "nome": "Limit Breaker",
  "atributo": "Técnica",
  "efeito": "Desbloqueado após acumular 10 sucessos consecutivos em golpes. Causa um dano devastador e pode desativar temporariamente habilidades especiais do inimigo."
 }
}
```

## Foice
- arma: `Foice`
- atributo principal: Técnica
```json
{
 "golpe_2": {
  "nome": "Golpe de Lâminas Cruzadas",
  "atributo": "Corpo",
  "teste": "2d6+Corpo",
  "dez_mais": [
   "Você corta o alvo com precisão, causando dano adicional e desarmando-o temporariamente.",
   "O inimigo é empurrado para trás, ganhando vantagem tática."
  ],
  "sete_nove": "Você consegue causar um corte profundo, mas o alvo resiste parcialmente ao seu ataque."
 },
 "golpe_3": {
  "nome": "Golpe de Arremesso",
  "atributo": "Reflexo",
  "teste": "2d6+Reflexo",
  "dez_mais": [
   "Você arremessa a foice com precisão, atingindo o alvo e causando dano adicional.",
   "O inimigo é jogado para trás, criando uma abertura tática."
  ],
  "sete_nove": "Você consegue lançar a foice, mas o alvo consegue se desviar parcialmente do ataque."
 },
 "limit_breaker": {
  "nome": "Golpe Final de Execução",
  "atributo": "Espírito",
  "efeito": "Após acumular 10 contagens de sucesso/erro, você desata um golpe devastador com a foice. O alvo sofre dano crítico e é incapacitado temporariamente."
 }
}
```

## Katana
- arma: `Katana`
- atributo principal: Espírito
```json
{
 "golpe_2": {
  "nome": "Corte Relâmpago",
  "atributo": "Reflexo",
  "teste": "2d6+Reflexo",
  "dez_mais": "Você acerta o inimigo com um corte rápido e preciso, causando dano adicional.",
  "sete_nove": "Você consegue acertar o inimigo, mas ele bloqueia parte do ataque, reduzindo o dano."
 },
 "golpe_3": {
  "nome": "Cortar e Fatiar",
  "atributo": "Corpo",
  "teste": "2d6+Corpo",
  "dez_mais": "Você realiza uma série de cortes rápidos, causando dano múltiplo ao inimigo.",
  "sete_nove": "Você consegue ferir o inimigo, mas não tão eficazmente quanto esperava."
 },
 "limit_breaker": {
  "nome": "Limit Breaker: Corte Final",
  "atributo": "Técnica",
  "efeito": "Após acumular 10 sucessos ou erros, você destrava este golpe especial. Realize um teste de 2d6+Técnica. Em caso de sucesso (10+), você realiza um corte devastador que ignora a defesa do inimigo e causa dano crítico. Em caso de sucesso com custo (7-9), o inimigo sofre dano significativo, mas consegue se defender parcialmente."
 }
}
```

## Lança
- arma: `Lança`
- atributo principal: Técnica
```json
{
 "golpe_2": {
  "nome": "Estocada Rápida",
  "atributo": "Reflexo",
  "teste": "2d6+Reflexo",
  "dez_mais": [
   "Você acerta um ponto vital do inimigo, causando dano adicional.",
   "O inimigo é atordoado, perdendo sua próxima ação."
  ],
  "sete_nove": "Você consegue acertar o inimigo, mas ele bloqueia parte do ataque, reduzindo o dano."
 },
 "golpe_3": {
  "nome": "Empurrão Pavoroso",
  "atributo": "Corpo",
  "teste": "2d6+Corpo",
  "dez_mais": [
   "Você empurra o inimigo para trás, criando uma distância segura.",
   "O inimigo é derrubado e fica vulnerável por um turno."
  ],
  "sete_nove": "Você consegue empurrar o inimigo, mas ele mantém o equilíbrio, reduzindo a eficácia do golpe."
 },
 "limit_breaker": {
  "nome": "Transperfuração Celestial",
  "atributo": "Técnica",
  "efeito": [
   "Você realiza uma série de movimentos rápidos e precisos, transpassando o inimigo com sua lança.",
   "O inimigo sofre dano crítico e é incapacitado por um turno."
  ]
 }
}
```

## Machado
- arma: `Machado`
- atributo principal: Corpo
```json
{
 "golpe_2": {
  "nome": "Golpe de Precisão",
  "atributo": "Reflexo",
  "teste": "2d6+Reflexo",
  "dez_mais": "Você acerta um ponto fraco do oponente, causando dano extra e ganhando vantagem na próxima ação contra ele.",
  "sete_nove": "Você consegue acertar o oponente, mas a precisão é comprometida. O oponente ganha um ponto de armadura temporária."
 },
 "golpe_3": {
  "nome": "Golpe de Força",
  "atributo": "Técnica",
  "teste": "2d6+Técnica",
  "dez_mais": "Você utiliza toda a sua habilidade para causar um golpe devastador, ignorando parte da armadura do oponente.",
  "sete_nove": "Você consegue aplicar uma técnica eficaz, mas o golpe não é tão forte quanto você queria. O oponente ganha um ponto de resistência temporária."
 },
 "limit_breaker": {
  "nome": "Machado Divino",
  "atributo": "Espírito",
  "efeito": "Ao alcançar 10 sucessos consecutivos com golpes normais, você destrava o Machado Divino. Este golpe é extremamente poderoso e pode causar dano crítico instantâneo ao oponente, além de conceder um bônus temporário para todos os atributos do jogador por uma rodada."
 }
}
```

## Martelo
- arma: `Martelo`
- atributo principal: Corpo
```json
{
 "golpe_2": {
  "nome": "Golpe de Reflexo",
  "atributo": "Reflexo",
  "teste": "2d6+Reflexo",
  "dez_mais": [
   "Você acerta o inimigo com precisão, causando dano extra e desorientando-o.",
   "O inimigo é atordoado por um breve momento."
  ],
  "sete_nove": [
   "Você acerta o inimigo, mas ele consegue se recuperar rapidamente."
  ]
 },
 "golpe_3": {
  "nome": "Golpe de Conhecimento",
  "atributo": "Conhecimento",
  "teste": "2d6+Conhecimento",
  "dez_mais": [
   "Você identifica um ponto fraco no inimigo, causando dano crítico.",
   "O inimigo é temporariamente vulnerável a ataques em seu ponto fraco."
  ],
  "sete_nove": [
   "Você acerta o inimigo, mas ele consegue se recuperar rapidamente."
  ]
 },
 "limit_breaker": {
  "nome": "Limit Breaker: Martelo Divino",
  "atributo": "Técnica",
  "efeito": [
   "Quando seu contador de sucesso/erro atinge 10, você pode usar este golpe especial.",
   "Realize um teste '2d6+Técnica'.",
   "Em um resultado de 10+, você causa dano massivo ao inimigo e o derruba instantaneamente.",
   "Em um resultado de 7-9, você causa dano significativo, mas o inimigo consegue se levantar."
  ]
 }
}
```

## Pá
- arma: `Pá`
- atributo principal: Conhecimento
```json
{
 "golpe_2": {
  "nome": "Golpe de Terra",
  "atributo": "Corpo",
  "teste": "2d6+Corpo",
  "dez_mais": [
   "Você causa um dano devastador, empurrando o inimigo para trás.",
   "O inimigo é lançado no ar e fica atordoado por um turno."
  ],
  "sete_nove": "Você consegue causar um pequeno dano, mas a pá fica presa no chão por um momento."
 },
 "golpe_3": {
  "nome": "Golpe de Vento",
  "atributo": "Reflexo",
  "teste": "2d6+Reflexo",
  "dez_mais": [
   "Você realiza uma série rápida de golpes, causando múltiplos danos.",
   "O inimigo é empurrado para trás e perde um turno."
  ],
  "sete_nove": "Você consegue causar um pequeno dano, mas o movimento rápido deixa você vulnerável por um momento."
 },
 "limit_breaker": {
  "nome": "Golpe Final da Terra",
  "atributo": "Corpo+Reflexo",
  "efeito": [
   "Você realiza uma série de golpes devastadores, causando dano crítico e empurrando o inimigo para trás.",
   "O inimigo é lançado no ar e fica atordoado por dois turnos."
  ]
 }
}
```

## Rapieira
- arma: `Rapieira`
- atributo principal: Reflexo
```json
{
 "golpe_2": {
  "nome": "Estocada de Precisão",
  "atributo": "Conhecimento",
  "teste": "2d6+Conhecimento",
  "dez_mais": [
   "Você inflige um golpe crítico, causando dano adicional e ignorando parte da armadura do inimigo.",
   "Você ganha uma vantagem tática, permitindo que você ou um aliado próximo faça um ataque grátis."
  ],
  "sete_nove": "Você acerta o alvo, mas ele consegue desviar parcialmente, reduzindo o dano causado."
 },
 "golpe_3": {
  "nome": "Lance de Fúria",
  "atributo": "Espírito",
  "teste": "2d6+Espírito",
  "dez_mais": [
   "Você inflige um golpe devastador, causando dano adicional e aplicando um efeito negativo ao alvo (como atordoamento ou sangramento).",
   "Você inspira seus aliados, aumentando a moral do grupo e concedendo um bônus temporário em suas próximas ações."
  ],
  "sete_nove": "Você acerta o alvo com força, mas ele consegue resistir parcialmente ao impacto, reduzindo o dano causado."
 },
 "limit_breaker": {
  "nome": "Estocada Definitiva",
  "atributo": "Técnica",
  "efeito": [
   "Você realiza uma série de movimentos precisos e devastadores, causando um dano massivo ao alvo.",
   "Se o alvo for um boss ou inimigo significativo, ele é derrotado instantaneamente."
  ]
 }
}
```

## Bastão
- arma: `Bastão`
- atributo principal: Espírito
```json
{
 "golpe_2": {
  "nome": "Golpe de Impacto",
  "atributo": "Corpo",
  "teste": "2d6+Corpo",
  "dez_mais": "Você atinge seu oponente com uma força devastadora, causando dano extra e empurrando-o para trás.",
  "sete_nove": "Você acerta um golpe sólido, mas seu oponente consegue se equilibrar."
 },
 "golpe_3": {
  "nome": "Golpe de Precisão",
  "atributo": "Reflexo",
  "teste": "2d6+Reflexo",
  "dez_mais": "Você realiza um golpe preciso, atingindo um ponto fraco e causando dano crítico.",
  "sete_nove": "Você acerta um golpe próximo ao alvo desejado, mas não causa dano crítico."
 },
 "limit_breaker": {
  "nome": "Impacto Desastroso",
  "atributo": "Técnica",
  "efeito": "Quando seu contador de sucesso/erro atinge 10, você pode usar este golpe especial. Realize um teste '2d6+Técnica'. Em caso de sucesso (7 ou mais), você causa dano massivo e atordoamento ao oponente."
 }
}
```

## Tonfas
- arma: `Tonfas`
- atributo principal: Técnica
```json
{
 "golpe_2": {
  "nome": "Golpe de Impacto",
  "atributo": "Corpo",
  "teste": "2d6+Corpo",
  "dez_mais": [
   "Você desvia-se do ataque inimigo e consegue um contra-ataque devastador, causando dano adicional.",
   "O inimigo é jogado para trás, criando uma oportunidade para manobras adicionais."
  ],
  "sete_nove": "Você acerta o inimigo com força, mas ele consegue se recuperar rapidamente."
 },
 "golpe_3": {
  "nome": "Golpe de Precisão",
  "atributo": "Reflexo",
  "teste": "2d6+Reflexo",
  "dez_mais": [
   "Você acerta um ponto fraco do inimigo, causando dano adicional e potencialmente incapacitando-o.",
   "O inimigo é pego de surpresa, permitindo que você ganhe uma vantagem tática."
  ],
  "sete_nove": "Você acerta o inimigo com precisão, mas ele consegue se esquivar do golpe mais devastador."
 },
 "limit_breaker": {
  "nome": "Limit Breaker: Golpe de Tormenta",
  "atributo": "Técnica",
  "efeito": [
   "Você realiza uma série de golpes rápidos e precisos, causando dano massivo ao inimigo.",
   "O inimigo é incapaz de se defender e sofre um golpe final devastador."
  ]
 }
}
```

## Clava
- arma: `Clava`
- atributo principal: Corpo
```json
{
 "golpe_2": {
  "nome": "Golpe de Espírito",
  "atributo": "Espírito",
  "teste": "2d6+Espírito",
  "dez_mais": "Você inflige um golpe devastador, causando dano extra e atordoando seu oponente.",
  "sete_nove": "Você consegue acertar um ponto fraco do oponente, causando dano normal, mas também expõe uma fraqueza que pode ser explorada."
 },
 "golpe_3": {
  "nome": "Golpe de Técnica",
  "atributo": "Técnica",
  "teste": "2d6+Técnica",
  "dez_mais": "Você realiza uma série de golpes precisos, causando múltiplos danos e reduzindo a defesa do oponente.",
  "sete_nove": "Você consegue acertar um golpe crítico em um ponto fraco do oponente, mas isso consome parte de sua energia."
 },
 "limit_breaker": {
  "nome": "Limit Breaker: Golpe Final",
  "atributo": "Corpo",
  "efeito": "Depois de acumular 10 sucessos ou erros em golpes normais, você pode usar este ataque devastador. Causa dano massivo e tem a chance de eliminar o oponente instantaneamente."
 }
}
```

## Nunchaku
- arma: `Nunchaku`
- atributo principal: Técnica
```json
{
 "golpe_2": {
  "nome": "Golpe de Vento",
  "atributo": "Reflexo",
  "teste": "2d6+Reflexo",
  "dez_mais": "Você acerta seu oponente com uma série rápida de golpes, causando dano adicional e desorientando-o.",
  "sete_nove": "Você consegue atingir seu oponente, mas ele consegue se recuperar rapidamente."
 },
 "golpe_3": {
  "nome": "Impacto da Terra",
  "atributo": "Corpo",
  "teste": "2d6+Corpo",
  "dez_mais": "Você desferi um golpe poderoso com os nunchakus, causando dano significativo e derrubando seu oponente.",
  "sete_nove": "Você consegue acertar seu oponente, mas ele consegue se equilibrar."
 },
 "limit_breaker": {
  "nome": "Tempestade de Golpes",
  "atributo": "Técnica",
  "efeito": "Depois de acumular 10 sucessos com golpes de nunchaku, você pode usar este ataque especial. Você desferi uma série rápida e implacável de golpes, causando dano massivo e deixando seu oponente incapacitado por um curto período."
 }
}
```

## Glaive
- arma: `Glaive`
- atributo principal: Reflexo
```json
{
 "golpe_2": {
  "nome": "Golpe de Vento",
  "atributo": "Corpo",
  "teste": "2d6+Corpo",
  "dez_mais": [
   "Você cria um redemoinho ao seu redor, empurrando todos os inimigos próximos e causando danos adicionais.",
   "Você pode escolher entre causar mais dano ou desarmar o inimigo."
  ],
  "sete_nove": "Você causa dano normal, mas também consegue desequilibrar o inimigo, facilitando um próximo ataque."
 },
 "golpe_3": {
  "nome": "Golpe de Terra",
  "atributo": "Espírito",
  "teste": "2d6+Espírito",
  "dez_mais": [
   "Você invoca a força da terra, criando uma onda de choque que atordoa o inimigo.",
   "Você pode escolher entre causar dano adicional ou reduzir temporariamente as defesas do inimigo."
  ],
  "sete_nove": "Você causa dano normal e diminui ligeiramente a defesa do inimigo."
 },
 "limit_breaker": {
  "nome": "Limit Breaker: Golpe de Luz",
  "atributo": "Técnica",
  "efeito": [
   "Você concentra toda sua energia em um único golpe, liberando uma explosão de luz que causa danos devastadores e atordoa todos os inimigos próximos.",
   "Este golpe pode ser usado apenas depois de acumular 10 pontos de sucesso/erro no contador."
  ]
 }
}
```

## Corrente com Peso
- arma: `Corrente com Peso`
- atributo principal: Técnica
```json
{
 "golpe_2": {
  "nome": "Lança de Correia",
  "atributo": "Corpo",
  "teste": "2d6+Corpo",
  "dez_mais": "Você envolve o inimigo com a corrente, prendendo-o firmemente. Escolha uma opção: 1) O inimigo está desorientado e você ganha vantagem em seu próximo ataque; 2) Você arrasta o inimigo para mais perto de você, reduzindo sua distância de combate.",
  "sete_nove": "Você consegue prender o inimigo com a corrente, mas ele ainda pode se mover. Você ganha um bônus de +1 no seu próximo teste de Técnica."
 },
 "golpe_3": {
  "nome": "Golpe de Refletor",
  "atributo": "Reflexo",
  "teste": "2d6+Reflexo",
  "dez_mais": "Você usa a corrente para criar uma armadilha rápida. Escolha uma opção: 1) Você prende o inimigo no chão, impedindo-o de se mover por um turno; 2) Você cria uma distração com a corrente, permitindo que você ou um aliado faça um ataque surpresa.",
  "sete_nove": "Você consegue distrair o inimigo com a corrente, mas ele ainda está atento. Você ganha um bônus de +1 no seu próximo teste de Reflexo."
 },
 "limit_breaker": {
  "nome": "Impacto Devastador",
  "atributo": "Técnica",
  "efeito": "Após acumular 10 pontos de sucesso/erro, você pode desferir um golpe devastador com a corrente. Este ataque ignora todas as defesas do inimigo e causa dano crítico automaticamente. Além disso, o impacto é tão forte que você pode escolher uma opção adicional: 1) O inimigo é nocauteado por um turno; 2) Você ganha um ponto de técnica extra para usar em sua próxima ação."
 }
}
```

## Manopla
- arma: `Manopla`
- atributo principal: Corpo
```json
{
 "golpe_2": {
  "nome": "Golpe de Reflexo",
  "atributo": "Reflexo",
  "teste": "2d6+Reflexo",
  "dez_mais": "Você acerta um ponto fraco do inimigo, causando dano adicional e ganhando vantagem no próximo teste contra ele.",
  "sete_nove": "Você desvia de um ataque iminente, mas o inimigo consegue se recuperar rapidamente."
 },
 "golpe_3": {
  "nome": "Golpe de Técnica",
  "atributo": "Técnica",
  "teste": "2d6+Técnica",
  "dez_mais": "Você executa uma combinação perfeita, causando dano adicional e imobilizando o inimigo por um turno.",
  "sete_nove": "Você consegue executar parte da combinação, mas o inimigo escapa de ser completamente imobilizado."
 },
 "limit_breaker": {
  "nome": "Limit Breaker",
  "atributo": "Corpo+Reflexo+Técnica",
  "efeito": "Após acumular 10 sucessos consecutivos com a Manopla, você destrava o Limit Breaker. Este golpe poderoso causa dano massivo e tem uma chance de derrotar o inimigo instantaneamente."
 }
}
```

## Leque
- arma: `Leque`
- atributo principal: Técnica
```json
{
 "golpe_2": {
  "nome": "Ataque de Vento",
  "atributo": "Corpo",
  "teste": "2d6+Corpo",
  "dez_mais": "Você cria uma rajada de vento que empurra o oponente, causando dano e permitindo um movimento livre.",
  "sete_nove": "O vento é forte, mas o oponente resiste. Você causa dano, mas ele não é empurrado."
 },
 "golpe_3": {
  "nome": "Ataque de Fogo",
  "atributo": "Espírito",
  "teste": "2d6+Espírito",
  "dez_mais": "Você invoca uma chama intensa que envolve o leque, causando dano e infligindo um efeito de queimadura.",
  "sete_nove": "A chama é forte, mas não suficiente para causar queimadura. Você causa dano normal."
 },
 "limit_breaker": {
  "nome": "Tempestade Final",
  "atributo": "Técnica",
  "efeito": "Depois de acumular 10 pontos no contador de sucesso/erro, você libera uma tempestade de elementos (vento e fogo) que causa dano massivo e pode causar um efeito de atordoamento ou queimadura."
 }
}
```
