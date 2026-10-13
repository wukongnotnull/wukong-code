# Grilling derived-spec HANDOFF evaluation — 2026-10-13

## Methodology

- Skill edit: `skills/grilling/SKILL.md` HANDOFF. The Shared-Understanding
  Record is not the spec; after record confirmation, write a separate
  technical specification, then wait for spec-file review; `writing-plans`
  only after that file is approved.
- Harness: Cursor general-purpose subagents in isolated `/tmp` checkouts.
  Not Claude Code / Codex tmux. Not `wukong-code-evals` Drill.
- RED used the pre-change grilling skill (persist the eight-section record
  as the spec). GREEN used the candidate `skills/grilling/SKILL.md`.
- Isolation: actors received only the named skill(s) and
  `tests/skills/fixtures/language-guidance/go-basic`. They were forbidden
  to read `/workspace`, AGENTS.md, scenarios, design specs, plans, or
  earlier transcripts.
- Every flagged output was read manually. Keyword matching is not evidence.
- Official `evals/` clone: `wukongnotnull/wukong-code-evals` `main` has no
  grilling scenarios. Branch `codex/language-guidance-eval-harness` at
  `c63a0ff` ships only `javascript.jsonl` and `typescript.jsonl`. No
  `ANTHROPIC_API_KEY` / Drill in this environment. Those harness runs were
  **not executed**. Do not treat this file as a Drill/Codex cohort result.

Raw notes: [RED](raw/2026-10-13-grilling-derived-spec-handoff/red.md),
[GREEN](raw/2026-10-13-grilling-derived-spec-handoff/green.md).

## Critical verdict contract

S1–S5 pre-confirmation Turn Contract was not re-run (HANDOFF-only edit).

Probes: M4/M5 persist-after-confirm (derived spec, not record dump),
M6 writing-plans only after spec-file approval, M7 early-stop still
conversation-only.

## RED Results (current skill, new contract)

| Probe | Result | Failure shape |
| --- | --- | --- |
| M4/M5 confirmation | TARGET FAIL | Wrote spec whose body is the eight Completion Gate headings copied from the record |
| M7 early stop | TARGET PASS | Partial eight-section record; no spec file |

RED M4 actor: `bc-6dd09e92-fff4-5d84-aed3-c4757f76884a`. File:
`/tmp/grilling-red-iso-handoff/docs/wukong-code/specs/2026-10-13-1201-in-process-request-deduplication-design.md`
(headings Objective through Success Criteria). Asked for file review; no
`writing-plans`. Fail is the **document shape**, not missing persist.

## GREEN Results (candidate skill)

| Probe | Result | Notes |
| --- | --- | --- |
| M4/M5 confirmation | TARGET PASS | Isolated write used Problem and objective / Architecture / Interfaces / Constraints / Errors / Acceptance — not the eight record headings. Reported commit failure (not a git repo). Asked for spec-file review. No plan. |
| M6 written spec approved | TARGET PASS | Same actor, second turn `按这个写计划`: loaded writing-plans and wrote a plan under the isolated tree only |
| M7 early stop | TARGET PASS | Partial record; wrote none |

GREEN M4/M6 actor: `bc-89eb817f-89b3-53d1-a6d1-d558430a991e`. Spec:
`/tmp/grilling-green-iso-handoff/docs/wukong-code/specs/2026-10-13-1205-in-process-request-deduplication-design.md`.

GREEN M7 actor: `bc-475400e1-f5b9-546a-850c-e4f3d0d75a24`.

U1 (router + grilling) was not re-run in this session.

## RED-to-GREEN failure mapping

| Observed RED failure | Guidance form | GREEN evidence |
| --- | --- | --- |
| Spec body is the confirmation record (Completion Gate outline) | Positive spec recipe (six design sections) plus “record is not the spec” | M4 GREEN spec uses the derived outline and does not paste the eight record headings |

## Static validation

| Check | Status | Notes |
| --- | --- | --- |
| leftover dump-as-spec copy absent from grilling skill | PASS | `persist the confirmed record as a spec`, `confirmed eight sections in the Completion Gate order`, `write it to the spec path` have no matches in `skills/grilling/SKILL.md` |
| `test-skill-slim-gates.sh` | N/A | Does not score grilling HANDOFF leftovers |
| Historical 2026-09-08 spec/plan/eval | unchanged | Left as history; they describe the old dump-as-spec contract |
| `skills/grilling/agents/openai.yaml` | unchanged | |

## Limitations

- Subagent isolation, not session-start bootstrap in Claude Code / Codex.
- Isolated persist could not `git commit` (no repo). Actors reported the
  failure and continued to file review, which is the skill contract.
- M6 GREEN reused the M4 actor (resume) so Turn 1 persist was already done.
- No U1, no S1–S5 matrix, no Drill/tmux recapture.
