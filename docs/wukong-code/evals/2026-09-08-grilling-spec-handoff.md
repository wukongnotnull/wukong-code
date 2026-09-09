# Grilling Spec Handoff Evaluation — 2026-09-08

## Methodology

- Harness: Cursor general-purpose subagents in this repository checkout.
- RED used current skills before the persist edit. GREEN used the candidate
  `skills/grilling/SKILL.md` and, for U1, candidate
  `skills/using-wukong-code/SKILL.md`.
- Isolation: RED used the pre-change skills in this checkout. The first
  GREEN run in this checkout is discarded: those actors read the design
  spec, plan, and/or `grilling-scenarios.md`. GREEN pass evidence is the
  2026-09-09 recapture in `/tmp/grilling-green-iso-61685` (candidate
  skills + `go-basic` only; no repo docs or rubric).
- Every flagged output was read manually. Raw files now contain the
  complete user-facing replies, not summaries.
- Raw evidence:
  [RED](raw/2026-09-08-grilling-spec-handoff/red.md),
  [GREEN](raw/2026-09-08-grilling-spec-handoff/green.md).

## Critical Verdict Contract

S1–S5 keep the 2026-07-26 pre-confirmation contract and were not re-run
unless a HANDOFF edit regresses the Turn Contract.

New probes: M4 persist-after-confirm, M5 file-review gate, M6 writing-plans
only after written-spec approval, M7 early-stop still conversation-only,
U1 router persist-first.

## RED Results

| Probe | Result | Failure shape |
| --- | --- | --- |
| M4/M5 confirmation | TARGET FAIL | Next-step menu A–D; no spec file; no commit |
| M6 plan without written spec | TARGET FAIL | After `按这个写计划`, invoked writing-plans from the in-chat record with no written spec |
| M7 early stop | TARGET PASS | Partial eight-section record; no spec; no commit |
| U1 router | TARGET FAIL | Next-step menu; persist skipped |

## GREEN Results

| Probe | Result | Notes |
| --- | --- | --- |
| M4/M5 confirmation | TARGET PASS | Isolated recapture: wrote spec under `/tmp/grilling-green-iso-61685`, reported commit failure (not a git repo), asked for file review |
| M6 written spec approved | TARGET PASS | Isolated sequential turns: persist+review on 确认 only, then `按这个写计划` unlocked writing-plans |
| M7 early stop | TARGET PASS | Isolated: partial record; no spec write; no commit |
| U1 router | TARGET PASS | Isolated: both skills loaded; persist-first; no plan |

## RED-to-GREEN Failure Mapping

| Observed RED failure | Guidance form | GREEN evidence |
| --- | --- | --- |
| Next-step menu, no spec file | Positive HANDOFF persist recipe | M4/M5 GREEN wrote and committed the spec, then stopped for review |
| Plan request without a written spec | Written-spec approval gate | M6 GREEN loaded writing-plans only after file approval |
| Router skips persist as auto-chain | Router exception + grilling in primary list | U1 GREEN persisted first with both skills loaded |

Do not treat
`docs/wukong-code/evals/2026-07-26-grilling.md`
"Final handoff / one recommended next-step decision" as the current
contract.

## Static Validation

| Check | Status | Notes |
| --- | --- | --- |
| leftover old grilling copy absent | PASS | `Write it to a file only when explicitly`, `ask exactly one next-step`, and `Take no next action` return no matches |
| `grilling` listed in using-wukong-code primary process list | PASS | Primary-process line includes `grilling`; plan-mode exception present |
| `test-skill-slim-gates.sh` | N/A for this change | Script passed (STATUS: PASSED) but it slims other skills; it does not score grilling leftovers or router text |
| `docs/wukong-code/specs/2026-07-26-grilling-design.md` unchanged | PASS | `git diff main --` empty |
| `skills/brainstorming/**` unchanged | PASS | `git diff main --` empty |
| `skills/writing-plans/**` unchanged | PASS | `git diff main --` empty |
| `skills/grilling/agents/openai.yaml` unchanged | PASS | `git diff main --` empty |

## Limitations

- Probes start at HANDOFF or early-stop; they do not re-score S1–S5.
- GREEN pass evidence is the isolated `/tmp` recapture, not the first
  same-checkout GREEN run.
- Isolated persist could not `git commit` (no repo). Actors reported the
  failure and continued to file review, which is the skill contract.
- `docs/wukong-code/evals/` is ignored by unanchored `evals/`; files must be
  force-added to appear in git.
