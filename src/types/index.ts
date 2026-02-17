export type ColumnStatus =
    | 'GUIA_GENERADA'
    | 'EN_REPARTO'
    | 'EN_OFICINA'
    | 'HABLAR_CON_ASESOR'
    | 'RETRASO_O_MOLESTIA'
    | 'NOVEDADES'
    | 'GARANTIAS'
    | 'DEVOLUCIONES';

export interface Card {
    id: string;
    numero_guia: string;
    cliente_nombre: string;
    telefono: string;
    columna: ColumnStatus;
    mensaje: string;
    porcentaje_entrega: number;
    pedidos_count: number;
    asignado_a: string;
    transportadora: string;
    producto: string;
    medio_pago: string;
    valor_total: number;
    ciudad: string;
    departamento: string;
    updated_at: string;
    created_at?: string;
}

/** Transportadoras disponibles */
export const TRANSPORTADORAS = [
    'Servientrega',
    'Coordinadora',
    'Interrapidisimo',
    'Envia',
    'TCC',
    'Deprisa',
    'Saferbo',
] as const;

export interface Movimiento {
    id: string;
    card_id: string;
    fecha: string;
    estado: string;
    detalle: string;
    ciudad: string;
    raw?: Record<string, unknown>;
}

export interface Devolucion {
    id: string;
    card_id: string;
    motivo: string;
    estado_devolucion: string;
    direccion_retorno: string;
    observaciones: string;
    fecha_solicitud: string;
    fecha_devolucion: string | null;
    created_at: string;
}

export const COLUMNS: { id: ColumnStatus; label: string }[] = [
    { id: 'GUIA_GENERADA', label: 'Guía Generada' },
    { id: 'EN_REPARTO', label: 'En Reparto' },
    { id: 'EN_OFICINA', label: 'En Oficina' },
    { id: 'HABLAR_CON_ASESOR', label: 'Hablar con Asesor' },
    { id: 'RETRASO_O_MOLESTIA', label: 'Retraso o Molestia' },
    { id: 'NOVEDADES', label: 'Novedades' },
    { id: 'GARANTIAS', label: 'Garantías' },
    { id: 'DEVOLUCIONES', label: 'Devoluciones' },
];

/** CSS class suffix for each column (dot colors & badges) */
export const COLUMN_STYLES: Record<ColumnStatus, { dotClass: string }> = {
    GUIA_GENERADA: { dotClass: 'guia' },
    EN_REPARTO: { dotClass: 'reparto' },
    EN_OFICINA: { dotClass: 'oficina' },
    HABLAR_CON_ASESOR: { dotClass: 'asesor' },
    RETRASO_O_MOLESTIA: { dotClass: 'retraso' },
    NOVEDADES: { dotClass: 'novedades' },
    GARANTIAS: { dotClass: 'garantias' },
    DEVOLUCIONES: { dotClass: 'devoluciones' },
};
