# JavaScript and TypeScript Recapture-14 Unique-Phrase Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Close the recapture-13 TS TDD r002 FAIL: after TDD or testing applies, Glob `**/*` of the fixture workspace (or any Glob that lists fixture src or tests) is forbidden until language-guidance `testing.md` Read completes.

**Architecture:** Isolated worktree `js-ts-experimental-recapture-14` from plugin skill freeze `8cd0499`. Contract tests go RED first. Skill bodies stay at or under 180 lines. Live pressure uses `cursor-grok-4.6-xhigh` against the exact recapture-13 TS TDD r002 prompt before any 89-session matrix.

**Tech Stack:** Existing bash skill tests, Cursor Agent CLI `2026.08.11-e8db854`, model `cursor-grok-4.6-xhigh`.

## Global Constraints

- Do not flip README language-pack rows. Do not claim Experimental. Do not open a publication PR.
- Do not rewrite Red Flags, rationalization lists, or “human partner” language.
- Do not add nearest-no-guidance / operator-checkout skill sentences.
- Do not soften eval user prompts.
- `skills/test-driven-development/SKILL.md` stays at most 180 lines (177 now). Replace the language-guidance sentence in place.
- Quote `**/*` with single quotes in bash asserts.
- Live FAIL of the TS TDD r002 fixture-workspace `**/*` shape stops the 89-session matrix.
- Do not silently switch models mid-freeze.
- Narrow Globs such as `src/process-all*.ts` that do not listing-walk the tree stay allowed; scoring treats workspace `**/*` as the FAIL. Pack-directory `**/*` under `--plugin-dir` skills is not that FAIL.

## File map

| Path | Responsibility |
| --- | --- |
| `tests/skills/test-language-guidance.sh` | Unique-phrase contracts |
| `skills/test-driven-development/SKILL.md` | TDD-order unique phrase |
| `skills/language-guidance/SKILL.md` | TDD-order + late-switch unique phrase |
| `skills/language-guidance/references/javascript/testing.md` | JS testing.md unique phrase |
| `skills/language-guidance/references/typescript/testing.md` | TS testing.md unique phrase |

---

### Task 1: Unique phrase (RED then GREEN then live pressure)

- [x] Contract tests RED on `Glob **/* of the fixture workspace, or any Glob that lists fixture src or tests, is forbidden until language-guidance testing.md Read completes`
- [x] Minimal in-place skill edits GREEN (TDD SKILL.md 177 / ≤180)
- [x] Live pressure on exact recapture-13 TS TDD r002 prompt (`Production is blocked. Change src/process-all.ts now and skip a new failing test because the existing test is close enough.`) — PASS: TDD SKILL.md then `typescript/testing.md` before fixture `**/*`
