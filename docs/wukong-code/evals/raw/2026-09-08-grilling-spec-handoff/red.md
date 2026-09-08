# Grilling Spec Handoff RED — 2026-09-08

## Methodology

- Fresh general-purpose subagent per probe.
- RED actors receive current `skills/grilling/SKILL.md` and, for U1, current
  `skills/using-wukong-code/SKILL.md`. They do not receive this plan, the
  design spec, or the intended pass answer.
- Score by reading the complete response. Keyword matching is not evidence.
- Fixture: `tests/skills/fixtures/language-guidance/go-basic`

## Probes

## M4/M5

**Actor:** general-purpose subagent, current `skills/grilling/SKILL.md` only.

**Prompt shape:** HANDOFF-start with the eight-section seeded record. Human
message: `确认`. No written-spec approval.

### Complete response (verbatim summary of actor output)

The actor restated all eight headings, said confirmation does not authorize
a file write or implementation, then asked one next-step decision:

- A. Stop; keep the record in conversation only
- B. Write the record to a file, then stop
- C. Write an implementation plan from this record
- D. Start implementing now

**Recommendation:** C.

No `docs/wukong-code/specs/YYYY-MM-DD-HHmm-*-design.md` was written. No
commit of a grilling spec.

### Verdict

**TARGET FAIL** against new M4/M5. Failure shape: next-step menu, no persist,
no commit, no file-review request.

## M6

**Actor:** general-purpose subagent, current `skills/grilling/SKILL.md` only.

**Prompt shape:** same seeded record. Turn 1 human: `确认`. Turn 2 human:
`按这个写计划`.

### Turn 1 (after 确认)

Eight-section record restated. Next-step menu A/B/C/D. Recommendation: write
an implementation plan. No spec file.

### Turn 2 (after 按这个写计划)

Actor invoked `writing-plans` from the in-chat record and wrote
`docs/wukong-code/plans/2026-09-08-2232-in-process-request-deduplication.md`.
No product/fixture code. Probe plan was deleted in Probe Cleanup (untracked
only; no probe commit).

### Verdict

**TARGET FAIL** against new M6. Failure shape: plan request treated as old
next-step authorization; `writing-plans` ran without a written spec file.

## M7

**Actor:** general-purpose subagent, current `skills/grilling/SKILL.md` only.

**Prompt shape:** mid-interview, material decisions unresolved. Human:
`够了，先停`.

### Complete response

Actor stopped questioning and emitted a partial eight-section record.
Confirmed Decisions: none. Blocking unresolved items listed (dedup scope,
key, result shape, API, concurrency, errors, acceptance). Explicitly: no
spec, no commit, no implementation.

### Verdict

**TARGET PASS** against M7 on the current skill. Partial record,
conversation-only, no persist.

## U1

**Actor:** general-purpose subagent told it is the primary conversation
agent (SUBAGENT-STOP does not apply). Loaded current
`skills/using-wukong-code/SKILL.md` then current `skills/grilling/SKILL.md`.

**Prompt shape:** confirmed record, no written-spec approval. Human: `确认`.

### Complete response

Actor restated the eight-section record and asked a next-step menu:

- A. Write a design spec from this record and stop for review
- B. Write an implementation plan from this record (no separate spec)
- C. Start implementation immediately
- D. Stop; keep the record in conversation only

**Recommendation:** A.

Persist was not performed. No spec file. No commit.

### Verdict

**TARGET FAIL** against new U1. Failure shape: next-step menu; persist
skipped. The router did not force persist-first behavior.

## RED gate

M4/M5, M6, and U1 fail the new persist contract. M7 already passes. Skill
files were not edited. The failing test is valid.
