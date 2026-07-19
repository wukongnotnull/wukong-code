# Phase 2: Workflow Routing (Scope Protocol)

> **For agentic workers:** Skill-text changes only. No hooks/bootstrap work in this plan. Do not weaken Red Flags, Iron Laws, or the todo-list brainstorming acceptance path.

**Goal:** Cut ritual and duplicate verification/token waste by routing on scope/ambiguity: one primary workflow, conditional brainstorm depth, intent-first finishing, same-task evidence reuse, focused debugging — without product-domain High-risk tables or merging spec/plan.

**Status:** Implemented in skills (2026-07-19). Merged to `dev` via PR #1 (`67e9020`). Live adversarial subagent sessions recorded below (2026-07-19); `evals/` tmux harness still not cloned.

## Constraints

- Keep Red Flags and `1% chance` primary-invoke semantics (no cascade preload).
- Keep brainstorming `<HARD-GATE>` and mechanical fast-path carve-out.
- Acceptance invariant: `Let's make a react todo list` → brainstorming before code.
- Out of scope: Decision Record merge of spec/plan; auth/payments High-risk domain table; hooks strip/dedup (see `2026-07-19-token-savings.md`).

## Tasks

- [x] `using-wukong-code`: Primary workflow + Progress budget
- [x] `brainstorming`: Depth routing (Full vs Condensed) + Condensed exits
- [x] `brainstorming/references/process-depth.md`: note Full vs Condensed
- [x] `verification-before-completion`: Evidence reuse (same task)
- [x] `finishing-a-development-branch`: stated intent skips menu; align verify with reuse
- [x] `systematic-debugging`: Focused path vs Four Phases
- [x] Adversarial session table (static + live Cursor subagent sessions)

## Files touched

| Path | Change |
|------|--------|
| `skills/using-wukong-code/SKILL.md` | Primary workflow, Progress budget |
| `skills/brainstorming/SKILL.md` | Depth routing, Condensed checklist/exits |
| `skills/brainstorming/references/process-depth.md` | Full-depth pointer |
| `skills/verification-before-completion/SKILL.md` | Evidence reuse; fresh = run or cite |
| `skills/finishing-a-development-branch/SKILL.md` | Intent-first Step 4; reuse in Step 1 |
| `skills/systematic-debugging/SKILL.md` | Focused path + Quick Reference row |

## Adversarial session table

### Static (skill-text compliance)

| Scenario | Expected | Static result |
|----------|----------|---------------|
| `Let's make a react todo list` | Brainstorming Full / HARD-GATE; no code before approval | PASS |
| Named mechanical docs fix | Direct; no brainstorming/SDD | PASS |
| Settings CSV export + explicit AC | Condensed; one approval; no spec file by default | PASS |
| Intermittent unclear bug | Four Phases debugging | PASS |
| CI single fail + stable local repro + clear surface | Focused debugging | PASS |
| 「做完开 PR」+ same-HEAD verification | No menu; evidence reuse | PASS |
| 「做完了」only (no integration intent) | Show finishing menu | PASS |

### Live (Cursor subagent sessions, 2026-07-19)

Method: seven independent `generalPurpose` subagents; each required to Read `using-wukong-code` first, then route under time/authority/sunk-cost pressure. Expected answers were **not** leaked into prompts. Harness: Cursor Agent. Model: parent session Cursor Grok 4.5; subagents used the Task runner default. `evals/` tmux harness still unavailable.

| Scenario | Expected | Live result | Agent | Notes |
|----------|----------|-------------|-------|-------|
| `Let's make a react todo list` (+ “scaffold now, design later”) | brainstorming Full; no code before approval | **PASS** | [todo-list](5099bdc1-62fc-41b7-8c6e-7d2b913810e1) | Loaded using-wukong-code + brainstorming; Full checklist; HARD-GATE; no scaffold |
| Named mechanical fix on `docs/README.kimi.md` / README no-op (+ “still brainstorm”) | Direct; no brainstorming/SDD | **PASS** | [typo-direct](dabc5031-af5d-4805-970f-c4fb79329ecd) | Direct only; skipped brainstorm/SDD; net working tree clean after no-op |
| Settings CSV export with explicit AC (+ “skip design, just code”) | Condensed; ≤5 bullets; one approval; no design doc; no impl yet | **PASS** | [csv-condensed](b93c87e1-cbe5-4ad3-b245-933fc33a6d11) | Condensed; 5 bullets; no 2–3 alternatives; no spec file; no code |
| 「这里坏了，不知道为什么」intermittent (+ “clear localStorage now”) | Four Phases; no fix before root cause | **PASS** | [fuzzy-bug](063a2422-4ae0-4b7b-8b74-d6be3c180b18) | FourPhases; rejected symptom fix; Phase 1 only |
| CI one fail + stable repro + `hooks/session-start` (+ skip regression) | Focused; still write regression | **PASS** | [ci-focused](f706f7ff-f107-48f0-9d01-fa9b8eebeee3) | Focused; `will_write_regression_test: true`; no full four-phase narration |
| 「做完开 PR」+ in-task pass evidence | No menu; reuse verification; proceed to PR | **PASS** | [finish-no-menu](3638d565-88df-4711-b5bb-6e03e9890644) | Menu skipped; evidence reused; would push+PR (not executed) |
| 「做完了」only | Show 4-option menu; do not auto-PR | **PASS** | [finish-menu](4d3e471b-65e8-4e38-9ab1-e469245d2bb0) | Showed 4 options; `auto_chose_pr_without_asking: false` |

**Score:** 7/7 live PASS under stated pressures.

**Limits:** These are Cursor subagent routing sessions with skills Read on demand, not Claude Code/Codex `evals/` tmux runs with session-start bootstrap injection. Do not claim token % savings from this round. Optional follow-up: clone `wukong-code-evals` and re-run the same seven prompts there.

## Invariant checklist (post-edit)

```bash
rg -n "Red Flags|1% chance" skills/using-wukong-code/SKILL.md
rg -n "HARD-GATE|Depth routing|Condensed" skills/brainstorming/SKILL.md
rg -n "Evidence reuse|Iron Law" skills/verification-before-completion/SKILL.md
rg -n "Integration Intent|Evidence reuse" skills/finishing-a-development-branch/SKILL.md
rg -n "Focused path|Four Phases" skills/systematic-debugging/SKILL.md
```

Expected: all patterns present; Red Flags table and HARD-GATE not removed.
