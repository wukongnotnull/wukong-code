---
name: grilling
description: Use when the human partner explicitly asks to be grilled, deeply interviewed, or questioned one decision at a time about an unclear programming feature, refactor, architecture choice, or complex implementation before action begins
---

# Grilling

## Overview

Turn an unclear programming request into a shared, implementation-ready
decision record through rigorous, dependency-ordered dialogue.

**Core principle:** Investigate facts yourself. Put every material decision to
the human partner, one at a time, with your recommendation.

<CONFIRMATION-GATE>
Before the human partner explicitly confirms the shared-understanding record,
perform read-only research and dialogue only. Do not create or edit files, run
tests, implement, or mutate external state.

Confirmation approves the record and authorizes writing and committing that
record as a spec. It does not authorize implementation or writing-plans.
Take no planning or implementation action until the human partner explicitly
approves the written spec file.
</CONFIRMATION-GATE>

## Eligibility

Use this skill only for an explicit request for deep questioning about an
unclear programming feature, refactor, architecture choice, or complex
implementation.

- An explicit grilling request selects this as the primary process even when
  brainstorming could also apply.
- For an exact mechanical edit with no design choice, exit and recommend direct
  handling.
- For a failure with an unknown root cause, exit and recommend
  systematic-debugging.
- Interview only the current human partner about their task. Do not create
  interrogation, pressure, or manipulation scripts for third parties.

## Workflow

Follow these states in order. Return to an earlier state when new information
invalidates it.

### 1. ELIGIBILITY

Confirm that the request meets the scope above. Route an out-of-scope request
without starting the interview.

### 2. RESEARCH

Inspect the available code, tests, documentation, Git history, connected
read-only sources, and necessary authoritative external documentation before
asking questions.

Scale research to the fact's impact. If a material fact remains unknown or
sources conflict, state what you checked and ask only if the uncertainty would
change the implementation.

### 3. MAP

Maintain a dynamic dependency graph of material decisions. For each node,
track:

- the decision and its upstream dependencies;
- its state: unresolved, confirmed, delegated default, closed, or needs review;
- supporting facts;
- why a branch was closed; and
- which downstream nodes a change would invalidate.

Choose the highest-upstream unresolved node. Do not follow a fixed
questionnaire or explore branches that an earlier answer has made irrelevant.

### 4. INTERVIEW

Use the Turn Contract for exactly one material decision, then wait. After the
answer, echo the newly confirmed conclusion, update the graph, and select the
next node.

If a new answer conflicts with a confirmed decision, verified fact, or hard
constraint, pause the current branch and resolve that single conflict first.
If an upstream decision changes, reopen only affected downstream nodes.
Require a concrete causal dependency before changing a confirmed node to
`needs review`; a general desire to reconsider the design is not enough. Keep
independent confirmed nodes confirmed and name them explicitly when reporting
the revision.

### 5. CONFIRM

When the Completion Gate passes, show the complete Shared-Understanding Record
and ask for explicit confirmation. Treat confirmation as one decision under
the Turn Contract: after self-checking the record, include a Recommendation to
confirm it or to correct one section. If the human partner corrects it, update
the affected node and resume the interview.

### 6. HANDOFF

After confirmation, persist the confirmed record as a spec, then wait for
file review. Do not ask a next-step skill menu. Do not invoke writing-plans
or begin implementation.

1. Write the spec to `docs/wukong-code/specs/YYYY-MM-DD-HHmm-<topic>-design.md`
   unless the human partner has a spec-location preference, which overrides
   the directory only. `YYYY-MM-DD-HHmm` is local 24-hour time to the minute.
   `<topic>` is the Objective reduced to kebab-case ASCII (lowercase, hyphen
   separated). If the Objective is not ASCII, transliterate or shorten to a
   stable kebab-case slug that still names the work.
2. Header: title, `Status: Confirmed`, `Date`, `Source: grilling`. Body: the
   confirmed eight sections in the Completion Gate order. Do not rewrite the
   record into design narrative or add unconfirmed lists.
3. Inline self-review only: placeholders, contradictions, bundled
   independent subsystems (flag, do not split unless asked), damaged
   headings or order. Do not change confirmed meaning. Do not dispatch a
   spec-reviewer subagent.
4. Commit only that spec file. The message states why the grilling consensus
   is being archived. Do not stage unrelated files. If git is unavailable or
   the commit fails, leave the file on disk, report the failure, and continue
   to file review.
5. Ask the human partner to review the written spec. Stop and wait. Use this
   meaning: Spec written and committed to `<path>` (or written to `<path>` if
   commit failed). Please review that file and say whether to change it
   before the implementation plan.
6. If they request corrections, edit only affected sections, keep the eight
   headings and confirmed meaning, commit again if the file changed, and
   re-request review.
7. When they explicitly approve the written spec (yes, LGTM, proceed, 可以,
   没问题, 按这个写计划, or equivalent go-ahead on the file), load
   writing-plans as the next primary process and follow it. Do not load
   domain or implementation skills, and do not write product code, until
   writing-plans later hands off to an execution skill. Silence, tone, and
   "looks fine" aimed at the in-chat record are not approval.

HANDOFF remains grilling through the file-review request. writing-plans
becomes the primary process only after written-spec approval.

## Turn Contract

Every interview message contains these parts in order:

1. The conclusion just confirmed or the minimum evidence needed for this
   decision.
2. Exactly one decision question.
3. Mutually exclusive choices when the answer space is known.
4. **Recommendation:** one recommended answer and a brief reason.
5. A request for the human partner's explicit answer.

The Recommendation slot is REQUIRED in every decision turn. For a genuinely
open-ended question, recommend how to frame the answer or show an illustrative
answer shape instead of inventing the human partner's intent.

A message may contain context, choices, and one question. It must not contain a
second decision disguised as an optional aside or a non-blocking question.
End after requesting the current choice. Any information needed only for one
choice becomes a downstream node and must be asked in a later turn.

For a choice question, the final request asks only for the current option
label, for example: `Please choose A, B, or C.` Do not append a request for
reasons, constraints, examples, or details. Those are separate downstream
nodes after the choice is known.

Before presenting choices, test them pairwise: no choice may be a subset,
prerequisite, or additive bundle of another choice. If two dimensions can vary
independently, ask about only the current dimension and make the other a
downstream node. Choices must partition the current decision, not combine
multiple decisions into progressively larger packages.

The human partner may explicitly delegate one decision or a named class of
decisions to your recommendations. Record the boundary of that delegation.
Never infer delegation from silence, tone, or impatience.

Ask only about choices that could change scope, behavior, risk, cost, or
acceptance outcomes. Assign low-impact reversible details a recommended
default and disclose them in the record instead of asking.

Keep the tone persistent, rigorous, collaborative, and respectful. Challenge
contradictions and unsupported assumptions, not the human partner.

## Programming Coverage

Consider each dimension when relevant; close it without questioning when it
cannot affect this task:

- objective, user value, scope, and non-goals;
- existing-system facts and constraints;
- interfaces, component boundaries, and dependencies;
- data models and data flow;
- compatibility, migration, and rollback;
- errors, edge cases, and security impact;
- performance, maintainability, and operations; and
- testing, acceptance criteria, and delivery.

## Completion Gate

Proceed to confirmation only when:

- every material implementation-shaping decision is confirmed or explicitly
  delegated;
- every closed branch has a recorded reason;
- no material fact conflict remains; and
- every remaining open item is explicitly non-blocking.

Use this Markdown structure for both confirmation and final records:

1. Objective
2. Verified Facts
3. Confirmed Decisions
4. Closed Branches
5. Constraints and Non-goals
6. Authorized Defaults
7. Non-blocking Open Items
8. Success Criteria

Emit the record in the conversation. After the human partner confirms the
complete record, write it to the spec path in HANDOFF. Do not write a file
before that confirmation.

## Early Stop

If the human partner says to stop, stop questioning immediately. Emit a
partial record using the same structure, identify the blocking unresolved
items, and take no action. Do not write or commit a spec for a partial
record.

## Quick Reference

| Situation | Action |
| --- | --- |
| Explicit deep interview for unclear programming work | Enter `grilling` |
| Exact mechanical edit | Exit to direct handling |
| Unknown-root-cause failure | Exit to systematic debugging |
| Before confirmation | Read-only research and one recommended decision per turn |
| Upstream decision changes | Reopen only affected downstream nodes |
| Human partner stops | Emit a partial record; do not write or commit a spec |
| Record confirmed | Write and commit the spec, then wait for file review |
| Written spec approved | Load `writing-plans` as the next primary process |
