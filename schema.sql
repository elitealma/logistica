-- Tablas para el Dashboard de Logística

-- 1. Tabla de Cards (Tarjetas de Guía)
CREATE TABLE public.cards (
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

-- 2. Tabla de Movimientos (Historial)
CREATE TABLE public.movimientos (
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
-- Nota: Asegúrese de que la publicación 'supabase_realtime' exista.
-- Si no existe, Supabase suele crearla automáticamente al habilitar Realtime en el dashboard.
-- Para habilitarla vía SQL:
ALTER PUBLICATION supabase_realtime ADD TABLE public.cards;

-- Opcional: Índices para mejorar rendimiento
CREATE INDEX idx_cards_columna ON public.cards(columna);
CREATE INDEX idx_movimientos_card_id ON public.movimientos(card_id);

-- RLS (Row Level Security)
-- Como es un MVP, se asume que se manejará con la anon key para simplificar.
-- Para producción, habilitar RLS y definir políticas.
ALTER TABLE public.cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.movimientos ENABLE ROW LEVEL SECURITY;

-- Políticas básicas para permitir acceso anónimo (MVP)
CREATE POLICY "Allow anonymous read cards" ON public.cards FOR SELECT USING (true);
CREATE POLICY "Allow anonymous update cards" ON public.cards FOR UPDATE USING (true);
CREATE POLICY "Allow anonymous insert cards" ON public.cards FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anonymous delete cards" ON public.cards FOR DELETE USING (true);

CREATE POLICY "Allow anonymous read movimientos" ON public.movimientos FOR SELECT USING (true);
CREATE POLICY "Allow anonymous insert movimientos" ON public.movimientos FOR INSERT WITH CHECK (true);
