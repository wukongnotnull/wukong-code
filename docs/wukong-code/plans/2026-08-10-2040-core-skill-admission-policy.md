# Core Skill Admission Policy Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the categorical core-skill exclusion with quality-gated admission guidance in contributor documentation and the PR template.

**Architecture:** Add a focused shell regression test for the policy contract, then update the README and PR template to admit domain-specific and externally sourced skills while retaining quality, provenance, dependency, and human-review gates. The test reads the two documents as contributors do and fails if the retired exclusion returns.

**Tech Stack:** Markdown documentation and template files; Bash static-policy regression test.

## Global Constraints

- Domain-specific and externally sourced skills are eligible for core review; acceptance remains discretionary and quality-gated.
- Preserve the zero-dependency expectation, source attribution, compatible licensing, testing/evaluation, duplicate search, full template, human diff review, and `dev` PR base requirements.
- Do not alter the bundled `frontend-design` skill or its Apache-2.0 license.
- Do not add runtime dependencies, installers, services, or network calls.

---

## File Structure

- Create: `tests/skills/test-core-skill-admission-policy.sh` — checks the contributor-facing policy contract.
- Modify: `README.md` — explains the quality-gated policy for new core skills.
- Modify: `.github/PULL_REQUEST_TEMPLATE.md` — replaces categorical exclusion with core-placement, provenance, and maintenance questions.

### Task 1: Specify the policy contract with a failing regression test

**Files:**

- Create: `tests/skills/test-core-skill-admission-policy.sh`
- Test: `tests/skills/test-core-skill-admission-policy.sh`

**Interfaces:**

- Consumes: repository-root `README.md` and `.github/PULL_REQUEST_TEMPLATE.md`.
- Produces: zero exit status only when both documents allow review of domain-specific skills while retaining concrete core-placement, source/license, maintenance, and human-review expectations.

- [ ] **Step 1: Write the failing test**

Create `tests/skills/test-core-skill-admission-policy.sh` with this complete content:

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
README="$REPO_ROOT/README.md"
TEMPLATE="$REPO_ROOT/.github/PULL_REQUEST_TEMPLATE.md"

failures=0

require_contains() {
  local file="$1"
  local text="$2"
  local description="$3"
  if rg -Fq -- "$text" "$file"; then
    printf '  [PASS] %s\n' "$description"
  else
    printf '  [FAIL] %s\n' "$description"
    failures=$((failures + 1))
  fi
}

require_absent() {
  local file="$1"
  local text="$2"
  local description="$3"
  if rg -Fq -- "$text" "$file"; then
    printf '  [FAIL] %s\n' "$description"
    failures=$((failures + 1))
  else
    printf '  [PASS] %s\n' "$description"
  fi
}

echo "Core skill admission policy tests"
require_contains "$README" "Domain-specific and externally sourced skills are eligible" "README permits domain-specific and externally sourced skills"
require_contains "$README" "license, dependency impact, tests or evaluations" "README retains quality gates"
require_absent "$README" "we don't generally accept contributions of new skills" "README removes categorical new-skill rejection"
require_contains "$TEMPLATE" "Domain-specific and externally sourced skills may be appropriate for core" "template permits domain-specific and externally sourced skills"
require_contains "$TEMPLATE" "source, license, maintenance owner, and runtime or tool dependencies" "template requires provenance and maintenance disclosure"
require_absent "$TEMPLATE" "it belongs in its own plugin — not here" "template removes standalone-plugin mandate"
require_contains "$TEMPLATE" "A human has reviewed the COMPLETE proposed diff before submission" "template retains human review gate"

if [[ "$failures" -gt 0 ]]; then
  printf '%s policy test(s) failed\n' "$failures"
  exit 1
fi

echo "All core skill admission policy tests passed"
```

- [ ] **Step 2: Run the test to verify RED**

Run:

```bash
bash tests/skills/test-core-skill-admission-policy.sh
```

Expected: non-zero exit status. The test must report failures for the absent eligibility and disclosure statements and for the two still-present categorical exclusions.

### Task 2: Implement the quality-gated admission policy

**Files:**

- Modify: `README.md:241-246`
- Modify: `.github/PULL_REQUEST_TEMPLATE.md:35-45,148-154`
- Test: `tests/skills/test-core-skill-admission-policy.sh`

**Interfaces:**

- Consumes: the policy contract from Task 1.
- Produces: matching contributor documentation and PR template language.

- [ ] **Step 1: Replace the README contributor guidance**

Replace the sentence beginning `Keep in mind that we don't generally accept contributions of new skills` and its continuation with this paragraph:

```markdown
Wukong Code accepts new skills after maintainer review when they solve a concrete problem, have a clear intended audience, and can be maintained safely across supported harnesses. Domain-specific and externally sourced skills are eligible for core review; contributors must disclose the source, license, dependency impact, tests or evaluations, and maintenance or update strategy. Core skills remain zero-dependency unless a separately documented harness-support exception applies.
```

- [ ] **Step 2: Replace the template's categorical exclusion**

Under `## Is this change appropriate for the core library?`, replace the current HTML comment with:

```markdown
<!-- Wukong Code core may contain composable skills for general-purpose or
     domain-specific work. Explain:

     - Who has the concrete problem this skill solves?
     - Why is core distribution appropriate instead of a standalone plugin?
     - If externally sourced, what are the source, license, maintenance owner,
       and runtime or tool dependencies?
     - What evidence shows the skill is useful and safe across its intended
       projects or harnesses?

     Domain-specific and externally sourced skills may be appropriate for core
     when their scope, provenance, maintenance burden, and test evidence are
     disclosed. -->
```

Replace the footer bullet `Promote or integrate third-party services or tools` with:

```markdown
- Omit the source, license, maintenance owner, or runtime/tool dependencies for
  an externally sourced or third-party skill
```

- [ ] **Step 3: Run the regression test to verify GREEN**

Run:

```bash
bash tests/skills/test-core-skill-admission-policy.sh
```

Expected: zero exit status and every named policy check passes.

- [ ] **Step 4: Run regression checks**

Run:

```bash
tests/codex/test-package-codex-plugin.sh
bash tests/shell-lint/test-lint-shell.sh
git diff --check
```

Expected: all commands exit zero.

- [ ] **Step 5: Commit the policy change**

```bash
git add README.md .github/PULL_REQUEST_TEMPLATE.md tests/skills/test-core-skill-admission-policy.sh
git commit -m "docs: allow domain skills in core"
```

## Plan Self-Review

- **Spec coverage:** Task 1 makes the new admission rule testable. Task 2 updates both contributor surfaces while retaining the required quality and human-review gates. No frontend skill content, license, runtime, or standalone-plugin surface is changed.
- **Placeholder scan:** the tasks contain complete test code, exact replacement text, commands, expected results, and commit paths; no deferred work remains.
- **Consistency:** every text fragment required by the test is introduced by Task 2, and every retired fragment is named in the matching removal instruction.
