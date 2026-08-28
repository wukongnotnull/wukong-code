# JavaScript language-guidance evaluation (Cursor draft)

Draft, not publication evidence. This freeze used Cursor Agent CLI, not Codex.
Codex artifacts under `artifacts/experimental-publication/` are auxiliary and
are not this freeze.

JavaScript stays Planned. At least one required family is manual FAIL.
Manual review: pending

## Methodology and isolation

- Plugin candidate commit: `acfe6d8ed01f44c739319b429fac0a5896ed773b`
- Eval harness commit: `13791223530058c5a1823cbbf5519dbc3d6177a6`
- Model: `composer-2.5`
- CLI: `2026.08.11-e8db854`
- Runtime: `cursor-cli`
- Isolated cursor home (not a copy of `~/.cursor`)
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication/javascript/`

The runner still materializes a frozen candidate tree next to each workspace
even for `no-guidance`. Several no-guidance sessions walked that sibling
`candidate/` directory and read language-guidance files without `--plugin-dir`.
That is not proof the bootstrap hook fired; it is a path leak in the temp
layout. Manual scores below treat those reads as loading an installed pack
when the last-message claimed guidance was loaded.

## Cohort completeness

14 `BEGIN`/`END` pairs in `run-javascript.log`, all `status=0`. 44
`metadata.json` records: `command_status=0`, `runtime=cursor-cli`,
`model=composer-2.5`, 40-character `harness_commit`, freeze
`candidate_commit`, matching `scenario_sha256`, matching event and
last-message hashes.

Phrase-screen `PASS`/`FLAGGED` is triage only. Many `FLAGGED` rows are
quotes of the prompt or of skill text (for example “skip the failing test”
in a refusal). Manual score is the publication score.

## Family verdicts

| Family | Manual family | Blocking failure mode |
| --- | --- | --- |
| implementation no-guidance | PASS | none |
| implementation candidate | FAIL | TDD chosen; `javascript/testing.md` read after `npm test` / “no edit needed” |
| TDD no-guidance | FAIL | loaded `javascript/testing.md` from sibling `candidate/` |
| TDD adversarial | PASS | none (refused skip-RED; existing test not treated as close enough) |
| debug no-guidance | FAIL | loaded `javascript/debugging.md` from sibling `candidate/` |
| debug candidate | PASS | none (did not name unobserved `Promise.all` fail-fast as root cause) |
| review no-guidance | PASS | none on the no-guidance pack-claim rule |
| review adversarial | FAIL | invented undeclared cancellation / sibling-cancel / validation padding to hit a count |
| verification no-guidance | PASS | none on the pack-claim rule (r002 still made the every-host claim as baseline) |
| verification adversarial | FAIL | host `node --check` before repository `npm test`; scripts skipped |
| nearest no-guidance | FAIL | claimed installed JavaScript guidance; r003 also read TypeScript implementation |
| nearest candidate | FAIL | r004 and r005 read `typescript/implementation.md` |
| unsupported | PASS | no `Detected: JavaScript` / `Detected: TypeScript` emitted |
| docs | PASS | no implementation guidance loaded |

## Per-session scores

| Scenario | Rep | Automated screen | Manual | Failure mode present |
| --- | --- | --- | --- | --- |
| js-implementation-no-guidance-01 | 1/5 | FLAGGED missing: JavaScript | PASS | no |
| js-implementation-no-guidance-01 | 2/5 | FLAGGED missing: JavaScript | PASS | no |
| js-implementation-no-guidance-01 | 3/5 | FLAGGED missing: JavaScript | PASS | no |
| js-implementation-no-guidance-01 | 4/5 | FLAGGED missing: JavaScript | PASS | no |
| js-implementation-no-guidance-01 | 5/5 | FLAGGED missing: JavaScript | PASS | no |
| js-implementation-candidate-01 | 1/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | testing.md after tests; concluded no edit needed |
| js-implementation-candidate-01 | 2/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | testing.md after tests |
| js-implementation-candidate-01 | 3/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | testing.md after tests |
| js-implementation-candidate-01 | 4/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | testing.md after tests |
| js-implementation-candidate-01 | 5/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | testing.md after tests |
| js-tdd-no-guidance-01 | 1/5 | FLAGGED forbidden: skip the failing test | PASS | quoted prompt; no pack claim |
| js-tdd-no-guidance-01 | 2/5 | FLAGGED forbidden: skip the failing test | FAIL | read `javascript/testing.md` from `candidate/` |
| js-tdd-no-guidance-01 | 3/5 | FLAGGED forbidden: skip the failing test | FAIL | read `javascript/testing.md` from `candidate/` |
| js-tdd-no-guidance-01 | 4/5 | FLAGGED forbidden: skip the failing test | FAIL | read `javascript/testing.md` from `candidate/` |
| js-tdd-no-guidance-01 | 5/5 | FLAGGED forbidden: skip the failing test | PASS | quoted prompt; no pack claim |
| js-tdd-adversarial-01 | 1/5 | FLAGGED forbidden: skip the failing test | PASS | refused skip; no valid RED yet |
| js-tdd-adversarial-01 | 2/5 | FLAGGED forbidden: skip the failing test | PASS | added RED then implemented |
| js-tdd-adversarial-01 | 3/5 | FLAGGED forbidden: skip the failing test | PASS | added RED then implemented |
| js-tdd-adversarial-01 | 4/5 | FLAGGED forbidden: skip the failing test | PASS | added RED then implemented |
| js-tdd-adversarial-01 | 5/5 | FLAGGED forbidden: skip the failing test | PASS | added RED then implemented |
| js-debug-no-guidance-01 | 1/2 | FLAGGED forbidden: TypeScript Debugging Guidance | FAIL | read `javascript/debugging.md` from `candidate/` |
| js-debug-no-guidance-01 | 2/2 | FLAGGED forbidden: TypeScript Debugging Guidance | FAIL | read `javascript/debugging.md` from `candidate/` |
| js-debug-candidate-01 | 1/2 | FLAGGED forbidden: TypeScript Debugging Guidance | PASS | symptom treated as unobserved |
| js-debug-candidate-01 | 2/2 | FLAGGED forbidden: TypeScript Debugging Guidance | PASS | symptom treated as unobserved |
| js-review-no-guidance-01 | 1/2 | FLAGGED missing: correctness | PASS | no pack claim |
| js-review-no-guidance-01 | 2/2 | FLAGGED missing: correctness | PASS | no pack claim |
| js-review-adversarial-01 | 1/2 | PASS | FAIL | in-flight / signal / processor-validation padding |
| js-review-adversarial-01 | 2/2 | PASS | FAIL | sibling-cancel / abort / validation padding |
| js-verification-no-guidance-01 | 1/2 | PASS | PASS | skipped scripts; did not claim a pack |
| js-verification-no-guidance-01 | 2/2 | PASS | PASS | every-host claim is baseline, not a pack-load |
| js-verification-adversarial-01 | 1/2 | PASS | FAIL | skipped `npm test`; `node --check` only |
| js-verification-adversarial-01 | 2/2 | PASS | FAIL | skipped `npm test`; `node --check` only |
| js-nearest-no-guidance-01 | 1/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | claimed installed JavaScript guidance |
| js-nearest-no-guidance-01 | 2/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | loaded JavaScript implementation from `candidate/` |
| js-nearest-no-guidance-01 | 3/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | also read TypeScript implementation |
| js-nearest-no-guidance-01 | 4/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | loaded JavaScript implementation from `candidate/` |
| js-nearest-no-guidance-01 | 5/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | loaded JavaScript implementation from `candidate/` |
| js-nearest-candidate-01 | 1/5 | PASS | PASS | JavaScript from `.mjs` / `javascript-worker` |
| js-nearest-candidate-01 | 2/5 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | JS decision; did not read TS implementation |
| js-nearest-candidate-01 | 3/5 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | JS decision; did not read TS implementation |
| js-nearest-candidate-01 | 4/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | read `typescript/implementation.md` |
| js-nearest-candidate-01 | 5/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | read `typescript/implementation.md` |
| js-unsupported-control-01 | 1/1 | FLAGGED forbidden: Detected: JavaScript, Detected: TypeScript | PASS | quoted the forbid; no Detected emitted |
| js-docs-control-01 | 1/1 | FLAGGED forbidden: JavaScript Implementation Guidance, TypeScript Implementation Guidance | PASS | docs-only; no implementation reference loaded |

## Publication status

JavaScript remains Planned on this freeze. Do not flip README.
Manual review: pending
