# Skill: Drizzle Patterns

Drizzle ORM conventions for this Next.js + Supabase + TypeScript project.

## Schema Structure

- One table per file: `db/schema/<table-name>.ts`
- Re-export all from `db/schema/index.ts`
- Always include `id` (uuid, `.defaultRandom()`), `createdAt`, `updatedAt` (timestamp, `withTimezone: true`)
- Prefer `text` over `varchar`; set `onDelete` on all foreign keys; add indexes for FK columns

## Relations

Use `relations()` from `drizzle-orm` for one-to-many and many-to-many. Always define both sides.

## Queries

- Use `db.query.<table>.findFirst/findMany` for relational queries with `with`
- Use `db.select/insert/update/delete` for explicit queries
- Use `sql` template tag only for window functions or CTEs

## Zod Derivation

Always use `createInsertSchema` / `createSelectSchema` from `drizzle-zod` — never write Zod schemas manually. Export TypeScript types from Zod schemas.

## Migrations

```bash
npx drizzle-kit generate   # generate migration from schema diff
npx drizzle-kit migrate    # apply migrations
```

Never edit generated migration files. Commit both schema and migrations. Run migrations in CI before deploy.

> For full API surface, see `reference.md`.
