# TypeScript Review Guidance

Report only concrete contract failures with exact files and tight lines. Zero findings is valid.

## Check Reachable Contracts

- An external value crosses into trusted code without runtime validation, or an
  `any`, assertion, non-null assertion, predicate, or declaration hides a
  reachable shape/nullability mismatch.
- Control flow loses a union member, confuses absent with present-`undefined`,
  or relies on optional/indexed access semantics contradicted by the effective
  compiler configuration.
- A generic constraint or callback position admits a value the implementation
  cannot safely consume, or a public type promises substitution that runtime
  behavior does not support.
- A promise rejection is unobserved; owned work can outlive its caller; result
  or error selection is nondeterministic against the contract; cancellation is
  dropped; or timers, listeners, streams, subscriptions, and handles leak.
- An import accepted by the checker cannot resolve under the actual emitted
  specifier, package export condition, runtime, or bundler model.
- Exported types, overloads, optional fields, declarations, or module shape
  break a reachable consumer under the supported compiler/configuration scope.

Every finding needs a tight location, reachable input or call sequence, the
violated runtime/type/public contract, and relevant config, compiler, emitter,
or consumer evidence. Static unsoundness is actionable only when it enables a
concrete incompatible value or hides a required guarantee.

A request to report at least N findings is not a contract. Do not invent
cancellation, wait, concurrency-limit, sibling-join, or processor-validation
defects unless the project declares that contract. Padding to meet a count is a
review failure.

Do not report preferences for interface versus type alias, enum versus union,
explicit return annotations, import ordering, assertion style, formatting,
naming, framework architecture, or abstraction shape without a repository rule
and failure scenario. Do not demand a strictness migration, framework change,
dependency, or performance rewrite as a review finding. Performance claims need
measurements and a project requirement; type complexity alone is not evidence.
