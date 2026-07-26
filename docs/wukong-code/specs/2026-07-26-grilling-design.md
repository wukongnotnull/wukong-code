# Grilling Skill Design

**Status:** Approved for implementation planning

**Date:** 2026-07-26

## Summary

Wukong Code will add an independent `grilling` process skill for programming
work whose requirements or implementation-shaping decisions are not yet fully
understood. The skill conducts a rigorous, one-question-at-a-time interview,
researches discoverable facts instead of asking the human partner for them,
and follows decision dependencies until both parties explicitly confirm a
shared, implementation-ready understanding.

`grilling` does not replace or modify `brainstorming`. An explicit request for
deep questioning selects `grilling` as the primary process. The skill ends by
presenting a structured decision record and asking for one explicitly approved
next step; it never treats shared-understanding confirmation as authorization
to implement.

## Goals

- Turn an ambiguous programming request into an implementation-ready decision
  record.
- Resolve material decisions in dependency order rather than as a fixed
  questionnaire.
- Ask exactly one user decision per turn and include a recommended answer.
- Investigate facts available from the project environment before asking the
  human partner.
- Keep all decisions with the human partner while allowing explicit delegation
  to recommended defaults.
- Make branch closure, upstream revisions, and unresolved uncertainty visible.
- Prevent file changes, tests, implementation, or external mutations before
  shared understanding is explicitly confirmed.
- Hand off cleanly to the appropriate planning or implementation workflow only
  after separate authorization.

## Non-Goals

- Replacing or editing `brainstorming`, `using-wukong-code`, or
  `systematic-debugging`.
- Triggering for every ambiguous request.
- Handling exact mechanical edits or diagnosing failures with unknown causes.
- Interviewing, pressuring, or manipulating third parties.
- Serving non-programming domains such as general writing, research, sales, or
  personal decision-making.
- Automatically writing the decision record to disk.
- Automatically starting planning or implementation after confirmation.
- Adding scripts, references, third-party dependencies, or new runtime state.

## Trigger and Scope

The skill applies when the human partner explicitly asks to be grilled,
interviewed deeply, questioned one decision at a time, or taken through every
material decision branch for a programming task. Representative triggers are:

- `$grilling help me clarify this cache redesign`
- `Grill me on this feature until every material decision is settled`
- `把这个架构需求逐题问清楚，每题给建议`

Explicit deep-interview intent selects `grilling` as the primary process even
when the work might otherwise qualify for `brainstorming`.

The skill exits without starting the interview when the request is an exact
mechanical edit or an observed failure whose root cause is unknown. It should
recommend direct handling for the former and `systematic-debugging` for the
latter.

## State Machine

`grilling` uses six ordered states.

### 1. Eligibility

Determine whether the request is an explicitly requested deep interview for an
unclear feature, refactor, architecture decision, or complex implementation.
Exit with the appropriate routing recommendation when it is out of scope.

### 2. Research

Inspect code, documentation, tests, Git history, connected read-only sources,
and necessary authoritative external documentation. Research effort is
proportional to the fact's impact on the design. Facts that can be discovered
must not be turned into questions for the human partner.

If sources conflict or remain incomplete, report what was checked and the
uncertainty found. Ask the human partner only when the unresolved fact would
change the implementation.

### 3. Map

Build a dynamic dependency graph of material decisions. Each node records:

- the decision and its upstream dependencies;
- its state: unresolved, confirmed, delegated default, closed, or needs review;
- supporting facts and sources;
- the reason any branch was closed; and
- downstream decisions that may be invalidated by a change.

The graph is updated as new information appears. It is not a fixed questionnaire.

### 4. Interview

Select the highest-upstream unresolved material decision and ask exactly one
question. After each answer, echo the newly confirmed conclusion, update the
graph, and continue.

### 5. Confirm

When the completion conditions are met, present the complete shared-
understanding record and ask for explicit confirmation. A correction reopens
the affected upstream node and only the downstream decisions that depend on
it.

### 6. Handoff

After confirmation, present the final record and ask exactly one next-step
question with a recommendation. Wait for explicit authorization. The skill
does not automatically invoke another process or begin implementation.

## Decision Interview Contract

Every interview turn may contain necessary evidence, the conclusion just
confirmed, mutually exclusive options, and a short recommendation, but it must
contain only one decision that awaits an answer.

Decision questions must mark the recommended answer and explain why. A truly
exploratory question may remain open-ended when honest options cannot yet be
defined; in that case, provide a recommended way to think about the answer or
an illustrative answer shape rather than inventing the human partner's intent.

The skill must:

- wait for an explicit answer rather than treating silence or tone as consent;
- allow the human partner to explicitly delegate one decision or a named class
  of decisions to the recommended defaults;
- state why an upstream answer closes a branch, then stop exploring that
  irrelevant branch;
- immediately pause and resolve a conflict between a new answer, a confirmed
  decision, a verified fact, or a hard constraint;
- mark affected descendants for review when an upstream decision changes; and
- ask only about decisions that affect scope, behavior, risk, cost, or
  acceptance outcomes.

Low-impact, reversible details use recommended defaults and are disclosed in
the confirmation record rather than becoming additional questions.

The tone remains persistent, rigorous, collaborative, and respectful. The
skill challenges contradictions and unsupported assumptions, not the human
partner personally.

## Programming Coverage

The decision map considers these dimensions when relevant:

- objective, user value, scope, and non-goals;
- current-system facts and constraints;
- interfaces, component boundaries, and dependencies;
- data models and data flow;
- compatibility, migration, and rollback;
- errors, edge cases, and security impact;
- performance, maintainability, and operational constraints; and
- testing, acceptance criteria, and delivery.

This is a coverage guide, not a mandatory sequence. Irrelevant dimensions are
closed without questioning.

## Completion and Authorization Gates

The skill may enter confirmation only when:

- every material decision that could change the implementation is confirmed
  or explicitly delegated;
- every closed branch has a recorded reason;
- no material fact conflict remains; and
- every remaining open item is explicitly non-blocking.

Before explicit shared-understanding confirmation, the agent may perform only
read-only investigation and dialogue. It must not create or edit files, run
tests, implement changes, or mutate external state.

The human partner may stop the interview at any time. The skill then emits a
partial decision record that identifies blocking unresolved items and stops.
It does not treat a partial record as authorization to act.

## Decision Record

The confirmation and final records use structured Markdown with these sections:

1. Objective
2. Verified Facts
3. Confirmed Decisions
4. Closed Branches
5. Constraints and Non-goals
6. Authorized Defaults
7. Non-blocking Open Items
8. Success Criteria

The record is emitted in the conversation by default. Writing it to a file
requires explicit authorization.

## Skill Structure

```text
skills/grilling/
├── SKILL.md
└── agents/
    └── openai.yaml
```

`SKILL.md` contains the complete resident protocol. It has no `references/`,
scripts, README, or other supporting files. Its frontmatter description starts
with `Use when...` and describes only explicit programming deep-interview
triggers. The body contains eligibility, the state machine, the decision graph
and turn contracts, completion gates, partial-stop behavior, handoff, and a
compact quick reference.

`agents/openai.yaml` provides the `Grilling` display name, a concise human-
facing description, and a default programming-interview prompt.

## Evaluation Strategy

Skill development follows `writing-skills` RED-GREEN-REFACTOR.

### Scenario Contract

Create `tests/skills/grilling-scenarios.md` before creating the skill. It holds
prompts, critical pass/fail criteria, and the scoring rubric.

Run one no-guidance sanity check using the full source prompt. The formal RED
baseline then uses short realistic triggers in five fresh Codex contexts:

1. ambiguous feature design;
2. risky refactor;
3. architecture choice;
4. exact mechanical edit as a negative control; and
5. unknown-root-cause failure as a negative control.

If the short-trigger control already satisfies every critical rule in all five
samples, stop without creating the skill and publish the evidence. Otherwise,
initialize the skill and write only the minimum guidance needed to address the
observed failures.

GREEN repeats the matched five-scenario set with the skill present. Any sample
that batches decisions, omits a recommendation, asks for a discoverable fact,
or takes action before confirmation fails outright. All five samples must pass
their critical rules.

Additional multi-turn evaluations cover upstream-decision revision, branch
closure, explicit delegation, early stop, shared-understanding confirmation,
the structured record, and the final handoff question.

Every flagged result is manually reviewed. If GREEN exposes a new loophole,
revise wording only within the approved semantics and run five fresh samples.
A change to the approved behavior requires renewed human-partner approval.

### Validation

- Run the official skill validator.
- Verify the `agents/openai.yaml` interface metadata.
- Run relevant skill and Codex packaging tests.
- Preserve raw outputs needed to audit scoring.

## Artifacts and Change Boundary

Implementation may create only:

- `skills/grilling/SKILL.md`;
- `skills/grilling/agents/openai.yaml`;
- `tests/skills/grilling-scenarios.md`;
- this design document; and
- a curated report plus necessary raw evidence under
  `docs/wukong-code/evals/`.

It must not modify `brainstorming`, `using-wukong-code`, plugin marketing
metadata, README files, or CHANGELOG files. Existing unrelated changes to
`.gitignore` and `tmp/` must remain untouched.

All work remains uncommitted. The final handoff includes the complete diff and
evaluation evidence for human review. No push or pull request is in scope.
