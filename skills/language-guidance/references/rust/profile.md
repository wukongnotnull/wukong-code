# Rust Project Profile

## Inspect Before Advising

1. Read the nearest Cargo.toml first. Cargo.toml is the ownership source for
   package, workspace, target, edition, rust-version, resolver, feature, and
   dependency decisions.
2. Inspect workspace membership and inherited fields; distinguish root facts
   from the package that owns the target file.
3. Read Cargo.lock and rust-toolchain files as supporting evidence, not a
   substitute for the owning manifest.
4. Inspect nearby source and tests for module, error, ownership, concurrency,
   unsafe, and test conventions.
5. Read CI, scripts, build wrappers, rustfmt configuration, lints, and declared
   Cargo extensions before choosing commands.
6. Check build.rs, proc macros, generated sources, FFI, cfgs, target triples,
   and enabled features when they can affect the task.

## Compatibility Boundaries

- The host compiler is execution evidence, not target compatibility evidence.
- Require manifest, toolchain, CI, or accepted project evidence before using a
  newer edition, MSRV, nightly feature, target API, or optional component.
- The nearest owning package wins over unrelated root or sibling markers.
- State uncertainty when active features, target, profile, or generated inputs
  are unknown. Do not silently assume all-features or the host platform.
- Preserve existing runtimes, error crates, test frameworks, and command
  wrappers. Mention an optional crate or Cargo extension only when the target
  already declares/configures it or the task explicitly adds it.
