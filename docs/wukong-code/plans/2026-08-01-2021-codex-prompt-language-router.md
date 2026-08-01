# Codex Prompt Language Router Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `wukong-code:subagent-driven-development` (recommended) or `wukong-code:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a Codex-only `UserPromptSubmit` hook that deterministically selects and injects the applicable language reference from explicit prompt and repository evidence.

**Architecture:** SessionStart continues to inject the general Wukong workflow. A new UserPromptSubmit command safely parses Codex's event JSON with authorized system `python3` standard-library modules, selects no more than one language/phase from a narrow evidence table, and injects the selected reference body as developer context. This is deterministic reference delivery, not an unsupported attempt to invoke the Skill tool on the model's behalf.

**Tech Stack:** Codex hook configuration, Bash, system `python3` standard library, the existing `run-hook.cmd` dispatcher, Markdown references, Bash/Python tests, and fresh Codex CLI behavior sessions.

## Global Constraints

- Codex-only: do not alter Claude, Cursor, Copilot, or language-reference content.
- No third-party dependency, installer, network call, or global configuration.
- If `python3` is unavailable, event JSON is malformed, evidence conflicts, or the target is unsupported/documentation-only, exit zero without injected language context.
- Inject exactly one selected reference; never preload every language or phase.
- The injected context names language, evidence, phase, and repository-relative reference path.
- Treat injection as loaded Codex guidance. Do not claim it forces a model file-read or guarantees every model response.
- Debugging, review, verification, testing-pressure, and implementation phases retain the existing explicit precedence order.
- The nearest target marker wins; ambiguous evidence selects nothing.
- README remains `Planned`; no PR or experimental claim without a fresh complete cohort and Rust-aware human review.

---

### Task 1: Write failing prompt-router controls — complete

**Files:**

- Modify: `tests/codex/test-marketplace-manifest.sh`
- Modify: `tests/hooks/test-session-start.sh`
- Modify: `tests/codex/test-package-codex-plugin.sh`

**Interfaces:**

- Consumes: `hooks/hooks-codex.json`, the existing dispatcher, and a command hook JSON event on stdin.
- Produces: failing checks for an exact UserPromptSubmit handler, packaged router, and language/phase selection outputs.

- [x] **Step 1: Add manifest and package RED assertions**

Require exactly one `UserPromptSubmit` command handler with:

```text
"${PLUGIN_ROOT}/hooks/run-hook.cmd" user-prompt-submit
```

Require `hooks/user-prompt-submit` in the archive while retaining the existing cross-harness exclusions.

- [x] **Step 2: Add hook behavior RED assertions**

Provide JSON input directly to the dispatcher and validate Codex nested `hookSpecificOutput.additionalContext` for:

```text
Rust R1 + rust-basic cwd -> Rust implementation and rust/implementation.md body
Rust review + rust-basic cwd -> Rust review and rust/review.md body
Go review + go-basic cwd -> Go review and go/review.md body
Swift verification + swift-basic cwd -> Swift verification and swift/verification.md body
TypeScript target -> explicit negative context; README typo and malformed JSON -> exit 0 with no context
```

- [x] **Step 3: Observe RED**

Run:

```bash
PATH=/usr/local/bin:$PATH bash tests/codex/test-marketplace-manifest.sh
PATH=/usr/local/bin:$PATH bash tests/hooks/test-session-start.sh
PATH=/usr/local/bin:$PATH bash tests/codex/test-package-codex-plugin.sh
```

Expected: new prompt-router assertions fail because no router exists; existing SessionStart assertions remain green.

### Task 2: Implement the smallest Codex-only router — complete

**Files:**

- Modify: `hooks/hooks-codex.json`
- Create: `hooks/user-prompt-submit` and `hooks/user-prompt-submit.py`
- Modify: `scripts/package-codex-plugin.sh` only if its explicit file list excludes the new hook

**Interfaces:**

- Input: Codex UserPromptSubmit JSON (`cwd`, `prompt`, `hook_event_name`).
- Positive output: nested `UserPromptSubmit` `additionalContext` JSON.
- No-selection output: empty stdout and exit zero.

- [x] **Step 1: Add the event configuration**

Add one `UserPromptSubmit` command handler to `hooks/hooks-codex.json`. It uses the `PLUGIN_ROOT` dispatcher and no matcher because Codex ignores matchers for this event.

- [x] **Step 2: Parse event and resolve target evidence**

Create executable Bash entry point `hooks/user-prompt-submit` and adjacent standard-library implementation `hooks/user-prompt-submit.py`. The entry point forwards stdin directly to Python, avoiding user-prompt serialization through shell arguments or environment variables. It returns no output unless `hook_event_name == "UserPromptSubmit"` and `cwd`/`prompt` are strings. It rejects a documentation-only README/docs typo when no supported source target is explicit.

The Python code extracts an explicit `.rs`, `.go`, or `.swift` target. Without one, it accepts a named language only when the cwd has that language's nearest marker. It walks upward only from the target parent (or cwd) for Rust `Cargo.toml`, Go `go.mod`/`go.work`, or Swift `Package.swift`; it returns no selection for TypeScript-only, unsupported, conflicting, or unresolvable evidence.

- [x] **Step 3: Select one phase and inject its body**

Classify lowercase prompt text in this exact priority order:

```text
diagnose / hang / failure investigation -> debugging
review -> review
claim complete / exact checks / verification -> verification
skip failing test / production blocked -> testing
otherwise supported source modification -> implementation
otherwise -> no selection
```

Resolve one path under `skills/language-guidance/references/<language>/<phase>.md`, reject resolution outside that directory, then read and inject its body. The context must state: `This hook has already delivered the sole selected language guidance for this turn; do not select another language or phase unless new user evidence supersedes it.`

- [x] **Step 4: Verify GREEN and commit**

Run the Task 1 checks. Expected: all pass, malformed input fails open, and only the selected reference is injected. Then commit:

```bash
git add hooks/hooks-codex.json hooks/user-prompt-submit hooks/user-prompt-submit.py \
  tests/codex/test-marketplace-manifest.sh tests/hooks/test-session-start.sh \
  tests/codex/test-package-codex-plugin.sh scripts/package-codex-plugin.sh
git commit -m "fix: route Codex language guidance by prompt"
```

### Task 3: Validate the bounded runtime claim

**Files:**

- Create: `docs/wukong-code/evals/raw/2026-07-29-rust-language-guidance/candidate/transcripts/<candidate>/prompt-router/`
- Modify: `docs/wukong-code/evals/raw/2026-07-29-rust-language-guidance/candidate.md`
- Modify: `docs/wukong-code/evals/2026-07-29-rust-language-guidance.md`

**Interfaces:**

- Consumes: a local installation of the committed candidate and fixed scenarios.
- Produces: startup/hook context evidence, final responses, and a bounded pass/fail decision.

- [ ] **Step 1: Run focused sessions**

Run five R1 Rust implementations, two R4 Rust reviews, one Go review, one Swift verification, S7 TypeScript, and S8 documentation-only. Sessions are fresh, ephemeral, read-only, low-reasoning `gpt-5.6-terra`, using only the inspected local plugin and one-time hook-trust bypass.

Pass conditions:

```text
R1 context: Rust implementation and rust/implementation.md content
R4 context: Rust review and rust/review.md content
Go/Swift: only their selected language reference content
S7: explicit negative prompt-router context; S8: no prompt-router additionalContext
```

- [ ] **Step 2: Gate the full cohort**

Run no complete 48-session matrix unless every focused run passes its hook-context contract and no final response invents another selected language/phase. A failure is recorded once and stops the candidate; do not try a second routing heuristic.

- [ ] **Step 3: Record results and verify**

Run:

```bash
git diff --check
PATH=/usr/local/bin:$PATH bash tests/skills/test-language-guidance.sh
PATH=/usr/local/bin:$PATH bash tests/hooks/test-session-start.sh
PATH=/usr/local/bin:$PATH bash tests/codex/test-marketplace-manifest.sh
PATH=/usr/local/bin:$PATH bash tests/codex/test-package-codex-plugin.sh
```

Record only deterministic hook selection/delivery and observed response behavior. Do not claim autonomous Skill invocation or on-disk reference reads across every model/harness.
