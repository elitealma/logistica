-- ═══════════════════════════════════════════════════
-- Elite Logística — Migración: Tabla de Devoluciones
-- Ejecutar en el SQL Editor de Supabase
-- ═══════════════════════════════════════════════════

-- 1. Crear tabla de devoluciones
CREATE TABLE IF NOT EXISTS public.devoluciones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    card_id UUID REFERENCES public.cards(id) ON DELETE CASCADE,
    motivo TEXT NOT NULL,
    estado_devolucion TEXT NOT NULL DEFAULT 'PENDIENTE',
    direccion_retorno TEXT,
    observaciones TEXT,
    fecha_solicitud TIMESTAMPTZ DEFAULT NOW(),
    fecha_devolucion TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Índice
CREATE INDEX IF NOT EXISTS idx_devoluciones_card_id ON public.devoluciones(card_id);

-- 3. RLS
ALTER TABLE public.devoluciones ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow anonymous read devoluciones" ON public.devoluciones;
DROP POLICY IF EXISTS "Allow anonymous insert devoluciones" ON public.devoluciones;
DROP POLICY IF EXISTS "Allow anonymous update devoluciones" ON public.devoluciones;

CREATE POLICY "Allow anonymous read devoluciones" ON public.devoluciones FOR SELECT USING (true);
CREATE POLICY "Allow anonymous insert devoluciones" ON public.devoluciones FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anonymous update devoluciones" ON public.devoluciones FOR UPDATE USING (true);

-- 4. Datos de prueba
INSERT INTO public.cards (numero_guia, cliente_nombre, telefono, columna, mensaje, porcentaje_entrega, pedidos_count, asignado_a)
VALUES
  ('SRV-001249', 'Alejandro Muñoz', '573002345678', 'DEVOLUCIONES', 'Cliente rechazó pedido — solicita devolución', 0, 1, 'Ana María Torres'),
  ('SRV-001250', 'Patricia Reyes Gil', '573008765432', 'DEVOLUCIONES', 'Paquete equivocado — devolver a origen', 0, 2, 'Luis Gómez')
ON CONFLICT (numero_guia) DO NOTHING;

-- 5. Detalle de devolución para las tarjetas nuevas
INSERT INTO public.devoluciones (card_id, motivo, estado_devolucion, direccion_retorno, observaciones)
SELECT c.id, 'Cliente rechazó el pedido', 'PENDIENTE', 'Cra 45 #23-10, Medellín', 'El cliente no estaba en la dirección y rechazó al segundo intento'
FROM public.cards c WHERE c.numero_guia = 'SRV-001249';

INSERT INTO public.devoluciones (card_id, motivo, estado_devolucion, direccion_retorno, observaciones)
SELECT c.id, 'Paquete equivocado', 'EN_PROCESO', 'Cl 80 #15-30, Bogotá', 'Se envió producto diferente al solicitado'
FROM public.cards c WHERE c.numero_guia = 'SRV-001250';
