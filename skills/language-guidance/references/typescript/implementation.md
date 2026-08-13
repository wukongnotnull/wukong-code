# TypeScript Implementation Guidance

Apply only rules whose conditions occur in the owning project.

## Runtime Boundaries and Narrowing

- Accept `unknown` at an untrusted boundary when the value's shape is not yet
  established, then validate and narrow before use. `any` is appropriate only
  where intentionally preserving an unchecked compatibility boundary; keep it
  local and document the lost guarantees.
- Prefer control-flow narrowing, predicates with proven runtime checks, and
  discriminated unions when they encode actual variants. Use a `never` check
  when the contract requires exhaustive handling and new members must fail the
  build.
- A type assertion changes the checker view, not the runtime value. The same is
  true of a non-null assertion: require a local invariant or runtime guard
  rather than using either syntax to silence contradictory evidence.
- Preserve optional-versus-missing semantics from the effective config,
  especially `strictNullChecks`, `exactOptionalPropertyTypes`, and indexed
  access behavior. Do not widen or normalize them incidentally.

## APIs, Generics, and Mutation

- Keep generic constraints tied to operations the implementation performs.
  Check input and callback positions under the owning strictness settings;
  variance-sensitive substitutions can be unsound even when two object shapes
  look related. Do not add variance annotations to force assignability.
- Use `readonly`, immutable results, or defensive copies only when the API
  contract prohibits shared mutation. Preserve established mutation and
  ownership semantics rather than imposing a universal style.
- Treat exported values and generated `.d.ts` files as compatibility surfaces.
  Check consumers before changing overloads, generic defaults, union members,
  optional fields, module exports, or declaration emit.

## Async, Resources, and Modules

- Define result ordering, error selection, partial-result behavior, promise
  completion, cancellation ownership, and cleanup before starting concurrent
  work. Await or otherwise observe every owned promise; passing an
  `AbortSignal` does not itself cancel work.
- Release owned timers, subscriptions, streams, handles, listeners, and other
  resources on success, failure, and cancellation. Use `using`/`await using`
  only when compiler, library, emit, and runtime/polyfill evidence supports it.
- Write import specifiers for the configured emitter plus actual runtime or
  bundler. Do not change `module`, `moduleResolution`, extensions, aliases,
  interop flags, or package metadata merely to make the checker accept an
  import.
- Static types do not validate JSON, messages, storage, environment values, or
  other external data. Validate at runtime before crossing into typed code.
- Gate `satisfies`, const type parameters, decorators, explicit resource
  management, and other versioned syntax or semantics on the project's declared
  TypeScript and runtime targets.

Enabling `strict`, tightening one of its checks, or changing module settings is
a project migration. Report it as separate scope with affected files,
dependencies, emitted output, and rollout evidence; never mandate it as an
incidental fix.
