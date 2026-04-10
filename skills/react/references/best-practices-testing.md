---
name: best-practices-testing
description: Testing React components - React Testing Library, hooks testing, patterns
---

# Testing React

Best practices for testing React applications.

## Component Testing

### Basic Test

```tsx
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { Button } from './Button'

test('renders button with text', () => {
  render(<Button>Click me</Button>)
  expect(screen.getByRole('button')).toHaveTextContent('Click me')
})

test('calls onClick when clicked', async () => {
  const handleClick = vi.fn()
  const user = userEvent.setup()
  
  render(<Button onClick={handleClick}>Click</Button>)
  await user.click(screen.getByRole('button'))
  
  expect(handleClick).toHaveBeenCalledTimes(1)
})
```

### Testing Forms

```tsx
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { LoginForm } from './LoginForm'

test('submits form with credentials', async () => {
  const user = userEvent.setup()
  const handleSubmit = vi.fn()
  
  render(<LoginForm onSubmit={handleSubmit} />)
  
  await user.type(screen.getByLabelText(/email/i), 'user@test.com')
  await user.type(screen.getByLabelText(/password/i), 'password123')
  await user.click(screen.getByRole('button', { name: /login/i }))
  
  expect(handleSubmit).toHaveBeenCalledWith({
    email: 'user@test.com',
    password: 'password123'
  })
})
```

## Hook Testing

### Custom Hook Test

```tsx
import { renderHook, act } from '@testing-library/react'
import { useCounter } from './useCounter'

test('increments counter', () => {
  const { result } = renderHook(() => useCounter())
  
  expect(result.current.count).toBe(0)
  
  act(() => {
    result.current.increment()
  })
  
  expect(result.current.count).toBe(1)
})

test('accepts initial value', () => {
  const { result } = renderHook(() => useCounter(10))
  expect(result.current.count).toBe(10)
})
```

## Mocking

### Mock API Calls

```tsx
import { render, screen, waitFor } from '@testing-library/react'
import { UserList } from './UserList'

test('displays users from API', async () => {
  const mockUsers = [
    { id: 1, name: 'John' },
    { id: 2, name: 'Jane' }
  ]
  
  global.fetch = vi.fn(() =>
    Promise.resolve({
      json: () => Promise.resolve(mockUsers)
    })
  )
  
  render(<UserList />)
  
  await waitFor(() => {
    expect(screen.getByText('John')).toBeInTheDocument()
    expect(screen.getByText('Jane')).toBeInTheDocument()
  })
})
```

### Mock React Query

```tsx
import { render, screen } from '@testing-library/react'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { UserProfile } from './UserProfile'

const createWrapper = () => {
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: { retry: false }
    }
  })
  return ({ children }: { children: React.ReactNode }) => (
    <QueryClientProvider client={queryClient}>
      {children}
    </QueryClientProvider>
  )
}

test('displays user data', async () => {
  render(<UserProfile userId="1" />, { wrapper: createWrapper() })
  
  expect(await screen.findByText('John Doe')).toBeInTheDocument()
})
```

## Snapshot Testing

```tsx
import { render } from '@testing-library/react'
import { Header } from './Header'

test('matches snapshot', () => {
  const { container } = render(<Header title="My App" />)
  expect(container).toMatchSnapshot()
})
```

## Testing Best Practices

```tsx
// ✅ Good: Test behavior, not implementation
test('displays error message on failure', async () => {
  // Test what user sees
})

// ❌ Bad: Test implementation details
test('sets error state to true', () => {
  // Tests internal state
})

// ✅ Good: Use semantic queries
screen.getByRole('button')
screen.getByLabelText('Email')
screen.getByText('Welcome')

// ❌ Bad: Use implementation-specific queries
screen.getByTestId('submit-button')
document.querySelector('.btn')
```

## Key Points

- Test behavior, not implementation
- Use React Testing Library
- Prefer user-event over fireEvent
- Mock external dependencies
- Test loading and error states
- Keep tests maintainable and readable
