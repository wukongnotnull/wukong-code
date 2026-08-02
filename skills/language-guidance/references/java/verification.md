# Java Verification Guidance

Verification-before-completion remains authoritative. Choose commands in this
order: CI/docs, repository scripts and wrappers, declared tools, safe official
toolchain defaults, then an explicit skipped or unknown result.

For an owning Maven or Gradle module, select only configured, relevant checks:

    ./mvnw -pl <module> test
    ./mvnw -pl <module> verify
    ./gradlew :<module>:test
    ./gradlew :<module>:check

Use the repository's wrapper and module/profile selectors when present. Maven success does not prove Gradle, and a focused test does not prove every module,
profile, test suite, formatter, static analysis, integration environment,
native image, JPMS path, or JDK target. Compilation does not establish runtime
linkage on untested deployment environments.

Run Checkstyle, SpotBugs, Error Prone, formatter, coverage, integration, or
security checks only when configured and available; never install them. Report
exact commands, exit codes, module, JDK, profile/configuration, test counts
when available, skipped checks, and unverified variants.
