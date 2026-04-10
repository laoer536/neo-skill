---
name: react
description: React 18/19 - Hooks, Components, Context, Suspense, Server Components. Use when writing React components, managing state with hooks, or implementing React patterns.
metadata:
  author: Neo
  version: "2026.04.09"
  source: Manual
---

# React

> Supports React 18+ and 19+. Check project's `package.json` to determine version.

## ⚠️ Version Selection Strategy

**ALWAYS check the project's React version first and apply the corresponding patterns:**

1. **React 19 project** → Use React 19 patterns and APIs exclusively
2. **React 18 project** → Use React 18 patterns, DO NOT use React 19 features
3. **New project (no version constraint)** → Default to React 19 best practices
4. **When in doubt** → Check `package.json` dependencies before proceeding

**High version takes precedence**: If the project supports multiple versions, prefer the higher version's patterns and APIs.

## Version Differences

### React 19 (Latest) - PREFERRED WHEN AVAILABLE
- **Actions**: Form actions with `useActionState`
- **use() hook**: Read resources and context directly
- **useOptimistic()**: Optimistic UI updates
- **useFormStatus()**: Form submission state tracking
- **useActionState()**: Form state management with pending state
- Server Components improvements
- Improved hydration and error boundaries

**Example - React 19 Form Pattern:**
```tsx
'use client'
import { useActionState } from 'react'

async function submitForm(prevState: any, formData: FormData) {
  // Server action logic
  return { success: true }
}

function MyForm() {
  const [state, formAction, isPending] = useActionState(submitForm, null)
  
  return (
    <form action={formAction}>
      <input name="email" />
      <button type="submit" disabled={isPending}>
        {isPending ? 'Submitting...' : 'Submit'}
      </button>
    </form>
  )
}
```

### React 18 (Stable) - USE WHEN PROJECT REQUIRES
- Concurrent features: `useTransition`, `useDeferredValue`
- Automatic batching
- Suspense for data fetching
- `createRoot` API
- Manual form handling with `useState` + `onSubmit`

**Example - React 18 Form Pattern:**
```tsx
'use client'
import { useState } from 'react'

function MyForm() {
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [error, setError] = useState<string | null>(null)
  
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsSubmitting(true)
    try {
      // Submit logic
    } catch (err) {
      setError('Submission failed')
    } finally {
      setIsSubmitting(false)
    }
  }
  
  return (
    <form onSubmit={handleSubmit}>
      <input name="email" />
      <button type="submit" disabled={isSubmitting}>
        {isSubmitting ? 'Submitting...' : 'Submit'}
      </button>
    </form>
  )
}
```

## Preferences

- Prefer TypeScript over JavaScript
- Prefer Functional Components over Class Components
- Use React Server Components (RSC) when applicable
- Prefer `const` arrow functions for components
- Use React Query / SWR for data fetching instead of useEffect

## Core

| Topic | Description | Reference |
|-------|-------------|-----------|
| Hooks | useState, useEffect, useContext, useMemo, useCallback, useRef, custom hooks | [core-hooks](references/core-hooks.md) |
| Components | Functional components, props, JSX, fragments, composition | [core-components](references/core-components.md) |
| State Management | Context, useReducer, state patterns, external state libs | [core-state](references/core-state.md) |

## Features

| Topic | Description | Reference |
|-------|-------------|-----------|
| Server Components | RSC, Server/Client components, streaming SSR | [features-server-components](references/features-server-components.md) |
| Suspense & Error Boundaries | Lazy loading, error handling, concurrent features | [features-suspense](references/features-suspense.md) |
| Performance | memo, useMemo, useCallback, code splitting, profiling | [features-performance](references/features-performance.md) |

## Best Practices

| Topic | Description | Reference |
|-------|-------------|-----------|
| Data Fetching | React Query, SWR, data patterns, caching | [best-practices-data-fetching](references/best-practices-data-fetching.md) |
| Testing | React Testing Library, hooks testing, patterns | [best-practices-testing](references/best-practices-testing.md) |

## Quick Reference

### Component Template

```tsx
import { useState, useEffect, useMemo } from 'react'

interface Props {
  title: string
  count?: number
  onUpdate?: (value: string) => void
}

const MyComponent: React.FC<Props> = ({ title, count = 0, onUpdate }) => {
  const [value, setValue] = useState('')
  
  const doubled = useMemo(() => count * 2, [count])
  
  useEffect(() => {
    console.log('Component mounted')
    return () => console.log('Component unmounted')
  }, [])
  
  return (
    <div>
      <h1>{title}</h1>
      <p>Count: {count}, Doubled: {doubled}</p>
    </div>
  )
}

export default MyComponent
```

### Key Hooks

```ts
// State
import { useState, useReducer } from 'react'

// Effects
import { useEffect, useLayoutEffect } from 'react'

// Context
import { useContext, createContext } from 'react'

// Performance
import { useMemo, useCallback, memo } from 'react'

// Refs
import { useRef, useImperativeHandle } from 'react'
```
