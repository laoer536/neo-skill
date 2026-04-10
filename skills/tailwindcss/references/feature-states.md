---
name: feature-states
description: Interactive state variants in Tailwind CSS
---

# State Variants

Style elements based on user interactions and states.

## Hover States

```html
<!-- Button hover -->
<button class="
  bg-blue-500
  hover:bg-blue-600
  hover:shadow-lg
  transition-colors
">
  Hover me
</button>

<!-- Card hover -->
<div class="
  rounded-lg
  hover:shadow-xl
  hover:-translate-y-1
  transition-all
  duration-200
">
  Hover card
</div>
```

## Focus States

```html
<!-- Input focus -->
<input class="
  border border-gray-300
  focus:border-blue-500
  focus:ring-2
  focus:ring-blue-200
  focus:outline-none
">

<!-- Button focus -->
<button class="
  focus:ring-2
  focus:ring-blue-500
  focus:ring-offset-2
">
  Accessible button
</button>
```

## Active States

```html
<button class="
  bg-blue-500
  hover:bg-blue-600
  active:bg-blue-700
  active:scale-95
  transition-all
">
  Click me
</button>
```

## Combined States

```html
<a href="#" class="
  text-blue-600
  hover:text-blue-700
  hover:underline
  focus:outline-none
  focus:ring-2
  focus:ring-blue-500
  active:text-blue-800
">
  Link with all states
</a>
```

## Form States

```html
<!-- Disabled state -->
<button disabled class="
  bg-gray-300
  disabled:opacity-50
  disabled:cursor-not-allowed
">
  Disabled
</button>

<!-- Required field -->
<input required class="
  border-2
  invalid:border-red-500
  valid:border-green-500
">

<!-- Checked state -->
<input type="checkbox" class="
  checked:bg-blue-500
  checked:border-transparent
">
```

## Transitions

```html
<!-- Smooth transitions -->
<button class="
  bg-blue-500
  hover:bg-blue-600
  transition-colors
  duration-200
  ease-in-out
">
  Smooth hover
</button>

<!-- Transform transition -->
<div class="
  hover:scale-105
  hover:rotate-3
  transition-transform
  duration-300
">
  Animated card
</div>
```

## Key Points

- Always provide visual feedback for interactive elements
- Use `focus:` for accessibility
- Combine states for rich interactions
- Add transitions for smooth state changes
- Test all states during development
