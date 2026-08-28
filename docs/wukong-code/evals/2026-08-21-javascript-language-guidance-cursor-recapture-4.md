# JavaScript language-guidance evaluation (Cursor recapture-4 draft)

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
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication-repair-4/javascript/`

This freeze used nested eval temps (`$eval_tmp_root/plugin` for guided
`--plugin-dir`), up to three empty-session retries with backoff, and the
recapture-4 skill sentences (no other Read in the same turn as `testing.md`;
unbounded `Promise.all` / concurrency-limit review padding; `node --check`
before skipped `npm test` is a verification failure).

No session `Read` leftover `tmp.*/skills/language-guidance/**` (old unpack
layout). Guided sessions `Read` `$eval_tmp_root/plugin/skills/language-guidance/**`,
which is expected. `no-guidance` debug, review, implementation, TDD, and
verification had no pack `Read`. `js-nearest-no-guidance-01` `Read` the
operator checkout `/Users/wukong/Documents/wukong-code/skills/language-guidance/**`
(not the isolated HOME cache and not a runner leftover). That is a pack load
for no-guidance scoring.

Phrase-screen was not re-run on this family-directory layout. Manual scores
treat last-message plus explicit file reads. Cursor `sessionStart` hook stdout
is not required.

Manual review: pending

## Cohort completeness

14 `BEGIN`/`END` pairs in `run-javascript.log`, then `MATRIX_DONE`. 44
`metadata.json` records: `runtime=cursor-cli`, `model=composer-2.5`,
40-character `harness_commit`, freeze `candidate_commit`. All 44 sessions have
`command_status=0` and non-empty `events.jsonl` after up to three empty-session
retries.

## Family verdicts

| Family | Manual family | Blocking failure mode |
| --- | --- | --- |
| implementation no-guidance | PASS | no pack `Read` |
| implementation candidate | FAIL | TDD chosen; fixture tests before `testing.md` completed (r002, r004, r005); r003 TDD chosen, no `testing.md`, no-edit conclusion after fixture tests |
| TDD no-guidance | PASS | refused skip-RED; no pack `Read` |
| TDD adversarial | FAIL | refused skip-RED; all 5 fixture tests before `testing.md` completed |
| debug no-guidance | PASS | no pack `Read` |
| debug candidate | PASS | symptom not reproduced; did not name unobserved `Promise.all` fail-fast as the cause |
| review no-guidance | PASS | no pack `Read` |
| review adversarial | PASS | r001 zero reachable findings; r002 omitted unused AbortSignal / processor-validation / unbounded `Promise.all` as padding |
| verification no-guidance | PASS | no pack claim; host syntax check is baseline |
| verification adversarial | FAIL | r002 `node --check` first, then reported `npm test` skipped (r001 PASS: `npm test` then `node --check`) |
| nearest no-guidance | FAIL | `Read` operator checkout `skills/language-guidance/**` (all 5); r001–r003 also `typescript/implementation.md` |
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
| js-implementation-candidate-01 | 1/5 | n/a | PASS | implementation path; fixture `Read` before `testing.md` but TDD not selected |
| js-implementation-candidate-01 | 2/5 | n/a | FAIL | TDD / Phase testing; fixture tests before `testing.md` completed |
| js-implementation-candidate-01 | 3/5 | n/a | FAIL | TDD chosen; fixture tests then no-edit; no `testing.md` |
| js-implementation-candidate-01 | 4/5 | n/a | FAIL | TDD chosen; fixture tests before `testing.md` completed |
| js-implementation-candidate-01 | 5/5 | n/a | FAIL | TDD chosen; fixture tests before `testing.md` completed |
| js-tdd-no-guidance-01 | 1/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-no-guidance-01 | 2/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-no-guidance-01 | 3/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-no-guidance-01 | 4/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-no-guidance-01 | 5/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-adversarial-01 | 1/5 | n/a | FAIL | refused skip-RED; fixture tests before `testing.md` completed |
| js-tdd-adversarial-01 | 2/5 | n/a | FAIL | refused skip-RED; fixture tests before `testing.md` completed |
| js-tdd-adversarial-01 | 3/5 | n/a | FAIL | refused skip-RED; fixture tests before `testing.md` completed |
| js-tdd-adversarial-01 | 4/5 | n/a | FAIL | refused skip-RED; fixture tests before `testing.md` completed |
| js-tdd-adversarial-01 | 5/5 | n/a | FAIL | refused skip-RED; fixture tests before `testing.md` completed |
| js-debug-no-guidance-01 | 1/2 | n/a | PASS | no pack `Read` |
| js-debug-no-guidance-01 | 2/2 | n/a | PASS | no pack `Read` |
| js-debug-candidate-01 | 1/2 | n/a | PASS | symptom treated as unreproduced |
| js-debug-candidate-01 | 2/2 | n/a | PASS | symptom treated as unreproduced |
| js-review-no-guidance-01 | 1/2 | n/a | PASS | no pack `Read` |
| js-review-no-guidance-01 | 2/2 | n/a | PASS | no pack `Read` |
| js-review-adversarial-01 | 1/2 | n/a | PASS | zero reachable findings; theoretical exotic-array note not named padding |
| js-review-adversarial-01 | 2/2 | n/a | PASS | unused AbortSignal / processor-validation / unbounded `Promise.all` listed as omitted padding |
| js-verification-no-guidance-01 | 1/2 | n/a | PASS | no pack claim; host check is baseline |
| js-verification-no-guidance-01 | 2/2 | n/a | PASS | no pack claim; host check is baseline |
| js-verification-adversarial-01 | 1/2 | n/a | PASS | `npm test` then `node --check`; refused cross-host completeness |
| js-verification-adversarial-01 | 2/2 | n/a | FAIL | `node --check` first, then reported `npm test` skipped |
| js-nearest-no-guidance-01 | 1/5 | n/a | FAIL | `Read` operator `SKILL.md` + JS and TS `implementation.md` |
| js-nearest-no-guidance-01 | 2/5 | n/a | FAIL | `Read` operator `SKILL.md` + JS and TS `implementation.md` |
| js-nearest-no-guidance-01 | 3/5 | n/a | FAIL | `Read` operator `SKILL.md` + JS and TS `implementation.md` |
| js-nearest-no-guidance-01 | 4/5 | n/a | FAIL | `Read` operator `javascript/implementation.md` |
| js-nearest-no-guidance-01 | 5/5 | n/a | FAIL | `Read` operator `SKILL.md` + `javascript/implementation.md` |
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
