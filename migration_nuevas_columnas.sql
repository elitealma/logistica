-- ═══════════════════════════════════════════════════
-- Elite Logística — Migración: Nuevas Columnas
-- Transportadora, Producto, Medio de Pago, Valor Total, Ciudad, Departamento
-- ═══════════════════════════════════════════════════

DO $$
BEGIN
  -- Transportadora (ej: Servientrega, Coordinadora, Interrapidisimo)
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='cards' AND column_name='transportadora') THEN
    ALTER TABLE public.cards ADD COLUMN transportadora TEXT;
  END IF;

  -- Producto
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='cards' AND column_name='producto') THEN
    ALTER TABLE public.cards ADD COLUMN producto TEXT;
  END IF;

  -- Medio de pago (ej: Contra-entrega, Transferencia, PSE, Tarjeta)
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='cards' AND column_name='medio_pago') THEN
    ALTER TABLE public.cards ADD COLUMN medio_pago TEXT;
  END IF;

  -- Valor total
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='cards' AND column_name='valor_total') THEN
    ALTER TABLE public.cards ADD COLUMN valor_total NUMERIC(12,2);
  END IF;

  -- Ciudad destino
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='cards' AND column_name='ciudad') THEN
    ALTER TABLE public.cards ADD COLUMN ciudad TEXT;
  END IF;

  -- Departamento destino
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='cards' AND column_name='departamento') THEN
    ALTER TABLE public.cards ADD COLUMN departamento TEXT;
  END IF;
END $$;

-- Índice para filtro de transportadora
CREATE INDEX IF NOT EXISTS idx_cards_transportadora ON public.cards(transportadora);
