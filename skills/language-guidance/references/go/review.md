# Go Review Guidance

Report only concrete failure modes with exact file and tight lines. Zero
findings is valid.

## Check

- Lost error identity across errors.Is/errors.As contracts.
- Discarded context, missing propagation, or uncanceled derived context.
- Goroutine without completion, blocking after owner return, or unsynchronized data.
- Unclear channel close ownership, double close, or send after close.
- Unsafe map, slice backing array, pointer, or resource ownership.
- Cleanup skipped on reachable error path.
- Feature newer than module or CI toolchain.
- Exported behavior changed without appropriate tests/API consideration.

Do not report naming, interface placement, table-test, or layout preferences
without a project rule or failure scenario. Do not invent races.
