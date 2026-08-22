# TypeScript language-guidance evaluation (Cursor recapture-4 draft)

Draft, not publication evidence. This freeze used Cursor Agent CLI, not Codex.
Codex artifacts under `artifacts/experimental-publication/`, the first Cursor
freeze under `artifacts/cursor-publication/`, recapture-1 under
`artifacts/cursor-publication-repair/`, recapture-2 under
`artifacts/cursor-publication-repair-2/`, and recapture-3 under
`artifacts/cursor-publication-repair-3/` are auxiliary and are not this freeze.

## Methodology and isolation

- Plugin candidate commit: `422980f46116e03f8e4cf2c14b35043e3dbd8b2f`
- Eval harness commit: `5b131f577473ae81ae6db27c6a73e352ce59e6a7`
- Model: `composer-2.5`
- CLI: `2026.08.11-e8db854`
- Runtime: `cursor-cli`
- Isolated cursor home (Keychain symlink only; not a copy of `~/.cursor`)
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication-repair-4/typescript/`

This freeze used nested eval temps (`$eval_tmp_root/plugin` for guided
`--plugin-dir`), up to three empty-session retries with backoff, and the
recapture-4 skill sentences (no other Read in the same turn as `testing.md`;
unbounded `Promise.all` / concurrency-limit review padding; `node --check`
before skipped `npm test` is a verification failure).

No session `Read` leftover `tmp.*/skills/language-guidance/**` (old unpack
layout). Guided sessions `Read` `$eval_tmp_root/plugin/skills/language-guidance/**`,
which is expected. `no-guidance` implementation, TDD, debug, review, and
verification had no pack `Read`. `ts-nearest-no-guidance-01` `Read`
`~/.cursor/plugins/local/wukong-code/skills/language-guidance/**` (the operator
Cursor local-plugin install, not the isolated HOME cache and not a runner
leftover). That is a pack load for no-guidance scoring.

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
| implementation candidate | FAIL | TDD chosen; fixture tests before `testing.md` completed (r001, r004, r005) |
| TDD no-guidance | PASS | refused skip-RED; no pack `Read` |
| TDD adversarial | FAIL | refused skip-RED; all 5 fixture tests before `testing.md` completed |
| debug no-guidance | PASS | no pack `Read` |
| debug candidate | PASS | symptom not reproduced as unobserved `Promise.all` fail-fast |
| review no-guidance | PASS | no pack `Read` |
| review adversarial | PASS | sparse-array finding; AbortSignal / sibling-cancel / processor-validation / `any` / unbounded `Promise.all` not used as padding |
| verification no-guidance | PASS | `tsc --noEmit` baseline; no pack claim |
| verification adversarial | PASS | `tsc --noEmit` is not runtime or every-consumer proof |
| nearest no-guidance | FAIL | `Read` operator local plugin `~/.cursor/plugins/local/wukong-code/skills/language-guidance/**` (all 5); r001/r003 also `java/review.md` |
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
| ts-implementation-candidate-01 | 3/5 | n/a | PASS | implementation phase; TDD not selected |
| ts-implementation-candidate-01 | 4/5 | n/a | FAIL | TDD chosen; fixture tests before `testing.md` completed |
| ts-implementation-candidate-01 | 5/5 | n/a | FAIL | TDD chosen; fixture tests before `testing.md` completed |
| ts-tdd-no-guidance-01 | 1/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-no-guidance-01 | 2/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-no-guidance-01 | 3/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-no-guidance-01 | 4/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-no-guidance-01 | 5/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-adversarial-01 | 1/5 | n/a | FAIL | refused skip-RED; fixture tests before `testing.md` completed |
| ts-tdd-adversarial-01 | 2/5 | n/a | FAIL | refused skip-RED; fixture tests before `testing.md` completed |
| ts-tdd-adversarial-01 | 3/5 | n/a | FAIL | refused skip-RED; fixture tests before `testing.md` completed |
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
| ts-verification-no-guidance-01 | 1/2 | n/a | PASS | no pack claim; `tsc --noEmit` is baseline |
| ts-verification-no-guidance-01 | 2/2 | n/a | PASS | no pack claim; `tsc --noEmit` is baseline |
| ts-verification-adversarial-01 | 1/2 | n/a | PASS | `tsc --noEmit` is not runtime or every-consumer proof |
| ts-verification-adversarial-01 | 2/2 | n/a | PASS | `tsc --noEmit` is not runtime or every-consumer proof |
| ts-nearest-no-guidance-01 | 1/5 | n/a | FAIL | `Read` local plugin `SKILL.md` + `java/review.md` |
| ts-nearest-no-guidance-01 | 2/5 | n/a | FAIL | `Read` local plugin `SKILL.md` |
| ts-nearest-no-guidance-01 | 3/5 | n/a | FAIL | `Read` local plugin `SKILL.md` + `java/review.md` |
| ts-nearest-no-guidance-01 | 4/5 | n/a | FAIL | `Read` local plugin `SKILL.md` |
| ts-nearest-no-guidance-01 | 5/5 | n/a | FAIL | `Read` local plugin `SKILL.md`; claimed TypeScript pack applied |
| ts-nearest-candidate-01 | 1/5 | n/a | PASS | TS from `app.ts` / nearest `tsconfig.json`; no JS pack `Read` |
| ts-nearest-candidate-01 | 2/5 | n/a | PASS | TS review; no JS pack `Read` |
| ts-nearest-candidate-01 | 3/5 | n/a | PASS | TS review; no JS pack `Read` |
| ts-nearest-candidate-01 | 4/5 | n/a | PASS | TS review; no JS pack `Read` |
| ts-nearest-candidate-01 | 5/5 | n/a | PASS | TS review; no JS pack `Read` |
| ts-cross-language-control-01 | 1/1 | n/a | PASS | no TypeScript or Rust `implementation.md` `Read` |
| ts-docs-control-01 | 1/1 | n/a | PASS | docs-only; no implementation reference loaded |
| ts-unsupported-control-01 | 1/1 | n/a | PASS | no corresponding installed language guidance; no Detected JS/TS emitted |

## Publication status

TypeScript remains Planned on this freeze. Do not flip README.
Manual review: pending
