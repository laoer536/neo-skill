---
name: features-routing
description: Next.js routing - Dynamic routes, route groups, intercepting routes, redirects
---

# Routing

Advanced routing patterns in Next.js App Router.

## Dynamic Routes

### Single Parameter

```tsx
// app/users/[id]/page.tsx
export default function UserPage({ params }: { params: { id: string } }) {
  return <div>User ID: {params.id}</div>
}
// /users/123 → params.id = "123"
```

### Multiple Parameters

```tsx
// app/users/[id]/posts/[postId]/page.tsx
export default function UserPostPage({ 
  params 
}: { 
  params: { id: string; postId: string } 
}) {
  return (
    <div>
      User: {params.id}, Post: {params.postId}
    </div>
  )
}
```

### Catch-all Routes

```tsx
// app/docs/[...slug]/page.tsx
export default function DocsPage({ 
  params 
}: { 
  params: { slug: string[] } 
}) {
  return <div>Path: {params.slug.join('/')}</div>
}
// /docs/a/b/c → params.slug = ["a", "b", "c"]
```

### Optional Catch-all

```tsx
// app/products/[[...slug]]/page.tsx
export default function ProductsPage({ 
  params 
}: { 
  params: { slug?: string[] } 
}) {
  return <div>{params.slug?.join('/') || 'All Products'}</div>
}
// /products → params.slug = undefined
// /products/a/b → params.slug = ["a", "b"]
```

## Route Groups

### Organize Without Affecting URL

```
app/
├── (marketing)/
│   ├── layout.tsx
│   └── page.tsx          # /
│
├── (shop)/
│   ├── layout.tsx
│   └── page.tsx          # /shop
│
└── (auth)/
    ├── layout.tsx
    ├── login/page.tsx    # /login
    └── register/page.tsx # /register
```

Route groups `(name)` don't appear in URL.

## Intercepting Routes

### Modal Pattern

```
app/
├── photos/
│   └── [id]/
│       └── page.tsx      # /photos/123
│
└── (...)photos/
    └── [id]/
        └── page.tsx      # Intercepted route
```

```tsx
// app/(...)photos/[id]/page.tsx
export default function PhotoModal({ params }: { params: { id: string } }) {
  return (
    <Modal>
      <Photo id={params.id} />
    </Modal>
  )
}
```

Navigate to `/photos/123` shows modal, but refresh shows full page.

## Redirects

### In Server Component

```tsx
import { redirect } from 'next/navigation'

async function AdminPage() {
  const user = await getCurrentUser()
  
  if (!user.isAdmin) {
    redirect('/unauthorized')
  }
  
  return <div>Admin Dashboard</div>
}
```

### Permanent Redirect

```tsx
import { permanentRedirect } from 'next/navigation'

export default function OldPage() {
  permanentRedirect('/new-page')
}
```

### Redirect in Middleware

```tsx
// middleware.ts
import { NextResponse } from 'next/server'

export function middleware(request: Request) {
  const pathname = request.nextUrl.pathname
  
  if (pathname === '/old-page') {
    return NextResponse.redirect(new URL('/new-page', request.url))
  }
}
```

## Rewrites

### next.config.ts

```ts
import type { NextConfig } from 'next'

const config: NextConfig = {
  async rewrites() {
    return [
      {
        source: '/blog/:slug',
        destination: '/posts/:slug',
      },
      {
        source: '/api/:path*',
        destination: 'https://external-api.com/:path*',
      },
    ]
  }
}

export default config
```

## Navigation

### Client-side Navigation

```tsx
'use client'

import Link from 'next/link'
import { useRouter } from 'next/navigation'

export function Navigation() {
  const router = useRouter()
  
  return (
    <nav>
      <Link href="/about">About</Link>
      <button onClick={() => router.push('/dashboard')}>
        Dashboard
      </button>
      <button onClick={() => router.back()}>Back</button>
      <button onClick={() => router.refresh()}>Refresh</button>
    </nav>
  )
}
```

### Programmatic Navigation

```tsx
'use client'

import { useRouter } from 'next/navigation'

export function LoginForm() {
  const router = useRouter()
  
  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    
    const success = await login(credentials)
    
    if (success) {
      router.push('/dashboard')
      router.refresh()
    }
  }
  
  return <form onSubmit={handleSubmit}>{/* ... */}</form>
}
```

## Key Points

- Use `[param]` for dynamic routes
- Use `[...slug]` for catch-all routes
- Route groups for organization only
- Intercepting routes for modals
- Use `redirect()` in Server Components
- Use `router.push()` in Client Components
- Middleware for edge redirects
