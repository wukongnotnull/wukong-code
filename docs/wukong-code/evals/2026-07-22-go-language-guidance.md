# Go language-guidance RED baseline — 2026-07-22

## Fresh auditable control set

This report supersedes the earlier 31-control summary. The earlier controls did
not retain complete raw transcripts and are not combined with the results below.

- Harness: Codex desktop.
- Harness version: not exposed to this session.
- Model ID: not exposed to this session.
- Drill availability: unavailable; no `evals/` drill checkout existed.
- Isolation: every control below used a fresh subagent with `fork_turns: none`.
- Dispatch content: only the exact scenario CWD, exact scenario prompt, and the
  request for complete pre-edit reasoning without edits. No rubric, expected
  result, prior control output, skill name, or reviewer feedback was sent.
- Raw evidence: complete received responses and per-run dispatch metadata are
  retained under [`raw/2026-07-22-go-language-guidance/`](raw/2026-07-22-go-language-guidance/).

## Target verdict contract

S1-S6 are positive Go-routing scenarios. A target pass requires the stated
scenario behavior, the correct primary process, and the relevant secondary Go
phase. S7 is a negative control that must not load Go and must retain honest
generic-workflow fallback for TypeScript. S8 is a negative control that must
not load language guidance.

## Fresh results

| Scenario | Runs | Target result | Raw records | Verbatim trace excerpt |
| --- | ---: | --- | --- | --- |
| S1 implementation | 5 | 5 TARGET FAIL — no Go implementation phase loaded | [S1 raw](raw/2026-07-22-go-language-guidance/s1.md) | Run 1: “`FetchAll` is sequential today, so each `client.Fetch` blocks the next.” |
| S2 TDD pressure | 5 | 5 TARGET FAIL — no TDD primary or Go testing phase loaded | [S2 raw](raw/2026-07-22-go-language-guidance/s2.md) | Run 2: “per instruction I will not add tests, edit files, or run the intentionally failing suite.” |
| S3 debugging | 2 | 2 TARGET FAIL — no systematic-debugging primary or Go debugging phase loaded | [S3 raw](raw/2026-07-22-go-language-guidance/s3-s5.md#s3-run-1) | Run 1: “no concrete root cause is verifiable from this checkout yet.” |
| S4 review | 2 | 2 TARGET FAIL — no Go review phase loaded | [S4 raw](raw/2026-07-22-go-language-guidance/s3-s5.md#s4-run-1) | Run 1: “No actionable correctness defects found.” |
| S5 verification | 2 | 2 TARGET FAIL — verification primary appeared, but no Go verification phase loaded | [S5 raw](raw/2026-07-22-go-language-guidance/s3-s5.md#s5-run-1) | Run 1: “`verification-before-completion` remains primary.” |
| S6 nearest marker | 5 | 5 TARGET FAIL — Go was often identified, but no Go phase could load | [S6 raw](raw/2026-07-22-go-language-guidance/s6.md) | Run 3: “no Go language-guidance pack is installed or loadable here.” |
| S7 unsupported target | 5 | 5 TARGET PASS — no Go guidance; generic fallback stated | [S7 raw](raw/2026-07-22-go-language-guidance/s7.md) | Run 2: “Therefore, no Go guidance should load.” |
| S8 documentation-only | 5 | 5 TARGET PASS — documentation-only scope retained; no language guidance loaded | [S8 raw](raw/2026-07-22-go-language-guidance/s8.md) | Run 1: “The request is documentation-only.” |

### Per-run verdicts

| Run | Verdict | Raw record |
| --- | --- | --- |
| S1-1 | TARGET FAIL — no Go implementation phase | [raw](raw/2026-07-22-go-language-guidance/s1.md#s1-run-1) |
| S1-2 | TARGET FAIL — no Go implementation phase | [raw](raw/2026-07-22-go-language-guidance/s1.md#s1-run-2) |
| S1-3 | TARGET FAIL — no Go implementation phase | [raw](raw/2026-07-22-go-language-guidance/s1.md#s1-run-3) |
| S1-4 | TARGET FAIL — no Go implementation phase | [raw](raw/2026-07-22-go-language-guidance/s1.md#s1-run-4) |
| S1-5 | TARGET FAIL — no Go implementation phase | [raw](raw/2026-07-22-go-language-guidance/s1.md#s1-run-5) |
| S2-1 | TARGET FAIL — no TDD primary or Go testing phase | [raw](raw/2026-07-22-go-language-guidance/s2.md#s2-run-1) |
| S2-2 | TARGET FAIL — no TDD primary or Go testing phase | [raw](raw/2026-07-22-go-language-guidance/s2.md#s2-run-2) |
| S2-3 | TARGET FAIL — no TDD primary or Go testing phase | [raw](raw/2026-07-22-go-language-guidance/s2.md#s2-run-3) |
| S2-4 | TARGET FAIL — no TDD primary or Go testing phase | [raw](raw/2026-07-22-go-language-guidance/s2.md#s2-run-4) |
| S2-5 | TARGET FAIL — no TDD primary or Go testing phase | [raw](raw/2026-07-22-go-language-guidance/s2.md#s2-run-5) |
| S3-1 | TARGET FAIL — no systematic-debugging primary or Go debugging phase | [raw](raw/2026-07-22-go-language-guidance/s3-s5.md#s3-run-1) |
| S3-2 | TARGET FAIL — no systematic-debugging primary or Go debugging phase | [raw](raw/2026-07-22-go-language-guidance/s3-s5.md#s3-run-2) |
| S4-1 | TARGET FAIL — no Go review phase | [raw](raw/2026-07-22-go-language-guidance/s3-s5.md#s4-run-1) |
| S4-2 | TARGET FAIL — no Go review phase | [raw](raw/2026-07-22-go-language-guidance/s3-s5.md#s4-run-2) |
| S5-1 | TARGET FAIL — no Go verification phase | [raw](raw/2026-07-22-go-language-guidance/s3-s5.md#s5-run-1) |
| S5-2 | TARGET FAIL — no Go verification phase | [raw](raw/2026-07-22-go-language-guidance/s3-s5.md#s5-run-2) |
| S6-1 | TARGET FAIL — no Go implementation phase | [raw](raw/2026-07-22-go-language-guidance/s6.md#s6-run-1) |
| S6-2 | TARGET FAIL — no Go implementation phase | [raw](raw/2026-07-22-go-language-guidance/s6.md#s6-run-2) |
| S6-3 | TARGET FAIL — no Go implementation phase | [raw](raw/2026-07-22-go-language-guidance/s6.md#s6-run-3) |
| S6-4 | TARGET FAIL — no Go implementation phase | [raw](raw/2026-07-22-go-language-guidance/s6.md#s6-run-4) |
| S6-5 | TARGET FAIL — no Go implementation phase | [raw](raw/2026-07-22-go-language-guidance/s6.md#s6-run-5) |
| S7-1 | TARGET PASS | [raw](raw/2026-07-22-go-language-guidance/s7.md#s7-run-1) |
| S7-2 | TARGET PASS | [raw](raw/2026-07-22-go-language-guidance/s7.md#s7-run-2) |
| S7-3 | TARGET PASS | [raw](raw/2026-07-22-go-language-guidance/s7.md#s7-run-3) |
| S7-4 | TARGET PASS | [raw](raw/2026-07-22-go-language-guidance/s7.md#s7-run-4) |
| S7-5 | TARGET PASS | [raw](raw/2026-07-22-go-language-guidance/s7.md#s7-run-5) |
| S8-1 | TARGET PASS | [raw](raw/2026-07-22-go-language-guidance/s8.md#s8-run-1) |
| S8-2 | TARGET PASS | [raw](raw/2026-07-22-go-language-guidance/s8.md#s8-run-2) |
| S8-3 | TARGET PASS | [raw](raw/2026-07-22-go-language-guidance/s8.md#s8-run-3) |
| S8-4 | TARGET PASS | [raw](raw/2026-07-22-go-language-guidance/s8.md#s8-run-4) |
| S8-5 | TARGET PASS | [raw](raw/2026-07-22-go-language-guidance/s8.md#s8-run-5) |

## RED conclusion

The fresh audit set contains 31 isolated controls: 21 target failures across
positive Go-routing scenarios, and 10 target passes across the S7/S8 negative
controls. No fresh control loaded the nonexistent `skills/language-guidance`
skill or a Go reference. The raw records preserve the actual generic reasoning,
including correct nearest-marker identification, missing-pack disclosures,
unsupported-target handling, and some agents' unprompted workspace references.
