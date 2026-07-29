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

## Installed-plugin rerun — route resolved, implementation gate still fails

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
SW1 is therefore a TARGET FAIL. The updated raw index preserves both runs and
their persistent session identifiers. This confirms the remaining failure is
phase selection, not plugin installation or Swift detection.
