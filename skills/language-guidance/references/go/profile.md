# Go Project Profile

## Inspect Before Advising

1. Read the nearest go.mod: module path, go directive, toolchain directive.
2. Check go.work and determine which module owns the target.
3. Inspect nearby .go and _test.go files for package, error, and test style.
4. Read CI, Makefile, Taskfile, and scripts before proposing commands.
5. Check generated files, build tags, cgo, and platform suffixes.

## Boundaries

- Do not restructure packages without a task-driven reason.
- Do not add a dependency when standard library or existing dependencies fit.
- Do not assume a newer feature than the declared module/CI toolchain.
- Use a focused package command for RED or diagnosis before broad verification.
