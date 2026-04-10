---
name: best-practices-performance
description: Next.js performance - Caching strategies, streaming, partial prerendering
---

# Performance

Optimize Next.js applications for maximum performance.

## Caching Strategies

### Static Generation (Fastest)

```tsx
// Default behavior - cached forever
async function StaticPage() {
  const data = await fetch('https://api.example.com/data')
  return <div>{data}</div>
}
```

### Revalidation

```tsx
// Time-based
await fetch('/api/data', { next: { revalidate: 3600 } })

// On-demand
revalidatePath('/page')
revalidateTag('tag')
```

### Cache Hierarchy

```
1. Full Route Cache (30s default)
2. Data Cache (persistent)
3. Router Cache (client-side, session)
```

## Streaming

### Suspense Boundaries

```tsx
export default function Page() {
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
    </div>
  )
}
```

### Progressive Loading

```tsx
async function ProductPage() {
  return (
    <div>
      {/* Load immediately */}
      <ProductInfo />
      
      {/* Load in background */}
      <Suspense fallback={<ReviewsSkeleton />}>
        <ProductReviews />
      </Suspense>
      
      {/* Load after interaction */}
      <Suspense fallback={<RelatedSkeleton />}>
        <RelatedProducts />
      </Suspense>
    </div>
  )
}
```

## Partial Prerendering (Next.js 14+)

```tsx
// app/layout.tsx
export const experimental_ppr = true

export default function Layout({ children }: { children: React.ReactNode }) {
  return (
    <html>
      <body>
        {/* Static shell */}
        <Header />
        <main>{children}</main>
        <Footer />
      </body>
    </html>
  )
}

// app/page.tsx
export default function Page() {
  return (
    <div>
      {/* Static */}
      <h1>Welcome</h1>
      
      {/* Dynamic */}
      <Suspense fallback={<Skeleton />}>
        <UserProfile />
      </Suspense>
    </div>
  )
}
```

## Image Optimization

```tsx
// ✅ Good
<Image
  src="/photo.jpg"
  alt="Photo"
  width={800}
  height={600}
  sizes="(max-width: 768px) 100vw, 800px"
/>

// ❌ Bad
<img src="/photo.jpg" alt="Photo" />
```

## Bundle Optimization

### Dynamic Imports

```tsx
import dynamic from 'next/dynamic'

const HeavyComponent = dynamic(() => import('./Heavy'), {
  loading: () => <p>Loading...</p>,
  ssr: false,
})
```

### Route Segments

Next.js automatically code-splits by routes. No config needed.

## Performance Checklist

- ✅ Enable PPR for hybrid static/dynamic
- ✅ Use streaming with Suspense
- ✅ Cache aggressively, revalidate intelligently
- ✅ Optimize images with `<Image>`
- ✅ Lazy load heavy components
- ✅ Use Edge runtime for middleware
- ✅ Monitor with Web Vitals

## Key Points

- Prefer static generation
- Stream with Suspense
- Cache by default, revalidate when needed
- Optimize images automatically
- Code-split by routes
