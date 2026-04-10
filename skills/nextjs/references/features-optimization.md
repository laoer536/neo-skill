---
name: features-optimization
description: Next.js optimization - Image, Font, Script optimization, lazy loading
---

# Optimization

Optimize Next.js applications for better performance.

## Image Optimization

### Basic Image

```tsx
import Image from 'next/image'

export function HeroImage() {
  return (
    <Image
      src="/hero.jpg"
      alt="Hero"
      width={1200}
      height={600}
      priority // Load immediately for LCP
    />
  )
}
```

### Remote Image

```tsx
// next.config.ts
const config = {
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'images.example.com',
        pathname: '/**',
      },
    ],
  },
}

// Component
<Image
  src="https://images.example.com/photo.jpg"
  alt="Remote"
  width={800}
  height={600}
/>
```

### Responsive Image

```tsx
<Image
  src="/responsive.jpg"
  alt="Responsive"
  width={800}
  height={600}
  sizes="(max-width: 768px) 100vw, 800px"
  style={{ width: '100%', height: 'auto' }}
/>
```

## Font Optimization

### Google Fonts

```tsx
// app/layout.tsx
import { Inter, Roboto_Mono } from 'next/font/google'

const inter = Inter({ 
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-inter',
})

const robotoMono = Roboto_Mono({
  subsets: ['latin'],
  variable: '--font-roboto-mono',
})

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html className={`${inter.variable} ${robotoMono.variable}`}>
      <body style={{ fontFamily: 'var(--font-inter)' }}>
        {children}
      </body>
    </html>
  )
}
```

### Local Fonts

```tsx
import localFont from 'next/font/local'

const myFont = localFont({
  src: './my-font.woff2',
  display: 'swap',
  variable: '--font-my-font',
})
```

## Script Optimization

### Third-party Scripts

```tsx
import Script from 'next/script'

export default function Layout() {
  return (
    <>
      {/* Load before page is interactive */}
      <Script
        src="https://www.google-analytics.com/analytics.js"
        strategy="beforeInteractive"
      />
      
      {/* Load after page becomes interactive */}
      <Script
        src="https://connect.facebook.net/en_US/sdk.js"
        strategy="lazyOnload"
      />
      
      {/* Load on idle */}
      <Script
        id="chat-widget"
        strategy="worker"
      >
        {`
          console.log('Script executed')
        `}
      </Script>
    </>
  )
}
```

## Lazy Loading

### Component Lazy Loading

```tsx
import dynamic from 'next/dynamic'

const HeavyChart = dynamic(() => import('./HeavyChart'), {
  loading: () => <p>Loading chart...</p>,
  ssr: false, // Disable SSR if needed
})

export function Dashboard() {
  return (
    <div>
      <h1>Dashboard</h1>
      <HeavyChart />
    </div>
  )
}
```

### Route-based Splitting

Next.js automatically splits code by routes. No configuration needed.

## Metadata Optimization

### Static Metadata

```tsx
// app/layout.tsx
export const metadata = {
  title: 'My App',
  description: 'My awesome application',
  icons: {
    icon: '/favicon.ico',
  },
}
```

### Dynamic Metadata

```tsx
// app/posts/[slug]/page.tsx
export async function generateMetadata({ 
  params 
}: { 
  params: { slug: string } 
}) {
  const post = await getPost(params.slug)
  
  return {
    title: post.title,
    description: post.excerpt,
    openGraph: {
      images: [post.coverImage],
    },
  }
}
```

## Performance Best Practices

```tsx
// ✅ Use next/image for all images
<Image src="/photo.jpg" alt="Photo" width={800} height={600} />

// ✅ Use next/font for fonts
const inter = Inter({ subsets: ['latin'] })

// ✅ Use dynamic import for heavy components
const Chart = dynamic(() => import('./Chart'))

// ✅ Use priority for LCP images
<Image src="/hero.jpg" alt="Hero" width={1200} height={600} priority />

// ❌ Don't use regular img tag
<img src="/photo.jpg" alt="Photo" />
```

## Key Points

- Always use `<Image>` component
- Optimize fonts with `next/font`
- Use `<Script>` for third-party scripts
- Lazy load heavy components with `dynamic()`
- Set proper metadata for SEO
- Use `priority` for LCP images
