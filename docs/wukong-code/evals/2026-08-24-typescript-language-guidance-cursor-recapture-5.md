# TypeScript language-guidance evaluation (Cursor recapture-5 draft)

Draft, not publication evidence. This freeze used Cursor Agent CLI, not Codex.
Codex artifacts under `artifacts/experimental-publication/`, the first Cursor
freeze under `artifacts/cursor-publication/`, recapture-1 under
`artifacts/cursor-publication-repair/`, recapture-2 under
`artifacts/cursor-publication-repair-2/`, recapture-3 under
`artifacts/cursor-publication-repair-3/`, and recapture-4 under
`artifacts/cursor-publication-repair-4/` are auxiliary and are not this freeze.

## Methodology and isolation

- Plugin candidate commit: `66d70865a18d193508631036ee3541c2ecb9661a`
- Eval harness commit: `39cbbec9d5842edd47ead87fcd6e1fc1399b4287`
- Model: `composer-2.5`
- CLI: `2026.08.11-e8db854`
- Runtime: `cursor-cli`
- Isolated cursor home (Keychain symlink only; not a copy of `~/.cursor`)
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication-repair-5/typescript/`

This freeze used nested eval temps (`$eval_tmp_root/plugin` for guided
`--plugin-dir`), up to three empty-session retries with backoff, and the
recapture-5 skill sentences (after TDD is selected, the first Read must be
`testing.md`; the first verification command must be the repository test
script). A live sandbox probe recorded
`sandbox_blocks_host_pack_reads=no`. That probe does not create a scoring
exemption.

No session `Read` leftover `tmp.*/skills/language-guidance/**` (old unpack
layout). Guided sessions `Read` `$eval_tmp_root/plugin/skills/language-guidance/**`,
which is expected. `no-guidance` implementation, TDD, debug, review,
verification, and nearest had no pack `Read`. That last family is a change
from recapture-4, where `ts-nearest-no-guidance-01` `Read`
`~/.cursor/plugins/local/wukong-code/skills/language-guidance/**`.

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
| implementation candidate | FAIL | TDD chosen; fixture/src before `testing.md` completed (r002, r004). r001/r003/r005 implementation path |
| TDD no-guidance | PASS | refused skip-RED; no pack `Read` |
| TDD adversarial | FAIL | refused skip-RED; r001/r002/r004/r005 fixture/src before `testing.md` (r003 `testing.md` first) |
| debug no-guidance | PASS | no pack `Read` |
| debug candidate | PASS | symptom not reproduced as unobserved `Promise.all` fail-fast |
| review no-guidance | PASS | no pack `Read` |
| review adversarial | PASS | sparse-array finding; AbortSignal / sibling-cancel / processor-validation / `any` / unbounded `Promise.all` not used as padding |
| verification no-guidance | PASS | `tsc --noEmit` baseline; no pack claim |
| verification adversarial | PASS | `tsc --noEmit` is not runtime or every-consumer proof |
| nearest no-guidance | PASS | no pack `Read` (all 5) |
| nearest candidate | PASS | TypeScript from `app.ts` + nearest `tsconfig.json`; no JavaScript review or implementation `Read` |
| cross-language | FAIL | `Read` TypeScript and Rust `implementation.md`, then stated packs were not loaded |
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
| ts-implementation-candidate-01 | 1/5 | n/a | PASS | implementation path; TDD not selected |
| ts-implementation-candidate-01 | 2/5 | n/a | FAIL | TDD loaded; fixture/src before `testing.md` completed |
| ts-implementation-candidate-01 | 3/5 | n/a | PASS | implementation path; TDD not selected |
| ts-implementation-candidate-01 | 4/5 | n/a | FAIL | TDD chosen; fixture/src before `testing.md` completed |
| ts-implementation-candidate-01 | 5/5 | n/a | PASS | implementation path; TDD not selected |
| ts-tdd-no-guidance-01 | 1/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-no-guidance-01 | 2/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-no-guidance-01 | 3/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-no-guidance-01 | 4/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-no-guidance-01 | 5/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-adversarial-01 | 1/5 | n/a | FAIL | refused skip-RED; fixture/src before `testing.md` completed |
| ts-tdd-adversarial-01 | 2/5 | n/a | FAIL | refused skip-RED; fixture/src before `testing.md` completed |
| ts-tdd-adversarial-01 | 3/5 | n/a | PASS | refused skip-RED; `testing.md` first |
| ts-tdd-adversarial-01 | 4/5 | n/a | FAIL | refused skip-RED; fixture/src before `testing.md` completed |
| ts-tdd-adversarial-01 | 5/5 | n/a | FAIL | refused skip-RED; fixture/src before `testing.md` completed |
| ts-debug-no-guidance-01 | 1/2 | n/a | PASS | no pack `Read` |
| ts-debug-no-guidance-01 | 2/2 | n/a | PASS | no pack `Read` |
| ts-debug-candidate-01 | 1/2 | n/a | PASS | symptom treated as unreproduced |
| ts-debug-candidate-01 | 2/2 | n/a | PASS | symptom treated as unreproduced |
| ts-review-no-guidance-01 | 1/2 | n/a | PASS | no pack `Read` |
| ts-review-no-guidance-01 | 2/2 | n/a | PASS | no pack `Read` |
| ts-review-adversarial-01 | 1/2 | n/a | PASS | sparse-array finding; padding excluded |
| ts-review-adversarial-01 | 2/2 | n/a | PASS | sparse-array finding; padding excluded |
| ts-verification-no-guidance-01 | 1/2 | n/a | PASS | no pack claim; `tsc --noEmit` is baseline |
| ts-verification-no-guidance-01 | 2/2 | n/a | PASS | no pack claim; `tsc --noEmit` is baseline |
| ts-verification-adversarial-01 | 1/2 | n/a | PASS | `tsc --noEmit` is not runtime or every-consumer proof |
| ts-verification-adversarial-01 | 2/2 | n/a | PASS | `tsc --noEmit` is not runtime or every-consumer proof |
| ts-nearest-no-guidance-01 | 1/5 | n/a | PASS | no pack `Read` |
| ts-nearest-no-guidance-01 | 2/5 | n/a | PASS | no pack `Read` |
| ts-nearest-no-guidance-01 | 3/5 | n/a | PASS | no pack `Read` |
| ts-nearest-no-guidance-01 | 4/5 | n/a | PASS | no pack `Read` |
| ts-nearest-no-guidance-01 | 5/5 | n/a | PASS | no pack `Read` |
| ts-nearest-candidate-01 | 1/5 | n/a | PASS | TS from `app.ts` / nearest `tsconfig.json`; no JS pack `Read` |
| ts-nearest-candidate-01 | 2/5 | n/a | PASS | TS review; no JS pack `Read` |
| ts-nearest-candidate-01 | 3/5 | n/a | PASS | TS review; no JS pack `Read` |
| ts-nearest-candidate-01 | 4/5 | n/a | PASS | TS review; no JS pack `Read` |
| ts-nearest-candidate-01 | 5/5 | n/a | PASS | TS review; no JS pack `Read` |
| ts-cross-language-control-01 | 1/1 | n/a | FAIL | `Read` TypeScript and Rust `implementation.md` |
| ts-docs-control-01 | 1/1 | n/a | PASS | docs-only; no implementation reference loaded |
| ts-unsupported-control-01 | 1/1 | n/a | PASS | no corresponding installed language guidance; no Detected JS/TS emitted |

## Publication status

TypeScript remains Planned on this freeze. Do not flip README.
Manual review: pending
