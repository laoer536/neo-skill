---
name: coding-style
description: Neo's coding style and formatting conventions for Vue and React projects
---

# Coding Style

## File Naming Decision Tree

When naming files, follow this decision tree:

```
What type of file is this?
├─ Component (UI)
│  ├─ New project (Tailwind CSS)? → PascalCase.tsx/vue (single file)
│  └─ Existing project (Less/SCSS)?
│     ├─ Vue? → ComponentName/index.vue + ComponentName/index.less
│     └─ React? → ComponentName/index.tsx + ComponentName/index.less
│
├─ Function
│  ├─ Composable/Hook? → camelCase with 'use' prefix (useAuth.ts)
│  ├─ Utility function? → camelCase (formatDate.ts)
│  └─ API function? → camelCase (fetchUsers.ts)
│
├─ Type/Interface
│  ├─ Component-specific? → Inline in component file (props, state types)
│  ├─ Single shared type? → PascalCase.types.ts (User.types.ts) or types.ts
│  └─ Multiple types? → types.ts or index.ts in types/ directory
│
├─ Config
│  └─ Framework/tool config? → kebab-case.config.ext (vite.config.ts)
│
├─ Page/Route
│  └─ Maps to URL? → kebab-case (user-profile.vue)
│
└─ Test
   └─ Testing source file? → source-file.test.ts (UserCard.test.tsx)
```

## Styling Strategy Decision

**Before creating components, determine the styling approach:**

```
Is this a new or existing project?
├─ New Project → Use Tailwind CSS
│  └─ Single file components with utility classes
│     └── UserCard.tsx (no separate style file)
│
└─ Existing Project (already using Less/SCSS) → Use Component Folders
   └─ Component folder with dedicated style file
      └── UserCard/
          ├── index.tsx
          └── index.less
```

## File Naming Conventions

### Why Mixed Naming Strategy?

We use different naming conventions based on file type and framework requirements:

- **PascalCase for components**: React **requires** PascalCase to distinguish components from HTML elements. Vue also recommends it.
- **camelCase for functions**: Composables, hooks, and utilities are functions, following JavaScript conventions.
- **kebab-case for config & routes**: Industry standard for config files and URL-friendly routes.

### Styling Approach: New vs Existing Projects

**New Projects - Tailwind CSS (Recommended)**
- Use single file components with Tailwind utility classes
- No separate style files needed
- Cleaner file structure, faster development

```bash
# ✅ New Project Structure (Tailwind CSS)
components/
├── UserCard.tsx          # Single file with Tailwind classes
├── UserProfile.vue       # Single file with Tailwind classes
└── Button.tsx            # No separate .less/.scss file
```

**Existing Projects - Less/SCSS**
- Use component folders with dedicated style files
- Maintains consistency with existing codebase
- Better for complex, custom styles

```bash
# ✅ Existing Project Structure (Less/SCSS)
components/
├── UserCard/
│   ├── index.tsx         # Component
│   └── index.less        # Component styles
└── UserProfile/
    ├── index.vue         # Component
    └── index.scss        # Component styles
```

### Vue Projects

**New Project (Tailwind CSS):**
- **Components**: PascalCase - `MyComponent.vue` (single file)
- **Styles**: Inline Tailwind classes in template

**Existing Project (Less/SCSS):**
- **Components**: PascalCase - `MyComponent.vue` or `ComponentName/index.vue`
- **Styles**: `ComponentName/index.less` or `ComponentName/index.scss`

**Common:**
- **Composables**: camelCase with `use` prefix - `useAuth.ts`
- **Stores**: camelCase with `use` prefix - `useUserStore.ts`
- **Pages**: kebab-case for routes - `user-profile.vue`
- **Utils**: camelCase - `formatDate.ts`

### React Projects

**New Project (Tailwind CSS):**
- **Components**: PascalCase - `MyComponent.tsx` (single file)
- **Styles**: Inline Tailwind classes with `className`

**Existing Project (Less/SCSS):**
- **Components**: PascalCase - `MyComponent.tsx` or `ComponentName/index.tsx`
- **Styles**: `ComponentName/index.less` or `ComponentName/index.scss`

**Common:**
- **Hooks**: camelCase with `use` prefix - `useAuth.ts`
- **Pages**: kebab-case for routes (Next.js) - `user-profile/page.tsx`
- **Utils**: camelCase - `formatDate.ts`
- **Types**: PascalCase - `UserType.ts` or in `types.ts`

### Shared Rules
- **Config files**: kebab-case or dotfile - `eslint.config.js`, `.env.local`
- **Test files**: `.test.ts` or `.spec.ts` alongside source - `UserCard.test.tsx`
- **Type definitions**: `types.ts` or `*.types.ts` - `User.types.ts` (avoids component name conflicts)

### Naming Convention Quick Reference

| File Type | Convention | Example | Reason |
|-----------|-----------|---------|--------|
| **Vue Component** | PascalCase | `MyComponent.vue` | Vue recommended |
| **React Component** | PascalCase (Required) | `MyComponent.tsx` | React requires it |
| **Component Folder** | PascalCase | `UserCard/index.tsx` | Folder name matches component |
| **Component Styles** | `index.less/scss` | `UserCard/index.less` | Auto-import with folder |
| **Composable/Hook** | camelCase + `use` prefix | `useAuth.ts` | It's a function |
| **Utility Function** | camelCase | `formatDate.ts` | JavaScript convention |
| **Type/Interface** | PascalCase + `.types.ts` or `types.ts` | `User.types.ts` or `types.ts` | Avoids component conflicts |
| **Class** | PascalCase | `UserService.ts` | TypeScript convention |
| **Config File** | kebab-case | `vite.config.ts` | Industry standard |
| **Page/Route** | kebab-case | `user-profile.vue` | URL-friendly |
| **Test File** | `.test.ts` suffix | `UserCard.test.tsx` | Clear association |
| **Constant File** | camelCase or kebab-case | `constants.ts` or `api-urls.ts` | Both acceptable |
| **React Import** | Destructured | `import { useState } from 'react'` | No `React.xxx` namespace |

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

// 4. Side-effect imports (rare)
import 'uno.css'
import './styles.css'
```

### Path Alias Preference

**When your project has configured path aliases (e.g., `@/` in tsconfig/vite.config), always prefer aliases over relative paths.**

```ts
// ✅ CORRECT - Use path alias for cross-directory imports
import { formatDate } from '@/utils/date'
import { UserCard } from '@/components/UserCard'
import { useAuth } from '@/hooks/useAuth'
import type { User } from '@/types'

// ❌ WRONG - Use relative paths for cross-directory imports
import { formatDate } from '../../utils/date'
import { UserCard } from '../components/UserCard'
import { useAuth } from '../../hooks/useAuth'
import type { User } from '../../types'

// ✅ ACCEPTABLE - Relative paths for same directory or siblings
import { helper } from './helper'              // Same directory
import { types } from '../types'               // Sibling directory
```

**Why prefer path aliases?**
1. **Readability** - Clear and consistent import paths regardless of file location
2. **Maintainability** - No need to recalculate `../` when moving files
3. **Portability** - Easy to copy/move components without breaking imports
4. **Cleaner code** - Avoids deeply nested relative paths like `../../../`
5. **Framework support** - Vite, Next.js, Nuxt all support path aliases out of the box

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
- **Type vs Interface**: 
  - Use `interface` for object shapes (extensible)
  - Use `type` for unions, intersections, tuples, mapped types
- **Function return types**: NOT mandatory for any function type (hooks, regular functions, or function components) — only declare when necessary (e.g., type inference fails, complex logic, or public API clarity)
- **Avoid `any`**: Use `unknown` if type is truly unknown
- **Generics**: Prefer explicit generic constraints

```ts
// ✅ Good - Return type can be omitted (TypeScript infers it)
interface User {
  id: string
  name: string
  email: string
}

type Status = 'pending' | 'success' | 'error'

// Component - return type optional
export function UserCard(props: UserCardProps) {
  const { user, onDelete } = props
  return <div>{user.name}</div>
}

// Hook - return type optional
export function useAuth(options: UseAuthOptions = {}) {
  const { redirectUrl = '/dashboard' } = options
  const [user, setUser] = useState<User | null>(null)
  return { user, setUser }
}

// Regular function - return type optional
function formatDate(date: Date, options: FormatDateOptions = {}) {
  const { locale = 'en' } = options
  return new Intl.DateTimeFormat(locale).format(date)
}

// ✅ When return type IS necessary - complex logic or public API
function transformData<T, R>(data: T[], transformer: (item: T) => R): R[] {
  return data.map(transformer)
}

// ❌ Bad
const getUser = (id: any): any => {
  // ...
}
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
import { useRoute } from 'vue-router'

// 2. Props & Emits
// ❌ Avoid destructuring props — it breaks reactivity
// const { title, count } = defineProps<...>()  // Wrong!
const props = defineProps<{
  title: string
  count?: number
}>()

const emit = defineEmits<{
  update: [value: string]
  reset: []
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

<style scoped>
.counter {
  padding: 1rem;
}
</style>
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

  // Prefer shallowRef for large objects/arrays (deep reactivity not needed here)
  const count = shallowRef(initial)
  
  const doubled = computed(() => count.value * 2)
  
  function increment() {
    if (max === undefined || count.value < max) {
      count.value++
    }
  }
  
  function decrement() {
    if (min === undefined || count.value > min) {
      count.value--
    }
  }
  
  function reset() {
    count.value = initial
  }
  
  return {
    // readonly() prevents consumers from mutating internal state directly
    count: readonly(count),
    doubled,
    increment,
    decrement,
    reset,
  }
}
```

## React-Specific Conventions

### Import Style

**Always use destructured imports from React, never use `React.xxx` namespace access.**

This applies to both React hooks and React types:

```tsx
// ✅ Good - Destructured imports
import { useState, useEffect, useCallback, useMemo } from 'react'
import type { ReactNode, CSSProperties, FC } from 'react'

// ❌ Bad - Namespace access
import React from 'react'

const [count, setCount] = React.useState(0)  // Verbose
const element: React.ReactNode = null        // Unnecessary namespace
const style: React.CSSProperties = {}        // Unnecessary namespace
```

**Benefits:**
- Cleaner, more readable code
- Consistent with modern React patterns
- Easier to see what dependencies a file has
- No need for `import React from 'react'` in modern tooling

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
  
  const handleUpdate = useCallback(() => {
    onUpdate?.(count)
  }, [count, onUpdate])
  
  return (
    <div className="counter">
      <h2>{title}</h2>
      <p>Count: {count}, Doubled: {doubled}</p>
      <button onClick={increment}>Increment</button>
      <button onClick={handleUpdate}>Update</button>
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
  
  const canIncrement = useMemo(() => {
    return max === undefined || count < max
  }, [count, max])
  
  const canDecrement = useMemo(() => {
    return min === undefined || count > min
  }, [count, min])
  
  const increment = useCallback(() => {
    setCount(prev => max !== undefined ? Math.min(prev + 1, max) : prev + 1)
  }, [max])
  
  const decrement = useCallback(() => {
    setCount(prev => min !== undefined ? Math.max(prev - 1, min) : prev - 1)
  }, [min])
  
  const reset = useCallback(() => {
    setCount(initial)
  }, [initial])
  
  return {
    count,
    doubled: count * 2,
    canIncrement,
    canDecrement,
    increment,
    decrement,
    reset,
  }
}
```

## Naming Conventions

### Function Parameters

**All functions should use object parameters and destructure in the function body.**

#### ⚠️ Mandatory Rules

**Rule 1: NEVER destructure in parameter list**

> ⚠️ **Scope**: React components, hooks, utility functions. **Not applicable to Vue `<script setup>` components** (uses `defineProps()` / `defineEmits()` macros). Vue composables and regular functions still apply this rule.

Always accept the full object as a parameter, then destructure in the function body. **This applies to ALL function types:**
- Component functions (React/Vue)
- Hook / Composable functions
- Utility functions
- Event handlers
- Any function that accepts object parameters

```ts
// ✅ CORRECT - Components: Accept full object, destructure in body
export function Button(props: ButtonProps) {
  const { variant, size, onClick, children } = props  // ← Destructure here
  return <button onClick={onClick}>{children}</button>
}

// ✅ CORRECT - Hooks: Accept full object, destructure in body
export function useAuth(options: UseAuthOptions = {}) {
  const { redirectUrl = '/dashboard', onLogin } = options  // ← Destructure here
  // hook implementation
}

// ✅ CORRECT - Utility functions: Accept full object, destructure in body
export function formatDate(date: Date, options: FormatDateOptions = {}) {
  const { locale = 'en', format = 'YYYY-MM-DD' } = options  // ← Destructure here
  // function implementation
}

// ❌ FORBIDDEN - Components: Destructuring in parameter list
export function Button({ variant, size, onClick, children }: ButtonProps) {
  // This pattern is NOT allowed for components
  return <button onClick={onClick}>{children}</button>
}

// ❌ FORBIDDEN - Hooks: Destructuring in parameter list
export function useAuth({ redirectUrl, onLogin }: UseAuthOptions) {
  // This pattern is NOT allowed for hooks
  // hook implementation
}

// ❌ FORBIDDEN - Utility functions: Destructuring in parameter list
export function formatDate(date: Date, { locale, format }: FormatDateOptions) {
  // This pattern is NOT allowed for utility functions
  // function implementation
}
```

**Rule 2: Destructuring MUST be the first statement**

When destructuring parameters, it MUST be the first statement in the function body. This applies to:
- React component functions
- Hook / Composable functions
- Utility functions
- Event handlers
- Any function that accepts object parameters

> ⚠️ **Not applicable to Vue `<script setup>` components**: `defineProps()` / `defineEmits()` are Vue compiler macros. Vue composables and regular functions still apply this rule.

```ts
// ✅ CORRECT - Destructuring is the FIRST statement
export function Button(props: ButtonProps) {
  const { variant, size, onClick, children } = props  // ← First line
  
  // Other logic after
  const handleClick = useCallback(() => {
    onClick?.()
  }, [onClick])
  
  return <button onClick={handleClick}>{children}</button>
}

// ✅ CORRECT - Hooks follow the same rule
export function useAuth(options: UseAuthOptions = {}) {
  const { redirectUrl = '/dashboard', onLogin } = options  // ← First line
  
  // State and logic after
  const [user, setUser] = useState(null)
  // ...
}

// ✅ CORRECT - Utility functions too
export function formatDate(date: Date, options: FormatDateOptions = {}) {
  const { locale = 'en', format = 'YYYY-MM-DD' } = options  // ← First line
  
  // Implementation after
  return new Intl.DateTimeFormat(locale).format(date)
}

// ❌ WRONG - Destructuring is NOT first
export function Button(props: ButtonProps) {
  const handleClick = useCallback(() => {
    // Some logic
  }, [])
  
  const { variant, size, onClick, children } = props  // ← Too late!
  return <button>{children}</button>
}

// ❌ WRONG - Mixing destructuring with other statements
export function useAuth(options: UseAuthOptions = {}) {
  const [user, setUser] = useState(null)
  const { redirectUrl } = options  // ← Should be first!
  // ...
}
```

**Why these rules?**
1. **Readability** - Clear separation between signature and implementation
2. **Consistency** - Same pattern across all function types
3. **Maintainability** - Easy to find and modify parameter handling
4. **Code review** - Quick to understand function signature and usage
5. **Debugging** - Can log entire `props` or `options` object easily

#### Type Naming Convention

| Function Type | Type Suffix | Example |
|--------------|-------------|---------|
| Component | `Props` | `ButtonProps` |
| Hook / Composable | `Options` | `UseAuthOptions` |
| Utility / Factory function | `Options` | `FormatDateOptions`, `CreateUserOptions` |
| Data transfer (required fields) | `Data` / `Input` | `CreateUserData`, `LoginInput` |

> `Params` is reserved for **route params only** (e.g. `RouteParams`, `useRoute().params`) to avoid semantic confusion.

#### Why Object Parameters?

**This is a mandatory rule for function types** - React components, hooks, and utility functions.

> ⚠️ **Not applicable to Vue `<script setup>` components**: Uses `defineProps()` / `defineEmits()` macros. **Vue composables and regular functions still apply this rule.**

**Never use positional parameters.** Always use a single object parameter with a separately declared type. **The function should have only ONE parameter (the options object), keeping the parameter list singular.**

```ts
// ❌ FORBIDDEN - Multiple positional parameters (any function type)
formatDate(date, 'en', 'YYYY-MM-DD', undefined, true)
//             ↑    ↑         ↑           ↑      ↑ multiple parameters!

// ✅ REQUIRED - Single object parameter (all function types)
formatDate({ date, locale: 'en', format: 'YYYY-MM-DD', showRelative: true })
//          ← ONE object containing all parameters →
```

**Examples across all function types:**

```ts
// ✅ CORRECT - Components use object parameters
interface ButtonProps {
  variant?: 'primary' | 'secondary'
  size?: 'sm' | 'md' | 'lg'
  onClick?: () => void
  children: React.ReactNode
}

export function Button(props: ButtonProps) {  // ← Single object parameter
  const { variant = 'primary', size = 'md', onClick, children } = props
  return <button onClick={onClick}>{children}</button>
}

// ✅ CORRECT - Hooks use object parameters
interface UseAuthOptions {
  redirectUrl?: string
  onLogin?: (user: User) => void
}

export function useAuth(options: UseAuthOptions = {}) {  // ← Single object parameter
  const { redirectUrl = '/dashboard', onLogin } = options
  // hook implementation
}

// ✅ CORRECT - Utility functions use object parameters
interface FormatDateOptions {
  date: Date
  locale?: string
  format?: string
  timezone?: string
}

export function formatDate(options: FormatDateOptions) {  // ← Single object parameter
  const { date, locale = 'en', format = 'YYYY-MM-DD', timezone } = options
  // function implementation
}

// ❌ FORBIDDEN - Components with positional parameters
export function Button(variant: string, size: string, onClick: () => void) {
  // Multiple positional parameters are NOT allowed
}

// ❌ FORBIDDEN - Hooks with positional parameters
export function useAuth(redirectUrl: string, onLogin: (user: User) => void) {
  // Multiple positional parameters are NOT allowed
}

// ❌ FORBIDDEN - Utility functions with positional parameters
export function formatDate(date: Date, locale: string, format: string, timezone?: string) {
  // Multiple positional parameters are NOT allowed
  // Adding a new param forces all callers to update
}

// ❌ FORBIDDEN - Utility functions with mixed parameters (date + options object)
export function formatDate(date: Date, options: FormatDateOptions) {
  // Two parameters are NOT allowed - must be single object only
}
```

Adding a new parameter to a positional function is a **breaking change** for all callers. With object parameters, new optional fields are always backward compatible.

#### Examples

```ts
// ✅ Components - Props suffix
interface ButtonProps {
  variant?: 'primary' | 'secondary'
  size?: 'sm' | 'md' | 'lg'
  onClick?: () => void
  children: React.ReactNode
}

export function Button(props: ButtonProps) {
  const { variant = 'primary', size = 'md', onClick, children } = props
  return <button onClick={onClick}>{children}</button>
}

// ✅ Hooks / Composables - Options suffix
interface UseAuthOptions {
  redirectUrl?: string
  onLogin?: (user: User) => void
}

export function useAuth(options: UseAuthOptions = {}) {
  const { redirectUrl = '/dashboard', onLogin } = options
  // hook implementation
}

// ✅ Utility functions - Options suffix
interface FormatDateOptions {
  locale?: string
  format?: string
  timezone?: string
}

export function formatDate(date: Date, options: FormatDateOptions = {}) {
  const { locale = 'en', format = 'YYYY-MM-DD', timezone } = options
  // function implementation
}

// ✅ Data transfer (all required) - Data suffix
interface CreateUserData {
  name: string
  email: string
  role: 'admin' | 'user'
}

export function createUser(data: CreateUserData): Promise<User> {
  // implementation
}

// ❌ Avoid - destructuring in parameter list
export function Button({ variant, size, onClick, children }: ButtonProps) {
  // Hard to read when many props
}

// ❌ Avoid - positional parameters
export function formatDate(date: Date, locale: string, format: string, timezone?: string) {
  // Adding a new param forces all callers to update
}
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

## Common Naming Mistakes

### ❌ React Components with kebab-case

```tsx
// ❌ WRONG - File: user-card.tsx
function userCard() {
  return <div>User Card</div>
}

// Usage in another file:
import userCard from './user-card'
// <userCard /> ❌ React treats this as HTML tag, not component!

// ✅ CORRECT - File: UserCard.tsx
function UserCard() {
  return <div>User Card</div>
}

// Usage:
import UserCard from './UserCard'
// <UserCard /> ✅ React recognizes this as component
```

### ❌ Inconsistent Type Naming

```ts
// ❌ WRONG - File name conflicts with component
// File: User.tsx (component)
// File: User.ts (type) - Conflict or confusing!

import type { User } from './User'  // Which User? The type or component?

// ✅ CORRECT - Option 1: Use .types.ts suffix
// File: User.types.ts
export type User = { id: string }

import type { User } from './User.types'  // Clear it's a type

// ✅ CORRECT - Option 2: Inline in component (preferred for component-specific types)
// File: UserCard.tsx
interface UserCardProps {
  user: { id: string; name: string }  // Inline type
}

// ✅ CORRECT - Option 3: Centralize types
// File: types.ts
export type User = { id: string }
export type Product = { id: string }

import type { User, Product } from './types'  // Clean
```

### ❌ Hooks Without `use` Prefix

```ts
// ❌ WRONG - Missing 'use' prefix
// File: auth.ts
export function auth() {  // Not clear it's a hook
  const [user, setUser] = useState(null)
  return { user, setUser }
}

// ✅ CORRECT - With 'use' prefix
// File: useAuth.ts
export function useAuth() {  // Clear it's a hook
  const [user, setUser] = useState(null)
  return { user, setUser }
}
```

### ✅ Correct Examples by File Type

```bash
# ===== NEW PROJECTS (Tailwind CSS) =====
# Single file components with Tailwind utility classes

components/
├── UserCard.tsx          ✅ React + Tailwind
├── UserProfile.vue       ✅ Vue + Tailwind
├── Button.tsx            ✅ No separate style file
└── layouts/
    └── DashboardLayout.tsx  ✅ Tailwind classes inline

# ===== EXISTING PROJECTS (Less/SCSS) =====
# Component folders with dedicated style files

components/
├── UserCard/
│   ├── index.tsx         ✅ React component
│   └── index.less        ✅ Component styles
├── UserProfile/
│   ├── index.vue         ✅ Vue component
│   └── index.scss        ✅ Component styles
└── layouts/
    └── DashboardLayout/
        ├── index.tsx     ✅ Layout component
        └── index.less    ✅ Layout styles

# Hooks/Composables (camelCase with 'use' prefix)
hooks/ or composables/
├── useAuth.ts            ✅ Custom hook
├── useUsers.ts           ✅ Data fetching hook
└── useLocalStorage.ts    ✅ Utility hook

# Utilities (camelCase)
utils/
├── formatDate.ts         ✅ Utility function
├── validateEmail.ts      ✅ Validation function
└── api-client.ts         ✅ API client (kebab-case also OK)

# Types (PascalCase.types.ts or centralized)
types/
├── User.types.ts         ✅ Single type (with .types suffix)
├── index.ts              ✅ Re-export all types
# OR
types.ts                  ✅ Centralized types

# Config (kebab-case)
├── vite.config.ts        ✅ Vite config
├── eslint.config.js      ✅ ESLint config
└── tailwind.config.ts    ✅ Tailwind config

# Routes/Pages (kebab-case - URL friendly)
pages/ or app/
├── user-profile.vue      ✅ → /user-profile
├── user-settings/
│   └── page.tsx          ✅ → /user-settings
└── [id].tsx              ✅ → /:id (dynamic route)
```

## Key Points

### Styling Strategy
- **New Projects**: Use Tailwind CSS - single file components, no separate style files
- **Existing Projects (Less/SCSS)**: Use component folders - `ComponentName/index.tsx` + `ComponentName/index.less`
- **Don't mix approaches**: Stick to one styling strategy per project
- **Consistency is crucial**: Follow the existing project's pattern

### File Naming
- **React components MUST be PascalCase** - `<my-component />` will be treated as HTML tag
- **Vue components SHOULD be PascalCase** - Official recommendation, better IDE support
- **Component folders use PascalCase** - `UserCard/index.tsx` not `user-card/index.tsx`
- **Component styles use `index.less/scss`** - Enables clean imports: `import './index.less'`
- **Functions/hooks use camelCase** - They are functions, not components
- **Config files use kebab-case** - Industry standard (`vite.config.ts`, `eslint.config.js`)
- **Routes use kebab-case** - Maps to URL paths (`/user-profile`)

### Component Folder Pattern (Less/SCSS Projects Only)
- Use when component needs dedicated styles (Less/SCSS)
- Folder name matches component name (PascalCase)
- Main component file is `index.tsx` or `index.vue`
- Styles file is `index.less` or `index.scss`
- Import from folder: `import UserCard from '@/components/UserCard'`

### Compound Components Pattern (React)

When a component has sub-components or related functions, use one of these patterns:

**Pattern A: Compound Components (Recommended for tightly-coupled sub-components)**

Use when sub-components are always used together and share context:

```tsx
// Form.tsx
import { createContext, useContext, type ReactNode } from 'react'

// 1. Define props interfaces
interface FormProps {
  onSubmit: (data: FormData) => void
  children: ReactNode
}

interface FormItemProps {
  label: string
  children: ReactNode
}

interface FormButtonProps {
  type?: 'submit' | 'reset'
  children: ReactNode
}

// 2. Main component
function Form(props: FormProps) {
  const { onSubmit, children } = props

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault()
  }

  return <form onSubmit={handleSubmit}>{children}</form>
}

// 3. Sub-components
function FormItem(props: FormItemProps) {
  const { label, children } = props
  return (
    <div className="form-item">
      <label>{label}</label>
      {children}
    </div>
  )
}

function FormButton(props: FormButtonProps) {
  const { type = 'submit', children } = props
  return <button type={type}>{children}</button>
}

// 4. Declaration Merging — tells TypeScript about static properties
namespace Form {
  export type ItemProps = FormItemProps
  export type ButtonProps = FormButtonProps
}

// 5. Attach sub-components
Form.Item = FormItem
Form.Button = FormButton

export { Form }

// Usage
import { Form } from '@/components/Form'

function UserForm() {
  return (
    <Form onSubmit={handleSubmit}>
      <Form.Item label="Name">
        <input name="name" />
      </Form.Item>
      <Form.Button>Submit</Form.Button>
    </Form>
  )
}
```

**Pattern B: Directory Structure (Recommended for independent sub-components)**

Use when sub-components can be used independently or have complex logic:

```
components/
└── Form/
    ├── index.tsx              # Main Form component
    ├── FormItem.tsx           # Sub-component (exported)
    ├── FormButton.tsx         # Sub-component (exported)
    ├── useFormContext.ts      # Shared hook (internal)
    └── types.ts               # Shared types (internal)
```

```tsx
// Form/index.tsx - Re-export all public APIs
export { Form } from './Form'
export { FormItem } from './FormItem'
export { FormButton } from './FormButton'

// Form/Form.tsx
import { FormItem, FormButton } from './index'
import type { ReactNode } from 'react'

interface FormProps {
  onSubmit: (data: FormData) => void
  children: ReactNode
}

export function Form(props: FormProps) {
  const { onSubmit, children } = props
  // implementation
}

// Attach sub-components for compound usage
Form.Item = FormItem
Form.Button = FormButton

// Form/FormItem.tsx - Can be used independently
interface FormItemProps {
  label: string
  children: ReactNode
}

export function FormItem(props: FormItemProps) {
  const { label, children } = props
  // implementation
}

// Usage - Option 1: Compound style
import { Form } from '@/components/Form'

<Form onSubmit={handleSubmit}>
  <Form.Item label="Name">
    <input />
  </Form.Item>
</Form>

// Usage - Option 2: Independent style
import { Form, FormItem, FormButton } from '@/components/Form'

<Form onSubmit={handleSubmit}>
  <FormItem label="Name">
    <input />
  </FormItem>
  <FormButton>Submit</FormButton>
</Form>
```

**Handling Functions in Component Files:**

Decide where to place functions based on their scope and reusability:

```
components/
└── UserForm/
    ├── index.tsx              # Main component
    ├── validateForm.ts        ✅ General utility (extracted)
    ├── formatFormData.ts      ✅ General utility (extracted)
    └── useFormContext.ts      ⚠️ Component-specific hook (may stay or extract)
```

**Rule 1: Component-specific helper functions → Keep inline**

Functions only used within the component and tightly coupled to its logic:

```tsx
// UserForm.tsx
import { useState, type FormEvent } from 'react'

interface UserFormProps {
  onSubmit: (data: UserData) => void
}

export function UserForm(props: UserFormProps) {
  const { onSubmit } = props
  const [formData, setFormData] = useState({})
  
  // ✅ Keep inline - tightly coupled to component state
  function handleFieldChange(field: string, value: string) {
    setFormData(prev => ({ ...prev, [field]: value }))
  }
  
  // ✅ Keep inline - uses component-specific context
  function handleSubmit(e: FormEvent) {
    e.preventDefault()
    onSubmit(transformFormData(formData))
  }
  
  return <form onSubmit={handleSubmit}>...</form>
}

// ❌ Private helper - only used by this component
function transformFormData(data: FormData): UserData {
  return { ...data, timestamp: Date.now() }
}
```

**Rule 2: General/reusable functions → Extract to separate file**

Functions with general utility that could be reused elsewhere:

```tsx
// validateForm.ts - Extracted general utility
interface ValidationRule {
  field: string
  validate: (value: any) => boolean
  message: string
}

export function validateForm(data: Record<string, any>, rules: ValidationRule[]) {
  const errors: Record<string, string> = {}
  
  for (const rule of rules) {
    if (!rule.validate(data[rule.field])) {
      errors[rule.field] = rule.message
    }
  }
  
  return {
    isValid: Object.keys(errors).length === 0,
    errors,
  }
}

export function sanitizeInput(input: string): string {
  return input.trim().replace(/[<>]/g, '')
}
```

```tsx
// UserForm.tsx - Import and use
import { validateForm, sanitizeInput } from './validateForm'
import { useState, type FormEvent } from 'react'

export function UserForm(props: UserFormProps) {
  const { onSubmit } = props
  
  function handleSubmit(e: FormEvent) {
    e.preventDefault()
    
    // Use extracted utilities
    const sanitizedData = Object.entries(formData).reduce(
      (acc, [key, value]) => ({ ...acc, [key]: sanitizeInput(value) }),
      {}
    )
    
    const validation = validateForm(sanitizedData, validationRules)
    
    if (validation.isValid) {
      onSubmit(sanitizedData)
    }
  }
  
  return <form onSubmit={handleSubmit}>...</form>
}
```

**Decision Guide for Functions:**

| Function Type | Location | Example |
|--------------|----------|---------|
| Tightly coupled to component state | Inline in component | `handleFieldChange`, `handleSubmit` |
| Uses component-specific context | Inline in component | `transformUserData`, `getInitialValues` |
| Pure utility, no dependencies | Extract to `.ts` file | `validateForm`, `formatDate`, `calculateTotal` |
| Reusable across components | Extract to `utils/` or `lib/` | `apiRequest`, `storage`, `analytics` |
| Complex transformation logic | Extract to separate file | `parseCSV`, `generateReport`, `mergeConfigs` |
| Component-specific but complex | Extract to same folder | `useFormContext.ts`, `formHelpers.ts` |

**Directory Structure Examples:**

```bash
# Simple component - all inline
components/
└── Button.tsx                    ✅ All logic in one file

# Component with general utilities
components/
└── UserForm/
    ├── index.tsx                 ✅ Component + inline helpers
    ├── validateForm.ts           ✅ General validation logic
    └── formatUserData.ts         ✅ General formatting logic

# Complex component with multiple concerns
components/
└── DataTable/
    ├── index.tsx                 ✅ Main component
    ├── DataTablePagination.tsx   ✅ Sub-component
    ├── DataTableFilters.tsx      ✅ Sub-component
    ├── useDataTable.ts           ✅ Component-specific hook
    ├── sortData.ts               ✅ General sorting utility
    └── filterData.ts             ✅ General filtering utility
```

**Key Principles:**

1. **Default inline** - Keep functions in component by default
2. **Auto-extract reusable** - AI should automatically extract functions that:
   - Are pure functions (no side effects, no component state/hooks)
   - Have generic names (not component-specific like `handleUserFormSubmit`)
   - Could logically be used in other components or contexts
   - Perform common operations (validation, formatting, calculation, transformation)
3. **Keep context-bound** - Functions that use component state, props, or hooks should stay inline
4. **Name clearly** - Extracted functions should have clear, self-documenting names

**Decision Guide:**

| Scenario | Pattern | Example |
|----------|---------|---------|
| Sub-components always used together | Pattern A (Compound) | `Form.Item`, `Menu.Item`, `Tabs.Tab` |
| Sub-components used independently | Pattern B (Directory) | `Modal`, `Modal.Header`, `Modal.Body` |
| Simple sub-components (no complex logic) | Pattern A | `Select.Option`, `Table.Column` |
| Complex sub-components (own hooks/types) | Pattern B | `DataTable`, `DataTable.Pagination`, `DataTable.Filters` |
| Need to export utility functions | Pattern B | `Form` + `useFormValidation` + `formatFormData` |

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
- Modern tooling doesn't require `import React from 'react'` anymore
