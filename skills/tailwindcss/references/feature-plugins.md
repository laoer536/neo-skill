---
name: feature-plugins
description: Tailwind CSS plugins and extensions
---

# Plugins

Extend Tailwind with official and custom plugins.

## Official Plugins

### Forms Plugin

```bash
npm install @tailwindcss/forms
```

```css
@import "tailwindcss";
@plugin "@tailwindcss/forms";
```

```html
<!-- Styled form elements -->
<input type="text" class="form-input">
<select class="form-select">
  <option>Option 1</option>
</select>
<input type="checkbox" class="form-checkbox">
<input type="radio" class="form-radio">
```

### Typography Plugin

```bash
npm install @tailwindcss/typography
```

```css
@import "tailwindcss";
@plugin "@tailwindcss/typography";
```

```html
<!-- Prose styles for content -->
<article class="prose prose-lg max-w-none">
  <h1>Article Title</h1>
  <p>Article content with beautiful typography...</p>
  <blockquote>Important quote</blockquote>
  <ul>
    <li>List item 1</li>
    <li>List item 2</li>
  </ul>
</article>

<!-- Dark mode support -->
<article class="prose dark:prose-invert">
  Dark mode typography
</article>
```

### Container Queries Plugin

```bash
npm install @tailwindcss/container-queries
```

```css
@import "tailwindcss";
@plugin "@tailwindcss/container-queries";
```

```html
<div class="@container">
  <div class="@sm:text-lg @md:text-xl @lg:text-2xl">
    Responsive to container size
  </div>
</div>
```

## Custom Plugins

### Create Plugin

```js
// tailwind-plugin.js
import plugin from 'tailwindcss/plugin'

export default plugin(function({ addUtilities, addComponents, theme }) {
  // Add utilities
  addUtilities({
    '.aspect-video': {
      aspectRatio: '16 / 9',
    },
    '.aspect-square': {
      aspectRatio: '1 / 1',
    },
  })
  
  // Add components
  addComponents({
    '.btn-primary': {
      backgroundColor: theme('colors.primary'),
      color: theme('colors.white'),
      padding: `${theme('spacing.2')} ${theme('spacing.4')}`,
      borderRadius: theme('borderRadius.md'),
      '&:hover': {
        backgroundColor: theme('colors.primary-dark'),
      },
    },
  })
})
```

```css
@import "tailwindcss";
@plugin "./tailwind-plugin";
```

### Simple Utility Extension

```css
@import "tailwindcss";

@theme {
  /* Custom utility via CSS */
}

@utility aspect-video {
  aspect-ratio: 16 / 9;
}

@utility line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
```

```html
<div class="aspect-video">16:9 aspect ratio</div>
<p class="line-clamp-2">Truncated text...</p>
```

## Key Points

- Use official plugins for common needs
- Create custom plugins for repeated patterns
- Keep custom plugins simple and well-documented
- Test plugins with both light and dark modes
- Consider bundle size when adding plugins
