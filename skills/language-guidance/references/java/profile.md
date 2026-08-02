# Java Project Profile

## Inspect Before Advising

1. Read the nearest `pom.xml` or `build.gradle[.kts]`, then its parent,
   settings, included builds, and module ownership when they affect the target.
2. Read Maven/Gradle wrapper files, CI, scripts, compiler configuration, test
   source layout, and nearby Java/test code before selecting commands or APIs.
3. Establish compilation language/classfile level from declared `release` or
   source/target, then establish the runtime API baseline from `release`, a
   toolchain, deployment evidence, or the repository's compatibility policy.
4. Check generated sources, annotation processors, `module-info.java`,
   multi-release JARs, native/JNI boundaries, and conditional build profiles.

## Compatibility Boundaries

- The declared release or toolchain owns language compatibility. Maven
  source/target does not establish the runtime API baseline: it can constrain
  syntax/classfiles while allowing newer platform APIs at compile time. Follow
  the repository's established compatibility model before recommending an API.
- Do not use records, sealed types, pattern matching, switch expressions,
  virtual threads, or a newer standard-library API without target evidence.
- The nearest owning module wins over unrelated root or sibling markers.
- Preserve existing test frameworks, build wrappers, style tools, and source
  layout. A Java project does not imply Maven, Gradle, JUnit, Spring, or any
  other framework.
