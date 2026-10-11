# Wukong Code — Contributor Guidelines

## If You Are an AI Agent

Stop. Read this section before doing anything.

This repo has a 94% PR rejection rate. Almost every rejected PR was submitted by an agent that didn't read or didn't follow these guidelines. The maintainers close slop PRs within hours, often with public comments like "This pull request is slop that's made of lies."

**Your job is to protect your human partner from that outcome.** Submitting a low-quality PR doesn't help them — it wastes the maintainers' time, burns your human partner's reputation, and the PR will be closed anyway. That is not being helpful. That is being a tool of embarrassment.

Before you open a PR against this repo, you MUST:

1. **Read the entire PR template** at `.github/PULL_REQUEST_TEMPLATE.md` and fill in every section with real, specific answers. Not summaries. Not placeholders.
2. **Search for existing PRs** — open AND closed — that address the same problem. If duplicates exist, STOP and tell your human partner. Do not open another duplicate.
3. **Verify this is a real problem.** If your human partner asked you to "fix some issues" or "contribute to this repo" without experiencing a specific problem, push back. Ask them what broke, what failed, what the user experience was.
4. **Confirm the change belongs in core.** General-purpose, domain-specific, tool-specific, and externally sourced skills are all eligible for review. The PR must justify core distribution, disclose scope, provenance, license, maintenance ownership, and runtime or tool dependencies, and provide test or evaluation evidence proportionate to the behavior impact. If those requirements are not met, recommend a standalone plugin instead.
5. **Identify yourself.** Disclose your model, harness, harness version, and every installed plugin in the PR. Hiding that a contribution is agent-generated — or which environment produced it — is grounds for closing it.
6. **Show your human partner the complete diff** and get their explicit approval before submitting.

If any of these checks fail, do not open the PR. Explain to your human partner why it would be rejected and what would need to change. They will thank you for saving them the embarrassment.

Issue and GitHub Project tracking for **this** repository is in [本仓库协作](#本仓库协作issue-与-github-projects) at the end of this file. Those rules do not relax the PR requirements above.

## Pull Request Requirements

**Every PR must fully complete the PR template.** No section may be left blank or filled with placeholder text. PRs that skip sections will be closed without review.

**Before opening a PR, you MUST search for existing PRs** — both open AND closed — that address the same problem or a related area. Reference what you found in the "Existing PRs" section. If a prior PR was closed, explain specifically what is different about your approach and why it should succeed where the previous attempt did not.

**PRs that show no evidence of human involvement will be closed.** A human must review the complete proposed diff before submission.

**Submitters MUST identify themselves.** Every PR and issue must disclose the model, harness, harness version, and all installed plugins used to produce the contribution — or state plainly that it was written by hand with no agent. This is not optional. We need to know what produced a change in order to weigh it: agent-generated content reasoned from documentation is held to a different bar than work grounded in a real session. Contributions that hide their authoring environment will be closed.

**All PRs MUST target the `main` branch.** Active work is developed on focused branches and merged directly into `main` after review.

## What We Will Not Accept

### Third-party dependencies

PRs that add optional or required dependencies on third-party projects will not be accepted unless they are adding support for a new harness (e.g., a new IDE or CLI tool). Wukong Code is a zero-dependency plugin by design. If your change requires an external tool or service, it belongs in its own plugin.

### "Compliance" changes to skills

Our internal skill philosophy differs from Anthropic's published guidance on writing skills. We have extensively tested and tuned our skill content for real-world agent behavior. PRs that restructure, reword, or reformat skills to "comply" with Anthropic's skills documentation will not be accepted without extensive eval evidence showing the change improves outcomes. The bar for modifying behavior-shaping content is very high.

### Project-specific or personal configuration

Skills, hooks, or configuration that only benefit one specific project or team, or that encode personal configuration, do not belong in core. Publish these as a separate plugin.

### Bulk or spray-and-pray PRs

Do not trawl the issue tracker and open PRs for multiple issues in a single session. Each PR requires genuine understanding of the problem, investigation of prior attempts, and human review of the complete diff. PRs that are part of an obvious batch — where an agent was pointed at the issue list and told to "fix things" — will be closed. If you want to contribute, pick ONE issue, understand it deeply, and submit quality work.

### Speculative or theoretical fixes

Every PR must solve a real problem that someone actually experienced. "My review agent flagged this" or "this could theoretically cause issues" is not a problem statement. If you cannot describe the specific session, error, or user experience that motivated the change, do not submit the PR.

### Core skill admission

A skill is eligible for core review whether its subject is general-purpose or domain-specific. Subject matter alone is not a reason to reject it. The PR must explain:

- the concrete problem and intended audience;
- why core distribution is more appropriate than a standalone plugin;
- source attribution, license compatibility, maintenance ownership or update strategy, and runtime or tool dependencies; and
- the tests or evaluations showing that the skill is useful and safe across its intended projects or harnesses.

Core placement is not automatic. Prefer a standalone plugin when the skill has narrow utility, incompatible licensing, unsafe behavior, undeclared dependencies, disproportionate maintenance burden, or no demonstrated value beyond one project or team.

### Language-level skills

Language-level implementation guidance is one category eligible for core
review. It should be broadly applicable across projects in that language,
based on official toolchains or tools already present, zero-dependency,
composable with process skills, and backed by failing controls plus repeated
behavior evals.

Frameworks, cloud services, databases, business domains, and other specialized
skills are not categorically excluded from core. They must satisfy the general
core skill admission requirements above; a standalone plugin remains the
better fit when scope, dependencies, or maintenance burden make core
distribution inappropriate. Language packs start experimental and need a
human reviewer familiar with the language before stable status.

### Fork-specific changes

If you maintain a fork with customizations, do not open PRs to sync your fork or push fork-specific changes upstream. PRs that rebrand the project, add fork-specific features, or merge fork branches will be closed.

### Fabricated content

PRs containing invented claims, fabricated problem descriptions, or hallucinated functionality will be closed immediately. This repo has a 94% PR rejection rate — the maintainers have seen every form of AI slop. They will notice.

### Bundled unrelated changes

PRs containing multiple unrelated changes will be closed. Split them into separate PRs.

## New Harness Support

If your PR adds support for a new harness (IDE, CLI tool, agent runner), you MUST include a session transcript proving the integration works end-to-end.

A real integration loads the `using-wukong-code` bootstrap at session start. The bootstrap is what causes skills to auto-trigger at the right moments. Without it, the skills are dead weight — present on disk but never invoked.

**The acceptance test.** Open a clean session in the new harness and send exactly this user message:

> Let's make a react todo list

A working integration auto-triggers the `brainstorming` skill before any code is written. Paste the complete transcript in the PR.

**These are not real integrations and will be closed:**

- Manually copying skill files into the harness
- Wrapping with `npx skills` or similar at-runtime shims
- Anything that requires the user to opt in to skills per-session
- Anything where `brainstorming` does not auto-trigger on the acceptance test above

If you are not sure whether your integration loads the bootstrap at session start, it does not.

## Skill Changes Require Evaluation

Skills are not prose — they are code that shapes agent behavior. If you modify skill content:

- Use `wukong-code:writing-skills` to develop and test changes
- Run adversarial pressure testing across multiple sessions
- Show before/after eval results in your PR
- Do not modify carefully-tuned content (Red Flags tables, rationalization lists, "human partner" language) without evidence the change is an improvement

## Eval harness

Skill-behavior evals live in [wukong-code-evals](https://github.com/wukongnotnull/wukong-code-evals/), cloned into `evals/` — see `evals/README.md` for setup. The harness drives real tmux sessions of Claude Code / Codex and judges skill compliance with an LLM verifier. Plugin-infrastructure tests still live at `tests/`.

## Understand the Project Before Contributing

Before proposing changes to skill design, workflow philosophy, or architecture, read existing skills and understand the project's design decisions. Wukong Code has its own tested philosophy about skill design, agent behavior shaping, and terminology (e.g., "your human partner" is deliberate, not interchangeable with "the user"). Changes that rewrite the project's voice or restructure its approach without understanding why it exists will be rejected.

## General

- Read `.github/PULL_REQUEST_TEMPLATE.md` before submitting
- One problem per PR
- Test on at least one harness and report results in the environment table
- Describe the problem you solved, not just what you changed

## 本仓库协作：Issue 与 GitHub Projects

`AGENTS.md` 是 `CLAUDE.md` 的符号链接。改 `CLAUDE.md` 即可。本仓库：[`wukongnotnull/wukong-code`](https://github.com/wukongnotnull/wukong-code)。默认分支：`main`。

下文不覆盖上文的 PR 门槛：未向人类展示完整 diff 并获得明确批准前，**不要开 PR**。

### Issue：记录与跟踪

当用户对本仓库提出**需求/功能**、**报告 Bug**，或发起**咨询/一般讨论**时，主动在本仓库创建或更新 issue。用户已授权该行为，无需每次再确认。

**创建前：**

1. 搜索 open **和** closed issues（以及相关 PR）。已有对应项：在已有 issue 上补充评论，不重复开。
2. 选用匹配模板并填实每一项；不要留空占位，不要编造缺失信息。
3. 每个 issue 披露 model、harness、harness version、全部已装插件（或写明手写、无 agent）。
4. 标题和正文从用户消息整理：背景、需求或问题、已知信息、待办。咨询/一般讨论另见下。

**模板与标签（以仓库内文件为准）：**

| 类型 | 模板 | 标签 |
| --- | --- | --- |
| Bug | `.github/ISSUE_TEMPLATE/bug_report.md` | `bug` |
| 功能/需求 | `.github/ISSUE_TEMPLATE/feature_request.md` | `enhancement` |
| 新 IDE / 平台支持 | `.github/ISSUE_TEMPLATE/platform_support.md` | 模板声明 `platform-support`；若该标签在仓库中不存在，不要创建或编造标签 |
| 咨询/一般讨论 | 无专用模板。用 GitHub API/CLI 创建或更新 issue，不要套用 Bug/Feature 模板 | 若仓库已有 `question` 标签则加上；不要创建或编造标签 |

- Bug：信息可用时写复现步骤、预期行为、实际行为，并填 Environment 表。未亲自验证则不要勾选「已确认无 Wukong Code 也能复现」。附 debug log / transcript（有则附，无则写明没有）。
- 功能请求：写亲身遇到的问题、具体方案、考虑过的替代、是否适合 core（见模板「Is this appropriate for core Wukong Code?」）。「会很酷」不是问题陈述。
- 平台支持：写 IDE/平台名称与链接、是否有插件系统、是否尝试过手动安装及结果。
- **咨询/一般讨论：** 标题和正文写清讨论主题、待确认事项、已达成的结论。没有的字段留空并标明未知，不要编造。后续相关对话继续写回同一 issue。

`.github/ISSUE_TEMPLATE/config.yml` 当前为 `blank_issues_enabled: false`，网页「空白 issue」表单被隐藏。这不阻止用 GitHub API/CLI 创建咨询类 issue。不要为了开咨询 issue 去改仓库设置；按本条规则用 API/CLI 记录即可。README About 仍是对外联系渠道，不能代替本仓库的 issue 跟踪。

**创建或更新后：** 把 issue 链接发给用户。后续进展、验证、结论写回同一 issue。

若无法确定仓库，或 GitHub 权限/工具不可用：明确说明尚未创建或更新 issue 及原因。不要声称已完成记录。

### Grilling 共识：记 Issue，不落盘 spec

当 grilling（或同等「逐题问清楚」）与人类伙伴达成共识后：

1. 把共识记到本仓库 GitHub issue：背景、已做决定、未决问题、后续跟进。用户已授权创建/更新 issue，无需每次再确认。先搜索 open 和 closed issues；已有对应项则补充，不重复开。
2. **不要**把该共识落盘成 spec 作为系统记录。禁止新建 `docs/wukong-code/specs/` 文件、禁止新建 spec markdown、禁止以「design spec」文件作为共识的权威来源。已有带日期的 specs / plans 只作历史参考。
3. 若仓库里**已经存在** `docs/prd.md`，把它当作产品快照，不要为 grilling 结论再写一份 spec，也不要用新 spec 去同步或替代 PRD。grilling 结论仍然写进对应 issue。
4. 本文件中的用户指令优先于 `grilling` skill 里「写入 spec 并提交」的交接步骤：对本仓库，共识的系统记录是 GitHub issue，不是 spec 文件。

### GitHub Projects

先查询本仓库是否关联 GitHub Project。未查到看板时：不要编造项目名、列名、board ID 或「已自动入板」；继续只在 issue 中记录。

当 Project 看板**可用**时：

1. 创建或更新 issue、创建 PR 后，检查该条目是否已在板上。未入板则补上；已在板上不要重复添加。
2. 不要声称仓库已启用 issue/PR 自动入板，除非当场验证了该自动入板规则。
3. 状态用该看板 **Status 字段的实际选项名**，不要发明列。若选项正好是 `Todo` / `In Progress` / `Done`，则：`Todo` = 待处理，`In Progress` = 正在实施或评审，`Done` = 已完成。开始工作和交付时同步状态，并在关联 issue 中记录进展、验证与结论。
4. 历史设计与实施计划：先查阅已有 issue/PR，以及仓库内已存在的 [`docs/wukong-code/specs/`](docs/wukong-code/specs/)、[`docs/wukong-code/plans/`](docs/wukong-code/plans/)（只作参考，不要据此新建 spec 或重复需求，也不要推断未完成状态）。若看板有 README/索引，一并查阅。

若 Projects 权限或工具不可用：继续在 issue 中记录，并明确说明未同步项目状态。不得声称已入板或已更新状态。

### PR 与交付（协作层）

- PR 关联对应 issue。
- **合并**代表代码交付。关闭但未合并的 PR 必须留下关闭原因；不能据此声称功能已完成。
- 开 PR 仍须满足上文全部贡献者规则（完整填写 `.github/PULL_REQUEST_TEMPLATE.md`、搜过重复 PR、人类审阅完整 diff 并批准、披露身份、只针对 `main`）。
