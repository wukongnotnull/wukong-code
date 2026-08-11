# Gemini Integration Retirement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remove Gemini as an active Wukong Code integration while retaining historical records and preventing accidental reintroduction.

**Architecture:** A new static test protects the generic extension/documentation surface. The existing Product Design integration test protects Product Design's active host declaration. The Product Design integrity digest is refreshed with the minimal wording change.

**Tech Stack:** Bash, JSON, Markdown, Node.js, existing test scripts.

## Global Constraints

- Retire Gemini completely; do not create a compatibility layer.
- Preserve historical release notes, plans, specifications, and raw evaluations.
- Do not change Product Design behavior beyond removing Gemini as a supported host.
- Add no dependencies and do not bundle CI, policy, language-guidance, or Antigravity work.
- Before changing `skills/product-design/SKILL.md`, invoke `wukong-code:writing-skills` and complete its required adversarial evaluation. Static checks are not behavior evidence.
- Refresh `product-design.lock.json` with the digest from `node scripts/check-product-design-import.mjs --print`; preserve its source and license fields.

---

## File Structure

| File | Responsibility |
| --- | --- |
| `tests/skills/test-gemini-retirement.sh` | Guards retired generic Gemini artifacts and current documentation. |
| `GEMINI.md`, `gemini-extension.json` | Deleted obsolete extension entry point and manifest. |
| `.version-bump.json`, `docs/testing.md`, `docs/porting-to-a-new-harness.md`, `scripts/sync-to-codex-plugin.sh`, `RELEASE-NOTES.md` | Remove active Gemini metadata and references. |
| `skills/product-design/SKILL.md`, `references/product-design-host-capabilities.md` | Remove Gemini from Product Design host guidance. |
| `tests/product-design/test-core-integration.sh`, `product-design.lock.json` | Cover the Product Design retirement and preserve its integrity lock. |

### Task 1: Add a Generic Retirement Regression Test

**Files:**
- Create: `tests/skills/test-gemini-retirement.sh`
- Test: `tests/skills/test-gemini-retirement.sh`

**Interfaces:**
- Consumes: Root metadata, current operational documentation, and release notes.
- Produces: A zero-dependency executable test which fails when generic Gemini support returns.

- [ ] **Step 1: Write the failing test**

Create this exact file:

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
failures=0

fail() { printf '  [FAIL] %s\n' "$1"; failures=$((failures + 1)); }
pass() { printf '  [PASS] %s\n' "$1"; }

require_missing() {
  local path="$1" description="$2"
  [[ -e "$path" ]] && fail "$description" || pass "$description"
}

require_absent() {
  local pattern="$1" path="$2" description="$3"
  rg -qi -- "$pattern" "$path" && fail "$description" || pass "$description"
}

echo "Gemini retirement checks"
require_missing "$REPO_ROOT/GEMINI.md" "Gemini context file is absent"
require_missing "$REPO_ROOT/gemini-extension.json" "Gemini extension manifest is absent"

if jq -e '.files[] | select(.path == "gemini-extension.json")' "$REPO_ROOT/.version-bump.json" >/dev/null; then
  fail "version metadata still declares the Gemini manifest"
else
  pass "version metadata omits the Gemini manifest"
fi

require_absent 'Gemini|gemini' "$REPO_ROOT/docs/testing.md" "testing guide does not advertise Gemini"
require_absent 'Gemini|gemini' "$REPO_ROOT/docs/porting-to-a-new-harness.md" "porting guide does not advertise Gemini"
require_absent 'GEMINI\.md|gemini-extension\.json' "$REPO_ROOT/scripts/sync-to-codex-plugin.sh" "Codex sync has no stale Gemini exclusions"

if rg -Fq '## v6.3.0' "$REPO_ROOT/RELEASE-NOTES.md"; then
  pass "release notes include v6.3.0"
else
  fail "release notes omit v6.3.0"
fi

if [[ "$failures" -gt 0 ]]; then
  printf '%s Gemini retirement check(s) failed\n' "$failures"
  exit 1
fi

echo "All Gemini retirement checks passed"
```

- [ ] **Step 2: Verify RED**

Run `bash tests/skills/test-gemini-retirement.sh`.

Expected: exit 1, reporting existing Gemini files, their version declaration, and/or current documentation references.

- [ ] **Step 3: Commit the regression test**

```bash
git add tests/skills/test-gemini-retirement.sh
git commit -m "test: cover Gemini integration retirement"
```

### Task 2: Retire Generic Gemini Artifacts and Documentation

**Files:**
- Delete: `GEMINI.md`
- Delete: `gemini-extension.json`
- Modify: `.version-bump.json:2-10`
- Modify: `docs/testing.md:3-6`
- Modify: `docs/porting-to-a-new-harness.md`
- Modify: `scripts/sync-to-codex-plugin.sh:64-71`
- Modify: `RELEASE-NOTES.md:3`
- Test: `tests/skills/test-gemini-retirement.sh`

**Interfaces:**
- Consumes: Task 1's RED test.
- Produces: No active generic metadata, docs, or packaging rules refer to Gemini.

- [ ] **Step 1: Delete artifacts and remove their version entry**

Delete `GEMINI.md` and `gemini-extension.json`. Remove only this entry from `.version-bump.json`:

```json
{ "path": "gemini-extension.json", "field": "version" },
```

- [ ] **Step 2: Rewrite current harness documentation without Gemini**

In `docs/testing.md`, use this exact eval description:

```markdown
- **`evals/`** — do agents behave correctly on real LLM sessions? Python harness driving real tmux sessions of Claude Code and Codex, with an LLM actor and verifier judging skill compliance.
```

In `docs/porting-to-a-new-harness.md`, remove all `Gemini`/`gemini` identifiers. Keep Shape C but replace Gemini-specific examples with this generic text:

```markdown
### Shape C — Instructions-file

The harness has neither a shell hook nor a code plugin — its session-start surface is a context file that the installed extension ships and the manifest declares. The extension-owned context file points at the bootstrap; never substitute an edit to the user's global instructions file.

Keep the manifest, context file, and tool-mapping reference together. If the harness supports includes, prove that they expand into session context; otherwise inline the bootstrap in the extension-owned context file. A convention that merely hints the model might read a file does not satisfy the session-start requirement.
```

Replace the Shape C routing-table example with:

```markdown
| ships an extension-declared context file it always loads | C (instructions-file) | a verified extension-owned context file |
```

Delete the Gemini Appendix A row. Remove Gemini from the Git-URL distribution example, leaving Kimi Code and OpenCode. Confirm with:

```bash
rg -n -i 'gemini' docs/porting-to-a-new-harness.md
```

Expected: no output.

- [ ] **Step 3: Remove stale sync rules and record v6.3.0**

Delete these `EXCLUDES` entries from `scripts/sync-to-codex-plugin.sh`:

```bash
  "/GEMINI.md"
  "/gemini-extension.json"
```

Add this entry immediately after the `RELEASE-NOTES.md` title:

```markdown
## v6.3.0 (2026-08-11)

### Harness Support

- **Gemini integration retired.** Removed residual extension configuration that referenced a removed tool mapping. Current documentation, version metadata, and Codex sync configuration no longer advertise Gemini CLI as a supported harness.
```

- [ ] **Step 4: Verify GREEN and commit**

Run:

```bash
bash tests/skills/test-gemini-retirement.sh
scripts/bump-version.sh --audit
```

Expected: both commands exit 0.

```bash
git add -A GEMINI.md gemini-extension.json .version-bump.json docs/testing.md \
  docs/porting-to-a-new-harness.md scripts/sync-to-codex-plugin.sh \
  RELEASE-NOTES.md tests/skills/test-gemini-retirement.sh
git commit -m "fix: retire Gemini integration"
```

### Task 3: Make Product Design Reject Gemini as a Host

**Files:**
- Modify: `tests/product-design/test-core-integration.sh:153-156,226-234`
- Test: `tests/product-design/test-core-integration.sh`

**Interfaces:**
- Consumes: Product Design host map and router skill.
- Produces: A static test that requires supported hosts and rejects Gemini references.

- [ ] **Step 1: Write the failing Product Design assertions**

Replace the host loop with:

```bash
for host in "Codex Desktop" "ChatGPT Work Mode" "Claude Code" Cursor Kimi OpenCode Pi; do
  grep -Fq "$host" "$REPO_ROOT/references/product-design-host-capabilities.md" ||
    fail "host capability contract is missing $host"
done
if rg -qi 'gemini' "$REPO_ROOT/references/product-design-host-capabilities.md"; then
  fail "host capability contract still lists Gemini"
fi
if rg -qi 'gemini' "$REPO_ROOT/skills/product-design/SKILL.md"; then
  fail "Product Design router still lists Gemini"
fi
grep -Fq "sequential fallback" "$REPO_ROOT/references/product-design-host-capabilities.md" ||
  fail "host capability contract does not define a sequential fallback"
```

Remove only this manifest-loop element:

```python
    "gemini-extension.json",
```

- [ ] **Step 2: Verify RED and commit**

Run `bash tests/product-design/test-core-integration.sh`.

Expected: exit 1 because either new assertion still finds Gemini. The existing import-integrity check remains green before changing imported content.

```bash
git add tests/product-design/test-core-integration.sh
git commit -m "test: require Product Design Gemini retirement"
```

### Task 4: Remove Gemini from Product Design and Refresh Its Lock

**Files:**
- Modify: `skills/product-design/SKILL.md:75-77`
- Modify: `references/product-design-host-capabilities.md:11-18`
- Modify: `product-design.lock.json:33-43`
- Test: `tests/product-design/test-core-integration.sh`
- Test: `tests/product-design/test-import-integrity.mjs`

**Interfaces:**
- Consumes: Task 3's RED test and the import digest tool.
- Produces: Product Design host guidance without Gemini plus a matching integrity lock.

- [ ] **Step 1: Complete the required skill-change evaluation**

Invoke `wukong-code:writing-skills` before editing `skills/product-design/SKILL.md`. Follow its required no-guidance control and adversarial evaluation process. Record the harness, model, repetitions, prompts, outcomes, and human review evidence; do not invent a passing result.

- [ ] **Step 2: Apply the minimal wording changes**

In `skills/product-design/SKILL.md`, replace:

```markdown
In Claude Code, Cursor, Kimi, OpenCode, Pi, Gemini, or another host, use the
browser capability exposed to that session.
```

with:

```markdown
In Claude Code, Cursor, Kimi, OpenCode, Pi, or another supported host, use the
browser capability exposed to that session.
```

Delete this row from `references/product-design-host-capabilities.md`:

```markdown
| Gemini | Available browser/terminal integrations | Use the portable state directory and sequential fallback. |
```

- [ ] **Step 3: Refresh the integrity lock**

Run `node scripts/check-product-design-import.mjs --print`, then replace only `product-design.lock.json`'s `integrity.value` with the emitted 64-character digest. Append this exact value to `local_adaptations`:

```json
"Gemini integration retirement"
```

- [ ] **Step 4: Verify GREEN and commit**

Run:

```bash
bash tests/product-design/test-core-integration.sh
node tests/product-design/test-import-integrity.mjs
node scripts/check-product-design-import.mjs
```

Expected: all commands exit 0.

```bash
git add skills/product-design/SKILL.md references/product-design-host-capabilities.md \
  product-design.lock.json tests/product-design/test-core-integration.sh
git commit -m "fix: remove Gemini from Product Design hosts"
```

### Task 5: Verify the Full Retirement Boundary

**Files:**
- Verify: all files changed by Tasks 1-4

**Interfaces:**
- Consumes: generic and Product Design regression checks.
- Produces: evidence that Gemini exists only in historical material.

- [ ] **Step 1: Run affected static checks**

```bash
bash tests/skills/test-gemini-retirement.sh
bash tests/product-design/test-core-integration.sh
node tests/product-design/test-import-integrity.mjs
node scripts/check-product-design-import.mjs
scripts/bump-version.sh --audit
bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh
```

Expected: every command exits 0. The skill wording change remains behavior-unverified until Task 4's required evaluation is recorded.

- [ ] **Step 2: Check the remaining-reference boundary and repository state**

```bash
rg -n -i 'gemini' --glob '!RELEASE-NOTES.md' --glob '!docs/wukong-code/specs/**' \
  --glob '!docs/wukong-code/plans/**' --glob '!docs/wukong-code/evals/**' \
  --glob '!docs/wukong-code/evals/raw/**' .
git diff --check
git status --short
```

Expected: the search emits no output, `git diff --check` exits 0, and the working tree is clean. Commit any in-repository skill-evaluation report separately; otherwise report its external location without claiming it passed.
