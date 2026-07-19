# Phase 2: Workflow Routing (Scope Protocol)

> **For agentic workers:** Skill-text changes only. No hooks/bootstrap work in this plan. Do not weaken Red Flags, Iron Laws, or the todo-list brainstorming acceptance path.

**Goal:** Cut ritual and duplicate verification/token waste by routing on scope/ambiguity: one primary workflow, conditional brainstorm depth, intent-first finishing, same-task evidence reuse, focused debugging — without product-domain High-risk tables or merging spec/plan.

**Status:** Implemented in skills (2026-07-19). Adversarial table below records static instruction compliance; live harness sessions remain recommended when `evals/` is available.

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
- [x] Adversarial session table (static compliance; live evals optional)

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

`evals/` was not cloned in this workspace. Results below are **static routing checks** against the updated skill text (2026-07-19). Re-run as live sessions before treating Phase 2 as eval-proven.

| Scenario | Expected | Static result | Evidence |
|----------|----------|---------------|----------|
| `Let's make a react todo list` | Brainstorming; design approval before code (Full or at least HARD-GATE) | PASS (instruction) | Ambiguous creative work → Depth **Full**; HARD-GATE intact; Scope routing row 1 |
| 「把 `foo.ts` 里 typo X 改成 Y」 | Direct; no brainstorming/SDD | PASS (instruction) | Scope routing mechanical fast path; brainstorming Fast path carve-out |
| 「给设置页加导出 CSV；验收：按钮导出当前筛选结果」 | Condensed brainstorm; one approval; default no spec file | PASS (instruction) | Depth **Condensed**; no design doc unless asked / multi-subsystem |
| 「这里坏了，不知道为什么」 | Full debugging | PASS (instruction) | Focused path requires single fail + stable repro + clear surface — absent → Four Phases |
| CI log → one failing test + local repro | Focused debugging path | PASS (instruction) | Focused path applicability block |
| 「做完开 PR」+ tests just passed same HEAD | No finishing menu; verification may reuse | PASS (instruction) | Step 4 intent skip; Step 1 + Evidence reuse |
| User never says how to integrate | Show finishing menu | PASS (instruction) | Step 4: menu when intent absent |

### Live session follow-up (when available)

If `evals/` is cloned or a human runs harness sessions, replace Static result with live pass/fail and paste transcripts or eval IDs here. Do not claim token % savings without measured sessions.

## Invariant checklist (post-edit)

```bash
rg -n "Red Flags|1% chance" skills/using-wukong-code/SKILL.md
rg -n "HARD-GATE|Depth routing|Condensed" skills/brainstorming/SKILL.md
rg -n "Evidence reuse|Iron Law" skills/verification-before-completion/SKILL.md
rg -n "Integration Intent|Evidence reuse" skills/finishing-a-development-branch/SKILL.md
rg -n "Focused path|Four Phases" skills/systematic-debugging/SKILL.md
```

Expected: all patterns present; Red Flags table and HARD-GATE not removed.
