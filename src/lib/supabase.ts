import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL ?? '';
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ?? '';

if (typeof window !== 'undefined' && (!supabaseUrl || !supabaseAnonKey)) {
    console.warn(
        '[Elite Logística] Supabase URL or Anon Key is missing. Check your .env file.'
    );
}

export const supabase = createClient(
    supabaseUrl || 'https://placeholder.supabase.co',
    supabaseAnonKey || 'placeholder-key'
);
