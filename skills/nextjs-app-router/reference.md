# Next.js App Router API Reference

Stable API surface for Next.js 14+. Use this to avoid hallucinating renamed or removed APIs.

---

## Special Files

| File | Purpose |
|------|---------|
| `layout.tsx` | Shared UI wrapper; persists state across navigations |
| `page.tsx` | Unique UI for a route; makes route publicly accessible |
| `loading.tsx` | Automatic Suspense fallback |
| `error.tsx` | Error boundary (`"use client"` required) |
| `not-found.tsx` | Rendered by `notFound()` |
| `route.ts` | API endpoint (no page UI) |
| `template.tsx` | Like layout but remounts on navigation |
| `middleware.ts` | Runs before requests; project root only |

---

## Navigation (`next/navigation`)

```ts
import { useRouter, usePathname, useSearchParams, redirect, notFound } from "next/navigation";

// Server Components
redirect("/login");           // hard redirect (throws)
notFound();                   // render not-found.tsx (throws)

// Client Components
const router = useRouter();
router.push("/path");
router.replace("/path");
router.back();
router.refresh();             // re-fetch server data without full reload

const pathname = usePathname();          // "/dashboard/settings"
const searchParams = useSearchParams();  // URLSearchParams
```

---

## Metadata

```ts
// Static — layout.tsx or page.tsx
export const metadata: Metadata = {
  title: "Page Title",
  description: "...",
  openGraph: { title: "...", description: "..." },
};

// Dynamic — page.tsx only
export async function generateMetadata(
  { params }: { params: { id: string } }
): Promise<Metadata> {
  const data = await fetchData(params.id);
  return { title: data.name };
}
```

---

## Server Actions

```ts
// Inline in Server Component
async function create(formData: FormData) {
  "use server";
  const name = formData.get("name") as string;
  await db.insert(items).values({ name });
  revalidatePath("/items");
}

// Dedicated file: actions/items.ts
"use server";
export async function deleteItem(id: string) {
  await db.delete(items).where(eq(items.id, id));
  revalidatePath("/items");
}
```

---

## Route Handlers (`app/api/.../route.ts`)

```ts
import { NextRequest, NextResponse } from "next/server";

export async function GET(req: NextRequest) {
  return NextResponse.json({ data: [] });
}

export async function POST(req: NextRequest) {
  const body = await req.json();
  return NextResponse.json({ ok: true }, { status: 201 });
}
```

---

## Caching & Revalidation

```ts
import { revalidatePath, revalidateTag } from "next/cache";
import { unstable_cache } from "next/cache";

// Revalidate after mutation
revalidatePath("/items");
revalidateTag("items");

// Cached server function
const getItems = unstable_cache(
  async () => db.query.items.findMany(),
  ["items"],
  { revalidate: 60, tags: ["items"] }
);
```

---

## Dynamic Routes

| Pattern | File | `params` shape |
|---------|------|----------------|
| `/post/123` | `app/post/[id]/page.tsx` | `{ id: "123" }` |
| `/a/b/c` | `app/[...slug]/page.tsx` | `{ slug: ["a","b","c"] }` |
| `/` or `/a/b` | `app/[[...slug]]/page.tsx` | `{}` or `{ slug: [...] }` |

```ts
// Generate static params at build time
export async function generateStaticParams() {
  const posts = await db.query.posts.findMany();
  return posts.map((p) => ({ id: p.id }));
}
```

---

## Parallel & Intercepting Routes

```
app/
  @modal/         # parallel slot — rendered alongside page
  (.)photo/[id]/  # intercept same-level route
  (..)photo/[id]/ # intercept one level up
```

Pass slots as props in `layout.tsx`: `{ children, modal }`.

---

## `next/image` & `next/link`

```tsx
import Image from "next/image";
import Link from "next/link";

<Image src="/hero.png" alt="Hero" width={800} height={400} priority />
<Link href="/about" prefetch={false}>About</Link>
```

---

## Middleware (`middleware.ts`)

```ts
import { NextRequest, NextResponse } from "next/server";

export function middleware(req: NextRequest) {
  const token = req.cookies.get("sb-token");
  if (!token) return NextResponse.redirect(new URL("/login", req.url));
  return NextResponse.next();
}

export const config = {
  matcher: ["/dashboard/:path*"],
};
```
