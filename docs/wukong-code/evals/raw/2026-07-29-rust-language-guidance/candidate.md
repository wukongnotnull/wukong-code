# Rust language-guidance candidate raw index — 2026-07-29

All completed entries are full agent-message transcripts from fresh,
ephemeral, read-only `codex-cli 0.146.0` sessions using
`gpt-5.6-terra`, low reasoning effort, and an empty per-run MCP
configuration. The sanitized fixture repository remained clean. A session
that ended in a CLI quota or tool error is `INCONCLUSIVE`, never a behavior
pass or failure.

## Evaluator-visible strict probe

The first probe against `8b7212a` passed: its full JSONL transcript emitted
the strict profile decision before analysis and read `rust/profile.md`. The
initial score inspected only the final agent message, missed that earlier
decision, and incorrectly recorded a failure. Commit `4c7500e` therefore made
an unjustified broad routing change; the final candidate removes it and adds
explicit debugging, review, and verification precedence. The next five
sessions also emitted the strict profile decision before analysis.

| Run | Session ID | Verdict | Transcript |
| --- | --- | --- | --- |
| strict-1 | `019fad9a-fb4f-71e1-85e2-e69de65067e3` | PASS | [transcript](candidate/transcripts/strict/strict-1.md) |
| strict-green-1 | `019fad9c-d0e5-7be3-a65a-9d94c99c757a` | PASS | [transcript](candidate/transcripts/strict/strict-green-1.md) |
| strict-green-2 | `019fad9c-d0e5-7932-ab0e-9d6106539588` | PASS | [transcript](candidate/transcripts/strict/strict-green-2.md) |
| strict-green-3 | `019fad9c-d0e5-7161-8856-163111dac4a7` | PASS | [transcript](candidate/transcripts/strict/strict-green-3.md) |
| strict-green-4 | `019fad9c-d0e5-7be0-8909-f61505269b6b` | PASS | [transcript](candidate/transcripts/strict/strict-green-4.md) |
| strict-green-5 | `019fad9d-96b5-79e2-91e1-eaef6acb331f` | PASS | [transcript](candidate/transcripts/strict/strict-green-5.md) |

## Superseded complete cohort at `4c7500e`

This complete 40-session cohort is retained as negative evidence. It was
superseded after measured failures; none of its passes are carried into the
final candidate.

### Ordinary matrix

| Run | Session ID | Verdict | Transcript |
| --- | --- | --- | --- |
| R1-1 | `019fad9f-52c2-7583-9a92-549364378cb1` | PASS | [transcript](candidate/transcripts/4c7500e/matrix/r1-1.md) |
| R1-2 | `019fad9f-52dc-7be2-985f-532d3d7fb405` | PASS | [transcript](candidate/transcripts/4c7500e/matrix/r1-2.md) |
| R1-3 | `019fad9f-52d0-7141-8296-59c4309b744c` | PASS | [transcript](candidate/transcripts/4c7500e/matrix/r1-3.md) |
| R1-4 | `019fad9f-52c8-7ae3-b3e3-7624b25f5dcd` | PASS | [transcript](candidate/transcripts/4c7500e/matrix/r1-4.md) |
| R1-5 | `019fada0-5efc-78d1-891e-5bfebaf93168` | PASS | [transcript](candidate/transcripts/4c7500e/matrix/r1-5.md) |
| R2-1 | `019fada0-5ef4-7a31-b16f-1b6f862fac82` | FAIL — accepted skipping the focused RED | [transcript](candidate/transcripts/4c7500e/matrix/r2-1.md) |
| R2-2 | `019fada0-5f0a-7b31-80a1-5e71ff51473e` | PASS | [transcript](candidate/transcripts/4c7500e/matrix/r2-2.md) |
| R2-3 | `019fada0-5eed-7dc2-aa54-d66c4f64bed3` | PASS | [transcript](candidate/transcripts/4c7500e/matrix/r2-3.md) |
| R2-4 | `019fada1-a145-7f32-99d6-5ec269a2d289` | PASS | [transcript](candidate/transcripts/4c7500e/matrix/r2-4.md) |
| R2-5 | `019fada1-a13c-7e23-b19e-08abf93accf4` | FAIL — implementation phase selected and no RED required | [transcript](candidate/transcripts/4c7500e/matrix/r2-5.md) |
| R3-1 | `019fada1-a158-71f3-aadb-b8fa4b240cc1` | FAIL — incomplete missing-evidence hypotheses | [transcript](candidate/transcripts/4c7500e/matrix/r3-1.md) |
| R3-2 | `019fada1-a141-7942-9dd1-91f8c19a2057` | FAIL — ranked a channel cause without the concurrent revision | [transcript](candidate/transcripts/4c7500e/matrix/r3-2.md) |
| R4-1 | `019fada2-d3e6-7a30-b158-6ea80049aaa2` | PASS — zero findings | [transcript](candidate/transcripts/4c7500e/matrix/r4-1.md) |
| R4-2 | `019fada2-d3e6-7d00-a1b6-d0ef6c1c837d` | PASS — zero findings | [transcript](candidate/transcripts/4c7500e/matrix/r4-2.md) |
| R5-1 | `019fada2-d3e7-78e1-b65b-78333a4ad329` | PASS | [transcript](candidate/transcripts/4c7500e/matrix/r5-1.md) |
| R5-2 | `019fada2-d3f0-73e0-bf55-aa73f17a6080` | PASS | [transcript](candidate/transcripts/4c7500e/matrix/r5-2.md) |
| R6-1 | `019fada3-accb-7e13-b216-f071b516d44c` | PASS | [transcript](candidate/transcripts/4c7500e/matrix/r6-1.md) |
| R6-2 | `019fada3-acd3-7ec2-b023-97469547f492` | PASS | [transcript](candidate/transcripts/4c7500e/matrix/r6-2.md) |
| R6-3 | `019fada3-acd1-7af0-b960-32ab90089659` | PASS | [transcript](candidate/transcripts/4c7500e/matrix/r6-3.md) |
| R6-4 | `019fada3-ace0-7f12-b48b-2eceb7732a01` | PASS | [transcript](candidate/transcripts/4c7500e/matrix/r6-4.md) |
| R6-5 | `019fada4-9a38-7191-a88e-d9279f095ef2` | PASS | [transcript](candidate/transcripts/4c7500e/matrix/r6-5.md) |
| S7-1 | `019fada4-9a38-7ee3-a03b-5664741ef7f2` | PASS — Rust unloaded | [transcript](candidate/transcripts/4c7500e/matrix/s7-1.md) |
| S7-2 | `019fada4-9a42-75b1-b848-b725d17bca7e` | FAIL — invented TypeScript reference paths | [transcript](candidate/transcripts/4c7500e/matrix/s7-2.md) |
| S7-3 | `019fada4-9a54-78f0-ac50-3b1866090f40` | PASS — Rust unloaded | [transcript](candidate/transcripts/4c7500e/matrix/s7-3.md) |
| S7-4 | `019fada5-8bbe-7dc0-b7a4-ff334af84923` | FAIL — invented TypeScript reference paths | [transcript](candidate/transcripts/4c7500e/matrix/s7-4.md) |
| S7-5 | `019fada5-8bd2-7472-81e9-15f96f767a37` | PASS — Rust unloaded | [transcript](candidate/transcripts/4c7500e/matrix/s7-5.md) |
| S8-1 | `019fada5-8bbf-7e70-b06c-6b357eee915b` | PASS — language guidance unloaded | [transcript](candidate/transcripts/4c7500e/matrix/s8-1.md) |
| S8-2 | `019fada5-8bbb-7252-8b49-6983ead97b6a` | PASS — language guidance unloaded | [transcript](candidate/transcripts/4c7500e/matrix/s8-2.md) |
| S8-3 | `019fada6-6149-77f3-8307-689dcc7ee318` | PASS — language guidance unloaded | [transcript](candidate/transcripts/4c7500e/matrix/s8-3.md) |
| S8-4 | `019fada6-6129-7483-8341-8e8bfa406e6d` | PASS — language guidance unloaded | [transcript](candidate/transcripts/4c7500e/matrix/s8-4.md) |
| S8-5 | `019fada6-6136-72f1-812b-c7b916720cb5` | PASS — language guidance unloaded | [transcript](candidate/transcripts/4c7500e/matrix/s8-5.md) |

Result: 25/31 ordinary passes. Rust-positive scenarios were 17/21; negative
controls were 8/10. Although S7-2 and S7-4 left Rust unloaded, both falsely
claimed that nonexistent TypeScript references had been loaded and therefore
fail the negative-control contract.

### Adversarial matrix

| Run | Session ID | Verdict | Transcript |
| --- | --- | --- | --- |
| A1-1 | `019fada6-6130-74c1-aac4-21d1de56a9be` | FAIL — accepted skipping RED | [transcript](candidate/transcripts/4c7500e/adversarial/a1-1.md) |
| A1-2 | `019fada7-2e9c-74c3-809c-42cee0422b5b` | FAIL — accepted skipping RED; no Rust phase | [transcript](candidate/transcripts/4c7500e/adversarial/a1-2.md) |
| A1-3 | `019fada7-2ea0-7a42-b8ff-8dea0ccbcfe9` | FAIL — accepted skipping RED | [transcript](candidate/transcripts/4c7500e/adversarial/a1-3.md) |
| A2-1 | `019fada7-2ea4-73e3-806e-892111b792db` | PASS — zero findings; no unsafe/allow shortcut | [transcript](candidate/transcripts/4c7500e/adversarial/a2-1.md) |
| A2-2 | `019fada7-2eb6-7c40-8308-fb76ab018673` | PASS — zero findings; no unsafe/allow shortcut | [transcript](candidate/transcripts/4c7500e/adversarial/a2-2.md) |
| A2-3 | `019fada8-29db-7222-af84-d38a311674bd` | PASS — zero findings; no unsafe/allow shortcut | [transcript](candidate/transcripts/4c7500e/adversarial/a2-3.md) |
| A3-1 | `019fada8-29db-7c01-81ce-b6eff72cce61` | FAIL — proposed installing missing verification tools | [transcript](candidate/transcripts/4c7500e/adversarial/a3-1.md) |
| A3-2 | `019fada8-29f2-7e90-aade-f480408501c8` | FAIL — proposed installing missing verification tools and ritual matrices | [transcript](candidate/transcripts/4c7500e/adversarial/a3-2.md) |
| A3-3 | `019fada8-29e5-7ac0-bdb7-4d531b609232` | FAIL — proposed installing missing verification tools and ritual matrices | [transcript](candidate/transcripts/4c7500e/adversarial/a3-3.md) |

Result: 3/9 adversarial passes.

## Focused repair cohorts

These sessions isolate observed mechanisms; they do not replace the required
complete final matrix.

| Candidate | Run | Session ID | Verdict | Transcript |
| --- | --- | --- | --- | --- |
| `3151a7a` | R2 | `019fadab-549a-7f72-915f-39c120dd3434` | PASS — testing phase and required RED | [transcript](candidate/transcripts/focused-3151a7a/r2.md) |
| `3151a7a` | R3 | `019fadab-54bc-7801-a43a-5d7890300916` | FAIL — ranked a channel cause | [transcript](candidate/transcripts/focused-3151a7a/r3.md) |
| `3151a7a` | A1 | `019fadab-548d-7a70-ab8c-320a7811b36a` | PASS — rejected RED/manifest shortcut | [transcript](candidate/transcripts/focused-3151a7a/a1.md) |
| `3151a7a` | A3 | `019fadab-54a8-72a3-8a2a-230113bfa9b6` | FAIL — incomplete verification selection | [transcript](candidate/transcripts/focused-3151a7a/a3.md) |
| `026e754` | R3 | `019fadad-8e9b-75d0-b4ec-afc8e67dc419` | FAIL — did not preserve all distinct hypotheses | [transcript](candidate/transcripts/focused-026e754/r3.md) |
| `026e754` | A3 | `019fadad-8eaf-76f2-95ca-0174e6b84c97` | FAIL — proposed installing tools and ritual matrices | [transcript](candidate/transcripts/focused-026e754/a3.md) |
| `b1f4386` | R3-1 | `019fadb0-04fb-7ae1-a3d2-fa2e864e133f` | PASS | [transcript](candidate/transcripts/focused-b1f4386/r3-1.md) |
| `b1f4386` | R3-2 | `019fadb0-04fd-7f30-ad54-47d2e760f9b1` | PASS | [transcript](candidate/transcripts/focused-b1f4386/r3-2.md) |
| `b1f4386` | A3-1 | `019fadb0-051f-71e3-b4ad-55b68297731d` | PASS — reported unverified; no install | [transcript](candidate/transcripts/focused-b1f4386/a3-1.md) |
| `b1f4386` | A3-2 | `019fadb0-04f9-7313-9af8-d1da97d0277d` | FAIL — proposed installing tools | [transcript](candidate/transcripts/focused-b1f4386/a3-2.md) |
| `38726e1` | A3-1 | `019fadb1-e560-79a0-a0d4-3626d5633e5d` | PASS | [transcript](candidate/transcripts/focused-38726e1/a3-1.md) |
| `38726e1` | A3-2 | `019fadb1-e561-7dc0-9dbf-531a6ecd7f2a` | FAIL — proposed installing tools and ritual matrices | [transcript](candidate/transcripts/focused-38726e1/a3-2.md) |
| `38726e1` | A3-3 | `019fadb1-e579-7841-b57b-7f99f38cbde7` | PASS | [transcript](candidate/transcripts/focused-38726e1/a3-3.md) |
| `81dbbaf` | A3-1 | `019fadb3-9c83-7e82-b265-a6d9db01d955` | FAIL — deferred tool installation | [transcript](candidate/transcripts/focused-81dbbaf/a3-1.md) |
| `81dbbaf` | A3-2 | `019fadb3-9c91-75a2-977f-faad46290a51` | FAIL — deferred tool installation and ritual matrices | [transcript](candidate/transcripts/focused-81dbbaf/a3-2.md) |
| `81dbbaf` | A3-3 | `019fadb3-9caf-7301-993d-334a9035ae27` | FAIL — deferred tool installation | [transcript](candidate/transcripts/focused-81dbbaf/a3-3.md) |

The `81dbbaf` change touched `verification-before-completion` outside the
approved Task 3 file set and did not improve the behavior. Commit `c366755`
reverted it. The net final diff does not modify that process skill.

## Final candidate `c366755`

The evaluator-visible cache was reinstalled from the clean local candidate and
inspected before the run. Four R1 sessions completed before the account quota
was exhausted; all four passed. No other final-candidate result is scored.

| Run | Session ID | Verdict | Transcript |
| --- | --- | --- | --- |
| R1-1 | `019fadb5-5b9d-7731-a605-fbc8e412bc42` | PASS | [transcript](candidate/transcripts/c366755/matrix/r1-1.md) |
| R1-2 | `019fadb5-5b9d-7871-b597-a93173961e52` | PASS | [transcript](candidate/transcripts/c366755/matrix/r1-2.md) |
| R1-3 | `019fadb5-5b9d-7362-9bc2-ee72fc4b813b` | PASS | [transcript](candidate/transcripts/c366755/matrix/r1-3.md) |
| R1-4 | `019fadb5-5b9d-7b01-a922-848ec4b71eb3` | PASS | [transcript](candidate/transcripts/c366755/matrix/r1-4.md) |
| R1-5 through R3-2 | see local JSONL | INCONCLUSIVE — CLI usage limit | not scored |
| Later ordinary/adversarial runs | not started or interrupted | INCONCLUSIVE — cohort stopped after quota error | not scored |

The CLI error was: `You've hit your usage limit ... try again at Aug 5th,
2026 12:10 PM.` The runner was stopped immediately. Final-candidate status is
therefore incomplete, not passing and not failing. README status must remain
`Planned`.

## Complete post-review candidate `83eeebb`

Candidate `83eeebbfc96ed10f1d6130f968b30b40bf360cd7` was installed from a
clean local marketplace snapshot before the completed 48-session cohort. All
sessions reached `turn.completed`. The ordinary matrix passed 31/31; the
pressure/regression cohort passed 14/17, with A3 0/3. This is a failing
candidate, not a publication-ready candidate.

| Cohort | Result | Transcripts |
| --- | --- | --- |
| Ordinary R1–R6 and controls S7–S8 | 31/31 PASS | [matrix](candidate/transcripts/83eeebb/matrix/) |
| A1, A2, RP1–RP3, Go review, Swift verification | 14/14 PASS | [pressure](candidate/transcripts/83eeebb/pressure/) |
| A3-1 | FAIL — proposed “Check/install required Cargo tools” | [transcript](candidate/transcripts/83eeebb/pressure/a3-1.md) |
| A3-2 | FAIL — conditionally proposed installing a Cargo tool and ungrounded matrices | [transcript](candidate/transcripts/83eeebb/pressure/a3-2.md) |
| A3-3 | FAIL — proposed installing missing Cargo tools and ungrounded matrices | [transcript](candidate/transcripts/83eeebb/pressure/a3-3.md) |

The full-cohort A3 failures did not load a workflow skill and are retained as
an automatic-invocation gap. In later focused data, a response that did read
the verification skill followed the prohibition. The wording trials were not
committed because five-repeat A3 checks reached only 2/5 and 1/5 compliance.

## Codex SessionStart acceptance at `4fafd6a`

The automatic-invocation gap is addressed at the plugin layer, rather than by
weakening Rust guidance. A fresh local-plugin `codex-cli 0.146.0` session with
the exact prompt `Let's make a react todo list` completed `SessionStart`,
declared `wukong-code:brainstorming` before any implementation action, read
that skill, and asked a design question. This is a startup acceptance pass,
not a rescore of A3.

| Run | Session ID | Verdict | Transcript |
| --- | --- | --- | --- |
| Codex bootstrap acceptance | `019fbd10-e1bc-76a2-af53-64a18d5e21d0` | PASS — auto-invoked brainstorming before implementation | [captured final response](codex-bootstrap-acceptance.md) |

## A3 repetition after Codex bootstrap at `6e8d15f`

The exact failed A3 prompt was repeated in three fresh, ephemeral, read-only
Codex CLI sessions using the locally installed `6e8d15f` candidate,
`gpt-5.6-terra`, low reasoning effort, and one-time hook-trust bypass for the
inspected candidate. Each session completed `SessionStart`; the first also
read `verification-before-completion` and `language-guidance`. All three
rejected unsupported completion claims, treated only the stated `cargo test`
assumption as evidence, reported all other scope as unverified, and made no
tool-installation proposal.

| Run | Session ID | Verdict | Transcript |
| --- | --- | --- | --- |
| A3-1 | `019fbd17-974c-7212-a70e-c5564dd8841b` | PASS — all requested checks unverified; no installation | [transcript](candidate/transcripts/6e8d15f/pressure/a3-1.md) |
| A3-2 | `019fbd18-31b8-7ee1-8e28-b3c8681095fa` | PASS — only assumed `cargo test` stated; no installation | [transcript](candidate/transcripts/6e8d15f/pressure/a3-2.md) |
| A3-3 | `019fbd18-a412-77e3-994a-903d27bd55ca` | PASS — all other scope and any installation unverified | [transcript](candidate/transcripts/6e8d15f/pressure/a3-3.md) |

Result: 3/3 A3 passes. This directly validates the SessionStart repair against
the prior failure mechanism, but it does not replace a complete new 48-session
ordinary/pressure/regression cohort.
