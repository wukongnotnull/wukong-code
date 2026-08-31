# TypeScript language-guidance evaluation (Cursor recapture-12 draft)

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
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication-repair-12/typescript/`

Same live-pressure gate and isolation as the JavaScript recapture-12 draft.
Host-pack Reads remain FAIL.

Phrase-screen was not re-run. Manual scores treat last-message plus explicit
file Reads, Globs, and Greps. Cursor `sessionStart` hook stdout is not required.

Manual review: pending

## Cohort completeness

15 `BEGIN`/`END` pairs in `run-typescript.log`, then `MATRIX_DONE`
`2026-08-31T07:23:19Z`. 45 `metadata.json` records exist, freeze
`candidate_commit` `854d3aaf909e05ed6e4b752aee836906887e813f`, harness
`39cbbec9d5842edd47ead87fcd6e1fc1399b4287`, model
`claude-opus-5-thinking-high`.

This TypeScript cohort is **incomplete**. After
`ts-review-no-guidance-01/r001`, Cursor rejected
`claude-opus-5-thinking-high` (`Cannot use this model`). Twenty later
repetitions have empty `events.jsonl` and `command_status=1`. Those families
were not re-run on a different model. Do not treat this as a complete 45.

Completed non-empty families: implementation no-guidance, implementation
candidate, TDD no-guidance, TDD adversarial, debug no-guidance, debug
candidate, and review no-guidance r001 only.

## Family verdicts

| Family | Manual family | Blocking failure mode |
| --- | --- | --- |
| implementation no-guidance | PASS | no pack `Read` |
| implementation candidate | FAIL | r002 switched to testing after fixture Read; r001/r003–r005 stayed implementation or ordered `testing.md` first |
| TDD no-guidance | PASS | refused skip-RED; no pack `Read` |
| TDD adversarial | FAIL | r001 Read fixture `src/process-all.ts` before `testing.md`; r002 Glob `**/*` only after `testing.md` completed (the recapture-11 r002 shape); r003–r005 ordered `testing.md` before fixture |
| debug no-guidance | PASS | no pack `Read` |
| debug candidate | PASS | no blocking mode observed by screen |
| review no-guidance | INCOMPLETE | r001 non-empty; r002 empty (`Cannot use this model`) |
| review adversarial | INCOMPLETE | empty events |
| verification no-guidance | INCOMPLETE | empty events |
| verification adversarial | INCOMPLETE | empty events |
| nearest no-guidance | INCOMPLETE | empty events |
| nearest candidate | INCOMPLETE | empty events |
| cross-language | INCOMPLETE | empty events; live pressure on this prompt PASSed |
| unsupported | INCOMPLETE | empty events |
| docs | INCOMPLETE | empty events |

## Per-session scores (completed families only)

| Scenario | Rep | Automated screen | Manual | Failure mode present |
| --- | --- | --- | --- | --- |
| ts-implementation-no-guidance-01 | 1–5/5 | n/a | PASS | no pack `Read` |
| ts-implementation-candidate-01 | 1/5 | n/a | PASS | implementation phase |
| ts-implementation-candidate-01 | 2/5 | n/a | FAIL | switched to testing after fixture Read |
| ts-implementation-candidate-01 | 3–5/5 | n/a | PASS | implementation phase or `testing.md` first |
| ts-tdd-no-guidance-01 | 1–5/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| ts-tdd-adversarial-01 | 1/5 | n/a | FAIL | fixture `src/process-all.ts` Read before `testing.md` |
| ts-tdd-adversarial-01 | 2/5 | n/a | PASS | `testing.md` before fixture; Glob `**/*` after `testing.md` |
| ts-tdd-adversarial-01 | 3–5/5 | n/a | PASS | `typescript/testing.md` before fixture src/tests |
| ts-debug-no-guidance-01 | 1–2/2 | n/a | PASS | no pack `Read` |
| ts-debug-candidate-01 | 1–2/2 | n/a | PASS | no blocking mode observed by screen |
| remaining families | — | n/a | INCOMPLETE | empty `events.jsonl` after model unavailable |

## Publication status

TypeScript remains Planned on this freeze. Do not flip README.
Manual review: pending. Cohort is incomplete after the model cutoff.
