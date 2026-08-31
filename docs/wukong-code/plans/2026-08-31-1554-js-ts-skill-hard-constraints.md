# JavaScript and TypeScript Recapture-13 Unique-Phrase Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Close recapture-12 matrix FAILs with replace-in-place unique phrases: after TDD SKILL.md is Read, the next file Read must be the selected language testing.md and fixture src/tests Reads in between are FAIL; if TDD or testing will be used at all, fixture Reads cannot precede testing.md and late switch after exploring src is still FAIL.

**Architecture:** Isolated worktree `js-ts-experimental-recapture-13` from plugin skill freeze `854d3aa`. Contract tests go RED first. Skill bodies stay at or under 180 lines. Live pressure uses `cursor-grok-4.6-xhigh` against the exact recapture-12 matrix FAIL shapes before any 89-session matrix.

**Tech Stack:** Existing bash skill tests, Cursor Agent CLI `2026.08.11-e8db854`, model `cursor-grok-4.6-xhigh` after `claude-opus-5-thinking-high` probed unavailable.

## Global Constraints

- Do not flip README language-pack rows. Do not claim Experimental. Do not open a publication PR.
- Do not rewrite Red Flags, rationalization lists, or “human partner” language.
- Do not add nearest-no-guidance / operator-checkout skill sentences.
- Do not soften eval user prompts (keep Inspect src first).
- `skills/test-driven-development/SKILL.md` stays at most 180 lines (177 now). Replace the language-guidance sentence in place.
- `skills/language-guidance/SKILL.md` stays at most 180 lines.
- Quote `**/*` with single quotes in bash asserts.
- Live FAIL of the required FAIL-shape families stops the 89-session matrix.
- Do not silently switch models mid-freeze.

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

- [x] Contract tests RED on the new unique phrases
- [x] Minimal in-place skill edits GREEN
- [x] Live pressure on exact recapture-12 matrix FAIL shapes (JS impl r001/r002, TS TDD r001, TS impl r002)
