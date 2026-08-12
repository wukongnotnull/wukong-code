# Original Visual-Direction Guidance

> Adapted from Anthropic's
> [`frontend-design`](https://github.com/anthropics/skills/tree/main/skills/frontend-design)
> skill under Apache-2.0. This file has been modified and narrowed for Product
> Design's original-direction ideation workflow. See the
> [full license](../../../references/licenses/frontend-design-APACHE-2.0.txt).

Use this guidance only when Product Design is inventing an original visual
direction or a substantial redesign. Do not use it for research, audits,
faithful clones, implementation from a selected visual target, design QA, or
sharing.

## Authority boundary

Explicit requirements, supplied evidence, saved context, brand systems,
design tokens, selected visuals, user constraints, and Product Design workflow
contracts remain authoritative. Use this guidance only for visual axes the
brief leaves open. It cannot waive the three-image selection gate or authorize
implementation.

## Direction plan

Before each Image Gen call, prepare a compact, brief-specific plan and include
it in that option's prompt:

- **Subject / audience / primary job:** name the concrete subject, intended
  audience, and the one job the surface must accomplish.
- **Visual system:** define a deliberate palette, typography system, and layout
  concept grounded in the subject's materials, artifacts, and vernacular.
- **Signature element:** name one memorable device that embodies this brief,
  then keep surrounding decoration disciplined.
- **Justified aesthetic risk:** concentrate one intentional visual risk in the
  signature element and explain why it serves the audience and surface job.
- **Interface language:** use realistic, subject-specific end-user copy. Name
  controls by what people recognize and keep action names consistent through
  the flow.
- **Anti-template critique:** identify one generic choice the plan initially
  suggested, replace it with a brief-specific choice, and state the change as
  `generic choice detected → replacement choice`.

Derive choices from the subject rather than current AI-design defaults. If the
brief explicitly requires a familiar pattern, preserve it; distinctiveness
never outranks evidence or usability. Match complexity to the chosen direction
and spend boldness in one place.
