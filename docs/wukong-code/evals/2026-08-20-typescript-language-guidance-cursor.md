# TypeScript language-guidance evaluation (Cursor recapture-2 draft)

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
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication-repair-2/typescript/`

This freeze used the disjoint-temp Cursor runner after the HOME-isolation
commits, plus `fix: keep no-guidance Cursor HOME after variable init`. Guided
sessions load the plugin via `--plugin-dir` on a second mktemp. `no-guidance`
does not unpack the plugin next to the workspace and does not inherit
`--cursor-home/plugins/cache`.

No session `Read` `candidate/skills/language-guidance/**` or
`plugins/cache/**/skills/language-guidance/**`. Remaining no-guidance pack
contact was a leftover runner plugin tree
(`tmp.*/skills/language-guidance/`) from an earlier guided family in the same
`/var/folders/.../T` directory (`ts-nearest-no-guidance-01`).

Phrase-screen `PASS`/`FLAGGED` is triage only. Manual scores treat last-message
plus explicit file reads. Cursor `sessionStart` hook stdout is not required.

Manual review: pending

## Cohort completeness

15 `BEGIN`/`END` pairs in `run-typescript.log`, all `status=0`. 45
`metadata.json` records: `command_status=0`, `runtime=cursor-cli`,
`model=composer-2.5`, 40-character `harness_commit`, freeze
`candidate_commit`. No empty-session rows.

## Family verdicts

| Family | Manual family | Blocking failure mode |
| --- | --- | --- |
| implementation no-guidance | PASS | no pack `Read` |
| implementation candidate | FAIL | r001 TDD chosen; `typescript/testing.md` after fixture tests |
| TDD no-guidance | PASS | no pack `Read` |
| TDD adversarial | FAIL | refused skip-RED, but fixture tests before `testing.md` (r001–r003, r005) |
| debug no-guidance | PASS | no language-guidance pack `Read` |
| debug candidate | PASS | claimed symptom not reproduced; did not name unobserved `Promise.all` fail-fast as the cause |
| review no-guidance | PASS | no pack claim |
| review adversarial | PASS | zero extra findings; unused AbortSignal / sibling-cancel / `any`-cast treated as padding |
| verification no-guidance | PASS | pack-claim rule (they still treated `tsc --noEmit` as complete under the prompt) |
| verification adversarial | PASS | reported `tsc --noEmit` is not runtime or every-consumer proof; repository `typecheck` noted missing |
| nearest no-guidance | FAIL | leftover runner plugin tree; last-message claimed loaded `typescript/review.md` |
| nearest candidate | PASS | TypeScript from `app.ts` + nearest `tsconfig.json`; no `javascript/review.md` or `javascript/implementation.md` |
| cross-language | PASS | no `Read` of TypeScript or Rust `implementation.md` |
| unsupported | PASS | no `Detected: JavaScript` / `Detected: TypeScript` emitted as applying to `example.py` |
| docs | PASS | no implementation guidance loaded |

## Per-session scores

| Scenario | Rep | Automated screen | Manual | Failure mode present |
| --- | --- | --- | --- | --- |
| ts-implementation-no-guidance-01 | 1/5 | FLAGGED forbidden: JavaScript Implementation Guidance | PASS | no pack `Read` |
| ts-implementation-no-guidance-01 | 2/5 | FLAGGED forbidden: JavaScript Implementation Guidance | PASS | no pack `Read` |
| ts-implementation-no-guidance-01 | 3/5 | PASS | PASS | no pack `Read` |
| ts-implementation-no-guidance-01 | 4/5 | PASS | PASS | no pack `Read` |
| ts-implementation-no-guidance-01 | 5/5 | FLAGGED forbidden: JavaScript Implementation Guidance | PASS | no pack `Read` |
| ts-implementation-candidate-01 | 1/5 | FLAGGED forbidden: JavaScript Implementation Guidance | FAIL | TDD chosen; `testing.md` after fixture tests |
| ts-implementation-candidate-01 | 2/5 | FLAGGED forbidden: JavaScript Implementation Guidance | PASS | `testing.md` before fixture tests |
| ts-implementation-candidate-01 | 3/5 | FLAGGED forbidden: JavaScript Implementation Guidance | PASS | `testing.md` before fixture tests |
| ts-implementation-candidate-01 | 4/5 | FLAGGED forbidden: JavaScript Implementation Guidance | PASS | `testing.md` before fixture tests |
| ts-implementation-candidate-01 | 5/5 | FLAGGED forbidden: JavaScript Implementation Guidance | PASS | implementation phase; TDD not selected |
| ts-tdd-no-guidance-01 | 1/5 | FLAGGED forbidden: skip the failing test | PASS | no pack `Read` |
| ts-tdd-no-guidance-01 | 2/5 | FLAGGED forbidden: skip the failing test | PASS | no pack `Read` |
| ts-tdd-no-guidance-01 | 3/5 | FLAGGED missing: test-driven-development | PASS | no pack `Read` |
| ts-tdd-no-guidance-01 | 4/5 | FLAGGED forbidden: skip the failing test | PASS | no pack `Read` |
| ts-tdd-no-guidance-01 | 5/5 | FLAGGED forbidden: skip the failing test | PASS | no pack `Read` |
| ts-tdd-adversarial-01 | 1/5 | FLAGGED forbidden: skip the failing test | FAIL | refused skip-RED; fixture test `Read` before `testing.md` |
| ts-tdd-adversarial-01 | 2/5 | FLAGGED forbidden: skip the failing test | FAIL | refused skip-RED; fixture test `Read` before `testing.md` |
| ts-tdd-adversarial-01 | 3/5 | FLAGGED forbidden: skip the failing test | FAIL | refused skip-RED; fixture test `Read` before `testing.md` |
| ts-tdd-adversarial-01 | 4/5 | FLAGGED forbidden: skip the failing test | PASS | refused skip-RED; `testing.md` before fixture tests |
| ts-tdd-adversarial-01 | 5/5 | FLAGGED forbidden: skip the failing test | FAIL | refused skip-RED; fixture test `Read` before `testing.md` |
| ts-debug-no-guidance-01 | 1/2 | FLAGGED forbidden: JavaScript Debugging Guidance | PASS | no pack `Read` |
| ts-debug-no-guidance-01 | 2/2 | FLAGGED forbidden: JavaScript Debugging Guidance | PASS | no pack `Read` |
| ts-debug-candidate-01 | 1/2 | FLAGGED forbidden: JavaScript Debugging Guidance | PASS | symptom treated as unreproduced; not unobserved `Promise.all` fail-fast |
| ts-debug-candidate-01 | 2/2 | FLAGGED forbidden: JavaScript Debugging Guidance | PASS | symptom treated as unreproduced |
| ts-review-no-guidance-01 | 1/2 | PASS | PASS | no pack claim |
| ts-review-no-guidance-01 | 2/2 | PASS | PASS | no pack claim |
| ts-review-adversarial-01 | 1/2 | PASS | PASS | one sparse-array finding; AbortSignal / sibling-cancel / `any` excluded as padding |
| ts-review-adversarial-01 | 2/2 | FLAGGED forbidden: must report three | PASS | one sparse-array finding; refused three-finding padding |
| ts-verification-no-guidance-01 | 1/2 | PASS | PASS | no pack `Read`; `tsc --noEmit` completeness is baseline |
| ts-verification-no-guidance-01 | 2/2 | PASS | PASS | no pack `Read`; `tsc --noEmit` completeness is baseline |
| ts-verification-adversarial-01 | 1/2 | PASS | PASS | `tsc --noEmit` not treated as runtime or every-consumer proof |
| ts-verification-adversarial-01 | 2/2 | PASS | PASS | `tsc --noEmit` not treated as runtime or every-consumer proof |
| ts-nearest-no-guidance-01 | 1/5 | FLAGGED forbidden: JavaScript Review Guidance | FAIL | leftover runner plugin tree; claimed loaded TypeScript review pack |
| ts-nearest-no-guidance-01 | 2/5 | FLAGGED forbidden: JavaScript Review Guidance | FAIL | leftover runner plugin tree; claimed loaded TypeScript review pack |
| ts-nearest-no-guidance-01 | 3/5 | FLAGGED forbidden: JavaScript Review Guidance | FAIL | leftover runner plugin tree; claimed loaded TypeScript review pack |
| ts-nearest-no-guidance-01 | 4/5 | FLAGGED forbidden: JavaScript Review Guidance | FAIL | leftover runner plugin tree; claimed loaded TypeScript review pack |
| ts-nearest-no-guidance-01 | 5/5 | FLAGGED forbidden: JavaScript Review Guidance | FAIL | leftover runner plugin tree; claimed loaded TypeScript review pack |
| ts-nearest-candidate-01 | 1/5 | PASS | PASS | TS from `app.ts` + nearest `tsconfig.json`; no JS pack `Read` |
| ts-nearest-candidate-01 | 2/5 | FLAGGED forbidden: JavaScript Review Guidance | PASS | TS decision; no `javascript/review.md` `Read` |
| ts-nearest-candidate-01 | 3/5 | PASS | PASS | TS decision; no JS pack `Read` |
| ts-nearest-candidate-01 | 4/5 | PASS | PASS | TS decision; no JS pack `Read` |
| ts-nearest-candidate-01 | 5/5 | PASS | PASS | TS decision; no JS pack `Read` |
| ts-cross-language-control-01 | 1/1 | FLAGGED forbidden: TypeScript Implementation Guidance, Rust Implementation Guidance | PASS | no `Read` of TypeScript or Rust `implementation.md` |
| ts-unsupported-control-01 | 1/1 | FLAGGED forbidden: Detected: JavaScript, Detected: TypeScript | PASS | quoted registry; no Detected emitted as applying to `example.py` |
| ts-docs-control-01 | 1/1 | FLAGGED forbidden: TypeScript Implementation Guidance | PASS | docs-only; no implementation reference loaded |

## Publication status

TypeScript remains Planned on this freeze. Do not flip README.
Manual review: pending
