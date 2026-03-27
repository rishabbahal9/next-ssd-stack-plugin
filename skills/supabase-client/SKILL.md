# Skill: Supabase Client

Supabase client setup conventions for this Next.js + TypeScript project.

## Client Types

Three distinct clients — use the right one per context:

| Context | Client | File |
|---------|--------|------|
| Browser / Client Components | `createBrowserClient` | `lib/supabase/client.ts` |
| Server Components / Actions | `createServerClient` | `lib/supabase/server.ts` |
| Admin / bypass RLS | `createClient` (service role) | `lib/supabase/admin.ts` |

## Browser Client

Use in `"use client"` components. Call once per component, not at module level.

```ts
import { createBrowserClient } from "@supabase/ssr";

export const createClient = () =>
  createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );
```

## Server Client

Use in Server Components, Route Handlers, and Server Actions. Requires cookie access.

```ts
import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";

export const createClient = async () => {
  const cookieStore = await cookies();
  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    { cookies: { getAll: () => cookieStore.getAll(),
                  setAll: (pairs) => pairs.forEach(({ name, value, options }) =>
                    cookieStore.set(name, value, options)) } }
  );
};
```

## Middleware (Auth Refresh)

Always refresh the session in `middleware.ts` to keep auth tokens valid.

```ts
import { updateSession } from "@/lib/supabase/middleware";
export async function middleware(request: NextRequest) {
  return await updateSession(request);
}
```

## Admin Client

Only in server-side code. Never expose service role key to the browser.

```ts
import { createClient } from "@supabase/supabase-js";

export const adminClient = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
);
```

> For full API patterns, see `reference.md`.
