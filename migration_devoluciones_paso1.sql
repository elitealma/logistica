-- ═══════════════════════════════════════════════════
-- PASO 1 de 2: Ejecutar PRIMERO y SOLO
-- Agregar 'DEVOLUCIONES' al enum kanban_columna
-- ═══════════════════════════════════════════════════
ALTER TYPE kanban_columna ADD VALUE IF NOT EXISTS 'DEVOLUCIONES';
