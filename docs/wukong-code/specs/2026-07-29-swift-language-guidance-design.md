# Swift Language Guidance Design

**Status:** Approved for implementation planning

**Date:** 2026-07-29

## Summary

Wukong Code will add a complete experimental Swift language pack to the
existing `language-guidance` skill. The pack will implement the shared six-phase
contract: project profiling, production implementation, testing, debugging,
review, and verification.

The first reproducible environment is a cross-platform Swift Package Manager
package. Xcode project and workspace markers participate in language detection,
but the initial evidence will not claim that Xcode-only schemes, destinations,
signing, or Apple-platform behavior were verified.

The design uses the Swift materials under `tmp/ECC-main` as candidate problem
and pattern sources. It does not copy those materials or inherit their universal
rules. Every retained recommendation must be language-level, conditional on
repository evidence, compatible with the declared toolchain, and checked
against Swift's official documentation or executable fixture evidence.

## Problem

The language-guidance router and Go vertical slice are implemented, while Swift
is still listed as planned. A Swift task therefore has no registered phase
references for concrete decisions about optionals, ownership, protocols,
structured concurrency, actor isolation, testing, or toolchain verification.

The ECC materials demonstrate the kinds of recurring Swift work that need
guidance:

- actor-isolated shared mutable state and persistence;
- Swift 6 concurrency diagnostics and `Sendable` boundaries;
- protocol-based dependency injection and deterministic tests;
- build failures involving SwiftPM, compiler versions, and actor isolation;
- review failures involving forced operations, ARC cycles, task ownership, and
  actor reentrancy.

Those materials also show why the Wukong Code pack must be narrower. Several
recommendations assume Swift 6.2, SwiftUI, Xcode, Apple SDKs, SwiftLint, or a
particular architecture. Applying them without project evidence would violate
the repository-first and zero-dependency contracts.

## Goals

- Register Swift as an experimental language in the existing router.
- Implement all six references required by the language-pack contract.
- Give correctness-relevant, condition-based guidance for Swift source work.
- Preserve primary process skills as authoritative.
- Reuse the repository's declared Swift version, test framework, commands, and
  tools instead of imposing new ones.
- Provide a buildable SwiftPM fixture and behavioral scenarios for every phase.
- Record honest RED/GREEN evidence, toolchain details, limitations, and human
  review requirements.

## Non-Goals

- Creating a separate top-level Swift skill or changing phase routing.
- Teaching Swift syntax or reproducing a comprehensive language guide.
- Requiring Swift 6.2, Swift Testing, SwiftLint, swift-format, or Xcode.
- Adding SwiftUI, UIKit, AppKit, Keychain, signing, simulator, or other
  Apple-platform guidance to the language core.
- Prescribing actor-based persistence, protocol-based dependency injection, or
  any other architecture when the task does not require it.
- Installing tools, adding package dependencies, or changing global settings.
- Claiming Xcode or Apple-platform verification from SwiftPM-only evidence.

## Architecture and Files

The existing `language-guidance` router remains unchanged. The implementation
adds one directory and registers it:

```text
skills/language-guidance/references/swift/
├── profile.md
├── implementation.md
├── testing.md
├── debugging.md
├── review.md
└── verification.md
```

The following existing surfaces will be extended:

- `skills/language-guidance/references/registry.json` registers `.swift` and
  the `Package.swift`, `.xcodeproj`, and `.xcworkspace` markers.
- `tests/skills/test-language-guidance.sh` validates the Swift pack contract.
- `tests/skills/language-guidance-scenarios.md` adds Swift behavior scenarios.
- `tests/skills/fixtures/language-guidance/swift-basic/` provides the executable
  SwiftPM fixture.
- `README.md` changes Swift from Planned to Experimental only when the evidence
  report contains real toolchain and run results.
- `docs/wukong-code/evals/` records the Swift evaluation report and sanitized
  raw outputs.

The shared size limits continue to apply: `profile.md` stays at or below 160
lines and every other phase reference stays at or below 200 lines.

## Detection and Version Evidence

Detection follows the existing priority order:

1. Swift explicitly named for the target work.
2. A target file ending in `.swift`.
3. The nearest `Package.swift`, `.xcodeproj`, or `.xcworkspace` marker.
4. A repository-scope marker only when target paths are unknown.
5. No selection when evidence conflicts or remains ambiguous.

After Swift is selected, the profile inspects repository evidence before
advising:

- the first-line `swift-tools-version` in the nearest `Package.swift`;
- package products, targets, platforms, dependencies, and Swift settings;
- declared Swift language mode and upcoming-feature flags where present;
- nearby `Sources/` and `Tests/` conventions;
- whether tests use Swift Testing, XCTest, or both;
- CI, scripts, Xcode schemes, formatting, and static-analysis configuration;
- generated sources, C/Objective-C interoperability, and platform conditions.

Swift 6.2 behaviors such as `@concurrent`, nonisolated nonsending defaults,
default actor isolation, and isolated conformances are recommended only when
the declared toolchain or build settings establish their availability. The
pack must not infer them merely from the current machine's compiler.

## Phase References

### Project Profile

`profile.md` tells the agent which version, build system, target, test framework,
CI command, and local conventions govern the current task. It distinguishes
SwiftPM evidence from Xcode-only evidence and requires the verified platform to
be reported.

### Production Implementation

`implementation.md` covers only rules whose conditions appear in the target
code:

- unwrap optionals at a boundary that can handle absence; use forced unwraps
  only when an invariant is locally established and failure is intentionally
  unrecoverable;
- choose value semantics for independent data and reference identity only when
  shared identity or lifecycle is required;
- examine escaping closure ownership and lifetime before adding weak or unowned
  captures; neither capture form is a universal fix;
- introduce protocols at substitution or ownership boundaries, then choose
  generics, `some`, or `any` based on the actual API requirement;
- preserve useful error contracts and avoid discarding actionable failures with
  `try?` or empty catches;
- prefer structured child-task ownership and define cancellation, ordering,
  first-error, and partial-result behavior before parallelizing;
- treat every actor `await` as a possible reentrancy point and revalidate state
  after suspension when correctness depends on it;
- require semantic proof before declaring `Sendable`, especially
  `@unchecked Sendable`, for reference types with mutable state.

Minimal examples illustrate the failure mechanism and preferred boundary. They
do not introduce frameworks, app architecture, or mandatory new abstractions.

### Testing

`testing.md` keeps the active TDD skill authoritative. It requires inspection of
existing tests before selecting Swift Testing or XCTest. A valid RED must build
far enough to execute the new test and fail because the requested behavior is
missing, rather than because of an unavailable tool, manifest error, or unrelated
failure.

The guidance covers focused execution, async and throwing tests, parameterized
tests only when the selected framework supports and benefits from them, test
isolation, deterministic dependency boundaries, and cancellation/error paths.
It does not require framework migration or a universal coverage threshold.

### Debugging

`debugging.md` keeps systematic debugging authoritative and classifies evidence
before proposing a fix:

- compiler and type-checker diagnostics with exact target and language mode;
- SwiftPM manifest or dependency-resolution failures;
- focused test failures and nondeterministic repetitions;
- async hangs, missing cancellation, leaked unstructured tasks, and continuations
  that do not resume exactly once;
- actor reentrancy or isolation violations;
- data races and invalid `Sendable` assumptions;
- ARC cycles, premature deallocation, and unsafe unowned captures;
- conditional compilation, SDK, architecture, or toolchain mismatch.

### Review

`review.md` permits zero findings and requires every finding to name a tight
location, a reachable failure scenario, and the affected contract. It checks
forced operations, swallowed errors, reference lifetimes, shared mutable state,
task cancellation and ownership, values crossing isolation boundaries, actor
state assumptions across `await`, public API changes, and version compatibility.

Naming, `struct` versus `class`, protocol usage, test framework, or formatter
preferences are not findings without a repository rule or concrete failure.

### Verification

`verification.md` selects commands in the contract order: CI and documentation,
repository scripts, declared tools, then safe official-toolchain defaults. For
a SwiftPM package, safe defaults are a focused test, `swift test`, and
`swift build` when they cover distinct concerns. `swift package dump-package`
is used when manifest interpretation is relevant.

Formatting and lint commands run only when the repository declares the tool.
Xcode commands run only when an applicable scheme, destination, and repository
workflow are known. Results state exact commands, exit codes, test counts when
available, verified platform/toolchain, skipped checks, and remaining targets.

## SwiftPM Fixture

The initial fixture is a dependency-free package under
`tests/skills/fixtures/language-guidance/swift-basic/`. It contains a small
asynchronous loading boundary and tests. The implementation scenario asks the
agent to load multiple identifiers concurrently while:

- preserving input order in successful results;
- propagating the first observed error;
- cancelling outstanding child work;
- avoiding unsynchronized captured mutation;
- keeping inputs, outputs, and error contracts safe across task boundaries.

The checked-in starting fixture remains simple enough to compile quickly. The
behavior scenarios can ask for a proposed change without requiring the static
fixture itself to contain the completed solution.

A mixed-language fixture places a Swift package near the Swift target and an
unrelated language marker in a sibling directory. The nearest marker must win.

## Static Tests

Static tests will verify:

- the registry contains exactly the implemented languages and valid status;
- Swift extensions, markers, phases, and reference paths match the contract;
- all six Swift files exist and satisfy size limits;
- no installer or global-configuration command enters language guidance;
- the fixture contains a valid `Package.swift`, source target, and test target;
- README and evidence links agree with registry status;
- plugin packaging retains every Swift reference.

The tests must begin RED against the pre-Swift state, then pass after the
implementation. They must not weaken existing Go or unsupported-language
assertions.

## Behavioral Evaluation

Fresh-session scenarios cover:

1. Swift production implementation with ordering, cancellation, and errors.
2. TDD pressure to skip RED.
3. Diagnosis of an intermittent async hang without editing.
4. Review that reports only concrete Swift correctness failures.
5. Exact completion verification for the SwiftPM fixture.
6. Nearest-marker selection in a mixed-language repository.
7. An unsupported-language negative control.
8. A documentation-only negative control.

The RED baseline uses an isolated checkout without the Swift registration and
references. Candidate GREEN runs use fresh sessions and preserve complete raw
responses. Positive routing scenarios run repeatedly; debugging, review, and
verification receive at least two runs each; adversarial prompts pressure the
agent to skip process gates, install a familiar tool, assume Swift 6.2, or claim
Xcode coverage from SwiftPM evidence.

The report separates these claims:

- static structure and packaging passed;
- the SwiftPM fixture built and tested on a named toolchain/platform;
- explicit `$language-guidance` routing passed or failed;
- automatic routing remained advisory and passed or failed in observed runs;
- Xcode and Apple-platform targets were not verified unless actually executed.

No aggregated pass claim may hide failed or missing runs.

## Source and Evidence Policy

Candidate material comes from:

- `tmp/ECC-main/skills/swift-actor-persistence/SKILL.md`;
- `tmp/ECC-main/skills/swift-concurrency-6-2/SKILL.md`;
- `tmp/ECC-main/skills/swift-protocol-di-testing/SKILL.md`;
- `tmp/ECC-main/skills/swiftui-patterns/SKILL.md` as a framework boundary;
- `tmp/ECC-main/agents/swift-build-resolver.md`;
- `tmp/ECC-main/agents/swift-reviewer.md`;
- `tmp/ECC-main/rules/swift/`.

Normative semantic checks use official Swift sources, including the Swift
Programming Language concurrency guide, the Swift 6 migration guide, SwiftPM
tools-version and command documentation, and official Swift Testing guidance.
Repository behavior and executable fixture evidence override both ECC examples
and generic recommendations.

## Release and Review Gates

Before Swift changes from Planned to Experimental, the implementation must
have:

- failing static controls captured before implementation;
- repeated candidate behavior runs with raw evidence;
- a passing SwiftPM fixture on a recorded Swift toolchain;
- relevant repository regression results with failures reported honestly;
- an evaluation report with known limitations and maintenance responsibility;
- review by a human familiar with Swift;
- review of the complete diff by the human partner.

Experimental status means initial evidence exists and real-project evidence is
still accumulating. It does not mean automatic routing is guaranteed.

## Risks and Mitigations

### Version-specific advice leaks into older projects

Mitigation: gate every new concurrency feature on declared version or build
settings and provide compatible reasoning rather than a universal syntax rule.

### Framework material enters the language core

Mitigation: exclude SwiftUI, Apple security APIs, code signing, and app
architecture. Use them only to identify boundaries and counterexamples.

### Style preferences are reported as correctness defects

Mitigation: require applicability, failure mechanism, repository evidence, and
important exceptions in implementation and review references.

### SwiftPM evidence is overstated as Xcode support

Mitigation: label the verified toolchain and platform in every report and keep
Xcode-only checks explicitly unverified until executed.

### Test tools or dependencies are imposed

Mitigation: inspect existing tests and declared tools first; never install or
add a framework from language guidance.

## Acceptance Criteria

- Swift is registered with the approved evidence markers and six valid phases.
- Every Swift reference follows the shared contract and size limits.
- The content covers the approved correctness areas without framework leakage.
- The SwiftPM fixture passes on a recorded local toolchain.
- Static and behavior evidence distinguishes actual passes, failures, and
  unverified targets.
- Existing Go routing and negative controls continue to behave as documented.
- README status and evidence links match the recorded results.
- A Swift-aware human and the human partner approve the language content and
  complete diff before any PR is opened.
