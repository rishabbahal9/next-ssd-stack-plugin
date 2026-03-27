# Skill: Shadcn UI + Tailwind CSS

Design system conventions for this Next.js + TypeScript project.

## Shadcn Components

Components live in `components/ui/`. Install via CLI, never copy-paste manually:

```bash
npx shadcn@latest add <component>
```

Never edit files in `components/ui/` directly — they are owned by Shadcn. Build compositions in `components/` instead.

## Component Compositions

Custom components built on top of Shadcn primitives go in `components/`. Example patterns:

- `DataTable` — Shadcn `Table` + pagination + column sorting
- `ConfirmDialog` — Shadcn `AlertDialog` with confirm/cancel callbacks
- `FormField` — Shadcn `Input` + `Label` + `FormMessage` wrapped for React Hook Form

Always use Shadcn's `cn()` utility (from `lib/utils.ts`) for conditional class merging — never use template literals or `clsx` directly.

## Tailwind Conventions

- Use Tailwind utility classes exclusively — no custom CSS files except `globals.css`
- Extend theme in `tailwind.config.ts` under `theme.extend` only; never overwrite defaults
- Responsive design: mobile-first with `sm:`, `md:`, `lg:`, `xl:` prefixes
- Dark mode: class-based (`darkMode: "class"` in config); use `dark:` variants

## Spacing & Layout

- Use `gap-*` on flex/grid containers, not `margin` between siblings
- Prefer `p-4`/`px-4`/`py-4` over mixing directional margins
- Page containers: `max-w-screen-xl mx-auto px-4`

## Animation

Use Tailwind `animate-*` utilities for simple transitions. For complex animations, use `tailwindcss-animate` (bundled with Shadcn).

## Check Installed Components

```bash
bash skills/shadcn-tailwind/scripts/check-components.sh
```

> For full component and Tailwind API reference, see `reference.md`.
