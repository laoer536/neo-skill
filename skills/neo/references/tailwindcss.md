---
name: tailwindcss
description: Neo's Tailwind CSS v4 setup preferences for Vite and Next.js projects
---

# Tailwind CSS v4

> Tailwind CSS v4 uses a CSS-first configuration approach — no `tailwind.config.js` needed for most projects.

## Vite Projects

### Install

```bash
pnpm add tailwindcss @tailwindcss/vite
```

### Configure

```ts
// vite.config.ts
import tailwindcss from '@tailwindcss/vite'
import { defineConfig } from 'vite'

export default defineConfig({
  plugins: [tailwindcss()],
})
```

### Import

```css
/* src/style.css */
@import "tailwindcss";
```

## Next.js Projects

### Install

```bash
pnpm add tailwindcss @tailwindcss/postcss postcss
```

### Configure

```js
// postcss.config.mjs
const config = {
  plugins: {
    "@tailwindcss/postcss": {},
  },
}
export default config
```

### Import

```css
/* app/globals.css */
@import "tailwindcss";
```

## Key Conventions

- **CSS-first theme**: Use `@theme { }` directive in CSS for custom tokens — no `tailwind.config.js`
- **Dark mode**: Use `class` strategy (`className={{ dark: condition }}`)
- **Mobile-first**: Always use breakpoint prefixes (`sm:`, `md:`, `lg:`, `xl:`, `2xl:`)
- **Prefer utility classes**: Reserve `@apply` for repeated patterns only
- **Single file components**: New projects keep styles inline with utility classes

## VSCode Extension

```json
// .vscode/extensions.json
{
  "recommendations": ["bradlc.vscode-tailwindcss"]
}
```
