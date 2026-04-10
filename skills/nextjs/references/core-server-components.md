---
name: core-server-components
description: Next.js Server Components, Client Components, Server Actions, streaming
---

# Server Components

Understanding Server and Client Components in Next.js App Router.

## Server Components (Default)

```tsx
// app/page.tsx - Server Component by default
async function HomePage() {
  // ✅ Can access backend directly
  const users = await db.user.findMany()
  const config = await fs.readFile('./config.json')
  
  // ❌ Cannot use hooks or browser APIs
  // const [count, setCount] = useState(0) // Error!
  // useEffect(() => {}) // Error!
  
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

## Client Components

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

### When to Use Client Components

Use `'use client'` when you need:
- `useState`, `useEffect`, `useContext`
- Event listeners (`onClick`, `onChange`)
- Browser APIs (`window`, `localStorage`)
- Custom hooks that use any of the above

## Composition Pattern

### Best Practice: Pass Client as Children

```tsx
// app/page.tsx (Server)
import { Counter } from './components/counter' // Client

export default function Page() {
  return (
    <div>
      <ServerData />
      {/* Client Component won't re-render when ServerData changes */}
      <Counter />
    </div>
  )
}

// Better: Pass as children
// app/layout.tsx (Server)
export default function Layout({ children }: { children: React.ReactNode }) {
  return (
    <div>
      <ServerComponent />
      {children} {/* Client Component stays isolated */}
    </div>
  )
}
```

## Server Actions

### Basic Server Action

```tsx
// app/actions.ts
'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'

export async function createTodo(formData: FormData) {
  const text = formData.get('text') as string
  
  await db.todo.create({ data: { text } })
  
  revalidatePath('/todos')
  redirect('/todos')
}

// app/todos/page.tsx
import { createTodo } from './actions'

export default function TodosPage() {
  return (
    <form action={createTodo}>
      <input name="text" required />
      <button type="submit">Add Todo</button>
    </form>
  )
}
```

### Server Action with useState

```tsx
// app/form.tsx
'use client'

import { useActionState } from 'react'
import { submitForm } from './actions'

export function ContactForm() {
  const [state, formAction, isPending] = useActionState(
    submitForm,
    { message: '' }
  )
  
  return (
    <form action={formAction}>
      <input name="email" required />
      <button type="submit" disabled={isPending}>
        {isPending ? 'Sending...' : 'Send'}
      </button>
      {state.message && <p>{state.message}</p>}
    </form>
  )
}
```

## Streaming

### Streaming with Suspense

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
      </body>
    </html>
  )
}

// app/products/page.tsx
async function ProductsPage() {
  return (
    <div>
      <Suspense fallback={<ProductSkeleton />}>
        <ProductList />
      </Suspense>
      <Suspense fallback={<ReviewSkeleton />}>
        <ProductReviews />
      </Suspense>
    </div>
  )
}
```

## Data Fetching Patterns

### Server Component (Recommended)

```tsx
// app/users/[id]/page.tsx
async function UserPage({ params }: { params: { id: string } }) {
  const user = await db.user.findUnique({
    where: { id: params.id }
  })
  
  if (!user) {
    notFound()
  }
  
  return (
    <div>
      <h1>{user.name}</h1>
      <p>{user.email}</p>
    </div>
  )
}
```

### Client Component with React Query

```tsx
// app/components/user-profile.tsx
'use client'

import { useQuery } from '@tanstack/react-query'

export function UserProfile({ userId }: { userId: string }) {
  const { data, isLoading } = useQuery({
    queryKey: ['user', userId],
    queryFn: () => fetch(`/api/users/${userId}`).then(res => res.json())
  })
  
  if (isLoading) return <div>Loading...</div>
  
  return <div>{data.name}</div>
}
```

## Key Points

- Server Components are default (no directive needed)
- Use `'use client'` only for interactivity
- Keep Server/Client boundary clear
- Pass Client Components as children
- Use Server Actions for mutations
- Stream with Suspense for better UX
