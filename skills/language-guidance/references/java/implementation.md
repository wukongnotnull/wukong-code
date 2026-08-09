# Java Implementation Guidance

Apply only rules whose conditions occur in target code.

## Contracts, Types, and Resources

- Preserve established null, `Optional`, exception, serialization, and public
  API contracts. `Optional.get()` is safe only when a local invariant proves
  presence; do not replace meaningful failure with `null` or an empty value.
- Keep exception type, cause, and interruption meaning when callers need them.
  Use try-with-resources for owned `AutoCloseable` resources when prompt close
  is required; do not close a resource whose ownership was transferred.
- Defensively copy or expose immutable views only when callers must not share
  mutable state. Do not add copies, records, builders, or abstractions by habit.
- Preserve `equals`/`hashCode` invariants for values used in hashed collections,
  and keep generic bounds and variance aligned with the established API.

## Concurrency and Interruption

Before starting work, specify executor ownership and shutdown, task completion,
interruption handling, cancellation, result ordering, partial-result policy,
error selection, and synchronization for shared mutable state. Join or await
every owned task. Thread completion order is not the error contract unless the
repository makes it observable. Do not swallow `InterruptedException`; either
propagate it or restore interrupt status where the surrounding contract allows.

Choose executors, futures, threads, virtual threads, locks, and concurrent
collections only after those contracts are known. Avoid unbounded task creation,
detached work, blocking while holding a lock, and mutable data crossing owners
without a synchronization invariant.

## Version-Gated Features

Use records, sealed types, pattern matching, switch expressions, and virtual
threads only when the owning module's declared JDK/toolchain supports them.
The host compiler is execution evidence, not permission to raise that target.
