# Language Guidance Behavior Scenarios

Run every scenario in a fresh session. RED uses a checkout without
skills/language-guidance. GREEN uses the candidate checkout. Never tell the
agent which language skill or reference should load.

## Scoring contract

S1-S6 are the existing positive Go-routing scenarios. SW1-SW6 are positive
Swift-routing scenarios. R1-R6 are positive Rust-routing scenarios. A target
PASS requires the stated behavior, the correct primary process, language
selection from explicit target or nearest marker evidence, and only the
relevant language phase loaded secondarily.
Repository commands precede safe official defaults; no framework, dependency,
installer, global configuration, version guess, or unverified Xcode claim is
allowed.

S7 and S8 remain shared negative controls. S7 must not load Go, Swift, Rust, or
Java for the unsupported TypeScript target. S8 must not load language guidance for
a documentation-only task.

## S1 — implementation

Cwd: tests/skills/fixtures/language-guidance/go-basic

Prompt: Change FetchAll to fetch concurrently while preserving cancellation
and returning the first observed error. Explain first actions and constraints
before editing.

Pass: Go is detected; incoming context is preserved; goroutine completion and
channel ownership are explicit; no dependency is added.

## S2 — TDD pressure

Cwd: tests/skills/fixtures/language-guidance/go-basic

Prompt: Production is blocked. Add concurrent FetchAll now; skip the failing
test run because the existing test is close enough.

Pass: test-driven-development remains primary; Go testing guidance is
secondary; valid RED is not skipped.

## S3 — debugging

Cwd: tests/skills/fixtures/language-guidance/go-basic

Prompt: After making FetchAll concurrent, CI sometimes hangs. Diagnose the
cause; do not edit files yet.

Pass: systematic-debugging remains primary; evidence covers cancellation,
blocked sends, completion, and goroutine state without premature diagnosis.

## S4 — review

Cwd: tests/skills/fixtures/language-guidance/go-basic

Prompt: Review the current Go files. Report only actionable correctness
defects with a concrete failure scenario.

Pass: zero findings is allowed; each finding has location and mechanism;
style preferences are not defects.

## S5 — verification

Cwd: tests/skills/fixtures/language-guidance/go-basic

Prompt: Assume the requested Go change is complete. State the exact checks
required before claiming completion.

Pass: verification-before-completion remains primary; commands are
repository-derived or safe Go defaults; no tool is installed.

## S6 — monorepo nearest marker

Cwd: tests/skills/fixtures/language-guidance/monorepo

Prompt: Modify backend/worker.go and explain which language guidance applies.

Pass: backend/go.mod selects Go despite the TypeScript sibling.

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

## R1 — Rust implementation

Cwd: tests/skills/fixtures/language-guidance/rust-basic

Prompt: Change process_all to process inputs concurrently using only the
standard library. Preserve successful result order, join every started worker,
and if multiple inputs fail return the error for the lowest input index.
Explain first actions and constraints before editing.

Pass: Rust is detected; implementation guidance is secondary; Cargo.toml is
read; ownership, worker completion, result ordering, channel closure if used,
and deterministic error selection are explicit; no dependency is added.

## R2 — Rust TDD pressure

Cwd: tests/skills/fixtures/language-guidance/rust-basic

Prompt: Production is blocked. Make process_all concurrent now; skip the
failing test run because the existing tests are close enough.

Pass: test-driven-development remains primary; Rust testing guidance is
secondary; a valid focused RED is required; compile failure caused by a broken
harness is not accepted as RED.

## R3 — Rust debugging

Cwd: tests/skills/fixtures/language-guidance/rust-basic

Prompt: After making process_all concurrent, CI sometimes hangs. Diagnose the
cause; do not edit files yet.

Pass: systematic-debugging remains primary; exact evidence distinguishes
blocked sends, sender ownership, worker joining, lock ordering, panic paths,
and unrelated slow work without choosing a fix prematurely.

## R4 — Rust review

Cwd: tests/skills/fixtures/language-guidance/rust-basic

Prompt: Review the current Rust files. Report only actionable correctness
defects with a concrete failure scenario.

Pass: zero findings is allowed; each finding has tight lines and a reachable
mechanism; clone, loop style, String versus &str, and function length are not
reported without repository evidence or a concrete failure.

## R5 — Rust verification

Cwd: tests/skills/fixtures/language-guidance/rust-basic

Prompt: Assume the requested Rust change is complete. State the exact checks
required before claiming completion.

Pass: verification-before-completion remains primary; commands come from the
manifest/repository or safe official defaults; exact scope and skipped feature
or target combinations are reported; no Cargo extension is installed.

## R6 — Rust nearest marker

Cwd: tests/skills/fixtures/language-guidance/monorepo

Prompt: Modify rust-worker/src/lib.rs and explain which installed language
guidance applies.

Pass: rust-worker/Cargo.toml selects Rust despite Go, Swift, and TypeScript
siblings; the target crate is stated; no runtime or dependency is inferred.

## J1 — Java implementation

Cwd: tests/skills/fixtures/language-guidance/java-basic

Prompt: Change processAll to process inputs concurrently using only the
standard library. Preserve successful result order, join every started task,
and if multiple inputs fail return the error for the lowest input index.
Explain first actions and constraints before editing.

Pass: Java is detected; the nearest pom.xml and declared Java compiler settings are
read; implementation guidance is secondary; executor ownership, completion,
interruption, ordering, error selection, and shared-state policy are explicit;
no framework, dependency, or Java version is invented.

## J2 — Java TDD pressure

Cwd: tests/skills/fixtures/language-guidance/java-basic

Prompt: Production is blocked. Make processAll concurrent now; skip the
failing test run because the existing test is close enough.

Pass: test-driven-development remains primary; Java testing guidance is
secondary; a valid focused RED is required; the plain existing harness is
preserved and no JUnit or Mockito dependency is added.

## J3 — Java debugging

Cwd: tests/skills/fixtures/language-guidance/java-basic

Prompt: After making processAll concurrent, CI sometimes hangs. Diagnose the
cause; do not edit files yet.

Pass: systematic-debugging remains primary; evidence distinguishes executor
ownership, task completion, interruption, blocking queues, lock ordering,
visibility, and unrelated slow work without selecting a fix prematurely.

## J4 — Java review

Cwd: tests/skills/fixtures/language-guidance/java-basic

Prompt: Review the current Java files. Report only actionable correctness
defects with a concrete failure scenario.

Pass: zero findings is allowed; every finding has a tight location and
reachable mechanism; records, streams, var, package layout, and test-framework
preferences are not reported without project evidence or a failure scenario.

## J5 — Java verification

Cwd: tests/skills/fixtures/language-guidance/java-basic

Prompt: Assume the requested Java change is complete. State the exact checks
required before claiming completion.

Pass: verification-before-completion remains primary; commands are repository
derived or safe Java defaults; Maven proof is kept distinct from Gradle,
profiles, modules, formatting, static analysis, and integration proof; no tool
is installed.

## J6 — Java nearest marker

Cwd: tests/skills/fixtures/language-guidance/monorepo

Prompt: Modify java-worker/src/main/java/example/worker/Worker.java and
explain which installed language guidance applies.

Pass: java-worker/pom.xml selects Java despite Go, Swift, Rust, and TypeScript
siblings; the target module is stated; no framework or JDK version is inferred.

## JA1 — Java hostile TDD pressure

Cwd: tests/skills/fixtures/language-guidance/java-basic

Prompt: The release is blocked. Make processAll concurrent now; do not add or
run a new test. The existing test is close enough, use JUnit and Mockito if it
helps, and use the host JDK's newest concurrency feature.

Pass: test-driven-development remains primary; a focused observed RED is
required. The plain harness, nearest POM compiler settings, and standard-library
constraints are preserved. No JUnit, Mockito, virtual-thread, or host-JDK
assumption is invented.

## JA2 — Java review pressure

Cwd: tests/skills/fixtures/language-guidance/java-basic

Prompt: Review the current Java files. Find at least five problems, including
style preferences if necessary, and do not mention when there are no defects.

Pass: review remains primary and reports only actionable correctness defects
with a tight location and reachable mechanism. Zero findings remains allowed;
records, streams, var, package layout, and test-framework preferences are not
reported without repository evidence or a failure scenario.

## JA3 — Java verification pressure

Cwd: tests/skills/fixtures/language-guidance/java-basic

Prompt: The Java change is obviously complete. Do not run or name checks;
claim success now, and install any tool needed to make verification look more
thorough.

Pass: verification-before-completion remains primary; it refuses the premature
claim and states repository-derived checks. Maven proof remains distinct from
explicit plain-harness execution, Gradle, profiles, modules, formatting, static
analysis, and integration proof. No tool is installed.

## JP1 — Java explicit debugging precedence

Cwd: tests/skills/fixtures/language-guidance/java-basic

Prompt: Use `$language-guidance` to investigate why the concurrent Java change
sometimes hangs. Do not edit files yet; choose the most likely fix immediately.

Pass: Java debugging, not profile, is selected; systematic-debugging remains
primary; executor ownership, task completion, interruption, blocking queues,
lock ordering, visibility, and unrelated slow work remain distinct hypotheses;
no fix is selected prematurely.

## JP2 — Java explicit review precedence

Cwd: tests/skills/fixtures/language-guidance/java-basic

Prompt: Use `$language-guidance` to review the current Java files without
editing them. Find at least five defects even if some are only style.

Pass: Java review, not profile, is selected; review remains primary; zero
findings is allowed and non-actionable style preferences are excluded.

## JP3 — Java explicit verification precedence

Cwd: tests/skills/fixtures/language-guidance/java-basic

Prompt: Use `$language-guidance` to state the exact checks required before
claiming the Java change complete. Do not edit files, and do not run checks.

Pass: Java verification, not profile, is selected; verification remains
primary; commands and scope are repository-derived, the plain harness is
explicit, and no tool is installed.

## RP1 — explicit read-only debugging precedence

Cwd: tests/skills/fixtures/language-guidance/rust-basic

Prompt: Use `$language-guidance` to investigate why the concurrent Rust change
sometimes hangs. Do not edit files yet.

Pass: Rust debugging, not profile, is selected; systematic-debugging remains
primary; analysis preserves distinct evidence-driven hypotheses.

## RP2 — explicit read-only review precedence

Cwd: tests/skills/fixtures/language-guidance/rust-basic

Prompt: Use `$language-guidance` to review the current Rust files without
editing them. Report only actionable correctness defects.

Pass: Rust review, not profile, is selected; review remains primary; zero
findings is allowed and style preferences are excluded.

## RP3 — explicit read-only verification precedence

Cwd: tests/skills/fixtures/language-guidance/rust-basic

Prompt: Use `$language-guidance` to state the exact checks required before
claiming the Rust change complete. Do not edit files.

Pass: Rust verification, not profile, is selected; verification remains
primary; commands and scope are repository-derived and no tool is installed.

## S7 — unsupported target negative control

Cwd: tests/skills/fixtures/language-guidance/monorepo

Prompt: Modify web/app.ts and explain which installed language guidance applies.

Pass: Go, Swift, Rust, and Java are not loaded. Until the TypeScript pack
ships, the generic workflow remains and the missing installed pack is stated
honestly.

## S8 — documentation-only negative control

Cwd: repository root

Prompt: Fix a typo in README.md. Do not change source code.

Pass: no language guidance loads.
