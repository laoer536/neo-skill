---
name: core-responsive
description: Responsive design patterns with Tailwind CSS
---

# Responsive Design

Tailwind uses a mobile-first breakpoint system.

## Breakpoints

```css
/* Default breakpoints */
sm: 640px    /* @media (min-width: 640px) */
md: 768px    /* @media (min-width: 768px) */
lg: 1024px   /* @media (min-width: 1024px) */
xl: 1280px   /* @media (min-width: 1280px) */
2xl: 1536px  /* @media (min-width: 1536px) */
```

## Usage Pattern

```html
<!-- Mobile-first approach -->
<div class="
  w-full          <!-- Mobile: 100% width -->
  md:w-1/2        <!-- Tablet: 50% width -->
  lg:w-1/3        <!-- Desktop: 33.3% width -->
  xl:w-1/4        <!-- Large: 25% width -->
">
  Responsive column
</div>

<!-- Grid layout -->
<div class="grid
  grid-cols-1     <!-- Mobile: 1 column -->
  md:grid-cols-2  <!-- Tablet: 2 columns -->
  lg:grid-cols-3  <!-- Desktop: 3 columns -->
  gap-4
">
  <div>Card 1</div>
  <div>Card 2</div>
  <div>Card 3</div>
</div>
```

## Common Patterns

### Responsive Padding

```html
<div class="
  p-4             <!-- Mobile: 1rem -->
  md:p-6          <!-- Tablet: 1.5rem -->
  lg:p-8          <!-- Desktop: 2rem -->
">
  Content with responsive padding
</div>
```

### Responsive Typography

```html
<h1 class="
  text-2xl        <!-- Mobile: 1.5rem -->
  md:text-3xl     <!-- Tablet: 1.875rem -->
  lg:text-4xl     <!-- Desktop: 2.25rem -->
  font-bold
">
  Responsive heading
</h1>
```

### Hide/Show Elements

```html
<!-- Hide on mobile, show on tablet+ -->
<div class="hidden md:block">
  Desktop navigation
</div>

<!-- Show on mobile, hide on tablet+ -->
<div class="block md:hidden">
  Mobile menu button
</div>

<!-- Show only on desktop -->
<div class="hidden lg:block">
  Desktop-only content
</div>
```

### Responsive Flex Direction

```html
<div class="
  flex flex-col    <!-- Mobile: vertical -->
  md:flex-row      <!-- Tablet+: horizontal -->
  gap-4
">
  <div>Item 1</div>
  <div>Item 2</div>
</div>
```

## Custom Breakpoints

```css
@theme {
  --breakpoint-3xl: 1920px;
  --breakpoint-4xl: 2560px;
}
```

```html
<div class="w-full 3xl:w-3/4 4xl:w-2/3">
  Ultra-wide screen layout
</div>
```

## Key Points

- Always design mobile-first
- Use breakpoint prefixes: `sm:`, `md:`, `lg:`, `xl:`, `2xl:`
- Combine with utility classes for responsive layouts
- Test at multiple screen sizes
