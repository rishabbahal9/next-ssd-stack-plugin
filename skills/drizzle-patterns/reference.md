# Drizzle ORM API Reference

Stable API surface for Drizzle ORM v0.30+. Use this to avoid hallucinating renamed or removed methods.

---

## Column Types (`drizzle-orm/pg-core`)

| Type | Usage |
|------|-------|
| `uuid(name)` | UUID column |
| `text(name)` | Unbounded string |
| `varchar(name, { length })` | Bounded string |
| `integer(name)` | 32-bit integer |
| `bigint(name, { mode })` | 64-bit integer (`mode: "number"` or `"bigint"`) |
| `boolean(name)` | Boolean |
| `timestamp(name, { withTimezone?, mode? })` | Timestamp |
| `date(name)` | Date only |
| `jsonb(name)` | JSONB |
| `numeric(name, { precision?, scale? })` | Decimal |
| `pgEnum(name, values)` | Postgres enum |

**Column modifiers:**
```ts
.primaryKey()
.notNull()
.default(value)
.defaultNow()         // timestamps only
.defaultRandom()      // uuid only
.unique()
.references(() => table.col, { onDelete?, onUpdate? })
```

---

## Table Definition (`drizzle-orm/pg-core`)

```ts
import { pgTable, index, uniqueIndex } from "drizzle-orm/pg-core";

const table = pgTable("table_name", {
  // columns
}, (t) => ({
  // indexes
  nameIdx: index("table_name_idx").on(t.columnName),
  uniqueNameIdx: uniqueIndex("table_unique_idx").on(t.columnName),
  // composite index
  compositeIdx: index("composite_idx").on(t.col1, t.col2),
}));
```

---

## Relations API (`drizzle-orm`)

```ts
import { relations } from "drizzle-orm";

// One-to-many
const parentRelations = relations(parentTable, ({ many }) => ({
  children: many(childTable),
}));

const childRelations = relations(childTable, ({ one }) => ({
  parent: one(parentTable, {
    fields: [childTable.parentId],
    references: [parentTable.id],
  }),
}));

// Many-to-many (via junction table)
const postRelations = relations(posts, ({ many }) => ({
  taggings: many(postTags),
}));

const postTagsRelations = relations(postTags, ({ one }) => ({
  post: one(posts, { fields: [postTags.postId], references: [posts.id] }),
  tag: one(tags, { fields: [postTags.tagId], references: [tags.id] }),
}));
```

---

## Query API

### Relational Query Builder (preferred)

```ts
// Requires relations defined and passed to drizzle()
const result = await db.query.tableName.findFirst({
  where: eq(table.col, value),
  with: { relation: true },
  columns: { id: true, name: true },  // select specific columns
  orderBy: desc(table.createdAt),
  limit: 10,
  offset: 0,
});

const results = await db.query.tableName.findMany({ /* same options */ });
```

### Core Query Builder

```ts
// SELECT
db.select().from(table)
db.select({ col: table.col }).from(table)
db.selectDistinct().from(table)

// with joins
db.select().from(table)
  .leftJoin(other, eq(table.otherId, other.id))
  .innerJoin(other, eq(table.otherId, other.id))

// INSERT
db.insert(table).values({ col: val })
db.insert(table).values([{ col: val }, { col: val2 }])
db.insert(table).values({ col: val }).returning()
db.insert(table).values({ col: val }).onConflictDoNothing()
db.insert(table).values({ col: val }).onConflictDoUpdate({
  target: table.col,
  set: { col: sql`excluded.col` },
})

// UPDATE
db.update(table).set({ col: val }).where(eq(table.id, id))
db.update(table).set({ col: val }).where(eq(table.id, id)).returning()

// DELETE
db.delete(table).where(eq(table.id, id))
db.delete(table).where(eq(table.id, id)).returning()
```

---

## Filter Operators (`drizzle-orm`)

```ts
import {
  eq, ne,              // equal, not equal
  gt, gte, lt, lte,   // comparisons
  and, or, not,        // logical
  isNull, isNotNull,   // null checks
  inArray, notInArray, // IN clause
  like, ilike,         // LIKE (case-sensitive / insensitive)
  between,             // BETWEEN
  sql,                 // raw SQL escape hatch
} from "drizzle-orm";
```

---

## Sorting & Pagination

```ts
import { asc, desc } from "drizzle-orm";

db.select().from(table)
  .orderBy(desc(table.createdAt), asc(table.name))
  .limit(20)
  .offset(40);
```

---

## Drizzle-Zod (`drizzle-zod`)

```ts
import { createInsertSchema, createSelectSchema } from "drizzle-zod";

// Basic
const insertSchema = createInsertSchema(table);
const selectSchema = createSelectSchema(table);

// With overrides
const insertSchema = createInsertSchema(table, {
  email: (schema) => schema.email(),
  name: (schema) => schema.min(2).max(100),
});

// Types
type NewRow = typeof insertSchema._type;
type Row = typeof selectSchema._type;
```

---

## `drizzle.config.ts` Options

```ts
import type { Config } from "drizzle-kit";

export default {
  schema: "./db/schema/index.ts",   // path to schema
  out: "./drizzle",                  // migration output dir
  dialect: "postgresql",             // "postgresql" | "mysql" | "sqlite"
  dbCredentials: {
    url: process.env.DATABASE_URL!,
  },
  verbose: true,                     // log SQL statements
  strict: true,                      // require confirmation on destructive ops
} satisfies Config;
```

**CLI commands:**
```bash
npx drizzle-kit generate    # generate SQL migration from schema diff
npx drizzle-kit migrate     # apply pending migrations
npx drizzle-kit push        # push schema directly (dev only, no migration files)
npx drizzle-kit studio      # open Drizzle Studio UI
npx drizzle-kit check       # check for migration conflicts
```

---

## DB Client Setup (`db/index.ts`)

```ts
import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";
import * as schema from "./schema";

const client = postgres(process.env.DATABASE_URL!);
export const db = drizzle(client, { schema });
```
