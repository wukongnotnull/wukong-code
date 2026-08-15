# JavaScript Debugging Mandatory Unobserved-Symptom Constraint

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Stop JavaScript debugging sessions from naming `Promise.all` fail-fast as the root cause of an unobserved intermittent-completion symptom after a self-authored probe.

**Architecture:** Follow-up recapture on union `e19deb5` still FAILed `js-debug-candidate-01` 2/2. The hook already injects `javascript/debugging.md`, including the self-authored-probe sentences, but that text sits below the reference body and is ignored. Testing pressure already works because it is a `Mandatory primary workflow` banner. Add the same shape for debugging, and close the leftover “focused reproducer” license still present in `javascript/debugging.md`.

**Tech Stack:** `hooks/user-prompt-submit.py`, JavaScript debugging markdown, Bash contract tests, existing eval runner.

## Global Constraints

- Work pack and hook changes only in `/Users/wukong/Documents/wukong-code/.worktrees/javascript-typescript-integration`.
- Do not overwrite `artifacts/followup-rerun/`, `artifacts/repair-rerun/`, or `artifacts/formal-rerun/typescript/nearest-*`.
- Add no third-party dependency.
- Do not claim Experimental publication, core admission, or “guided beats baseline.”
- Phrase assertions use `grep -qF`; required phrases must be one contiguous line.
- Recapture only `js-debug-candidate-01` (2). Implementation family already PASSed.
- If the debug family still FAILs, stop. Do not open a PR.

## Evidence already in hand

Follow-up recapture on candidate `e19deb53137d2e09c9148e25a0948a04d180121c` + harness `c63a0ffe6bd2333d6c564869fb18d3f1513d2bf4`, model `gpt-5.6-terra`:

- `js-debug-candidate-01` r001/r002: existing suite passed 100–200 times; agents wrote a custom fail-fast probe; last messages said “Cause identified” / “Root cause” and named `Promise.all` immediate rejection.
- `js-implementation-candidate-01` 5/5 PASS against the original TDD-without-`testing.md` failure. Do not rerun it.
- Hook additionalContext is not in `events.jsonl`. The next recapture still scores from last-message root-cause claims, not from phrase presence of “JavaScript” / “runtime.”

Current leftover license in `javascript/debugging.md`:

```
until a focused reproducer eliminates branches.
```

That sentence still authorizes the probe the later paragraph forbids.

---

### Task 1: Inject a mandatory debugging constraint from the hook

**Files:**
- Modify: `tests/hooks/test-session-start.sh`
- Modify: `hooks/user-prompt-submit.py`
- Test: `tests/hooks/test-session-start.sh`

**Interfaces:**
- Consumes: existing `TESTING_PRESSURE_WORKFLOW` injection when `phase == "testing"`, and `phase_for()` already returning `"debugging"` for `Investigate why test/process-all.test.js...`.
- Produces: debugging-phase additionalContext that starts with a mandatory investigation constraint, plus a JavaScript-only `Promise.all` fail-fast prohibition.

- [ ] **Step 1: Write the failing hook assertion**

In `tests/hooks/test-session-start.sh`, immediately after the Rust debugging assertion, add:

```bash
assert_prompt_router_output \
    "JavaScript debugging request forbids naming an unobserved fail-fast cause" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/javascript-basic\",\"prompt\":\"Investigate why test/process-all.test.js sometimes observes the wrong completion behavior. Do not edit yet.\"}" \
    "Mandatory investigation constraint|# JavaScript Debugging Guidance|Delivered: javascript/debugging.md|A self-authored fail-fast, hang, or cleanup probe does not define the user symptom.|If the existing suite passes and does not observe completion order, do not name Promise.all fail-fast as the cause of that test." \
    "# JavaScript Implementation Guidance"$'\037'"javascript/implementation.md" \
    "$router_home"
```

- [ ] **Step 2: Run the hook test to verify RED**

From the union worktree:

```bash
bash tests/hooks/test-session-start.sh
```

Expected: FAIL on the new JavaScript debugging assertion because the hook still injects only the reference body.

- [ ] **Step 3: Add the debugging workflow banner**

In `hooks/user-prompt-submit.py`, immediately after `TESTING_PRESSURE_WORKFLOW`, add:

```python
DEBUGGING_UNOBSERVED_WORKFLOW = """Mandatory investigation constraint for this request:

If the existing test suite passes and does not observe the claimed symptom, the symptom is undefined. Do not name a root cause. A self-authored fail-fast, hang, or cleanup probe does not define the user symptom.

"""

DEBUGGING_JS_COMPLETION_CONSTRAINT = """If the existing suite passes and does not observe completion order, do not name Promise.all fail-fast as the cause of that test.

"""
```

Replace:

```python
    workflow = TESTING_PRESSURE_WORKFLOW if phase == "testing" else ""
```

with:

```python
    workflow = TESTING_PRESSURE_WORKFLOW if phase == "testing" else ""
    if phase == "debugging":
        workflow = DEBUGGING_UNOBSERVED_WORKFLOW
        if language == "javascript":
            workflow += DEBUGGING_JS_COMPLETION_CONSTRAINT
```

Do not inject `testing.md` or implementation references on a debugging turn.

- [ ] **Step 4: Run the hook test to verify GREEN**

```bash
bash tests/hooks/test-session-start.sh
```

Expected: all assertions PASS, including the new JavaScript debugging case and the existing Rust debugging case.

- [ ] **Step 5: Commit**

```bash
git add tests/hooks/test-session-start.sh hooks/user-prompt-submit.py
git commit -m "$(cat <<'EOF'
fix: forbid unobserved JS debug root causes in hook context

EOF
)"
```

---

### Task 2: Close the leftover focused-reproducer license

**Files:**
- Modify: `tests/skills/test-language-guidance.sh`
- Modify: `skills/language-guidance/references/javascript/debugging.md`
- Test: `tests/skills/test-language-guidance.sh`

**Interfaces:**
- Consumes: existing unobserved-symptom assertions in `javascript/debugging.md`.
- Produces: the classify-the-boundary paragraph no longer treats a focused reproducer as enough to name a cause.

- [ ] **Step 1: Write the failing phrase assertion**

After the existing JavaScript debugging assertions, add:

```bash
assert_contains skills/language-guidance/references/javascript/debugging.md \
  "until an existing test, log, or user-supplied failing assertion eliminates branches."
```

Do not keep an assertion for `until a focused reproducer eliminates branches.`

- [ ] **Step 2: Run the test to verify RED**

```bash
bash tests/skills/test-language-guidance.sh
```

Expected: FAIL on the new phrase. Existing self-authored-probe assertions still PASS.

- [ ] **Step 3: Replace the leftover license**

In `skills/language-guidance/references/javascript/debugging.md`, replace:

```
until
a focused reproducer eliminates branches.
```

with:

```
until
an existing test, log, or user-supplied failing assertion eliminates branches.
```

Keep the file under 200 lines.

- [ ] **Step 4: Run tests to verify GREEN**

```bash
bash tests/skills/test-language-guidance.sh
bash tests/hooks/test-session-start.sh
bash scripts/test.sh
```

Expected: all exit 0.

- [ ] **Step 5: Commit**

```bash
git add tests/skills/test-language-guidance.sh skills/language-guidance/references/javascript/debugging.md
git commit -m "$(cat <<'EOF'
fix: stop treating a JS debug probe as enough evidence

EOF
)"
```

---

### Task 3: Recapture only the debug family

**Files:**
- Create ignored artifacts under `evals/.worktrees/language-guidance-eval-harness/artifacts/debug-constraint-rerun/`
- Do not modify `artifacts/followup-rerun/` or earlier formal/repair roots

**Interfaces:**
- Consumes: new union HEAD after Tasks 1–2, harness `c63a0ffe6bd2333d6c564869fb18d3f1513d2bf4` or later, a new isolated `CODEX_HOME`.
- Produces: metadata-bound transcripts for `js-debug-candidate-01` (2) only.

- [ ] **Step 1: Record frozen SHAs**

```bash
git -C /Users/wukong/Documents/wukong-code/.worktrees/javascript-typescript-integration rev-parse HEAD
git -C /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness rev-parse HEAD
```

- [ ] **Step 2: Create a new isolated auth home and wait for explicit authorization**

Do not copy `~/.codex/auth.json`. Stop and ask the human partner to complete `codex login --device-auth`.

- [ ] **Step 3: Run only `js-debug-candidate-01`**

From the evals worktree, `--candidate-repo` = union worktree, `--model gpt-5.6-terra`, `--scenario js-debug-candidate-01`. Refuse to overwrite existing artifact directories.

- [ ] **Step 4: Summarize and score**

Manual PASS: no named `Promise.all` fail-fast / hang / cleanup root cause unless an existing test, log, or user-supplied failing assertion observed that symptom. A self-authored probe is not enough. Phrase-screen `FLAGGED` for missing `JavaScript` / `runtime` is not the score.

If either repetition still FAILs, stop. Do not open a PR.

- [ ] **Step 5: Logout and delete only the temporary auth root**
