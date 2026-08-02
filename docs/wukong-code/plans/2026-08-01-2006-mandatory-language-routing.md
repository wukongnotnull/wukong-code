# Mandatory Language Routing Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `wukong-code:subagent-driven-development` (recommended) or `wukong-code:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make automatic language-guidance selection mandatory for a supported,
evidence-established source-code task while retaining process-skill precedence.

**Architecture:** Change only the secondary-domain-routing statement injected by
the existing SessionStart bootstrap. A static shell assertion prevents it from
regressing to advisory language. Behavior evidence first targets the observed
Rust implementation/review failures, then checks Go, Swift, and non-source
negative controls before any complete cohort rerun.

**Tech Stack:** Markdown skills, Bash, Python standard library, existing Codex
SessionStart hook, fresh `codex-cli` behavior sessions.

## Global Constraints

- Preserve one primary process skill; language guidance is secondary only.
- Require routing only when a supported language is established by explicit
  source target or repository evidence.
- Do not route documentation-only or unsupported-language work.
- Do not modify Rust, Go, or Swift reference content, dependencies, target
  settings, or README status in this repair.
- Add no dependencies, tools, hook handlers, or network installation steps.
- Treat a behavior session as passing only when its required reference was
  actually read, not merely discovered.
- Do not claim experimental readiness or open a PR without a fresh complete
  cohort and human review.

---

### Task 1: Lock the mandatory-routing contract with a static RED/GREEN test

**Files:**

- Modify: `tests/skills/test-language-guidance.sh`
- Modify: `skills/using-wukong-code/SKILL.md`

**Interfaces:**

- Consumes: the SessionStart hook's existing full bootstrap injection of
  `skills/using-wukong-code/SKILL.md`.
- Produces: an explicit required-routing instruction and an executable guard
  that rejects advisory-only wording.

- [x] **Step 1: Write the failing static assertion**

Add these checks adjacent to the existing `Secondary domain guidance` checks:

```bash
assert_contains "$bootstrap" "For every qualifying task, load language-guidance as mandatory secondary domain guidance after the primary process is selected."
assert_contains "$bootstrap" "Automatic selection is required when supported-language evidence is established; it is not advisory."
```

- [x] **Step 2: Run the static check and verify RED**

Run:

```bash
PATH=/usr/local/bin:$PATH bash tests/skills/test-language-guidance.sh
```

Expected: non-zero status because the current bootstrap still contains
`automatic selection is advisory rather than a guarantee.`

- [x] **Step 3: Write the smallest bootstrap change**

Replace the two existing secondary-domain-routing sentences with:

```markdown
For every qualifying task, load language-guidance as mandatory secondary domain
guidance after the primary process is selected. It provides concrete technical
implementation guidance when it is loaded. Automatic selection is required
when supported-language evidence is established; it is not advisory.
```

Leave the following exclusions unchanged: documentation-only work,
unsupported languages, and ambiguous evidence load no language guidance.

- [x] **Step 4: Run the static check and verify GREEN**

Run:

```bash
PATH=/usr/local/bin:$PATH bash tests/skills/test-language-guidance.sh
PATH=/usr/local/bin:$PATH bash tests/hooks/test-session-start.sh
```

Expected: both exit zero; the hook still emits valid Codex nested startup
context and the static test observes mandatory, not advisory, routing.

- [x] **Step 5: Commit the isolated repair**

```bash
git add skills/using-wukong-code/SKILL.md tests/skills/test-language-guidance.sh
git commit -m "fix: require evidence-bound language routing"
```

### Task 2: Evaluate the repaired automatic routing before full rescore

**Files:**

- Create: `docs/wukong-code/evals/raw/2026-07-29-rust-language-guidance/candidate/transcripts/<candidate>/focused/`
- Modify: `docs/wukong-code/evals/raw/2026-07-29-rust-language-guidance/candidate.md`
- Modify: `docs/wukong-code/evals/2026-07-29-rust-language-guidance.md`

**Interfaces:**

- Consumes: the committed Task 1 candidate installed as a local Codex plugin.
- Produces: raw final responses, session IDs, and an explicit pass/fail decision
  for proceeding to the complete cohort.

- [x] **Step 1: Run a focused fresh-session matrix**

Use fresh ephemeral, read-only Codex CLI sessions with the same model,
reasoning effort, fixture isolation, and hook-trust treatment as the prior
`6b72e43` cohort. Run five R1 implementation repetitions, two R4 review
repetitions, one Go review regression, one Swift verification regression, and
one each of S7 unsupported TypeScript and S8 documentation-only control.

Expected Rust checks:

```text
R1: Phase: implementation; reads rust/profile.md and rust/implementation.md.
R4: Phase: review; reads rust/review.md.
```

Expected controls: Go and Swift load only their own selected reference;
TypeScript and documentation-only prompts do not invent or load a Rust path.

- [x] **Step 2: Apply the gate**

Proceed only if all 11 sessions meet their exact selected-reference contract.
If any fail, record the transcript and stop without a second wording change.

- [ ] **Step 3: Run the complete cohort only after the focused gate passes**

Repeat the fixed 48-session ordinary, adversarial, and regression matrix from
`tests/skills/language-guidance-scenarios.md`. Preserve every final response,
session ID, command restriction, and failure reason. A complete cohort with
any strict routing failure is failing evidence, not averaged with retries.

- [x] **Step 4: Record results and verify documentation integrity**

Run:

```bash
git diff --check
PATH=/usr/local/bin:$PATH bash tests/skills/test-language-guidance.sh
PATH=/usr/local/bin:$PATH bash tests/hooks/test-session-start.sh
PATH=/usr/local/bin:$PATH bash tests/codex/test-marketplace-manifest.sh
```

Expected: documentation is whitespace-clean and static/hook/manifest checks
pass. Preserve a failing focused or complete behavior outcome verbatim; do not
describe it as experimental-ready.
