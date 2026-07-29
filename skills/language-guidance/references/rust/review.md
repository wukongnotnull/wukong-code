# Rust Review Guidance

Report only concrete failure modes with exact files and tight lines.
Zero findings is valid.

## Check Reachable Contracts

- Recoverable production input or timing failure becomes a panic or discarded
  error, or required error identity/context is lost.
- A borrow, move, lifetime, drop order, resource, or ownership transfer rests
  on an invalid assumption.
- Unsafe code has an incomplete or false caller/callee invariant.
- Shared state lacks required synchronization; tasks or threads leak; sends can
  block forever; lock order can deadlock; async code blocks the executor; or a
  Send/Sync claim is invalid.
- SQL, command, path, secret, or untrusted-deserialization handling violates a
  concrete boundary when that operation is present.
- Behavior compiles under the wrong feature, target, edition, MSRV, or
  toolchain, or a public/serialized contract changes without tests.

Every finding needs location, reachable scenario, violated contract, and
relevant version/feature evidence. Do not report naming, derive order, function
length, nesting, loop style, allocation, String versus &str, Cow, wildcard
matches, clone, or visibility without a repository rule or concrete failure.
Do not invent races, undefined behavior, or performance regressions.
