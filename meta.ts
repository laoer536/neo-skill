/**
 * Hand-written skills with Neo's preferences/tastes/recommendations
 * 
 * Note: This project does NOT use submodules.
 * All skills are manually created and maintained in the skills/ directory.
 * 
 * This array serves as the skill registry. Only skills listed here
 * will be managed by the CLI tools (init, list, etc.).
 * 
 * To add a new skill:
 * 1. Add the skill name to this array
 * 2. Run `pnpm start init` to create skill structure
 * 3. Edit skills/{skill-name}/SKILL.md and references/
 */
export const manual = [
  // Personal preferences
  'neo',
  
  // React Ecosystem
  'react',
  'nextjs',
  'remix',
  
  // Vue Ecosystem
  'vue',
  'nuxt',
  'pinia',
  'vitepress',
  'vue-best-practices',
  'vue-router-best-practices',
  'vue-testing-best-practices',
  'vueuse-functions',
  
  // Shared Tools
  'vite',
  'vitest',
  'pnpm',
  'tailwindcss',
  'tsdown',
  'turborepo',
  'web-design-guidelines',
]
