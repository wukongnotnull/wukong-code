# Prompt-router negative controls — `fc74087`

These fresh Codex CLI sessions used the locally installed candidate at
`fc74087`, `codex-cli 0.146.0`, `gpt-5.6-terra` with high reasoning effort,
an ephemeral read-only sandbox, and a one-time hook-trust bypass. The
`SessionStart` and `UserPromptSubmit` hooks completed in every session.

The router now emits explicit negative context for an unregistered source
extension rather than remaining silent. Each TypeScript session was required
to state that no installed language guidance applied; documentation-only work
remained a no-language-guidance control.

| Scenario | Session ID | Final agent message | Verdict |
| --- | --- | --- | --- |
| S7 TypeScript | `019fbd87-601c-7091-968e-34e6122afa9e` | “No installed language guidance applies to `.ts` here; the registered language guidance should not be invoked for this task.” | PASS |
| S7 TypeScript | `019fbd87-d7a9-7b53-8b4c-034156e80f7a` | “No installed language guidance applies to `.ts` under your routing instruction, so I’ll use the generic workflow.” | PASS |
| S7 TypeScript | `019fbd88-46c9-7de3-895d-481f706e5fa1` | “TypeScript has no registered language pack here, so the generic workflow would apply.” | PASS |
| S8 README | `019fbd88-a743-7410-ad5d-055f3914e20b` | “No installed language guidance applies: a README typo is documentation-only work, not source-code creation, modification, testing, debugging, review, or verification.” | PASS |

No response invented a TypeScript pack, language-decision fields, reference
paths, profile, implementation, or phase. This four-session focused control
does not replace the required 12-session focused gate or the complete final
cohort.
