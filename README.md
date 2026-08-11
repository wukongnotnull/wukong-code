# Wukong Code

Wukong Code is a complete software development methodology for your coding agents, built on top of a set of composable skills and some initial instructions that make sure your agent uses them.


## Quickstart

Give your agent Wukong Code: [Claude Code](#claude-code), [Antigravity](#antigravity), [Codex App](#codex-app), [Codex CLI](#codex-cli), [Cursor](#cursor), [Factory Droid](#factory-droid), [GitHub Copilot CLI](#github-copilot-cli), [Kimi Code](#kimi-code), [OpenCode](#opencode), [Pi](#pi).

## How it works

It starts from the moment you fire up your coding agent. As soon as it sees that you're building something, it *doesn't* just jump into trying to write code. Instead, it steps back and asks you what you're really trying to do. 

Once it's teased a spec out of the conversation, it shows it to you in chunks short enough to actually read and digest. 

After you've signed off on the design, your agent puts together an implementation plan that's clear enough for an enthusiastic junior engineer with poor taste, no judgement, no project context, and an aversion to testing to follow. It emphasizes true red/green TDD, YAGNI (You Aren't Gonna Need It), and DRY. 

Next up, once you say "go", it launches a *subagent-driven-development* process, having agents work through each engineering task, inspecting and reviewing their work, and continuing forward. It's not uncommon for your agent to work autonomously for a couple hours at a time without deviating from the plan you put together.

There's a bunch more to it, but that's the core of the system. And because the skills trigger automatically, you don't need to do anything special. Your coding agent just has Wukong Code.

## Installation

Installation differs by harness. If you use more than one, install Wukong Code separately for each one.

### Claude Code

Install from this repository:

```bash
/plugin marketplace add wukongnotnull/wukong-code
/plugin install wukong-code@wukong-code
```

### Antigravity

Install Wukong Code as a plugin from this repository:

```bash
agy plugin install https://github.com/wukongnotnull/wukong-code
```

Antigravity runs the plugin's session-start hook, so Wukong Code is active from
the first message. Reinstall with the same command to update.

### Codex App

Wukong Code is available via the [official Codex plugin marketplace](https://github.com/openai/plugins).

- In the Codex app, click on Plugins in the sidebar.
- You should see `Wukong Code` in the Coding section.
- Click the `+` next to Wukong Code and follow the prompts.

### Codex CLI

Wukong Code is available via the [official Codex plugin marketplace](https://github.com/openai/plugins).

- Open the plugin search interface:

  ```bash
  /plugins
  ```

- Search for Wukong Code:

  ```bash
  wukong-code
  ```

- Select `Install Plugin`.

### Cursor

- In Cursor Agent chat, install from marketplace:

  ```text
  /add-plugin wukong-code
  ```

- Or search for "wukong-code" in the plugin marketplace.

### Factory Droid

- Register the marketplace:

  ```bash
  droid plugin marketplace add https://github.com/wukongnotnull/wukong-code
  ```

- Install the plugin:

  ```bash
  droid plugin install wukong-code@wukong-code
  ```

### GitHub Copilot CLI

- Register the marketplace:

  ```bash
  copilot plugin marketplace add wukongnotnull/wukong-code
  ```

- Install the plugin:

  ```bash
  copilot plugin install wukong-code@wukong-code
  ```

### Kimi Code

Wukong Code is available in Kimi Code's plugin marketplace.

- Open Kimi Code's plugin manager:

  ```text
  /plugins
  ```

- Go to `Marketplace` > `Wukong Code` and install it.

- Or install directly from this repository:

  ```text
  /plugins install https://github.com/wukongnotnull/wukong-code
  ```

- Detailed docs: [docs/README.kimi.md](docs/README.kimi.md)

### OpenCode

OpenCode uses its own plugin install; install Wukong Code separately even if you
already use it in another harness.

- Tell OpenCode:

  ```
  Fetch and follow instructions from https://raw.githubusercontent.com/wukongnotnull/wukong-code/refs/heads/main/.opencode/INSTALL.md
  ```

- Detailed docs: [docs/README.opencode.md](docs/README.opencode.md)

### Pi

Install Wukong Code as a Pi package from this repository:

```bash
pi install git:github.com/wukongnotnull/wukong-code
```

For local development, run Pi with this checkout loaded as a temporary package:

```bash
pi -e /path/to/wukong-code
```

The Pi package loads the Wukong Code skills and a small extension that injects the `using-wukong-code` bootstrap at session startup and again after compaction. Pi has native skills, so no compatibility `Skill` tool is required. Subagent and task-list tools remain optional Pi companion packages.

## The Basic Workflow

1. **brainstorming** - Activates before writing code. Refines rough ideas through questions, explores alternatives, presents design in sections for validation. Saves design document.

2. **using-git-worktrees** - Activates after design approval. Creates isolated workspace on new branch, runs project setup, verifies clean test baseline.

3. **writing-plans** - Activates with approved design. Breaks work into bite-sized tasks (2-5 minutes each). Every task has exact file paths, complete code, verification steps.

4. **subagent-driven-development** or **executing-plans** - Activates with plan. Dispatches fresh subagent per task with two-stage review (spec compliance, then code quality), or executes in batches with human checkpoints.

5. **test-driven-development** - Activates during implementation. Enforces RED-GREEN-REFACTOR: write failing test, watch it fail, write minimal code, watch it pass, commit. Deletes code written before tests.

6. **requesting-code-review** - Activates between tasks. Reviews against plan, reports issues by severity. Critical issues block progress.

7. **finishing-a-development-branch** - Activates when tasks complete. Verifies tests, presents options (merge/PR/keep/discard), cleans up worktree.

**The agent checks for relevant skills before any task.** Mandatory workflows, not suggestions.

## Language Guidance

Wukong Code keeps methodology language-agnostic, then loads concrete language
guidance when target files and nearby markers provide evidence. Only the current
language and phase load; unsupported or ambiguous work keeps the generic
workflow. Automatic selection is advisory rather than guaranteed.

| Language | Status | Implementation | Testing | Debugging | Review | Verification | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Go | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | [Eval report](docs/wukong-code/evals/2026-07-22-go-language-guidance.md) |
| Java | Experimental | — | — | — | — | — | — |
| TypeScript | Planned | — | — | — | — | — | — |
| Swift | Planned | — | — | — | — | — | — |
| Rust | Experimental | — | — | — | — | — | — |

Experimental means initial behavior evals exist but real-project evidence is
still accumulating. Packs never install tools or override repository commands.
Framework guidance remains outside core. The Go [eval report](docs/wukong-code/evals/2026-07-22-go-language-guidance.md)
records the verified fixture and toolchain, eval date, known limitations, and
the language-guidance maintenance responsibility. Do not publish Experimental
status until those fields contain real evidence.

## What's Inside

### Skills Library

**Testing**
- **test-driven-development** - RED-GREEN-REFACTOR cycle (includes testing anti-patterns reference)

**Debugging**
- **systematic-debugging** - 4-phase root cause process (includes root-cause-tracing, defense-in-depth, condition-based-waiting techniques)
- **verification-before-completion** - Ensure it's actually fixed

**Language implementation**
- **language-guidance** - Experimental, evidence-based guidance for supported languages and phases

**Frontend design**
- **frontend-design** — Anthropic's Apache-2.0 guidance for distinctive,
  intentional frontend visual design. [Source](https://github.com/anthropics/skills/tree/main/skills/frontend-design)

**Collaboration** 
- **brainstorming** - Socratic design refinement
- **writing-plans** - Detailed implementation plans
- **executing-plans** - Batch execution with checkpoints
- **dispatching-parallel-agents** - Concurrent subagent workflows
- **requesting-code-review** - Pre-review checklist
- **receiving-code-review** - Responding to feedback
- **using-git-worktrees** - Parallel development branches
- **finishing-a-development-branch** - Merge/PR decision workflow
- **subagent-driven-development** - Fast iteration with two-stage review (spec compliance, then code quality)

**Meta**
- **writing-skills** - Create new skills following best practices (includes testing methodology)
- **using-wukong-code** - Introduction to the skills system

### Product Design (local fork integration)

Local fork version `6.3.0` also bundles Product Design
workflows for product brief intake,
UX research, flow audits, visual ideation, image and URL-to-code prototypes,
prototype QA, saved design context, and prototype sharing. These ten skills are
imported from product-design version 0.1.52; their shared references, bootstrap
scripts, and web/mobile starter templates are packaged with the root plugin.
This domain-specific addition is local only and must not be submitted as a
Wukong Code upstream core contribution. The imported Product Design material
is MIT-licensed by OpenAI; its provenance and required copyright/license text
are preserved in `product-design.lock.json` and `THIRD_PARTY_NOTICES.md`. Run
`node scripts/check-product-design-import.mjs` to verify the exact integrated
content against the lock, or add `--print` after a reviewed upstream refresh to
calculate the replacement digest.

## Philosophy

- **Test-Driven Development** - Write tests first, always
- **Systematic over ad-hoc** - Process over guessing
- **Complexity reduction** - Simplicity as primary goal
- **Evidence over claims** - Verify before declaring success

## Contributing

The general contribution process for Wukong Code is below. Wukong Code accepts
new skills after maintainer review when they solve a concrete problem, have a
clear intended audience, and can be maintained safely across supported
harnesses. Domain-specific and externally sourced skills are eligible for core
review; contributors must disclose the source, license, dependency impact,
tests or evaluations, and maintenance or update strategy. Core skills remain
zero-dependency unless a separately documented harness-support exception
applies.

1. Fork the repository
2. Switch to the 'dev' branch
3. Create a branch for your work
4. Follow the `writing-skills` skill for creating and testing new and modified skills
5. Submit a PR, being sure to fill in the pull request template.

Skill-behavior tests use the drill eval harness from [wukong-code-evals](https://github.com/wukongnotnull/wukong-code-evals/), cloned into `evals/` — see `evals/README.md` for setup. Plugin-infrastructure tests live at `tests/` and run via the relevant `run-*.sh` or `npm test`.

See `skills/writing-skills/SKILL.md` for the complete guide.

## Updating

Wukong Code updates are somewhat coding-agent dependent, but are often automatic.

## License

MIT License - see LICENSE file for details

## Community

- **Issues**: https://github.com/wukongnotnull/wukong-code/issues
- **Repository**: https://github.com/wukongnotnull/wukong-code
