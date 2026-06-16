---
name: git-worktree-init
description: Initialize git worktree layout for parallel branch work without stashing or switching
metadata:
  author: Neo
  version: "2026.06.16"
  source: Manual
---

# git-worktree-init

> Initialize git worktree layout for a project, enabling parallel branch work without stashing or switching.

## When to use

- User wants to set up git worktree for a project
- User mentions "worktree", "工作树", "并行分支", "多分支工作"
- Starting a new feature branch that needs an isolated worktree
- User wants to separate master/main from feature branches into different directories

## Prerequisites

- Must be inside a git repository
- Git version >= 2.15 (worktree support)

## Workflow

### Step 1: Gather project info

```bash
# Get project directory name (used as worktree prefix)
PROJECT_NAME=$(basename $(git rev-parse --show-toplevel))

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)

# Get default branch (master or main)
DEFAULT_BRANCH=$(git remote show origin | grep 'HEAD branch' | awk '{print $NF}')
```

### Step 2: Determine worktree directory name

Worktree directory name follows the pattern:

```
<project>-<branch-name-with-slashes-replaced-by-hyphens>
```

Convert the branch name to a directory name by replacing `/` with `-`:

| Branch name | Worktree directory |
|---|---|
| `feature/homepage` | `<project>-feature-homepage` |
| `feature/user/537007` | `<project>-feature-user-537007` |
| `bugfix/login-error` | `<project>-bugfix-login-error` |
| `conflict/537007` | `<project>-conflict-537007` |
| `release/v1.0` | `<project>-release-v1.0` |
| `my-custom-branch` | `<project>-my-custom-branch` |

This keeps the full branch context in the directory name while ensuring it's a valid filesystem path.

### Step 3: Check existing worktrees

Before creating any worktree, always check:

```bash
git worktree list
```

**Uniqueness rule: One branch can only have ONE worktree directory.**

If the current branch already has a worktree:
- Report the existing worktree path to the user
- Do NOT create a duplicate
- Ask user if they want to remove the existing one first

### Step 4: Set up main directory

The main project directory should point to the default branch (master/main).

**Before proceeding, verify the working tree is clean:**

```bash
git status
```

If there are uncommitted changes, the checkout operations below will fail. **Stop and inform the user**, asking them to commit or stash changes manually. **Wait for the user to confirm completion before continuing the workflow.**

- Option A: Commit changes — `git add . && git commit -m "WIP: save current work"`
- Option B: Stash changes — `git stash push -m "worktree-setup-temp"`

If the current branch is NOT the default branch:
1. The current branch needs its own worktree
2. The main directory needs to switch to default branch
3. Since the current branch is checked out in main dir, we need a temporary branch to free it up:

```bash
# Create temp branch to free up current branch
git checkout -b _worktree_temp

# Add worktree for current branch
git worktree add ../<worktree-dir-name> <current-branch>

# Switch main directory back to default branch
git checkout <default-branch>

# Delete temp branch
git branch -d _worktree_temp
```

If the current branch IS the default branch:
- The default branch must be up to date with remote before creating worktrees from it:

```bash
git pull origin <default-branch>
```

If the pull fails due to conflicts, **stop and inform the user** — ask them to resolve manually before continuing.

- No need to create a separate worktree for it
- Just ensure main directory is on default branch
- Ask user if they need worktrees for other branches

### Step 5: Verify final state

Run `git worktree list` and validate the following:

1. **Main directory on default branch**: The main project directory must point to `master` or `main`, not a feature branch or detached HEAD.
2. **Branch uniqueness**: Each branch should appear only once across all worktrees. No duplicates.
3. **Naming convention**: Every worktree directory name should follow `<project>-<branch-name-with-slashes-as-hyphens>` pattern. Flag any deviations.
4. **No stale entries**: No worktree should be marked as `prunable`. If any appear, run `git worktree prune` and re-check.
5. **No detached HEAD**: No worktree (except intentionally) should be in detached HEAD state.

If any check fails, report the issue to the user and suggest the fix before proceeding.

Example of a valid final state:

```
/path/to/my-project          abc1234 [master]
/path/to/my-project-feature-homepage  def5678 [feature/homepage]
```

Example of issues to flag:

```
# BAD: main directory on feature branch (not default)
/path/to/my-project  abc1234 [feature/homepage]   ← should be master/main

# BAD: detached HEAD in main directory
/path/to/my-project  abc1234 (detached HEAD)       ← should be master/main

# BAD: duplicate worktrees for same branch
/path/to/my-project-feature-homepage  def5678 [feature/homepage]
/path/to/my-project-feature-homepage2 ghi9012 [feature/homepage]  ← duplicate!

# BAD: stale/prunable worktree
/path/to/my-project-old-feature  (prunable)         ← needs prune
```

Present `git worktree list` output to the user with a summary: number of worktrees, which branches are covered, and whether all checks passed.

## Adding worktrees for additional branches

For adding new worktrees after initial setup:

```bash
git worktree add ../<project>-<branch-name-dir> <branch-name>
```

Where `<branch-name-dir>` is the branch name with `/` replaced by `-`. Always check uniqueness first via `git worktree list`.

## Removing worktrees

```bash
git worktree remove ../<worktree-dir-name>
```

After removal, check if main directory needs to be reassigned. If the removed worktree was for the default branch, check out default branch in the main directory.

## Conflict resolution workflow with worktree

When resolving merge conflicts, work in the feature branch's worktree directory:

```bash
cd ../<project>-<branch-name-dir>
git merge <default-branch>
# Resolve conflicts...
git add . && git commit
```

No need to stash or switch branches. Both directories are available simultaneously.

## Important notes

- Never leave the main directory in detached HEAD state. Always ensure it points to the default branch.
- When renaming a worktree directory, must remove and re-add it (git tracks by path):
  ```bash
  git worktree remove ../old-name
  git worktree add ../new-name <branch>
  ```
- Worktree directories are placed as siblings of the main project directory by default (`../`).
- If a worktree becomes stale (directory removed manually), run `git worktree prune` to clean up.
