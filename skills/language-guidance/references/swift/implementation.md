# Swift Implementation Guidance

Apply only rules whose conditions occur in target code.

## Optionals and Failure

- Handle nil where absence has domain meaning. Forced unwrap is valid only when
  a local invariant proves a value exists and process termination is intended;
  otherwise it turns recoverable input or timing changes into a trap.
- Do not replace a meaningful thrown error with try? when callers need to
  distinguish failure from absence. Preserve the established error contract.

## Value, Identity, and ARC

- Prefer value semantics when copies should be independent. Use reference
  identity when shared identity or lifecycle is part of the contract, not as a
  universal performance shortcut.
- For escaping or stored closures, trace who retains the closure and captured
  objects. Use weak only when nil during execution is valid; use unowned only
  when lifetime dominance is proven. Unnecessary weak capture can drop work,
  while an invalid unowned capture traps.

## Protocol and Type Boundaries

- Introduce a protocol at a real substitution or ownership boundary. Choose a
  generic or some for a preserved concrete type, and any for heterogeneous or
  stored values that need type erasure.
- Do not add conformances such as Equatable, Codable, or Sendable without a
  consumer contract and semantic validity.

## Structured Concurrency

- Before creating child tasks, define who awaits them, how cancellation reaches
  blocking work, result ordering, first-error behavior, and partial results.
- Prefer structured child tasks when lifetime follows the parent. Retain and
  cancel an unstructured Task when independent lifetime is intentional.
- Cancellation is cooperative: check it at task boundaries and ensure awaited
  operations observe it. Do not assume cancel() stops arbitrary work.

## Actors and Sendable

- Use isolation for shared mutable state, but treat every await inside an actor
  as a reentrancy point. Revalidate state after suspension when correctness
  depends on the earlier value.
- Values crossing task or actor boundaries must satisfy the active language
  mode's sendability rules. Use @unchecked Sendable only with a documented,
  reviewable synchronization invariant; it suppresses checking rather than
  providing safety.
- Apply @MainActor to a real main-actor boundary. Do not use nonisolated or a
  global actor merely to silence a diagnostic.

## Minimal Example

    struct Item {
        let id: String
    }

    enum LoadError: Error {
        case missing(String)
    }

    protocol ItemLoading {
        func load(_ id: String) async throws -> Item?
    }

    func requireItem(_ id: String, client: any ItemLoading) async throws -> Item {
        guard let item = try await client.load(id) else {
            throw LoadError.missing(id)
        }
        return item
    }

The example demonstrates an optional-to-error boundary. It does not require
new domain types or a protocol when the target already has a different contract.
