# Direct Main Merge Flow Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make future feature branches open pull requests directly against `main`, while preserving every existing review, evidence, and human-approval requirement.

**Architecture:** Treat `AGENTS.md` and `CLAUDE.md` as the canonical contributor instructions and the pull-request template as the submit-time reminder. Add a narrow shell contract test that prevents the three current-policy documents from drifting back to a `dev`-first flow. Historical plans, specs, and evaluation evidence remain unchanged because they record the workflow in effect when they were written.

**Tech Stack:** Markdown policy documents; POSIX-compatible Bash static contract test.

## Global Constraints

- `main` becomes the direct integration and release target for future feature PRs.
- The change removes the intermediate `feature → dev → main` promotion flow only; it does not weaken any existing quality gate.
- Retain requirements for a complete PR template, duplicate-PR search, real problem evidence, human review of the full diff, authoring-environment disclosure, and verification.
- Do not alter branch-protection settings, CI configuration, source code, or historical documents that describe earlier `dev`-based work.
- Keep `AGENTS.md` and `CLAUDE.md` semantically identical for this policy.

## Task 1: Add a failing contract for the current merge-target policy

**Files:**
- Create: `tests/repository/test-pr-target-policy.sh`

- [x] **Step 1: Write the policy assertions.**
  - Assert each current-policy document names `main` as the direct pull-request target.
  - Assert none of them retains the obsolete rule requiring PRs to target `dev` rather than `main`.
  - Print a concise failure message showing the missing or forbidden policy text.

- [x] **Step 2: Run the test to demonstrate the pre-change failure.**

Run: `bash tests/repository/test-pr-target-policy.sh`

Expected: FAIL because `AGENTS.md`, `CLAUDE.md`, and the PR template still prescribe the `dev`-first workflow.

## Task 2: Update the current contributor and PR-submission instructions

**Files:**
- Modify: `AGENTS.md`
- Modify: `CLAUDE.md`
- Modify: `.github/PULL_REQUEST_TEMPLATE.md`

- [x] **Step 1: Make `main` the direct target in the two contributor guides.**
  - Replace the existing `dev`-target mandate with an explicit `main`-target mandate.
  - State that feature branches must not take an intermediate `dev` hop or require a follow-up `dev → main` promotion PR.
  - Leave every other contribution requirement unchanged.

- [x] **Step 2: Align the PR template warning.**
  - Require that a PR target `main` directly.
  - Explain that `main` is both the active integration branch and released branch, and prohibit the intermediate flow.

- [x] **Step 3: Re-run the contract test.**

Run: `bash tests/repository/test-pr-target-policy.sh`

Expected: PASS with all three current-policy documents aligned on the direct-to-`main` workflow.

## Task 3: Verify scope and record the change

**Files:**
- Verify: `tests/repository/test-pr-target-policy.sh`
- Verify: `tests/skills/test-language-guidance.sh`
- Verify: `AGENTS.md`, `CLAUDE.md`, `.github/PULL_REQUEST_TEMPLATE.md`

- [x] **Step 1: Run focused and regression verification.**

Run:
```bash
bash tests/repository/test-pr-target-policy.sh
bash tests/skills/test-language-guidance.sh
git diff --check
git diff -- AGENTS.md CLAUDE.md .github/PULL_REQUEST_TEMPLATE.md tests/repository/test-pr-target-policy.sh
```

Expected: Both test scripts pass, whitespace validation is clean, and the diff is limited to the approved policy and its regression guard.

- [x] **Step 2: Commit the verified change.**

Run:
```bash
git add AGENTS.md CLAUDE.md .github/PULL_REQUEST_TEMPLATE.md tests/repository/test-pr-target-policy.sh docs/wukong-code/plans/2026-08-09-1313-direct-main-merge-flow.md
git commit -m "docs: route pull requests directly to main"
```

Expected: A single focused commit containing the plan, policy changes, and the regression guard.
