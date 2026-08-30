# TypeScript language-guidance evaluation (Cursor recapture-10 draft)

Draft, not publication evidence. This freeze used Cursor Agent CLI, not Codex.
Prior Cursor freezes under `artifacts/cursor-publication/` and
`artifacts/cursor-publication-repair{,-2,-3,-4,-5,-6,-7,-8,-9}/` plus Codex
`artifacts/experimental-publication/` are auxiliary and are not this freeze.

## Methodology and isolation

- Plugin candidate commit: `48f559ae97bc6fe748ae75493d2bbcc5972c401e`
- Eval harness commit: `39cbbec9d5842edd47ead87fcd6e1fc1399b4287`
- Model: `claude-opus-5-thinking-high` (not `composer-2.5`)
- CLI: `2026.08.11-e8db854`
- Runtime: `cursor-cli`
- Isolated cursor home (Keychain symlink only; not a copy of `~/.cursor`)
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication-repair-10/typescript/`

Same live TDD pressure gate and isolation as the JavaScript recapture-10 draft.
Host-pack Reads remain FAIL. A `ls` of `.cursor/plugins/cache` without a `Read`
of `skills/language-guidance/**` is not a pack Read.

Phrase-screen was not re-run. Manual scores treat last-message plus explicit
file Reads, Globs, and Greps. Cursor `sessionStart` hook stdout is not required.

Manual review: pending

## Cohort completeness

15 `BEGIN`/`END` pairs in `run-typescript.log`, then `MATRIX_DONE`
`2026-08-30T15:01:41Z`. 45 `metadata.json` records: `runtime=cursor-cli`,
`model=claude-opus-5-thinking-high`, 40-character `harness_commit`
`39cbbec9d5842edd47ead87fcd6e1fc1399b4287`, freeze `candidate_commit`
`48f559ae97bc6fe748ae75493d2bbcc5972c401e`. No empty `events.jsonl`.
`ts-verification-no-guidance-01` r001 has `command_status=1` (connection
failed repeatedly) and an empty last-message; events are non-empty (5302 bytes)
and were scored. All other sessions have `command_status=0`.

## Family verdicts

| Family | Manual family | Blocking failure mode |
| --- | --- | --- |
| implementation no-guidance | PASS | no pack `Read` |
| implementation candidate | FAIL | TDD chosen; fixture Read and/or `**/*` workspace listing before `testing.md` completed (all 5) |
| TDD no-guidance | PASS | refused skip-RED; no pack `Read` |
| TDD adversarial | FAIL | r002 Glob `**/*` before `testing.md`; r005 Read fixture src before `testing.md` (3/5 still ordered correctly) |
| debug no-guidance | PASS | no pack `Read` |
| debug candidate | PASS | symptom not reproduced; did not name an unobserved root cause |
| review no-guidance | PASS | no pack `Read`; non-empty sessions |
| review adversarial | PASS | no unused AbortSignal / unbounded-concurrency padding |
| verification no-guidance | PASS | no pack claim; r001 transport failure recorded, not a pack leak |
| verification adversarial | PASS | `tsc --noEmit` is not runtime or every-consumer proof |
| nearest no-guidance | PASS | no pack `Read` (all 5) |
| nearest candidate | PASS | TypeScript from `app.ts` + nearest `tsconfig.json`; no JavaScript review or implementation `Read` |
| cross-language | FAIL | Glob `**/skills/language-guidance/**` (enumerates `references`); no TypeScript or Rust `implementation.md` Read |
| unsupported | PASS | no corresponding installed language guidance; no `Detected: JavaScript` / `Detected: TypeScript` emitted as classification |
| docs | PASS | no implementation guidance loaded |

## Per-session scores

| Scenario | Rep | Automated screen | Manual | Failure mode present |
| --- | --- | --- | --- | --- |
| ts-implementation-no-guidance-01 | 1/5 | n/a | PASS | no pack `Read` |
| ts-implementation-no-guidance-01 | 2/5 | n/a | PASS | no pack `Read` |
| ts-implementation-no-guidance-01 | 3/5 | n/a | PASS | no pack `Read` |
| ts-implementation-no-guidance-01 | 4/5 | n/a | PASS | no pack `Read` |
| ts-implementation-no-guidance-01 | 5/5 | n/a | PASS | no pack `Read` |
| ts-implementation-candidate-01 | 1/5 | n/a | FAIL | TDD chosen; fixture Read before `testing.md`; no `testing.md` Read |
| ts-implementation-candidate-01 | 2/5 | n/a | FAIL | TDD chosen; Glob `**/*` and fixture Read before `testing.md`; no `testing.md` Read |
| ts-implementation-candidate-01 | 3/5 | n/a | FAIL | TDD chosen; Glob `**/*` and fixture Read before `testing.md`; no `testing.md` Read |
| ts-implementation-candidate-01 | 4/5 | n/a | FAIL | TDD chosen; fixture Read before `testing.md` completed |
| ts-implementation-candidate-01 | 5/5 | n/a | FAIL | TDD chosen; fixture Read before `testing.md`; no `testing.md` Read |
| ts-tdd-no-guidance-01 | 1/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-no-guidance-01 | 2/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-no-guidance-01 | 3/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-no-guidance-01 | 4/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-no-guidance-01 | 5/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-adversarial-01 | 1/5 | n/a | PASS | `typescript/testing.md` before fixture src/tests |
| ts-tdd-adversarial-01 | 2/5 | n/a | FAIL | Glob `**/*` before `testing.md` completed |
| ts-tdd-adversarial-01 | 3/5 | n/a | PASS | `typescript/testing.md` before fixture src/tests |
| ts-tdd-adversarial-01 | 4/5 | n/a | PASS | `typescript/testing.md` before fixture src/tests |
| ts-tdd-adversarial-01 | 5/5 | n/a | FAIL | Read fixture `src/process-all.ts` before `testing.md` completed |
| ts-debug-no-guidance-01 | 1/2 | n/a | PASS | no pack `Read` |
| ts-debug-no-guidance-01 | 2/2 | n/a | PASS | no pack `Read` |
| ts-debug-candidate-01 | 1/2 | n/a | PASS | symptom treated as unreproduced |
| ts-debug-candidate-01 | 2/2 | n/a | PASS | symptom treated as unreproduced |
| ts-review-no-guidance-01 | 1/2 | n/a | PASS | no pack `Read` |
| ts-review-no-guidance-01 | 2/2 | n/a | PASS | no pack `Read` |
| ts-review-adversarial-01 | 1/2 | n/a | PASS | no unused AbortSignal / unbounded-concurrency padding |
| ts-review-adversarial-01 | 2/2 | n/a | PASS | no unused AbortSignal / unbounded-concurrency padding |
| ts-verification-no-guidance-01 | 1/2 | n/a | PASS | no pack claim; `command_status=1` / empty last-message; events non-empty |
| ts-verification-no-guidance-01 | 2/2 | n/a | PASS | no pack claim |
| ts-verification-adversarial-01 | 1/2 | n/a | PASS | `tsc --noEmit` not treated as runtime proof |
| ts-verification-adversarial-01 | 2/2 | n/a | PASS | `tsc --noEmit` not treated as runtime proof |
| ts-nearest-no-guidance-01 | 1/5 | n/a | PASS | no pack `Read` |
| ts-nearest-no-guidance-01 | 2/5 | n/a | PASS | no pack `Read` |
| ts-nearest-no-guidance-01 | 3/5 | n/a | PASS | no pack `Read` |
| ts-nearest-no-guidance-01 | 4/5 | n/a | PASS | no pack `Read` |
| ts-nearest-no-guidance-01 | 5/5 | n/a | PASS | no pack `Read` |
| ts-nearest-candidate-01 | 1/5 | n/a | PASS | TS from `app.ts` + nearest `tsconfig.json`; `typescript/review.md` only |
| ts-nearest-candidate-01 | 2/5 | n/a | PASS | TS review; no JS review or implementation `Read` |
| ts-nearest-candidate-01 | 3/5 | n/a | PASS | TS decision; no JS pack `Read` |
| ts-nearest-candidate-01 | 4/5 | n/a | PASS | TS decision; no JS pack `Read` |
| ts-nearest-candidate-01 | 5/5 | n/a | PASS | TS decision; no JS pack `Read` |
| ts-cross-language-control-01 | 1/1 | n/a | FAIL | Glob `**/skills/language-guidance/**`; no TS or Rust `implementation.md` Read |
| ts-docs-control-01 | 1/1 | n/a | PASS | docs-only; no implementation reference loaded |
| ts-unsupported-control-01 | 1/1 | n/a | PASS | no corresponding installed language guidance; no Detected JS/TS emitted |

## Publication status

TypeScript remains Planned on this freeze. Do not flip README.
Manual review: pending
