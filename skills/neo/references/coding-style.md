---
name: coding-style
description: Neo's coding style and formatting conventions for Vue and React projects
---

# Coding Style

## File Naming

### Decision Tree

```
What type of file is this?
├─ Component (UI)
│  ├─ New project (Tailwind CSS)? → PascalCase.tsx/vue (single file)
│  └─ Existing project (Less/SCSS)? → ComponentName/index.tsx|vue + ComponentName/index.less|scss
│
├─ Function
│  ├─ Composable/Hook? → camelCase with 'use' prefix (useAuth.ts)
│  └─ Utility/API? → camelCase (formatDate.ts, fetchUsers.ts)
│
├─ Type/Interface
│  ├─ Component-specific? → Inline in component file
│  └─ Shared? → PascalCase.types.ts (User.types.ts) or types.ts
│
├─ Config → kebab-case.config.ext (vite.config.ts)
├─ Page/Route → kebab-case (user-profile.vue)
└─ Test → source-file.test.ts (UserCard.test.tsx)
```

### Styling Strategy

**Before creating components, determine the styling approach:**

```
Is this a new or existing project?
├─ New Project → Tailwind CSS (single file, no separate styles)
│  └── UserCard.tsx
│
└─ Existing Project (Less/SCSS) → Component folders
   └── UserCard/
       ├── index.tsx
       └── index.less
```

### Naming Conventions

| File Type | Convention | Example | Reason |
|-----------|-----------|---------|--------|
| **Vue Component** | PascalCase | `MyComponent.vue` | Vue recommended |
| **React Component** | PascalCase (Required) | `MyComponent.tsx` | React requires it |
| **Component Folder** | PascalCase | `UserCard/index.tsx` | Matches component name |
| **Component Styles** | `index.less/scss` | `UserCard/index.less` | Auto-import with folder |
| **Composable/Hook** | camelCase + `use` prefix | `useAuth.ts` | It's a function |
| **Utility Function** | camelCase | `formatDate.ts` | JavaScript convention |
| **Type/Interface** | `.types.ts` or `types.ts` | `User.types.ts` | Avoids component conflicts |
| **Config File** | kebab-case | `vite.config.ts` | Industry standard |
| **Page/Route** | kebab-case | `user-profile.vue` | URL-friendly |
| **Test File** | `.test.ts` suffix | `UserCard.test.tsx` | Clear association |
| **React Import** | Destructured | `import { useState } from 'react'` | No `React.xxx` namespace |

**Why mixed naming?**
- **PascalCase for components**: React **requires** it to distinguish from HTML elements
- **camelCase for functions**: Composables, hooks, utilities follow JS conventions
- **kebab-case for config & routes**: Industry standard for config files and URL-friendly routes

## Code Organization

### Import Order

```ts
// 1. External dependencies
import { ref, computed } from 'vue'
import { useState, useEffect } from 'react'
import { defineStore } from 'pinia'

// 2. Internal modules (use path aliases when configured)
import { formatDate } from '@/utils/date'        // ✅ Prefer alias (@/ or ~/
import { UserCard } from '@/components'          // ✅ Cleaner and more portable
// ❌ Avoid relative paths for cross-directory imports
import { helper } from '../../../utils/helper'   // Hard to read and maintain

// 3. Relative imports (only for same-directory or sibling files)
import { helper } from './helper'
import type { User } from './types'

// 4. Style imports
// Tailwind CSS project:
import 'virtual:uno.css'  // UnoCSS
import 'virtual:tailwind.css'  // Tailwind

// Non-Tailwind project (CSS Modules):
import styles from './styles.module.css'  // CSS
import styles from './styles.module.scss'  // SCSS
import styles from './styles.module.less'  // Less

// Global styles (if needed):
import './global.css'
```

### Path Alias Preference

**When your project has configured path aliases (e.g., `@/`), always prefer aliases over relative paths for cross-directory imports.**

```ts
// ✅ CORRECT - Use path alias
import { formatDate } from '@/utils/date'
import { UserCard } from '@/components/UserCard'

// ❌ WRONG - Relative paths for cross-directory
import { formatDate } from '../../utils/date'

// ✅ ACCEPTABLE - Relative paths for same/sibling directory
import { helper } from './helper'
```

**Benefits**: Readability, maintainability, portability, cleaner code, framework support (Vite, Next.js, Nuxt).

### File Structure Pattern

```ts
// Top to bottom:
// 1. Imports
// 2. Type definitions (Props named as [ComponentName]Props)
// 3. Constants
// 4. Main export (component/function/class)
// 5. Helper functions (if not exported)

import { useState } from 'react'

interface CounterProps {
  title: string
  initialCount?: number
}

const DEFAULT_COUNT = 0

export function Counter(props: CounterProps) {
  const { title, initialCount = DEFAULT_COUNT } = props
  const [count, setCount] = useState(initialCount)
  return <div>{title}: {count}</div>
}

// Private helpers
function formatCount(count: number): string {
  return count.toString().padStart(2, '0')
}
```

## Formatting Preferences

### General Rules
- **Semicolons**: No semicolons (let linter handle it)
- **Quotes**: Single quotes for strings, double quotes for JSX
- **Trailing commas**: Always (ES2017+)
- **Max line length**: 100 characters
- **Indentation**: 2 spaces
- **End of line**: LF (Unix-style)

### TypeScript Specific
- **Type vs Interface**: Use `interface` for object shapes (extensible), `type` for unions/intersections/tuples
- **Function return types**: Optional — only declare when necessary (type inference fails, complex logic, or public API clarity)
- **Avoid `any`**: Use `unknown` if type is truly unknown
- **Generics**: Prefer explicit generic constraints

```ts
// ✅ Good
interface User {
  id: string
  name: string
}

type Status = 'pending' | 'success' | 'error'

// Return type optional (TypeScript infers it)
export function UserCard(props: UserCardProps) {
  const { user, onDelete } = props
  return <div>{user.name}</div>
}

// When return type IS necessary - complex logic or public API
function transformData<T, R>(data: T[], transformer: (item: T) => R): R[] {
  return data.map(transformer)
}

// ❌ Bad
const getUser = (id: any): any => { }
```

## Vue-Specific Conventions

### Preferences (from `vue` skill)

> See [`vue` skill](skills/vue/SKILL.md) for full details.

- **Always use Composition API** with `<script setup lang="ts">`
- **Use `defineProps` / `defineEmits`** for props and emits — access via `props.xxx` and `emit('event')`
  - This is Vue syntax-level convention, completely different from React's function parameter destructuring rules — no conflict exists
- **Use `shallowRef` over `ref`** when you don't need deep reactivity (better performance for large objects/arrays)
- **`readonly` on composable return values** is optional defensive practice — wrap state when you want to prevent accidental mutation by consumers
- **Pinia stores**: Use `use` prefix — `useUserStore.ts` (same as composables), store files colocate with features when using feature-based organization

### Component Structure

```vue
<script setup lang="ts">
// 1. Imports
import { ref, computed, onMounted } from 'vue'

// 2. Props & Emits (❌ Avoid destructuring — breaks reactivity)
const props = defineProps<{
  title: string
  count?: number
}>()

const emit = defineEmits<{
  update: [value: string]
}>()

// 3. Reactive state
const count = ref(props.count ?? 0)

// 4. Computed
const doubled = computed(() => count.value * 2)

// 5. Watchers
watch(() => props.title, (newVal) => {
  console.log('Title changed:', newVal)
})

// 6. Lifecycle
onMounted(() => {
  console.log('Mounted')
})

// 7. Methods
function increment() {
  count.value++
  emit('update', count.value.toString())
}
</script>

<template>
  <div class="counter">
    <h2>{{ title }}</h2>
    <p>Count: {{ count }}, Doubled: {{ doubled }}</p>
    <button @click="increment">Increment</button>
  </div>
</template>
```

### Composables Pattern

```ts
// useCounter.ts
import { ref, computed, shallowRef, readonly } from 'vue'

interface UseCounterOptions {
  initial?: number
  min?: number
  max?: number
}

export function useCounter(options: UseCounterOptions = {}) {
  const { initial = 0, min, max } = options

  // Prefer shallowRef for large objects/arrays
  const count = shallowRef(initial)
  const doubled = computed(() => count.value * 2)
  
  function increment() {
    if (max === undefined || count.value < max) count.value++
  }
  
  return {
    count: readonly(count),
    doubled,
    increment,
    decrement: () => { if (min === undefined || count.value > min) count.value-- },
    reset: () => { count.value = initial },
  }
}
```

## React-Specific Conventions

### Import Style

**Always use destructured imports from React, never use `React.xxx` namespace access.**

```tsx
// ✅ Good - Destructured imports
import { useState, useEffect, useCallback, useMemo } from 'react'
import type { ReactNode, CSSProperties } from 'react'

// ❌ Bad - Namespace access
import React from 'react'
const [count, setCount] = React.useState(0)
const element: React.ReactNode = null
```

**Benefits**: Cleaner code, modern patterns, easier dependency tracking.

**Note**: Whether `import React from 'react'` is needed depends on:
- React 17+ with new JSX transform: not required
- ESLint `react/react-in-jsx-scope` rule: off = not required, on = required

### Component Structure

```tsx
'use client' // Only if needed

import { useState, useMemo, useCallback } from 'react'

interface CounterProps {
  title: string
  initialCount?: number
  onUpdate?: (value: number) => void
}

export function Counter(props: CounterProps) {
  const { title, initialCount = 0, onUpdate } = props
  
  const [count, setCount] = useState(initialCount)
  const doubled = useMemo(() => count * 2, [count])
  
  const increment = useCallback(() => {
    setCount(prev => prev + 1)
  }, [])
  
  return (
    <div className="counter">
      <h2>{title}</h2>
      <p>Count: {count}, Doubled: {doubled}</p>
      <button onClick={increment}>Increment</button>
    </div>
  )
}
```

### Custom Hooks Pattern

```ts
// useCounter.ts
import { useState, useCallback, useMemo } from 'react'

interface UseCounterOptions {
  initial?: number
  min?: number
  max?: number
}

export function useCounter(options: UseCounterOptions = {}) {
  const { initial = 0, min, max } = options
  
  const [count, setCount] = useState(initial)
  
  const canIncrement = useMemo(() => max === undefined || count < max, [count, max])
  const canDecrement = useMemo(() => min === undefined || count > min, [count, min])
  
  const increment = useCallback(() => {
    setCount(prev => max !== undefined ? Math.min(prev + 1, max) : prev + 1)
  }, [max])
  
  const decrement = useCallback(() => {
    setCount(prev => min !== undefined ? Math.max(prev - 1, min) : prev - 1)
  }, [min])
  
  return {
    count,
    doubled: count * 2,
    canIncrement,
    canDecrement,
    increment,
    decrement,
    reset: useCallback(() => setCount(initial), [initial]),
  }
}
```

## Naming Conventions

### Function Parameters

**All functions should use object parameters and destructure in the function body.**

> ⚠️ **Scope**: React components, hooks, utility functions. **Not applicable to Vue `<script setup>`** (uses `defineProps()` / `defineEmits()` macros). Vue composables and regular functions still apply this rule.

#### Mandatory Rules

1. **NEVER destructure in parameter list** - Accept full object as parameter
2. **Destructuring MUST be the first statement** - Right after function declaration

```ts
// ✅ CORRECT - Accept full object, destructure as first statement
export function Button(props: ButtonProps) {
  const { variant, size, onClick, children } = props  // ← First line
  
  const handleClick = useCallback(() => { onClick?.() }, [onClick])
  return <button onClick={handleClick}>{children}</button>
}

export function useAuth(options: UseAuthOptions = {}) {
  const { redirectUrl = '/dashboard', onLogin } = options  // ← First line
  // hook implementation
}

// ❌ FORBIDDEN - Destructuring in parameter list
export function Button({ variant, size, onClick, children }: ButtonProps) { }

// ❌ WRONG - Destructuring is NOT first
export function Button(props: ButtonProps) {
  const handleClick = useCallback(() => { }, [])
  const { variant, size, onClick, children } = props  // ← Too late!
  return <button>{children}</button>
}
```

**Why these rules?**
- **Readability** - Clear separation between signature and implementation
- **Consistency** - Same pattern across all function types
- **Debugging** - Can log entire `props` or `options` object easily

#### Type Naming Convention

| Function Type | Type Suffix | Example |
|--------------|-------------|---------|
| Component | `Props` | `ButtonProps` |
| Hook / Composable | `Options` | `UseAuthOptions` |
| Utility / Factory function | `Options` | `FormatDateOptions`, `CreateUserOptions` |
| Data transfer (required fields) | `Data` / `Input` | `CreateUserData`, `LoginInput` |

> `Params` is reserved for **route params only** (e.g. `RouteParams`, `useRoute().params`) to avoid semantic confusion.

#### Why Object Parameters?

**Never use positional parameters.** Always use a single object parameter with a separately declared type.

```ts
// ❌ FORBIDDEN - Multiple positional parameters (breaking change when adding params)
formatDate(date, 'en', 'YYYY-MM-DD', undefined, true)

// ✅ REQUIRED - Single object parameter (backward compatible)
formatDate({ date, locale: 'en', format: 'YYYY-MM-DD', showRelative: true })
```

#### Complete Examples

```ts
// ✅ Components - Props suffix
interface ButtonProps {
  variant?: 'primary' | 'secondary'
  size?: 'sm' | 'md' | 'lg'
  onClick?: () => void
  children: ReactNode
}

export function Button(props: ButtonProps) {
  const { variant = 'primary', size = 'md', onClick, children } = props
  return <button onClick={onClick}>{children}</button>
}

// ✅ Hooks / Composables - Options suffix
export function useAuth(options: UseAuthOptions = {}) {
  const { redirectUrl = '/dashboard', onLogin } = options
  // hook implementation
}

// ✅ Utility functions - Options suffix (date as required field)
export function formatDate(options: FormatDateOptions) {
  const { date, locale = 'en', format = 'YYYY-MM-DD' } = options
  // function implementation
}

// ✅ Data transfer (all required) - Data suffix
export function createUser(data: CreateUserData): Promise<User> { }

// ❌ Avoid - positional parameters
export function formatDate(date: Date, locale: string, format: string) { }
```

### Variables & Functions
```ts
// Booleans: is/has/should/can prefix
const isLoading = true
const hasPermission = false
const shouldUpdate = true
const canEdit = false

// Event handlers: handle prefix
function handleClick() { }
function handleSubmit(event: FormEvent) { }

// Callbacks: on prefix (for props)
interface ComponentProps {
  onClick?: () => void
  onSubmit?: (data: FormData) => void
  onChange?: (value: string) => void
}

// Getters: get prefix (for functions that return)
function getUser(id: string): User { }
function formatDate(date: Date): string { }
```

### Constants
```ts
// UPPER_SNAKE_CASE for true constants
const MAX_RETRY_COUNT = 3
const API_BASE_URL = 'https://api.example.com'
const DEFAULT_TIMEOUT = 5000

// camelCase for config objects
const defaultConfig = {
  timeout: 5000,
  retries: 3,
}
```

## Comments Guidelines

### When to Comment
- **Why** not **what**: Explain reasoning, not obvious code
- **Complex algorithms**: Brief explanation of approach
- **Workarounds**: Why the workaround is needed
- **TODOs**: With context and ideally issue reference

### Comment Format
```ts
// ✅ Good - explains WHY
// Using shallowRef because we only need to track the reference,
// not deep reactivity. This improves performance for large objects.
const data = shallowRef<LargeDataset>()

// ❌ Bad - explains WHAT (obvious)
// Increment count by 1
count++

// TODO with context
// TODO: Replace with GraphQL query once backend supports it
// See: https://github.com/org/project/issues/123
const data = await fetch('/api/data')

// @ts-expect with explanation
// @ts-expect-error - API returns inconsistent types, handled at runtime
const result = unsafeOperation()
```

## Key Points

### Styling Strategy
- **New Projects**: Tailwind CSS - single file components, no separate style files
- **Existing Projects (Less/SCSS)**: Component folders - `ComponentName/index.tsx` + `ComponentName/index.less`
- **Don't mix approaches**: Stick to one styling strategy per project

### File Naming
- **React components MUST be PascalCase** - `<my-component />` will be treated as HTML tag
- **Vue components SHOULD be PascalCase** - Official recommendation, better IDE support
- **Functions/hooks use camelCase** - They are functions, not components
- **Config files use kebab-case** - Industry standard (`vite.config.ts`, `eslint.config.js`)
- **Routes use kebab-case** - Maps to URL paths (`/user-profile`)

### Compound Components Pattern (React)

When a component has sub-components, use **directory structure with type extension**:

```
components/
└── Form/
    ├── index.tsx              # Re-export all public APIs
    ├── Form.tsx               # Main component
    ├── FormItem.tsx           # Sub-component (exported)
    ├── FormButton.tsx         # Sub-component (exported)
    └── useFormContext.ts      # Shared hook (internal)
```

```tsx
// Form/index.tsx - Re-export all public APIs
export { Form } from './Form'
export { FormItem } from './FormItem'
export { FormButton } from './FormButton'
```

```tsx
// Form/FormItem.tsx
import type { ReactNode } from 'react'

interface FormItemProps {
  label: string
  children: ReactNode
}

export function FormItem(props: FormItemProps) {
  const { label, children } = props
  return <div className="form-item"><label>{label}</label>{children}</div>
}
```

```tsx
// Form/FormButton.tsx
import type { ReactNode } from 'react'

interface FormButtonProps {
  type?: 'submit' | 'reset'
  children: ReactNode
}

export function FormButton(props: FormButtonProps) {
  const { type = 'submit', children } = props
  return <button type={type}>{children}</button>
}
```

```tsx
// Form/Form.tsx - Main component with type extension
import type { ReactNode, FC } from 'react'
import { FormItem, FormButton } from './index'

interface FormProps {
  onSubmit: (data: FormData) => void
  children: ReactNode
}

function FormImpl(props: FormProps) {
  const { onSubmit, children } = props
  return <form onSubmit={onSubmit}>{children}</form>
}

// Extend type and mount sub-components
interface FormComponent extends FC<FormProps> {
  Item: typeof FormItem
  Button: typeof FormButton
}

const Form = FormImpl as FormComponent
Form.Item = FormItem
Form.Button = FormButton

export { Form }
```

**Key Points:**
- **Always use `function` declaration** for components (never `FC`)
- **Use `interface extends FC`** for type extension (import `FC` from React)
- **Use `typeof ComponentName`** for sub-component types
- **Mount sub-components** after type extension
- **Re-export** sub-components for independent usage

**Usage Examples:**

```tsx
// Usage - Compound style
import { Form } from '@/components/Form'

function UserForm() {
  return (
    <Form onSubmit={handleSubmit}>
      <Form.Item label="Name"><input name="name" /></Form.Item>
      <Form.Button>Submit</Form.Button>
    </Form>
  )
}

// Usage - Independent style
import { Form, FormItem, FormButton } from '@/components/Form'

function UserForm() {
  return (
    <Form onSubmit={handleSubmit}>
      <FormItem label="Name"><input name="name" /></FormItem>
      <FormButton>Submit</FormButton>
    </Form>
  )
}
```

**Handling Functions in Component Files:**

| Function Type | Location | Example |
|--------------|----------|---------|
| Tightly coupled to component state | Inline in component | `handleFieldChange`, `handleSubmit` |
| Uses component-specific context | Inline in component | `transformUserData`, `getInitialValues` |
| Pure utility, no dependencies | Extract to `.ts` file | `validateForm`, `formatDate`, `calculateTotal` |
| Reusable across components | Extract to `utils/` or `lib/` | `apiRequest`, `storage`, `analytics` |
| Component-specific but complex | Extract to same folder | `useFormContext.ts`, `formHelpers.ts` |

**Key Principles:**
1. **Default inline** - Keep functions in component by default
2. **Auto-extract reusable** - AI should automatically extract pure functions with generic names
3. **Keep context-bound** - Functions that use component state, props, or hooks should stay inline

### General
- Consistency within a project is more important than following every rule
- Use linter and formatter to enforce style automatically
- Prefer explicit over implicit (types, return values)
- Keep files focused - split when they grow too large (>300 lines)
- Use meaningful names - avoid abbreviations unless widely known

### React Import Style
- **Always use destructured imports** from React (`import { useState } from 'react'`)
- **Never use `React.xxx` namespace** access (`React.useState`, `React.ReactNode`)
- Applies to both **hooks** (`useState`, `useEffect`) and **types** (`ReactNode`, `FormEvent`)
- Whether `import React from 'react'` is needed depends on ESLint config and React version:
  - React 17+ with new JSX transform: not required
  - ESLint `react/react-in-jsx-scope` rule: off = not required, on = required
