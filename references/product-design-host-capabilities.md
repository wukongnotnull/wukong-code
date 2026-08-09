# Product Design Host Capabilities

Route Product Design by available capabilities, not by host name alone. Run a
lightweight tool preflight for the current session and select the first usable
path below.

## Host map

| Host | Preferred path | Required fallback behavior |
| --- | --- | --- |
| Codex Desktop | In-app Browser, local terminal preview, ImageGen, and an available hosting skill | Use Chrome only for an existing login/profile or when the in-app Browser is blocked. |
| ChatGPT Work Mode | Cloud browser, ImageGen, and Sites when exposed | Continue locally without hosting when Sites is absent; never claim an unavailable preview or deployment. |
| Claude Code | Available browser/terminal integrations | Use the sequential fallback when subagents are unavailable. |
| Cursor | Available browser/terminal integrations | Use the sequential fallback and return the local preview path supported by the host. |
| Kimi | Available browser/terminal integrations | Skip unavailable image generation or hosting branches without disabling unrelated Product Design work. |
| OpenCode | Available browser/terminal integrations | Use the portable state directory and sequential fallback. |
| Pi | Available browser/terminal integrations | Use the portable state directory and sequential fallback. |
| Gemini | Available browser/terminal integrations | Use the portable state directory and sequential fallback. |

The table describes preferred adapters, not guaranteed tools. Current tool
availability is authoritative.

## Capability decisions

1. **Source capture:** URL cloning and screenshot-based audits require a browser
   that can capture the source. If none is available, stop that focused workflow
   and ask for screenshots or a supported browser; do not block unrelated
   research, context, or image-to-code work.
2. **Visual target:** visual ideation requires ImageGen or another explicitly
   available image generator. If generation is unavailable, use a user-provided
   screenshot/Figma frame/mockup as the target or explain that visual option
   generation is unavailable.
3. **Build and preview:** implementation requires local file and command access.
   When a browser preview is unavailable, build/test may continue, but report
   visual comparison as unverified.
4. **Sharing:** deployment runs only through a hosting capability explicitly
   available in the current session. Missing hosting never blocks a verified
   local handoff.
5. **Parallel work:** subagents are an optimization, not a requirement. When
   they are unavailable or unauthorized, use the sequential fallback: perform
   the same capture, build, screenshot, compare, and fix stages in order in the
   current agent.
6. **Saved context:** resolve state through `product-design-user-context`.
   Codex keeps its existing `$CODEX_HOME/state/plugins/product-design` layout;
   other hosts use `PRODUCT_DESIGN_STATE_DIR`, XDG state, or the documented
   portable home fallback.

## Claims

Only claim capabilities actually exercised in the current host. Do not call a
prototype visually verified without a rendered comparison, hosted without a
returned deployment result, or saved for future sessions without a successful
writable-state preflight.
