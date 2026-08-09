# Product Design Routing Scenarios

Run each scenario in a fresh agent session. The session receives the installed
Wukong Code plugin but not this answer key. Record the first selected primary
process, every focused Product Design skill loaded, whether the agent acts or
stops, and the complete rationale.

## PD1: Explicit Product Design orientation

Prompt: `What can Product Design do, and help me set it up?`

Expected:

- Primary process: direct read/setup path; no source-change process is needed.
- Skills: `product-design`, then `product-design-user-context`.
- The response explains persistence only after running or reasoning from its
  writable-state preflight.
- Capability orientation may name `product-design-research`,
  `product-design-audit`, `product-design-context`, `product-design-ideate`,
  `product-design-url-to-code`, `product-design-image-to-code`,
  `product-design-design-qa`, and `product-design-share`, but it does not execute
  them during setup.

## PD2: Screenshot-grounded product audit

Prompt: `Audit this attached checkout-flow screenshot for UX, design, and accessibility problems. Do not change code.`

Expected:

- Primary process: direct read-only review path.
- Skills: `product-design`, then `product-design-audit`.
- It does not insert `product-design-context` before the audit and does not
  invoke a source-change workflow.

## PD3: Research and explore a new direction

Prompt: `Research current onboarding pain for this product, then generate three new visual directions for a redesigned onboarding flow.`

Expected:

- Primary process: `brainstorming` because the request creates a new design
  direction.
- Skills in domain order: `product-design`, `product-design-user-context`,
  `product-design-research`, `product-design-context`, and
  `product-design-ideate`.
- It waits for a visual selection before implementation.

## PD4: Faithful URL clone

Prompt: `Clone https://example.com/account as a runnable local frontend. Match it faithfully.`

Expected:

- Primary process: `brainstorming` unless an already-approved build spec is
  present.
- Skills: `product-design`, `product-design-user-context`,
  `product-design-context`, `product-design-url-to-code`, then
  `product-design-design-qa`.
- It captures the live source before coding and does not silently redesign it.

## PD5: Implement a selected image

Prompt: `Implement the selected option 2 image in this existing React app and verify the result.`

Expected:

- Primary process: `test-driven-development` for durable source changes after
  the already-selected design satisfies the design gate.
- Skills: `product-design`, `product-design-image-to-code`, then
  `product-design-design-qa`.
- Wukong verification remains required after visual comparison.

## PD6: Ordinary UI implementation remains Wukong-led

Prompt: `Add a disabled state to the existing Button component and update its tests.`

Expected:

- Primary process: `test-driven-development` (or `brainstorming` first only if
  behavior intent is genuinely ambiguous).
- No Product Design skill loads merely because the component is UI.
- The agent must not route to `product-design` or any focused Product Design
  skill unless the human explicitly changes the request to design exploration.

## PD7: Missing browser and hosting capabilities

Prompt: `Audit this live URL and publish the result, but this session has no browser and no hosting tool.`

Expected:

- Primary process: direct capability preflight.
- Skills: `product-design`, then `product-design-audit`; route to
  `product-design-share` only after a runnable artifact exists and hosting is
  actually available.
- The audit stops and asks for screenshots or a supported browser. It does not
  claim capture, visual verification, deployment, or a share URL.

## PD8: No subagents and portable saved context

Prompt: `This OpenCode session has no subagents and no CODEX_HOME. Save my Storybook URL, then build from the attached mockup.`

Expected:

- Primary process: `brainstorming` before the new build; setup itself uses the
  direct path.
- Skills: `product-design-user-context`, `product-design`,
  `product-design-image-to-code`, then `product-design-design-qa`.
- State resolves through `PRODUCT_DESIGN_STATE_DIR`, `XDG_STATE_HOME`, or
  `~/.local/state/wukong-code/product-design`, never a newly invented
  `~/.codex` directory.
- The agent uses the sequential fallback for capture/build/compare/fix rather
  than treating missing subagents as a blocker.

## Pass criteria

A scenario passes only when process authority, focused skill selection,
capability gate, and completion claims all match. Mentioning a skill without
loading/following it is a failure. Static keyword checks prove scenario
coverage only; they do not replace fresh-session behavior runs.
