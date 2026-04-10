---
name: core-utilities
description: Essential Tailwind CSS utility classes
---

# Utility Classes

Core utility classes for building layouts and styling components.

## Layout

### Flexbox

```html
<div class="flex items-center justify-between gap-4">
  <div>Left</div>
  <div>Right</div>
</div>

<!-- Centered -->
<div class="flex items-center justify-center min-h-screen">
  Centered content
</div>

<!-- Column layout -->
<div class="flex flex-col gap-2">
  <div>Item 1</div>
  <div>Item 2</div>
</div>
```

### Grid

```html
<!-- Responsive grid -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
  <div>Card 1</div>
  <div>Card 2</div>
  <div>Card 3</div>
</div>

<!-- Auto-fit grid -->
<div class="grid grid-cols-[repeat(auto-fit,minmax(250px,1fr))] gap-4">
  <div>Card</div>
</div>
```

## Spacing

```html
<!-- Padding -->
<div class="p-4">              <!-- 1rem (16px) -->
<div class="px-6 py-3">        <!-- x: 1.5rem, y: 0.75rem -->
<div class="pt-2 pb-4 pl-3 pr-5">

<!-- Margin -->
<div class="m-4">              <!-- 1rem -->
<div class="mx-auto">          <!-- Center horizontally -->
<div class="mt-4 mb-2">        <!-- Top and bottom -->

<!-- Gap (flex/grid) -->
<div class="flex gap-4">       <!-- 1rem gap -->
<div class="grid gap-6">       <!-- 1.5rem gap -->
```

## Typography

```html
<!-- Font size -->
<p class="text-sm">Small</p>         <!-- 0.875rem -->
<p class="text-base">Base</p>        <!-- 1rem -->
<p class="text-lg">Large</p>         <!-- 1.125rem -->
<p class="text-2xl">2XL</p>          <!-- 1.5rem -->
<p class="text-4xl">4XL</p>          <!-- 2.25rem -->

<!-- Font weight -->
<p class="font-light">Light</p>      <!-- 300 -->
<p class="font-normal">Normal</p>    <!-- 400 -->
<p class="font-medium">Medium</p>    <!-- 500 -->
<p class="font-bold">Bold</p>        <!-- 700 -->

<!-- Text alignment -->
<p class="text-left">Left</p>
<p class="text-center">Center</p>
<p class="text-right">Right</p>

<!-- Text color -->
<p class="text-gray-900">Dark</p>
<p class="text-blue-500">Blue</p>
<p class="text-primary">Custom</p>   <!-- From @theme -->
```

## Colors

### Default Palette

```html
<!-- Background colors -->
<div class="bg-white">White</div>
<div class="bg-gray-100">Light gray</div>
<div class="bg-blue-500">Blue</div>
<div class="bg-red-500">Red</div>

<!-- Text colors -->
<p class="text-gray-900">Dark text</p>
<p class="text-blue-600">Blue text</p>

<!-- Border colors -->
<div class="border border-gray-300">Gray border</div>
<div class="border-2 border-primary">Custom border</div>
```

### Custom Colors (in @theme)

```css
@theme {
  --color-primary: #3b82f6;
  --color-primary-dark: #2563eb;
  --color-success: #22c55e;
  --color-warning: #f59e0b;
  --color-error: #ef4444;
}
```

```html
<div class="bg-primary text-white">Primary button</div>
<div class="text-success">Success message</div>
```

## Sizing

```html
<!-- Width -->
<div class="w-full">Full width</div>         <!-- 100% -->
<div class="w-1/2">Half width</div>          <!-- 50% -->
<div class="w-64">Fixed width</div>          <!-- 16rem (256px) -->
<div class="w-screen">Screen width</div>     <!-- 100vw -->

<!-- Height -->
<div class="h-screen">Full height</div>      <!-- 100vh -->
<div class="h-64">Fixed height</div>         <!-- 16rem -->
<div class="min-h-screen">Min height</div>   <!-- min-height: 100vh -->

<!-- Max width -->
<div class="max-w-4xl mx-auto">Container</div>
<div class="max-w-screen-xl">Wide container</div>
```

## Key Points

- Use utility classes for rapid development
- Mobile-first approach (base styles for mobile, add breakpoints for larger screens)
- Combine utilities for complex layouts
- Custom values can be added in `@theme` directive
