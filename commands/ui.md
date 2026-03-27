You are scaffolding UI components for a Next.js project using Shadcn UI, Tailwind CSS, and Zod validation.

Parse `$ARGUMENTS` as `<type> <name>` (e.g. `form signup`, `table users`, `dialog confirm-delete`).
Supported types: `form`, `table`, `dialog`.

If the type is not supported, respond:
> Unknown UI type. Usage: `/ui form <name>` | `/ui table <name>` | `/ui dialog <name>`

Otherwise, use the Agent tool to invoke a `general-purpose` subagent with the following task:

---

Scaffold a **<type>** UI component named **<name>** in `components/<name>/` of the current working directory. Use the Write tool to create each file, then list all created paths.

## Conventions
- Shadcn imports: `@/components/ui/*`
- Zod for all form validation schemas
- PascalCase for component names, kebab-case for file names
- Tailwind CSS for all styling — no inline styles
- Client components must include `'use client'` directive

## Files to create

### `form <name>` → `components/<name>/`
- `index.tsx` — `'use client'`; Shadcn `<Form>`, `<FormField>`, `<Input>`, `<Button>`; Zod schema with `useForm` from `react-hook-form` + `zodResolver`; `onSubmit` stub that logs values
- `schema.ts` — Zod schema and inferred TypeScript type for the form

### `table <name>` → `components/<name>/`
- `index.tsx` — `'use client'`; Shadcn `<DataTable>` with `@tanstack/react-table`; column definitions with sorting enabled; pagination controls using Shadcn `<Button>` and `<Select>`
- `columns.tsx` — typed `ColumnDef<TData>` array; stub columns matching a generic `<name>` row shape

### `dialog <name>` → `components/<name>/`
- `index.tsx` — `'use client'`; Shadcn `<Dialog>`, `<DialogTrigger>`, `<DialogContent>`, `<DialogHeader>`, `<DialogFooter>`; confirm and cancel `<Button>` actions; `onConfirm` and `onCancel` props
