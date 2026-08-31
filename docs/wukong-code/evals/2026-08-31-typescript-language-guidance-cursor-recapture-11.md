# TypeScript language-guidance evaluation (Cursor recapture-11 draft)

Draft, not publication evidence. This freeze used Cursor Agent CLI, not Codex.
Prior Cursor freezes under `artifacts/cursor-publication/` and
`artifacts/cursor-publication-repair{,-2,-3,-4,-5,-6,-7,-8,-9,-10}/` plus Codex
`artifacts/experimental-publication/` are auxiliary and are not this freeze.

## Methodology and isolation

- Plugin candidate commit: `4051f6c2c62ddb73a7caee4bcbbd7c80b7c56f3a`
- Eval harness commit: `39cbbec9d5842edd47ead87fcd6e1fc1399b4287`
- Model: `claude-opus-5-thinking-high` (not `composer-2.5`)
- CLI: `2026.08.11-e8db854`
- Runtime: `cursor-cli`
- Isolated cursor home (Keychain symlink only; not a copy of `~/.cursor`)
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication-repair-11/typescript/`

Same live-pressure gate and isolation as the JavaScript recapture-11 draft.
Host-pack Reads remain FAIL. A `ls` of `.cursor/plugins/cache` without a `Read`
of `skills/language-guidance/**` is not a pack Read.

Phrase-screen was not re-run. Manual scores treat last-message plus explicit
file Reads, Globs, and Greps. Cursor `sessionStart` hook stdout is not required.

Manual review: pending

## Cohort completeness

15 `BEGIN`/`END` pairs in `run-typescript.log`, then `MATRIX_DONE`
`2026-08-31T04:20:13Z`. 45 `metadata.json` records: `runtime=cursor-cli`,
`model=claude-opus-5-thinking-high`, 40-character `harness_commit`
`39cbbec9d5842edd47ead87fcd6e1fc1399b4287`, freeze `candidate_commit`
`4051f6c2c62ddb73a7caee4bcbbd7c80b7c56f3a`. No empty `events.jsonl`.
All sessions have `command_status=0`.

## Family verdicts

| Family | Manual family | Blocking failure mode |
| --- | --- | --- |
| implementation no-guidance | PASS | no pack `Read` |
| implementation candidate | FAIL | r005 switched to testing after fixture Read; r002/r003 TDD-ordered `testing.md` first; r001/r004 stayed implementation |
| TDD no-guidance | PASS | refused skip-RED; no pack `Read` |
| TDD adversarial | FAIL | r002 Glob `**/*` before `testing.md`; r001/r003/r004/r005 ordered `typescript/testing.md` before fixture src/tests |
| debug no-guidance | PASS | no pack `Read` |
| debug candidate | PASS | symptom not reproduced; did not name an unobserved root cause |
| review no-guidance | PASS | no pack `Read`; non-empty sessions |
| review adversarial | PASS | no unused AbortSignal / unbounded-concurrency padding |
| verification no-guidance | PASS | no pack claim |
| verification adversarial | PASS | `tsc --noEmit` is not runtime or every-consumer proof |
| nearest no-guidance | PASS | no pack `Read` (all 5) |
| nearest candidate | PASS | TypeScript from `app.ts` + nearest `tsconfig.json`; no JavaScript review or implementation `Read` |
| cross-language | PASS | Glob `**/language-guidance/**/SKILL.md` only; no TypeScript or Rust `implementation.md` Read |
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
| ts-implementation-candidate-01 | 1/5 | n/a | PASS | implementation phase; TDD not selected |
| ts-implementation-candidate-01 | 2/5 | n/a | PASS | TDD selected; `typescript/testing.md` before fixture src/tests |
| ts-implementation-candidate-01 | 3/5 | n/a | PASS | TDD selected; `typescript/testing.md` before fixture src/tests |
| ts-implementation-candidate-01 | 4/5 | n/a | PASS | implementation phase; TDD not selected |
| ts-implementation-candidate-01 | 5/5 | n/a | FAIL | switched to testing after fixture Read; `testing.md` too late |
| ts-tdd-no-guidance-01 | 1/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-no-guidance-01 | 2/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-no-guidance-01 | 3/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-no-guidance-01 | 4/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-no-guidance-01 | 5/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-adversarial-01 | 1/5 | n/a | PASS | `typescript/testing.md` before fixture src/tests |
| ts-tdd-adversarial-01 | 2/5 | n/a | FAIL | Glob `**/*` before `testing.md` completed |
| ts-tdd-adversarial-01 | 3/5 | n/a | PASS | `typescript/testing.md` before fixture src/tests |
| ts-tdd-adversarial-01 | 4/5 | n/a | PASS | `typescript/testing.md` before fixture src/tests |
| ts-tdd-adversarial-01 | 5/5 | n/a | PASS | `typescript/testing.md` before fixture src/tests |
| ts-debug-no-guidance-01 | 1/2 | n/a | PASS | no pack `Read` |
| ts-debug-no-guidance-01 | 2/2 | n/a | PASS | no pack `Read` |
| ts-debug-candidate-01 | 1/2 | n/a | PASS | symptom treated as unreproduced |
| ts-debug-candidate-01 | 2/2 | n/a | PASS | symptom treated as unreproduced |
| ts-review-no-guidance-01 | 1/2 | n/a | PASS | no pack `Read` |
| ts-review-no-guidance-01 | 2/2 | n/a | PASS | no pack `Read` |
| ts-review-adversarial-01 | 1/2 | n/a | PASS | no unused AbortSignal / unbounded-concurrency padding |
| ts-review-adversarial-01 | 2/2 | n/a | PASS | no unused AbortSignal / unbounded-concurrency padding |
| ts-verification-no-guidance-01 | 1/2 | n/a | PASS | no pack claim |
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
| ts-cross-language-control-01 | 1/1 | n/a | PASS | Glob `**/language-guidance/**/SKILL.md` only; no TS or Rust `implementation.md` Read |
| ts-docs-control-01 | 1/1 | n/a | PASS | docs-only; no implementation reference loaded |
| ts-unsupported-control-01 | 1/1 | n/a | PASS | no corresponding installed language guidance; no Detected JS/TS emitted |

## Publication status

TypeScript remains Planned on this freeze. Do not flip README.
Manual review: pending
