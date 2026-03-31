-- ═══════════════════════════════════════════════════
-- Elite Logística — Migración: Columna estado_legible
-- Agrega la columna que muestra el estado en texto
-- coloquial para que los empleados lo entiendan fácil
-- ═══════════════════════════════════════════════════

-- 1. Agregar columna estado_legible a la tabla cards
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema='public'
      AND table_name='cards'
      AND column_name='estado_legible'
  ) THEN
    ALTER TABLE public.cards
      ADD COLUMN estado_legible TEXT DEFAULT 'Sin estado';
    RAISE NOTICE 'Columna estado_legible agregada correctamente ✅';
  ELSE
    RAISE NOTICE 'La columna estado_legible ya existe, no se vuelve a crear.';
  END IF;
END $$;

-- 2. Poblar automáticamente el estado_legible
--    según el valor interno de "columna" (el kanban)
UPDATE public.cards
SET estado_legible = CASE columna
  WHEN 'GUIA_GENERADA'        THEN '📦 Guía Creada — el paquete aún no ha salido'
  WHEN 'EN_OFICINA'           THEN '🏭 En Bodega Regional — esperando salir a reparto'
  WHEN 'EN_REPARTO'           THEN '🛵 En Camino — el mensajero va hacia el cliente'
  WHEN 'ENTREGADO_AL_CLIENTE' THEN '✅ Entregado — el cliente ya recibió su pedido'
  WHEN 'DEVOLUCIONES'         THEN '🔄 En Devolución — el paquete regresa al remitente'
  ELSE                             '❓ Estado desconocido'
END
WHERE estado_legible IS NULL OR estado_legible = 'Sin estado';

-- 3. Agregar índice para búsquedas por estado_legible
CREATE INDEX IF NOT EXISTS idx_cards_estado_legible ON public.cards(estado_legible);
