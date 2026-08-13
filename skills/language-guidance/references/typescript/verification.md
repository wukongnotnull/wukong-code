# TypeScript Verification Guidance

Verification-before-completion remains authoritative. Choose commands in this
order: CI/docs, repository scripts, declared local tools, a safe official
compiler fallback only when already available, then an explicit skipped or
unknown result. Never install a missing compiler, runner, formatter, or linter.

## Select Evidence by Contract

- Type check: use the owning script/config and declared compiler version. When
  no repository command exists and a compatible local compiler is present, a
  conditional fallback is `./node_modules/.bin/tsc --noEmit -p
  <owning-tsconfig>`.
- Build/emission: run the established build or emit command when output syntax,
  transforms, assets, source maps, or package layout matter.
- Runtime tests: run the configured runner, transform/loader, environment, and
  focused selector before broader suites.
- Type and declaration tests: run their established diagnostic/API oracle;
  separately inspect generated declarations or downstream consumers when public
  types changed.
- Lint/format/coverage: run only configured scripts and tools already present.
- Integration: exercise the supported runtime, bundler, package export
  conditions, project references, and target variants established by the task,
  CI, or repository—not an invented matrix.

Type checking does not prove runtime execution, tests, bundling, emitted module
compatibility, declaration usability, formatting, or integration behavior. A
runtime test pass likewise does not prove the checker or public declarations.

`tsc --noEmit` is not a universal default: it requires an available compatible
compiler and the correct owning config. It may omit build transforms, runtime
resolution, test discovery, declaration emit, and referenced projects not
covered by that invocation. Use the repository's solution/project-reference
command when one exists; do not add `--build`, `--force`, or config flags by
ritual.

Report exact commands, exit codes, compiler source/version when known, owning
config, runner/transform and runtime, reached tests, emitted/declaration scope,
skipped checks, and unverified configs or environments. Never turn an assumed,
missing, or unrun command into passing evidence.
