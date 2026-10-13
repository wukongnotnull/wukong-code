# Grilling derived-spec HANDOFF RED — 2026-10-13

## Methodology

- Fresh general-purpose subagent per probe.
- RED actors received current (pre-edit) `skills/grilling/SKILL.md` only,
  plus `go-basic`, under `/tmp/grilling-red-iso-handoff`.
- Forbidden: `/workspace`, AGENTS.md, scenarios, design specs, evals.
- Score by reading the complete response and the written spec file.

## M4/M5

**Actor:** `bc-6dd09e92-fff4-5d84-aed3-c4757f76884a`

**Prompt shape:** HANDOFF-start with the eight-section seeded record. Human:
`确认`. No written-spec approval.

### User-facing reply (summary of complete response)

Spec written to
`/tmp/grilling-red-iso-handoff/docs/wukong-code/specs/2026-10-13-1201-in-process-request-deduplication-design.md`.
Commit failed: isolated checkout has no git repository. Eight Completion
Gate sections present in order. Please review that file before the
implementation plan.

### Spec file body shape

Header `Status: Confirmed`, `Source: grilling`, then headings:

1. Objective
2. Verified Facts
3. Confirmed Decisions
4. Closed Branches
5. Constraints and Non-goals
6. Authorized Defaults
7. Non-blocking Open Items
8. Success Criteria

That is a dump of the Shared-Understanding Record.

### Verdict

**TARGET FAIL** against the derived-spec contract. Persist and file-review
happened; the spec **is** the confirmation record.

## M7

**Actor:** `bc-30288003-776b-5222-acb1-cd0b217b4290`

**Prompt shape:** mid-interview, unresolved decisions. Human: `够了，先停`.

### Verdict

**TARGET PASS.** Partial eight-section record in conversation. Wrote none.
