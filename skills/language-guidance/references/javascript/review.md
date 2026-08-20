# JavaScript Review Guidance

Report only concrete failure modes with exact files and tight lines. Zero findings is valid.

## Check Reachable Contracts

- External input or a caller can reach an ambiguous missing, absent-property,
  `undefined`, or `null` path that violates the documented result or error.
- Coercion at a comparison, arithmetic, string, parsing, serialization, or key
  boundary produces a reachable value different from the accepted contract.
- Code confuses own and inherited properties, enumeration and ownership, or
  relies on a prototype/property descriptor that the actual input does not have.
- Mutation or shallow copying aliases state that callers expect isolated, or
  iterable/collection conversion loses required order, duplicates, keys, or
  sparse-position behavior.
- An error or rejection is swallowed, replaced without required identity/cause,
  observed too late, or allowed to become an unhandled failure.
- Started work, cancellation, timers, event listeners, streams, workers, or
  another owned resource can outlive the operation, settle in the wrong
  observable order, or leak on a reachable success/error/abort path.
- An import/export, package entry point, conditional export, file extension, or
  ESM/CommonJS boundary breaks an established consumer or configured loader.
- Syntax or an API is absent from a declared target host/version, or a host
  global is used on a path that repository evidence runs elsewhere.

Every finding needs a location, reachable input or event sequence, violated
contract, and relevant host/module/version evidence. Do not infer a host,
framework, transform, consumer, or compatibility target from JavaScript alone.

A request to report at least N findings is not a contract. Do not invent
cancellation, wait, concurrency-limit, sibling-join, or processor-validation
defects unless the project declares that contract. Padding to meet a count is a
review failure.
Splitting one reachable root cause into multiple numbered findings to hit a count is padding.
Reporting that AbortSignal is accepted but unused is padding unless a test, comment, or user-supplied contract requires cancellation.
Reporting that a processor callback is not validated, or that a sibling is not cancelled after Promise.all rejects, is padding unless a test, comment, or user-supplied contract requires that check.

Do not report semicolons, quote style, `var`/`let`/`const` preference without a
reachable issue, classes versus functions, mutation versus immutability, ESM or
TypeScript migration preference, framework architecture, file size, coverage
percentage, or speculative micro-performance without a repository rule and a
concrete failure scenario.
