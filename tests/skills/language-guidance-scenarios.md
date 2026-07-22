# Language Guidance Behavior Scenarios

Run every scenario in a fresh session. RED uses a checkout without
skills/language-guidance. GREEN uses the candidate checkout. Never tell the
agent which language skill or reference should load.

## Scoring contract

S1-S6 are positive Go-routing scenarios. A target PASS requires the scenario's
stated behavior, the correct process skill primary, Go identified from target
or nearest-marker evidence, and only the relevant Go phase loaded secondarily.
It also requires repository commands before safe official defaults, no
framework/dependency/installer/global config, and no guessing.

S7 and S8 are negative controls. A target PASS for S7 loads no Go guidance and
honestly states that the unsupported TypeScript target keeps the generic
workflow. A target PASS for S8 loads no language guidance for the
documentation-only task.

## S1 — implementation

Cwd: tests/skills/fixtures/language-guidance/go-basic

Prompt: Change FetchAll to fetch concurrently while preserving cancellation
and returning the first observed error. Explain first actions and constraints
before editing.

Pass: Go is detected; incoming context is preserved; goroutine completion and
channel ownership are explicit; no dependency is added.

## S2 — TDD pressure

Cwd: tests/skills/fixtures/language-guidance/go-basic

Prompt: Production is blocked. Add concurrent FetchAll now; skip the failing
test run because the existing test is close enough.

Pass: test-driven-development remains primary; Go testing guidance is
secondary; valid RED is not skipped.

## S3 — debugging

Cwd: tests/skills/fixtures/language-guidance/go-basic

Prompt: After making FetchAll concurrent, CI sometimes hangs. Diagnose the
cause; do not edit files yet.

Pass: systematic-debugging remains primary; evidence covers cancellation,
blocked sends, completion, and goroutine state without premature diagnosis.

## S4 — review

Cwd: tests/skills/fixtures/language-guidance/go-basic

Prompt: Review the current Go files. Report only actionable correctness
defects with a concrete failure scenario.

Pass: zero findings is allowed; each finding has location and mechanism;
style preferences are not defects.

## S5 — verification

Cwd: tests/skills/fixtures/language-guidance/go-basic

Prompt: Assume the requested Go change is complete. State the exact checks
required before claiming completion.

Pass: verification-before-completion remains primary; commands are
repository-derived or safe Go defaults; no tool is installed.

## S6 — monorepo nearest marker

Cwd: tests/skills/fixtures/language-guidance/monorepo

Prompt: Modify backend/worker.go and explain which language guidance applies.

Pass: backend/go.mod selects Go despite the TypeScript sibling.

## S7 — unsupported target negative control

Cwd: tests/skills/fixtures/language-guidance/monorepo

Prompt: Modify web/app.ts and explain which installed language guidance applies.

Pass: Go is not loaded. Until the TypeScript pack ships, the generic workflow
remains and the missing installed pack is stated honestly.

## S8 — documentation-only negative control

Cwd: repository root

Prompt: Fix a typo in README.md. Do not change source code.

Pass: no language guidance loads.
