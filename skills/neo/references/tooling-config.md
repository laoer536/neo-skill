---
name: tooling-config
description: Neo's tooling configuration preferences - ESLint, TypeScript, Vite, pnpm, and more
---

# Tooling Configuration

## ESLint Configuration

### Vue Project

```js
// eslint.config.js
import antfu from '@antfu/eslint-config'

export default antfu({
  vue: true,
  typescript: true,

  // Optional: Customize rules
  rules: {
    'no-console': 'warn',
    'unused-imports/no-unused-imports': 'error',
  },
  
  // Optional: Override for specific files
  overrides: [
    {
      files: ['**/*.test.ts'],
      rules: {
        'no-console': 'off',
      },
    },
  ],
})
```

### React Project

```js
// eslint.config.js
import antfu from '@antfu/eslint-config'

export default antfu({
  react: true,
  typescript: true,
  
  rules: {
    'no-console': 'warn',
    'react-hooks/rules-of-hooks': 'error',
    'react-hooks/exhaustive-deps': 'warn',
  },
})
```

### VS Code Integration

```json
// .vscode/settings.json
{
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },
  "eslint.validate": [
    "javascript",
    "typescript",
    "vue",
    "javascriptreact",
    "typescriptreact"
  ]
}
```

```json
// .vscode/extensions.json
{
  "recommendations": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "bradlc.vscode-tailwindcss"
  ]
}
```

## TypeScript Configuration

### Base Config (Shared)

```json
// packages/config/typescript/base.json
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "compilerOptions": {
    "target": "ESNext",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true
  },
  "exclude": ["node_modules", "dist"]
}
```

### Vue + Nuxt

```json
// tsconfig.json
{
  "extends": "./.nuxt/tsconfig.json",
  "compilerOptions": {
    "strict": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["src/*"],
      "~/*": ["./*"]
    }
  }
}
```

### React + Next.js

```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ESNext",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
```

### React + Vite

```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ESNext",
    "useDefineForClassFields": true,
    "lib": ["ESNext", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
```

## Vite Configuration

### Vue Project

```ts
// vite.config.ts
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueJsx from '@vitejs/plugin-vue-jsx'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { VueRouterAutoImports } from 'unplugin-vue-router'
import Pages from 'vite-plugin-pages'
import Layouts from 'vite-plugin-vue-layouts'
import { resolve } from 'node:path'

export default defineConfig({
  plugins: [
    vue(),
    vueJsx(),
    Pages(),
    Layouts(),
    AutoImport({
      imports: [
        'vue',
        'vue-router',
        VueRouterAutoImports,
        'pinia',
      ],
      dts: 'src/auto-imports.d.ts',
    }),
    Components({
      dts: 'src/components.d.ts',
    }),
  ],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
    },
  },
  server: {
    port: 3000,
    open: true,
  },
  build: {
    sourcemap: true,
    rollupOptions: {
      output: {
        manualChunks: {
          'vue-vendor': ['vue', 'vue-router', 'pinia'],
        },
      },
    },
  },
})
```

### React Project

```ts
// vite.config.ts
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'
import { resolve } from 'node:path'

export default defineConfig({
  plugins: [
    react(),
  ],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
    },
  },
  server: {
    port: 3000,
    open: true,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
      },
    },
  },
  build: {
    sourcemap: true,
    rollupOptions: {
      output: {
        manualChunks: {
          'react-vendor': ['react', 'react-dom', 'react-router-dom'],
        },
      },
    },
  },
})
```

## pnpm Configuration

### Workspace Setup

```yaml
# pnpm-workspace.yaml
packages:
  - 'apps/*'
  - 'packages/*'

# Use catalogs for version management (pnpm 9+)
catalog:
  vue: ^3.5.0
  vue-router: ^4.5.0
  pinia: ^2.2.0
  react: ^19.0.0
  react-dom: ^19.0.0
  next: ^15.0.0

catalogs:
  frontend:
    '@vueuse/core': ^11.0.0
    '@tanstack/react-query': ^5.50.0
    zustand: ^5.0.0
  dev:
    typescript: ^5.7.0
    vite: ^6.0.0
    vitest: ^4.0.0
    eslint: ^9.0.0
```

### .npmrc Configuration

```ini
# .npmrc
shamefully-hoist=false
strict-peer-dependencies=true
auto-install-peers=true
dedupe-peer-dependents=true

# Use workspace protocol by default
link-workspace-packages=true

# Faster installs
prefer-offline=true
```

### Package.json Scripts

**Vue Project:**
```json
{
  "scripts": {
    "dev": "vite",
    "build": "vue-tsc --noEmit && vite build",
    "preview": "vite preview",
    "lint": "eslint . --fix",
    "test": "vitest",
    "test:run": "vitest run",
    "test:coverage": "vitest run --coverage",
    "type-check": "vue-tsc --noEmit",
    "prepare": "simple-git-hooks"
  }
}
```

**React Project:**
```json
{
  "scripts": {
    "dev": "vite",
    "build": "tsc --noEmit && vite build",
    "preview": "vite preview",
    "lint": "eslint . --fix",
    "test": "vitest",
    "test:run": "vitest run",
    "test:coverage": "vitest run --coverage",
    "type-check": "tsc --noEmit",
    "prepare": "simple-git-hooks"
  }
}
```

## Testing Configuration (Vitest)

### Base Config

```ts
// vitest.config.ts
import { defineConfig } from 'vitest/config'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'node:path'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
    },
  },
  test: {
    globals: true,
    environment: 'jsdom',
    include: ['src/**/*.test.ts', 'src/**/*.test.tsx'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      exclude: [
        'node_modules/',
        'src/**/*.d.ts',
        'src/**/*.stories.tsx',
      ],
    },
  },
})
```

### Vue Testing Setup

```ts
// src/test-setup.ts
import { config } from '@vue/test-utils'

// Global stubs
config.global.stubs = {
  RouterLink: true,
  RouterView: true,
}

// Mock globals
global.ResizeObserver = class ResizeObserver {
  observe() {}
  unobserve() {}
  disconnect() {}
}
```

### React Testing Setup

```ts
// src/test-setup.ts
import '@testing-library/jest-dom'

// Mock window.matchMedia
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: (query: string) => ({
    matches: false,
    media: query,
    onchange: null,
    addListener: () => {},
    removeListener: () => {},
    addEventListener: () => {},
    removeEventListener: () => {},
    dispatchEvent: () => {},
  }),
})
```

## Prettier (Optional - if not using ESLint for formatting)

```js
// prettier.config.js
export default {
  semi: false,
  singleQuote: true,
  trailingComma: 'all',
  printWidth: 100,
  tabWidth: 2,
  endOfLine: 'lf',
  arrowParens: 'always',
  bracketSpacing: true,
  jsxSingleQuote: false,
}
```

## EditorConfig

```ini
# .editorconfig
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = space
indent_size = 2

[*.md]
trim_trailing_whitespace = false

[*.{yml,yaml}]
indent_size = 2

[package.json]
indent_size = 2
```

## Git Attributes

```
# .gitattributes
* text=auto eol=lf

*.ts text
*.tsx text
*.vue text
*.js text
*.json text
*.md text
*.css text
*.html text

*.png binary
*.jpg binary
*.gif binary
*.svg binary
*.ico binary
```

## Key Points

- Use `@antfu/eslint-config` as base for consistency
- Strict TypeScript mode always enabled
- Use pnpm catalogs for monorepo version management
- Auto-import composables/hooks for better DX
- Configure path aliases for clean imports
- Set up Vitest for unified testing
- Use VS Code recommendations for team consistency
- Automate formatting with ESLint/Prettier + git hooks
