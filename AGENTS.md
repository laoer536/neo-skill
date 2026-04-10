# Skills Management Guide

Manage Neo's personal Agent Skills collection.

## Project Structure

This project uses a **manual-only** approach without Git submodules:

```
.
├── meta.ts                     # Skill registry
├── scripts/
│   └── cli.ts                  # Skills management CLI
├── skills/                     # All skill directories
│   └── {skill-name}/
│       ├── SKILL.md           # Skill index
│       └── references/
│           └── *.md            # Detailed references
├── AGENTS.md                   # This guide (English)
└── AGENTS.zh.md               # Chinese version
```

## CLI Commands

```bash
pnpm start list        # List all skills
pnpm start init        # Create new skill structures (interactive)
pnpm start init -y     # Auto-create all skills from meta.ts
pnpm start --help      # Show help
```

## Adding New Skills

### Method 1: Using CLI

1. Add skill name to `manual` array in `meta.ts`:
   ```ts
   export const manual = [
     'neo',
     'react',
     'nextjs',
     'my-new-skill',  // Add here
   ]
   ```

2. Run initialization:
   ```bash
   pnpm start init -y
   ```

3. Edit the generated files:
   - `skills/my-new-skill/SKILL.md` - Skill index
   - `skills/my-new-skill/references/*.md` - Detailed references

### Method 2: Manual Creation

1. Create skill directory:
   ```bash
   mkdir -p skills/my-skill/references
   ```

2. Create `SKILL.md` following the format below

3. Add to `meta.ts` manual array

## SKILL.md Format

```markdown
---
name: skill-name
description: Brief description of the skill
metadata:
  author: Neo
  version: "2026.04.09"
  source: Manual
---

# Skill Name

> Brief summary or key principles

## Preferences

- Your preferences here

## Core References

| Topic | Description | Reference |
|-------|-------------|-----------|
| Topic 1 | Description | [topic-1](references/topic-1.md) |

## Features

### Feature A

| Topic | Description | Reference |
|-------|-------------|-----------|
| Feature A | Description | [feature-a](references/feature-a.md) |
```

## References Format

```markdown
---
name: topic-name
description: Brief description
---

# Topic Name

Description of what this covers.

## Usage

```typescript
// Code examples
```

## Key Points

- Important detail 1
- Important detail 2
```

## Writing Guidelines

1. **Be concise** - Remove fluff, keep essential information
2. **Be practical** - Focus on usage patterns and code examples
3. **One concept per file** - Split large topics
4. **Include code** - Always provide working examples
5. **Explain why** - Not just how, but when and why

## Current Skills

See [README.md](README.md) for complete skills list.
