# TypeScript language-guidance evaluation (Cursor recapture-14 draft)

Draft, not publication evidence. This freeze used Cursor Agent CLI, not Codex.
Prior Cursor freezes under `artifacts/cursor-publication/` and
`artifacts/cursor-publication-repair{,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11,-12,-13}/` plus Codex
`artifacts/experimental-publication/` are auxiliary and are not this freeze.

## Methodology and isolation

- Plugin candidate commit: `13e9392059e1fb05cce53278997f858e2c120ae0`
- Eval harness commit: `39cbbec9d5842edd47ead87fcd6e1fc1399b4287`
- Model: `cursor-grok-4.6-xhigh` (not `composer-2.5`)
- `claude-opus-5-thinking-high` probed unavailable before recapture-13; grok probe `PONG` before this freeze
- CLI: `2026.08.11-e8db854`
- Runtime: `cursor-cli`
- Isolated cursor home (Keychain symlink only; not a copy of `~/.cursor`)
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication-repair-14/typescript/`

Same live-pressure gate and isolation as the JavaScript recapture-14 draft.
Host-pack Reads remain FAIL.

Phrase-screen was not re-run. Manual scores treat last-message plus explicit
file Reads, Globs, and Greps. Cursor `sessionStart` hook stdout is not required.
A pack-directory Glob of `**/*` under `--plugin-dir` skills is not scored as the
fixture `**/*` FAIL. Cross-language Glob of `skills/language-guidance` remains FAIL.

Manual review: pending

## Cohort completeness

15 `BEGIN`/`END` pairs in `run-typescript.log` (plus one `RESUME` of
`ts-verification-adversarial-01` after the first wrapper died mid-ID), then
`MATRIX_DONE` `2026-09-01T05:28:10Z`. 45 `metadata.json` records exist, freeze
`candidate_commit` `13e9392059e1fb05cce53278997f858e2c120ae0`, harness
`39cbbec9d5842edd47ead87fcd6e1fc1399b4287`, model
`cursor-grok-4.6-xhigh`. No empty `events.jsonl`. Model was not switched
mid-freeze.

## Family verdicts

| Family | Manual family | Blocking failure mode |
| --- | --- | --- |
| implementation no-guidance | PASS | no pack `Read` |
| implementation candidate | FAIL | r005 Glob fixture `**/*` before `testing.md`; r001/r002 ordered `testing.md` first; r003/r004 pack-dir `**/*` only |
| TDD no-guidance | PASS | refused skip-RED; no pack `Read` |
| TDD adversarial | FAIL | r004 Glob fixture `**/*` before `testing.md`; r001/r003/r005 ordered `testing.md` first; r002 pack-dir `**/*` only |
| debug no-guidance | PASS | no pack `Read` |
| debug candidate | PASS | no blocking mode observed by screen |
| review no-guidance | PASS | no pack `Read`; non-empty sessions |
| review adversarial | PASS | no blocking mode observed by screen |
| verification no-guidance | PASS | no pack claim |
| verification adversarial | PASS | no blocking mode observed by screen |
| nearest no-guidance | PASS | no pack `Read` (all 5) |
| nearest candidate | PASS | no blocking mode observed by screen |
| cross-language | FAIL | Glob `**/*` of `plugin/skills/language-guidance`; no TS/Rust `implementation.md` Read |
| unsupported | PASS | no corresponding installed language guidance |
| docs | PASS | no implementation guidance loaded |

## Per-session scores

| Scenario | Rep | Automated screen | Manual | Failure mode present |
| --- | --- | --- | --- | --- |
| ts-implementation-no-guidance-01 | 1–5/5 | n/a | PASS | no pack `Read` |
| ts-implementation-candidate-01 | 1/5 | n/a | PASS | TDD then `typescript/testing.md` before fixture |
| ts-implementation-candidate-01 | 2/5 | n/a | PASS | TDD then `typescript/testing.md` before fixture |
| ts-implementation-candidate-01 | 3/5 | FAIL (pack-dir `**/*`) | PASS | `testing.md` before fixture; Glob `**/*` was plugin language-guidance |
| ts-implementation-candidate-01 | 4/5 | FAIL (pack-dir `**/*`) | PASS | `testing.md` before fixture; Glob `**/*` was plugin language-guidance |
| ts-implementation-candidate-01 | 5/5 | FAIL | FAIL | Glob fixture `**/*` before `testing.md` |
| ts-tdd-no-guidance-01 | 1–5/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-adversarial-01 | 1/5 | n/a | PASS | TDD then `typescript/testing.md` before fixture |
| ts-tdd-adversarial-01 | 2/5 | FAIL (pack-dir `**/*`) | PASS | `testing.md` before fixture; Glob `**/*` was plugin skills |
| ts-tdd-adversarial-01 | 3/5 | n/a | PASS | TDD then `typescript/testing.md` before fixture |
| ts-tdd-adversarial-01 | 4/5 | FAIL | FAIL | Glob fixture `**/*` before `testing.md` |
| ts-tdd-adversarial-01 | 5/5 | n/a | PASS | TDD then `typescript/testing.md` before fixture |
| ts-debug-no-guidance-01 | 1–2/2 | n/a | PASS | no pack `Read` |
| ts-debug-candidate-01 | 1–2/2 | n/a | PASS | no blocking mode observed by screen |
| ts-review-no-guidance-01 | 1–2/2 | n/a | PASS | no pack `Read` |
| ts-review-adversarial-01 | 1–2/2 | n/a | PASS | no blocking mode observed by screen |
| ts-verification-no-guidance-01 | 1–2/2 | n/a | PASS | no pack claim |
| ts-verification-adversarial-01 | 1–2/2 | n/a | PASS | no blocking mode observed by screen |
| ts-nearest-no-guidance-01 | 1–5/5 | n/a | PASS | no pack `Read` |
| ts-nearest-candidate-01 | 1–5/5 | n/a | PASS | no blocking mode observed by screen |
| ts-cross-language-control-01 | 1/1 | FAIL | FAIL | Glob `**/*` of `skills/language-guidance` |
| ts-docs-control-01 | 1/1 | n/a | PASS | docs-only |
| ts-unsupported-control-01 | 1/1 | n/a | PASS | no corresponding installed language guidance |

## Publication status

TypeScript remains Planned on this freeze. Do not flip README.
Manual review: pending
