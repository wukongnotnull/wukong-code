# Product Design and Frontend Design Composition Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make Product Design automatically compose the independent `frontend-design` skill into original visual design and substantial redesign ideation while excluding every fidelity-preserving and read-only workflow.

**Architecture:** Keep `frontend-design` byte-for-byte unchanged and add a three-layer composition contract: the Product Design router selects the branch, the shared composition reference resolves authority, and `product-design-ideate` applies the visual guidance before ImageGen. Develop the behavior with matched fresh-session RED/GREEN controls, deterministic routing assertions, and the existing Product Design integrity lock.

**Tech Stack:** Markdown skills and evaluation records, Bash integration checks, Node.js SHA-256 import-integrity checker, Codex fresh-context subagents.

## Global Constraints

- Preserve `skills/frontend-design/SKILL.md` and `skills/frontend-design/LICENSE.txt` byte-for-byte.
- Load `frontend-design` only for original visual directions and substantial redesigns.
- Exclude audits, research-only requests, faithful URL clones, selected-visual implementation, design QA, sharing, and ordinary UI implementation.
- Explicit user constraints, supplied or saved evidence, existing design systems, and approved visual targets remain authoritative.
- Wukong process gates remain primary; `frontend-design` loads only after the governing process permits secondary domain guidance.
- Product Design still generates exactly three independent visual options and waits for selection before build work.
- Add no dependency, template, browser, asset, hosting, or runtime behavior.
- Use `wukong-code:writing-skills` RED-GREEN-REFACTOR: no skill edit before a failing behavioral or deterministic control is captured.
- Use fresh child contexts with `fork_turns: none`, neutral sample IDs, no expected answer in dispatch prompts, and at most three concurrent children.
- Read every child response manually; keyword counts alone are not behavioral evidence.
- Keep all work on `codex/product-design-frontend-design-composition`; do not push or open a pull request.
- Use `apply_patch` for repository edits. Force-add evaluation records because the repository's unanchored `evals/` ignore rule hides `docs/wukong-code/evals/`.
- Preserve the ignored user-local `skills/.DS_Store`. The Product Design core
  test rejects it, so every invocation temporarily moves it into a unique
  `mktemp` directory and restores it with an EXIT trap; never delete or stage
  it.

---

## File Map

- Modify `tests/product-design/routing-scenarios.md`: executable fresh-session prompts and positive/negative answer key.
- Modify `tests/product-design/test-core-integration.sh`: deterministic presence, exclusion, and scenario-coverage checks.
- Modify `skills/product-design/SKILL.md`: inclusion decision and explicit exclusion boundary.
- Modify `references/wukong-product-design-composition.md`: authority order and lifecycle-gate composition contract.
- Modify `skills/product-design-ideate/SKILL.md`: eligible loading step and art-direction output recipe.
- Modify `product-design.lock.json`: new digest for changed imported Product Design content only.
- Create `docs/wukong-code/evals/raw/2026-08-12-product-design-frontend-composition/red.md`: complete no-guidance control transcripts.
- Create `docs/wukong-code/evals/raw/2026-08-12-product-design-frontend-composition/green.md`: complete candidate-guidance transcripts.
- Create `docs/wukong-code/evals/raw/2026-08-12-product-design-frontend-composition/refactor.md`: ambiguous-boundary probes and any wording iterations.
- Create `docs/wukong-code/evals/2026-08-12-product-design-frontend-composition.md`: curated methodology, results, failure mapping, checks, and limitations.

---

### Task 1: Define the Routing Contract and Capture RED

**Files:**
- Modify: `tests/product-design/routing-scenarios.md`
- Modify: `tests/product-design/test-core-integration.sh`
- Create: `docs/wukong-code/evals/raw/2026-08-12-product-design-frontend-composition/red.md`

**Interfaces:**
- Consumes: the approved spec at `docs/wukong-code/specs/2026-08-12-1412-product-design-frontend-design-composition-design.md` and the current Product Design skills at commit `e64c5d5`.
- Produces: scenario IDs `PD9` through `PD11`, strengthened `PD2` through `PD5` expectations, a deterministic failing test, initial frontend hashes, and complete no-guidance control transcripts.

- [ ] **Step 1: Verify the existing Product Design baseline before changing tests**

Run:

```bash
(
  pd_metadata_tmp="$(mktemp -d)"
  pd_metadata_saved=0
  restore_pd_metadata() {
    if (( pd_metadata_saved )); then
      mv "$pd_metadata_tmp/skills.DS_Store" skills/.DS_Store
    fi
    rmdir "$pd_metadata_tmp"
  }
  trap restore_pd_metadata EXIT
  if [[ -f skills/.DS_Store ]]; then
    mv skills/.DS_Store "$pd_metadata_tmp/skills.DS_Store"
    pd_metadata_saved=1
  fi
  bash tests/product-design/test-core-integration.sh
  node --test tests/product-design/test-import-integrity.mjs
  shasum -a 256 skills/frontend-design/SKILL.md skills/frontend-design/LICENSE.txt
)
```

Expected: both tests exit zero. Record the two frontend hashes at the top of `red.md`; they are the immutable comparison values for Task 4.

- [ ] **Step 2: Add the exact scenario contract before editing any skill**

Append these scenarios to `tests/product-design/routing-scenarios.md`:

```markdown
## PD9: Original Product Design direction

Prompt: `Use Product Design to create three original visual directions for a new independent-bookstore landing page. There is no existing visual target.`

Expected:

- Primary process: `brainstorming`; its design gate remains authoritative.
- Skills after the governing process permits domain guidance:
  `product-design`, `frontend-design`, `product-design-user-context`,
  `product-design-context`, and `product-design-ideate`.
- `frontend-design` grounds the subject, audience, page job, visual system,
  signature element, and anti-template critique before ImageGen prompts.
- The agent waits for the user to select one of exactly three visual options.

## PD10: Substantial redesign from a URL

Prompt: `Use Product Design to redesign https://example.com/account into a new premium direction. Treat the current page as context, not a visual target to clone.`

Expected:

- Primary process: `brainstorming`; its design gate remains authoritative.
- Skills after the governing process permits domain guidance:
  `product-design`, `frontend-design`, `product-design-user-context`,
  `product-design-context`, and `product-design-ideate`.
- The current URL is captured as evidence, while `frontend-design` may shape
  only the visual axes the redesign brief leaves open.
- It does not route to `product-design-url-to-code` as a faithful clone.

## PD11: Research-only Product Design request

Prompt: `Use Product Design to research current onboarding pain for this product. Report findings only; do not redesign or implement anything.`

Expected:

- Primary process: direct read-only research path.
- Skills: `product-design`, `product-design-user-context`, and
  `product-design-research`.
- `frontend-design` does not load because no visual direction is being
  invented.
```

Also add these exact bullets to the existing scenarios:

```markdown
PD2: - `frontend-design` does not load for an evidence-based audit.
PD3: - `frontend-design` loads after the brainstorming gate and before `product-design-ideate` because the request asks for new visual directions.
PD4: - `frontend-design` does not load; the captured URL is authoritative.
PD5: - `frontend-design` does not load again; the selected image is authoritative.
```

- [ ] **Step 3: Add deterministic assertions that must initially fail**

In `tests/product-design/test-core-integration.sh`, change the scenario loop to:

```bash
for scenario in PD1 PD2 PD3 PD4 PD5 PD6 PD7 PD8 PD9 PD10 PD11; do
  grep -Fq "## $scenario:" "$ROUTING_SCENARIOS" ||
    fail "routing scenarios are missing $scenario"
done
```

Then add these assertions after the existing composition-contract checks:

```bash
grep -Fq 'Original visual directions and substantial redesigns load `$frontend-design`' \
  "$REPO_ROOT/skills/product-design/SKILL.md" ||
  fail "Product Design router does not include frontend-design for original directions"
grep -Fq 'Faithful workflows exclude `$frontend-design`' \
  "$REPO_ROOT/references/wukong-product-design-composition.md" ||
  fail "composition contract does not protect fidelity workflows"
grep -Fq '[$frontend-design](../frontend-design/SKILL.md)' \
  "$REPO_ROOT/skills/product-design-ideate/SKILL.md" ||
  fail "Product Design ideation does not load frontend-design"
grep -Fq 'frontend-design does not load' "$ROUTING_SCENARIOS" ||
  fail "routing scenarios do not contain a frontend-design negative control"
```

- [ ] **Step 4: Run deterministic RED**

Run:

```bash
(
  pd_metadata_tmp="$(mktemp -d)"
  pd_metadata_saved=0
  restore_pd_metadata() {
    if (( pd_metadata_saved )); then
      mv "$pd_metadata_tmp/skills.DS_Store" skills/.DS_Store
    fi
    rmdir "$pd_metadata_tmp"
  }
  trap restore_pd_metadata EXIT
  if [[ -f skills/.DS_Store ]]; then
    mv skills/.DS_Store "$pd_metadata_tmp/skills.DS_Store"
    pd_metadata_saved=1
  fi
  bash tests/product-design/test-core-integration.sh
)
```

Expected: nonzero exit with `Product Design router does not include frontend-design for original directions`. If it fails earlier, fix only the scenario/test syntax until this exact missing-production-contract failure is reached.

- [ ] **Step 5: Create the RED evidence header and rubric**

Create `red.md` with these required fields:

```markdown
# Product Design / Frontend Design RED Evidence — 2026-08-12

## Methodology

- Harness and version: write the exact values exposed by the runtime; write
  `not exposed by this runtime` for any unavailable version.
- Model and version/ID: write the exact values exposed by the runtime; write
  `not exposed by this runtime` for any unavailable identifier.
- Installed plugins: write the complete plugin list visible to the session.
- Isolation: fresh contexts with `fork_turns: none`; maximum three concurrent.
- Candidate state: Product Design files from commit `e64c5d5`, before composition edits.
- Frontend file SHA-256: copy the two exact Step 1 hash lines.
- Scoring: manual review of every complete response.

## Critical Verdict Contract

A sample fails if it includes `frontend-design` on an excluded route, omits it
on an eligible route, lets it override user/source/design-system constraints,
loads it before the Wukong lifecycle gate permits domain guidance, or replaces
the three visual options with prose or ASCII output.
```

When a runtime field is not exposed, write `not exposed by this runtime`; do not infer a value.

- [ ] **Step 6: Run the matched no-guidance controls**

Dispatch fresh children against the current unmodified Product Design skills. Each child receives only:

```text
Use the Product Design capability rooted at
/Users/wukong/Documents/wukong-code/skills/product-design/SKILL.md for this
request. Inspect only the skill files needed to decide the route. Do not edit
files, generate images, open a browser, or deploy. Return the exact primary
process and skill sequence you would use, followed by the first user-facing
action you would take.
```

Append one exact natural prompt from PD2, PD3, PD4, PD5, PD9, PD10, or PD11
to each dispatch. Do not append the scenario label or its Expected section.

Run five independent repetitions of PD9 and five of PD4. Run one repetition each of PD2, PD3, PD5, PD10, and PD11. Use neutral child task names such as `sample_001`; do not include scenario IDs, expected skills, the spec, this plan, rubric, or candidate wording in dispatch prompts.

Expected RED: at least one PD9 repetition omits `frontend-design`. Negative controls must be scored even if they pass. If every positive and negative sample already passes, write `NO CHANGE JUSTIFIED`, revert Task 1 test/scenario changes, and stop before Task 2.

- [ ] **Step 7: Preserve and score every RED response verbatim**

For each of the 15 samples, create a `### sample_NNN` section and record the
exact natural prompt, a `TARGET PASS` or `TARGET FAIL` critical verdict, the
specific observed route or authority behavior, a verbatim rationalization or
interpretation when present (otherwise the literal word `none`), and the
complete child response as a block quote.

End with a result table by scenario and list the exact recurring failure shapes that Task 2 must address.

- [ ] **Step 8: Commit the RED contract and evidence**

Run:

```bash
git add tests/product-design/routing-scenarios.md tests/product-design/test-core-integration.sh
git add -f docs/wukong-code/evals/raw/2026-08-12-product-design-frontend-composition/red.md
git diff --cached --check
git commit -m "test: define frontend design composition controls"
```

Expected: one commit containing tests, scenarios, and RED evidence only; no Product Design skill or reference file is changed.

---

### Task 2: Implement the Minimum Composition Contract

**Files:**
- Modify: `skills/product-design/SKILL.md`
- Modify: `references/wukong-product-design-composition.md`
- Modify: `skills/product-design-ideate/SKILL.md`
- Modify: `product-design.lock.json`

**Interfaces:**
- Consumes: the exact RED failure shapes from Task 1.
- Produces: one observable inclusion predicate, one exclusion predicate, one authority order, and one ideation output recipe without changing `frontend-design`.

- [ ] **Step 1: Add the router's inclusion and exclusion predicates**

In `skills/product-design/SKILL.md`, add this section after `## Process Selection`:

```markdown
## Frontend Design Composition

Original visual directions and substantial redesigns load `$frontend-design`
after the governing Wukong process permits secondary domain guidance and
before `$product-design-ideate`. This includes new products, pages, screens,
or features with no selected visual target, plus redesigns that may
intentionally depart from their source.

Audits, research-only requests, faithful URL clones, selected-visual
implementations, design QA, sharing, and ordinary UI implementation do not
load `$frontend-design`. For URL requests, `clone`, `recreate`, or `match
faithfully` selects the fidelity branch; `redesign`, `new direction`, or
`inspired by` selects the original-direction branch. If the wording leaves
that choice materially ambiguous, ask one targeted fidelity question.
```

Update the `$product-design-ideate` router entry with one sentence pointing back to this section. Do not duplicate the full matrix elsewhere in the router.

- [ ] **Step 2: Add the shared authority contract**

In `references/wukong-product-design-composition.md`, add:

```markdown
## Frontend visual guidance

Original visual directions and substantial redesigns may load
`frontend-design` as secondary visual-domain guidance after the selected
Wukong lifecycle gate permits it. Resolve conflicts in this order:

1. Explicit human-partner requirements and hard constraints.
2. Supplied or saved source evidence, existing design systems, brand assets,
   tokens, and approved visual targets.
3. The selected Wukong process and its lifecycle gates.
4. Product Design workflow contracts.
5. `frontend-design` choices on visual axes the brief leaves open.

Faithful workflows exclude `$frontend-design`: audits, research-only work, URL
clones, selected-visual implementation, design QA, and sharing preserve their
source of truth. `frontend-design` cannot waive the three-option selection
gate, replace image options with prose or ASCII wireframes, or authorize
implementation.
```

- [ ] **Step 3: Add the ideation recipe without copying the upstream skill**

In `skills/product-design-ideate/SKILL.md`, add this section immediately before `## Workflow`:

```markdown
## Frontend Design Composition

For an original visual direction or substantial redesign, load
[$frontend-design](../frontend-design/SKILL.md) after the governing Wukong
process permits secondary domain guidance and before preparing Image Gen
prompts. Do not load it for a faithful clone or an already-selected visual
target.

Use the loaded guidance to define, for each direction:

- one concrete subject, intended audience, and primary surface job;
- a deliberate palette, typography system, and layout concept;
- one signature element and one justified aesthetic risk;
- realistic subject-specific content; and
- a pre-generation critique that replaces generic AI defaults not required by
  the brief.

Product Design evidence and constraints remain authoritative. Feed this design
plan into the three independent Image Gen prompts; do not show a prose or ASCII
mock as a substitute for the required images.
```

- [ ] **Step 4: Confirm only intended imported files changed**

Run:

```bash
git diff -- skills/product-design/SKILL.md references/wukong-product-design-composition.md skills/product-design-ideate/SKILL.md
git diff --exit-code -- skills/frontend-design/SKILL.md skills/frontend-design/LICENSE.txt
```

Expected: the first command shows only the three approved composition edits; the second exits zero with no output.

- [ ] **Step 5: Update the Product Design integrity digest**

Run:

```bash
node scripts/check-product-design-import.mjs --root "$PWD" --print
```

Use `apply_patch` to replace only `product-design.lock.json` → `integrity.value` with the printed lowercase SHA-256 value. Do not change `imported_roots`, upstream Product Design version, Wukong Code version, license, or distribution.

- [ ] **Step 6: Run deterministic GREEN**

Run:

```bash
(
  pd_metadata_tmp="$(mktemp -d)"
  pd_metadata_saved=0
  restore_pd_metadata() {
    if (( pd_metadata_saved )); then
      mv "$pd_metadata_tmp/skills.DS_Store" skills/.DS_Store
    fi
    rmdir "$pd_metadata_tmp"
  }
  trap restore_pd_metadata EXIT
  if [[ -f skills/.DS_Store ]]; then
    mv skills/.DS_Store "$pd_metadata_tmp/skills.DS_Store"
    pd_metadata_saved=1
  fi
  bash tests/product-design/test-core-integration.sh
  node --test tests/product-design/test-import-integrity.mjs
)
```

Expected: both commands exit zero. Do not commit yet; behavior GREEN is the deployment gate in Task 3.

---

### Task 3: Prove GREEN, Probe the Boundary, and Record the Evaluation

**Files:**
- Create: `docs/wukong-code/evals/raw/2026-08-12-product-design-frontend-composition/green.md`
- Create: `docs/wukong-code/evals/raw/2026-08-12-product-design-frontend-composition/refactor.md`
- Create: `docs/wukong-code/evals/2026-08-12-product-design-frontend-composition.md`
- Potentially modify only when a recorded failure requires it: `skills/product-design/SKILL.md`, `references/wukong-product-design-composition.md`, `skills/product-design-ideate/SKILL.md`, `product-design.lock.json`

**Interfaces:**
- Consumes: Task 1 prompts and rubric, Task 2 candidate wording, and complete RED evidence.
- Produces: matched before/after results, ambiguous-language boundary evidence, a failure-to-guidance map, and a final candidate that passes fresh controls after its last wording change.

- [ ] **Step 1: Run matched GREEN controls**

Repeat the exact 15 Task 1 dispatches with fresh neutral child names and `fork_turns: none`. The only setup difference is that children read the candidate Product Design files from the current branch. Do not show them RED results, expected routes, the rubric, or candidate rationale.

Expected: every eligible PD3/PD9/PD10 sample includes `frontend-design` after the Wukong gate and before ideation; every PD2/PD4/PD5/PD11 sample excludes it.

- [ ] **Step 2: Preserve and manually score every GREEN response**

Use the same per-sample fields as `red.md`. The summary must show matched RED and GREEN counts separately for PD9 and PD4's five repetitions, plus individual results for PD2, PD3, PD5, PD10, and PD11.

- [ ] **Step 3: Run ambiguous-language REFACTOR probes**

Run two fresh repetitions of each prompt:

```text
Use Product Design to make https://example.com/account better.
Use Product Design to create a new account experience inspired by https://example.com/account.
Use Product Design to match https://example.com/account but modernize it.
```

Pass rules:

- `make ... better` asks one targeted fidelity question because departure is ambiguous.
- `inspired by` routes to substantial redesign and includes `frontend-design`.
- `match ... but modernize` asks one targeted fidelity question because its directives conflict.

Record all six complete responses in `refactor.md`.

- [ ] **Step 4: Apply only evidence-justified wording refinements**

Use this decision table:

| Observed failure | Allowed minimal refinement |
|---|---|
| Eligible route omits `frontend-design` | Make the positive predicate a required ordered step in both router and ideate sections. |
| Fidelity route includes `frontend-design` | Add that exact observable route to the exclusion sentence; do not add broad UI exclusions. |
| Guidance overrides evidence or design system | Tighten the numbered authority order in the composition reference. |
| Ambiguous wording is guessed | Add the exact failed phrase family to the one-question predicate. |
| Prose/ASCII substitutes for images | Tighten the positive output recipe in ideate; do not add a rationalization table. |

After any wording change, update the lock digest and run a completely fresh 15-sample GREEN cohort plus all six ambiguity probes. Earlier passing samples cannot prove the final wording. Continue until one unchanged candidate passes every control or a new failure repeats for three iterations and requires human direction.

- [ ] **Step 5: Write the curated evaluation report**

Create `docs/wukong-code/evals/2026-08-12-product-design-frontend-composition.md` with these sections:

```markdown
# Product Design / Frontend Design Composition Evaluation — 2026-08-12

## Methodology
## Critical Verdict Contract
## RED Results
## GREEN and REFACTOR Results
## Routing Matrix
## RED-to-GREEN Failure Mapping
## Static Validation
## Limitations
## Conclusion
```

Link the three raw evidence files. State exact harness/model/plugin metadata when exposed and explicit limitations when not exposed. Do not claim implicit cross-harness discovery unless it was actually tested.

- [ ] **Step 6: Re-run deterministic checks after the final wording**

Run:

```bash
(
  pd_metadata_tmp="$(mktemp -d)"
  pd_metadata_saved=0
  restore_pd_metadata() {
    if (( pd_metadata_saved )); then
      mv "$pd_metadata_tmp/skills.DS_Store" skills/.DS_Store
    fi
    rmdir "$pd_metadata_tmp"
  }
  trap restore_pd_metadata EXIT
  if [[ -f skills/.DS_Store ]]; then
    mv skills/.DS_Store "$pd_metadata_tmp/skills.DS_Store"
    pd_metadata_saved=1
  fi
  bash tests/product-design/test-core-integration.sh
  node --test tests/product-design/test-import-integrity.mjs
  git diff --check
)
```

Expected: all exit zero.

- [ ] **Step 7: Commit the candidate and evaluation evidence**

Run:

```bash
git add skills/product-design/SKILL.md \
  references/wukong-product-design-composition.md \
  skills/product-design-ideate/SKILL.md \
  product-design.lock.json
git add -f \
  docs/wukong-code/evals/raw/2026-08-12-product-design-frontend-composition/green.md \
  docs/wukong-code/evals/raw/2026-08-12-product-design-frontend-composition/refactor.md \
  docs/wukong-code/evals/2026-08-12-product-design-frontend-composition.md
git diff --cached --check
git commit -m "feat: compose frontend design into Product Design ideation"
```

Expected: the commit contains the three contract edits, lock update, and complete evaluation evidence. `frontend-design` remains absent from the diff.

---

### Task 4: Run Final Verification and Audit the Complete Diff

**Files:**
- Verify: all Task 1–3 paths and the immutable `skills/frontend-design` files.

**Interfaces:**
- Consumes: the two implementation commits and the approved design specification.
- Produces: fresh deterministic test output, unchanged upstream hashes, a requirement-to-evidence audit, and a complete diff ready for human review.

- [ ] **Step 1: Run the full relevant verification suite**

Run:

```bash
(
  pd_metadata_tmp="$(mktemp -d)"
  pd_metadata_saved=0
  restore_pd_metadata() {
    if (( pd_metadata_saved )); then
      mv "$pd_metadata_tmp/skills.DS_Store" skills/.DS_Store
    fi
    rmdir "$pd_metadata_tmp"
  }
  trap restore_pd_metadata EXIT
  if [[ -f skills/.DS_Store ]]; then
    mv skills/.DS_Store "$pd_metadata_tmp/skills.DS_Store"
    pd_metadata_saved=1
  fi
  bash tests/product-design/test-core-integration.sh
  node --test tests/product-design/test-import-integrity.mjs
  node scripts/check-product-design-import.mjs --root "$PWD"
  bash tests/codex/test-package-codex-plugin.sh
  bash tests/skills/test-skill-slim-gates.sh
  git diff HEAD~2..HEAD --check
)
```

Expected: every command exits zero. If the package test reports a known environment-specific failure, record the exact output and do not claim the package suite passed.

- [ ] **Step 2: Prove the independent frontend skill is untouched**

Run:

```bash
shasum -a 256 skills/frontend-design/SKILL.md skills/frontend-design/LICENSE.txt
git diff e64c5d5..HEAD --exit-code -- skills/frontend-design/SKILL.md skills/frontend-design/LICENSE.txt
```

Expected: hashes exactly match Task 1 and the Git diff command exits zero with no output.

- [ ] **Step 3: Audit every acceptance criterion against evidence**

Create a checklist in the final implementation handoff mapping:

```text
Original direction inclusion -> PD9 GREEN cohort
Substantial redesign inclusion -> PD3 and PD10 GREEN samples
Audit/research exclusion -> PD2 and PD11 GREEN samples
Faithful clone exclusion -> PD4 GREEN cohort
Selected-visual exclusion -> PD5 GREEN sample
Authority preservation -> composition contract plus ambiguous probes
Three-image selection gate -> ideate contract inspection
Frontend bytes unchanged -> SHA-256 and git diff
Static/integrity/package status -> fresh commands from Step 1
```

Do not convert a missing or blocked row into a pass.

- [ ] **Step 4: Inspect repository and commit scope**

Run:

```bash
git status --short
git log --oneline e64c5d5..HEAD
git diff --stat e64c5d5..HEAD
git diff e64c5d5..HEAD -- \
  tests/product-design/routing-scenarios.md \
  tests/product-design/test-core-integration.sh \
  skills/product-design/SKILL.md \
  references/wukong-product-design-composition.md \
  skills/product-design-ideate/SKILL.md \
  product-design.lock.json \
  docs/wukong-code/evals
```

Expected: no unrelated path appears. Show this complete proposed diff to the human partner before any push or pull request.

- [ ] **Step 5: Stop at human review**

Do not push, merge, or open a pull request. If the human later requests a PR, first read `.github/PULL_REQUEST_TEMPLATE.md`, search all open and closed related PRs, disclose the model, harness/version, and all installed plugins, target `dev`, and obtain explicit approval of the complete diff.
