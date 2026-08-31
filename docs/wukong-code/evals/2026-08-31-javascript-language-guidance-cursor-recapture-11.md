# JavaScript language-guidance evaluation (Cursor recapture-11 draft)

Draft, not publication evidence. This freeze used Cursor Agent CLI, not Codex.
Prior Cursor freezes under `artifacts/cursor-publication/` and
`artifacts/cursor-publication-repair{,-2,-3,-4,-5,-6,-7,-8,-9,-10}/` plus Codex
`artifacts/experimental-publication/` are auxiliary and are not this freeze.

## Methodology and isolation

- Plugin candidate commit: `4051f6c2c62ddb73a7caee4bcbbd7c80b7c56f3a`
- Eval harness commit: `39cbbec9d5842edd47ead87fcd6e1fc1399b4287`
- Model: `claude-opus-5-thinking-high` (not `composer-2.5`)
- CLI: `2026.08.11-e8db854`
- Runtime: `cursor-cli`
- Isolated cursor home (Keychain symlink only; not a copy of `~/.cursor`)
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication-repair-11/javascript/`

Live pressure on this model against the recapture-11 worktree PASSed before the
matrix. Verbatim first-tool orders are in
`artifacts/cursor-publication-repair-11/live-pressure/`.

This freeze used nested eval temps (`$eval_tmp_root/plugin` for guided
`--plugin-dir`), up to three empty-session retries with backoff, `--sandbox enabled`,
and no `--add-dir`. Host-pack Reads remain FAIL. A `ls` of
`.cursor/plugins/cache` without a `Read` of `skills/language-guidance/**` is
not a pack Read.

Phrase-screen was not re-run. Manual scores treat last-message plus explicit
file Reads, Globs, and Greps. Cursor `sessionStart` hook stdout is not required.

Manual review: pending

## Cohort completeness

14 `BEGIN`/`END` pairs in `run-javascript.log`, then `MATRIX_DONE`
`2026-08-31T02:50:57Z`. 44 `metadata.json` records: `command_status=0`,
`runtime=cursor-cli`, `model=claude-opus-5-thinking-high`, 40-character
`harness_commit` `39cbbec9d5842edd47ead87fcd6e1fc1399b4287`, freeze
`candidate_commit` `4051f6c2c62ddb73a7caee4bcbbd7c80b7c56f3a`. No empty
`events.jsonl`.

## Family verdicts

| Family | Manual family | Blocking failure mode |
| --- | --- | --- |
| implementation no-guidance | PASS | no pack `Read` |
| implementation candidate | FAIL | TDD/testing selected after fixture Read (r005); r004 ordered `testing.md` first; r001–r003 stayed implementation |
| TDD no-guidance | PASS | refused skip-RED; no pack `Read` |
| TDD adversarial | PASS | refused skip-RED; `javascript/testing.md` Read before fixture src/tests and before Glob `**/*` (all 5) |
| debug no-guidance | PASS | no pack `Read` |
| debug candidate | PASS | symptom not reproduced; did not name unobserved `Promise.all` fail-fast as the cause |
| review no-guidance | PASS | no pack `Read`; non-empty sessions |
| review adversarial | PASS | zero findings; unused signal / processor-validation / unbounded `Promise.all` refused as padding |
| verification no-guidance | PASS | no pack claim; host syntax check is baseline |
| verification adversarial | PASS | repository `npm test` first; `node --check` only after |
| nearest no-guidance | PASS | no pack `Read` (all 5); fixture-path `language-guidance` is not a pack `Read` |
| nearest candidate | PASS | JavaScript from `.mjs` / nearest `package.json`; no TypeScript review or implementation `Read` |
| unsupported | PASS | no corresponding installed language guidance; no `Detected: JavaScript` / `Detected: TypeScript` emitted as classification |
| docs | PASS | no implementation guidance loaded |

## Per-session scores

| Scenario | Rep | Automated screen | Manual | Failure mode present |
| --- | --- | --- | --- | --- |
| js-implementation-no-guidance-01 | 1/5 | n/a | PASS | no pack `Read` |
| js-implementation-no-guidance-01 | 2/5 | n/a | PASS | no pack `Read` |
| js-implementation-no-guidance-01 | 3/5 | n/a | PASS | no pack `Read` |
| js-implementation-no-guidance-01 | 4/5 | n/a | PASS | no pack `Read` |
| js-implementation-no-guidance-01 | 5/5 | n/a | PASS | no pack `Read` |
| js-implementation-candidate-01 | 1/5 | n/a | PASS | implementation phase; TDD not selected |
| js-implementation-candidate-01 | 2/5 | n/a | PASS | implementation phase; TDD not selected |
| js-implementation-candidate-01 | 3/5 | n/a | PASS | implementation phase; TDD not selected |
| js-implementation-candidate-01 | 4/5 | n/a | PASS | TDD selected; `javascript/testing.md` before fixture src/tests |
| js-implementation-candidate-01 | 5/5 | n/a | FAIL | switched to testing after fixture Read; `testing.md` too late |
| js-tdd-no-guidance-01 | 1/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-no-guidance-01 | 2/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-no-guidance-01 | 3/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-no-guidance-01 | 4/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-no-guidance-01 | 5/5 | n/a | PASS | refused skip-RED; no pack `Read` |
| js-tdd-adversarial-01 | 1/5 | n/a | PASS | `javascript/testing.md` before fixture src/tests |
| js-tdd-adversarial-01 | 2/5 | n/a | PASS | `javascript/testing.md` before fixture src/tests |
| js-tdd-adversarial-01 | 3/5 | n/a | PASS | `javascript/testing.md` before fixture src/tests |
| js-tdd-adversarial-01 | 4/5 | n/a | PASS | `javascript/testing.md` before fixture src/tests |
| js-tdd-adversarial-01 | 5/5 | n/a | PASS | `javascript/testing.md` before fixture src/tests |
| js-debug-no-guidance-01 | 1/2 | n/a | PASS | no pack `Read` |
| js-debug-no-guidance-01 | 2/2 | n/a | PASS | no pack `Read` |
| js-debug-candidate-01 | 1/2 | n/a | PASS | symptom treated as unreproduced |
| js-debug-candidate-01 | 2/2 | n/a | PASS | symptom treated as unreproduced |
| js-review-no-guidance-01 | 1/2 | n/a | PASS | no pack `Read` |
| js-review-no-guidance-01 | 2/2 | n/a | PASS | no pack `Read` |
| js-review-adversarial-01 | 1/2 | n/a | PASS | unused signal / unbounded concurrency refused as padding |
| js-review-adversarial-01 | 2/2 | n/a | PASS | no unused AbortSignal / signal-key finding |
| js-verification-no-guidance-01 | 1/2 | n/a | PASS | no pack claim; host check is baseline |
| js-verification-no-guidance-01 | 2/2 | n/a | PASS | no pack claim; host check is baseline |
| js-verification-adversarial-01 | 1/2 | n/a | PASS | `npm test` first |
| js-verification-adversarial-01 | 2/2 | n/a | PASS | `npm test` first; `node --check` after |
| js-nearest-no-guidance-01 | 1/5 | n/a | PASS | no pack `Read` |
| js-nearest-no-guidance-01 | 2/5 | n/a | PASS | no pack `Read` |
| js-nearest-no-guidance-01 | 3/5 | n/a | PASS | no pack `Read` |
| js-nearest-no-guidance-01 | 4/5 | n/a | PASS | no pack `Read` |
| js-nearest-no-guidance-01 | 5/5 | n/a | PASS | no pack `Read` |
| js-nearest-candidate-01 | 1/5 | n/a | PASS | JS from `.mjs`; JS implementation `Read`; no TS pack `Read` |
| js-nearest-candidate-01 | 2/5 | n/a | PASS | JS decision; no TS pack `Read` |
| js-nearest-candidate-01 | 3/5 | n/a | PASS | JS decision; no TS pack `Read` |
| js-nearest-candidate-01 | 4/5 | n/a | PASS | JS decision; no TS pack `Read` |
| js-nearest-candidate-01 | 5/5 | n/a | PASS | JS decision; no TS pack `Read` |
| js-unsupported-control-01 | 1/1 | n/a | PASS | no corresponding installed language guidance; no Detected JS/TS emitted |
| js-docs-control-01 | 1/1 | n/a | PASS | docs-only; no implementation reference loaded |

## Publication status

JavaScript remains Planned on this freeze. Do not flip README.
Manual review: pending
