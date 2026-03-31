-- ═══════════════════════════════════════════════════
-- Elite Logística — Migración: Trigger estado_legible
-- Con los 5 procesos reales de Servientrega
-- ═══════════════════════════════════════════════════

-- 1. Función del trigger (actualizada con procesos reales)
CREATE OR REPLACE FUNCTION public.fn_set_estado_legible()
RETURNS TRIGGER AS $$
BEGIN
  NEW.estado_legible := CASE NEW.columna
    WHEN 'GUIA_GENERADA'        THEN '📦 Alistamiento — la guía fue creada, el paquete aún no ha salido'
    WHEN 'EN_OFICINA'           THEN '🏭 Entrada de Regional — el paquete llegó a la bodega'
    WHEN 'EN_REPARTO'           THEN '🛵 Salida a Zona Urbana — el mensajero va hacia el cliente'
    WHEN 'ENTREGADO_AL_CLIENTE' THEN '✅ Entrega Verificada — el cliente ya recibió su pedido'
    WHEN 'DEVOLUCIONES'         THEN '🔄 Devolución — el paquete regresa al remitente'
    ELSE                             '❓ Estado desconocido'
  END;
  NEW.updated_at := NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Recrear trigger
DROP TRIGGER IF EXISTS trg_set_estado_legible ON public.cards;
CREATE TRIGGER trg_set_estado_legible
  BEFORE INSERT OR UPDATE OF columna
  ON public.cards
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_set_estado_legible();

-- 3. Refrescar todos los registros existentes
UPDATE public.cards
SET estado_legible = CASE columna
  WHEN 'GUIA_GENERADA'        THEN '📦 Alistamiento — la guía fue creada, el paquete aún no ha salido'
  WHEN 'EN_OFICINA'           THEN '🏭 Entrada de Regional — el paquete llegó a la bodega'
  WHEN 'EN_REPARTO'           THEN '🛵 Salida a Zona Urbana — el mensajero va hacia el cliente'
  WHEN 'ENTREGADO_AL_CLIENTE' THEN '✅ Entrega Verificada — el cliente ya recibió su pedido'
  WHEN 'DEVOLUCIONES'         THEN '🔄 Devolución — el paquete regresa al remitente'
  ELSE                             '❓ Estado desconocido'
END;
