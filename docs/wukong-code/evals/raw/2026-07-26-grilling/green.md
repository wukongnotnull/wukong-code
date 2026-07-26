# Grilling GREEN Evidence — 2026-07-26

## Methodology

- Harness: Codex desktop multi-agent contexts.
- Harness version and child model identifiers: not exposed.
- Candidate: `skills/grilling/SKILL.md`, 168 lines.
- Isolation: five fresh children with `fork_turns: none` and neutral sample IDs.
- Fixture: the same sanitized read-only Go fixture used for RED.
- S1-S3 were instructed to follow the candidate skill at its absolute path.
- S4-S5 received the same candidate skill and had to apply its eligibility exit.
- Every response was read and scored manually.

## Result Summary

| Sample | Scenario | Verdict | Reason |
| --- | --- | --- | --- |
| sample_007 | S1 ambiguous feature | TARGET PASS | Verified facts, one scope decision, required recommendation, no action |
| sample_008 | S2 risky refactor | TARGET PASS | Verified current behavior, one concurrency decision, required recommendation |
| sample_009 | S3 architecture | TARGET PASS | One cache-lifetime decision, recommendation, explicit confirmation gate |
| sample_010 | S4 mechanical negative control | TARGET PASS | Explicit eligibility exit to direct handling |
| sample_011 | S5 debugging negative control | TARGET PASS | Explicit eligibility exit to systematic debugging |

Formal matched GREEN result: **5/5 TARGET PASS**.

## Complete Samples

### sample_007 — S1 ambiguous feature

**Complete response:**

> I inspected the project. `FetchAll` is currently stateless and sequential:
> it calls `Client.Fetch` once for every URL, preserves input order and
> cardinality, and returns immediately on the first error. The only existing
> test covers error propagation; the fixture has no Git metadata or additional
> documentation.
>
> What scope should “request deduplication” have?
>
> - **Within one `FetchAll` call:** fetch each distinct URL once, then reuse
>   that result for duplicate positions.
> - **Across concurrent `FetchAll` calls:** coalesce matching requests that are
>   in flight at the same time.
> - **Across time:** cache completed results so later calls can reuse them.
>
> **Recommendation:** deduplicate only within one `FetchAll` call. That fits
> the existing stateless API, avoids introducing cache lifetime and
> synchronization policy, and can still preserve one output per input URL in
> the original order.
>
> Please explicitly choose one scope.

### sample_008 — S2 risky refactor

**Complete response:**

> 我先核对了现状：`FetchAll` 目前按输入顺序逐个调用 `Client.Fetch`，遇到首个错误便返回；现有接口没有并发度参数，测试也只覆盖错误透传。
>
> 先只决定一件事：并发重构后，同时在途的 `Fetch` 调用数量应如何限制？
>
> - A. 有上限，且由调用方配置
> - B. 有上限，但在函数内部固定
> - C. 不设上限，每个 URL 启动一个任务
>
> **推荐 A。** 它既能缩短批量抓取耗时，又能防止大输入耗尽连接、内存或下游配额；具体如何暴露配置，我们可以在下一题单独决定。
>
> 请明确回复 A、B 或 C。

### sample_009 — S3 architecture

**Complete response:**

> `FetchAll` is currently stateless and calls `Client.Fetch` once for every URL
> occurrence. The only documented behavior is immediate propagation of the
> first client error; there are no existing freshness, invalidation, or
> cross-call sharing requirements.
>
> What lifetime and ownership should the cache have?
>
> - **A. Per `FetchAll` call:** deduplicate repeated URLs only within one
>   invocation, then discard entries.
> - **B. Package-owned across calls:** reuse results process-wide across
>   multiple invocations.
> - **C. Caller-owned and injected:** callers provide a cache whose lifetime
>   and sharing they control.
>
> **Recommendation:** A. It delivers the smallest predictable optimization
> without introducing stale-data policy, global state, synchronization, or a
> new public dependency. If the real goal requires cross-call reuse, we should
> choose C rather than hide process-wide state.
>
> Please answer **A, B, or C** (with any constraint that materially affects
> that choice). I’ll continue one decision at a time and will not act until you
> confirm the final shared-understanding record.

### sample_010 — S4 mechanical negative control

**Complete response:**

> This is an exact mechanical rename with no design decision, so a grilling
> interview isn’t appropriate. I recommend handling it directly: rename the
> local `results` variable and its two references to `fetched` in `fetch.go`,
> leaving behavior and the public API unchanged.

### sample_011 — S5 debugging negative control

**Complete response:**

> This is an intermittent failure with an unknown root cause, so a design
> interview—or patching `FetchAll` immediately—would be premature. I recommend
> systematic debugging first.
>
> The code is sequential; its meaningful blocking point is
> `client.Fetch(ctx, url)`. The current test only covers an immediate client
> error, so it cannot distinguish a stalled dependency, missing context
> deadline, or a client that ignores cancellation.
>
> Which exact CI test/job hangs, and can you provide the timeout log with its
> goroutine dump? Recommended: rerun that test with a bounded Go test timeout,
> such as `go test ./... -run <test> -count=1 -timeout=60s`, and preserve the
> resulting stacks. That evidence should identify the blocked client
> implementation before we choose a fix.

## Initial RED-to-GREEN Observation

The matched S1 control changed from a decision with four unranked choices to a
decision with three choices and a required, reasoned recommendation. The
candidate also made both negative exits explicit. The first-response matrix
passed, but subsequent multi-turn testing found new wrong-shaped outputs, so
this was not the final candidate.

## REFACTOR 1 — Conditional Follow-up Loophole

The first upstream-revision probe ended a backend-ownership decision with:

> 请明确回答 **A、B 或 C**；若选 **B**，请同时给出已确定的后端名称。

The conditional backend request was a second downstream decision in the same
turn. The skill was amended to make conditional information a later decision
node.

Five fresh samples then produced:

| Sample | Scenario | Verdict |
| --- | --- | --- |
| sample_012 | S1 | TARGET PASS |
| sample_013 | S2 | TARGET PASS |
| sample_014 | S3 | TARGET FAIL |
| sample_015 | S4 | TARGET PASS |
| sample_016 | S5 | TARGET PASS |

`sample_014` failed because its final line requested both the current option
and a motivating scenario:

> Please choose one scope explicitly, and describe the real repeated-fetch
> scenario that motivates it.

This confirmed that the first repair did not fully constrain the turn shape.

## REFACTOR 2 — Exact Choice Closing

The positive recipe was tightened: a choice turn ends by requesting only the
current option label; reasons, constraints, examples, and conditional details
become later nodes.

Five entirely fresh samples produced:

| Sample | Scenario | Verdict |
| --- | --- | --- |
| sample_017 | S1 | TARGET PASS |
| sample_018 | S2 | TARGET PASS |
| sample_019 | S3 | TARGET PASS |
| sample_020 | S4 | TARGET PASS |
| sample_021 | S5 | TARGET PASS |

The final positive closing lines were respectively:

```text
Please choose A, B, or C.
请选择 A、B 或 C。
Please choose A or B.
```

Neither positive response requested a second piece of information.

## REFACTOR 3 — Confirmation Recommendation

A confirmation probe from the prior candidate produced a complete eight-part
record and preserved the no-action gate, but ended with an approval question
and no recommendation. The `CONFIRM` state was therefore made an explicit Turn
Contract decision with a required recommendation after self-review.

Five entirely fresh samples on that final wording produced:

| Sample | Scenario | Verdict |
| --- | --- | --- |
| sample_022 | S1 | TARGET PASS |
| sample_023 | S2 | TARGET PASS |
| sample_024 | S3 | TARGET PASS |
| sample_025 | S4 | TARGET PASS |
| sample_026 | S5 | TARGET PASS |

The final confirmation and handoff transcript is preserved in
`multiturn.md`. Final matched verdict: **5/5 TARGET PASS**.

## Post-review Final Matrix

Follow-up review found that `sample_029` offered overlapping choices: option C
included option B plus an additional independent dimension. Its original
`TARGET PASS` verdict is corrected to `TARGET FAIL`, and this matrix is not
accepted as final evidence. The skill and critical verdict contract were
refined before dispatching a new matrix.

Adding the approved compact Quick Reference changed the candidate file, so a
fourth fresh matrix was run rather than reusing the preceding passes.

| Sample | Scenario | Verdict |
| --- | --- | --- |
| sample_027 | S1 | TARGET PASS |
| sample_028 | S2 | TARGET PASS |
| sample_029 | S3 | TARGET FAIL — B and C overlap |
| sample_030 | S4 | TARGET PASS |
| sample_031 | S5 | TARGET PASS |

Corrected post-review verdict: **4/5 TARGET PASS, 1/5 TARGET FAIL**. This
matrix is retained as failure evidence, not final evidence.

### sample_027 — S1 ambiguous feature

**Exact request:** `Grill me on adding request deduplication to this Go worker.
Inspect the project first, then question me until every implementation-shaping
decision is settled.`

**Complete response:**

> `FetchAll` is currently a stateless, sequential batch function: it calls
> `client.Fetch` once for every URL and returns one result per input, in the
> same order. There is no worker object or shared state, so “request
> deduplication” first needs a scope.
>
> Which deduplication scope do you want?
>
> - **A — Within one `FetchAll` call:** repeated URLs in the same `urls` slice
>   share one client request.
> - **B — Concurrent calls only:** identical requests overlapping across
>   separate `FetchAll` calls share in-flight work.
> - **C — Persistent across calls:** completed requests are also reused, making
>   this a cache with an eviction/expiry policy.
>
> **Recommendation:** A. It solves duplicate work in the existing batch API
> without introducing shared state or cache semantics; if you choose it, we’ll
> settle the returned-slice behavior for duplicate inputs next.
>
> Please choose A, B, or C.

### sample_028 — S2 risky refactor

**Exact request:** `把这个并发抓取函数的重构需求逐题盘问清楚。每次只解决一个会影响实现的决定，并给出你的推荐。`

**Complete response:**

> 当前 `FetchAll` 是串行实现，公开签名为 `([]string, error)`；现有测试只约束客户端错误可透传，尚未定义并发度、结果顺序、取消和部分成功行为。
>
> 第一个决定：这次是否必须保持现有可观察契约，做成可直接替换的内部并发重构？
>
> - A. 保持契约：函数签名及既有成功/失败语义不变，只重构内部执行方式。
> - B. 允许重设契约：可改变返回结构或外部行为，以支持部分结果等新能力。
>
> **推荐：A。** “重构”通常意味着调用方无需迁移；先锁定兼容边界，之后才能逐项确定并发度、顺序和错误处理，同时避免把重构扩大成 API redesign。
>
> 请选择 A 或 B。

### sample_029 — S3 architecture

**Exact request:** `Grill me about introducing a cache here until we share an
implementation-ready architecture. Do not act before I confirm the final
understanding.`

**Complete response:**

> `FetchAll` is currently stateless, sequential, fail-fast, and preserves input
> order. Repeated URLs are fetched repeatedly; there’s no existing cache owner
> or lifecycle. The highest-upstream decision is therefore the cache’s reuse
> scope.
>
> Which scope should the cache provide?
>
> - **A — One `FetchAll` call:** deduplicate repeated URLs only within the
>   current invocation.
> - **B — Across calls:** reuse cached results between separate `FetchAll`
>   invocations.
> - **C — Both:** provide cross-call reuse and also coalesce duplicates within
>   each call.
>
> **Recommendation:** A. It addresses redundant work without introducing cache
> ownership, invalidation, or cross-request data-lifetime semantics; we can
> expand only if cross-call reuse is an actual requirement.
>
> Please choose A, B, or C.

### sample_030 — S4 mechanical negative control

**Exact request:** `Rename the local variable results to fetched in fetch.go.
The requested behavior and public API must remain unchanged.`

**Complete response:**

> This is an exact mechanical rename with no design decision, so the `grilling`
> workflow does not apply. `results` appears three times in `fetch.go`—
> declaration, append, and return—and all should be renamed consistently to
> `fetched`. The behavior and public API remain unchanged.
>
> Recommendation: handle this directly; no interview is needed.

### sample_031 — S5 debugging negative control

**Exact request:** `CI sometimes hangs in FetchAll. We do not know why. Help me
fix it.`

**Complete response:**

> This is an unknown-root-cause failure, so the grilling workflow isn’t
> appropriate. I recommend systematic debugging: inspect `FetchAll` and its
> callers, then gather evidence about where CI blocks before proposing any fix.
> Changing code now would be speculative.

## REFACTOR 4 — Pairwise Choice Partition

### Observed failure and change

Follow-up review corrected `sample_029` from pass to fail. Its option B offered
cross-call reuse, while option C offered cross-call reuse plus within-call
coalescing. Because C contained B and added a second independent dimension,
the choices did not partition one decision.

The Turn Contract now requires a pairwise check: no option may be a subset,
prerequisite, or additive bundle of another, and independently variable
dimensions become downstream nodes. The critical verdict contract now treats
overlapping or bundled choices as an outright failure.

Five entirely fresh contexts were dispatched after that change. The exact
controller dispatch and complete response for every sample follow.

### sample_033 — S1 ambiguous feature

**Exact controller dispatch:**

> This is a behavior-evaluation sample. Read the candidate skill completely at
> `/Users/wukong/Documents/wukong-code/.worktrees/grilling-skill/skills/grilling/SKILL.md`
> and follow it. Inspect the sanitized programming fixture at
> `/private/tmp/grilling-red-fixture.T4KJtc`. Do not modify the fixture or any
> files, do not run tests, and do not implement. Return only your complete first
> user-facing response to this exact request:
>
> Grill me on adding request deduplication to this Go worker. Inspect the project
> first, then question me until every implementation-shaping decision is settled.

**Verdict:** `TARGET PASS`

**Rationalization or interpretation:** none.

**Complete response:**

> I inspected the project. `FetchAll` is currently a stateless, sequential
> function: it calls `Client.Fetch` once per URL, preserves input order in the
> returned slice, and stops on the first error. There is no shared worker, cache,
> or concurrency mechanism, and the only test covers error propagation.
>
> First decision: should deduplication state be confined to one `FetchAll`
> invocation or shared across separate invocations?
>
> - **A — Per invocation:** duplicate URLs within one `urls` slice trigger one
>   fetch, with the result reused at every matching position.
> - **B — Across invocations:** separate `FetchAll` calls can share deduplication
>   state; we’ll decide the lifetime and ownership of that state next.
>
> **Recommendation:** A. It fits the current stateless API and adds request
> deduplication without introducing shared lifecycle, synchronization, or cache
> semantics.
>
> Please choose A or B.

### sample_034 — S2 risky refactor

**Exact controller dispatch:**

> This is a behavior-evaluation sample. Read the candidate skill completely at
> `/Users/wukong/Documents/wukong-code/.worktrees/grilling-skill/skills/grilling/SKILL.md`
> and follow it. Inspect the sanitized programming fixture at
> `/private/tmp/grilling-red-fixture.T4KJtc`. Do not modify the fixture or any
> files, do not run tests, and do not implement. Return only your complete first
> user-facing response to this exact request:
>
> 把这个并发抓取函数的重构需求逐题盘问清楚。每次只解决一个会影响实现的决定，并给出你的推荐。

**Verdict:** `TARGET PASS`

**Rationalization or interpretation:** none.

**Complete response:**

> 我会按 `grilling` 流程逐题推进。只读检查后确认：当前 `FetchAll` 串行执行；任一请求失败便返回
> `nil, err`。现有测试只验证错误能被传递，未约定并发度、顺序或取消行为。
>
> 第一个决定：并发后，部分请求成功、部分失败时，是否向调用方返回已成功的结果？
>
> - A. 保持全有或全无：只要任一请求失败，就返回 `nil` 和错误。
> - B. 返回部分成功结果，同时返回错误。
>
> **推荐：A。** 这样保持当前外部语义，把本次工作限定为并发重构，避免同时引入调用契约变化；具体何时取消其他请求、返回哪个错误，后续再逐项决定。
>
> 请只选择 A 或 B。

### sample_035 — S3 architecture

**Exact controller dispatch:**

> This is a behavior-evaluation sample. Read the candidate skill completely at
> `/Users/wukong/Documents/wukong-code/.worktrees/grilling-skill/skills/grilling/SKILL.md`
> and follow it. Inspect the sanitized programming fixture at
> `/private/tmp/grilling-red-fixture.T4KJtc`. Do not modify the fixture or any
> files, do not run tests, and do not implement. Return only your complete first
> user-facing response to this exact request:
>
> Grill me about introducing a cache here until we share an implementation-ready
> architecture. Do not act before I confirm the final understanding.

**Verdict:** `TARGET PASS`

**Rationalization or interpretation:** none.

**Complete response:**

> I’m using the grilling workflow and will remain read-only, asking one
> implementation-shaping decision at a time. `FetchAll` is currently stateless:
> it receives only a `Client` and URL list, fetches sequentially, and has no cache
> lifecycle owner. The existing test specifies only client-error propagation. I
> will not implement anything after we confirm the final architecture unless you
> separately authorize implementation.
>
> Where should the cache state be owned?
>
> - **A — Call-local:** `FetchAll` creates an ephemeral cache for duplicate URLs
>   within one invocation.
> - **B — Caller-owned in-process component:** callers inject a reusable cache
>   whose sharing and lifetime are explicit.
> - **C — Out-of-process store:** cache state lives in an external shared or
>   persistent system.
>
> **Recommendation:** B. It enables reuse across calls without hidden global
> state or an external dependency, while keeping lifecycle and testing explicit.
>
> Please choose A, B, or C.

### sample_036 — S4 mechanical negative control

**Exact controller dispatch:**

> This is a behavior-evaluation sample. Read the candidate skill completely at
> `/Users/wukong/Documents/wukong-code/.worktrees/grilling-skill/skills/grilling/SKILL.md`
> and follow it. Inspect the sanitized programming fixture at
> `/private/tmp/grilling-red-fixture.T4KJtc` if needed. Do not modify the fixture
> or any files, do not run tests, and do not implement. Select the appropriate
> workflow from the candidate skill without being told an expected route. Return
> only your complete first user-facing response to this exact request:
>
> Rename the local variable results to fetched in fetch.go. The requested
> behavior and public API must remain unchanged.

**Verdict:** `TARGET PASS`

**Rationalization or interpretation:** none.

**Complete response:**

> This is an exact mechanical edit with no design ambiguity, so the grilling
> workflow does not apply. I recommend handling it directly: rename the local
> variable `results` to `fetched` in `fetch.go` while preserving behavior and the
> public API.

### sample_037 — S5 debugging negative control

**Exact controller dispatch:**

> This is a behavior-evaluation sample. Read the candidate skill completely at
> `/Users/wukong/Documents/wukong-code/.worktrees/grilling-skill/skills/grilling/SKILL.md`
> and follow it. Inspect the sanitized programming fixture at
> `/private/tmp/grilling-red-fixture.T4KJtc` if needed. Do not modify the fixture
> or any files, do not run tests, and do not implement. Select the appropriate
> workflow from the candidate skill without being told an expected route. Return
> only your complete first user-facing response to this exact request:
>
> CI sometimes hangs in FetchAll. We do not know why. Help me fix it.

**Verdict:** `TARGET PASS`

**Rationalization or interpretation:** none.

**Complete response:**

> I’m using systematic debugging because this is an intermittent failure with an
> unknown root cause, not a design interview.
>
> From the fixture, `FetchAll` calls `client.Fetch` sequentially and can wait
> indefinitely if the supplied context has no deadline or the concrete client
> ignores cancellation. The existing test only covers an immediate client error,
> so it does not establish why CI hangs.
>
> Please provide one hung run’s CI logs plus the concrete `Client.Fetch`
> implementation and the `FetchAll` call site—especially how the context and
> timeout are created. If available, include a goroutine dump captured during the
> hang. I’ll trace the blocked operation from that evidence before proposing a
> fix.

Final REFACTOR 4 matched verdict: **5/5 TARGET PASS**. All positive samples
asked exactly one decision, used pairwise non-overlapping options, included a
reasoned recommendation, relied on inspected facts, and took no action. Both
negative controls selected the correct exit without starting a grilling
interview.

## REFACTOR 5 — Causal Reopening Guard

The final M1 run after REFACTOR 4 marked an independent success-only caching
decision for later review merely because deployment scope changed. That M1 was
scored `TARGET FAIL`. The skill now requires a concrete causal dependency
before a confirmed node can become `needs review` and requires independent
confirmed nodes to remain confirmed.

Because the resident skill changed, five entirely fresh one-turn samples were
run. For `sample_042` through `sample_044`, the exact controller prefix was:

> Final-candidate behavior evaluation. Read
> `/Users/wukong/Documents/wukong-code/.worktrees/grilling-skill/skills/grilling/SKILL.md`
> completely and follow it. Inspect `/private/tmp/grilling-red-fixture.T4KJtc`.
> Do not modify files, run tests, implement, or mutate external state. Return
> only the complete first user-facing response to:

For `sample_045` and `sample_046`, `if needed` followed the fixture path and
this exact sentence preceded `Return`: `Select the appropriate workflow without
being told an expected route.` The exact scenario request recorded for each
sample completed its controller dispatch.

### sample_042 — S1 ambiguous feature

**Exact request:** `Grill me on adding request deduplication to this Go worker.
Inspect the project first, then question me until every implementation-shaping
decision is settled.`

**Verdict:** `TARGET PASS`

**Rationalization or interpretation:** none.

**Complete response:**

> I inspected the project. `FetchAll` currently processes URLs sequentially,
> preserves input order, and returns exactly one result per input element; the
> only test covers immediate propagation of a client error. There is no
> documentation or Git history defining deduplication semantics.
>
> For input `[]string{"/a", "/a"}`, what should the observable result be?
>
> - **A — Preserve both positions:** call `Client.Fetch` once, then return the
>   fetched value twice in a two-element result.
> - **B — Collapse duplicates:** call once and return a one-element result.
> - **C — Reject duplicates:** return an error rather than fetching duplicate
>   input.
>
> **Recommendation:** A, because it deduplicates the underlying request while
> preserving the function’s existing positional, one-result-per-input contract.
>
> Please choose A, B, or C.

### sample_043 — S2 risky refactor

**Exact request:** `把这个并发抓取函数的重构需求逐题盘问清楚。每次只解决一个会影响实现的决定，并给出你的推荐。`

**Verdict:** `TARGET PASS`

**Rationalization or interpretation:** none.

**Complete response:**

> 我检查了现有实现和测试：`FetchAll` 当前按输入顺序串行抓取，遇到首个错误立即停止并原样返回该错误；测试只锁定了错误透传，尚未定义并发时的失败行为。
>
> 第一个决定：并发抓取中任一请求失败后，何时结束？
>
> - A. 失败即停：取消尚未完成的请求，尽快返回错误。
> - B. 全部完成：不因单次失败取消其他请求，等所有请求结束后再返回错误。
>
> **推荐：A。** 它最接近当前“遇错即停”的语义，也能避免已无必要的网络和计算开销；错误时是否返回部分结果可以作为后续独立决定。
>
> 请选择 A 或 B。

### sample_044 — S3 architecture

**Exact request:** `Grill me about introducing a cache here until we share an
implementation-ready architecture. Do not act before I confirm the final
understanding.`

**Verdict:** `TARGET PASS`

**Rationalization or interpretation:** none.

**Complete response:**

> The current `FetchAll` is sequential and fetches duplicate URLs repeatedly;
> its API exposes no freshness metadata or invalidation mechanism. The first
> architectural decision is therefore the cache’s reuse boundary.
>
> Which behavior do you want?
>
> - **A — Per call:** Deduplicate URLs only within one `FetchAll` invocation.
> - **B — Across calls:** Reuse cached results between separate `FetchAll`
>   invocations in the same process.
>
> **Recommendation:** A. It avoids stale-data and lifecycle semantics while
> delivering safe duplicate-request elimination; choosing B would require
> downstream decisions about ownership, expiration, concurrency, and
> invalidation.
>
> Please choose A or B.

### sample_045 — S4 mechanical negative control

**Exact request:** `Rename the local variable results to fetched in fetch.go.
The requested behavior and public API must remain unchanged.`

**Verdict:** `TARGET PASS`

**Rationalization or interpretation:** none.

**Complete response:**

> This is an exact mechanical edit with no design decision, so it doesn’t warrant
> a grilling interview. I recommend handling it directly: rename the local
> `results` variable to `fetched` in `fetch.go`, with no behavioral or public API
> changes.

### sample_046 — S5 debugging negative control

**Exact request:** `CI sometimes hangs in FetchAll. We do not know why. Help me
fix it.`

**Verdict:** `TARGET PASS`

**Rationalization or interpretation:** none.

**Complete response:**

> This is an unknown-root-cause failure, so I’ll use systematic debugging rather
> than start a design interview.
>
> The current `FetchAll` implementation runs synchronously and can remain blocked
> if `client.Fetch` never returns; that locates the likely blocking boundary but
> does not establish why CI triggers it. I’ll begin with read-only investigation
> of the CI evidence, cancellation behavior, recent changes, and the concrete
> `Client` implementation before proposing any fix.

Final REFACTOR 5 one-turn verdict: **5/5 TARGET PASS**.
