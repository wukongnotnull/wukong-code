# Wukong Code — Product Requirements Document

**Status:** Living snapshot of this repository. Not a roadmap.  
**Product:** Wukong Code (`wukong-code`)  
**Current version in tree:** `6.4.0` (`package.json`, plugin manifests), plus documented Unreleased work already on `main` (see `RELEASE-NOTES.md`)  
**License:** MIT  
**This document does not replace** `README.md` (install and overview) or `AGENTS.md` / `CLAUDE.md` (contributor rules).

Grounded in: `README.md`, `AGENTS.md`, `CLAUDE.md`, `.github/PULL_REQUEST_TEMPLATE.md`, issue templates, `docs/porting-to-a-new-harness.md`, `docs/testing.md`, `docs/evals-setup.md`, `skills/`, `hooks/`, `THIRD_PARTY_NOTICES.md`, `product-design.lock.json`. Dated files under `docs/wukong-code/specs/` and `docs/wukong-code/plans/` are historical design records; they are cited only where they describe behavior that still ships.

---

## 1. Purpose

Wukong Code is a **zero-dependency plugin** that gives a coding agent:

1. A **composable skill library** covering software development (design, planning, TDD, debugging, review, verification, collaboration) and Product Design (research, audit, ideation, clone/implement, Design QA, share).
2. **Session-start bootstrap** (`using-wukong-code`) so those skills **auto-trigger** from task context. Without the bootstrap, skill files on disk are inert.

Tagline in `README.md`: *A complete software development methodology for coding agents* — design first, test-driven development, evidence before claims.

This is **not** an IDE, a hosted agent, or a package that installs language toolchains into the user's project.

---

## 2. Who it is for

| Audience | What they need from this product |
| --- | --- |
| Developers using a supported coding agent | A repeatable engineering and Product Design process that runs inside their existing harness, without a special per-task prompt |
| Human partners reviewing agent work | Skills that force design approval, failing tests before production code, and fresh verification before completion claims |
| Contributors (humans and agents) | A high bar for what may enter **core**, documented in `AGENTS.md` / `CLAUDE.md` and the PR template |
| Harness porters | A thin delivery layer (bootstrap + tool mapping + install artifact) that must not rewrite skill bodies |

There are no named customer personas, usage metrics, or market-share claims in this repository. Do not invent them.

---

## 3. In scope (core)

What **this repository** ships and maintains:

- **Harness-agnostic skills** under `skills/` (26 top-level skills: 16 general development + 10 Product Design).
- **Per-harness delivery:** plugin manifests, SessionStart / equivalent injectors, `skills/using-wukong-code/references/<harness>-tools.md` where that harness uses a mapping file.
- **Bootstrap:** inject `using-wukong-code` at session start (and after compaction where a harness supports it, e.g. Pi) so the agent checks for a relevant skill **before** acting.
- **Scope routing** in `using-wukong-code`: pick the **smallest** applicable process skill; do not auto-chain brainstorming → plans → worktrees → subagent-driven-development for mechanical edits.
- **Product Design** skills imported from OpenAI Product Design `0.1.52` (MIT), with local adaptations recorded in `product-design.lock.json`. Anthropic `frontend-design` is **not** a standalone skill; its guidance is folded into `product-design-ideate` (Apache-2.0 notice retained).
- **Experimental `language-guidance` packs** (Go, Java, TypeScript, JavaScript, Swift, Rust): load only the relevant phase when repository evidence identifies the language. Packs do **not** install tools or override repository commands.
- **Brainstorming visual companion:** optional local companion used by `brainstorming` for visual questions; just-in-time, never required.
- **Contributor and eval infrastructure** in this repo: `tests/` (plugin/infrastructure), docs for cloning [wukong-code-evals](https://github.com/wukongnotnull/wukong-code-evals) into gitignored `evals/`.
- **Documentation for operators:** install in `README.md` (and translations), harness-specific notes (`docs/README.kimi.md`, `docs/README.opencode.md`), porting (`docs/porting-to-a-new-harness.md`), testing and evals setup.

---

## 4. Out of scope / non-goals

From `AGENTS.md`, `CLAUDE.md`, the PR template, README FAQ, and porting guide. These are product constraints, not suggestions.

| Non-goal | Rule |
| --- | --- |
| Third-party runtime dependencies in core | Rejected unless the change is **new harness support**. External tools/services belong in a **standalone plugin** |
| Installing project or language tools | Language packs and skills must not install toolchains or replace repo-defined commands. Missing tools are reported, not installed |
| Per-session opt-in to skills | A working integration loads bootstrap at session start. Manual copy of skill files, `npx skills` shims, or “enable skills this session” are not real integrations |
| Rewriting skill bodies to match Anthropic skills docs | Skill content is behavior-shaping code. “Compliance” rewording without eval evidence is rejected |
| Project- or team-only configuration in core | Personal or single-project skills/hooks belong in a separate plugin |
| Automatic admission of every skill | Domain-specific and externally sourced skills **may** be reviewed for core; placement is not automatic |
| Framework / cloud / database packs as language guidance | Language packs stay language-level and official-toolchain based. Specialized stacks need the general core-admission bar; a standalone plugin is preferred when scope or maintenance is narrow |
| Gemini CLI | Retired in v6.3.0; not a supported harness |
| Official Codex plugin marketplace listing | Codex App installs from this repository URL; README states it is not in the official Codex marketplace |
| Editing the user's global config to “install” | Ports must ship through the harness install artifact only (`docs/porting-to-a-new-harness.md`) |
| Fork rebrand / sync-from-fork PRs | Closed |
| Speculative or bulk “fix the tracker” PRs | Closed. One real, experienced problem per PR |
| Fabricated claims or hallucinated features | Closed |
| Bundled unrelated changes | Closed |

**Standalone plugin vs core:** Prefer a standalone plugin when the skill has narrow utility, incompatible licensing, unsafe behavior, undeclared dependencies, disproportionate maintenance, or no demonstrated value beyond one project or team.

---

## 5. Capabilities

### 5.1 Software development workflow

Skills are **requirements**, not suggestions, when they apply. `using-wukong-code` classifies first.

```text
Your idea
   ↓
Brainstorm or grilling → Approved design → Implementation plan
   ↓
RED → GREEN → REFACTOR → Review → Verification
   ↓
Merge / PR / keep the branch
```

| Step | Skill(s) | Requirement |
| --- | --- | --- |
| Route | `using-wukong-code` | Check skills before any action; smallest applicable workflow |
| Design | `brainstorming` | New features / behavior change / ambiguous intent: design approval before implementation. Optional visual companion |
| Deep interview | `grilling` | Explicit grilling / 「逐题问清楚」. Persist confirmed record as a spec; `writing-plans` only after the **written** spec is approved |
| Debug | `systematic-debugging` | Unclear bugs: root cause before fix |
| Fast path | (none / one domain skill) | Named mechanical edit (exact file + exact change, no design ambiguity) |
| Plan | `writing-plans` | Approved multi-step design → small tasks with paths and verification |
| Isolate | `using-git-worktrees` | Isolated workspace when execution needs isolation; clean test baseline |
| Execute | `executing-plans` or `subagent-driven-development` | Task-level review or human checkpoints; TDD when implementation applies |
| TDD | `test-driven-development` | RED before production implementation. Testing-pressure routing beats brainstorming when the user asks to skip a failing test |
| Verify | `verification-before-completion` | Fresh evidence; do not treat unrun checks as proof |
| Review | `requesting-code-review`, `receiving-code-review` | Spec and quality review in the loop |
| Parallelism | `dispatching-parallel-agents` | Isolated parallel work when appropriate |
| Finish | `finishing-a-development-branch` | Honor existing integration intent, or offer merge / PR / keep / discard |
| Meta | `writing-skills` | How to author and eval skills |

### 5.2 Product Design workflow

Router: `product-design`. **Not** one fixed sequence; shortest path for the request.

| Path | Skills | Gates |
| --- | --- | --- |
| Research / audit | `product-design-user-context`, `product-design-context`, `product-design-research` or `product-design-audit` | Evidence-based; **does not modify source code** |
| Explore a new direction | `product-design-ideate` | Three visual options; human chooses before implementation |
| Clone / implement | `product-design-url-to-code` or `product-design-image-to-code` | Faithful recreation / selected visual as responsive frontend |
| QA | `product-design-design-qa` | Compare render vs visual source; **blocks handoff** until it passes |
| Share | `product-design-share` | Publish runnable prototype when the user asks |

Product Design adapts to **actually available** browser, image-generation, local-build, and sharing capabilities. It does not invent tools.

### 5.3 Language guidance

Methodology stays language-agnostic. When markers identify a supported language and phase, load **only** that pack's relevant files.

| Language | Status in README | Evidence |
| --- | --- | --- |
| Go, Java, Swift, Rust | Experimental | Eval reports under `docs/wukong-code/evals/` |
| TypeScript, JavaScript | Experimental | Cursor recapture-15 drafts; **publication eval pending** |

**Experimental** means published in core while real-project evidence is still accumulating. Language packs need a human reviewer familiar with the language before stable status.

### 5.4 Supported harnesses

Install **separately** per harness. Supported as of README:

Antigravity · Claude Code · Codex App · Codex CLI · Cursor · Factory Droid · GitHub Copilot CLI · Kimi Code · OpenCode · Pi

**New-harness acceptance (required in the PR template):** a clean session, user message exactly `Let's make a react todo list`, must **auto-trigger `brainstorming` before any code**. Bootstrap at session start is the integration.

Architecture of a port (`docs/porting-to-a-new-harness.md`):

1. **Skills** — shared verbatim; name **actions**, not vendor tools.
2. **Tool mapping** — `references/<harness>-tools.md` when the harness uses that pattern.
3. **Bootstrap** — inject `using-wukong-code` (+ Product Design composition pointer when that skill exists).

---

## 6. Constraints (quality and collaboration)

Contributor-facing product rules. `AGENTS.md` states a **94% PR rejection rate** for this repository; that figure is the project's own warning, not an independent metric.

- PRs target **`main`**. Complete every PR template section. Disclose model, harness, harness version, plugins. A **human** must review the **complete** diff before submission.
- Search **open and closed** PRs before opening another.
- Skill changes: use `writing-skills`, adversarial pressure testing, **before/after eval** results. Do not retune Red Flags, rationalization lists, or “human partner” language without evidence.
- Issues: bug vs platform (try without Wukong Code); feature requests must justify **core** vs standalone plugin; new IDE requests go through `platform_support`.
- Terminology: **“your human partner”** is deliberate.

---

## 7. How success is judged

No growth or NPS targets are defined in-repo. Success is **behavioral and contribution quality**.

| Gate | What “good” means | Where it lives |
| --- | --- | --- |
| Bootstrap | Skills fire at the right time without a per-task ritual | SessionStart / injectors; new-harness transcript |
| Process | Design before code; RED before green; verify before “done” | Skill bodies + evals |
| Product Design | Research/audit do not edit source; new visuals need a chosen direction; Design QA blocks bad handoff | Product Design skills + import lock |
| Plugin correctness | Non-LLM packaging, hooks, mapping, manifests | `tests/`; `npm test` / `npm run test:extended`; CI `.github/workflows/test.yml` |
| Skill behavior | Real agent sessions comply with skills | `evals/` clone of wukong-code-evals; Drill / Cursor cohorts (manual / on-demand; needs API keys) |
| Eval definitions | Scenario JSONL stays valid | Weekly `evals-static.yml` (no API keys) |
| Language packs | Failing controls + repeated behavior evals; no extra frameworks | PR template “Language-pack evidence”; reports under `docs/wukong-code/evals/` |
| Contribution | Real problem, one change, human review, no slop | PR template; `AGENTS.md` |

Full LLM evals are **outside** the required PR test gate by design (`docs/evals-setup.md`). Publication and skill-wording claims still require them.

---

## 8. Provenance

| Source | Role |
| --- | --- |
| [Superpowers](https://github.com/obra/superpowers) (MIT, Jesse Vincent) | Core development skills, `using-*` bootstrap pattern, hooks/injectors, Codex packaging, contributor-guideline lineage |
| [OpenAI Product Design](https://github.com/openai/role-specific-plugins/tree/main/plugins/product-design) (MIT) | Ten Product Design skills and related assets; lockfile `product-design.lock.json` |
| [Anthropic frontend-design](https://github.com/anthropics/skills/tree/main/skills/frontend-design) (Apache-2.0) | Folded into `product-design-ideate` original-direction guidance; not a top-level skill |

Maintainer identity in README About: **悟空非空也 (Wukong)**.

---

## 9. Related documents

| Document | Use |
| --- | --- |
| `README.md` (and `README.zh-CN.md`, `README.zh-TW.md`, `README.ja.md`, `README.ko.md`) | Install, workflow, skill inventory |
| `AGENTS.md` / `CLAUDE.md` | Contributor / agent PR rules |
| `.github/PULL_REQUEST_TEMPLATE.md` | Mandatory PR fields, harness transcript, evals |
| `docs/porting-to-a-new-harness.md` | How a port must work |
| `docs/testing.md` | `tests/` vs `evals/` |
| `docs/evals-setup.md` | Cloning and tiering the eval harness |
| `RELEASE-NOTES.md` | Shipped vs Unreleased on `main` |
| `docs/wukong-code/specs/`, `docs/wukong-code/plans/` | Dated feature designs and implementation plans (history) |
