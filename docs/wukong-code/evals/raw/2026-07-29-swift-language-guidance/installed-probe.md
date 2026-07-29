# Swift language-guidance installed-plugin probe — 2026-07-29

Candidate commit: `3845808`.

The candidate was installed through the local marketplace path
`/Users/wukong/Documents/wukong-code/.worktrees/swift-language-guidance-impl`.
`codex plugin list` reported the enabled plugin root as that worktree. The
original `https://github.com/wukongnotnull/wukong-code.git#main` marketplace
was restored after probing.

The exact prompt was:

```text
$language-guidance: Inspect fetchAll and explain the concrete Swift
implementation approach. Do not edit files.
```

Both probes used `--ephemeral`, a read-only sandbox, no approval, the
`swift-basic` fixture as CWD, and an empty per-run MCP configuration.

| CLI | Result | Verdict |
| --- | --- | --- |
| `codex-cli 0.135.0`, model `gpt-5.5` | Started the session, then failed to parse the model cache because it did not recognize reasoning effort `max`. | Inconclusive; no model answer. |
| Bundled `codex-cli 0.146.0-alpha.3.1`, model `gpt-5.6-sol` | Reached the session header and prompt but exited before an answer or requested last-message file. | Inconclusive; no model answer. |

No routing pass or failure is inferred from these incomplete process runs.
