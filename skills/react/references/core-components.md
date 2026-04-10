---
name: core-components
description: Functional components, props, JSX, composition patterns
---

# React Components

Building blocks of React applications using functional components.

## Basic Component

```tsx
interface CounterProps {
  title: string
  count?: number
  onIncrement?: () => void
  children?: React.ReactNode
}

export function Counter(props: CounterProps) {
  const { title, count = 0, onIncrement, children } = props
  
  return (
    <div>
      <h2>{title}</h2>
      <p>Count: {count}</p>
      {onIncrement && (
        <button onClick={onIncrement}>Increment</button>
      )}
      {children}
    </div>
  )
}
```

## Component Composition

### Container Pattern

```tsx
interface CardProps {
  children: React.ReactNode
  className?: string
}

function Card(props: CardProps) {
  const { children, className = '' } = props
  
  return (
    <div className={`card ${className}`}>
      {children}
    </div>
  )
}

function CardHeader({ children }: { children: React.ReactNode }) {
  return <div className="card-header">{children}</div>
}

function CardBody({ children }: { children: React.ReactNode }) {
  return <div className="card-body">{children}</div>
}

function CardFooter({ children }: { children: React.ReactNode }) {
  return <div className="card-footer">{children}</div>
}

// Usage
function UserCard() {
  return (
    <Card>
      <CardHeader>
        <h2>User Profile</h2>
      </CardHeader>
      <CardBody>
        <p>User details here...</p>
      </CardBody>
      <CardFooter>
        <button>Edit</button>
      </CardFooter>
    </Card>
  )
}
```

### Render Props Pattern

```tsx
interface RenderProps<T> {
  data: T
  loading: boolean
  error: Error | null
}

function Fetcher<T>({
  url,
  children
}: {
  url: string
  children: (props: RenderProps<T>) => React.ReactNode
}) {
  const [data, setData] = useState<T | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<Error | null>(null)
  
  useEffect(() => {
    fetch(url)
      .then(res => res.json())
      .then(setData)
      .catch(setError)
      .finally(() => setLoading(false))
  }, [url])
  
  return children({ data: data as T, loading, error })
}

// Usage
function UserList() {
  return (
    <Fetcher<User[]> url="/api/users">
      ({ data, loading, error }) => {
        if (loading) return <p>Loading...</p>
        if (error) return <p>Error: {error.message}</p>
        return (
          <ul>
            {data.map(user => (
              <li key={user.id}>{user.name}</li>
            ))}
          </ul>
        )
      }
    </Fetcher>
  )
}
```

## Props Patterns

### Optional Props with Defaults

```tsx
interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'danger'
  size?: 'sm' | 'md' | 'lg'
  disabled?: boolean
  onClick?: () => void
  children: React.ReactNode
}

function Button(props: ButtonProps) {
  const { variant = 'primary', size = 'md', disabled = false, onClick, children } = props
  
  const className = `btn btn-${variant} btn-${size}`
  
  return (
    <button
      className={className}
      disabled={disabled}
      onClick={onClick}
    >
      {children}
    </button>
  )
}
```

### Rest Props

```tsx
interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label: string
  error?: string
}

function Input(props: InputProps) {
  const { label, error, className = '', ...rest } = props
  
  return (
    <div>
      <label>{label}</label>
      <input
        className={`input ${error ? 'input-error' : ''} ${className}`}
        {...rest}
      />
      {error && <span className="error">{error}</span>}
    </div>
  )
}

// Usage - all standard input props work
<Input
  label="Email"
  type="email"
  placeholder="Enter your email"
  error="Invalid email format"
/>
```

## Component Variants

### Forward Ref

```tsx
import { forwardRef, useRef } from 'react'

interface CustomInputProps {
  label: string
  value: string
  onChange: (value: string) => void
}

const CustomInput = forwardRef<HTMLInputElement, CustomInputProps>(
  function CustomInput(props, ref) {
    const { label, value, onChange } = props
    
    return (
      <div>
        <label>{label}</label>
        <input
          ref={ref}
          value={value}
          onChange={(e) => onChange(e.target.value)}
        />
      </div>
    )
  }
)

CustomInput.displayName = 'CustomInput'

// Usage
function Form() {
  const inputRef = useRef<HTMLInputElement>(null)
  
  const focusInput = () => {
    inputRef.current?.focus()
  }
  
  return (
    <div>
      <CustomInput
        ref={inputRef}
        label="Name"
        value=""
        onChange={() => {}}
      />
      <button onClick={focusInput}>Focus Input</button>
    </div>
  )
}
```

## Key Points

- Prefer functional components over class components
- Use TypeScript interfaces for props
- Provide default values for optional props
- Use composition over inheritance
- Keep components small and focused
- Extract reusable logic into custom hooks
