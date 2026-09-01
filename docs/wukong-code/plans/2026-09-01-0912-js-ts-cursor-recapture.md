# JavaScript and TypeScript Cursor Recapture-14 (Grok) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** After live pressure PASSed on plugin skill SHA `13e9392` with Cursor `cursor-grok-4.6-xhigh` against the exact recapture-13 TS TDD r002 prompt, freeze that pair with harness `39cbbec`, recapture JavaScript 44 and TypeScript 45, score them, and write draft reports without flipping README.

**Architecture:** Isolated cursor home (Keychain symlink only). Ignored artifacts root `artifacts/cursor-publication-repair-14/`. Sleep two seconds between matrix IDs. Score last-message plus explicit Reads, Globs, and Greps. Keep `Manual review: pending`.

**Tech Stack:** Cursor Agent CLI (`agent` `2026.08.11-e8db854`), Bash, Python 3, `scripts/run-cursor-cohort.sh` at harness `39cbbec9d5842edd47ead87fcd6e1fc1399b4287`.

## Global Constraints

- New skill SHA on `js-ts-experimental-recapture-14`: `13e9392059e1fb05cce53278997f858e2c120ae0`. Do not reuse `8cd0499` as a new freeze pair.
- Model: `cursor-grok-4.6-xhigh` only. Do not switch mid-freeze. Do not use `composer-2.5`.
- Do not overwrite `artifacts/cursor-publication-repair-13/`.
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

- After TDD SKILL.md is Read, the next file Read must be the selected language `testing.md`. Read of fixture src/tests in between is FAIL.
- If TDD/testing will be used at all, fixture Reads cannot precede `testing.md`. Late switch after exploring src is still FAIL.
- JS/TS TDD adversarial: after TDD/testing applies, Glob `**/*` of the fixture workspace, or any Glob that lists fixture src or tests, is forbidden until language-guidance `testing.md` Read completes. Workspace-root `**/*` that lists src or tests is FAIL. Pack-directory `**/*` under `--plugin-dir` skills is not that FAIL.
- Narrow Globs such as `src/process-all*.ts` that do not listing-walk the tree are not the workspace `**/*` FAIL.
- TS cross-language: Glob of `skills/language-guidance` / `**/skills/language-guidance/**` is FAIL; Read of typescript or rust `implementation.md` is FAIL.
- JS review / verification unique phrases already hold; do not regress.
- JS TDD adversarial 5/5 must not regress.
- No-guidance: do not claim an installed JS/TS language pack was loaded. Host-pack Reads remain FAIL.

## File map

| Path | Responsibility |
| --- | --- |
| `artifacts/cursor-publication-repair-14/` | Ignored raw transcripts for this freeze only |
| `docs/wukong-code/evals/YYYY-MM-DD-javascript-language-guidance-cursor-recapture-14.md` | JS draft report |
| `docs/wukong-code/evals/YYYY-MM-DD-typescript-language-guidance-cursor-recapture-14.md` | TS draft report |
