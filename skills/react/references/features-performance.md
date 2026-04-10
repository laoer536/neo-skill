---
name: features-performance
description: Performance optimization - memo, useMemo, useCallback, code splitting, profiling
---

# Performance Optimization

Optimize React applications for better rendering performance.

## React.memo

### Prevent Unnecessary Re-renders

```tsx
import { memo } from 'react'

interface Props {
  title: string
  onClick: () => void
}

const ExpensiveComponent = memo(({ title, onClick }: Props) => {
  console.log('Rendering...')
  return <button onClick={onClick}>{title}</button>
})

// Only re-renders when props change
function Parent() {
  const [count, setCount] = useState(0)
  const handleClick = useCallback(() => console.log('clicked'), [])
  
  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
      <ExpensiveComponent title="Click me" onClick={handleClick} />
    </div>
  )
}
```

### Custom Comparison

```tsx
const ComplexComponent = memo(
  ({ data, config }: Props) => {
    return <div>{/* Complex rendering */}</div>
  },
  (prevProps, nextProps) => {
    // Return true if props are equal (skip re-render)
    return prevProps.data.id === nextProps.data.id
  }
)
```

## useMemo

### Expensive Computations

```tsx
function ProductList({ products, filter }: Props) {
  // Only recompute when products or filter change
  const filteredProducts = useMemo(() => {
    console.log('Filtering products...')
    return products
      .filter(p => p.category === filter.category)
      .sort((a, b) => a.price - b.price)
  }, [products, filter])
  
  return (
    <ul>
      {filteredProducts.map(product => (
        <li key={product.id}>{product.name} - ${product.price}</li>
      ))}
    </ul>
  )
}
```

### Referential Equality

```tsx
function Form() {
  const [name, setName] = useState('')
  
  // Memoize object to prevent child re-renders
  const user = useMemo(() => ({
    name,
    updatedAt: Date.now()
  }), [name])
  
  return <ChildComponent user={user} />
}
```

## useCallback

### Stable Function References

```tsx
function TodoList() {
  const [todos, setTodos] = useState<Todo[]>([])
  
  // Stable reference
  const addTodo = useCallback((text: string) => {
    setTodos(prev => [...prev, { id: Date.now(), text, completed: false }])
  }, [])
  
  const removeTodo = useCallback((id: number) => {
    setTodos(prev => prev.filter(todo => todo.id !== id))
  }, [])
  
  return (
    <div>
      <TodoForm onAdd={addTodo} />
      <Todos items={todos} onRemove={removeTodo} />
    </div>
  )
}
```

## Code Splitting

### Route-based Splitting

```tsx
import { lazy, Suspense } from 'react'
import { BrowserRouter, Routes, Route } from 'react-router-dom'

const Home = lazy(() => import('./pages/Home'))
const About = lazy(() => import('./pages/About'))
const Dashboard = lazy(() => import('./pages/Dashboard'))

function App() {
  return (
    <BrowserRouter>
      <Suspense fallback={<LoadingSpinner />}>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/about" element={<About />} />
          <Route path="/dashboard" element={<Dashboard />} />
        </Routes>
      </Suspense>
    </BrowserRouter>
  )
}
```

### Conditional Splitting

```tsx
const HeavyChart = lazy(() => import('./HeavyChart'))

function Dashboard({ showChart }: { showChart: boolean }) {
  return (
    <div>
      <h1>Dashboard</h1>
      {showChart && (
        <Suspense fallback={<ChartSkeleton />}>
          <HeavyChart />
        </Suspense>
      )}
    </div>
  )
}
```

## Virtualization

### Long Lists

```tsx
import { FixedSizeList as List } from 'react-window'

function VirtualizedList({ items }: { items: string[] }) {
  const Row = ({ index, style }: { index: number; style: CSSProperties }) => (
    <div style={style}>
      {items[index]}
    </div>
  )
  
  return (
    <List
      height={600}
      itemCount={items.length}
      itemSize={35}
      width="100%"
    >
      {Row}
    </List>
  )
}
```

## Profiling

### React DevTools Profiler

```tsx
import { Profiler } from 'react'

function onRenderCallback(
  id: string,
  phase: 'mount' | 'update',
  actualDuration: number,
  baseDuration: number,
  startTime: number,
  commitTime: number
) {
  console.log(`${id} took ${actualDuration}ms to render`)
}

function App() {
  return (
    <Profiler id="App" onRender={onRenderCallback}>
      <MainContent />
    </Profiler>
  )
}
```

## Performance Checklist

- ✅ Use `React.memo` for pure components
- ✅ Memoize expensive computations with `useMemo`
- ✅ Stabilize callbacks with `useCallback`
- ✅ Code split routes and heavy components
- ✅ Virtualize long lists
- ✅ Avoid inline object/function creation in render
- ✅ Use production build
- ✅ Profile with React DevTools

## Key Points

- Don't optimize prematurely - measure first
- Focus on actual bottlenecks, not perceived ones
- React DevTools Profiler is your friend
- Memoization has costs - use judiciously
- Code splitting improves initial load time
- Virtualization for lists > 100 items
