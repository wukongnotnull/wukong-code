# Go Testing Guidance

The active TDD skill controls RED-GREEN-REFACTOR.

## Discovery and RED

Inspect existing _test.go files before choosing package style, table tests,
helpers, parallel subtests, or existing third-party helpers.

    go test ./path/to/package -run '^TestName$/^Subtest$' -count=1

Valid RED reaches the new test and fails for missing behavior. Syntax errors,
unused imports, missing tools, and unrelated failures are invalid RED.

## GREEN and Expansion

    go test ./path/to/package -count=1
    go test ./...

Use -race when concurrency is in scope and the environment supports it.
A race run observes only executed paths.

## Test Design

- Test behavior and error contracts, not private sequencing.
- Use t.Cleanup for test-lifecycle cleanup.
- With t.Parallel, verify fixture and captured-variable ownership.
- Use tables only for cases sharing behavior and setup.
- Add fuzzing only when the accepted task has a relevant input boundary.
- Do not add a dependency when testing and existing helpers are sufficient.
