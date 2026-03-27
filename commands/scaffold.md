You are scaffolding files for a Next.js App Router project using Supabase SSR, Shadcn UI, and Drizzle ORM.

Parse `$ARGUMENTS` as `<type> <name>` (e.g. `page dashboard`, `api users`, `feature auth`).
Supported types: `page`, `api`, `feature` (alias: `module`).

If the type is not supported, respond:
> Unknown scaffold type. Usage: `/scaffold page <name>` | `/scaffold api <name>` | `/scaffold feature <name>`

Otherwise, use the Agent tool to invoke a `general-purpose` subagent with the following task:

---

Scaffold a **<type>** named **<name>** in the current working directory. Use the Write tool to create each file, then list all created paths.

Before writing, check if `lib/supabase/server.ts` exists — if so, import from it instead of inlining the client setup.

## Conventions
- Supabase server client: `createServerClient<Database>` from `@supabase/ssr`, typed with `Database` from `@/types/supabase`
- Route handlers and Server Actions: use full cookie read/write (`getAll` + `setAll`)
- RSC pages: read-only cookies (`getAll` only)
- Shadcn imports: `@/components/ui/*`
- PascalCase for component and function names, kebab-case for file names

## Files to create

### `page <name>` → `app/<name>/`
- `page.tsx` — async RSC; initialize Supabase SSR client; stub data fetch; render with Shadcn container
- `layout.tsx` — route layout with `Metadata` export
- `loading.tsx` — Suspense skeleton using Shadcn `<Skeleton>`
- `error.tsx` — `'use client'` error boundary with a reset button

### `api <name>` → `app/api/<name>/route.ts`
- GET and POST handlers; Supabase SSR client with full cookie handling; return `NextResponse.json`

### `feature <name>` (or `module`) → `features/<name>/`
- `types.ts` — Zod schema + inferred TypeScript type
- `actions/index.ts` — `'use server'`; Supabase SSR client; stub CRUD server actions
- `hooks/use-<name>.ts` — `'use client'`; useState + useEffect stub returning `{ data, loading }`
- `components/index.ts` — empty barrel file for Shadcn-based components
- `index.ts` — re-exports from types, actions, and hooks
