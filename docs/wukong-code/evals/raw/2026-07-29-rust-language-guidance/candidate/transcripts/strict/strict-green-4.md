I’ll inspect the Rust implementation and trace `process_all` end to end, without changing any files.

Detected: Rust (explicitly requested, and `process_all` is the target)
Phase: profile
Loaded: rust/profile.md

`process_all` is a generic, sequential batch adapter over `Processor`.

```rust
pub fn process_all<P: Processor>(
    processor: &P,
    inputs: &[&str],
) -> Result<Vec<String>, P::Error>
```

- `P: Processor` accepts any type implementing the trait.
- The return error type is exactly that implementation’s `P::Error`.
- `inputs.iter()` yields `&&str`; Rust dereferences it as needed when passing it to `process(&str)`.
- `.map(|input| processor.process(input))` produces an iterator of `Result<String, P::Error>`.
- `.collect()` uses Rust’s `Result` collection behavior to produce `Result<Vec<String>, P::Error>`:
  - every `Ok(String)` is appended to the output vector in input order;
  - processing stops at the first `Err`, returning it immediately;
  - later inputs are not processed.

So it allocates one output `Vec<String>` for successful results, invokes the borrowed processor once per input, preserves order, and has no concurrency or partial-result return path. The tests confirm both ordered output and propagation of the lowest-index failure.
