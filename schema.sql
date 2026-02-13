-- ═══════════════════════════════════════════════════
-- Elite Logística — Schema (idempotente)
-- Proyecto Transportadoras · Supabase
-- ═══════════════════════════════════════════════════

-- 1. Tabla de Cards (Tarjetas de Guía)
-- Agrega columnas faltantes si la tabla ya existe
DO $$
BEGIN
  -- Crear tabla si no existe
  CREATE TABLE IF NOT EXISTS public.cards (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      numero_guia TEXT UNIQUE NOT NULL,
      cliente_nombre TEXT,
      telefono TEXT,
      columna TEXT NOT NULL DEFAULT 'GUIA_GENERADA',
      mensaje TEXT,
      porcentaje_entrega INTEGER DEFAULT 0,
      pedidos_count INTEGER DEFAULT 1,
      asignado_a TEXT,
      created_at TIMESTAMPTZ DEFAULT NOW(),
      updated_at TIMESTAMPTZ DEFAULT NOW()
  );

  -- Agregar columnas faltantes (si la tabla ya existía)
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='cards' AND column_name='numero_guia') THEN
    ALTER TABLE public.cards ADD COLUMN numero_guia TEXT UNIQUE;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='cards' AND column_name='cliente_nombre') THEN
    ALTER TABLE public.cards ADD COLUMN cliente_nombre TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='cards' AND column_name='telefono') THEN
    ALTER TABLE public.cards ADD COLUMN telefono TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='cards' AND column_name='columna') THEN
    ALTER TABLE public.cards ADD COLUMN columna TEXT NOT NULL DEFAULT 'GUIA_GENERADA';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='cards' AND column_name='mensaje') THEN
    ALTER TABLE public.cards ADD COLUMN mensaje TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='cards' AND column_name='porcentaje_entrega') THEN
    ALTER TABLE public.cards ADD COLUMN porcentaje_entrega INTEGER DEFAULT 0;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='cards' AND column_name='pedidos_count') THEN
    ALTER TABLE public.cards ADD COLUMN pedidos_count INTEGER DEFAULT 1;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='cards' AND column_name='asignado_a') THEN
    ALTER TABLE public.cards ADD COLUMN asignado_a TEXT;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='cards' AND column_name='updated_at') THEN
    ALTER TABLE public.cards ADD COLUMN updated_at TIMESTAMPTZ DEFAULT NOW();
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='cards' AND column_name='created_at') THEN
    ALTER TABLE public.cards ADD COLUMN created_at TIMESTAMPTZ DEFAULT NOW();
  END IF;
END $$;

-- 2. Tabla de Movimientos (Historial)
CREATE TABLE IF NOT EXISTS public.movimientos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    card_id UUID REFERENCES public.cards(id) ON DELETE CASCADE,
    fecha TIMESTAMPTZ DEFAULT NOW(),
    estado TEXT,
    detalle TEXT,
    ciudad TEXT,
    raw JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Habilitar Realtime para la tabla cards
-- (Si ya está agregada, Postgres lanzará un NOTICE, no un error)
DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE public.cards;
EXCEPTION WHEN duplicate_object THEN
  RAISE NOTICE 'cards ya está en supabase_realtime';
END $$;

-- 4. Índices (IF NOT EXISTS)
CREATE INDEX IF NOT EXISTS idx_cards_columna ON public.cards(columna);
CREATE INDEX IF NOT EXISTS idx_movimientos_card_id ON public.movimientos(card_id);

-- 5. RLS
ALTER TABLE public.cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.movimientos ENABLE ROW LEVEL SECURITY;

-- 6. Políticas (DROP + CREATE para ser idempotente)
DROP POLICY IF EXISTS "Allow anonymous read cards" ON public.cards;
DROP POLICY IF EXISTS "Allow anonymous update cards" ON public.cards;
DROP POLICY IF EXISTS "Allow anonymous insert cards" ON public.cards;
DROP POLICY IF EXISTS "Allow anonymous delete cards" ON public.cards;
DROP POLICY IF EXISTS "Allow anonymous read movimientos" ON public.movimientos;
DROP POLICY IF EXISTS "Allow anonymous insert movimientos" ON public.movimientos;

CREATE POLICY "Allow anonymous read cards" ON public.cards FOR SELECT USING (true);
CREATE POLICY "Allow anonymous update cards" ON public.cards FOR UPDATE USING (true);
CREATE POLICY "Allow anonymous insert cards" ON public.cards FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anonymous delete cards" ON public.cards FOR DELETE USING (true);

CREATE POLICY "Allow anonymous read movimientos" ON public.movimientos FOR SELECT USING (true);
CREATE POLICY "Allow anonymous insert movimientos" ON public.movimientos FOR INSERT WITH CHECK (true);
