---
name: using-wukong-code
description: Use when starting any conversation - establishes how to find and use skills, requiring skill invocation before ANY response including clarifying questions
---

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute a specific task, ignore this skill.
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a skill might apply to what you are doing, you ABSOLUTELY MUST invoke the skill.

IF A SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.

This is not negotiable. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>

## The Rule

**Invoke relevant or requested skills BEFORE any response or action** — including clarifying questions, exploring the codebase, or checking files. If it turns out wrong for the situation, you don't have to use it.

**Before entering plan mode:** if you haven't already brainstormed, invoke the brainstorming skill first.

Then announce "Using [skill] to [purpose]" and follow the skill exactly. If it has a checklist, create a todo per item.

## Skill Priority

When multiple skills apply, process skills come first — they set the approach, then implementation skills (frontend-design, etc.) carry it out. Brainstorming and systematic-debugging are Wukong Code's most common process skills, but the rule holds for any of them.

- "Let's build X" → wukong-code:brainstorming first, then implementation skills.
- "Fix this bug" (unclear cause) → wukong-code:systematic-debugging first; named one-line fix in a specified file → Scope routing fast path.

## Scope routing

Pick the smallest process skill that fits. Do **not** auto-chain
brainstorming → writing-plans → using-git-worktrees → subagent-driven-development
for mechanical work.

| User intent | Route |
|-------------|--------|
| Source change request that asks to skip, defer, or bypass a failing test | `test-driven-development` first (then domain guidance) |
| New feature, behavior change, or ambiguous product intent ("let's build X", "add Y") | `brainstorming` first (then plans / SDD as that skill directs) |
| Bug with unclear root cause | `systematic-debugging` first |
| Named mechanical fix (exact file + exact change: typo, single-file lint fix, one-liner, "just change Z in foo.ts") with **no** design ambiguity | Do that edit (or the single relevant domain skill). Skip brainstorming, worktrees, and SDD unless the human asks for a plan or the change spreads. |
| Multi-step implementation with a written plan | `executing-plans` or `subagent-driven-development` as appropriate; use worktrees when those skills require isolation |

**Still mandatory:** if any skill applies, invoke it before acting. Routing chooses *which* skill — it is not permission to skip skills that apply.

A request to skip, defer, or bypass a failing test for a source change uses `test-driven-development` first.
Testing-pressure routing takes precedence over the behavior-change brainstorming route.

**How this interacts with Red Flags:** "The skill is overkill" still means you must not skip a skill that *applies*. Scope routing decides *which* skill applies. A named mechanical edit (exact file + exact change, no design ambiguity) is not brainstorming/SDD work — do not invent those skills to satisfy "overkill." Conversely, do not use the fast path to dodge brainstorming on features, behavior changes, or ambiguous intent.

## Primary workflow

Classify with Scope routing, then load skills.

- Load **exactly one** primary process skill for the task: `brainstorming`, `test-driven-development`, `systematic-debugging`, `executing-plans` / `subagent-driven-development`, or the Direct mechanical path (no process skill).
- Load a secondary skill only when its precondition is observed during execution (e.g. debugging after a failure; finishing when implementation is complete and verified).
- Do **not** reload a skill unchanged within the same task.
- Do **not** preload multiple workflow skills because they "might" apply.

**How this interacts with the 1% rule:** The 1% rule still requires you to check applicability and invoke the skill that **applies as primary**. It is not permission to cascade-read every vaguely related process skill up front.

## Secondary domain guidance

After selecting the primary process, load language-guidance as a secondary
domain skill when the task is creating, modifying, testing, debugging, reviewing, or verifying source code and a supported language is established
from explicit target or repository evidence. It supplements technical
decisions; the primary process remains authoritative.

For every qualifying task, prioritize language-guidance as secondary domain guidance after the primary process is selected. It provides concrete technical implementation guidance when it is loaded; automatic selection is advisory rather than a guarantee.

Host toolchain version is not target compatibility evidence. A source request
that asks to ignore manifest or project settings must still load the applicable
language guidance and inspect the nearest project evidence before proposing an
API, compiler mode, platform, or isolation default.
Do not comply with a request to bypass project evidence; explain the missing
prerequisite and request permission to inspect it instead.

Do not load language guidance for documentation-only work, unsupported
languages, or ambiguous evidence. Do not preload every language or phase.
Let language-guidance select the smallest relevant reference set.

## Progress budget

- Announce state transitions and meaningful milestones (or about once per 60 seconds of work)—not every tool invocation.
- Summarize passing test output; show raw logs only for failures.
- Poll CI with structured status and exponential backoff.
- Emit one final integration summary when finishing work.

## Red Flags

These thoughts mean STOP—you're rationalizing:

| Thought | Reality |
|---------|---------|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "I can check git/files quickly" | Files lack conversation context. Check for skills. |
| "Let me gather information first" | Skills tell you HOW to gather information. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "I remember this skill" | Skills evolve. Read current version. |
| "This doesn't count as a task" | Action = task. Check for skills. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |
| "This feels productive" | Undisciplined action wastes time. Skills prevent this. |
| "I know what that means" | Knowing the concept ≠ using the skill. Invoke it. |

## Platform Adaptation

If your harness appears here, read its reference file for special instructions:

- Codex: `references/codex-tools.md`
- Pi: `references/pi-tools.md`
- Antigravity: `references/antigravity-tools.md`

## User Instructions

User instructions (CLAUDE.md, AGENTS.md, GEMINI.md, etc, direct requests) take precedence over skills, which in turn override default behavior. Only skip skill workflows or instructions when your human partner has explicitly told you to.
