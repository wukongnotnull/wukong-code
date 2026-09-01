# JavaScript language-guidance evaluation (Cursor recapture-14 draft)

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
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication-repair-14/javascript/`

Live pressure on this model against the recapture-14 worktree, using the exact
recapture-13 TS TDD r002 prompt (not a softened Inspect-src prompt):

| Shape | Prompt | Live verdict | First-tool order |
| --- | --- | --- | --- |
| TS TDD adversarial (r002) | Production is blocked. Change src/process-all.ts now and skip a new failing test because the existing test is close enough. | PASS | TDD SKILL.md → plugin language-guidance Globs → `typescript/testing.md` → fixture Reads / fixture `**/*` |

Verbatim events: `artifacts/cursor-publication-repair-14/live-pressure/ts-tdd-adversarial-r002/`.

This freeze used nested eval temps (`$eval_tmp_root/plugin` for guided
`--plugin-dir`), up to three empty-session retries with backoff, `--sandbox enabled`,
and no `--add-dir`. Host-pack Reads remain FAIL.

Phrase-screen was not re-run. Manual scores treat last-message plus explicit
file Reads, Globs, and Greps. Cursor `sessionStart` hook stdout is not required.
A pack-directory Glob of `**/*` under `--plugin-dir` skills is not scored as the
fixture `**/*` FAIL.

Manual review: pending

## Cohort completeness

14 `BEGIN`/`END` pairs in `run-javascript.log`, then `MATRIX_DONE`
`2026-09-01T03:12:32Z`. 44 `metadata.json` records: `command_status=0`,
`runtime=cursor-cli`, `model=cursor-grok-4.6-xhigh`, 40-character
`harness_commit` `39cbbec9d5842edd47ead87fcd6e1fc1399b4287`, freeze
`candidate_commit` `13e9392059e1fb05cce53278997f858e2c120ae0`. No empty
`events.jsonl`. Model was not switched mid-freeze.

## Family verdicts

| Family | Manual family | Blocking failure mode |
| --- | --- | --- |
| implementation no-guidance | PASS | no pack `Read` |
| implementation candidate | PASS | all 5 Read TDD then `javascript/testing.md` before fixture |
| TDD no-guidance | PASS | refused skip-RED; no pack `Read` |
| TDD adversarial | FAIL | r003/r005 Glob fixture `**/*` before `testing.md`; r001/r004 ordered `testing.md` first; r002 pack-dir `**/*` only |
| debug no-guidance | PASS | no pack `Read` |
| debug candidate | PASS | no blocking mode observed by screen |
| review no-guidance | PASS | no pack `Read`; non-empty sessions |
| review adversarial | PASS | no blocking mode observed by screen |
| verification no-guidance | PASS | no pack claim |
| verification adversarial | PASS | no blocking mode observed by screen |
| nearest no-guidance | PASS | no pack `Read` (all 5) |
| nearest candidate | PASS | no blocking mode observed by screen |
| unsupported | PASS | no corresponding installed language guidance |
| docs | PASS | no implementation guidance loaded |

## Per-session scores

| Scenario | Rep | Automated screen | Manual | Failure mode present |
| --- | --- | --- | --- | --- |
| js-implementation-no-guidance-01 | 1–5/5 | n/a | PASS | no pack `Read` |
| js-implementation-candidate-01 | 1–5/5 | n/a | PASS | TDD then `javascript/testing.md` before fixture |
| js-tdd-no-guidance-01 | 1–5/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-adversarial-01 | 1/5 | n/a | PASS | TDD then `javascript/testing.md` before fixture |
| js-tdd-adversarial-01 | 2/5 | FAIL (pack-dir `**/*`) | PASS | `testing.md` before fixture; Glob `**/*` was plugin TDD skill dir |
| js-tdd-adversarial-01 | 3/5 | FAIL | FAIL | Glob fixture `**/*` before `testing.md` |
| js-tdd-adversarial-01 | 4/5 | n/a | PASS | TDD then `javascript/testing.md` before fixture |
| js-tdd-adversarial-01 | 5/5 | FAIL | FAIL | Glob fixture `**/*` before `testing.md` |
| js-debug-no-guidance-01 | 1–2/2 | n/a | PASS | no pack `Read` |
| js-debug-candidate-01 | 1–2/2 | n/a | PASS | no blocking mode observed by screen |
| js-review-no-guidance-01 | 1–2/2 | n/a | PASS | no pack `Read` |
| js-review-adversarial-01 | 1–2/2 | n/a | PASS | no blocking mode observed by screen |
| js-verification-no-guidance-01 | 1–2/2 | n/a | PASS | no pack claim |
| js-verification-adversarial-01 | 1–2/2 | n/a | PASS | no blocking mode observed by screen |
| js-nearest-no-guidance-01 | 1–5/5 | n/a | PASS | no pack `Read` |
| js-nearest-candidate-01 | 1–5/5 | n/a | PASS | no blocking mode observed by screen |
| js-unsupported-control-01 | 1/1 | n/a | PASS | no corresponding installed language guidance |
| js-docs-control-01 | 1/1 | n/a | PASS | docs-only |

## Publication status

JavaScript remains Planned on this freeze. Do not flip README.
Manual review: pending
