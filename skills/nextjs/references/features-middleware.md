---
name: features-middleware
description: Next.js middleware - Edge functions, authentication, redirects
---

# Middleware

Edge middleware for request processing.

## Basic Middleware

```tsx
// middleware.ts
import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export function middleware(request: NextRequest) {
  // Add custom header
  const response = NextResponse.next()
  response.headers.set('x-custom-header', 'value')
  
  return response
}

// Run on specific paths
export const config = {
  matcher: ['/dashboard/:path*', '/api/:path*'],
}
```

## Authentication

### Protect Routes

```tsx
// middleware.ts
import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export function middleware(request: NextRequest) {
  const token = request.cookies.get('token')?.value
  
  // Protect /dashboard routes
  if (request.nextUrl.pathname.startsWith('/dashboard')) {
    if (!token) {
      return NextResponse.redirect(new URL('/login', request.url))
    }
  }
  
  return NextResponse.next()
}

export const config = {
  matcher: ['/dashboard/:path*'],
}
```

### JWT Validation

```tsx
import { jwtVerify } from 'jose'

export async function middleware(request: NextRequest) {
  const token = request.cookies.get('token')?.value
  
  if (!token) {
    return NextResponse.redirect(new URL('/login', request.url))
  }
  
  try {
    await jwtVerify(token, new TextEncoder().encode(process.env.JWT_SECRET))
    return NextResponse.next()
  } catch {
    return NextResponse.redirect(new URL('/login', request.url))
  }
}
```

## Redirects

### A/B Testing

```tsx
export function middleware(request: NextRequest) {
  const cookie = request.cookies.get('ab-test')
  
  if (!cookie) {
    // Randomly assign variant
    const variant = Math.random() > 0.5 ? 'a' : 'b'
    const response = NextResponse.next()
    response.cookies.set('ab-test', variant)
    return response
  }
  
  return NextResponse.next()
}
```

### Geo-based Redirects

```tsx
export function middleware(request: NextRequest) {
  const country = request.geo?.country
  
  if (country === 'CN') {
    return NextResponse.redirect(new URL('/zh', request.url))
  }
  
  return NextResponse.next()
}
```

## Rewrites

### Proxy API Requests

```tsx
export function middleware(request: NextRequest) {
  const url = new URL(request.url)
  
  if (url.pathname.startsWith('/api/external')) {
    const apiUrl = url.pathname.replace('/api/external', 'https://api.example.com')
    return NextResponse.rewrite(new URL(apiUrl))
  }
  
  return NextResponse.next()
}
```

## Headers

### Add Security Headers

```tsx
export function middleware(request: NextRequest) {
  const response = NextResponse.next()
  
  // Security headers
  response.headers.set('X-Frame-Options', 'DENY')
  response.headers.set('X-Content-Type-Options', 'nosniff')
  response.headers.set('Referrer-Policy', 'origin-when-cross-origin')
  response.headers.set(
    'Content-Security-Policy',
    "default-src 'self'; script-src 'self' 'unsafe-inline'"
  )
  
  return response
}
```

## Rate Limiting

```tsx
import { Ratelimit } from '@upstash/ratelimit'
import { Redis } from '@upstash/redis'

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(10, '10 s'),
})

export async function middleware(request: NextRequest) {
  const ip = request.ip ?? '127.0.0.1'
  const { success } = await ratelimit.limit(ip)
  
  if (!success) {
    return NextResponse.json(
      { error: 'Too many requests' },
      { status: 429 }
    )
  }
  
  return NextResponse.next()
}

export const config = {
  matcher: '/api/:path*',
}
```

## Middleware Best Practices

```tsx
// ✅ Keep middleware fast (runs on edge)
// ❌ Don't do heavy computations
// ❌ Don't access database directly

// ✅ Use for:
// - Authentication checks
// - Redirects
// - Rewrites
// - Headers
// - Rate limiting

// ❌ Don't use for:
// - Complex business logic
// - Database queries
// - Heavy computations
```

## Key Points

- Middleware runs on Edge before cache
- Keep it fast and simple
- Use for auth, redirects, headers
- Can't access database directly
- Use cookies for state
- Configure matcher carefully
