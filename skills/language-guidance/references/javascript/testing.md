# JavaScript Testing Guidance

The active TDD skill controls RED-GREEN-REFACTOR. Pressure to skip an observed
RED is not evidence that an existing test covers the new behavior.
Once TDD is the selected primary process, read this file before running `npm test`, executing fixture tests, or concluding no production edit is needed.
Do not Read *.test.js, *.test.ts, or fixture test files until this file has been read.
After TDD SKILL.md is Read, the next file Read must be this testing.md; Read of fixture src or tests in between is FAIL. After TDD or testing applies, a same-turn Glob **/* of javascript-basic, typescript-basic, or the fixture workspace after TDD SKILL.md, including while locating language-guidance via pack Glob, is forbidden until language-guidance testing.md Read completes, including after TDD SKILL.md or language-guidance SKILL.md were already Read; a workspace-root **/* that lists src or tests is a TDD failure; if TDD or testing will be used at all, fixture Reads cannot precede this testing.md and late switch after exploring src (including during brainstorming) is still FAIL; starting process-all.test.js, process-all.test.ts, src/process-all.js, src/process-all.ts, or any fixture or src Glob, Grep, Read, or **/* workspace listing before this Read completes is a failure.

## Discover the Existing Oracle

Inspect the nearest package, scripts, CI, nearby tests, runner configuration,
focused selectors, module mode, transforms, test environment, fixtures, mocks,
and external services before choosing a command. Establish whether tests run in
Node, a browser, Bun, Deno, a worker, an emulator, or a custom host.

Preserve the repository's Node test runner, Vitest, Jest, Mocha, browser
harness, Bun test, Deno test, or custom runner and its established assertion,
fixture, and mocking style. Do not add or migrate a runner because a familiar
command would be easier.

## Valid RED

Valid RED reaches the new test and fails for the missing behavior. A parse or
module-loader error, missing transform, undiscovered test, absent DOM or
service, unavailable dependency, wrong host, and unrelated suite failure do not
prove RED. Fix the harness or select the owning environment until the focused
test fails for the intended reason.

After the smallest implementation, re-run the focused test and then expand to
the repository's relevant package, integration, and CI checks. A focused pass
proves only that selector, host, module mode, transform, and configuration.

## Observable Async Behavior

- Test runtime validation, returned values, error identity/cause, ordering,
  settlement, cancellation contract, and resource cleanup rather than private
  callback sequence or implementation structure.
- Control asynchronous boundaries with promises, signals, runner-supported
  primitives, or explicit events. Arbitrary sleeps and event-loop timing are
  not synchronization.
- Use fake timers, DOM emulation, coverage, snapshots, module mocking, or a
  runner migration only when repository evidence establishes it and the task
  includes that scope. Do not install a missing harness.
- JSDoc assertions, `checkJs`, and type-level expectations apply only when the
  existing test or build configuration enables them; they do not replace
  runtime tests for external values.
