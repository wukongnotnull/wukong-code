# Rust Testing Guidance

The active TDD skill controls RED-GREEN-REFACTOR.

## Discover the Existing Oracle

Inspect Cargo.toml, workspace layout, nearby tests, CI, features, targets, and
existing unit, integration, documentation, async, property, mock, benchmark,
and UI-test harnesses before choosing a command.

## Valid RED

- A runtime RED compiles, reaches the intended focused test, and fails for the
  missing behavior.
- Compile-fail doctests, UI tests, and compiler-diagnostic tests are valid RED
  when the repository's established harness reaches the intended compile
  assertion and observes the expected missing or mismatched diagnostic.
- Syntax errors in the harness, missing tools, unrelated feature resolution,
  and unrelated failing tests are invalid RED evidence.

## Focus Then Expand

Use repository commands first. Safe Cargo shapes, when applicable, include:

    cargo test --test '<target>' '<test-name>' -- --exact
    cargo test -p '<package>' '<test-name>' -- --exact
    cargo test

Select package, feature, target, doc, example, or workspace flags from task and
repository evidence. A focused pass proves only its focused scope.

Test observable behavior such as results, error identity, order, completion,
and cancellation policy, not scheduler timing. Keep concurrency tests
deterministic; arbitrary sleeps are not synchronization.

Use rstest, proptest, mockall, Criterion, coverage tools, or runtime-specific
test attributes only when already present or explicitly requested. Do not set
a universal coverage threshold or migrate the test framework incidentally.
