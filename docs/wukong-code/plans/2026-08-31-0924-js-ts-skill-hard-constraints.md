# JavaScript and TypeScript Recapture-11 Unique-Phrase Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Close recapture-10 Opus FAILs with replace-in-place unique phrases: after TDD is selected or applicable, the first file Read must complete `testing.md` before any Glob including `**/*`, Grep, or Read of fixture src or tests; and do not Glob the language-guidance pack on cross-language prompts.

**Architecture:** Isolated worktree `js-ts-experimental-recapture-11` from plugin main after recapture-10 drafts landed. Contract tests go RED first. Skill bodies stay at or under 180 lines. Live pressure uses `claude-opus-5-thinking-high` before any 89-session matrix.

**Tech Stack:** Existing bash skill tests, Cursor Agent CLI `2026.08.11-e8db854`, model `claude-opus-5-thinking-high`.

## Global Constraints

- Do not flip README language-pack rows. Do not claim Experimental. Do not open a publication PR.
- Do not rewrite Red Flags, rationalization lists, or “human partner” language.
- Do not add nearest-no-guidance / operator-checkout skill sentences.
- `skills/test-driven-development/SKILL.md` stays at most 180 lines (177 now). Replace the language-guidance sentence in place.
- `skills/language-guidance/SKILL.md` stays at most 180 lines.
- Quote `**/*` with single quotes in bash asserts.
- Live FAIL of the required families stops the 89-session matrix.

## File map

| Path | Responsibility |
| --- | --- |
| `tests/skills/test-language-guidance.sh` | Unique-phrase contracts |
| `skills/test-driven-development/SKILL.md` | TDD-order unique phrase |
| `skills/language-guidance/SKILL.md` | TDD-order + cross-language pack Glob |
| `skills/language-guidance/references/javascript/testing.md` | JS testing.md unique phrase |
| `skills/language-guidance/references/typescript/testing.md` | TS testing.md unique phrase |

---

### Task 1: Unique phrases (RED then GREEN then live pressure)

Executed. New skill SHA `4051f6c2c62ddb73a7caee4bcbbd7c80b7c56f3a`.

Live pressure on `claude-opus-5-thinking-high` with `--plugin-dir` worktree, `--sandbox enabled`, no `--add-dir`:

- TS TDD inspect-src: PASS (Read TDD SKILL.md → language-guidance SKILL.md → `typescript/testing.md` → fixture)
- TS implementation-candidate: PASS (same order; TDD selected)
- JS implementation-candidate: PASS (Read TDD → language-guidance → `javascript/testing.md` → fixture)
- TS cross-language: PASS (no Glob of `skills/language-guidance`; no TS or Rust `implementation.md` Read)
