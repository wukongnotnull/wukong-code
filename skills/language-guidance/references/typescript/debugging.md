# TypeScript Debugging Guidance

Systematic debugging remains authoritative. Reproduce with the repository
command and classify checker, emit, loader, and runtime evidence before editing.

## Keep Failure Classes Separate

- Checker: retain the full diagnostic, primary span, effective config, compiler
  version, project-reference owner, included files, and relevant narrowing or
  generic relationship.
- Resolution: capture the importing file and specifier, resolution trace when
  available, `moduleResolution`, paths/base URL, extension rules, package
  `type`/`exports`/`imports` conditions, and whether the failure is checker-only,
  transform-time, or runtime.
- Emit/runtime shape: compare source imports, emitted specifiers and module
  syntax, declaration output, package metadata, loader/runtime, and the actual
  artifact executed. Type-check success does not make incompatible output load.
- Stale artifacts: identify which command owns generated JavaScript,
  declarations, build info, caches, and source maps before treating an old file
  or shifted stack location as current source behavior.
- Runtime boundary: retain the external value and validation path; an assertion
  can hide a checker warning but cannot repair malformed data.
- Async/test lifecycle: trace promise creation and observation, rejection,
  result ordering, cancellation ownership, timers, fake clocks, open handles,
  cleanup, and every started operation that must complete.

Do not change module settings before reproducing the resolver mismatch in both
the TypeScript resolver and the actual runtime or bundler path. Do not toggle
`module`, `moduleResolution`, paths, extensions, interop flags, `skipLibCheck`,
or package metadata merely because a familiar setting removes one diagnostic.

When CI hangs or import evidence is incomplete, do not rank a root cause. Keep
module resolution, emitted/runtime module shape, package export conditions,
stale output, unobserved async completion or rejection, cancellation, timers or
open handles, and unrelated slow work as distinct hypotheses until one is
reproduced.

Read affected callers and output, test one causal hypothesis, make the smallest
intent-preserving change, and rerun the focused reproducer before broader checks.
Never delete caches or generated output until ownership evidence shows staleness
is causal.
