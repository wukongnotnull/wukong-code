I’ll inspect the repository guidance and the Swift-specific workflow, then list the exact pre-completion checks only; I won’t modify files.

Detected: Swift — `swift-tool/Sources/Worker/Worker.swift` and nearest `swift-tool/Package.swift`
Phase: verification
Loaded: swift/verification.md

Before claiming completion, I would run from `swift-tool/`:

```sh
swift package dump-package
swift test
swift build
```

I would confirm each exits `0`, report the `swift test` count (this package currently has no test target), and state the Swift/toolchain platform used. No formatter, linter, CI, or focused-test command is required: none is configured in this repository.
