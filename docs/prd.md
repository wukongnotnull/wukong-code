# Wukong Code — 产品需求文档（PRD）

**状态：** 本文是对本仓库现状的快照，不是路线图。  
**产品：** Wukong Code（`wukong-code`）  
**本仓库当前版本：** `6.7.0`（`package.json`、各插件 manifest；见 `RELEASE-NOTES.md`）  
**许可证：** MIT  
**本文不替代** `README.md`（安装与概览）或 `AGENTS.md` / `CLAUDE.md`（贡献者规则）。

依据：`README.md`、`AGENTS.md`、`CLAUDE.md`、`.github/PULL_REQUEST_TEMPLATE.md`、issue 模板、`docs/porting-to-a-new-harness.md`、`docs/testing.md`、`docs/evals-setup.md`、`skills/`、`hooks/`、`THIRD_PARTY_NOTICES.md`、`product-design.lock.json`。`docs/wukong-code/specs/` 与 `docs/wukong-code/plans/` 下的带日期文件是历史设计记录，仅在其所描述行为仍在交付时引用。

---

## 1. 产品目的

Wukong Code 是一个**零依赖插件**，为编程智能体提供：

1. **可组合的技能库**，覆盖软件开发（设计、规划、TDD、调试、评审、验证、协作）与 Product Design（研究、审计、构思、复刻/实现、Design QA、分享）。
2. **会话启动时的引导指令**（bootstrap：`using-wukong-code`），使这些技能根据任务上下文**自动触发**。没有 bootstrap，磁盘上的技能文件不会被调用。

`README.md` 中的定位：*A complete software development methodology for coding agents*（面向编程智能体的完整软件开发方法论）——先设计、测试驱动开发、先验证再下结论。

它**不是** IDE、托管智能体，也不是会向用户项目安装语言工具链的软件包。

---

## 2. 面向谁

| 对象 | 他们从本产品得到什么 |
| --- | --- |
| 使用受支持编程智能体的开发者 | 在现有 harness 内运行的、可重复的工程与 Product Design 流程，无需每次任务写特殊提示 |
| 审阅智能体工作的 human partner | 强制先确认设计、生产代码前先写失败测试、宣布完成前必须有刚跑过的验证 |
| 贡献者（人类与智能体） | 进入 **core** 的高门槛，见 `AGENTS.md` / `CLAUDE.md` 与 PR 模板 |
| Harness 移植者 | 精简的交付层（bootstrap + 工具映射 + 安装产物），不得改写技能正文 |

本仓库没有具名用户画像、用量数据或市场份额声明。不要编造。

---

## 3. 范围内（core）

**本仓库**交付并维护的内容：

- **不依赖特定 harness 的技能**，位于 `skills/`（26 个顶层技能：16 个通用开发 + 10 个 Product Design）。
- **按 harness 交付：** 插件清单、SessionStart 或等价注入器；该 harness 使用映射文件时，路径为 `skills/using-wukong-code/references/<harness>-tools.md`。
- **Bootstrap：** 在会话启动时注入 `using-wukong-code`（若 harness 支持上下文压缩后再注入，例如 Pi，也在压缩之后注入），使智能体在**行动前**检查相关技能。
- **`using-wukong-code` 中的 Scope routing：** 选择**最小且适用**的过程技能；对机械修改不要自动串联 brainstorming → plans → worktrees → subagent-driven-development。
- **Product Design** 技能自 OpenAI Product Design `0.1.52`（MIT）导入，本地适配记录在 `product-design.lock.json`。Anthropic `frontend-design` **不是**独立顶层技能；其指导已并入 `product-design-ideate`（保留 Apache-2.0 声明）。
- **实验性 `language-guidance` 包**（Go、Java、TypeScript、JavaScript、Swift、Rust）：仅在仓库证据识别出语言时加载对应阶段。这些包**不**安装工具，也**不**覆盖仓库既有命令。
- **Brainstorming visual companion：** `brainstorming` 在涉及视觉问题时可选的本地 companion；按需启用，从不强制。
- **本仓库内的贡献与评估基础设施：** `tests/`（插件/基础设施）；文档说明将 [wukong-code-evals](https://github.com/wukongnotnull/wukong-code-evals) 克隆到被 `.gitignore` 排除的 `evals/`。
- **使用与移植说明：** 安装见 `README.md`（及其译本）；按 harness 分写的说明（`docs/README.kimi.md`、`docs/README.opencode.md`）；移植（`docs/porting-to-a-new-harness.md`）；测试与评估环境搭建。

---

## 4. 范围外 / 非目标

来自 `AGENTS.md`、`CLAUDE.md`、PR 模板、README FAQ 与移植指南。这些是产品约束，不是建议。

| 非目标 | 规则 |
| --- | --- |
| core 中的第三方运行时依赖 | 除非该改动是**新增 harness 支持**，否则拒绝。外部工具/服务应做成 **standalone plugin** |
| 安装项目或语言工具 | 语言包与技能不得安装工具链或替换仓库定义的命令。缺失工具只报告，不安装 |
| 每个会话再选择是否启用技能 | 有效集成必须在会话启动时加载 bootstrap。手工拷贝技能文件、`npx skills` 一类 shim、或「本会话再启用技能」都不是真正的集成 |
| 为符合 Anthropic skills 文档而改写技能正文 | 技能内容是塑造行为的代码。没有评估证据的「合规」改写会被拒绝 |
| 把仅服务单一项目或团队的配置放进 core | 个人或单项目的技能/钩子应做成独立插件 |
| 自动接纳每一个技能 | 面向特定领域以及外部引入的技能**可以**进入 core 评审；进入 core 不是自动的 |
| 把框架 / 云 / 数据库包当作 language guidance | 语言包只覆盖该语言本身，并基于官方工具链。专用技术栈须满足通用的 core 准入门槛；范围窄或维护成本过高时，优先做成 standalone plugin |
| Gemini CLI | 已在 v6.3.0 退役；不是受支持 harness |
| 上架官方 Codex 插件市场 | Codex App 从本仓库 URL 安装；README 写明未上架官方 Codex marketplace |
| 改用户全局配置来「安装」 | 移植必须只通过 harness 的安装产物交付（`docs/porting-to-a-new-harness.md`） |
| 把 fork 重新包装成另一品牌 / 从 fork 同步到上游的 PR | 关闭 |
| 推测性或批量「修 issue 列表」的 PR | 关闭。每个 PR 只解决一个真实遇到过的问题 |
| 编造声明或虚构功能 | 关闭 |
| 捆绑互不相关的改动 | 关闭 |

**Standalone plugin 与 core：** 当技能用途窄、许可证不兼容、行为不安全、未声明依赖、维护成本过高、或无法证明超出单一项目/团队的价值时，优先做成独立插件。

---

## 5. 主要能力

### 5.1 软件开发工作流

技能在适用时是**要求**，不是建议。先由 `using-wukong-code` 分类。

```text
你的想法
   ↓
Brainstorm 或 grilling → 已确认的设计 → 实施计划
   ↓
RED → GREEN → REFACTOR → 评审 → 验证
   ↓
合并 / PR / 保留分支
```

| 步骤 | 技能 | 要求 |
| --- | --- | --- |
| 路由 | `using-wukong-code` | 任何行动前检查技能；选择最小且适用的工作流 |
| 设计 | `brainstorming` | 新功能 / 行为变更 / 意图不明：实现前须设计确认。可选 visual companion |
| 深度访谈 | `grilling` | 明确要求 grilling / 「逐题问清楚」。把已确认记录写成 spec；仅在**书面** spec 获批后才进入 `writing-plans` |
| 调试 | `systematic-debugging` | 根因不明的缺陷：先查根因再修 |
| 快路径 | （无 / 一个领域技能） | 已明确指定的机械修改（确切文件 + 确切改动，无设计歧义） |
| 计划 | `writing-plans` | 已确认的多步设计 → 带路径与验证步骤的小任务 |
| 隔离 | `using-git-worktrees` | 执行需要隔离时使用独立工作区；先确认干净的测试基线 |
| 执行 | `executing-plans` 或 `subagent-driven-development` | 任务级评审或由人确认的检查点；实现阶段适用 TDD 时按 TDD 执行 |
| TDD | `test-driven-development` | 生产实现前必须 RED。用户要求跳过失败测试时，testing-pressure 路由优先于 brainstorming |
| 验证 | `verification-before-completion` | 需要刚跑过的证据；未实际运行的检查不能当作已经验证 |
| 评审 | `requesting-code-review`、`receiving-code-review` | 过程中检查需求符合度与代码质量 |
| 并行 | `dispatching-parallel-agents` | 适当时做隔离的并行工作 |
| 收尾 | `finishing-a-development-branch` | 尊重已有集成意图，或提供合并 / PR / 保留 / 丢弃 |
| 元技能 | `writing-skills` | 如何编写并评测技能 |

### 5.2 Product Design 工作流

路由技能：`product-design`。**不是**固定不变的一套步骤；按请求选最短路径。

| 路径 | 技能 | 门槛 |
| --- | --- | --- |
| 研究 / 审计 | `product-design-user-context`、`product-design-context`、`product-design-research` 或 `product-design-audit` | 以证据为准；**不修改源代码** |
| 探索新方向 | `product-design-ideate` | 三个视觉方案；实现前由人选择 |
| 复刻 / 实现 | `product-design-url-to-code` 或 `product-design-image-to-code` | 忠实复刻 / 将选定视觉稿实现为响应式前端 |
| QA | `product-design-design-qa` | 比较渲染结果与视觉来源；未通过则**阻断交付** |
| 分享 | `product-design-share` | 用户要求时发布可运行原型 |

Product Design 只适配**当前实际可用**的浏览器、图像生成、本地构建与分享能力。不虚构工具。

### 5.3 Language guidance

Wukong Code 在方法论层面保持语言无关。当标记识别出受支持语言与阶段时，**只**加载该包的相关文件。

| 语言 | README 中的状态 | 证据 |
| --- | --- | --- |
| Go、Java、Swift、Rust | 实验性 | `docs/wukong-code/evals/` 下的评估报告 |
| TypeScript、JavaScript | 实验性 | Cursor recapture-15 草案；**发布评估待定** |

**实验性**（Experimental）表示已进入 core 发布，真实项目证据仍在积累。语言包在标为 stable 前，需要熟悉该语言的人工审阅者。

### 5.4 受支持的 harness

每个 harness **分别**安装。README 当前列出：

Antigravity · Claude Code · Codex App · Codex CLI · Cursor · Factory Droid · GitHub Copilot CLI · Kimi Code · OpenCode · Pi

**新 harness 验收（PR 模板强制）：** 在全新会话中原样发送 `Let's make a react todo list`，必须在写任何代码前**自动触发 `brainstorming`**。会话启动时加载 bootstrap 才算集成。

移植架构（`docs/porting-to-a-new-harness.md`）：

1. **Skills** — 各 harness 共用同一份原文；只描述**动作**，不写厂商工具名。
2. **Tool mapping** — 该 harness 使用此模式时，用 `references/<harness>-tools.md`。
3. **Bootstrap** — 注入 `using-wukong-code`（存在 Product Design 技能时另加 composition pointer）。

---

## 6. 约束（质量与协作）

面向贡献者的产品规则。`AGENTS.md` 写明本仓库 **94% 的 PR 会被拒绝**；这是项目自己的警告，不是经外部核实的统计。

- PR 目标分支为 **`main`**。填完 PR 模板每一节。写明所用 model、harness、harness 版本、已安装插件。提交前必须有**人类**审阅**完整** diff。
- 开新 PR 前检索**未关闭与已关闭**的 PR。
- 改技能：使用 `writing-skills`、对抗性压测、**改前/改后评估**。无证据不得改动 Red Flags、rationalization 列表或 “human partner” 用语。
- Issue：先区分 bug 与平台问题（卸载 Wukong Code 再复现）；功能请求须说明为何进 **core** 而非 standalone plugin；新 IDE 走 `platform_support`。
- 用语：**“your human partner”** 是有意保留的。

---

## 7. 如何判断成功

仓库内没有增长或 NPS 目标。成功看**行为表现与贡献质量**。

| 门槛 | 「好」是什么 | 落在何处 |
| --- | --- | --- |
| Bootstrap | 技能在正确时机触发，无需每次任务再走一遍仪式 | SessionStart / 注入器；新 harness 会话记录 |
| 过程 | 先设计再写代码；先 RED 再 GREEN；先验证再宣布完成 | 技能正文 + 评估 |
| Product Design | 研究/审计不改源码；新视觉须先选定方向；Design QA 挡住不合格交付 | Product Design 技能 + 导入锁 |
| 插件正确性 | 不依赖大模型的打包、钩子、映射、清单 | `tests/`；`npm test` / `npm run test:extended`；CI `.github/workflows/test.yml` |
| 技能行为 | 真实智能体会话遵守技能 | `evals/` 中的 wukong-code-evals 克隆；Drill / Cursor 评测批次（手动/按需；需要 API key） |
| 评估定义 | scenario JSONL 保持有效 | 每周 `evals-static.yml`（不需要 API key） |
| 语言包 | 失败对照组 + 重复行为评估；不引入额外框架 | PR 模板 “Language-pack evidence”；报告在 `docs/wukong-code/evals/` |
| 贡献 | 真实问题、一次改动、人类审阅、无敷衍稿（slop） | PR 模板；`AGENTS.md` |

完整的大模型评估按设计**不在** PR 必跑测试范围内（`docs/evals-setup.md`）。涉及发布或技能措辞的主张仍需要跑这些评估。

---

## 8. 来源与许可

| 来源 | 角色 |
| --- | --- |
| [Superpowers](https://github.com/obra/superpowers)（MIT，Jesse Vincent） | 核心开发技能、`using-*` bootstrap 模式、hooks/injectors、Codex 打包、贡献者指南的渊源 |
| [OpenAI Product Design](https://github.com/openai/role-specific-plugins/tree/main/plugins/product-design)（MIT） | 十个 Product Design 技能及相关资源；锁文件 `product-design.lock.json` |
| [Anthropic frontend-design](https://github.com/anthropics/skills/tree/main/skills/frontend-design)（Apache-2.0） | 并入 `product-design-ideate` 的原创视觉方向指导；不是顶层技能 |

README About 中的维护者身份：**悟空非空也 (Wukong)**。

---

## 9. 相关文档

| 文档 | 用途 |
| --- | --- |
| `README.md`（以及 `README.zh-CN.md`、`README.zh-TW.md`、`README.ja.md`、`README.ko.md`） | 安装、工作流、技能清单 |
| `AGENTS.md` / `CLAUDE.md` | 贡献者 / 智能体 PR 规则 |
| `.github/PULL_REQUEST_TEMPLATE.md` | 必填 PR 字段、harness 会话记录、评估 |
| `docs/porting-to-a-new-harness.md` | 移植必须满足什么 |
| `docs/testing.md` | `tests/` 与 `evals/` |
| `docs/evals-setup.md` | 如何克隆并分层运行评估 harness |
| `RELEASE-NOTES.md` | `main` 上已发布与 Unreleased |
| `docs/wukong-code/specs/`、`docs/wukong-code/plans/` | 带日期的功能设计与实施计划（历史） |
