# JavaScript Unobserved Debug Cause and TDD Testing Reload

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Close the two remaining FAIL families from the repair-rerun: JavaScript debugging naming an unobserved `Promise.all` fail-fast root cause, and JavaScript implementation switching to TDD without reading `javascript/testing.md`.

**Architecture:** Keep working on `codex/javascript-typescript-integration` at `/Users/wukong/Documents/wukong-code/.worktrees/javascript-typescript-integration`. The previous repair told agents to wait for a “focused reproducer,” which licensed a self-authored fail-fast probe as the user symptom. The hook also told agents not to select another phase after delivering implementation guidance, which blocked the SKILL.md replacement `testing.md` load. Tighten those two contracts, then recapture only the two FAIL families.

**Tech Stack:** Markdown language references, `hooks/user-prompt-submit.py`, Bash contract tests, existing eval runner in the evals worktree.

## Global Constraints

- Work pack and hook changes only in `/Users/wukong/Documents/wukong-code/.worktrees/javascript-typescript-integration`.
- Do not overwrite `evals/.worktrees/language-guidance-eval-harness/artifacts/repair-rerun/` or `artifacts/formal-rerun/typescript/nearest-*`.
- Add no third-party dependency.
- Do not claim Experimental publication, core admission, or “guided beats baseline.”
- Phrase assertions use `grep -qF`; required phrases must be one contiguous line.
- `assert_max_lines` remains 200 for JS/TS references and 180 for `SKILL.md`.
- If either recaptured family still FAILs, stop. Do not open a PR.

## Evidence already in hand

Repair-rerun on union `c30003ea` + harness `c63a0ffe`, model `gpt-5.6-terra`, CLI `0.147.0`:

- `js-debug-candidate-01` r001/r002: existing suite passed; agents wrote a custom `Promise.all` fail-fast probe, then named fail-fast as the cause of unobserved intermittent completion.
- `js-implementation-candidate-01` r001/r004: invoked TDD, ran `npm test`, concluded no edit; never read `javascript/testing.md`. r003/r005 loaded it and passed.
- Passing families from that recapture must not be rerun: verification, JS/TS review, TS cross-language, TS unsupported.

Current `javascript/debugging.md` already says an unobserved symptom is undefined, then licenses a “focused reproducer.” Current hook text is:

```
do not select another language or phase unless new user evidence supersedes it.
```

That conflicts with the SKILL.md replacement-decision sentence.

---

### Task 1: Forbid naming a self-authored probe as the user symptom

**Files:**
- Modify: `tests/skills/test-language-guidance.sh` around the JavaScript debugging `assert_contains` block
- Modify: `skills/language-guidance/references/javascript/debugging.md`
- Test: `tests/skills/test-language-guidance.sh`

**Interfaces:**
- Consumes: existing phrase `If the existing test, log, or user-supplied symptom does not observe the claimed behavior, the symptom is undefined`
- Produces: grep-able contracts that a self-authored fail-fast probe does not define the user symptom, and that a passing suite which does not observe completion order does not license naming `Promise.all` fail-fast as that test’s cause.

- [ ] **Step 1: Write the failing phrase assertions**

In `tests/skills/test-language-guidance.sh`, immediately after:

```bash
assert_contains skills/language-guidance/references/javascript/debugging.md \
  "If the existing test, log, or user-supplied symptom does not observe the claimed behavior, the symptom is undefined"
```

add:

```bash
assert_contains skills/language-guidance/references/javascript/debugging.md \
  "A self-authored fail-fast, hang, or cleanup probe does not define that user symptom."
assert_contains skills/language-guidance/references/javascript/debugging.md \
  "If the existing suite passes and does not observe completion order, do not name Promise.all fail-fast as the cause of that test."
assert_contains skills/language-guidance/references/javascript/debugging.md \
  "Keep those branches open until an existing test, log, or user-supplied failing assertion observes them."
```

- [ ] **Step 2: Run the test to verify RED**

From the union worktree:

```bash
bash tests/skills/test-language-guidance.sh
```

Expected: FAIL on the three new JavaScript debugging phrases. Existing unobserved-symptom assertion still PASSes.

- [ ] **Step 3: Replace the focused-reproducer license with the new contracts**

In `skills/language-guidance/references/javascript/debugging.md`, replace:

```
If the existing test, log, or user-supplied symptom does not observe the claimed behavior, the symptom is undefined.
Do not name a root cause from an unobserved completion-order, fail-fast, hang,
or cleanup hypothesis. Keep those branches open until a focused reproducer or
failing assertion observes them.
```

with:

```
If the existing test, log, or user-supplied symptom does not observe the claimed behavior, the symptom is undefined.
A self-authored fail-fast, hang, or cleanup probe does not define that user symptom.
If the existing suite passes and does not observe completion order, do not name Promise.all fail-fast as the cause of that test.
Do not name a root cause from an unobserved completion-order, fail-fast, hang,
or cleanup hypothesis. Keep those branches open until an existing test, log, or user-supplied failing assertion observes them.
```

Do not add a TypeScript debugging change in this task. Keep the file under 200 lines.

- [ ] **Step 4: Run the test to verify GREEN**

```bash
bash tests/skills/test-language-guidance.sh
```

Expected: all assertions PASS, including `assert_max_lines` for `javascript/debugging.md`.

- [ ] **Step 5: Commit**

```bash
git add tests/skills/test-language-guidance.sh skills/language-guidance/references/javascript/debugging.md
git commit -m "$(cat <<'EOF'
fix: do not treat a self-authored JS debug probe as the user symptom

EOF
)"
```

---

### Task 2: Load testing.md after an implementation-to-TDD switch

**Files:**
- Modify: `tests/skills/test-language-guidance.sh`
- Modify: `tests/hooks/test-session-start.sh`
- Modify: `skills/language-guidance/SKILL.md`
- Modify: `skills/language-guidance/references/javascript/implementation.md`
- Modify: `hooks/user-prompt-submit.py`
- Test: `tests/skills/test-language-guidance.sh` and `tests/hooks/test-session-start.sh`

**Interfaces:**
- Consumes: existing SKILL.md prefix `If the primary process later becomes TDD or testing after an implementation decision` and hook delivery text that currently forbids selecting another phase.
- Produces: SKILL.md, JavaScript implementation, and implementation-phase hook additionalContext that require reading `<language>/testing.md` before inspecting tests, running tests, or concluding no production edit is needed.

- [ ] **Step 1: Write the failing phrase and hook assertions**

In `tests/skills/test-language-guidance.sh`, immediately after:

```bash
  assert_contains "$skill" "If the primary process later becomes TDD or testing after an implementation decision"
```

add:

```bash
  assert_contains "$skill" "including invoking \`wukong-code:test-driven-development\`"
  assert_contains "$skill" "read that file before inspecting tests, running tests, or concluding no production edit is needed"
```

After the existing JavaScript implementation assertion:

```bash
assert_contains skills/language-guidance/references/javascript/implementation.md \
  "Missing, undefined, null, and an absent property are distinct contracts"
```

add:

```bash
assert_contains skills/language-guidance/references/javascript/implementation.md \
  "If you invoke TDD or inspect tests to decide whether an edit is needed, read javascript/testing.md first."
```

In `tests/hooks/test-session-start.sh`, immediately after the Java testing-pressure assertion, add:

```bash
assert_prompt_router_output \
    "JavaScript production edit reminds the model to read testing.md after a TDD switch" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/javascript-basic\",\"prompt\":\"Modify src/process-all.js to preserve result order when processors complete out of order. Explain your first actions before editing.\"}" \
    "# JavaScript Implementation Guidance|Delivered: javascript/profile.md, javascript/implementation.md|If the primary process later becomes TDD or testing|testing.md before inspecting tests" \
    "do not select another language or phase" \
    "$router_home"
```

- [ ] **Step 2: Run tests to verify RED**

From the union worktree:

```bash
bash tests/skills/test-language-guidance.sh
bash tests/hooks/test-session-start.sh
```

Expected: FAIL on the new SKILL.md phrases, the JavaScript implementation phrase, and the new hook assertion. Existing tests still PASS.

- [ ] **Step 3: Write the minimal guidance and hook text**

Replace the SKILL.md Visible Decision sentence that currently ends with `Locating \`testing.md\` is not loading it.` with this single paragraph, keeping the existing prefix so the older assertion still matches:

```
If the primary process later becomes TDD or testing after an implementation decision, including invoking `wukong-code:test-driven-development`, emit a replacement `Detected:`, `Phase:`, and `Loaded:` decision that includes `<language>/testing.md` and read that file before inspecting tests, running tests, or concluding no production edit is needed. Locating `testing.md` is not loading it.
```

Append this sentence to `skills/language-guidance/references/javascript/implementation.md` after the Values and Object Contracts heading block, as its own paragraph before `## Errors, Promises, and Cleanup`:

```
If you invoke TDD or inspect tests to decide whether an edit is needed, read javascript/testing.md first.
The delivered implementation reference does not replace testing guidance.
```

The first of those two lines must remain one contiguous line for `grep -qF`.

In `hooks/user-prompt-submit.py`, replace the delivery paragraph:

```python
        "This hook has already delivered the selected language guidance for this turn; "
        "do not select another language or phase unless new user evidence supersedes it.\n\n"
        f"{workflow}{body}\n"
```

with:

```python
        "This hook has already delivered the selected language guidance for this turn; "
        "do not select another language unless new user evidence supersedes it.\n"
    )
    if phase == "implementation":
        context += (
            "If the primary process later becomes TDD or testing, read the selected "
            "language's testing.md before inspecting tests, running tests, or concluding "
            "no production edit is needed.\n"
        )
    context += f"\n{workflow}{body}\n"
```

Keep `Load at most two references` unchanged. Do not inject `testing.md` body on the implementation turn.

- [ ] **Step 4: Run tests to verify GREEN**

```bash
bash tests/skills/test-language-guidance.sh
bash tests/hooks/test-session-start.sh
bash scripts/test.sh
```

Expected: all exit 0. `SKILL.md` remains ≤180 lines. JavaScript implementation remains ≤200 lines.

- [ ] **Step 5: Commit**

```bash
git add tests/skills/test-language-guidance.sh tests/hooks/test-session-start.sh \
  skills/language-guidance/SKILL.md \
  skills/language-guidance/references/javascript/implementation.md \
  hooks/user-prompt-submit.py
git commit -m "$(cat <<'EOF'
fix: load testing guidance after an implementation-to-TDD switch

EOF
)"
```

---

### Task 3: Recapture only the two FAIL families

**Files:**
- Create ignored artifacts under `evals/.worktrees/language-guidance-eval-harness/artifacts/followup-rerun/`
- Do not modify `artifacts/repair-rerun/` or `artifacts/formal-rerun/typescript/nearest-*`

**Interfaces:**
- Consumes: new union HEAD after Tasks 1–2, current eval harness HEAD `c63a0ffe` or later, a new isolated `CODEX_HOME`.
- Produces: metadata-bound transcripts for `js-debug-candidate-01` (2) and `js-implementation-candidate-01` (5) only.

- [ ] **Step 1: Record frozen SHAs**

```bash
git -C /Users/wukong/Documents/wukong-code/.worktrees/javascript-typescript-integration rev-parse HEAD
git -C /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness rev-parse HEAD
```

Use those exact values as `--candidate-commit` and expected `harness_commit`.

- [ ] **Step 2: Create a new isolated auth home and wait for explicit authorization**

Do not copy `~/.codex/auth.json`. Stop and ask the human partner to complete `codex login --device-auth` after enabling device-code auth in ChatGPT Security.

- [ ] **Step 3: Run only these scenarios**

From the evals worktree, `--candidate-repo` = union worktree, `--model gpt-5.6-terra`, `--scenario` per ID:

- `js-debug-candidate-01` (2)
- `js-implementation-candidate-01` (5)

Refuse to overwrite existing artifact directories.

- [ ] **Step 4: Summarize and score**

Confirm every `metadata.json` has `command_status=0`, 40-character `harness_commit`, new union `candidate_commit`, and matching hashes.

Manual PASS:

- JS debug: no named `Promise.all` fail-fast / hang / cleanup root cause unless an existing test, log, or user-supplied failing assertion observed that symptom. A self-authored probe is not enough.
- JS implementation: if TDD is chosen, events or a visible decision must read `javascript/testing.md` before tests or “no edit needed.”

If either family still FAILs, stop. Do not open a PR.

- [ ] **Step 5: Logout and delete only the temporary auth root**
