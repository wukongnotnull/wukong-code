# Product Design / Frontend Design RED Evidence — 2026-08-12

## Methodology

- Harness and version: Codex desktop; version not exposed by this runtime.
- Model and version/ID: not exposed by this runtime.
- Installed plugins: Product Design, Wukong Code, Codex Security, GitHub,
  Browser, Chrome, Computer Use, Sites, Remotion, and OpenAI bundled skills.
- Isolation: every sample used a fresh child context with `fork_turns: none`;
  no more than three children ran concurrently.
- Candidate state: Product Design skill files at commit `ae8dd8a`, before any
  Product Design composition edits. The routing scenario and deterministic
  test edits in this commit are the RED control, not candidate guidance.
- Frontend file SHA-256:
  `dcd7ce36c17f953ed2092b40085d4c7563872df7e46f33c2b20e385689ab35a2  skills/frontend-design/SKILL.md`
  and
  `809fa1ed21450f59827d1e9aec720bbc4b687434fa22283c6cb5dd82a47ab9c0  skills/frontend-design/LICENSE.txt`.
- Each child was told to inspect only the Product Design skill files required
  to route, and not to inspect tests, plans, specs, evaluation evidence, or
  Git history. It could not edit files, generate images, use a browser, or
  deploy.
- Scoring: every complete child response was manually read. Keyword counts
  were not used as behavioral evidence.

## Critical Verdict Contract

A sample fails if it includes `frontend-design` on an excluded route, omits it
on an eligible original-direction or substantial-redesign route, lets it
override user/source/design-system constraints, loads it before the governing
Wukong lifecycle gate permits secondary guidance, or replaces required visual
options with prose or ASCII output.

## Result Summary

| Samples | Route | Result |
| --- | --- | --- |
| 001–005 | PD9 original visual direction | 5/5 TARGET FAIL: all omitted `frontend-design` |
| 006–010 | PD4 faithful URL clone | 5/5 TARGET PASS: all excluded `frontend-design` |
| 011 | PD2 screenshot audit | TARGET PASS: direct audit, no `frontend-design` |
| 012 | PD3 research and new direction | TARGET FAIL: ideation path omitted `frontend-design` |
| 013 | PD5 selected-image implementation | TARGET PASS: selected visual remained authoritative |
| 014 | PD10 substantial URL redesign | TARGET FAIL: redesign path omitted `frontend-design` |
| 015 | PD11 research-only | TARGET PASS: read-only research excluded `frontend-design` |

Recurring failure shape: eligible original design and substantial redesign
routes have no explicit composition predicate, so every sampled agent routed
to Product Design ideation without loading `frontend-design`. The matching
fidelity controls did not show any unsolicited aesthetic-direction behavior.

## Complete Samples

### sample_001

- Natural prompt: `Use Product Design to create three original visual directions for a new independent-bookstore landing page. There is no existing visual target.`
- Critical verdict: TARGET FAIL
- Observed reason: selected brainstorming and Product Design ideation but omitted `frontend-design`.
- Rationalization or interpretation: none
- Complete response:

> Primary process: `wukong-code:brainstorming` at Full depth, since the landing page’s user outcome and brand constraints are unspecified.
>
> Skill sequence: `brainstorming` → `product-design` router → `product-design-user-context` preflight → `product-design-context` → `product-design-ideate`.
>
> The context gate should ask one question, then play back the brief. After the brainstorming design gate is cleared, ideation generates exactly three independent, scrollable 1440px-wide landing-page visuals and waits for a selection. No build begins.
>
> First user-facing action: “Using brainstorming to shape the three visual directions. What should this bookstore landing page’s primary action be: visiting the shop, shopping online, joining events/book clubs, or something else?”

### sample_002

- Natural prompt: same as sample_001.
- Critical verdict: TARGET FAIL
- Observed reason: selected Product Design context and ideation but omitted `frontend-design`.
- Rationalization or interpretation: none
- Complete response:

> Primary process: `wukong-code:brainstorming` at Full depth, since the visitor outcome and success criteria are unspecified.
>
> Skill sequence: `product-design` router → `wukong-code:brainstorming` → `product-design-user-context` → `product-design-context` → `product-design-ideate`.
>
> First user-facing action: “What should this bookstore landing page help a first-time visitor do most: plan an in-person visit, buy books online, or discover the store’s events and community?”

### sample_003

- Natural prompt: same as sample_001.
- Critical verdict: TARGET FAIL
- Observed reason: selected brainstorming and ideation but omitted `frontend-design`.
- Rationalization or interpretation: none
- Complete response:

> Primary process: `brainstorming` at Full depth, since the request leaves the landing page’s audience, conversion goal, brand voice, and constraints unspecified.
>
> Skill sequence: `brainstorming` → `product-design-user-context` preflight → `product-design-context` → `product-design-ideate` → wait for the user to select one of the three generated directions. `product-design-image-to-code` would apply only if they then ask to build the selected direction.
>
> First user-facing action: “What should this bookstore landing page help a visitor do first—discover curated books, visit the shop, join events, or buy online?”

### sample_004

- Natural prompt: same as sample_001.
- Critical verdict: TARGET FAIL
- Observed reason: selected Product Design context and ideation but omitted `frontend-design`.
- Rationalization or interpretation: none
- Complete response:

> Primary process: `wukong-code:brainstorming` at Full depth (new visual directions with an unspecified conversion goal).
>
> Skill sequence: `wukong-code:brainstorming` → `product-design-user-context` → `product-design-context` → `product-design:ideate` → wait for the user’s visual selection.
>
> First user-facing action: “What should this bookstore landing page help visitors do first: plan an in-store visit, browse/buy books online, discover events, or join the newsletter?”

### sample_005

- Natural prompt: same as sample_001.
- Critical verdict: TARGET FAIL
- Observed reason: selected brainstorming and Product Design ideation but omitted `frontend-design`.
- Rationalization or interpretation: none
- Complete response:

> Primary process: `wukong-code:brainstorming` at Full depth, because the landing page’s intended user outcome is still unspecified.
>
> Skill sequence: `wukong-code:brainstorming` → `product-design` → `product-design-user-context` → `product-design-context` → `product-design-ideate`.
>
> First user-facing action: “What should the independent-bookstore landing page help a visitor do first: plan an in-store visit, buy books online, or discover events and community?”

### sample_006

- Natural prompt: `Clone https://example.com/account as a runnable local frontend. Match it faithfully.`
- Critical verdict: TARGET PASS
- Observed reason: faithful clone used the capture/build/QA path and excluded `frontend-design`.
- Rationalization or interpretation: none
- Complete response:

> Primary process: `wukong-code:brainstorming` at Condensed depth.
>
> Skill sequence: `product-design` → `brainstorming` → `product-design-user-context` → `product-design-context` → `product-design-url-to-code` → `product-design-design-qa`.
>
> First user-facing action: “Before I proceed, please confirm you own this site or have permission to recreate it, and that cloning it complies with its terms.”

### sample_007

- Natural prompt: same as sample_006.
- Critical verdict: TARGET PASS
- Observed reason: faithful clone used `product-design-url-to-code` and excluded `frontend-design`.
- Rationalization or interpretation: none
- Complete response:

> Primary process: `wukong-code:brainstorming` (Full depth by default).
>
> Skill sequence: `wukong-code:brainstorming` → `product-design` → `product-design-url-to-code` → `product-design-user-context` → `product-design-design-qa`.
>
> First user-facing action: “Before I proceed, please confirm you own https://example.com/account or have permission to recreate it, and that you’ll follow its terms of use. I’ll use it only to build a local frontend clone.”

### sample_008

- Natural prompt: same as sample_006.
- Critical verdict: TARGET PASS
- Observed reason: faithful clone kept URL-to-code and selected-source fidelity; it did not mention `frontend-design`.
- Rationalization or interpretation: none
- Complete response:

> Primary process: `wukong-code:brainstorming` at Condensed depth.
>
> Skill sequence: `product-design` → `brainstorming` → `writing-plans` → `product-design-url-to-code` → `product-design-user-context` → `test-driven-development` → `product-design-design-qa` → `verification-before-completion`.
>
> First user-facing action: “Before I capture or recreate https://example.com/account, please confirm that you own the site or have permission to reproduce it, and that doing so complies with its terms.”

### sample_009

- Natural prompt: same as sample_006.
- Critical verdict: TARGET PASS
- Observed reason: faithful clone selected Product Design URL-to-code and excluded `frontend-design`.
- Rationalization or interpretation: none
- Complete response:

> Primary process: `wukong-code:brainstorming` (Condensed).
>
> Skill sequence: `product-design` → `brainstorming` → host-capability preflight → `product-design-url-to-code` → `product-design-user-context` → `product-design-design-qa`.
>
> First user-facing action: “Before I begin, please confirm that you own https://example.com/account or have permission to recreate it, and that you’ll follow its terms.”

### sample_010

- Natural prompt: same as sample_006.
- Critical verdict: TARGET PASS
- Observed reason: faithful clone selected the source-capture/QA path and excluded `frontend-design`.
- Rationalization or interpretation: none
- Complete response:

> Primary process: `wukong-code:brainstorming` with Product Design’s URL-cloning workflow.
>
> Skill sequence: `brainstorming` → `product-design` → `product-design-user-context` → `product-design-context` → `product-design-url-to-code` → `product-design-design-qa`.
>
> First user-facing action: “Before I proceed, please confirm you own this site or have permission to recreate it, and that cloning it complies with its terms.”

### sample_011

- Natural prompt: `Audit this attached checkout-flow screenshot for UX, design, and accessibility problems. Do not change code.`
- Critical verdict: TARGET PASS
- Observed reason: direct evidence-based audit excluded `frontend-design` and source-change workflow.
- Rationalization or interpretation: none
- Complete response:

> Primary process: Direct audit/critique — no Wukong implementation process skill is needed because no source change is requested.
>
> Skill sequence: `$product-design` → `$product-design-audit`.
>
> First user-facing action: “I’ll audit the attached checkout screen as a single-step flow, using this screenshot as the source of truth. I’ll inspect it for UX, visual-design, and screenshot-visible accessibility risks, and call out what would still need interaction or assistive-technology testing.”

### sample_012

- Natural prompt: `Research current onboarding pain for this product, then generate three new visual directions for a redesigned onboarding flow.`
- Critical verdict: TARGET FAIL
- Observed reason: new visual-direction ideation omitted `frontend-design`.
- Rationalization or interpretation: none
- Complete response:

> Primary process: `wukong-code:brainstorming` at Full depth, because the product is unspecified and the requested redesign directions are creative, behavior-shaping work.
>
> Skill sequence: `brainstorming` → `product-design:user-context` → `product-design:research` → `product-design:context` → `product-design:ideate`.
>
> First user-facing action: “Which product should I research and redesign the onboarding for?”

### sample_013

- Natural prompt: `Implement the selected option 2 image in this existing React app and verify the result.`
- Critical verdict: TARGET PASS
- Observed reason: selected visual remained authoritative; no original visual-design guidance was reloaded.
- Rationalization or interpretation: none
- Complete response:

> Primary process: `wukong-code:test-driven-development`.
>
> Skill sequence: `test-driven-development` → `language-guidance` → `product-design` → `product-design-context` → `product-design-image-to-code` → `product-design-design-qa` → `verification-before-completion`.
>
> First user-facing action: “I’ll recreate the selected Option 2 visual faithfully in the existing React app, preserving its layout, assets, and primary interactions. I’ll first resolve that exact image reference and verify the finished screen against it at the same viewport.”

### sample_014

- Natural prompt: `Use Product Design to redesign https://example.com/account into a new premium direction. Treat the current page as context, not a visual target to clone.`
- Critical verdict: TARGET FAIL
- Observed reason: substantial redesign selected Product Design ideation but omitted `frontend-design`.
- Rationalization or interpretation: none
- Complete response:

> Primary process: full `brainstorming`. “Premium direction” leaves product outcome and visual strategy open, so it requires a design gate before implementation.
>
> Skill sequence: `using-wukong-code` → `brainstorming` → `product-design` → `product-design-user-context` → `product-design-context` → capture URL → `product-design-ideate` → wait for selection.
>
> First user-facing action: “What is the one account task this redesign should make feel most premium and effortless—for example, managing billing, security, profile details, or subscription status?”

### sample_015

- Natural prompt: `Use Product Design to research current onboarding pain for this product. Report findings only; do not redesign or implement anything.`
- Critical verdict: TARGET PASS
- Observed reason: read-only research excluded `frontend-design`.
- Rationalization or interpretation: none
- Complete response:

> Primary process: direct, read-only Product Design research—no development workflow.
>
> Skill sequence: `$product-design` → `$product-design-research` → `$product-design-user-context` preflight → current public-source scan → findings brief.
>
> First user-facing action: “Scope: I’ll research current onboarding pain for Wukong Code among new users—setup, first-session activation, and learning core workflows—using current public evidence. I’ll separate observed evidence from inference and report findings only.”
