# Codex UserPromptSubmit router pilot — `14c7aaf`

These are the final agent messages from fresh, ephemeral, read-only Codex CLI
sessions using the locally inspected candidate, `gpt-5.6-terra` at low
reasoning effort, and the one-time hook-trust bypass. The CLI reported that
enabled hooks were permitted via the one-time bypass in every session. The
captured Codex JSONL output did not echo injected developer context, so
reference delivery is established by the deterministic hook test and the
session observations below.

This is a six-session delivery pilot, not the complete focused gate described
in the implementation plan. It must not be used to change the Rust pack's
publication status.

| Scenario | Session ID | Final agent message | Observation |
| --- | --- | --- | --- |
| R1 Rust implementation | `019fbd50-caaa-7f61-b5eb-70082fe95a7e` | “I’m using `wukong-code:brainstorming` to shape the concurrency contract before proposing changes, and the Rust guidance already supplied for implementation constraints.” | Hooked session identified supplied Rust implementation guidance before inspecting the fixture. |
| R4 Rust review | `019fbd51-88af-73d3-bb1b-9a04455ba0ae` | “I can’t review `src/lib.rs` without its contents, and you asked me not to run commands. Paste the file and I’ll report only concrete correctness bugs.” | The read-only request did not invent a finding or another language/phase. |
| Go review | `019fbd51-fc06-71c2-a5bc-2cffa1139544` | “I can’t review `main.go` without its contents. Please paste the file, and I’ll report only concrete correctness defects.” | The read-only request did not invent a finding or another language/phase. |
| Swift verification | `019fbd52-8238-7a53-95fa-fe02c99196f1` | It required `swift package dump-package`, `swift test`, and `swift build`, plus configured formatter/linter only when present, and reported required evidence scope. | Matches the delivered Swift verification content; no tool was installed. |
| S7 TypeScript negative control | `019fbd53-0df4-7863-9d0a-522faf2aa0e8` | “I can’t modify `web/app.ts`: no specific change was requested, and this workspace is read-only. The applicable installed guidance is `wukong-code:language-guidance`, which should identify the project’s language from repository evidence before source edits.” | No TypeScript reference path or unsupported phase was invented. |
| S8 documentation-only negative control | `019fbd53-7040-7260-b586-8745749a5b00` | “Which typo should I fix? Please provide the incorrect and desired text; I won’t run commands or change source code.” | No language reference or source scope was invented. |

After the pilot, the local candidate marketplace was removed and the normal
remote `wukong-code` `dev` marketplace was reinstalled and enabled.
