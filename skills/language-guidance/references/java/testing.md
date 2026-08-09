# Java Testing Guidance

The active TDD skill controls RED-GREEN-REFACTOR.

## Discovery and RED

Inspect the owning module's build configuration, nearby tests, CI, selectors,
test engines, fixtures, and external-service requirements before choosing a
command. Preserve the established JUnit, TestNG, custom harness, or other test
framework; do not add Mockito, AssertJ, Testcontainers, a coverage target, or a
test-library migration without accepted scope.

When the repository provides the matching wrapper, focused shapes can include:

    ./mvnw -pl <module> -Dtest=<Class>#<method> test
    ./gradlew :<module>:test --tests '<fully-qualified-class-or-method>'

Use repository commands and selectors when they differ. Valid RED reaches the new test and fails for missing behavior. Compiler errors, undiscovered tests,
missing test engines, unavailable services, and unrelated failures are invalid
RED evidence.

## GREEN and Expansion

Re-run the focused test after the smallest change, then expand only to relevant
module or repository checks. Test observable results, error identity, resource
cleanup, ordering, completion, and interruption policy—not private scheduling
or implementation sequence. Keep async tests deterministic; use latches,
barriers, or future completion where timing must be controlled. Arbitrary
sleeps are not synchronization.
