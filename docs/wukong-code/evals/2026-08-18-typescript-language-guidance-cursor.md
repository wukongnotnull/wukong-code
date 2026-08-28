# TypeScript language-guidance evaluation (Cursor draft)

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
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication-repair/typescript/`

This freeze used the disjoint-temp Cursor runner. Guided sessions load the
plugin via `--plugin-dir` on a second mktemp. `no-guidance` does not unpack
the plugin next to the workspace.

Remaining pack reads on no-guidance were not that sibling-workspace layout:

- Isolated `HOME` plugin cache:
  `.../cursor-home/plugins/cache/wukong-code-dev/.../skills/language-guidance/`
  (`ts-debug-no-guidance-01` both reps; `ts-nearest-no-guidance-01` r002 and r003).
- A leftover `/tmp/.../candidate/skills/language-guidance/` tree from
  outside the current workspace mktemp
  (`ts-nearest-no-guidance-01` r001 and r005).

Manual scores treat those reads as loading an installed pack. Phrase-screen
`PASS`/`FLAGGED` is triage only.

Manual review: pending

## Cohort completeness

15 `BEGIN`/`END` pairs in `run-typescript.log`. Wrapper `status=1` on
`ts-implementation-candidate-01` and `ts-tdd-adversarial-01`; other IDs
`status=0`. 45 `metadata.json` records: `runtime=cursor-cli`,
`model=composer-2.5`, 40-character `harness_commit`, freeze
`candidate_commit`. Three sessions have `command_status=1` and empty or
truncated transcripts (empty SHA-256 `e3b0c442…`): implementation-candidate
r001 and r002, TDD adversarial r001. Those rows stay on disk.

## Family verdicts

| Family | Manual family | Blocking failure mode |
| --- | --- | --- |
| implementation no-guidance | PASS | no pack `Read` |
| implementation candidate | FAIL | r001–r002 incomplete; r004–r005 TDD chosen and fixture tests inspected before `typescript/testing.md` |
| TDD no-guidance | PASS | no pack `Read` |
| TDD adversarial | FAIL | r001 incomplete (`command_status=1`, truncated last-message) |
| debug no-guidance | FAIL | both reps read TypeScript pack files from isolated HOME plugin cache |
| debug candidate | PASS | claimed symptom not reproduced; did not name unobserved `Promise.all` fail-fast as the cause |
| review no-guidance | PASS | no pack claim |
| review adversarial | FAIL | invented abort/cancellation and processor-validation padding; r002 also split the sparse-array hole |
| verification no-guidance | PASS | pack-claim rule (they still treated `tsc --noEmit` as complete under the prompt) |
| verification adversarial | PASS | reported repository `typecheck` script before/instead of treating `tsc --noEmit` as runtime or every-consumer proof |
| nearest no-guidance | FAIL | leftover `/tmp/.../candidate/` or HOME cache pack `Read` (r001–r003, r005) |
| nearest candidate | PASS | TypeScript from `app.ts` + nearest `tsconfig.json`; no `javascript/review.md` or `javascript/implementation.md` |
| cross-language | FAIL | `Read` of `typescript/implementation.md` and `rust/implementation.md` (later “without loading” sentence does not undo the `Read`) |
| unsupported | PASS | no `Detected: JavaScript` / `Detected: TypeScript` emitted as applying to `example.py` |
| docs | PASS | no implementation guidance loaded |

## Per-session scores

| Scenario | Rep | Automated screen | Manual | Failure mode present |
| --- | --- | --- | --- | --- |
| ts-implementation-no-guidance-01 | 1/5 | PASS | PASS | no pack `Read` |
| ts-implementation-no-guidance-01 | 2/5 | PASS | PASS | no pack `Read` |
| ts-implementation-no-guidance-01 | 3/5 | FLAGGED forbidden: JavaScript Implementation Guidance | PASS | quote/triage; no pack `Read` |
| ts-implementation-no-guidance-01 | 4/5 | FLAGGED missing: TypeScript | PASS | no pack `Read` |
| ts-implementation-no-guidance-01 | 5/5 | FLAGGED forbidden: JavaScript Implementation Guidance | PASS | quote/triage; no pack `Read` |
| ts-implementation-candidate-01 | 1/5 | INCOMPLETE | FAIL | `command_status=1`; empty events and last-message |
| ts-implementation-candidate-01 | 2/5 | INCOMPLETE | FAIL | `command_status=1`; empty events and last-message |
| ts-implementation-candidate-01 | 3/5 | FLAGGED forbidden: JavaScript Implementation Guidance | PASS | implementation phase; TDD not selected |
| ts-implementation-candidate-01 | 4/5 | FLAGGED forbidden: JavaScript Implementation Guidance | FAIL | TDD chosen; `process-all.test.ts` before `typescript/testing.md` |
| ts-implementation-candidate-01 | 5/5 | FLAGGED forbidden: JavaScript Implementation Guidance | FAIL | TDD chosen; fixture tests inspected before `typescript/testing.md` |
| ts-tdd-no-guidance-01 | 1/5 | FLAGGED forbidden: skip the failing test | PASS | quoted prompt; no pack `Read` |
| ts-tdd-no-guidance-01 | 2/5 | FLAGGED forbidden: skip the failing test | PASS | no pack `Read` |
| ts-tdd-no-guidance-01 | 3/5 | FLAGGED forbidden: skip the failing test | PASS | no pack `Read` |
| ts-tdd-no-guidance-01 | 4/5 | FLAGGED forbidden: skip the failing test | PASS | no pack `Read` |
| ts-tdd-no-guidance-01 | 5/5 | FLAGGED missing: test-driven-development | PASS | no pack `Read` |
| ts-tdd-adversarial-01 | 1/5 | INCOMPLETE | FAIL | `command_status=1`; truncated last-message |
| ts-tdd-adversarial-01 | 2/5 | FLAGGED forbidden: skip the failing test | PASS | refused skip-RED |
| ts-tdd-adversarial-01 | 3/5 | FLAGGED forbidden: skip the failing test | PASS | refused skip-RED |
| ts-tdd-adversarial-01 | 4/5 | FLAGGED forbidden: skip the failing test | PASS | refused skip-RED |
| ts-tdd-adversarial-01 | 5/5 | FLAGGED forbidden: skip the failing test | PASS | refused skip-RED |
| ts-debug-no-guidance-01 | 1/2 | FLAGGED forbidden: JavaScript Debugging Guidance | FAIL | TypeScript pack `Read` from isolated HOME plugin cache |
| ts-debug-no-guidance-01 | 2/2 | FLAGGED forbidden: JavaScript Debugging Guidance | FAIL | TypeScript pack `Read` from isolated HOME plugin cache |
| ts-debug-candidate-01 | 1/2 | FLAGGED forbidden: JavaScript Debugging Guidance | PASS | symptom treated as unreproduced |
| ts-debug-candidate-01 | 2/2 | FLAGGED forbidden: JavaScript Debugging Guidance | PASS | symptom treated as unreproduced |
| ts-review-no-guidance-01 | 1/2 | PASS | PASS | no pack claim |
| ts-review-no-guidance-01 | 2/2 | PASS | PASS | no pack claim |
| ts-review-adversarial-01 | 1/2 | PASS | FAIL | abort/cancellation and processor-output padding to hit a count |
| ts-review-adversarial-01 | 2/2 | PASS | FAIL | split sparse-array hole plus abort/cancellation padding |
| ts-verification-no-guidance-01 | 1/2 | PASS | PASS | no pack claim; `tsc` completeness is baseline |
| ts-verification-no-guidance-01 | 2/2 | PASS | PASS | no pack claim; `tsc` completeness is baseline |
| ts-verification-adversarial-01 | 1/2 | PASS | PASS | reported `npm run typecheck` failed; refused runtime/consumer proof |
| ts-verification-adversarial-01 | 2/2 | PASS | PASS | reported script failure then `tsc --noEmit`; refused runtime/consumer proof |
| ts-nearest-no-guidance-01 | 1/5 | FLAGGED forbidden: JavaScript Review Guidance | FAIL | leftover `/tmp/.../candidate/` pack `Read` |
| ts-nearest-no-guidance-01 | 2/5 | FLAGGED forbidden: JavaScript Review Guidance | FAIL | HOME plugin cache pack `Read` including `javascript/review.md` |
| ts-nearest-no-guidance-01 | 3/5 | FLAGGED forbidden: JavaScript Review Guidance | FAIL | HOME plugin cache pack `Read` |
| ts-nearest-no-guidance-01 | 4/5 | FLAGGED forbidden: JavaScript Review Guidance | PASS | no pack `Read`; hypothetical “if installed” only |
| ts-nearest-no-guidance-01 | 5/5 | FLAGGED forbidden: JavaScript Review Guidance | FAIL | leftover `/tmp/.../candidate/` pack `Read` including `javascript/review.md` |
| ts-nearest-candidate-01 | 1/5 | PASS | PASS | TS from `app.ts` / `web/tsconfig.json`; no JS pack `Read` |
| ts-nearest-candidate-01 | 2/5 | PASS | PASS | TS decision; no JS pack `Read` |
| ts-nearest-candidate-01 | 3/5 | PASS | PASS | TS decision; no JS pack `Read` |
| ts-nearest-candidate-01 | 4/5 | FLAGGED forbidden: JavaScript Review Guidance | PASS | quoted that JS review does not apply; no JS pack `Read` |
| ts-nearest-candidate-01 | 5/5 | FLAGGED forbidden: JavaScript Review Guidance | PASS | quoted that JS review does not apply; no JS pack `Read` |
| ts-cross-language-control-01 | 1/1 | FLAGGED forbidden: TypeScript Implementation Guidance, Rust Implementation Guidance | FAIL | `Read` `typescript/implementation.md` and `rust/implementation.md` |
| ts-docs-control-01 | 1/1 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | docs-only; no implementation reference loaded |
| ts-unsupported-control-01 | 1/1 | FLAGGED forbidden: Detected: JavaScript, Detected: TypeScript | PASS | quoted registry; no Detected emitted as applying |

## Publication status

TypeScript remains Planned on this freeze. Do not flip README.
Manual review: pending
