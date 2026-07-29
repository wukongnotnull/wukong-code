# Rust language-guidance RED baseline raw index — 2026-07-29

All entries are complete final responses from fresh, ephemeral, read-only
`codex-cli 0.146.0` sessions using `gpt-5.6-terra` with low reasoning effort
and an empty per-run MCP configuration. The sanitized fixture repository was
clean before and after the cohort.

| Run | Session ID | Verdict | Complete response |
| --- | --- | --- | --- |
| R1-1 | `019fad8d-69ad-7b70-ae61-b671e396555b` | TARGET FAIL — no Rust implementation phase | [response](baseline/r1-1.md) |
| R1-2 | `019fad8d-69ab-79f0-897e-c7aeae85e386` | TARGET FAIL — no Rust implementation phase | [response](baseline/r1-2.md) |
| R1-3 | `019fad8d-69ad-73a0-a52f-4c6de51d5dcc` | TARGET FAIL — no Rust implementation phase | [response](baseline/r1-3.md) |
| R1-4 | `019fad8d-69c4-7a20-88cb-a8b427632954` | TARGET FAIL — no Rust implementation phase | [response](baseline/r1-4.md) |
| R1-5 | `019fad8e-5e1b-7b71-aaa1-9273e088d82f` | TARGET FAIL — no Rust implementation phase | [response](baseline/r1-5.md) |
| R2-1 | `019fad8e-5e1b-7c63-8685-33a0a7979f54` | TARGET FAIL — accepted skipping RED; no Rust testing phase | [response](baseline/r2-1.md) |
| R2-2 | `019fad8e-5e1b-7fa3-b652-c52a1daf534a` | TARGET FAIL — accepted skipping RED; no Rust testing phase | [response](baseline/r2-2.md) |
| R2-3 | `019fad8e-5e2f-7cc0-8a55-2912e0b72b58` | TARGET FAIL — retained RED; Rust testing unavailable | [response](baseline/r2-3.md) |
| R2-4 | `019fad8f-6039-7253-a854-2fa687eedcd2` | TARGET FAIL — accepted skipping RED; no Rust testing phase | [response](baseline/r2-4.md) |
| R2-5 | `019fad8f-6046-77e3-9323-8bc681158286` | TARGET FAIL — retained RED; no Rust testing phase | [response](baseline/r2-5.md) |
| R3-1 | `019fad8f-6049-7e60-b8f0-b018a4239a01` | TARGET FAIL — no Rust debugging phase | [response](baseline/r3-1.md) |
| R3-2 | `019fad8f-603e-7ae0-b387-6716cfacc0bd` | TARGET FAIL — no Rust debugging phase | [response](baseline/r3-2.md) |
| R4-1 | `019fad90-707e-7823-b2ef-437023e95f6f` | TARGET FAIL — zero findings, no Rust review phase | [response](baseline/r4-1.md) |
| R4-2 | `019fad90-7099-76e2-ad6e-a3bec7a3b476` | TARGET FAIL — zero findings, no Rust review phase | [response](baseline/r4-2.md) |
| R5-1 | `019fad90-7085-7ca0-8fd7-d8b654bdbc21` | TARGET FAIL — unavailable MSRV/Clippy commands; no Rust verification phase | [response](baseline/r5-1.md) |
| R5-2 | `019fad90-707f-7983-9570-8e5a26b50c47` | TARGET FAIL — ritual all-features; no Rust verification phase | [response](baseline/r5-2.md) |
| R6-1 | `019fad91-4ecb-7d12-b318-805c2ed5d3cb` | TARGET FAIL — nearest Rust marker found, pack unavailable | [response](baseline/r6-1.md) |
| R6-2 | `019fad91-4ec4-7670-9b0b-1ed0b4f0e03c` | TARGET FAIL — nearest Rust marker found, pack unavailable | [response](baseline/r6-2.md) |
| R6-3 | `019fad91-4ec6-7830-b92e-79ce1ef57882` | TARGET FAIL — nearest Rust marker found, pack unavailable | [response](baseline/r6-3.md) |
| R6-4 | `019fad91-4ecb-7482-be5e-eca59eacb9da` | TARGET FAIL — nearest Rust marker found, pack unavailable | [response](baseline/r6-4.md) |
| R6-5 | `019fad92-07d6-7683-ba58-915b68ee0a62` | TARGET FAIL — nearest Rust marker found, pack unavailable | [response](baseline/r6-5.md) |
| S7-1 | `019fad92-07d6-73b1-958b-50bc890011ba` | PASS — unsupported TypeScript, no language pack loaded | [response](baseline/s7-1.md) |
| S7-2 | `019fad92-07dd-70f3-a45f-e7cd54fb029e` | PASS — unsupported TypeScript, no language pack loaded | [response](baseline/s7-2.md) |
| S7-3 | `019fad92-07ec-7952-be9c-c03855e376a0` | PASS — unsupported TypeScript, no language pack loaded | [response](baseline/s7-3.md) |
| S7-4 | `019fad92-d7e7-71f1-b93d-786f3794e5be` | PASS — unsupported TypeScript, no language pack loaded | [response](baseline/s7-4.md) |
| S7-5 | `019fad92-d7e5-7111-b462-08fd5577d7ac` | PASS — unsupported TypeScript, no language pack loaded | [response](baseline/s7-5.md) |
| S8-1 | `019fad92-d7f1-7a43-833c-a281e9acd44b` | PASS — documentation-only, no language guidance | [response](baseline/s8-1.md) |
| S8-2 | `019fad92-d7f6-73d1-b59a-a202a70900a6` | PASS — documentation-only, no language guidance | [response](baseline/s8-2.md) |
| S8-3 | `019fad93-9a7d-7210-8870-880d7d4dfe63` | PASS — documentation-only, no language guidance | [response](baseline/s8-3.md) |
| S8-4 | `019fad93-9a8d-78b0-9967-3d093fafde67` | PASS — documentation-only, no language guidance | [response](baseline/s8-4.md) |
| S8-5 | `019fad93-9a9c-7ed2-a8e2-691765fc5ed4` | PASS — documentation-only, no language guidance | [response](baseline/s8-5.md) |

The excluded calibration session was
`019fad87-fad5-75b0-808e-3cc11e519148`. It read the implementation branch's
design and plan, so it is contamination evidence rather than a scored control.
