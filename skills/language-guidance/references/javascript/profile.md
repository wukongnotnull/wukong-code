# JavaScript Project Profile

JavaScript syntax does not identify its host environment. Establish the target
and its ownership boundary before recommending APIs, module rules, commands, or
compatibility changes.

## Inspect Before Advising

1. Start with the target extension and nearest `package.json`; inspect target
   files and nearby imports before using a root or sibling marker.
2. Read package `type`, scripts, engines, exports/imports, workspaces, and the
   owning package boundary. A lockfile proves package-manager evidence only; it
   does not establish the runtime, script, or package that owns the target.
3. Read runtime configuration, bundler/transpiler configuration, HTML,
   service-worker and worker entry points, JSX transform settings, tests,
   lint/format configuration, CI, generated-code boundaries, and deployment
   declarations relevant to the target.
4. Record each supported host and version from repository evidence: Node,
   browser engines, Bun, Deno, workers, an embedded runtime, or another host.
   Host globals and built-in modules apply only where that host owns execution.

## Module and Compatibility Boundaries

- `.mjs` and `.cjs` explicitly distinguish ESM and CommonJS in Node. A `.js`
  file's module treatment depends on the owning host, nearest package rules,
  loader, or transform; JavaScript alone does not select one.
- `.jsx` establishes JSX syntax, not React, a transform, a runtime, or browser
  execution. Inspect the configured transform and entry point.
- `package.json` is an ownership marker, not proof that every descendant runs
  in Node. Browser bundles, build scripts, workers, and published entry points
  can have different hosts and module contracts inside one package.
- The nearest target package and explicit target extension beat unrelated root
  or sibling markers. A `.ts` or `.tsx` target remains TypeScript even beside a
  JavaScript package marker.
- The host machine version is execution evidence, not target compatibility
  evidence. Use engines, CI, deployment, browserslist or equivalent declared
  policy, and configured transforms before selecting syntax or APIs.
- Preserve established package manager, runner, transform, formatter, linter,
  generated output, and source layout. Do not introduce a host, framework,
  dependency, or configuration merely because JavaScript permits it.
