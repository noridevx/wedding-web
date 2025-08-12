// Runtime client for Supabase storage (optional configuration)
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

export const SUPABASE_BUCKET = import.meta.env.VITE_SUPABASE_BUCKET || 'wedding-photos'
export const SUPABASE_FOLDER = import.meta.env.VITE_SUPABASE_FOLDER || 'uploads'

export const supabase = (supabaseUrl && supabaseAnonKey)
  ? createClient(supabaseUrl, supabaseAnonKey)
  : null

export function isSupabaseConfigured () {
  return Boolean(supabase)
}

export function buildPublicUrl (bucket, path) {
  if (!supabaseUrl) return ''
  return `${supabaseUrl}/storage/v1/object/public/${bucket}/${path}`
}


