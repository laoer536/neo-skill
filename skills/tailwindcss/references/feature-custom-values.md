---
name: feature-custom-values
description: Extending Tailwind with custom theme values
---

# Custom Values

Extend Tailwind's default theme with custom values.

## Custom Colors

```css
@import "tailwindcss";

@theme {
  /* Brand colors */
  --color-primary: #3b82f6;
  --color-primary-50: #eff6ff;
  --color-primary-100: #dbeafe;
  --color-primary-200: #bfdbfe;
  --color-primary-500: #3b82f6;
  --color-primary-900: #1e3a8a;
  
  /* Semantic colors */
  --color-success: #22c55e;
  --color-warning: #f59e0b;
  --color-error: #ef4444;
  --color-info: #3b82f6;
}
```

```html
<div class="bg-primary text-white">Primary background</div>
<div class="text-success">Success message</div>
<div class="border-warning border-2">Warning border</div>
```

## Custom Fonts

```css
@import "tailwindcss";

@theme {
  --font-sans: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  --font-serif: 'Merriweather', Georgia, serif;
  --font-mono: 'Fira Code', 'Courier New', monospace;
}
```

```html
<p class="font-sans">Sans-serif text</p>
<p class="font-serif">Serif text</p>
<code class="font-mono">Monospace text</code>
```

## Custom Spacing

```css
@import "tailwindcss";

@theme {
  --spacing-custom: 1200px;
  --spacing-section: 4rem;
  --spacing-page: 2rem;
}
```

```html
<div class="max-w-custom mx-auto">Custom max width</div>
<section class="py-section">Section padding</section>
<div class="px-page">Page padding</div>
```

## Custom Breakpoints

```css
@import "tailwindcss";

@theme {
  --breakpoint-3xl: 1920px;
  --breakpoint-4xl: 2560px;
}
```

```html
<div class="
  grid grid-cols-1
  md:grid-cols-2
  xl:grid-cols-3
  3xl:grid-cols-4
  4xl:grid-cols-5
">
  Responsive grid
</div>
```

## Custom Animations

```css
@import "tailwindcss";

@theme {
  --animate-fade-in: fade-in 0.5s ease-out;
  --animate-slide-up: slide-up 0.3s ease-out;
}

@keyframes fade-in {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slide-up {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
```

```html
<div class="animate-fade-in">Fade in</div>
<div class="animate-slide-up">Slide up</div>
```

## Custom Shadows

```css
@import "tailwindcss";

@theme {
  --shadow-card: 0 2px 8px rgba(0, 0, 0, 0.1);
  --shadow-card-hover: 0 4px 16px rgba(0, 0, 0, 0.15);
  --shadow-elevated: 0 8px 24px rgba(0, 0, 0, 0.2);
}
```

```html
<div class="shadow-card hover:shadow-card-hover transition-shadow">
  Card with custom shadow
</div>
```

## Key Points

- Use `@theme` directive for all customizations
- Follow naming conventions: `--color-`, `--font-`, `--spacing-`, etc.
- Custom values integrate seamlessly with utilities
- Keep custom values in a separate CSS file if needed
- Document custom values for team consistency
