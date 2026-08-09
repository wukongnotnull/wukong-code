# Product Design Core Hardening Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Harden the local Product Design core integration so Wukong process skills remain authoritative, imported helpers work outside the repository root, Codex syncs retain required resources, and MIT provenance is machine-checkable.

**Architecture:** Keep the ten imported skill names stable in this first hardening pass and add a small Wukong-owned adaptation contract around them. Extend the focused integration and sync tests before changing skills or scripts, then add provenance metadata and preserve the upstream MIT notice.

**Tech Stack:** Markdown skills and references, Bash integration tests and sync scripts, Python standard library for YAML-frontmatter shape checks, JSON provenance metadata.

## Global Constraints

- Keep this integration local-fork-only; do not open or prepare an upstream PR.
- Do not alter the imported templates or add runtime dependencies.
- Wukong process selection remains primary; Product Design supplies secondary domain guidance.
- Every production behavior change starts with a focused failing test.
- Preserve the user's untracked Java plan and do not pull, rebase, or overwrite the diverged `main` branch.
- Skill-behavior subagent evals cannot be dispatched unless the user explicitly authorizes subagents; deterministic regression checks are required in this pass and the remaining behavioral eval gap must be reported.

---

### Task 1: Strengthen the Product Design integration contract test

**Files:**
- Modify: `tests/product-design/test-core-integration.sh`

**Interfaces:**
- Consumes: the ten imported `skills/*/SKILL.md` files and shared Product Design references.
- Produces: one deterministic verifier for strict frontmatter shape, workflow composition markers, absolute-path guidance, provenance metadata, and local Markdown links in skills plus shared references.

- [ ] **Step 1: Add failing assertions**

Require each `SKILL.md` to begin and end YAML frontmatter with an exact matching `name`, require the Wukong/Product Design composition reference and markers, reject stale `/plugins/product-design/` examples and bare `python3 scripts/` commands, and require `product-design.lock.json` plus `THIRD_PARTY_NOTICES.md`.

- [ ] **Step 2: Run the focused test to verify RED**

Run: `bash tests/product-design/test-core-integration.sh`

Expected: nonzero exit identifying the first missing hardening contract.

- [ ] **Step 3: Leave the test failing until Tasks 2 and 4 provide the required production files**

Do not weaken assertions to accommodate current behavior.

### Task 2: Compose Product Design with Wukong and repair installed paths

**Files:**
- Create: `references/wukong-product-design-composition.md`
- Modify: `references/critical-overrides.md`
- Modify: `references/local-prototype-preflight.md`
- Modify: `skills/index/SKILL.md`
- Modify: `skills/user-context/SKILL.md`

**Interfaces:**
- Consumes: Wukong's primary-process contract from `skills/using-wukong-code/SKILL.md`.
- Produces: a shared authority/order contract linked from the Product Design router and critical overrides; helper commands that resolve from installed file locations rather than the user's current directory.

- [ ] **Step 1: Add the minimal composition contract**

State that exactly one Wukong primary process governs source changes, Product Design is secondary domain guidance, brainstorming approval may satisfy Product Design intent approval when it includes the visual direction, and Wukong verification remains required before completion claims.

- [ ] **Step 2: Link the contract from router and overrides**

Add explicit references in `skills/index/SKILL.md` and `references/critical-overrides.md` without rewriting unrelated imported guidance.

- [ ] **Step 3: Replace cwd-relative helper commands**

Require absolute script paths resolved from the directory containing `skills/user-context/SKILL.md`; replace standalone `/plugins/product-design/` bootstrap examples with `/wukong-code/` installation examples resolved relative to `references/local-prototype-preflight.md`.

- [ ] **Step 4: Run the focused test**

Run: `bash tests/product-design/test-core-integration.sh`

Expected: the workflow/path assertions pass; provenance assertions remain RED until Task 4.

### Task 3: Preserve Product Design helpers in Codex sync

**Files:**
- Modify: `tests/codex-plugin-sync/test-sync-to-codex-plugin.sh`
- Modify: `scripts/sync-to-codex-plugin.sh`

**Interfaces:**
- Consumes: `scripts/bootstrap-prototype.mjs` and `scripts/check-sites-starter-contract.mjs` from the source checkout.
- Produces: synced Codex plugin content containing only those two root helper scripts while continuing to exclude other repository scripts.

- [ ] **Step 1: Add fixture files and failing assertions**

Create the two Product Design helper fixtures plus an unrelated root script; assert the destination includes the helpers and excludes the unrelated script.

- [ ] **Step 2: Run the sync test to verify RED**

Run: `bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh`

Expected: nonzero exit because the current `/scripts/` exclusion drops both helpers.

- [ ] **Step 3: Add ordered rsync includes**

Build `RSYNC_ARGS` with `--include=/scripts/`, the two exact helper includes, then `--exclude=/scripts/***`; keep all existing exclusions and ignored-path handling.

- [ ] **Step 4: Run the sync test to verify GREEN**

Run: `bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh`

Expected: exit zero with helper-inclusion and unrelated-script-exclusion assertions passing.

### Task 4: Record MIT provenance in distributable artifacts

**Files:**
- Create: `product-design.lock.json`
- Create: `THIRD_PARTY_NOTICES.md`
- Modify: `README.md`
- Modify: `scripts/package-codex-plugin.sh`
- Modify: `tests/codex/test-package-codex-plugin.sh`

**Interfaces:**
- Consumes: source package identity `product-design` version `0.1.52` and the imported path families.
- Produces: a machine-readable local-only lock and a packaged upstream MIT notice.

- [ ] **Step 1: Extend package tests with failing provenance expectations**

Assert that archives contain `product-design.lock.json` plus `THIRD_PARTY_NOTICES.md`.

- [ ] **Step 2: Run the package test to verify RED**

Run: `bash tests/codex/test-package-codex-plugin.sh`

Expected: nonzero exit because packaging currently omits both provenance files.

- [ ] **Step 3: Add provenance and licensing boundary files**

Record source name, version, repository URL, import date, imported path families, local-only policy, and `license: MIT`. Include the upstream copyright and full MIT terms from `openai/role-specific-plugins`.

- [ ] **Step 4: Include provenance in packages**

Include the notice and lock files in Codex archives and update usage text to list all shipped root resource families.

- [ ] **Step 5: Run focused and package tests to verify GREEN**

Run: `bash tests/product-design/test-core-integration.sh && bash tests/codex/test-package-codex-plugin.sh`

Expected: both commands exit zero.

### Task 5: Final regression and diff review

**Files:**
- Review: all paths modified by Tasks 1–4

**Interfaces:**
- Consumes: the hardened local integration.
- Produces: fresh verification evidence and a bounded list of deferred work.

- [ ] **Step 1: Run the relevant regression suite**

Run: `bash tests/product-design/test-core-integration.sh && node scripts/check-sites-starter-contract.mjs && bash tests/codex/test-package-codex-plugin.sh && bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh && bash tests/codex/test-marketplace-manifest.sh`

Expected: every command exits zero.

- [ ] **Step 2: Validate repository hygiene**

Run: `git diff --check && git status --short`

Expected: no whitespace errors; only intentional hardening files plus the pre-existing untracked Java plan appear.

- [ ] **Step 3: Review the complete diff**

Confirm no imported template, unrelated Wukong skill, remote branch, or user-owned untracked file changed.

- [ ] **Step 4: Report deferred work**

Keep generic skill renaming, cross-harness behavior evals, host-neutral state migration, and synchronized fork versioning as explicit follow-up work because they require broader compatibility decisions or additional authorization.
