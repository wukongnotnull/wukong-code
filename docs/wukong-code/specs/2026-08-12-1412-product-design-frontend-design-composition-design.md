# Product Design and Frontend Design Composition

**Status:** Approved for implementation planning

**Date:** 2026-08-12

## Summary

Wukong Code will keep `frontend-design` as an independent top-level skill and
compose it into Product Design only for original visual design and substantial
redesign work. Product Design's router will make the boundary visible, the
composition contract will define authority, and `product-design-ideate` will
apply the guidance before generating visual options.

Faithful workflows will not load `frontend-design`. Audits, research, URL
clones, implementation from an already-selected visual target, and design QA
must preserve their current evidence or source visual instead of introducing a
new aesthetic direction.

## Problem

Wukong Code currently ships both Product Design and Anthropic's
`frontend-design`, but the capabilities are independent. Product Design can
generate visual directions without explicitly applying `frontend-design`'s
subject grounding, intentional visual system, signature element, and
anti-template critique. Users must know to request both skills themselves.

Merging the full `frontend-design` text into Product Design would duplicate
behavioral guidance, expand context, obscure its separate Apache-2.0 license,
and make upstream updates harder to track. Loading it for every Product Design
request would also conflict with workflows whose purpose is fidelity rather
than invention.

## Goals

- Automatically load `frontend-design` for original visual design and
  substantial redesign requests handled through Product Design.
- Keep `frontend-design` independently discoverable and unchanged.
- Give Product Design's evidence, user constraints, and existing design system
  authority over `frontend-design` suggestions.
- Ensure faithful workflows never acquire an unsolicited new aesthetic
  direction.
- Cover the positive and negative routing boundaries with fresh-session
  behavior scenarios and repository integration checks.

## Non-Goals

- Copying or rewriting `frontend-design` inside a Product Design skill.
- Changing `frontend-design`'s license, attribution, or upstream snapshot.
- Applying `frontend-design` to ordinary UI implementation merely because the
  task touches frontend code.
- Applying it to audits, research, faithful URL clones, image-to-code from a
  selected visual, design QA, or sharing.
- Changing Product Design's browser, template, asset, hosting, or design-QA
  contracts.
- Opening an upstream pull request as part of this work.

## Routing Model

The Product Design router owns the inclusion decision. The focused ideation
skill owns execution of the included guidance.

| Request class | Load `frontend-design` | Reason |
|---|---:|---|
| New product, page, screen, or feature needing an original visual direction | Yes | The visual system must be invented from the subject and brief. |
| Redesign that may intentionally depart from its current appearance | Yes | The user is requesting a new aesthetic thesis rather than strict fidelity. |
| Design exploration requesting distinct visual alternatives | Yes | The alternatives benefit from subject grounding and anti-template critique. |
| UX research or product-flow audit | No | These are evidence-gathering and critique workflows, not visual invention. |
| Faithful URL clone or recreation | No | The captured source is authoritative. |
| Implementation from a selected screenshot, Figma frame, mockup, or ImageGen result | No | The selected visual is authoritative. |
| Design QA against an existing reference | No | QA measures fidelity; it must not redefine the target. |
| Sharing or deployment | No | Sharing does not make design decisions. |
| Ordinary UI implementation outside explicit Product Design | No | Existing Wukong process and language guidance remain sufficient. |

For URL-based requests, wording determines the branch:

- `Clone`, `recreate`, or `match faithfully` means fidelity and excludes
  `frontend-design`.
- `Redesign`, `improve`, or `create something inspired by` allows departure
  from the source and includes `frontend-design` before ideation.

If intent is ambiguous and the choice would materially change fidelity, the
agent asks one targeted question before selecting the branch.

## Authority and Composition

The following order resolves conflicts:

1. Explicit user requirements and hard constraints.
2. Supplied or saved source evidence, including an existing design system,
   brand assets, tokens, and approved visual targets.
3. The selected Wukong process and its lifecycle gates.
4. Product Design workflow contracts for context, source selection, visual
   generation, implementation, and QA.
5. `frontend-design` guidance for subject grounding, visual distinctiveness,
   typography, layout, motion, copy, and self-critique.

`frontend-design` therefore enriches choices only on axes the brief leaves
open. It cannot replace an existing design system, override a selected visual,
waive Product Design's three-option selection gate, or bypass Wukong
brainstorming, planning, TDD, and verification requirements.

## Ideation Behavior

For an original direction or substantial redesign,
`product-design-ideate` will load and follow `frontend-design` before calling
ImageGen. Its analysis will contribute the following inputs to each generated
direction:

- A concrete subject, intended audience, and single primary job for the
  surface.
- A deliberate visual system covering palette, typography, layout, and a
  single signature element.
- Realistic, subject-specific content and interface language.
- One justified aesthetic risk, concentrated rather than scattered.
- A pre-generation critique that replaces choices resembling generic AI
  defaults when the brief did not request them.

These inputs supplement the existing Product Design prompt and constraints.
They do not change the requirement to generate exactly three independent
visual options, display them before numbering, and wait for the user's
selection before build work.

The integration should reference and invoke `frontend-design`; it should not
duplicate its detailed prose in Product Design files.

## Files and Responsibilities

### `skills/product-design/SKILL.md`

- Add the positive and negative routing boundary.
- State that original design and substantial redesign load
  `$frontend-design` before `$product-design-ideate`.
- Keep faithful URL clone and selected-visual implementation routes excluded.

### `references/wukong-product-design-composition.md`

- Define `frontend-design` as secondary visual-domain guidance.
- Record the conflict-precedence order.
- State that it applies only within an already-selected Wukong process and
  cannot bypass lifecycle gates.

### `skills/product-design-ideate/SKILL.md`

- Require `$frontend-design` for the eligible request classes.
- Translate its outputs into ImageGen art direction without copying the skill.
- Add the anti-template critique before generation.
- Preserve the existing three-option and selection contract.

### `tests/product-design/routing-scenarios.md`

- Add a positive fresh-session scenario for original design or substantial
  redesign.
- Add or strengthen negative scenarios for faithful URL cloning and
  implementation from an already-selected visual.
- Record exact expected skill order and exclusion behavior.

### `tests/product-design/test-core-integration.sh`

- Assert that the router, composition contract, and ideation skill each name
  the composition boundary.
- Assert that routing scenarios cover both positive and fidelity-preserving
  negative cases.

### `product-design.lock.json`

- Update the integrated-content digest after all Product Design file changes
  are complete.
- Do not add `skills/frontend-design` to `imported_roots`; it remains a
  separately sourced top-level skill rather than imported Product Design
  content.

## Test and Evaluation Strategy

Because skill text shapes behavior, implementation follows the
`writing-skills` RED-GREEN-REFACTOR workflow.

### RED

Run fresh sessions without the new composition instructions and record whether
agents omit `frontend-design` during original ideation or incorrectly apply it
to fidelity work. Preserve the complete observed outputs and rationales.

The minimum behavior set is:

1. Original landing-page or product-screen design requests
   `frontend-design` before ideation.
2. A substantial redesign grounded in an existing URL uses the source as
   context but permits a new direction and requests `frontend-design`.
3. A faithful URL clone does not request `frontend-design`.
4. Implementation from a selected screenshot or ImageGen option does not
   request `frontend-design` again.
5. An audit or research-only request does not request `frontend-design`.

### GREEN

Add the smallest routing, composition, and ideation instructions that make the
positive cases load the skill and the negative cases exclude it. Re-run the
same fresh-session scenarios and inspect every result manually.

### REFACTOR

Probe ambiguous language such as `make this site better`, `use this site as
inspiration`, and `match this but modernize it`. Tighten routing only where
observed behavior crosses the agreed fidelity boundary, then repeat the
scenarios.

### Repository Checks

- `tests/product-design/test-core-integration.sh`
- `node --test tests/product-design/test-import-integrity.mjs`
- `node scripts/check-product-design-import.mjs --root <repo>`
- Any repository-wide skill validation and packaging checks required by the
  implementation plan.

Static checks prove that the contract is present and packaged. Fresh-session
behavior runs prove that agents actually follow it. Both are required.

## Acceptance Criteria

- Original design and substantial redesign consistently load and follow
  `frontend-design` before Product Design ideation.
- Ideation visibly grounds each direction in the subject, audience, surface
  goal, deliberate visual system, and one signature element.
- Faithful URL clone, selected-visual implementation, audit, research, design
  QA, and sharing routes do not load `frontend-design` automatically.
- Explicit user constraints, existing design systems, and selected visual
  targets remain authoritative.
- `frontend-design/SKILL.md` and `LICENSE.txt` remain byte-for-byte unchanged.
- Product Design routing and import-integrity tests pass with the updated lock
  digest.
- Fresh-session behavior evidence covers every positive and negative class in
  the minimum behavior set.

## Risks and Mitigations

- **Over-triggering on any UI task:** keep the decision in the explicit Product
  Design router and retain the existing ordinary-implementation negative case.
- **Fidelity drift:** name excluded workflows in both the router and composition
  contract, and test URL cloning and selected-visual implementation directly.
- **Duplicated or stale guidance:** invoke the standalone skill instead of
  copying its prose.
- **Workflow collision:** preserve Wukong process authority and Product Design's
  existing visual-selection gate in the composition contract.
- **Context growth:** load `frontend-design` only for the eligible ideation
  branch, not for every Product Design request.
- **False confidence from static tests:** require fresh-session behavior runs
  and manual inspection in addition to grep-based integration checks.

## Human Review and Delivery

Implementation remains local until the complete diff and evaluation evidence
are shown to the human partner. No pull request will be opened without the
repository-required search for related open and closed PRs, complete PR
template answers, authoring-environment disclosure, explicit diff approval,
and a `dev` target branch.
