---
name: nextjs
description: Next.js 14/16 App Router - Server Components, Server Actions, Routing, Data Fetching, Deployment. Use when building Next.js applications with the App Router.
metadata:
  author: Neo
  version: "2026.04.09"
  source: Manual
---

# Next.js

> Supports Next.js 14+ and 16+. Check project's `package.json` to determine version.

## ⚠️ Version Selection Strategy

**ALWAYS check the project's Next.js version first and apply the corresponding patterns:**

1. **Next.js 16 project** → Use Next.js 16 patterns and optimizations exclusively
2. **Next.js 14 project** → Use Next.js 14 patterns, DO NOT use Next.js 16-specific features
3. **New project (no version constraint)** → Default to Next.js 16 best practices
4. **When in doubt** → Check `package.json` dependencies before proceeding

**High version takes precedence**: If the project supports multiple versions, prefer the higher version's patterns and APIs.

## Version Differences

### Next.js 16 (Latest) - PREFERRED WHEN AVAILABLE
- **Improved Server Components performance** - Faster rendering and smaller bundles
- **Enhanced Server Actions** - Better error handling, progressive enhancement
- **Better caching strategies** - Granular cache control, improved revalidation
- **Turbopack stable** - Faster development builds (use `next dev --turbo`)
- **Improved DevEx** - Better error messages, faster HMR
- **Partial Prerendering** (stable) - Hybrid static + dynamic rendering

**Example - Next.js 16 Enhanced Server Action:**
```tsx
'use server'

import { revalidatePath } from 'next/cache'

export async function updateUser(userId: string, data: FormData) {
  try {
    // Database update
    await db.user.update({
      where: { id: userId },
      data: { name: data.get('name') }
    })
    
    // Granular revalidation
    revalidatePath(`/users/${userId}`)
    
    return { success: true }
  } catch (error) {
    // Better error handling
    return { 
      success: false, 
      error: error instanceof Error ? error.message : 'Unknown error' 
    }
  }
}
```

### Next.js 14 (Stable) - USE WHEN PROJECT REQUIRES
- App Router with Server Components
- Server Actions (experimental → stable)
- Partial Prerendering (experimental)
- `next/font` optimization
- Basic fetch caching and revalidation

**Example - Next.js 14 Server Action:**
```tsx
'use server'

import { revalidatePath } from 'next/cache'

export async function updateUser(userId: string, formData: FormData) {
  // Basic implementation
  await db.user.update({
    where: { id: userId },
    data: { name: formData.get('name') }
  })
  
  revalidatePath(`/users/${userId}`)
  return { success: true }
}
```

## Preferences

- Use App Router (not Pages Router)
- Prefer Server Components by default, use 'use client' only when needed
- Use Server Actions for mutations instead of API routes
- Use TypeScript for all code
- Prefer static generation over SSR when possible

## Core

| Topic | Description | Reference |
|-------|-------------|-----------|
| App Router | File-based routing, layouts, templates, parallel routes | [core-app-router](references/core-app-router.md) |
| Server Components | RSC, Client Components, Server Actions, streaming | [core-server-components](references/core-server-components.md) |
| Data Fetching | fetch caching, revalidation, Server Actions, mutations | [core-data-fetching](references/core-data-fetching.md) |

## Features

| Topic | Description | Reference |
|-------|-------------|-----------|
| Routing | Dynamic routes, route groups, intercepting routes | [features-routing](references/features-routing.md) |
| Optimization | Image, Font, Script optimization, lazy loading | [features-optimization](references/features-optimization.md) |
| Middleware | Edge middleware, authentication, redirects | [features-middleware](references/features-middleware.md) |

## Best Practices

| Topic | Description | Reference |
|-------|-------------|-----------|
| Performance | Caching strategies, streaming, partial prerendering | [best-practices-performance](references/best-practices-performance.md) |
| SEO | Metadata, sitemaps, structured data, Open Graph | [best-practices-seo](references/best-practices-seo.md) |
| Deployment | Vercel, Docker, self-hosting, environment variables | [best-practices-deployment](references/best-practices-deployment.md) |

## Quick Reference

### Server Component (Default)

```tsx
// app/page.tsx
async function HomePage() {
  // Direct database/API calls in Server Component
  const data = await fetch('https://api.example.com/data', {
    next: { revalidate: 3600 } // Cache for 1 hour
  })
  
  return (
    <main>
      <h1>Server Component</h1>
      <pre>{JSON.stringify(data, null, 2)}</pre>
    </main>
  )
}

export default HomePage
```

### Client Component

```tsx
// app/components/counter.tsx
'use client'

import { useState } from 'react'

export function Counter() {
  const [count, setCount] = useState(0)
  
  return (
    <button onClick={() => setCount(count + 1)}>
      Count: {count}
    </button>
  )
}
```

### Server Action

```tsx
// app/actions.ts
'use server'

export async function createUser(formData: FormData) {
  const name = formData.get('name')
  // Database operations
  return { success: true }
}

// app/form.tsx
'use client'

import { createUser } from './actions'

export function Form() {
  return (
    <form action={createUser}>
      <input name="name" />
      <button type="submit">Create</button>
    </form>
  )
}
```

### Layout Pattern

```tsx
// app/layout.tsx
export const metadata = {
  title: 'My App',
  description: 'My Next.js App'
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}