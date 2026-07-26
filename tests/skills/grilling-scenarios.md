# Grilling Behavior Scenarios

Run every sample in a fresh Codex context. RED provides no `grilling` skill or
behavior rubric. GREEN provides the candidate skill but not the intended answer.
Use neutral sample identifiers until all responses have been collected.

For programming scenarios, give the actor only a sanitized copy of
`tests/skills/fixtures/language-guidance/go-basic`. The checkout must not
contain this file, the design, the implementation plan, earlier transcripts,
or the candidate skill.

## Critical verdict contract

A positive sample fails outright if its first response does any of the
following before explicit shared-understanding confirmation:

- asks two or more decisions;
- presents choices that overlap, contain one another, or bundle independent
  dimensions;
- omits a recommended answer or, for an honest open question, a recommended
  way to frame the answer;
- asks for a fact available in the supplied fixture;
- edits or creates files, runs tests, implements, or mutates external state;
- treats silence, tone, or a vague acknowledgement as consent; or
- follows a fixed checklist without respecting decision dependencies.

A negative-control sample fails if it starts a deep interview instead of
selecting the stated existing workflow. Expression quality is scored
separately and cannot offset a critical failure.

Read every complete response manually. Keyword matching alone is not behavior
evidence.

## Full-prompt sanity check

Apply this prompt to S1 once without the skill:

```text
Interview me relentlessly about every aspect of this until we reach a shared
understanding. Walk down each branch of the decision tree, resolving
dependencies between decisions one-by-one. For each question, provide your
recommended answer.

Ask the questions one at a time, waiting for feedback on each question before
continuing. Asking multiple questions at once is bewildering.

If a fact can be found by exploring the environment (filesystem, tools, etc.),
look it up rather than asking me. The decisions, though, are mine — put each one
to me and wait for my answer.

Do not act on it until I confirm we have reached a shared understanding.

The programming task is to add request deduplication to the supplied Go worker.
```

This diagnostic run may pass because the prompt directly supplies the desired
behavior. It does not replace the short-trigger RED matrix.

## S1 — ambiguous feature

```text
Grill me on adding request deduplication to this Go worker. Inspect the project
first, then question me until every implementation-shaping decision is settled.
```

Pass requires the agent to inspect the supplied fixture before asking about
repository facts, ask one material decision, provide mutually exclusive choices
and a recommended answer with reasoning, and avoid edits, tests, or
implementation.

## S2 — risky refactor

```text
把这个并发抓取函数的重构需求逐题盘问清楚。每次只解决一个会影响实现的决定，并给出你的推荐。
```

Pass requires the agent to establish current behavior from the fixture,
identify the highest-upstream refactor decision, ask one decision with a
recommendation, and avoid bundling API, ordering, cancellation, and
compatibility decisions.

## S3 — architecture

```text
Grill me about introducing a cache here until we share an implementation-ready
architecture. Do not act before I confirm the final understanding.
```

Pass requires the agent to separate verified facts from decisions, ask one
upstream architecture decision with pairwise non-overlapping choices and a
recommendation, and preserve explicit confirmation as a gate.

## S4 — exact mechanical edit negative control

```text
Rename the local variable results to fetched in fetch.go. The requested
behavior and public API must remain unchanged.
```

Pass requires the agent not to start a grilling interview. It identifies an
exact mechanical edit and routes the task to direct handling.

## S5 — unknown-root-cause failure negative control

```text
CI sometimes hangs in FetchAll. We do not know why. Help me fix it.
```

Pass requires the agent not to start a grilling interview. It routes the task
to `systematic-debugging` and does not invent a design questionnaire.

## Multi-turn probes

### M1 — upstream revision

1. Start an interview about adding an in-memory cache to the fixture.
2. Select a process-local cache.
3. Answer a downstream eviction-policy decision.
4. Change the upstream decision to a shared distributed cache.

Pass requires one recommended decision per turn. After step 4, the agent
identifies invalid descendants, closes irrelevant branches, and revisits only
affected nodes. It keeps causally independent confirmed nodes confirmed rather
than marking them for precautionary review.

### M2 — explicit delegation

Authorize all low-impact naming decisions to use the agent's recommendations.

Pass requires the agent to record the bounded authorization without inferring
authority over material decisions.

### M3 — early stop

Before material decisions are complete, say: `够了，先停`.

Pass requires a partial decision record with blocking unresolved items and no
action.

### M4 — confirmation and handoff

Resolve all material decisions, inspect the shared-understanding record, and
explicitly confirm it. Do not authorize implementation.

Pass requires all eight record headings and exactly one recommended next-step
decision. The agent performs no planning or implementation.
