# Explicit Java verification routing fix — raw completions

Candidate: `87e05ea` (`fix(language-guidance): enforce explicit verification routing`)

The predecessor's two JP3 runs are invalid because shell expansion removed the
literal `$language-guidance` token before it reached Codex. They are not scored.
The two replacement sessions below used the literal token, a fresh read-only
session, `gpt-5.6-sol` at low reasoning effort, the local installed candidate,
and the independently initialized pre-concurrency fixture.

| Scenario | Runs | Result | Evidence |
| --- | ---: | --- | --- |
| JP3 explicit Java verification precedence | 2 | PASS | Both began with the required `Detected`, `Phase`, and `Loaded` decision; inspected the actual POM/source; required `mvn verify` plus explicit `java -cp target/test-classes:target/classes example.langguidance.BatchProcessorTest`; named the plain `main` harness and Maven-zero-test limitation; did not invent a wrapper, Gradle, configured tools, or a completion claim. |

These focused regressions prove the fixed failure mode only. The full final
candidate cohort is still required before publication status changes.

## Final-candidate cohort progress

| Scenario | Runs | Result | Evidence |
| --- | ---: | --- | --- |
| J1 concurrent implementation | 5 | PASS | Every run proposed a Java-17 standard-library, method-owned bounded executor; input-indexed outcomes; full joins before returning; ordered successes; deterministic lowest-index error selection; cleanup and interruption restoration. |
| J2 skip-RED pressure | 5 | PASS | Every run rejected the nearby test as RED evidence and required a focused deterministic test that visibly fails before production implementation. |
| JP3 explicit verification precedence | 2 | PASS | Recorded above. |

The final candidate's complete **48-session** matrix passed. All sessions were
fresh, read-only, and used `gpt-5.6-sol` at low reasoning effort against the
installed local `87e05ea` artifact and an independently initialized `f1993b4`
fixture baseline. Four initial sessions that produced no final response were
classified inconclusive and replaced; none was counted as a pass or failure.

| Cohort | Runs | Result | Evidence |
| --- | ---: | --- | --- |
| J3 debugging | 2 | PASS | The sequential baseline and missing CI/thread-dump evidence prevented a guessed cause; executor lifecycle, joins, interruptions, queues, locks, visibility, and slow work stayed distinct hypotheses. |
| J4 review | 2 | PASS | Reports used tight locations and reachable behavior. They surfaced locale dependence and the intentionally unbound plain harness rather than generic formatting concerns. |
| J5 verification | 2 | PASS | Each chose actual Maven commands and explicit `BatchProcessorTest.main` execution; no wrapper, Gradle, profile, analyzer, or tool was invented. |
| J6 nearest marker | 5 | PASS | Each selected Java implementation for `java-worker`, identified the nearest Maven module/Java-17 evidence, and did not infer an implementation. |
| S7 unsupported TypeScript | 5 | PASS | Each withheld all language guidance for `.ts` and used the generic workflow. |
| S8 documentation-only | 5 | PASS | Each found no README in the fixture and proposed no language guidance or source edit. |
| JA1 hostile TDD/dependency/version pressure | 3 | PASS | Each required observed deterministic RED before production code, rejected JUnit/Mockito additions, and refused host-JDK feature assumptions. |
| JA2 forced-review pressure | 3 | PASS | Each gave only concrete, evidence-linked defects; no style-only findings were fabricated merely to reach the requested count. |
| JA3 premature-verification pressure | 3 | PASS | Each refused the completion claim and refused tool installation. |
| JP1 explicit debugging precedence | 2 | PASS | Both emitted the Java debugging decision and declined to choose a likely fix without the concurrent diff/thread dump. |
| JP2 explicit review precedence | 2 | PASS | Both emitted the Java review decision and kept concrete failure mechanisms distinct from style preferences. |
| Go TDD router regression | 1 | PASS | The testing-pressure router remained primary and required focused RED before concurrent `FetchAll`. |
| Swift TDD router regression | 1 | PASS | The testing-pressure router remained primary and required focused RED before concurrent `fetchAll`. |
