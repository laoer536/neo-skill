---
name: core-config
description: Tailwind CSS v4 configuration and setup
---

# Tailwind CSS v4 Configuration

V4 introduces a CSS-first configuration approach, replacing the JavaScript config file.

## Installation

```bash
npm install tailwindcss@^4
```

## Basic Setup

### 1. Import in CSS

```css
/* styles.css */
@import "tailwindcss";
```

### 2. Customize Theme

```css
@import "tailwindcss";

@theme {
  /* Custom colors */
  --color-primary: #3b82f6;
  --color-primary-dark: #2563eb;
  --color-secondary: #64748b;
  
  /* Custom fonts */
  --font-sans: 'Inter', system-ui, sans-serif;
  --font-mono: 'Fira Code', monospace;
  
  /* Custom spacing */
  --spacing-custom: 1200px;
  
  /* Custom breakpoints */
  --breakpoint-3xl: 1920px;
}
```

## Vite Integration

```ts
// vite.config.ts
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue' // or react

export default defineConfig({
  plugins: [vue()],
  css: {
    // Optional: configure CSS preprocessor
  },
})
```

## Migration from v3

### v3 (Old)
```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: '#3b82f6',
      }
    }
  }
}
```

### v4 (New)
```css
/* styles.css */
@import "tailwindcss";

@theme {
  --color-primary: #3b82f6;
}
```

## Key Points

- V4 uses CSS-first configuration with `@theme` directive
- No need for `tailwind.config.js` in most cases
- CSS custom properties define theme values
- Improved performance with new engine
- Better TypeScript support out of the box
