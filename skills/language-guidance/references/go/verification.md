# Go Verification Guidance

Verification-before-completion remains authoritative. Choose commands from
CI/docs, repository scripts, declared tools, then safe Go defaults.

    gofmt -l <changed-go-files>
    go test ./path/to/changed/package
    go test ./...
    go vet ./...

Any gofmt output is failure. Add -race only when concurrency is in scope and
supported; report unsupported prerequisites instead of installing them.

Report exact commands, exit codes, test counts when available, formatting
output, and skipped checks. Do not claim one command proves another concern.
For build tags, cgo, generated files, or platform files, state the verified
target and remaining untested targets.
