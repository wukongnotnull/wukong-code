# Rust Verification Guidance

Verification-before-completion remains authoritative. Choose commands in this
order: CI/docs, repository scripts and wrappers, declared tools/components,
safe official Cargo defaults, then an explicit skipped or unknown result.

For a Cargo package, select only checks relevant to the change:

    cargo test --test '<target>' '<test-name>' -- --exact
    cargo test
    cargo check
    cargo fmt --check
    cargo clippy

Choose package, workspace, target, profile, default/all/no-default features,
doc tests, examples, and benches from repository and task evidence. Do not add
flags ritually. A focused test does not prove the workspace; cargo test does
not prove formatting, every lint, security, every feature, or every target.

Run cargo-audit, cargo-deny, cargo-llvm-cov, Miri, or another extension only
when configured and available. Missing Cargo extensions are reported, never
installed.

Report exact commands, exit codes, test counts when available, compiler,
package, features, target, profile, formatting/lint output, skipped checks, and
unverified combinations. For unsafe, FFI, generated code, proc macros, or cfg
branches, state the exact configuration exercised and remaining coverage.
