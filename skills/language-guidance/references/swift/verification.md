# Swift Verification Guidance

Verification-before-completion remains authoritative. Choose commands from
CI/docs, repository scripts, declared tools, then safe official-toolchain
defaults.

For a SwiftPM package, select only commands relevant to the change:

    swift package dump-package
    swift test --filter '<existing-test-identifier>'
    swift test
    swift build

Manifest inspection does not replace compilation, and a focused test does not
replace the broader suite. Run a declared formatter or linter only when its
repository configuration and executable are present; do not install it.

For Xcode work, use the repository's scheme, destination, and command. Do not
guess signing, simulator, or platform settings. SwiftPM success is not Xcode
verification.

Report exact commands, exit codes, test counts when available, compiler and
platform, formatting output, skipped checks, and unverified targets. For
conditional compilation, generated code, C interoperability, or Apple-only
APIs, state the exact configuration exercised and remaining coverage.
