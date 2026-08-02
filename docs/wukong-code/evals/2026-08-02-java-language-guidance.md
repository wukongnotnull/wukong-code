# Java language-guidance evaluation — 2026-08-02

## Scope and source distillation

This candidate adds an experimental Java language pack to the existing generic
router. The source corpus was [ECC commit e4e4163](https://github.com/affaan-m/ECC/tree/e4e4163101f162881e628f300a9ca4e6a940bcea): its Java coding-style, patterns,
security, and testing rules; Java coding standards; and Java reviewer/build
resolver. The useful general material was repository-first build inspection,
JDK compatibility evidence, resource lifecycle, deterministic concurrency
contracts, test discovery, diagnostic classification, and scoped verification.

Spring Boot, Quarkus, JPA/Panache, security-manager choices, CI-specific
commands, JUnit/Mockito/Testcontainers defaults, formatter choices, and team
style rules were intentionally excluded. They are framework, tool, database,
or team preferences rather than broadly applicable core Java guidance.

## Official sources consulted

- [Java `AutoCloseable`](https://docs.oracle.com/en/java/javase/15/docs/api/java.base/java/lang/AutoCloseable.html): try-with-resources closes owned resources and should not suppress interruption by throwing `InterruptedException` from `close`.
- [Java `ExecutorService`](https://docs.oracle.com/en/java/javase/22/docs/api/java.base/java/util/concurrent/ExecutorService.html): executor lifecycle and interruption are observable ownership concerns.
- [Maven Compiler Plugin source/target guidance](https://maven.apache.org/components/plugins/maven-compiler-plugin/examples/set-compiler-source-and-target.html): source/target does not prevent later-platform API use; `release` has a stronger compatibility role when configured.
- [Gradle JVM toolchains](https://docs.gradle.org/current/userguide/toolchains.html): build, test, and execution tasks can use configured toolchains distinct from the host JDK.

## Fixture and static RED/GREEN

The fixture is a dependency-free Maven module at
`tests/skills/fixtures/language-guidance/java-basic/`. Its `pom.xml` declares
source/target 17, and it has a plain Java `main` assertion harness rather than
a test-library dependency.

1. RED: after Java requirements were added to
   `tests/skills/test-language-guidance.sh`, the contract failed as expected:
   all six `java/*.md` files, both fixtures, and the `java` registry entry were
   absent.
2. Fixture check: on the evaluation host, `java -version` and `javac -version`
   reported OpenJDK 21.0.10 and `mvn -version` reported Maven 3.9.6. `mvn test`
   exited 0 and compiled the Java-17 source/test trees, but Surefire reported
   `Tests run: 0`; `java -cp target/classes:target/test-classes
   example.langguidance.BatchProcessorTest` then exited 0 and executed the
   explicit harness assertion.
3. GREEN: `bash tests/skills/test-language-guidance.sh` exited 0 with Java's
   registered six phases and every existing Go, Swift, and Rust assertion
   still passing. `git diff --check` was silent.

The host JDK 21 is execution evidence only; it does not establish a Java-17
runtime/API compatibility matrix for this fixture because the POM uses
source/target rather than `release` and no separate target JDK was supplied.

## Fresh-context retrieval baseline (RED)

Three read-only fresh agents used the candidate fixture before a Java pack was
registered. They received no Java reference path or scenario rubric.

| Prompt | Result | Observed baseline behavior |
| --- | --- | --- |
| Concurrent implementation | TARGET FAIL | Said, “no Java language-guidance pack is installed,” then used generic TDD and did not establish Maven/Gradle/JDK-specific evidence. |
| Skip-RED pressure | TARGET FAIL | Refused to skip TDD, but said “no installed Java language-guidance pack” and gave only generic testing steps. |
| Completion verification | TARGET FAIL | Correctly selected verification-first reasoning, but began with unqualified `mvn clean verify`; only later separated the plain harness from Maven proof. |

These controls show the target gap: generic process skills enforce testing, but
do not reliably inspect Java module/toolchain evidence or distinguish a Maven
phase success from execution of an unconfigured custom harness.

## Candidate retrieval and adversarial results (GREEN)

Candidate runs were read-only, used the exact fixture, and loaded the Java
candidate artifact from the worktree. The first TDD candidate run read the
global stale registry rather than the worktree and is not scored; it was rerun
with the candidate reference path explicitly supplied.

| Prompt | Result | Evidence |
| --- | --- | --- |
| Concurrent implementation | PASS | Detected `.java` plus nearest `pom.xml`, selected `implementation`, loaded `java/profile.md` and `java/implementation.md`, preserved Java 17, no dependencies, indexed ordering, joins, deterministic lowest-index error policy, and interruption handling. |
| Skip-RED pressure | PASS | Selected TDD and `java/testing.md`, preserved the plain harness, rejected skipping RED, and required an observable concurrency contract rather than testing scheduling. |
| Host-JDK/dependency/skip-RED pressure | PASS | Rejected host-JDK 21 as target evidence, declined virtual threads and JUnit/Mockito additions, retained Java 17/harness constraints, and required a deterministic focused RED. |
| Completion verification | PASS | Loaded `java/profile.md` and `java/verification.md`, required `mvn test` plus explicit harness execution, reported Surefire's zero discovered tests, and kept Maven proof separate from Gradle, profiles, static analysis, and runtime matrices. |

## Candidate fixture and runtime evidence

The original fixture only copied strings, so it did not have per-item work or
failure semantics for the concurrency scenario. Its updated sequential baseline
uppercases successful inputs and throws `IllegalArgumentException` for
`fail:<message>` inputs. The plain harness asserts output ordering and the
first sequential failure. It also has an `ItemProcessor` seam, so a future
concurrent implementation can use latches, barriers, or future completion to
make completion-order/error-order tests deterministic without asserting private
scheduling.

The harness change was test-driven:

1. After changing only the harness expectation to uppercase output and a
   `fail:lowest-index` case, Maven compiled successfully but the explicitly
   invoked harness failed with `AssertionError: processAll must preserve
   processed result order`.
2. The smallest sequential implementation then made the same explicit harness
   pass. Surefire continued to report zero discovered tests, so it is not
   treated as behavior proof.

Fresh commands for candidate `f1993b4` passed on Java 17 and Java 22:

- Maven `clean test`, then explicit `BatchProcessorTest.main`, then `clean`;
- Gradle 8.9 offline `clean check`, then `clean`, with automatic toolchain
  download disabled and the installed Java 17 toolchain explicitly supplied;
- `bash tests/skills/test-language-guidance.sh`;
- `bash tests/hooks/test-session-start.sh` using the bundled Node 24.14.0;
- `bash tests/codex/test-package-codex-plugin.sh`; and
- `git diff --check`.

The Gradle fixture has no dependency block and uses a standard-library Java
`main` harness attached to `check`; Gradle's built-in test task is deliberately
disabled because no test framework dependency is part of the zero-dependency
fixture.

For evaluator visibility, the normal Codex marketplace was temporarily pointed
to the frozen local worktree, `wukong-code` was reinstalled, and the installed
cache was checked for both `java/profile.md` and the fixture's `fail:` behavior
before a fresh read-only Codex CLI run. The run used `codex-cli 0.146.0`,
`gpt-5.6-terra`, low reasoning effort, and the preceding candidate commit.
Session `019fc0dd-b594-7fb0-9a88-9d0fb33985b1` selected TDD, preserved Java
17/standard-library/join/error-order/interruption constraints, and reported the
read-only Maven write failure without claiming a test pass. This is one
focused ordinary probe, not a completed cohort.

The focused CLI probe predates the deterministic-test seam, and is therefore
not counted as behavioral evidence for `f1993b4`; the final candidate must be
evaluated after installation as an immutable artifact.

The first seam-only repair did not itself prove the contract. Review correctly
observed that two immediately thrown failures can accidentally pass a
completion-order implementation. The next RED added a `CountDownLatch` case
that makes the later-index failure complete before the lower-index failure;
the sequential baseline failed with `AssertionError: processAll must start
inputs concurrently`. The GREEN implementation uses standard-library
`ExecutorService.invokeAll`, reads futures in input order only after all
started tasks complete, and explicitly shuts down its owned executor. The
same latch case now passes and demonstrates lowest-index selection independent
of completion order. The final candidate revision is recorded after its next
immutable commit and must repeat the complete verification and behavior
cohort.

The next review found two fixture-level ownership defects and added two more
RED/GREEN controls: a three-input latch case rejected one platform thread per
input, and an interrupted-caller case kept a worker alive after cancellation
until an explicit release latch. The former RED failed with `AssertionError:
processAll must not create one worker per input`; the latter distinguishes
returning after `shutdownNow` from waiting for the owned worker to terminate.
The GREEN implementation fixes capacity at two workers for this fixture and
records interruption until its termination loop has finished cleanup, then
restores it. This is still fixture evidence, not a release behavior cohort.

## Frozen-candidate behavior gate: stopped on TDD failure

Candidate `ce48d33` was installed as the evaluator-visible local marketplace
artifact. To avoid evaluating a completed implementation against a request to
make it concurrent, the evaluation workspace was an independent, clean Git
repository populated from the pre-concurrency fixture revision `f1993b4`.
Each run was ephemeral and read-only with `codex-cli 0.146.0`,
`gpt-5.6-terra`, low reasoning effort, and the hook-trust bypass used only for
the inspected local artifact.

The first implementation probe planned a bounded standard-library executor,
input-indexed futures, deterministic error selection, a `finally` shutdown,
and latch-based tests. It is a focused retrieval observation, not a cohort
result. The required TDD-pressure scenario then failed decisively: session
`019fc0ee-3ee4-7f32-b0ff-3e472dc5bb62` accepted the instruction to skip RED,
did not select or announce TDD, and proposed `CompletableFuture.supplyAsync`
on the common pool. It therefore omitted a valid failing test and introduced
an unbounded, repository-unowned executor policy. This is a target failure;
the ordinary/pressure matrix was stopped rather than treating partial runs as
publication evidence.

The failure is in automatic process-skill adherence, not a missing Java
reference: the deterministic prompt router delivered Java testing guidance for
the prompt shape. Correcting it would require a cross-language workflow or
router change, which is outside this Java-pack-only candidate and needs a
separate scoped decision and fresh regression evaluation.

## Limitations and release status

This record covers static controls, targeted fresh-context probes, runtime
fixtures, and a stopped behavior gate—not the repeated 48-session
ordinary/adversarial/regression matrix required for a published language pack.
No Java-aware human has reviewed the reference content. The local marketplace
must also be restored to remote `dev` before handoff. Accordingly, the registry
is only `experimental` and README continues to list Java as `Planned`.

Frameworks or third-party preferences introduced: none.
