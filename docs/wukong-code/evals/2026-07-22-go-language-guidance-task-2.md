# Task 2 — Go Language Guidance Pack Evidence

## Scope boundary

Task 2 delivers the standalone router, Go references, and static contract. Its
behavioral evidence is intentionally limited to two clean explicit-invocation
S1 smoke runs. The primary process and automatic secondary-language routing are
not one executable path until Task 3 updates `using-wukong-code`.

Task 3 owns the complete S1-S8 automatic-routing GREEN matrix. No partial
standalone S2 evidence is claimed as a behavioral GREEN result.

## Static RED

Before any production pack file existed, `bash tests/skills/test-language-guidance.sh`
exited 1 with `STATUS: FAILED`: all language-guidance paths were missing. That
was the expected static-contract RED.

## Static GREEN

After the Go-only pack was added, the language-guidance contract passed, the
existing slim gates passed, and `git diff --check` was silent. The contract
validates the registry, Go-only phase files, line budgets, required skill text,
and absence of installer commands.

## Explicit-invocation smoke evidence

Two fresh isolated S1 runs explicitly supplied the candidate skill artifact.
Both detected Go from target files and the nearest `go.mod`, selected the
implementation phase, loaded only `go/profile.md` and `go/implementation.md`,
kept the standard library, made goroutine ownership/cancellation explicit, and
reported focused RED/GREEN plus Go verification. Their complete chronological
transcripts are retained outside the repository for the controller record.

## Official sources used

- [testing package](https://pkg.go.dev/testing): informed `t.Cleanup` and the
  testing guidance.
- [Go Concurrency Patterns: Context](https://go.dev/blog/context): informed
  context propagation and cancellation guidance.
- [Contexts and structs](https://go.dev/blog/context-and-structs): informed
  context-first parameters and avoiding context storage in structs.
- [Data Race Detector](https://go.dev/doc/articles/race_detector): informed
  `-race` usage and its executed-path limitation.
- [Security Best Practices for Go Developers](https://go.dev/doc/security/best-practices):
  informed the Go tooling and security posture.

## Limitations

The standalone-pack behavior campaign was deliberately not completed. Repeated
S2 attempts exposed routing interactions that belong to the Task 3 integration
surface, not to a standalone pack claim. A trial of `codex exec --json` also
did not start inference because the local Codex CLI reported a usage limit.
The system `quick_validate.py` could not run because its environment lacks the
`yaml` module; Task 2 uses manual frontmatter and JSON validation instead and
does not install PyYAML.
