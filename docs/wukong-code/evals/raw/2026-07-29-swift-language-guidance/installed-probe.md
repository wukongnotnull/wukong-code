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

## SW1 rerun after phase-routing fix

Candidate commit: `8f018c8`.

The common language router was changed so a requested production-source edit
uses the implementation phase even while brainstorming or explaining first
actions. Its static contract was red before this wording existed and green
afterwards. The candidate plugin was then installed from the frozen worktree
for the following persistent, read-only run; the original Git `dev`
marketplace was restored afterward.

| Scenario | Session ID | Result | Verdict |
| --- | --- | --- | --- |
| SW1 implementation after routing fix | `019fabfd-3bef-7062-a821-633f9ee9a20e` | Emitted `Detected: Swift` from `Package.swift` and target Swift files, `Phase: implementation`, and `Loaded: swift/profile.md, swift/implementation.md`; read both references, inspected the fixture, proposed a throwing task group with indexed ordering and cooperative cancellation, and made no edits. | PASS: required implementation guidance loaded before analysis. |

## Matrix continuation after routing fixes

Candidate commits: `055f895` (language-selected test reference) and `53e38fe`
(testing-pressure TDD priority). The first SW2 run after the second change used
the already-installed cache and therefore read the old bootstrap; it is not
scored. The candidate was removed and re-added from the local marketplace
before the scored sessions below. Every scored session used a fresh persistent
read-only CLI session, and no fixture files were changed.

| Scenario | Session ID | Result | Verdict |
| --- | --- | --- | --- |
| SW2 TDD pressure | `019fac18-9c66-7710-8e8d-14b3d34424a6` | Chose TDD over brainstorming, read `swift/testing.md`, said the existing XCTest cannot prove concurrency, and rejected the requested skip of RED. Its read-only attempt to add the test was denied. | PASS |
| SW3 debugging | `019fac1a-bfd6-7da1-95ab-dca3bfa58d31` | Emitted `Phase: debugging`, loaded `swift/debugging.md`, and distinguished task-group cancellation, continuations, actor/synchronization cycles, and unrelated slow work without inventing a cause. | PASS |
| SW4 review | `019fac1a-bfd6-7f80-84d0-8482151b8c22` | Emitted `Phase: review`, loaded `swift/review.md`, inspected the SwiftPM fixture, and reported no actionable defect. | PASS |
| SW5 verification | `019fac1a-bfd6-7293-82ff-a758594af8fa` | Emitted `Phase: verification`, loaded `swift/verification.md`, listed manifest, focused/full test, build, and diff checks, and did not call SwiftPM proof of Xcode coverage. | PASS |
| SW6 nearest marker | `019fac1c-cf6e-7cf3-a677-3785f595b6f2` | Selected Swift profile and implementation from `swift-tool/Package.swift`, not Go or TypeScript siblings, and requested a concrete change rather than inventing one. | PASS |
| S7 unsupported TypeScript | `019fac1c-cf6e-7681-8735-d683b873232e` | Identified `.ts` as unsupported and retained generic workflow with no Go or Swift reference. | PASS |
| S8 documentation-only | `019fac1c-cf78-7de2-abdc-f6e5dfa575c7` | Handled the README typo as documentation-only and did not announce or load language guidance. | PASS |

The archive test was run from a temporary ordinary clone at `53e38fe`, because
the packaging script rejects linked worktrees before packaging. It passed the
six Swift-reference archive assertions. The suite still failed only its known
timezone-sensitive timestamp assertions: ZIP expected `00:00` and observed
`08:00`; tar expected `Dec 31 1969` and observed `Jan 1 1970`.

This table is a single fresh pass per scenario. It does not replace repeated
GREEN/adversarial coverage or a Swift-aware human review.
