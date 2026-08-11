# Test Automation Design

**Date:** 2026-08-11

## Problem

The repository has many focused test entry points but no root `npm test` script,
no canonical local command, and no GitHub Actions workflow. Contributors must
discover test commands from individual directories, while host-dependent and
LLM-backed checks cannot run reliably in a pull-request environment.

## Goals

- Provide one documented local entry point for deterministic infrastructure
  checks.
- Run that same entry point in GitHub Actions for pull requests and pushes to
  the default development branches.
- Keep tests that require a host CLI, credentials, or real LLM sessions out of
  the required PR gate without hiding them.
- Make suite membership and failure propagation testable.

## Non-goals

- Running `evals/` Drill scenarios in GitHub Actions.
- Installing Claude Code, OpenCode, or Antigravity in CI.
- Repairing the existing Antigravity mapping failure in this change.
- Replacing focused test runners maintained by individual harnesses.

## Design

### Root command

Add `scripts/test.sh` as the canonical dispatcher and expose it through
`package.json` as `npm test`. The script accepts:

- no argument or `--suite core` — execute the required deterministic suite;
- `--suite extended` — execute `core` first, then opt-in local checks;
- `--help` — print the supported interface and the suite boundary.

The dispatcher is Bash, runs from the repository root regardless of its caller,
prints the command before each invocation, stops on the first failure, and
returns that failure status. It must not silently skip an unavailable command
inside `core`.

### Suite boundary

`core` contains repository-local tests that require only Bash, Node.js, Python
when already provided by the runner, and ordinary Git tooling:

| Area | Command |
| --- | --- |
| Core skill policy | `bash tests/skills/test-core-skill-admission-policy.sh` |
| Skill contracts | `bash tests/skills/test-language-guidance.sh`, `bash tests/skills/test-skill-slim-gates.sh`, `bash tests/skills/test-gemini-retirement.sh` |
| Bootstrap hook | `bash tests/hooks/test-session-start.sh` |
| OpenCode static checks | `bash tests/opencode/run-tests.sh` |
| Kimi manifest | `bash tests/kimi/run-tests.sh` |
| Pi extension | `node --test tests/pi/test-pi-extension.mjs` |
| Codex packaging | `bash tests/codex/test-marketplace-manifest.sh`, `bash tests/codex/test-package-codex-plugin.sh` |
| Codex sync | `bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh` |
| Product Design | `bash tests/product-design/test-core-integration.sh`, `node --test tests/product-design/test-import-integrity.mjs` |
| Shell lint contract | `bash tests/shell-lint/test-lint-shell.sh` |

`extended` runs `core`, installs the checked-in dependencies under
`tests/brainstorm-server/` with `npm ci`, executes that Node suite, and then
runs `bash tests/antigravity/run-tests.sh`. The latter is deliberately
non-blocking for PRs while its currently failing mapping contract is repaired
in a separate change.

Host-CLI integration suites (Claude Code and OpenCode integration mode),
explicit skill request probes, and Drill evaluations remain manual. The
dispatcher prints their documented location in its `--help` output rather than
pretending they passed.

### GitHub Actions

Add `.github/workflows/test.yml` with two jobs:

- `core`: on `pull_request` and pushes to `main` or `dev`; checks out the
  source, uses the current Node LTS line, and runs `npm test`.
- `extended`: manual-only through `workflow_dispatch`; reuses the same checkout
  and Node setup, then runs `bash scripts/test.sh --suite extended`.

The workflow invokes the repository dispatcher rather than duplicating its
command list. The Actions dependency cache keys the checked-in
`tests/brainstorm-server/package-lock.json`; core requires no package install
because the root package has no dependencies.

### Regression coverage and documentation

Add a focused test for `scripts/test.sh` that verifies the supported suite
arguments, core membership, extended ordering, and nonzero exit propagation by
using a controlled fixture or command override. Update `docs/testing.md` with
the root commands, CI policy, and manual-only test categories.

## Acceptance criteria

1. `npm test` and `bash scripts/test.sh --suite core` invoke the identical
   deterministic suite and fail on a failed child command.
2. `bash scripts/test.sh --suite extended` runs core before its opt-in checks.
3. GitHub Actions runs the core command on PRs and pushes to `main` and `dev`;
   extended can be manually dispatched.
4. The runner's interface and membership have automated regression coverage.
5. The testing guide identifies the PR gate and clearly separates manual
   host/LLM evaluations.

## Risks and mitigations

- A focused test may gain a host dependency over time. Keeping the command
  list explicit and testing it makes that change reviewable.
- The Antigravity check currently fails. It stays in the opt-in extended tier
  so it remains visible without blocking unrelated pull requests.
- CI and local commands can drift. Both jobs call the same dispatcher, and the
  workflow only owns environment setup.
