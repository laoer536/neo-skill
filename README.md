# Neo's Skills

A curated collection of [Agent Skills](https://agentskills.io/home) reflecting Neo's preferences, best practices, and tool documentation for modern frontend development.

## Installation

### Option 1: Using CLI (Traditional)

```bash
pnpx skills add neo/skills --skill='*'
```

Or install all skills globally:

```bash
pnpx skills add neo/skills --skill='*' -g
```

Learn more about CLI usage at [skills](https://github.com/vercel-labs/skills).

### Option 2: Sync Script (Recommended for Local Development)

Sync all skills to your AI platform's local directory:

```bash
./sync-all-skills.sh
```

This will install all skills to `~/.qoder/skills/` (or your configured platform path).

**Supported AI Platforms:**
- Qoder: `~/.qoder/skills`
- Cursor: `~/.cursor/skills`
- Custom: Edit `sync-all-skills.sh` to set your target path

See [AGENTS.md](AGENTS.md) for detailed configuration.

## Skills Overview

This collection provides a one-stop skill library for developers working with Vue and React ecosystems.

### Manual Skills

> Curated with personal preferences

Manually maintained by Neo, including preferred tools, setup conventions, and best practices.

| Skill | Description |
|-------|-------------|
| [neo](skills/neo) | Neo's coding standards, tool preferences, and workflow guidelines |

### Vue Ecosystem

> Generated from official documentation

| Skill | Description |
|-------|-------------|
| [vue](skills/vue) | Vue 3 Core - Composition API, Reactivity, Components |
| [nuxt](skills/nuxt) | Nuxt 3 Framework - SSR, Server Routes, Modules |
| [pinia](skills/pinia) | Pinia - Intuitive, Type-Safe Vue State Management |
| [vitepress](skills/vitepress) | VitePress - Vite-Powered Static Site Generator |
| [vue-best-practices](skills/vue-best-practices) | Vue 3 + TypeScript Best Practices |

### React Ecosystem

> Generated from official documentation

| Skill | Description |
|-------|-------------|
| [react](skills/react) | React 18+ - Hooks, Components, Context, Suspense |
| [nextjs](skills/nextjs) | Next.js 14+ App Router - Server Components, Server Actions |

### Shared Tools

> Build tools and utilities for both ecosystems

| Skill | Description |
|-------|-------------|
| [vite](skills/vite) | Vite Build Tool - Config, Plugins, SSR |
| [vitest](skills/vitest) | Vitest - Vite-Native Unit Testing Framework |
| [pnpm](skills/pnpm) | pnpm - Fast, Disk-Space Efficient Package Manager |

## Adding New Skills

1. Add skill name to `meta.ts` manual array
2. Run `pnpm start init` to create skill structure
3. Create detailed references in `skills/{name}/references/`

See [AGENTS.md](AGENTS.md) for detailed guidelines.

## License

Skills and scripts in this repository are under [MIT](LICENSE.md) License.
