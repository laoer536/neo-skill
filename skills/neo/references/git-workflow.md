---
name: git-workflow
description: Neo's Git workflow, branching strategy, commit conventions, and PR guidelines
---

# Git Workflow

## Branch Naming Convention

### Format: `type/description`

```bash
# Features
feature/user-authentication
feature/add-dark-mode
feature/implement-search

# Bug fixes
fix/login-crash
fix/memory-leak
fix/incorrect-calculation

# Documentation
docs/update-readme
docs/add-api-docs

# Refactoring
refactor/extract-utils
refactor/simplify-auth

# Testing
test/add-unit-tests
test/e2e-checkout

# Chores (build, config, dependencies)
chore/update-dependencies
chore/configure-eslint
chore/cleanup-unused-files

# Hotfixes (production emergencies)
hotfix/critical-security-patch
hotfix/fix-deployment
```

### Rules
- **Use hyphens** (`-`) not underscores or camelCase
- **Keep it short** but descriptive
- **Prefix with type** for clarity
- **Lowercase only**

## Commit Message Format

### Conventional Commits

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types

| Type | Description | Example |
|------|-------------|---------|
| `feat` | New feature | `feat(auth): add OAuth2 login` |
| `fix` | Bug fix | `fix(api): handle timeout errors` |
| `docs` | Documentation | `docs(readme): add setup guide` |
| `style` | Code style (formatting) | `style: format with prettier` |
| `refactor` | Code refactoring | `refactor(utils): extract date helpers` |
| `perf` | Performance | `perf: lazy load images` |
| `test` | Tests | `test(auth): add login tests` |
| `chore` | Build/config/dependencies | `chore: update dependencies` |
| `ci` | CI/CD | `ci: add github actions` |
| `revert` | Revert commit | `revert: feat(auth): add OAuth2` |

### Scope (Optional)

Use component, module, or feature name:

```bash
feat(auth): add password reset
fix(api): handle 404 errors
docs(readme): update installation guide
style(button): adjust padding
refactor(store): simplify state management
```

### Description Rules

- **Imperative mood**: "add" not "added" or "adds"
- **Lowercase first letter** (some prefer uppercase, pick one)
- **No period** at the end
- **Keep it concise** (max 72 chars)

### Examples

```bash
# ✅ Good
feat(user): add profile picture upload
fix(api): retry failed requests with exponential backoff
docs: update contributing guide
refactor(hooks): extract useLocalStorage
test(components): add snapshot tests for Button
chore: update eslint to v9

# ❌ Bad
fixed the bug
Update stuff
Added new feature and fixed some things
```

### Body (Optional)

Explain **what** and **why**, not **how**:

```bash
feat(cart): add quantity validation

Prevent users from adding more than 99 items to cart.
This aligns with inventory system limitations.

Fixes #123
```

### Footers (Optional)

```bash
# Reference issues
Closes #123
Fixes #456
Related to #789

# Breaking changes
BREAKING CHANGE: Drop Node.js 14 support

# Co-authors
Co-authored-by: Name <email@example.com>
```

### Full Example

```bash
feat(auth): implement JWT refresh token rotation

Add automatic token refresh when access token expires.
Tokens are now rotated on each refresh for better security.

The old refresh token is invalidated when a new one is issued,
preventing token reuse attacks.

BREAKING CHANGE: Login response now includes refresh_token
Closes #234
Co-authored-by: Jane Smith <jane@example.com>
```

## Git Workflow Strategies

### Strategy 1: Feature Branch Workflow (Recommended for Teams)

```bash
# 1. Start from main
git checkout main
git pull origin main

# 2. Create feature branch
git checkout -b feature/user-profile

# 3. Work and commit
git add .
git commit -m "feat(profile): add user avatar upload"

# 4. Keep branch updated
git fetch origin
git rebase origin/main

# 5. Push and create PR
git push -u origin feature/user-profile
```

### Strategy 2: Git Flow (For Complex Projects)

```
main (production)
  └── develop (integration)
        ├── feature/login
        ├── feature/dashboard
        ├── release/v1.0.0
        └── hotfix/security-patch
```

### Strategy 3: Trunk-Based (For Small Teams/Experienced)

```bash
# Short-lived branches (< 2 days)
main
  ├── feat/add-search (1 day)
  └── fix/typo (2 hours)

# Or use feature flags
main (with flags)
  - ENABLE_SEARCH=false
  - NEW_UI=false
```

## Pull Request Guidelines

### PR Title

Use same format as commit messages:

```
feat(auth): add two-factor authentication
fix(api): resolve CORS issues
docs: update API reference
```

### PR Description Template

```markdown
## Description

Brief summary of changes.

## Type of Change

- [ ] Bug fix (non-breaking change)
- [ ] New feature (non-breaking change)
- [ ] Breaking change
- [ ] Documentation update
- [ ] Refactoring
- [ ] Performance improvement

## Changes

- Added X
- Updated Y
- Removed Z

## Screenshots (if applicable)

Before/after screenshots for UI changes.

## Testing

- [ ] Unit tests added/updated
- [ ] E2E tests pass
- [ ] Manual testing completed

**Test Steps:**
1. Go to '...'
2. Click on '...'
3. Verify '...'

## Checklist

- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Tests pass locally

## Related Issues

Closes #123
```

## Commit Best Practices

### 1. Atomic Commits

One logical change per commit:

```bash
# ✅ Good - Separate commits
git commit -m "feat(auth): add login form"
git commit -m "feat(auth): add validation"
git commit -m "test(auth): add login tests"

# ❌ Bad - Mixed commit
git commit -m "add login, fix typo, update deps"
```

### 2. Commit Early and Often

```bash
# ✅ Good - Small, focused commits
git commit -m "feat: add button component"
git commit -m "feat: add button variants"
git commit -m "test: add button tests"

# ❌ Bad - Huge commits
# One commit with 50 files changed
```

### 3. Review Before Committing

```bash
# Check what will be committed
git status
git diff
git diff --staged

# Interactive staging
git add -p  # Review hunks
```

### 4. Fix Mistakes

```bash
# Amend last commit message
git commit --amend

# Add forgotten file to last commit
git add forgotten-file.ts
git commit --amend --no-edit

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Split commit
git reset --soft HEAD~1
git add -p  # Selectively stage
git commit -m "first part"
git commit -m "second part"
```

## Git Hooks Setup

### Using simple-git-hooks

```json
{
  "simple-git-hooks": {
    "pre-commit": "pnpm lint-staged",
    "commit-msg": "pnpm commitlint --edit"
  },
  "lint-staged": {
    "*.{js,ts,tsx,vue}": "eslint --fix",
    "*.{js,ts,tsx,vue,md,json}": "prettier --write"
  }
}
```

### Install Hooks

```bash
npx simple-git-hooks
```

## Useful Git Commands

### Daily Workflow

```bash
# Start day
git pull --rebase

# Check status
git status
git log --oneline -10

# Commit
git add .
git commit -m "type: message"

# Sync with remote
git fetch
git rebase origin/main

# Push
git push
# or for new branch
git push -u origin branch-name
```

### Investigation

```bash
# View commit history
git log --oneline --graph --all
git log --author="name"
git log --since="2024-01-01"

# Find when something changed
git log -S "search text"
git log -p file.ts

# Blame - who changed what
git blame file.ts
git blame -L 10,20 file.ts  # Lines 10-20

# Find breaking commit
git bisect start
git bisect bad
git bisect good <commit>
# Test and mark good/bad
git bisect reset
```

### Cleanup

```bash
# Remove merged branches
git branch --merged | grep -v "\\*" | xargs git branch -d

# Prune remote tracking branches
git remote prune origin

# Clean untracked files (DRY RUN)
git clean -fd --dry-run

# Clean untracked files (ACTUAL)
git clean -fd
```

## Tagging Releases

```bash
# Create tag
git tag -a v1.0.0 -m "Release v1.0.0"

# Push tag
git push origin v1.0.0

# Semantic versioning
v<MAJOR>.<MINOR>.<PATCH>
v1.0.0  # Initial release
v1.1.0  # New feature (backward compatible)
v1.1.1  # Bug fix
v2.0.0  # Breaking change
```

## Key Points

- Use conventional commits for consistency
- Keep commits atomic and focused
- Write clear, descriptive commit messages
- Rebase feature branches regularly
- Use PR templates for consistency
- Review code before committing
- Automate with git hooks
- Tag releases with semantic versioning
