---
name: brainstorming
description: "You MUST use this before creative or behavior-changing work — creating features, building components, adding functionality, modifying behavior, or ambiguous product intent. Explores user intent, requirements and design before implementation."
---

# Brainstorming Ideas Into Designs

Help turn ideas into fully formed designs and specs through natural collaborative dialogue.

Start by understanding the current project context, then ask questions one at a time to refine the idea. Once you understand what you're building, present the design and get user approval.

<HARD-GATE>
Do NOT invoke any implementation skill, write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it — whenever this skill applies (new features, behavior changes, or ambiguous product intent).
</HARD-GATE>

## Anti-Pattern: "This Is Too Simple To Need A Design"

If you are about to build a feature, change user-facing behavior, or invent a design, you do **not** get to skip this skill because it "feels small." A todo list, a new utility module, or a behavior tweak still needs design approval (Full or Condensed below)—never skip the HARD-GATE by calling the work "simple."

**Fast path (does not use this skill):** the human named an exact mechanical edit with no design choices (typo, rename already agreed, clear one-line fix in a specified file). Config or behavior changes are NOT fast path. That path is routed in `using-wukong-code` Scope routing — do not force brainstorming onto it.

## Depth routing

Pick a depth before running the checklist. Condensed shortens ceremony; it does **not** skip design approval.

| Depth | When | Behavior |
|-------|------|----------|
| **Full** | Requirements ambiguous, product/behavior intent unclear, or no acceptance criteria | Full checklist below (2–3 approaches, sectioned approval, persist spec, user reviews spec → writing-plans) |
| **Condensed** | Human gave a clear request **and** acceptance criteria, but work is still a feature/behavior change (not mechanical fast path) | Explore context → state the chosen approach in at most 5 bullets → **one approval** → exit per Condensed exits. Do not require 2–3 alternatives. Do **not** write/commit a design doc unless the human asks or the work spans multiple subsystems. |

Offer alternatives only when they materially change cost, risk, or UX. Visual companion rules still apply (just-in-time, never required).

### Condensed checklist

You MUST create a task for each of these and complete them in order:

1. **Explore project context** — check files, docs, recent commits
2. **Clarify only if needed** — at most a few targeted questions; skip if acceptance criteria are already explicit
3. **Present approach** — at most 5 bullets; get one approval (HARD-GATE still applies)
4. **Exit** — follow Condensed exits below

### Condensed exits

After approval:

- **Multi-step or cross-module work** → invoke `writing-plans` (do not start implementation skills yet)
- **Single-module, clear acceptance criteria** → implement directly (skip writing-plans). Still use verification-before-completion / finishing-a-development-branch when those apply later

## Checklist (Full depth)

When Depth routing selected **Full**, you MUST create a task for each of these items and complete them in order:

1. **Explore project context** — check files, docs, recent commits
2. **Offer the visual companion just-in-time** — NOT upfront. The first time a question would genuinely be clearer shown than described, offer it then (its own message); on approval its browser tab opens for you. If no visual question ever arises, never offer it. See the Visual Companion section below.
3. **Ask clarifying questions** — one at a time, understand purpose/constraints/success criteria
4. **Propose 2-3 approaches** — with trade-offs and your recommendation
5. **Present design** — in sections scaled to their complexity, get user approval after each section
6. **Write design doc** — save to `docs/wukong-code/specs/YYYY-MM-DD-HHmm-<topic>-design.md` and commit
7. **Spec self-review** — quick inline check for placeholders, contradictions, ambiguity, scope (see below)
8. **User reviews written spec** — ask user to review the spec file before proceeding
9. **Transition to implementation** — invoke writing-plans skill to create implementation plan

## After the Design (Full depth)

**Documentation:**

- Write the validated design (spec) to `docs/wukong-code/specs/YYYY-MM-DD-HHmm-<topic>-design.md`
  - `HHmm` is 24-hour local time to the minute (e.g. `2026-07-30-1425-auth-design.md`)
  - (User preferences for spec location override this default)
- Use elements-of-style:writing-clearly-and-concisely skill if available
- Commit the design document to git

**Spec Self-Review:**
After writing the spec document, look at it with fresh eyes:

1. **Placeholder scan:** Any "TBD", "TODO", incomplete sections, or vague requirements? Fix them.
2. **Internal consistency:** Do any sections contradict each other? Does the architecture match the feature descriptions?
3. **Scope check:** Is this focused enough for a single implementation plan, or does it need decomposition?
4. **Ambiguity check:** Could any requirement be interpreted two different ways? If so, pick one and make it explicit.

Fix any issues inline. No need to re-review — just fix and move on.

**User Review Gate:**
After the spec review loop passes, ask the user to review the written spec before proceeding:

> "Spec written and committed to `<path>`. Please review it and let me know if you want to make any changes before we start writing out the implementation plan."

Wait for the user's response. If they request changes, make them and re-run the spec review loop. Only proceed once the user approves.

**Implementation (Full depth):**

- Invoke the writing-plans skill to create a detailed implementation plan
- Do NOT invoke any other skill. writing-plans is the next step.

**Full-depth terminal state is invoking writing-plans.** Do NOT invoke frontend-design, mcp-builder, or any other implementation skill before that. (Condensed single-module exit may implement after approval—see Condensed exits.)

## Process depth (on demand)

`skills/brainstorming/references/process-depth.md`

## Visual Companion

A browser-based companion for showing mockups, diagrams, and visual options during brainstorming. Available as a tool — not a mode. Accepting the companion means it's available for questions that benefit from visual treatment; it does NOT mean every question goes through the browser.

**Offering the companion (just-in-time):** Do NOT offer it upfront. Wait until a question would genuinely be clearer shown than told — a real mockup / layout / diagram question, not merely a UI *topic*. The first time that happens, offer it then, as its own message:
> "This next part might be easier if I show you — I can put together mockups, diagrams, and comparisons in a browser tab as we go. It's still new and can be token-intensive. Want me to? I'll open it for you."

**This offer MUST be its own message.** Only the offer — no clarifying question, summary, or other content. Wait for the user's response. If they accept, start the server with `--open` so their browser opens to the first screen automatically. If they decline, continue text-only and don't offer again unless they raise it.

**Per-question decision:** Even after the user accepts, decide FOR EACH QUESTION whether to use the browser or the terminal. The test: **would the user understand this better by seeing it than reading it?**

- **Use the browser** for content that IS visual — mockups, wireframes, layout comparisons, architecture diagrams, side-by-side visual designs
- **Use the terminal** for content that is text — requirements questions, conceptual choices, tradeoff lists, A/B/C/D text options, scope decisions

A question about a UI topic is not automatically a visual question. "What does personality mean in this context?" is a conceptual question — use the terminal. "Which wizard layout works better?" is a visual question — use the browser.

If they agree to the companion, read the detailed guide before proceeding:
`skills/brainstorming/visual-companion.md`
