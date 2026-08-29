# TypeScript language-guidance evaluation (Cursor recapture-8 draft)

Draft, not publication evidence. This freeze used Cursor Agent CLI, not Codex.
Codex artifacts under `artifacts/experimental-publication/`, the first Cursor
freeze under `artifacts/cursor-publication/`, recapture-1 under
`artifacts/cursor-publication-repair/`, recapture-2 under
`artifacts/cursor-publication-repair-2/`, recapture-3 under
`artifacts/cursor-publication-repair-3/`, recapture-4 under
`artifacts/cursor-publication-repair-4/`, recapture-5 under
`artifacts/cursor-publication-repair-5/`, recapture-6 under
`artifacts/cursor-publication-repair-6/`, and recapture-7 under
`artifacts/cursor-publication-repair-7/` are auxiliary and are not this freeze.

## Methodology and isolation

- Plugin candidate commit: `e3410de3c5949510e7d717accfa8e5a8c8470f4c`
- Eval harness commit: `39cbbec9d5842edd47ead87fcd6e1fc1399b4287`
- Model: `composer-2.5`
- CLI: `2026.08.11-e8db854`
- Runtime: `cursor-cli`
- Isolated cursor home (Keychain symlink only; not a copy of `~/.cursor`)
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication-repair-8/typescript/`

This freeze used nested eval temps (`$eval_tmp_root/plugin` for guided
`--plugin-dir`), up to three empty-session retries with backoff, and the
recapture-7 skill sentences already on plugin `main` via PR #28 (after TDD is
selected, the first Read must be `testing.md`; a workspace Glob of `**/*`
that lists src or test files before that Read completes is FAIL; listing
unbounded concurrency as a review finding is padding). A live sandbox
probe recorded `sandbox_blocks_host_pack_reads=no`. That probe does not
create a scoring exemption. Smoke recorded
`smoke_no_guidance_host_pack_read=no`. Host-pack Reads remain FAIL.

No session `Read` leftover `tmp.*/skills/language-guidance/**` (old unpack
layout). No session `Read` operator checkout
`/Users/wukong/Documents/wukong-code/**/skills/language-guidance/**` or
`~/.cursor/plugins/local/wukong-code/skills/language-guidance/**`. Guided
sessions `Read` `$eval_tmp_root/plugin/skills/language-guidance/**`, which is
expected. All six `no-guidance` families had no pack `Read`.
`_auth_failed_*` leftovers from the aborted first launch are ignored and
are not counted toward 45.

Phrase-screen was not re-run on this family-directory layout. Manual scores
treat last-message plus explicit file Reads, Globs, and Greps. Cursor
`sessionStart` hook stdout is not required.

Manual review: pending

## Cohort completeness

15 `BEGIN`/`END` pairs in `run-typescript.log`, then `MATRIX_DONE`
`2026-08-29T04:16:16Z`. 45 `metadata.json` records excluding
`_auth_failed_*`: `command_status=0`, `runtime=cursor-cli`,
`model=composer-2.5`, 40-character `harness_commit`
`39cbbec9d5842edd47ead87fcd6e1fc1399b4287`, freeze `candidate_commit`
`e3410de3c5949510e7d717accfa8e5a8c8470f4c`. No empty `events.jsonl`.

## Family verdicts

| Family | Manual family | Blocking failure mode |
| --- | --- | --- |
| implementation no-guidance | PASS | no pack `Read` |
| implementation candidate | FAIL | TDD chosen; fixture Read/`**/*` workspace listing before `testing.md` completed (all 5) |
| TDD no-guidance | PASS | refused skip-RED; no pack `Read` |
| TDD adversarial | FAIL | refused skip-RED; `**/*` workspace listing before `testing.md` completed (all 5) |
| debug no-guidance | PASS | no pack `Read` |
| debug candidate | PASS | symptom not reproduced; did not name unobserved `Promise.all` fail-fast as the cause |
| review no-guidance | PASS | no pack `Read`; non-empty sessions |
| review adversarial | PASS | sparse-array finding; AbortSignal / sibling-cancel / unbounded `Promise.all` / concurrency-limit / processor-validation not used as padding |
| verification no-guidance | PASS | no pack claim; host `tsc --noEmit` is baseline |
| verification adversarial | PASS | `tsc --noEmit` is not runtime or every-consumer proof |
| nearest no-guidance | PASS | no pack `Read` (all 5) |
| nearest candidate | PASS | TypeScript from `app.ts` + nearest `tsconfig.json`; no JavaScript review or implementation `Read` |
| cross-language | PASS | no TypeScript or Rust `implementation.md` Read; no Glob of `skills/language-guidance/references` |
| unsupported | PASS | no corresponding installed language guidance; no `Detected: JavaScript` / `Detected: TypeScript` emitted as classification |
| docs | PASS | no implementation guidance loaded |

## Per-session scores

| Scenario | Rep | Automated screen | Manual | Failure mode present |
| --- | --- | --- | --- | --- |
| ts-implementation-no-guidance-01 | 1/5 | n/a | PASS | no pack `Read` |
| ts-implementation-no-guidance-01 | 2/5 | n/a | PASS | no pack `Read` |
| ts-implementation-no-guidance-01 | 3/5 | n/a | PASS | no pack `Read` |
| ts-implementation-no-guidance-01 | 4/5 | n/a | PASS | no pack `Read` |
| ts-implementation-no-guidance-01 | 5/5 | n/a | PASS | no pack `Read` |
| ts-implementation-candidate-01 | 1/5 | n/a | FAIL | TDD chosen; fixture Read and `**/*` Glob before `testing.md` completed |
| ts-implementation-candidate-01 | 2/5 | n/a | FAIL | TDD chosen; `**/*` Glob before `testing.md` completed |
| ts-implementation-candidate-01 | 3/5 | n/a | FAIL | TDD chosen; fixture Read and `**/*` Glob before `testing.md` completed |
| ts-implementation-candidate-01 | 4/5 | n/a | FAIL | TDD chosen; `**/*` Glob before `testing.md` completed |
| ts-implementation-candidate-01 | 5/5 | n/a | FAIL | TDD chosen; `**/*` Glob before `testing.md` completed |
| ts-tdd-no-guidance-01 | 1/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-no-guidance-01 | 2/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-no-guidance-01 | 3/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-no-guidance-01 | 4/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-no-guidance-01 | 5/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-adversarial-01 | 1/5 | n/a | FAIL | refused skip-RED; `**/*` Glob before `testing.md` completed |
| ts-tdd-adversarial-01 | 2/5 | n/a | FAIL | refused skip-RED; `**/*` Glob before `testing.md` completed |
| ts-tdd-adversarial-01 | 3/5 | n/a | FAIL | refused skip-RED; `**/*` Glob and fixture Read before `testing.md` completed |
| ts-tdd-adversarial-01 | 4/5 | n/a | FAIL | refused skip-RED; `**/*` Glob before `testing.md` completed |
| ts-tdd-adversarial-01 | 5/5 | n/a | FAIL | refused skip-RED; `**/*` Glob and fixture Read before `testing.md` completed |
| ts-debug-no-guidance-01 | 1/2 | n/a | PASS | no pack `Read` |
| ts-debug-no-guidance-01 | 2/2 | n/a | PASS | no pack `Read` |
| ts-debug-candidate-01 | 1/2 | n/a | PASS | symptom treated as unreproduced; `Promise.all` fail-fast not observed |
| ts-debug-candidate-01 | 2/2 | n/a | PASS | symptom treated as unreproduced; `Promise.all` fail-fast not observed |
| ts-review-no-guidance-01 | 1/2 | n/a | PASS | no pack `Read` |
| ts-review-no-guidance-01 | 2/2 | n/a | PASS | no pack `Read` |
| ts-review-adversarial-01 | 1/2 | n/a | PASS | sparse-array finding; padding excluded |
| ts-review-adversarial-01 | 2/2 | n/a | PASS | sparse-array finding; padding excluded |
| ts-verification-no-guidance-01 | 1/2 | n/a | PASS | no pack claim; host `tsc --noEmit` is baseline |
| ts-verification-no-guidance-01 | 2/2 | n/a | PASS | no pack claim; host `tsc --noEmit` is baseline |
| ts-verification-adversarial-01 | 1/2 | n/a | PASS | `tsc --noEmit` is not runtime or every-consumer proof |
| ts-verification-adversarial-01 | 2/2 | n/a | PASS | `tsc --noEmit` is not runtime or every-consumer proof |
| ts-nearest-no-guidance-01 | 1/5 | n/a | PASS | no pack `Read` |
| ts-nearest-no-guidance-01 | 2/5 | n/a | PASS | no pack `Read` |
| ts-nearest-no-guidance-01 | 3/5 | n/a | PASS | no pack `Read` |
| ts-nearest-no-guidance-01 | 4/5 | n/a | PASS | no pack `Read` |
| ts-nearest-no-guidance-01 | 5/5 | n/a | PASS | no pack `Read` |
| ts-nearest-candidate-01 | 1/5 | n/a | PASS | TS from `app.ts` / nearest `tsconfig.json`; no JS pack `Read` |
| ts-nearest-candidate-01 | 2/5 | n/a | PASS | TS review; no JS pack `Read` |
| ts-nearest-candidate-01 | 3/5 | n/a | PASS | TS review; no JS pack `Read` |
| ts-nearest-candidate-01 | 4/5 | n/a | PASS | TS review; no JS pack `Read` |
| ts-nearest-candidate-01 | 5/5 | n/a | PASS | TS review; no JS pack `Read` |
| ts-cross-language-control-01 | 1/1 | n/a | PASS | no TypeScript or Rust `implementation.md` Read |
| ts-docs-control-01 | 1/1 | n/a | PASS | docs-only; no implementation reference loaded |
| ts-unsupported-control-01 | 1/1 | n/a | PASS | no corresponding installed language guidance; no Detected JS/TS emitted |

## Publication status

TypeScript remains Planned on this freeze. Do not flip README.
Manual review: pending
