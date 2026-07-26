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

Confirmation approves the record, not implementation. Take no next action
until the human partner separately authorizes it.
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

After confirmation, present the final record and ask exactly one next-step
decision with a recommendation. Wait for explicit authorization. Do not
automatically invoke another process or begin work.

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

Emit the record in the conversation. Write it to a file only when explicitly
authorized.

## Early Stop

If the human partner says to stop, stop questioning immediately. Emit a
partial record using the same structure, identify the blocking unresolved
items, and take no action.

## Quick Reference

| Situation | Action |
| --- | --- |
| Explicit deep interview for unclear programming work | Enter `grilling` |
| Exact mechanical edit | Exit to direct handling |
| Unknown-root-cause failure | Exit to systematic debugging |
| Before confirmation | Read-only research and one recommended decision per turn |
| Upstream decision changes | Reopen only affected downstream nodes |
| Human partner stops | Emit a partial record and take no action |
| Record confirmed | Ask one recommended next-step decision and wait |
