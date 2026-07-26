# Go language-guidance sanitized RED baseline — 2026-07-22

## Supersession and methodology

This report **supersedes, and does not combine with, the 31 controls in `7c24b81`**. Those agents could read the scenario/rubric material from the main worktree. This replacement used only `/tmp/wukong-lg-controls.OqrLdG`, a standalone temporary Git repository containing fixture files and `README.md`; it contained no plan, scenario document, rubric, or earlier evidence.

- Harness: Codex desktop; harness version: not exposed.
- Controller dispatch model: `gpt-5.6-terra`, low reasoning effort; child model ID otherwise not exposed.
- Installed-plugin inventory: not exposed to the controls.
- Drill checkout: unavailable; the provided sanitized temporary repository was used instead.
- Isolation: 31 fresh children, each dispatched with `fork_turns: none`.
- Dispatch text: exactly a sanitized CWD, the fixed scenario request, and `Return your complete pre-edit reasoning and intended response. Do not modify files.`
- Raw evidence: complete received responses and exact dispatch metadata are preserved under [raw/2026-07-22-go-language-guidance/](raw/2026-07-22-go-language-guidance/). Neutral sample IDs were mapped to scenarios only after collection.

## Verdict contract

S1-S6 are positive Go-routing cases: a pass requires the stated behavior, correct primary process, Go identified from target or nearest-marker evidence, and the relevant Go phase loaded secondarily. S7 is a negative control: no Go guidance and an honest generic fallback for the unsupported TypeScript target. S8 is a documentation-only negative control: no language guidance.

## Results

| Scenario | Runs | Result | Raw evidence |
| --- | ---: | --- | --- |
| S1 implementation | 5 | 5 TARGET FAIL — no explicit Go implementation phase | [S1](raw/2026-07-22-go-language-guidance/s1.md) |
| S2 TDD pressure | 5 | 5 TARGET FAIL — no TDD primary or Go testing phase | [S2](raw/2026-07-22-go-language-guidance/s2.md) |
| S3 debugging | 2 | 2 TARGET FAIL — no systematic-debugging primary or Go debugging phase | [S3](raw/2026-07-22-go-language-guidance/s3-s5.md#s3-run-1) |
| S4 review | 2 | 2 TARGET FAIL — no Go review phase | [S4](raw/2026-07-22-go-language-guidance/s3-s5.md#s4-run-1) |
| S5 verification | 2 | 2 TARGET FAIL — no verification primary or Go verification phase | [S5](raw/2026-07-22-go-language-guidance/s3-s5.md#s5-run-1) |
| S6 nearest marker | 5 | 5 TARGET FAIL — Go was identified, but the required process/Go implementation phase was absent | [S6](raw/2026-07-22-go-language-guidance/s6.md) |
| S7 unsupported target | 5 | 3 TARGET PASS, 2 TARGET FAIL — three runs honestly retained generic fallback; two claimed unavailable TypeScript guidance | [S7](raw/2026-07-22-go-language-guidance/s7.md) |
| S8 documentation-only | 5 | 5 TARGET PASS — documentation-only scope retained; no language guidance | [S8](raw/2026-07-22-go-language-guidance/s8.md) |

### Per-run verdicts

| Neutral sample | Scenario | Verdict |
| --- | --- | --- |
| sample_001 | S1 | TARGET FAIL |
| sample_002 | S1 | TARGET FAIL |
| sample_003 | S1 | TARGET FAIL |
| sample_004 | S1 | TARGET FAIL |
| sample_005 | S1 | TARGET FAIL |
| sample_006 | S2 | TARGET FAIL |
| sample_007 | S2 | TARGET FAIL |
| sample_008 | S2 | TARGET FAIL |
| sample_009 | S2 | TARGET FAIL |
| sample_010 | S2 | TARGET FAIL |
| sample_011 | S3 | TARGET FAIL |
| sample_012 | S3 | TARGET FAIL |
| sample_013 | S4 | TARGET FAIL |
| sample_014 | S4 | TARGET FAIL |
| sample_015 | S5 | TARGET FAIL |
| sample_016 | S5 | TARGET FAIL |
| sample_017 | S6 | TARGET FAIL |
| sample_018 | S6 | TARGET FAIL |
| sample_019 | S6 | TARGET FAIL |
| sample_020 | S6 | TARGET FAIL |
| sample_021 | S6 | TARGET FAIL |
| sample_022 | S7 | TARGET PASS |
| sample_023 | S7 | TARGET FAIL |
| sample_024 | S7 | TARGET PASS |
| sample_025 | S7 | TARGET FAIL |
| sample_026 | S7 | TARGET PASS |
| sample_027 | S8 | TARGET PASS |
| sample_028 | S8 | TARGET PASS |
| sample_029 | S8 | TARGET PASS |
| sample_030 | S8 | TARGET PASS |
| sample_031 | S8 | TARGET PASS |

## Conclusion

The clean replacement set contains **31/31 complete responses**: **8 TARGET PASS** and **23 TARGET FAIL**. No complete response cites the main worktree’s scenario file, plan, RED/GREEN status, or rubric, and no response uses an S label obtained from a child task name (all child task names were neutral sequential identifiers). The outcomes are not combined with the contaminated `7c24b81` controls.

## Fresh pre-fix S1 probe — 2026-07-26

- Environment: fresh candidate runtime from
  `/private/tmp/wukong-lg-task3-green.OrbOyc/eval/go-basic`.
- Raw output: `/private/tmp/wukong-lg-task3-green.OrbOyc/s1-run-1.txt`.
- Result: TARGET FAIL. The response gave a semantically plausible Go
  concurrency approach, including `context.WithCancel`, `sync`, ordered
  results, and focused tests, but did not visibly invoke `language-guidance`
  or state the required `Detected:`, `Phase:`, and `Loaded:` decision.

This is one failed pre-fix S1 probe; it does not establish a full-matrix result.

## Post-install runtime result — 2026-07-26

Both the pre-fix and mandatory-wording S1 probes returned plausible Go
guidance but omitted the visible `Detected:`, `Phase:`, and `Loaded:` decision;
therefore the automatic path is advisory. This is not a pass claim for the
full automatic matrix.
