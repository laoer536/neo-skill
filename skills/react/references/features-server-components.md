---
name: features-server-components
description: React Server Components, Server/Client components boundary, streaming SSR
---

# Server Components

React Server Components (RSC) enable running components on the server.

## Server vs Client Components

### Server Component (Default in Next.js App Router)

```tsx
// app/page.tsx - This is a Server Component by default
async function HomePage() {
  // Can directly access database, file system, etc.
  const users = await db.user.findMany()
  
  return (
    <main>
      <h1>Users</h1>
      <ul>
        {users.map(user => (
          <li key={user.id}>{user.name}</li>
        ))}
      </ul>
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

## When to Use Client Components

Use `'use client'` when you need:
- Interactivity (onClick, onChange, etc.)
- State hooks (useState, useReducer)
- Effect hooks (useEffect, useLayoutEffect)
- Browser APIs (window, localStorage, etc.)
- Custom hooks that use any of the above

## Composition Pattern

### Server → Client Composition

```tsx
// app/page.tsx (Server Component)
import { Counter } from './components/counter' // Client Component
import { UserList } from './components/user-list' // Server Component

async function Page() {
  const users = await fetchUsers()
  
  return (
    <div>
      <h1>Dashboard</h1>
      {/* Pass Client Component as children to avoid re-rendering */}
      <UserList users={users}>
        <Counter />
      </UserList>
    </div>
  )
}

// app/components/user-list.tsx (Server Component)
export function UserList({ 
  users, 
  children 
}: { 
  users: User[]
  children: React.ReactNode
}) {
  return (
    <div>
      <ul>
        {users.map(user => <li key={user.id}>{user.name}</li>)}
      </ul>
      {/* Client Component stays interactive */}
      {children}
    </div>
  )
}
```

## Data Fetching in Server Components

```tsx
// app/products/[id]/page.tsx
async function ProductPage({ params }: { params: { id: string } }) {
  // Direct database query
  const product = await db.product.findUnique({
    where: { id: params.id }
  })
  
  if (!product) {
    notFound()
  }
  
  return (
    <article>
      <h1>{product.name}</h1>
      <p>{product.description}</p>
      <p className="text-2xl">${product.price}</p>
      <AddToCart productId={product.id} /> {/* Client Component */}
    </article>
  )
}
```

## Streaming SSR

```tsx
// app/layout.tsx
import { Suspense } from 'react'

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html>
      <body>
        <Suspense fallback={<HeaderSkeleton />}>
          <Header />
        </Suspense>
        <main>{children}</main>
        <Suspense fallback={<FooterSkeleton />}>
          <Footer />
        </Suspense>
      </body>
    </html>
  )
}
```

## Server Actions

```tsx
// app/actions.ts
'use server'

import { revalidatePath } from 'next/cache'

export async function createTodo(formData: FormData) {
  const text = formData.get('text') as string
  
  await db.todo.create({
    data: { text }
  })
  
  revalidatePath('/todos')
}

// app/todos/page.tsx
'use client'

import { createTodo } from './actions'
import { useState } from 'react'

export function TodoForm() {
  const [pending, startTransition] = useTransition()
  
  return (
    <form action={createTodo}>
      <input name="text" required />
      <button type="submit" disabled={pending}>
        {pending ? 'Adding...' : 'Add Todo'}
      </button>
    </form>
  )
}
```

## Key Points

- Server Components are default in Next.js App Router
- Use `'use client'` only when needed
- Keep Server/Client boundary clear
- Pass Client Components as children to prevent re-rendering
- Server Components can directly access backend resources
- Use Server Actions for mutations instead of API routes
