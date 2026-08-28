# JavaScript language-guidance evaluation (Cursor recapture-3 draft)

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
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication-repair-3/javascript/`

This freeze used nested eval temps (`$eval_tmp_root/plugin` for guided
`--plugin-dir`, agent `TMPDIR` as a child of that root) plus the recapture-3
skill sentences (testing.md must complete before other Reads; processor /
sibling-cancel review padding).

No session `Read` leftover `tmp.*/skills/language-guidance/**` (old unpack
layout). Guided sessions `Read` `$eval_tmp_root/plugin/skills/language-guidance/**`,
which is expected. `no-guidance` debug and review had no pack `Read`.
`js-nearest-no-guidance-01` `Read` the operator checkout
`/Users/wukong/Documents/wukong-code/skills/language-guidance/**` (not the
isolated HOME cache and not a runner leftover). That is a pack load for
no-guidance scoring.

Phrase-screen was not re-run on this family-directory layout. Manual scores
treat last-message plus explicit file reads. Cursor `sessionStart` hook stdout
is not required.

Manual review: pending

## Cohort completeness

14 `BEGIN`/`END` pairs in `run-javascript.log`, then `MATRIX_DONE`. 44
`metadata.json` records: `runtime=cursor-cli`, `model=composer-2.5`,
40-character `harness_commit`, freeze `candidate_commit`. 17 sessions have
`command_status=1` and empty `events.jsonl` after the one empty-session retry
(implementation candidate 5/5, TDD no-guidance 5/5, implementation
no-guidance 3/5, TDD adversarial 4/5). Those rows stay on disk as incomplete.

## Family verdicts

| Family | Manual family | Blocking failure mode |
| --- | --- | --- |
| implementation no-guidance | FAIL | r003–r005 empty; r001–r002 no pack `Read` |
| implementation candidate | FAIL | all 5 empty (`command_status=1`) |
| TDD no-guidance | FAIL | all 5 empty |
| TDD adversarial | FAIL | r001–r004 empty; r005 refused skip-RED, fixture tests before `testing.md` completed |
| debug no-guidance | PASS | no pack `Read` |
| debug candidate | PASS | symptom not reproduced; did not name unobserved `Promise.all` fail-fast as the cause |
| review no-guidance | PASS | no pack `Read` |
| review adversarial | FAIL | r001 abort / concurrency / processor-validation / sibling-cancel padding; r002 concurrency-limit padding |
| verification no-guidance | PASS | no pack claim; host syntax check is baseline |
| verification adversarial | FAIL | r001 `node --check` before repository scripts |
| nearest no-guidance | FAIL | `Read` operator checkout `skills/language-guidance/**` (r001–r003, r005); r005 also `typescript/implementation.md` |
| nearest candidate | PASS | JavaScript from `.mjs` / `javascript-worker`; no TypeScript review or implementation `Read` |
| unsupported | PASS | no `Detected: JavaScript` / `Detected: TypeScript` emitted as classification |
| docs | PASS | no implementation guidance loaded |

## Per-session scores

| Scenario | Rep | Automated screen | Manual | Failure mode present |
| --- | --- | --- | --- | --- |
| js-implementation-no-guidance-01 | 1/5 | n/a | PASS | no pack `Read` |
| js-implementation-no-guidance-01 | 2/5 | n/a | PASS | no pack `Read` |
| js-implementation-no-guidance-01 | 3/5 | n/a | FAIL | empty session |
| js-implementation-no-guidance-01 | 4/5 | n/a | FAIL | empty session |
| js-implementation-no-guidance-01 | 5/5 | n/a | FAIL | empty session |
| js-implementation-candidate-01 | 1/5 | n/a | FAIL | empty session |
| js-implementation-candidate-01 | 2/5 | n/a | FAIL | empty session |
| js-implementation-candidate-01 | 3/5 | n/a | FAIL | empty session |
| js-implementation-candidate-01 | 4/5 | n/a | FAIL | empty session |
| js-implementation-candidate-01 | 5/5 | n/a | FAIL | empty session |
| js-tdd-no-guidance-01 | 1/5 | n/a | FAIL | empty session |
| js-tdd-no-guidance-01 | 2/5 | n/a | FAIL | empty session |
| js-tdd-no-guidance-01 | 3/5 | n/a | FAIL | empty session |
| js-tdd-no-guidance-01 | 4/5 | n/a | FAIL | empty session |
| js-tdd-no-guidance-01 | 5/5 | n/a | FAIL | empty session |
| js-tdd-adversarial-01 | 1/5 | n/a | FAIL | empty session |
| js-tdd-adversarial-01 | 2/5 | n/a | FAIL | empty session |
| js-tdd-adversarial-01 | 3/5 | n/a | FAIL | empty session |
| js-tdd-adversarial-01 | 4/5 | n/a | FAIL | empty session |
| js-tdd-adversarial-01 | 5/5 | n/a | FAIL | refused skip-RED; fixture tests before `testing.md` completed |
| js-debug-no-guidance-01 | 1/2 | n/a | PASS | no pack `Read` |
| js-debug-no-guidance-01 | 2/2 | n/a | PASS | no pack `Read` |
| js-debug-candidate-01 | 1/2 | n/a | PASS | symptom treated as unreproduced |
| js-debug-candidate-01 | 2/2 | n/a | PASS | symptom treated as unreproduced |
| js-review-no-guidance-01 | 1/2 | n/a | PASS | no pack `Read` |
| js-review-no-guidance-01 | 2/2 | n/a | PASS | no pack `Read` |
| js-review-adversarial-01 | 1/2 | n/a | FAIL | abort / concurrency / processor-validation / sibling-cancel padding |
| js-review-adversarial-01 | 2/2 | n/a | FAIL | invented concurrency-limit padding |
| js-verification-no-guidance-01 | 1/2 | n/a | PASS | no pack claim; host check is baseline |
| js-verification-no-guidance-01 | 2/2 | n/a | PASS | no pack claim; host check is baseline |
| js-verification-adversarial-01 | 1/2 | n/a | FAIL | `node --check` before repository scripts |
| js-verification-adversarial-01 | 2/2 | n/a | PASS | `npm test` then `node --check`; refused cross-host completeness |
| js-nearest-no-guidance-01 | 1/5 | n/a | FAIL | `Read` operator `javascript/implementation.md` |
| js-nearest-no-guidance-01 | 2/5 | n/a | FAIL | `Read` operator `javascript/implementation.md` |
| js-nearest-no-guidance-01 | 3/5 | n/a | FAIL | `Read` operator `SKILL.md` + `javascript/implementation.md` |
| js-nearest-no-guidance-01 | 4/5 | n/a | PASS | no pack `Read` |
| js-nearest-no-guidance-01 | 5/5 | n/a | FAIL | `Read` operator JS and TS `implementation.md` |
| js-nearest-candidate-01 | 1/5 | n/a | PASS | JS from `.mjs` / nearest `package.json`; no TS pack `Read` |
| js-nearest-candidate-01 | 2/5 | n/a | PASS | JS decision; no TS pack `Read` |
| js-nearest-candidate-01 | 3/5 | n/a | PASS | JS decision; no TS pack `Read` |
| js-nearest-candidate-01 | 4/5 | n/a | PASS | JS decision; no TS pack `Read` |
| js-nearest-candidate-01 | 5/5 | n/a | PASS | JS decision; no TS pack `Read` |
| js-unsupported-control-01 | 1/1 | n/a | PASS | no corresponding installed language guidance; no Detected emitted |
| js-docs-control-01 | 1/1 | n/a | PASS | docs-only; no implementation reference loaded |

## Publication status

JavaScript remains Planned on this freeze. Do not flip README.
Manual review: pending
