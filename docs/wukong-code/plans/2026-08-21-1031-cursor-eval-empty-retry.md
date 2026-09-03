# Cursor Eval Empty-Session Retry Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Recover Cursor eval sessions that write empty `events.jsonl` twice in a row (recapture-3 lost 17 JavaScript rows after one retry), and lock that the runner never passes `--add-dir` pointing at the operator plugin checkout.

**Architecture:** Keep `--sandbox enabled` and `--workspace` on the fixture. Retry an empty agent invoke up to three times with linear backoff (`CURSOR_EVAL_EMPTY_RETRY_SLEEP`, default 1s). Cursor CLI has no path-deny flag; do not invent `--add-dir` or disable sandbox. Operator-checkout pack Reads stay a recapture scoring FAIL and a smoke hard-fail in the sibling recapture-4 plan.

**Tech Stack:** Bash 3.2+, Python 3 standard library, existing fake `agent` in `tests/test-run-cursor-cohort.sh`.

## Global Constraints

- Repository: `wukong-code-evals` worktree `/Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness`.
- Continue on branch `cursor/language-guidance-eval-harness`. Do not merge to evals `main` from this plan.
- Do not modify `scripts/run-cohort.sh` (Codex).
- Add no package-manager dependency.
- Keep `--sandbox enabled`. Do not add `--worktree`. Do not add `--add-dir`.
- Do not copy `~/.cursor`. Darwin Keychain remains symlink-only.
- `no-guidance` argv must omit `--plugin-dir`.
- Do not sweep Darwin `T` / `/tmp` for other processes' temps.
- Do not flip README language-pack rows. Do not open a publication PR from this plan.
- The runner is bash. Keep `status=$?` in the runner as-is.

## File map

| Path | Responsibility |
| --- | --- |
| `scripts/run-cursor-cohort.sh` | Three empty-session attempts with backoff |
| `tests/test-run-cursor-cohort.sh` | Fake-agent empty-twice recovery; no `--add-dir` |
| `README.md` | Document three retries and no path-deny |

Reuse without editing: `scripts/render-config.py`, `scripts/extract-cursor-last-message.py`, `scripts/summarize.py`, `scenarios/javascript.jsonl`, `scenarios/typescript.jsonl`.

Do not start the recapture-4 plan until this plan and the skill plan have commits on their worktrees.

---

### Task 1: Recover two consecutive empty agent invokes

**Files:**
- Modify: `tests/test-run-cursor-cohort.sh`
- Modify: `scripts/run-cursor-cohort.sh`
- Modify: `README.md`

**Interfaces:**
- Consumes: existing `FAKE_EMPTY_ONCE` (one empty, then success) and `status=$?` after agent.
- Produces: up to three agent invokes when `events.jsonl` is empty; `CURSOR_EVAL_EMPTY_RETRY_SLEEP` (default `1`) between empties; `FAKE_EMPTY_TWICE` recovers on the third invoke; argv never includes `--add-dir`.

- [ ] **Step 1: Write the failing empty-twice contract**

In `tests/test-run-cursor-cohort.sh`, immediately after the `FAKE_EMPTY_ONCE` block in the fake `agent`:

```
if [[ "${FAKE_EMPTY_ONCE:-0}" == 1 ]]; then
  marker="$FAKE_RECORD/empty-once"
  if [[ ! -e "$marker" ]]; then
    touch "$marker"
    exit 1
  fi
fi
```

add:

```
if [[ "${FAKE_EMPTY_TWICE:-0}" == 1 ]]; then
  marker="$FAKE_RECORD/empty-twice"
  count=0
  if [[ -f "$marker" ]]; then
    count="$(cat "$marker")"
  fi
  count=$((count + 1))
  printf '%s\n' "$count" >"$marker"
  if [[ "$count" -lt 3 ]]; then
    exit 1
  fi
fi
```

Immediately after the existing `record-empty` / `FAKE_EMPTY_ONCE` success asserts (the `grep -Fxq 'JavaScript guidance loaded'` on `$TMP/empty-artifacts/.../last-message.md`), add:

```bash
mkdir -p "$TMP/record-empty-twice"
if ! env PATH="$TMP/bin:$PATH" FAKE_RECORD="$TMP/record-empty-twice" FAKE_EMPTY_TWICE=1 \
  CURSOR_EVAL_EMPTY_RETRY_SLEEP=0 HOME="$TMP/operator-home" \
  "$RUNNER" \
  --manifest "$TMP/manifest.jsonl" --language javascript --variant candidate \
  --scenario js-smoke-candidate-01 \
  --candidate-repo "$TMP/candidate" --candidate-commit "$candidate_sha" \
  --model test-model --cursor-home "$TMP/auth" --artifacts "$TMP/empty-twice-artifacts" \
  --agent-bin "$TMP/bin/agent"; then
  echo "runner did not recover from two empty agent invokes" >&2
  exit 1
fi
test -s "$TMP/empty-twice-artifacts/js-smoke-candidate-01/r001/events.jsonl"
python3 - "$TMP/empty-twice-artifacts/js-smoke-candidate-01/r001/metadata.json" <<'PY'
import json, sys
data = json.load(open(sys.argv[1], encoding="utf-8"))
assert data["command_status"] == 0
PY
grep -Fxq 'JavaScript guidance loaded' "$TMP/empty-twice-artifacts/js-smoke-candidate-01/r001/last-message.md"
python3 - "$TMP/record-empty-twice/empty-twice" <<'PY'
from pathlib import Path
import sys
assert Path(sys.argv[1]).read_text().strip() == "3"
PY
```

Immediately after the existing no-guidance leftover `--plugin-dir` grep, add:

```bash
if grep -Fxq -- '--add-dir' "$TMP/record-ng-leftover/args"; then
  echo "no-guidance leftover rerun passed --add-dir" >&2
  exit 1
fi
if grep -Fq 'Documents/wukong-code/skills/language-guidance' "$TMP/record-ng-leftover/args"; then
  echo "no-guidance argv named operator language-guidance" >&2
  exit 1
fi
```

- [ ] **Step 2: Run the test to verify it fails**

Run:

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
CURSOR_EVAL_EMPTY_RETRY_SLEEP=0 bash tests/test-run-cursor-cohort.sh
```

Expected: FAIL with `runner did not recover from two empty agent invokes` (current runner retries empty once). Do not edit the runner until this failure is observed.

- [ ] **Step 3: Retry empty events up to three times**

In `scripts/run-cursor-cohort.sh`, replace the current agent invoke plus one empty retry:

```
    set +e
    env "${agent_env[@]}" "$agent_bin" "${args[@]}" "$prompt" >"$events"
    status=$?
    set -e
    if [[ ! -s "$events" ]]; then
      set +e
      env "${agent_env[@]}" "$agent_bin" "${args[@]}" "$prompt" >"$events"
      status=$?
      set -e
    fi
```

with:

```
    empty_tries=0
    while true; do
      set +e
      env "${agent_env[@]}" "$agent_bin" "${args[@]}" "$prompt" >"$events"
      status=$?
      set -e
      if [[ -s "$events" ]]; then
        break
      fi
      empty_tries=$((empty_tries + 1))
      if [[ "$empty_tries" -ge 3 ]]; then
        break
      fi
      sleep $((empty_tries * ${CURSOR_EVAL_EMPTY_RETRY_SLEEP:-1}))
    done
```

Do not change `--sandbox enabled`. Do not add `--add-dir` or `--worktree`. Keep guided `--plugin-dir` and no-guidance omission unchanged.

- [ ] **Step 4: Run the test to verify it passes**

Run:

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
CURSOR_EVAL_EMPTY_RETRY_SLEEP=0 bash tests/test-run-cursor-cohort.sh
```

Expected: `STATUS: PASSED`. `FAKE_EMPTY_ONCE` still recovers. `FAKE_EMPTY_TWICE` recovers on the third invoke.

- [ ] **Step 5: Document retries and the operator-checkout limit**

In `README.md`, immediately after the paragraph that ends with `Guided sessions still set HOME and XDG directories to --cursor-home.`, add:

```
If `events.jsonl` is empty, the Cursor runner retries that repetition up to
three agent invokes, sleeping `n * CURSOR_EVAL_EMPTY_RETRY_SLEEP` seconds
after empty attempt `n` (default sleep unit 1). Set
`CURSOR_EVAL_EMPTY_RETRY_SLEEP=0` in tests. Cursor CLI has no path-deny
flag; the runner never passes `--add-dir`. A no-guidance `Read` of the
operator checkout `…/Documents/wukong-code/skills/language-guidance/**` is
still a publication FAIL and must fail recapture smoke.
```

- [ ] **Step 6: Commit**

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
git add tests/test-run-cursor-cohort.sh scripts/run-cursor-cohort.sh README.md
git commit -m "$(cat <<'EOF'
fix: retry empty Cursor eval sessions three times with backoff

EOF
)"
```

---

## Spec coverage

- Three empty retries with backoff: Task 1.
- No `--add-dir`, no path-deny invention: Task 1 argv asserts and README.
- Operator-checkout Read remains a recapture smoke FAIL: README plus sibling recapture-4 plan.
- No README language-pack flip: Global Constraints.

## Execution handoff

Skill constraints are `2026-08-21-1031-js-ts-skill-hard-constraints.md`. Recapture-4 is `2026-08-21-1031-js-ts-cursor-recapture.md`.
