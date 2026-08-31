# JavaScript and TypeScript Recapture-12 Unique-Phrase Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Close recapture-11 Opus matrix FAILs with replace-in-place unique phrases: after TDD or testing applies, Glob of fixture `**/*` is forbidden until `testing.md` Read completes, including after TDD SKILL.md or language-guidance SKILL.md were already Read; a workspace-root `**/*` that lists src or tests is a TDD failure; if TDD or testing will be used, `testing.md` must be the first file Read — inspecting fixture src or tests first then switching does not count and cannot retroactively switch after fixture Reads.

**Architecture:** Isolated worktree `js-ts-experimental-recapture-12` from plugin skill freeze `4051f6c`. Contract tests go RED first. Skill bodies stay at or under 180 lines. Live pressure uses `claude-opus-5-thinking-high` against the exact recapture-11 FAIL shapes before any 89-session matrix.

**Tech Stack:** Existing bash skill tests, Cursor Agent CLI `2026.08.11-e8db854`, model `claude-opus-5-thinking-high`.

## Global Constraints

- Do not flip README language-pack rows. Do not claim Experimental. Do not open a publication PR.
- Do not rewrite Red Flags, rationalization lists, or “human partner” language.
- Do not add nearest-no-guidance / operator-checkout skill sentences.
- Do not soften eval user prompts (keep Inspect src first).
- `skills/test-driven-development/SKILL.md` stays at most 180 lines (177 now). Replace the language-guidance sentence in place.
- `skills/language-guidance/SKILL.md` stays at most 180 lines.
- Quote `**/*` with single quotes in bash asserts.
- Live FAIL of the required FAIL-shape families stops the 89-session matrix.

## File map

| Path | Responsibility |
| --- | --- |
| `tests/skills/test-language-guidance.sh` | Unique-phrase contracts |
| `skills/test-driven-development/SKILL.md` | TDD-order unique phrase |
| `skills/language-guidance/SKILL.md` | TDD-order + late-switch unique phrase |
| `skills/language-guidance/references/javascript/testing.md` | JS testing.md unique phrase |
| `skills/language-guidance/references/typescript/testing.md` | TS testing.md unique phrase |

---

### Task 1: Unique phrases (RED then GREEN then live pressure)

- [ ] Contract tests RED on the new unique phrases
- [ ] Minimal in-place skill edits GREEN
- [ ] Live pressure on exact recapture-11 FAIL shapes (TS TDD r002 prompt + `**/*` risk; JS/TS implementation-candidate r005 prompt)
