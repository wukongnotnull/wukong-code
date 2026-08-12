# Frontend Design Fold-In Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Move the behaviorally useful parts of the standalone `frontend-design` skill into Product Design's original-direction ideation path, then remove the standalone skill without changing fidelity-preserving Product Design routes.

**Architecture:** Keep `product-design` as the routing owner and `product-design-ideate` as the only consumer of an internal visual-direction reference. Move the Apache-2.0 attribution and license to the Product Design reference boundary, remove the top-level skill, and change static packaging/integrity contracts so the standalone skill cannot return accidentally.

**Tech Stack:** Markdown skills and references, Bash integration tests, Node.js integrity tooling, JSON lock metadata, Codex packaging tests.

## Global Constraints

- Preserve Product Design's positive route: original visual directions and substantial redesigns receive distinctive visual-direction guidance.
- Preserve negative routes: research, audits, faithful URL clones, selected-visual implementation, design QA, and sharing do not receive original-direction guidance.
- Use the RED baseline in `docs/wukong-code/evaluation-results/2026-08-12-frontend-design-fold-in-baseline.md`; do not duplicate behavior Product Design already supplies.
- Require these new observable fields per original direction: one signature element, one justified aesthetic risk, and one pre-generation anti-template critique with the changed choice.
- Preserve subject grounding and end-user interface-copy guidance in concise form.
- Preserve Apache-2.0 attribution, a prominent modification notice, and the full license text after deleting `skills/frontend-design/`.
- Do not modify or stage the human partner's unrelated changes in `.github/PULL_REQUEST_TEMPLATE.md`, `CLAUDE.md`, `docs/README.kimi.md`, or `docs/porting-to-a-new-harness.md`.
- Do not push or open a pull request until the human partner explicitly selects the publish option and approves the complete proposed diff.

---

### Task 1: Convert routing and packaging contracts to the folded architecture

**Files:**

- Modify: `tests/product-design/test-core-integration.sh`
- Modify: `tests/product-design/routing-scenarios.md`
- Modify: `tests/codex/test-package-codex-plugin.sh`

**Interfaces:**

- Consumes: the standalone `frontend-design` routing and package assertions.
- Produces: failing assertions for an internal Product Design reference, the three required direction fields, fidelity-route exclusions, removal of the standalone directory, and packaged Apache license preservation.

- [ ] **Step 1: Replace standalone routing assertions**

Require `skills/product-design-ideate/SKILL.md` to load `references/original-visual-direction.md` only for original directions and substantial redesigns. Require the reference to name `Signature element`, `Justified aesthetic risk`, and `Anti-template critique`. Require `skills/product-design` and the composition contract to preserve the positive and negative route classes without naming a separately loaded skill.

- [ ] **Step 2: Add removal and license assertions**

Require `skills/frontend-design` to be absent; require the internal reference and `references/licenses/frontend-design-APACHE-2.0.txt` to exist; require the reference to identify Anthropic as its source and state that it was modified for Product Design.

- [ ] **Step 3: Update Codex package assertions**

Require the archive to exclude `skills/frontend-design/SKILL.md` and include the internal visual-direction reference and its Apache license.

- [ ] **Step 4: Verify the new contracts fail for the expected missing architecture**

Run:

```bash
bash tests/product-design/test-core-integration.sh
bash tests/codex/test-package-codex-plugin.sh
```

Expected: nonzero exits because the internal Product Design reference and relocated license do not exist, while the standalone skill still exists.

---

### Task 2: Fold the minimal visual-direction guidance into Product Design

**Files:**

- Create: `skills/product-design-ideate/references/original-visual-direction.md`
- Create: `references/licenses/frontend-design-APACHE-2.0.txt`
- Modify: `skills/product-design/SKILL.md`
- Modify: `skills/product-design-ideate/SKILL.md`
- Modify: `references/wukong-product-design-composition.md`
- Delete: `skills/frontend-design/SKILL.md`
- Delete: `skills/frontend-design/LICENSE.txt`

**Interfaces:**

- Consumes: RED gaps from the baseline; current inclusion/exclusion rules; Apache-2.0 source text.
- Produces: one on-demand reference loaded only for original directions and substantial redesigns; no standalone discoverable `frontend-design` skill.

- [ ] **Step 1: Create the internal reference**

Write a concise reference that requires this direction-plan shape:

```text
Subject / audience / primary job
Visual system: palette, typography, layout
Signature element: one memorable brief-specific device
Justified aesthetic risk: one concentrated risk and why it serves the brief
Interface language: realistic end-user copy with consistent action names
Anti-template critique: generic choice detected → replacement choice
```

It must state that supplied evidence, brand systems, selected visuals, user constraints, and Product Design contracts are authoritative. It must not introduce new aesthetics to fidelity workflows.

- [ ] **Step 2: Preserve attribution and license**

Add a header identifying the reference as adapted from Anthropic's `frontend-design` skill under Apache-2.0 and stating that it has been modified and narrowed for Product Design. Copy the full existing Apache-2.0 license to `references/licenses/frontend-design-APACHE-2.0.txt`.

- [ ] **Step 3: Change the router and ideation consumer**

Replace the standalone-skill load instruction with the internal reference load. Keep the existing observable inclusion and exclusion predicates. Feed the reference's required shape into each of the three ImageGen prompts.

- [ ] **Step 4: Update authority wording**

Replace composition-contract references to a secondary top-level skill with the internal original-direction guidance at the same lowest authority level.

- [ ] **Step 5: Remove the standalone skill**

Delete the standalone `SKILL.md` and its colocated license only after the relocated license and internal reference exist.

- [ ] **Step 6: Run focused contracts**

Run:

```bash
bash tests/product-design/test-core-integration.sh
bash tests/codex/test-package-codex-plugin.sh
```

Expected: routing, removal, license, and packaging assertions pass except for the stale Product Design integrity digest.

---

### Task 3: Synchronize integrity, notices, and multilingual documentation

**Files:**

- Modify: `product-design.lock.json`
- Modify: `THIRD_PARTY_NOTICES.md`
- Modify: `README.md`
- Modify: `README.zh-CN.md`
- Modify: `README.zh-TW.md`
- Modify: `README.ja.md`
- Modify: `README.ko.md`

**Interfaces:**

- Consumes: the folded skill architecture from Task 2.
- Produces: a deterministic Product Design lock, compliant attribution, and five READMEs that advertise 26 top-level skills (16 general + 10 Product Design) without listing `frontend-design` independently.

- [ ] **Step 1: Update lock metadata**

The new ideation reference is already covered by the existing `skills/product-design-ideate` imported root; do not add an overlapping root. Add only `references/licenses/frontend-design-APACHE-2.0.txt` to the imported roots. Add a local adaptation describing the folded visual-direction guidance. Compute the replacement digest with:

```bash
node scripts/check-product-design-import.mjs --print
```

Write the exact digest to `product-design.lock.json`.

- [ ] **Step 2: Update third-party notices**

Add a distinct Anthropic Frontend Design subsection that identifies the adapted reference, links its source, states it was modified and narrowed, and points to the full Apache-2.0 license file.

- [ ] **Step 3: Update all five READMEs**

Change the inventory from 27 to 26 and general development skills from 17 to 16. Remove the standalone Frontend Design row. In the Product Design ideation row, explain that original directions include subject-grounded, intentional visual direction and anti-template critique adapted from Anthropic's guidance. Keep all 10 Product Design skill names unchanged.

- [ ] **Step 4: Verify synchronization**

Run:

```bash
node scripts/check-product-design-import.mjs
git diff --check -- README.md README.zh-CN.md README.zh-TW.md README.ja.md README.ko.md
```

Expected: integrity passes and the five README files have no whitespace errors.

---

### Task 4: Run GREEN and REFACTOR behavior evaluations

**Files:**

- Modify: `docs/wukong-code/evaluation-results/2026-08-12-frontend-design-fold-in-baseline.md`

**Interfaces:**

- Consumes: the three RED scenarios and the new internal reference.
- Produces: fresh-session GREEN results for the positive routes and explicit negative-control results for fidelity routes.

- [ ] **Step 1: Run five fresh samples per positive scenario**

For the ceramic studio, SaaS dashboard, and jazz club prompts, inspect every output. Each must include the seven rubric fields, especially an explicit signature element, justified risk, and anti-template critique with a replacement.

- [ ] **Step 2: Run fidelity negative controls**

Run fresh scenarios for an evidence-based audit, faithful URL clone, and implementation from a selected screenshot. They must not load or apply original-direction guidance.

- [ ] **Step 3: Refactor only observed gaps**

If a field is missing or an excluded route invents a new aesthetic direction, tighten the smallest observable recipe or predicate and repeat all affected samples. Do not add broad prohibitions for output-shape failures.

- [ ] **Step 4: Record complete verdicts**

Append per-scenario counts, failures, manual-inspection notes, and the final GREEN/REFACTOR verdict to the evaluation report.

---

### Task 5: Full verification and human handoff

**Files:**

- Verify: all paths changed in Tasks 1–4.

**Interfaces:**

- Consumes: completed implementation and behavior evidence.
- Produces: repository verification evidence and a complete diff for human approval.

- [ ] **Step 1: Run repository checks**

```bash
node scripts/check-product-design-import.mjs
node --test tests/product-design/test-import-integrity.mjs
bash tests/product-design/test-core-integration.sh
bash tests/codex/test-package-codex-plugin.sh
npm test
```

Expected: all checks pass. If the known ignored `skills/.DS_Store` blocks the Product Design integration suite, report it as a pre-existing environmental blocker rather than deleting it without permission.

- [ ] **Step 2: Verify removal and attribution**

```bash
test ! -e skills/frontend-design
rg -n 'frontend-design' skills references tests README*.md THIRD_PARTY_NOTICES.md product-design.lock.json
git diff --check
```

Expected: no operational reference treats `frontend-design` as a standalone skill; attribution and historical evaluation references may still name the source.

- [ ] **Step 3: Review scope**

Confirm unrelated human changes remain unstaged and absent from the diff for this task.

- [ ] **Step 4: Present the complete diff**

Show the human partner the changed-file list, behavior evidence, license handling, verification results, and any remaining blocker before committing or opening a PR.
