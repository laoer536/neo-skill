---
name: tailwindcss
description: Tailwind CSS v4 utility-first CSS framework. Use when styling components, configuring themes, or working with responsive design, dark mode, or custom utilities.
metadata:
  author: Neo
  version: "2026.04.09"
  source: Manual
---

# Tailwind CSS v4

> Based on Tailwind CSS v4. Prefer utility-first approach with minimal custom CSS.

Tailwind CSS is a utility-first CSS framework for rapidly building custom user interfaces. V4 introduces a new engine with improved performance and simpler configuration.

## Preferences

- Use Tailwind CSS v4 for all new projects
- Prefer utility classes over custom CSS
- Use `@apply` sparingly, only for repeated patterns
- Configure theme in `tailwind.config.ts` when needed
- Enable dark mode with `class` strategy

## Core

| Topic | Description | Reference |
|-------|-------------|-----------|
| Configuration | v4 setup, CSS-first config, theme customization | [core-config](references/core-config.md) |
| Utility Classes | Layout, spacing, typography, colors, effects | [core-utilities](references/core-utilities.md) |
| Responsive Design | Breakpoints, mobile-first patterns | [core-responsive](references/core-responsive.md) |

## Features

### Dark Mode & States

| Topic | Description | Reference |
|-------|-------------|-----------|
| Dark Mode | `dark:` variant, class-based strategy | [feature-dark-mode](references/feature-dark-mode.md) |
| Hover & Focus | State variants, interactive patterns | [feature-states](references/feature-states.md) |

### Customization

| Topic | Description | Reference |
|-------|-------------|-----------|
| Custom Values | Extend theme, custom utilities | [feature-custom-values](references/feature-custom-values.md) |
| Plugins | Official and custom plugins | [feature-plugins](references/feature-plugins.md) |

## Quick Reference

### Basic Setup (v4)

```css
/* styles.css - v4 uses CSS-first configuration */
@import "tailwindcss";

@theme {
  --color-primary: #3b82f6;
  --color-secondary: #64748b;
  --font-sans: 'Inter', sans-serif;
}
```

### Common Patterns

```html
<!-- Responsive design (mobile-first) -->
<div class="w-full md:w-1/2 lg:w-1/3">
  Content
</div>

<!-- Dark mode -->
<div class="bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
  Theme-aware content
</div>

<!-- Hover & focus states -->
<button class="bg-blue-500 hover:bg-blue-600 focus:ring-2 focus:ring-blue-300">
  Click me
</button>

<!-- Flexbox layout -->
<div class="flex items-center justify-between gap-4">
  <span>Left</span>
  <span>Right</span>
</div>
```

### Vue/React Integration

**Vue (with Vite):**
```ts
// vite.config.ts
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
})
```

**React (with Vite):**
```ts
// vite.config.ts
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
})
```

## Migration from v3 to v4

- Configuration moved to CSS (`@theme` instead of `tailwind.config.js`)
- Improved performance with new Rust-based engine
- Simplified installation process
- Better TypeScript support
