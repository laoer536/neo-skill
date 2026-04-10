---
name: best-practices-data-fetching
description: Data fetching patterns - React Query, SWR, caching, optimistic updates
---

# Data Fetching

Modern data fetching patterns in React applications.

## React Query (Recommended)

### Basic Query

```tsx
import { useQuery } from '@tanstack/react-query'

interface User {
  id: string
  name: string
  email: string
}

function UserProfile({ userId }: { userId: string }) {
  const { data, isLoading, error } = useQuery({
    queryKey: ['user', userId],
    queryFn: () => fetch(`/api/users/${userId}`).then(res => res.json())
  })
  
  if (isLoading) return <div>Loading...</div>
  if (error) return <div>Error: {error.message}</div>
  
  return (
    <div>
      <h1>{data.name}</h1>
      <p>{data.email}</p>
    </div>
  )
}
```

### Mutation

```tsx
import { useMutation, useQueryClient } from '@tanstack/react-query'

function CreateTodo() {
  const queryClient = useQueryClient()
  
  const mutation = useMutation({
    mutationFn: (newTodo: { text: string }) =>
      fetch('/api/todos', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(newTodo)
      }).then(res => res.json()),
    onSuccess: () => {
      // Invalidate and refetch
      queryClient.invalidateQueries({ queryKey: ['todos'] })
    }
  })
  
  return (
    <form
      onSubmit={(e) => {
        e.preventDefault()
        const text = (e.target as HTMLFormElement).text.value
        mutation.mutate({ text })
      }}
    >
      <input name="text" />
      <button type="submit" disabled={mutation.isPending}>
        {mutation.isPending ? 'Adding...' : 'Add'}
      </button>
    </form>
  )
}
```

### Optimistic Updates

```tsx
function TodoList() {
  const queryClient = useQueryClient()
  
  const mutation = useMutation({
    mutationFn: updateTodo,
    // Optimistic update
    onMutate: async (newTodo) => {
      // Cancel outgoing refetches
      await queryClient.cancelQueries({ queryKey: ['todos'] })
      
      // Snapshot previous value
      const previous = queryClient.getQueryData(['todos'])
      
      // Optimistically update
      queryClient.setQueryData(['todos'], (old: Todo[]) => [...old, newTodo])
      
      return { previous }
    },
    // Rollback on error
    onError: (err, newTodo, context) => {
      queryClient.setQueryData(['todos'], context?.previous)
    },
    // Always refetch after error or success
    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: ['todos'] })
    }
  })
  
  return <TodoForm onSubmit={mutation.mutate} />
}
```

## SWR Alternative

```tsx
import useSWR from 'swr'

const fetcher = (url: string) => fetch(url).then(res => res.json())

function Profile() {
  const { data, error, isLoading } = useSWR('/api/user', fetcher)
  
  if (isLoading) return <div>Loading...</div>
  if (error) return <div>Error</div>
  
  return <h1>{data.name}</h1>
}
```

## Server Components (Next.js)

```tsx
// app/users/page.tsx
async function UsersPage() {
  // Direct database access in Server Component
  const users = await db.user.findMany()
  
  return (
    <div>
      <h1>Users</h1>
      <ul>
        {users.map(user => (
          <li key={user.id}>{user.name}</li>
        ))}
      </ul>
    </div>
  )
}
```

## Key Points

- Use React Query for client-side data fetching
- Server Components for server-side data in Next.js
- Always handle loading and error states
- Use optimistic updates for better UX
- Invalidate queries after mutations
- Cache responses appropriately
