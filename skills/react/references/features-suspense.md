---
name: features-suspense
description: Suspense, Error Boundaries, lazy loading, concurrent features
---

# Suspense & Error Boundaries

Handle async operations and errors gracefully.

## Suspense

### Basic Suspense

```tsx
import { Suspense, lazy } from 'react'

const LazyComponent = lazy(() => import('./HeavyComponent'))

function App() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <LazyComponent />
    </Suspense>
  )
}
```

### Nested Suspense

```tsx
function Page() {
  return (
    <div>
      <Suspense fallback={<HeaderSkeleton />}>
        <Header />
      </Suspense>
      
      <main>
        <Suspense fallback={<ContentSkeleton />}>
          <Content />
        </Suspense>
      </main>
      
      <Suspense fallback={<FooterSkeleton />}>
        <Footer />
      </Suspense>
    </div>
  )
}
```

### Suspense with Data Fetching

```tsx
// Using React.lazy for route-based code splitting
const Dashboard = lazy(() => import('./Dashboard'))
const Settings = lazy(() => import('./Settings'))

function Router() {
  const [page, setPage] = useState('dashboard')
  
  return (
    <div>
      <nav>
        <button onClick={() => setPage('dashboard')}>Dashboard</button>
        <button onClick={() => setPage('settings')}>Settings</button>
      </nav>
      
      <Suspense fallback={<PageLoader />}>
        {page === 'dashboard' ? <Dashboard /> : <Settings />}
      </Suspense>
    </div>
  )
}
```

## Error Boundaries

### Class Component Error Boundary

```tsx
import { Component, ErrorInfo, ReactNode } from 'react'

interface Props {
  children: ReactNode
  fallback?: ReactNode
}

interface State {
  hasError: boolean
  error: Error | null
}

class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props)
    this.state = { hasError: false, error: null }
  }
  
  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error }
  }
  
  componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error('Error caught by boundary:', error, errorInfo)
    // Send to error tracking service
  }
  
  render() {
    if (this.state.hasError) {
      return this.props.fallback || (
        <div>
          <h2>Something went wrong</h2>
          <p>{this.state.error?.message}</p>
          <button onClick={() => this.setState({ hasError: false, error: null })}>
            Try again
          </button>
        </div>
      )
    }
    
    return this.props.children
  }
}

// Usage
function App() {
  return (
    <ErrorBoundary>
      <MainContent />
    </ErrorBoundary>
  )
}
```

### Error Boundary with Suspense

```tsx
function SafeComponent() {
  return (
    <ErrorBoundary fallback={<ErrorScreen />}>
      <Suspense fallback={<LoadingScreen />}>
        <AsyncComponent />
      </Suspense>
    </ErrorBoundary>
  )
}
```

## Concurrent Features

### useTransition

```tsx
import { useState, useTransition } from 'react'

function SearchPage() {
  const [query, setQuery] = useState('')
  const [results, setResults] = useState([])
  const [isPending, startTransition] = useTransition()
  
  const handleSearch = (value: string) => {
    setQuery(value)
    
    // Low priority update
    startTransition(() => {
      const filtered = searchDatabase(value)
      setResults(filtered)
    })
  }
  
  return (
    <div>
      <input
        value={query}
        onChange={(e) => handleSearch(e.target.value)}
        placeholder="Search..."
      />
      {isPending && <p>Searching...</p>}
      <ul>
        {results.map(result => (
          <li key={result.id}>{result.name}</li>
        ))}
      </ul>
    </div>
  )
}
```

### useDeferredValue

```tsx
import { useState, useDeferredValue } from 'react'

function ExpensiveList({ items }: { items: string[] }) {
  const [query, setQuery] = useState('')
  const deferredQuery = useDeferredValue(query)
  
  const filteredItems = items.filter(item =>
    item.toLowerCase().includes(deferredQuery.toLowerCase())
  )
  
  return (
    <div>
      <input
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        placeholder="Filter..."
      />
      <LongList items={filteredItems} />
    </div>
  )
}
```

## Key Points

- Use Suspense for async UI states
- Wrap routes and heavy components with Suspense
- Always use Error Boundaries in production
- Combine Suspense + Error Boundaries for robust error handling
- Use concurrent features for better UX during expensive operations
