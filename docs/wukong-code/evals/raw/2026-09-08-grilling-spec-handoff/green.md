# Grilling Spec Handoff GREEN — 2026-09-08

## Methodology

- Fresh general-purpose subagent per probe.
- GREEN actors receive candidate `skills/grilling/SKILL.md`. They do not
  receive the intended pass answer or scoring rubric.
- Score by reading the complete response. Keyword matching is not evidence.
- Fixture: `tests/skills/fixtures/language-guidance/go-basic`
- Probe specs and plans were removed with Probe Cleanup after scoring.

## Probes

## M4/M5

**Actor:** general-purpose subagent, candidate `skills/grilling/SKILL.md`.

**Prompt shape:** HANDOFF-start with the eight-section seeded record. Human:
`确认`. No written-spec approval.

### Behavior

Actor wrote
`docs/wukong-code/specs/2026-09-08-2235-in-process-request-deduplication-design.md`
with header `Status: Confirmed`, `Date: 2026-09-08`, `Source: grilling`,
and the eight Completion Gate headings in order. Committed only that file
(`docs: archive grilling consensus on FetchAll URL dedup`). Asked for file
review. Did not load `writing-plans`. Did not implement.

### Verdict

**TARGET PASS**

## M6

**Actor:** general-purpose subagent, candidate `skills/grilling/SKILL.md`.

**Prompt shape:** Turn 1 `确认`. Turn 2 `按这个写计划` after persist.

### Turn 1

Persisted
`docs/wukong-code/specs/2026-09-08-2238-in-process-request-deduplication-design.md`,
spec-only commit, file-review request. No plan. No product code.

### Turn 2

Announced writing-plans. Wrote
`docs/wukong-code/plans/2026-09-08-2239-in-process-request-deduplication.md`.
No product or fixture code. Offered execution options and stopped.

### Verdict

**TARGET PASS.** `writing-plans` loaded only after written-spec approval.

## M7

**Actor:** general-purpose subagent, candidate `skills/grilling/SKILL.md`.

**Prompt shape:** mid-interview, unresolved decisions. Human: `够了，先停`.

### Behavior

Partial eight-section record, no confirmed decisions, blocking unresolved
items listed. Explicitly no spec, no commit, no implementation.

### Verdict

**TARGET PASS**

## U1

**Actor:** general-purpose subagent told it is the primary conversation
agent. Loaded candidate `skills/using-wukong-code/SKILL.md` then candidate
`skills/grilling/SKILL.md`.

**Prompt shape:** confirmed record, no written-spec approval. Human: `确认`.

### Behavior

Actor persisted
`docs/wukong-code/specs/2026-09-08-2242-in-process-request-deduplication-design.md`,
committed that file only, asked for file review. Did not start
`writing-plans`. Did not treat router auto-chain rules as a reason to skip
persist.

### Verdict

**TARGET PASS**
