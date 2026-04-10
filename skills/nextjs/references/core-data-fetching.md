---
name: core-data-fetching
description: Next.js data fetching - fetch caching, revalidation, Server Actions
---

# Data Fetching

Data fetching patterns in Next.js App Router.

## Server Component Fetching

### Basic Fetch

```tsx
// app/users/page.tsx
async function UsersPage() {
  const res = await fetch('https://api.example.com/users')
  const users = await res.json()
  
  return (
    <ul>
      {users.map(user => <li key={user.id}>{user.name}</li>)}
    </ul>
  )
}
```

### Direct Database Access

```tsx
// app/posts/[id]/page.tsx
import { db } from '@/lib/db'

async function PostPage({ params }: { params: { id: string } }) {
  const post = await db.post.findUnique({
    where: { id: params.id },
    include: { author: true, comments: true }
  })
  
  if (!post) {
    notFound()
  }
  
  return (
    <article>
      <h1>{post.title}</h1>
      <p>{post.content}</p>
      <Author author={post.author} />
      <Comments comments={post.comments} />
    </article>
  )
}
```

## Caching Strategies

### Static Generation (Default)

```tsx
// Data fetched once at build time
async function StaticPage() {
  const data = await fetch('https://api.example.com/data')
  // Cached forever
  return <div>{data}</div>
}
```

### Time-based Revalidation

```tsx
// Revalidate every 1 hour
async function TimedPage() {
  const data = await fetch('https://api.example.com/data', {
    next: { revalidate: 3600 } // 1 hour
  })
  
  return <div>{data}</div>
}
```

### On-demand Revalidation

```tsx
// app/actions.ts
'use server'

import { revalidatePath, revalidateTag } from 'next/cache'

export async function updatePost(id: string, data: PostData) {
  await db.post.update({ where: { id }, data })
  
  // Revalidate specific path
  revalidatePath(`/posts/${id}`)
  
  // Or revalidate by tag
  revalidateTag('posts')
}

// app/posts/page.tsx
async function PostsPage() {
  const posts = await fetch('https://api.example.com/posts', {
    next: { tags: ['posts'] }
  })
  
  return <div>{/* ... */}</div>
}
```

### No Caching

```tsx
// Always fetch fresh data
async function DynamicPage() {
  const data = await fetch('https://api.example.com/data', {
    cache: 'no-store'
  })
  
  return <div>{data}</div>
}

// Or export dynamic
export const dynamic = 'force-dynamic'
```

## Server Actions for Mutations

### Form Mutation

```tsx
// app/actions.ts
'use server'

export async function createUser(formData: FormData) {
  const name = formData.get('name') as string
  const email = formData.get('email') as string
  
  await db.user.create({ data: { name, email } })
  
  revalidatePath('/users')
}

// app/users/new/page.tsx
import { createUser } from '../actions'

export default function NewUserPage() {
  return (
    <form action={createUser}>
      <input name="name" required />
      <input name="email" type="email" required />
      <button type="submit">Create User</button>
    </form>
  )
}
```

### Optimistic Updates

```tsx
// app/todos/page.tsx
'use client'

import { useOptimistic } from 'react'
import { createTodo } from './actions'

export default function TodosPage({ todos }: { todos: Todo[] }) {
  const [optimisticTodos, addOptimisticTodo] = useOptimistic(
    todos,
    (state, newTodo: Todo) => [...state, newTodo]
  )
  
  async function formAction(formData: FormData) {
    const text = formData.get('text') as string
    addOptimisticTodo({ id: 'temp', text, completed: false })
    await createTodo(formData)
  }
  
  return (
    <form action={formAction}>
      <input name="text" />
      <button type="submit">Add</button>
      <ul>
        {optimisticTodos.map(todo => (
          <li key={todo.id}>{todo.text}</li>
        ))}
      </ul>
    </form>
  )
}
```

## Parallel Data Fetching

```tsx
async function Page() {
  // Sequential (slow)
  // const user = await getUser()
  // const posts = await getPosts(user.id)
  
  // Parallel (fast)
  const [user, posts] = await Promise.all([
    getUser(),
    getPosts()
  ])
  
  return <div>{/* ... */}</div>
}
```

## Key Points

- Server Components can fetch directly
- Use `next: { revalidate }` for time-based caching
- Use `revalidatePath()` for on-demand updates
- Server Actions for form mutations
- Prefer static generation when possible
- Use `no-store` for always-fresh data
