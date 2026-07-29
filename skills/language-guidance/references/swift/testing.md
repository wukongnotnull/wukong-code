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
