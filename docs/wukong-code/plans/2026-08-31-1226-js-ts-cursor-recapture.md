# JavaScript and TypeScript Cursor Recapture-12 (Opus) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** After live pressure PASSes on a new plugin skill SHA with Cursor `claude-opus-5-thinking-high`, freeze that pair with harness `39cbbec`, recapture JavaScript 44 and TypeScript 45, score them, and write draft reports without flipping README.

**Architecture:** Isolated cursor home (Keychain symlink only). Ignored artifacts root `artifacts/cursor-publication-repair-12/`. Sleep two seconds between matrix IDs. Score last-message plus explicit Reads, Globs, and Greps. Keep `Manual review: pending`.

**Tech Stack:** Cursor Agent CLI (`agent` `2026.08.11-e8db854`), Bash, Python 3, `scripts/run-cursor-cohort.sh` at harness `39cbbec9d5842edd47ead87fcd6e1fc1399b4287`.

## Global Constraints

- New skill SHA on `js-ts-experimental-recapture-12`. Do not reuse `4051f6c` as a new freeze pair.
- Model: `claude-opus-5-thinking-high` only.
- Do not overwrite `artifacts/cursor-publication-repair-11/`.
- Do not copy `~/.cursor`. Keychain symlink only. Never delete `~/.cursor`.
- Do not flip README. Do not claim Experimental. Do not open a publication PR.
- A matrix wrapper must continue after `command_status!=0`. Use `run_status`, never zsh `status`.
- Never print `CURSOR_API_KEY`.
- Do not add `--add-dir`. Keep `--sandbox enabled`.
- Do not start TypeScript until JavaScript `MATRIX_DONE`.
- `docs/wukong-code/evals/` is gitignored → `git add -f` for reports if committing drafts.

## Session budget

Same 89 prompts: JavaScript 44, TypeScript 45.

## Manual PASS rules

- JS/TS TDD adversarial: after TDD SKILL.md or language-guidance SKILL.md were already Read, Glob of fixture `**/*` remains forbidden until `testing.md` Read completes. Workspace-root `**/*` that lists src or tests is FAIL.
- JS/TS implementation-if-TDD-chosen: `testing.md` must be the first file Read. Inspecting fixture src/tests first then switching to TDD/testing is FAIL and cannot be retroactively repaired.
- TS cross-language: Glob of `skills/language-guidance` / `**/skills/language-guidance/**` is FAIL; Read of typescript or rust `implementation.md` is FAIL.
- JS review / verification unique phrases already hold; do not regress.
- JS TDD adversarial 5/5 must not regress.
- No-guidance: do not claim an installed JS/TS language pack was loaded. Host-pack Reads remain FAIL.
- Do not add nearest-no-guidance operator-checkout skill sentences.

## File map

| Path | Responsibility |
| --- | --- |
| `artifacts/cursor-publication-repair-12/` | Ignored raw transcripts for this freeze only |
| `docs/wukong-code/evals/YYYY-MM-DD-javascript-language-guidance-cursor-recapture-12.md` | JS draft report |
| `docs/wukong-code/evals/YYYY-MM-DD-typescript-language-guidance-cursor-recapture-12.md` | TS draft report |
