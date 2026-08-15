# TypeScript Project Profile

## Inspect Before Advising

1. Find the nearest `tsconfig.json` that includes the target file. Read its
   `extends` chain, `files`/`include`/`exclude`, project `references`, and any
   build or test configs that own a different source set.
2. Establish the project compiler version from a lockfile, package manager
   metadata, script, wrapper, or CI. A host `tsc` version is execution evidence,
   not project compatibility evidence.
3. Read `target`, `lib`, `module`, `moduleResolution`, `moduleDetection`, `jsx`,
   `strict` and related checks, path aliases, declaration/output/source-map
   settings, generated inputs, and whether files are emitted or transformed by
   another tool.
4. Read the nearest package metadata, including `type`, `exports`, `imports`,
   `types`, and relevant workspace ownership. Inspect scripts, CI, test and lint
   configuration, nearby source/tests, supported runtimes, and deployed output.

## Compatibility Boundaries

- The owning tsconfig and emitted runtime model control compatibility. Compiler
  module resolution must model the runtime or bundler that consumes the emitted
  specifiers; `.ts` alone does not establish Node, DOM, Bun, Deno, React, or a
  bundler.
- `target` controls emitted JavaScript syntax while `lib` controls available
  ambient APIs. Neither proves that a runtime, polyfill, or platform API exists.
- Follow the effective configuration after `extends`, and distinguish a
  solution config from the referenced project that owns the file. Declaration
  output from project references can affect downstream compatibility.
- One `tsconfig` cannot safely describe multiple incompatible runtime
  environments. Browser, server, worker, test, and tooling sources need their
  established configs or an explicit scoped migration; do not merge their
  ambient globals or module assumptions by convenience.
- Preserve configured scripts, transforms, test runners, JSX mode, generated
  code boundaries, public declaration layout, and path mapping. Do not infer
  that a checker-only alias or import rewrite works at runtime.
