# Java Debugging Guidance

Systematic debugging remains authoritative. Reproduce and classify evidence
before changing code.

## Classify

- Compiler: retain the exact diagnostic, primary source position, owning
  module, declared release/toolchain, processor inputs, and module/class path.
- Build resolution: inspect the selected wrapper, repositories, effective Maven
  model or Gradle configuration, and the exact dependency or plugin failure.
- Test failure: run the smallest existing selector and preserve its full output,
  inputs, and environmental requirements.
- Runtime linkage: retain the exact missing/incompatible class or method,
  class-loader/version evidence, and deployment/build artifact relationship.
- Concurrency: trace executor ownership, task completion, interruption,
  blocked queues, lock ordering, memory visibility, and unrelated slow work.

When concurrent hang evidence is absent, do not name a leading, likely, or most likely cause. Keep executor lifecycle, task joins, interrupted work,
blocked queues, lock ordering, visibility, and unrelated slow work as distinct
hypotheses until one is reproduced.

Read the diagnostic and affected callers, test one causal hypothesis, then
change the smallest intent-preserving point. Do not delete caches, refresh
dependencies, suppress diagnostics, or upgrade a JDK/plugin until evidence
shows it is causal.
