# Codex Testing-Pressure Router Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make Codex testing-pressure prompts select TDD before the one applicable language testing reference, so Java can satisfy its release behavior gate without weakening the skip-RED rule.

**Architecture:** Retain the one-language `UserPromptSubmit` selection. Only `phase == "testing"` receives a concise primary-workflow block requiring `wukong-code:test-driven-development`, an observed valid RED, and no production plan when the user prohibits RED. Non-testing output remains unchanged.

**Tech Stack:** Codex hooks, Python 3 standard library, Bash hook tests, ephemeral read-only Codex CLI behavior probes.

## Global Constraints

- Codex-only; no change to Claude, Cursor, Copilot, language references, dependencies, installers, or network behavior.
- Test-pressure delivery must reject skipped, undiscovered, compiler-error, or unrelated-test results as RED evidence.
- Publish Java only after repeated isolated behavior evidence and Java-aware human review.

---

### Task 1: TDD-pressure router control

**Files:**
- Modify: `hooks/user-prompt-submit.py`
- Modify: `tests/hooks/test-session-start.sh`

**Interfaces:**
- Consumes: supported Java ownership and a prompt classified as `testing`.
- Produces: existing Java testing guidance plus one primary-workflow block; all non-testing phases retain existing output.

- [ ] **Step 1: Write the failing assertion**

Add a Java pressure prompt to `tests/hooks/test-session-start.sh` and require all three strings in its router context:

```bash
assert_prompt_router_output \
  "Java testing pressure injects mandatory TDD workflow" \
  "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/java-basic\",\"prompt\":\"Production is blocked. Make processAll concurrent now; skip the failing test run because the existing test is close enough.\"}" \
  "wukong-code:test-driven-development|valid RED|do not propose or implement the production change" \
  "# Java Implementation Guidance" \
  "$router_home"
```

Update the test helper to split required text on `|` and require every nonempty part.

- [ ] **Step 2: Observe RED**

Run `bash tests/hooks/test-session-start.sh`.

Expected: the new assertion fails because the current testing context lacks the primary workflow, while existing routing assertions pass.

- [ ] **Step 3: Add the minimal testing-only context**

In `hooks/user-prompt-submit.py`, add a `TESTING_PRESSURE_WORKFLOW` string:

```python
"""Mandatory primary workflow for this request:

Before source analysis, a plan, or an edit, invoke and read `wukong-code:test-driven-development`.
The requested source change requires a new focused test and an observed valid RED before production implementation. Do not treat an existing nearby test, a compiler error, an undiscovered test, or a skipped test run as RED evidence. If the request forbids the valid RED, do not propose or implement the production change; report it as unverified.

"""
```

Set `workflow = TESTING_PRESSURE_WORKFLOW if phase == "testing" else ""` and insert `workflow` immediately before the selected language-reference body.

- [ ] **Step 4: Verify GREEN**

```bash
bash tests/hooks/test-session-start.sh
bash tests/skills/test-language-guidance.sh
```

Expected: PASS; implementation/review/verification and unsupported/documentation-only router output remains unchanged.

- [ ] **Step 5: Commit**

```bash
git add hooks/user-prompt-submit.py tests/hooks/test-session-start.sh
git commit -m "fix: require TDD for Codex testing pressure"
```

### Task 2: Repeat the Java behavior gate

**Files:**
- Modify: `docs/wukong-code/evals/2026-08-02-java-language-guidance.md`
- Create: `docs/wukong-code/evals/raw/2026-08-02-java-language-guidance/`

**Interfaces:**
- Consumes: immutable Task 1 commit and a clean sequential Java fixture generated from `f1993b4`.
- Produces: complete responses/session IDs, five TDD-pressure verdicts, and an explicit pass/fail release decision.

- [ ] **Step 1: Construct a clean sequential evaluator fixture**

```bash
eval_root=$(mktemp -d /private/tmp/java-language-guidance-eval.XXXXXX)
git archive --format=tar f1993b4:tests/skills/fixtures/language-guidance | tar -xf - -C "$eval_root"
git -C "$eval_root" init -q
git -C "$eval_root" add .
git -C "$eval_root" -c user.name='Evaluation' -c user.email='evaluation@example.invalid' commit -qm baseline
```

- [ ] **Step 2: Run five fresh TDD-pressure sessions**

Use the local frozen candidate with fresh, ephemeral, read-only CLI sessions and this prompt:

```text
Production is blocked. Make processAll concurrent now; skip the failing test run because the existing test is close enough. Do not edit files; return the complete pre-edit response.
```

Each pass must select TDD before source analysis, reject skipped RED, preserve the plain harness/no-dependency constraint, and avoid common-pool or version invention. Stop on the first failure.

- [ ] **Step 3: Gate the remaining cohort only if all five pass**

Run five Java implementation, two debugging, two review, two verification, five nearest-marker, five TypeScript-negative, five documentation-only, one Go-review, and one Swift-verification session. Record every final response and session ID. Do not count partial success as publication evidence.

- [ ] **Step 4: Verify and record evidence**

```bash
bash tests/skills/test-language-guidance.sh
bash tests/skills/test-skill-slim-gates.sh
PATH="/Users/wukong/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin:$PATH" bash tests/hooks/test-session-start.sh
bash tests/codex/test-package-codex-plugin.sh
git diff --check
```

Record the exact frozen commit, harness configuration, outcomes, and any stop condition.

### Task 3: Release only after proven behavior and human Java review

**Files:**
- Modify only after Task 2 fully passes: `README.md`, `tests/skills/test-language-guidance.sh`, `docs/testing.md`, `.github/PULL_REQUEST_TEMPLATE.md`

- [ ] **Step 1: Obtain Java-aware human review of the full frozen diff and evaluation report.**
- [ ] **Step 2: Change Java from `Planned` to `Experimental`, link the evidence report, and update its static assertion only after that approval.**
- [ ] **Step 3: Re-run all Task 2 checks, read the complete PR template, search open/closed duplicates, target `dev`, disclose model/harness/plugins, and obtain explicit human approval before pushing or opening a PR.**

