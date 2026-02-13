# Elite Logística — Dashboard Kanban

Dashboard de logística en tiempo real tipo Kanban para seguimiento de guías y entregas.  
**Proyecto Transportadoras** · Supabase Realtime · Next.js · Docker.

---

## 🚀 Características

- **Kanban en tiempo real** — sincronización automática con Supabase Realtime (Postgres Changes).
- **Drag & Drop** — arrastra tarjetas entre columnas para cambiar su estado; se actualiza en Supabase y se refleja en todos los clientes.
- **7 columnas operativas** — Guía Generada, En Reparto, En Oficina, Hablar con Asesor, Retraso o Molestia, Novedades, Garantías.
- **Panel lateral de detalle** — click en una tarjeta para ver datos completos y timeline de movimientos.
- **WhatsApp** — botón directo `wa.me` con el teléfono del cliente.
- **Buscador global** — filtra por número de guía o nombre de cliente.
- **Filtro por columna** — chips de filtro rápido en la barra superior.
- **UI premium oscura** — diseño operacional con tema oscuro, glassmorphism y animaciones.
- **Dockerizado** — imagen liviana con Next.js standalone, lista para Portainer.

---

## 📦 Requisitos previos

1. Un proyecto en [Supabase](https://supabase.com/) (el proyecto **Transportadoras**).
2. Ejecutar el script [`schema.sql`](./schema.sql) en el **SQL Editor** de Supabase para crear las tablas.
3. En el dashboard de Supabase, asegurarse de que **Realtime** está habilitado para la tabla `cards`.

---

## 🗄️ Base de datos

Ejecuta `schema.sql` en tu SQL Editor de Supabase. Esto crea:

| Tabla | Descripción |
|---|---|
| `public.cards` | Tarjetas de guía con estado, teléfono, mensaje, etc. |
| `public.movimientos` | Historial de eventos por guía (FK a `cards.id`). |

El script también:
- Habilita Realtime en la tabla `cards`.
- Configura RLS con políticas abiertas (MVP).
- Crea índices para rendimiento.

---

## ⚙️ Variables de entorno

Copia `.env.example` a `.env` y completa con tus credenciales:

```bash
cp .env.example .env
```

| Variable | Descripción |
|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | URL del proyecto Supabase |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Clave pública (anon) de Supabase |

---

## 💻 Desarrollo local

```bash
npm install
npm run dev
```

Abre [http://localhost:3000](http://localhost:3000).

---

## 🐳 Docker

### Build & Run

```bash
docker compose up -d --build
```

La app estará disponible en `http://localhost:3000`.

### Solo build de imagen

```bash
docker build -t elite-logistica .
docker run -p 3000:3000 \
  -e NEXT_PUBLIC_SUPABASE_URL=tu-url \
  -e NEXT_PUBLIC_SUPABASE_ANON_KEY=tu-key \
  elite-logistica
```

---

## 🚢 Deploy en Portainer (Stack from Git)

1. En Portainer → **Stacks** → **Add Stack**.
2. Selecciona **Repository** como Build method.
3. Pega la URL del repositorio: `https://github.com/elitealma/logistica.git`
4. Branch: `main`
5. Compose path: `docker-compose.yml` (valor por defecto).
6. En **Environment variables**, agrega:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
7. Click en **Deploy the stack**.

> **Nota**: Portainer clona el repo y usa el `docker-compose.yml` + `Dockerfile` incluidos. Para actualizar, edita el código en el repo y redeploy. No uses submodules.

---

## 🔒 Seguridad (MVP)

Este MVP usa la **anon key** de Supabase para lectura y escritura. Para producción se recomienda:
- Habilitar **Row Level Security (RLS)** con políticas restrictivas.
- Agregar **autenticación** via Supabase Auth.
- Usar **service_role key** solo en el servidor.

---

## 📁 Estructura del proyecto

```
├── src/
│   ├── app/
│   │   ├── globals.css      # Design system
│   │   ├── layout.tsx        # Root layout
│   │   └── page.tsx          # Dashboard Kanban
│   ├── lib/
│   │   └── supabase.ts       # Cliente Supabase
│   └── types/
│       └── index.ts           # Tipos TypeScript
├── schema.sql                 # DDL para Supabase
├── Dockerfile                 # Multi-stage build
├── docker-compose.yml         # Compose para Portainer
├── .env.example               # Template de variables
└── README.md
```

---

Hecho con ❤️ por **Elite Alma IA**.
