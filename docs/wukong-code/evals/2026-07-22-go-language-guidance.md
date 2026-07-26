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

- Checked-in fixture: [`tests/skills/fixtures/language-guidance/go-basic/`](../../../tests/skills/fixtures/language-guidance/go-basic/), containing `fetch.go`, `fetch_test.go`, and the `go.mod` nearest marker.
- Fixture module marker: `module example.com/language-guidance-fixture`; its declared language version is `go 1.22`.
- Verified local toolchain: `go version go1.26.1 darwin/arm64` on 2026-07-26.
- Focused fixture verification: `env GOCACHE=/private/tmp/wukong-language-guidance-go-cache go test ./...` in that fixture exited 0 and printed `ok example.com/language-guidance-fixture 2.351s`.
- Default-cache context: the earlier `go test ./...` printed successful package output, then the sandbox denied Go build-cache trimming and that command exited 1. It is not counted as a passing command.
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

## Explicit strict runtime probe — 2026-07-26

- Candidate commit: `cf597a0`.
- Harness: Codex CLI `0.135.0`, model `gpt-5.5`, read-only sandbox.
- Isolation: a fresh temporary `CODEX_HOME` installed only the candidate
  marketplace; the normal Codex configuration was restored byte-for-byte
  afterward.
- Prompt: `$language-guidance: Inspect FetchAll and explain the concrete Go
  implementation approach. Do not edit files.`
- Result: PASS for the explicit strict path. The fresh session injected
  `wukong-code:language-guidance` and emitted three independent decision lines:
  `Detected: Go ...`, `Phase: implementation`, and `Loaded:` with the selected
  `references/go/profile.md` and `references/go/implementation.md` paths; see
  the [sanitized transcript](raw/2026-07-26-explicit-language-guidance.md).

This verifies the explicit invocation contract once. It does not change the
automatic path from advisory to guaranteed, and it is not a full behavior-matrix
pass claim.

## Final-candidate regression and explicit rerun — 2026-07-26

- Candidate implementation commit under test: `d7f4285ce8718bdd07c9317e4e1149a85a1eb9e1`.
- Finalizer harness: Codex desktop; harness version and model identifier were
  not exposed to this report-writing session.
- Explicit rerun harness: Codex CLI `0.135.0`, model `gpt-5.5`, read-only
  sandbox. A fresh temporary `CODEX_HOME` installed only
  `wukong-code@wukong-code-dev` version `6.2.1` from the candidate checkout.

### Fresh local command summary

| Command | Exit | Result |
| --- | ---: | --- |
| `bash tests/skills/test-language-guidance.sh` | 0 | Static language-pack, bootstrap, metadata, and documentation contracts passed. |
| `bash tests/skills/test-skill-slim-gates.sh` | 0 | All four skill size gates passed. |
| `bash tests/hooks/test-session-start.sh` | 0 | All seven hook assertions passed. |
| `bash tests/opencode/run-tests.sh` | 0 | 2 passed, 0 failed; integration tests were not run. |
| `bash tests/kimi/run-tests.sh` | 0 | Kimi plugin manifest check passed. |
| `node --test tests/pi/test-pi-extension.mjs` | 0 | 7 passed, 0 failed. |
| `bash tests/codex/test-package-codex-plugin.sh` | 9 | Linked-worktree checkout guard failed before archive assertions. |
| same package test in an isolated normal clone at `d7f4285` | 1 | Archive behavior passed except the two known timezone-sensitive timestamp assertions: ZIP expected midnight but observed 08:00, and tar expected Dec 31 1969 but observed Jan 1 1970. |
| `bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh` | 0 | All sync regression assertions passed. |
| `bash scripts/lint-shell.sh` | 1 | Unverified: required `shellcheck` executable was not on `PATH`. |
| `git diff --check` | 0 | No whitespace errors before this evidence-only edit. |

Missing `shellcheck` is an unverified limit, not a lint pass. The linked-worktree
package result is also not a pass; the normal-clone rerun separates that guard
from the two reproduced timezone-sensitive failures.

### Final-candidate explicit strict probe

The exact saved prompt was rerun because `47a95a6` changed the strict timing
sentence after the earlier `cf597a0` probe. The candidate bootstrap injected
both `wukong-code:using-wukong-code` and `wukong-code:language-guidance`. Before
inspecting the fixture, the response emitted these three visible lines:

```text
Detected: Go from the user’s explicit target and the local fixture path `go-basic`.
Phase: profile
Loaded: `/private/tmp/.../skills/language-guidance/references/go/profile.md`
```

The response later said, `I’m also loading the Go implementation reference`,
and only then read `references/go/implementation.md`. Verdict: **TARGET FAIL**
for the final-candidate strict path. Although all three labels were visible,
the same implementation-approach prompt that selected `Phase: implementation`
and both references in the saved passing run instead selected `profile` and one
reference initially, then expanded the loaded set after substantive inspection.
The process exited 0 and produced sound Go advice, but exit status is not
behavioral-contract evidence.

### Post-fix explicit reference-set probe

- Candidate fix commit: `10dc86f` (`fix: keep explicit language references declared`).
- Isolation and exact prompt: a new temporary `CODEX_HOME` installed only the
  candidate plugin, then Codex CLI `0.135.0` with model `gpt-5.5` and a
  read-only sandbox received the same explicit prompt shown above.
- Installed-skill check: the isolated cache contained the new prohibition on
  loading another language reference without a new complete decision.
- Visible decision:

```text
Detected: Go, from explicit user request and `go-basic` fixture path
Phase: profile
Loaded: `/private/tmp/.../skills/language-guidance/references/go/profile.md`
```

Result: **TARGET PASS for the reference-set invariant in this one run**. The
session read `references/go/profile.md`, inspected the fixture, and returned
concrete Go advice. It did not load `references/go/implementation.md` or any
other language reference after the decision, so every language reference read
was declared in the visible `Loaded:` line. The process exited 0. This focused
pass does not erase the preceding `d7f4285` failure or establish a full
automatic or explicit behavior matrix.

### Before/after and unsupported-language boundary

- Sanitized no-guidance baseline: 31/31 runs completed, with 8 TARGET PASS and
  23 TARGET FAIL; all 21 positive S1-S6 Go-routing controls failed.
- Automatic candidate path: the retained S1 probes omitted the visible decision,
  so automatic selection remains advisory and no automatic matrix pass is claimed.
- Explicit path: one isolated run at `cf597a0` passed; the `d7f4285` rerun
  failed as described above; and the focused reference-set rerun at `10dc86f`
  passed once. This establishes the corrected reference-set behavior for one
  post-fix run, not a full explicit behavior matrix.
- No positive TypeScript routing run was performed or passed. TypeScript remains
  unsupported/planned. The two inconsistent S7 baseline excerpts remain fully
  preserved in the raw evidence: run 2 invented TypeScript `profile.md` and
  `implementation.md` guidance, while run 4 said TypeScript guidance applies
  despite also reporting no installed language-specific skill.

The evidence supports the Go pack's static structure, one historical strict
explicit success, and one focused post-fix reference-set success. It does not
support guaranteed automatic routing, a positive TypeScript pack, a pristine
full local regression, or a full explicit behavior matrix. Human review by
someone familiar with Go remains a release gate for the reference content.

## Maintenance responsibility

Wukong Code language-guidance maintainers; stable status requires review by a
human familiar with Go.
