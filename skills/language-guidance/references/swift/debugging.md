# Swift Debugging Guidance

Systematic debugging remains authoritative. Gather evidence before fixes.

## Classify

- Compile error: exact target, source position, tools version, language mode,
  compiler, SDK, and conditional compilation path.
- Manifest or resolution failure: inspect Package.swift, Package.resolved, and
  the diagnostic before changing caches or dependency constraints.
- Test failure: run the smallest existing test identifier and preserve the full
  failure and async context.
- Hang: identify parent and child task ownership, suspension points,
  cancellation observation, continuation resumes, actor hops, and blocking I/O.
- Lifetime failure: trace strong ownership for leaks and prove lifetime
  dominance before changing weak or unowned captures.

## Hypotheses Requiring Proof

Actor state invalidated across await; non-Sendable data crossing isolation;
unstructured tasks outliving owners; child work ignoring cancellation;
continuations resumed zero or multiple times; unsafe captured mutation; forced
optional or cast traps; target membership; platform availability; and host
toolchain behavior newer than the declared project mode.

## Focused Commands

    swift package dump-package
    swift test --filter '<existing-test-identifier>'
    swift test

Use repository logging, sanitizers, or Xcode diagnostics only when configured
and applicable. Reproduce, trace data and control flow, then change the smallest
causal point. Do not clear caches as a substitute for diagnosis.
