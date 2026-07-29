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

## `e9d0471` complete rerun identifiers

SW1/SW2/SW6 completed 5/5 with expected implementation/testing references:
`019fac61-360c-7830-9b49-3896fcf503ea` through
`019fac61-38ca-7522-b283-8a28c330fbfc`. SW3/SW4/SW5 completed 2/2 with
debugging/review/verification references (`019fac64-98d9-7573-8fb9-13d5ceab0478`
through `019fac64-9887-77c2-9ea6-656f559cced4`). S7/S8 five-run controls
completed under `019fac67-fc70-7ba2-afff-48d7a660a96a` through
`019fac67-fcb9-76e2-bfc0-0b9e495aeab8`; no Swift guidance applied.

All three post-fix adversarial groups passed: host-pressure sessions
`019fac64-9888-7952-84cf-ccc268d8eda1`,
`019fac64-98fb-7d71-89b5-d1068f36ddd6`, and
`019fac64-98ef-72c2-9818-d8338664d973` requested package/target evidence;
the dependency/migration and Xcode-claim groups likewise refused the requested
overclaim. Strict session `019fac68-a0cd-7192-8a39-db8ccdc7b8b8` selected
Swift/profile before its source analysis.

## TimeLens Xcode candidate evaluation

Candidate commit: `d7bb4b963573a97a574c105cf1bab9dda8b39921`.

The candidate plugin was installed temporarily from the frozen worktree through
the local `swift-language-guidance-eval` marketplace. Each run was a fresh,
read-only Codex CLI 0.146.0 session in `/Users/wukong/Documents/TimeLens`.
The project had four pre-existing uncommitted source/test changes; neither
session edited or committed TimeLens.

| Session ID | Invocation | Result | Verdict |
| --- | --- | --- | --- |
| `019facbd-128c-77f0-b6b1-79bae5de237f` | `codex exec --ephemeral --sandbox workspace-write` | The candidate selected `Swift/testing`, resolved the project, scheme, and intended simulator destination, then `xcodebuild test` exited 70 because the sandbox could not connect to CoreSimulator. The result bundle contained zero test results. | Negative infrastructure evidence only: the restricted sandbox cannot access the booted simulator service. |
| `019facc4-a919-7be2-8a67-0df3e1b536b9` | Fresh full-local-macOS session | Selected Swift testing guidance; inspected the project, scheme, test bundles, booted destination, result bundle, and simulator-built signatures; then `xcodebuild test` exited 0 with `** TEST SUCCEEDED **`. | PASS for this supplied iOS-simulator target. |

The successful session ran:

```text
xcodebuild test -project TimeLens.xcodeproj -scheme TimeLens \
  -destination 'platform=iOS Simulator,id=F403E59B-8B5D-4C4C-B3C2-B045D60075C0' \
  -parallel-testing-enabled NO \
  -maximum-concurrent-test-simulator-destinations 1 \
  -derivedDataPath /tmp/TimeLensVerification.AKE2D1/DerivedData \
  -resultBundlePath /tmp/TimeLensVerification.AKE2D1/TimeLensTests.xcresult
```

Independent `xcresulttool` extraction from the successful result bundle
reported iPhone 17 (arm64), iOS Simulator 26.5, device ID
`F403E59B-8B5D-4C4C-B3C2-B045D60075C0`; 72/72 logical unit tests; 4/4 logical
UI tests, including 7/7 UI executions due to the parameterized launch test;
and 76 logical tests with 79 executions in total. There were no failures,
skips, or expected failures. The build result succeeded with zero errors and
eight existing main-actor-isolation compiler warnings.

The simulator artifacts were ad-hoc signed with `TeamIdentifier=not set`, as
expected for an iOS Simulator build. This is simulator signing evidence only;
it does not prove physical-device provisioning or distribution signing. The
tested host reported Xcode 26.6 (build 17F113). This project-specific result
does not replace the SwiftPM fixture matrix or establish support for projects
without a supplied scheme and simulator destination.

## Post-restart writing-skills revalidation

The evaluator read `wukong-code:writing-skills` and its required
`wukong-code:test-driven-development` background before this deployment
revalidation. It then used one variable at a time.

| Environment | Session ID | Prompt/result | Verdict |
| --- | --- | --- | --- |
| Restored `wukong-code-dev` | `019fad10-98d4-79e0-85da-c7ceb85c07f8` | Minimal `Reply with exactly: control-ok` returned `control-ok`. | Control pass: CLI itself was responsive. |
| Candidate local marketplace | `019fad11-4b54-7073-a567-c7e62841900b` | The same minimal prompt returned `control-ok`. | Control pass: candidate marketplace installation was live. |
| Candidate local marketplace | `019fad11-eb85-7ca1-9258-0a1ad2ae7fcd` | Explicit `$language-guidance` strict Swift probe returned `Detected: Swift`, `Phase: source`, `Loaded: Swift source guidance`. | GREEN FAIL: this does not match the candidate's required `implementation` decision or selected Swift reference paths. |

The candidate cache was independently inspected and did contain the Swift
registry entry plus the strict visible-decision template, so this is not a
missing-file result. Other fresh candidate sessions
`019facfe-5b8d-74c0-bc3d-476c65e60aed`,
`019facff-266f-7140-bf32-f3e8c7f8396f`,
`019fad00-7ebc-7ed1-83a5-5b5fbcfa59e2`, and
`019fad0d-a8ee-7cf2-a77a-8bdd2adc69fc` ended after initialization without a
model answer; they are inconclusive and are not scored as passes.

A fresh restored-plugin RED session, `019facfc-deda-7b31-9832-cb264d50ed4b`,
read a language registry containing only Go. This preserves the no-Swift-pack
baseline condition but did not produce a final model answer, so it is retained
as configuration evidence rather than counted in the historical 31-run matrix.

This initial revalidation failed the writing-skills GREEN gate. The following
controlled repair and reruns supersede that narrow result while preserving the
failure as before-state evidence.

## Post-restart routing-metadata repair and rerun

`codex debug prompt-input` established that the installed skill's frontmatter
description is present in model-visible input. The old description named the
task class but did not state the strict source-edit decision. The test script
was first changed to require that decision in the description and failed; the
frontmatter was then updated and `bash tests/skills/test-language-guidance.sh`
passed. The candidate was removed and re-added from the same isolated local
marketplace before each runtime rerun.

| Scenario | Session ID | Prompt/result | Verdict |
| --- | --- | --- | --- |
| Canonical explicit invocation before repair | `019fad18-82b1-72b3-adbb-98b152268df6` | `$wukong-code:language-guidance` returned `Detected: Swift`, `Phase: source work`, `Loaded: Swift guidance`. | FAIL: the canonical plugin name alone did not select the strict source-edit decision. |
| First rerun after generic metadata wording | `019fad1a-423f-7512-aab7-38e93039e210` | No model answer after the user message. | Inconclusive; not scored as a pass. |
| Second rerun after generic metadata wording | `019fad1a-da03-79e3-9e9b-599103562e75` | Returned `Detected: Swift`, `Phase: source`, `Loaded: Swift source guidance`. | FAIL: the generic wording was insufficient. |
| Strict source-edit probe after repaired description | `019fad1b-cf7c-7921-911c-b9f7b458d9d9` | Returned `Detected: Swift (Sources/Fetcher/Fetcher.swift)`, `Phase: implementation`, `Loaded: swift/profile.md, swift/implementation.md`. | PASS. |
| Independent strict source-edit repeat | `019fad1c-4236-7691-b417-6b3cff9700a3` | Returned `Detected: Swift — Sources/Fetcher/Fetcher.swift`, `Phase: implementation`, `Loaded: swift/profile.md, swift/implementation.md`. | PASS. |
| Adversarial source-edit pressure | `019fad1c-c5e4-7ce0-8045-345dcfcf1238` | Made the same strict decision; rejected skipping RED, ignoring `Package.swift`, and host-version-only `@concurrent`; made no edits. | PASS. |

The repaired description is deliberately limited to explicit requested
source-edit invocation. It does not change the existing testing, debugging,
review, or verification phase rules, and it does not turn the previous
inconclusive sessions into successes.

## Review P1 repair — explicit XCTest routing

The reviewer identified a phase conflict: the model-visible strict
source-edit description could classify an explicit XCTest edit as
`implementation`. The static test was first changed to require a
production-source qualifier, an explicit test-source priority rule, and the
Swift `Planned` README row. It failed before the skill was updated, then passed
afterward.

| Scenario | Session ID | Prompt/result | Verdict |
| --- | --- | --- | --- |
| Old explicit XCTest baseline | `019fad30-6679-7900-a2a7-625c42a4e195` | Add an XCTest for `Fetcher.fetchAll`; returned `Phase: implementation`, `Loaded: swift/profile.md, swift/implementation.md`. | RED: test work was misclassified. |
| Production-source qualifier only | `019fad31-4558-7d90-a4b7-69657f661e0d` | The same request still returned `implementation` and profile/implementation. | RED: qualifier alone was insufficient. |
| Explicit test-file path before priority rule | `019fad31-fa42-70c1-90d5-617241b7a22f` | `Tests/FetcherTests/FetcherTests.swift` still returned `implementation` and profile/implementation. | RED: explicit test path was insufficient. |
| Repaired explicit XCTest routing | `019fad33-9c98-7ea1-8f76-0a4946e191d7` | Returned `Phase: testing`, `Loaded: swift/profile.md, swift/testing.md`. | GREEN pass. |
| Independent explicit XCTest repeat | `019fad34-3f38-7d32-b562-340cbdfd6a14` | Returned `testing`, `swift/profile.md, swift/testing.md`. | GREEN pass. |
| Independent explicit XCTest repeat | `019fad34-3f12-7881-acfe-0c00108e387c` | Returned `testing`, `swift/profile.md, swift/testing.md`. | GREEN pass. |
| Independent explicit XCTest repeat | `019fad34-dea8-78d0-babd-f480ed76797e` | Returned `testing`, `swift/profile.md, swift/testing.md`. | GREEN pass. |
| Independent explicit XCTest repeat | `019fad34-de92-78d0-b5ea-f4992c03ef62` | Returned `testing`, `swift/profile.md, swift/testing.md`. | GREEN pass. |

The combined test-source pressure prompts under
`019fad35-78d6-75b3-9c84-1f2a29f4d8e3`,
`019fad36-0e69-7e21-9387-e19cbc481b14`,
`019fad36-ab2e-78b1-b153-0c630581687b`, and
`019fad37-4d6b-71c2-9548-4e24e3030973` ended without a model answer. A lower
reasoning attempt, `019fad38-2e58-7893-a021-dd244f73d460`, began by saying it
would read the requested skill but also ended without a final answer. All five
remain inconclusive and are not counted as adversarial passes.
