# CI Extended Gate Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Run the repository's deterministic extended suite on every pull request and push to `main` or `dev`.

**Architecture:** Keep `scripts/test.sh` and its `core`/`extended` suite boundary unchanged. The existing PR/push GitHub Actions job invokes `npm run test:extended`; the existing manual workflow input remains available for either suite. Static regression assertions and testing documentation describe the new mandatory gate.

**Tech Stack:** GitHub Actions, Bash, npm, Node.js 22.

## Global Constraints

- Do not add runtime or test dependencies; `tests/brainstorm-server/package-lock.json` remains the only nested npm lockfile required by the extended suite.
- Keep host-CLI integrations, credentialed tests, and real LLM/Drill evaluations outside CI.
- Run the extended checks sequentially in one Ubuntu job; its loopback tests use fixed local ports.
- Preserve `workflow_dispatch` support for both `core` and `extended`.

---

### Task 1: Make the CI contract reject a core-only PR gate

**Files:**
- Modify: `tests/test-automation/test-test-runner.sh:164-180`
- Test: `tests/test-automation/test-test-runner.sh`

**Interfaces:**
- Consumes: `.github/workflows/test.yml` text.
- Produces: a static assertion requiring PR/push CI to invoke `npm run test:extended` and use the nested brainstorm-server lockfile cache.

- [ ] **Step 1: Write the failing test**

Replace the current core workflow assertion with these checks:

```bash
assert_file_contains "$REPO_ROOT/.github/workflows/test.yml" \
  'run: npm run test:extended' \
  "workflow runs the extended suite for pull requests and pushes"
assert_file_contains "$REPO_ROOT/.github/workflows/test.yml" \
  'cache-dependency-path: tests/brainstorm-server/package-lock.json' \
  "workflow caches the nested extended-suite lockfile"
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `bash tests/test-automation/test-test-runner.sh`

Expected: failure reporting the missing `run: npm run test:extended` workflow command while the workflow still invokes `npm test` for PRs and pushes.

- [ ] **Step 3: Commit the RED test**

```bash
git add tests/test-automation/test-test-runner.sh
git commit -m "test: require extended CI gate"
```

### Task 2: Run the extended suite from the PR/push workflow

**Files:**
- Modify: `.github/workflows/test.yml:17-27`
- Test: `tests/test-automation/test-test-runner.sh`

**Interfaces:**
- Consumes: `package.json` script `test:extended`, which invokes `bash scripts/test.sh --suite extended`.
- Produces: a `test` job for pull requests and pushes with Node 22, npm caching based on `tests/brainstorm-server/package-lock.json`, and the extended command.

- [ ] **Step 1: Write the minimal workflow implementation**

Replace the `core` job header and its Node/setup/run block with:

```yaml
  test:
    if: github.event_name != 'workflow_dispatch'
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: npm
          cache-dependency-path: tests/brainstorm-server/package-lock.json
      - run: npm run test:extended
```

Do not change the `manual` job or `scripts/test.sh`.

- [ ] **Step 2: Run the focused test to verify it passes**

Run: `bash tests/test-automation/test-test-runner.sh`

Expected: `PASS: layered test runner contract`.

- [ ] **Step 3: Commit the workflow change**

```bash
git add .github/workflows/test.yml tests/test-automation/test-test-runner.sh
git commit -m "ci: gate pull requests with extended tests"
```

### Task 3: Document the mandatory extended CI gate

**Files:**
- Modify: `docs/testing.md:8-26`
- Test: `tests/test-automation/test-test-runner.sh`

**Interfaces:**
- Consumes: the two package scripts and workflow behavior from Task 2.
- Produces: documentation that identifies `npm run test:extended` as the local equivalent of the PR/push gate, while retaining `npm test` as the quicker core suite and retaining manual-only external tests.

- [ ] **Step 1: Add a failing documentation assertion**

Add this assertion after the existing extended-suite documentation assertion:

```bash
assert_file_contains "$REPO_ROOT/docs/testing.md" \
  'GitHub Actions runs the extended suite for pull requests and pushes to `main` and `dev`.' \
  "testing guide documents the mandatory extended CI gate"
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `bash tests/test-automation/test-test-runner.sh`

Expected: failure reporting the missing mandatory-extended-gate sentence.

- [ ] **Step 3: Write the minimal documentation update**

Keep both local commands, but replace the core-only CI paragraph with:

```markdown
GitHub Actions runs the extended suite for pull requests and pushes to `main` and `dev`.
Use `npm run test:extended` locally to reproduce that gate; `npm test` remains the
quicker core suite. Manual workflow dispatch can run either suite. Tests that need
a host CLI, credentials, or real LLM sessions remain manual: use the relevant
runner under `tests/` or the Drill workflow under `evals/`.
```

- [ ] **Step 4: Run focused regression tests**

Run: `bash tests/test-automation/test-test-runner.sh && npm test`

Expected: the test-runner contract passes and the core suite reports `All core tests passed`.

- [ ] **Step 5: Commit the documentation update**

```bash
git add docs/testing.md tests/test-automation/test-test-runner.sh
git commit -m "docs: describe extended CI gate"
```

### Task 4: Verify the complete CI-equivalent suite

**Files:**
- Verify: `.github/workflows/test.yml`, `docs/testing.md`, `tests/test-automation/test-test-runner.sh`

**Interfaces:**
- Consumes: completed Tasks 1-3.
- Produces: evidence that the workflow contract, core suite, and extended suite all pass on the final commit.

- [ ] **Step 1: Check diff integrity**

Run: `git diff main...HEAD --check`

Expected: no output and exit code 0.

- [ ] **Step 2: Run final verification**

Run:

```bash
bash tests/test-automation/test-test-runner.sh
npm test
npm run test:extended
```

Expected: each command exits 0; the last command reports `All extended tests passed`.

- [ ] **Step 3: Review commit scope**

Run: `git status --short --branch && git log --oneline main..HEAD`

Expected: clean feature branch with only the CI-gate commits described above.

