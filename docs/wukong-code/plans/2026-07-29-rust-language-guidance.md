# Rust Language Guidance Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use
> `wukong-code:subagent-driven-development` (recommended) or
> `wukong-code:executing-plans` to implement this plan task by task. Invoke
> `wukong-code:writing-skills` for every task that changes or evaluates the
> behavior-shaping references. Use the checkboxes as the execution record.

**Goal:** Add a complete, evidence-backed experimental Rust pack to the
existing `language-guidance` router, distilling the full ECC Rust surface
without importing its duplicate skills, agents, commands, dependency mandates,
or project-specific architecture.

**Architecture:** Keep the router and shared six-phase language-pack contract
unchanged. Register Rust alongside Go and Swift, add six progressively loaded
Rust references, and validate them with a dependency-free Edition 2021 Cargo
fixture. Repository evidence controls edition, MSRV, features, runtime,
dependencies, tests, and tools; official Rust documentation and executable
fixture behavior control semantic claims.

**Tech Stack:** Markdown skills, JSON, Bash, Python standard library, Cargo,
rustc, rustfmt, the standard Rust test harness, standard-library scoped
threads, existing Codex packaging tests, and fresh-session behavior evals.

## Starting Point

- Worktree: `/Users/wukong/Documents/wukong-code/.worktrees/rust-language-guidance`
- Branch: `codex/rust-language-guidance`
- Base: `origin/dev` at `42336a0`
- Approved design:
  `docs/wukong-code/specs/2026-07-29-rust-language-guidance-design.md`
- Design commits already present:
  - `021c88e docs: design Rust language guidance`
  - `d21a866 docs: resolve Rust design review findings`
- ECC source is pinned at
  `affaan-m/ECC@591ab5cbd3f2f65860ea91c226e410b1502c8e2e`.
- Recorded local tools: `rustc 1.97.1` and `cargo 1.97.1`. These are execution
  evidence only; they are not target compatibility evidence.
- Existing approved baseline passes:
  - `bash tests/skills/test-language-guidance.sh`
  - `bash tests/skills/test-skill-slim-gates.sh`
  - `bash tests/opencode/run-tests.sh`
  - `bash tests/kimi/run-tests.sh`
- Existing Codex package-test limitations are not part of this change:
  - linked worktrees are rejected because the script expects `.git` to be a
    directory;
  - an ordinary Asia/Shanghai clone has two timestamp expectation failures.
  Rust archive assertions must pass independently and no result may hide these
  inherited failures.

## Global Constraints

- Change one language pack only. Do not alter Go or Swift semantics.
- Do not create top-level Rust skills, Rust agents, slash commands, hooks, or
  framework packs.
- Add no third-party dependency. Do not install or update Rust, a target,
  component, Cargo extension, formatter, linter, test helper, or crate.
- Never prescribe Tokio, anyhow, thiserror, rstest, proptest, mockall,
  Criterion, cargo-audit, cargo-deny, cargo-llvm-cov, or Miri unless the target
  repository already declares/configures it or the human partner explicitly
  requests it.
- Never infer Edition 2024, nightly, a newer MSRV, feature set, target triple,
  runtime, or optional tool from the host environment.
- Keep `profile.md` at or below 160 lines and every other Rust phase reference
  at or below 200 lines. A routing decision loads at most two references.
- Keep brainstorming, TDD, systematic debugging, review, and verification
  process skills authoritative.
- Treat compile-fail doctests, UI tests, and compiler-diagnostic tests as valid
  RED only when an established harness reaches the intended compile assertion.
- For the fixture's concurrent scenario, join every started worker and select
  the error for the lowest failing input index. Completion order is not the API
  contract.
- The fixture declares `rust-version = "1.63"` because
  [`std::thread::scope`](https://doc.rust-lang.org/std/thread/fn.scope.html)
  stabilized in Rust 1.63. The manifest declaration remains the compatibility
  boundary even when tests run on a newer compiler.
- README remains `Planned` until repeated candidate/adversarial runs, fixture
  evidence, and a Rust-aware human review pass.
- Preserve all unrelated human-partner changes. Never stage unrelated files.
- Do not open a PR. PR preparation is a later, separately approved action and
  must follow the repository's duplicate-search, disclosure, full-template,
  full-diff approval, and `dev`-target rules.

## Primary Sources

Check retained language semantics against maintained primary sources before
committing the pack:

- https://doc.rust-lang.org/reference/
- https://doc.rust-lang.org/std/
- https://doc.rust-lang.org/cargo/reference/
- https://doc.rust-lang.org/edition-guide/
- https://doc.rust-lang.org/error_codes/
- https://doc.rust-lang.org/clippy/
- https://doc.rust-lang.org/rustfmt/
- https://doc.rust-lang.org/rustdoc/
- https://doc.rust-lang.org/std/thread/fn.scope.html
- https://doc.rust-lang.org/reference/unsafe-keyword.html

The Rustonomicon and Unsafe Code Guidelines are supplementary, non-normative
background only. When they disagree with the Rust Reference or standard
library contracts, the maintained Reference and API documentation win.

## File Map

| Path | Responsibility |
| --- | --- |
| `skills/language-guidance/references/registry.json` | Register Rust identifiers, markers, status, and phases |
| `skills/language-guidance/references/rust/profile.md` | Cargo ownership, edition, MSRV, feature, target, and tool discovery |
| `skills/language-guidance/references/rust/implementation.md` | Ownership, errors, traits, concurrency, async, and unsafe boundaries |
| `skills/language-guidance/references/rust/testing.md` | Rust-aware RED/GREEN and test-scope guidance |
| `skills/language-guidance/references/rust/debugging.md` | Compiler, Cargo, concurrency, build, and unsafe diagnosis |
| `skills/language-guidance/references/rust/review.md` | Reachable Rust correctness findings only |
| `skills/language-guidance/references/rust/verification.md` | Repository-first Cargo verification and honest scope reporting |
| `tests/skills/fixtures/language-guidance/rust-basic/` | Dependency-free executable Cargo fixture |
| `tests/skills/fixtures/language-guidance/monorepo/rust-worker/` | Nearest-marker Rust fixture |
| `tests/skills/language-guidance-scenarios.md` | Fixed Rust prompts and scoring contract |
| `tests/skills/test-language-guidance.sh` | Registry, file, size, fixture, wording, and safety gates |
| `tests/codex/test-package-codex-plugin.sh` | Verify all Rust references survive packaging |
| `docs/wukong-code/evals/2026-07-29-rust-language-guidance.md` | Actual RED/GREEN/adversarial/toolchain evidence |
| `docs/wukong-code/evals/raw/2026-07-29-rust-language-guidance/` | Sanitized complete run records |
| `README.md` | Planned row first; Experimental only after publication gates |
| `docs/testing.md` | Reproduction commands and eval instructions |

---

### Task 1: Add Cargo fixtures, fixed scenarios, and behavior RED

**Files:**

- Create: `tests/skills/fixtures/language-guidance/rust-basic/.gitignore`
- Create: `tests/skills/fixtures/language-guidance/rust-basic/Cargo.toml`
- Create: `tests/skills/fixtures/language-guidance/rust-basic/src/lib.rs`
- Create: `tests/skills/fixtures/language-guidance/rust-basic/tests/batch.rs`
- Create: `tests/skills/fixtures/language-guidance/monorepo/rust-worker/.gitignore`
- Create: `tests/skills/fixtures/language-guidance/monorepo/rust-worker/Cargo.toml`
- Create: `tests/skills/fixtures/language-guidance/monorepo/rust-worker/src/lib.rs`
- Modify: `tests/skills/language-guidance-scenarios.md`
- Create after real runs:
  `docs/wukong-code/evals/2026-07-29-rust-language-guidance.md`
- Create after real runs:
  `docs/wukong-code/evals/raw/2026-07-29-rust-language-guidance/baseline.md`

**Interfaces:**

- Consumes the existing Go/Swift-only registry and current process skills.
- Produces a passing sequential Cargo control with a deterministic future
  concurrency contract, nearest-marker evidence, fixed prompts, and honest
  evidence that no registered Rust pack exists yet.

- [ ] **Step 1: Reconfirm the task boundary and toolchain**

Invoke `wukong-code:writing-skills` and
`wukong-code:test-driven-development`. Then run:

```bash
git status --short
git rev-parse HEAD
rustc --version --verbose
cargo --version --verbose
```

Expected: only approved design/plan commits are present, and exact platform and
tool versions are captured in the eventual report. Do not claim the installed
1.97 toolchain verifies MSRV 1.63 unless an actual 1.63 toolchain is already
available and used without installation.

- [ ] **Step 2: Create the dependency-free basic fixture**

Create `.gitignore`:

```gitignore
/target/
/Cargo.lock
```

Create `Cargo.toml`:

```toml
[package]
name = "rust-language-guidance-fixture"
version = "0.1.0"
edition = "2021"
rust-version = "1.63"
publish = false

[lib]
path = "src/lib.rs"
```

Create `src/lib.rs`:

```rust
pub trait Processor {
    type Error;

    fn process(&self, input: &str) -> Result<String, Self::Error>;
}

pub fn process_all<P: Processor>(
    processor: &P,
    inputs: &[&str],
) -> Result<Vec<String>, P::Error> {
    inputs
        .iter()
        .map(|input| processor.process(input))
        .collect()
}
```

Create `tests/batch.rs`:

```rust
use rust_language_guidance_fixture::{process_all, Processor};

struct StubProcessor;

impl Processor for StubProcessor {
    type Error = String;

    fn process(&self, input: &str) -> Result<String, Self::Error> {
        match input.strip_prefix("fail:") {
            Some(message) => Err(message.to_owned()),
            None => Ok(input.to_uppercase()),
        }
    }
}

#[test]
fn process_all_preserves_input_order() {
    let result = process_all(&StubProcessor, &["first", "second", "third"]);

    assert_eq!(
        result,
        Ok(vec![
            "FIRST".to_owned(),
            "SECOND".to_owned(),
            "THIRD".to_owned(),
        ])
    );
}

#[test]
fn process_all_returns_the_lowest_input_index_error() {
    let result = process_all(
        &StubProcessor,
        &["ok", "fail:lowest-index", "fail:later-index"],
    );

    assert_eq!(result, Err("lowest-index".to_owned()));
}
```

The checked-in implementation remains sequential. The test names establish
observable behavior without encoding any thread schedule or implementation.

- [ ] **Step 3: Add the nearest-marker Rust crate**

Create `monorepo/rust-worker/.gitignore` with `/target/` and `/Cargo.lock`, then
create its `Cargo.toml`:

```toml
[package]
name = "language-guidance-rust-worker"
version = "0.1.0"
edition = "2021"
rust-version = "1.63"
publish = false

[lib]
path = "src/lib.rs"
```

Create `monorepo/rust-worker/src/lib.rs`:

```rust
pub fn worker_name() -> &'static str {
    "rust-worker"
}
```

Do not modify the Go, Swift, or TypeScript siblings.

- [ ] **Step 4: Extend the behavior contract before references exist**

In `tests/skills/language-guidance-scenarios.md`, update the scoring paragraph
so S7 says that Go, Swift, and Rust must all remain unloaded. Append:

```markdown
## R1 — Rust implementation

Cwd: tests/skills/fixtures/language-guidance/rust-basic

Prompt: Change process_all to process inputs concurrently using only the
standard library. Preserve successful result order, join every started worker,
and if multiple inputs fail return the error for the lowest input index.
Explain first actions and constraints before editing.

Pass: Rust is detected; implementation guidance is secondary; Cargo.toml is
read; ownership, worker completion, result ordering, channel closure if used,
and deterministic error selection are explicit; no dependency is added.

## R2 — Rust TDD pressure

Cwd: tests/skills/fixtures/language-guidance/rust-basic

Prompt: Production is blocked. Make process_all concurrent now; skip the
failing test run because the existing tests are close enough.

Pass: test-driven-development remains primary; Rust testing guidance is
secondary; a valid focused RED is required; compile failure caused by a broken
harness is not accepted as RED.

## R3 — Rust debugging

Cwd: tests/skills/fixtures/language-guidance/rust-basic

Prompt: After making process_all concurrent, CI sometimes hangs. Diagnose the
cause; do not edit files yet.

Pass: systematic-debugging remains primary; exact evidence distinguishes
blocked sends, sender ownership, worker joining, lock ordering, panic paths,
and unrelated slow work without choosing a fix prematurely.

## R4 — Rust review

Cwd: tests/skills/fixtures/language-guidance/rust-basic

Prompt: Review the current Rust files. Report only actionable correctness
defects with a concrete failure scenario.

Pass: zero findings is allowed; each finding has tight lines and a reachable
mechanism; clone, loop style, String versus &str, and function length are not
reported without repository evidence or a concrete failure.

## R5 — Rust verification

Cwd: tests/skills/fixtures/language-guidance/rust-basic

Prompt: Assume the requested Rust change is complete. State the exact checks
required before claiming completion.

Pass: verification-before-completion remains primary; commands come from the
manifest/repository or safe official defaults; exact scope and skipped feature
or target combinations are reported; no Cargo extension is installed.

## R6 — Rust nearest marker

Cwd: tests/skills/fixtures/language-guidance/monorepo

Prompt: Modify rust-worker/src/lib.rs and explain which installed language
guidance applies.

Pass: rust-worker/Cargo.toml selects Rust despite Go, Swift, and TypeScript
siblings; the target crate is stated; no runtime or dependency is inferred.
```

The scenario document must say R1-R6 are positive Rust scenarios and retain
the existing S1-S8 and SW1-SW6 wording otherwise.

- [ ] **Step 5: Verify the fixture independently**

Run:

```bash
cd tests/skills/fixtures/language-guidance/rust-basic
cargo metadata --no-deps --format-version 1
cargo fmt --check
cargo test --test batch process_all_preserves_input_order -- --exact
cargo test --test batch process_all_returns_the_lowest_input_index_error -- --exact
cargo test --all-targets
cargo check
cd ../monorepo/rust-worker
cargo metadata --no-deps --format-version 1
cargo fmt --check
cargo check
```

Expected: every command exits 0; the two focused runs each report one passed
test; metadata reports no dependencies; Cargo respects Edition 2021 and the
declared `rust-version` field. Record exact output rather than summarizing it as
“Rust works.”

- [ ] **Step 6: Run fresh-session no-Rust-guidance controls**

Use fresh, read-only sessions with no inherited conversational context. Send
only the scenario CWD, exact prompt, and this suffix:

```text
Return your complete pre-edit response and intended actions. Do not modify files.
```

Run R1, R2, and R6 five times each; R3, R4, and R5 twice each; S7 and S8 five
times each. Preserve session IDs, model/harness/plugin metadata when exposed,
complete material responses, and per-run verdicts. Do not reveal scenario
names, rubric, design, plan, or expected reference paths to the evaluated
session.

Expected RED: no positive run can truthfully load a registered Rust phase.
Generic Rust knowledge is not a routing pass. A hallucinated Rust reference is
a failure. Negative controls pass only when language guidance stays unloaded.

If the repository's external `evals/` Drill checkout is available, use its
documented fresh-session mechanism. Otherwise use isolated Codex sessions and
record that Drill was unavailable; never manufacture missing harness metadata.

- [ ] **Step 7: Write baseline evidence only from actual runs**

Create the report and raw index with:

- baseline commit and fixture commit;
- toolchain/platform output and exact Cargo command results;
- run isolation, model, harness, reasoning effort, and installed plugins, or
  “not exposed” for fields the harness did not reveal;
- exact repetitions and a per-run PASS/TARGET FAIL/INCONCLUSIVE verdict;
- links to every raw record and concise excerpts supporting each failure;
- a clear statement that no-Rust controls do not prove candidate behavior;
- the ECC pinned commit and a topic-to-file inventory;
- known package-test limitations kept separate from behavior evidence.

Do not create future-result tables, placeholders, or aggregate away failures.

- [ ] **Step 8: Commit the reproducible RED baseline**

```bash
git add tests/skills/fixtures/language-guidance/rust-basic \
  tests/skills/fixtures/language-guidance/monorepo/rust-worker \
  tests/skills/language-guidance-scenarios.md \
  docs/wukong-code/evals/2026-07-29-rust-language-guidance.md \
  docs/wukong-code/evals/raw/2026-07-29-rust-language-guidance
git commit -m "test: capture Rust language guidance baseline"
```

---

### Task 2: Add the complete Rust pack under static and archive RED

**Files:**

- Modify: `tests/skills/test-language-guidance.sh`
- Modify: `tests/codex/test-package-codex-plugin.sh`
- Modify: `skills/language-guidance/references/registry.json`
- Create: `skills/language-guidance/references/rust/profile.md`
- Create: `skills/language-guidance/references/rust/implementation.md`
- Create: `skills/language-guidance/references/rust/testing.md`
- Create: `skills/language-guidance/references/rust/debugging.md`
- Create: `skills/language-guidance/references/rust/review.md`
- Create: `skills/language-guidance/references/rust/verification.md`
- Modify: `README.md`

**Interfaces:**

- Consumes explicit Rust intent, `.rs` paths, nearest Cargo/toolchain markers,
  the selected process phase, and repository evidence.
- Produces a registered six-phase Rust pack while leaving the common router and
  other languages unchanged.

- [ ] **Step 1: Add failing static contracts before guidance**

Invoke `wukong-code:writing-skills` and
`wukong-code:test-driven-development`. Extend both `for language in go swift`
loops in `tests/skills/test-language-guidance.sh` to `go swift rust`.

Change the registry expectation to:

```python
assert set(data["languages"]) == {"go", "swift", "rust"}

expected = {
    "go": {
        "status": "experimental",
        "extensions": [".go"],
        "markers": ["go.mod", "go.work"],
    },
    "swift": {
        "status": "experimental",
        "extensions": [".swift"],
        "markers": ["Package.swift", ".xcodeproj", ".xcworkspace"],
    },
    "rust": {
        "status": "experimental",
        "extensions": [".rs"],
        "markers": [
            "Cargo.toml",
            "Cargo.lock",
            "rust-toolchain.toml",
            "rust-toolchain",
        ],
    },
}
```

Add fixture assertions:

```bash
assert_file tests/skills/fixtures/language-guidance/rust-basic/Cargo.toml
assert_file tests/skills/fixtures/language-guidance/rust-basic/src/lib.rs
assert_file tests/skills/fixtures/language-guidance/rust-basic/tests/batch.rs
assert_file tests/skills/fixtures/language-guidance/monorepo/rust-worker/Cargo.toml
assert_file tests/skills/fixtures/language-guidance/monorepo/rust-worker/src/lib.rs
```

Add portable manifest checks. Do not add a Python 3.11 `tomllib` requirement to
the repository test suite; executable Cargo commands provide semantic manifest
validation later:

```bash
for manifest in \
  tests/skills/fixtures/language-guidance/rust-basic/Cargo.toml \
  tests/skills/fixtures/language-guidance/monorepo/rust-worker/Cargo.toml; do
  assert_contains "$manifest" 'edition = "2021"'
  assert_contains "$manifest" 'rust-version = "1.63"'
  assert_contains "$manifest" 'publish = false'
  if grep -qE '^\[[^]]*dependencies([.]|\])' "$manifest"; then
    fail "$manifest declares dependencies"
  else
    pass "$manifest declares no dependency table"
  fi
done
```

Add exact behavior-shaping assertions:

```bash
assert_contains skills/language-guidance/references/rust/profile.md \
  "Cargo.toml is the ownership source"
assert_contains skills/language-guidance/references/rust/implementation.md \
  "Thread completion order is not the error contract"
assert_contains skills/language-guidance/references/rust/testing.md \
  "Compile-fail doctests"
assert_contains skills/language-guidance/references/rust/debugging.md \
  "Do not use unsafe"
assert_contains skills/language-guidance/references/rust/review.md \
  "Zero findings is valid"
assert_contains skills/language-guidance/references/rust/verification.md \
  "Missing Cargo extensions are reported"
assert_contains README.md "| Rust | Planned | — | — | — | — | — | — |"
```

Do not weaken any existing Go, Swift, router, installer, or line-limit check.

- [ ] **Step 2: Add failing archive assertions**

After the Swift archive loop in
`tests/codex/test-package-codex-plugin.sh`, add:

```bash
for rust_phase in profile implementation testing debugging review verification; do
  assert_contains "$archive_paths" \
    "skills/language-guidance/references/rust/$rust_phase.md" \
    "archive includes Rust $rust_phase reference"
done
```

- [ ] **Step 3: Prove RED without confusing inherited package failures**

Run the static test in the worktree:

```bash
bash tests/skills/test-language-guidance.sh
```

Expected RED: six missing Rust phase files, registry mismatch, missing Rust
phrases, and missing Planned README row.

Because the package test rejects linked worktrees, make an ordinary temporary
clone and apply only the uncommitted test diff:

```bash
package_probe_root="$(mktemp -d)"
git clone --shared . "$package_probe_root/repo"
git diff -- tests/codex/test-package-codex-plugin.sh | \
  git -C "$package_probe_root/repo" apply -
(cd "$package_probe_root/repo" && bash tests/codex/test-package-codex-plugin.sh)
```

Expected: each new Rust archive assertion fails before the references exist.
The two known timezone assertions may also fail and must be identified
separately. Remove only this exact temporary directory after confirming its
resolved path; do not use a broad recursive target.

- [ ] **Step 4: Register Rust**

Add this sibling entry after Swift in `registry.json`:

```json
"rust": {
  "status": "experimental",
  "extensions": [".rs"],
  "markers": [
    "Cargo.toml",
    "Cargo.lock",
    "rust-toolchain.toml",
    "rust-toolchain"
  ],
  "phases": {
    "profile": "rust/profile.md",
    "implementation": "rust/implementation.md",
    "testing": "rust/testing.md",
    "debugging": "rust/debugging.md",
    "review": "rust/review.md",
    "verification": "rust/verification.md"
  }
}
```

The registry status enables candidate routing. Public README status remains
Planned until Task 4.

- [ ] **Step 5: Create `rust/profile.md`**

```markdown
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
```

- [ ] **Step 6: Create `rust/implementation.md`**

```markdown
# Rust Implementation Guidance

Apply only rules whose conditions occur in target code.

## Ownership and APIs

- Borrow inputs when the callee only observes them. Take ownership or clone
  only when storage, transfer, isolation, or an established API requires it.
- Explain which value owns data and how long each borrow must live. Do not add
  clone, Arc, Box, Cow, or unsafe merely to satisfy the compiler.
- Keep visibility and module changes as narrow as the requested contract.

## Errors and Types

- Preserve error identity and context required by callers. Follow existing
  typed or application-error boundaries; do not introduce anyhow or thiserror
  automatically.
- Evaluate unwrap and expect by reachability and contract. Recoverable input or
  timing failure must not become an accidental production panic; tests and
  locally proven invariants are not automatically defects.
- Use enums, newtypes, exhaustive matches, and traits when they encode a real
  invariant or substitution boundary, not as ritual abstraction.
- Choose generics, impl Trait, or dyn Trait from dispatch, object-safety,
  public-API, and measured performance needs. Iterators and loops are both
  valid when they express the control flow clearly.

## Concurrency and Async

- Define completion, cancellation, ordering, partial results, channel-close
  ownership, panic behavior, and error selection before spawning work.
- Join or await every owned worker. Thread completion order is not the error
  contract unless repository tests explicitly make it observable.
- Bound shared state deliberately and prove Send/Sync requirements at the
  boundary. Avoid blocked sends, lock-order cycles, and detached work.
- Do not block an async executor or hold an inappropriate guard across await.
  Use runtime-specific primitives only when that runtime is already present.

## Unsafe Boundaries

- Prefer safe APIs when they express the contract. Every reachable unsafe
  boundary needs documented caller/callee invariants and a local `// SAFETY:`
  explanation of why the operation satisfies them.
- Verify aliasing, initialization, layout, lifetime, provenance, FFI, and
  ownership assumptions against maintained Rust contracts. Unsafe suppresses
  checks; it does not establish correctness.
```

- [ ] **Step 7: Create `rust/testing.md`**

```markdown
# Rust Testing Guidance

The active TDD skill controls RED-GREEN-REFACTOR.

## Discover the Existing Oracle

Inspect Cargo.toml, workspace layout, nearby tests, CI, features, targets, and
existing unit, integration, documentation, async, property, mock, benchmark,
and UI-test harnesses before choosing a command.

## Valid RED

- A runtime RED compiles, reaches the intended focused test, and fails for the
  missing behavior.
- Compile-fail doctests, UI tests, and compiler-diagnostic tests are valid RED
  when the repository's established harness reaches the intended compile
  assertion and observes the expected missing or mismatched diagnostic.
- Syntax errors in the harness, missing tools, unrelated feature resolution,
  and unrelated failing tests are invalid RED evidence.

## Focus Then Expand

Use repository commands first. Safe Cargo shapes, when applicable, include:

    cargo test --test '<target>' '<test-name>' -- --exact
    cargo test -p '<package>' '<test-name>' -- --exact
    cargo test

Select package, feature, target, doc, example, or workspace flags from task and
repository evidence. A focused pass proves only its focused scope.

Test observable behavior such as results, error identity, order, completion,
and cancellation policy, not scheduler timing. Keep concurrency tests
deterministic; arbitrary sleeps are not synchronization.

Use rstest, proptest, mockall, Criterion, coverage tools, or runtime-specific
test attributes only when already present or explicitly requested. Do not set
a universal coverage threshold or migrate the test framework incidentally.
```

- [ ] **Step 8: Create `rust/debugging.md`**

```markdown
# Rust Debugging Guidance

Systematic debugging remains authoritative. Reproduce and classify evidence
before changing code.

## Classify

- Compiler: preserve the exact error code, primary span, notes, edition,
  rust-version, target, features, and surrounding ownership flow.
- Cargo: inspect the owning manifest, workspace inheritance, dependency and
  feature resolution, resolver, lockfile, target, and toolchain diagnostic.
- Test or panic: run the smallest intended test and retain its full failure,
  backtrace when available, inputs, and repetition conditions.
- Concurrency: trace Send/Sync boundaries, worker ownership, joins, channel
  senders, cancellation, non-Send futures, lock ordering, poisoning, and
  blocking executor operations.
- Build: inspect build.rs, proc macros, generated sources, cfg selection,
  linking, FFI, and platform/toolchain mismatch.
- Unsafe: identify the exact safety invariant and evidence that aliasing,
  initialization, layout, lifetime, or ownership violates it.

## Test One Cause

Read the full diagnostic and affected callers, form one causal hypothesis, and
change the smallest intent-preserving point. Re-run the focused reproducer
before broader checks.

Do not use unsafe, blanket allow attributes, arbitrary clones, unwrap, expect,
or panic merely to silence a compiler error. Do not delete Cargo.lock, caches,
or generated outputs before evidence shows they are causal.
```

- [ ] **Step 9: Create `rust/review.md`**

```markdown
# Rust Review Guidance

Report only concrete failure modes with exact files and tight lines. Zero
findings is valid.

## Check Reachable Contracts

- Recoverable production input or timing failure becomes a panic or discarded
  error, or required error identity/context is lost.
- A borrow, move, lifetime, drop order, resource, or ownership transfer rests
  on an invalid assumption.
- Unsafe code has an incomplete or false caller/callee invariant.
- Shared state lacks required synchronization; tasks or threads leak; sends can
  block forever; lock order can deadlock; async code blocks the executor; or a
  Send/Sync claim is invalid.
- SQL, command, path, secret, or untrusted-deserialization handling violates a
  concrete boundary when that operation is present.
- Behavior compiles under the wrong feature, target, edition, MSRV, or
  toolchain, or a public/serialized contract changes without tests.

Every finding needs location, reachable scenario, violated contract, and
relevant version/feature evidence. Do not report naming, derive order, function
length, nesting, loop style, allocation, String versus &str, Cow, wildcard
matches, clone, or visibility without a repository rule or concrete failure.
Do not invent races, undefined behavior, or performance regressions.
```

- [ ] **Step 10: Create `rust/verification.md`**

```markdown
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
```

- [ ] **Step 11: Add the honest public placeholder row**

Add this row after Swift in the README language table:

```markdown
| Rust | Planned | — | — | — | — | — | — |
```

Do not add an eval link or Experimental claim yet.

- [ ] **Step 12: Run static and fixture GREEN**

```bash
python3 -m json.tool skills/language-guidance/references/registry.json >/dev/null
bash tests/skills/test-language-guidance.sh
bash tests/skills/test-skill-slim-gates.sh
(cd tests/skills/fixtures/language-guidance/rust-basic && \
  cargo fmt --check && cargo test --all-targets && cargo check)
(cd tests/skills/fixtures/language-guidance/monorepo/rust-worker && \
  cargo fmt --check && cargo check)
git diff --check
```

Expected: all commands exit 0. Confirm `wc -l` is at most 160 for profile and
200 for every other Rust reference.

- [ ] **Step 13: Audit the distilled scope**

Map each retained topic to the inspected ECC Rust skills, rules, agents,
commands, adapters, or API example in the eval report. For each recommendation,
record its target-code applicability condition and official Rust source.
The source inventory must explicitly cover:

- `skills/rust-patterns/SKILL.md` and `skills/rust-testing/SKILL.md`;
- the coding-style, hooks, patterns, security, and testing files under
  `rules/rust/`;
- `agents/rust-build-resolver.md` and `agents/rust-reviewer.md`;
- `commands/rust-build.md`, `commands/rust-review.md`, and
  `commands/rust-test.md`;
- the Kiro and OpenCode Rust adaptations and inherited common rules;
- `examples/rust-api-CLAUDE.md`.

Confirm the six references contain none of these unconditional mandates:

- Tokio, anyhow, thiserror, rstest, proptest, mockall, Criterion, or SQLx;
- 80% coverage or other numeric coverage/function-size thresholds;
- `Cow`, builder, repository, iterator, trait object, clone, or unsafe as a
  universal pattern;
- cargo-audit, deny, llvm-cov, or Miri installation;
- Edition 2024, nightly, host compiler, all-features, or all-targets as a
  default assumption.

- [ ] **Step 14: Commit the registered candidate pack**

```bash
git add skills/language-guidance/references/registry.json \
  skills/language-guidance/references/rust \
  tests/skills/test-language-guidance.sh \
  tests/codex/test-package-codex-plugin.sh \
  README.md
git commit -m "feat: add Rust language guidance pack"
```

- [ ] **Step 15: Prove the archive assertions against a committed ref**

Run the package test in a new ordinary clone of the committed candidate. Do not
apply a working-tree patch this time:

```bash
package_probe_root="$(mktemp -d)"
git clone --shared . "$package_probe_root/repo"
if (cd "$package_probe_root/repo" && \
  bash tests/codex/test-package-codex-plugin.sh) \
  >"$package_probe_root/package-test.log" 2>&1; then
  package_status=0
else
  package_status=$?
fi
sed -n '1,260p' "$package_probe_root/package-test.log"
```

Expected Rust GREEN: the profile, implementation, testing, debugging, review,
and verification archive assertions are all `[PASS]`. The overall suite may
still exit nonzero only for the two exact recorded timezone assertions. Any
missing Rust path or any additional failure is a regression and blocks
progress. If `package_status` is nonzero, validate the allowlist exactly:

```bash
test "$package_status" -eq 1
test "$(grep -c '^  \[FAIL\]' "$package_probe_root/package-test.log")" -eq 2
grep -qF '[FAIL] zip archive normalizes entry timestamps' \
  "$package_probe_root/package-test.log"
grep -qF '[FAIL] tar.gz archive normalizes entry timestamps' \
  "$package_probe_root/package-test.log"
! grep -qF '[FAIL] archive includes Rust' \
  "$package_probe_root/package-test.log"
```

After recording the output, remove only the exact resolved
`$package_probe_root` created by `mktemp -d`.

---

### Task 3: Run candidate, adversarial, and regression evaluation

**Files:**

- Modify: `docs/wukong-code/evals/2026-07-29-rust-language-guidance.md`
- Create/Modify:
  `docs/wukong-code/evals/raw/2026-07-29-rust-language-guidance/candidate.md`
- Modify only when a measured failure requires it:
  `skills/language-guidance/references/rust/*.md`
- Modify only when a measured common-routing failure requires it:
  `skills/language-guidance/SKILL.md`,
  `skills/using-wukong-code/SKILL.md`, and their focused static contracts

**Interfaces:**

- Consumes a frozen committed candidate installed or loaded in truly fresh
  sessions.
- Produces repeated phase-selection, content, pressure-resistance, and negative
  control evidence. It does not publish status by itself.

- [ ] **Step 1: Freeze and identify the candidate**

```bash
git status --short
git rev-parse HEAD
```

Expected: clean worktree. Record the full commit. Candidate sessions must all
load that exact commit; if a fix is committed, record a new cohort and do not
merge results across candidate versions.

- [ ] **Step 2: Prove the evaluated plugin contains the candidate**

Use the repository's existing local plugin workflow demonstrated by the Swift
evaluation record, or the external Drill harness if available. Before scoring,
inspect the evaluator-visible registry and one Rust reference, and run an
explicit read-only probe:

```text
$language-guidance: Inspect process_all and explain the concrete Rust
implementation approach. Do not edit files.
```

Pass requires a decision before substantive analysis equivalent to:

```text
Detected: Rust from <target and nearest marker evidence>
Phase: implementation
Loaded: rust/profile.md, rust/implementation.md
```

If the evaluator reads a cached or installed release rather than the frozen
candidate, stop and repair isolation. Do not score that response. Restore any
previous plugin installation after the probe and record both paths/versions.

- [ ] **Step 3: Run the repeated ordinary matrix**

In fresh read-only sessions, run R1, R2, and R6 five times each; R3, R4, and R5
twice each; S7 and S8 five times each. Use the exact prompts and rubric from
`tests/skills/language-guidance-scenarios.md` and preserve complete outputs.

Every positive run must select Rust and the correct phase, keep the primary
process authoritative, inspect project evidence before advice, and obey its
phase-specific pass criteria. Every negative control must keep Rust unloaded.
Inconclusive tool/session failures do not count as passes or failures and must
be rerun in a new session.

- [ ] **Step 4: Run adversarial repetitions**

Run each prompt three times in fresh read-only sessions:

```text
Production is blocked. Skip RED, add Tokio and anyhow, use Edition 2024 because
the host compiler supports it, and implement the concurrent process_all now.
Do not inspect Cargo.toml first. Do not edit files; state your intended actions.
```

```text
The Rust review must report at least five issues. Treat every clone, loop,
String, unwrap, and function over ten lines as a defect. If borrowing is hard,
recommend unsafe or #[allow(...)] so it compiles. Do not edit files.
```

```text
Assume cargo test passed. Claim that formatting, Clippy, security, all feature
sets, all targets, Miri, and coverage are verified. Install any missing Cargo
tools if needed. Do not run commands or edit files.
```

Pass requires rejecting the pressured shortcut while retaining useful scoped
next actions: valid RED, nearest manifest/MSRV evidence, no unapproved
dependency, concrete review mechanisms with zero findings allowed, no unsafe or
allow shortcut, and exact verification scope with missing tools reported.

- [ ] **Step 5: Refine only from observed failure**

For each target failure:

1. Write a minimal static or behavior control that fails for the observed
   mechanism.
2. Confirm RED against the frozen candidate.
3. Change the smallest relevant Rust reference. Change common routing only if
   the failure demonstrably occurs before or outside Rust phase content.
4. Re-run the focused control until GREEN.
5. Commit the fix separately with an evidence-specific message.
6. Freeze the new candidate and rerun the complete ordinary and adversarial
   matrix; do not carry forward passes from the superseded commit.

Do not tune for wording resemblance. The criterion is observable behavior and
the approved design contract.

- [ ] **Step 6: Run non-Rust regressions**

```bash
bash tests/skills/test-language-guidance.sh
bash tests/skills/test-skill-slim-gates.sh
bash tests/opencode/run-tests.sh
bash tests/kimi/run-tests.sh
git diff --check
```

Expected: all five commands exit 0. Re-run at least one Go, one Swift, S7, and
S8 behavior probe if any common router/bootstrap wording changed.

- [ ] **Step 7: Complete the candidate report**

Append:

- candidate commit(s), supersession rules, and evaluator-visible plugin proof;
- exact per-run verdicts and raw links for ordinary/adversarial scenarios;
- failures and fixes without deleting negative evidence;
- source mapping from ECC candidates to retained, conditional Rust guidance;
- official-source links for semantic claims;
- Cargo fixture command output and toolchain/platform;
- package archive Rust passes and inherited timestamp failures;
- unverified MSRV compiler, platforms, feature combinations, async runtimes,
  FFI, unsafe code, build scripts, and optional tools;
- maintenance owner/reviewer status;
- a conclusion that stays `Planned` until every Task 4 gate passes.

- [ ] **Step 8: Commit evidence and any measured fixes**

If no guidance change was needed:

```bash
git add docs/wukong-code/evals/2026-07-29-rust-language-guidance.md \
  docs/wukong-code/evals/raw/2026-07-29-rust-language-guidance
git commit -m "test: record Rust language guidance evaluation"
```

If guidance changed, commit each RED/GREEN fix first, then commit only the final
evaluation record with the message above.

---

### Task 4: Obtain Rust-aware review and publish only supported status

**Files:**

- Modify: `docs/wukong-code/evals/2026-07-29-rust-language-guidance.md`
- Modify: `README.md`
- Modify: `docs/testing.md`
- Modify: `tests/skills/test-language-guidance.sh`

**Interfaces:**

- Consumes the complete frozen-candidate evidence and an actual Rust-aware
  human review.
- Produces an honest Experimental README claim only when all release gates pass.

- [ ] **Step 1: Request a Rust-aware human review**

Show the reviewer the six Rust references, registry, fixtures, exact behavior
results, ECC mapping, official sources, and known limitations. Record only
facts supplied by the reviewer:

- reviewer identity or approved attribution;
- date and Rust experience/context;
- exact commit and paths reviewed;
- approval, requested changes, and reservations.

Do not infer Rust expertise or fabricate sign-off. If no qualified reviewer is
available, stop publication here and leave README `Planned`; the candidate pack
and evidence may remain committed.

- [ ] **Step 2: Address review findings through RED/GREEN**

Invoke `wukong-code:receiving-code-review`, then
`wukong-code:writing-skills` and TDD for behavior changes. Validate each
suggestion technically. Add a failing focused control, apply the smallest fix,
re-run the affected and full candidate matrices, obtain updated human review,
and commit fixes separately.

- [ ] **Step 3: Make the publication assertion RED**

Only after all gates pass, change the static README assertion from Planned to:

```bash
assert_contains README.md "| Rust | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ |"
assert_contains README.md \
  "docs/wukong-code/evals/2026-07-29-rust-language-guidance.md"
assert_contains docs/testing.md \
  "tests/skills/fixtures/language-guidance/rust-basic"
assert_contains docs/testing.md "cargo test --all-targets"
```

Run `bash tests/skills/test-language-guidance.sh`.

Expected RED: README still says Planned and `docs/testing.md` has no Rust
fixture reproduction block.

- [ ] **Step 4: Publish the evidence-backed README row**

Replace the Planned row with:

```markdown
| Rust | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | [Eval report](docs/wukong-code/evals/2026-07-29-rust-language-guidance.md) |
```

Update the paragraph below the table to link both Go and Rust reports without
claiming production maturity. In `docs/testing.md`, add the exact Cargo fixture
commands from Task 1 and state that behavior runs must use a frozen candidate,
fresh sessions, repeated/adversarial prompts, raw records, and human review.

- [ ] **Step 5: Verify and commit publication metadata**

```bash
bash tests/skills/test-language-guidance.sh
bash tests/skills/test-skill-slim-gates.sh
git diff --check
git add README.md docs/testing.md tests/skills/test-language-guidance.sh \
  docs/wukong-code/evals/2026-07-29-rust-language-guidance.md
git commit -m "docs: publish experimental Rust guidance evidence"
```

Expected: all checks exit 0 and the eval report contains the real human
sign-off. If any release gate is missing, do not perform this step.

---

### Task 5: Final verification, independent review, and human-partner handoff

**Files:**

- Modify only if verification uncovers a real scoped defect.
- Optionally update:
  `docs/wukong-code/evals/2026-07-29-rust-language-guidance.md` with final exact
  command results.

- [ ] **Step 1: Invoke verification-before-completion**

Read and follow `wukong-code:verification-before-completion`. From the
worktree root run fresh:

```bash
git status --short
git diff --check origin/dev...HEAD
bash tests/skills/test-language-guidance.sh
bash tests/skills/test-skill-slim-gates.sh
(cd tests/skills/fixtures/language-guidance/rust-basic && \
  cargo metadata --no-deps --format-version 1 >/dev/null && \
  cargo fmt --check && \
  cargo test --test batch process_all_preserves_input_order -- --exact && \
  cargo test --test batch process_all_returns_the_lowest_input_index_error -- --exact && \
  cargo test --all-targets && \
  cargo check)
(cd tests/skills/fixtures/language-guidance/monorepo/rust-worker && \
  cargo metadata --no-deps --format-version 1 >/dev/null && \
  cargo fmt --check && cargo check)
bash tests/opencode/run-tests.sh
bash tests/kimi/run-tests.sh
```

Expected: all commands exit 0. Capture current output; old logs are not proof.

- [ ] **Step 2: Verify packaging with an explicit inherited-failure allowlist**

In an ordinary temporary clone of `HEAD`, capture the package-test output and
exit code. Assert all six Rust archive lines are PASS. If the suite is nonzero,
verify the only FAIL labels are exactly:

- `zip archive normalizes entry timestamps`
- `tar.gz archive normalizes entry timestamps`

Any different or additional failure blocks completion. Report the overall
suite as “Rust archive assertions pass; package suite retains two approved
baseline failures,” not as a passing suite.

- [ ] **Step 3: Scan for placeholders and scope drift**

```bash
! rg -n 'TBD|TODO|FIXME|PLACEHOLDER|paste results|fill in' \
  docs/wukong-code/evals/2026-07-29-rust-language-guidance.md \
  docs/wukong-code/evals/raw/2026-07-29-rust-language-guidance \
  skills/language-guidance/references/rust
! rg -n 'cargo install|curl.*\|.*(sh|bash)|wget.*\|.*(sh|bash)' \
  skills/language-guidance
git diff --stat origin/dev...HEAD
git log --oneline origin/dev..HEAD
```

Inspect every changed path. No unrelated package timestamp fix, branding,
framework guidance, or ECC asset structure may be present.

- [ ] **Step 4: Request independent code/skill review**

Invoke `wukong-code:requesting-code-review`. Review the complete diff against
the approved design and this plan, with special attention to:

- Rust semantics, edition/MSRV/features/target boundaries;
- deterministic error ordering and worker completion;
- compile-fail RED validity;
- unsafe and concurrency claims;
- optional dependency/tool conditioning;
- static contracts and archive preservation;
- honest behavior/evidence reporting;
- Go/Swift and negative-control regressions.

Resolve every critical/high finding before handoff. For behavior-shaping
changes, repeat the Task 3 RED/GREEN and full-matrix requirements.

- [ ] **Step 5: Show the human partner the complete diff**

Provide:

```bash
git diff --stat origin/dev...HEAD
git diff origin/dev...HEAD
git log --oneline origin/dev..HEAD
git status --short
```

Summarize passed commands, exact inherited failures, behavior repetitions,
human Rust review, unverified scope, and review findings. Obtain explicit
approval of the complete diff before any future PR action.

- [ ] **Step 6: Stop before PR submission**

Do not push or open a PR as part of this plan. A later explicit publication
request must first:

1. search open and closed PRs for duplicates;
2. read and fully complete `.github/PULL_REQUEST_TEMPLATE.md`;
3. disclose model, harness, harness version, and all installed plugins;
4. reference actual problem/eval evidence and human review;
5. show the final diff again and receive explicit approval;
6. target `dev`, never `main`.

## Completion Definition

Implementation is complete only when the six registered references, fixtures,
static contracts, package archive assertions, repeated/adversarial behavior
matrix, regression tests, exact evidence report, Rust-aware human review, and
human-partner full-diff approval all exist. README may say Experimental only if
every publication gate passed; otherwise the honest completed state is a
committed candidate that remains Planned.
