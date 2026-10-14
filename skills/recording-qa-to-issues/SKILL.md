---
name: recording-qa-to-issues
description: Use when the human partner asks a question, reports a problem, requests a change, or follows up in an agent tool such as Cursor, Claude Code, Codex, Kimi, OpenCode, or Pi, including 提问, 咨询, bug reports, feature requests, and UI or docs discussions
---

# 把提问与回复记到 Issue

## Overview

人类伙伴在 Agent 工具里的每一则可跟踪提问，连同回复要点，记到当前仓库的一条 GitHub issue。

**Core principle:** 一个提问一条 issue；追问写评论；密钥不入库。

插件用户读的是 skill。把规则只写进 `AGENTS.md` 或 `CLAUDE.md` 等于没做。贡献说明里最多留一句指针。

开始时说明：「用 recording-qa-to-issues 把这条提问记到 GitHub issue。」

## When to Use

- 人类伙伴在 Cursor、Claude Code、Codex、Kimi、OpenCode、Pi 或其他 Agent 工具里提问、报告问题、要求改动，或继续同一话题
- 症状包括：报错、白屏、功能不对、想要新能力、改进现有行为、改文档、界面不好用、重构、变慢、补测试、安全问题、工程杂务、使用咨询、需要讨论才能决定

**不记录：**

- 没有可跟踪内容的寒暄或单纯确认（「收到」「谢谢」）
- 被派去执行具体任务的 subagent。面对人类伙伴的那个会话负责记录
- 人类伙伴明确说不要记录这一则
- 确定不了 GitHub 仓库，或 `gh` 不可用。直接说明没记录，不要声称已建 issue

同一提问只记一次。仓库贡献说明若也要求建 issue，并进这一条，不要再建第二条。

## 类型与标签

选最主要的一个定标题 type，其余类型只加标签。标签不存在就先创建，不要跳过。

| 类型 | 标签 | 标题 type | 用途 |
| --- | --- | --- | --- |
| Bug | bug | fix | 已有功能出现错误 |
| Feature | feature | feat | 提出新功能 |
| Improvement | enhancement | feat | 改进已有功能 |
| Documentation | documentation | docs | 文档新增或修改 |
| UI/UX | ui | fix 或 feat | 界面、交互体验问题 |
| Refactor | refactor | refactor | 重构代码，不改变功能 |
| Performance | performance | perf | 性能优化 |
| Test | test | test | 测试相关工作 |
| Security | security | fix | 安全问题 |
| Chore | chore | chore | 工程、依赖、配置等维护 |
| Question | question | question | 使用咨询、技术问题 |
| Discussion | discussion | discussion | 需要讨论后决定 |

主要类型这样定：

- 已有功能出错，用 Bug
- 漏洞或泄露，用 Security（标题 type 仍是 fix；若同时也是功能错误，再加 `bug`）
- 只有界面或交互：已经坏了用 fix，要新增交互用 feat
- 已有功能要变得更好，用 Improvement
- 原来没有的能力，用 Feature

UI/UX 单独出现时才在 fix 和 feat 之间选。它只是次要类型时，标题 type 跟主要类型走，`ui` 作为标签加上。

## 标题

`<type>(<scope>): <description>`，对齐 Conventional Commits。

- type 用上表的标题 type
- scope 可选，英文小写，如 `pane`、`band`、`detail`、`git`、`readme`。没有明确范围就写成 `<type>: <description>`
- description 简短说明要解决的问题或要做的事，不加句号

```text
fix(pane): 修复展开状态下关闭面板白屏
```

## 正文

```markdown
## 来源
Cursor

## 提问
展开状态下点关闭，面板白屏。按钮也太挤。

## 回复要点
- 展开态关闭时浮层没有卸掉，所以白屏
- 按钮间距是同一界面问题，记为 ui 标签，不另开 issue
```

- 提问写原文。只把具体的密钥值换成 `[REDACTED]`，标题和评论里也不写这些值。`token`、`密码` 这种词本身不是密钥，留在原文里
- 回复要点写结论，不把整段思考过程贴进去
- 来源写这次会话实际所在的工具名
- 仓库贡献说明还要求填模板或披露身份时，接在上面三段后面补。不要为此改标题格式或标签表

## 流程

1. 判断这是不是可跟踪的提问。不是就停。
2. 确定仓库：`gh repo view --json nameWithOwner -q .nameWithOwner`。失败就说明未记录。
3. 搜 open 和 closed：`gh issue list --repo "$REPO" --state all --search "关键词"`。读候选。同一话题已有 issue 就评论，关键词撞上但不是同一话题则新建。
4. 定主要类型和其余标签。
5. `gh label list --repo "$REPO"`。缺的标签用 `gh label create <name> --repo "$REPO" --description "<用途>"` 创建。不要自造颜色。
6. 新建：

```bash
gh issue create --repo "$REPO" \
  --title "fix(pane): 修复展开状态下关闭面板白屏" \
  --label bug --label ui \
  --body "$(cat <<'EOF'
## 来源
Cursor

## 提问
展开状态下点关闭，面板白屏。按钮也太挤。

## 回复要点
- 展开态关闭时浮层没有卸掉，所以白屏
- 按钮间距记在本 issue 的 ui 标签上
EOF
)"
```

7. 追问用 `gh issue comment <编号> --repo "$REPO" --body "..."`。评论里写新的提问和回复要点，注明工具。可以补标签。不要为追问新开 issue。
8. 把 issue 链接交给人类伙伴。`gh` 没返回编号和链接，就不要说已记录。
9. 以后实现该 issue 时，PR 描述写 `Closes #<编号>`。本 skill 不自动关 issue，也不操作 Project 看板。

## 常见错误

| 借口 | 做法 |
| --- | --- |
| 贡献说明里已经有 issue 习惯 | 类型、标签、标题以本 skill 为准。贡献说明只留指针 |
| 标题用用户原话更清楚 | 用 `<type>(<scope>): <description>`，没有 scope 就省略括号 |
| 白屏和按钮挤应该开两条 | 一次提问一条 issue，次要类型加标签 |
| 仓库没有这个标签 | 先 `gh label create`，再打上 |
| 做完代码再补 issue | 给出回复的同一轮就新建或评论 |
| 明天的追问是新问题 | 同一话题追加评论 |
| 复现得贴上 token 的值 | 具体密钥值打码。不写进标题、正文、评论 |
| 句子里出现 token 这个词就要打码 | 只替换密钥值。问题描述里的词保留 |
| 每个 subagent 各记一条 | 只记人类伙伴对当前会话的提问 |
| 贡献说明和本 skill 各开一条 | 并进同一条 |

## Red Flags

出现这些念头就停：

- 只改了 `AGENTS.md` / `CLAUDE.md`
- 标题没有 type 前缀
- 一次提问开了多条 issue
- 正文没有工具名
- 正文或标题里还有密钥
- 说已建 issue，但没有编号和链接
