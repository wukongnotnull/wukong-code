# Wukong Code

<p align="center">
  <img src="./assets/readme/hero.png" width="100%" alt="Wukong Code: a complete software development methodology for coding agents. Design first, TDD, and evidence before claims.">
</p>

**A complete software development methodology for coding agents**

Design first · Test-driven development · Evidence before claims

[License: MIT](LICENSE)
[Version](https://github.com/wukongnotnull/wukong-code/tags)
[Plugin](https://github.com/wukongnotnull/wukong-code)
[Stars](https://github.com/wukongnotnull/wukong-code/stargazers)

**Languages:** [English](README.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [日本語](README.ja.md) · [한국어](README.ko.md)

> Wukong Code gives your coding agent a set of composable skills and the startup instructions that make those skills activate at the right moment—from brainstorming and planning to TDD, review, and verification.

<p align="center">
  <img src="./assets/readme/workflow.svg" width="100%" alt="Development path: design, plan, RED, GREEN, then verify.">
</p>

---

**Quick nav**

[Why Wukong Code](#why-wukong-code) · [How it works](#how-it-works) · [Install](#supported-agents--installation) · [Workflow](#the-basic-workflow) · [Skills](#whats-inside) · [Language guidance](#language-guidance) · [FAQ](#faq) · [Contributing](#contributing) · [License](#license)

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

Wukong Code is not listed in the official Codex plugin marketplace. Install it directly from this repository:

1. Click **Plugins** in the Codex sidebar.
2. Choose the option to install a plugin from a repository URL.
3. Enter `https://github.com/wukongnotnull/wukong-code` and follow the prompts.

### Codex CLI

Add this repository as a marketplace source, then install Wukong Code:

```bash
/plugin marketplace add wukongnotnull/wukong-code
/plugin install wukong-code@wukong-code
```

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

**26 top-level skills**: 16 general development skills and 10 Product Design skills.

| Area | Skills and guidance |
| --- | --- |
| **Testing** | `test-driven-development`, testing anti-patterns |
| **Debugging** | `systematic-debugging`, root-cause tracing, defense in depth, condition-based waiting |
| **Verification** | `verification-before-completion` |
| **Planning** | `brainstorming`, `grilling`, `writing-plans`, `executing-plans` |
| **Collaboration** | `dispatching-parallel-agents`, `subagent-driven-development`, `requesting-code-review`, `receiving-code-review` |
| **Workspace** | `using-git-worktrees`, `finishing-a-development-branch` |
| **Language implementation** | Experimental evidence-based `language-guidance` packs |
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
| `product-design-ideate` | Generates three subject-grounded, intentional visual directions with an anti-template critique |
| `product-design-url-to-code` | Faithfully recreates a live URL as a runnable local frontend prototype |
| `product-design-image-to-code` | Implements a selected visual source as a responsive, interactive frontend |
| `product-design-design-qa` | Compares the rendered implementation with its visual source and gates handoff |
| `product-design-share` | Publishes a runnable prototype and returns a shareable link when requested |

They are imported from Product Design `0.1.52`. Their MIT provenance is
recorded in [`product-design.lock.json`](product-design.lock.json) and
[`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md).

---

## Language Guidance

Wukong Code remains language-agnostic at the methodology level. When repository evidence identifies a supported language and phase, the agent loads only the relevant implementation guidance. Packs do not install tools or override repository commands.

| Language | Status | Implementation | Testing | Debugging | Review | Verification | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Go | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | [Eval report](docs/wukong-code/evals/2026-07-22-go-language-guidance.md) |
| Java | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | [Eval report](docs/wukong-code/evals/2026-08-02-java-language-guidance.md) |
| TypeScript | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | [Cursor recapture-15 draft](docs/wukong-code/evals/2026-09-01-typescript-language-guidance-cursor-recapture-15.md) — publication eval pending |
| JavaScript | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | [Cursor recapture-15 draft](docs/wukong-code/evals/2026-09-01-javascript-language-guidance-cursor-recapture-15.md) — publication eval pending |
| Swift | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | [Eval report](docs/wukong-code/evals/2026-07-29-swift-language-guidance.md) |
| Rust | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | [Eval report](docs/wukong-code/evals/2026-07-29-rust-language-guidance.md) |

**Experimental** means the pack is published in core while real-project evidence is still accumulating. The Evidence column lists a report when one exists; drafts marked *publication eval pending* have not cleared every behavior family or human reviewer gate. Framework, cloud-service, database, and team-specific guidance stays outside core.

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

**Do I need to invoke skills manually?**

No. A working harness integration loads the bootstrap at session start, and the agent selects relevant skills from the task context.

**Can I install Wukong Code in more than one coding agent?**

Yes. Install it separately in each harness because their plugin systems are independent.

**How do I update it?**

Use the update flow provided by your harness. Repository-based installs can generally be refreshed by repeating the installation command.

**Does Wukong Code install project dependencies?**

No. Core is zero-dependency and its language packs do not install tools or replace repository-defined commands.

**Where do the behavior evals live?**

Skill-behavior evals live in [wukong-code-evals](https://github.com/wukongnotnull/wukong-code-evals), cloned locally into `evals/`. Plugin-infrastructure tests remain in `tests/`.

---

## Contributing

Wukong Code accepts new skills after maintainer review when they solve a
concrete problem, have a clear intended audience, and can be maintained safely
across supported harnesses. Domain-specific and externally sourced skills are eligible
for core review; contributors must disclose the source, license, dependency impact,
tests or evaluations, and maintenance or update strategy. Core skills remain
zero-dependency unless a separately documented harness-support exception applies.

1. Fork the repository and create a focused branch from `main`.
2. Read and complete every section of `.github/PULL_REQUEST_TEMPLATE.md`.
3. Use `writing-skills` when creating or changing behavior-shaping skill content.
4. Run the relevant infrastructure tests and behavior evaluations.
5. Show a human the complete proposed diff and obtain approval before submission.
6. Submit one focused PR targeting `main`.

See `skills/writing-skills/SKILL.md` for the complete skill-development guide.

---

## About

**悟空非空也 (Wukong)** — Founder of Way to AI, indie developer, content creator.

| Platform | Link |
| --- | --- |
| 🌐 Website | [waytoai.cn](https://waytoai.cn) |
| 𝕏 Twitter | [悟空非空也](https://x.com/wukongnotnull) |
| 📺 Bilibili | [悟空非空也](https://space.bilibili.com/456634391) |
| ▶️ YouTube | [悟空非空也](https://www.youtube.com/@wukongnotnull) |
| 📕 Xiaohongshu | [悟空非空也](https://www.xiaohongshu.com/user/profile/5ca89c2f000000001100952b) |
| 💬 WeChat | Search「悟空非空也」 |

---

## Acknowledgements

Thanks to the following open-source projects and skill collections for their inspiration and foundational work:

- [Superpowers](https://github.com/obra/superpowers)
- [Frontend Design](https://github.com/anthropics/skills/tree/main/skills/frontend-design)
- [Product Design](https://github.com/openai/role-specific-plugins/tree/main/plugins/product-design)

---

## License

Wukong Code is released under the [MIT License](LICENSE). Third-party notices are recorded in [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md).

MIT License © [悟空非空也](https://github.com/wukongnotnull)
