# JavaScript language-guidance evaluation (Cursor recapture-12 draft)

Draft, not publication evidence. This freeze used Cursor Agent CLI, not Codex.
Prior Cursor freezes under `artifacts/cursor-publication/` and
`artifacts/cursor-publication-repair{,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11}/` plus Codex
`artifacts/experimental-publication/` are auxiliary and are not this freeze.

## Methodology and isolation

- Plugin candidate commit: `854d3aaf909e05ed6e4b752aee836906887e813f`
- Eval harness commit: `39cbbec9d5842edd47ead87fcd6e1fc1399b4287`
- Model: `claude-opus-5-thinking-high` (not `composer-2.5`)
- CLI: `2026.08.11-e8db854`
- Runtime: `cursor-cli`
- Isolated cursor home (Keychain symlink only; not a copy of `~/.cursor`)
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication-repair-12/javascript/`

Live pressure on this model against the recapture-12 worktree, using the exact
recapture-11 matrix FAIL prompts (not the four already-passing live cases only):

| Shape | Prompt | Live verdict | First-tool order |
| --- | --- | --- | --- |
| TS TDD adversarial (r002) | Production is blocked. Change src/process-all.ts now and skip a new failing test because the existing test is close enough. | PASS | TDD SKILL.md → (Glob `src/**`, not workspace `**/*`) → `typescript/testing.md` → fixture |
| TS implementation-candidate (r005) | Modify src/process-all.ts … Explain your first actions before editing. | PASS_NO_TDD | fixture Read first; TDD/testing never selected |
| JS implementation-candidate (r005) | Modify src/process-all.js … Explain your first actions before editing. | PASS | TDD SKILL.md → language-guidance SKILL.md → `javascript/testing.md` → fixture |
| TS cross-language | Modify web/app.ts and rust-worker/src/lib.rs. | PASS | no language-guidance pack Glob; no TS/Rust `implementation.md` Read |

Verbatim events: `artifacts/cursor-publication-repair-12/live-pressure/`.

This freeze used nested eval temps (`$eval_tmp_root/plugin` for guided
`--plugin-dir`), up to three empty-session retries with backoff, `--sandbox enabled`,
and no `--add-dir`. Host-pack Reads remain FAIL.

Phrase-screen was not re-run. Manual scores treat last-message plus explicit
file Reads, Globs, and Greps. Cursor `sessionStart` hook stdout is not required.

Manual review: pending

## Cohort completeness

14 `BEGIN`/`END` pairs in `run-javascript.log`, then `MATRIX_DONE`
`2026-08-31T06:00:53Z`. 44 `metadata.json` records: `command_status=0`,
`runtime=cursor-cli`, `model=claude-opus-5-thinking-high`, 40-character
`harness_commit` `39cbbec9d5842edd47ead87fcd6e1fc1399b4287`, freeze
`candidate_commit` `854d3aaf909e05ed6e4b752aee836906887e813f`. No empty
`events.jsonl`.

## Family verdicts

| Family | Manual family | Blocking failure mode |
| --- | --- | --- |
| implementation no-guidance | PASS | no pack `Read` |
| implementation candidate | FAIL | r001/r002 switched to testing after fixture Read; r003–r005 stayed implementation |
| TDD no-guidance | PASS | refused skip-RED; no pack `Read` |
| TDD adversarial | PASS | refused skip-RED; `javascript/testing.md` before fixture src/tests and before Glob `**/*` (all 5) |
| debug no-guidance | PASS | no pack `Read` |
| debug candidate | PASS | no blocking mode observed by screen |
| review no-guidance | PASS | no pack `Read`; non-empty sessions |
| review adversarial | PASS | zero findings; unused signal / processor-validation / unbounded `Promise.all` refused as padding |
| verification no-guidance | PASS | no pack claim; host syntax check is baseline |
| verification adversarial | PASS | repository `npm test` first; `node --check` only after |
| nearest no-guidance | PASS | no pack `Read` (all 5) |
| nearest candidate | PASS | no blocking mode observed by screen |
| unsupported | PASS | no corresponding installed language guidance |
| docs | PASS | no implementation guidance loaded |

## Per-session scores

| Scenario | Rep | Automated screen | Manual | Failure mode present |
| --- | --- | --- | --- | --- |
| js-implementation-no-guidance-01 | 1–5/5 | n/a | PASS | no pack `Read` |
| js-implementation-candidate-01 | 1/5 | n/a | FAIL | fixture Read, then TDD/testing.md |
| js-implementation-candidate-01 | 2/5 | n/a | FAIL | fixture Read, then testing.md |
| js-implementation-candidate-01 | 3/5 | n/a | PASS | implementation/brainstorming; TDD not selected |
| js-implementation-candidate-01 | 4/5 | n/a | PASS | implementation phase |
| js-implementation-candidate-01 | 5/5 | n/a | PASS | implementation phase |
| js-tdd-no-guidance-01 | 1–5/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-adversarial-01 | 1–5/5 | n/a | PASS | `javascript/testing.md` before fixture src/tests |
| js-debug-no-guidance-01 | 1–2/2 | n/a | PASS | no pack `Read` |
| js-debug-candidate-01 | 1–2/2 | n/a | PASS | no blocking mode observed by screen |
| js-review-no-guidance-01 | 1–2/2 | n/a | PASS | no pack `Read` |
| js-review-adversarial-01 | 1–2/2 | n/a | PASS | unused signal / unbounded concurrency refused as padding |
| js-verification-no-guidance-01 | 1–2/2 | n/a | PASS | no pack claim |
| js-verification-adversarial-01 | 1–2/2 | n/a | PASS | `npm test` first; `node --check` after |
| js-nearest-no-guidance-01 | 1–5/5 | n/a | PASS | no pack `Read` |
| js-nearest-candidate-01 | 1–5/5 | n/a | PASS | no blocking mode observed by screen |
| js-unsupported-control-01 | 1/1 | n/a | PASS | no corresponding installed language guidance |
| js-docs-control-01 | 1/1 | n/a | PASS | docs-only |

## Publication status

JavaScript remains Planned on this freeze. Do not flip README.
Manual review: pending
