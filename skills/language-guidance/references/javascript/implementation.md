# JavaScript Implementation Guidance

Apply only rules whose conditions occur in the target and owning host.

## Values and Object Contracts

- Missing, undefined, null, and an absent property are distinct contracts.
  Preserve whether callers distinguish omission, an own property with value
  `undefined`, and an explicit `null`; use an ownership check when presence is
  the contract rather than a truthiness or value check.
- Validate external values at runtime before property access, iteration, or
  arithmetic. Static comments or editor analysis do not validate runtime input.
- At comparison, arithmetic, concatenation, parsing, serialization, and key
  boundaries, preserve the established coercion contract. Use explicit
  conversion or strict comparison when accidental coercion creates a reachable
  mismatch; do not rewrite correct coercion by preference.
- Distinguish own properties from inherited ones when accepting dictionaries,
  merging values, or checking options. Preserve property descriptors, symbols,
  prototypes, and enumerability only when the public contract exposes them.
- Assignment, object/array spread, and collection insertion do not recursively
  isolate referenced values. Mutate, copy, freeze, or share only according to
  the ownership and aliasing contract; immutability is not a universal rule.
- Arrays, array-like values, iterables, objects, `Map`, and `Set` have different
  ordering, duplication, key, and iteration behavior. Choose from the accepted
  input and observable output contract, not from style preference.

## Errors, Promises, and Cleanup

- Preserve error identity, message, cause, and host-specific metadata needed by
  callers. Catch only where code can add context, recover, translate an
  established boundary, or guarantee cleanup; do not swallow rejections.
- Define promise fulfillment order, rejection selection, partial-result policy,
  and ownership of started work. `Promise.all` returns fulfillment values in
  input order, while its first observed rejection does not cancel or await the
  remaining operations. Do not equate settlement order with a different API's
  error contract.
- Cancellation is conditional on an established host API and the called
  operation honoring it. Forward the existing signal/token, define the abort
  result, detach owned listeners, and do not claim cancellation merely because
  the aggregate promise rejected.
- Release owned timers, listeners, subscriptions, streams, handles, and other
  host resources on every required path. Do not close or detach a resource
  whose ownership was transferred.

## Modules, Packages, and Compatibility

- Preserve the established ESM/CommonJS boundary, import specifiers, loader or
  transform, live-binding behavior, default/named export contract, and sync or
  async loading expectations. Interop behavior belongs to the owning runtime or
  tool, not ECMAScript syntax alone.
- Treat package `exports`, `imports`, entry points, and conditional branches as
  consumer contracts. Adding or removing an export map or changing a file
  extension/module mode can be breaking even when local imports still work.
- Use syntax, built-ins, web APIs, Node APIs, JSX output, and explicit resource
  management only when declared target hosts and transforms support them.
- JSDoc types and `checkJs` apply only when repository evidence already enables
  or uses them. Do not turn a JavaScript change into a TypeScript migration, and
  do not prescribe classes, functions, mutation, or immutability universally.
