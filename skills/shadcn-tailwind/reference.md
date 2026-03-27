# Shadcn UI + Tailwind CSS Reference

Stable API surface for Shadcn UI (Radix-based) and Tailwind CSS v3+.

---

## `cn()` Utility (`lib/utils.ts`)

```ts
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

Usage:
```tsx
<div className={cn("base-class", isActive && "active-class", className)} />
```

---

## Common Shadcn Components

| Component | Import path | Notes |
|-----------|-------------|-------|
| Button | `@/components/ui/button` | `variant`, `size` props |
| Input | `@/components/ui/input` | Uncontrolled by default |
| Label | `@/components/ui/label` | Pair with `htmlFor` |
| Textarea | `@/components/ui/textarea` | |
| Select | `@/components/ui/select` | `SelectTrigger`, `SelectContent`, `SelectItem` |
| Checkbox | `@/components/ui/checkbox` | |
| Dialog | `@/components/ui/dialog` | `DialogTrigger`, `DialogContent`, `DialogHeader` |
| AlertDialog | `@/components/ui/alert-dialog` | For destructive confirmations |
| Sheet | `@/components/ui/sheet` | Slide-in panel |
| Tabs | `@/components/ui/tabs` | `TabsList`, `TabsTrigger`, `TabsContent` |
| Table | `@/components/ui/table` | `TableHeader`, `TableBody`, `TableRow`, `TableCell` |
| Card | `@/components/ui/card` | `CardHeader`, `CardContent`, `CardFooter` |
| Badge | `@/components/ui/badge` | `variant`: `default`, `secondary`, `destructive`, `outline` |
| Toast / Sonner | `@/components/ui/sonner` | Use `toast()` from `sonner` |
| Skeleton | `@/components/ui/skeleton` | Loading placeholder |
| Separator | `@/components/ui/separator` | |
| DropdownMenu | `@/components/ui/dropdown-menu` | |
| Popover | `@/components/ui/popover` | `PopoverTrigger`, `PopoverContent` |
| Tooltip | `@/components/ui/tooltip` | Wrap app in `TooltipProvider` |
| Form | `@/components/ui/form` | React Hook Form integration |

---

## Button Variants

```tsx
<Button variant="default" size="default">Submit</Button>
<Button variant="destructive">Delete</Button>
<Button variant="outline">Cancel</Button>
<Button variant="secondary">Secondary</Button>
<Button variant="ghost">Ghost</Button>
<Button variant="link">Link</Button>

// Sizes: "default" | "sm" | "lg" | "icon"
```

---

## Form Pattern (React Hook Form + Shadcn)

```tsx
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { Form, FormField, FormItem, FormLabel, FormControl, FormMessage } from "@/components/ui/form";

const form = useForm<Schema>({ resolver: zodResolver(schema) });

<Form {...form}>
  <form onSubmit={form.handleSubmit(onSubmit)}>
    <FormField control={form.control} name="email" render={({ field }) => (
      <FormItem>
        <FormLabel>Email</FormLabel>
        <FormControl><Input {...field} /></FormControl>
        <FormMessage />
      </FormItem>
    )} />
    <Button type="submit">Submit</Button>
  </form>
</Form>
```

---

## Tailwind Theme Extension (`tailwind.config.ts`)

```ts
import type { Config } from "tailwindcss";

export default {
  darkMode: "class",
  content: ["./app/**/*.{ts,tsx}", "./components/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        brand: { 50: "#...", 500: "#...", 900: "#..." },
      },
      fontFamily: {
        sans: ["var(--font-geist-sans)"],
        mono: ["var(--font-geist-mono)"],
      },
      borderRadius: {
        // Shadcn uses CSS vars — extend here if overriding
      },
    },
  },
  plugins: [require("tailwindcss-animate")],
} satisfies Config;
```

---

## Responsive Breakpoints

| Prefix | Min-width |
|--------|-----------|
| `sm:` | 640px |
| `md:` | 768px |
| `lg:` | 1024px |
| `xl:` | 1280px |
| `2xl:` | 1536px |

Always mobile-first: base styles apply to all sizes, prefixed styles apply upward.

---

## Dark Mode

```tsx
// Toggle dark mode by adding/removing "dark" class on <html>
document.documentElement.classList.toggle("dark");

// In components
<div className="bg-white dark:bg-zinc-900 text-zinc-900 dark:text-zinc-50" />
```

---

## Animation (`tailwindcss-animate`)

```tsx
// Fade in
<div className="animate-in fade-in duration-300" />

// Slide in from bottom
<div className="animate-in slide-in-from-bottom-4 duration-300" />

// Zoom in
<div className="animate-in zoom-in-95 duration-200" />

// Out variants: animate-out fade-out, slide-out-to-top-4, zoom-out-95
```
