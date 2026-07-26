# Go Debugging Guidance

Systematic debugging remains authoritative. Gather evidence before fixes.

## Classify

- Compile error: exact package, position, and declared Go version.
- Test failure: focused rerun with -count=1.
- Hang/leak: bounded timeout or goroutine stacks; blocked operations/creators.
- Race: smallest reproducer under -race when supported; keep both stacks.
- Panic: full stack and first application frame with a false invariant.

## Hypotheses Requiring Proof

Typed nil interfaces; missing cancellation; blocked sends; shared map/slice/
pointer ownership; defer in long loops; build tags, cgo, workspace, module
replacements, and platform-specific selection.

## Focused Commands

    go test ./path/to/package -run '^TestName$' -count=1 -v
    go test ./path/to/package -run '^TestName$' -count=20
    go test -race ./path/to/package -run '^TestName$' -count=1
    go test ./path/to/package -run '^TestName$' -timeout=10s

Reproduce, trace data/control flow, then change the smallest causal point.
