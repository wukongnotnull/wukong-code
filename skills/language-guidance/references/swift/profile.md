# Swift Project Profile

## Inspect Before Advising

1. Read the nearest Package.swift first line, products, targets, platforms,
   dependencies, Swift settings, and language modes.
2. For Xcode projects, inspect repository schemes, project settings, CI, and
   the exact target before selecting a command or platform.
3. Inspect nearby Sources and Tests for module layout, access control, error
   style, concurrency boundaries, and Swift Testing or XCTest usage.
4. Read CI, scripts, formatter, and lint configuration before proposing tools.
5. Check generated sources, conditional compilation, C or Objective-C
   interoperability, SDK availability, and platform-specific files.

## Version and Target Boundaries

- The swift-tools-version controls manifest APIs and minimum package tools; it
  does not prove every target uses the host's newest language behavior.
- Require declared toolchain, language-mode, or build-setting evidence before
  using version-specific features such as default actor isolation,
  nonisolated-nonsending behavior, isolated conformances, or @concurrent.
- The nearest package or Xcode target owns the source; unrelated root markers
  and sibling projects do not override it.
- Preserve the repository's test framework and commands. Swift Testing and
  XCTest can coexist; do not migrate frameworks without task scope.
- Report the verified toolchain and platform. SwiftPM success does not prove an
  Xcode scheme, simulator destination, code-signing path, or Apple-only API.
