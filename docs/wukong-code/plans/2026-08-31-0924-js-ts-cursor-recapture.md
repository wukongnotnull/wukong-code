# JavaScript and TypeScript Cursor Recapture-11 (Opus) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** After live pressure PASSed on plugin `4051f6c` with Cursor `claude-opus-5-thinking-high`, freeze that pair, recapture JavaScript 44 and TypeScript 45, score them, and write draft reports without flipping README.

**Architecture:** Isolated cursor home (Keychain symlink only). Ignored artifacts root `artifacts/cursor-publication-repair-11/`. Sleep two seconds between matrix IDs. Score last-message plus explicit Reads, Globs, and Greps. Keep `Manual review: pending`.

**Tech Stack:** Cursor Agent CLI (`agent` `2026.08.11-e8db854`), Bash, Python 3, `scripts/run-cursor-cohort.sh` at harness `39cbbec9d5842edd47ead87fcd6e1fc1399b4287`.

## Global Constraints

- Freeze candidate is `4051f6c2c62ddb73a7caee4bcbbd7c80b7c56f3a` on `js-ts-experimental-recapture-11`. Do not reuse `48f559a` as a new attempt.
- Model: `claude-opus-5-thinking-high` only.
- Do not overwrite `artifacts/cursor-publication-repair-10/`.
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

- JS/TS TDD adversarial / implementation-if-TDD-chosen: first file Read after TDD is applicable must complete language-guidance `testing.md` before Glob including `**/*`, Grep, or Read of fixture src/tests.
- TS cross-language: Glob of `skills/language-guidance` / `**/skills/language-guidance/**` is FAIL; Read of typescript or rust `implementation.md` is FAIL.
- JS review / verification unique phrases already hold; do not regress.
- No-guidance: do not claim an installed JS/TS language pack was loaded. Host-pack Reads remain FAIL.
- Do not add nearest-no-guidance operator-checkout skill sentences.

## File map

| Path | Responsibility |
| --- | --- |
| `artifacts/cursor-publication-repair-11/` | Ignored raw transcripts for this freeze only |
| `docs/wukong-code/evals/YYYY-MM-DD-javascript-language-guidance-cursor-recapture-11.md` | JS draft report |
| `docs/wukong-code/evals/YYYY-MM-DD-typescript-language-guidance-cursor-recapture-11.md` | TS draft report |
