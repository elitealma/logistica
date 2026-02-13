-- ═══════════════════════════════════════════════════
-- Elite Logística — Datos de Prueba (Seed Data)
-- Proyecto Transportadoras
-- ═══════════════════════════════════════════════════

INSERT INTO public.cards (numero_guia, cliente_nombre, telefono, columna, mensaje, porcentaje_entrega, pedidos_count, asignado_a)
VALUES
  ('SRV-001234', 'María García López', '573001234567', 'GUIA_GENERADA', 'Paquete registrado en sistema', 0, 1, 'Carlos Pérez'),
  ('SRV-001235', 'Juan David Martínez', '573009876543', 'GUIA_GENERADA', 'Esperando recolección', 0, 2, 'Carlos Pérez'),
  ('SRV-001236', 'Andrea Rodríguez', '573005551234', 'EN_REPARTO', 'En camino a destino final', 60, 1, 'Luis Gómez'),
  ('SRV-001237', 'Pedro Sánchez Ruiz', '573007778899', 'EN_REPARTO', 'Motorizado en ruta — zona norte', 45, 3, 'Luis Gómez'),
  ('SRV-001238', 'Sofia Hernández', '573004443322', 'EN_REPARTO', 'Segunda entrega del día', 80, 1, 'Ana María Torres'),
  ('SRV-001239', 'Carlos Eduardo Díaz', '573006665544', 'EN_OFICINA', 'Disponible para recogida en oficina Cali', 100, 1, NULL),
  ('SRV-001240', 'Laura Mejía Castro', '573002223344', 'EN_OFICINA', 'Cliente notificado por SMS', 100, 2, NULL),
  ('SRV-001241', 'Diego Ramírez', '573008887766', 'HABLAR_CON_ASESOR', 'Cliente solicita cambio de dirección', 30, 1, 'Valentina Cruz'),
  ('SRV-001242', 'Camila Torres Vega', '573001112233', 'HABLAR_CON_ASESOR', 'Requiere información de entrega', 0, 1, 'Valentina Cruz'),
  ('SRV-001243', 'Fernando López B.', '573003334455', 'RETRASO_O_MOLESTIA', 'Retraso por clima adverso — Bogotá', 20, 1, 'Carlos Pérez'),
  ('SRV-001244', 'Isabella Moreno', '573005556677', 'RETRASO_O_MOLESTIA', 'Cliente reporta demora de 3 días', 10, 2, 'Luis Gómez'),
  ('SRV-001245', 'Andrés Felipe Ruiz', '573007778800', 'NOVEDADES', 'Dirección incorrecta — requiere actualización', 0, 1, 'Ana María Torres'),
  ('SRV-001246', 'Natalia Vargas P.', '573009990011', 'NOVEDADES', 'Paquete devuelto a origen', 0, 1, NULL),
  ('SRV-001247', 'Roberto Castillo', '573001234000', 'GARANTIAS', 'Producto llegó dañado — proceso de garantía', 0, 1, 'Valentina Cruz'),
  ('SRV-001248', 'Daniela Ospina', '573006543210', 'GARANTIAS', 'Solicitud de reemplazo aprobada', 50, 1, 'Carlos Pérez')
ON CONFLICT (numero_guia) DO NOTHING;

-- Movimientos de ejemplo para algunas tarjetas
INSERT INTO public.movimientos (card_id, fecha, estado, detalle, ciudad)
SELECT c.id, NOW() - interval '3 days', 'Guía generada', 'Paquete registrado en el sistema', 'Medellín'
FROM public.cards c WHERE c.numero_guia = 'SRV-001236';

INSERT INTO public.movimientos (card_id, fecha, estado, detalle, ciudad)
SELECT c.id, NOW() - interval '2 days', 'En bodega', 'Paquete recibido en centro de distribución', 'Medellín'
FROM public.cards c WHERE c.numero_guia = 'SRV-001236';

INSERT INTO public.movimientos (card_id, fecha, estado, detalle, ciudad)
SELECT c.id, NOW() - interval '1 day', 'En tránsito', 'Salida hacia ciudad destino', 'Bogotá'
FROM public.cards c WHERE c.numero_guia = 'SRV-001236';

INSERT INTO public.movimientos (card_id, fecha, estado, detalle, ciudad)
SELECT c.id, NOW() - interval '2 hours', 'En reparto', 'Motorizado asignado para entrega', 'Bogotá'
FROM public.cards c WHERE c.numero_guia = 'SRV-001236';

INSERT INTO public.movimientos (card_id, fecha, estado, detalle, ciudad)
SELECT c.id, NOW() - interval '5 days', 'Guía generada', 'Pedido registrado', 'Cali'
FROM public.cards c WHERE c.numero_guia = 'SRV-001243';

INSERT INTO public.movimientos (card_id, fecha, estado, detalle, ciudad)
SELECT c.id, NOW() - interval '4 days', 'En tránsito', 'Salida desde Cali', 'Cali'
FROM public.cards c WHERE c.numero_guia = 'SRV-001243';

INSERT INTO public.movimientos (card_id, fecha, estado, detalle, ciudad)
SELECT c.id, NOW() - interval '3 days', 'En oficina', 'Disponible en oficina Bogotá Norte', 'Bogotá'
FROM public.cards c WHERE c.numero_guia = 'SRV-001243';

INSERT INTO public.movimientos (card_id, fecha, estado, detalle, ciudad)
SELECT c.id, NOW() - interval '1 day', 'Hablar con asesor', 'Cliente requiere información adicional', 'Bogotá'
FROM public.cards c WHERE c.numero_guia = 'SRV-001243';

INSERT INTO public.movimientos (card_id, fecha, estado, detalle, ciudad)
SELECT c.id, NOW() - interval '2 days', 'Novedad', 'Producto recibido con daño visible', 'Barranquilla'
FROM public.cards c WHERE c.numero_guia = 'SRV-001247';

INSERT INTO public.movimientos (card_id, fecha, estado, detalle, ciudad)
SELECT c.id, NOW() - interval '1 day', 'Garantía', 'Proceso de garantía iniciado', 'Barranquilla'
FROM public.cards c WHERE c.numero_guia = 'SRV-001247';
