import { existsSync, mkdirSync, readdirSync, writeFileSync } from 'node:fs'
import { dirname, join } from 'node:path'
import process from 'node:process'
import { fileURLToPath } from 'node:url'
import * as p from '@clack/prompts'
import { manual } from '../meta.ts'

const __dirname = dirname(fileURLToPath(import.meta.url))
const root = join(__dirname, '..')

function createSkillStructure(skillName: string): void {
  const skillPath = join(root, 'skills', skillName)
  const referencesPath = join(skillPath, 'references')

  if (existsSync(skillPath)) {
    p.log.warn(`Skill "${skillName}" already exists, skipping...`)
    return
  }

  mkdirSync(referencesPath, { recursive: true })

  // Create SKILL.md
  const skillMd = `---
name: ${skillName}
description: ${skillName} skill
metadata:
  author: Neo
  version: "${new Date().toISOString().split('T')[0].replace(/-/g, '.')}"
  source: Manual
---

# ${skillName.charAt(0).toUpperCase() + skillName.slice(1)}

> Add your preferences, best practices, and recommendations here.

## Preferences

- Add your preferences here

## Core References

| Topic | Description | Reference |
|-------|-------------|-----------|
| Topic 1 | Description | [topic-1](references/topic-1.md) |

## Features

### Feature A

| Topic | Description | Reference |
|-------|-------------|-----------|
| Feature A | Description | [feature-a](references/feature-a.md) |
`
  writeFileSync(join(skillPath, 'SKILL.md'), skillMd, 'utf-8')

  // Create example reference
  const referenceMd = `---
name: topic-1
description: Example topic reference
---

# Topic 1

Description of this topic.

## Usage

\`\`\`typescript
// Add code examples here
\`\`\`

## Key Points

- Important detail 1
- Important detail 2
`
  writeFileSync(join(referencesPath, 'topic-1.md'), referenceMd, 'utf-8')

  p.log.success(`Created skill: ${skillName}`)
}

async function initSkills() {
  p.intro('Skills Manager - Init')

  const skillsPath = join(root, 'skills')
  if (!existsSync(skillsPath)) {
    mkdirSync(skillsPath, { recursive: true })
  }

  const existingSkills = readdirSync(skillsPath, { withFileTypes: true })
    .filter(dirent => dirent.isDirectory())
    .map(dirent => dirent.name)

  const newSkills = manual.filter(skill => !existingSkills.includes(skill))

  if (newSkills.length === 0) {
    p.log.success('All skills already exist')
    return
  }

  p.log.info(`Found ${newSkills.length} new skill(s) to create`)

  const selected = await p.multiselect({
    message: 'Select skills to create',
    options: newSkills.map(skill => ({
      value: skill,
      label: skill,
    })),
    initialValues: newSkills,
  })

  if (p.isCancel(selected)) {
    p.cancel('Cancelled')
    return
  }

  for (const skill of selected as string[]) {
    createSkillStructure(skill)
  }

  p.outro('Skills initialized')
}

async function listSkills() {
  p.intro('Skills Manager - List')

  if (manual.length === 0) {
    p.log.warn('No skills registered in meta.ts')
    return
  }

  const skillsPath = join(root, 'skills')
  if (!existsSync(skillsPath)) {
    p.log.warn('No skills directory found')
    return
  }

  p.log.success(`Found ${manual.length} registered skill(s):`)
  
  for (const skill of manual) {
    const skillPath = join(skillsPath, skill)
    
    if (!existsSync(skillPath)) {
      p.log.message(`  - ${skill} ⚠️  (not created yet)`)
      continue
    }
    
    // Check multiple possible reference directory names
    const possibleRefDirs = ['references', 'reference']
    let refCount = 0
    
    for (const dirName of possibleRefDirs) {
      const refPath = join(skillPath, dirName)
      if (existsSync(refPath)) {
        const count = readdirSync(refPath).filter(f => f.endsWith('.md')).length
        refCount += count
      }
    }
    
    p.log.message(`  - ${skill} (${refCount} references)`)
  }

  // Show unregistered skills
  const allSkills = readdirSync(skillsPath, { withFileTypes: true })
    .filter(dirent => dirent.isDirectory())
    .map(dirent => dirent.name)
  
  const unregistered = allSkills.filter(s => !manual.includes(s))
  if (unregistered.length > 0) {
    p.log.message('')
    p.log.warn(`Found ${unregistered.length} unregistered skill(s) (not in meta.ts):`)
    for (const skill of unregistered) {
      p.log.message(`  - ${skill}`)
    }
  }

  p.outro('Done')
}

async function main() {
  const args = process.argv.slice(2)
  const command = args[0]

  if (!command || command === '--help' || command === '-h') {
    console.log(`
Skills Manager - Neo's Personal Skills

Usage:
  pnpm start <command>

Commands:
  init    Create skill structures from meta.ts
  list    List all available skills
  help    Show this help message

Examples:
  pnpm start init        # Interactive mode
  pnpm start init -y     # Auto-create all new skills
  pnpm start list        # List all skills
    `)
    return
  }

  switch (command) {
    case 'init':
      await initSkills()
      break
    case 'list':
      await listSkills()
      break
    default:
      p.log.error(`Unknown command: ${command}`)
      process.exit(1)
  }
}

main().catch((err) => {
  console.error(err)
  process.exit(1)
})
