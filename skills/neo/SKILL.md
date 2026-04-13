---
name: neo
description: Neo's personal coding standards and engineering conventions for JavaScript/TypeScript projects. This is the PUBLIC SKILL that defines my preferences. Covers both Vue and React ecosystems. ALWAYS load this skill for any coding task.
metadata:
  author: Neo
  version: "2026.04.13"
  source: Manual
---

# Neo's Public Skill

> **This is my core skill** — it defines my personal coding standards, tooling preferences, and engineering conventions. Load this for ALL coding tasks.

## Priority & Usage Guidelines

### 🎯 This is My PUBLIC SKILL

This skill defines **my personal preferences** and should be loaded for **ALL coding tasks**. It serves as the foundation for:
- Code style and formatting conventions
- Project structure and organization
- Tooling configuration (ESLint, TypeScript, Vite, etc.)
- Git workflow and commit conventions
- Testing strategies and patterns

### ⚠️ Important: This is a Supplementary Skill

This skill serves as a **general-purpose fallback** and **supplement** to more specific skills. It should **NOT** override project-specific or framework-specific skills.

### Technology Stack Detection

**BEFORE applying any skill, always:**

1. **Check `package.json`** to identify:
   - Framework and version (Vue 3.x, React 19.x, Next.js 15.x, etc.)
   - Build tool (Vite, Webpack, etc.)
   - Styling solution (Tailwind CSS, CSS Modules, etc.)
   - State management (Pinia, Zustand, etc.)
   - Testing framework (Vitest, Jest, etc.)

2. **Check configuration files**:
   - `vite.config.ts`, `next.config.ts`, `nuxt.config.ts`
   - `tailwind.config.ts`
   - `tsconfig.json`, `eslint.config.js`

3. **Only apply relevant skills** based on detected technology stack

### Priority Rules

1. **Project-Specific Skills > This General Skill**
   - If working on a Vue project, `vue` skill rules take precedence
   - If working on a React project, `react` skill rules take precedence
   - If working on a Next.js project, `nextjs` skill rules take precedence

2. **Version-Specific Rules**
   - React 18 vs 19: Check `package.json` for exact version
   - Next.js 15: Check `package.json` for exact version
   - Apply version-specific best practices from respective skills

3. **Conflict Resolution**
   - When rules conflict, **use the more specific skill's rules**
   - This skill only applies when no other skill covers the topic
   - Example: If `vue` skill says one thing about components, and this skill says another → follow `vue` skill

4. **Complementary Usage**
   - This skill fills gaps not covered by other skills
   - Use for: general coding practices, git workflow, tooling setup, testing guidelines
   - Defer to specific skills for: framework APIs, framework-specific patterns, framework best practices

### Example Scenarios

```yaml
Scenario: Working on a Vue + Nuxt project

Skills Active: [vue, nuxt, neo]

Priority:
  1. nuxt       # Most specific - Nuxt conventions
  2. vue        # Framework-specific - Vue patterns
  3. neo        # General fallback - Git workflow, testing, etc.

If nuxt skill defines a rule → Use nuxt rule
If nuxt is silent but vue defines a rule → Use vue rule
If both are silent → Use neo rule
```

### When This Skill Applies

✅ **Use this skill for:**
- Git workflow and commit conventions
- General TypeScript practices
- Testing strategies and patterns
- File naming (when not defined by framework skills)
- Code organization principles
- Tooling configuration (ESLint, Vite, pnpm)
- Project structure (when not defined by framework skills)

❌ **Defer to specific skills for:**
- Vue component patterns → Use `vue` skill
- React hooks patterns → Use `react` skill
- Nuxt routing → Use `nuxt` skill
- Next.js App Router → Use `nextjs` skill
- Pinia state management → Use `pinia` skill
- Framework-specific best practices → Use respective framework skill

---

## Dual Ecosystem Support

> **Note**: For framework-specific patterns, always defer to the respective framework skill (`vue`, `react`, `nuxt`, `nextjs`, etc.). This skill provides general conventions that apply across ecosystems.

This skill set covers **both Vue and React ecosystems**:

### Vue Ecosystem
- **Framework**: Vue 3.5 + Nuxt 3
- **State Management**: Pinia
- **Build Tool**: Vite
- **Styling**: Tailwind CSS v4
- **Testing**: Vitest + Vue Testing Library
- **SSG**: VitePress
- **Component Patterns**: See [`vue` skill](skills/vue/SKILL.md) — always use Composition API + `<script setup lang="ts">`, prefer `shallowRef` over `ref` when deep reactivity is not needed, avoid Reactive Props Destructuring

### React Ecosystem
- **Framework**: React 19+ + Next.js 15+
- **State Management**: React Query / Zustand
- **Build Tool**: Vite / Next.js built-in
- **Styling**: Tailwind CSS v4 / CSS Modules
- **Testing**: Vitest + React Testing Library
- **SSG**: Next.js static generation

### Shared Tools
- **Package Manager**: pnpm
- **Linting**: ESLint with appropriate configs
- **Testing**: Vitest (both ecosystems)
- **Bundler**: Vite / tsdown
- **Monorepo**: Turborepo + pnpm workspaces

## When to Use Which

| Scenario | Recommendation | Reason |
|----------|---------------|--------|
| Content-heavy sites | Vue + Nuxt | Better DX, auto-imports |
| Enterprise apps | React + Next.js | Larger ecosystem, more hires |
| Rapid prototyping | Vue + Nuxt | Faster development |
| Full-stack apps | Either (Next.js/Nuxt) | Both have server features |
| Component libraries | React or Vue | Depends on target audience |
| Micro-frontends | React | Better ecosystem support |

## Coding Practices

> See [coding-style](references/coding-style.md) for detailed conventions.

### TypeScript (Neo-specific rules)

- **Function return types**: NOT mandatory for any function type (hooks, regular functions, or function components) — only declare when necessary (e.g., type inference fails, complex logic, or public API clarity)
- **Object parameters always**: Never use positional parameters — always accept an object and destructure. Adding a positional param is a breaking change; adding an optional object field is not
- **Parameter type naming**: `XxxProps` for components, `UseXxxOptions` for hooks/composables, `XxxOptions` for utility functions, `XxxData`/`XxxInput` for required data transfer objects. `Params` is reserved for route params only

---

## Tooling Choices

> See [tooling-config](references/tooling-config.md) for detailed configurations.

- **Package Manager**: pnpm
- **Linter**: ESLint with `@antfu/eslint-config`
- **TypeScript**: Strict mode, `moduleResolution: bundler`
- **Testing**: Vitest
- **Build**: Vite / tsdown

---

## Project Conventions

> See [project-structure](references/project-structure.md) for directory layouts and [git-workflow](references/git-workflow.md) for conventions.

- **File naming**: kebab-case for files, PascalCase for components/classes, camelCase for variables/functions
- **Dual ecosystem**: Vue (Nuxt/Vite) + React (Next.js/Vite) in the same projects
- **Type files**: Extract to `types.ts` or `types/*.ts`; never mix with component logic
- **Test files**: Co-located with source, `foo.ts` → `foo.test.ts`

---

## References

| Topic | Description | Ecosystem | Priority | Reference |
|-------|-------------|-----------|----------|-----------|
| Coding Style | File naming, code organization, Vue/React patterns, comments | Vue + React | P0 | [coding-style](references/coding-style.md) |
| Project Structure | Vue/Nuxt, React/Next.js, monorepo organization | Vue + React | P1 | [project-structure](references/project-structure.md) |
| Git Workflow | Branch naming, conventional commits, PR guidelines | Shared | P1 | [git-workflow](references/git-workflow.md) |
| Tooling Config | ESLint, TypeScript, Vite, pnpm, Vitest setup | Shared | P1 | [tooling-config](references/tooling-config.md) |
| Testing | Unit tests, component testing, mocking, coverage | Vue + React | P1 | [testing-guidelines](references/testing-guidelines.md) |
| Tailwind CSS v4 | Vite/Next.js setup, CSS-first theme, dark mode | Vue + React | P2 | [tailwindcss](references/tailwindcss.md) |

> **Priority**: P0 = Always load | P1 = Load when needed | P2 = Optional reference
> **Ecosystem**: Vue + React = Both ecosystems | Shared = Cross-cutting concerns

