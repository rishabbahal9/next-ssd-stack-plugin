# next-ssd-stack

A Claude plugin for Next.js, Supabase, Shadcn UI, and Drizzle (SSD stack) web apps.

**Author:** [Rishab Bahal](https://github.com/rishabbahal9) · **Version:** 0.0.0 · **License:** MIT

---

## Overview

next-ssd-stack is a Claude plugin that brings slash commands, specialized subagents, skills, hooks, and MCP server configuration into a single installable unit for Next.js App Router projects using Supabase SSR auth, Drizzle ORM for database access, and Shadcn UI for components.

It removes repetitive scaffolding, enforces project conventions automatically, and surfaces the right agent for each task — schema design, RLS policy generation, UI composition, API route generation — without switching context.

---

## Tech Stack

- **Next.js** — App Router, React Server Components, server actions, route handlers
- **Supabase** — auth via `@supabase/ssr`, PostgreSQL, Row Level Security
- **Shadcn UI + Tailwind CSS** — component library, design tokens, CSS variables
- **Drizzle ORM** — schema definitions, migrations, type inference, Zod derivation

---

## Installation

**Prerequisites:** Claude Code CLI installed; target project is a Next.js + Supabase + Drizzle app.

### Via Marketplace (Recommended)

Install directly from the [tech-stack-claude-plugin-marketplace](https://github.com/rishabbahal9/tech-stack-claude-plugin-marketplace):

1. Add the marketplace:
   ```sh
   /plugin marketplace add rishabbahal9/tech-stack-claude-plugin-marketplace
   ```

2. Install the plugin:
   ```sh
   /plugin install next-ssd-stack@tech-stack-claude-plugin-marketplace
   ```

3. To update the plugin later:
   ```sh
   /plugin marketplace update tech-stack-claude-plugin-marketplace
   ```

### Manual Installation

1. Copy the `next-ssd-stack/` directory into your project root.
2. Claude Code automatically detects `.claude-plugin/plugin.json` when started in that directory.
3. Slash commands and agents are immediately available.

No package installation required. The plugin itself has no external dependencies. MCP servers are fetched on first use via `npx` and require Node.js to be available.

---

## Plugin Directory Structure

```
next-ssd-stack/
├── .claude-plugin/
│   └── plugin.json             # Plugin metadata
├── .mcp.json                   # MCP server config (Supabase + Context7)
├── agents/
│   ├── schema-architect.md
│   ├── rls-writer.md
│   ├── ui-composer.md
│   ├── api-builder.md
│   └── migration-reviewer.md   # planned
├── skills/
│   ├── drizzle-patterns/       # SKILL.md + reference.md
│   ├── supabase-client/        # SKILL.md + reference.md
│   ├── nextjs-app-router/      # SKILL.md + reference.md
│   └── shadcn-tailwind/        # SKILL.md + reference.md + scripts/
├── commands/
│   ├── scaffold.md
│   ├── db.md
│   ├── ui.md
│   ├── rls.md
│   ├── typecheck.md
│   └── deploy-check.md         # planned
├── hooks/
│   ├── enforce-drizzle.sh
│   ├── auto-format.sh
│   ├── schema-validate.sh
│   ├── protect-generated.sh
│   └── env-guard.sh
└── README.md
```

---

## Slash Commands

### /scaffold

Scaffolds pages, API routes, and feature modules following App Router conventions with Supabase SSR and Shadcn UI wiring.

```sh
/scaffold <type> <name>
# type: page | api | feature (alias: module)
```

| Type | Creates |
|------|---------|
| `page` | `app/<name>/page.tsx`, `layout.tsx`, `loading.tsx`, `error.tsx` |
| `api` | `app/api/<name>/route.ts` with typed GET/POST handlers |
| `feature` | `features/<name>/` with `types.ts`, `actions/`, `hooks/`, `components/`, `index.ts` |

**Examples:** `/scaffold page dashboard` · `/scaffold api users` · `/scaffold feature auth`

---

### /db

Drizzle ORM command center for schema generation, migrations, seeding, and diff inspection.

```sh
/db <subcommand> [table]
```

| Subcommand | What it does |
|-----------|--------------|
| `schema <table>` | Generates `pgTable` definition with columns, Zod schemas, and barrel export |
| `migrate` | Runs `drizzle-kit generate` then `drizzle-kit migrate` |
| `seed <table>` | Generates typed seed data with 5–10 realistic records |
| `diff` | Shows pending schema changes vs. applied migrations |

**Examples:** `/db schema posts` · `/db migrate` · `/db seed users` · `/db diff`

---

### /ui

Scaffolds Shadcn UI components — forms with Zod validation, data tables with pagination, and confirmation dialogs.

```sh
/ui <type> <name>
# type: form | table | dialog
```

| Type | Creates |
|------|---------|
| `form` | `components/<name>/index.tsx` + `schema.ts` with react-hook-form and Zod |
| `table` | `index.tsx` + `columns.tsx` with `@tanstack/react-table`, sorting, pagination |
| `dialog` | Single `index.tsx` with Shadcn Dialog, confirm/cancel actions |

**Examples:** `/ui form signup` · `/ui table users` · `/ui dialog confirm-delete`

---

### /rls

Generates Supabase Row Level Security policies by reading the Drizzle schema for the named table.

```sh
/rls <table>
```

Creates `supabase/migrations/<timestamp>_rls_<table>.sql` with own-data CRUD policies, admin service-role bypass, and optional public-read. Also writes a reference doc at `supabase/rls/<table>.md`.

**Example:** `/rls posts`

---

### /typecheck

Runs TypeScript, Drizzle type inference, and ESLint checks in a single pass with cross-referenced error reporting.

```sh
/typecheck
```

Outputs a structured PASS/FAIL summary for each check, errors grouped by file, with suggested fixes.

---

### /deploy-check (planned)

Pre-deployment checklist covering type checking, `console.log` detection, environment variable validation, migration status, and RLS coverage. Not yet implemented.

---

## Agents

### schema-architect

**When to use:** Creating or extending a Drizzle ORM schema from a plain-English data model description.

**Capabilities:**
- Generates `pgTable` definitions with `uuid` PKs, timestamps, and constraints
- Defines `relations()` for one-to-one and one-to-many associations
- Creates `pgEnum` for enumerated columns
- Derives `insertSchema`/`selectSchema` Zod types; maintains naming consistency across `db/schema/`

**Note:** `Bash` tool is disallowed — designs schemas but does not run commands.

**Invoked by:** `/db schema <table>` or directly.

---

### rls-writer

**When to use:** Generating or updating Supabase RLS policies to match a Drizzle schema.

**Capabilities:**
- Reads schema files to identify ownership columns
- Generates SQL for authenticated-only, owner-based, role-based (JWT claims), and public-read patterns
- Writes migration-ready SQL with explanatory comments per policy
- Verifies no table is left with open access by default

**Invoked by:** `/rls <table>` or directly.

---

### ui-composer

**When to use:** Building composed UI components, pages, or layouts with the project's installed Shadcn components.

**Capabilities:**
- Reads `components.json` to confirm installed components before use
- Applies CSS variable theming and Tailwind v4 conventions
- Enforces RSC boundaries — defaults to Server Components, adds `"use client"` only where required
- Produces accessible, responsive layouts using `cn()` utility and named exports

**Invoked by:** `/ui <type> <name>` or directly.

---

### api-builder

**When to use:** Generating typed `route.ts` files or deciding between route handlers and server actions.

**Capabilities:**
- Generates route handlers with `createServerClient` cookie setup
- Validates request input with Zod before processing
- Integrates Drizzle queries with consistent auth guard (`supabase.auth.getUser()`)
- Applies standard error handling and HTTP status conventions; never exposes stack traces

**Invoked by:** `/scaffold api <name>` or directly.

---

### migration-reviewer (planned)

Read-only agent (Write, Edit, and Bash disallowed) that cross-references generated SQL against the existing schema to flag destructive changes before any migration runs. Returns pass / warn / block. Not yet implemented.

---

## Skills

Skills are markdown knowledge bases loaded by Claude for domain-specific context. Each skill has a `SKILL.md` (conventions) and `reference.md` (API surface).

| Skill | Purpose |
|-------|---------|
| `drizzle-patterns` | Project Drizzle conventions: column helpers, relation patterns, migration workflow, Zod derivation |
| `supabase-client` | Three client contexts (browser, server SSR, admin); middleware auth refresh; Storage and Realtime patterns |
| `nextjs-app-router` | App Router conventions, RSC vs client decision tree, server actions vs route handlers, metadata, parallel routes |
| `shadcn-tailwind` | Installed Shadcn component inventory, custom compositions, Tailwind theme extensions, dark mode approach |

---

## Hooks

Hooks fire at lifecycle events deterministically, without LLM judgment.

| Hook | Event | What it does |
|------|-------|-------------|
| `enforce-drizzle` | PreToolUse: Write/Edit | Blocks raw SQL (`db.execute`) in application code outside migration files |
| `auto-format` | PostToolUse: Write/Edit | Runs Prettier on `.ts`, `.tsx`, `.css` files after every write |
| `schema-validate` | PostToolUse: Write/Edit in `db/schema/` | Runs `drizzle-kit check` immediately after schema changes |
| `protect-generated` | PreToolUse: Write/Edit | Blocks writes to `drizzle/meta/`, `node_modules/`, `.next/` |
| `env-guard` | PreToolUse: Bash | Blocks commands that would expose env vars (e.g., `cat .env`) |

---

## MCP Servers

Configured via `.mcp.json` in the plugin root. Two servers are bundled.

### Supabase MCP

Connects Claude to your live Supabase project for schema inspection, RLS-aware queries, auth configuration checks, and storage management.

**Setup:** Export your Supabase personal access token (not the anon key) before starting Claude Code:

```sh
export SUPABASE_ACCESS_TOKEN=your_token_here
```

To scope to a specific project, add `--project-ref <ref>` to the args in `.mcp.json`.

Runs in `--read-only` mode by default — Claude cannot execute destructive database operations.

### Context7

Live documentation lookup for Drizzle, Shadcn, and Next.js APIs. Prevents stale training-data answers for fast-moving libraries. No setup required.

---

## Conventions

- Supabase server client always uses `createServerClient` from `@supabase/ssr` with full `getAll`/`setAll` cookie handling in route handlers and server actions; read-only `getAll` in RSC pages
- All Shadcn component imports use the `@/components/ui/*` path alias
- PascalCase for component and function names; kebab-case for file names
- Drizzle schemas: `uuid` PKs with `.defaultRandom()`, `createdAt`/`updatedAt` on every table, `$inferSelect`/`$inferInsert` exports required
- No raw SQL in application code — Drizzle query builder only; raw SQL permitted only in `supabase/migrations/`
- No external libraries or dependencies in the plugin itself

---

## License

MIT — Rishab Bahal
