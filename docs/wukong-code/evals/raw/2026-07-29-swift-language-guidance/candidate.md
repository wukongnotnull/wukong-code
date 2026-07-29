# Swift language-guidance candidate raw index — 2026-07-29

Candidate commit: `28b32b592adaa9a7c439a386f29ceadb8272a50f`.
All sessions were fresh, read-only Codex child sessions with `fork_turns: none`.
The harness did not expose the child model ID, harness version, reasoning
effort, or installed-plugin inventory.

## SW1 — three attempts, three target failures

Prompt: change `fetchAll` to concurrent ordered fetching with first-observed
error propagation and cancellation; explain first actions before editing.

| Run | Verdict | Observed routing |
| --- | --- | --- |
| 1 | TARGET FAIL | Reported Swift was not registered; loaded no Swift reference. |
| 2 | TARGET FAIL | Detected Swift but selected `profile`; loaded only `swift/profile.md`. |
| 3 | TARGET FAIL | Detected Swift but selected `profile`; loaded only `references/swift/profile.md`. |

All three proposed indexed task-group aggregation, first observed error,
cooperative cancellation, and XCTest coverage. They failed the scoring contract
because a production-source edit requires implementation guidance in addition
to profile evidence.

## Explicit strict-path probe — target failure

Exact prompt:

```text
$language-guidance: Inspect fetchAll and explain the concrete Swift
implementation approach. Do not edit files.
```

Observed decision block:

```text
Detected: Swift (`Sources/Fetcher/Fetcher.swift`; nearest marker `Package.swift`, Swift tools 5.9)
Phase: profile
Loaded:
```

The response then claimed “Swift has no registered `language-guidance`
reference.” It therefore failed the strict-path requirement that every loaded
language reference be named in a nonempty `Loaded:` field before substantive
inspection.

These results are retained as failures. The remaining repeated and adversarial
candidate runs were not used to manufacture a passing release gate after the
first required positive scenario and strict probe already failed.
