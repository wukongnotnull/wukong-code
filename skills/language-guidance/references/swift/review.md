# Swift Review Guidance

Report only concrete failure modes with exact files and tight lines. Zero
findings is valid.

## Check

- Forced unwrap, try, or cast reachable from input, timing, decoding, or an
  unproven invariant.
- Actionable error identity discarded by try?, an empty catch, or replacement
  with an indistinguishable result.
- Strong reference cycle, premature weak capture, or unowned capture whose
  lifetime can end first.
- Shared mutable state without valid isolation or synchronization.
- Child or unstructured task without defined completion and cancellation.
- Non-Sendable value crossing an isolation boundary or @unchecked Sendable
  without a valid synchronization invariant.
- Actor logic that assumes state is unchanged across an await suspension.
- UI or other main-actor state accessed outside its established isolation.
- API or syntax newer than the target's declared toolchain, language mode, SDK,
  or platform.
- Exported behavior changed without corresponding error, compatibility, or test
  consideration.

Do not report naming, struct-versus-class, protocol, existential-versus-generic,
test-framework, formatting, or access-control preferences without a repository
rule or reachable failure scenario. Do not invent races or retain cycles.
