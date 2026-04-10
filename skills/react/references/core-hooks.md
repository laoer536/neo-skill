---
name: core-hooks
description: React Hooks - useState, useEffect, useContext, useMemo, useCallback, useRef, and custom hooks
---

# React Hooks

Core hooks for state management, side effects, and performance optimization.

## State Hooks

### useState

```tsx
import { useState } from 'react'

function Counter() {
  const [count, setCount] = useState(0)
  const [user, setUser] = useState({ name: '', email: '' })
  
  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  )
}
```

### useReducer

```tsx
import { useReducer } from 'react'

interface State {
  count: number
  step: number
}

type Action = 
  | { type: 'increment' }
  | { type: 'decrement' }
  | { type: 'reset' }

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case 'increment':
      return { ...state, count: state.count + state.step }
    case 'decrement':
      return { ...state, count: state.count - state.step }
    case 'reset':
      return { count: 0, step: state.step }
    default:
      return state
  }
}

function Counter() {
  const [state, dispatch] = useReducer(reducer, { count: 0, step: 1 })
  
  return (
    <div>
      <p>Count: {state.count}</p>
      <button onClick={() => dispatch({ type: 'increment' })}>+</button>
      <button onClick={() => dispatch({ type: 'decrement' })}>-</button>
      <button onClick={() => dispatch({ type: 'reset' })}>Reset</button>
    </div>
  )
}
```

## Effect Hooks

### useEffect

```tsx
import { useState, useEffect } from 'react'

function DataFetcher({ url }: { url: string }) {
  const [data, setData] = useState(null)
  const [loading, setLoading] = useState(true)
  
  useEffect(() => {
    let cancelled = false
    
    async function fetchData() {
      setLoading(true)
      try {
        const response = await fetch(url)
        const json = await response.json()
        if (!cancelled) {
          setData(json)
        }
      } catch (error) {
        console.error('Fetch failed:', error)
      } finally {
        if (!cancelled) {
          setLoading(false)
        }
      }
    }
    
    fetchData()
    
    return () => {
      cancelled = true
    }
  }, [url])
  
  if (loading) return <p>Loading...</p>
  return <pre>{JSON.stringify(data, null, 2)}</pre>
}
```

### useLayoutEffect

```tsx
import { useRef, useLayoutEffect } from 'react'

function Tooltip({ text }: { text: string }) {
  const ref = useRef<HTMLDivElement>(null)
  
  useLayoutEffect(() => {
    if (ref.current) {
      const { bottom, left } = ref.current.getBoundingClientRect()
      // Position tooltip before paint
      ref.current.style.top = `${bottom + 10}px`
      ref.current.style.left = `${left}px`
    }
  }, [])
  
  return <div ref={ref}>{text}</div>
}
```

## Context Hook

### useContext

```tsx
import { createContext, useContext, useState } from 'react'

interface ThemeContextType {
  theme: 'light' | 'dark'
  toggleTheme: () => void
}

const ThemeContext = createContext<ThemeContextType | null>(null)

function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState<'light' | 'dark'>('light')
  
  const toggleTheme = () => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light')
  }
  
  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  )
}

function useTheme() {
  const context = useContext(ThemeContext)
  if (!context) {
    throw new Error('useTheme must be used within ThemeProvider')
  }
  return context
}

function ThemedButton() {
  const { theme, toggleTheme } = useTheme()
  
  return (
    <button
      onClick={toggleTheme}
      className={theme === 'dark' ? 'dark' : 'light'}
    >
      Current theme: {theme}
    </button>
  )
}
```

## Performance Hooks

### useMemo

```tsx
import { useMemo } from 'react'

function ExpensiveList({ items, filter }: { items: string[], filter: string }) {
  const filteredItems = useMemo(() => {
    console.log('Filtering items...')
    return items.filter(item => 
      item.toLowerCase().includes(filter.toLowerCase())
    )
  }, [items, filter])
  
  return (
    <ul>
      {filteredItems.map((item, index) => (
        <li key={index}>{item}</li>
      ))}
    </ul>
  )
}
```

### useCallback

```tsx
import { useState, useCallback } from 'react'

function TodoList() {
  const [todos, setTodos] = useState<string[]>([])
  
  const addTodo = useCallback((text: string) => {
    setTodos(prev => [...prev, text])
  }, [])
  
  const removeTodo = useCallback((index: number) => {
    setTodos(prev => prev.filter((_, i) => i !== index))
  }, [])
  
  return (
    <div>
      <TodoForm onAdd={addTodo} />
      <List items={todos} onRemove={removeTodo} />
    </div>
  )
}
```

## Ref Hook

### useRef

```tsx
import { useRef, useEffect } from 'react'

function AutoFocusInput() {
  const inputRef = useRef<HTMLInputElement>(null)
  
  useEffect(() => {
    inputRef.current?.focus()
  }, [])
  
  return <input ref={inputRef} type="text" />
}
```

## Custom Hooks

```tsx
import { useState, useEffect } from 'react'

function useLocalStorage<T>(key: string, initialValue: T) {
  const [storedValue, setStoredValue] = useState<T>(() => {
    try {
      const item = window.localStorage.getItem(key)
      return item ? JSON.parse(item) : initialValue
    } catch {
      return initialValue
    }
  })
  
  const setValue = (value: T | ((val: T) => T)) => {
    try {
      const valueToStore = value instanceof Function ? value(storedValue) : value
      setStoredValue(valueToStore)
      window.localStorage.setItem(key, JSON.stringify(valueToStore))
    } catch (error) {
      console.error(error)
    }
  }
  
  return [storedValue, setValue] as const
}

// Usage
function UserPreferences() {
  const [theme, setTheme] = useLocalStorage('theme', 'light')
  
  return (
    <button onClick={() => setTheme(theme === 'light' ? 'dark' : 'light')}>
      Theme: {theme}
    </button>
  )
}
```

## Key Points

- Always include cleanup functions in useEffect when needed
- Use useMemo for expensive computations
- Use useCallback for functions passed as props to memoized components
- Create custom hooks to extract and reuse stateful logic
- Follow the Rules of Hooks: only call hooks at the top level
