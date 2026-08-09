# Product Design Core Completion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Complete the Product Design core integration with collision-free skill names, portable host/state behavior, distinct local-fork versioning, and evidence-backed routing and packaging verification.

**Architecture:** Replace the ten generic imported skill identities with a `product-design-*` namespace while preserving a one-to-one source mapping in `product-design.lock.json`. Keep one shared host-capability contract at repository root, centralize state-root resolution in a reusable Python module, and make every harness manifest advertise one synchronized prerelease version.

**Tech Stack:** Markdown skills/references, Bash regression tests, Python 3 standard library, JSON manifests, existing multi-harness test scripts.

## Global Constraints

- Work directly on `main` as explicitly requested; do not pull, rebase, push, or open a PR.
- Preserve the pre-existing untracked Java plan.
- Do not change Product Design template behavior or add dependencies; declaring
  the Node engine required by the existing locked toolchain is allowed.
- Keep all ten source capabilities and their local support files.
- Wukong primary process skills remain authoritative over Product Design domain guidance.
- Use `6.3.0-product-design.1` on every declared local-fork version surface.
- Each behavior or source change begins with a failing deterministic test.
- Fresh multi-session agent evals require explicit subagent authorization; prepare executable scenarios and report that gate if authorization remains absent.

---

### Task 1: Namespace all Product Design skills

**Files:**
- Modify: `tests/product-design/test-core-integration.sh`
- Rename: the ten imported skill directories under `skills/`
- Modify: the renamed `SKILL.md` files and local cross-links
- Modify: `references/critical-overrides.md`
- Modify: `product-design.lock.json`
- Modify: `README.md`

**Interfaces:**
- Consumes: the ten current generic skills.
- Produces: `product-design`, `product-design-audit`, `product-design-context`, `product-design-design-qa`, `product-design-ideate`, `product-design-image-to-code`, `product-design-research`, `product-design-share`, `product-design-url-to-code`, and `product-design-user-context`.

- [ ] **Step 1: Change the focused test to require the new mapping**

Require exact directory/frontmatter pairs and reject every legacy Product Design directory. Require all Product Design cross-skill links and `$skill` mentions to use the new names.

- [ ] **Step 2: Run RED**

Run: `bash tests/product-design/test-core-integration.sh`

Expected: nonzero exit reporting `skills/product-design/SKILL.md` missing.

- [ ] **Step 3: Rename directories and identities**

Apply this exact mapping:

```text
index         -> product-design
audit         -> product-design-audit
get-context   -> product-design-context
design-qa     -> product-design-design-qa
ideate        -> product-design-ideate
image-to-code -> product-design-image-to-code
research      -> product-design-research
share         -> product-design-share
url-to-code   -> product-design-url-to-code
user-context  -> product-design-user-context
```

Update frontmatter names, relative links, headings that present `$skill` names, router prose, and lock-file imported roots. Do not rename source-local scripts, references, or templates.

- [ ] **Step 4: Run GREEN and link checks**

Run: `bash tests/product-design/test-core-integration.sh`

Expected: exit zero with all legacy names absent.

### Task 2: Add portable host capability and state behavior

**Files:**
- Create: `references/product-design-host-capabilities.md`
- Create: `skills/product-design-user-context/scripts/state_paths.py`
- Create: `tests/product-design/test-user-context-state.py`
- Modify: `skills/product-design/SKILL.md`
- Modify: `skills/product-design-user-context/SKILL.md`
- Modify: `skills/product-design-user-context/references/onboarding.md`
- Modify: `skills/product-design-user-context/scripts/init_user_context.py`
- Modify: `skills/product-design-user-context/scripts/user_context_preflight.py`
- Modify: `tests/product-design/test-core-integration.sh`

**Interfaces:**
- Consumes: optional `--state-dir`, `PRODUCT_DESIGN_STATE_DIR`, `--codex-home`, `CODEX_HOME`, `XDG_STATE_HOME`, and the user's home directory.
- Produces: `resolve_state_dir(state_dir, codex_home, environ, home)` with priority: CLI state override, environment state override, explicit/ambient Codex home, existing legacy Codex state, XDG state, portable home fallback.

- [ ] **Step 1: Add failing state tests**

Test exact override priority, Codex compatibility, existing legacy migration, XDG resolution, and default `~/.local/state/wukong-code/product-design` behavior with isolated temporary homes.

- [ ] **Step 2: Run RED**

Run: `python3 -m unittest tests/product-design/test-user-context-state.py -v`

Expected: import failure because `state_paths.py` does not exist.

- [ ] **Step 3: Implement shared state resolution**

Both scripts import the new module. Retain `--codex-home` for compatibility, add `PRODUCT_DESIGN_STATE_DIR`, stop defaulting non-Codex hosts to `~/.codex`, and preserve an existing legacy context directory.

- [ ] **Step 4: Replace platform refusal with capability routing**

Link `references/product-design-host-capabilities.md` from the Product Design router. Define Codex/ChatGPT full paths, tool-capability predicates for other harnesses, sequential fallback when subagents are unavailable, and explicit blocking only for workflows that require unavailable source capture or deployment.

- [ ] **Step 5: Run GREEN**

Run: `python3 -m unittest tests/product-design/test-user-context-state.py -v && bash tests/product-design/test-core-integration.sh`

Expected: all tests pass without reading or writing the real home directory.

### Task 3: Distinguish the local fork version

**Files:**
- Modify: every file declared by `.version-bump.json`
- Modify: `product-design.lock.json`
- Modify: `README.md`
- Modify: `tests/product-design/test-core-integration.sh`

**Interfaces:**
- Consumes: current synchronized version `6.2.1`.
- Produces: synchronized local prerelease `6.3.0-product-design.1` across package, Codex, Claude, Cursor, Kimi, Gemini, and marketplace manifests.

- [ ] **Step 1: Add a failing local-fork version assertion**

Require `scripts/bump-version.sh --check` to report `6.3.0-product-design.1` and require README/lock metadata to identify the local fork version.

- [ ] **Step 2: Run RED**

Run: `bash tests/product-design/test-core-integration.sh`

Expected: nonzero exit showing current version `6.2.1`.

- [ ] **Step 3: Bump all declared versions**

Run: `bash scripts/bump-version.sh 6.3.0-product-design.1`

Review the audit output; no undeclared active manifest may retain `6.2.1`.

- [ ] **Step 4: Run GREEN**

Run: `bash scripts/bump-version.sh --check && bash tests/product-design/test-core-integration.sh`

Expected: all declared versions match and the focused integration test passes.

### Task 4: Add routing scenarios and complete cross-harness verification

**Files:**
- Create: `tests/product-design/routing-scenarios.md`
- Modify: `tests/product-design/test-core-integration.sh`
- Verify: Codex/Claude/Cursor/Kimi/OpenCode/Pi/Gemini integration surfaces

**Interfaces:**
- Consumes: the namespaced router, host contract, packaging paths, and harness manifests.
- Produces: positive/negative scenario expectations and fresh verification evidence for every supported harness test available in this checkout.

- [ ] **Step 1: Add routing scenarios**

Cover explicit Product Design invocation, design audit, URL clone, selected-image implementation, ordinary UI coding that remains Wukong-led, missing-browser blocking, no-subagent sequential fallback, and portable saved-context setup. Each scenario states the expected primary process plus focused Product Design skill.

- [ ] **Step 2: Validate scenario completeness statically**

Require all ten namespaced skill names and the negative ordinary-coding case to appear in the scenario file; require the router description to exclude ordinary implementation.

- [ ] **Step 3: Run repository verification**

Run the Product Design, template-contract, Codex package/sync/marketplace, Kimi, Pi, OpenCode, and shared skill-slim tests that exist locally. Do not install missing tools.

- [ ] **Step 4: Run fresh behavior sessions when authorized**

Use one fresh session per routing scenario, compare output against the scenario's required process/skill selection, and record verbatim failures. If subagent/session authorization is absent, leave this as the only explicit completion gate rather than claiming behavior has been proven.

### Task 5: Completion audit and direct-main commit

**Files:**
- Review: the complete integration range and current worktree

**Interfaces:**
- Consumes: Tasks 1–4 and the original integration design/review requirements.
- Produces: a requirement-by-requirement completion matrix, final direct-main commit, and either verified goal completion or one precise remaining authorization gate.

- [ ] **Step 1: Run full relevant verification and `git diff --check`**

Run:

```bash
bash tests/product-design/test-core-integration.sh
python3 -m unittest tests/product-design/test-user-context-state.py -v
node scripts/check-sites-starter-contract.mjs
bash tests/codex/test-package-codex-plugin.sh
bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh
bash tests/codex/test-marketplace-manifest.sh
bash tests/kimi/run-tests.sh
node --test tests/pi/test-pi-extension.mjs
bash tests/skills/test-skill-slim-gates.sh
git diff --check
```

Expected: every available command exits zero.

- [ ] **Step 2: Confirm no legacy generic Product Design directories, stale standalone-plugin paths, version drift, or untracked generated artifacts remain**

Run:

```bash
bash scripts/bump-version.sh --check
rg -n '/plugins/product-design/|python3 scripts/' skills/product-design* references
for path in audit design-qa get-context ideate image-to-code index research share url-to-code user-context; do test ! -e "skills/$path"; done
```

Expected: synchronized version output, no stale-path matches, and no legacy directories.

- [ ] **Step 3: Confirm the user's Java plan is untouched**

Run: `git status --short`

Expected: `docs/wukong-code/plans/2026-08-02-1220-java-language-guidance.md` remains the same pre-existing untracked file.

- [ ] **Step 4: Commit verified changes directly to `main` without pushing**

Run: stage only Task 1–4 paths, inspect `git diff --cached --check`, then commit with `git commit -m "feat: complete product design core integration"`.

- [ ] **Step 5: Mark the active goal complete only if every requirement, including fresh behavior evidence, is proven**

Evidence: the completion matrix must link each requirement to a passing command or inspected artifact; missing fresh-session behavior output keeps the goal active.
