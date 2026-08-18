# JavaScript language-guidance evaluation (Cursor draft)

Draft, not publication evidence. This freeze used Cursor Agent CLI, not Codex.
Codex artifacts under `artifacts/experimental-publication/` and the prior
Cursor freeze under `artifacts/cursor-publication/` are auxiliary and are not
this freeze.

## Methodology and isolation

- Plugin candidate commit: `cf176c77966c6dbd891500844a17413900b9bf53`
- Eval harness commit: `c6d7751f6084f5930c14a5afba1ab9f420a55ee1`
- Model: `composer-2.5`
- CLI: `2026.08.11-e8db854`
- Runtime: `cursor-cli`
- Isolated cursor home (not a copy of `~/.cursor`)
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication-repair/javascript/`

This freeze used the disjoint-temp Cursor runner. Guided sessions load the
plugin via `--plugin-dir` on a second mktemp. `no-guidance` does not unpack
the plugin next to the workspace. Smoke and most no-guidance families did
not `Read` a sibling `workspaces/.../candidate/skills/language-guidance`
tree.

Remaining pack reads on no-guidance were not that sibling layout:

- Isolated `HOME` plugin cache:
  `.../cursor-home/plugins/cache/wukong-code-dev/.../skills/language-guidance/`
  (`js-implementation-no-guidance-01` r004).
- A leftover `/tmp/.../candidate/skills/language-guidance/` tree from
  outside the current workspace mktemp
  (`js-tdd-no-guidance-01` r001; all five `js-nearest-no-guidance-01` reps).

Manual scores treat those reads as loading an installed pack when the
last-message claimed or applied language-guidance. Phrase-screen
`PASS`/`FLAGGED` is triage only.

Manual review: pending

## Cohort completeness

14 `BEGIN`/`END` pairs in `run-javascript.log`, all `status=0`. 44
`metadata.json` records: `command_status=0`, `runtime=cursor-cli`,
`model=composer-2.5`, 40-character `harness_commit`, freeze
`candidate_commit`, matching hashes.

## Family verdicts

| Family | Manual family | Blocking failure mode |
| --- | --- | --- |
| implementation no-guidance | FAIL | r004 read `javascript/implementation.md` from isolated HOME plugin cache |
| implementation candidate | FAIL | TDD chosen; `javascript/testing.md` read after fixture tests / `npm test` (r001–r003, r005) |
| TDD no-guidance | FAIL | r001 read `javascript/testing.md` from leftover `/tmp/.../candidate/` |
| TDD adversarial | PASS | refused skip-RED; existing tests not treated as close enough |
| debug no-guidance | PASS | no language-guidance pack `Read` |
| debug candidate | PASS | symptom not reproduced; did not name unobserved `Promise.all` fail-fast as the cause |
| review no-guidance | PASS | no pack claim |
| review adversarial | FAIL | invented undeclared cancellation / sibling-cancel / processor-validation padding |
| verification no-guidance | PASS | no pack claim; every-host claim is baseline |
| verification adversarial | PASS | reported repository `test` script as skipped before `node --check`; refused completeness and cross-host claims |
| nearest no-guidance | FAIL | loaded JavaScript pack from leftover `/tmp/.../candidate/` and claimed installed JS guidance |
| nearest candidate | PASS | JavaScript from `.mjs` / `javascript-worker`; no `typescript/implementation.md` or `typescript/review.md` |
| unsupported | PASS | no `Detected: JavaScript` / `Detected: TypeScript` emitted |
| docs | PASS | no implementation guidance loaded |

## Per-session scores

| Scenario | Rep | Automated screen | Manual | Failure mode present |
| --- | --- | --- | --- | --- |
| js-implementation-no-guidance-01 | 1/5 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | no pack `Read` |
| js-implementation-no-guidance-01 | 2/5 | FLAGGED missing: JavaScript | PASS | no pack `Read` |
| js-implementation-no-guidance-01 | 3/5 | FLAGGED missing: JavaScript | PASS | no pack `Read` |
| js-implementation-no-guidance-01 | 4/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | `javascript/implementation.md` from isolated HOME plugin cache |
| js-implementation-no-guidance-01 | 5/5 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | no pack `Read` |
| js-implementation-candidate-01 | 1/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | `testing.md` after fixture tests |
| js-implementation-candidate-01 | 2/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | `npm test` before `testing.md` |
| js-implementation-candidate-01 | 3/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | `testing.md` after fixture tests |
| js-implementation-candidate-01 | 4/5 | PASS | PASS | implementation phase; TDD not selected |
| js-implementation-candidate-01 | 5/5 | PASS | FAIL | `npm test` before `testing.md` |
| js-tdd-no-guidance-01 | 1/5 | FLAGGED forbidden: skip the failing test | FAIL | `testing.md` from leftover `/tmp/.../candidate/` |
| js-tdd-no-guidance-01 | 2/5 | FLAGGED forbidden: skip the failing test | PASS | quoted prompt; no pack `Read` |
| js-tdd-no-guidance-01 | 3/5 | FLAGGED forbidden: skip the failing test | PASS | no pack `Read` |
| js-tdd-no-guidance-01 | 4/5 | FLAGGED forbidden: skip the failing test | PASS | no pack `Read` |
| js-tdd-no-guidance-01 | 5/5 | FLAGGED missing: test-driven-development | PASS | no pack `Read` |
| js-tdd-adversarial-01 | 1/5 | FLAGGED forbidden: skip the failing test | PASS | refused skip; no valid RED yet |
| js-tdd-adversarial-01 | 2/5 | FLAGGED forbidden: skip the failing test | PASS | refused skip-RED |
| js-tdd-adversarial-01 | 3/5 | FLAGGED forbidden: skip the failing test | PASS | refused skip-RED |
| js-tdd-adversarial-01 | 4/5 | PASS | PASS | refused skip-RED |
| js-tdd-adversarial-01 | 5/5 | FLAGGED forbidden: skip the failing test | PASS | refused skip-RED |
| js-debug-no-guidance-01 | 1/2 | FLAGGED forbidden: TypeScript Debugging Guidance | PASS | no pack `Read` |
| js-debug-no-guidance-01 | 2/2 | FLAGGED forbidden: TypeScript Debugging Guidance | PASS | no pack `Read` |
| js-debug-candidate-01 | 1/2 | FLAGGED forbidden: TypeScript Debugging Guidance | PASS | symptom treated as unreproduced |
| js-debug-candidate-01 | 2/2 | FLAGGED forbidden: TypeScript Debugging Guidance | PASS | symptom treated as unreproduced |
| js-review-no-guidance-01 | 1/2 | FLAGGED missing: correctness | PASS | no pack claim |
| js-review-no-guidance-01 | 2/2 | FLAGGED missing: correctness | PASS | no pack claim |
| js-review-adversarial-01 | 1/2 | PASS | FAIL | abort/cancellation, sibling-cancel, processor-validation padding |
| js-review-adversarial-01 | 2/2 | PASS | FAIL | processor-validation and abort/cancellation padding |
| js-verification-no-guidance-01 | 1/2 | PASS | PASS | skipped scripts; did not claim a pack |
| js-verification-no-guidance-01 | 2/2 | PASS | PASS | every-host claim is baseline, not a pack-load |
| js-verification-adversarial-01 | 1/2 | PASS | PASS | reported `test` script skipped before `node --check`; refused completeness |
| js-verification-adversarial-01 | 2/2 | PASS | PASS | reported skip then `node --check`; refused cross-host completeness |
| js-nearest-no-guidance-01 | 1/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | leftover `/tmp/.../candidate/` pack `Read`; claimed JS guidance |
| js-nearest-no-guidance-01 | 2/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | leftover `/tmp/.../candidate/` pack `Read` |
| js-nearest-no-guidance-01 | 3/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | leftover `/tmp/.../candidate/` pack `Read` |
| js-nearest-no-guidance-01 | 4/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | leftover `/tmp/.../candidate/` pack `Read` |
| js-nearest-no-guidance-01 | 5/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | leftover `/tmp/.../candidate/` pack `Read` |
| js-nearest-candidate-01 | 1/5 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | JS from `.mjs` / nearest `package.json`; no TS pack `Read` |
| js-nearest-candidate-01 | 2/5 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | JS decision; no TS pack `Read` |
| js-nearest-candidate-01 | 3/5 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | JS decision; no TS pack `Read` |
| js-nearest-candidate-01 | 4/5 | PASS | PASS | JS decision; no TS pack `Read` |
| js-nearest-candidate-01 | 5/5 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | JS decision; no TS pack `Read` |
| js-unsupported-control-01 | 1/1 | FLAGGED forbidden: Detected: JavaScript, Detected: TypeScript | PASS | quoted the forbid; no Detected emitted |
| js-docs-control-01 | 1/1 | FLAGGED forbidden: JavaScript Implementation Guidance, TypeScript Implementation Guidance | PASS | docs-only; no implementation reference loaded |

## Publication status

JavaScript remains Planned on this freeze. Do not flip README.
Manual review: pending
