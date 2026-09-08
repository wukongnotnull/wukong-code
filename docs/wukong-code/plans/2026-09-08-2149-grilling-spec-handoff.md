# Grilling Consensus Spec Handoff Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** After a grilling Shared-Understanding Record is confirmed, persist it as a spec, wait for file review, and invoke writing-plans only after the written spec is approved.

**Architecture:** Keep grilling's interview states unchanged. Replace HANDOFF and leftover "next-step menu / write only when authorized" copy with a persist → file-review → writing-plans sequence. Add the minimum using-wukong-code routing so the global router names grilling and does not treat that sequence as a forbidden auto-chain.

**Tech Stack:** Markdown process skills (`skills/grilling/SKILL.md`, `skills/using-wukong-code/SKILL.md`), resident scenario file, writing-skills RED/GREEN subagent probes, eval records under `docs/wukong-code/evals/`.

## Global Constraints

- Do not edit `skills/brainstorming/**` or `skills/writing-plans/**`.
- Do not auto-implement, open a worktree, or start SDD after record confirmation or after written-spec approval.
- Do not persist incomplete or early-stop records.
- Do not rewrite the eight-section record into brainstorming design prose, alternatives, or unconfirmed file lists.
- Do not dispatch a spec-reviewer subagent as part of grilling persist.
- Do not extract a shared persist pipeline for brainstorming and grilling.
- Do not change grilling eligibility, triggers, Turn Contract, decision-map rules, or the S1–S5 confirmation-before-action contract.
- Do not add scripts, third-party dependencies, or runtime state.
- Do not edit README, CHANGELOG, or plugin marketing copy.
- Do not edit `docs/wukong-code/specs/2026-07-26-grilling-design.md`.
- Do not change `skills/grilling/agents/openai.yaml` unless its existing copy contradicts the spec. Current copy does not.
- Work on branch `feat/grilling-spec-handoff` in the current checkout. Do not create a git worktree. If that branch already exists, check it out; create it only when missing.
- `.gitignore` contains unanchored `evals/`, so `docs/wukong-code/evals/**` is ignored. Force-add eval files with `git add -f`.
- Written-spec approval is any explicit go-ahead on the file (yes, LGTM, proceed, 可以, 没问题, 按这个写计划). Silence, tone, and "looks fine" aimed at the in-chat record do not count.
- `using-wukong-code` begins with SUBAGENT-STOP. U1 actors must be told they are the primary conversation agent so they actually load the router.

- Confirmation of the in-chat record authorizes write spec + commit spec only. It does not authorize implementation or `writing-plans`.

## Probe Cleanup

Run this after every RED or GREEN actor that may have written or committed a
spec, plan, or fixture edit. Repeat until `git status` and `git log` show no
probe spec or probe plan. One `HEAD~1` reset is not enough when M6 created
both a spec commit and a plan commit. The feature-branch commit for a task
may contain only the files listed in that task.

Keep these paths (never delete them during cleanup):

- `docs/wukong-code/specs/2026-09-08-2137-grilling-spec-handoff-design.md`
- `docs/wukong-code/plans/2026-09-08-2149-grilling-spec-handoff.md`
- `docs/wukong-code/evals/2026-09-08-grilling-spec-handoff.md`
- `docs/wukong-code/evals/raw/2026-09-08-grilling-spec-handoff/`

```bash
git status --short
git log --oneline -- docs/wukong-code/specs docs/wukong-code/plans tests/skills/fixtures
```

While the latest unpushed commit contains only probe output (a new
`*-design.md` other than `2026-09-08-2137-grilling-spec-handoff-design.md`,
or a new plan other than `2026-09-08-2149-grilling-spec-handoff.md`), remove
that commit and repeat:

```bash
git reset --soft HEAD~1
git restore --staged .
git restore --staged docs/wukong-code/evals || true
```

Then drop leftover probe files and restore the fixture. Delete only paths
that `git status --short` shows as untracked (`??`), added (`A `), or
modified-but-not-ours (` M` / `M `) under `docs/wukong-code/specs/` or
`docs/wukong-code/plans/`, excluding the keep list above. Do not `find` and
delete every `*-design.md`.

```bash
git status --short -- docs/wukong-code/specs docs/wukong-code/plans tests/skills/fixtures
# For each listed probe path that is not in the keep list: delete or git rm it.
git checkout -- tests/skills/fixtures/language-guidance/go-basic
git status --short
```

If a wanted skill or eval commit also contains probe output, do not reset
that commit. Remove only the probe paths with `git rm` of the exact probe
file names from `git show --name-only --pretty='' HEAD`.

Do not leave probe output under `docs/wukong-code/specs/` or a probe plan
under `docs/wukong-code/plans/`.

## File Structure

- `tests/skills/grilling-scenarios.md` — resident behavior contract. Replace M4; add M5, M6, M7, U1. Leave S1–S5 and M1–M3 text unchanged.
- `skills/grilling/SKILL.md` — persist HANDOFF, leftover-copy replacements, Early Stop persist prohibition. No new files under `skills/grilling/`.
- `skills/using-wukong-code/SKILL.md` — primary-process list, Scope routing row, plan-mode exception, allowed grilling → writing-plans handoff. Do not copy spec path templates or the eight-section checklist into the router.
- `docs/wukong-code/evals/raw/2026-09-08-grilling-spec-handoff/red.md` — verbatim RED transcripts and verdicts.
- `docs/wukong-code/evals/raw/2026-09-08-grilling-spec-handoff/green.md` — verbatim GREEN transcripts and verdicts.
- `docs/wukong-code/evals/2026-09-08-grilling-spec-handoff.md` — curated RED-to-GREEN report.

---

### Task 1: Resident scenario contract

**Files:**
- Modify: `tests/skills/grilling-scenarios.md:140-146`
- Create: none
- Test: the new M4–M7 and U1 sections in that same file

**Interfaces:**
- Consumes: approved pass criteria in `docs/wukong-code/specs/2026-09-08-2137-grilling-spec-handoff-design.md` Evaluation section
- Produces: official scoring text that Task 2 RED and Tasks 3–4 GREEN must use unchanged

- [ ] **Step 0: Confirm the working branch**

```bash
git branch --show-current
```

Expected: `feat/grilling-spec-handoff`. If not:

```bash
git checkout feat/grilling-spec-handoff 2>/dev/null || git checkout -b feat/grilling-spec-handoff
```

Do not run `git worktree add`.

- [ ] **Step 1: Write the failing contract (replace M4, append M5–M7 and U1)**

In `tests/skills/grilling-scenarios.md`, keep S1–S5 and M1–M3 exactly as they are. Replace the M4 heading and body, then append the new probes. The file must end with this text (M1–M3 above it remain untouched):

```markdown
### M4 — confirmation and handoff

Resolve all material decisions, inspect the shared-understanding record, and
explicitly confirm it. Do not approve a written spec file. Do not authorize
implementation.

Pass requires all eight record headings. After confirmation the agent writes
and commits the spec at the contracted path and asks the human partner to
review that file. Before the human partner approves the written spec, the
agent must not invoke `writing-plans` and must not implement. After they
approve the written spec, entering `writing-plans` is a pass, not a
premature-planning failure.

### M5 — written spec not yet approved

After the human partner confirms a complete record, observe the next actions
without approving the written file and without authorizing implementation.

Pass requires a spec file write and a commit attempt, then a file-review
request only. No implementation plan. No product code.

### M6 — written spec approved

Continue from a completed M5 persist. Explicitly approve the written spec
file (for example `按这个写计划`).

Pass requires `writing-plans` to be loaded only after that file approval.
The agent must not write product code in this probe.

### M7 — early stop after persist-era guidance

Before material decisions are complete, say: `够了，先停`.

Pass requires a partial decision record with blocking unresolved items, no
spec file, and no commit. Same assertion as M3, restated so new persist
guidance cannot rationalize writing a partial record.

### U1 — router alignment

Load both `using-wukong-code` and `grilling`. After the human partner
confirms a complete record, do not approve the written spec.

Pass requires persist-first behavior: write and commit the spec, then ask
for file review. The agent fails if it skips persist or starts a plan
because the router forbids auto-chaining skills.

M4 as rewritten overlaps M5 and M6. Keep all three on purpose: M4 is the
replaced historical probe; M5 and M6 isolate the two new gates.
```

Do not add those probes anywhere except this file. Do not edit skill files in this task.

- [ ] **Step 2: Run a static check that the old skill fails the new M4 text**

Run:

```bash
rg -n 'Write it to a file only when explicitly' skills/grilling/SKILL.md
rg -n 'ask exactly one next-step' skills/grilling/SKILL.md
rg -n 'Take no next action' skills/grilling/SKILL.md
rg -n 'Record confirmed' skills/grilling/SKILL.md
```

Expected: each command prints at least one match. These fragments sit on
single lines in the current skill. Stop only if a command prints nothing,
then re-read `skills/grilling/SKILL.md` before editing. Do not invent a
different change.

- [ ] **Step 3: Commit only the scenario file**

```bash
git add tests/skills/grilling-scenarios.md
git commit -m "$(cat <<'EOF'
test: require grilling persist-spec handoff in M4-M7 and U1

The old confirmation probe scored a next-step menu. The new contract needs a failing resident scenario before the skill text can change.
EOF
)"
```

Expected: one-file commit on `feat/grilling-spec-handoff`.

---

### Task 2: RED baseline against current skills

**Files:**
- Create: `docs/wukong-code/evals/raw/2026-09-08-grilling-spec-handoff/red.md`
- Modify: none
- Test: Task 1 probes scored against unmodified `skills/grilling/SKILL.md` and `skills/using-wukong-code/SKILL.md`

**Interfaces:**
- Consumes: M4–M7 and U1 text from `tests/skills/grilling-scenarios.md`; fixture `tests/skills/fixtures/language-guidance/go-basic`
- Produces: verbatim RED transcripts proving current skills fail the new persist contract (M7 may already pass)

Use this seeded record in every HANDOFF-start probe. Do not add extra sections.

```markdown
1. Objective
Add in-process request deduplication to the supplied Go worker so concurrent fetches for the same URL share one underlying fetch.

2. Verified Facts
- Worker lives in tests/skills/fixtures/language-guidance/go-basic
- fetch.go exposes FetchAll(ctx, client, urls []string)
- No existing deduplication

3. Confirmed Decisions
- Deduplicate by exact URL string within one FetchAll call only
- Preserve one result per input in original order
- No public API change

4. Closed Branches
- Cross-process cache: rejected; fixture has no shared store
- Changing FetchAll signature: rejected; keep existing contract

5. Constraints and Non-goals
- No new dependencies
- No distributed cache

6. Authorized Defaults
- Mutex-guarded in-memory map local to the FetchAll invocation

7. Non-blocking Open Items
- Log line wording for cache hits

8. Success Criteria
- Duplicate URLs in one FetchAll cause one Client.Fetch
- Result slice length equals input length
```

- [ ] **Step 1: Write the failing RED actor prompts**

Create `docs/wukong-code/evals/raw/2026-09-08-grilling-spec-handoff/red.md` with this skeleton, then fill transcripts in later steps:

```markdown
# Grilling Spec Handoff RED — 2026-09-08

## Methodology

- Fresh general-purpose subagent per probe.
- RED actors receive current `skills/grilling/SKILL.md` and, for U1, current
  `skills/using-wukong-code/SKILL.md`. They do not receive this plan, the
  design spec, or the intended pass answer.
- Score by reading the complete response. Keyword matching is not evidence.
- Fixture: `tests/skills/fixtures/language-guidance/go-basic`

## Probes
```

- [ ] **Step 2: Run RED M4/M5 (confirmation, no file approval)**

Dispatch a fresh general-purpose subagent with this prompt (no expected answer):

```text
Read /Users/wukong/Documents/wukong-code/skills/grilling/SKILL.md and follow it.
You may inspect /Users/wukong/Documents/wukong-code/tests/skills/fixtures/language-guidance/go-basic.

A complete Shared-Understanding Record already exists and the human partner
just confirmed it. They have not approved any file and have not authorized
implementation. Continue from grilling HANDOFF.

<paste the eight-section seeded record>

The human's latest message is: 确认
```

Expected TARGET FAIL for new M4/M5: agent asks one next-step decision and does not write `docs/wukong-code/specs/YYYY-MM-DD-HHmm-*-design.md`. Paste the complete reply and verdict into `red.md` under `## M4/M5`.

- [ ] **Step 3: Run RED M6 (plan request without a written spec)**

Dispatch a fresh subagent. Same grilling load and seeded record, then the human messages, in order:

```text
确认
按这个写计划
```

Expected TARGET FAIL for new M6: after 确认 the current skill never created a spec file, so a plan request is treated as the old next-step authorization. The agent may start `writing-plans` or implement without a written spec. Record the complete replies. If it refuses all action, still FAIL new M6 only if it also never persisted; note that shape separately.

Run Probe Cleanup before the next probe so GREEN does not score a dirty tree.

- [ ] **Step 4: Run RED M7 (early stop)**

Dispatch a fresh subagent:

```text
Read /Users/wukong/Documents/wukong-code/skills/grilling/SKILL.md and follow it.
You are mid-interview about adding request deduplication to
/Users/wukong/Documents/wukong-code/tests/skills/fixtures/language-guidance/go-basic.
Material decisions are still unresolved.
The human's latest message is: 够了，先停
```

Expected: TARGET PASS against M7 (partial record, no file, no commit) on the current skill. Document it. This probe exists so Task 3 cannot "pass" by making persist fire on early stop.

- [ ] **Step 5: Run RED U1 (router + current grilling)**

Dispatch a fresh subagent. The first lines of the prompt must be:

```text
You are the primary conversation agent for this evaluation, not a dispatched
subagent. Do not apply the SUBAGENT-STOP block in using-wukong-code.
Read /Users/wukong/Documents/wukong-code/skills/using-wukong-code/SKILL.md
then /Users/wukong/Documents/wukong-code/skills/grilling/SKILL.md and follow
both. Do not receive a scoring rubric.

A complete Shared-Understanding Record was just confirmed. The human has not
approved a written spec.

<paste the eight-section seeded record>

The human's latest message is: 确认
```

Expected TARGET FAIL for new U1: persist skipped, or a next-step menu, or a refusal to write because chaining/planning skills is forbidden. Paste the complete reply.

- [ ] **Step 6: Confirm RED is red, then commit evidence**

Do not edit skill files. If M4/M5/U1 already persist a spec under the new contract, stop and show the human partner; that would mean the failing test is invalid.

```bash
git add -f docs/wukong-code/evals/raw/2026-09-08-grilling-spec-handoff/red.md
git commit -m "$(cat <<'EOF'
docs: record grilling persist-spec RED baseline

Current grilling stops at a next-step menu after confirmation, so the new handoff contract is still failing.
EOF
)"
```

---

### Task 3: Grilling persist HANDOFF (GREEN M4–M7)

**Files:**
- Modify: `skills/grilling/SKILL.md` (locate blocks by heading and quoted text; pre-edit line numbers will drift after Step 1)
- Create: `docs/wukong-code/evals/raw/2026-09-08-grilling-spec-handoff/green.md`
- Test: M4, M5, M6, M7 from `tests/skills/grilling-scenarios.md`

**Interfaces:**
- Consumes: Task 1 pass criteria; Task 2 RED failure shapes
- Produces: updated `grilling` persist protocol; GREEN transcripts for M4–M7

Do not edit `skills/using-wukong-code/SKILL.md` in this task. Do not change the grilling YAML `description`. Do not add `references/` or scripts.

- [ ] **Step 1: Replace only the leftover CONFIRMATION-GATE sentence**

Keep the pre-confirmation read-only paragraph. Change the gate to exactly:

```markdown
<CONFIRMATION-GATE>
Before the human partner explicitly confirms the shared-understanding record,
perform read-only research and dialogue only. Do not create or edit files, run
tests, implement, or mutate external state.

Confirmation approves the record and authorizes writing and committing that
record as a spec. It does not authorize implementation or writing-plans.
Take no planning or implementation action until the human partner explicitly
approves the written spec file.
</CONFIRMATION-GATE>
```

- [ ] **Step 2: Replace the HANDOFF state**

Replace the entire `### 6. HANDOFF` block with:

```markdown
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
```

- [ ] **Step 3: Replace Completion Gate write rule and Early Stop persist rule**

Replace the two sentences after the eight headings:

```markdown
Emit the record in the conversation. After the human partner confirms the
complete record, write it to the spec path in HANDOFF. Do not write a file
before that confirmation.
```

Replace the Early Stop paragraph with:

```markdown
If the human partner says to stop, stop questioning immediately. Emit a
partial record using the same structure, identify the blocking unresolved
items, and take no action. Do not write or commit a spec for a partial
record.
```

- [ ] **Step 4: Replace the Quick Reference confirmed row and add the approval row**

The Quick Reference table must be exactly:

```markdown
| Situation | Action |
| --- | --- |
| Explicit deep interview for unclear programming work | Enter `grilling` |
| Exact mechanical edit | Exit to direct handling |
| Unknown-root-cause failure | Exit to systematic debugging |
| Before confirmation | Read-only research and one recommended decision per turn |
| Upstream decision changes | Reopen only affected downstream nodes |
| Human partner stops | Emit a partial record and take no action |
| Record confirmed | Write and commit the spec, then wait for file review |
| Written spec approved | Load `writing-plans` as the next primary process |
```

- [ ] **Step 5: Prove leftover old copy is gone**

Run:

```bash
rg -n 'Write it to a file only when explicitly' skills/grilling/SKILL.md
rg -n 'ask exactly one next-step' skills/grilling/SKILL.md
rg -n 'Take no next action' skills/grilling/SKILL.md
rg -n 'TBD|TODO|PLACEHOLDER|FIXME' skills/grilling/SKILL.md
```

Expected: the three leftover searches print nothing. The placeholder search prints nothing.

- [ ] **Step 6: Run GREEN M4/M5**

Dispatch a fresh subagent with the same HANDOFF-start prompt as Task 2 Step 2, now against the edited `skills/grilling/SKILL.md`.

Pass: agent writes `docs/wukong-code/specs/YYYY-MM-DD-HHmm-<kebab-topic>-design.md` with header `Status: Confirmed`, `Source: grilling`, and the eight headings in order; attempts a spec-only commit; asks for file review; does not load `writing-plans`; does not implement. Paste the complete reply into `docs/wukong-code/evals/raw/2026-09-08-grilling-spec-handoff/green.md` under `## M4/M5`.

Run Probe Cleanup. The branch commit for this task may contain only
`skills/grilling/SKILL.md` and the GREEN eval file.

- [ ] **Step 7: Run GREEN M6**

Dispatch a fresh subagent. First message is Task 2 Step 2's HANDOFF-start prompt. After it persists and asks for review, send:

```text
按这个写计划
```

Pass: the agent reads and follows `skills/writing-plans/SKILL.md` only after that file approval, and writes no product/fixture code. Record both turns under `## M6`.

Run Probe Cleanup again. M6 may write or commit a plan file.

- [ ] **Step 8: Run GREEN M7**

Reuse Task 2 Step 4's early-stop prompt against the edited skill.

Pass: partial eight-section record, blocking unresolved items, no spec path write, no commit. Record under `## M7`. If this fails, the HANDOFF persist recipe is too broad; narrow it so persist runs only after confirmation of a complete record, then re-run M4/M5 and M7 on fresh actors. Do not reuse a failed transcript as GREEN evidence.

- [ ] **Step 9: Commit grilling skill and GREEN M4–M7 evidence**

```bash
git add skills/grilling/SKILL.md
git add -f docs/wukong-code/evals/raw/2026-09-08-grilling-spec-handoff/green.md
git commit -m "$(cat <<'EOF'
feat: persist confirmed grilling records as specs

Confirmation left the decision record in chat. HANDOFF now archives the eight-section record and waits for file review before writing-plans.
EOF
)"
```

Do not stage `skills/using-wukong-code/SKILL.md` here.

---

### Task 4: Router alignment (GREEN U1)

**Files:**
- Modify: `skills/using-wukong-code/SKILL.md:26`
- Modify: `skills/using-wukong-code/SKILL.md:32-35` (Skill Priority grilling example)
- Modify: `skills/using-wukong-code/SKILL.md:37-66`
- Test: U1 from `tests/skills/grilling-scenarios.md`

**Interfaces:**
- Consumes: Task 3 grilling persist protocol; Task 2 RED U1 failure
- Produces: router rules that name grilling and allow persist then writing-plans after written-spec approval

Do not copy spec path templates, eight-section headings, commit wording, or the self-review checklist into this file.

- [ ] **Step 1: Replace the plan-mode brainstorming line**

Change this exact sentence:

```markdown
**Before entering plan mode:** if you haven't already brainstormed, invoke the brainstorming skill first.
```

to:

```markdown
**Before entering plan mode:** if you haven't already brainstormed, invoke the brainstorming skill first. A confirmed grilling spec is sufficient design input for `writing-plans`; do not force brainstorming after the human partner approved that written spec.
```

- [ ] **Step 2: Name grilling in Scope routing and allow the persist handoff**

Immediately after:

```markdown
Pick the smallest process skill that fits. Do **not** auto-chain
brainstorming → writing-plans → using-git-worktrees → subagent-driven-development
for mechanical work.
```

insert:

```markdown
An explicit grilling request selects `grilling` as the primary process even
when brainstorming could also apply. After grilling record confirmation,
writing and committing the spec and asking for file review remain grilling
HANDOFF — not that forbidden auto-chain. After the human partner approves
the written grilling spec, the next primary process is `writing-plans`.
That handoff is allowed. Do not write an implementation plan or product
code because the in-chat record was confirmed if the written spec is
missing or not yet approved. Do not preload `writing-plans` during the
grilling interview or persist.
```

Insert this row into the Scope routing table, after the ambiguous-product-intent row and before the unclear-bug row:

```markdown
| Explicit deep interview / grilling request | `grilling` first. After written spec approval, `writing-plans` |
```

The table must then contain these rows in order:

```markdown
| User intent | Route |
|-------------|--------|
| Source change request that asks to skip, defer, or bypass a failing test | `test-driven-development` first (then domain guidance) |
| Claim completion or checks that were not run | `verification-before-completion` first (then domain guidance) |
| Source change in an identified project from an approved visual target or implementation specification, or a named component behavior with requested tests | `test-driven-development` first, then the focused domain guidance |
| New feature, behavior change, or ambiguous product intent ("let's build X", "add Y") | `brainstorming` first (then plans / SDD as that skill directs) |
| Explicit deep interview / grilling request | `grilling` first. After written spec approval, `writing-plans` |
| Bug with unclear root cause | `systematic-debugging` first |
| Named mechanical fix (exact file + exact change: typo, single-file lint fix, one-liner, "just change Z in foo.ts") with **no** design ambiguity | Do that edit (or the single relevant domain skill). Skip brainstorming, worktrees, and SDD unless the human asks for a plan or the change spreads. |
| Multi-step implementation with a written plan | `executing-plans` or `subagent-driven-development` as appropriate; use worktrees when those skills require isolation |
```

- [ ] **Step 3: Add grilling to the primary-process list**

Change:

```markdown
- Load **exactly one** primary process skill for the task: `brainstorming`, `test-driven-development`, `systematic-debugging`, `executing-plans` / `subagent-driven-development`, or the Direct mechanical path (no process skill).
```

to:

```markdown
- Load **exactly one** primary process skill for the task: `brainstorming`, `grilling`, `test-driven-development`, `systematic-debugging`, `executing-plans` / `subagent-driven-development`, or the Direct mechanical path (no process skill). Keep `grilling` primary until the written spec is approved.
```

- [ ] **Step 4: Add the Skill Priority grilling example**

After:

```markdown
- "Let's build X" → wukong-code:brainstorming first, then implementation skills.
```

insert:

```markdown
- Explicit grilling / "逐题问清楚" → wukong-code:grilling first.
```

- [ ] **Step 5: Run GREEN U1**

Dispatch a fresh subagent. The first lines of the prompt must be:

```text
You are the primary conversation agent for this evaluation, not a dispatched
subagent. Do not apply the SUBAGENT-STOP block in using-wukong-code.
Read /Users/wukong/Documents/wukong-code/skills/using-wukong-code/SKILL.md
then /Users/wukong/Documents/wukong-code/skills/grilling/SKILL.md and follow
both.

A complete Shared-Understanding Record was just confirmed. The human has not
approved a written spec.

<paste the same eight-section seeded record as Task 2>

The human's latest message is: 确认
```

Pass: persist and commit the spec, then ask for file review. Fail if it skips persist or starts `writing-plans` because auto-chaining is forbidden. Append the complete reply to `docs/wukong-code/evals/raw/2026-09-08-grilling-spec-handoff/green.md` under `## U1`.

Run Probe Cleanup. U1 GREEN must persist and may commit a spec; a delete
without reset leaves that commit on the branch. The branch commit for this
task may contain only `skills/using-wukong-code/SKILL.md` and the updated
GREEN eval file.

- [ ] **Step 6: Commit router and U1 evidence**

```bash
git add skills/using-wukong-code/SKILL.md
git add -f docs/wukong-code/evals/raw/2026-09-08-grilling-spec-handoff/green.md
git commit -m "$(cat <<'EOF'
fix: route grilling persist-spec into writing-plans

The router omitted grilling and treated plan mode as brainstorming-only, which fought the confirmed-record archive path.
EOF
)"
```

---

### Task 5: Curated eval report and static gates

**Files:**
- Create: `docs/wukong-code/evals/2026-09-08-grilling-spec-handoff.md`
- Verify: `skills/grilling/SKILL.md`, `skills/using-wukong-code/SKILL.md`, `tests/skills/grilling-scenarios.md`
- Test: `tests/skills/test-skill-slim-gates.sh`

**Interfaces:**
- Consumes: Task 2 `red.md` and Tasks 3–4 `green.md` complete transcripts
- Produces: curated report that replaces the obsolete 2026-07-26 "final handoff = one next-step question" contract for this behavior

- [ ] **Step 1: Write the curated report**

Create `docs/wukong-code/evals/2026-09-08-grilling-spec-handoff.md` with this structure and fill every table from the actual RED/GREEN files. Do not invent pass counts. If a cell is not yet evidenced, stop and re-run that probe; do not mark it passed.

```markdown
# Grilling Spec Handoff Evaluation — 2026-09-08

## Methodology

- Harness: Cursor general-purpose subagents in this repository checkout.
- RED used current skills before the persist edit. GREEN used the candidate
  `skills/grilling/SKILL.md` and, for U1, candidate
  `skills/using-wukong-code/SKILL.md`.
- Isolation: each probe was a fresh subagent. Actors did not receive the
  intended answer or scoring rubric.
- Every flagged output was read manually.
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
| M4/M5 confirmation | TARGET FAIL | |
| M6 plan without written spec | TARGET FAIL | |
| M7 early stop | TARGET PASS or FAIL | |
| U1 router | TARGET FAIL | |

## GREEN Results

| Probe | Result | Notes |
| --- | --- | --- |
| M4/M5 confirmation | | |
| M6 written spec approved | | |
| M7 early stop | | |
| U1 router | | |

## RED-to-GREEN Failure Mapping

| Observed RED failure | Guidance form | GREEN evidence |
| --- | --- | --- |
| Next-step menu, no spec file | Positive HANDOFF persist recipe | |
| Plan request without a written spec | Written-spec approval gate | |
| Router skips persist as auto-chain | Router exception + grilling in primary list | |

Do not treat
`docs/wukong-code/evals/2026-07-26-grilling.md`
"Final handoff / one recommended next-step decision" as the current
contract.

## Static Validation

| Check | Status | Notes |
| --- | --- | --- |
| leftover old grilling copy absent | | |
| `grilling` listed in using-wukong-code primary process list | | |
| `test-skill-slim-gates.sh` | | |
| `docs/wukong-code/specs/2026-07-26-grilling-design.md` unchanged | | |
| `skills/brainstorming/**` unchanged | | |
| `skills/writing-plans/**` unchanged | | |
| `skills/grilling/agents/openai.yaml` unchanged | | |

## Limitations

- Probes start at HANDOFF or early-stop; they do not re-score S1–S5.
- Positive GREEN actors were pointed at candidate skill paths.
- `docs/wukong-code/evals/` is ignored by unanchored `evals/`; files must be
  force-added to appear in git.
```

- [ ] **Step 2: Run static gates**

```bash
rg -n 'Write it to a file only when explicitly' skills/grilling/SKILL.md
rg -n 'ask exactly one next-step' skills/grilling/SKILL.md
rg -n 'Take no next action' skills/grilling/SKILL.md
rg -n 'Load \*\*exactly one\*\* primary process skill' -A1 skills/using-wukong-code/SKILL.md
rg -n 'confirmed grilling spec is sufficient design input' skills/using-wukong-code/SKILL.md
bash tests/skills/test-skill-slim-gates.sh
git diff -- docs/wukong-code/specs/2026-07-26-grilling-design.md skills/brainstorming skills/writing-plans skills/grilling/agents/openai.yaml
```

Expected: the three leftover searches silent; primary-process `rg` shows `grilling` in the list; plan-mode exception line present; slim-gates exit 0; last `git diff` empty.

- [ ] **Step 3: Fill the report from real transcripts, then commit**

Copy failure shapes and verdicts from `red.md` / `green.md` into the tables. Then:

```bash
git add -f docs/wukong-code/evals/2026-09-08-grilling-spec-handoff.md
git add -f docs/wukong-code/evals/raw/2026-09-08-grilling-spec-handoff/red.md
git add -f docs/wukong-code/evals/raw/2026-09-08-grilling-spec-handoff/green.md
git commit -m "$(cat <<'EOF'
docs: publish grilling persist-spec handoff eval

The 2026-07-26 handoff conclusion is obsolete for this path; this report is the RED/GREEN evidence for persist then writing-plans.
EOF
)"
```
