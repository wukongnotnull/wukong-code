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

README status remains `Planned`. Experimental publication still requires the
candidate matrix, adversarial repetitions, Rust archive assertions, repository
regressions, and Rust-aware human review.
