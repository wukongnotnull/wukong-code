# Grilling Consensus Spec Handoff

**Status:** Approved for implementation planning

**Date:** 2026-09-08

**Source:** brainstorming (this change); runtime source of grilling records remains `grilling`

## Summary

After the human partner confirms a complete grilling Shared-Understanding
Record, `grilling` must archive that record as a spec file, commit it, and
wait for review of the written file. Approval of the written spec — not
confirmation of the in-chat record — is the authorization to invoke
`writing-plans`.

`using-wukong-code` must name this terminal path so the global router does not
keep treating "record confirmed" as "stop and wait" or as a forbidden
auto-chain.

This change supersedes one 2026-07-26 non-goal: automatically writing the
decision record to disk. Confirmation now requires that persist.

It does **not** invert the 2026-07-26 rule against starting planning or
implementation at confirmation time. Confirmation still must not invoke
`writing-plans` or implement. The 2026-07-26 HANDOFF that only asks one
next-step question is replaced by persist → file review → `writing-plans`
after written-spec approval.

The 2026-07-26 document stays historical. Do not edit it. The new behavior is
defined only here.

## Problem

A confirmed grilling record is implementation-ready, but it lives only in the
conversation. `writing-plans` expects a durable spec. The current HANDOFF asks
one next-step question and forbids any automatic process, so the consensus
often never becomes a file and never reaches an implementation plan.

`using-wukong-code` currently omits `grilling` from both the Scope routing
table and the "exactly one primary process skill" list. Agents that load the
router after a confirmed record can stall, or refuse the persist → plan
sequence as an illegal skill chain.

## Goals

- Persist a confirmed complete Shared-Understanding Record as a spec file.
- Commit that spec file immediately after inline self-review.
- Stop and wait for the human partner to review the written spec.
- Invoke `writing-plans` only after the written spec is approved.
- Keep confirmation-before-persist read-only.
- Keep early-stop and partial records conversation-only.
- Align `using-wukong-code` so grilling's persist and plan handoff are the
  intended terminal path, not an auto-chain violation.

## Non-Goals

- Replacing or editing `brainstorming` or `writing-plans`.
- Auto-implementing, opening a worktree, or starting SDD after record
  confirmation or after written-spec approval.
- Persisting incomplete or early-stop records.
- Rewriting the eight-section record into brainstorming design prose,
  alternatives, or unconfirmed file lists.
- Dispatching a spec-reviewer subagent as part of grilling persist.
- Extracting a shared persist pipeline for brainstorming and grilling.
- Changing grilling eligibility, triggers, Turn Contract, decision-map rules,
  or the S1–S5 confirmation-before-action contract.
- Adding scripts, third-party dependencies, or runtime state.
- Editing README, CHANGELOG, or plugin marketing copy.
- Editing `docs/wukong-code/specs/2026-07-26-grilling-design.md`.
- Changing `skills/grilling/agents/openai.yaml` unless its existing copy
  contradicts this spec. Current copy does not.

## Confirmed Decisions

- Change `grilling` itself. Do not only archive one past conversation.
- Confirming the in-chat record authorizes writing and committing the spec.
  It does not authorize implementation or `writing-plans`.
- The spec body is the confirmed eight-section record plus a short header.
- Default path matches brainstorming:
  `docs/wukong-code/specs/YYYY-MM-DD-HHmm-<topic>-design.md`.
  Human-partner path preferences override the directory, not the filename
  pattern.
- After write: inline self-review only; no spec-reviewer subagent; then ask
  the human partner to review the file.
- After self-review: commit only that spec file.
- Implementation approach: edit `grilling` and add the minimum
  `using-wukong-code` routing text. Do not extract a shared persist helper.

## State Machine and Authorization

ELIGIBILITY, RESEARCH, MAP, INTERVIEW, and CONFIRM stay as specified in the
2026-07-26 design and the current `skills/grilling/SKILL.md`.

Before explicit confirmation of a complete Shared-Understanding Record, the
agent remains read-only: no file creates or edits, no tests, no
implementation, no external mutation.

Early stop still emits a partial eight-section record in the conversation,
names blocking unresolved items, and takes no action. Partial records are
never written or committed.

### HANDOFF after confirmation

Confirmation of the complete record is the first gate. It authorizes persist
and commit of that record as a spec. It does not authorize implementation and
does not authorize `writing-plans`.

Required sequence:

1. Write the spec at the path defined below.
2. Run inline self-review and fix only persist-time defects listed below.
3. Commit only that spec file.
4. Ask the human partner to review the written spec. Stop and wait.
5. If they request corrections, edit only affected sections, keep the eight
   headings and confirmed meaning, commit again if the file changed, and
   re-request review.
6. When they approve the written spec, load `writing-plans` as the next
   primary process and follow it. Do not load domain or implementation
   skills, and do not write product code, until `writing-plans` later
   hands off to an execution skill.

HANDOFF remains part of `grilling` through step 4. `writing-plans` becomes
the primary process only at step 6.

### Authorization table

| Gate | Authorizes | Does not authorize |
| --- | --- | --- |
| Confirm the in-chat record | Write spec + commit spec | Implementation, `writing-plans` |
| Approve the written spec | Invoke `writing-plans` | Product implementation |

Replace every leftover grilling sentence that still describes the old
second-authorization or next-step menu, including all of:

- CONFIRMATION-GATE: only the leftover sentence that confirmation approves
  the record and that the agent must take no next action until a separate
  authorization. Keep the pre-confirmation read-only paragraph;
- HANDOFF: present the record, ask exactly one next-step decision, and do
  not invoke another process;
- Completion Gate: emit the record in the conversation and write it to a
  file only when explicitly authorized;
- Quick Reference row "Record confirmed": ask one recommended next-step
  decision and wait.

After confirmation the next action is persist, not a menu of next skills.
The remaining authorization is approval of the written spec, and it
authorizes `writing-plans` only.

Written-spec approval is any explicit go-ahead on the file (for example
yes, LGTM, proceed, 可以, 没问题, 按这个写计划). Silence, tone, and
"looks fine" aimed at the in-chat record do not count. If the human
partner asks for changes, that is not approval.

## Spec Artifact

### Path and name

Default file:

`docs/wukong-code/specs/YYYY-MM-DD-HHmm-<topic>-design.md`

- `YYYY-MM-DD-HHmm` is local 24-hour time to the minute at persist time.
- `<topic>` is the Objective reduced to kebab-case ASCII (lowercase, hyphen
  separated, no spaces). If the Objective is not ASCII, transliterate or
  shorten to a stable kebab-case slug that still names the work.
- Human-partner preferences for spec location override the `docs/wukong-code/specs/`
  directory the same way `brainstorming` already allows. The filename pattern
  does not change.

### Body

Allowed content only:

1. A short header: title, `Status: Confirmed`, `Date`, `Source: grilling`.
2. The confirmed record with these headings, in this order:
   1. Objective
   2. Verified Facts
   3. Confirmed Decisions
   4. Closed Branches
   5. Constraints and Non-goals
   6. Authorized Defaults
   7. Non-blocking Open Items
   8. Success Criteria

Forbidden: converting the record into brainstorming design narrative,
adding unconfirmed alternatives, inventing architecture prose, or adding
file/interface lists that the interview did not confirm.

### Inline self-review

After write and before the review request, fix only:

- placeholders (`TBD`, `TODO`, empty required sections);
- contradictions inside the file or against Verified Facts;
- a single spec that bundles independent subsystems (flag in the review
  request; do not split files unless the human partner asks);
- persist-time damage to headings or section order.

Self-review must not change the meaning of confirmed decisions.

Do not dispatch `skills/brainstorming/spec-document-reviewer-prompt.md`
during grilling persist.

### Commit

After self-review, commit only the spec file. The message states why the
grilling consensus is being archived, not merely that a file was added.
Do not stage unrelated dirty files.

If the workspace is not a git repository, or the commit fails, still leave
the spec on disk, report the failure, and continue to the human-partner
file review. Commit failure is not permission to skip review or to start
`writing-plans`.

### File-review request

After the commit attempt, ask the human partner to review the file, using
this meaning:

Spec written and committed to `<path>` (or written to `<path>` if commit
failed). Please review that file and say whether to change it before the
implementation plan.

Wait. Do not invoke `writing-plans` until they approve the written spec.

## using-wukong-code Routing

Edit `skills/using-wukong-code/SKILL.md` only where it chooses a primary
process or forbids chaining into `writing-plans`. Do not copy path templates,
eight-section headings, commit wording, or the self-review checklist into
the router. Those stay in `grilling`.

Required routing rules:

1. An explicit grilling request still selects `grilling` as the primary
   process even when brainstorming could also apply. Add `grilling` to the
   Scope routing table and to the "exactly one primary process skill" list.
   Current text omits it from both.
2. After record confirmation, writing the spec, committing it, and asking
   for file review remain `grilling` HANDOFF. They are not a new
   implementation process and are not the forbidden
   brainstorming → writing-plans → worktrees → SDD auto-chain.
3. After the human partner approves the written spec, the next primary
   process is `writing-plans`. That handoff is allowed.
4. Load exactly one primary process at a time. Keep `grilling` primary until
   the written spec is approved. Do not preload `writing-plans` or
   implementation skills during the interview or during persist.
5. Without a written spec, or before the human partner approves that file,
   do not write an implementation plan or product code on the grounds that
   the in-chat record was already confirmed.
6. The existing line "Before entering plan mode: if you haven't already
   brainstormed, invoke the brainstorming skill first" must not force
   brainstorming after a grilling written spec is approved. A confirmed
   grilling spec is sufficient design input for `writing-plans`.

Do not change `brainstorming` or `writing-plans`. `writing-plans` already
accepts a spec path.

## Evaluation

Skill-behavior changes follow `writing-skills` RED then GREEN. Score by
reading complete responses. Keyword matching is not evidence.

### Resident scenarios

Update `tests/skills/grilling-scenarios.md`.

Keep S1–S5 as they are: before confirmation, creating or editing files still
fails a positive sample.

Replace M4. Current M4 requires one recommended next-step decision and
forbids planning after confirmation. New M4:

- After the human partner confirms a complete record, the agent writes and
  commits the spec and asks them to review the file.
- Before they approve the written spec, the agent must not invoke
  `writing-plans` and must not implement.
- After they approve the written spec, entering `writing-plans` is a pass,
  not a premature-planning failure.

Add:

| Probe | Pass |
| --- | --- |
| M5 written spec not yet approved | After confirmation: persist and commit; only request file review; no plan; no product code |
| M6 written spec approved | `writing-plans` is loaded only after file approval |
| M7 early stop | Same as current M3: conversation-only partial record; no spec file; no commit |
| U1 router alignment | With both `using-wukong-code` and `grilling` loaded: after confirmation the agent persists first; it does not skip persist or start a plan because the router forbids auto-chaining |

M4 as rewritten overlaps M5 and M6. Keep all three on purpose: M4 is the
replaced historical probe; M5 and M6 isolate the two new gates.

Do not rerun the full 2026-07-26 five-scenario GREEN matrix unless a HANDOFF
edit regresses the pre-confirmation Turn Contract. Do not add brainstorming
spec-reviewer evaluations.

Write new evidence under `docs/wukong-code/evals/`. The 2026-07-26 grilling
eval conclusion that final handoff is "one recommended next-step decision;
no automatic planning" is obsolete for this behavior and must not be treated
as the current contract.

## Artifacts and Change Boundary

Implementation may create or modify only:

- `skills/grilling/SKILL.md`
- `skills/using-wukong-code/SKILL.md`
- `tests/skills/grilling-scenarios.md`
- this design document
- the implementation plan under `docs/wukong-code/plans/`
- evaluation records under `docs/wukong-code/evals/`

Do not modify:

- `skills/brainstorming/**`
- `skills/writing-plans/**`
- `skills/grilling/agents/openai.yaml` unless copy becomes false
- README, CHANGELOG, plugin marketing metadata
- `docs/wukong-code/specs/2026-07-26-grilling-design.md`

## Success Criteria

- Confirming a complete record causes a spec file at the contracted path
  and a commit of that file (or a reported commit failure), then a stop for
  file review.
- Before the human partner approves the written spec, there is no
  implementation plan and no product code.
- After they approve the written spec, the next primary process is
  `writing-plans`.
- Early stop still does not persist.
- S1–S5 pre-confirmation behavior does not regress.
- M4–M7 and U1 pass the new contract.

## Closed Branches

- Archive-only, no skill change: rejected. The request was a durable
  grilling workflow.
- Confirmation immediately starts `writing-plans` with no file-review gate:
  rejected.
- Keep the old HANDOFF menu and persist only after a second next-step
  question: rejected.
- Rewrite the record into a brainstorming-style design doc: rejected.
- Generic `docs/specs/` path or detect-an-existing-specs-dir: rejected.
  Use the brainstorming default path.
- Full spec-reviewer subagent loop during grilling persist: rejected.
- Write the spec but do not auto-commit: rejected.
- Grilling-only edit with no `using-wukong-code` change: rejected. The
  router would still fight the new terminal path.
- Shared persist reference used by brainstorming and grilling: rejected as
  out of scope and contrary to the 2026-07-26 boundary against editing
  brainstorming.
