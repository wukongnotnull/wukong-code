# Java Language Guidance Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an evidence-driven, zero-dependency Java language-guidance pack covering profile, implementation, testing, debugging, review, and verification.

**Architecture:** Register Java by source extension and nearest Maven or Gradle marker, then add six compact, framework-neutral reference files selected by the existing language router. A plain-Java Maven fixture, static contract assertions, and fresh-session scenarios make the selection and advice testable without making Spring Boot, Quarkus, JUnit, Mockito, or a formatter a core requirement.

**Tech Stack:** Markdown skill references, JSON registry, Bash static-contract tests, Java source fixture, Maven project metadata.

## Global Constraints

- Java support remains `experimental`; README stays `Planned` until repeated behavioral GREEN results and Java-aware human review exist.
- Core guidance must remain framework-, cloud-, database-, and team-style-neutral.
- Do not add a production dependency, installer command, global configuration, or assumed Java/JUnit/Gradle/Maven version.
- Use the nearest project marker and declared toolchain/build configuration as compatibility evidence; host JDK is execution evidence only.
- Every phase must preserve the selected primary process and provide conditions rather than unconditional style rules.

---

### Task 1: Establish the Java language-pack RED control

**Files:**
- Create: `tests/skills/fixtures/language-guidance/java-basic/pom.xml`
- Create: `tests/skills/fixtures/language-guidance/java-basic/src/main/java/example/langguidance/BatchProcessor.java`
- Create: `tests/skills/fixtures/language-guidance/java-basic/src/test/java/example/langguidance/BatchProcessorTest.java`
- Create: `tests/skills/fixtures/language-guidance/monorepo/java-worker/pom.xml`
- Create: `tests/skills/fixtures/language-guidance/monorepo/java-worker/src/main/java/example/worker/Worker.java`
- Modify: `tests/skills/test-language-guidance.sh`
- Modify: `tests/skills/language-guidance-scenarios.md`

**Consumes:** The existing language-guidance contract, Go/Swift/Rust fixtures, and S1-S8 scenario format.

**Produces:** A failing Java-only contract that requires a registered six-phase pack and fixtures; J1-J6 plus Java monorepo, unsupported-language, and documentation-only scenario requirements.

- [ ] **Step 1: Write the failing static assertions and scenarios**

Add Java to the language loop, require `java` in the registry, require six Java phase files, require both marker fixtures, and assert Java-specific phrases that will be introduced by the minimal pack:

```bash
for language in go swift rust java; do
  for phase in profile implementation testing debugging review verification; do
    assert_file "skills/language-guidance/references/$language/$phase.md"
  done
done

assert_file tests/skills/fixtures/language-guidance/java-basic/pom.xml
assert_file tests/skills/fixtures/language-guidance/monorepo/java-worker/pom.xml
assert_contains skills/language-guidance/references/java/profile.md \
  "The declared release or toolchain owns language compatibility"
assert_contains skills/language-guidance/references/java/testing.md \
  "Valid RED reaches the new test"
assert_contains skills/language-guidance/references/java/verification.md \
  "Maven success does not prove Gradle"
```

Append J1-J6 to `tests/skills/language-guidance-scenarios.md`: implementation, TDD-pressure, debugging, review, verification, and nearest-marker prompts. Require source/toolchain evidence, primary-process preservation, general Java only, no dependency/tool installation, and no framework inference.

- [ ] **Step 2: Run the contract to verify RED**

Run: `bash tests/skills/test-language-guidance.sh`

Expected: FAIL because the Java registry entry, six references, and fixtures are absent.

- [ ] **Step 3: Add the minimal source-only fixtures**

Create a Maven-owned Java 17 fixture without dependencies. `BatchProcessor` must use only the standard library and retain indexed outcomes; the test class must use a plain `main` method with explicit `AssertionError` checks, so the fixture does not impose JUnit or another framework. The monorepo Java fixture must contain a separate nearest `pom.xml` and one `Worker.java` source file.

```java
package example.langguidance;

import java.util.ArrayList;
import java.util.List;

public final class BatchProcessor {
    public List<String> processAll(List<String> inputs) {
        return new ArrayList<>(inputs);
    }
}
```

- [ ] **Step 4: Re-run the contract and confirm it remains RED only for the missing pack**

Run: `bash tests/skills/test-language-guidance.sh`

Expected: FAIL only on the missing Java registry/reference assertions, confirming the fixture paths and test wiring are correct.

### Task 2: Add the registered Java profile and implementation references

**Files:**
- Create: `skills/language-guidance/references/java/profile.md`
- Create: `skills/language-guidance/references/java/implementation.md`
- Modify: `skills/language-guidance/references/registry.json`

**Consumes:** Task 1's failing controls and the shared language-pack contract.

**Produces:** A `java` registry entry with `.java` and Maven/Gradle markers; profile and implementation guidance selected together for production source edits.

- [ ] **Step 1: Complete the profile and implementation control phrases**

Keep the assertions from Task 1. Add assertions that check `java` has experimental status, `.java`, `pom.xml`, `build.gradle`, `build.gradle.kts`, `settings.gradle`, and `settings.gradle.kts`, plus the six expected phase keys.

- [ ] **Step 2: Write `java/profile.md`**

Document repository-first inspection of the nearest `pom.xml` or Gradle build/settings files, module ownership, declared JDK release/toolchain, compiler options, source/test layout, wrappers, CI, generated sources, annotation processors, multi-release JARs, JPMS, native integration, and test framework. State that host `java -version` does not establish target compatibility and that Java version-sensitive syntax needs project evidence.

- [ ] **Step 3: Write `java/implementation.md`**

Use short conditional sections for nullness/`Optional`, exception identity and try-with-resources, immutability/defensive copies, equality and generic contracts, and concurrency. Concurrency guidance must require an explicit owner for executor lifetime, completion, interruption, result order, error selection, cancellation, and shared mutable state before choosing threads, futures, virtual threads, locks, or concurrent collections. Version-gate records, sealed types, pattern matching, switch expressions, and virtual threads.

- [ ] **Step 4: Register Java minimally**

Add this registry entry, preserving the existing JSON order and mapping every phase to `java/<phase>.md`:

```json
"java": {
  "status": "experimental",
  "extensions": [".java"],
  "markers": [
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
    "settings.gradle",
    "settings.gradle.kts"
  ]
}
```

- [ ] **Step 5: Run the contract to verify partial GREEN**

Run: `bash tests/skills/test-language-guidance.sh`

Expected: Java profile and implementation assertions pass; contract remains RED for the four unimplemented Java phase files and their required content.

### Task 3: Add Java testing and debugging references

**Files:**
- Create: `skills/language-guidance/references/java/testing.md`
- Create: `skills/language-guidance/references/java/debugging.md`
- Modify: `tests/skills/test-language-guidance.sh`

**Consumes:** Task 2's Java registry, profile, implementation, and fixture.

**Produces:** Testing and debugging guidance that preserves existing frameworks and distinguishes valid failing behavior from harness failures.

- [ ] **Step 1: Add focused testing/debugging assertions**

Require `java/testing.md` to preserve the existing test framework, reject compiler/build/discovery failures as RED, and use repository commands before Maven or Gradle wrapper defaults. Require `java/debugging.md` to keep dependency resolution, annotation processing, module/classpath, runtime linkage, concurrency, and JDK mismatch as distinct evidence paths.

- [ ] **Step 2: Write `java/testing.md`**

Explain RED-GREEN ownership belongs to the active TDD skill. Direct the agent to inspect the module's test sources, build setup, CI, and existing test framework. Show only conditional focused command shapes:

```text
./mvnw -pl <module> -Dtest=<Class>#<method> test
./gradlew :<module>:test --tests '<fully-qualified-class-or-method>'
```

State that those commands apply only when the wrapper/build tool/test selector exists. A valid RED must compile/discover/reach the new test and fail for missing behavior; compiler errors, absent test engines, unavailable services, and unrelated failures are invalid. Preserve established JUnit/TestNG/custom harnesses and do not introduce Mockito, AssertJ, Testcontainers, coverage targets, sleeps, or test-library migrations without scope.

- [ ] **Step 3: Write `java/debugging.md`**

Classify compiler errors by primary diagnostic, owning module, JDK release, and annotation/module/classpath inputs; build resolution by wrapper, repository, effective model/configuration, and exact cause; test failure by focused reproducible run; runtime linkage by exact class/method/loader/version evidence; and concurrency by executor ownership, task completion, interruption, blocking queues, locks, visibility, and unrelated slow work. Prohibit cache deletion or dependency/toolchain upgrades until evidence identifies them as causal.

- [ ] **Step 4: Run the contract to verify partial GREEN**

Run: `bash tests/skills/test-language-guidance.sh`

Expected: testing/debugging assertions pass; contract remains RED only for review and verification files.

### Task 4: Add Java review and verification references

**Files:**
- Create: `skills/language-guidance/references/java/review.md`
- Create: `skills/language-guidance/references/java/verification.md`
- Modify: `tests/skills/test-language-guidance.sh`

**Consumes:** Tasks 1-3 and the shared language-pack contract.

**Produces:** Actionable Java review and evidence-scoped Maven/Gradle verification guidance.

- [ ] **Step 1: Add review/verification assertions**

Require review to allow zero findings and require a location plus reachable failure scenario. Require verification to distinguish Maven from Gradle, report skipped checks, and avoid assuming compilation proves all configured variants.

- [ ] **Step 2: Write `java/review.md`**

Require exact-file, tight-line, reachable-contract findings only. Cover resource acquisition/closing, swallowed or misclassified exceptions, `Optional`/null failures reachable from input, mutable exposure, `equals`/`hashCode` contract failures, raw/unsafe generic boundaries, executor/task lifecycle, interruption, unsynchronised shared state, lock-order deadlocks, JDK/API/module incompatibility, and public/serialized contract changes without tests. Exclude preferences for records, streams, `var`, annotations, package layout, test framework, style, framework architecture, or performance speculation without project rules and a concrete failure.

- [ ] **Step 3: Write `java/verification.md`**

Choose commands in this order: CI/docs, repository scripts/wrappers, declared tools, then safe toolchain defaults. For Maven or Gradle projects, show only applicable command shapes:

```text
./mvnw -pl <module> test
./mvnw -pl <module> verify
./gradlew :<module>:test
./gradlew :<module>:check
```

State that Maven success does not prove Gradle, a focused test does not prove all modules/profiles/test suites, and a compile/test run does not prove formatter, static analysis, integration environment, native image, JPMS, or all JDK targets. Run Checkstyle, SpotBugs, Error Prone, formatter, coverage, integration tests, or security scans only when configured and available; never install them. Report exact commands, exit codes, module, JDK, profile/configuration, test counts when available, skipped checks, and unverified variants.

- [ ] **Step 4: Run the complete static contract to verify GREEN**

Run: `bash tests/skills/test-language-guidance.sh`

Expected: `STATUS: PASSED`, with all existing Go/Swift/Rust checks unchanged and all Java checks passing.

### Task 5: Record evidence, run behavioral checks, and refactor only observed gaps

**Files:**
- Create: `docs/wukong-code/evals/2026-08-02-java-language-guidance.md`
- Modify: `docs/wukong-code/evals/raw/2026-08-02-java-language-guidance/README.md` (only if raw transcripts are suitable for source control)
- Modify: `README.md`

**Consumes:** The complete Java pack, J1-J6 scenarios, static contract, and runtime evaluation results.

**Produces:** An honest experimental evaluation record and documentation status that does not overclaim automatic routing or human review.

- [ ] **Step 1: Run no-guidance RED controls in fresh isolated sessions**

Use a sanitized fixture-only checkout that excludes Java references and scenario rubric. Run at least five J1/J2/J6 repetitions and two J3/J4/J5 repetitions, plus five unsupported-language and documentation-only controls. Capture complete responses, exact harness/model/plugin details, and each incorrect generic-routing or Java-advice behavior verbatim.

- [ ] **Step 2: Run Java fixture checks**

Inspect declared toolchain first. Run only commands supported by the fixture and environment, beginning with the module wrapper if present. Record the exact command, exit status, output, and any unavailable tool without installing it.

- [ ] **Step 3: Run with-guidance GREEN and adversarial controls**

Run the same fresh-session matrix with the candidate pack. Add three repetitions each for: host-JDK pressure that asks to ignore the declared release; pressure to add JUnit/Mockito or a framework; and pressure to claim Maven output proves all Gradle/module/profile variants. Every run must remain within the scenario's evidence boundaries.

- [ ] **Step 4: Refactor only demonstrated routing or wording failures**

For every failing GREEN or adversarial run, quote the observed response in the evaluation record, make the smallest matching wording or contract change, add a static RED assertion first, and repeat the affected controls. Do not add framework-specific guidance as a workaround.

- [ ] **Step 5: Write the evaluation record and preserve release status**

Document ECC source commit `e4e4163101f162881e628f300a9ca4e6a940bcea`, the distilled general-Java principles, excluded Spring/Quarkus content, official source URLs, toolchain/fixture facts, RED/GREEN/adversarial results, limitations, and Java-aware human-review status. Keep `README.md`'s Java status `Planned` until every publication gate is independently met; never fabricate a sign-off.

- [ ] **Step 6: Run complete regression verification and diff review**

Run:

```bash
bash tests/skills/test-language-guidance.sh
bash tests/skills/test-skill-slim-gates.sh
git diff --check
git diff -- skills/language-guidance tests/skills README.md docs/wukong-code/evals
```

Expected: static contracts and slim gates pass, `git diff --check` is silent, and the diff contains only Java language-pack infrastructure and evidence.
