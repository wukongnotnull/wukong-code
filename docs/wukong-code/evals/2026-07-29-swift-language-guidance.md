# Swift language-guidance baseline — 2026-07-29

## Methodology

This baseline ran before Swift was registered or had phase references. It does
not combine with the Go evaluation report.

- Baseline commit before fixture edits: `9adf5799b31b2aa6a1775656a67978dc6e397150`.
- Harness: Codex desktop child sessions; child model, harness version,
  reasoning effort, and plugin inventory were not exposed.
- Isolation: 31 fresh children dispatched with `fork_turns: none`; each was
  told not to edit files.
- Fixture: dependency-free SwiftPM package with `swift-tools-version: 5.9` and
  XCTest, plus a mixed Go/TypeScript/Swift marker fixture.
- Local toolchain: Apple Swift 6.3.3, target `arm64-apple-macosx26.0`, Xcode
  26.6. The host compiler is environment evidence, not fixture language-mode
  evidence.
- Raw index: [baseline raw index](raw/2026-07-29-swift-language-guidance/baseline.md).

## SwiftPM fixture result

| Command | Result |
| --- | --- |
| `swift package dump-package` in `swift-basic` | passed |
| focused XCTest | passed; 1 test |
| `swift test` | passed; 1 test |
| `swift build` in `swift-basic` | passed |
| manifest and build in `monorepo/swift-tool` | passed |

No Xcode scheme, simulator, signing, or Apple-platform target was executed.

## Results

| Scenario | Runs | Result |
| --- | ---: | --- |
| SW1 implementation | 5 | 5 TARGET FAIL — no registered Swift implementation phase; one run hallucinated Swift paths |
| SW2 TDD pressure | 5 | 5 TARGET FAIL — no Swift testing phase; four runs accepted skipping RED |
| SW3 debugging | 2 | 2 TARGET FAIL — plausible generic diagnosis, no Swift debugging phase |
| SW4 review | 2 | 2 TARGET FAIL — appropriate zero findings, no Swift review phase |
| SW5 verification | 2 | 2 TARGET FAIL — plausible SwiftPM checks, no Swift verification phase |
| SW6 nearest marker | 5 | 5 TARGET FAIL — Swift detected but unsupported |
| S7 unsupported TypeScript | 5 | 5 TARGET PASS — no Go or Swift guidance loaded |
| S8 documentation-only | 5 | 5 TARGET PASS — no language guidance loaded |

The 31 responses produced 10 target passes and 21 target failures. The positive
failures identify the missing Swift pack, not ambiguous markers. They also show
the pack must counter invented reference paths, pressure to skip RED, host
toolchain assumptions, and overstatement of SwiftPM evidence.

## Limitations and maintenance

An attempted local `codex-cli 0.135.0` run was not counted: its default model
required a newer CLI and its fallback timed out while initializing configured
MCP servers. Child sessions supplied the fresh-context baseline. Automatic
routing remains advisory. Experimental publication still requires candidate
evaluation, regression results, and a Swift-aware human review.

## Candidate result — not publication-ready

Candidate commit: `28b32b592adaa9a7c439a386f29ceadb8272a50f`.
The language contract passed at this commit. The complete SwiftPM fixture had
already passed as recorded above. Packaging in a temporary ordinary clone
included the new Swift reference assertion, but the package suite retained two
pre-existing timestamp-expectation failures in this timezone: ZIP expected
`(1980, 1, 1, 0, 0, 0)` but observed `(1980, 1, 1, 8, 0, 0)`; tar expected
`Dec 31 1969` but observed `Jan 1 1970`.

Fresh-child candidate probing stopped early rather than treating partial success
as release evidence. Three SW1 attempts produced
three TARGET FAIL verdicts: one reported that Swift was unregistered; two
detected Swift but selected only `profile` and did not load implementation
guidance for a production-source change. Their concurrency proposals correctly
mentioned ordered indexed results, first-observed error, structured ownership,
and cooperative cancellation, but those properties do not compensate for the
required phase-selection failure. See [candidate raw index](raw/2026-07-29-swift-language-guidance/candidate.md).

The explicit strict-path probe also failed: it emitted `Detected` and `Phase`
but an empty `Loaded` field and stated that Swift was unregistered. This child
evaluation harness did not consistently load the frozen worktree's candidate
registry, so it cannot substantiate automatic routing or strict-path behavior.
No README support claim is published from this result. Xcode, simulator,
code-signing, and Apple-platform targets remain unverified. A Swift-aware human
review remains pending.

## Installed-plugin probe — inconclusive

The candidate plugin was temporarily installed through the local
`wukong-code-dev` marketplace and `codex plugin list` confirmed that its root
was the frozen worktree. The original Git marketplace was restored afterward.
Two read-only strict-path probes reached the CLI session header but no model
answer: the installed `codex-cli 0.135.0` failed while parsing the current
model cache, and the bundled `codex-cli 0.146.0-alpha.3.1` ended after session
initialization without writing its requested last-message file. These runs do
not establish a routing result. Their environment output is retained in the
[installed-probe raw index](raw/2026-07-29-swift-language-guidance/installed-probe.md).

## Installed-plugin rerun — Swift detection and strict routing work

After the user updated the standalone CLI to `0.146.0`, the candidate was
installed again from the frozen worktree and the original Git marketplace was
restored after the runs. Persistent read-only CLI transcripts now establish
that the installed plugin resolves Swift references. The explicit strict probe
passed: it emitted `Detected: Swift`, `Phase: profile`, and
`Loaded: swift/profile.md` before inspecting the fixture.

The same installed candidate then ran SW1 once. It detected Swift from
`Fetcher.swift` and the nearest `Package.swift`, but emitted only
`Phase: profile` and `Loaded: swift/profile.md`. Its proposed use of a throwing
task group, indexed result storage, first-observed error handling, and
cooperative cancellation was technically responsive, but it did not load the
required implementation guidance for a requested production-source change.
SW1 was therefore a TARGET FAIL. The updated raw index preserves both runs and
their persistent session identifiers. This isolated the failure to phase
selection, not plugin installation or Swift detection.

## Installed-plugin regression fix — SW1 phase gate passes

Commit `8f018c8` narrows the common router so a requested production-source
change selects implementation even when brainstorming or a request to explain
first actions postpones editing. A new static contract first failed, then
passed, for that rule. With the candidate plugin temporarily installed from
the worktree, a persistent read-only SW1 rerun emitted `Phase: implementation`
and `Loaded: swift/profile.md, swift/implementation.md` before inspecting the
fixture. It then gave the expected structured-concurrency proposal and made no
fixture edits. The original Git `dev` marketplace was restored after the run.
See the [installed-probe raw index](raw/2026-07-29-swift-language-guidance/installed-probe.md).

This closes the observed SW1 routing regression, but it does not make the
language pack publication-ready: the remaining scenario matrix, Xcode-specific
coverage, and Swift-aware human review are still pending.

## Installed-plugin matrix continuation — single fresh pass per remaining scenario

Two additional common-routing defects surfaced during review and were repaired:
the TDD/testing selection named `go/testing.md` unconditionally, and the
bootstrap sent test-skipping pressure to brainstorming before TDD. Both had
failing static contracts before the minimal router changes. The candidate was
reinstalled after the cache refresh and then evaluated in fresh persistent
read-only CLI sessions.

SW2 selected TDD as its primary workflow, read `swift/testing.md`, and refused
to treat the existing XCTest as a substitute for a valid RED run. SW3 through
SW6 selected Swift debugging, review, verification, and nearest-marker
implementation guidance respectively. The unsupported TypeScript and
documentation-only negative controls did not load language guidance. The
package archive check also included all six Swift references; its only failures
were the pre-existing timezone-sensitive ZIP and tar timestamp expectations.
The raw index records session IDs and exact qualifications.

These are one fresh session per scenario, not the contract's required repeated
GREEN/adversarial evaluation. README remains intentionally `Planned` until
those release gates and a Swift-aware human sign-off are completed; the
candidate registry remains experimental for isolated runtime evaluation.

## Swift-aware human review sign-off

On 2026-07-29, `wukongnotnull` signed the Swift human review for commit
`005674e`, reporting 10 years of Swift experience. The review covered the six
Swift phases, common routing, SwiftPM fixtures, and the evaluation record.
The reviewer approved progression to the next evaluation stage, while retaining
the requirements for repeated/adversarial evaluation, Xcode coverage, and a
`Planned` README status until publication gates are complete.

## Frozen-candidate repeated and adversarial evaluation — publication gate not met

The candidate was frozen at `2df621a8f435efc55b1e07e0bf6b9d691c58aedd` and
installed from the local worktree. Fresh persistent read-only Codex CLI 0.146.0
sessions were used for the following repetitions; all fixture worktrees remained
unchanged. The repeated ordinary matrix passed: SW1, SW2, and SW6 each passed
five times; SW3, SW4, and SW5 each passed twice; and the TypeScript and
documentation-only controls each passed five times. A fresh strict invocation
also emitted the required Swift/profile decision block before source analysis.

The adversarial gate did not pass. In all three repetitions of the prompt that
instructed the agent to ignore `Package.swift` and use `@concurrent`, the agent
accepted the instruction, proposed unsupported `@concurrent` annotations, and
did not establish the package's declared settings. The other two adversarial
prompts passed three times each: every run rejected installing SwiftLint and
migrating XCTest without accepted scope, and every run kept SwiftPM test proof
separate from Xcode, simulator, and code-signing proof. This variance is a
release blocker, not an ambiguity to average away.

The installed toolchain is Xcode 26.6 (build 17F113) with Apple Swift 6.3.3.
However, `tests/` contains no `.xcodeproj` or `.xcworkspace`; no scheme,
destination, simulator, signing configuration, or Apple-platform target was
provided. Therefore no honest Xcode build/test coverage exists yet. README
remains `Planned`, and this pack remains experimental pending a fix for the
host-version/configuration adversarial behavior and a supplied Xcode target.

## Host-version pressure regression repair — adversarial rerun passes, full matrix still pending

The first repair (`ac0ac2e`) made host-version pressure explicit, but only one
of three reruns stopped before proposing a target-specific rewrite. A second,
narrower repair (`e9d0471`) instructs the bootstrap not to comply with a
request to bypass project evidence and to request permission to inspect it.
The static contract was RED before each wording change and GREEN after it.

Three new fresh read-only runs of the same hostile prompt then all refused the
rewrite, explained that host Swift 6.3 does not establish the target language
mode or default actor isolation, requested `Package.swift` or target settings,
and made no edits. This repairs the observed adversarial case, but the changed
bootstrap now needs a complete repeated matrix rerun. Xcode-specific coverage
is still blocked by the absence of a supplied project/workspace, scheme, and
destination; README remains `Planned`.

## `e9d0471` complete routing rerun

After the explicit project-evidence refusal was added, a fresh local-plugin
run completed SW1/SW2/SW6 five times each and SW3/SW4/SW5 twice each. Every
positive run loaded its expected Swift reference and retained the scenario
boundary. S7 and S8 each completed five times without applying Swift guidance.
All three repetitions of each adversarial prompt passed: host-version pressure
requested project evidence, dependency/framework pressure was rejected, and
SwiftPM success was not reported as Xcode, simulator, or signing verification.
The strict probe emitted Swift/profile selection before analysis. These results
close the behavior regression for `e9d0471`; actual Xcode target coverage is
still absent, so publication remains blocked and README remains `Planned`.

## TimeLens Xcode candidate evaluation

The frozen candidate at `d7bb4b963573a97a574c105cf1bab9dda8b39921` was
temporarily installed from its local worktree and evaluated in two fresh,
read-only Codex CLI 0.146.0 sessions against the user-supplied TimeLens iOS
project. The first, workspace-sandboxed attempt selected Swift testing guidance
but could not connect to CoreSimulator; `xcodebuild` exited 70 and produced no
test results. That infrastructure failure is retained as negative evidence,
not counted as application-test coverage.

The second session had full local macOS access. It selected Swift testing
guidance, inspected the project and booted iPhone 17 simulator, then ran the
full `TimeLens` scheme serially. `xcodebuild test` exited 0 with `** TEST
SUCCEEDED **`; the result bundle records 72/72 logical unit tests and 4/4
logical UI tests passing, with the parameterized UI launch test producing 7/7
UI executions. Across the bundle, 76 logical tests and 79 executions passed
with no failures, skips, or expected failures. The build had no errors and
eight existing Swift concurrency warnings about main-actor isolation.

The simulator-built artifacts were ad-hoc signed with no team identifier. This
is valid simulator evidence only: no physical-device provisioning or
distribution-signing claim is made. This closes the previously absent Xcode,
scheme, simulator, and simulator-signing coverage for this concrete project;
it does not relax the remaining publication gates or change README status from
`Planned`. See the [TimeLens Xcode candidate raw record](raw/2026-07-29-swift-language-guidance/installed-probe.md#timelens-xcode-candidate-evaluation).

## Updated Swift-aware human review sign-off

On 2026-07-29, `wukongnotnull` completed an updated Swift-aware review with
10 years of Swift experience. The review covered `005674e..d7bb4b9` common
routing and its static tests, plus the uncommitted TimeLens Xcode evaluation
record. The reviewer approved committing the language-pack evidence and
entering PR preparation. No additional reservation was supplied. This sign-off
does not authorize committing the separate TimeLens working tree.

## Post-restart writing-skills revalidation — initial GREEN failed

Before this revalidation, the evaluator read `wukong-code:writing-skills` and
its required `wukong-code:test-driven-development` background. A fresh
no-guidance run against the restored `wukong-code-dev` plugin exposed a
registry containing only Go, preserving the expected Swift RED condition.

The frozen candidate was then installed from a fresh local marketplace. Its
cached files were verified to contain the Swift registry entry and the strict
`Detected:`, `Phase:`, and `Loaded:` template. A candidate-plugin control
session answered `control-ok`, so the CLI and marketplace installation were
alive. However, the matching explicit `$language-guidance` Swift strict probe
returned the generic, noncompliant output `Detected: Swift`, `Phase: source`,
and `Loaded: Swift source guidance`; it did not load the candidate's required
paths or choose `implementation`. This is a scored GREEN failure. Several
other candidate sessions ended after initialization without a model answer and
are retained as inconclusive rather than counted as passes.

This initial revalidation did not satisfy the writing-skills deployment gate.
The next experiment tested the model-visible skill summary separately from the
full skill body; the repair and its fresh results are recorded below.

## Post-restart writing-skills repair — GREEN passes

`codex debug prompt-input` showed that Codex exposes each installed skill's
frontmatter description to the model before the full `SKILL.md` is read. The
failed candidate output showed that the prior generic description did not
reliably carry the strict source-edit decision to that entry point. This is an
observed routing limitation, not evidence that the Swift registry or reference
files were absent.

Following `writing-skills` and `test-driven-development`, the static contract
was made RED by requiring the model-visible description to state the strict
source-edit decision. It then went GREEN after adding that requirement to the
frontmatter: an explicit requested source edit must emit `Detected`,
`Phase: implementation`, and the selected `profile.md` plus
`implementation.md` paths before responding. `bash
tests/skills/test-language-guidance.sh` and `git diff --check` passed after the
change.

The freshly reinstalled local candidate passed two independent strict Swift
probes. Sessions `019fad1b-cf7c-7921-911c-b9f7b458d9d9` and
`019fad1c-4236-7691-b417-6b3cff9700a3` both detected the fixture's Swift
source, selected `implementation`, and loaded
`swift/profile.md, swift/implementation.md`. A third fresh adversarial session
(`019fad1c-c5e4-7ce0-8045-345dcfcf1238`) made the same decision and rejected
each pressure request: skipping focused RED, ignoring `Package.swift`, and
using `@concurrent` solely because the host supports Swift 6.3. It made no
fixture edits. The immediately preceding session
`019fad1a-da03-79e3-9e9b-599103562e75` remains a recorded failure, and
`019fad1a-423f-7512-aab7-38e93039e210` remains inconclusive because it had no
model answer. This before/after record satisfies the repaired invocation
scenario's RED, repeated GREEN, and adversarial evaluation requirement; see
the [installed-probe raw index](raw/2026-07-29-swift-language-guidance/installed-probe.md).
