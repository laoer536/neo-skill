---
name: core-state
description: State management patterns - Context, useReducer, external state libraries
---

# State Management

Managing application state in React applications.

## Local State

### useState for Simple State

```tsx
function Form() {
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  
  return (
    <form>
      <input value={name} onChange={e => setName(e.target.value)} />
      <input value={email} onChange={e => setEmail(e.target.value)} />
    </form>
  )
}
```

## Context + useReducer Pattern

### Global State Management

```tsx
import { createContext, useContext, useReducer, ReactNode } from 'react'

// Types
interface Todo {
  id: string
  text: string
  completed: boolean
}

interface State {
  todos: Todo[]
  filter: 'all' | 'active' | 'completed'
}

type Action =
  | { type: 'ADD_TODO'; payload: string }
  | { type: 'TOGGLE_TODO'; payload: string }
  | { type: 'DELETE_TODO'; payload: string }
  | { type: 'SET_FILTER'; payload: State['filter'] }

// Initial state
const initialState: State = {
  todos: [],
  filter: 'all'
}

// Reducer
function todoReducer(state: State, action: Action): State {
  switch (action.type) {
    case 'ADD_TODO':
      return {
        ...state,
        todos: [...state.todos, {
          id: Date.now().toString(),
          text: action.payload,
          completed: false
        }]
      }
    case 'TOGGLE_TODO':
      return {
        ...state,
        todos: state.todos.map(todo =>
          todo.id === action.payload
            ? { ...todo, completed: !todo.completed }
            : todo
        )
      }
    case 'DELETE_TODO':
      return {
        ...state,
        todos: state.todos.filter(todo => todo.id !== action.payload)
      }
    case 'SET_FILTER':
      return { ...state, filter: action.payload }
    default:
      return state
  }
}

// Context
interface TodoContextType {
  state: State
  dispatch: React.Dispatch<Action>
}

const TodoContext = createContext<TodoContextType | null>(null)

// Provider
function TodoProvider({ children }: { children: ReactNode }) {
  const [state, dispatch] = useReducer(todoReducer, initialState)
  
  return (
    <TodoContext.Provider value={{ state, dispatch }}>
      {children}
    </TodoContext.Provider>
  )
}

// Custom hook
function useTodos() {
  const context = useContext(TodoContext)
  if (!context) {
    throw new Error('useTodos must be used within TodoProvider')
  }
  return context
}

// Usage
function TodoApp() {
  return (
    <TodoProvider>
      <TodoInput />
      <TodoList />
      <TodoFilter />
    </TodoProvider>
  )
}

function TodoInput() {
  const [text, setText] = useState('')
  const { dispatch } = useTodos()
  
  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    if (text.trim()) {
      dispatch({ type: 'ADD_TODO', payload: text })
      setText('')
    }
  }
  
  return (
    <form onSubmit={handleSubmit}>
      <input value={text} onChange={e => setText(e.target.value)} />
      <button type="submit">Add</button>
    </form>
  )
}
```

## External State Libraries

### Zustand (Recommended)

```tsx
import { create } from 'zustand'

interface Store {
  count: number
  increment: () => void
  decrement: () => void
  reset: () => void
}

const useStore = create<Store>((set) => ({
  count: 0,
  increment: () => set((state) => ({ count: state.count + 1 })),
  decrement: () => set((state) => ({ count: state.count - 1 })),
  reset: () => set({ count: 0 }),
}))

function Counter() {
  const count = useStore((state) => state.count)
  const increment = useStore((state) => state.increment)
  const decrement = useStore((state) => state.decrement)
  
  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={increment}>+</button>
      <button onClick={decrement}>-</button>
    </div>
  )
}
```

## State Management Decision Tree

```
Is state local to one component?
├─ Yes → useState
└─ No → Shared state
    ├─ Simple shared state → useContext + useReducer
    └─ Complex app state → Zustand (recommended)

Is state server data?
├─ Yes → React Query / SWR
└─ No → Client state (see above)
```

## Key Points

- Keep state as local as possible
- Lift state up only when needed
- Use Context for theme, auth, locale - not all state
- Prefer Zustand for complex client state
- Use React Query for server state
- Avoid prop drilling with proper state management
