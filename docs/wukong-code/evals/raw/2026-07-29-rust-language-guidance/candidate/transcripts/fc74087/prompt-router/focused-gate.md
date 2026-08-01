# Prompt-router focused gate — `fc74087`

Twelve fresh, ephemeral, read-only `codex-cli 0.146.0` sessions used the
locally installed candidate, `gpt-5.6-terra` at low reasoning effort, and a
one-time hook-trust bypass. `SessionStart` and `UserPromptSubmit` completed in
every run. Each final agent message observed the no-command/no-edit boundary.

| Scenario | Session ID | Observed final behavior | Verdict |
| --- | --- | --- | --- |
| R1-1 Rust implementation | `019fbd8a-0288-7f92-9272-66a17fa636f2` | Preserved input order, joins, lowest-index error, `Send`, panic-policy, and no external crates. | PASS |
| R1-2 Rust implementation | `019fbd8a-77f5-7943-81cc-625feaadf060` | Preserved `std` primitives, worker joins, result ordering, and lowest-index errors. | PASS |
| R1-3 Rust implementation | `019fbd8a-ffc5-7571-aff4-045ce6938931` | Defined one worker per input, joins, original ordering, and deterministic errors. | PASS |
| R1-4 Rust implementation | `019fbd8b-649e-7d73-bbfa-5537813346ec` | Preserved standard library, ordering, joins, deterministic errors, and API boundary. | PASS |
| R1-5 Rust implementation | `019fbd8b-c4e1-7b80-896a-f8f290720516` | Preserved one worker per input, indexed results, joins, ordered successes, and lowest-index errors. | PASS |
| R4-1 Rust review | `019fbd8c-2d7f-78b2-a56f-ad86c2cafb85` | Requested source contents rather than inventing a defect. | PASS |
| R4-2 Rust review | `019fbd8c-91b4-7811-b609-fce4327688b2` | Requested source contents rather than inventing a defect. | PASS |
| Go review | `019fbd8c-fb5e-7e80-bc11-e36d6176f01c` | Requested `main.go` contents and promised only concrete, line-specific findings. | PASS |
| Swift verification | `019fbd8d-7420-7290-b27a-fb313004519d` | Required `swift package dump-package`, `swift test`, and `swift build`; configuration-dependent tools stayed conditional. | PASS |
| S7 TypeScript | `019fbd8e-0501-7280-b5ec-91765e8a595a` | Stated that `.ts` has no registered language pack and would not invoke or invent one. | PASS |
| S8 documentation | `019fbd8e-608c-78a2-858e-b7431ce1845c` | Stated that README work is documentation-only and has no installed language guidance. | PASS |

The TypeScript control intentionally received explicit negative prompt-router
context: silent non-selection had twice produced invented TypeScript guidance.
The deterministic hook test covers that delivery; this runtime gate evaluates
the observed model response. This focused result permits the 48-session cohort
but is not itself a publication or PR decision.
