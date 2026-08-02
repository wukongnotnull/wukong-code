`process_all` is already implemented as the idiomatic sequential Rust approach:

```rust
inputs
    .iter()
    .map(|input| processor.process(input))
    .collect()
```

Concretely:

- `inputs.iter()` traverses inputs in slice order.
- `map` calls `Processor::process` for each item.
- `collect()` is inferred as `Result<Vec<String>, P::Error>` from the function’s return type.
- Rust’s `Result` collection stops at the first `Err`, so the lowest-index failing input is returned.
- On success, outputs remain in input order.

The `input` binding is `&&str` during iteration, but Rust deref coercion passes it correctly to `process(&str)`. This is compatible with the package’s declared Rust 1.63 MSRV and requires no dependency or API changes.