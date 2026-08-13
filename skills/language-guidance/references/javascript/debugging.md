# JavaScript Debugging Guidance

Systematic debugging remains authoritative. Reproduce under the owning runtime and module mode before changing code or configuration.

## Classify the Boundary

- Parse and load: retain the exact syntax diagnostic, target file extension,
  nearest package `type`, loader/transform, import path, entry point, and host.
- Resolution and interop: inspect package exports/imports, conditions, default
  and named exports, ESM/CommonJS direction, path/URL rules, generated output,
  and the runtime or bundler that owns resolution.
- Host: identify the missing or different global/API and prove whether the
  affected path runs in Node, a browser context, a worker, Bun, Deno, a test
  environment, or another configured host.
- Values: retain the external input and distinguish absent properties,
  `undefined`, `null`, coercion, own/inherited lookup, mutation, and aliasing.
- Async: trace promise creation, handling, fulfillment/rejection, result and
  error ordering, awaited/owned work, and cleanup. A rejected aggregate does not
  prove remaining operations stopped.
- Liveness: inspect active timers, listeners, streams, sockets, workers, open
  handles, pending tasks, cancellation propagation, timer/microtask ordering,
  and unrelated slow work as separate hypotheses.
- Transforms: compare source to the executed artifact and source map; retain the
  exact bundler/transpiler mode, cache key, generated output, and CI command.

When evidence is absent, do not select a leading, likely, or most likely cause.
Keep module mode, host APIs, promise settlement, event-loop liveness,
cancellation, stale transformed output, and unrelated slow work distinct until
a focused reproducer eliminates branches.

Read the affected entry point and callers, test one causal hypothesis, then
change the smallest intent-preserving boundary. Do not change package `type`,
file extensions, exports/imports, transforms, runtime versions, lockfiles,
caches, or dependencies before evidence identifies them as causal.
