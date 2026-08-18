import { defineStore } from 'pinia'
import { useSupa } from '../lib/supabase.js'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    ready: false,
    sessao: null,      // Supabase session (user, access_token etc.)
    perfil: null,     // linha da tabela perfis (papel, nome, discord, foto)
    personagem: null, // personagem vinculado (dono_id === user.id)
  }),
  getters: {
    logado: s => !!s.sessao,
    user: s => s.sessao ? s.sessao.user : null,
    uid: s => s.sessao ? s.sessao.user.id : null,
    ehMestre: s => !!(s.perfil && s.perfil.papel === 'mestre'),
    ehJogador: s => !!(s.perfil && s.perfil.papel === 'jogador'),
    temPersonagem: s => !!s.personagem,
    foto: s => (s.personagem && s.personagem.foto_url) || (s.perfil && s.perfil.foto_url) || '',
    nomeMostrar: s => (s.personagem && s.personagem.nome) || (s.perfil && s.perfil.nome) || (s.sessao && s.sessao.user.email) || ''
  },
  actions: {
    async init() {
      if (this.ready) return
      const supa = useSupa()
      try {
        const { data: sd } = await supa.auth.getSession()
        this.sessao = (sd && sd.session) ? sd.session : null
      } catch (e) { console.error(e) }
      // onChange listener
      supa.auth.onAuthStateChange(async (_evt, sess) => {
        this.sessao = sess
        if (sess) await this.carregarPerfilEPersonagem()
        else { this.perfil = null; this.personagem = null }
        // Link de "esqueci a senha" (redirectTo = raiz do site, sem rota
        // hash — ver LoginModal.vue): o GoTrue processa o token da URL e
        // dispara esse evento sozinho, antes do vue-router conseguir
        // resolver a rota certa a partir do hash "#access_token=...". Força
        // a navegação pra RedefinirSenha.vue explicitamente aqui.
        if (_evt === 'PASSWORD_RECOVERY') location.hash = '#/redefinir-senha'
        // Mesmo problema, versão "confirmar e-mail no autocadastro": o link
        // do e-mail também usa emailRedirectTo = raiz do site (Cadastro.vue),
        // então quem clica cai na Home (rota "/") já logado, mas com a
        // ficha ainda em rascunho no localStorage — Cadastro.vue é quem sabe
        // terminar de criá-la (retomarRascunhoSeExistir), só que só faz isso
        // no próprio onMounted. Sem essa navegação forçada a pessoa fica
        // "logada sem ficha" até entrar em /cadastro na mão.
        if (sess && !this.personagem && localStorage.getItem('sao-rpg-cadastro-pendente')) {
          location.hash = '#/cadastro'
        }
      })
      if (this.sessao) await this.carregarPerfilEPersonagem()
      this.ready = true
    },
    async carregarPerfilEPersonagem() {
      if (!this.uid) { this.perfil=null; this.personagem=null; return }
      const supa = useSupa()
      try {
        const [rp, rpers] = await Promise.all([
          supa.from('perfis').select('*').eq('id', this.uid).maybeSingle(),
          supa.from('personagens').select('*').eq('dono_id', this.uid).maybeSingle()
        ])
        this.perfil = rp.data || null
        this.personagem = rpers.data || null
      } catch (e) {
        console.error('auth.carregarPerfilEPersonagem', e)
      }
    },
    async login(email, senha) {
      const supa = useSupa()
      const r = await supa.auth.signInWithPassword({ email, password: senha })
      if (r.error) throw r.error
      this.sessao = r.data.session
      await this.carregarPerfilEPersonagem()
      return this.sessao
    },
    async logout() {
      try { await useSupa().auth.signOut() } catch (e) { console.error(e) }
      this.sessao = null
      this.perfil = null
      this.personagem = null
    }
  }
})
