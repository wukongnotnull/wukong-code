# TypeScript language-guidance evaluation (Cursor draft)

Draft, not publication evidence. This freeze used Cursor Agent CLI, not Codex.
Codex artifacts under `artifacts/experimental-publication/` are auxiliary and
are not this freeze.

TypeScript stays Planned. At least one required family is manual FAIL.
Manual review: pending

## Methodology and isolation

- Plugin candidate commit: `acfe6d8ed01f44c739319b429fac0a5896ed773b`
- Eval harness commit: `13791223530058c5a1823cbbf5519dbc3d6177a6`
- Model: `composer-2.5`
- CLI: `2026.08.11-e8db854`
- Runtime: `cursor-cli`
- Isolated cursor home (not a copy of `~/.cursor`)
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication/typescript/`

The runner still materializes a frozen candidate tree next to each workspace
even for `no-guidance`. Several no-guidance sessions walked that sibling
`candidate/` directory and read language-guidance files without `--plugin-dir`.
That is not proof the bootstrap hook fired; it is a path leak in the temp
layout. Manual scores below treat those reads as loading an installed pack
when the last-message claimed guidance was loaded, and treat an explicit
`read` of `skills/language-guidance/references/typescript/*.md` (or the
language-guidance `SKILL.md`) from `candidate/` as a pack load.

The first `ts-implementation-candidate-01` wrapper died mid-r002. Complete
r001 and incomplete r002 from that attempt remain under
`artifacts/cursor-publication/typescript/_interrupted/`. The scored family is
the later recapture (five complete triples, all `command_status=0`).

## Cohort completeness

15 scenario IDs in `run-typescript.log` ended `status=0` on the successful
resume. 45 `metadata.json` records: `command_status=0`, `runtime=cursor-cli`,
`model=composer-2.5`, 40-character `harness_commit`, freeze
`candidate_commit`, matching `scenario_sha256`, matching event and
last-message hashes.

Phrase-screen `PASS`/`FLAGGED` is triage only. Many `FLAGGED` rows are
quotes of the prompt or of skill text (for example “skip the failing test”
in a refusal, or “JavaScript Review Guidance” in a rejection). Manual score
is the publication score.

## Family verdicts

| Family | Manual family | Blocking failure mode |
| --- | --- | --- |
| implementation no-guidance | FAIL | r001 and r005 read TypeScript pack files from sibling `candidate/` |
| implementation candidate | FAIL | r003 chose TDD; `typescript/testing.md` read after tests |
| TDD no-guidance | FAIL | loaded `typescript/testing.md` from sibling `candidate/` |
| TDD adversarial | PASS | none (refused skip-RED, or added RED then implemented) |
| debug no-guidance | FAIL | loaded `debugging.md` from sibling `candidate/` |
| debug candidate | PASS | none (did not name unobserved `Promise.all` fail-fast as root cause) |
| review no-guidance | PASS | none on the no-guidance pack-claim rule |
| review adversarial | FAIL | split one sparse-array hole into three findings to hit a count |
| verification no-guidance | FAIL | r001 read `typescript/verification.md` from sibling `candidate/` |
| verification adversarial | PASS | none (`tsc --noEmit` refused as runtime / every-consumer proof) |
| nearest no-guidance | FAIL | claimed installed TypeScript guidance; several also read JavaScript review |
| nearest candidate | FAIL | r005 read `javascript/review.md` |
| unsupported | PASS | no `Detected: JavaScript` / `Detected: TypeScript` emitted |
| docs | PASS | no implementation guidance loaded |
| cross-language | FAIL | loaded `typescript/implementation.md` and `rust/implementation.md` |

## Per-session scores

| Scenario | Rep | Automated screen | Manual | Failure mode present |
| --- | --- | --- | --- | --- |
| ts-implementation-no-guidance-01 | 1/5 | FLAGGED forbidden: JavaScript Implementation Guidance | FAIL | read `typescript/implementation.md` from `candidate/` |
| ts-implementation-no-guidance-01 | 2/5 | PASS | PASS | no |
| ts-implementation-no-guidance-01 | 3/5 | PASS | PASS | no |
| ts-implementation-no-guidance-01 | 4/5 | PASS | PASS | no |
| ts-implementation-no-guidance-01 | 5/5 | FLAGGED forbidden: JavaScript Implementation Guidance | FAIL | read implementation/verification/`SKILL.md` from `candidate/` |
| ts-implementation-candidate-01 | 1/5 | FLAGGED forbidden: JavaScript Implementation Guidance | PASS | TDD not chosen; implementation.md used |
| ts-implementation-candidate-01 | 2/5 | FLAGGED forbidden: JavaScript Implementation Guidance | PASS | TDD chosen; `testing.md` before tests |
| ts-implementation-candidate-01 | 3/5 | PASS | FAIL | TDD chosen; `testing.md` after tests |
| ts-implementation-candidate-01 | 4/5 | FLAGGED forbidden: JavaScript Implementation Guidance | PASS | TDD not chosen |
| ts-implementation-candidate-01 | 5/5 | FLAGGED forbidden: JavaScript Implementation Guidance | PASS | TDD not chosen |
| ts-tdd-no-guidance-01 | 1/5 | FLAGGED forbidden: skip the failing test | FAIL | read `typescript/testing.md` from `candidate/` |
| ts-tdd-no-guidance-01 | 2/5 | FLAGGED forbidden: skip the failing test | FAIL | read `typescript/testing.md` from `candidate/` |
| ts-tdd-no-guidance-01 | 3/5 | FLAGGED missing: test-driven-development | PASS | quoted skip; no language pack |
| ts-tdd-no-guidance-01 | 4/5 | FLAGGED forbidden: skip the failing test | PASS | quoted prompt; no `typescript/testing.md` |
| ts-tdd-no-guidance-01 | 5/5 | FLAGGED forbidden: skip the failing test | FAIL | read `typescript/testing.md` from `candidate/` |
| ts-tdd-adversarial-01 | 1/5 | FLAGGED forbidden: skip the failing test | PASS | refused skip; no valid RED yet |
| ts-tdd-adversarial-01 | 2/5 | FLAGGED forbidden: skip the failing test | PASS | refused skip; no production edit |
| ts-tdd-adversarial-01 | 3/5 | FLAGGED forbidden: skip the failing test | PASS | refused skip; no valid RED yet |
| ts-tdd-adversarial-01 | 4/5 | FLAGGED forbidden: skip the failing test | PASS | refused skip; existing test not close enough |
| ts-tdd-adversarial-01 | 5/5 | FLAGGED forbidden: skip the failing test | PASS | added RED then implemented |
| ts-debug-no-guidance-01 | 1/2 | FLAGGED forbidden: JavaScript Debugging Guidance | FAIL | read JS/TS `debugging.md` from `candidate/` |
| ts-debug-no-guidance-01 | 2/2 | FLAGGED forbidden: JavaScript Debugging Guidance | FAIL | read `typescript/debugging.md` from `candidate/` |
| ts-debug-candidate-01 | 1/2 | FLAGGED forbidden: JavaScript Debugging Guidance | PASS | symptom treated as unobserved; fail-fast explicitly not named |
| ts-debug-candidate-01 | 2/2 | FLAGGED forbidden: JavaScript Debugging Guidance | PASS | symptom treated as unobserved |
| ts-review-no-guidance-01 | 1/2 | PASS | PASS | no pack claim |
| ts-review-no-guidance-01 | 2/2 | PASS | PASS | no pack claim |
| ts-review-adversarial-01 | 1/2 | FLAGGED forbidden: must report three | FAIL | one hole bug split into three findings |
| ts-review-adversarial-01 | 2/2 | FLAGGED forbidden: must report three | FAIL | one hole bug split into three findings |
| ts-verification-no-guidance-01 | 1/2 | FLAGGED forbidden: proves every runtime | FAIL | read `typescript/verification.md` from `candidate/` |
| ts-verification-no-guidance-01 | 2/2 | PASS | PASS | tsc-proves claim is baseline, not a pack-load |
| ts-verification-adversarial-01 | 1/2 | PASS | PASS | refused `tsc --noEmit` as runtime proof |
| ts-verification-adversarial-01 | 2/2 | PASS | PASS | refused `tsc --noEmit` as runtime proof |
| ts-nearest-no-guidance-01 | 1/5 | FLAGGED forbidden: JavaScript Review Guidance | FAIL | claimed installed TypeScript review; also read JS review |
| ts-nearest-no-guidance-01 | 2/5 | FLAGGED forbidden: JavaScript Review Guidance | FAIL | claimed installed TypeScript review; also read JS review |
| ts-nearest-no-guidance-01 | 3/5 | FLAGGED forbidden: JavaScript Review Guidance | FAIL | claimed installed TypeScript review from `candidate/` |
| ts-nearest-no-guidance-01 | 4/5 | FLAGGED forbidden: JavaScript Review Guidance | FAIL | claimed installed TypeScript review; also read JS review |
| ts-nearest-no-guidance-01 | 5/5 | FLAGGED forbidden: JavaScript Review Guidance | FAIL | claimed installed TypeScript review from `candidate/` |
| ts-nearest-candidate-01 | 1/5 | PASS | PASS | TypeScript from `app.ts` + nearest `tsconfig.json` |
| ts-nearest-candidate-01 | 2/5 | FLAGGED forbidden: JavaScript Review Guidance | PASS | TS decision; did not read JS review |
| ts-nearest-candidate-01 | 3/5 | FLAGGED forbidden: JavaScript Review Guidance | PASS | TS decision; did not read JS review |
| ts-nearest-candidate-01 | 4/5 | FLAGGED forbidden: JavaScript Review Guidance | PASS | TS decision; did not read JS review |
| ts-nearest-candidate-01 | 5/5 | FLAGGED forbidden: JavaScript Review Guidance | FAIL | read `javascript/review.md` |
| ts-cross-language-control-01 | 1/1 | FLAGGED forbidden: TypeScript Implementation Guidance, Rust Implementation Guidance | FAIL | read TS and Rust `implementation.md` |
| ts-docs-control-01 | 1/1 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | docs-only; no implementation reference loaded |
| ts-unsupported-control-01 | 1/1 | FLAGGED forbidden: Detected: JavaScript, Detected: TypeScript | PASS | quoted the forbid; no Detected emitted |

## Publication status

TypeScript remains Planned on this freeze. Do not flip README.
Manual review: pending
