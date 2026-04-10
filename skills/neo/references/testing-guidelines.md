---
name: testing-guidelines
description: Neo's testing strategy and best practices for Vue and React applications
---

# Testing Guidelines

## Testing Strategy

### Testing Pyramid

```
        /\
       /  \  E2E Tests (10%)
      /____\
     /      \
    /________\  Integration Tests (20%)
   /          \
  /____________\  Unit Tests (70%)
 /              \
/________________\
```

### What to Test

| Test Type | What | Tools | Frequency |
|-----------|------|-------|-----------|
| **Unit** | Functions, utilities, composables/hooks | Vitest | Every commit |
| **Integration** | Component interactions, API calls | Vitest + Testing Library | Every commit |
| **E2E** | Critical user flows | Playwright/Cypress | Before deployment |

## Unit Testing

### Vue - Testing Composables

```ts
// composables/useCounter.test.ts
import { describe, it, expect } from 'vitest'
import { useCounter } from './useCounter'

describe('useCounter', () => {
  it('should initialize with default value', () => {
    const { count } = useCounter()
    expect(count.value).toBe(0)
  })

  it('should initialize with provided value', () => {
    const { count } = useCounter({ initial: 10 })
    expect(count.value).toBe(10)
  })

  it('should increment count', async () => {
    const { count, increment } = useCounter()
    increment()
    expect(count.value).toBe(1)
  })

  it('should respect max value', async () => {
    const { count, increment } = useCounter({ max: 2 })
    increment()
    increment()
    increment() // Should not exceed max
    expect(count.value).toBe(2)
  })
})
```

### React - Testing Hooks

```ts
// hooks/useCounter.test.ts
import { describe, it, expect } from 'vitest'
import { renderHook, act } from '@testing-library/react'
import { useCounter } from './useCounter'

describe('useCounter', () => {
  it('should initialize with default value', () => {
    const { result } = renderHook(() => useCounter())
    expect(result.current.count).toBe(0)
  })

  it('should initialize with provided value', () => {
    const { result } = renderHook(() => useCounter({ initial: 10 }))
    expect(result.current.count).toBe(10)
  })

  it('should increment count', () => {
    const { result } = renderHook(() => useCounter())
    
    act(() => {
      result.current.increment()
    })
    
    expect(result.current.count).toBe(1)
  })

  it('should respect max value', () => {
    const { result } = renderHook(() => useCounter({ max: 2 }))
    
    act(() => {
      result.current.increment()
      result.current.increment()
      result.current.increment()
    })
    
    expect(result.current.count).toBe(2)
  })
})
```

### Testing Utilities

```ts
// utils/format.test.ts
import { describe, it, expect } from 'vitest'
import { formatDate, formatCurrency } from './format'

describe('formatDate', () => {
  it('should format date correctly', () => {
    const date = new Date('2024-01-15')
    expect(formatDate(date)).toBe('Jan 15, 2024')
  })

  it('should handle invalid date', () => {
    expect(formatDate(null)).toBe('')
    expect(formatDate(undefined)).toBe('')
  })
})

describe('formatCurrency', () => {
  it('should format number as currency', () => {
    expect(formatCurrency(1234.56)).toBe('$1,234.56')
  })

  it('should handle zero', () => {
    expect(formatCurrency(0)).toBe('$0.00')
  })
})
```

## Component Testing

### Vue Components

```tsx
// components/UserCard.test.ts
import { describe, it, expect, vi } from 'vitest'
import { render, screen, fireEvent } from '@testing-library/vue'
import UserCard from './UserCard.vue'

describe('UserCard', () => {
  const mockUser = {
    id: '1',
    name: 'John Doe',
    email: 'john@example.com',
  }

  it('should render user information', () => {
    render(UserCard, {
      props: { user: mockUser },
    })

    expect(screen.getByText('John Doe')).toBeTruthy()
    expect(screen.getByText('john@example.com')).toBeTruthy()
  })

  it('should emit delete event when delete button clicked', async () => {
    const onDelete = vi.fn()
    
    render(UserCard, {
      props: {
        user: mockUser,
        onDelete,
      },
    })

    await fireEvent.click(screen.getByText('Delete'))
    
    expect(onDelete).toHaveBeenCalledWith('1')
    expect(onDelete).toHaveBeenCalledTimes(1)
  })

  it('should show loading state', () => {
    render(UserCard, {
      props: {
        user: mockUser,
        loading: true,
      },
    })

    expect(screen.getByText('Loading...')).toBeTruthy()
    expect(screen.queryByText('John Doe')).toBeFalsy()
  })
})
```

### React Components

```tsx
// components/UserCard.test.tsx
import { describe, it, expect, vi } from 'vitest'
import { render, screen, fireEvent } from '@testing-library/react'
import UserCard from './UserCard'

describe('UserCard', () => {
  const mockUser = {
    id: '1',
    name: 'John Doe',
    email: 'john@example.com',
  }

  it('should render user information', () => {
    render(<UserCard user={mockUser} />)

    expect(screen.getByText('John Doe')).toBeInTheDocument()
    expect(screen.getByText('john@example.com')).toBeInTheDocument()
  })

  it('should call onDelete when delete button clicked', async () => {
    const onDelete = vi.fn()
    
    render(<UserCard user={mockUser} onDelete={onDelete} />)

    fireEvent.click(screen.getByText('Delete'))
    
    expect(onDelete).toHaveBeenCalledWith('1')
    expect(onDelete).toHaveBeenCalledTimes(1)
  })

  it('should show loading state', () => {
    render(<UserCard user={mockUser} loading={true} />)

    expect(screen.getByText('Loading...')).toBeInTheDocument()
    expect(screen.queryByText('John Doe')).not.toBeInTheDocument()
  })

  it('should match snapshot', () => {
    const { container } = render(<UserCard user={mockUser} />)
    expect(container).toMatchSnapshot()
  })
})
```

## Testing Async Code

### Vue - Testing API Calls

```ts
// composables/useUsers.test.ts
import { describe, it, expect, vi, beforeEach } from 'vitest'
import { useUsers } from './useUsers'
import * as api from '@/api/users'

vi.mock('@/api/users')

describe('useUsers', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('should fetch users successfully', async () => {
    const mockUsers = [
      { id: '1', name: 'John' },
      { id: '2', name: 'Jane' },
    ]
    
    vi.mocked(api.getUsers).mockResolvedValue(mockUsers)

    const { users, loading, fetchUsers } = useUsers()
    
    expect(loading.value).toBe(false)
    
    await fetchUsers()
    
    expect(loading.value).toBe(false)
    expect(users.value).toEqual(mockUsers)
  })

  it('should handle fetch error', async () => {
    vi.mocked(api.getUsers).mockRejectedValue(new Error('Network error'))

    const { users, error, fetchUsers } = useUsers()
    
    await fetchUsers()
    
    expect(error.value).toBe('Network error')
    expect(users.value).toEqual([])
  })
})
```

### React - Testing with React Query

```tsx
// components/UserList.test.tsx
import { describe, it, expect, vi } from 'vitest'
import { render, screen, waitFor } from '@testing-library/react'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import UserList from './UserList'
import * as api from '@/api/users'
import type { ReactNode } from 'react'

vi.mock('@/api/users')

const createWrapper = () => {
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: { retry: false },
    },
  })
  return ({ children }: { children: ReactNode }) => (
    <QueryClientProvider client={queryClient}>
      {children}
    </QueryClientProvider>
  )
}

describe('UserList', () => {
  it('should display users after fetch', async () => {
    const mockUsers = [
      { id: '1', name: 'John' },
      { id: '2', name: 'Jane' },
    ]
    
    vi.mocked(api.getUsers).mockResolvedValue(mockUsers)

    render(<UserList />, { wrapper: createWrapper() })

    expect(screen.getByText('Loading...')).toBeInTheDocument()

    await waitFor(() => {
      expect(screen.getByText('John')).toBeInTheDocument()
      expect(screen.getByText('Jane')).toBeInTheDocument()
    })
  })

  it('should display error on fetch failure', async () => {
    vi.mocked(api.getUsers).mockRejectedValue(new Error('Failed to fetch'))

    render(<UserList />, { wrapper: createWrapper() })

    await waitFor(() => {
      expect(screen.getByText('Error: Failed to fetch')).toBeInTheDocument()
    })
  })
})
```

## Testing Patterns

### Mock External Dependencies

```ts
// Mock fetch
vi.mock('globalThis.fetch', () => ({
  fetch: vi.fn(),
}))

// Mock modules
vi.mock('@/api/client', () => ({
  default: {
    get: vi.fn(),
    post: vi.fn(),
  },
}))

// Mock window APIs
Object.defineProperty(window, 'localStorage', {
  value: {
    getItem: vi.fn(),
    setItem: vi.fn(),
    removeItem: vi.fn(),
  },
  writable: true,
})
```

### Test Custom Renderers

```ts
// test-utils.tsx (React)
import { render } from '@testing-library/react'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { BrowserRouter } from 'react-router-dom'

const createTestQueryClient = () =>
  new QueryClient({
    defaultOptions: {
      queries: { retry: false },
    },
  })

export function renderWithProviders(
  ui: React.ReactElement,
  options = {}
) {
  const queryClient = createTestQueryClient()
  
  return render(
    <QueryClientProvider client={queryClient}>
      <BrowserRouter>{ui}</BrowserRouter>
    </QueryClientProvider>,
    options
  )
}

// Usage
import { renderWithProviders } from '@/test-utils'
renderWithProviders(<UserList />)
```

```ts
// test-utils.ts (Vue)
import { render } from '@testing-library/vue'
import { createRouter, createWebHistory } from 'vue-router'
import { createPinia } from 'pinia'

export function renderWithProviders(component: any, options = {}) {
  const router = createRouter({
    history: createWebHistory(),
    routes: [],
  })
  
  const pinia = createPinia()
  
  return render(component, {
    global: {
      plugins: [router, pinia],
    },
    ...options,
  })
}

// Usage
import { renderWithProviders } from '@/test-utils'
renderWithProviders(UserCard, { props: { user } })
```

## Snapshot Testing

### When to Use

- Complex UI structures
- Component output consistency
- Configuration objects

### Example

```ts
it('should match snapshot', () => {
  const { container } = render(<UserCard user={mockUser} />)
  expect(container).toMatchSnapshot()
})

// For complex objects
it('should generate correct config', () => {
  const config = generateConfig(options)
  expect(config).toMatchFileSnapshot('./__snapshots__/config.json')
})
```

### Update Snapshots

```bash
# Review and update
vitest -u

# Update specific snapshot
vitest -u --testNamePattern="should match snapshot"
```

## Code Coverage

### Configuration

```ts
// vitest.config.ts
export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      thresholds: {
        global: {
          branches: 80,
          functions: 80,
          lines: 80,
          statements: 80,
        },
      },
      exclude: [
        'node_modules/',
        'src/**/*.d.ts',
        'src/**/*.stories.tsx',
        'src/test-utils.ts',
      ],
    },
  },
})
```

### Run Coverage

```bash
vitest run --coverage
```

## Testing Best Practices

### 1. Test Behavior, Not Implementation

```ts
// ✅ Good - Tests behavior
it('should add item to cart', async () => {
  await fireEvent.click(screen.getByText('Add to Cart'))
  expect(screen.getByText('1 item in cart')).toBeInTheDocument()
})

// ❌ Bad - Tests implementation
it('should call addToCart function', () => {
  expect(mockAddToCart).toHaveBeenCalled()
})
```

### 2. Use Descriptive Test Names

```ts
// ✅ Good
it('should display error message when API call fails')
it('should disable submit button while loading')

// ❌ Bad
it('test1')
it('should work')
```

### 3. Follow AAA Pattern

```ts
it('should filter active users', () => {
  // Arrange
  const users = [
    { id: 1, name: 'John', active: true },
    { id: 2, name: 'Jane', active: false },
  ]
  
  // Act
  const { result } = renderHook(() => useFilterUsers(users))
  const activeUsers = result.current.getActiveUsers()
  
  // Assert
  expect(activeUsers).toHaveLength(1)
  expect(activeUsers[0].name).toBe('John')
})
```

### 4. One Assertion Per Test (Mostly)

```ts
// ✅ Good - Focused tests
it('should increment count', () => {
  // ...
  expect(count).toBe(1)
})

it('should decrement count', () => {
  // ...
  expect(count).toBe(-1)
})

// ✅ Also OK - Related assertions
it('should swap values', () => {
  expect(a).toBe(2)
  expect(b).toBe(1)
})
```

## Key Points

- Aim for 70% unit, 20% integration, 10% E2E tests
- Test behavior, not implementation details
- Use descriptive test names
- Mock external dependencies (API, localStorage, etc.)
- Keep tests fast and isolated
- Use snapshots for complex UI, but don't overuse
- Set coverage thresholds (80%+ recommended)
- Co-locate test files with source files
- Use Testing Library for component tests
- Test edge cases and error scenarios
