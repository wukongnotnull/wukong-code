# JavaScript language-guidance evaluation (Cursor recapture-6 draft)

Draft, not publication evidence. This freeze used Cursor Agent CLI, not Codex.
Codex artifacts under `artifacts/experimental-publication/`, the first Cursor
freeze under `artifacts/cursor-publication/`, recapture-1 under
`artifacts/cursor-publication-repair/`, recapture-2 under
`artifacts/cursor-publication-repair-2/`, recapture-3 under
`artifacts/cursor-publication-repair-3/`, recapture-4 under
`artifacts/cursor-publication-repair-4/`, and recapture-5 under
`artifacts/cursor-publication-repair-5/` are auxiliary and are not this freeze.

## Methodology and isolation

- Plugin candidate commit: `62f472addda1a3b590d96ad88d5f26b8050566b9`
- Eval harness commit: `39cbbec9d5842edd47ead87fcd6e1fc1399b4287`
- Model: `composer-2.5`
- CLI: `2026.08.11-e8db854`
- Runtime: `cursor-cli`
- Isolated cursor home (Keychain symlink only; not a copy of `~/.cursor`)
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication-repair-6/javascript/`

This freeze used nested eval temps (`$eval_tmp_root/plugin` for guided
`--plugin-dir`), up to three empty-session retries with backoff, and the
recapture-6 skill sentences (after TDD is selected, do not Glob, Grep, or
Read fixture or src in the same turn as `testing.md`; obeying a request to
skip `npm test` is not permission to run `node --check` first). A live
sandbox probe recorded `sandbox_blocks_host_pack_reads=no`. That probe does
not create a scoring exemption. Smoke recorded a no-guidance host-pack Read;
the matrix continued. Host-pack Reads remain FAIL.

No session `Read` leftover `tmp.*/skills/language-guidance/**` (old unpack
layout). Guided sessions `Read` `$eval_tmp_root/plugin/skills/language-guidance/**`,
which is expected. `no-guidance` implementation, TDD, debug, review, and
verification had no pack `Read`. `js-nearest-no-guidance-01` r001 `Read` the
operator checkout `/Users/wukong/Documents/wukong-code/skills/language-guidance/**`.
r002–r005 of that family had no pack `Read`.

Phrase-screen was not re-run on this family-directory layout. Manual scores
treat last-message plus explicit file Reads, Globs, and Greps. Cursor
`sessionStart` hook stdout is not required.

Manual review: pending

## Cohort completeness

14 `BEGIN`/`END` pairs in `run-javascript.log`, then `MATRIX_DONE`. 44
`metadata.json` records: `command_status=0`, `runtime=cursor-cli`,
`model=composer-2.5`, 40-character `harness_commit`, freeze
`candidate_commit`. No empty `events.jsonl`.

## Family verdicts

| Family | Manual family | Blocking failure mode |
| --- | --- | --- |
| implementation no-guidance | PASS | no pack `Read` |
| implementation candidate | FAIL | TDD chosen; fixture Glob/Read before `testing.md` completed (all 5) |
| TDD no-guidance | PASS | refused skip-RED; no pack `Read` |
| TDD adversarial | FAIL | refused skip-RED; fixture Glob before `testing.md` completed (all 5) |
| debug no-guidance | PASS | no pack `Read` |
| debug candidate | PASS | symptom not reproduced; did not name unobserved `Promise.all` fail-fast as the cause |
| review no-guidance | PASS | no pack `Read`; non-empty sessions |
| review adversarial | FAIL | r001 unbounded-concurrency padding; r002 omitted unused AbortSignal / sibling-cancel / processor-validation / unbounded `Promise.all` as padding |
| verification no-guidance | PASS | no pack claim; host syntax check is baseline |
| verification adversarial | PASS | first verification command is `npm test` (both reps) |
| nearest no-guidance | FAIL | r001 `Read` operator checkout `skills/language-guidance/**`; r002–r005 no pack `Read` |
| nearest candidate | PASS | JavaScript from `.mjs` / `javascript-worker`; no TypeScript review or implementation `Read` |
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
| js-implementation-candidate-01 | 1/5 | n/a | FAIL | TDD chosen; fixture Glob before `testing.md` completed |
| js-implementation-candidate-01 | 2/5 | n/a | FAIL | TDD chosen; fixture Glob before `testing.md` completed |
| js-implementation-candidate-01 | 3/5 | n/a | FAIL | TDD chosen; fixture Glob before `testing.md` completed |
| js-implementation-candidate-01 | 4/5 | n/a | FAIL | TDD chosen; fixture Glob before `testing.md` completed |
| js-implementation-candidate-01 | 5/5 | n/a | FAIL | TDD chosen; fixture/src Read before `testing.md` completed |
| js-tdd-no-guidance-01 | 1/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-no-guidance-01 | 2/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-no-guidance-01 | 3/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-no-guidance-01 | 4/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-no-guidance-01 | 5/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-adversarial-01 | 1/5 | n/a | FAIL | refused skip-RED; fixture Glob before `testing.md` completed |
| js-tdd-adversarial-01 | 2/5 | n/a | FAIL | refused skip-RED; fixture Glob before `testing.md` completed |
| js-tdd-adversarial-01 | 3/5 | n/a | FAIL | refused skip-RED; fixture Glob/Read before `testing.md` completed |
| js-tdd-adversarial-01 | 4/5 | n/a | FAIL | refused skip-RED; fixture Glob before `testing.md` completed |
| js-tdd-adversarial-01 | 5/5 | n/a | FAIL | refused skip-RED; fixture Glob before `testing.md` completed |
| js-debug-no-guidance-01 | 1/2 | n/a | PASS | no pack `Read` |
| js-debug-no-guidance-01 | 2/2 | n/a | PASS | no pack `Read` |
| js-debug-candidate-01 | 1/2 | n/a | PASS | symptom treated as unreproduced |
| js-debug-candidate-01 | 2/2 | n/a | PASS | symptom treated as unreproduced |
| js-review-no-guidance-01 | 1/2 | n/a | PASS | no pack `Read` |
| js-review-no-guidance-01 | 2/2 | n/a | PASS | no pack `Read` |
| js-review-adversarial-01 | 1/2 | n/a | FAIL | unbounded concurrency listed as a finding |
| js-review-adversarial-01 | 2/2 | n/a | PASS | unused AbortSignal / sibling-cancel / processor-validation / unbounded `Promise.all` listed as omitted padding |
| js-verification-no-guidance-01 | 1/2 | n/a | PASS | no pack claim; host check is baseline |
| js-verification-no-guidance-01 | 2/2 | n/a | PASS | no pack claim; host check is baseline |
| js-verification-adversarial-01 | 1/2 | n/a | PASS | `npm test` first; refused skip-scripts |
| js-verification-adversarial-01 | 2/2 | n/a | PASS | `npm test` then `node --check`; refused cross-host completeness |
| js-nearest-no-guidance-01 | 1/5 | n/a | FAIL | `Read` operator checkout `javascript/implementation.md` |
| js-nearest-no-guidance-01 | 2/5 | n/a | PASS | no pack `Read` |
| js-nearest-no-guidance-01 | 3/5 | n/a | PASS | no pack `Read` |
| js-nearest-no-guidance-01 | 4/5 | n/a | PASS | no pack `Read` |
| js-nearest-no-guidance-01 | 5/5 | n/a | PASS | no pack `Read` |
| js-nearest-candidate-01 | 1/5 | n/a | PASS | JS from `.mjs` / nearest `package.json`; no TS pack `Read` |
| js-nearest-candidate-01 | 2/5 | n/a | PASS | JS decision; no TS pack `Read` |
| js-nearest-candidate-01 | 3/5 | n/a | PASS | JS decision; no TS pack `Read` |
| js-nearest-candidate-01 | 4/5 | n/a | PASS | JS decision; no TS pack `Read` |
| js-nearest-candidate-01 | 5/5 | n/a | PASS | JS decision; no TS pack `Read` |
| js-unsupported-control-01 | 1/1 | n/a | PASS | no corresponding installed language guidance; no Detected JS/TS emitted |
| js-docs-control-01 | 1/1 | n/a | PASS | docs-only; no implementation reference loaded |

## Publication status

JavaScript remains Planned on this freeze. Do not flip README.
Manual review: pending
