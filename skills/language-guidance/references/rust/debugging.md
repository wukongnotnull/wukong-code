# Rust Debugging Guidance

Systematic debugging remains authoritative. Reproduce and classify evidence
before changing code.

## Classify

- Compiler: preserve the exact error code, primary span, notes, edition,
  rust-version, target, features, and surrounding ownership flow.
- Cargo: inspect the owning manifest, workspace inheritance, dependency and
  feature resolution, resolver, lockfile, target, and toolchain diagnostic.
- Test or panic: run the smallest intended test and retain its full failure,
  backtrace when available, inputs, and repetition conditions.
- Concurrency: trace Send/Sync boundaries, worker ownership, joins, channel
  senders, cancellation, non-Send futures, lock ordering, poisoning, and
  blocking executor operations.
- Build: inspect build.rs, proc macros, generated sources, cfg selection,
  linking, FFI, and platform/toolchain mismatch.
- Unsafe: identify the exact safety invariant and evidence that aliasing,
  initialization, layout, lifetime, or ownership violates it.

## Test One Cause

Read the full diagnostic and affected callers, form one causal hypothesis, and
change the smallest intent-preserving point. Re-run the focused reproducer
before broader checks.

Do not use unsafe, blanket allow attributes, arbitrary clones, unwrap, expect,
or panic merely to silence a compiler error. Do not delete Cargo.lock, caches,
or generated outputs before evidence shows they are causal.
