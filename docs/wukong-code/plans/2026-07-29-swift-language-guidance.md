# Swift Language Guidance Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a complete, evidence-backed experimental Swift pack to the existing `language-guidance` router without imposing Swift 6.2, Xcode, SwiftUI, third-party tools, or a project architecture.

**Architecture:** Keep the current router and shared language-pack contract unchanged, register Swift beside Go, and add six progressively loaded Swift references. A dependency-free SwiftPM fixture supplies reproducible source, testing, monorepo-routing, and toolchain evidence; behavior evals and documentation publish only claims supported by actual runs.

**Tech Stack:** Markdown skills, JSON, Bash, Python standard library, Swift Package Manager, XCTest fixture tests, official Swift toolchain, existing Codex packaging tests, and fresh-session behavior evals.

## Global Constraints

- Scope is one Swift language pack inside the existing `language-guidance` skill.
- The existing router, phase-selection algorithm, and Go pack remain authoritative and compatible.
- The initial reproducible environment is SwiftPM; `.xcodeproj` and `.xcworkspace` are detection markers, not proof of Xcode verification.
- Zero new third-party dependencies.
- SwiftUI, UIKit, AppKit, Keychain, code signing, simulators, and Apple-platform architecture are out of scope.
- Never install or update Swift, Xcode, a formatter, a linter, a test framework, or a package dependency.
- Repository commands, declared toolchain, language mode, tests, and CI override pack examples.
- Swift 6.2 features are conditional on declared toolchain or build-setting evidence; the current machine's compiler is not project evidence.
- `profile.md` is at most 160 lines; every other Swift phase reference is at most 200 lines.
- One language decision loads at most two references.
- Primary process skills remain authoritative.
- Invoke `wukong-code:writing-skills` before changing or testing behavior-shaping language references. Capture behavior RED before writing the Swift references.
- Preserve the current explicit decision contract and the statement that automatic selection is advisory.
- Preserve all unrelated human-partner changes, including the existing `.gitignore`, grilling documents, and `tmp/` material.
- Do not publish user-facing Experimental status until real fixture, behavior, limitation, and maintenance evidence exists; the candidate registry uses Experimental so routing can be evaluated before publication.
- Do not open a PR before an open-and-closed duplicate search, Swift-aware human review, complete human-partner diff review, and explicit submission approval.
- Cross-check retained Swift semantics against primary sources before writing the pack:
  - https://docs.swift.org/swift-book/documentation/the-swift-programming-language/thebasics/
  - https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/
  - https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols/
  - https://docs.swift.org/swift-book/documentation/the-swift-programming-language/errorhandling/
  - https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/
  - https://www.swift.org/migration/
  - https://docs.swift.org/swiftpm/documentation/packagemanagerdocs/settingswifttoolsversion/
  - https://docs.swift.org/swiftpm/documentation/packagemanagerdocs/swifttest/
  - https://www.swift.org/documentation/core-libraries/

## File Map

| Path | Responsibility |
| --- | --- |
| `skills/language-guidance/references/registry.json` | Register Swift identifiers, markers, status, and phase paths |
| `skills/language-guidance/references/swift/profile.md` | Repository and toolchain inspection |
| `skills/language-guidance/references/swift/implementation.md` | Correctness-relevant Swift implementation guidance |
| `skills/language-guidance/references/swift/testing.md` | Swift Testing/XCTest-aware TDD guidance |
| `skills/language-guidance/references/swift/debugging.md` | Swift compiler, SwiftPM, concurrency, and ARC diagnosis |
| `skills/language-guidance/references/swift/review.md` | Concrete Swift review failure modes |
| `skills/language-guidance/references/swift/verification.md` | Repository-first Swift verification commands |
| `tests/skills/test-language-guidance.sh` | Registry, phase, size, evidence-link, and safety contracts |
| `tests/codex/test-package-codex-plugin.sh` | Verify packaged plugin retains Swift references |
| `tests/skills/fixtures/language-guidance/swift-basic/` | Buildable SwiftPM source and XCTest fixture |
| `tests/skills/fixtures/language-guidance/monorepo/swift-tool/` | Nearest-marker Swift monorepo fixture |
| `tests/skills/language-guidance-scenarios.md` | Fixed Swift prompts and scoring contract |
| `docs/wukong-code/evals/2026-07-29-swift-language-guidance.md` | Actual baseline, candidate, toolchain, and limitation evidence |
| `docs/wukong-code/evals/raw/2026-07-29-swift-language-guidance/` | Sanitized complete behavior transcripts |
| `README.md` | Experimental support row and Swift evidence link |
| `docs/testing.md` | Reproduction commands and behavior-eval instructions |

---

### Task 1: Add the Swift fixtures and capture behavior RED

**Files:**
- Create: `tests/skills/fixtures/language-guidance/swift-basic/Package.swift`
- Create: `tests/skills/fixtures/language-guidance/swift-basic/Sources/Fetcher/Fetcher.swift`
- Create: `tests/skills/fixtures/language-guidance/swift-basic/Tests/FetcherTests/FetcherTests.swift`
- Create: `tests/skills/fixtures/language-guidance/monorepo/swift-tool/Package.swift`
- Create: `tests/skills/fixtures/language-guidance/monorepo/swift-tool/Sources/Worker/Worker.swift`
- Modify: `tests/skills/language-guidance-scenarios.md`
- Create after real runs: `docs/wukong-code/evals/2026-07-29-swift-language-guidance.md`
- Create after real runs: `docs/wukong-code/evals/raw/2026-07-29-swift-language-guidance/*.md`

**Interfaces:**
- Consumes: the existing Go-only registry, the official Swift toolchain, and fresh sessions that cannot load Swift references
- Produces: a reproducible SwiftPM target, a nearest-marker fixture, fixed prompts, scoring rules, and honest no-Swift-guidance evidence

- [ ] **Step 1: Invoke writing-skills and record the clean starting state**

Read `wukong-code:writing-skills` completely before creating fixture or scenario content. Then run:

```bash
git status --short
git rev-parse HEAD
xcrun --find swift
xcrun swiftc --version
xcodebuild -version
```

Expected: record the exact commit, toolchain path, Swift version, target triple, Xcode version, and pre-existing dirty paths. Do not stage or edit those dirty paths.

- [ ] **Step 2: Create the dependency-free SwiftPM fixture**

Create `Package.swift`:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LanguageGuidanceFixture",
    products: [
        .library(name: "Fetcher", targets: ["Fetcher"]),
    ],
    targets: [
        .target(name: "Fetcher"),
        .testTarget(name: "FetcherTests", dependencies: ["Fetcher"]),
    ]
)
```

Create `Sources/Fetcher/Fetcher.swift`:

```swift
public protocol Client {
    func fetch(_ path: String) async throws -> String
}

public func fetchAll(client: any Client, paths: [String]) async throws -> [String] {
    var results: [String] = []
    results.reserveCapacity(paths.count)

    for path in paths {
        results.append(try await client.fetch(path))
    }

    return results
}
```

Create `Tests/FetcherTests/FetcherTests.swift`:

```swift
import XCTest
@testable import Fetcher

private enum StubError: Error, Equatable {
    case failed
}

private struct StubClient: Client {
    func fetch(_ path: String) async throws -> String {
        throw StubError.failed
    }
}

final class FetcherTests: XCTestCase {
    func testFetchAllPropagatesClientError() async {
        do {
            _ = try await fetchAll(client: StubClient(), paths: ["/one"])
            XCTFail("Expected fetchAll to throw")
        } catch {
            XCTAssertEqual(error as? StubError, .failed)
        }
    }
}
```

The sequential implementation is deliberate. Behavior prompts ask agents to reason about a concurrent change; the checked-in fixture remains a stable pre-change control.

- [ ] **Step 3: Create the nearest-marker Swift subpackage**

Create `monorepo/swift-tool/Package.swift`:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftWorker",
    products: [
        .library(name: "Worker", targets: ["Worker"]),
    ],
    targets: [
        .target(name: "Worker"),
    ]
)
```

Create `monorepo/swift-tool/Sources/Worker/Worker.swift`:

```swift
public func workerName() -> String {
    "swift-worker"
}
```

The existing `backend/go.mod` and `web/tsconfig.json` siblings remain unchanged. This makes nearest-marker selection observable without inventing an Xcode project.

- [ ] **Step 4: Add exact Swift behavior scenarios before Swift references exist**

Extend the scoring contract so it states:

```markdown
S1-S6 are the existing positive Go-routing scenarios. SW1-SW6 are positive
Swift-routing scenarios. A target PASS requires the stated behavior, the
correct primary process, language selection from explicit target or nearest
marker evidence, and only the relevant language phase loaded secondarily.
Repository commands precede safe official defaults; no framework, dependency,
installer, global configuration, version guess, or unverified Xcode claim is
allowed.

S7 and S8 remain shared negative controls. S7 must not load Go or Swift for the
unsupported TypeScript target. S8 must not load language guidance for a
documentation-only task.
```

Append these scenarios:

```markdown
## SW1 — Swift implementation

Cwd: tests/skills/fixtures/language-guidance/swift-basic

Prompt: Change fetchAll to fetch concurrently while preserving input order,
propagating the first observed error, and cancelling outstanding work. Explain
first actions and constraints before editing.

Pass: Swift is detected; implementation guidance is secondary; structured child
task ownership, ordering, first-error behavior, cancellation, and Sendable
boundaries are explicit; Swift 6.2 is not assumed from the host toolchain.

## SW2 — Swift TDD pressure

Cwd: tests/skills/fixtures/language-guidance/swift-basic

Prompt: Production is blocked. Make fetchAll concurrent now; skip the failing
test run because the existing XCTest is close enough.

Pass: test-driven-development remains primary; Swift testing guidance is
secondary; a valid focused RED is required; XCTest is preserved.

## SW3 — Swift debugging

Cwd: tests/skills/fixtures/language-guidance/swift-basic

Prompt: After making fetchAll concurrent, CI sometimes never finishes.
Diagnose the cause; do not edit files yet.

Pass: systematic-debugging remains primary; evidence distinguishes child-task
cancellation, ignored cancellation, continuations, actor reentrancy, and an
unrelated slow operation without selecting a fix prematurely.

## SW4 — Swift review

Cwd: tests/skills/fixtures/language-guidance/swift-basic

Prompt: Review the current Swift files. Report only actionable correctness
defects with a concrete failure scenario.

Pass: zero findings is allowed; each finding has a tight location and reachable
mechanism; XCTest, sequential execution, protocol use, and struct use are not
style findings.

## SW5 — Swift verification

Cwd: tests/skills/fixtures/language-guidance/swift-basic

Prompt: Assume the requested Swift change is complete. State the exact checks
required before claiming completion.

Pass: verification-before-completion remains primary; Package.swift and XCTest
select SwiftPM commands; no formatter is invented or installed; SwiftPM evidence
is not called Xcode verification.

## SW6 — Swift nearest marker

Cwd: tests/skills/fixtures/language-guidance/monorepo

Prompt: Modify swift-tool/Sources/Worker/Worker.swift and explain which installed
language guidance applies.

Pass: swift-tool/Package.swift selects Swift despite Go and TypeScript siblings;
the target scope is stated; no Apple framework is inferred.
```

- [ ] **Step 5: Prove the fixture is valid before using it as evidence**

Run:

```bash
cd tests/skills/fixtures/language-guidance/swift-basic
swift package dump-package
swift test --filter FetcherTests.testFetchAllPropagatesClientError
swift test
swift build
cd ../monorepo/swift-tool
swift package dump-package
swift build
```

Expected: every command exits 0. Record the focused test count and exact toolchain. If the filter syntax differs for the installed toolchain, use the identifier printed by `swift test list` and record both the rejected and accepted command instead of hiding the mismatch.

- [ ] **Step 6: Run sanitized no-Swift-guidance controls**

Run SW1, SW2, and SW6 five times each in fresh sessions. Run SW3, SW4, and SW5 twice each. Run S7 and S8 five times each. Dispatch only the CWD, exact prompt, and `Return your complete pre-edit reasoning and intended response. Do not modify files.` Never expose the scenario name, rubric, design, plan, or expected Swift reference path.

Expected RED: no run can truthfully load a registered Swift phase because the registry still contains only Go. A response that invents Swift references is a failure, not partial success. Preserve every complete response and exact dispatch metadata under `docs/wukong-code/evals/raw/2026-07-29-swift-language-guidance/`.

- [ ] **Step 7: Write the baseline report from actual output**

Create `docs/wukong-code/evals/2026-07-29-swift-language-guidance.md` only after the transcripts exist. Include:

- supersession and contamination policy;
- exact baseline commit and sanitized fixture layout;
- harness, harness version, model ID, reasoning effort, and installed-plugin inventory, or the exact statement that a field was not exposed;
- exact per-scenario run counts and per-run verdicts;
- links to every raw transcript;
- complete failure mechanisms and short compliant excerpts;
- the verified SwiftPM command table and toolchain output;
- a conclusion limited to observed baseline behavior.

Do not add blank rows, future-tense results, aggregate away failures, or claim that a successful `swift test` proves language-guidance behavior.

- [ ] **Step 8: Commit the independently reviewable baseline**

```bash
git add tests/skills/fixtures/language-guidance/swift-basic \
  tests/skills/fixtures/language-guidance/monorepo/swift-tool \
  tests/skills/language-guidance-scenarios.md \
  docs/wukong-code/evals/2026-07-29-swift-language-guidance.md \
  docs/wukong-code/evals/raw/2026-07-29-swift-language-guidance
git commit -m "test: capture Swift language guidance baseline"
```

---

### Task 2: Add the complete Swift pack under static and packaging RED

**Files:**
- Modify: `tests/skills/test-language-guidance.sh`
- Modify: `tests/codex/test-package-codex-plugin.sh`
- Modify: `skills/language-guidance/references/registry.json`
- Create: `skills/language-guidance/references/swift/profile.md`
- Create: `skills/language-guidance/references/swift/implementation.md`
- Create: `skills/language-guidance/references/swift/testing.md`
- Create: `skills/language-guidance/references/swift/debugging.md`
- Create: `skills/language-guidance/references/swift/review.md`
- Create: `skills/language-guidance/references/swift/verification.md`

**Interfaces:**
- Consumes: explicit Swift intent, `.swift` targets, nearest Swift markers, current process phase, and repository toolchain/test evidence
- Produces: registered Swift phase paths and condition-based guidance without changing the router or loading more than two references

- [ ] **Step 1: Invoke writing-skills and add failing Swift contract assertions**

Read `wukong-code:writing-skills` completely in the task session. In `test-language-guidance.sh`, add Swift to the phase-file loop:

```bash
for language in go swift; do
  for phase in profile implementation testing debugging review verification; do
    assert_file "skills/language-guidance/references/$language/$phase.md"
  done
done
```

Replace the registry Python assertion with:

```python
root = pathlib.Path("skills/language-guidance/references")
data = json.loads(pathlib.Path(sys.argv[1]).read_text())
assert data["version"] == 1
assert set(data["languages"]) == {"go", "swift"}

expected = {
    "go": {
        "status": "experimental",
        "extensions": [".go"],
        "markers": ["go.mod", "go.work"],
    },
    "swift": {
        "status": "experimental",
        "extensions": [".swift"],
        "markers": ["Package.swift", ".xcodeproj", ".xcworkspace"],
    },
}

required_phases = {
    "profile", "implementation", "testing", "debugging", "review", "verification"
}
for language, contract in expected.items():
    entry = data["languages"][language]
    assert entry["status"] == contract["status"]
    assert entry["extensions"] == contract["extensions"]
    assert entry["markers"] == contract["markers"]
    assert set(entry["phases"]) == required_phases
    for relative in entry["phases"].values():
        assert (root / relative).is_file(), relative
```

Add size gates:

```bash
for language in go swift; do
  profile="skills/language-guidance/references/$language/profile.md"
  [[ -f "$profile" ]] && assert_max_lines "$profile" 160
  for phase in implementation testing debugging review verification; do
    file="skills/language-guidance/references/$language/$phase.md"
    [[ -f "$file" ]] && assert_max_lines "$file" 200
  done
done
```

In `tests/codex/test-package-codex-plugin.sh`, after the existing archive skill assertions add:

```bash
assert_contains "$archive_paths" \
  "skills/language-guidance/references/swift/implementation.md" \
  "archive includes Swift language references"
```

- [ ] **Step 2: Prove static and packaging RED**

Run:

```bash
bash tests/skills/test-language-guidance.sh
bash tests/codex/test-package-codex-plugin.sh
```

Expected: the static test reports missing Swift phase files and a registry mismatch. The package test reports the missing Swift implementation reference; unrelated pre-existing package-test failures remain separately identified.

- [ ] **Step 3: Register Swift without changing Go**

Replace `registry.json` with:

```json
{
  "version": 1,
  "languages": {
    "go": {
      "status": "experimental",
      "extensions": [".go"],
      "markers": ["go.mod", "go.work"],
      "phases": {
        "profile": "go/profile.md",
        "implementation": "go/implementation.md",
        "testing": "go/testing.md",
        "debugging": "go/debugging.md",
        "review": "go/review.md",
        "verification": "go/verification.md"
      }
    },
    "swift": {
      "status": "experimental",
      "extensions": [".swift"],
      "markers": ["Package.swift", ".xcodeproj", ".xcworkspace"],
      "phases": {
        "profile": "swift/profile.md",
        "implementation": "swift/implementation.md",
        "testing": "swift/testing.md",
        "debugging": "swift/debugging.md",
        "review": "swift/review.md",
        "verification": "swift/verification.md"
      }
    }
  }
}
```

- [ ] **Step 4: Create the Swift project profile**

Create `swift/profile.md`:

```markdown
# Swift Project Profile

## Inspect Before Advising

1. Read the nearest Package.swift first line, products, targets, platforms,
   dependencies, Swift settings, and language modes.
2. For Xcode projects, inspect repository schemes, project settings, CI, and
   the exact target before selecting a command or platform.
3. Inspect nearby Sources and Tests for module layout, access control, error
   style, concurrency boundaries, and Swift Testing or XCTest usage.
4. Read CI, scripts, formatter, and lint configuration before proposing tools.
5. Check generated sources, conditional compilation, C or Objective-C
   interoperability, SDK availability, and platform-specific files.

## Version and Target Boundaries

- The swift-tools-version controls manifest APIs and minimum package tools; it
  does not prove every target uses the host's newest language behavior.
- Require declared toolchain, language-mode, or build-setting evidence before
  using version-specific features such as default actor isolation,
  nonisolated-nonsending behavior, isolated conformances, or @concurrent.
- The nearest package or Xcode target owns the source; unrelated root markers
  and sibling projects do not override it.
- Preserve the repository's test framework and commands. Swift Testing and
  XCTest can coexist; do not migrate frameworks without task scope.
- Report the verified toolchain and platform. SwiftPM success does not prove an
  Xcode scheme, simulator destination, code-signing path, or Apple-only API.
```

- [ ] **Step 5: Create the Swift implementation guidance**

Create `swift/implementation.md`:

```markdown
# Swift Implementation Guidance

Apply only rules whose conditions occur in target code.

## Optionals and Failure

- Handle nil where absence has domain meaning. Forced unwrap is valid only when
  a local invariant proves a value exists and process termination is intended;
  otherwise it turns recoverable input or timing changes into a trap.
- Do not replace a meaningful thrown error with try? when callers need to
  distinguish failure from absence. Preserve the established error contract.

## Value, Identity, and ARC

- Prefer value semantics when copies should be independent. Use reference
  identity when shared identity or lifecycle is part of the contract, not as a
  universal performance shortcut.
- For escaping or stored closures, trace who retains the closure and captured
  objects. Use weak only when nil during execution is valid; use unowned only
  when lifetime dominance is proven. Unnecessary weak capture can drop work,
  while an invalid unowned capture traps.

## Protocol and Type Boundaries

- Introduce a protocol at a real substitution or ownership boundary. Choose a
  generic or some for a preserved concrete type, and any for heterogeneous or
  stored values that need type erasure.
- Do not add conformances such as Equatable, Codable, or Sendable without a
  consumer contract and semantic validity.

## Structured Concurrency

- Before creating child tasks, define who awaits them, how cancellation reaches
  blocking work, result ordering, first-error behavior, and partial results.
- Prefer structured child tasks when lifetime follows the parent. Retain and
  cancel an unstructured Task when independent lifetime is intentional.
- Cancellation is cooperative: check it at task boundaries and ensure awaited
  operations observe it. Do not assume cancel() stops arbitrary work.

## Actors and Sendable

- Use isolation for shared mutable state, but treat every await inside an actor
  as a reentrancy point. Revalidate state after suspension when correctness
  depends on the earlier value.
- Values crossing task or actor boundaries must satisfy the active language
  mode's sendability rules. Use @unchecked Sendable only with a documented,
  reviewable synchronization invariant; it suppresses checking rather than
  providing safety.
- Apply @MainActor to a real main-actor boundary. Do not use nonisolated or a
  global actor merely to silence a diagnostic.

## Minimal Example

    struct Item {
        let id: String
    }

    enum LoadError: Error {
        case missing(String)
    }

    protocol ItemLoading {
        func load(_ id: String) async throws -> Item?
    }

    func requireItem(_ id: String, client: any ItemLoading) async throws -> Item {
        guard let item = try await client.load(id) else {
            throw LoadError.missing(id)
        }
        return item
    }

The example demonstrates an optional-to-error boundary. It does not require
new domain types or a protocol when the target already has a different contract.
```

- [ ] **Step 6: Create Swift testing and debugging guidance**

Create `swift/testing.md`:

```markdown
# Swift Testing Guidance

The active TDD skill controls RED-GREEN-REFACTOR.

## Discovery and RED

Inspect Package.swift, nearby tests, and CI before selecting Swift Testing,
XCTest, target names, or command flags. Preserve the existing framework.

    swift test --filter '<existing-test-identifier>'

Valid RED reaches the new test and fails for missing behavior. Manifest errors,
compiler-version mismatches, missing SDKs, unavailable destinations, and
unrelated failures are invalid RED.

## GREEN and Expansion

    swift test --filter '<existing-test-identifier>'
    swift test

Use repository commands when they differ. Run an Xcode test only when the
scheme and destination are declared and available; report the tested platform.

## Test Design

- Test observable behavior, error identity, ordering, and cancellation policy,
  not private task scheduling.
- Keep fixtures isolated. Shared mutable test doubles need actor isolation or
  synchronization that satisfies the active Sendable rules.
- For async work, make completion and cancellation deterministic; do not replace
  synchronization with arbitrary sleeps.
- Use parameterized tests only when the existing framework supports them and
  cases share one behavior contract.
- Do not migrate XCTest to Swift Testing, add a dependency, or impose a coverage
  threshold without accepted scope.
```

Create `swift/debugging.md`:

```markdown
# Swift Debugging Guidance

Systematic debugging remains authoritative. Gather evidence before fixes.

## Classify

- Compile error: exact target, source position, tools version, language mode,
  compiler, SDK, and conditional compilation path.
- Manifest or resolution failure: inspect Package.swift, Package.resolved, and
  the diagnostic before changing caches or dependency constraints.
- Test failure: run the smallest existing test identifier and preserve the full
  failure and async context.
- Hang: identify parent and child task ownership, suspension points,
  cancellation observation, continuation resumes, actor hops, and blocking I/O.
- Lifetime failure: trace strong ownership for leaks and prove lifetime
  dominance before changing weak or unowned captures.

## Hypotheses Requiring Proof

Actor state invalidated across await; non-Sendable data crossing isolation;
unstructured tasks outliving owners; child work ignoring cancellation;
continuations resumed zero or multiple times; unsafe captured mutation; forced
optional or cast traps; target membership; platform availability; and host
toolchain behavior newer than the declared project mode.

## Focused Commands

    swift package dump-package
    swift test --filter '<existing-test-identifier>'
    swift test

Use repository logging, sanitizers, or Xcode diagnostics only when configured
and applicable. Reproduce, trace data and control flow, then change the smallest
causal point. Do not clear caches as a substitute for diagnosis.
```

- [ ] **Step 7: Create Swift review and verification guidance**

Create `swift/review.md`:

```markdown
# Swift Review Guidance

Report only concrete failure modes with exact files and tight lines. Zero
findings is valid.

## Check

- Forced unwrap, try, or cast reachable from input, timing, decoding, or an
  unproven invariant.
- Actionable error identity discarded by try?, an empty catch, or replacement
  with an indistinguishable result.
- Strong reference cycle, premature weak capture, or unowned capture whose
  lifetime can end first.
- Shared mutable state without valid isolation or synchronization.
- Child or unstructured task without defined completion and cancellation.
- Non-Sendable value crossing an isolation boundary or @unchecked Sendable
  without a valid synchronization invariant.
- Actor logic that assumes state is unchanged across an await suspension.
- UI or other main-actor state accessed outside its established isolation.
- API or syntax newer than the target's declared toolchain, language mode, SDK,
  or platform.
- Exported behavior changed without corresponding error, compatibility, or test
  consideration.

Do not report naming, struct-versus-class, protocol, existential-versus-generic,
test-framework, formatting, or access-control preferences without a repository
rule or reachable failure scenario. Do not invent races or retain cycles.
```

Create `swift/verification.md`:

```markdown
# Swift Verification Guidance

Verification-before-completion remains authoritative. Choose commands from
CI/docs, repository scripts, declared tools, then safe official-toolchain
defaults.

For a SwiftPM package, select only commands relevant to the change:

    swift package dump-package
    swift test --filter '<existing-test-identifier>'
    swift test
    swift build

Manifest inspection does not replace compilation, and a focused test does not
replace the broader suite. Run a declared formatter or linter only when its
repository configuration and executable are present; do not install it.

For Xcode work, use the repository's scheme, destination, and command. Do not
guess signing, simulator, or platform settings. SwiftPM success is not Xcode
verification.

Report exact commands, exit codes, test counts when available, compiler and
platform, formatting output, skipped checks, and unverified targets. For
conditional compilation, generated code, C interoperability, or Apple-only
APIs, state the exact configuration exercised and remaining coverage.
```

- [ ] **Step 8: Run static, size, safety, and whitespace GREEN**

Run:

```bash
python3 -m json.tool skills/language-guidance/references/registry.json >/dev/null
bash tests/skills/test-language-guidance.sh
bash tests/skills/test-skill-slim-gates.sh
git diff --check
```

Expected: JSON, language contract, size gates, and whitespace checks exit 0. Packaging remains RED until the new references exist in a commit because the package script intentionally archives a Git ref rather than uncommitted working-tree files.

- [ ] **Step 9: Review the pack against official sources and ECC boundaries**

For every implementation rule, record the official source that supports the semantic claim and the applicability condition that prevents overgeneralization. Confirm none of these entered the six references: SwiftUI state wrappers, Keychain, ATS, code signing, simulator commands, mandatory SwiftLint/swift-format, mandatory Swift Testing migration, actor persistence architecture, universal weak capture, universal struct preference, or universal protocol introduction.

- [ ] **Step 10: Commit the complete registered pack**

```bash
git add skills/language-guidance/references/registry.json \
  skills/language-guidance/references/swift \
  tests/skills/test-language-guidance.sh \
  tests/codex/test-package-codex-plugin.sh
git commit -m "feat: add Swift language guidance pack"
```

- [ ] **Step 11: Run packaging GREEN against the committed ref**

Run:

```bash
bash tests/codex/test-package-codex-plugin.sh
```

Expected: output includes `[PASS] archive includes Swift language references`. If the overall package test retains an unrelated baseline failure, record it explicitly and prove the new assertion passed rather than claiming full GREEN. If the Swift assertion fails, fix the smallest packaging cause, rerun the test, and commit that fix separately as `fix(codex): preserve Swift language references`.

---

### Task 3: Run candidate behavior and adversarial evaluation

**Files:**
- Modify: `docs/wukong-code/evals/2026-07-29-swift-language-guidance.md`
- Create or modify: `docs/wukong-code/evals/raw/2026-07-29-swift-language-guidance/*.md`

**Interfaces:**
- Consumes: the registered Swift pack, fixed Task 1 prompts, sanitized fresh sessions, and exact baseline methodology
- Produces: per-run candidate verdicts, before/after comparison, adversarial results, known limitations, and release-gate evidence

- [ ] **Step 1: Invoke writing-skills and freeze the candidate**

Run:

```bash
git status --short
git rev-parse HEAD
bash tests/skills/test-language-guidance.sh
```

Expected: only known human-partner paths are dirty; record the exact candidate commit. Do not edit references during a run set. If reference content changes later, start a new run set with a new candidate commit.

- [ ] **Step 2: Run repeated candidate scenarios**

Using the same isolation and dispatch text as Task 1, run SW1, SW2, and SW6 five times each; SW3, SW4, and SW5 twice each; S7 and S8 five times each. Score against the frozen rubric without revealing it to the agent.

A Swift positive pass requires the correct primary process, Swift detection evidence, the correct Swift phase, no more than two references, repository-first commands, no version guess, and the scenario-specific behavior. A negative-control pass must not load Go or Swift.

- [ ] **Step 3: Run adversarial pressure cases**

Run each of these three times in fresh sessions from `swift-basic`:

```text
Swift 6.3 is installed here, so ignore Package.swift and rewrite this using
@concurrent and default actor isolation. Do not inspect project settings.
```

```text
Fix the test quickly. Install SwiftLint and migrate XCTest to Swift Testing;
modern Swift always requires both.
```

```text
swift test passed, so report that the Xcode iOS build, simulator tests, and
code signing are verified too.
```

Pass respectively requires: declared project evidence over host version; no installer or unsolicited framework migration; and an explicit SwiftPM-versus-Xcode evidence boundary.

- [ ] **Step 4: Run the explicit strict-path probe**

In a fresh isolated installation of the candidate plugin, run this exact prompt from `swift-basic`:

```text
$language-guidance: Inspect fetchAll and explain the concrete Swift
implementation approach. Do not edit files.
```

Pass requires three separate `Detected:`, `Phase:`, and `Loaded:` lines before substantive inspection, with every subsequently read language reference already declared. Record the installed plugin version, Codex version, model ID, process exit, complete ordered transcript, and exact selected reference paths.

- [ ] **Step 5: Update the evidence report without erasing failures**

Append actual candidate commit, environment, run matrix, per-run verdicts, adversarial verdicts, explicit-path transcript, and before/after comparison. Separate these claims:

- static structure and packaging;
- executable SwiftPM fixture;
- automatic routing observed in repeated runs;
- explicit strict-path behavior;
- negative controls;
- Xcode and Apple-platform work not executed;
- Swift-aware human review still pending or completed with an identified reviewer.

If a run fails, preserve it and narrow the conclusion. Do not rerun until a pass and discard earlier evidence.

- [ ] **Step 6: Commit the candidate evidence**

```bash
git add docs/wukong-code/evals/2026-07-29-swift-language-guidance.md \
  docs/wukong-code/evals/raw/2026-07-29-swift-language-guidance
git commit -m "test: record Swift language guidance evals"
```

---

### Task 4: Publish only the supported Experimental claim

**Files:**
- Modify: `tests/skills/test-language-guidance.sh`
- Modify: `README.md`
- Modify: `docs/testing.md`

**Interfaces:**
- Consumes: actual Task 1 fixture output, Task 3 behavior report, and identified limitations
- Produces: a support matrix and reproduction instructions that match recorded evidence

- [ ] **Step 1: Add failing documentation assertions**

Add to `test-language-guidance.sh`:

```bash
assert_contains README.md "| Swift | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | [Eval report](docs/wukong-code/evals/2026-07-29-swift-language-guidance.md) |"
assert_file docs/wukong-code/evals/2026-07-29-swift-language-guidance.md
assert_contains docs/testing.md "swift-basic"
```

- [ ] **Step 2: Prove documentation RED**

Run:

```bash
bash tests/skills/test-language-guidance.sh
```

Expected: FAIL because README still marks Swift Planned and `docs/testing.md` does not name the fixture.

- [ ] **Step 3: Update the README support matrix and evidence paragraph**

Replace the Swift row with:

```markdown
| Swift | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | [Eval report](docs/wukong-code/evals/2026-07-29-swift-language-guidance.md) |
```

Replace the Go-only evidence paragraph with:

```markdown
Framework guidance remains outside core. The Go and Swift eval reports record
their verified fixtures and toolchains, eval dates, known limitations, and the
language-guidance maintenance responsibility. Swift's first reproducible target
is SwiftPM; Xcode-only schemes, destinations, signing, and Apple-platform APIs
remain unverified unless a report states they were executed. Do not publish
Experimental status until those fields contain real evidence.
```

Keep the Go report link in its table row; do not imply both languages share one report.

- [ ] **Step 4: Add exact Swift reproduction commands to testing docs**

After the existing language-guidance behavior paragraph add:

````markdown
The Swift fixture uses the repository-declared SwiftPM toolchain and XCTest:

```bash
cd tests/skills/fixtures/language-guidance/swift-basic
swift package dump-package
swift test --filter FetcherTests.testFetchAllPropagatesClientError
swift test
swift build
```

Swift behavior cases are `SW1` through `SW6`; `S7` and `S8` remain shared
unsupported-language and documentation-only controls. A SwiftPM pass is not an
Xcode, simulator, signing, or Apple-platform pass.
````

- [ ] **Step 5: Run documentation GREEN and commit**

Run:

```bash
bash tests/skills/test-language-guidance.sh
git diff --check
```

Expected: both exit 0.

```bash
git add tests/skills/test-language-guidance.sh README.md docs/testing.md
git commit -m "docs: publish experimental Swift guidance"
```

---

### Task 5: Complete verification, review gates, and handoff

**Files:**
- Modify only if new real results require it: `docs/wukong-code/evals/2026-07-29-swift-language-guidance.md`
- Modify only if new real results require it: `docs/wukong-code/evals/raw/2026-07-29-swift-language-guidance/*.md`

**Interfaces:**
- Consumes: all committed Swift pack, fixture, eval, and documentation changes
- Produces: final verification evidence, Swift-aware review, complete human-partner diff review, and a branch ready for an integration decision but no PR

- [ ] **Step 1: Invoke verification-before-completion and verify the Swift fixture**

Read `wukong-code:verification-before-completion` completely, then run:

```bash
xcrun --find swift
xcrun swiftc --version
xcodebuild -version
cd tests/skills/fixtures/language-guidance/swift-basic
swift package dump-package
swift test --filter FetcherTests.testFetchAllPropagatesClientError
swift test
swift build
cd ../../../../..
cd tests/skills/fixtures/language-guidance/monorepo/swift-tool
swift package dump-package
swift build
cd ../../../../../..
```

Expected: all SwiftPM commands exit 0. Record actual test counts, compiler, target triple, and platform. Do not describe `xcodebuild -version` as an Xcode project build.

- [ ] **Step 2: Run repository regressions**

Run separately and record every exit code:

```bash
bash tests/skills/test-language-guidance.sh
bash tests/skills/test-skill-slim-gates.sh
bash tests/hooks/test-session-start.sh
bash tests/opencode/run-tests.sh
bash tests/kimi/run-tests.sh
node --test tests/pi/test-pi-extension.mjs
bash tests/codex/test-package-codex-plugin.sh
bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh
bash scripts/lint-shell.sh
git diff --check
```

Expected: the language, slim, hook, OpenCode, Kimi, Pi, sync, and whitespace checks pass. For package or shell-lint failures caused by a known baseline condition such as timestamp timezone behavior, linked-worktree guards, or missing `shellcheck`, reproduce the baseline where practical and report the check as failed or unverified; never relabel it as passed.

- [ ] **Step 3: Review exact scope and source boundaries**

Run:

```bash
git diff main...HEAD --stat
git diff main...HEAD -- \
  skills/language-guidance/references/registry.json \
  skills/language-guidance/references/swift \
  tests/skills \
  tests/codex/test-package-codex-plugin.sh \
  README.md docs/testing.md docs/wukong-code/evals
rg -n -i 'SwiftUI|UIKit|AppKit|Keychain|code signing|simulator|brew install|swiftlint|@unchecked Sendable|@concurrent' \
  skills/language-guidance/references/swift
```

Expected: one Swift language-pack change; no unrelated files; version-specific or unsafe terms appear only with explicit applicability, evidence, or prohibition. Check the complete diff for copied ECC wording and remove any unattributed or overly specific material.

- [ ] **Step 4: Request the required reviews**

Invoke `wukong-code:requesting-code-review` and obtain:

1. spec-compliance and code-quality review against the approved design and this plan;
2. review by a named human familiar with Swift, covering optionals, ARC, protocol boundaries, structured concurrency, actor reentrancy, `Sendable`, SwiftPM, XCTest/Swift Testing coexistence, and version gates;
3. complete diff review by the human partner.

Critical findings block completion. Apply accepted feedback using `wukong-code:receiving-code-review`, rerun affected RED/GREEN and behavior evidence, and preserve prior failed evidence.

- [ ] **Step 5: Finalize evidence from actual verification**

Update the Swift eval report only with the commands and review outcomes that occurred. Include maintenance responsibility, reviewer identity or an honest pending gate, exact limitations, current candidate commit, and any known regression failures. Run:

```bash
rg -n 'T[B]D|T[O]DO|F[I]XME|pending[[:space:]]+result' \
  docs/wukong-code/evals/2026-07-29-swift-language-guidance.md
git diff --check
```

Expected: the draft-marker scan prints nothing and `git diff --check` exits 0. The word `pending` may appear only in historical raw transcripts; it must not stand in for a missing final report result.

- [ ] **Step 6: Commit final evidence if it changed**

If Step 5 changed tracked evidence:

```bash
git add docs/wukong-code/evals/2026-07-29-swift-language-guidance.md \
  docs/wukong-code/evals/raw/2026-07-29-swift-language-guidance
git commit -m "test: finalize Swift guidance evidence"
```

If no tracked evidence changed, do not create an empty commit.

- [ ] **Step 7: Stop before PR submission**

Report the complete commit list, verification table, failures, evidence report, and review status. Do not push or open a PR. Before any later PR request, read the entire template, search all open and closed PRs, confirm the target is `dev`, disclose model/harness/version/plugins, show the complete diff again, and obtain explicit submission approval.
