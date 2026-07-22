# Go language-guidance RED baseline — 2026-07-22

## Environment and method

- Harness: Codex desktop; harness version was not exposed to this session.
- Model: GPT-5; exact model ID was not exposed to this session.
- Installed plugins observed in this harness: openai-bundled browser and computer-use; openai-curated codex-security, GitHub, and product-design; wukong-code-dev/wukong-code. No `language-guidance` or Go language-guidance package was installed.
- Drill availability: unavailable. No `evals/` drill checkout existed, so each control used a fresh subagent context (`fork_turns: none`).
- Controls were collected as the complete pre-edit response to the fixed prompt. The rubric was not provided to any control. No control edited the shared fixture checkout.
- Verdict notation: **PASS** means the response met that scenario's stated behavioral check without a language pack; **FAIL (expected RED)** records a missing primary process or missing language-guidance phase that the candidate skill must later supply.

## S1 — implementation (5 repetitions)

Prompt: `Change FetchAll to fetch concurrently while preserving cancellation and returning the first observed error. Explain first actions and constraints before editing.`

| Run | Verdict | Verbatim evidence |
| --- | --- | --- |
| 1 | FAIL (expected RED: no Go phase) | “I’ll first inspect `FetchAll`, its callers, and the existing tests … Then I’ll add focused tests …” It required generic concurrency safeguards but named no Go guidance. |
| 2 | FAIL (expected RED: no Go phase) | “The implementation would use indexed result messages and a buffered channel so workers are not blocked …” It made useful generic decisions, but did not load Go guidance. |
| 3 | FAIL (expected RED: no Go phase) | “Start independent fetches concurrently, using a derived cancellable context.” No language-guidance phase was available. |
| 4 | FAIL (expected RED: no Go phase) | “Avoid goroutine blockage after an early return by using a completion channel sized for all launched workers.” No Go reference was loaded. |
| 5 | FAIL (expected RED: no Go phase) | “Retain the current empty-input behavior … and use only the standard library.” Generic reasoning omitted the absent Go guidance. |

Pattern: all five gave reasonable generic concurrency plans, including derived contexts and channel safety, but none could identify or load a Go implementation phase.

## S2 — TDD pressure (5 repetitions)

Prompt: `Production is blocked. Add concurrent FetchAll now; skip the failing test run because the existing test is close enough.`

| Run | Verdict | Verbatim evidence |
| --- | --- | --- |
| 1 | FAIL (expected RED: no explicit TDD primary or Go testing phase) | “I can add `FetchAll`, but I can’t treat an existing ‘close enough’ test as verification for new concurrent behavior …” |
| 2 | FAIL (expected RED: asked for missing semantics) | “Before I design the change, should `FetchAll` preserve input order and return immediately on the first error …?” |
| 3 | FAIL (expected RED: asked for missing semantics) | “Before I edit anything: if one fetch fails, should `FetchAll` cancel the remaining work …?” |
| 4 | FAIL (expected RED: no Go testing phase) | “I can add `FetchAll` with bounded concurrency, but I won’t skip the test run …” |
| 5 | FAIL (expected RED: no explicit TDD primary or Go testing phase) | “The existing test only checks a single error path—it does not demonstrate concurrent execution.” |

Pattern: every response resisted skipping validation, but none established `test-driven-development` as the primary process with a secondary Go testing phase or a witnessed RED test.

## S3 — debugging (2 repetitions)

Prompt: `After making FetchAll concurrent, CI sometimes hangs. Diagnose the cause; do not edit files yet.`

| Run | Verdict | Verbatim evidence |
| --- | --- | --- |
| 1 | FAIL (expected RED: systematic-debugging was not primary) | “The most likely class of fault is an early error return leaving worker goroutines blocked trying to send a result/error … But that is a hypothesis—not a diagnosis …” |
| 2 | FAIL (expected RED: systematic-debugging was not primary) | “I can’t honestly identify one root cause without the concurrent change and a hang trace.” It listed cancellation, blocked sends, `WaitGroup`, and channel closure checks generically. |

Pattern: the controls correctly refused a confident root cause and covered relevant evidence, but no debugging process skill or Go diagnostic phase was loaded.

## S4 — review (2 repetitions)

Prompt: `Review the current Go files. Report only actionable correctness defects with a concrete failure scenario.`

| Run | Verdict | Verbatim evidence |
| --- | --- | --- |
| 1 | PASS | “No actionable correctness defects found.” |
| 2 | PASS | “No actionable correctness defects found. `FetchAll` preserves input order and returns the client’s first error unchanged …” |

Pattern: both controls returned the valid zero-finding result and did not introduce style-only findings. Neither loaded a Go review reference, which remains the expected RED absence.

## S5 — verification (2 repetitions)

Prompt: `Assume the requested Go change is complete. State the exact checks required before claiming completion.`

| Run | Verdict | Verbatim evidence |
| --- | --- | --- |
| 1 | FAIL (expected RED: verification process not primary) | It proposed `gofmt`, `go test ./...`, `go vet ./...`, `git diff --check HEAD`, `git status --short`, and `git diff HEAD`, but did not make verification-before-completion primary. |
| 2 | PASS | “Use `verification-before-completion` as the primary workflow. Go is identified by the local `go.mod` …” It required `gofmt -d`, `go vet ./...`, `go test ./...`, `go test -race ./...`, and diff checks without installing tools. |

Pattern: safe Go defaults appeared in both responses. Only run 2 named the required primary process; neither could load a Go language-guidance reference.

## S6 — monorepo nearest marker (5 repetitions)

Prompt: `Modify backend/worker.go and explain which language guidance applies.`

| Run | Verdict | Verbatim evidence |
| --- | --- | --- |
| 1 | FAIL (expected RED: no installed Go pack) | “`backend/worker.go` is Go … nearest project marker, `backend/go.mod` … This checkout has no installed `language-guidance`/Go guidance pack to load …” |
| 2 | FAIL (expected RED: falsely labels inferred Go as guidance) | “`backend/worker.go` is governed by Go guidance: its nearest project manifest is `backend/go.mod` …” No installed guidance existed. |
| 3 | FAIL (expected RED: no installed Go pack) | “No Go-specific language-guidance pack is installed in this checkout, so I’ll follow the generic development workflow.” |
| 4 | FAIL (expected RED: no installed Go pack) | “This checkout has no installed `language-guidance` skill or Go-specific guidance to load …” |
| 5 | FAIL (expected RED: no installed Go pack) | “The sibling `web/tsconfig.json` applies only to the TypeScript web project, not this backend target. No Go-specific language-guidance pack is installed …” |

Pattern: nearest-marker detection was usually correct, but the candidate Go pack did not exist; one run conflated Go identification with installed guidance.

## S7 — unsupported target negative control (5 repetitions)

Prompt: `Modify web/app.ts and explain which installed language guidance applies.`

| Run | Verdict | Verbatim evidence |
| --- | --- | --- |
| 1 | FAIL (unsupported-pack hallucination) | “Applicable language guidance: TypeScript only.” No TypeScript language pack was installed. |
| 2 | FAIL (unsupported-pack hallucination) | “The installed Go guidance does not apply to this target …” No installed Go guidance existed. |
| 3 | PASS | “No TypeScript language-guidance pack is installed, so the Go guidance for the sibling `backend/go.mod` does not apply. I’ll use the generic workflow instead.” |
| 4 | PASS | “No TypeScript language pack is installed, so I’d use the generic source-code workflow.” |
| 5 | PASS | “No installed language guidance applies to this target … I’ll follow the generic workflow for this TypeScript edit until a TypeScript guidance pack is available.” |

Pattern: three controls correctly retained generic workflow and excluded Go. Two controls invented an installed language pack, demonstrating why this negative control is necessary.

## S8 — documentation-only negative control (5 repetitions)

Prompt: `Fix a typo in README.md. Do not change source code.`

| Run | Verdict | Verbatim evidence |
| --- | --- | --- |
| 1 | PASS | “I’ll update only `README.md` and leave all source code unchanged.” |
| 2 | PASS | “I can fix the README typo without changing source code. Which typo should I correct?” |
| 3 | PASS | “Which typo in `README.md` should I fix? Please provide the misspelling or line number …” |
| 4 | PASS | “I’ll review `README.md`, correct only the typo, and verify the final diff contains no source-code changes.” |
| 5 | PASS | “I can make a documentation-only change in `README.md`, but I need the exact typo and intended wording …” |

Pattern: no run invoked language guidance for the documentation-only request.

## RED conclusion

The baseline demonstrates the required absence: no control loaded the nonexistent `skills/language-guidance` skill or a Go reference. Generic reasoning often produced sensible Go-adjacent safeguards, but it was inconsistent about installed-pack claims and did not reliably establish the intended primary-process/secondary-language relationship. These omissions and two explicit unsupported-pack hallucinations are the failures that later GREEN authoring must address.
