import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'node:path'

export default defineConfig(({ mode }) => {
  // Copia variáveis .env da raiz (SUPABASE_URL / SUPABASE_ANON_KEY etc.) para o Vite process.env
  const projRoot = path.resolve(__dirname, '..', '..')
  const env = loadEnv(mode, projRoot, '')
  const viteEnv = {}
  // Variaveis que devem ser expostas pro browser: VITE_ prefix
  viteEnv['VITE_SUPABASE_URL'] = env.SUPABASE_URL || env.VITE_SUPABASE_URL || ''
  viteEnv['VITE_SUPABASE_ANON_KEY'] = env.SUPABASE_ANON_KEY || env.VITE_SUPABASE_ANON_KEY || ''
  return {
    // GitHub Pages publica em usuario.github.io/nome-do-repo/ — o app precisa
    // saber desse prefixo pra referenciar os próprios assets certo. Em dev
    // (npm run dev) fica "/" normal; só o build de produção usa o prefixo.
    base: mode === 'production' ? '/sao-rpg-aincrad/' : '/',
    plugins: [vue()],
    define: Object.fromEntries(
      Object.entries(viteEnv).map(([k,v]) => [`import.meta.env.${k}`, JSON.stringify(v)])
    ),
    resolve: {
      alias: {
        '@': path.resolve(__dirname, 'src')
      }
    },
    server: {
      host: '127.0.0.1',
      port: 5173
    }
  }
})
