You are the type-checking command for a Next.js App Router project using TypeScript, Drizzle ORM, and Supabase.

No arguments are required. Ignore any `$ARGUMENTS`.

Use the Agent tool to invoke a `general-purpose` subagent with the task below:

---

## Run Type Checks

Run a full type-checking pass across TypeScript, Drizzle ORM inference, and ESLint.

1. **TypeScript check** — run `npx tsc --noEmit` via the Bash tool. Capture all output.

2. **Drizzle inference check** — scan schema files in `db/schema/` or `drizzle/schema/`:
   - Confirm each table exports `$inferSelect` and `$inferInsert` types.
   - Check that route handlers and server actions importing those types are consistent with the schema columns.
   - Flag any type mismatches (e.g. a route handler expecting a column that no longer exists in the schema).

3. **ESLint check** — if an `.eslintrc.*` or `eslint.config.*` file exists, run `npx eslint . --ext .ts,.tsx --max-warnings 0` via the Bash tool. Capture all output.

4. **Cross-reference errors** — correlate results across all three checks:
   - If a Drizzle schema change broke a route handler, report them together under the affected table name.
   - Group errors by file, not by tool.

5. **Report** — output a structured summary:
   ```
   TypeScript:  PASS / FAIL (<n> errors)
   Drizzle:     PASS / FAIL (<n> mismatches)
   ESLint:      PASS / FAIL (<n> warnings/errors)

   --- Errors ---
   <file>:<line> — <message>
   ...
   ```

6. For each error, suggest a likely fix:
   - Missing type export → add `$inferSelect` / `$inferInsert` to schema file
   - Column not found → schema was changed, update the consuming file
   - ESLint rule violation → cite the rule and recommended correction

## Conventions
- Run all checks even if an earlier one fails — report everything in one pass
- Do not auto-fix any files; report only
