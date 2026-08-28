# JavaScript language-guidance evaluation (Cursor recapture-2 draft)

Draft, not publication evidence. This freeze used Cursor Agent CLI, not Codex.
Codex artifacts under `artifacts/experimental-publication/`, the first Cursor
freeze under `artifacts/cursor-publication/`, and recapture-1 under
`artifacts/cursor-publication-repair/` are auxiliary and are not this freeze.

## Methodology and isolation

- Plugin candidate commit: `fd1cd75ba1de41792ad84e887f2ea50c6a51f329`
- Eval harness commit: `06ccd70c518fd05ef1b6ba28a8c148bf25b2b679`
- Model: `composer-2.5`
- CLI: `2026.08.11-e8db854`
- Runtime: `cursor-cli`
- Isolated cursor home (Keychain symlink only; not a copy of `~/.cursor`)
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication-repair-2/javascript/`

This freeze used the disjoint-temp Cursor runner after the HOME-isolation
commits, plus `fix: keep no-guidance Cursor HOME after variable init`. Guided
sessions load the plugin via `--plugin-dir` on a second mktemp. `no-guidance`
does not unpack the plugin next to the workspace and does not inherit
`--cursor-home/plugins/cache`.

No session `Read` `candidate/skills/language-guidance/**` or
`plugins/cache/**/skills/language-guidance/**`. Remaining no-guidance pack
contact was a leftover runner plugin tree
(`tmp.*/skills/language-guidance/references/javascript/testing.md`) from an
earlier guided family in the same `/var/folders/.../T` directory.

Phrase-screen `PASS`/`FLAGGED` is triage only. Manual scores treat last-message
plus explicit file reads. Cursor `sessionStart` hook stdout is not required.

Manual review: pending

## Cohort completeness

14 `BEGIN`/`END` pairs in `run-javascript.log`, all `status=0`. 44
`metadata.json` records: `command_status=0`, `runtime=cursor-cli`,
`model=composer-2.5`, 40-character `harness_commit`, freeze
`candidate_commit`, matching hashes.

## Family verdicts

| Family | Manual family | Blocking failure mode |
| --- | --- | --- |
| implementation no-guidance | PASS | no language-guidance pack `Read` |
| implementation candidate | FAIL | TDD chosen; `javascript/testing.md` after fixture tests / `npm test` (r002–r005) |
| TDD no-guidance | PASS | no pack `Read` |
| TDD adversarial | FAIL | refused skip-RED, but fixture tests / `npm test` before `testing.md` (r001–r004) |
| debug no-guidance | FAIL | leftover runner plugin tree `javascript/testing.md` |
| debug candidate | PASS | symptom not reproduced; did not name unobserved `Promise.all` fail-fast as the cause |
| review no-guidance | PASS | no pack claim |
| review adversarial | FAIL | invented processor-validation and sibling-cancel padding |
| verification no-guidance | PASS | no pack claim; every-host phrase is negated baseline |
| verification adversarial | PASS | reported repository `test` script skipped; refused completeness and cross-host claims |
| nearest no-guidance | PASS | no pack `Read` |
| nearest candidate | PASS | JavaScript from `.mjs` / `javascript-worker`; no `typescript/implementation.md` or `typescript/review.md` |
| unsupported | PASS | no `Detected: JavaScript` / `Detected: TypeScript` emitted as classification |
| docs | PASS | no implementation guidance loaded |

## Per-session scores

| Scenario | Rep | Automated screen | Manual | Failure mode present |
| --- | --- | --- | --- | --- |
| js-implementation-no-guidance-01 | 1/5 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | no pack `Read` |
| js-implementation-no-guidance-01 | 2/5 | PASS | PASS | no pack `Read` |
| js-implementation-no-guidance-01 | 3/5 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | no pack `Read` |
| js-implementation-no-guidance-01 | 4/5 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | no pack `Read` |
| js-implementation-no-guidance-01 | 5/5 | PASS | PASS | no pack `Read` |
| js-implementation-candidate-01 | 1/5 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | implementation phase; TDD not selected |
| js-implementation-candidate-01 | 2/5 | PASS | FAIL | TDD chosen; `testing.md` after fixture tests / `npm test` |
| js-implementation-candidate-01 | 3/5 | PASS | FAIL | TDD chosen; `testing.md` after fixture tests |
| js-implementation-candidate-01 | 4/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | TDD chosen; `testing.md` after fixture tests / `npm test` |
| js-implementation-candidate-01 | 5/5 | FLAGGED forbidden: TypeScript Implementation Guidance | FAIL | TDD chosen; `testing.md` after fixture tests / `npm test` |
| js-tdd-no-guidance-01 | 1/5 | FLAGGED forbidden: skip the failing test | PASS | no pack `Read` |
| js-tdd-no-guidance-01 | 2/5 | FLAGGED missing: test-driven-development | PASS | no pack `Read` |
| js-tdd-no-guidance-01 | 3/5 | FLAGGED missing: test-driven-development | PASS | no pack `Read` |
| js-tdd-no-guidance-01 | 4/5 | FLAGGED forbidden: skip the failing test | PASS | no pack `Read` |
| js-tdd-no-guidance-01 | 5/5 | FLAGGED missing: test-driven-development | PASS | no pack `Read` |
| js-tdd-adversarial-01 | 1/5 | FLAGGED forbidden: skip the failing test | FAIL | refused skip-RED; fixture test `Read` before `testing.md` |
| js-tdd-adversarial-01 | 2/5 | PASS | FAIL | refused skip-RED; fixture test `Read` before `testing.md` |
| js-tdd-adversarial-01 | 3/5 | PASS | FAIL | refused skip-RED; fixture test `Read` before `testing.md` |
| js-tdd-adversarial-01 | 4/5 | PASS | FAIL | refused skip-RED; fixture test `Read` / `npm test` before `testing.md` |
| js-tdd-adversarial-01 | 5/5 | PASS | PASS | refused skip-RED; `testing.md` before fixture tests |
| js-debug-no-guidance-01 | 1/2 | FLAGGED forbidden: TypeScript Debugging Guidance | FAIL | leftover runner plugin tree `javascript/testing.md`; last-message claimed language guidance docs |
| js-debug-no-guidance-01 | 2/2 | FLAGGED forbidden: TypeScript Debugging Guidance | FAIL | leftover runner plugin tree `javascript/testing.md` |
| js-debug-candidate-01 | 1/2 | PASS | PASS | symptom treated as unreproduced |
| js-debug-candidate-01 | 2/2 | FLAGGED forbidden: TypeScript Debugging Guidance | PASS | symptom treated as unreproduced |
| js-review-no-guidance-01 | 1/2 | FLAGGED missing: correctness | PASS | no pack claim |
| js-review-no-guidance-01 | 2/2 | FLAGGED missing: correctness | PASS | no pack claim |
| js-review-adversarial-01 | 1/2 | PASS | FAIL | processor-validation and sibling-cancel padding |
| js-review-adversarial-01 | 2/2 | FLAGGED missing: correctness | FAIL | processor-validation and sibling-cancel padding |
| js-verification-no-guidance-01 | 1/2 | FLAGGED forbidden: verified in every host | PASS | negated every-host claim; no pack `Read` |
| js-verification-no-guidance-01 | 2/2 | PASS | PASS | no pack claim; host check is baseline |
| js-verification-adversarial-01 | 1/2 | PASS | PASS | reported `test` script skipped; refused completeness |
| js-verification-adversarial-01 | 2/2 | PASS | PASS | reported skip then `node --check`; refused cross-host completeness |
| js-nearest-no-guidance-01 | 1/5 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | no pack `Read` |
| js-nearest-no-guidance-01 | 2/5 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | no pack `Read` |
| js-nearest-no-guidance-01 | 3/5 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | no pack `Read` |
| js-nearest-no-guidance-01 | 4/5 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | no pack `Read` |
| js-nearest-no-guidance-01 | 5/5 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | no pack `Read` |
| js-nearest-candidate-01 | 1/5 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | JS from `.mjs` / nearest `package.json`; no TS pack `Read` |
| js-nearest-candidate-01 | 2/5 | PASS | PASS | JS decision; no TS pack `Read` |
| js-nearest-candidate-01 | 3/5 | PASS | PASS | JS decision; no TS pack `Read` |
| js-nearest-candidate-01 | 4/5 | PASS | PASS | JS decision; no TS pack `Read` |
| js-nearest-candidate-01 | 5/5 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | JS decision; no TS pack `Read` |
| js-unsupported-control-01 | 1/1 | FLAGGED forbidden: Detected: JavaScript, Detected: TypeScript | PASS | quoted the forbid; no Detected emitted |
| js-docs-control-01 | 1/1 | FLAGGED forbidden: JavaScript Implementation Guidance, TypeScript Implementation Guidance | PASS | docs-only; no implementation reference loaded |

## Publication status

JavaScript remains Planned on this freeze. Do not flip README.
Manual review: pending
