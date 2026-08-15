# JavaScript and TypeScript Language Guidance Behavior Repair

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Close the remaining JavaScript and TypeScript candidate behavior failures that block core admission, then recapture only the failed eval families on the union commit with the frozen eval harness.

**Architecture:** Keep working on `codex/javascript-typescript-integration` (currently `5990f88`). Strengthen hook abstention for mixed-language prompts, then tighten the failing JavaScript/TypeScript references. Eval scenario and runner changes stay in `wukong-code-evals` on `codex/language-guidance-eval-harness`. Do not merge to `main`, open a PR, or change README status.

**Tech Stack:** Markdown language references, `hooks/user-prompt-submit.py`, Bash contract tests, zero-dependency eval runner in the evals worktree.

## Global Constraints

- Work in `/Users/wukong/Documents/wukong-code/.worktrees/javascript-typescript-integration` for pack/hook changes; work in `/Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness` for eval-scenario changes.
- Add no third-party dependency, runtime, package manager, or harness tool.
- Do not claim Experimental publication, core admission, or “guided beats baseline.”
- Historical 88-run artifacts at `evals/.../artifacts/formal/` are auxiliary only: they lack `harness_commit` and used standalone commits `ce769d0` / `6320186`, not union `5990f88`.
- The repaired TypeScript nearest-marker 10-run on union `5990f88` + harness `4361274` is valid routing evidence and must not be overwritten.
- One problem per later PR: this plan produces a candidate increment, not a publication PR.

## Evidence already in hand

Codex session `019ffa6f-d6e7-7a90-bad3-2086f8a2dd71` completed the missing TypeScript nearest-marker rerun after the session stopped at candidate 3/5.

| Cohort | Automated screen | Manual routing score | Binding |
| --- | --- | --- | --- |
| `ts-nearest-no-guidance-01` r001–r005 | 4 PASS / 1 FLAGGED (r002 missing `TypeScript`, `tsconfig.json`) | 5/5 correctly said no installed guidance; r002 did not name the nearest TypeScript owner marker | harness `4361274`, candidate `5990f88`, model `gpt-5.6-terra`, CLI `0.147.0` |
| `ts-nearest-candidate-01` r001–r005 | 5/5 PASS | 5/5 named TypeScript review guidance from `app.ts` + nearest `tsconfig.json` and rejected JavaScript Review Guidance | same freeze |

Independent reviews of the older 88 runs remain the behavior baseline to repair:

- JavaScript candidate blockers: debug 2/2 FAIL; implementation r003/r004 failed to load `testing.md` after switching to TDD; adversarial verification r001 skipped the package test script; adversarial review r002 invented undeclared cancellation/wait/validation findings.
- TypeScript blockers: adversarial review r002 invented an undeclared sibling-cancel finding; no unsupported-language control; cross-language control loaded both TypeScript and Rust implementation references after the hook returned empty.
- Hook additional context is not serialized in `events.jsonl`. Score later reruns from explicit reference reads, visible `Detected`/`Phase`/`Loaded` lines, and commands. Do not invent a Codex event field.

---

### Task 1: Emit explicit mixed-language hook abstention

**Files:**
- Modify: `hooks/user-prompt-submit.py:154-186` and `hooks/user-prompt-submit.py:233-270`
- Modify: `tests/hooks/test-session-start.sh:400-413`
- Test: `tests/hooks/test-session-start.sh`

**Interfaces:**
- Consumes: `prompt_targets()`, `target_selection()`, and the existing unsupported-language additionalContext shape.
- Produces: when two or more registered languages appear in actionable targets, UserPromptSubmit additionalContext that names those languages and forbids loading either pack.

- [ ] **Step 1: Convert the empty mixed-language cases into failing output assertions**

In `tests/hooks/test-session-start.sh`, replace the two `assert_prompt_router_empty` cases for `Modify web/app.ts and rust-worker/src/lib.rs.` and `Modify web/app.ts, web/other.ts, and rust-worker/src/lib.rs.` with:

```bash
assert_prompt_router_output \
    "Cross-language actionable targets tell the model not to load either pack" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/monorepo\",\"prompt\":\"Modify web/app.ts and rust-worker/src/lib.rs.\"}" \
    "Multiple registered languages are in scope|TypeScript|Rust|Do not invoke language-guidance" \
    "# TypeScript Implementation Guidance"$'\037'"# Rust Implementation Guidance"$'\037'"Delivered: typescript/"$'\037'"Delivered: rust/" \
    "$router_home"

assert_prompt_router_output \
    "Three coordinated targets retain a conflicting final language and abstain explicitly" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/monorepo\",\"prompt\":\"Modify web/app.ts, web/other.ts, and rust-worker/src/lib.rs.\"}" \
    "Multiple registered languages are in scope|TypeScript|Rust|Do not invoke language-guidance" \
    "# TypeScript Implementation Guidance"$'\037'"# Rust Implementation Guidance" \
    "$router_home"
```

Keep the mixed registered/unsupported empty case until Task 1 only covers two registered languages.

- [ ] **Step 2: Run the hook test to verify RED**

Run from the union worktree:

```bash
bash tests/hooks/test-session-start.sh
```

Expected: FAIL on the two new mixed-language output assertions because the hook still prints nothing.

- [ ] **Step 3: Emit abstention context when multiple registered languages are selected**

Add this helper next to `target_language()` in `hooks/user-prompt-submit.py`:

```python
def mixed_registered_languages(
    prompt: str, cwd: Path, languages: dict[str, Any]
) -> list[str] | None:
    targets = prompt_targets(prompt, languages)
    if len(targets) < 2:
        return None
    names: list[str] = []
    for target in targets:
        selection = target_selection(target, cwd, languages)
        if selection is not None:
            names.append(selection[0])
    unique = list(dict.fromkeys(names))
    return unique if len(unique) > 1 else None
```

In `main()`, after computing `selection` and before the unsupported-extension branch, add:

```python
        mixed = mixed_registered_languages(payload["prompt"], cwd, languages)
        if mixed:
            display = ", ".join(
                languages[name].get("display_name", name.capitalize()) for name in mixed
            )
            context = (
                "Deterministic Codex language routing\n\n"
                f"Multiple registered languages are in scope: {display}.\n"
                "Do not invoke language-guidance, emit a language decision, or load either "
                "language's references. State each target scope separately and keep the "
                "generic workflow until the human partner selects one target.\n"
            )
            print(
                json.dumps(
                    {
                        "hookSpecificOutput": {
                            "hookEventName": "UserPromptSubmit",
                            "additionalContext": context,
                        }
                    },
                    ensure_ascii=False,
                )
            )
            return
```

Also add this sentence to `skills/language-guidance/SKILL.md` under Detection Evidence, after “Ask or return no selection when evidence conflicts.”:

```
If a prompt names source targets in two or more registered languages, do not
emit `Detected:`, `Phase:`, or `Loaded:` and do not read either language pack.
State each target scope separately and keep the generic workflow.
```

Add a matching `assert_contains` in `tests/skills/test-language-guidance.sh` next to the existing “Do not guess” assertion:

```bash
assert_contains "$skill" "source targets in two or more registered languages"
```

- [ ] **Step 4: Run hook and language-guidance tests**

```bash
bash tests/hooks/test-session-start.sh
bash tests/skills/test-language-guidance.sh
```

Expected: both exit 0; mixed-language cases now print abstention and omit implementation bodies.

- [ ] **Step 5: Commit**

```bash
git add hooks/user-prompt-submit.py tests/hooks/test-session-start.sh \
  skills/language-guidance/SKILL.md tests/skills/test-language-guidance.sh
git commit -m "$(cat <<'EOF'
fix: abstain explicitly on mixed-language source targets

EOF
)"
```

### Task 2: Stop JavaScript debugging from naming an unobserved root cause

**Files:**
- Modify: `skills/language-guidance/references/javascript/debugging.md:26-29`
- Modify: `tests/skills/test-language-guidance.sh:364-365`
- Test: `tests/skills/test-language-guidance.sh`

**Interfaces:**
- Consumes: existing “When evidence is absent, do not select a leading, likely, or most likely cause.”
- Produces: an additional rule that an existing test which does not observe the claimed symptom leaves the symptom undefined.

- [ ] **Step 1: Add the failing phrase assertion**

Replace the JavaScript debugging assertion with:

```bash
assert_contains skills/language-guidance/references/javascript/debugging.md \
  "Reproduce under the owning runtime and module mode"
assert_contains skills/language-guidance/references/javascript/debugging.md \
  "If the existing test, log, or user-supplied symptom does not observe the claimed behavior, the symptom is undefined"
```

- [ ] **Step 2: Run the contract to verify RED**

```bash
bash tests/skills/test-language-guidance.sh
```

Expected: FAIL with the new phrase missing from `javascript/debugging.md`.

- [ ] **Step 3: Add the rule after the existing “When evidence is absent” paragraph**

```markdown
If the existing test, log, or user-supplied symptom does not observe the
claimed behavior, the symptom is undefined. Do not name a root cause from an
unobserved completion-order, fail-fast, hang, or cleanup hypothesis. Keep those
branches open until a focused reproducer or failing assertion observes them.
```

Do not weaken systematic-debugging as the primary process.

- [ ] **Step 4: Re-run the contract**

```bash
bash tests/skills/test-language-guidance.sh
```

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add skills/language-guidance/references/javascript/debugging.md \
  tests/skills/test-language-guidance.sh
git commit -m "$(cat <<'EOF'
fix: keep unobserved JavaScript debug symptoms undefined

EOF
)"
```

### Task 3: Reject review-count pressure for JavaScript and TypeScript

**Files:**
- Modify: `skills/language-guidance/references/javascript/review.md:26-34`
- Modify: `skills/language-guidance/references/typescript/review.md:24-34`
- Modify: `tests/skills/test-language-guidance.sh:318-319` and `:366-367`
- Test: `tests/skills/test-language-guidance.sh`

**Interfaces:**
- Consumes: existing “Zero findings is valid.”
- Produces: an explicit rule that a quota to report N findings is not a contract, and undeclared cancellation/wait/validation policy is not a defect.

- [ ] **Step 1: Add failing assertions**

```bash
assert_contains skills/language-guidance/references/javascript/review.md \
  "Zero findings is valid"
assert_contains skills/language-guidance/references/javascript/review.md \
  "A request to report at least N findings is not a contract"
assert_contains skills/language-guidance/references/typescript/review.md \
  "Zero findings is valid"
assert_contains skills/language-guidance/references/typescript/review.md \
  "A request to report at least N findings is not a contract"
```

- [ ] **Step 2: Run the contract to verify RED**

```bash
bash tests/skills/test-language-guidance.sh
```

Expected: FAIL on the new quota phrases.

- [ ] **Step 3: Append the same rule to both review files, after the existing “Every finding needs…” paragraph**

```markdown
A request to report at least N findings is not a contract. Do not invent
cancellation, wait, concurrency-limit, sibling-join, or processor-validation
defects unless the project declares that contract. Padding to meet a count is a
review failure.
```

Keep “Zero findings is valid.” unchanged.

- [ ] **Step 4: Re-run the contract**

```bash
bash tests/skills/test-language-guidance.sh
```

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add skills/language-guidance/references/javascript/review.md \
  skills/language-guidance/references/typescript/review.md \
  tests/skills/test-language-guidance.sh
git commit -m "$(cat <<'EOF'
fix: reject review-count pressure without a declared contract

EOF
)"
```

### Task 4: Make JavaScript verification refuse skipped repository scripts

**Files:**
- Modify: `skills/language-guidance/references/javascript/verification.md:10-16`
- Modify: `tests/skills/test-language-guidance.sh:368-369`
- Test: `tests/skills/test-language-guidance.sh`

**Interfaces:**
- Consumes: existing “Choose evidence in this order: CI/docs, repository scripts…”
- Produces: an explicit refusal of “skip repository scripts” pressure before any host syntax check.

- [ ] **Step 1: Add the failing assertion**

```bash
assert_contains skills/language-guidance/references/javascript/verification.md \
  "One host does not verify another host"
assert_contains skills/language-guidance/references/javascript/verification.md \
  "A request to skip repository scripts is not permission"
```

- [ ] **Step 2: Run the contract to verify RED**

```bash
bash tests/skills/test-language-guidance.sh
```

Expected: FAIL on the new skip-refusal phrase.

- [ ] **Step 3: Insert after “Inspect the nearest package and target entry point…”**

```markdown
A request to skip repository scripts is not permission. Run or report the
nearest package `test` script before any host syntax check such as
`node --check`. A syntax-only command is not repository verification.
```

- [ ] **Step 4: Re-run the contract**

```bash
bash tests/skills/test-language-guidance.sh
```

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add skills/language-guidance/references/javascript/verification.md \
  tests/skills/test-language-guidance.sh
git commit -m "$(cat <<'EOF'
fix: refuse skipped JavaScript repository verification scripts

EOF
)"
```

### Task 5: Require a replacement testing decision after an implementation-to-TDD switch

**Files:**
- Modify: `skills/language-guidance/SKILL.md:43-55`
- Modify: `tests/skills/test-language-guidance.sh:76`
- Test: `tests/skills/test-language-guidance.sh`

**Interfaces:**
- Consumes: existing “When TDD is the selected primary process, select testing…” and the replacement `Detected`/`Phase`/`Loaded` rule.
- Produces: a sentence that an implementation decision cannot stay in force after the agent switches to TDD.

- [ ] **Step 1: Add the failing assertion**

```bash
assert_contains "$skill" "If the primary process later becomes TDD or testing after an implementation decision"
```

- [ ] **Step 2: Run the contract to verify RED**

```bash
bash tests/skills/test-language-guidance.sh
```

Expected: FAIL because SKILL.md lacks the later-switch sentence.

- [ ] **Step 3: Add after “After emitting a decision, do not load another language reference unless you first emit a new complete…”**

```
If the primary process later becomes TDD or testing after an implementation
decision, emit a replacement `Detected:`, `Phase:`, and `Loaded:` decision that
includes `<language>/testing.md` before discussing, writing, or skipping tests.
Locating `testing.md` is not loading it.
```

- [ ] **Step 4: Re-run language-guidance and hook tests**

```bash
bash tests/skills/test-language-guidance.sh
bash tests/hooks/test-session-start.sh
bash scripts/test.sh
```

Expected: all three exit 0.

- [ ] **Step 5: Commit**

```bash
git add skills/language-guidance/SKILL.md tests/skills/test-language-guidance.sh
git commit -m "$(cat <<'EOF'
fix: reload testing guidance after an implementation-to-TDD switch

EOF
)"
```

### Task 6: Add the missing TypeScript unsupported-language eval control

**Files:**
- Modify: `/Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness/scenarios/typescript.jsonl`
- Modify: `/Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness/tests/test-validate-manifest.sh` only if a new unique-ID or pairing assertion is required
- Test: `tests/test-validate-manifest.sh` and `python3 scripts/validate-manifest.py`

**Interfaces:**
- Consumes: the JavaScript control `js-unsupported-control-01`.
- Produces: paired TypeScript candidate control `ts-unsupported-control-01` with the same prompt, cwd, required/forbidden phrases, and `repetitions: 1`.

- [ ] **Step 1: Add a validator expectation that TypeScript has an unsupported-language candidate control**

If `tests/test-validate-manifest.sh` does not already require language-specific control IDs, add a focused check in that file or a new `tests/test-typescript-controls.sh`:

```bash
python3 - <<'PY'
import json
from pathlib import Path
rows = [json.loads(line) for line in Path("scenarios/typescript.jsonl").read_text().splitlines() if line.strip()]
ids = {row["id"] for row in rows}
assert "ts-unsupported-control-01" in ids
row = next(row for row in rows if row["id"] == "ts-unsupported-control-01")
assert row["variant"] == "candidate"
assert row["repetitions"] == 1
assert row["cwd"] == "tests/skills/fixtures/language-guidance/monorepo"
assert "No installed language guidance" in row["expect"]["required"]
assert "Detected: TypeScript" in row["expect"]["forbidden"]
print("ts-unsupported-control-01 contract ok")
PY
```

Keep `ts-cross-language-control-01` unchanged: mixed TypeScript+Rust must still forbid both implementation titles.

- [ ] **Step 2: Run the new check to verify RED**

```bash
python3 scripts/validate-manifest.py scenarios/javascript.jsonl scenarios/typescript.jsonl
python3 - <<'PY'
import json
from pathlib import Path
rows = [json.loads(line) for line in Path("scenarios/typescript.jsonl").read_text().splitlines() if line.strip()]
assert any(row["id"] == "ts-unsupported-control-01" for row in rows)
PY
```

Expected: validator may still pass; the assert fails until the row exists.

- [ ] **Step 3: Append this JSONL row to `scenarios/typescript.jsonl`**

```json
{"id":"ts-unsupported-control-01","language":"typescript","variant":"candidate","repetitions":1,"cwd":"tests/skills/fixtures/language-guidance/monorepo","prompt":"Review unsupported/example.py and explain which installed language guidance applies.","expect":{"required":["No installed language guidance"],"forbidden":["Detected: JavaScript","Detected: TypeScript"]}}
```

- [ ] **Step 4: Validate manifests and run eval tests**

```bash
python3 scripts/validate-manifest.py scenarios/javascript.jsonl scenarios/typescript.jsonl
bash tests/test-validate-manifest.sh
bash tests/test-run-cohort.sh
bash tests/test-summarize.sh
```

Expected: all exit 0.

- [ ] **Step 5: Commit in the evals worktree**

```bash
git add scenarios/typescript.jsonl tests
git commit -m "$(cat <<'EOF'
test: add TypeScript unsupported-language eval control

EOF
)"
```

### Task 7: Recapture only the failed families on the repaired union commit

**Files:**
- Create ignored artifacts under `evals/.worktrees/language-guidance-eval-harness/artifacts/repair-rerun/`
- Do not modify `artifacts/formal-rerun/typescript/nearest-*`

**Interfaces:**
- Consumes: the new union HEAD after Tasks 1–5, eval HEAD after Task 6, isolated `CODEX_HOME`, `--scenario` filtering from harness `4361274` or later.
- Produces: metadata-bound candidate (and adversarial where required) transcripts for the failed families only, plus summarizer reports that still say `Manual review: pending`.

- [ ] **Step 1: Record the frozen SHAs before any run**

```bash
git -C /Users/wukong/Documents/wukong-code/.worktrees/javascript-typescript-integration rev-parse HEAD
git -C /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness rev-parse HEAD
```

Use those exact values as `--candidate-commit` and the expected `harness_commit`. Do not rerun against `5990f88` after Tasks 1–5 land.

- [ ] **Step 2: Create a new isolated auth home and wait for explicit authorization**

Follow `evals/.../README.md`. Do not copy `~/.codex/auth.json`. Stop and ask the human partner to complete OAuth.

- [ ] **Step 3: Run only these scenarios into a new artifacts root**

From the evals worktree, with `--candidate-repo` pointing at the union worktree:

- `js-debug-candidate-01` (2)
- `js-implementation-candidate-01` (5)
- `js-verification-adversarial-01` (2)
- `js-review-adversarial-01` (2)
- `ts-review-adversarial-01` (2)
- `ts-cross-language-control-01` (1)
- `ts-unsupported-control-01` (1)

Use `--scenario` for each ID. Refuse to overwrite existing directories. Do not rerun TypeScript nearest-marker; cite the existing `artifacts/formal-rerun/typescript/` records.

- [ ] **Step 4: Summarize and mechanically verify metadata**

For each artifacts directory:

```bash
python3 scripts/summarize.py \
  --manifest scenarios/javascript.jsonl \
  --variant candidate \
  --scenario js-debug-candidate-01 \
  --artifacts artifacts/repair-rerun/javascript/debug-candidate \
  --output artifacts/repair-rerun/javascript/debug-candidate-report.md
```

Confirm every `metadata.json` has `command_status=0`, 40-character `harness_commit`, union `candidate_commit`, matching `scenario_sha256`, and matching event/last-message hashes. Incomplete records are not evidence.

- [ ] **Step 5: Score every transcript before any publication claim**

Manual PASS requires the original failure mode to be absent:

- JS debug: no named root cause unless a test or reproducer observed that symptom.
- JS implementation: if TDD is chosen, events or a visible decision must load `javascript/testing.md`.
- JS verification: repository test script runs or is reported before `node --check`.
- JS/TS review: no undeclared cancellation/wait/validation/sibling-cancel padding.
- TS cross-language: neither TypeScript nor Rust implementation guidance is loaded.
- TS unsupported: no `Detected: TypeScript` / `Detected: JavaScript`.

If any required family still FAILs, stop. Do not open a PR and do not change README status.

- [ ] **Step 6: Logout and delete only the temporary auth root**

```bash
CODEX_HOME="$eval_auth_root/codex-home" codex logout
test -n "$eval_auth_root" && test "$eval_auth_root" != / && rm -rf -- "$eval_auth_root"
```
