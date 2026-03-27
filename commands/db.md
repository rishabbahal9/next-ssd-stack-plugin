You are the Drizzle ORM command center for a Next.js App Router project using Supabase, Drizzle ORM, and TypeScript.

Parse `$ARGUMENTS` as `<subcommand> [table]` (e.g. `schema users`, `migrate`, `seed posts`, `diff`).
Supported subcommands: `schema`, `migrate`, `seed`, `diff`.

If the subcommand is not supported, respond:
> Unknown subcommand. Usage: `/db schema <table>` | `/db migrate` | `/db seed <table>` | `/db diff`

Otherwise, use the Agent tool to invoke a `general-purpose` subagent with the appropriate task below:

---

## `schema <table>`

Generate a Drizzle ORM table schema for **<table>** in the current working directory.

1. Check for an existing schema directory (`db/schema/` or `drizzle/schema/`) — use whichever exists.
2. Read any existing schema files to infer naming conventions, column patterns, and shared types (e.g. `id`, `createdAt`, `updatedAt`).
3. Create `db/schema/<table>.ts` (or `drizzle/schema/<table>.ts`) with:
   - `pgTable` definition using `drizzle-orm/pg-core`
   - Typed columns: `uuid` for IDs, `text`/`varchar` for strings, `timestamp` with `defaultNow()` for timestamps
   - A `$inferSelect` and `$inferInsert` export for type inference
   - Index hints for foreign keys and frequently queried columns
4. If other schema files export from a barrel `index.ts`, add the new export there.
5. List all created/modified files.

## Conventions
- Use `pgTable` from `drizzle-orm/pg-core`
- ID column: `id: uuid('id').primaryKey().defaultRandom()`
- Timestamps: `createdAt: timestamp('created_at').defaultNow().notNull()`
- Export types: `export type <Table> = typeof <table>.$inferSelect`

---

## `migrate`

Run Drizzle migrations in the current working directory.

1. Run `npx drizzle-kit generate` via the Bash tool and capture output.
2. If generation succeeds, run `npx drizzle-kit migrate` and capture output.
3. Report the full output of both commands.
4. If either command fails, show the error and suggest likely fixes (missing `drizzle.config.ts`, wrong `out` path, unapplied schema changes).

---

## `seed <table>`

Generate typed seed data for **<table>**.

1. Locate the schema for `<table>` in `db/schema/<table>.ts` or `drizzle/schema/<table>.ts`. Read it to extract column names and types.
2. Create `db/seed/<table>.ts` with:
   - An array of 5–10 typed seed records using `$inferInsert` from the schema
   - A `seed()` async function that uses Drizzle's `db.insert(<table>).values(seedData)` with `.onConflictDoNothing()`
   - A `main()` entry point that calls `seed()` and logs results
3. If a `db/seed/index.ts` exists, import and call the new seed function there.
4. List all created/modified files.

## Conventions
- Import `db` from `@/lib/db` or the existing db client path
- Use realistic placeholder data (no lorem ipsum for names/emails)

---

## `diff`

Show pending Drizzle schema changes.

1. Run `npx drizzle-kit diff` via the Bash tool if available, and report its output.
2. If `drizzle-kit diff` is not available, inspect the `drizzle/` or `db/migrations/` folder:
   - List all migration files sorted by name
   - Read the most recent migration file and display its contents
3. Compare migration file timestamps against the schema files' last-modified times to identify schemas that have changed since the last migration.
4. Summarize: which tables have pending changes, which are up-to-date.
