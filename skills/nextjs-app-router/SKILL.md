# Skill: Next.js App Router

App Router conventions for this Next.js + Supabase + TypeScript project.

## File-Based Routing

- Pages: `app/<route>/page.tsx` — default export, server component by default
- Layouts: `app/<route>/layout.tsx` — wrap shared UI; persist across navigations
- Templates: `app/<route>/template.tsx` — re-mount on navigation (use for animations or reset state)
- Loading: `app/<route>/loading.tsx` — automatic Suspense boundary
- Error: `app/<route>/error.tsx` — must be `"use client"`; catches errors in subtree
- Not Found: `app/<route>/not-found.tsx` — rendered by `notFound()` from `next/navigation`

## Server vs. Client Components

Default to **Server Components**. Add `"use client"` only when you need:
- `useState`, `useEffect`, `useReducer`, or other React hooks
- Browser APIs (`window`, `localStorage`, etc.)
- Event handlers (`onClick`, `onChange`, etc.)
- Third-party client-only libraries

Push `"use client"` as far down the tree as possible.

## Data Fetching

- Fetch in Server Components with `async/await` — no `useEffect` for server data
- Use `cache()` from React or Next.js `unstable_cache` for deduplication
- Colocate data fetching with the component that needs it

## Server Actions vs. Route Handlers

| Use | When |
|-----|------|
| Server Actions | Form submissions, mutations called from React components |
| Route Handlers (`app/api/.../route.ts`) | Webhooks, external API consumers, non-React clients |

Define Server Actions in `actions/` or inline with `"use server"` directive.

## Metadata

Use `generateMetadata` (async, for dynamic) or `export const metadata` (static) in `page.tsx` or `layout.tsx`. Never set `<title>` or `<meta>` tags manually in JSX.

## Middleware

Put auth session refresh and route protection in `middleware.ts` at the project root. Keep it lightweight — no DB queries.

> For full API surface, see `reference.md`.
