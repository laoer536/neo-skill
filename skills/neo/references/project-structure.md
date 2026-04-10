---
name: project-structure
description: Neo's project structure conventions for Vue and React applications
---

# Project Structure

## Styling Strategy: New vs Existing Projects

**Before setting up your project structure, determine the styling approach:**

### New Projects - Tailwind CSS (Recommended)

For new projects, we recommend using **Tailwind CSS** with single file components:

**Advantages:**
- Faster development with utility classes
- Smaller bundle size (purges unused styles)
- No need to manage separate style files
- Consistent design system
- Better developer experience

**File Structure:**
```bash
components/
├── UserCard.tsx          # Single file with Tailwind classes
├── UserProfile.vue       # Single file with Tailwind classes
└── Button.tsx            # No separate .less/.scss file
```

**Component Example (React):**
```tsx
// UserCard.tsx - Single file with Tailwind
interface UserCardProps {
  user: { id: string; name: string; email: string }
}

export function UserCard(props: UserCardProps) {
  const { user } = props

  return (
    <div className="p-4 border border-gray-200 rounded-lg">
      <h3 className="text-xl font-semibold mb-2">{user.name}</h3>
      <p className="text-gray-600">{user.email}</p>
    </div>
  )
}
```

**Component Example (Vue):**
```vue
<!-- UserCard.vue - Single file with Tailwind -->
<script setup lang="ts">
// ❌ Avoid destructuring props — it breaks reactivity
// const { user } = defineProps<...>()  // Wrong!
const props = defineProps<{
  user: { id: string; name: string; email: string }
}>()
</script>

<template>
  <div class="p-4 border border-gray-200 rounded-lg">
    <h3 class="text-xl font-semibold mb-2">{{ props.user.name }}</h3>
    <p class="text-gray-600">{{ props.user.email }}</p>
  </div>
</template>
```

### Existing Projects - Less/SCSS

For existing projects already using Less or SCSS, maintain consistency with **component folders**:

**When to Use:**
- Project already has Less/SCSS setup
- Complex custom styles that are hard to convert
- Team familiar with CSS preprocessors
- Large codebase that's costly to migrate

**File Structure:**
```bash
components/
├── UserCard/
│   ├── index.tsx         # Component
│   └── index.less        # Component styles
└── UserProfile/
    ├── index.vue         # Component
    └── index.scss        # Component styles
```

### Migration Guide

If converting from Less/SCSS to Tailwind CSS:

1. **Don't rewrite everything at once** - Gradual migration
2. **New components use Tailwind** - Start fresh with new features
3. **Refactor old components** - When touching existing code
4. **Keep both temporarily** - During transition period

---

## Vue + Nuxt Project Structure

### Standard Nuxt 3 Project

```
my-nuxt-app/
├── .nuxt/                    # Generated (gitignore)
├── .output/                  # Build output (gitignore)
├── assets/                   # Uncompiled assets (images, styles)
├── components/               # Auto-imported components
│   ├── ui/                   # UI component library
│   │   ├── Button.vue
│   │   ├── Input.vue
│   │   └── Modal.vue
│   ├── layout/               # Layout components
│   │   ├── Header.vue
│   │   └── Footer.vue
│   └── features/             # Feature-specific components
│       └── UserCard.vue
├── composables/              # Auto-imported composables
│   ├── useAuth.ts
│   ├── useApi.ts
│   └── useAnalytics.ts
├── layouts/                  # Page layouts
│   ├── default.vue
│   └── auth.vue
├── middleware/               # Route middleware
│   └── auth.ts
├── pages/                    # File-based routing
│   ├── index.vue
│   ├── about.vue
│   └── users/
│       ├── index.vue
│       └── [id].vue
├── plugins/                  # Nuxt plugins
│   ├── api.ts
│   └── analytics.ts
├── public/                   # Static assets (served as-is)
│   ├── favicon.ico
│   └── robots.txt
├── server/                   # Server-side code
│   ├── api/                  # API routes
│   │   └── users/
│   │       ├── index.ts
│   │       └── [id].ts
│   ├── middleware/           # Server middleware
│   └── utils/                # Server utilities
├── stores/                   # Pinia stores (auto-imported)
│   ├── useUserStore.ts
│   └── useCartStore.ts
├── types/                    # TypeScript type definitions
│   ├── api.ts
│   ├── user.ts
│   └── index.ts
├── utils/                    # Utility functions
│   ├── format.ts
│   └── validation.ts
├── .env                      # Environment variables (gitignore)
├── .env.example              # Environment variables template
├── app.vue                   # Root component
├── nuxt.config.ts            # Nuxt configuration
├── tsconfig.json             # TypeScript configuration
├── eslint.config.js          # ESLint configuration

├── package.json
└── README.md
```

### Vue + Vite Project (Non-Nuxt)

```
my-vue-app/
├── public/                   # Static assets
├── src/
│   ├── assets/              # Images, fonts, global styles
│   ├── components/          # Reusable components
│   │   ├── ui/              # UI component library
│   │   ├── features/        # Feature components
│   │   └── common/          # Shared components
│   ├── composables/         # Vue composables
│   │   ├── useAuth.ts
│   │   └── useApi.ts
│   ├── directives/          # Custom directives
│   ├── layouts/             # Layout components
│   ├── pages/               # Page components (Vue Router)
│   ├── plugins/             # Vue plugins
│   ├── router/              # Vue Router config
│   │   ├── index.ts
│   │   └── routes.ts
│   ├── stores/              # Pinia stores
│   │   ├── useUserStore.ts
│   │   └── index.ts
│   ├── styles/              # Global styles
│   │   ├── main.css
│   │   └── variables.css
│   ├── types/               # TypeScript types
│   │   ├── api.ts
│   │   └── index.ts
│   ├── utils/               # Utility functions
│   ├── views/               # Page views (alternative to pages/)
│   ├── App.vue              # Root component
│   ├── main.ts              # Entry point
│   └── auto-imports.d.ts    # Auto-generated (unplugin-auto-import)
├── .env
├── .env.example
├── index.html
├── vite.config.ts
├── tsconfig.json
├── eslint.config.js
├── package.json
└── README.md
```

## React + Next.js Project Structure

### Next.js 15+ App Router

```
my-next-app/
├── .next/                   # Build output (gitignore)
├── app/                     # App Router (Next.js 13+)
│   ├── (auth)/              # Route group (doesn't affect URL)
│   │   ├── login/
│   │   │   └── page.tsx
│   │   └── register/
│   │       └── page.tsx
│   ├── (marketing)/         # Another route group
│   │   ├── about/
│   │   │   └── page.tsx
│   │   └── layout.tsx
│   ├── api/                 # API routes
│   │   ├── users/
│   │   │   ├── route.ts     # GET, POST, etc.
│   │   │   └── [id]/
│   │   │       └── route.ts
│   │   └── webhooks/
│   │       └── stripe/
│   │           └── route.ts
│   ├── dashboard/
│   │   ├── @analytics/      # Parallel routes
│   │   │   └── page.tsx
│   │   ├── @team/
│   │   │   └── page.tsx
│   │   ├── layout.tsx
│   │   └── page.tsx
│   ├── users/
│   │   ├── [id]/
│   │   │   ├── profile/
│   │   │   │   └── page.tsx
│   │   │   └── page.tsx
│   │   └── page.tsx
│   ├── actions.ts           # Server Actions
│   ├── globals.css          # Global styles
│   ├── layout.tsx           # Root layout
│   ├── loading.tsx          # Global loading UI
│   ├── error.tsx            # Global error boundary
│   ├── not-found.tsx        # 404 page
│   └── page.tsx             # Home page
├── components/              # React components
│   ├── ui/                  # UI component library
│   │   ├── button.tsx
│   │   ├── input.tsx
│   │   └── modal.tsx
│   ├── layout/              # Layout components
│   │   ├── header.tsx
│   │   └── footer.tsx
│   ├── features/            # Feature-specific components
│   │   └── UserCard.tsx
│   └── providers/           # Context providers
│       ├── auth-provider.tsx
│       └── theme-provider.tsx
├── hooks/                   # Custom React hooks
│   ├── useAuth.ts
│   ├── useApi.ts
│   └── useAnalytics.ts
├── lib/                     # Library code, utilities
│   ├── api.ts               # API client
│   ├── auth.ts              # Auth utilities
│   ├── db.ts                # Database client
│   └── utils.ts             # Helper functions
├── public/                  # Static assets
│   ├── images/
│   └── fonts/
├── styles/                  # Style files (if not using CSS-in-JS)
│   └── globals.css
├── types/                   # TypeScript type definitions
│   ├── api.ts
│   ├── user.ts
│   └── index.ts
├── middleware.ts            # Next.js middleware
├── next.config.js           # Next.js configuration
├── tsconfig.json
├── eslint.config.js
├── tailwind.config.ts       # Tailwind CSS config (if using)
├── .env.local               # Environment variables (gitignore)
├── .env.example
├── package.json
└── README.md
```

### React + Vite Project (SPA)

```
my-react-app/
├── public/                  # Static assets
├── src/
│   ├── assets/             # Images, fonts
│   ├── components/         # React components
│   │   ├── ui/             # UI component library
│   │   ├── features/       # Feature components
│   │   └── common/         # Shared components
│   ├── hooks/              # Custom hooks
│   │   ├── useAuth.ts
│   │   └── useApi.ts
│   ├── pages/              # Page components
│   ├── providers/          # Context providers
│   │   ├── auth-provider.tsx
│   │   └── theme-provider.tsx
│   ├── routes/             # React Router config
│   │   ├── index.tsx
│   │   └── protected.tsx
│   ├── services/           # API services
│   │   ├── api.ts
│   │   └── auth.ts
│   ├── stores/             # State management (Zustand)
│   │   ├── useAuthStore.ts
│   │   └── index.ts
│   ├── styles/             # Global styles
│   │   └── index.css
│   ├── types/              # TypeScript types
│   │   ├── api.ts
│   │   └── index.ts
│   ├── utils/              # Utility functions
│   ├── App.tsx             # Root component
│   ├── main.tsx            # Entry point
│   └── vite-env.d.ts       # Vite type declarations
├── .env
├── .env.example
├── index.html
├── vite.config.ts
├── tsconfig.json
├── eslint.config.js
├── tailwind.config.ts
├── package.json
└── README.md
```

## Monorepo Structure (Turborepo + pnpm)

```
my-monorepo/
├── apps/
│   ├── web/                # Next.js web app
│   │   ├── app/
│   │   ├── components/
│   │   └── package.json
│   ├── docs/               # VitePress documentation
│   │   ├── docs/
│   │   └── package.json
│   └── admin/              # Nuxt admin panel
│       ├── pages/
│       └── package.json
├── packages/
│   ├── ui/                 # Shared UI components
│   │   ├── src/
│   │   │   ├── button.tsx
│   │   │   └── input.tsx
│   │   ├── package.json
│   │   └── tsconfig.json
│   ├── config/             # Shared configs
│   │   ├── eslint/
│   │   ├── typescript/
│   │   └── package.json
│   ├── utils/              # Shared utilities
│   │   ├── src/
│   │   │   ├── format.ts
│   │   │   └── validation.ts
│   │   └── package.json
│   ├── types/              # Shared TypeScript types
│   │   ├── src/
│   │   │   ├── api.ts
│   │   │   └── user.ts
│   │   └── package.json
│   └── api-client/         # Shared API client
│       ├── src/
│       │   └── client.ts
│       └── package.json
├── .turbo/                 # Turborepo cache (gitignore)
├── node_modules/           # pnpm (gitignore)
├── pnpm-workspace.yaml     # Workspace config
├── turbo.json              # Turborepo config
├── package.json
└── README.md
```

## Key Principles

### 1. Feature-Based Organization

Group by feature, not by type:

```
# ✅ Good - Feature-based
features/
├── auth/
│   ├── login.tsx
│   ├── register.tsx
│   └── useAuth.ts
└── users/
    ├── UserList.tsx
    └── useUsers.ts

# ❌ Bad - Type-based
components/
hooks/
pages/
```

### 2. Colocation

Keep related files together:

**Pattern A: Single File Component (Tailwind CSS - New Projects)**
```
components/
└── UserCard.tsx          # Component with Tailwind classes
```

**Pattern B: Component Folder (Less/SCSS - Existing Projects)**
```
components/
└── UserCard/
    ├── index.tsx           # Component (default export)
    ├── index.less          # Styles (or index.scss)
    ├── UserCard.test.tsx   # Tests
    └── types.ts            # Types (optional)
```

### Component Folder Pattern (Less/SCSS Projects Only)

> **Note**: This pattern is for **existing projects using Less/SCSS**. For new projects, use Tailwind CSS with single file components.

When using Less or SCSS with component-scoped styles, organize as:

```
components/
└── ComponentName/              # PascalCase folder name
    ├── index.tsx               # or index.vue for Vue
    ├── index.less              # or index.scss (component styles)
    ├── ComponentName.test.tsx  # Tests (optional, can be colocated)
    └── types.ts                # Types (optional, if needed)
```

**Example - React Component:**

```
components/
└── UserCard/
    ├── index.tsx               # Main component
    └── index.less              # Component-specific styles
```

```tsx
// components/UserCard/index.tsx
import './index.less' // Import component styles

interface UserCardProps {
  user: { id: string; name: string; email: string }
}

export function UserCard(props: UserCardProps) {
  const { user } = props

  return (
    <div className="user-card">
      <h3>{user.name}</h3>
      <p>{user.email}</p>
    </div>
  )
}
```

```less
// components/UserCard/index.less
.user-card {
  padding: 1rem;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  
  h3 {
    margin: 0 0 0.5rem;
    font-size: 1.25rem;
  }
  
  p {
    margin: 0;
    color: #666;
  }
}
```

**Example - Vue Component:**

```
components/
└── UserCard/
    ├── index.vue             # Main component
    └── index.less            # Component-specific styles
```

```vue
<!-- components/UserCard/index.vue -->
<script setup lang="ts">
import './index.less'

// ❌ Avoid destructuring props — it breaks reactivity
// const { user } = defineProps<...>()  // Wrong!
const props = defineProps<{
  user: { id: string; name: string; email: string }
}>()
</script>

<template>
  <div class="user-card">
    <h3>{{ props.user.name }}</h3>
    <p>{{ props.user.email }}</p>
  </div>
</template>
```

**Usage:**

```tsx
// Import from folder (uses index.tsx automatically)
import UserCard from '@/components/UserCard'

// Or explicit
import UserCard from '@/components/UserCard/index'
```

### 3. Clear Boundaries

- **components/**: UI only, no business logic
- **lib/**: Pure utilities, framework-agnostic
- **services/**: External API communication
- **hooks/** or **composables/**: Reusable logic
- **stores/**: Global state management

### 4. Avoid Deep Nesting

Keep directory depth to 3-4 levels maximum:

```
# ✅ Good (3 levels)
components/ui/button.tsx

# ❌ Bad (6 levels)
components/features/users/list/items/user.tsx
```

### 5. Use Index Files Sparingly

Only use `index.ts` when it adds value. Two valid use cases:

**Case 1: Clean public API for a library/package**

```ts
// ✅ Good - provides a clean public API surface
// packages/ui/index.ts
export { Button } from './button'
export { Input } from './input'
export { Modal } from './modal'

// Consumer imports from one place
import { Button, Modal } from '@my-org/ui'
```

**Case 2: Barrel file for a feature folder (when sub-imports are messy)**

```ts
// ✅ Good - hides internal structure
// features/auth/index.ts
export { LoginForm } from './LoginForm'
export { AuthGuard } from './AuthGuard'
export { useAuth } from './useAuth'

// Consumer gets clean imports
import { LoginForm, useAuth } from '@/features/auth'
```

**When NOT to use index.ts:**

```ts
// ❌ Bad - single component, no need to hide anything
// components/Button/index.ts
export { Button } from './Button'  // Just use '@/components/Button' directly

// ❌ Bad - unnecessary indirection for a few files
// utils/index.ts
export { formatDate } from './formatDate'
export { validateEmail } from './validateEmail'
// Just import from '@/utils/formatDate' directly
```

**Rule of thumb**: If the folder contains mostly standalone files and there's no real internal complexity to hide, skip the `index.ts`.

## Environment Variables

```
.env                 # Local development (gitignore)
.env.example         # Template with dummy values (commit)
.env.local           # Local overrides (gitignore)
.env.production      # Production values
.env.staging         # Staging values
.env.test            # Test environment
```

### Naming Convention

```bash
# Public (exposed to browser)
NEXT_PUBLIC_API_URL=https://api.example.com
VITE_API_URL=https://api.example.com

# Server-only
DATABASE_URL=postgresql://...
SECRET_KEY=abc123

# Feature flags
ENABLE_ANALYTICS=true
ENABLE_BETA=false
```

## Key Points

### Styling Strategy
- **New Projects**: Use Tailwind CSS with single file components
- **Existing Projects (Less/SCSS)**: Use component folders with `index.less/scss`
- **Don't mix in same project**: Choose one approach and stick to it
- **Migration**: Gradually convert from Less/SCSS to Tailwind when refactoring

### Structure Principles
- Consistency across projects is crucial
- Adapt structure to project size (smaller = simpler)
- Use feature-based organization for large apps
- Keep related files colocated
- Maintain clear boundaries between layers
- Document non-obvious structural decisions
