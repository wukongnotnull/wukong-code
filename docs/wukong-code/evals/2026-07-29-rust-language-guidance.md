# Rust language-guidance evaluation — 2026-07-29

## Methodology and isolation

This first record is the no-Rust-guidance RED baseline. Rust fixtures and
scenario definitions existed, but the installed `language-guidance` registry
contained only Go and Swift and had no Rust references.

- Source branch commit before fixture edits:
  `b839bfece6c1d1bf679a987f6afa41a6bb089b18`.
- Sanitized fixture repository commit: `32728eb`.
- Harness: `codex-cli 0.146.0`, `gpt-5.6-terra`, low reasoning effort,
  ephemeral fresh sessions, read-only sandbox, empty per-run MCP configuration.
- Concurrency: at most four independent CLI sessions.
- Installed Wukong Code plugin: `wukong-code@wukong-code-dev` 6.2.1 from its
  Git marketplace cache; its evaluator-visible registry had Go and Swift only.
- Other enabled plugins: Sites, Browser, Chrome, and Computer Use. Documents,
  PDF, Spreadsheets, Presentations, Template Creator, and Visualize were
  installed but disabled.
- Every scored session received only its CWD, exact scenario prompt, and the
  instruction to return a complete pre-edit response without modifying files.
- The sanitized repository contained only the Rust basic crate, the mixed
  Go/Swift/TypeScript/Rust monorepo fixture, and a minimal README. It had a
  clean Git commit and no Wukong Code design, plan, scenario rubric, or Rust
  reference file.
- One earlier R1 calibration run against the implementation worktree is
  excluded because it read the design and plan, contaminating the control.

Complete final responses, session IDs, and per-run verdicts are preserved in
the [baseline raw index](raw/2026-07-29-rust-language-guidance/baseline.md).
CLI JSONL remains in the local evaluation scratch directory and is not treated
as source-controlled behavior evidence.

## Cargo fixture evidence

Local execution environment:

- `rustc 1.97.1 (8bab26f4f 2026-07-14)`;
- `cargo 1.97.1 (c980f4866 2026-06-30)`;
- host `aarch64-apple-darwin`, macOS 26.5.2;
- fixture Edition 2021, declared `rust-version = "1.63"`, no dependencies.

| Command | Result |
| --- | --- |
| `cargo metadata --no-deps --format-version 1` in `rust-basic` | PASS; one library, one integration test target, no dependencies |
| `cargo fmt --check` in `rust-basic` | PASS after applying rustfmt's one-line signature formatting |
| focused input-order test | PASS; 1 passed, 1 filtered out |
| focused lowest-index-error test | PASS; 1 passed, 1 filtered out |
| `cargo test --all-targets` in `rust-basic` | PASS; 2 integration tests passed |
| `cargo check` in `rust-basic` | PASS |
| metadata, formatting, and check in `monorepo/rust-worker` | PASS; no dependencies |

The installed 1.97 compiler does not prove the declared 1.63 MSRV. No older
toolchain was installed for this evaluation.

## RED behavior results

| Scenario | Runs | Result |
| --- | ---: | --- |
| R1 implementation | 5 | 5 TARGET FAIL — technically plausible standard-library plans, but no registered Rust implementation phase loaded |
| R2 TDD pressure | 5 | 5 TARGET FAIL — no Rust testing phase; 3/5 accepted skipping RED and 2/5 retained a RED cycle |
| R3 debugging | 2 | 2 TARGET FAIL — correctly observed the concurrent change was absent, but no Rust debugging phase loaded |
| R4 review | 2 | 2 TARGET FAIL — both correctly returned zero findings, but no Rust review phase loaded |
| R5 verification | 2 | 2 TARGET FAIL — no Rust verification phase; one assumed `all-features`, the other proposed unavailable `+1.63`/Clippy commands |
| R6 nearest marker | 5 | 5 TARGET FAIL — all selected the nearest Cargo crate and explicitly reported that Rust guidance was unavailable |
| S7 unsupported TypeScript | 5 | 5 PASS — TypeScript selected from `web/tsconfig.json`; Go, Swift, and Rust guidance remained unloaded |
| S8 documentation-only | 5 | 5 PASS — documentation-only scope loaded no language guidance |

The 31 scored sessions produced 10 negative-control passes and 21 expected
positive target failures. Generic Rust knowledge did not count as a phase
selection pass. No run hallucinated an existing Rust reference path.

The controls demonstrate three concrete needs for the candidate pack:

1. registered Rust phase selection, not merely Rust syntax detection;
2. explicit resistance to skipping a valid RED run;
3. verification derived from manifest/repository evidence rather than ritual
   `all-features`, unavailable toolchains, or optional components.

## Candidate implementation and refinement

The registered Rust candidate was introduced at `8b7212a`. The evaluated
cohorts then produced these measured routing/content repairs:

| Commit | Observed failure | Minimal repair |
| --- | --- | --- |
| `4c7500e` | Initial final-message-only score misread a passing strict probe | Unjustified broad profile routing; removed after full JSONL review |
| `3151a7a` | TDD pressure accepted skipped RED; verification scope expanded | Require testing phase/RED and evidence-bounded verification |
| `026e754` | Missing concurrent revision still produced a leading cause | Forbid ranked causes without the target revision/log |
| `b1f4386` | Missing-evidence diagnosis collapsed distinct branches; no-command verification skipped its reference | Preserve concurrency hypotheses; strengthen verification trigger |
| `38726e1` | No-command verification sometimes bypassed bootstrap routing | Put unsupported-claim routing in the bootstrap description |
| `81dbbaf` | Experimental change outside the approved Task 3 file set | Superseded and reverted; no net process-skill change |
| `c366755` | Frozen pre-review candidate | Net candidate used for the interrupted final cohort |

The complete superseded `4c7500e` cohort scored 25/31 ordinary and 3/9
adversarial passes. Its Rust-positive scenarios scored 17/21 and controls
scored 8/10; two TypeScript controls invented nonexistent reference paths.
Failures were not discarded: they drove the focused repairs above. The frozen
`c366755` cohort completed only four sessions, all R1 passes, before
`codex-cli` returned an account usage-limit error. The runner was stopped;
remaining sessions are `INCONCLUSIVE` and no superseded pass was carried
forward.

Review of the complete strict-probe JSONL also corrected an earlier scoring
error: `strict-1` emitted `Phase: profile` and loaded `rust/profile.md` before
its final message, so it was a pass. The post-review candidate removes the
unjustified generic no-edit profile rule and explicitly gives failure
investigation, code review, and completion verification precedence. That
behavior-changing correction requires a new complete cohort after quota reset.

Complete agent-message transcripts, session IDs, and per-run verdicts are in
the [candidate raw index](raw/2026-07-29-rust-language-guidance/candidate.md).

## Candidate source and semantic boundaries

The six references retain only conditional, repository-first guidance from
the ECC inventory:

- `rust/profile.md`: Cargo ownership, workspace/target evidence, MSRV,
  edition, toolchain, features, generated inputs, and target uncertainty;
- `rust/implementation.md`: ownership/API boundaries, typed errors,
  concurrency completion/order/error contracts, async runtime preservation,
  and unsafe invariants;
- `rust/testing.md`: valid runtime and compile-fail RED, focused-to-broad Cargo
  checks, deterministic concurrency tests, and conditional optional tools;
- `rust/debugging.md`: exact compiler/Cargo/test/build evidence, distinct hang
  hypotheses, and invariant-first unsafe diagnosis;
- `rust/review.md`: reachable correctness mechanisms, tight locations, zero
  findings, and rejection of style-as-defect review;
- `rust/verification.md`: repository-defined scope, safe Cargo defaults,
  explicit missing/unknown checks, and no tool installation.

The main Rust semantic and toolchain boundaries are conditional on repository
evidence and map to the maintained primary sources below. Project-specific
external APIs instead require the owning repository or upstream API contract;
the pack does not infer domain-specific risk from Rust alone.

| Recommendation | Applies when | Authority/source |
| --- | --- | --- |
| Manifest, edition, MSRV, targets, profiles, and build inputs | `Cargo.toml`, workspace metadata, or nearby Cargo configuration establishes the crate scope | [manifest](https://doc.rust-lang.org/cargo/reference/manifest.html), [workspaces](https://doc.rust-lang.org/cargo/reference/workspaces.html), [features](https://doc.rust-lang.org/cargo/reference/features.html), [editions](https://doc.rust-lang.org/edition-guide/), [build scripts](https://doc.rust-lang.org/cargo/reference/build-scripts.html) |
| Ownership, borrowing, visibility, error propagation, and API types | Target signatures, callers, and established error/module boundaries require the choice; borrowing or abstraction is not prescribed ritually | [references and borrowing](https://doc.rust-lang.org/book/ch04-02-references-and-borrowing.html), [`Result`](https://doc.rust-lang.org/std/result/index.html), [visibility](https://doc.rust-lang.org/reference/visibility-and-privacy.html), [generics](https://doc.rust-lang.org/reference/items/generics.html), [dyn compatibility](https://doc.rust-lang.org/reference/items/traits.html#dyn-compatibility) |
| Scoped threads and cross-thread value boundaries | Existing standard-library threaded code or the requested contract requires threads | [`thread::scope`](https://doc.rust-lang.org/std/thread/fn.scope.html), [`Send`](https://doc.rust-lang.org/std/marker/trait.Send.html), [`Sync`](https://doc.rust-lang.org/std/marker/trait.Sync.html) |
| Async ownership and cancellation contracts | The repository already selects an async runtime or exposes a `Future` boundary | [`Future`](https://doc.rust-lang.org/std/future/trait.Future.html), [async blocks](https://doc.rust-lang.org/reference/expressions/block-expr.html#async-blocks) |
| Unsafe invariants, pointer validity, provenance, and FFI boundaries | Existing code contains `unsafe`, raw pointers, or external blocks; guidance does not introduce them | [`unsafe`](https://doc.rust-lang.org/reference/unsafe-keyword.html), [undefined behavior](https://doc.rust-lang.org/reference/behavior-considered-undefined.html), [`std::ptr`](https://doc.rust-lang.org/std/ptr/index.html), [external blocks](https://doc.rust-lang.org/reference/items/external-blocks.html) |
| Runtime and compile-fail tests | The repository has Cargo tests, rustdoc compile-fail tests, or an already-established compiler/UI diagnostic harness; the pack does not introduce `compiletest` | [`cargo test`](https://doc.rust-lang.org/cargo/commands/cargo-test.html), [rustdoc tests](https://doc.rust-lang.org/rustdoc/write-documentation/documentation-tests.html), [rustc UI tests](https://rustc-dev-guide.rust-lang.org/tests/ui.html) |
| Exact compiler, Cargo, and build diagnosis | A captured error, failing command, build script, feature, or target supplies evidence | [error index](https://doc.rust-lang.org/error_codes/error-index.html), [`cargo check`](https://doc.rust-lang.org/cargo/commands/cargo-check.html), [build scripts](https://doc.rust-lang.org/cargo/reference/build-scripts.html) |
| Correctness review boundaries | Target code exposes recoverable errors, ownership/drop behavior, unsafe, concurrency, or a public compatibility surface | [`Result`](https://doc.rust-lang.org/std/result/index.html), [destructors and drop scopes](https://doc.rust-lang.org/reference/destructors.html), [undefined behavior](https://doc.rust-lang.org/reference/behavior-considered-undefined.html), [`Send`](https://doc.rust-lang.org/std/marker/trait.Send.html), [`Sync`](https://doc.rust-lang.org/std/marker/trait.Sync.html), [Cargo SemVer guidance](https://doc.rust-lang.org/cargo/reference/semver.html) |
| Project-specific external API review | The exact external operation and untrusted input path are present in target code | Owning repository rules and upstream API documentation; no Rust-only SQL, command, path, secret, or deserialization finding |
| Focused-to-broad verification and optional formatting/lint checks | Repository scripts or installed official components establish the command and scope | [`cargo test`](https://doc.rust-lang.org/cargo/commands/cargo-test.html), [`cargo check`](https://doc.rust-lang.org/cargo/commands/cargo-check.html), [`cargo fmt`](https://doc.rust-lang.org/cargo/commands/cargo-fmt.html), [Clippy usage](https://doc.rust-lang.org/clippy/usage.html) |

The fixture's `rust-version = "1.63"` is compatibility intent recorded in the
manifest; the installed Rust 1.97 host does not prove that MSRV. Optional
components and unexecuted feature or target combinations remain explicitly
unverified. The Rustonomicon was useful background during source review but is
not used as the primary authority for these recommendations.

## Candidate static, Cargo, and package evidence

After the measured repairs:

| Check | Result |
| --- | --- |
| `bash tests/skills/test-language-guidance.sh` | PASS |
| `bash tests/skills/test-skill-slim-gates.sh` | PASS |
| Rust focused tests and `cargo test --all-targets` | PASS |
| Rust `cargo check` and `cargo fmt --check` | PASS |
| six Rust files in Codex ZIP archive | PASS in ordinary temporary clone |
| six Rust files in Codex tar.gz archive | PASS in ordinary temporary clone |
| full Codex package suite | retains only the two approved timezone-sensitive ZIP/tar timestamp failures |

The full non-Rust repository regressions and final package rerun are recorded
again during final local verification below. None substitutes for the missing
final behavior cohort.

## Pre-review local verification at `c366755`

| Command | Result |
| --- | --- |
| `bash tests/skills/test-language-guidance.sh` | PASS |
| `bash tests/skills/test-skill-slim-gates.sh` | PASS |
| `bash tests/opencode/run-tests.sh` | PASS — 2 passed, 0 failed |
| `bash tests/kimi/run-tests.sh` | PASS — manifest valid |
| `cargo test --all-targets && cargo check && cargo fmt --check` in `rust-basic` | PASS — 2 integration tests |
| same Cargo sequence in `monorepo/rust-worker` | PASS |
| `git diff --check` | PASS before evidence write; rerun required after final evidence commit |
| Codex package test in a new ordinary clone with `TZ=Asia/Shanghai` | Rust ZIP/tar assertions PASS; suite status 1 only because the two approved timestamp checks fail |

Because common bootstrap/router wording changed, the plan requires fresh Go,
Swift, S7, and S8 behavior probes. They could not start after the account quota
error and remain `INCONCLUSIVE`; static contracts and harness tests passing do
not replace those probes.

## Post-review local verification at `53b2284`

| Command | Result |
| --- | --- |
| `bash tests/skills/test-language-guidance.sh` | PASS, including phase precedence and the external-API review boundary |
| `bash tests/skills/test-skill-slim-gates.sh` | PASS |
| `bash tests/opencode/run-tests.sh` | PASS — 2 passed, 0 failed |
| `bash tests/kimi/run-tests.sh` | PASS — manifest valid |
| `cargo test --all-targets && cargo check && cargo fmt --check` in `rust-basic` | PASS — 2 integration tests |
| same Cargo sequence in `monorepo/rust-worker` | PASS |
| `git diff --check` | PASS |
| Codex package test in a new ordinary clone with `TZ=Asia/Shanghai` | all six Rust ZIP/tar assertions PASS; status 1 only for the two pre-existing timezone-sensitive timestamp assertions |

These checks validate the static contracts, fixtures, harness manifests, and
archive contents. They do not replace the missing post-review behavior cohort.

## ECC source inventory

ECC candidate material is pinned to
`591ab5cbd3f2f65860ea91c226e410b1502c8e2e`. The inventory was read as source
material, not copied as Wukong Code structure.

| Concern | Inspected ECC surfaces | Integration boundary |
| --- | --- | --- |
| Ownership, borrowing, errors, traits, type patterns, concurrency, async, and unsafe | `skills/rust-patterns/SKILL.md`; `rules/rust/coding-style.md`; `rules/rust/patterns.md`; `rules/rust/security.md`; `agents/rust-reviewer.md`; `examples/rust-api-CLAUDE.md` | Retain only condition-based language semantics; no universal crate, architecture, clone, iterator, or unsafe rule |
| Unit/integration/doc/property/mock/benchmark and coverage guidance | `skills/rust-testing/SKILL.md`; `rules/rust/testing.md`; `commands/rust-test.md` | TDD remains primary; compile-fail controls are valid only through an established oracle; optional tools stay conditional |
| Cargo/compiler/build diagnosis | `agents/rust-build-resolver.md`; `commands/rust-build.md`; `rules/rust/hooks.md` | Preserve exact diagnostics, edition/MSRV/features/target evidence; do not install tools or duplicate debugging workflow |
| Correctness review and security boundaries | `agents/rust-reviewer.md`; `commands/rust-review.md`; Rust coding/security rules | Require reachable failure mechanisms and tight locations; zero findings remains valid |
| Harness adaptations | `.kiro/agents/`, `.kiro/skills/`, `.kiro/steering/rust-patterns.md`, `.kiro/hooks/rust-check-on-edit.kiro.hook`, `.opencode/commands/`, and `.opencode/prompts/agents/` Rust assets | Treat as delivery variants and inherited behavior, not additional top-level Wukong assets |

Japanese and Spanish translations were checked only for parity; the canonical
English assets control the inventory.

## Known baseline limitations

- Automatic language routing is advisory. These sessions evaluate observed
  Codex CLI behavior, not every supported harness or model.
- No Rust 1.63 compiler, non-host target, feature matrix, async runtime, FFI,
  unsafe code, build script, proc macro, or Cargo extension was executed.
- The existing Codex package test rejects linked worktrees and, in an ordinary
  Asia/Shanghai clone, retains two timezone-sensitive ZIP/tar timestamp
  failures. They predate this Rust work and are not fixed here.
- RED results cannot establish candidate quality. Candidate and adversarial
  cohorts must use a frozen committed Rust pack and new sessions.
- The pre-review `c366755` behavior cohort is incomplete because the evaluator
  account reached its usage limit. It must be rerun in full after the limit
  resets; superseded or focused results cannot be averaged into it.
- The post-review phase-precedence correction has no completed behavior cohort;
  RP1-RP3 plus the ordinary, adversarial, Go, Swift, S7, and S8 regressions must
  run after quota reset.
- No Rust-aware human reviewer has signed off on the exact final commit and
  scope.

README status remains `Planned`. Experimental publication still requires the
candidate matrix, adversarial repetitions, Rust archive assertions, repository
regressions, and Rust-aware human review.
