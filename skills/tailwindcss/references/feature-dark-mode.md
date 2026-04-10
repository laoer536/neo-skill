---
name: feature-dark-mode
description: Dark mode implementation with Tailwind CSS
---

# Dark Mode

Implement theme switching with Tailwind's dark mode variants.

## Configuration

```css
@import "tailwindcss";

@theme {
  --color-bg-primary: #ffffff;
  --color-bg-primary-dark: #0f172a;  /* Automatic dark variant */
  --color-text-primary: #0f172a;
  --color-text-primary-dark: #ffffff;
}
```

## Usage

### Basic Dark Mode

```html
<div class="bg-white dark:bg-slate-900">
  <p class="text-gray-900 dark:text-white">
    Theme-aware content
  </p>
</div>
```

### Complex Component

```html
<div class="
  bg-white dark:bg-gray-800
  border border-gray-200 dark:border-gray-700
  rounded-lg p-6
">
  <h2 class="text-xl font-bold text-gray-900 dark:text-white">
    Card Title
  </h2>
  <p class="text-gray-600 dark:text-gray-300">
    Card description with theme-aware colors
  </p>
  <button class="
    mt-4 px-4 py-2
    bg-blue-500 hover:bg-blue-600
    text-white
    rounded-md
  ">
    Action
  </button>
</div>
```

## Enabling Dark Mode

### Class Strategy (Recommended)

```html
<!-- HTML -->
<html class="dark">
  <body>
    <!-- Dark mode active -->
  </body>
</html>
```

```ts
// Toggle with JavaScript
function toggleDarkMode() {
  document.documentElement.classList.toggle('dark')
}

// Check system preference
if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
  document.documentElement.classList.add('dark')
}
```

### Vue Composable

```ts
// composables/useDarkMode.ts
import { ref, onMounted } from 'vue'

export function useDarkMode() {
  const isDark = ref(false)
  
  onMounted(() => {
    isDark.value = localStorage.getItem('theme') === 'dark' ||
      window.matchMedia('(prefers-color-scheme: dark)').matches
    
    if (isDark.value) {
      document.documentElement.classList.add('dark')
    }
  })
  
  function toggle() {
    isDark.value = !isDark.value
    if (isDark.value) {
      document.documentElement.classList.add('dark')
      localStorage.setItem('theme', 'dark')
    } else {
      document.documentElement.classList.remove('dark')
      localStorage.setItem('theme', 'light')
    }
  }
  
  return { isDark, toggle }
}
```

### React Hook

```ts
// hooks/useDarkMode.ts
import { useState, useEffect } from 'react'

export function useDarkMode() {
  const [isDark, setIsDark] = useState(false)
  
  useEffect(() => {
    isDark = localStorage.getItem('theme') === 'dark' ||
      window.matchMedia('(prefers-color-scheme: dark)').matches
    
    if (isDark) {
      document.documentElement.classList.add('dark')
    }
  }, [])
  
  function toggle() {
    setIsDark(prev => {
      const newValue = !prev
      if (newValue) {
        document.documentElement.classList.add('dark')
        localStorage.setItem('theme', 'dark')
      } else {
        document.documentElement.classList.remove('dark')
        localStorage.setItem('theme', 'light')
      }
      return newValue
    })
  }
  
  return { isDark, toggle }
}
```

## Key Points

- Use `dark:` prefix for dark mode variants
- Prefer class strategy for manual control
- Respect system preference on first load
- Store user preference in localStorage
- Test both themes during development
