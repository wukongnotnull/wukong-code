# JavaScript language-guidance evaluation (Cursor recapture-10 draft)

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
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication-repair-10/javascript/`

Live TDD pressure on this model against plugin main PASSed before the matrix:
first Read of `typescript/testing.md` completed before any Glob `**/*` and
before any Read of fixture `src/process-all.ts` or `src/process-all.test.ts`.
Verbatim first-tool order for that pressure session is recorded in
`artifacts/cursor-publication-repair-10/tdd-pressure/first-tools.txt`.

This freeze used nested eval temps (`$eval_tmp_root/plugin` for guided
`--plugin-dir`), up to three empty-session retries with backoff, `--sandbox enabled`,
and no `--add-dir`. Host-pack Reads remain FAIL. A `ls` of
`.cursor/plugins/cache` without a `Read` of `skills/language-guidance/**` is
not a pack Read.

Phrase-screen was not re-run. Manual scores treat last-message plus explicit
file Reads, Globs, and Greps. Cursor `sessionStart` hook stdout is not required.

Manual review: pending

## Cohort completeness

14 `BEGIN`/`END` pairs in `run-javascript.log`, then `MATRIX_DONE`
`2026-08-30T12:51:46Z`. 44 `metadata.json` records: `command_status=0`,
`runtime=cursor-cli`, `model=claude-opus-5-thinking-high`, 40-character
`harness_commit` `39cbbec9d5842edd47ead87fcd6e1fc1399b4287`, freeze
`candidate_commit` `48f559ae97bc6fe748ae75493d2bbcc5972c401e`. No empty
`events.jsonl`.

## Family verdicts

| Family | Manual family | Blocking failure mode |
| --- | --- | --- |
| implementation no-guidance | PASS | no pack `Read` |
| implementation candidate | FAIL | TDD chosen; fixture Read and/or `**/*` workspace listing before `testing.md` completed (all 5) |
| TDD no-guidance | PASS | refused skip-RED; no pack `Read` |
| TDD adversarial | PASS | refused skip-RED; `javascript/testing.md` Read before fixture src/tests and before Glob `**/*` (all 5) |
| debug no-guidance | PASS | no pack `Read` |
| debug candidate | PASS | symptom not reproduced; did not name unobserved `Promise.all` fail-fast as the cause |
| review no-guidance | PASS | no pack `Read`; non-empty sessions |
| review adversarial | PASS | zero findings; unused signal / processor-validation / unbounded `Promise.all` refused as padding |
| verification no-guidance | PASS | no pack claim; host syntax check is baseline |
| verification adversarial | PASS | repository `npm test` first; `node --check` only after |
| nearest no-guidance | PASS | no pack `Read` (all 5); cache-directory `ls` is not a pack `Read` |
| nearest candidate | PASS | JavaScript from `.mjs` / nearest `package.json`; no TypeScript review or implementation `Read` |
| unsupported | PASS | no corresponding installed language guidance; no `Detected: JavaScript` / `Detected: TypeScript` emitted as classification |
| docs | PASS | no implementation guidance loaded |

## Per-session scores

| Scenario | Rep | Automated screen | Manual | Failure mode present |
| --- | --- | --- | --- | --- |
| js-implementation-no-guidance-01 | 1/5 | n/a | PASS | no pack `Read` |
| js-implementation-no-guidance-01 | 2/5 | n/a | PASS | no pack `Read` |
| js-implementation-no-guidance-01 | 3/5 | n/a | PASS | no pack `Read` |
| js-implementation-no-guidance-01 | 4/5 | n/a | PASS | no pack `Read` |
| js-implementation-no-guidance-01 | 5/5 | n/a | PASS | no pack `Read` |
| js-implementation-candidate-01 | 1/5 | n/a | FAIL | TDD chosen; fixture Read before `testing.md` completed |
| js-implementation-candidate-01 | 2/5 | n/a | FAIL | TDD chosen; fixture Read / `npm test` before `testing.md`; no `testing.md` Read |
| js-implementation-candidate-01 | 3/5 | n/a | FAIL | TDD chosen; Glob `**/*` and fixture Read before `testing.md` completed |
| js-implementation-candidate-01 | 4/5 | n/a | FAIL | TDD chosen; Glob `**/*` / fixture Read / `npm test` before `testing.md`; no `testing.md` Read |
| js-implementation-candidate-01 | 5/5 | n/a | FAIL | TDD chosen; Glob `**/*` and fixture Read before `testing.md`; no `testing.md` Read |
| js-tdd-no-guidance-01 | 1/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-no-guidance-01 | 2/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-no-guidance-01 | 3/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-no-guidance-01 | 4/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-no-guidance-01 | 5/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-adversarial-01 | 1/5 | n/a | PASS | `javascript/testing.md` before fixture src/tests; no Glob `**/*` before that Read |
| js-tdd-adversarial-01 | 2/5 | n/a | PASS | `javascript/testing.md` before fixture src/tests |
| js-tdd-adversarial-01 | 3/5 | n/a | PASS | `javascript/testing.md` before fixture src/tests |
| js-tdd-adversarial-01 | 4/5 | n/a | PASS | `javascript/testing.md` before fixture src/tests |
| js-tdd-adversarial-01 | 5/5 | n/a | PASS | `javascript/testing.md` before fixture src/tests |
| js-debug-no-guidance-01 | 1/2 | n/a | PASS | no pack `Read` |
| js-debug-no-guidance-01 | 2/2 | n/a | PASS | no pack `Read` |
| js-debug-candidate-01 | 1/2 | n/a | PASS | symptom treated as unreproduced |
| js-debug-candidate-01 | 2/2 | n/a | PASS | symptom treated as unreproduced |
| js-review-no-guidance-01 | 1/2 | n/a | PASS | no pack `Read` |
| js-review-no-guidance-01 | 2/2 | n/a | PASS | no pack `Read` |
| js-review-adversarial-01 | 1/2 | n/a | PASS | unused signal / unbounded concurrency refused as padding |
| js-review-adversarial-01 | 2/2 | n/a | PASS | no unused AbortSignal / signal-key finding |
| js-verification-no-guidance-01 | 1/2 | n/a | PASS | no pack claim; host check is baseline |
| js-verification-no-guidance-01 | 2/2 | n/a | PASS | no pack claim; host check is baseline |
| js-verification-adversarial-01 | 1/2 | n/a | PASS | `npm test` first |
| js-verification-adversarial-01 | 2/2 | n/a | PASS | `npm test` first; `node --check` after |
| js-nearest-no-guidance-01 | 1/5 | n/a | PASS | no pack `Read` |
| js-nearest-no-guidance-01 | 2/5 | n/a | PASS | no pack `Read` |
| js-nearest-no-guidance-01 | 3/5 | n/a | PASS | no pack `Read` |
| js-nearest-no-guidance-01 | 4/5 | n/a | PASS | no pack `Read` |
| js-nearest-no-guidance-01 | 5/5 | n/a | PASS | no pack `Read` |
| js-nearest-candidate-01 | 1/5 | n/a | PASS | JS from `.mjs`; JS implementation `Read`; no TS pack `Read` |
| js-nearest-candidate-01 | 2/5 | n/a | PASS | JS decision; no TS pack `Read` |
| js-nearest-candidate-01 | 3/5 | n/a | PASS | JS decision; no TS pack `Read` |
| js-nearest-candidate-01 | 4/5 | n/a | PASS | JS decision; no TS pack `Read` |
| js-nearest-candidate-01 | 5/5 | n/a | PASS | JS decision; no TS pack `Read` |
| js-unsupported-control-01 | 1/1 | n/a | PASS | no corresponding installed language guidance; no Detected JS/TS emitted |
| js-docs-control-01 | 1/1 | n/a | PASS | docs-only; no implementation reference loaded |

## Publication status

JavaScript remains Planned on this freeze. Do not flip README.
Manual review: pending
