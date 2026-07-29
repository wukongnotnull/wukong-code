# Rust Language Guidance Design

**Status:** Approved for implementation planning

**Date:** 2026-07-29

**Base:** `origin/dev` at `42336a0`

## Summary

Wukong Code will add a complete experimental Rust language pack to the
existing `language-guidance` skill. The pack will implement the shared
six-phase contract: project profiling, production implementation, testing,
debugging, review, and verification.

The Rust materials in affaan-m/ECC at commit
`591ab5cbd3f2f65860ea91c226e410b1502c8e2e` are candidate knowledge sources.
They will not be copied as standalone skills, agents, commands, or rules.
Every retained recommendation must be language-level, conditional on target
repository evidence, compatible with the declared Rust toolchain, and checked
against official Rust documentation or executable fixture evidence.

The first reproducible environment is a dependency-free Cargo library using
Edition 2021 and the standard test harness. Third-party crates and Cargo
extensions mentioned by ECC remain conditional: the pack may advise about
them only when the target repository already declares or configures them.

## Problem

The language-guidance router currently has complete Go and Swift vertical
slices, while Rust has no registered phase references. Rust source work
therefore receives no concrete secondary guidance for ownership, borrowing,
error contracts, trait bounds, feature resolution, concurrency, unsafe
invariants, Cargo testing, or toolchain-aware verification.

ECC contains substantial Rust material across:

- `skills/rust-patterns/SKILL.md` and `skills/rust-testing/SKILL.md`;
- `rules/rust/` coding style, hooks, patterns, security, and testing;
- `agents/rust-build-resolver.md` and `agents/rust-reviewer.md`;
- `commands/rust-build.md`, `commands/rust-review.md`, and
  `commands/rust-test.md`;
- Kiro and OpenCode adaptations of those assets;
- `examples/rust-api-CLAUDE.md`.

Those materials identify useful recurring concerns, but their original form
does not fit Wukong Code core. They duplicate existing process skills, contain
universal thresholds and style rules, assume optional crates and tools, and
mix framework guidance with language guidance. A direct transplant would
weaken progressive loading and conflict with the repository-first contract.

## Goals

- Register Rust as an experimental language in the existing router.
- Implement all six references required by the language-pack contract.
- Distill the full ECC Rust surface into correctness-relevant, condition-based
  guidance without preserving its duplicate asset structure.
- Keep brainstorming, TDD, systematic debugging, review, and verification
  skills authoritative.
- Reuse the target repository's declared Rust version, edition, features,
  commands, dependencies, test framework, and tools.
- Provide dependency-free Cargo fixtures and behavioral scenarios for every
  phase.
- Record honest RED/GREEN evidence, toolchain details, limitations, and human
  review requirements.
- Preserve existing Go and Swift behavior and packaging.

## Non-Goals

- Creating top-level `rust-patterns`, `rust-testing`, or other Rust skills.
- Adding Rust-specific agents or `/rust-build`, `/rust-review`, or `/rust-test`
  commands.
- Teaching Rust syntax or reproducing a comprehensive Rust book.
- Requiring Tokio, anyhow, thiserror, rstest, proptest, mockall, Criterion,
  SQLx, cargo-audit, cargo-deny, cargo-llvm-cov, Miri, or any other optional
  dependency or tool.
- Imposing universal coverage, function-length, allocation, `Cow`, builder,
  repository-pattern, or architecture requirements.
- Treating every `unwrap`, `expect`, `clone`, loop, wildcard match, or mutable
  variable as a defect without a reachable failure or repository rule.
- Installing a compiler, target, formatter, linter, coverage tool, dependency,
  or Cargo subcommand.
- Bundling fixes for pre-existing Codex packaging-test failures.

## Architecture and Files

The existing `language-guidance` router remains unchanged. The implementation
adds one directory and registers it:

```text
skills/language-guidance/references/rust/
├── profile.md
├── implementation.md
├── testing.md
├── debugging.md
├── review.md
└── verification.md
```

The following existing surfaces will be extended:

- `skills/language-guidance/references/registry.json` registers `.rs` and Rust
  project markers.
- `tests/skills/test-language-guidance.sh` validates the Rust pack contract.
- `tests/skills/language-guidance-scenarios.md` adds Rust behavior scenarios.
- `tests/skills/fixtures/language-guidance/rust-basic/` provides an executable
  dependency-free Cargo fixture.
- The mixed-language fixture gains a Rust target for nearest-marker routing.
- `tests/codex/test-package-codex-plugin.sh` verifies all six Rust references
  survive packaging.
- `README.md` lists Rust as Experimental only after the evidence and human
  review gates pass.
- `docs/wukong-code/evals/` records the Rust evaluation report and sanitized
  raw outputs.

The shared size limits continue to apply: `profile.md` stays at or below 160
lines and every other phase reference stays at or below 200 lines. One routing
decision loads at most two references.

## Detection and Project Evidence

Detection follows the existing priority order:

1. Rust explicitly named for the target work.
2. A target file ending in `.rs`.
3. The nearest Rust project marker above the target.
4. A repository-scope marker only when target paths are unknown.
5. No selection when evidence conflicts or remains ambiguous.

The registry will recognize these marker names:

- `Cargo.toml`;
- `Cargo.lock`;
- `rust-toolchain.toml`;
- `rust-toolchain`.

`Cargo.toml` is the primary ownership marker. A lockfile or toolchain file may
support detection, but it does not replace reading the nearest manifest before
technical advice.

After Rust is selected, the profile inspects:

- workspace membership, package ownership, targets, and manifest inheritance;
- `edition`, `rust-version`, resolver, features, and optional dependencies;
- pinned toolchain, components, targets, and CI toolchain evidence;
- nearby `.rs` and test files for error, module, concurrency, and test style;
- `build.rs`, generated files, proc macros, FFI, unsafe policy, and target cfgs;
- CI, Makefile, justfile, task scripts, formatter configuration, and lints;
- whether third-party runtimes, error crates, test helpers, security tools, or
  coverage tools are already declared.

The host compiler is not target compatibility evidence. Advice must not assume
Edition 2024, a newer MSRV, or an available nightly feature unless project
evidence establishes it.

## Phase References

### Project Profile

`profile.md` identifies the package or workspace member that owns the target,
the applicable edition and MSRV, enabled feature set, target platform, test
layout, CI commands, optional tooling, and local conventions. It distinguishes
workspace-wide facts from package-specific facts and reports uncertainty when
the active feature or target combination is unknown.

### Production Implementation

`implementation.md` applies only rules whose conditions occur in target code.
It distills ECC guidance into these boundaries:

- borrow inputs when the callee does not need ownership; take or clone values
  only when storage, transfer, isolation, or an established API contract
  requires it;
- preserve error identity and context expected by callers; use typed or
  application errors according to existing crate boundaries rather than
  introducing `thiserror` or `anyhow` automatically;
- use enums, newtypes, exhaustive matching, and trait boundaries when they make
  an actual invariant or substitution requirement explicit;
- choose generics, `impl Trait`, or trait objects from dispatch, object-safety,
  API, and performance requirements rather than a universal preference;
- use iterators or loops according to control-flow clarity and measured needs;
- keep visibility and module changes as narrow as the task requires;
- define thread/task completion, cancellation, ordering, channel ownership,
  first-error behavior, and partial-result policy before adding concurrency;
- avoid blocking an async executor and holding inappropriate guards across
  `.await`, but mention runtime-specific primitives only when that runtime is
  already present;
- require a documented safety contract for every reachable unsafe boundary and
  a local `// SAFETY:` explanation for each unsafe operation where project
  conventions require or benefit from it.

`unwrap` and `expect` are evaluated by contract: a reachable recoverable error
must not become an accidental panic, while tests and locally proven invariants
are not automatically findings. Similarly, `clone`, `Cow`, allocation, builder
patterns, and repository patterns remain contextual design choices.

### Testing

`testing.md` keeps the active TDD skill authoritative. It first inspects
existing unit, integration, documentation, async, property, mock, and benchmark
tests before selecting techniques.

A valid RED must compile far enough to execute the intended new test and fail
because requested behavior is missing. Syntax errors, borrow-checker errors in
the test, unavailable tools, feature-resolution failures, and unrelated test
failures are invalid RED evidence.

Focused commands are derived from repository evidence and may use Cargo
package, test target, feature, or exact test filters. Broader workspace runs
follow only after the focused cycle. Property testing, mocking, benchmarking,
coverage, and async test attributes are recommended only when the repository
already uses or explicitly requests their supporting tools. The pack does not
set a universal coverage percentage.

### Debugging

`debugging.md` keeps systematic debugging authoritative and classifies evidence
before proposing fixes:

- parser, name-resolution, type, trait-bound, borrow, move, and lifetime
  diagnostics with exact error codes and spans;
- feature, dependency, resolver, workspace, lockfile, target, edition, and MSRV
  mismatches;
- failing focused tests, panics, and nondeterministic repetitions;
- non-`Send` futures, blocking executor work, lost cancellation, blocked sends,
  lock ordering, poisoning, and task/thread lifetime;
- unsafe invariant violations, FFI boundaries, aliasing, layout, and ownership;
- build scripts, proc macros, generated sources, cfg selection, linking, and
  platform/toolchain mismatch.

The workflow reproduces the smallest failing target, reads the full diagnostic
and affected ownership context, tests one causal hypothesis at a time, and
applies the smallest intent-preserving fix. It never uses `unsafe`, blanket
`allow` attributes, arbitrary clones, or panics merely to silence a compiler
error.

### Review

`review.md` permits zero findings. Every finding must identify tight lines, a
reachable failure scenario, and the violated contract. It checks:

- accidental panic or discarded error on a reachable production path;
- lost error identity or context required by callers;
- invalid borrow, move, lifetime, resource, or ownership transfer assumptions;
- unsafe blocks or declarations with incomplete or false invariants;
- unsynchronized shared state, task/thread leaks, deadlocks, blocking async
  work, invalid `Send`/`Sync`, or unclear channel-close ownership;
- SQL, command, path, secret, and untrusted-deserialization boundaries when
  those operations occur;
- behavior compiled under the wrong feature, target, edition, or toolchain;
- public API or serialized representation changes without contract-aware tests.

Naming, derive order, function length, nesting depth, loop style, allocation,
`String` versus `&str`, use of `Cow`, wildcard matching, or visibility are not
findings without repository evidence or a concrete failure mechanism.

### Verification

`verification.md` keeps verification-before-completion authoritative and
chooses commands in this order:

1. CI and repository documentation.
2. Existing repository scripts and build wrappers.
3. Tools and components declared by the project.
4. Safe official Cargo/rustc/rustfmt/Clippy defaults.
5. An explicit unknown or skipped result when evidence is insufficient.

Safe defaults may include focused `cargo test`, `cargo check`,
`cargo fmt --check`, `cargo clippy`, and a broader workspace command when their
scope matches the change. `--workspace`, `--all-targets`, `--all-features`,
`--no-default-features`, target triples, release builds, doc tests, examples,
and benches are selected from project and task evidence rather than added
ritually.

Cargo extensions such as audit, deny, llvm-cov, and Miri are run only when
configured and available. Missing tools are reported, never installed.
Verification reports exact commands, exit codes, test counts when available,
active features and targets, formatting output, skipped checks, and unverified
combinations. No single Cargo command is claimed to prove every concern.

## Cargo Fixture

The initial fixture is a dependency-free library under
`tests/skills/fixtures/language-guidance/rust-basic/`. Its manifest declares
Edition 2021 and a concrete `rust-version` supported by the recorded evaluator
toolchain.

The library exposes a small sequential batch-processing boundary over a trait
or closure supplied by the caller. The implementation scenario asks the agent
to process independent inputs concurrently with the standard library while:

- preserving input order in successful results;
- returning an error according to a stated first-observed contract;
- joining all started work before return;
- avoiding detached threads and blocked channel sends;
- making ownership of inputs, results, and channel closure explicit;
- adding no dependency.

The checked-in fixture remains simple and passing. Scenarios request a proposed
or implemented change without storing the completed concurrent solution in the
baseline fixture.

The mixed-language fixture places a Rust crate near the Rust target and an
unrelated language marker in a sibling or repository root. The nearest
`Cargo.toml` must win.

## Static Tests

Static tests will verify:

- the registry contains exactly the implemented languages and valid status;
- Rust extension, markers, phases, and paths match the shared contract;
- all six Rust files exist and satisfy size limits;
- language guidance contains no installer or global-configuration command;
- the Rust fixture has a valid dependency-free manifest, source target, and
  test target;
- README status and evidence links agree with registry status;
- Codex packaging retains every Rust reference;
- existing Go and Swift contract assertions remain intact.

Tests must begin RED against the pre-Rust `dev` state and pass after the
implementation. Existing assertions must be extended rather than weakened.

## Behavioral Evaluation

Fresh-session scenarios cover:

1. Rust production implementation with ordering, joining, ownership, and
   errors.
2. TDD pressure to skip a valid RED run.
3. Diagnosis of an intermittent hang, deadlock, non-`Send` future, or borrow
   failure without premature editing.
4. Review that reports only concrete Rust correctness failures.
5. Exact completion verification for the Cargo fixture.
6. Nearest-marker selection in a mixed-language repository.
7. An unsupported-language negative control.
8. A documentation-only negative control.

The RED baseline uses the current `dev` checkout without Rust registration and
references. Candidate GREEN runs use fresh sessions and preserve complete raw
responses. Positive routing scenarios run repeatedly; debugging, review, and
verification receive at least two runs each.

Adversarial prompts pressure the agent to:

- skip RED because production is blocked;
- add Tokio, anyhow, or another familiar dependency without repository
  evidence;
- assume Edition 2024 or a newer MSRV from the host compiler;
- install cargo-audit, cargo-deny, cargo-llvm-cov, Miri, or another tool;
- report style preferences as correctness defects;
- use `unsafe`, `clone`, `allow`, or panic as a compiler-error shortcut;
- claim one `cargo test` run proves formatting, linting, security, every
  feature, and every target.

The report separates static structure, fixture execution, explicit
`$language-guidance` routing, automatic advisory routing, repeated behavior,
and packaging. No aggregated pass claim may hide failed or missing runs.

## Source and Evidence Policy

ECC candidate material is pinned to commit
`591ab5cbd3f2f65860ea91c226e410b1502c8e2e`. The implementation report will
map retained topics back to the inspected ECC files without copying their
large examples or behavior-shaping wording.

Normative semantic checks use primary Rust sources, including:

- The Rust Reference and standard library documentation;
- The Cargo Book and Cargo command documentation;
- The Rust Edition Guide and rustc error-code explanations;
- official rustfmt and Clippy documentation;
- The Rustonomicon and Unsafe Code Guidelines where applicable;
- official Rust testing, concurrency, async, and FFI documentation.

Optional third-party behavior is sourced from that tool or crate's primary
documentation only when repository evidence makes it applicable. Executable
fixture behavior and the target repository override generic examples.

## Baseline Limitations

The approved `dev` baseline is `42336a0`. These checks pass before Rust work:

- `bash tests/skills/test-language-guidance.sh`;
- `bash tests/skills/test-skill-slim-gates.sh`;
- `bash tests/opencode/run-tests.sh`;
- `bash tests/kimi/run-tests.sh`.

`bash tests/codex/test-package-codex-plugin.sh` has pre-existing failures:

- a linked worktree is rejected because the packaging script expects `.git` to
  be a directory rather than accepting a worktree `.git` file;
- in a normal `dev` clone under the Asia/Shanghai environment, ZIP and tar
  timestamp assertions differ by timezone representation.

The human partner approved recording these failures and continuing without
bundling fixes. Rust packaging verification must still demonstrate that new
references are present. Results must distinguish inherited failures from new
Rust regressions.

## Release and Review Gates

Before Rust changes from absent to Experimental in README, implementation must
have:

- failing static controls captured before guidance is written;
- repeated candidate behavior runs with preserved raw evidence;
- a passing Cargo fixture on a recorded rustc/cargo toolchain and platform;
- relevant repository regression results with all failures reported honestly;
- an evaluation report with known limitations and maintenance responsibility;
- review by a human familiar with Rust;
- review of the complete diff by the human partner.

No pull request will be opened until repository duplicate search, complete PR
template preparation, authoring-environment disclosure, full diff review, and
explicit submission approval are complete. Any future PR targets `dev`.

## Risks and Mitigations

### ECC rules become universal mandates

Mitigation: express observable applicability and exceptions; reject fixed
coverage, function-size, architecture, crate, and style requirements unless
the target repository declares them.

### Compiler advice ignores edition, MSRV, features, or target

Mitigation: profile the nearest manifest and CI first; treat the host toolchain
as execution evidence only, not target compatibility evidence.

### Dependency-rich examples leak into zero-dependency repositories

Mitigation: keep the fixture standard-library-only and mention optional crates
or Cargo extensions only when already declared or explicitly requested.

### Ownership guidance creates unnecessary clones or unsafe workarounds

Mitigation: require an ownership and lifetime explanation tied to the data-flow
contract; never accept `clone` or `unsafe` solely because compilation succeeds.

### Async and synchronization advice assumes a runtime

Mitigation: keep core reasoning runtime-neutral and load runtime-specific
primitives only from target repository evidence.

### Review reports stylistic preferences as defects

Mitigation: require location, reachable failure scenario, affected contract,
and version/feature evidence for every finding; zero findings is valid.

### Verification overclaims feature or platform coverage

Mitigation: record exact packages, features, targets, profiles, toolchain,
commands, and skipped combinations. One passing command proves only its scope.

### Existing packaging failures obscure regressions

Mitigation: preserve the approved baseline, compare exact failures, and add
Rust-specific archive-presence assertions that can be evaluated separately.

## Acceptance Criteria

- Rust is registered as Experimental with the approved extension and markers.
- Every Rust reference follows the shared six-phase contract and size limits.
- The content covers the approved ECC concerns without duplicate top-level
  skills, agents, commands, framework leakage, or dependency mandates.
- The dependency-free Cargo fixture passes on a recorded toolchain.
- Static and behavior evidence distinguishes passes, failures, inherited
  baseline limitations, and unverified targets.
- Existing Go and Swift routing, negative controls, and package references do
  not regress.
- README status and evidence links match actual recorded results.
- A Rust-aware human and the human partner approve the language content and
  complete diff before any pull request is opened.
