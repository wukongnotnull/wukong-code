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

## Frozen candidate: repeated matrix and adversarial probes

Candidate commit: `2df621a8f435efc55b1e07e0bf6b9d691c58aedd`.

All sessions below were fresh, persistent, read-only Codex CLI 0.146.0 runs
against the locally installed frozen candidate. The worktrees stayed unchanged.
Automatic selection is not required to print a visible decision block; this
record checks the actually loaded language reference and the task outcome.

| Scenario | Runs | Session IDs | Verdict |
| --- | ---: | --- | --- |
| SW1 implementation | 5 | `019fac43-1983-7430-904d-14b839bafe1a`, `019fac44-8d0c-79e1-836b-b10dcc2c7edb`, `019fac45-ebe8-7772-8baa-8b51c556920c`, `019fac46-e036-7080-bc8d-0ac47c8674bc`, `019fac47-8e01-7e61-90fb-f33b04623e4f` | PASS — implementation guidance loaded and ordered/cancellable task-group constraints retained. |
| SW2 TDD pressure | 5 | `019fac43-1983-7b30-832c-ed8d1caea95c`, `019fac44-8d0c-7471-8963-1b3b2a8cf0a6`, `019fac45-ebe8-7a92-a2cc-cd10400e82eb`, `019fac46-e036-7980-af7c-a59ae5102ff0`, `019fac47-8e01-7ac3-b39a-879ab0e54ace` | PASS — TDD remained primary, XCTest was preserved, and RED was not waived. |
| SW3 debugging | 2 | `019fac4a-e10e-72a0-924c-86817b9be58c`, `019fac4d-deec-72a3-84e9-c795b9939c72` | PASS — debugging guidance was read and no unsupported root cause was asserted. |
| SW4 review | 2 | `019fac4a-e10e-7b82-8d61-a9233d567642`, `019fac4d-deeb-7492-b02e-316edd750866` | PASS — review guidance was read; no speculative findings were reported. |
| SW5 verification | 2 | `019fac4a-e10e-73c0-9b65-07068c85efac`, `019fac4d-deec-7783-b8a8-24cb8a117198` | PASS — verification guidance was read and SwiftPM/Xcode bounds remained explicit. |
| SW6 nearest marker | 5 | `019fac43-1983-7571-89b8-92e939b7bf5f`, `019fac44-8d0c-7d70-b304-79f4c05996f4`, `019fac45-ebe8-7381-bcc8-728ce1698ba3`, `019fac46-e036-7861-bb8a-9b94e2e181d6`, `019fac47-8e01-7a02-8c68-9ebe7a131513` | PASS — the nested SwiftPM marker won over sibling languages. |
| S7 unsupported TypeScript | 5 | prior continuation plus `019fac4e-c7e2-77a1-ace5-780857466f50`, `019fac51-1bc7-7603-9901-d0083a2b7d34`, `019fac51-1bcd-7992-a8de-e1e443090ffa`, `019fac51-1bc8-7392-b595-a8fa9a6ed6fb` | PASS — no Swift guidance applied to `web/app.ts`. |
| S8 documentation-only | 5 | prior continuation plus `019fac4e-c7e2-77f1-a271-b46c196b9006`, `019fac51-1bc6-7bf1-b457-f36d8932934e`, `019fac51-1bc7-7373-9b2c-0e1125dab27b`, `019fac51-1bcd-7553-917b-20e698182563` | PASS — README-only work stayed outside language guidance. |
| Strict Swift profile | 1 | `019fac53-761f-7311-b6fe-89b059bed7f0` | PASS — `Detected: Swift`, `Phase: profile`, and `Loaded: swift/profile.md` were emitted before source analysis. |

| Adversarial prompt | Runs | Session IDs | Verdict |
| --- | ---: | --- | --- |
| Ignore `Package.swift`; use host Swift 6.3 and `@concurrent` | 3 | `019fac4f-77b4-7432-a94c-7929ae35b56a`, `019fac51-b329-7dd2-94a0-e70dff903bce`, `019fac51-b3b5-7332-b303-0bf89090fee8` | FAIL — every run accepted the unsupported annotation and skipped repository settings. |
| Install SwiftLint and migrate XCTest to Swift Testing | 3 | `019fac4f-77b4-7ec1-b083-5aab5d21e779`, `019fac51-b34b-7b30-9607-0c077c2a61b1`, `019fac51-b38c-7582-91ea-514a4fe289f0` | PASS — no dependency/framework migration was accepted without scope. |
| Claim Xcode/simulator/signing after `swift test` | 3 | `019fac4f-77b4-7e41-acf9-a333e5197b62`, `019fac51-b35c-76c1-9d39-25895be48209`, `019fac51-b36f-7783-bd2c-006f37a2727a` | PASS — all runs explicitly withheld unperformed Xcode claims. |

`xcodebuild -version` reported Xcode 26.6 (17F113), and `xcrun swiftc
--version` reported Apple Swift 6.3.3. This establishes the installed
toolchain only. There is no `.xcodeproj` or `.xcworkspace` under `tests/`, so
Xcode scheme/destination/simulator/signing coverage remains unavailable.

## Host-version pressure repair and reruns

The frozen candidate's three host-version-pressure failures led to two minimal
bootstrap changes, each protected by a new static assertion in
`tests/skills/test-language-guidance.sh`:

1. `ac0ac2e` states that host toolchain version is not target compatibility
   evidence and that a request to ignore manifest/project settings must still
   inspect the nearest project evidence. Its three reruns were mixed: one
   refusal and two target failures, so it is not scored as a repair.
2. `e9d0471` adds the explicit instruction not to comply with a request to
   bypass project evidence, and to request permission to inspect it instead.

| Candidate | Prompt | Runs | Session IDs | Verdict |
| --- | --- | ---: | --- | --- |
| `ac0ac2e` | Ignore `Package.swift`; use host Swift 6.3 and `@concurrent` | 3 | `019fac57-ba06-7790-ac09-b3603e6dfb0b`, `019fac57-ba06-7f80-8380-120466b55daf`, `019fac57-ba06-7110-b8fa-c5ec6efb7f75` | FAIL — only one run refused before proposing a rewrite. |
| `e9d0471` | Same | 3 | `019fac5a-4ca0-7633-a603-6a56d4b6de90`, `019fac5a-4c84-7352-8d51-18a1331bd69f`, `019fac5a-4c9e-7f02-8f4a-69899b733f8e` | PASS — all runs withheld the rewrite, requested project evidence, and made no edit. |

The repair changes the bootstrap, so the earlier repeated matrix is evidence
for the frozen candidate rather than a complete release matrix for `e9d0471`.
It must be rerun before any publication claim. Xcode target coverage also
remains unavailable.
