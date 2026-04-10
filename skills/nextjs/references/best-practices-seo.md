---
name: best-practices-seo
description: Next.js SEO - Metadata, sitemaps, structured data, Open Graph
---

# SEO

Optimize Next.js applications for search engines.

## Metadata

### Static Metadata

```tsx
// app/layout.tsx
export const metadata = {
  title: {
    default: 'My App',
    template: '%s | My App',
  },
  description: 'My awesome application',
  keywords: ['nextjs', 'react', 'seo'],
  authors: [{ name: 'Neo' }],
  creator: 'Neo',
  publisher: 'My Company',
  robots: 'index, follow',
  icons: {
    icon: '/favicon.ico',
    apple: '/apple-touch-icon.png',
  },
}
```

### Dynamic Metadata

```tsx
// app/posts/[slug]/page.tsx
export async function generateMetadata({ params }: { params: { slug: string } }) {
  const post = await getPost(params.slug)
  
  return {
    title: post.title,
    description: post.excerpt,
    openGraph: {
      title: post.title,
      description: post.excerpt,
      images: [post.coverImage],
      type: 'article',
      publishedTime: post.date,
      authors: [post.author],
    },
    twitter: {
      card: 'summary_large_image',
      title: post.title,
      description: post.excerpt,
      images: [post.coverImage],
    },
  }
}
```

## Sitemaps

### Dynamic Sitemap

```tsx
// app/sitemap.ts
import { MetadataRoute } from 'next'

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const posts = await getPosts()
  
  return [
    {
      url: 'https://example.com',
      lastModified: new Date(),
      changeFrequency: 'daily',
      priority: 1,
    },
    ...posts.map(post => ({
      url: `https://example.com/posts/${post.slug}`,
      lastModified: new Date(post.updatedAt),
      changeFrequency: 'weekly' as const,
      priority: 0.8,
    })),
  ]
}
```

## Robots.txt

```tsx
// app/robots.ts
import { MetadataRoute } from 'next'

export default function robots(): MetadataRoute.Robots {
  return {
    rules: {
      userAgent: '*',
      allow: '/',
      disallow: ['/admin/', '/api/'],
    },
    sitemap: 'https://example.com/sitemap.xml',
  }
}
```

## Structured Data

### JSON-LD

```tsx
// app/posts/[slug]/page.tsx
function JsonLd({ post }: { post: Post }) {
  const jsonLd = {
    '@context': 'https://schema.org',
    '@type': 'Article',
    headline: post.title,
    description: post.excerpt,
    image: post.coverImage,
    datePublished: post.date,
    author: {
      '@type': 'Person',
      name: post.author,
    },
  }
  
  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
    />
  )
}

export default function PostPage({ post }: { post: Post }) {
  return (
    <article>
      <JsonLd post={post} />
      <h1>{post.title}</h1>
      {/* Content */}
    </article>
  )
}
```

## Open Graph

### Complete OG Setup

```tsx
export const metadata = {
  openGraph: {
    title: 'My Page Title',
    description: 'My page description',
    url: 'https://example.com/page',
    siteName: 'My Site',
    images: [
      {
        url: 'https://example.com/og-image.jpg',
        width: 1200,
        height: 630,
        alt: 'OG Image',
      },
    ],
    locale: 'en_US',
    type: 'website',
  },
}
```

## SEO Checklist

- ✅ Unique title for each page
- ✅ Meta description (150-160 chars)
- ✅ Open Graph tags for social sharing
- ✅ Twitter Card tags
- ✅ Sitemap.xml
- ✅ Robots.txt
- ✅ Structured data (JSON-LD)
- ✅ Semantic HTML
- ✅ Proper heading hierarchy
- ✅ Alt text for images
- ✅ Canonical URLs

## Key Points

- Use Metadata API for SEO
- Generate dynamic sitemaps
- Add structured data for rich results
- Optimize for social sharing
- Follow semantic HTML practices
