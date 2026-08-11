<template>
  <div>
    <div v-if="!auth.logado" class="msg info">🔒 <router-link to="/mestre-login">Entrar como mestre</router-link> pra acessar o painel.</div>
    <div v-else-if="!auth.ehMestre" class="msg erro">
      ⛔ A conta <b>{{ auth.user?.email }}</b> não tem papel de mestre nesta mesa.
      <router-link to="/mestre-login" style="margin-left:6px">Trocar de conta</router-link>
    </div>

    <!-- ============ INTERFACE DE MESTRE — SIDEBAR ADMIN + CONTEÚDO ============ -->
    <div v-else class="admin-shell">
      <!-- SIDEBAR FIXA ESQUERDA (diferenciada: roxo escuro, barra lateral) -->
      <aside class="admin-sidebar">
        <div class="admin-brand">
          <div class="brand-emoji">🧙</div>
          <div>
            <div class="brand-title">Painel do Mestre</div>
            <div class="brand-sub">Aincrad · Andar 1</div>
          </div>
        </div>
        <nav class="admin-nav">
          <div v-for="s in secoes" :key="s.k" class="admin-nav-item" :class="{on: aba===s.k, d: s.divider}"
            role="button" tabindex="0" :aria-current="aba===s.k ? 'page' : undefined"
            @click="aba=s.k" @keydown.enter="aba=s.k" @keydown.space.prevent="aba=s.k">
            <span class="ico">{{ s.ico }}</span>
            <span class="lbl">{{ s.lbl }}</span>
            <span v-if="s.badge" class="badge">{{ s.badge }}</span>
          </div>
        </nav>
        <div class="admin-foot">
          <div class="pill on" style="justify-content:center;width:100%;display:flex">
            <img v-if="auth.foto" :src="auth.foto" alt="" style="width:18px;height:18px;border-radius:50%;border:1px solid var(--laranja);margin-right:6px;object-fit:cover">
            👑 Mestre logado
          </div>
          <div style="margin-top:8px;font-size:12px;color:var(--ink-dim);text-align:center">
            {{ auth.nomeMostrar || auth.perfil?.nome || 'Mestre' }}
          </div>
          <div style="margin-top:10px">
            <router-link to="/" class="btn ghost" style="width:100%;justify-content:center;display:flex">🏠 Voltar para Home</router-link>
          </div>
        </div>
      </aside>

      <!-- CONTEÚDO PRINCIPAL -->
      <section class="admin-main">
        <!-- Cabeçalho comum a todas as abas -->
        <header class="admin-header">
          <div>
            <h2>{{ secaoAtual?.ico }} {{ secaoAtual?.lbl }}</h2>
            <p class="admin-desc" v-if="secaoAtual?.desc">{{ secaoAtual.desc }}</p>
          </div>
          <div style="display:flex;gap:8px;align-items:center;flex-wrap:wrap">
            <router-link v-if="aba==='jogadores'" to="/mestre" @click.prevent="aba='criar'" class="btn primario">➕ Criar novo personagem</router-link>
            <button v-if="aba==='jogadores'" class="btn" :disabled="carregandoPers" @click="carregarJogadores()">🔄 Atualizar lista</button>
          </div>
        </header>

        <!-- ============ ABA 1: DASHBOARD ============ -->
        <div v-if="aba==='dashboard'" class="admin-content">
          <!-- Cards estatísticos -->
          <div class="admin-statgrid">
            <div class="admin-stat">
              <div class="stat-ico" style="background:#2d3a7a">👥</div>
              <div>
                <div class="stat-num">{{ totalPersonagens }}</div>
                <div class="stat-lbl">Jogadores ativos</div>
              </div>
            </div>
            <div class="admin-stat">
              <div class="stat-ico" style="background:#7a4e2d">💰</div>
              <div>
                <div class="stat-num">{{ totalColCirculante }}</div>
                <div class="stat-lbl">Col em circulação (todos)</div>
              </div>
            </div>
            <div class="admin-stat">
              <div class="stat-ico" style="background:#3a7a4b">🛠️</div>
              <div>
                <div class="stat-num">{{ totalProfissoesDiferentes }}</div>
                <div class="stat-lbl">Profissões diferentes</div>
              </div>
            </div>
            <div class="admin-stat">
              <div class="stat-ico" style="background:#7a2d66">💨</div>
              <div>
                <div class="stat-num">{{ mediaFolego.toFixed(1) }}</div>
                <div class="stat-lbl">Fôlego médio (de 20)</div>
              </div>
            </div>
          </div>
          <!-- 2 colunas: jogadores recentes + últimas atividades -->
          <div class="admin-twocol">
            <div class="card" style="background:var(--panel-2)">
              <h4 style="margin:0 0 12px;color:var(--azul-bright)">🎲 Últimos personagens criados</h4>
              <div v-if="carregandoPers" class="msg info carregando">Carregando…</div>
              <div v-else-if="!jogadores.length" class="msg warn">Nenhum personagem criado ainda.</div>
              <div v-else class="admin-list">
                <div v-for="p in jogadores.slice(0,6)" :key="p.nome" class="admin-row" role="button" tabindex="0"
                  @click="aba='jogadores'; selecionarPersonagem(p)"
                  @keydown.enter="aba='jogadores'; selecionarPersonagem(p)"
                  @keydown.space.prevent="aba='jogadores'; selecionarPersonagem(p)">
                  <img v-if="p.foto_url" :src="p.foto_url" :alt="p.nome" class="row-avatar">
                  <div v-else class="row-avatar def">👤</div>
                  <div style="flex:1">
                    <div class="row-nome">{{ p.nome }} <span class="pill rar-incomum" style="margin-left:6px">💨 {{ p.folego ?? 0 }}/20</span></div>
                    <div class="row-sub">🛠️ {{ p.profissao || 'Sem profissão' }} · 💬 {{ p.discord_nome || '—' }}</div>
                  </div>
                  <div class="row-val">
                    💵 {{ ((p.col_mao||0)+(p.col_guardado||0)).toLocaleString('pt-BR') }} Col
                  </div>
                </div>
              </div>
            </div>
            <div class="card" style="background:var(--panel-2)">
              <h4 style="margin:0 0 12px;color:var(--azul-bright)">⚔️ Ações rápidas</h4>
              <div class="admin-quick">
                <router-link to="/tarefas" class="btn" style="justify-content:space-between;display:flex">🎯 Missões do dia <span>→</span></router-link>
                <router-link to="/profissoes" class="btn" style="justify-content:space-between;display:flex">🛠️ Oficina de Craft <span>→</span></router-link>
                <router-link to="/mercado" class="btn" style="justify-content:space-between;display:flex">🏪 Mercado <span>→</span></router-link>
                <button class="btn" @click="aba='jogadores'" style="justify-content:space-between;display:flex">👥 Gerenciar jogadores <span>→</span></button>
                <button class="btn" @click="aba='criar'" style="justify-content:space-between;display:flex">➕ Criar personagem <span>→</span></button>
              </div>
              <h4 style="margin:18px 0 10px;color:var(--azul-bright)">📊 Distribuição por profissão</h4>
              <div v-if="!jogadores.length" class="msg warn">Sem dados ainda.</div>
              <div v-else class="admin-list">
                <div v-for="g in distProfissoes" :key="g.nome" class="admin-row">
                  <div class="row-nome">🛠️ {{ g.nome }}</div>
                  <div style="flex:1;margin:0 12px">
                    <div style="height:10px;background:#201b2e;border-radius:5px;overflow:hidden">
                      <div :style="{width: Math.min(100, (g.qtd/Math.max(1,jogadores.length))*100)+'%', height:'100%', background:'linear-gradient(90deg,var(--laranja),var(--ink-dim))'}"></div>
                    </div>
                  </div>
                  <div class="row-val">{{ g.qtd }} jogadores</div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- ============ ABA MESA & SESSÃO (ferramentas de condução ao vivo) ============ -->
        <div v-if="aba==='mesa'" class="admin-content">
          <div class="msg info">
            🎬 Estado gravado no banco (não mais no navegador) — qualquer dispositivo logado como mestre vê o mesmo estado. RLS bloqueia jogador de ler ou escrever qualquer coisa aqui.
          </div>

          <div class="admin-twocol">
            <div class="card" style="background:var(--panel-2)">
              <h4 style="margin:0 0 4px;color:var(--azul-bright)">🕰️ Relógios narrativos</h4>
              <p style="color:var(--ink-faint);font-size:12px;margin:0 0 12px">Progresso 0-6 de ameaças e tramas de fundo. Suba quando a ficção empurrar.</p>
              <div v-if="carregandoMesa" class="msg info carregando">Carregando…</div>
              <div v-else style="display:grid;gap:12px">
                <div v-for="r in relogios" :key="r.id">
                  <div class="row-nome">{{ r.nome }} <span class="pill" style="margin-left:6px">{{ r.valor }}/6</span></div>
                  <div class="row-sub" style="margin-bottom:6px">{{ r.descricao }}</div>
                  <input type="range" min="0" max="6" step="1" v-model.number="r.valor" @change="salvarRelogio(r)" style="width:100%">
                </div>
              </div>
            </div>

            <div class="card" style="background:var(--panel-2)">
              <h4 style="margin:0 0 4px;color:var(--azul-bright)">🛡️ Preparação de Raid <span class="pill" style="margin-left:6px">{{ raidPrepTotal }}/6</span></h4>
              <p style="color:var(--ink-faint);font-size:12px;margin:0 0 12px">Um crédito por contribuição diferente. Em 6, o raid começa com vantagem coletiva; em 3 ou menos, o mestre escolhe uma pressão inicial.</p>
              <div class="admin-list">
                <label v-for="c in raidPrep" :key="c.categoria" class="admin-row" style="cursor:pointer">
                  <input type="checkbox" v-model="c.marcado" @change="salvarRaidPrep(c)">
                  <div style="flex:1">
                    <div class="row-nome">{{ c.categoria }}</div>
                    <div class="row-sub">{{ c.uso }}</div>
                  </div>
                </label>
              </div>
            </div>
          </div>

          <div class="card" style="background:var(--panel-2)">
            <h4 style="margin:0 0 12px;color:var(--azul-bright)">🤝 Favor e Suspeita</h4>
            <div class="admin-toolbar">
              <input v-model="novaRelacaoNome" placeholder="Nome da relação — pessoa, facção, clã…"
                style="flex:1;background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:9px 12px;border-radius:6px;font:inherit">
              <div style="display:flex;align-items:center;gap:8px;background:var(--panel-3);border:1px solid var(--line);border-radius:6px;padding:0 10px">
                <input type="range" min="-3" max="3" step="1" v-model.number="novaRelacaoValor" style="width:140px">
                <span class="pill" style="white-space:nowrap">{{ novaRelacaoValor }} · {{ statusRelacao(novaRelacaoValor) }}</span>
              </div>
              <button class="btn primario" :disabled="!novaRelacaoNome.trim()" @click="salvarRelacao()">Salvar</button>
            </div>
            <div v-if="!relacoes.length" class="msg warn" style="margin-top:10px">Nenhuma relação registrada.</div>
            <div v-else class="admin-list" style="margin-top:10px">
              <div v-for="r in relacoes" :key="r.nome" class="admin-row">
                <div style="flex:1">
                  <div class="row-nome">{{ r.nome }}</div>
                  <div class="row-sub">{{ r.valor }} · {{ statusRelacao(r.valor) }}</div>
                </div>
                <button class="btn tiny bad ghost" @click="removerRelacao(r)">🗑️ Remover</button>
              </div>
            </div>
          </div>

          <div class="admin-twocol">
            <div class="card" style="background:var(--panel-2)">
              <h4 style="margin:0 0 4px;color:var(--azul-bright)">🩹 Condições dos jogadores</h4>
              <p style="color:var(--ink-faint);font-size:12px;margin:0 0 12px">Substituem pontos de vida. 3 ativas = Crítico (rolagem À Beira no próximo perigo grave).</p>
              <div v-if="!jogadores.filter(j=>!j.excluido).length" class="msg warn">Nenhum jogador cadastrado ainda.</div>
              <div v-else style="display:grid;gap:12px">
                <div v-for="p in jogadores.filter(j=>!j.excluido)" :key="p.nome">
                  <div class="row-nome">{{ p.nome }} <span v-if="(p.condicoes||[]).length>=3" class="pill bad" style="margin-left:6px">Crítico</span></div>
                  <div style="display:flex;gap:6px;flex-wrap:wrap;margin-top:6px">
                    <label v-for="cond in CONDICOES" :key="cond" class="pill" :class="{on:(p.condicoes||[]).includes(cond)}" style="cursor:pointer">
                      <input type="checkbox" style="display:none" :checked="(p.condicoes||[]).includes(cond)" @change="toggleCondicaoJogador(p,cond)">
                      {{ cond }}
                    </label>
                  </div>
                </div>
              </div>
            </div>

            <div class="card" style="background:var(--panel-2)">
              <h4 style="margin:0 0 4px;color:var(--azul-bright)">⚔️ Rastreador de combate</h4>
              <p style="color:var(--ink-faint);font-size:12px;margin:0 0 12px">Sem HP nem iniciativa neste sistema (quem age é o jogador, o monstro reage) — isto é só uma contagem de golpes pra não decorar.</p>
              <div class="admin-toolbar">
                <select v-model="monstroEscolhido" style="flex:1;background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:9px 12px;border-radius:6px;font:inherit">
                  <option value="">-- Escolher monstro --</option>
                  <option v-for="m in monstrosRef" :key="m.id" :value="m.id">{{ m.nome }} · {{ m.ameaca || '?' }}</option>
                </select>
                <button class="btn primario" :disabled="!monstroEscolhido" @click="adicionarCombate()">Adicionar à cena</button>
              </div>
              <div v-if="!combateAtivo.length" class="msg warn" style="margin-top:10px">Nenhum monstro em cena.</div>
              <div v-else class="admin-list" style="margin-top:10px">
                <div v-for="c in combateAtivo" :key="c.id" class="admin-row">
                  <div style="flex:1">
                    <div class="row-nome">{{ c.monstro_nome }} <span class="pill" v-if="c.nivel_ameaca">{{ c.nivel_ameaca }}</span></div>
                    <div class="row-sub">golpes p/ derrotar: {{ c.golpes_alvo || '?' }}</div>
                  </div>
                  <button class="btn tiny" @click="ajustarGolpes(c,-1)">−1</button>
                  <span class="pill on">{{ c.golpes_atual }}</span>
                  <button class="btn tiny" @click="ajustarGolpes(c,1)">+1</button>
                  <button class="btn tiny bad ghost" @click="encerrarCombate(c)">Encerrar</button>
                </div>
              </div>
            </div>
          </div>

          <div class="card" style="background:var(--panel-2)">
            <h4 style="margin:0 0 12px;color:var(--azul-bright)">📓 Registro de sessão</h4>
            <div class="form">
              <div class="campo"><label>Sessão / episódio</label><input v-model="novaSessao.titulo"></div>
              <div class="campo"><label>Trio em cena</label><input v-model="novaSessao.trio"></div>
              <div class="campo" style="grid-column:1/-1"><label>Fato que mudou o andar</label><textarea rows="2" v-model="novaSessao.fato" placeholder="O que agora é verdade no mundo? Seja concreto."></textarea></div>
              <div class="campo" style="grid-column:1/-1"><label>Versão pública / rumor</label><textarea rows="2" v-model="novaSessao.rumor"></textarea></div>
              <div class="campo" style="grid-column:1/-1"><label>Próxima pressão</label><textarea rows="2" v-model="novaSessao.pressao" placeholder="Quem reage, e o que essa pessoa quer?"></textarea></div>
            </div>
            <div style="margin-top:10px"><button class="btn primario" @click="salvarSessao()">💾 Salvar no registro</button></div>
            <div v-if="sessoes.length" style="margin-top:14px" class="admin-list">
              <div v-for="s in sessoes" :key="s.id" class="admin-row" style="flex-direction:column;align-items:flex-start">
                <div class="row-nome">{{ s.titulo || 'Sessão sem título' }} <span v-if="s.trio" class="row-sub">· {{ s.trio }}</span></div>
                <div v-if="s.fato" class="row-sub"><b>Fato:</b> {{ s.fato }}</div>
                <div v-if="s.rumor" class="row-sub"><b>Rumor:</b> {{ s.rumor }}</div>
                <div v-if="s.pressao" class="row-sub"><b>Próxima pressão:</b> {{ s.pressao }}</div>
              </div>
            </div>
          </div>

          <div class="admin-twocol">
            <div class="card" style="background:var(--panel-2)">
              <h4 style="margin:0 0 12px;color:var(--azul-bright)">🔒 Segredos e puzzles no mapa</h4>
              <div v-if="!segredosPontos.length" class="msg warn">Nenhum ponto de segredo/puzzle carregado.</div>
              <div v-else class="admin-list">
                <div v-for="p in segredosPontos" :key="p.id" class="admin-row" style="flex-direction:column;align-items:flex-start">
                  <div class="row-nome">{{ p.nome }} <span class="pill" style="margin-left:6px">{{ p.regiao }}</span></div>
                  <div class="row-sub">{{ p.descricao }}</div>
                  <div v-if="p.mestre" class="row-sub" style="color:#e0887a"><b>Só mestre:</b> {{ p.mestre }}</div>
                </div>
              </div>
            </div>
            <div class="card" style="background:var(--panel-2)">
              <h4 style="margin:0 0 12px;color:var(--azul-bright)">💎 Raros do andar — não estão à venda</h4>
              <div v-if="!rarosDoAndar.length" class="msg warn">Nenhum raro carregado.</div>
              <div v-else class="admin-list">
                <div v-for="x in rarosDoAndar" :key="x.id" class="admin-row" style="flex-direction:column;align-items:flex-start">
                  <div class="row-nome">{{ x.nome }} <span class="pill" style="margin-left:6px">{{ x.slot || x.tipo }}</span></div>
                  <div class="row-sub">{{ x.efeito }}</div>
                  <div v-if="x.obter" class="row-sub"><b>Fonte:</b> {{ x.obter }}</div>
                </div>
              </div>
            </div>
          </div>

          <div class="card" style="background:var(--panel-2)">
            <h4 style="margin:0 0 4px;color:var(--azul-bright)">🎯 Metas Globais (cooperação, item 18)</h4>
            <p style="color:var(--ink-faint);font-size:12px;margin:0 0 12px">Até 3 abertas ao mesmo tempo. Todo jogador que doar qualquer quantidade recebe a recompensa quando a meta bater 100%.</p>
            <div class="form" style="padding:0;border:none;background:transparent;grid-template-columns:repeat(3,1fr)">
              <div class="campo" style="grid-column:span 2"><label>Título</label><input v-model="novaMeta.titulo"></div>
              <div class="campo"><label>Item pedido (nome exato)</label><input v-model="novaMeta.meta_item"></div>
              <div class="campo" style="grid-column:span 3"><label>Descrição</label><textarea rows="2" v-model="novaMeta.descricao"></textarea></div>
              <div class="campo"><label>Quantidade meta</label><input type="number" min="1" v-model.number="novaMeta.meta_qtd"></div>
              <div class="campo"><label>Recompensa Col</label><input type="number" min="0" v-model.number="novaMeta.recompensa_col"></div>
              <div class="campo"><label>Recompensa XP</label><input type="number" min="0" v-model.number="novaMeta.recompensa_xp"></div>
              <div class="campo"><label>Reputação — alvo</label><input v-model="novaMeta.recompensa_reputacao_alvo_nome" placeholder="ex: Sindicato dos Ossos"></div>
              <div class="campo"><label>Reputação — valor</label><input type="number" min="-3" max="3" v-model.number="novaMeta.recompensa_reputacao_valor"></div>
            </div>
            <div style="margin-top:10px"><button class="btn primario" :disabled="!novaMeta.titulo||!novaMeta.meta_item||!novaMeta.meta_qtd" @click="criarMetaGlobal()">Criar meta</button></div>
            <div v-if="!metasAtivas.length" class="msg warn" style="margin-top:12px">Nenhuma meta ativa.</div>
            <div v-else class="admin-list" style="margin-top:12px">
              <div v-for="m in metasAtivas" :key="m.id" class="admin-row" style="flex-direction:column;align-items:flex-start">
                <div class="row-nome">{{ m.titulo }}</div>
                <div class="row-sub">{{ m.progresso }}/{{ m.meta_qtd }} × {{ m.meta_item }}</div>
              </div>
            </div>
          </div>

          <div class="card" style="background:var(--panel-2)">
            <h4 style="margin:0 0 4px;color:var(--azul-bright)">🔨 Painel de Profissões (item 16, visão do mestre)</h4>
            <p style="color:var(--ink-faint);font-size:12px;margin:0 0 12px">
              As 16 profissões lado a lado — não é a tela do jogador (ele só vê a própria); isto é só pra você
              ver de longe onde a mesa está investindo.
            </p>
            <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:8px">
              <div v-for="p in painelProfissoes" :key="p.nome" class="admin-row" style="flex-direction:column;align-items:flex-start;gap:2px">
                <div class="row-nome" style="font-size:12.5px">{{ p.nome }}</div>
                <div class="row-sub">{{ p.jogadores }} jogador{{ p.jogadores===1?'':'es' }} · nv máx {{ p.nivelMax }}</div>
              </div>
            </div>
          </div>
        </div>

        <!-- ============ ABA 2: LISTAGEM DE JOGADORES (ver fichas de qualquer jogador) ============ -->
        <div v-if="aba==='jogadores'" class="admin-content">
          <div class="admin-toolbar">
            <input v-model="buscaJog" placeholder="🔎 Buscar personagem, Discord, profissão…"
              style="flex:1;background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:9px 12px;border-radius:6px;font:inherit">
            <select v-model="filtroProf" style="background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:9px 12px;border-radius:6px;font:inherit">
              <option value="">Todas as profissões</option>
              <option v-for="g in distProfissoes" :key="g.nome" :value="g.nome">{{ g.nome }} ({{ g.qtd }})</option>
            </select>
            <button class="btn" @click="buscaJog=''; filtroProf=''">Limpar filtros</button>
          </div>
          <div v-if="carregandoPers" class="msg info carregando">Carregando lista de jogadores…</div>
          <div v-else-if="!jogadoresFiltrados.length" class="msg warn">Nenhum personagem com esses filtros.</div>
          <div v-else class="card" style="background:var(--panel-2);padding:0;overflow:hidden">
            <table class="admin-table">
              <thead>
                <tr>
                  <th style="text-align:left">Personagem</th>
                  <th>Profissão</th>
                  <th>Discord</th>
                  <th>Clã</th>
                  <th style="text-align:right">Col total</th>
                  <th style="text-align:right">Fôlego</th>
                  <th style="text-align:center">Ações</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="p in jogadoresFiltrados" :key="p.nome" tabindex="0"
                  @click="selecionarPersonagem(p)" @keydown.enter="selecionarPersonagem(p)">
                  <td>
                    <div style="display:flex;align-items:center;gap:10px">
                      <img v-if="p.foto_url" :src="p.foto_url" :alt="p.nome" class="row-avatar">
                      <div v-else class="row-avatar def">👤</div>
                      <div>
                        <div class="row-nome">{{ p.nome }}</div>
                        <div class="row-sub">{{ p.discord_email || '—' }}</div>
                      </div>
                    </div>
                  </td>
                  <td style="text-align:center">{{ p.profissao || '—' }}</td>
                  <td style="text-align:center">{{ p.discord_nome || '—' }}</td>
                  <td style="text-align:center">{{ p.guilda || 'Independente' }}</td>
                  <td style="text-align:right;font-weight:700;color:var(--laranja)">{{ ((p.col_mao||0)+(p.col_guardado||0)).toLocaleString('pt-BR') }}</td>
                  <td style="text-align:center">{{ p.folego ?? 0 }}/20</td>
                  <td style="text-align:center;white-space:nowrap">
                    <button class="btn tiny" @click.stop="editarPersonagem(p)">✏️ Editar</button>
                    <button class="btn tiny ghost" @click.stop="resetarSenha(p)">🔑 Resetar senha</button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <!-- Modal VER FICHA de outro jogador (mestre vê tudo) -->
          <div v-if="fichaAberta" class="modal-bg on" @click.self="fichaAberta=null">
            <div class="modal" style="max-width:780px">
              <div class="top">
                <h2>👤 Ficha de {{ fichaAberta.nome }}</h2>
                <button class="btn ghost" @click="fichaAberta=null">✕</button>
              </div>
              <div class="body">
                <div style="display:grid;grid-template-columns:180px 1fr;gap:14px">
                  <img v-if="fichaAberta.foto_url" :src="fichaAberta.foto_url" :alt="'Retrato de ' + fichaAberta.nome"
                    style="width:100%;aspect-ratio:1/1;object-fit:cover;border-radius:10px;border:2px solid var(--laranja)">
                  <div v-else style="width:100%;aspect-ratio:1/1;border-radius:10px;border:2px dashed var(--line);display:grid;place-items:center;color:var(--ink-faint);font-size:70px">👤</div>
                  <div class="card" style="background:var(--panel);border:none;padding:0">
                    <div class="form" style="padding:0;border:none;background:transparent">
                      <div class="campo">
                        <label>Nome</label>
                        <input v-model="fichaAberta.nome">
                      </div>
                      <div class="campo">
                        <label>Profissão</label>
                        <input v-model="fichaAberta.profissao">
                      </div>
                      <div class="campo">
                        <label>Arma atual</label>
                        <input v-model="fichaAberta.arma">
                      </div>
                      <div class="campo">
                        <label>Clã / Guilda</label>
                        <input v-model="fichaAberta.guilda">
                      </div>
                    </div>
                  </div>
                </div>
                <div class="card" style="margin-top:14px;background:var(--panel);border:none">
                  <h4 style="margin:0 0 10px;color:var(--azul-bright)">📊 Atributos</h4>
                  <div class="atributos">
                    <div v-for="a in atributosAbertos" :key="a.k" class="atrib" :class="{pos:a.v>0, neg:a.v<0}">
                      <label>{{ a.nome }}</label>
                      <input type="range" min="-3" max="3" step="1" v-model.number="a.v">
                      <div class="v">{{ a.v>0?'+':'' }}{{ a.v }}</div>
                    </div>
                  </div>
                </div>
                <div class="card" style="margin-top:14px;background:var(--panel);border:none">
                  <h4 style="margin:0 0 10px;color:var(--azul-bright)">💰 Dinheiro · 💨 Fôlego</h4>
                  <p style="color:var(--ink-faint);font-size:12px;margin:-6px 0 10px">
                    Não existe nível de personagem separado no sistema — ver <code>dolist/05_niveis_e_xp.md</code>
                    (decisão em aberto). Quem trava dificuldade/desbloqueio hoje é o Nível de Profissão.
                  </p>
                  <div class="form" style="padding:0;border:none;background:transparent">
                    <div class="campo">
                      <label>💰 Col na mão</label>
                      <input type="number" min="0" v-model.number="fichaAberta.col_mao">
                    </div>
                    <div class="campo">
                      <label>🏦 Col guardado (Stash)</label>
                      <input type="number" min="0" v-model.number="fichaAberta.col_guardado">
                    </div>
                    <div class="campo">
                      <label>💨 Fôlego (de 20)</label>
                      <input type="number" min="0" max="20" v-model.number="fichaAberta.folego">
                    </div>
                    <div class="campo" style="grid-column:1 / -1">
                      <label>Conceito</label>
                      <textarea rows="2" v-model="fichaAberta.conceito"></textarea>
                    </div>
                    <div class="campo" style="grid-column:1 / -1">
                      <label>Aparência</label>
                      <textarea rows="2" v-model="fichaAberta.aparencia"></textarea>
                    </div>
                    <div class="campo" style="grid-column:1 / -1">
                      <label>Foto URL (personagem)</label>
                      <input v-model="fichaAberta.foto_url">
                    </div>
                  </div>
                </div>
                <div class="card" style="margin-top:14px;background:var(--panel);border:none">
                  <h4 style="margin:0 0 10px;color:var(--azul-bright)">🩹 Condições ativas</h4>
                  <p style="color:var(--ink-faint);font-size:12px;margin:-6px 0 10px">
                    Condições substituem pontos de vida (ver <code>docs/regras_nucleares_campanha.md</code>). Com 3 ativas o personagem está em Crítico — próximo perigo grave pede a rolagem À Beira.
                  </p>
                  <div style="display:flex;gap:8px;flex-wrap:wrap">
                    <label v-for="cond in CONDICOES" :key="cond" class="pill" :class="{on:(fichaAberta.condicoes||[]).includes(cond)}" style="cursor:pointer">
                      <input type="checkbox" style="display:none" :checked="(fichaAberta.condicoes||[]).includes(cond)" @change="toggleCondicaoFicha(cond)">
                      {{ cond }}
                    </label>
                  </div>
                  <div v-if="(fichaAberta.condicoes||[]).length>=3" class="msg erro" style="margin-top:10px">⚠️ Crítico — o próximo perigo grave pede a rolagem À Beira (2d6+Espírito).</div>
                </div>
                <div class="card" style="margin-top:14px;background:var(--panel);border:none">
                  <h4 style="margin:0 0 10px;color:var(--azul-bright)">🤝 Reputação</h4>
                  <p style="color:var(--ink-faint);font-size:12px;margin:-6px 0 10px">
                    Universo inteiro — cidade, vila, NPC, clã, facção. Jogador não edita a própria (só o mestre e a
                    recompensa automática de missão mudam isto).
                  </p>
                  <div class="admin-toolbar">
                    <input v-model="novaRepAlvo" placeholder="Nome — ex: Tolbana, Erik o Fazendeiro, Sindicato dos Ossos…"
                      style="flex:1;background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:8px 10px;border-radius:6px;font:inherit">
                    <select v-model="novaRepTipo" style="background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:8px 10px;border-radius:6px;font:inherit">
                      <option value="outro">Outro</option>
                      <option value="cidade">Cidade</option>
                      <option value="vila">Vila</option>
                      <option value="npc">NPC</option>
                      <option value="cla">Clã</option>
                      <option value="faccao">Facção</option>
                    </select>
                    <input type="number" min="-3" max="3" v-model.number="novaRepDelta" style="width:70px;background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:8px 10px;border-radius:6px;font:inherit">
                    <button class="btn primario" :disabled="!novaRepAlvo.trim()" @click="salvarReputacaoFicha()">Aplicar</button>
                  </div>
                  <div v-if="!reputacoesFicha.length" class="msg warn" style="margin-top:10px">Nenhuma reputação registrada.</div>
                  <div v-else style="display:flex;gap:8px;flex-wrap:wrap;margin-top:10px">
                    <span v-for="r in reputacoesFicha" :key="r.alvo_nome" class="pill" :class="{on:r.nivel>0}">{{ r.alvo_nome }} ({{ r.alvo_tipo }}) · {{ r.nivel }}</span>
                  </div>
                </div>
                <div class="card" style="margin-top:14px;background:var(--panel);border:none">
                  <h4 style="margin:0 0 10px;color:var(--azul-bright)">⚡ Limit Breaker</h4>
                  <p style="color:var(--ink-faint);font-size:12px;margin:-6px 0 10px">
                    Contador por arma equipada (trocar de arma não zera a anterior). Em 10, o golpe especial da arma
                    destrava; usar zera de novo. Ferramenta de mesa — o site não rola isso sozinho.
                  </p>
                  <div class="admin-toolbar">
                    <select v-model="novaLbArma" style="flex:1;background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:8px 10px;border-radius:6px;font:inherit">
                      <option value="">-- Escolher tipo de arma --</option>
                      <option v-for="a in tiposArma" :key="a" :value="a">{{ a }}</option>
                    </select>
                    <button class="btn primario" :disabled="!novaLbArma" @click="adicionarLimitBreaker()">Adicionar</button>
                  </div>
                  <div v-if="!limitBreakerFicha.length" class="msg warn" style="margin-top:10px">Nenhum contador registrado ainda.</div>
                  <div v-else class="admin-list" style="margin-top:10px">
                    <div v-for="lb in limitBreakerFicha" :key="lb.arma_tipo" class="admin-row">
                      <div style="flex:1">
                        <div class="row-nome">{{ lb.arma_tipo }} <span v-if="lb.contador>=10" class="pill on">destravado!</span></div>
                        <div class="row-sub">{{ lb.contador }}/10</div>
                      </div>
                      <button class="btn tiny" @click="ajustarLimitBreaker(lb,-1)">−1</button>
                      <button class="btn tiny" @click="ajustarLimitBreaker(lb,1)">+1</button>
                      <button class="btn tiny primario" :disabled="lb.contador<10" @click="usarLimitBreaker(lb)">⚡ Usar (zera)</button>
                    </div>
                  </div>
                </div>
                <div style="margin-top:14px;display:flex;gap:10px;justify-content:space-between;flex-wrap:wrap">
                  <button class="btn bad ghost" @click="excluirPersonagem(fichaAberta)">🗑️ Excluir (lógico)</button>
                  <div style="display:flex;gap:10px">
                    <button class="btn" @click="resetarSenha(fichaAberta)">🔑 Resetar senha</button>
                    <button class="btn" @click="fichaAberta=null">Fechar</button>
                    <button class="btn primario" :disabled="salvandoPers" @click="salvarPersonagem()">
                      {{ salvandoPers ? '💾 Salvando…' : '💾 Salvar alterações' }}
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!-- Modal reset senha -->
          <div v-if="senhaResetada" class="modal-bg on" @click.self="senhaResetada=null">
            <div class="modal" style="max-width:560px">
              <div class="top">
                <h2>🔑 Senha resetada</h2>
                <button class="btn ghost" @click="senhaResetada=null">✕</button>
              </div>
              <div class="body">
                <div class="msg ok" style="margin:0 0 12px">Envie essa senha para <b>{{ senhaResetada.nome }}</b> no Discord.</div>
                <div style="display:flex;gap:8px;align-items:center">
                  <code style="flex:1;background:var(--panel-3);padding:10px 12px;border-radius:6px;border:1px solid var(--laranja);color:var(--azul-bright);font-size:16px;letter-spacing:.05em;word-break:break-all">{{ senhaResetada.senha }}</code>
                  <button class="btn primario" @click="copiarSenhaResetada()">{{ copiadoReset?'✅ Copiado':'📋 Copiar' }}</button>
                </div>
                <div style="text-align:right;margin-top:16px">
                  <button class="btn" @click="senhaResetada=null">Fechar</button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- ============ ABA 3: CRIAR PERSONAGEM (mantido, com visual novo) ============ -->
        <div v-if="aba==='criar'" class="admin-content">
          <div class="card" style="background:var(--panel-2);border-color:var(--line)">
            <h3 style="margin:0 0 10px;color:var(--azul-bright)">🧙 Criar Jogador / Personagem</h3>
            <p style="color:var(--ink-dim);margin:0 0 14px;font-size:13px">Preencha os dados. O sistema gera uma senha forte automática e exibe aqui para você copiar e enviar no Discord.</p>
            <div class="form">
              <div style="grid-column:1 / -1">
                <div class="campo foto-campo">
                  <label>Foto do personagem (URL)</label>
                  <div style="display:grid;grid-template-columns:160px 1fr;gap:14px;align-items:stretch">
                    <div class="foto-preview" :style="previewEstilo">
                      <span v-if="!F.foto_url">👤</span>
                    </div>
                    <div style="display:grid;gap:6px">
                      <input v-model="F.foto_url" placeholder="Cole uma URL de imagem ou deixe em branco." style="width:100%;background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:10px 12px;border-radius:6px;font:inherit;outline:none">
                      <div style="display:flex;gap:8px;flex-wrap:wrap">
                        <button class="btn" type="button" @click="aleatorioFoto()">🎲 Foto aleatória</button>
                        <button class="btn ghost" type="button" @click="F.foto_url=''">Limpar</button>
                      </div>
                      <small style="color:var(--ink-faint);font-size:12px">Dica: use qualquer URL HTTPS (Discord, Gravatar, Dicebear, Imgur).</small>
                    </div>
                  </div>
                </div>
              </div>
              <div class="campo">
                <label>Nome no Discord <span style="color:#e05050">*</span></label>
                <input v-model.trim="F.discord_nome" placeholder="Ex: Shen#1234">
              </div>
              <div class="campo">
                <label>E-mail do Discord <span style="color:#e05050">*</span></label>
                <input v-model.trim="F.discord_email" type="email" placeholder="Ex: shen@exemplo.com">
              </div>
              <div class="campo">
                <label>Nome do personagem <span style="color:#e05050">*</span></label>
                <input v-model.trim="F.nome" placeholder="Ex: Shen Kurenai">
              </div>
              <div class="campo">
                <label>Profissão</label>
                <select v-model="F.profissao">
                  <option value="">-- Sem profissão --</option>
                  <option v-for="o in oficios" :key="o.nome" :value="o.nome">{{ o.nome }} · {{ o.atributo||'—' }}</option>
                </select>
              </div>
              <div class="campo">
                <label>Arma inicial (Comum)</label>
                <select v-model="F.arma">
                  <option value="">-- Sem arma --</option>
                  <option v-for="a in armasComuns" :key="a.id" :value="a.id?.startsWith && a.id.startsWith('arm-')?a.id:a.id || a.nome">{{ a.nome }} · Dano {{ a.dano_padrao || '?' }}</option>
                </select>
              </div>
              <div class="campo">
                <label>Clã / Guilda</label>
                <select v-model="F.guilda">
                  <option value="">-- Independente --</option>
                  <option v-for="g in clas" :key="g.id" :value="g.nome">{{ g.nome }}</option>
                </select>
              </div>
              <div style="grid-column:1 / -1;margin-top:6px">
                <h4 style="margin:0 0 8px;color:var(--azul-bright)">Atributos · Padrão Andar 1: 0, -1, -1, -1, -2 = <b>-5</b></h4>
                <div class="atributos">
                  <div v-for="a in listaAtributos" :key="a.k" class="atrib" :class="{pos:a.v>0, neg:a.v<0}">
                    <label>{{ a.nome }}</label>
                    <input type="range" :min="-2" :max="2" step="1" v-model.number="a.v">
                    <div class="v">{{ a.v > 0 ? '+' : '' }}{{ a.v }}</div>
                  </div>
                </div>
                <div class="sum-box" :style="somaBoxEstilo">Soma = {{ somaAtributos }}</div>
              </div>
              <div class="campo" style="grid-column:1 / -1">
                <label>Conceito</label>
                <textarea v-model="F.conceito" rows="2"></textarea>
              </div>
              <div class="campo" style="grid-column:1 / -1">
                <label>Aparência</label>
                <textarea v-model="F.aparencia" rows="2"></textarea>
              </div>
              <div style="grid-column:1 / -1;display:flex;gap:10px;justify-content:flex-end">
                <button class="btn ghost" type="button" @click="resetarForm()">Resetar</button>
                <button class="btn primario" :disabled="salvando" type="button" @click="salvar()">
                  {{ salvando ? 'Criando…' : '✨ Criar Personagem & Gerar Senha' }}
                </button>
              </div>
            </div>
          </div>
          <div v-if="resultadoCriacao" class="modal-bg on" @click.self>
            <div class="modal" style="max-width:640px">
              <div class="top">
                <h2>✅ Jogador criado!</h2>
                <button class="btn ghost" @click="resultadoCriacao=null">Fechar</button>
              </div>
              <div class="body">
                <div class="msg ok" style="margin:0 0 12px">⚠️ Copie a senha AGORA e envie para <b>{{ resultadoCriacao.nome }}</b> — única vez!</div>
                <div class="card" style="padding:14px;background:var(--panel)">
                  <div style="display:grid;grid-template-columns:140px 1fr;gap:6px;font-size:13.5px">
                    <div style="color:var(--ink-dim)">👤 Personagem</div><div><b>{{ resultadoCriacao.nome }}</b></div>
                    <div style="color:var(--ink-dim)">💬 Discord</div><div>{{ resultadoCriacao.discord_nome || '—' }}</div>
                    <div style="color:var(--ink-dim)">📧 Login (email)</div><div><code style="background:var(--panel-3);padding:2px 6px;border-radius:4px">{{ resultadoCriacao.email }}</code></div>
                    <div style="color:var(--ink-dim)">🔑 Senha</div>
                    <div>
                      <div style="display:flex;gap:8px;align-items:center;flex-wrap:wrap">
                        <code style="flex:1;min-width:220px;background:var(--panel-3);padding:8px 10px;border-radius:6px;font-size:15px;border:1px solid var(--laranja);color:var(--azul-bright)">{{ resultadoCriacao.senha }}</code>
                        <button class="btn primario" @click="copiarSenhaCriada()">{{ copiadoCriada?'✅ Copiado!':'📋 Copiar' }}</button>
                      </div>
                    </div>
                  </div>
                </div>
                <div style="display:flex;gap:10px;justify-content:flex-end;margin-top:14px">
                  <button class="btn" @click="resultadoCriacao=null; resetarForm()">Criar OUTRO jogador</button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- ============ ABA 4: COMPÊNDIO (edita QUALQUER conteúdo do jogo) ============ -->
        <div v-if="aba==='compendio'" class="admin-content">
          <div class="msg info">
            📚 Aqui você cria, edita e exclui (logicamente) qualquer conteúdo do jogo — monstros, missões, receitas,
            materiais, pontos do mapa, clãs, ofícios e mais. O que não muda por aqui de propósito é <b>mecânica pura de
            regra</b> (ex: a fórmula de chance de sucesso, que usa só o Nível de Profissão) — isso mora no código, não
            no banco, pra não quebrar o jogo sem querer.
          </div>
          <div v-for="g in gruposCompendio" :key="g.k" class="card" style="background:var(--panel-2)">
            <div class="compendio-grupo-head" @click="g.colapsavel && (grupoAberto[g.k] = !grupoAberto[g.k])">
              <h4 style="margin:0;color:var(--azul-bright)">{{ g.ico }} {{ g.lbl }}</h4>
              <span v-if="g.colapsavel" class="pill">{{ grupoAberto[g.k] ? '▾ ocultar' : '▸ mostrar' }}</span>
            </div>
            <div v-if="!g.colapsavel || grupoAberto[g.k]" class="compendio-grid">
              <button
                v-for="t in g.tabelas"
                :key="t"
                class="compendio-item"
                @click="compendioAberto = t"
              >
                <span class="ico">{{ tabelaCfg(t)?.icone || '📄' }}</span>
                <span class="lbl">{{ tabelaCfg(t)?.rotulo || t }}</span>
              </button>
            </div>
          </div>
        </div>

        <EditorEntidade
          v-if="compendioAberto"
          :tabela="compendioAberto"
          @fechar="compendioAberto = null"
        />

        <!-- ============ ABA 7: MERCADO ============ -->
        <div v-if="aba==='mercado'" class="admin-content">
          <div class="card" style="background:var(--panel-2)">
            <h4 style="margin:0 0 12px;color:var(--azul-bright)">🏪 Anúncios do mercado</h4>
            <button class="btn" style="margin-bottom:10px" @click="carregarMercado()">🔄 Atualizar</button>
            <div v-if="carregandoMercado" class="msg info carregando">Carregando mercado…</div>
            <div v-else-if="!anuncios.length" class="msg warn">Nenhum anúncio no mercado.</div>
            <div v-else class="admin-list">
              <div v-for="a in anuncios" :key="a.id" class="admin-row">
                <div style="flex:1">
                  <div class="row-nome">{{ a.inventario?.nome || a.item_id || ('Item #'+a.inventario_id) }}</div>
                  <div class="row-sub">👤 Vendedor: {{ a.vendedor_nome }} · {{ a.inventario?.quantidade || 1 }} × {{ a.preco_col || 0 }} Col</div>
                </div>
                <div style="text-align:right">
                  <div class="row-val">💵 {{ a.preco_col || 0 }} Col</div>
                  <div class="row-sub" v-if="a.expira_em">⏳ Expira {{ formatarData(a.expira_em) }}</div>
                </div>
                <button class="btn tiny bad ghost" @click="removerAnuncio(a)" style="margin-left:8px">🗑️ Remover</button>
              </div>
            </div>
          </div>
        </div>

        <!-- ============ ABA 8: INVENTÁRIOS (ver stash de qualquer jogador) ============ -->
        <div v-if="aba==='inventarios'" class="admin-content">
          <div class="card" style="background:var(--panel-2)">
            <h4 style="margin:0 0 12px;color:var(--azul-bright)">🎒 Inventários · Stash (por jogador)</h4>
            <div class="admin-toolbar">
              <select v-model="invPers" style="flex:1;background:var(--panel-3);border:1px solid var(--line);color:var(--ink);padding:9px 12px;border-radius:6px;font:inherit">
                <option value="">-- Selecione um jogador --</option>
                <option v-for="p in jogadores" :key="p.nome" :value="p.nome">{{ p.nome }} ({{ p.profissao || 'Sem profissão' }})</option>
              </select>
              <button class="btn" :disabled="!invPers" @click="carregarInventarioJog()">🔄 Carregar inventário</button>
            </div>
            <div v-if="carregandoInvJog" class="msg info carregando" style="margin-top:10px">Carregando inventário…</div>
            <div v-else-if="invPers && !invItens.length" class="msg warn" style="margin-top:10px">Inventário vazio para esse jogador.</div>
            <div v-else-if="invItens.length" class="admin-list" style="margin-top:10px">
              <div v-for="it in invItens" :key="it.id" class="admin-row">
                <span class="pill">{{ tituloTipo(it.tipo) }}</span>
                <div style="flex:1">
                  <div class="row-nome">{{ it.nome || it.item_id }}</div>
                  <div class="row-sub">{{ it.slot || '—' }} <span v-if="it.equipado">· equipado</span></div>
                </div>
                <span class="pill on">📦 x {{ it.quantidade || 1 }}</span>
              </div>
            </div>
          </div>
        </div>

      </section>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth.js'
import { useSupa } from '../lib/supabase.js'
import { TABELAS_ADMIN, GRUPOS_COMPENDIO } from '../lib/tabelasAdmin.js'
import EditorEntidade from '../components/EditorEntidade.vue'

const auth = useAuthStore()
defineEmits(['pedir-login'])
const supa = useSupa()

// ===== Sidebar de navegação admin =====
const aba = ref('dashboard')
const secoes = [
  { k:'dashboard', ico:'📊', lbl:'Dashboard', desc:'Visão geral da campanha: jogadores, dinheiro, profissões, ações rápidas.' },
  { k:'mesa', ico:'🎬', lbl:'Mesa & Sessão', desc:'Relógios narrativos, preparação de raid, favor/suspeita, log de sessão, condições e rastreador de combate — estado gravado no banco, só o mestre vê.', divider:true },
  { k:'jogadores', ico:'👥', lbl:'Jogadores', desc:'Lista de todos os personagens. Clique em um para abrir a ficha completa, editar, resetar senha ou excluir logicamente.', divider:true },
  { k:'criar',     ico:'➕', lbl:'Criar Personagem', desc:'Formulário para cadastrar um novo aventureiro, com senha forte gerada automaticamente.' },
  { k:'compendio', ico:'📚', lbl:'Compêndio', desc:'Todo o conteúdo do jogo — monstros, missões, receitas, materiais, pontos do mapa, clãs e mais. Crie, edite e exclua livremente.', divider:true },
  { k:'mercado',   ico:'🏪', lbl:'Mercado', desc:'Anúncios ativos do mercado dos jogadores, valores e data de expiração.', divider:true },
  { k:'inventarios', ico:'🎒', lbl:'Inventários', desc:'Inspecione o inventário pessoal e stash de qualquer jogador.' },
]
const secaoAtual = computed(() => secoes.find(s => s.k === aba.value))

// ===== ====== ABA JOGADORES / DASHBOARD ===== ======
const carregandoPers = ref(false)
const jogadores = ref([])
const buscaJog = ref('')
const filtroProf = ref('')
const totalPersonagens = computed(() => jogadores.value.filter(p=>!p.excluido).length)
const totalColCirculante = computed(() => jogadores.value.reduce((s,p)=>s+(p.col_mao||0)+(p.col_guardado||0),0).toLocaleString('pt-BR'))
const totalProfissoesDiferentes = computed(() => new Set(jogadores.value.map(p=>p.profissao).filter(Boolean)).size)
const CONDICOES = ['Exposto','Ferido','Abalado','Separado','Exaurido','Comprometido']
const mediaFolego = computed(() => {
  const ativos = jogadores.value.filter(p=>!p.excluido)
  if (!ativos.length) return 0
  return ativos.reduce((s,p)=>s+(p.folego??0),0) / ativos.length
})
const distProfissoes = computed(() => {
  const h = {}
  jogadores.value.forEach(p => { const k = p.profissao || 'Sem profissão'; h[k] = (h[k]||0)+1 })
  return Object.keys(h).sort().map(n => ({ nome:n, qtd: h[n] }))
})
const jogadoresFiltrados = computed(() => {
  let l = jogadores.value
  if (filtroProf.value) l = l.filter(p => p.profissao === filtroProf.value)
  if (buscaJog.value.trim()) {
    const s = buscaJog.value.toLowerCase()
    l = l.filter(p => [p.nome, p.discord_nome, p.discord_email, p.profissao, p.guilda].join(' ').toLowerCase().indexOf(s)>=0)
  }
  return l
})
const fichaAberta = ref(null)
const salvandoPers = ref(false)
const senhaResetada = ref(null)
const copiadoReset = ref(false), copiadoCriada = ref(false)
const atributosAbertos = computed({
  get() {
    const at = (fichaAberta.value && fichaAberta.value.atributos) || {}
    return Object.keys({tecnica:0,espirito:0,conhecimento:0,reflexo:0,corpo:0}).map(k => ({
      k,
      nome: {tecnica:'Técnica',espirito:'Espírito',conhecimento:'Conhecimento',reflexo:'Reflexo',corpo:'Corpo'}[k],
      v: at[k] ?? 0
    }))
  },
  set(val) {
    if (!fichaAberta.value) return
    const at = {}
    val.forEach(a => at[a.k] = a.v)
    fichaAberta.value.atributos = at
  }
})
function selecionarPersonagem(p){
  fichaAberta.value = JSON.parse(JSON.stringify(p))
  // guarda o nome ORIGINAL à parte: e' a chave primaria de verdade (texto),
  // e outras tabelas (inventario, transacoes, nivel_profissao...) guardam
  // esse texto como referencia solta, sem FK com cascade — se o campo
  // "Nome" for editado no formulario, o WHERE do update tem que continuar
  // mirando a linha original, senão a busca erra e nada salva.
  fichaAberta.value._pkNome = p.nome
  carregarReputacaoFicha()
  carregarLimitBreakerFicha()
}
function toggleCondicaoFicha(cond){
  if (!fichaAberta.value) return
  const atual = fichaAberta.value.condicoes || []
  fichaAberta.value.condicoes = atual.includes(cond) ? atual.filter(c=>c!==cond) : [...atual, cond]
}

// ===== ====== REPUTAÇÃO (na ficha de cada jogador) ===== ======
const reputacoesFicha = ref([])
const novaRepAlvo = ref(''), novaRepTipo = ref('outro'), novaRepDelta = ref(1)
async function carregarReputacaoFicha(){
  reputacoesFicha.value = []
  if (!fichaAberta.value?._pkNome) return
  const r = await supa.from('reputacao_personagem').select('*').eq('personagem_nome', fichaAberta.value._pkNome).order('alvo_nome')
  reputacoesFicha.value = r.data || []
}
async function salvarReputacaoFicha(){
  const alvo = novaRepAlvo.value.trim()
  if (!alvo || !fichaAberta.value?._pkNome) return
  try {
    const r = await supa.rpc('mestre_ajustar_reputacao', {
      p_personagem_nome: fichaAberta.value._pkNome, p_alvo_nome: alvo,
      p_delta: novaRepDelta.value, p_alvo_tipo: novaRepTipo.value, p_motivo: 'ajuste manual do mestre',
    })
    if (r.error) throw r.error
    novaRepAlvo.value = ''; novaRepTipo.value = 'outro'; novaRepDelta.value = 1
    await carregarReputacaoFicha()
  } catch(e){ alert('Erro ao ajustar reputação: '+e.message) }
}

// ===== ====== LIMIT BREAKER (na ficha de cada jogador) ===== ======
const tiposArma = ref([])
const limitBreakerFicha = ref([])
const novaLbArma = ref('')
async function carregarTiposArma(){
  if (tiposArma.value.length) return
  const r = await supa.from('moves_arma').select('nome').order('nome')
  tiposArma.value = (r.data || []).map(x => x.nome)
}
async function carregarLimitBreakerFicha(){
  limitBreakerFicha.value = []
  if (!fichaAberta.value?._pkNome) return
  const r = await supa.from('limit_breaker_contador').select('*').eq('personagem_nome', fichaAberta.value._pkNome).order('arma_tipo')
  limitBreakerFicha.value = r.data || []
}
async function adicionarLimitBreaker(){
  if (!novaLbArma.value || !fichaAberta.value?._pkNome) return
  try {
    await supa.from('limit_breaker_contador').upsert({ personagem_nome: fichaAberta.value._pkNome, arma_tipo: novaLbArma.value, contador: 0 })
    novaLbArma.value = ''
    await carregarLimitBreakerFicha()
  } catch(e){ alert('Erro: '+e.message) }
}
async function ajustarLimitBreaker(lb, delta){
  const novo = Math.max(0, Math.min(10, lb.contador + delta))
  lb.contador = novo
  try { await supa.from('limit_breaker_contador').update({ contador: novo }).eq('personagem_nome', lb.personagem_nome).eq('arma_tipo', lb.arma_tipo) }
  catch(e){ alert('Erro: '+e.message) }
}
async function usarLimitBreaker(lb){
  lb.contador = 0
  try { await supa.from('limit_breaker_contador').update({ contador: 0 }).eq('personagem_nome', lb.personagem_nome).eq('arma_tipo', lb.arma_tipo) }
  catch(e){ alert('Erro: '+e.message) }
}

async function carregarJogadores(){
  carregandoPers.value = true
  try {
    // personagens nao tem coluna de data de criacao — updated_at e' a
    // melhor proxy disponivel (tambem serve pra ver quem mexeu por ultimo).
    const r = await supa.from('personagens').select('*').order('updated_at', {ascending:false})
    jogadores.value = r.data || []
  } catch(e){ console.warn(e) }
  finally { carregandoPers.value = false }
}
async function editarPersonagem(p){ selecionarPersonagem(p) }
async function salvarPersonagem(){
  // pk real de personagens e' "nome" (texto), nao existe coluna "id".
  if (!fichaAberta.value?._pkNome) return
  salvandoPers.value = true
  try {
    const { _pkNome, ...rest } = fichaAberta.value
    const r = await supa.from('personagens').update(rest).eq('nome', _pkNome)
    if (r.error) throw r.error
    if (rest.nome && rest.nome !== _pkNome) {
      alert('Nome mudou de "'+_pkNome+'" para "'+rest.nome+'" — atualizado na ficha, mas inventário, transações e nível de profissão continuam referenciando o nome antigo (não há troca em cascata). Evite renomear personagem com histórico.')
    }
    await carregarJogadores()
    await auth.carregarPerfilEPersonagem()
  } catch(e){ alert('Erro ao salvar: '+e.message) }
  finally { salvandoPers.value = false }
}
async function excluirPersonagem(p){
  if (!confirm(`EXCLUIR (lógico) ${p.nome}? Ele vai desaparecer da lista, mas os dados continuam no banco.`)) return
  try {
    await supa.from('personagens').update({ excluido: true, visivel: false }).eq('nome', p.nome)
    fichaAberta.value = null
    await carregarJogadores()
  } catch(e){ alert('Erro: '+e.message) }
}
function gerarSenha(){
  const letras='ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789!@#$%&*?'
  const len = 14
  let s=''
  const arr = new Uint32Array(len); (window.crypto||window.msCrypto).getRandomValues(arr)
  for (let i=0;i<len;i++) s += letras[arr[i] % letras.length]
  const cls = ['ABCDEFGHJ','abcdefghj','23456789','!@#$%&*?']
  const ar2 = new Uint32Array(cls.length); (window.crypto||window.msCrypto).getRandomValues(ar2)
  return cls.map((c,i)=>c[ar2[i]%c.length]).join('') + s
}
async function resetarSenha(p){
  if (!p?.dono_id && !p?.discord_email){ alert('Esse personagem não tem dono/email vinculado.'); return }
  const email = p.discord_email
  if (!email){ alert('Sem email.'); return }
  const senha = gerarSenha()
  try {
    const r = await supa.rpc('resetar_senha_usuario', { p_email: email, p_nova_senha: senha })
    if (r.error) throw r.error
    senhaResetada.value = { nome: p.nome, senha }
  } catch(e){ alert('Erro ao resetar: '+e.message) }
}
async function copiarSenhaResetada(){
  if (!senhaResetada.value) return
  try { await navigator.clipboard.writeText(senhaResetada.value.senha) } catch(_){}
  copiadoReset.value = true
  setTimeout(()=> copiadoReset.value=false, 2200)
}
async function copiarSenhaCriada(){
  if (!resultadoCriacao.value) return
  try { await navigator.clipboard.writeText(resultadoCriacao.value.senha) } catch(_){}
  copiadoCriada.value = true
  setTimeout(()=> copiadoCriada.value=false, 2200)
}

// ===== ====== CRIAR PERSONAGEM (formulário, mantido) ===== ======
const F = reactive({
  foto_url:'', discord_nome:'', discord_email:'', nome:'', profissao:'', arma:'', guilda:'',
  conceito:'', aparencia:''
})
const listaAtributos = reactive([
  { k:'tecnica',      nome:'Técnica',      v: 0 },
  { k:'espirito',     nome:'Espírito',     v:-1 },
  { k:'conhecimento', nome:'Conhecimento', v:-1 },
  { k:'reflexo',      nome:'Reflexo',      v:-1 },
  { k:'corpo',        nome:'Corpo',        v:-2 },
])
const somaAtributos = computed(() => listaAtributos.reduce((s,a)=>s+a.v, 0))
const somaBoxEstilo = computed(() => {
  const d = somaAtributos.value - (-5)
  if (d === 0) return { background:'linear-gradient(135deg,#1e3a25,#0a0806)',color:'#62c56a',border:'1px solid #62c56a' }
  if (Math.abs(d) <= 1) return { background:'linear-gradient(135deg,#2a2512,#0a0806)',color:'#d9ad5e',border:'1px solid #d9ad5e' }
  return { background:'linear-gradient(135deg,#3a1212,#0a0806)',color:'#e05050',border:'1px solid #e05050' }
})
const oficios = ref([])
const armasComuns = ref([])
const clas = ref([])
const salvando = ref(false)
const resultadoCriacao = ref(null)
const previewEstilo = computed(() => F.foto_url
  ? `background:#1a1526 url('${F.foto_url}') center/cover no-repeat;border:2px solid #7a5ab8;border-radius:10px`
  : `background:#1a1526;border:2px dashed #332a4d;color:#6d6199;display:grid;place-items:center;font-size:60px;border-radius:10px`)
function aleatorioFoto(){
  const seed = (F.nome||F.discord_nome||'avatar').replace(/\s+/g,'').slice(0,12) || Math.random().toString(36).slice(2,10)
  F.foto_url = `https://api.dicebear.com/9.x/thumbs/png?seed=${encodeURIComponent(seed)}&backgroundColor=2d3748,3a3a6a,3a5a3a`
}
function resetarForm(){
  Object.assign(F, { foto_url:'', discord_nome:'', discord_email:'', nome:'', profissao:'', arma:'', guilda:'', conceito:'', aparencia:'' })
  listaAtributos[0].v=0; listaAtributos[1].v=-1; listaAtributos[2].v=-1; listaAtributos[3].v=-1; listaAtributos[4].v=-2
  resultadoCriacao.value=null
}
async function salvar(){
  if (!F.nome){ alert('Informe o NOME do personagem.'); return }
  if (!F.discord_nome){ alert('Informe o Nome no Discord.'); return }
  if (!F.discord_email){ alert('Informe o E-mail do Discord — login do jogador.'); return }
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(F.discord_email)){ alert('E-mail inválido.'); return }
  salvando.value = true
  const senha = gerarSenha()
  try {
    const email = F.discord_email.trim()
    let uid = null
    const rSign = await supa.auth.signUp({ email, password: senha, options: { data: { nome: F.nome, discord_nome: F.discord_nome } } })
    if (rSign.error && rSign.error.code !== 'user_already_exists'){
      const rRPC = await supa.rpc('criar_usuario_mestre', { p_email: email, p_senha: senha, p_nome: F.nome })
      if (rRPC.error) throw new Error('signup: ' + rSign.error.message + ' / RPC: ' + rRPC.error.message)
      uid = typeof rRPC.data === 'string' ? rRPC.data : (rRPC.data && rRPC.data.uid)
    } else if (rSign.error && rSign.error.code === 'user_already_exists'){
      const rRPC = await supa.rpc('resetar_senha_usuario', { p_email: email, p_nova_senha: senha })
      if (rRPC.error) throw new Error('resetar senha: ' + rRPC.error.message)
      uid = typeof rRPC.data === 'string' ? rRPC.data : (rRPC.data && rRPC.data.uid)
    } else {
      uid = rSign.data && rSign.data.user && rSign.data.user.id
    }
    if (!uid) throw new Error('Não consegui criar/recuperar a conta.')
    await supa.from('perfis').upsert([{ id: uid, papel: 'jogador', nome: F.nome, discord_nome: F.discord_nome, discord_email: email, foto_url: F.foto_url || null }])
    const atributos = {}
    listaAtributos.forEach(a => atributos[a.k] = a.v)
    const armaFinal = F.arma?.id ?? F.arma
    // "nome" e' a chave primaria de personagens — sem coluna "id",
    // "nivel", "folego_max" nem "folego_atual" (fôlego e' um valor só,
    // teto fixo de 20 em todo o resto do backend, ver comprar_folego()).
    const rPers = await supa.from('personagens').insert([{
      nome: F.nome, dono_id: uid, profissao: F.profissao || null,
      arma: armaFinal || null, guilda: F.guilda || null, atributos,
      conceito: F.conceito || null, aparencia: F.aparencia || null,
      foto_url: F.foto_url || null, discord_nome: F.discord_nome || null, discord_email: email,
      folego: 20, col_mao: 2000, col_guardado: 1000, visivel: true, excluido: false
    }]).select('nome').single()
    if (rPers.error) throw new Error('personagem insert: ' + rPers.error.message)
    resultadoCriacao.value = { nome: rPers.data.nome, uid, email, senha, discord_nome: F.discord_nome, profissao: F.profissao, arma: F.arma, guilda: F.guilda }
    await carregarJogadores()
    await auth.carregarPerfilEPersonagem()
  } catch(e){ alert('Erro ao criar:\n\n'+e.message) }
  finally { salvando.value = false }
}

// ===== ====== HELPERS compartilhados ===== ======
function tituloTipo(t){
  // valores reais (constraint inventario_tipo_check): arma, equipamento, consumivel, material, carta, cristal, ovo, pet.
  return { material:'🌿 Material', arma:'⚔️ Arma', equipamento:'🥋 Equipamento',
    consumivel:'🍗 Consumível', pet:'🐾 Pet', ovo:'🥚 Ovo', carta:'🃏 Carta', cristal:'💎 Cristal' }[t] || '📦 Item'
}
function formatarData(d){ if(!d)return'—'; try { return new Date(d).toLocaleDateString('pt-BR') } catch(_){return d} }

// ===== ====== ABA COMPÊNDIO (editor genérico de qualquer tabela de conteúdo) ===== ======
const gruposCompendio = GRUPOS_COMPENDIO
const grupoAberto = reactive({})
gruposCompendio.forEach(g => { if (g.colapsavel) grupoAberto[g.k] = false })
const compendioAberto = ref(null)
function tabelaCfg(t){ return TABELAS_ADMIN[t] }

// ===== ====== ABA MERCADO (vitrine dos jogadores) ===== ======
const carregandoMercado = ref(false), anuncios = ref([])
async function carregarMercado(){
  carregandoMercado.value = true
  try {
    const r = await supa.from('vitrine').select('*, inventario: inventario_id (*)').eq('vendido', false).order('criado_em', {ascending:false}).limit(200)
    if (r.error) throw r.error
    anuncios.value = r.data || []
  } catch(e){ console.warn(e) } finally { carregandoMercado.value = false }
}
async function removerAnuncio(a){
  const nomeItem = a.inventario?.nome || a.item_id || ('#'+a.id)
  if (!a?.id || !confirm(`Remover anúncio "${nomeItem}" do mercado?`)) return
  try {
    const r = await supa.rpc('remover_anuncio', { p_vitrine_id: a.id })
    if (r.error) throw r.error
    if (typeof r.data === 'string' && r.data) throw new Error(r.data)
    await carregarMercado()
  } catch(e){ alert('Erro: '+e.message) }
}

// ===== ====== ABA INVENTÁRIOS ===== ======
const invPers = ref(''), carregandoInvJog = ref(false), invItens = ref([])
async function carregarInventarioJog(){
  if (!invPers.value) return
  carregandoInvJog.value = true
  try { const r = await supa.from('inventario').select('*').eq('personagem_nome', invPers.value).order('obtido_em', {ascending:false}).limit(500); invItens.value = r.data || [] }
  catch(e){console.warn(e)} finally { carregandoInvJog.value = false }
}

// ===== ====== ABA MESA & SESSÃO ===== ======
const carregandoMesa = ref(false)
const relogios = ref([])
const raidPrep = ref([])
const raidPrepTotal = computed(() => raidPrep.value.filter(c=>c.marcado).length)
const relacoes = ref([])
const novaRelacaoNome = ref(''), novaRelacaoValor = ref(0)
const sessoes = ref([])
const novaSessao = reactive({ titulo:'', trio:'', fato:'', rumor:'', pressao:'' })
const monstrosRef = ref([])
const monstroEscolhido = ref('')
const combateAtivo = ref([])
const segredosPontos = ref([])
const rarosDoAndar = ref([])

function statusRelacao(v){ return v>=3?'Protegido':v>=1?'Favor':v<=-3?'Bloqueado':v<=-1?'Suspeita':'Neutro' }

async function salvarRelogio(r){
  try { await supa.from('mesa_relogios').update({ valor: r.valor }).eq('id', r.id) }
  catch(e){ console.warn(e) }
}
async function salvarRaidPrep(c){
  try { await supa.from('mesa_raid_prep').update({ marcado: c.marcado }).eq('categoria', c.categoria) }
  catch(e){ console.warn(e) }
}
async function salvarRelacao(){
  const nome = novaRelacaoNome.value.trim()
  if (!nome) return
  try {
    await supa.from('mesa_relacoes').upsert({ nome, valor: novaRelacaoValor.value })
    novaRelacaoNome.value = ''; novaRelacaoValor.value = 0
    await carregarRelacoes()
  } catch(e){ alert('Erro ao salvar relação: '+e.message) }
}
async function removerRelacao(r){
  try { await supa.from('mesa_relacoes').delete().eq('nome', r.nome); await carregarRelacoes() }
  catch(e){ alert('Erro: '+e.message) }
}
async function carregarRelacoes(){
  const r = await supa.from('mesa_relacoes').select('*').order('nome')
  relacoes.value = r.data || []
}
async function toggleCondicaoJogador(p, cond){
  const atual = p.condicoes || []
  const novo = atual.includes(cond) ? atual.filter(c=>c!==cond) : [...atual, cond]
  p.condicoes = novo // otimista — atualiza a lista na hora
  try { await supa.from('personagens').update({ condicoes: novo }).eq('nome', p.nome) }
  catch(e){ alert('Erro ao salvar condição: '+e.message) }
}
async function adicionarCombate(){
  const m = monstrosRef.value.find(x => x.id === monstroEscolhido.value)
  if (!m) return
  try {
    const r = await supa.from('mesa_combate').insert({
      monstro_id: m.id, monstro_nome: m.nome, nivel_ameaca: m.ameaca, golpes_alvo: m.golpes, golpes_atual: 0, ativo: true,
    }).select().single()
    if (r.error) throw r.error
    combateAtivo.value.unshift(r.data)
    monstroEscolhido.value = ''
  } catch(e){ alert('Erro ao adicionar: '+e.message) }
}
async function ajustarGolpes(c, delta){
  c.golpes_atual = Math.max(0, (c.golpes_atual||0) + delta)
  try { await supa.from('mesa_combate').update({ golpes_atual: c.golpes_atual }).eq('id', c.id) }
  catch(e){ console.warn(e) }
}
async function encerrarCombate(c){
  try {
    await supa.from('mesa_combate').update({ ativo: false }).eq('id', c.id)
    combateAtivo.value = combateAtivo.value.filter(x=>x.id!==c.id)
  } catch(e){ alert('Erro: '+e.message) }
}
async function salvarSessao(){
  if (!novaSessao.titulo.trim() && !novaSessao.fato.trim()) return
  try {
    await supa.from('mesa_sessoes').insert({ ...novaSessao })
    Object.assign(novaSessao, { titulo:'', trio:'', fato:'', rumor:'', pressao:'' })
    await carregarSessoes()
  } catch(e){ alert('Erro ao salvar sessão: '+e.message) }
}
async function carregarSessoes(){
  const r = await supa.from('mesa_sessoes').select('*').order('criado_em', {ascending:false}).limit(12)
  sessoes.value = r.data || []
}
async function carregarMesa(){
  carregandoMesa.value = true
  try {
    const [rRel, rRaid, rRelac, rSess, rMonst, rComb, rPontos, rArmas, rEquip] = await Promise.all([
      supa.from('mesa_relogios').select('*').order('id'),
      supa.from('mesa_raid_prep').select('*').order('categoria'),
      supa.from('mesa_relacoes').select('*').order('nome'),
      supa.from('mesa_sessoes').select('*').order('criado_em', {ascending:false}).limit(12),
      // monstros_publico: mesmo motivo do pontos_publico logo abaixo — a
      // tabela base "monstros" nunca teve GRANT SELECT pra "authenticated"
      // (só a view resolve com segurança); essa linha ficou pra trás quando
      // o fix foi aplicado no resto do arquivo (achado 11/08 revendo
      // Combate.vue, que tinha o mesmo bug pro jogador comum).
      supa.from('monstros_publico').select('id,nome,ameaca,golpes').order('nome'),
      supa.from('mesa_combate').select('*').eq('ativo', true).order('criado_em', {ascending:false}),
      // pontos_publico: a coluna "mestre" nunca teve GRANT SELECT na tabela
      // base pra "authenticated" — só a view resolve com segurança via
      // CASE WHEN is_mestre() (achado 10/08, "permission denied for table
      // pontos"). A view já filtra visivel/excluido; is_mestre() bypassa
      // ambos, então o mestre também vê ponto excluído aqui — aceitável
      // pra uma lista de segredos/puzzles de mesa.
      supa.from('pontos_publico').select('id,nome,regiao,descricao,mestre').in('categoria', ['segredo','puzzle']),
      supa.from('armas').select('id,nome,tipo,efeito,obter').eq('raridade','Raro').eq('excluido',false),
      supa.from('equipamentos').select('id,nome,slot,efeito,obter').eq('raridade','Raro').eq('excluido',false),
    ])
    relogios.value = rRel.data || []
    raidPrep.value = rRaid.data || []
    relacoes.value = rRelac.data || []
    sessoes.value = rSess.data || []
    monstrosRef.value = rMonst.data || []
    combateAtivo.value = rComb.data || []
    segredosPontos.value = rPontos.data || []
    rarosDoAndar.value = [...(rArmas.data||[]), ...(rEquip.data||[])]
    await Promise.all([carregarMetasAtivas(), carregarPainelProfissoes()])
  } catch(e){ console.warn(e) }
  finally { carregandoMesa.value = false }
}

// ===== ====== METAS GLOBAIS (item 18C) ===== ======
const metasAtivas = ref([])
const novaMeta = reactive({ titulo:'', descricao:'', meta_item:'', meta_qtd:10, recompensa_col:0, recompensa_xp:0, recompensa_reputacao_alvo_nome:'', recompensa_reputacao_valor:0 })
async function carregarMetasAtivas(){
  const r = await supa.from('metas_globais').select('*').eq('finalizada', false).order('criado_em', {ascending:false})
  metasAtivas.value = r.data || []
}

// ===== ====== PAINEL DE PROFISSÕES (item 16 parte 3, visão mestre) ===== ======
const painelProfissoes = ref([])
async function carregarPainelProfissoes(){
  const [rOf, rNp] = await Promise.all([
    supa.from('oficios').select('nome').eq('excluido', false).order('nome'),
    supa.from('nivel_profissao').select('profissao,nivel'),
  ])
  const porProf = {}
  for (const r of (rNp.data || [])) {
    const k = r.profissao
    if (!porProf[k]) porProf[k] = { jogadores: 0, nivelMax: 0 }
    porProf[k].jogadores++
    porProf[k].nivelMax = Math.max(porProf[k].nivelMax, r.nivel || 1)
  }
  painelProfissoes.value = (rOf.data || []).map(o => ({
    nome: o.nome,
    jogadores: porProf[o.nome]?.jogadores || 0,
    nivelMax: porProf[o.nome]?.nivelMax || 0,
  }))
}
async function criarMetaGlobal(){
  try {
    const r = await supa.rpc('criar_meta_global', {
      p_titulo: novaMeta.titulo, p_descricao: novaMeta.descricao, p_meta_item: novaMeta.meta_item, p_meta_qtd: novaMeta.meta_qtd,
      p_recompensa_col: novaMeta.recompensa_col || null, p_recompensa_xp: novaMeta.recompensa_xp || null,
      p_recompensa_item: null,
      p_recompensa_reputacao_alvo_nome: novaMeta.recompensa_reputacao_alvo_nome || null,
      p_recompensa_reputacao_valor: novaMeta.recompensa_reputacao_valor || null,
    })
    if (r.error) throw r.error
    const d = JSON.parse(r.data)
    if (d.erro) { alert(d.erro); return }
    Object.assign(novaMeta, { titulo:'', descricao:'', meta_item:'', meta_qtd:10, recompensa_col:0, recompensa_xp:0, recompensa_reputacao_alvo_nome:'', recompensa_reputacao_valor:0 })
    await carregarMetasAtivas()
  } catch(e){ alert('Erro ao criar meta: '+e.message) }
}

// ===== ====== ON MOUNT ===== ======
onMounted(async () => {
  if (!auth.ready) await auth.init()
  if (!auth.ehMestre) return
  // Carrega catálogos para criar personagem e para as abas
  const proms = [
    supa.from('oficios').select('nome, atributo').eq('excluido',false),
    supa.from('armas').select('*').eq('raridade','Comum').eq('excluido',false),
    // clas_publico: mesmo motivo do pontos_publico acima — "ganchos" só
    // tem GRANT SELECT resolvido com segurança dentro da view.
    supa.from('clas_publico').select('*'),
    carregarJogadores(), carregarMercado(), carregarMesa(), carregarTiposArma(),
  ]
  const [rOf, rAr, rCl] = await Promise.all(proms)
  oficios.value = (rOf?.data || []).sort((a,b)=>a.nome.localeCompare(b.nome,'pt-BR'))
  armasComuns.value = (rAr?.data || []).sort((a,b)=>(a.nome||'').localeCompare(b.nome||'','pt-BR'))
  clas.value = (rCl?.data || []).sort((a,b)=>(a.nome||'').localeCompare(b.nome||'','pt-BR'))
})
</script>

<style scoped>
.admin-shell {
  display: grid;
  grid-template-columns: 240px 1fr;
  gap: 18px;
  margin-top: 8px;
  min-height: 70vh;
}
.admin-sidebar {
  background: var(--panel);
  backdrop-filter: blur(10px);
  border: 1px solid var(--line);
  border-left: 3px solid var(--laranja);
  padding: 16px 12px;
  display: flex;
  flex-direction: column;
  gap: 14px;
  min-height: 100%;
  position: sticky;
  top: 10px;
}
.admin-brand {
  display: flex; gap: 10px; align-items: center;
  padding: 10px 8px;
  background: rgba(255,153,0,.08);
  border: 1px solid var(--line);
}
.brand-emoji { font-size: 34px; line-height: 1; }
.brand-title { color: var(--ink); font-weight: 800; font-size: 15px; letter-spacing: .01em; font-family: var(--f-titulo); }
.brand-sub { color: var(--ink-faint); font-size: 11px; font-family: var(--f-mono); }
.admin-nav { display: flex; flex-direction: column; gap: 3px; }
.admin-nav-item {
  display: flex; align-items: center; gap: 10px;
  padding: 10px 12px;
  color: var(--ink-dim); font-size: 13.5px; cursor: pointer;
  border: 1px solid transparent;
  transition: all .15s;
}
.admin-nav-item.d { margin-top: 10px; border-top: 1px dashed var(--line); padding-top: 14px; }
.admin-nav-item:hover { background: rgba(255,153,0,.08); color: var(--laranja-bright); }
.admin-nav-item:focus-visible { outline: 2px solid var(--laranja); outline-offset: -2px; }
.admin-nav-item.on {
  background: linear-gradient(90deg, rgba(255,153,0,.16), rgba(255,153,0,.03));
  border-color: var(--laranja-dim);
  color: #ffffff;
  font-weight: 700;
  box-shadow: inset 0 0 12px rgba(255,153,0,.08);
}
.admin-nav-item .ico { font-size: 18px; }
.admin-nav-item .lbl { flex: 1; }
.admin-foot { margin-top: auto; padding-top: 10px; border-top: 1px dashed var(--line); }

.admin-main { min-width: 0; }
.admin-header {
  background: var(--panel);
  backdrop-filter: blur(10px);
  border: 1px solid var(--line);
  border-left: 3px solid var(--laranja);
  padding: 14px 18px;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 12px;
  flex-wrap: wrap;
  margin-bottom: 14px;
}
.admin-header h2 { margin: 0; color: var(--ink); font-size: 21px; font-family: var(--f-titulo) }
.admin-desc { margin: 4px 0 0; color: var(--ink-dim); font-size: 13px; max-width: 70ch; }
.admin-content { display: grid; gap: 14px; }

.admin-statgrid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 12px;
}
.admin-stat {
  background: var(--panel-2);
  border: 1px solid var(--line);
  padding: 14px;
  display: flex;
  gap: 12px;
  align-items: center;
}
.stat-ico {
  width: 52px; height: 52px;
  display: grid; place-items: center;
  font-size: 26px;
  border-radius: 10px;
  flex-shrink: 0;
}
.stat-num { color: var(--ink); font-weight: 800; font-size: 22px; font-family: var(--f-mono); }
.stat-lbl { color: var(--ink-dim); font-size: 12px; margin-top: 2px; }

.admin-twocol {
  display: grid;
  grid-template-columns: 1.2fr 1fr;
  gap: 14px;
}
.admin-toolbar {
  display: flex; gap: 8px; flex-wrap: wrap;
  margin-bottom: 10px;
}
.admin-list { display: flex; flex-direction: column; gap: 6px; }
.admin-row {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 12px;
  background: var(--panel-2);
  border: 1px solid var(--line);
  transition: all .15s;
  flex-wrap: wrap;
}
.admin-row[role="button"], .admin-row.clicavel { cursor: pointer; }
.admin-row[role="button"]:hover { background: var(--panel-3); border-color: var(--azul-dim); }
.admin-row[role="button"]:focus-visible { outline: 2px solid var(--laranja); outline-offset: 1px; }
.row-avatar { width: 38px; height: 38px; border-radius: 8px; object-fit: cover; border: 1px solid var(--line); }
.row-avatar.def { display: grid; place-items: center; background: var(--panel-3); color: var(--ink-faint); font-size: 18px; }
.row-nome { color: var(--ink); font-weight: 700; font-size: 14px; }
.row-sub { color: var(--ink-dim); font-size: 12px; margin-top: 2px; }
.row-val { color: var(--azul-bright); font-weight: 600; font-size: 13px; }
.admin-quick { display: grid; gap: 6px; }
.btn.tiny { padding: 5px 9px; font-size: 12px; }

.admin-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 13px;
}
.admin-table th {
  background: var(--panel-2);
  color: var(--azul-bright);
  text-align: left;
  padding: 10px 12px;
  border-bottom: 1px solid var(--line);
  font-weight: 600;
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: .05em;
}
.admin-table td {
  padding: 10px 12px;
  border-bottom: 1px solid var(--line);
  color: var(--ink-dim);
}
.admin-table tbody tr { cursor: pointer; }
.admin-table tbody tr:hover { background: var(--panel-3); }
.admin-table tbody tr:focus-visible { outline: 2px solid var(--laranja); outline-offset: -2px; }
.pill {
  display: inline-flex;
  gap: 4px;
  align-items: center;
  padding: 2px 8px;
  border-radius: 999px;
  font-size: 11px;
  background: var(--panel-3);
  color: var(--ink-dim);
  border: 1px solid var(--line);
  font-weight: 600;
}
.badge {
  background: var(--laranja);
  color: #1a0f00;
  border-radius: 999px;
  padding: 1px 8px;
  font-size: 10px;
  font-weight: 800;
}

@media (max-width: 900px) {
  .admin-shell { grid-template-columns: 1fr; }
  .admin-sidebar { position: relative; }
  .admin-twocol { grid-template-columns: 1fr; }
}
.foto-preview { aspect-ratio: 1/1; min-height: 160px; }
.foto-campo { grid-column: 1 / -1; }
.modal :deep(.top), .modal :deep(.body) { background: var(--panel-2) !important; }
.modal-bg.on :deep(.modal) { background: var(--panel-2) !important; border-color: var(--line-bright) !important; }

.compendio-grupo-head { display:flex; align-items:center; justify-content:space-between; gap:10px; cursor:default; }
.compendio-grid { display:grid; grid-template-columns:repeat(auto-fill, minmax(190px,1fr)); gap:8px; margin-top:12px; }
.compendio-item {
  display:flex; align-items:center; gap:10px; text-align:left;
  padding:11px 12px; background:var(--panel-2); border:1px solid var(--line);
  color:var(--ink); font:inherit; font-size:13px; cursor:pointer; transition:all .15s;
}
.compendio-item:hover { background:var(--panel-3); border-color:var(--laranja-dim); }
.compendio-item:focus-visible { outline: 2px solid var(--laranja); outline-offset: 1px; }
.compendio-item .ico { font-size:18px; }
.compendio-item .lbl { flex:1; font-weight:600; }
</style>
