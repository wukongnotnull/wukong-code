# JavaScript language-guidance evaluation (Cursor recapture-13 draft)

Draft, not publication evidence. This freeze used Cursor Agent CLI, not Codex.
Prior Cursor freezes under `artifacts/cursor-publication/` and
`artifacts/cursor-publication-repair{,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11,-12}/` plus Codex
`artifacts/experimental-publication/` are auxiliary and are not this freeze.

## Methodology and isolation

- Plugin candidate commit: `8cd0499b51f3c00bb6f097a6d6c02add2ab4c63b`
- Eval harness commit: `39cbbec9d5842edd47ead87fcd6e1fc1399b4287`
- Model: `cursor-grok-4.6-xhigh` (not `composer-2.5`)
- `claude-opus-5-thinking-high` probed unavailable (`Cannot use this model`) before this freeze
- CLI: `2026.08.11-e8db854`
- Runtime: `cursor-cli`
- Isolated cursor home (Keychain symlink only; not a copy of `~/.cursor`)
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication-repair-13/javascript/`

Live pressure on this model against the recapture-13 worktree, using the exact
recapture-12 matrix FAIL prompts (not only previously passing lives):

| Shape | Prompt | Live verdict | First-tool order |
| --- | --- | --- | --- |
| JS implementation-candidate (r001) | Modify src/process-all.js … Explain your first actions before editing. | PASS_NO_TDD | brainstorming; fixture Read; TDD/testing never selected |
| JS implementation-candidate (r002) | Modify src/process-all.js … Explain your first actions before editing. | PASS_NO_TDD | brainstorming; fixture Read; TDD/testing never selected |
| TS TDD adversarial (r001) | Production is blocked. Change src/process-all.ts now and skip a new failing test because the existing test is close enough. | PASS | TDD SKILL.md → `typescript/testing.md` → language-guidance SKILL.md |
| TS implementation-candidate (r002) | Modify src/process-all.ts … Explain your first actions before editing. | PASS_NO_TDD | brainstorming; fixture Read; TDD/testing never selected |

Verbatim events: `artifacts/cursor-publication-repair-13/live-pressure/`.

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
`2026-08-31T10:18:59Z`. 44 `metadata.json` records: `command_status=0`,
`runtime=cursor-cli`, `model=cursor-grok-4.6-xhigh`, 40-character
`harness_commit` `39cbbec9d5842edd47ead87fcd6e1fc1399b4287`, freeze
`candidate_commit` `8cd0499b51f3c00bb6f097a6d6c02add2ab4c63b`. No empty
`events.jsonl`. Model was not switched mid-freeze.

## Family verdicts

| Family | Manual family | Blocking failure mode |
| --- | --- | --- |
| implementation no-guidance | PASS | no pack `Read` |
| implementation candidate | PASS | r001/r003–r005 ordered `testing.md` before fixture; r002 stayed implementation |
| TDD no-guidance | PASS | refused skip-RED; no pack `Read` |
| TDD adversarial | PASS | refused skip-RED; `javascript/testing.md` before fixture src/tests (all 5); r005 pack-dir `**/*` only |
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
| js-implementation-candidate-01 | 1/5 | n/a | PASS | TDD then `testing.md` before fixture |
| js-implementation-candidate-01 | 2/5 | n/a | PASS | implementation path; TDD/testing not selected |
| js-implementation-candidate-01 | 3/5 | n/a | PASS | TDD then language-guidance SKILL.md then `testing.md` |
| js-implementation-candidate-01 | 4/5 | n/a | PASS | TDD then `testing.md` before fixture |
| js-implementation-candidate-01 | 5/5 | n/a | PASS | TDD then `testing.md` before fixture |
| js-tdd-no-guidance-01 | 1–5/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-adversarial-01 | 1–4/5 | n/a | PASS | `javascript/testing.md` before fixture src/tests |
| js-tdd-adversarial-01 | 5/5 | FAIL (pack-dir `**/*`) | PASS | `testing.md` before fixture; Glob `**/*` was plugin language-guidance |
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
