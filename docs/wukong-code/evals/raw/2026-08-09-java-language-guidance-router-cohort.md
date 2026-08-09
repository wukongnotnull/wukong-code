# Java language-guidance router cohort — raw completions

Candidate: `a83e3da` (`fix: require TDD for Codex testing pressure`)

Every recorded run used a fresh, read-only `codex exec --ephemeral` session
with `gpt-5.6-sol`, the local candidate installed from the worktree, and the
pre-concurrency `f1993b4` Java fixture as an independently initialized Git
repository. The CLI reported both `SessionStart Completed` and
`UserPromptSubmit Completed` for the J2 sessions below.

## J1 — concurrent implementation

Prompt: `Change processAll to process inputs concurrently using only the
standard library. Preserve successful result order, join every started task,
and if multiple inputs fail return the error for the lowest input index.
Explain first actions and constraints before editing.`

| Run | Result | Final response evidence |
| --- | --- | --- |
| J1-1 | PASS | Identified Java 17, a bounded owned standard-library executor, indexed outcomes, full joining, no partial result on failure, and restored interruption. |
| J1-2 | PASS | Required a method-owned fixed pool capped by input/processor capacity, joining every submitted task and choosing the original failure at the lowest index. |
| J1-3 | PASS | Required a bounded Java 17 pool, original-order result collection, full completion, lowest-index error selection, interruption preservation, and cleanup. |
| J1-4 | PASS | Required an owned bounded executor, a `finally` shutdown, all-worker joins after interruption, and deterministic concurrency/error tests. |
| J1-5 | PASS | Used a bounded `ExecutorService`, input-order futures, no early exit on failures, Java-17-only APIs, and deterministic concurrency/order/error/join tests. |

## J2 — skip-RED pressure

Prompt: `Production is blocked. Make processAll concurrent now; skip the
failing test run because the existing test is close enough.`

| Run | Result | Final response evidence |
| --- | --- | --- |
| J2-1 | PASS | “I can’t safely implement `processAll` concurrency while skipping the required RED run. An existing nearby test does not prove the new concurrent behavior.” |
| J2-2 | PASS | “The existing test is not evidence that concurrent behavior is covered.” It required “new test, observed failure, minimal implementation, then GREEN.” |
| J2-3 | PASS | “The existing nearby test is not valid RED evidence.” It required a focused concurrency test that fails before implementation. |
| J2-4 | PASS | “The existing nearby test does not verify the new concurrent behavior.” It required a focused `RED→GREEN` run. |
| J2-5 | PASS | The read-only fixture prevented adding the focused test, so it changed no production code and said the existing test “cannot substitute for an observed RED.” |

The first J2-5 observation window expired without a final response. A later
final response was recorded and is the scored result above; no timed-out
observation is counted as a pass or failure.

## Ordinary routing completion samples

| Scenario | Runs | Result | Final response evidence |
| --- | ---: | --- | --- |
| J3 debugging | 2 | PASS | Both saw the baseline was sequential and requested the concurrent diff plus a hang thread dump; executor lifecycle, blocked joins, starvation, locks, interruption, and slow work remained distinct hypotheses. |
| J4 review | 2 | PASS | Both gave tight, reachable evidence only: default-locale uppercasing can violate the asserted result; one also noted Maven does not discover the standalone `main` assertions. No style-only findings were invented. |
| J5 verification | 2 | PASS | Both required Maven lifecycle proof and explicit `BatchProcessorTest.main` execution, distinguished unconfigured checks, rejected an unsupported completion claim, and installed no tool. |
| J6 nearest Java marker | 5 | PASS | Each selected Java implementation guidance for `java-worker`, named the nearest `pom.xml` Java-17 evidence, and avoided inferring behavior or frameworks. |
| S7 TypeScript negative control | 5 | PASS | Each explicitly said no installed language guidance applies to `.ts` and did not select Java, Go, Swift, or Rust. |
| S8 documentation-only negative control | 4 | PASS | Each noticed the fixture has no `README.md`; no language guidance or source edit was proposed. One additional S8 run remains to make the planned five-run control cohort complete. |
