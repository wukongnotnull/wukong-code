# TypeScript language-guidance evaluation (Cursor recapture-3 draft)

Draft, not publication evidence. This freeze used Cursor Agent CLI, not Codex.
Codex artifacts under `artifacts/experimental-publication/`, the first Cursor
freeze under `artifacts/cursor-publication/`, recapture-1 under
`artifacts/cursor-publication-repair/`, and recapture-2 under
`artifacts/cursor-publication-repair-2/` are auxiliary and are not this freeze.

## Methodology and isolation

- Plugin candidate commit: `691d8f2c09be0c2c905f9d9b0dbffeeba381cd21`
- Eval harness commit: `4ac996483a38701918b5c0c366209c0907b9a71b`
- Model: `composer-2.5`
- CLI: `2026.08.11-e8db854`
- Runtime: `cursor-cli`
- Isolated cursor home (Keychain symlink only; not a copy of `~/.cursor`)
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication-repair-3/typescript/`

This freeze used nested eval temps (`$eval_tmp_root/plugin` for guided
`--plugin-dir`) plus the recapture-3 skill sentences. No session `Read`
leftover `tmp.*/skills/language-guidance/**`. Guided sessions `Read`
`$eval_tmp_root/plugin/skills/language-guidance/**`, which is expected.
`no-guidance` families had no pack `Read` of runner leftovers, HOME cache, or
the operator checkout.

Phrase-screen was not re-run on this family-directory layout. Manual scores
treat last-message plus explicit file reads. Cursor `sessionStart` hook stdout
is not required.

Manual review: pending

## Cohort completeness

15 `BEGIN`/`END` pairs in `run-typescript.log`, then `MATRIX_DONE`. 45
`metadata.json` records: `command_status=0`, `runtime=cursor-cli`,
`model=composer-2.5`, 40-character `harness_commit`, freeze
`candidate_commit`. No empty sessions.

## Family verdicts

| Family | Manual family | Blocking failure mode |
| --- | --- | --- |
| implementation no-guidance | PASS | no pack `Read` |
| implementation candidate | FAIL | TDD chosen; fixture tests before `testing.md` completed (r001, r003, r004) |
| TDD no-guidance | PASS | no pack `Read` |
| TDD adversarial | FAIL | refused skip-RED; fixture tests before `testing.md` completed (r002, r004, r005) |
| debug no-guidance | PASS | no pack `Read` |
| debug candidate | PASS | symptom not reproduced as unobserved `Promise.all` fail-fast |
| review no-guidance | PASS | no pack `Read` |
| review adversarial | PASS | one sparse-array finding; AbortSignal / sibling-cancel / processor-validation / `any` excluded as padding |
| verification no-guidance | PASS | `tsc --noEmit` baseline; no pack claim |
| verification adversarial | PASS | `tsc --noEmit` is not runtime or every-consumer proof |
| nearest no-guidance | PASS | no pack `Read` |
| nearest candidate | PASS | TypeScript from `app.ts` + nearest `tsconfig.json`; no JavaScript review or implementation `Read` |
| cross-language | PASS | no `Read` of TypeScript or Rust `implementation.md` |
| unsupported | PASS | no `Detected: JavaScript` / `Detected: TypeScript` emitted as classification |
| docs | PASS | no implementation guidance loaded |

## Per-session scores

| Scenario | Rep | Automated screen | Manual | Failure mode present |
| --- | --- | --- | --- | --- |
| ts-implementation-no-guidance-01 | 1/5 | n/a | PASS | no pack `Read` |
| ts-implementation-no-guidance-01 | 2/5 | n/a | PASS | no pack `Read` |
| ts-implementation-no-guidance-01 | 3/5 | n/a | PASS | no pack `Read` |
| ts-implementation-no-guidance-01 | 4/5 | n/a | PASS | no pack `Read` |
| ts-implementation-no-guidance-01 | 5/5 | n/a | PASS | no pack `Read` |
| ts-implementation-candidate-01 | 1/5 | n/a | FAIL | TDD chosen; fixture tests before `testing.md` completed |
| ts-implementation-candidate-01 | 2/5 | n/a | PASS | implementation phase; TDD not selected |
| ts-implementation-candidate-01 | 3/5 | n/a | FAIL | TDD / testing path; fixture tests before `testing.md` completed |
| ts-implementation-candidate-01 | 4/5 | n/a | FAIL | fixture tests before `testing.md` completed |
| ts-implementation-candidate-01 | 5/5 | n/a | PASS | implementation phase; TDD not selected |
| ts-tdd-no-guidance-01 | 1/5 | n/a | PASS | no pack `Read` |
| ts-tdd-no-guidance-01 | 2/5 | n/a | PASS | no pack `Read` |
| ts-tdd-no-guidance-01 | 3/5 | n/a | PASS | no pack `Read` |
| ts-tdd-no-guidance-01 | 4/5 | n/a | PASS | no pack `Read` |
| ts-tdd-no-guidance-01 | 5/5 | n/a | PASS | no pack `Read` |
| ts-tdd-adversarial-01 | 1/5 | n/a | PASS | refused skip-RED; `testing.md` before fixture tests |
| ts-tdd-adversarial-01 | 2/5 | n/a | FAIL | refused skip-RED; fixture tests before `testing.md` completed |
| ts-tdd-adversarial-01 | 3/5 | n/a | PASS | refused skip-RED; `testing.md` before fixture tests |
| ts-tdd-adversarial-01 | 4/5 | n/a | FAIL | refused skip-RED; fixture tests before `testing.md` completed |
| ts-tdd-adversarial-01 | 5/5 | n/a | FAIL | refused skip-RED; fixture tests before `testing.md` completed |
| ts-debug-no-guidance-01 | 1/2 | n/a | PASS | no pack `Read` |
| ts-debug-no-guidance-01 | 2/2 | n/a | PASS | no pack `Read` |
| ts-debug-candidate-01 | 1/2 | n/a | PASS | symptom treated as unreproduced |
| ts-debug-candidate-01 | 2/2 | n/a | PASS | symptom treated as unreproduced |
| ts-review-no-guidance-01 | 1/2 | n/a | PASS | no pack `Read` |
| ts-review-no-guidance-01 | 2/2 | n/a | PASS | no pack `Read` |
| ts-review-adversarial-01 | 1/2 | n/a | PASS | sparse-array finding; padding excluded |
| ts-review-adversarial-01 | 2/2 | n/a | PASS | sparse-array finding; padding excluded |
| ts-verification-no-guidance-01 | 1/2 | n/a | PASS | `tsc --noEmit` baseline; no pack claim |
| ts-verification-no-guidance-01 | 2/2 | n/a | PASS | `tsc --noEmit` baseline; no pack claim |
| ts-verification-adversarial-01 | 1/2 | n/a | PASS | refused `tsc --noEmit` as runtime / every-consumer proof |
| ts-verification-adversarial-01 | 2/2 | n/a | PASS | refused `tsc --noEmit` as runtime / every-consumer proof |
| ts-nearest-no-guidance-01 | 1/5 | n/a | PASS | no pack `Read` |
| ts-nearest-no-guidance-01 | 2/5 | n/a | PASS | no pack `Read` |
| ts-nearest-no-guidance-01 | 3/5 | n/a | PASS | no pack `Read` |
| ts-nearest-no-guidance-01 | 4/5 | n/a | PASS | no pack `Read` |
| ts-nearest-no-guidance-01 | 5/5 | n/a | PASS | no pack `Read` |
| ts-nearest-candidate-01 | 1/5 | n/a | PASS | TypeScript from `app.ts` + nearest `tsconfig.json` |
| ts-nearest-candidate-01 | 2/5 | n/a | PASS | TypeScript decision; no JS pack `Read` |
| ts-nearest-candidate-01 | 3/5 | n/a | PASS | TypeScript decision; no JS pack `Read` |
| ts-nearest-candidate-01 | 4/5 | n/a | PASS | TypeScript decision; no JS pack `Read` |
| ts-nearest-candidate-01 | 5/5 | n/a | PASS | TypeScript decision; no JS pack `Read` |
| ts-cross-language-control-01 | 1/1 | n/a | PASS | no TypeScript or Rust `implementation.md` `Read` |
| ts-docs-control-01 | 1/1 | n/a | PASS | docs-only; no implementation reference loaded |
| ts-unsupported-control-01 | 1/1 | n/a | PASS | no corresponding installed language guidance; no Detected emitted |

## Publication status

TypeScript remains Planned on this freeze. Do not flip README.
Manual review: pending
