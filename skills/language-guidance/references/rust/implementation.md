# Rust Implementation Guidance

Apply only rules whose conditions occur in target code.

## Ownership and APIs

- Borrow inputs when the callee only observes them. Take ownership or clone
  only when storage, transfer, isolation, or an established API requires it.
- Explain which value owns data and how long each borrow must live. Do not add
  clone, Arc, Box, Cow, or unsafe merely to satisfy the compiler.
- Keep visibility and module changes as narrow as the requested contract.

## Errors and Types

- Preserve error identity and context required by callers. Follow existing
  typed or application-error boundaries; do not introduce anyhow or thiserror
  automatically.
- Evaluate unwrap and expect by reachability and contract. Recoverable input or
  timing failure must not become an accidental production panic; tests and
  locally proven invariants are not automatically defects.
- Use enums, newtypes, exhaustive matches, and traits when they encode a real
  invariant or substitution boundary, not as ritual abstraction.
- Choose generics, impl Trait, or dyn Trait from dispatch, object-safety,
  public-API, and measured performance needs. Iterators and loops are both
  valid when they express the control flow clearly.

## Concurrency and Async

- Define completion, cancellation, ordering, partial results, channel-close
  ownership, panic behavior, and error selection before spawning work.
- Join or await every owned worker.
- Thread completion order is not the error contract unless repository tests
  explicitly make it observable.
- Bound shared state deliberately and prove Send/Sync requirements at the
  boundary. Avoid blocked sends, lock-order cycles, and detached work.
- Do not block an async executor or hold an inappropriate guard across await.
  Use runtime-specific primitives only when that runtime is already present.

## Unsafe Boundaries

- Prefer safe APIs when they express the contract. Every reachable unsafe
  boundary needs documented caller/callee invariants and a local `// SAFETY:`
  explanation of why the operation satisfies them.
- Verify aliasing, initialization, layout, lifetime, provenance, FFI, and
  ownership assumptions against maintained Rust contracts. Unsafe suppresses
  checks; it does not establish correctness.
