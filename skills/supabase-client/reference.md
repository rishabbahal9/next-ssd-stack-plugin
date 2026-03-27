# Supabase Client API Reference

Stable API surface for `@supabase/ssr` v0.5+ and `@supabase/supabase-js` v2+.

---

## Auth

```ts
// Get current session (server)
const { data: { user } } = await supabase.auth.getUser();

// Sign in
await supabase.auth.signInWithPassword({ email, password });
await supabase.auth.signInWithOAuth({ provider: "github" });

// Sign out
await supabase.auth.signOut();

// Listen to auth state (browser only)
supabase.auth.onAuthStateChange((event, session) => { ... });
```

---

## Database Queries

```ts
// SELECT
const { data, error } = await supabase
  .from("table")
  .select("id, name, created_at")
  .eq("user_id", userId)
  .order("created_at", { ascending: false })
  .limit(20);

// SELECT with join
const { data } = await supabase
  .from("posts")
  .select("*, author:profiles(id, name)");

// INSERT
const { data, error } = await supabase
  .from("table")
  .insert({ col: value })
  .select()
  .single();

// UPDATE
const { data, error } = await supabase
  .from("table")
  .update({ col: value })
  .eq("id", id)
  .select()
  .single();

// DELETE
const { error } = await supabase
  .from("table")
  .delete()
  .eq("id", id);

// UPSERT
const { data, error } = await supabase
  .from("table")
  .upsert({ id, col: value }, { onConflict: "id" });
```

---

## Filter Operators

```ts
.eq("col", value)          // =
.neq("col", value)         // !=
.gt("col", value)          // >
.gte("col", value)         // >=
.lt("col", value)          // <
.lte("col", value)         // <=
.like("col", "%pattern%")  // LIKE
.ilike("col", "%pattern%") // ILIKE
.is("col", null)           // IS NULL
.in("col", [v1, v2])       // IN
.contains("col", value)    // @> (jsonb/array)
.or("col.eq.1,col.eq.2")   // OR
```

---

## Storage

```ts
// Upload
const { data, error } = await supabase.storage
  .from("bucket")
  .upload("path/file.png", file, { upsert: true });

// Download URL (public bucket)
const { data } = supabase.storage
  .from("bucket")
  .getPublicUrl("path/file.png");

// Download URL (private bucket — signed)
const { data } = await supabase.storage
  .from("bucket")
  .createSignedUrl("path/file.png", 3600); // 1 hour

// Delete
await supabase.storage.from("bucket").remove(["path/file.png"]);
```

---

## Realtime

```ts
// Subscribe to table changes (browser only)
const channel = supabase
  .channel("table-changes")
  .on("postgres_changes",
    { event: "*", schema: "public", table: "messages" },
    (payload) => console.log(payload)
  )
  .subscribe();

// Unsubscribe on cleanup
return () => { supabase.removeChannel(channel); };
```

---

## Required Environment Variables

```env
NEXT_PUBLIC_SUPABASE_URL=https://<project>.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=<anon-key>
SUPABASE_SERVICE_ROLE_KEY=<service-role-key>   # server only, never expose
```
