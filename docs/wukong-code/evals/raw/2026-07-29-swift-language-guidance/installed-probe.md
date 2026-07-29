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

## Persistent CLI rerun after standalone update

After the user updated the standalone CLI to `0.146.0`, the candidate was
installed again through the same local marketplace. These runs used persistent
read-only sessions with an empty per-run MCP configuration; raw JSONL remains
in the local Codex session store under the listed session IDs. The original Git
marketplace was restored afterward.

| Scenario | Session ID | Result | Verdict |
| --- | --- | --- | --- |
| Explicit strict path | `019fabee-9d66-7fc2-9920-29d52784ce26` | Emitted `Detected: Swift`, `Phase: profile`, and `Loaded: swift/profile.md`; read the profile and gave a source-grounded sequential `fetchAll` analysis. | PASS |
| SW1 implementation | `019fabf0-ab88-7fe1-8537-c35a23944ecb` | Detected Swift from `Fetcher.swift` and `Package.swift`, but emitted only `Phase: profile` and `Loaded: swift/profile.md`; then proposed task groups, indexed ordering, first-observed errors, and cooperative cancellation. | TARGET FAIL: implementation guidance not loaded. |

The strict-path run was read-only, so a sandbox denial prevented `swift --version`
from creating its Xcode cache; the agent correctly reported that it could not
verify the installed compiler from that session. The SW1 run likewise performed
no edits or tests.
