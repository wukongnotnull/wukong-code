# Java Review Guidance

Report only concrete failure modes with exact files and tight lines. Zero findings is valid.

## Check Reachable Contracts

- Owned `AutoCloseable` resources leak, close on the wrong lifecycle, or lose a
  primary exception/interrupt contract.
- Input, timing, or integration paths can reach an unintended null,
  `Optional.get()`, unchecked cast, raw generic boundary, or discarded error.
- Callers can mutate state that was promised isolated, or `equals` and
  `hashCode` violate a collection-reachable value contract.
- Executors, tasks, and threads outlive their owner; cancellation or
  interruption is discarded; shared mutable state lacks a synchronization
  invariant; or lock order can deadlock under a reachable sequence.
- Code uses a language, platform API, module, or linkage contract incompatible
  with the declared JDK/toolchain, or changes public/serialized behavior
  without appropriate compatibility and test consideration.

Every finding needs a location, reachable failure scenario, violated contract,
and relevant build/version evidence. Do not report preferences for records,
streams, `var`, annotations, package layout, test framework, framework
architecture, formatting, or speculative performance without a repository rule
and concrete failure scenario. Do not invent races or compatibility failures.
