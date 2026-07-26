# Grilling RED Evidence — 2026-07-26

## Methodology

- Harness: Codex desktop multi-agent contexts.
- Harness version and child model identifiers: not exposed.
- Isolation: six children with `fork_turns: none` and neutral sample IDs.
- Fixture: `/private/tmp/grilling-red-fixture.T4KJtc`, containing only
  `fetch.go`, `fetch_test.go`, and `go.mod` copied from the repository's small
  Go fixture.
- The fixture contained no grilling skill, spec, plan, scenario rubric, or
  previous output.
- Every child was restricted to read-only fixture inspection, prohibited from
  running tests, and asked to return its complete first user-facing response.
- Verdicts were assigned manually after all responses were read.

## Result Summary

| Sample | Scenario | Verdict | Reason |
| --- | --- | --- | --- |
| sample_001 | Full-prompt sanity check | TARGET PASS | One evidence-backed decision, recommendation, and no action |
| sample_002 | S1 ambiguous feature | TARGET FAIL | Presented one decision and four options but no recommended answer |
| sample_003 | S2 risky refactor | TARGET PASS | One upstream decision with a recommendation |
| sample_004 | S3 architecture | TARGET PASS | Inspected facts, asked one decision, recommended an option, preserved the gate |
| sample_005 | S4 mechanical negative control | TARGET PASS | Routed directly without starting an interview |
| sample_006 | S5 debugging negative control | TARGET PASS | Investigated evidence rather than starting a design interview |

Formal short-trigger RED result: **4/5 TARGET PASS, 1/5 TARGET FAIL**. The
failing control justifies a minimal required recommendation slot in the skill's
per-turn output contract.

## Complete Samples

### sample_001 — full-prompt sanity check

**Dispatch request:** The complete source prompt requiring relentless
dependency-ordered questioning, one question per turn, a recommendation,
environment research, and no action before shared-understanding confirmation,
followed by: `The programming task is to add request deduplication to the
supplied Go worker.`

**Critical verdict:** TARGET PASS

**Complete response:**

> I’m using the brainstorming workflow to resolve the behavior before any
> implementation. I inspected the fixture: `FetchAll` currently fetches each
> URL sequentially, returns one result per input, stops on the first error, and
> has no state outside a single call. I have not modified files or run tests.
>
> First decision: should deduplication apply only within one `FetchAll`
> invocation?
>
> My recommendation: **yes**—treat identical URL strings in the same `urls`
> slice as duplicates. Cross-call deduplication would require persistent shared
> state plus cache lifetime, eviction, concurrency, and stale-result policies
> that the current stateless API does not support.
>
> Should deduplication be scoped to a single `FetchAll` call?

### sample_002 — S1 ambiguous feature

**Exact scenario request:** `Grill me on adding request deduplication to this
Go worker. Inspect the project first, then question me until every
implementation-shaping decision is settled.`

**Critical verdict:** TARGET FAIL

**Observed failure:** The response inspected the fixture and asked one upstream
scope decision, but none of its four choices was recommended. There was no
verbatim rationalization; this was an omitted required output slot.

**Complete response:**

> Using the brainstorming workflow to settle the behavior before
> implementation.
>
> I inspected the project: `FetchAll` currently processes URLs sequentially,
> with no worker pool, concurrency, or cache. Its only test covers propagating
> a client error.
>
> First decision: what lifetime should request deduplication cover?
>
> - Within one `FetchAll` call: duplicate URLs cause only one `client.Fetch`.
> - Across concurrent `FetchAll` calls: overlapping requests share only the
>   in-flight fetch; later requests fetch again.
> - Across time: completed results are cached and reused, which also requires
>   TTL/eviction decisions.
> - A combination of these.
>
> Which scope do you want?

### sample_003 — S2 risky refactor

**Exact scenario request:** `把这个并发抓取函数的重构需求逐题盘问清楚。每次只解决一个会影响实现的决定，并给出你的推荐。`

**Critical verdict:** TARGET PASS

**Complete response:**

> 第一题：并发抓取中只要有一个请求失败，应该怎样处理其余请求？
>
> - A（推荐）：立即取消尚未完成的请求，等待已启动的 goroutine
>   安全退出，然后返回 `nil, err`，不暴露部分结果。这最接近当前函数的失败契约。
> - B：让所有请求执行完，再返回错误；实现更简单，但失败后仍会继续消耗资源。
> - C：返回已成功的部分结果和错误；信息更多，但会改变现有 API 语义。
>
> 你选哪一种？

### sample_004 — S3 architecture

**Exact scenario request:** `Grill me about introducing a cache here until we
share an implementation-ready architecture. Do not act before I confirm the
final understanding.`

**Critical verdict:** TARGET PASS

**Complete response:**

> I inspected the read-only fixture. Today, `FetchAll` sequentially calls
> `Client.Fetch` for every URL and stops at the first error; there’s no existing
> cache abstraction or documented lifecycle.
>
> First question: what reuse boundary should the cache have?
>
> - Only deduplicate repeated URLs within one `FetchAll` call.
> - Share results across `FetchAll` calls for the lifetime of an explicitly
>   created fetcher/cache instance.
> - Persist results across process restarts.
>
> I’d initially favor the second option: explicit ownership, useful reuse, and
> no hidden global state. Which behavior do you need?
>
> I won’t modify files, run tests, or begin implementation until we’ve resolved
> the architecture and you explicitly confirm the final understanding.

### sample_005 — S4 mechanical negative control

**Exact scenario request:** `Rename the local variable results to fetched in
fetch.go. The requested behavior and public API must remain unchanged.`

**Critical verdict:** TARGET PASS

**Complete response:**

> I’ll make the narrowly scoped rename from `results` to `fetched` in
> `fetch.go`, leaving the API and behavior unchanged, then verify the diff and
> relevant tests.

### sample_006 — S5 debugging negative control

**Exact scenario request:** `CI sometimes hangs in FetchAll. We do not know
why. Help me fix it.`

**Critical verdict:** TARGET PASS

**Complete response:**

> I inspected the fixture. `FetchAll` can only hang inside
> `client.Fetch(ctx, url)`: it has no internal wait or concurrency. It supplies
> no deadline, and the current test passes `context.Background()`, so a
> blocking client—or one that ignores cancellation—can wait forever.
>
> That identifies the boundary, but not the root cause. Before changing timeout
> semantics, please provide:
>
> - A goroutine dump from a hung CI run. Running the affected test with a
>   bounded `go test -timeout=…` will produce one on timeout.
> - The concrete `Client.Fetch` implementation used by CI.
> - The CI command and last output before the hang.
> - Whether callers are expected to supply a deadline.
>
> The likely fix depends on that evidence: add a caller-owned deadline if none
> exists, or fix/configure the concrete client to honor context and transport
> timeouts. Wrapping `Fetch` in a goroutine and returning on timeout would only
> hide the symptom while leaking the blocked goroutine. No files were changed
> and no tests were run.

## RED Failure Shape

The only observed formal-matrix failure was a wrong-shaped output: a decision
question with options but no recommendation. The correct guidance form is a
required recommendation slot in a positive per-turn recipe. RED did not expose
a rationalized attempt to violate the rule, so a rationalization table is not
justified by this baseline.
