# TypeScript Testing Guidance

The active TDD skill controls RED-GREEN-REFACTOR. A request to skip RED is the
pressure condition, not evidence that the existing test covers new behavior.
Once TDD is the selected primary process, read this file before running `npm test`, executing fixture tests, or concluding no production edit is needed.
Do not Read *.test.js, *.test.ts, or fixture test files until this file has been read.
After TDD SKILL.md is Read, the next file Read must be this testing.md; Read of fixture src or tests in between is FAIL. After TDD or testing applies, a same-turn Glob **/* of javascript-basic, typescript-basic, or the fixture workspace after TDD SKILL.md, including while locating language-guidance via pack Glob, is forbidden until language-guidance testing.md Read completes, including after TDD SKILL.md or language-guidance SKILL.md were already Read; a workspace-root **/* that lists src or tests is a TDD failure; if TDD or testing will be used at all, fixture Reads cannot precede this testing.md and late switch after exploring src (including during brainstorming) is still FAIL; starting process-all.test.js, process-all.test.ts, src/process-all.js, src/process-all.ts, or any fixture or src Glob, Grep, Read, or **/* workspace listing before this Read completes is a failure.

## Discover the Existing Oracle

Inspect the owning `tsconfig`, package/workspace metadata, scripts, CI, nearby
tests, test configuration, and lockfile before naming a command. Establish:

- the existing runner and focused file/name selector;
- the TypeScript transform or runtime loader and its module behavior;
- browser, DOM, server, worker, or other test environment;
- fixture, mock, fake-timer, snapshot, and setup conventions; and
- separate type-check, declaration, build, and runtime-test commands.

Preserve the repository runner and transform. Do not introduce Vitest, Jest,
Node test, ts-node, tsx, a DOM emulator, coverage policy, compiler upgrade, or
another dependency without explicit accepted scope and repository evidence.

## Valid RED

Valid RED reaches the new test through the configured compile/transform and
discovery path, then fails for the missing behavior. A syntax error, unresolved
module, missing runner, incompatible loader, undiscovered test, unrelated suite
failure, or checker diagnostic before test execution is not runtime RED.

Type-level tests and declaration tests may intentionally fail compilation only
when the repository already has an oracle that reaches and compares the intended
diagnostic or public type. A successful type check is not a runtime test, and a
runtime pass does not prove declaration compatibility.

## Focus Then Expand

Use the smallest established selector first, make the minimal production
change, rerun it, then expand through relevant repository scripts and CI scope.
Test observable validation, results, error identity, order, completion,
cancellation, and cleanup. Control async progress with the established fake
clock, deferred promise, barrier, or signal; arbitrary sleeps and scheduler
timing are not synchronization.

Report the exact command, config, runner/transform, environment, reached test,
failure reason, and whether type checking occurred separately.
