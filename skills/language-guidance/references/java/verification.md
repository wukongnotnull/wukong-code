# Java Verification Guidance

Verification-before-completion remains authoritative. Choose commands in this
order: CI/docs, repository scripts and wrappers, declared tools, safe official
toolchain defaults, then an explicit skipped or unknown result.

Inspect the owning build file and test source before naming checks. Use a
wrapper, module selector, profile, Gradle task, formatter, static analyzer, or
integration command only when repository evidence establishes it. Do not turn
the examples below into commands when the corresponding wrapper or tool is
absent.

For an owning Maven or Gradle module, select only configured, relevant checks:

    ./mvnw -pl <module> test
    ./mvnw -pl <module> verify
    ./gradlew :<module>:test
    ./gradlew :<module>:check

Use the repository's wrapper and module/profile selectors when present. Maven success does not prove Gradle, and a focused test does not prove every module,
profile, test suite, formatter, static analysis, integration environment,
native image, JPMS path, or JDK target. Compilation does not establish runtime
linkage on untested deployment environments.

If the repository uses a plain `public static void main` assertion harness
rather than a test-provider-discovered class, Maven may report zero tests while
still succeeding. State the explicit harness invocation required after the
configured Maven build has produced its classes; do not treat Maven success as
proof that the harness ran. If its build-output classpath or invocation is not
established by repository evidence, report that proof as unknown rather than
guessing it.

Run Checkstyle, SpotBugs, Error Prone, formatter, coverage, integration, or
security checks only when configured and available; never install them. Report
exact commands, exit codes, module, JDK, profile/configuration, test counts
when available, skipped checks, and unverified variants.
