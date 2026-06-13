---
name: style-fix
description: Fix code style issues on changed files by orchestrating Prettier, Stylelint, and ESLint. Activates when the user asks to "fix style", "fix lint", "clean up code style", "format my changes", "run prettier/eslint/stylelint on changed files", or wants to auto-fix style issues before committing. Standalone — does not depend on or invoke any other skill.
metadata:
  author: Neo
  version: "2026.06.13"
  source: Manual
---

# Style Fix

Auto-fix code style issues on **only the files you changed**, using Prettier, Stylelint, and ESLint. Standalone skill — do not load or reference any other skill while executing this workflow.

## Core Principles

- **Scope to changed files only.** Never run against the whole project unless the user explicitly asks.
- **Detect before running.** Confirm which of Prettier / Stylelint / ESLint are actually installed and configured before invoking anything.
- **Prettier and Stylelint: auto-fix first, then verify.**
- **ESLint: check first, auto-fix only if needed, then re-check.** Never run `--fix` blindly.
- **Human in the loop for ESLint residuals.** If ESLint still reports errors after auto-fix, pause and let AI (or the user) address them before looping.
- **Respect the project's own config.** Use the project's `package.json` scripts when available; fall back to direct CLI binaries only when necessary.

## Phase 1 — Reconnaissance

Before touching any file, answer these questions.

### 1.1 Which tools are in use?

Run (silently, do not show raw output unless debugging):

```bash
# From package.json (dependencies + devDependencies)
grep -E '"(prettier|eslint|stylelint)"' package.json

# Optional: detect config files as secondary evidence
ls -la | grep -E '\.(prettierrc|eslintrc|stylelintrc)|prettier\.config|eslint\.config|stylelint\.config'
```

Decision table:

| Evidence | Conclusion |
|---|---|
| `prettier` in deps OR prettier config file | **Prettier in use** |
| `stylelint` in deps OR stylelint config file | **Stylelint in use** |
| `eslint` in deps OR eslint config file | **ESLint in use** |
| None of the above | Stop and tell the user: "No style tooling detected in this project." Do not install anything unless asked. |

### 1.2 Which runner to use?

Prefer, in order:

1. **npm/pnpm/yarn script** defined in `package.json` (e.g. `lint`, `lint:fix`, `format`, `stylelint`). Use `cat package.json | grep -A1 '"scripts"'` to discover them.
2. **Local binary** via `npx prettier` / `pnpm exec prettier` / `./node_modules/.bin/prettier`.
3. **Global binary** — last resort; warn the user before using.

Detect the package manager by the lockfile (`pnpm-lock.yaml` → pnpm, `yarn.lock` → yarn, else npm).

### 1.3 Which files changed?

Collect changed files with git:

```bash
# Staged + unstaged + untracked (new files) — scoped to current branch vs main
git diff --name-only --diff-filter=ACMRT HEAD     # committed-but-not-on-base
git diff --name-only --diff-filter=ACMRT          # unstaged
git diff --cached --name-only --diff-filter=ACMRT # staged
git ls-files --others --exclude-standard          # untracked
```

Then filter to extensions relevant to the detected tools:

- **Prettier**: `.js .jsx .ts .tsx .vue .json .md .mdx .css .scss .less .html .yaml .yml .graphql`
- **Stylelint**: `.css .scss .sass .less .vue` (only `<style>` blocks)
- **ESLint**: `.js .jsx .ts .tsx .vue .svelte`

Deduplicate. If the resulting list is empty, tell the user and stop.

## Phase 2 — Execute (order matters)

Run the three phases in this exact order. For each phase, pass the **explicit file list** collected in Phase 1 — never a glob like `.` or `src/**`.

### 2.1 Prettier (if detected) — auto-fix

```bash
npx prettier --write <files...>
```

If the project defines a `format` script, prefer it: `pnpm format -- <files...>` (some scripts don't accept file args; fall back to direct CLI in that case).

After running, briefly report: files formatted, any parse errors. Parse errors are **not** auto-fixable — flag them for Phase 3.

### 2.2 Stylelint (if detected) — auto-fix

```bash
npx stylelint "<files>" --fix
```

Stylelint's `--fix` mutates in place and is safe on changed files. If the project uses PostCSS/Sass/Less, ensure the syntax flag matches the project config (usually auto-detected from config).

Report: files fixed, warnings, errors that couldn't be auto-fixed.

### 2.3 ESLint (if detected) — check → fix → re-check

This is the careful phase. **Do not run `--fix` first.**

**Step A — Check only:**

```bash
npx eslint <files...> --format stylish
```

Parse the output:
- **0 problems** → skip to Phase 3.
- **Only fixable problems** → go to Step B.
- **Unfixable problems** → go straight to Phase 3 (human/AI intervention).
- **Mix** → Step B, then Phase 3 for residuals.

**Step B — Auto-fix (only when Step A found fixable issues):**

```bash
npx eslint <files...> --fix
```

**Step C — Re-check:**

```bash
npx eslint <files...> --format stylish
```

- **0 problems** → Phase 3.
- **Still problems** → Phase 3.

## Phase 3 — AI-Assisted Fix Loop

Triggered only when ESLint still reports issues after auto-fix, or when Prettier/Stylelint reported parse errors.

### 3.1 Triage

For each remaining problem:

1. Read the reported line + surrounding context (5–10 lines).
2. Classify:
   - **Mechanical** (unused import, missing semicolon, wrong quote style, `===` vs `==`): fix directly.
   - **Semantic** (no-unused-vars that might be intentional, react-hooks/exhaustive-deps, complex `@typescript-eslint` rules): ask the user before changing behavior.
3. Apply the fix with Edit (never overwrite whole files).

### 3.2 Re-verify

After each round of manual fixes, re-run the full ESLint check from Step C on the affected files only. Continue looping while:

- problems remain, AND
- the problem count strictly decreased from the previous round, AND
- fewer than 3 rounds have run.

If the count stops decreasing or 3 rounds pass, **stop and report** the remaining issues to the user with file:line references. Do not loop forever.

## Phase 4 — Summary

At the end, output a short report (no fluff):

```
Style fix complete
- Prettier: 7 files formatted
- Stylelint: 3 files fixed
- ESLint: 12 issues found → 10 auto-fixed → 2 remaining (manual review)
  - src/foo.ts:42  @typescript-eslint/no-explicit-any
  - src/bar.vue:18 vue/no-v-html
```

If everything is clean, a single line is enough: `Style fix: all changed files clean (prettier ✓ stylelint ✓ eslint ✓).`

## Things to Avoid

- **Do not** run tools against `node_modules`, `dist`, `build`, or other ignored dirs — trust each tool's own ignore config, but never pass those paths explicitly.
- **Do not** modify ESLint/Prettier/Stylelint config files as part of this workflow. If the config is broken, tell the user.
- **Do not** commit the changes automatically. The user decides when to commit.
- **Do not** load or invoke any other skill (including `neo`, `simplify`, `vue-best-practices`, etc.) while executing this skill — it is standalone.
- **Do not** run `eslint --fix` before the initial check. Check-first is non-negotiable.
- **Do not** use `--force` or suppress flags (`--quiet` to hide warnings) to make the output look clean. Surface real issues.

## Activation Checklist

Before starting, confirm you have:

- [ ] Identified which of Prettier / Stylelint / ESLint are present (or none).
- [ ] Identified the package manager (pnpm / yarn / npm).
- [ ] Collected the list of changed files filtered to relevant extensions.
- [ ] Chosen runner (script vs direct CLI) for each detected tool.

If any of these fail, stop and report rather than guessing.
