You are the Row Level Security policy generator for a Next.js App Router project using Supabase and Drizzle ORM.

Parse `$ARGUMENTS` as `<table>` (e.g. `users`, `posts`).

If no table name is provided, respond:
> Missing table name. Usage: `/rls <table>` (e.g. `/rls users`)

Otherwise, use the Agent tool to invoke a `general-purpose` subagent with the task below:

---

## Generate RLS Policies for `<table>`

Generate Supabase Row Level Security policies for the **<table>** table.

1. Locate the Drizzle schema for `<table>` in `db/schema/<table>.ts` or `drizzle/schema/<table>.ts`. Read it to identify:
   - Primary key column
   - User/owner foreign key columns (e.g. `user_id`, `owner_id`, `created_by`)
   - Any role or visibility columns (e.g. `is_public`, `role`, `status`)

2. Generate a SQL migration file at `supabase/migrations/<timestamp>_rls_<table>.sql` with the following policies:

   **Own-data access** — users can only read/write their own rows:
   ```sql
   CREATE POLICY "<table>_select_own" ON "<table>"
     FOR SELECT USING (auth.uid() = user_id);

   CREATE POLICY "<table>_insert_own" ON "<table>"
     FOR INSERT WITH CHECK (auth.uid() = user_id);

   CREATE POLICY "<table>_update_own" ON "<table>"
     FOR UPDATE USING (auth.uid() = user_id);

   CREATE POLICY "<table>_delete_own" ON "<table>"
     FOR DELETE USING (auth.uid() = user_id);
   ```

   **Admin override** — service role bypasses RLS:
   ```sql
   CREATE POLICY "<table>_admin_all" ON "<table>"
     FOR ALL USING (auth.role() = 'service_role');
   ```

   **Public read** (only if a `is_public` or similar column exists):
   ```sql
   CREATE POLICY "<table>_public_read" ON "<table>"
     FOR SELECT USING (is_public = true);
   ```

3. Ensure RLS is enabled on the table:
   ```sql
   ALTER TABLE "<table>" ENABLE ROW LEVEL SECURITY;
   ```

4. Create a reference doc at `supabase/rls/<table>.md` explaining each policy:
   - Policy name
   - Operation (SELECT / INSERT / UPDATE / DELETE / ALL)
   - Who it applies to
   - Why it exists

5. List all created/modified files.

## Conventions
- Use `auth.uid()` for user identity checks
- Use `auth.role() = 'service_role'` for admin/service bypass
- Policy names follow the pattern: `<table>_<operation>_<scope>`
- Adapt policies based on actual schema columns — if no `user_id` column exists, note it and skip own-data policies
