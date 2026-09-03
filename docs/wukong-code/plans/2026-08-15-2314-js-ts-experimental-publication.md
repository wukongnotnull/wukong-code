# JavaScript and TypeScript Experimental Publication

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Produce honest Experimental README rows for JavaScript and TypeScript only after a frozen no-guidance / candidate / adversarial matrix, manual scoring, rewritten eval reports, and language-aware human review.

**Architecture:** Recapture the full eval manifests on one plugin commit and one harness commit. Older family PASSes (`c30003e`, `e19deb5`, `9e4406d`, nearest-marker `5990f88`) are development history only. JavaScript and TypeScript publish independently: one language may stay Planned if the other clears every gate. Do not flip README until a named human reviewer signs the exact commit.

**Tech Stack:** Existing `wukong-code-evals` runner in `/Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness`, Codex CLI `0.147.0`, model `gpt-5.6-terra`, Markdown eval reports, Bash contract tests.

## Global Constraints

- Candidate freeze: `/Users/wukong/Documents/wukong-code` at `e616b3b` unless HEAD moved; if HEAD moved, freeze the new `git rev-parse HEAD` before any session and use that SHA everywhere.
- Harness freeze: `c63a0ffe6bd2333d6c564869fb18d3f1513d2bf4` unless the evals worktree HEAD moved; record the actual `git rev-parse HEAD` from that worktree.
- Do not overwrite `artifacts/repair-rerun/`, `artifacts/followup-rerun/`, `artifacts/debug-constraint-rerun/`, or `artifacts/formal-rerun/`.
- Do not copy `~/.codex/auth.json`. Use a new isolated `CODEX_HOME` and `codex login --device-auth`.
- Phrase-screen `PASS`/`FLAGGED` is triage only. Manual score is the publication score.
- Do not write “guided beats baseline” unless the paired no-guidance vs candidate scores actually show that.
- Do not invent a human reviewer, date, or sign-off. If none is available, stop and leave README Planned.
- Add no third-party dependency.
- JS and TS remain separate rows. Never combine them.
- If any required family for a language FAILs, that language stays Planned. Do not open a publication PR for it.

## Evidence that does not count as this freeze

| Record | Why it is auxiliary |
| --- | --- |
| Historical 88-run `artifacts/formal/` | No `harness_commit`; standalone `ce769d0` / `6320186` |
| `artifacts/formal-rerun/typescript/nearest-*` | Candidate `5990f88`, not `e616b3b` |
| `artifacts/repair-rerun/` | Candidate `c30003ea` |
| `artifacts/followup-rerun/` | Candidate `e19deb53` |
| `artifacts/debug-constraint-rerun/` | Candidate `9e4406d6` |
| `docs/wukong-code/evals/2026-08-13-*-language-guidance.md` | Drafts; they say they are not publication evidence |

## Session budget

89 Codex sessions on the freeze (44 JavaScript + 45 TypeScript). Expect several hours. Logout and delete only the isolated auth root after scoring.

### JavaScript (44)

| ID | Variant | N |
| --- | --- | ---: |
| `js-implementation-no-guidance-01` | no-guidance | 5 |
| `js-implementation-candidate-01` | candidate | 5 |
| `js-tdd-no-guidance-01` | no-guidance | 5 |
| `js-tdd-adversarial-01` | adversarial | 5 |
| `js-debug-no-guidance-01` | no-guidance | 2 |
| `js-debug-candidate-01` | candidate | 2 |
| `js-review-no-guidance-01` | no-guidance | 2 |
| `js-review-adversarial-01` | adversarial | 2 |
| `js-verification-no-guidance-01` | no-guidance | 2 |
| `js-verification-adversarial-01` | adversarial | 2 |
| `js-nearest-no-guidance-01` | no-guidance | 5 |
| `js-nearest-candidate-01` | candidate | 5 |
| `js-unsupported-control-01` | candidate | 1 |
| `js-docs-control-01` | candidate | 1 |

### TypeScript (45)

| ID | Variant | N |
| --- | --- | ---: |
| `ts-implementation-no-guidance-01` | no-guidance | 5 |
| `ts-implementation-candidate-01` | candidate | 5 |
| `ts-tdd-no-guidance-01` | no-guidance | 5 |
| `ts-tdd-adversarial-01` | adversarial | 5 |
| `ts-debug-no-guidance-01` | no-guidance | 2 |
| `ts-debug-candidate-01` | candidate | 2 |
| `ts-review-no-guidance-01` | no-guidance | 2 |
| `ts-review-adversarial-01` | adversarial | 2 |
| `ts-verification-no-guidance-01` | no-guidance | 2 |
| `ts-verification-adversarial-01` | adversarial | 2 |
| `ts-nearest-no-guidance-01` | no-guidance | 5 |
| `ts-nearest-candidate-01` | candidate | 5 |
| `ts-cross-language-control-01` | candidate | 1 |
| `ts-docs-control-01` | candidate | 1 |
| `ts-unsupported-control-01` | candidate | 1 |

## Manual PASS rules

Score last-message plus explicit file reads / visible `Detected`/`Phase`/`Loaded` / commands. Hook additionalContext is not in `events.jsonl`.

- JS/TS implementation candidate: if TDD is chosen, `javascript/testing.md` or `typescript/testing.md` must be read before tests or “no edit needed.”
- JS/TS TDD adversarial: do not skip a valid RED; do not implement production because an existing nearby test is “close enough.”
- JS debug candidate: no named `Promise.all` fail-fast / hang / cleanup root cause unless an existing test, log, or user-supplied failing assertion observed that symptom.
- JS/TS review adversarial: zero findings is valid; do not invent undeclared cancellation / wait / validation / sibling-cancel / `any`-cast padding to hit a count.
- JS verification adversarial: repository test script runs or is reported before a generic host syntax check; do not claim Node proves browsers/Bun/Deno/workers.
- TS verification adversarial: `tsc --noEmit` is not runtime or every-consumer proof.
- JS nearest candidate: JavaScript from `javascript-worker` / `.mjs`; do not load TypeScript implementation.
- TS nearest candidate: TypeScript from `app.ts` + nearest `tsconfig.json`; do not load JavaScript review.
- JS/TS unsupported: no `Detected: JavaScript` / `Detected: TypeScript`; keep generic workflow.
- JS/TS docs-only: no implementation guidance loaded.
- TS cross-language: neither TypeScript nor Rust implementation guidance loaded.
- No-guidance variants: do not claim an installed JS/TS language pack was loaded.

A language may publish only when every required family for that language is manual PASS and every `metadata.json` has `command_status=0`, 40-character `harness_commit`, freeze `candidate_commit`, matching `scenario_sha256`, and matching event/last-message hashes.

---

### Task 1: Freeze SHAs and isolate Codex auth

**Files:**
- Create: ignored directory `evals/.worktrees/language-guidance-eval-harness/artifacts/experimental-publication/`
- Create: `/tmp/wukong-code-eval-auth-root.txt` pointing at a new temp home

**Interfaces:**
- Consumes: current plugin `main` and evals worktree HEAD.
- Produces: printed `CANDIDATE` and `HARNESS` SHAs used by every later `run-cohort.sh` invocation, plus an isolated logged-in `CODEX_HOME`.

- [ ] **Step 1: Record the freeze**

```bash
CANDIDATE=$(git -C /Users/wukong/Documents/wukong-code rev-parse HEAD)
HARNESS=$(git -C /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness rev-parse HEAD)
printf 'CANDIDATE=%s\nHARNESS=%s\n' "$CANDIDATE" "$HARNESS"
test -d /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness/artifacts/experimental-publication \
  && echo 'refusing to reuse existing experimental-publication root' && exit 1
mkdir -p /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness/artifacts/experimental-publication
```

Expected: two 40-character SHAs. If `experimental-publication` already exists, stop and pick a new unused directory name.

- [ ] **Step 2: Start isolated device-auth and wait**

```bash
eval_auth_root="$(mktemp -d /tmp/wukong-code-eval-auth.XXXXXX)"
mkdir -p "$eval_auth_root/codex-home"
printf '%s\n' "$eval_auth_root" > /tmp/wukong-code-eval-auth-root.txt
test ! -e "$eval_auth_root/codex-home/auth.json"
CODEX_HOME="$eval_auth_root/codex-home" codex login --device-auth
```

Stop and give the human partner the device URL and one-time code. Do not continue until `CODEX_HOME="$eval_auth_root/codex-home" codex login status` prints `Logged in using ChatGPT` and the isolated `auth.json` inode differs from `$HOME/.codex/auth.json`.

---

### Task 2: Recapture the JavaScript matrix

**Files:**
- Create: `artifacts/experimental-publication/javascript/<family>/` plus `run-javascript.log`

**Interfaces:**
- Consumes: Task 1 `CANDIDATE`, `HARNESS`, isolated `CODEX_HOME`.
- Produces: 44 complete `metadata.json` / `events.jsonl` / `last-message.md` triples.

- [ ] **Step 1: Define the runner**

From the evals worktree, with `EVAL_ROOT`, `UNION=/Users/wukong/Documents/wukong-code`, `AUTH_ROOT`, `CANDIDATE`, `MODEL=gpt-5.6-terra`:

```bash
run_one() {
  local language="$1" variant="$2" scenario="$3" artifacts="$4"
  printf '\n===== START %s %s =====\n' "$scenario" "$(date -u +%H:%M:%S)" | tee -a "$LOG"
  mkdir -p "$EVAL_ROOT/$artifacts"
  if "$EVAL_ROOT/scripts/run-cohort.sh" \
      --manifest "$EVAL_ROOT/scenarios/${language}.jsonl" \
      --language "$language" \
      --variant "$variant" \
      --scenario "$scenario" \
      --candidate-repo "$UNION" \
      --candidate-commit "$CANDIDATE" \
      --model "$MODEL" \
      --codex-home "$AUTH_ROOT/codex-home" \
      --artifacts "$EVAL_ROOT/$artifacts" \
      </dev/null >>"$LOG" 2>&1
  then
    printf '===== OK %s =====\n' "$scenario" | tee -a "$LOG"
  else
    printf '===== FAIL %s =====\n' "$scenario" | tee -a "$LOG"
    return 1
  fi
}
```

- [ ] **Step 2: Run every JavaScript ID**

```bash
LOG="$EVAL_ROOT/artifacts/experimental-publication/run-javascript.log"
run_one javascript no-guidance js-implementation-no-guidance-01 artifacts/experimental-publication/javascript/implementation-no-guidance
run_one javascript candidate js-implementation-candidate-01 artifacts/experimental-publication/javascript/implementation-candidate
run_one javascript no-guidance js-tdd-no-guidance-01 artifacts/experimental-publication/javascript/tdd-no-guidance
run_one javascript adversarial js-tdd-adversarial-01 artifacts/experimental-publication/javascript/tdd-adversarial
run_one javascript no-guidance js-debug-no-guidance-01 artifacts/experimental-publication/javascript/debug-no-guidance
run_one javascript candidate js-debug-candidate-01 artifacts/experimental-publication/javascript/debug-candidate
run_one javascript no-guidance js-review-no-guidance-01 artifacts/experimental-publication/javascript/review-no-guidance
run_one javascript adversarial js-review-adversarial-01 artifacts/experimental-publication/javascript/review-adversarial
run_one javascript no-guidance js-verification-no-guidance-01 artifacts/experimental-publication/javascript/verification-no-guidance
run_one javascript adversarial js-verification-adversarial-01 artifacts/experimental-publication/javascript/verification-adversarial
run_one javascript no-guidance js-nearest-no-guidance-01 artifacts/experimental-publication/javascript/nearest-no-guidance
run_one javascript candidate js-nearest-candidate-01 artifacts/experimental-publication/javascript/nearest-candidate
run_one javascript candidate js-unsupported-control-01 artifacts/experimental-publication/javascript/unsupported
run_one javascript candidate js-docs-control-01 artifacts/experimental-publication/javascript/docs
```

Refuse to overwrite an existing scenario artifacts directory. Incomplete records are not evidence.

- [ ] **Step 3: Summarize and check metadata**

For each JavaScript artifacts directory:

```bash
python3 scripts/summarize.py \
  --manifest scenarios/javascript.jsonl \
  --variant <variant> \
  --scenario <id> \
  --artifacts <dir> \
  --output artifacts/experimental-publication/javascript/<id>-report.md
```

Then verify every `metadata.json`: `command_status=0`, `candidate_commit=$CANDIDATE`, `harness_commit=$HARNESS`, matching hashes, `model=gpt-5.6-terra`.

---

### Task 3: Manually score JavaScript and rewrite its eval report

**Files:**
- Modify: `docs/wukong-code/evals/2026-08-13-javascript-language-guidance.md`
- Test: `tests/skills/test-language-guidance.sh` only in Task 7, after human review

**Interfaces:**
- Consumes: Task 2 artifacts and the Manual PASS rules.
- Produces: a JavaScript report that either (a) remains a draft and says Planned, or (b) records freeze SHAs, per-family manual scores, and waits for Task 6 human review.

- [ ] **Step 1: Score every JavaScript last-message and events file**

Write a table with columns Scenario, Rep, Automated screen, Manual, Failure mode present. A single FAIL family blocks JavaScript publication.

- [ ] **Step 2: If any JavaScript family FAILs, stop that language**

Keep the report title as a draft. Keep this sentence in the file:

```
Development-session observations were not preserved as raw output or intermediate commits and are not independently verifiable publication evidence.
```

Do not touch README. Continue Task 4 for TypeScript.

- [ ] **Step 3: If every JavaScript family PASSes, replace the draft banner**

Change the title from `evaluation draft` to `evaluation`. Replace the opening “Draft, not publication evidence” paragraph with a Methodology block that includes these exact facts, filled from Task 1–2:

```markdown
## Methodology and isolation

- Plugin candidate commit: `<CANDIDATE>`
- Eval harness commit: `<HARNESS>`
- Model: `gpt-5.6-terra`
- CLI: `codex-cli 0.147.0`
- Isolated `CODEX_HOME` (not a copy of `~/.codex/auth.json`)
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/experimental-publication/javascript/`
- Older formal/repair/followup/debug-constraint records are auxiliary and are not this freeze
```

Keep ECC provenance, official TC39/MDN/Node sources, and exclusions already in the draft. Add the manual-score tables. State that JavaScript-aware human review is still pending until Task 6.

- [ ] **Step 4: Commit only if the report changed and JavaScript is still not Experimental in README**

```bash
git add docs/wukong-code/evals/2026-08-13-javascript-language-guidance.md
git commit -m "$(cat <<'EOF'
docs: record frozen JavaScript language-guidance publication cohort

EOF
)"
```

---

### Task 4: Recapture the TypeScript matrix

**Files:**
- Create: `artifacts/experimental-publication/typescript/<family>/` plus `run-typescript.log`

**Interfaces:**
- Consumes: the same Task 1 freeze and auth as Task 2.
- Produces: 45 complete artifact triples.

- [ ] **Step 1: Run every TypeScript ID with the same `run_one` helper**

```bash
LOG="$EVAL_ROOT/artifacts/experimental-publication/run-typescript.log"
run_one typescript no-guidance ts-implementation-no-guidance-01 artifacts/experimental-publication/typescript/implementation-no-guidance
run_one typescript candidate ts-implementation-candidate-01 artifacts/experimental-publication/typescript/implementation-candidate
run_one typescript no-guidance ts-tdd-no-guidance-01 artifacts/experimental-publication/typescript/tdd-no-guidance
run_one typescript adversarial ts-tdd-adversarial-01 artifacts/experimental-publication/typescript/tdd-adversarial
run_one typescript no-guidance ts-debug-no-guidance-01 artifacts/experimental-publication/typescript/debug-no-guidance
run_one typescript candidate ts-debug-candidate-01 artifacts/experimental-publication/typescript/debug-candidate
run_one typescript no-guidance ts-review-no-guidance-01 artifacts/experimental-publication/typescript/review-no-guidance
run_one typescript adversarial ts-review-adversarial-01 artifacts/experimental-publication/typescript/review-adversarial
run_one typescript no-guidance ts-verification-no-guidance-01 artifacts/experimental-publication/typescript/verification-no-guidance
run_one typescript adversarial ts-verification-adversarial-01 artifacts/experimental-publication/typescript/verification-adversarial
run_one typescript no-guidance ts-nearest-no-guidance-01 artifacts/experimental-publication/typescript/nearest-no-guidance
run_one typescript candidate ts-nearest-candidate-01 artifacts/experimental-publication/typescript/nearest-candidate
run_one typescript candidate ts-cross-language-control-01 artifacts/experimental-publication/typescript/cross-language
run_one typescript candidate ts-docs-control-01 artifacts/experimental-publication/typescript/docs
run_one typescript candidate ts-unsupported-control-01 artifacts/experimental-publication/typescript/unsupported
```

- [ ] **Step 2: Summarize and check metadata**

Same `summarize.py` and `metadata.json` contract as Task 2, using `scenarios/typescript.jsonl`.

---

### Task 5: Manually score TypeScript and rewrite its eval report

**Files:**
- Modify: `docs/wukong-code/evals/2026-08-13-typescript-language-guidance.md`

**Interfaces:**
- Consumes: Task 4 artifacts and the Manual PASS rules.
- Produces: a TypeScript report that either stays a draft or records the freeze and pending human review.

- [ ] **Step 1: Score every TypeScript transcript against the Manual PASS rules**

- [ ] **Step 2: If any TypeScript family FAILs, keep the draft publication-status section and do not touch README**

- [ ] **Step 3: If every TypeScript family PASSes, replace the draft publication-status section**

Use the same Methodology block shape as JavaScript, pointing at `artifacts/experimental-publication/typescript/`. Keep ECC/`eb497026` provenance and official TypeScript handbook sources already in the draft. State that TypeScript-aware human review is pending until Task 6.

- [ ] **Step 4: Commit the TypeScript report without README status changes**

```bash
git add docs/wukong-code/evals/2026-08-13-typescript-language-guidance.md
git commit -m "$(cat <<'EOF'
docs: record frozen TypeScript language-guidance publication cohort

EOF
)"
```

---

### Task 6: Language-aware human review

**Files:**
- Modify: the eval report(s) that passed Tasks 3 and/or 5

**Interfaces:**
- Consumes: the six JS and/or TS references, registry, fixtures, freeze SHAs, and the scored tables.
- Produces: a review block with only facts the reviewer supplies.

- [ ] **Step 1: Stop and ask the human partner to name reviewers**

Required fields, copied verbatim from the reviewer (do not infer expertise):

- reviewer identity or approved attribution
- date
- language experience/context (JavaScript and/or TypeScript)
- exact commit reviewed (`CANDIDATE`)
- paths reviewed
- approval, requested changes, and reservations

If no qualified reviewer is available, stop. README stays Planned.

- [ ] **Step 2: If the reviewer requests behavior changes, do not publish**

Route those changes to a new repair plan. Re-run only the affected families on a new freeze. Do not reuse this plan’s README steps on the old SHA.

- [ ] **Step 3: If the reviewer approves, append this block to the matching eval report**

```markdown
## Language-aware human review

- Reviewer: <identity>
- Date: <date>
- Language context: <JavaScript and/or TypeScript experience>
- Commit: <CANDIDATE>
- Paths: skills/language-guidance/references/<language>/, registry.json, fixtures, this report
- Decision: approved for Experimental publication
- Reservations: <none, or quoted reservations>
```

```bash
git add docs/wukong-code/evals/2026-08-13-javascript-language-guidance.md \
  docs/wukong-code/evals/2026-08-13-typescript-language-guidance.md
git commit -m "$(cat <<'EOF'
docs: record language-aware review for JS/TS publication

EOF
)"
```

Only add the files that actually received a sign-off.

---

### Task 7: Flip README only for languages that cleared every gate

**Files:**
- Modify: `tests/skills/test-language-guidance.sh`
- Modify: `README.md`, `README.zh-CN.md`, `README.zh-TW.md`, `README.ja.md`, `README.ko.md`
- Modify: `docs/testing.md` only if a language publishes (add the fixture reproduction line already used for other packs)
- Test: `tests/skills/test-language-guidance.sh` and `bash scripts/test.sh`

**Interfaces:**
- Consumes: Task 6 sign-off and passing freeze scores.
- Produces: Experimental rows and matching contract tests for each approved language only.

- [ ] **Step 1: Write the failing publication assertions**

If JavaScript was approved, replace these existing asserts in `tests/skills/test-language-guidance.sh`:

```bash
assert_contains README.md "| JavaScript | Planned | — | — | — | — | — | — |"
assert_contains README.zh-CN.md "| JavaScript | 计划中 |"
assert_contains README.zh-TW.md "| JavaScript | 規劃中 |"
assert_contains README.ja.md "| JavaScript | 計画中 |"
assert_contains README.ko.md "| JavaScript | 계획됨 |"
assert_contains "$javascript_eval" \
  "Development-session observations were not preserved as raw output or intermediate commits and are not independently verifiable publication evidence."
```

with:

```bash
assert_contains README.md "| JavaScript | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | [Eval report](docs/wukong-code/evals/2026-08-13-javascript-language-guidance.md) |"
assert_contains README.zh-CN.md "| JavaScript | 实验性 |"
assert_contains README.zh-TW.md "| JavaScript | 實驗性 |"
assert_contains README.ja.md "| JavaScript | 実験的 |"
assert_contains README.ko.md "| JavaScript | 실험적 |"
assert_contains "$javascript_eval" "Plugin candidate commit:"
assert_contains "$javascript_eval" "## Language-aware human review"
```

If TypeScript was approved, add (there is no current TypeScript Planned assert):

```bash
assert_contains README.md "| TypeScript | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | [Eval report](docs/wukong-code/evals/2026-08-13-typescript-language-guidance.md) |"
assert_contains README.zh-CN.md "| TypeScript | 实验性 |"
assert_contains README.zh-TW.md "| TypeScript | 實驗性 |"
assert_contains README.ja.md "| TypeScript | 実験的 |"
assert_contains README.ko.md "| TypeScript | 실험적 |"
```

If a language did not clear the gates, leave its Planned asserts unchanged.

- [ ] **Step 2: Run the test to verify RED**

```bash
bash tests/skills/test-language-guidance.sh
```

Expected: FAIL on the new Experimental phrases because README still says Planned.

- [ ] **Step 3: Update only the approved README rows**

JavaScript, if approved:

```markdown
| JavaScript | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | [Eval report](docs/wukong-code/evals/2026-08-13-javascript-language-guidance.md) |
```

```markdown
| JavaScript | 实验性 | ✓   | ✓   | ✓   | ✓   | ✓   | [评估报告](docs/wukong-code/evals/2026-08-13-javascript-language-guidance.md) |
```

```markdown
| JavaScript | 實驗性 | ✓ | ✓ | ✓ | ✓ | ✓ | [評估報告](docs/wukong-code/evals/2026-08-13-javascript-language-guidance.md) |
```

```markdown
| JavaScript | 実験的 | ✓ | ✓ | ✓ | ✓ | ✓ | [評価レポート](docs/wukong-code/evals/2026-08-13-javascript-language-guidance.md) |
```

```markdown
| JavaScript | 실험적 | ✓ | ✓ | ✓ | ✓ | ✓ | [평가 보고서](docs/wukong-code/evals/2026-08-13-javascript-language-guidance.md) |
```

TypeScript, if approved, uses the same status words and `2026-08-13-typescript-language-guidance.md`. Keep any unapproved language on its current Planned / 计划中 / 規劃中 / 計画中 / 계획됨 row.

In `docs/testing.md`, after the existing `test-language-guidance.sh` mention, add only the lines for published languages:

```
JavaScript fixture: `tests/skills/fixtures/language-guidance/javascript-basic` (`npm test`).
TypeScript fixture: `tests/skills/fixtures/language-guidance/typescript-basic` (local `tsc` / fixture tests).
```

- [ ] **Step 4: Run tests to verify GREEN**

```bash
bash tests/skills/test-language-guidance.sh
bash scripts/test.sh
```

Expected: all exit 0.

- [ ] **Step 5: Commit**

```bash
git add tests/skills/test-language-guidance.sh README.md README.zh-CN.md README.zh-TW.md README.ja.md README.ko.md docs/testing.md docs/wukong-code/evals
git commit -m "$(cat <<'EOF'
docs: publish experimental JS/TS language-guidance status

EOF
)"
```

Only stage files that actually changed.

---

### Task 8: Logout isolated auth

**Files:** none in git

- [ ] **Step 1: Logout and delete only the temp auth root**

```bash
eval_auth_root="$(cat /tmp/wukong-code-eval-auth-root.txt)"
CODEX_HOME="$eval_auth_root/codex-home" codex logout
test -n "$eval_auth_root" && test "$eval_auth_root" != / && test "$eval_auth_root" != "$HOME" && rm -rf -- "$eval_auth_root"
rm -f /tmp/wukong-code-eval-auth-root.txt
test -f "$HOME/.codex/auth.json" && echo 'global auth.json untouched'
```

Do not push unless the human partner explicitly asks. Experimental on `main` is a publication claim; they must see the complete README diff first.
