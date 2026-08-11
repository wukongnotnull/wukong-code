# Layered Test Automation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add one deterministic root test command and GitHub Actions gate while preserving opt-in coverage for environment-dependent checks.

**Architecture:** `scripts/test.sh` is the sole command dispatcher. Its core suite consists only of repository-local deterministic checks; its extended suite appends the existing brainstorm-server and Antigravity checks. `package.json` and GitHub Actions delegate to this script so the command list has a single owner.

**Tech Stack:** Bash, Node.js test runner, npm, GitHub Actions YAML.

## Global Constraints

- Keep Wukong Code's shipped plugin dependency-free; `npm ci` is permitted only inside the existing `tests/brainstorm-server` test package.
- `core` must never silently skip an unavailable command.
- Do not put host-CLI, credentialed, or real-LLM evaluation suites in the required PR gate.
- Keep Antigravity in `extended` until its separately tracked mapping failure is repaired.
- Use only Bash features available in macOS's default Bash 3.2: indexed arrays and functions are allowed; associative arrays are not.

---

### Task 1: Establish the dispatcher regression contract

**Files:**
- Create: `tests/test-automation/test-test-runner.sh`
- Test: `tests/test-automation/test-test-runner.sh`

**Interfaces:**
- Consumes: an executable `scripts/test.sh` accepting `--suite core`, `--suite extended`, and `--help`.
- Produces: a fixture-based contract that later tasks must satisfy without running the repository's full test suite.

- [ ] **Step 1: Write the failing test**

Create `tests/test-automation/test-test-runner.sh` with `set -euo pipefail`, a `mktemp -d` fixture, and a cleanup trap. Copy `scripts/test.sh` into `$fixture/scripts/test.sh` when it exists; before implementation, make the test report that the runner is missing and exit nonzero.

The test must create executable no-op shell stubs at every core path:

```bash
tests/skills/test-core-skill-admission-policy.sh
tests/skills/test-language-guidance.sh
tests/skills/test-skill-slim-gates.sh
tests/skills/test-gemini-retirement.sh
tests/hooks/test-session-start.sh
tests/opencode/run-tests.sh
tests/kimi/run-tests.sh
tests/codex/test-marketplace-manifest.sh
tests/codex/test-package-codex-plugin.sh
tests/codex-plugin-sync/test-sync-to-codex-plugin.sh
tests/product-design/test-core-integration.sh
tests/shell-lint/test-lint-shell.sh
tests/antigravity/run-tests.sh
```

Each stub appends its relative path to `$WUKONG_TEST_RUNNER_LOG`; when its path equals `$WUKONG_TEST_RUNNER_FAIL_PATH`, it exits `42`. Put stub `node` and `npm` executables before the system PATH. They append their argument vector to the same log and exit zero.

Assert all of the following:

```bash
PATH="$fixture/bin:$PATH" WUKONG_TEST_RUNNER_LOG="$log" \
  bash "$fixture/scripts/test.sh" --suite core

PATH="$fixture/bin:$PATH" WUKONG_TEST_RUNNER_LOG="$log" \
  bash "$fixture/scripts/test.sh" --suite extended

PATH="$fixture/bin:$PATH" WUKONG_TEST_RUNNER_LOG="$log" \
  WUKONG_TEST_RUNNER_FAIL_PATH="tests/hooks/test-session-start.sh" \
  bash "$fixture/scripts/test.sh" --suite core
```

The first log must contain the 12 core shell paths plus these Node calls in the listed positions:

```text
node --test tests/pi/test-pi-extension.mjs
node --test tests/product-design/test-import-integrity.mjs
```

The extended log must start with the complete core log, then contain exactly:

```text
npm ci --prefix tests/brainstorm-server
npm test --prefix tests/brainstorm-server
tests/antigravity/run-tests.sh
```

Require the failure command to exit `42`, require `--help` to mention both suite names, and require an unknown suite to exit nonzero.

- [ ] **Step 2: Run the test to verify it fails**

Run: `bash tests/test-automation/test-test-runner.sh`

Expected: FAIL with `scripts/test.sh is missing`.

- [ ] **Step 3: Commit the RED test**

```bash
git add tests/test-automation/test-test-runner.sh
git commit -m "test: define layered test runner contract"
```

### Task 2: Implement the root test dispatcher

**Files:**
- Create: `scripts/test.sh`
- Modify: `package.json`
- Test: `tests/test-automation/test-test-runner.sh`

**Interfaces:**
- Consumes: `--suite core`, `--suite extended`, `--help`; no environment variables are required by the production interface.
- Produces: exit status 0 only when every selected child command succeeds; `npm test` invokes `bash scripts/test.sh --suite core`.

- [ ] **Step 1: Implement the argument parser and command functions**

Create `scripts/test.sh` with this command shape. Keep the listed commands and ordering exactly aligned with Task 1:

```bash
#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

usage() {
  cat <<'EOF'
Usage: bash scripts/test.sh [--suite core|extended]

Suites:
  core      Deterministic repository checks used by pull-request CI (default).
  extended  Runs core, then brainstorm-server and Antigravity checks.

Host CLI integrations and Drill LLM evaluations remain manual; see docs/testing.md.
EOF
}

run() {
  printf '\n>>> '
  printf '%q ' "$@"
  printf '\n'
  "$@"
}

run_core() {
  run bash tests/skills/test-core-skill-admission-policy.sh
  run bash tests/skills/test-language-guidance.sh
  run bash tests/skills/test-skill-slim-gates.sh
  run bash tests/skills/test-gemini-retirement.sh
  run bash tests/hooks/test-session-start.sh
  run bash tests/opencode/run-tests.sh
  run bash tests/kimi/run-tests.sh
  run node --test tests/pi/test-pi-extension.mjs
  run bash tests/codex/test-marketplace-manifest.sh
  run bash tests/codex/test-package-codex-plugin.sh
  run bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh
  run bash tests/product-design/test-core-integration.sh
  run node --test tests/product-design/test-import-integrity.mjs
  run bash tests/shell-lint/test-lint-shell.sh
}

run_extended() {
  run_core
  run npm ci --prefix tests/brainstorm-server
  run npm test --prefix tests/brainstorm-server
  run bash tests/antigravity/run-tests.sh
}
```

Finish the parser so no argument selects `core`, `--suite` requires exactly one of `core` or `extended`, `--help` exits zero, and any other argument prints usage to stderr and exits `2`. After a selected suite succeeds, print `All <suite> tests passed`.

- [ ] **Step 2: Expose the default and opt-in commands in package metadata**

Replace the currently absent `scripts` object in `package.json` with:

```json
"scripts": {
  "test": "bash scripts/test.sh --suite core",
  "test:extended": "bash scripts/test.sh --suite extended"
}
```

- [ ] **Step 3: Run the focused regression test to verify it passes**

Run: `bash tests/test-automation/test-test-runner.sh`

Expected: PASS, including core order, extended suffix, help text, unknown-suite rejection, and child exit-status propagation.

- [ ] **Step 4: Run the real core suite**

Run: `npm test`

Expected: every command in `run_core` passes and the script prints `All core tests passed`.

- [ ] **Step 5: Commit the green implementation**

```bash
git add scripts/test.sh package.json tests/test-automation/test-test-runner.sh
git commit -m "test: add layered root test runner"
```

### Task 3: Add CI and document the tiers

**Files:**
- Create: `.github/workflows/test.yml`
- Modify: `docs/testing.md`
- Test: `tests/test-automation/test-test-runner.sh`

**Interfaces:**
- Consumes: `npm test` and `bash scripts/test.sh --suite extended` from Task 2.
- Produces: a required deterministic `core` CI job and a manual-only `extended` job.

- [ ] **Step 1: Add the workflow**

Create `.github/workflows/test.yml` with this complete structure:

```yaml
name: Test

on:
  pull_request:
  push:
    branches: [main, dev]
  workflow_dispatch:
    inputs:
      suite:
        description: Suite to run
        required: true
        default: extended
        type: choice
        options: [core, extended]

jobs:
  core:
    if: github.event_name != 'workflow_dispatch'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 22
      - run: npm test
  manual:
    if: github.event_name == 'workflow_dispatch'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: npm
          cache-dependency-path: tests/brainstorm-server/package-lock.json
      - run: bash scripts/test.sh --suite ${{ inputs.suite }}
```

Do not add root `npm ci`: `package.json` has no dependencies or lockfile. The extended command owns installing its existing nested test dependencies.

- [ ] **Step 2: Update the testing guide**

Insert a `## Unified local and CI checks` section before `## Plugin tests` in `docs/testing.md`:

```markdown
## Unified local and CI checks

Run the deterministic pull-request gate locally with:

```bash
npm test
```

Run the opt-in extended checks, including brainstorm-server and Antigravity,
with:

```bash
npm run test:extended
```

GitHub Actions runs the core suite for pull requests and pushes to `main` and
`dev`. The extended suite is available through manual workflow dispatch. Tests
that need a host CLI, credentials, or real LLM sessions remain manual: use the
relevant runner under `tests/` or the Drill workflow under `evals/`.
```

- [ ] **Step 3: Extend the dispatcher regression test with metadata checks**

In `tests/test-automation/test-test-runner.sh`, add static assertions that:

```bash
jq -e '.scripts.test == "bash scripts/test.sh --suite core"' package.json
jq -e '.scripts["test:extended"] == "bash scripts/test.sh --suite extended"' package.json
grep -Fq 'run: npm test' .github/workflows/test.yml
grep -Fq 'workflow_dispatch:' .github/workflows/test.yml
grep -Fq 'npm run test:extended' docs/testing.md
```

Run those assertions against the real repository after fixture assertions, so
the test verifies both execution behavior and its public entry points.

- [ ] **Step 4: Run all checks for this change**

Run:

```bash
bash tests/test-automation/test-test-runner.sh
npm test
git diff --check
```

Expected: all commands exit 0.

- [ ] **Step 5: Commit CI and documentation**

```bash
git add .github/workflows/test.yml docs/testing.md tests/test-automation/test-test-runner.sh
git commit -m "ci: run core test suite"
```

### Task 4: Final verification and handoff

**Files:**
- Verify: `scripts/test.sh`, `package.json`, `.github/workflows/test.yml`, `docs/testing.md`, `tests/test-automation/test-test-runner.sh`

**Interfaces:**
- Consumes: all Task 1–3 artifacts.
- Produces: evidence that the local and CI entry points agree on their contract.

- [ ] **Step 1: Run the focused and core suites**

Run:

```bash
bash tests/test-automation/test-test-runner.sh
npm test
```

Expected: exit 0 and `All core tests passed` from the root command.

- [ ] **Step 2: Validate changed-file integrity**

Run:

```bash
git diff main...HEAD --check
git status --short
```

Expected: no whitespace errors and no uncommitted files.

- [ ] **Step 3: Record the intentionally unrun scope**

Report that `npm run test:extended` is not a passing completion gate until the
existing Antigravity mapping contract is fixed. Report that host CLI and Drill
tests remain manual by design.
