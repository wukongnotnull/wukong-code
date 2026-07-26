# Go Implementation Guidance

Apply only rules whose conditions occur in target code.

## Errors

- Return errors to a handling boundary; avoid log-and-return duplication.
- Wrap with percent-w when callers need errors.Is or errors.As.
- Preserve established sentinel and typed-error contracts.

## Context and Cancellation

- Pass an incoming context through blocking or remote operations.
- Put context first; do not store it in a struct without an existing contract.
- Call every derived-context cancel function on all paths.

## Concurrency Ownership

Before starting a goroutine, identify who waits, how it stops, and who owns
channel close. Avoid sends that can block after the owner returns. Specify
ordering, first-error behavior, cancellation, and partial-result policy in
tests before selecting a channel, mutex, or indexed result strategy.

## Interfaces, Data, Resources

- Define an interface at the consuming boundary only when substitution helps.
- Synchronize or copy maps, slice backing arrays, and pointers crossing owners.
- Close resources at the acquiring layer unless ownership is transferred.
- Place defer after successful acquire; use helper scope in long loops.

## Minimal Example

    func Load(ctx context.Context, client Client, id string) (Item, error) {
        item, err := client.Load(ctx, id)
        if err != nil {
            return Item{}, fmt.Errorf("load item %q: %w", id, err)
        }
        return item, nil
    }

The example demonstrates propagation and wrapping, not required new types.
