<div align="center">

<img src="assets/wukong-code-small.svg" alt="Wukong Code logo" width="160" />

# Wukong Code

**A complete software development methodology for coding agents**<br>
Design first · Test-driven development · Evidence before claims

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/github/v/tag/wukongnotnull/wukong-code?label=version)](https://github.com/wukongnotnull/wukong-code/tags)
[![Plugin](https://img.shields.io/badge/type-coding%20agent%20plugin-F59E0B.svg)](https://github.com/wukongnotnull/wukong-code)
[![Stars](https://img.shields.io/github/stars/wukongnotnull/wukong-code?style=social)](https://github.com/wukongnotnull/wukong-code/stargazers)

</div>

**Languages:** [English](README.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [日本語](README.ja.md) · [한국어](README.ko.md)

> Wukong Code gives your coding agent a set of composable skills and the startup instructions that make those skills activate at the right moment—from brainstorming and planning to TDD, review, and verification.

---

**Quick nav**<br>
[Why Wukong Code](#why-wukong-code) · [How it works](#how-it-works) · [Install](#supported-agents--installation) · [Workflow](#the-basic-workflow) · [Skills](#whats-inside) · [Language guidance](#language-guidance) · [Testing](#testing) · [FAQ](#faq) · [Contributing](#contributing) · [License](#license)

---

## Why Wukong Code

| Capability | What you get |
| --- | --- |
| **Design before code** | The agent clarifies intent, explores alternatives, and gets approval before implementation |
| **Executable plans** | Approved designs become small tasks with exact files and verification steps |
| **True TDD** | RED–GREEN–REFACTOR is enforced instead of tests being added after the code |
| **Systematic debugging** | Root causes are investigated before fixes are proposed |
| **Review in the loop** | Work is checked for spec compliance and code quality as it progresses |
| **Evidence before claims** | Completion requires fresh verification output, not assumptions |
| **Automatic activation** | Skills trigger from the task context; no special per-task prompt is required |

For developers who want coding agents to follow a repeatable engineering process—not just generate code quickly.

---

## How it works

Wukong Code starts working when an agent session begins. It routes the request into the relevant development or Product Design workflow, then loads only the focused skills needed for that task.

### Software development

When the agent detects a build or behavior-change request, it pauses implementation and first works out what you are actually trying to accomplish.

After you approve the design, the agent creates a concrete implementation plan, follows true red/green TDD, delegates isolated tasks when appropriate, reviews the result, and verifies the complete change before calling it done.

```text
Your idea
   ↓
Brainstorm → Approved design → Implementation plan
   ↓
RED → GREEN → REFACTOR → Review → Verification
   ↓
Merge / PR / keep the branch
```

### Product Design

Product Design closes the gap between product ideas and working software. It uses saved product context—such as brand assets, design systems, screenshots, components, and preferred tools—when available, then follows the path that matches your goal:

```text
Research or audit
Product / flow → Capture current evidence → UX, visual, and accessibility findings

Explore a new direction
Design brief → 3 visual options → You choose → Responsive prototype

Clone or implement
Live URL or selected visual → Frontend build → Design QA → Preview / share
```

Research and audits remain evidence-based and do not modify source code. New designs require a selected visual direction before implementation. Prototype handoff is blocked until the rendered result has been compared with its visual source and Design QA passes.

Because the skills activate automatically, you work with your coding agent normally. The appropriate development or Product Design process is built into the session and adapts to the browser, image-generation, local-build, and sharing capabilities that are actually available.

---

## Supported agents & installation

Installation differs by harness. If you use more than one, install Wukong Code separately for each one.

Current release: **[v6.3.0](https://github.com/wukongnotnull/wukong-code/releases/tag/v6.3.0)**. Gemini CLI support was retired in this release and is no longer advertised as supported.

**Supported:** [Antigravity](#antigravity) · [Claude Code](#claude-code) · [Codex App](#codex-app) · [Codex CLI](#codex-cli) · [Cursor](#cursor) · [Factory Droid](#factory-droid) · [GitHub Copilot CLI](#github-copilot-cli) · [Kimi Code](#kimi-code) · [OpenCode](#opencode) · [Pi](#pi)

### Antigravity

Install the plugin from this repository:

```bash
agy plugin install https://github.com/wukongnotnull/wukong-code
```

Antigravity runs the session-start hook, so Wukong Code is active from the first message. Reinstall with the same command to update.

### Claude Code

Install from this repository:

```bash
/plugin marketplace add wukongnotnull/wukong-code
/plugin install wukong-code@wukong-code
```

### Codex App

Wukong Code is available through the [official Codex plugin marketplace](https://github.com/openai/plugins).

1. Click **Plugins** in the Codex sidebar.
2. Find **Wukong Code** in the Coding section.
3. Click the `+` and follow the prompts.

### Codex CLI

Open the plugin interface:

```text
/plugins
```

Search for `wukong-code`, then select **Install Plugin**.

### Cursor

In Cursor Agent chat:

```text
/add-plugin wukong-code
```

Or search for `wukong-code` in the plugin marketplace.

### Factory Droid

```bash
droid plugin marketplace add https://github.com/wukongnotnull/wukong-code
droid plugin install wukong-code@wukong-code
```

### GitHub Copilot CLI

```bash
copilot plugin marketplace add wukongnotnull/wukong-code
copilot plugin install wukong-code@wukong-code
```

### Kimi Code

Open `/plugins`, go to **Marketplace → Wukong Code**, and install it. You can also install directly:

```text
/plugins install https://github.com/wukongnotnull/wukong-code
```

See the [Kimi Code installation guide](docs/README.kimi.md) for details.

### OpenCode

Tell OpenCode:

```text
Fetch and follow instructions from https://raw.githubusercontent.com/wukongnotnull/wukong-code/refs/heads/main/.opencode/INSTALL.md
```

See the [OpenCode installation guide](docs/README.opencode.md) for details.

### Pi

Install as a Pi package:

```bash
pi install git:github.com/wukongnotnull/wukong-code
```

For local development:

```bash
pi -e /path/to/wukong-code
```

The Pi package loads the skills and injects the `using-wukong-code` bootstrap at startup and after compaction. Pi has native skills; subagent and task-list tools remain optional companion packages.

---

## The basic workflow

### Software development workflow

1. **using-wukong-code** — Checks the task before any action and selects the smallest applicable workflow.
2. **brainstorming**, **systematic-debugging**, or a direct path — Routes feature work through design, unclear bugs through root-cause investigation, and exact mechanical edits directly.
3. **writing-plans** — Turns an approved multi-step design into small tasks with exact file paths and verification steps.
4. **using-git-worktrees** — Creates an isolated workspace and verifies a clean test baseline when the execution needs isolation.
5. **subagent-driven-development** or **executing-plans** — Executes the plan with task-level review or human checkpoints; implementation uses RED–GREEN–REFACTOR when TDD applies.
6. **verification-before-completion** and code review — Requires fresh evidence and checks the whole result before completion claims.
7. **finishing-a-development-branch** — Honors an existing integration intent or offers merge, PR, keep, and discard options.

**The agent checks for relevant skills before every task. These workflows are requirements, not suggestions.**

### Product Design workflow

1. **product-design** — Identifies the goal and routes the request to the appropriate focused Product Design skill.
2. **product-design-user-context** — Loads saved brand assets, design systems, screenshots, references, and preferences when they can ground the task.
3. **product-design-context** — Clarifies the design target, intended user, and desired outcome before visual exploration or implementation.
4. **product-design-research**, **product-design-audit**, or **product-design-ideate** — Researches current user pain, audits captured product evidence, or generates three visual directions for selection.
5. **product-design-url-to-code** or **product-design-image-to-code** — Faithfully recreates a live URL or implements the selected visual target as a responsive frontend.
6. **product-design-design-qa** — Compares the rendered prototype with its visual source and blocks handoff until the comparison passes.
7. **product-design-share** — Publishes the runnable prototype and returns a shareable link when the user asks to deploy or share it.

**These skills do not run as one fixed sequence on every request. Product Design selects the shortest applicable path for research, audit, ideation, cloning, implementation, QA, or sharing.**

---

## What's inside

Version `6.3.0` ships **27 top-level skills**: 17 general development skills and 10 Product Design skills.

| Area | Skills and guidance |
| --- | --- |
| **Testing** | `test-driven-development`, testing anti-patterns |
| **Debugging** | `systematic-debugging`, root-cause tracing, defense in depth, condition-based waiting |
| **Verification** | `verification-before-completion` |
| **Planning** | `brainstorming`, `grilling`, `writing-plans`, `executing-plans` |
| **Collaboration** | `dispatching-parallel-agents`, `subagent-driven-development`, `requesting-code-review`, `receiving-code-review` |
| **Workspace** | `using-git-worktrees`, `finishing-a-development-branch` |
| **Language implementation** | Experimental evidence-based `language-guidance` packs |
| **Frontend design** | Distinctive, intentional frontend visual-design guidance from [Anthropic Skills](https://github.com/anthropics/skills/tree/main/skills/frontend-design) |
| **Meta** | `writing-skills`, `using-wukong-code` |

### Product Design

Version `6.3.0` bundles these ten Product Design skills:

| Skill | Purpose |
| --- | --- |
| `product-design` | Routes Product Design requests to the appropriate focused workflow |
| `product-design-user-context` | Saves or loads brand assets, design systems, screenshots, references, and preferences |
| `product-design-context` | Clarifies the design target, intended user, and desired outcome |
| `product-design-research` | Researches current user pain points and product opportunities from fresh sources |
| `product-design-audit` | Audits product flows for UX, visual-design, and accessibility issues using captured evidence |
| `product-design-ideate` | Generates three visual directions for the user to compare and select |
| `product-design-url-to-code` | Faithfully recreates a live URL as a runnable local frontend prototype |
| `product-design-image-to-code` | Implements a selected visual source as a responsive, interactive frontend |
| `product-design-design-qa` | Compares the rendered implementation with its visual source and gates handoff |
| `product-design-share` | Publishes a runnable prototype and returns a shareable link when requested |

They are imported from Product Design `0.1.52`. Their MIT provenance is recorded in [`product-design.lock.json`](product-design.lock.json) and [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md).

Verify the imported content with:

```bash
node scripts/check-product-design-import.mjs
```

---

## Language Guidance

Wukong Code remains language-agnostic at the methodology level. When repository evidence identifies a supported language and phase, the agent loads only the relevant implementation guidance. Packs do not install tools or override repository commands.

| Language | Status | Implementation | Testing | Debugging | Review | Verification | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Go | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | [Eval report](docs/wukong-code/evals/2026-07-22-go-language-guidance.md) |
| Java | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | [Eval report](docs/wukong-code/evals/2026-08-02-java-language-guidance.md) |
| TypeScript | Planned | — | — | — | — | — | — |
| Swift | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | [Eval report](docs/wukong-code/evals/2026-07-29-swift-language-guidance.md) |
| Rust | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | [Eval report](docs/wukong-code/evals/2026-07-29-rust-language-guidance.md) |

**Experimental** means initial behavior evals exist while real-project evidence is still accumulating. Framework, cloud-service, database, and team-specific guidance stays outside core.

---

## Testing

Run the deterministic core checks:

```bash
npm test
```

Run core plus the brainstorm-server and Antigravity checks:

```bash
npm run test:extended
```

Tests that require a host CLI, credentials, or real LLM sessions remain manual. See [`docs/testing.md`](docs/testing.md) for plugin test runners and the separate [wukong-code-evals](https://github.com/wukongnotnull/wukong-code-evals) behavior-evaluation workflow.

---

## Philosophy

| Principle | Meaning |
| --- | --- |
| **Test-driven development** | Write the failing test first |
| **Systematic over ad hoc** | Follow a repeatable process instead of guessing |
| **Complexity reduction** | Prefer the smallest clear solution |
| **Evidence over claims** | Verify before declaring success |

---

## FAQ

**Do I need to invoke skills manually?**<br>
No. A working harness integration loads the bootstrap at session start, and the agent selects relevant skills from the task context.

**Can I install Wukong Code in more than one coding agent?**<br>
Yes. Install it separately in each harness because their plugin systems are independent.

**How do I update it?**<br>
Use the update flow provided by your harness. Repository-based installs can generally be refreshed by repeating the installation command.

**Does Wukong Code install project dependencies?**<br>
No. Core is zero-dependency and its language packs do not install tools or replace repository-defined commands.

**Where do the behavior evals live?**<br>
Skill-behavior evals live in [wukong-code-evals](https://github.com/wukongnotnull/wukong-code-evals), cloned locally into `evals/`. Plugin-infrastructure tests remain in `tests/`.

---

## Contributing

Contributions must solve a concrete, experienced problem. Read [`.github/PULL_REQUEST_TEMPLATE.md`](.github/PULL_REQUEST_TEMPLATE.md) and the repository contributor instructions before starting.

Domain-specific and externally sourced skills are eligible for core review when they have a clear audience and can be maintained safely across supported harnesses. Contributors must disclose their source, license, dependency impact, tests or evaluations, and maintenance or update strategy. Core remains zero-dependency unless a separately documented harness-support exception applies.

1. Search open and closed PRs for related work.
2. Fork the repository and create a focused branch from `main`.
3. Create one focused branch for one problem.
4. Use `writing-skills` and behavior evals for any skill change.
5. Test on at least one harness and disclose the complete agent environment.
6. Show the complete diff to a human reviewer before opening the PR.

Project-specific, tool-specific, and narrowly personal integrations normally belong in standalone plugins. See [`skills/writing-skills/SKILL.md`](skills/writing-skills/SKILL.md) and [`docs/testing.md`](docs/testing.md) for the full workflow.

---

## Community

- [GitHub Issues](https://github.com/wukongnotnull/wukong-code/issues)
- [Source repository](https://github.com/wukongnotnull/wukong-code)

---

## License

Wukong Code is released under the [MIT License](LICENSE). Third-party notices are recorded in [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md).

<div align="center">

MIT License · [Wukong Code](https://github.com/wukongnotnull/wukong-code)

</div>
