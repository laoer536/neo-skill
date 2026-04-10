---
name: core-app-router
description: Next.js App Router - File-based routing, layouts, templates, parallel routes
---

# App Router

Next.js 14/16 file-based routing with the App Router.

## File Conventions

```
app/
├── layout.tsx        # Root layout (required)
├── page.tsx          # Home page (required)
├── loading.tsx       # Global loading UI
├── error.tsx         # Error boundary
├── not-found.tsx     # 404 page
│
├── dashboard/
│   ├── layout.tsx    # Dashboard layout
│   ├── page.tsx      # /dashboard
│   └── loading.tsx   # Dashboard loading
│
├── users/
│   ├── page.tsx      # /users
│   └── [id]/
│       ├── page.tsx  # /users/:id
│       └── loading.tsx
│
└── @sidebar/         # Parallel route
    └── page.tsx
```

## Basic Routes

### Page

```tsx
// app/page.tsx
export default function HomePage() {
  return <h1>Welcome Home</h1>
}

// app/about/page.tsx
export default function AboutPage() {
  return <h1>About Us</h1>
}
```

### Dynamic Routes

```tsx
// app/users/[id]/page.tsx
export default function UserPage({ params }: { params: { id: string } }) {
  return <h1>User {params.id}</h1>
}

// app/posts/[slug]/page.tsx
export default function PostPage({ params }: { params: { slug: string } }) {
  return <article>Post: {params.slug}</article>
}
```

### Catch-all Routes

```tsx
// app/docs/[...slug]/page.tsx
export default function DocsPage({ params }: { params: { slug: string[] } }) {
  return <div>Docs: {params.slug.join('/')}</div>
}
// Matches: /docs/a, /docs/a/b, /docs/a/b/c
```

## Layouts

### Root Layout

```tsx
// app/layout.tsx
export const metadata = {
  title: 'My App',
  description: 'My Next.js Application'
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>
        <Header />
        <main>{children}</main>
        <Footer />
      </body>
    </html>
  )
}
```

### Nested Layouts

```tsx
// app/dashboard/layout.tsx
export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div className="dashboard">
      <Sidebar />
      <main>{children}</main>
    </div>
  )
}

// app/dashboard/page.tsx
export default function DashboardPage() {
  return <h1>Dashboard</h1>
}
```

## Loading UI

```tsx
// app/loading.tsx
export default function Loading() {
  return (
    <div className="spinner">
      <LoadingSpinner />
    </div>
  )
}

// app/dashboard/loading.tsx
export default function DashboardLoading() {
  return <DashboardSkeleton />
}
```

## Error Handling

```tsx
// app/error.tsx
'use client'

import { useEffect } from 'react'

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  useEffect(() => {
    console.error(error)
  }, [error])
  
  return (
    <div>
      <h2>Something went wrong!</h2>
      <button onClick={() => reset()}>Try again</button>
    </div>
  )
}
```

## Not Found

```tsx
// app/not-found.tsx
import Link from 'next/link'

export default function NotFound() {
  return (
    <div>
      <h2>404 - Not Found</h2>
      <p>Could not find requested resource</p>
      <Link href="/">Return Home</Link>
    </div>
  )
}
```

## Route Groups

```
app/
├── (marketing)/
│   ├── layout.tsx    # Marketing layout
│   └── page.tsx      # /
│
└── (shop)/
    ├── layout.tsx    # Shop layout
    └── page.tsx      # /shop
```

Route groups don't affect URL path, only organizational.

## Parallel Routes

```tsx
// app/layout.tsx
export default function RootLayout({
  children,
  @analytics,
  @team,
}: {
  children: React.ReactNode
  @analytics: React.ReactNode
  @team: React.ReactNode
}) {
  return (
    <>
      {children}
      {@analytics}
      {@team}
    </>
  )
}

// app/@analytics/page.tsx
export default function AnalyticsPage() {
  return <Analytics />
}
```

## Key Points

- `page.tsx` and `layout.tsx` are special files
- Layouts preserve state across navigation
- Use loading.tsx for Suspense boundaries
- Error boundaries catch errors in child components
- Dynamic routes use [param] syntax
- Route groups use (group) syntax
