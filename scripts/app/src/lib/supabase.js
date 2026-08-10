import { createClient } from '@supabase/supabase-js'

let SUPA = null
export function useSupa() {
  if (!SUPA) {
    const url = (import.meta.env.VITE_SUPABASE_URL || '').trim()
    const key = (import.meta.env.VITE_SUPABASE_ANON_KEY || '').trim()
    if (!url || !key) {
      console.warn('[supa] VITE_SUPABASE_URL ou VITE_SUPABASE_ANON_KEY não definido.')
    }
    SUPA = createClient(url, key, {
      auth: { persistSession: true, autoRefreshToken: true, detectSessionInUrl: true }
    })
  }
  return SUPA
}
