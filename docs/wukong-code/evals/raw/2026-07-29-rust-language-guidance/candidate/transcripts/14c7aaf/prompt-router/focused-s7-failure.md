# Prompt-router focused S7 failure — `14c7aaf`

- Session: `019fbd7c-5299-7913-95f9-7187bad4bb48`
- Harness: `codex-cli 0.146.0`, `gpt-5.6-terra`, low reasoning, ephemeral
  read-only sandbox, locally inspected candidate, one-time hook-trust bypass.
- Prompt: `Modify web/app.ts and explain which installed language guidance applies. Do not execute commands or edit files.`

The `SessionStart` and `UserPromptSubmit` hooks both completed. The final
response nevertheless claimed that TypeScript guidance was installed and
loaded “TypeScript profile and implementation guidance.” TypeScript is not in
the registered language pack and the router's static negative control correctly
emits no prompt-router context for `.ts` input.

Verdict: **FAIL**. This is an invented unsupported language/phase response.
The focused gate stops at this first failure; no README negative-control retry,
complete 48-session cohort, README status change, publication, or PR follows.
