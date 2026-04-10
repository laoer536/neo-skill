---
name: best-practices-deployment
description: Next.js deployment - Vercel, Docker, self-hosting, environment variables
---

# Deployment

Deploy Next.js applications to various platforms.

## Vercel (Recommended)

### Automatic Deployment

```bash
# Connect GitHub repo to Vercel
# Push to main branch → Auto deploy
```

### Environment Variables

```bash
# Set in Vercel Dashboard
DATABASE_URL=postgresql://...
NEXT_PUBLIC_API_URL=https://api.example.com
```

### Preview Deployments

Every PR gets automatic preview URL.

## Docker

### Dockerfile

```dockerfile
# Base image
FROM node:20-alpine AS base

# Dependencies
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json pnpm-lock.yaml* ./
RUN corepack enable pnpm && pnpm install --frozen-lockfile

# Builder
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN corepack enable pnpm && pnpm build

# Runner
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT 3000

CMD ["node", "server.js"]
```

### next.config.ts

```ts
const config: NextConfig = {
  output: 'standalone',
}
```

### Build and Run

```bash
docker build -t my-next-app .
docker run -p 3000:3000 my-next-app
```

## Self-Hosting

### Node.js Server

```bash
pnpm build
pnpm start
```

### PM2

```bash
pm2 start npm --name "my-app" -- start
pm2 save
pm2 startup
```

## Environment Variables

### .env.local

```bash
# Server-side only
DATABASE_URL=postgresql://localhost:5432/mydb
SECRET_KEY=mysecret

# Client-side (prefixed with NEXT_PUBLIC_)
NEXT_PUBLIC_API_URL=https://api.example.com
NEXT_PUBLIC_GA_ID=GA-123456
```

### Validation

```tsx
// lib/env.ts
import { z } from 'zod'

const envSchema = z.object({
  DATABASE_URL: z.string().url(),
  SECRET_KEY: z.string().min(32),
  NEXT_PUBLIC_API_URL: z.string().url(),
})

export const env = envSchema.parse(process.env)
```

## CI/CD

### GitHub Actions

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - uses: pnpm/action-setup@v2
        with:
          version: 8
      
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      
      - run: pnpm install
      - run: pnpm build
      - run: pnpm test
      
      # Deploy to Vercel
      - uses: amondnet/vercel-action@v20
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
```

## Monitoring

### Web Vitals

```tsx
// app/layout.tsx
import { Analytics } from '@vercel/analytics/react'
import { SpeedInsights } from '@vercel/speed-insights/next'

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html>
      <body>
        {children}
        <Analytics />
        <SpeedInsights />
      </body>
    </html>
  )
}
```

## Deployment Checklist

- ✅ Set environment variables
- ✅ Run build locally first
- ✅ Test production build
- ✅ Configure custom domain
- ✅ Enable HTTPS
- ✅ Set up monitoring
- ✅ Configure error tracking
- ✅ Backup database
- ✅ Test deployment rollback

## Key Points

- Vercel is easiest for Next.js
- Use Docker for self-hosting
- Validate environment variables
- Monitor with Web Vitals
- Test before deploying
