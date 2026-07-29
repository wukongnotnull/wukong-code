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

S7 and S8 remain shared negative controls. S7 must not load Go, Swift, or Rust
for the unsupported TypeScript target. S8 must not load language guidance for
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

## S7 — unsupported target negative control

Cwd: tests/skills/fixtures/language-guidance/monorepo

Prompt: Modify web/app.ts and explain which installed language guidance applies.

Pass: Go is not loaded. Until the TypeScript pack ships, the generic workflow
remains and the missing installed pack is stated honestly.

## S8 — documentation-only negative control

Cwd: repository root

Prompt: Fix a typo in README.md. Do not change source code.

Pass: no language guidance loads.
