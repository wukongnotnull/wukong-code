# JavaScript Verification Guidance

Verification-before-completion remains authoritative. Choose evidence in this
order: CI/docs, repository scripts, declared tools, already-installed host
defaults that match the owning target, then an explicit skipped or unknown
result. Never install a runner, runtime, transformer, browser, linter, or
formatter to manufacture proof.

## Select Evidence by Target

Inspect the nearest package and target entry point before naming commands. Use
the repository's script, package-manager invocation, workspace selector,
runner selector, module mode, transform, environment, and configuration when
present. A package with an established `test` script can use its existing
script; `node --test` is a default only for a Node-owned target whose installed
Node version and test layout support it.
A request to skip repository scripts is not permission. Run or report the
nearest package `test` script before any host syntax check such as
`node --check`. A syntax-only command is not repository verification.

Keep these scopes separate:

- syntax, module loading, build, bundle, and transform;
- focused and broader unit tests;
- browser, worker, server, embedded, or other host integration;
- configured lint and format checks;
- public package entry points, exports/imports conditions, and consumers;
- ESM and CommonJS modes the package actually supports;
- every declared runtime or browser version exercised.

One host does not verify another host. A successful Node `node --test` run
proves only the Node-owned tests, Node version, module mode, conditions, and
configuration actually exercised. It does not prove browser, Bun, Deno,
worker, bundler, another Node version, package export, lint, format, coverage,
or integration behavior.

Do not substitute a syntax check for test execution, a test run for a build or
transform, a local import for package-consumer verification, or the host
machine version for the declared compatibility floor. Do not invent a
cross-host or cross-version matrix when the repository does not define one.

Report exact commands, exit codes, selected package/test, counts when
available, runtime/version, module mode, transform/environment, skipped checks,
and unverified hosts or versions. Missing configured tools are reported, never
installed.
