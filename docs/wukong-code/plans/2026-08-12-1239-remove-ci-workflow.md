# Remove CI Workflow Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remove the repository-owned GitHub Actions test workflow while preserving deterministic local test commands.

**Architecture:** Delete the sole GitHub Actions workflow and its workflow-specific regression script. Keep `scripts/test.sh`, `npm test`, and `npm run test:extended` unchanged as local commands; update their descriptions and the testing guide so they no longer claim PR or CI gate status.

**Tech Stack:** Bash, npm, Markdown, Git.

## Global Constraints

- Delete only `.github/workflows/test.yml`; retain issue templates, funding configuration, and pull request template.
- Retain `scripts/test.sh`, `package.json` scripts, all underlying test suites, and Antigravity integration tests.
- Do not add dependencies or external services.
- Do not claim GitHub Actions runs repository tests after this change.

---

### Task 1: Delete the CI workflow contract and workflow

**Files:**
- Delete: `.github/workflows/test.yml`
- Delete: `tests/test-automation/test-test-runner.sh`

**Interfaces:**
- Consumes: the user-approved decision to remove repository-owned CI configuration.
- Produces: no GitHub Actions workflow or test that asserts a GitHub Actions workflow exists.

- [ ] **Step 1: Verify the workflow-specific test currently passes**

Run: `bash tests/test-automation/test-test-runner.sh`

Expected: `PASS: layered test runner contract`.

- [ ] **Step 2: Delete the workflow-specific contract**

Remove `tests/test-automation/test-test-runner.sh`. Its fixture stubs and assertions exist solely to require `.github/workflows/test.yml`, including `workflow_dispatch`, `npm run test:extended`, cache configuration, and CI documentation text.

- [ ] **Step 3: Delete the GitHub Actions workflow**

Remove `.github/workflows/test.yml`. Do not delete any other file under `.github/`.

- [ ] **Step 4: Verify both files are absent**

Run:

```bash
test ! -e .github/workflows/test.yml
test ! -e tests/test-automation/test-test-runner.sh
```

Expected: exit code 0.

- [ ] **Step 5: Commit the deletion**

```bash
git add -u .github/workflows/test.yml tests/test-automation/test-test-runner.sh
git commit -m "ci: remove test workflow"
```

### Task 2: Remove CI-gate language from local test documentation

**Files:**
- Modify: `scripts/test.sh:12-13`
- Modify: `docs/testing.md:8-26`
- Test: `npm test`

**Interfaces:**
- Consumes: retained local commands `npm test` and `npm run test:extended`.
- Produces: local-only instructions: `core` is the default deterministic suite, and `extended` adds brainstorm-server and Antigravity checks.

- [ ] **Step 1: Update the script help text**

Replace the suite descriptions with:

```text
  core      Deterministic repository checks (default).
  extended  Runs core, then brainstorm-server and Antigravity checks.
```

- [ ] **Step 2: Update the testing guide**

Replace the `## Unified local and CI checks` heading with `## Local deterministic checks`. Replace the CI-gate wording with:

```markdown
Run the default deterministic checks locally with:

```bash
npm test
```

Run the extended checks, including brainstorm-server and Antigravity, with:

```bash
npm run test:extended
```

Tests that need a host CLI, credentials, or real LLM sessions remain manual: use the
relevant runner under `tests/` or the Drill workflow under `evals/`.
```

- [ ] **Step 3: Verify removed CI claims are absent**

Run:

```bash
! rg -n 'pull-request CI|pull-request gate|GitHub Actions runs the extended suite' scripts/test.sh docs/testing.md
```

Expected: exit code 0 with no matches.

- [ ] **Step 4: Run the retained default suite**

Run: `npm test`

Expected: exit code 0 and `All core tests passed`.

- [ ] **Step 5: Commit the documentation and help update**

```bash
git add scripts/test.sh docs/testing.md
git commit -m "docs: describe local test commands"
```

### Task 3: Verify the repository no longer defines test CI

**Files:**
- Verify: `.github/`, `package.json`, `scripts/test.sh`, `docs/testing.md`

**Interfaces:**
- Consumes: Tasks 1-2.
- Produces: evidence that no workflow or CI-specific test remains, while local commands work.

- [ ] **Step 1: Check workflow and contract removal**

Run:

```bash
find .github/workflows -type f -print
test ! -e tests/test-automation/test-test-runner.sh
```

Expected: no workflow paths printed and exit code 0.

- [ ] **Step 2: Run final verification**

Run:

```bash
npm test
npm run test:extended
git diff main...HEAD --check
```

Expected: each command exits 0; `npm run test:extended` reports `All extended tests passed`.

- [ ] **Step 3: Review commit scope**

Run: `git status --short --branch && git log --oneline main..HEAD`

Expected: clean feature branch with only the CI-removal commits described above.
