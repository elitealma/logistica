'use client';

export const dynamic = 'force-dynamic';

import React, { useEffect, useState, useMemo, useCallback, useRef } from 'react';
import { supabase } from '@/lib/supabase';
import { Card, ColumnStatus, COLUMNS, Movimiento, COLUMN_STYLES, TRANSPORTADORAS } from '@/types';
import {
  Search,
  Phone,
  MessageSquare,
  Clock,
  X,
  Package,
  Truck,
  MapPin,
  User,
  CreditCard,
  DollarSign,
  Building2,
} from 'lucide-react';

/* ═══════════════════════════════════════════════════════
   Elite Logística — Kanban Dashboard
   Proyecto Transportadoras · Supabase Realtime
   ═══════════════════════════════════════════════════════ */

export default function KanbanDashboard() {
  const [cards, setCards] = useState<Card[]>([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [loading, setLoading] = useState(true);
  const [selectedCard, setSelectedCard] = useState<Card | null>(null);
  const [history, setHistory] = useState<Movimiento[]>([]);
  const [historyLoading, setHistoryLoading] = useState(false);
  const [dragOverColumn, setDragOverColumn] = useState<ColumnStatus | null>(null);
  const [filterColumn, setFilterColumn] = useState<ColumnStatus | null>(null);
  const [filterTransportadora, setFilterTransportadora] = useState<string>('');
  const dragCardId = useRef<string | null>(null);

  // ── Initial fetch ──────────────────────────────────
  useEffect(() => {
    fetchCards();
  }, []);

  // ── Realtime subscription ──────────────────────────
  useEffect(() => {
    const channel = supabase
      .channel('realtime-cards')
      .on(
        'postgres_changes' as any,
        { event: '*', schema: 'public', table: 'cards' },
        (payload: any) => {
          console.log('[Elite Logística] Realtime:', payload.eventType, payload);
          if (payload.eventType === 'INSERT') {
            setCards((prev) => [payload.new as Card, ...prev]);
          } else if (payload.eventType === 'UPDATE') {
            setCards((prev) =>
              prev.map((c) =>
                c.id === (payload.new as Card).id ? (payload.new as Card) : c
              )
            );
          } else if (payload.eventType === 'DELETE') {
            setCards((prev) =>
              prev.filter((c) => c.id !== (payload.old as any).id)
            );
          }
        }
      )
      .subscribe((status: string) => {
        console.log('[Elite Logística] Realtime status:', status);
      });

    return () => {
      supabase.removeChannel(channel);
    };
  }, []);

  const fetchCards = async () => {
    setLoading(true);
    const { data, error } = await supabase
      .from('cards')
      .select('*')
      .order('updated_at', { ascending: false });

    if (error) {
      console.error('[Elite Logística] Error fetching cards:', error);
    } else {
      setCards(data || []);
    }
    setLoading(false);
  };

  // ── Open card detail ───────────────────────────────
  const handleCardClick = useCallback(async (card: Card) => {
    setSelectedCard(card);
    setHistory([]);
    setHistoryLoading(true);

    const { data, error } = await supabase
      .from('movimientos')
      .select('*')
      .eq('card_id', card.id)
      .order('fecha', { ascending: false });

    if (!error) {
      setHistory((data as Movimiento[]) || []);
    }
    setHistoryLoading(false);
  }, []);

  // ── Drag & Drop: update column ─────────────────────
  const updateCardColumn = useCallback(
    async (cardId: string, newColumn: ColumnStatus) => {
      const oldCards = [...cards];

      // Optimistic update
      setCards((prev) =>
        prev.map((c) =>
          c.id === cardId
            ? { ...c, columna: newColumn, updated_at: new Date().toISOString() }
            : c
        )
      );

      const { error } = await supabase
        .from('cards')
        .update({
          columna: newColumn,
          updated_at: new Date().toISOString(),
        })
        .eq('id', cardId);

      if (error) {
        console.error('[Elite Logística] Error updating column:', error);
        setCards(oldCards);
        alert('Error al mover la tarjeta. Se revirtió el cambio.');
      }
    },
    [cards]
  );

  // ── Filters ────────────────────────────────────────
  const filteredCards = useMemo(() => {
    const term = searchTerm.toLowerCase();
    return cards.filter((card) => {
      const matchSearch =
        !term ||
        (card.numero_guia ?? '').toLowerCase().includes(term) ||
        (card.cliente_nombre ?? '').toLowerCase().includes(term);
      const matchColumn = !filterColumn || card.columna === filterColumn;
      const matchTransportadora =
        !filterTransportadora || card.transportadora === filterTransportadora;
      return matchSearch && matchColumn && matchTransportadora;
    });
  }, [cards, searchTerm, filterColumn, filterTransportadora]);

  const cardsByColumn = useMemo(() => {
    const acc = {} as Record<ColumnStatus, Card[]>;
    COLUMNS.forEach((col) => {
      acc[col.id] = filteredCards.filter((c) => c.columna === col.id);
    });
    return acc;
  }, [filteredCards]);

  const totalCards = cards.length;

  // ── List of unique transportadoras from existing data ──
  const uniqueTransportadoras = useMemo(() => {
    const fromCards = cards
      .map((c) => c.transportadora)
      .filter((t): t is string => !!t);
    const all = new Set([...TRANSPORTADORAS, ...fromCards]);
    return Array.from(all).sort();
  }, [cards]);

  // ── Helpers ────────────────────────────────────────
  const formatTime = (iso: string) => {
    try {
      return new Date(iso).toLocaleTimeString('es-CO', {
        hour: '2-digit',
        minute: '2-digit',
      });
    } catch {
      return '';
    }
  };

  const formatDateTime = (iso: string) => {
    try {
      return new Date(iso).toLocaleString('es-CO', {
        day: '2-digit',
        month: 'short',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
      });
    } catch {
      return '';
    }
  };

  const formatCurrency = (value: number | null | undefined) => {
    if (value == null) return '—';
    return new Intl.NumberFormat('es-CO', {
      style: 'currency',
      currency: 'COP',
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    }).format(value);
  };

  // ── Loading state ──────────────────────────────────
  if (loading) {
    return (
      <div className="loading">
        <div className="loading__spinner" />
        <div className="loading__text">Conectando con Elite Logística…</div>
      </div>
    );
  }

  // ── Render ─────────────────────────────────────────
  return (
    <div className="dashboard">
      {/* ── Header ──────────────────────────────── */}
      <header className="header">
        <div className="header__brand">
          <div className="header__logo">EL</div>
          <div>
            <div className="header__title">Elite Logística</div>
            <div className="header__subtitle">Transportadoras</div>
          </div>
        </div>

        <div className="header__center">
          <div className="search">
            <Search size={16} className="search__icon" />
            <input
              className="search__input"
              type="text"
              placeholder="Buscar por # guía o nombre de cliente…"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
          </div>
        </div>

        <div className="header__right">
          {/* Filtro Transportadora */}
          <div className="filter-select-wrapper">
            <Truck size={14} className="filter-select__icon" />
            <select
              className="filter-select"
              value={filterTransportadora}
              onChange={(e) => setFilterTransportadora(e.target.value)}
            >
              <option value="">Todas las Transportadoras</option>
              {uniqueTransportadoras.map((t) => (
                <option key={t} value={t}>
                  {t}
                </option>
              ))}
            </select>
          </div>

          <div className="live-badge">
            <span className="live-badge__dot" />
            En vivo
          </div>
        </div>
      </header>

      {/* ── Stats bar (column filter chips) ───── */}
      <div className="stats-bar">
        <button
          className={`stat-chip ${!filterColumn ? 'stat-chip--active' : ''}`}
          onClick={() => setFilterColumn(null)}
        >
          Todas <span className="stat-chip__count">{totalCards}</span>
        </button>
        {COLUMNS.map((col) => {
          const count = cards.filter((c) => c.columna === col.id).length;
          return (
            <button
              key={col.id}
              className={`stat-chip ${filterColumn === col.id ? 'stat-chip--active' : ''}`}
              onClick={() =>
                setFilterColumn(filterColumn === col.id ? null : col.id)
              }
            >
              {col.label} <span className="stat-chip__count">{count}</span>
            </button>
          );
        })}
      </div>

      {/* ── Kanban Board ────────────────────────── */}
      <main className="kanban">
        {COLUMNS.map((col) => {
          const style = COLUMN_STYLES[col.id];
          const colCards = cardsByColumn[col.id] || [];

          return (
            <div
              key={col.id}
              className={`column ${dragOverColumn === col.id ? 'column--drag-over' : ''}`}
              onDragOver={(e) => {
                e.preventDefault();
                setDragOverColumn(col.id);
              }}
              onDragLeave={() => setDragOverColumn(null)}
              onDrop={(e) => {
                e.preventDefault();
                setDragOverColumn(null);
                const cardId = dragCardId.current;
                if (cardId) {
                  updateCardColumn(cardId, col.id);
                  dragCardId.current = null;
                }
              }}
            >
              <div className="column__header">
                <div className="column__header-left">
                  <span className={`column__dot dot--${style.dotClass}`} />
                  <span className="column__name">{col.label}</span>
                </div>
                <span className="column__count">{colCards.length}</span>
              </div>

              <div className="column__cards">
                {colCards.length === 0 ? (
                  <div className="column__empty">Sin tarjetas</div>
                ) : (
                  colCards.map((card) => (
                    <div
                      key={card.id}
                      className="card"
                      draggable
                      onDragStart={() => {
                        dragCardId.current = card.id;
                      }}
                      onDragEnd={() => {
                        dragCardId.current = null;
                        setDragOverColumn(null);
                      }}
                      onClick={() => handleCardClick(card)}
                    >
                      <div className="card__guia">
                        <span className="card__guia-number">
                          {card.numero_guia}
                        </span>
                        <span className="card__time">
                          {formatTime(card.updated_at)}
                        </span>
                      </div>

                      <div className="card__client">
                        {card.cliente_nombre || 'Sin nombre'}
                      </div>

                      {card.transportadora && (
                        <div className="card__row card__transportadora">
                          <Truck size={13} />
                          <span>{card.transportadora}</span>
                        </div>
                      )}

                      {card.producto && (
                        <div className="card__row">
                          <Package size={13} />
                          <span className="card__message">{card.producto}</span>
                        </div>
                      )}

                      {(card.ciudad || card.departamento) && (
                        <div className="card__row">
                          <MapPin size={13} />
                          <span>
                            {[card.ciudad, card.departamento]
                              .filter(Boolean)
                              .join(', ')}
                          </span>
                        </div>
                      )}

                      {card.telefono && (
                        <div className="card__row">
                          <Phone size={13} />
                          <span>{card.telefono}</span>
                        </div>
                      )}

                      {card.mensaje && (
                        <div className="card__row">
                          <MessageSquare size={13} />
                          <span className="card__message">{card.mensaje}</span>
                        </div>
                      )}

                      <div className="card__footer">
                        <span
                          className={`card__badge badge--${style.dotClass}`}
                        >
                          {col.label}
                        </span>

                        {card.valor_total != null && card.valor_total > 0 && (
                          <span className="card__value">
                            {formatCurrency(card.valor_total)}
                          </span>
                        )}

                        {(card.porcentaje_entrega ?? 0) > 0 && (
                          <div className="card__progress">
                            <div
                              className="card__progress-fill"
                              style={{
                                width: `${card.porcentaje_entrega}%`,
                              }}
                            />
                          </div>
                        )}
                      </div>
                    </div>
                  ))
                )}
              </div>
            </div>
          );
        })}
      </main>

      {/* ── Drawer (Card Details) ───────────────── */}
      {selectedCard && (
        <>
          <div
            className="drawer-overlay"
            onClick={() => setSelectedCard(null)}
          />
          <aside className="drawer">
            <div className="drawer__header">
              <div className="drawer__title">
                Guía {selectedCard.numero_guia}
              </div>
              <button
                className="drawer__close"
                onClick={() => setSelectedCard(null)}
              >
                <X size={16} />
              </button>
            </div>

            <div className="drawer__body">
              {/* Info */}
              <div className="drawer__section">
                <div className="drawer__section-title">
                  Información de la guía
                </div>
                <div className="drawer__field">
                  <span className="drawer__label">Cliente</span>
                  <span className="drawer__value">
                    {selectedCard.cliente_nombre}
                  </span>
                </div>
                <div className="drawer__field">
                  <span className="drawer__label">Teléfono</span>
                  <span className="drawer__value">
                    {selectedCard.telefono || '—'}
                  </span>
                </div>
                <div className="drawer__field">
                  <span className="drawer__label">Estado</span>
                  <span className="drawer__value">
                    {selectedCard.columna}
                  </span>
                </div>
                <div className="drawer__field">
                  <span className="drawer__label">Transportadora</span>
                  <span className="drawer__value">
                    {selectedCard.transportadora || '—'}
                  </span>
                </div>
                <div className="drawer__field">
                  <span className="drawer__label">Producto</span>
                  <span className="drawer__value">
                    {selectedCard.producto || '—'}
                  </span>
                </div>
                <div className="drawer__field">
                  <span className="drawer__label">Medio de Pago</span>
                  <span className="drawer__value">
                    {selectedCard.medio_pago || '—'}
                  </span>
                </div>
                <div className="drawer__field">
                  <span className="drawer__label">Valor Total</span>
                  <span className="drawer__value">
                    {formatCurrency(selectedCard.valor_total)}
                  </span>
                </div>
                <div className="drawer__field">
                  <span className="drawer__label">Ciudad</span>
                  <span className="drawer__value">
                    {selectedCard.ciudad || '—'}
                  </span>
                </div>
                <div className="drawer__field">
                  <span className="drawer__label">Departamento</span>
                  <span className="drawer__value">
                    {selectedCard.departamento || '—'}
                  </span>
                </div>
                <div className="drawer__field">
                  <span className="drawer__label">Asignado a</span>
                  <span className="drawer__value">
                    {selectedCard.asignado_a || '—'}
                  </span>
                </div>
                <div className="drawer__field">
                  <span className="drawer__label">Pedidos</span>
                  <span className="drawer__value">
                    {selectedCard.pedidos_count ?? 1}
                  </span>
                </div>
                <div className="drawer__field">
                  <span className="drawer__label">Entrega</span>
                  <span className="drawer__value">
                    {selectedCard.porcentaje_entrega ?? 0}%
                  </span>
                </div>
                {selectedCard.mensaje && (
                  <div className="drawer__field" style={{ flexDirection: 'column', alignItems: 'flex-start', gap: '0.375rem' }}>
                    <span className="drawer__label">Mensaje</span>
                    <span className="drawer__value" style={{ textAlign: 'left', maxWidth: '100%' }}>
                      {selectedCard.mensaje}
                    </span>
                  </div>
                )}
              </div>

              {/* WhatsApp */}
              {selectedCard.telefono && (
                <div className="drawer__section">
                  <a
                    href={`https://wa.me/${selectedCard.telefono.replace(/\D/g, '')}`}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="whatsapp-btn"
                  >
                    <MessageSquare size={18} />
                    Contactar por WhatsApp
                  </a>
                </div>
              )}

              {/* History */}
              <div className="drawer__section">
                <div className="drawer__section-title">
                  Historial de movimientos
                </div>

                {historyLoading ? (
                  <div style={{ textAlign: 'center', padding: '1rem' }}>
                    <div className="loading__spinner" style={{ width: 24, height: 24, margin: '0 auto' }} />
                  </div>
                ) : history.length > 0 ? (
                  <div className="timeline">
                    {history.map((h) => (
                      <div key={h.id} className="timeline__item">
                        <div className="timeline__dot" />
                        <div className="timeline__date">
                          {formatDateTime(h.fecha)}
                        </div>
                        <div className="timeline__status">{h.estado}</div>
                        {h.detalle && (
                          <div className="timeline__detail">{h.detalle}</div>
                        )}
                        {h.ciudad && (
                          <div className="timeline__city">
                            <MapPin
                              size={11}
                              style={{
                                display: 'inline',
                                verticalAlign: 'middle',
                                marginRight: 4,
                              }}
                            />
                            {h.ciudad}
                          </div>
                        )}
                      </div>
                    ))}
                  </div>
                ) : (
                  <p
                    style={{
                      color: 'var(--text-muted)',
                      fontSize: '0.82rem',
                      padding: '0.5rem 0',
                    }}
                  >
                    No hay movimientos registrados.
                  </p>
                )}
              </div>
            </div>
          </aside>
        </>
      )}
    </div>
  );
}
