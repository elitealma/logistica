-- ═══════════════════════════════════════════════════
-- Elite Logística — Datos de Simulación Adicionales
-- Más clientes para todas las columnas del Kanban
-- Ejecutar en el SQL Editor de Supabase
-- ═══════════════════════════════════════════════════

INSERT INTO public.cards (numero_guia, cliente_nombre, telefono, columna, mensaje, porcentaje_entrega, pedidos_count, asignado_a)
VALUES
  -- GUIA GENERADA (4 más)
  ('SRV-002001', 'Valentina Restrepo M.', '573012345601', 'GUIA_GENERADA', 'Pedido recibido — esperando despacho', 0, 1, 'Carlos Pérez'),
  ('SRV-002002', 'Héctor Fabio Ríos', '573012345602', 'GUIA_GENERADA', 'Paquete empacado y etiquetado', 0, 3, 'Luis Gómez'),
  ('SRV-002003', 'Mariana Castaño V.', '573012345603', 'GUIA_GENERADA', 'Orden confirmada por el vendedor', 0, 1, 'Ana María Torres'),
  ('SRV-002004', 'Óscar Julián Parra', '573012345604', 'GUIA_GENERADA', 'Recogida programada para mañana', 0, 2, 'Valentina Cruz'),

  -- EN REPARTO (5 más)
  ('SRV-002005', 'Juliana Betancur', '573012345605', 'EN_REPARTO', 'Motorizado en camino — zona sur Medellín', 55, 1, 'Carlos Pérez'),
  ('SRV-002006', 'Ricardo Salazar O.', '573012345606', 'EN_REPARTO', 'En ruta — entrega estimada 2 horas', 70, 2, 'Luis Gómez'),
  ('SRV-002007', 'Claudia Milena Duque', '573012345607', 'EN_REPARTO', 'Segundo intento de entrega hoy', 40, 1, 'Ana María Torres'),
  ('SRV-002008', 'Esteban Arango L.', '573012345608', 'EN_REPARTO', 'Paquete en vehículo de reparto #12', 85, 1, 'Valentina Cruz'),
  ('SRV-002009', 'Liliana Cárdenas', '573012345609', 'EN_REPARTO', 'En tránsito Bogotá → Barranquilla', 30, 4, 'Carlos Pérez'),

  -- EN OFICINA (3 más)
  ('SRV-002010', 'Francisco Herrera M.', '573012345610', 'EN_OFICINA', 'Disponible en oficina Cra 7 Bogotá', 100, 1, NULL),
  ('SRV-002011', 'Gloria Inés Patiño', '573012345611', 'EN_OFICINA', 'Esperando recogida — notificado hace 2 días', 100, 2, NULL),
  ('SRV-002012', 'Sergio Andrés Villa', '573012345612', 'EN_OFICINA', 'Paquete en custodia — oficina Cali norte', 100, 1, 'Luis Gómez'),

  -- HABLAR CON ASESOR (3 más)
  ('SRV-002013', 'Alejandra Monsalve', '573012345613', 'HABLAR_CON_ASESOR', 'Quiere reprogramar fecha de entrega', 0, 1, 'Valentina Cruz'),
  ('SRV-002014', 'Gustavo Henao R.', '573012345614', 'HABLAR_CON_ASESOR', 'Pregunta por estado de su envío urgente', 0, 3, 'Ana María Torres'),
  ('SRV-002015', 'Paola Andrea Suárez', '573012345615', 'HABLAR_CON_ASESOR', 'Solicita factura y soporte de entrega', 0, 1, 'Carlos Pérez'),

  -- RETRASO O MOLESTIA (4 más)
  ('SRV-002016', 'Miguel Ángel Zapata', '573012345616', 'RETRASO_O_MOLESTIA', 'Sin actualización hace 5 días — escalado', 5, 1, 'Luis Gómez'),
  ('SRV-002017', 'Rosa Elena Gutiérrez', '573012345617', 'RETRASO_O_MOLESTIA', 'Retraso por cierre vial en Bucaramanga', 15, 2, 'Valentina Cruz'),
  ('SRV-002018', 'Jairo Humberto Castro', '573012345618', 'RETRASO_O_MOLESTIA', 'Cliente furioso — tercer retraso consecutivo', 10, 1, 'Carlos Pérez'),
  ('SRV-002019', 'Carolina Vélez A.', '573012345619', 'RETRASO_O_MOLESTIA', 'Paquete extraviado temporalmente en bodega', 0, 1, 'Ana María Torres'),

  -- NOVEDADES (3 más)
  ('SRV-002020', 'Fabián Andrés Ortiz', '573012345620', 'NOVEDADES', 'Dirección no existe — contactar al cliente', 0, 1, 'Luis Gómez'),
  ('SRV-002021', 'Sandra Milena Rojas', '573012345621', 'NOVEDADES', 'Paquete mojado por lluvias — evaluar daños', 0, 2, 'Carlos Pérez'),
  ('SRV-002022', 'Mauricio Lozano P.', '573012345622', 'NOVEDADES', 'Destinatario fallecido — pendiente resolución', 0, 1, 'Valentina Cruz'),

  -- GARANTÍAS (3 más)
  ('SRV-002023', 'Adriana Sepúlveda', '573012345623', 'GARANTIAS', 'Pantalla rota al recibir — fotos adjuntas', 0, 1, 'Ana María Torres'),
  ('SRV-002024', 'Jorge Iván Cardona', '573012345624', 'GARANTIAS', 'Producto no corresponde a lo solicitado', 0, 1, 'Luis Gómez'),
  ('SRV-002025', 'Ximena Giraldo F.', '573012345625', 'GARANTIAS', 'Garantía aprobada — esperando envío de reemplazo', 50, 1, 'Valentina Cruz'),

  -- DEVOLUCIONES (4 más)
  ('SRV-002026', 'Hernán Darío Muñoz', '573012345626', 'DEVOLUCIONES', 'No acepta paquete — pedido cancelado', 0, 1, 'Carlos Pérez'),
  ('SRV-002027', 'Bibiana Correa S.', '573012345627', 'DEVOLUCIONES', 'Devolución por cambio de talla solicitado', 0, 2, 'Ana María Torres'),
  ('SRV-002028', 'Camilo Ernesto Peña', '573012345628', 'DEVOLUCIONES', 'Cliente viajó — nadie recibe en dirección', 0, 1, 'Luis Gómez'),
  ('SRV-002029', 'Lucía Fernanda Gómez', '573012345629', 'DEVOLUCIONES', 'Producto defectuoso — devolver al proveedor', 0, 3, 'Valentina Cruz')
ON CONFLICT (numero_guia) DO NOTHING;

-- Movimientos de ejemplo para tarjetas nuevas
INSERT INTO public.movimientos (card_id, fecha, estado, detalle, ciudad)
SELECT c.id, NOW() - interval '4 days', 'Guía generada', 'Pedido registrado', 'Bogotá'
FROM public.cards c WHERE c.numero_guia = 'SRV-002005';

INSERT INTO public.movimientos (card_id, fecha, estado, detalle, ciudad)
SELECT c.id, NOW() - interval '3 days', 'En bodega', 'Recibido en centro de distribución', 'Bogotá'
FROM public.cards c WHERE c.numero_guia = 'SRV-002005';

INSERT INTO public.movimientos (card_id, fecha, estado, detalle, ciudad)
SELECT c.id, NOW() - interval '1 day', 'En tránsito', 'Salida hacia Medellín', 'Bogotá'
FROM public.cards c WHERE c.numero_guia = 'SRV-002005';

INSERT INTO public.movimientos (card_id, fecha, estado, detalle, ciudad)
SELECT c.id, NOW() - interval '3 hours', 'En reparto', 'Motorizado asignado zona sur', 'Medellín'
FROM public.cards c WHERE c.numero_guia = 'SRV-002005';

INSERT INTO public.movimientos (card_id, fecha, estado, detalle, ciudad)
SELECT c.id, NOW() - interval '6 days', 'Guía generada', 'Orden confirmada', 'Cali'
FROM public.cards c WHERE c.numero_guia = 'SRV-002016';

INSERT INTO public.movimientos (card_id, fecha, estado, detalle, ciudad)
SELECT c.id, NOW() - interval '5 days', 'En tránsito', 'Salida de Cali', 'Cali'
FROM public.cards c WHERE c.numero_guia = 'SRV-002016';

INSERT INTO public.movimientos (card_id, fecha, estado, detalle, ciudad)
SELECT c.id, NOW() - interval '3 days', 'Novedad', 'Retraso por congestión en terminal', 'Bucaramanga'
FROM public.cards c WHERE c.numero_guia = 'SRV-002016';

INSERT INTO public.movimientos (card_id, fecha, estado, detalle, ciudad)
SELECT c.id, NOW() - interval '1 day', 'Escalado', 'Sin respuesta del transportista local', 'Bucaramanga'
FROM public.cards c WHERE c.numero_guia = 'SRV-002016';

-- Devoluciones detalle
INSERT INTO public.devoluciones (card_id, motivo, estado_devolucion, direccion_retorno, observaciones)
SELECT c.id, 'Pedido cancelado por cliente', 'PENDIENTE', 'Cra 15 #45-20, Bogotá', 'Cliente canceló antes de recibir'
FROM public.cards c WHERE c.numero_guia = 'SRV-002026';

INSERT INTO public.devoluciones (card_id, motivo, estado_devolucion, direccion_retorno, observaciones)
SELECT c.id, 'Cambio de talla', 'EN_PROCESO', 'Cl 50 #30-15, Medellín', 'Talla M cambiar por L'
FROM public.cards c WHERE c.numero_guia = 'SRV-002027';

INSERT INTO public.devoluciones (card_id, motivo, estado_devolucion, direccion_retorno, observaciones)
SELECT c.id, 'Nadie recibe', 'PENDIENTE', 'Av 68 #12-40, Bogotá', 'Tres intentos fallidos'
FROM public.cards c WHERE c.numero_guia = 'SRV-002028';

INSERT INTO public.devoluciones (card_id, motivo, estado_devolucion, direccion_retorno, observaciones)
SELECT c.id, 'Producto defectuoso', 'COMPLETADA', 'Cra 7 #70-10, Cali', 'Devuelto al proveedor exitosamente'
FROM public.cards c WHERE c.numero_guia = 'SRV-002029';
