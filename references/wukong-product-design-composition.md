# Wukong Code and Product Design Composition

Wukong process selection remains primary. Product Design skills are secondary
domain guidance for product context, visual direction, prototype templates,
design comparison, and design QA.

## Authority and order

1. Use `skills/using-wukong-code/SKILL.md` to select exactly one primary
   Wukong process for the request.
2. Load the focused Product Design skill only when its trigger applies.
3. Follow the Wukong process for lifecycle gates such as brainstorming,
   planning, TDD, debugging, review, and verification.
4. Follow Product Design for domain decisions inside those gates: brief
   quality, source capture, visual target selection, starter choice, fidelity,
   interaction coverage, and design QA.

Product Design instructions do not replace, waive, or compete with a selected
Wukong process. Tool availability and Product Design's build ownership rules do
not change that authority.

## Approval mapping

Do not ask the human partner to approve the same decision twice. An approved
Wukong brainstorming design satisfies Product Design's intent/brief approval
when it names the design target, intended user outcome, and chosen visual
direction. Product Design must still obtain a visual choice when the approved
design has no selected visual target.

`get-context` playback is a domain handoff, not a second implementation
approval. It may continue in the same turn only when the governing Wukong
process has already cleared the applicable design gate.

## Source changes and completion

- When Product Design creates or changes durable source code, use the selected
  Wukong implementation process and its required tests.
- A throwaway visual prototype is exempt from TDD only when the human partner
  explicitly accepts that exception; template/runtime contract checks still
  apply.
- Product Design comparison and QA supplement Wukong verification. They do not
  authorize a completion claim without the verification required by the
  governing process.
- Audit, research, and critique requests that do not change source code may run
  directly under their focused Product Design skill.

## Conflict rule

If a Product Design instruction conflicts with the selected Wukong process,
preserve the Wukong lifecycle gate and apply the Product Design instruction
within it. If that cannot be done without materially changing the requested
outcome, stop and ask the human partner which outcome to prioritize.

## Original visual-direction guidance

Original visual directions and substantial redesigns may load Product Design's
internal original visual-direction guidance after the selected Wukong
lifecycle gate permits it. Resolve conflicts in this order:

1. Explicit human-partner requirements and hard constraints.
2. Supplied or saved source evidence, existing design systems, brand assets,
   tokens, and approved visual targets.
3. The selected Wukong process and its lifecycle gates.
4. Product Design workflow contracts.
5. Original visual-direction choices on visual axes the brief leaves open.

Fidelity-preserving workflows exclude the original visual-direction guidance:
audits, research-only work, URL clones, selected-visual implementation, design
QA, and sharing preserve their source of truth. The internal guidance cannot
waive the three-option selection gate, replace image options with prose or
ASCII wireframes, or authorize implementation.
