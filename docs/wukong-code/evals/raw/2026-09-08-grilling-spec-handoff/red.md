# Grilling Spec Handoff RED — 2026-09-08

## Methodology

- Fresh general-purpose subagent per probe.
- RED actors received current `skills/grilling/SKILL.md` (pre-persist edit)
  and, for U1, current `skills/using-wukong-code/SKILL.md`. They were not
  given the intended pass answer or scoring rubric in the prompt.
- Score by reading the complete response. Keyword matching is not evidence.
- Fixture: `tests/skills/fixtures/language-guidance/go-basic`
- Replies below are the actor's full user-facing text from that run.

## Probes

## M4/M5

**Actor:** general-purpose subagent, pre-change `skills/grilling/SKILL.md` only.

**Prompt shape:** HANDOFF-start with the eight-section seeded record. Human
message: `确认`. No written-spec approval.

### Complete response

You confirmed the Shared-Understanding Record. I inspected `tests/skills/fixtures/language-guidance/go-basic`: `FetchAll(ctx, client, urls []string)` is the public contract, and it fetches each URL independently with no deduplication.

That confirmation locks the record below. It does not authorize a file write or implementation.

1. Objective  
Add in-process request deduplication to the supplied Go worker so concurrent fetches for the same URL share one underlying fetch.

2. Verified Facts  
- Worker lives in `tests/skills/fixtures/language-guidance/go-basic`  
- `fetch.go` exposes `FetchAll(ctx, client, urls []string)`  
- No existing deduplication  

3. Confirmed Decisions  
- Deduplicate by exact URL string within one `FetchAll` call only  
- Preserve one result per input in original order  
- No public API change  

4. Closed Branches  
- Cross-process cache: rejected; fixture has no shared store  
- Changing `FetchAll` signature: rejected; keep existing contract  

5. Constraints and Non-goals  
- No new dependencies  
- No distributed cache  

6. Authorized Defaults  
- Mutex-guarded in-memory map local to the `FetchAll` invocation  

7. Non-blocking Open Items  
- Log line wording for cache hits  

8. Success Criteria  
- Duplicate URLs in one `FetchAll` cause one `Client.Fetch`  
- Result slice length equals input length  

What should we do next with this confirmed record?

- **A.** Stop here. Keep the record in this conversation only.  
- **B.** Write the Shared-Understanding Record to a file, then stop.  
- **C.** Write an implementation plan from this record. No product code.  
- **D.** Start implementing now.

**Recommendation:** C. The record is complete enough to plan, and a plan is the next process that does not mutate the worker or treat confirmation as implementation approval.

Please choose A, B, C, or D.

### Verdict

**TARGET FAIL** against new M4/M5. Failure shape: next-step menu, no persist,
no commit, no file-review request.

## M6

**Actor:** general-purpose subagent, pre-change `skills/grilling/SKILL.md` only.

**Prompt shape:** same seeded record. Turn 1 human: `确认`. Turn 2 human:
`按这个写计划`.

### Complete response — Turn 1 (after 确认)

Using grilling to complete HANDOFF from the confirmed Shared-Understanding Record.

I inspected `tests/skills/fixtures/language-guidance/go-basic`: `FetchAll` walks `urls` in order, calls `client.Fetch` once per element, and has no dedup map.

Confirmed: the Shared-Understanding Record below is the implementation-ready decision record. Confirmation approves this record only. It does not authorize implementation.

1. Objective  
Add in-process request deduplication to the supplied Go worker so concurrent fetches for the same URL share one underlying fetch.

2. Verified Facts  
- Worker lives in `tests/skills/fixtures/language-guidance/go-basic`  
- `fetch.go` exposes `FetchAll(ctx, client, urls []string)`  
- No existing deduplication  

3. Confirmed Decisions  
- Deduplicate by exact URL string within one `FetchAll` call only  
- Preserve one result per input in original order  
- No public API change  

4. Closed Branches  
- Cross-process cache: rejected; fixture has no shared store  
- Changing `FetchAll` signature: rejected; keep existing contract  

5. Constraints and Non-goals  
- No new dependencies  
- No distributed cache  

6. Authorized Defaults  
- Mutex-guarded in-memory map local to the `FetchAll` invocation  

7. Non-blocking Open Items  
- Log line wording for cache hits  

8. Success Criteria  
- Duplicate URLs in one `FetchAll` cause one `Client.Fetch`  
- Result slice length equals input length  

What should the next authorized action be?

A. Write an implementation plan from this confirmed record  
B. Implement `FetchAll` now without a written plan  
C. Persist this record to a spec file and stop  
D. Stop here; keep the record in this conversation only  

**Recommendation:** A. The record is complete and implementation-ready. A written plan is the lowest-risk next step: it locks TDD and the call-local mutex map without changing the public API or starting code.

Please choose A, B, C, or D.

### Complete response — Turn 2 (after 按这个写计划)

I'm using the writing-plans skill to create the implementation plan.

`按这个写计划` authorizes planning from the confirmed in-chat record (choice A). It does not authorize product implementation.

Plan complete and saved to `docs/wukong-code/plans/2026-09-08-2232-in-process-request-deduplication.md`.

The plan has one TDD task: a failing test that `["/a","/b","/a"]` yields two `Client.Fetch` calls and a length-3 result in input order, then a call-local `sync.Mutex` + `map[string]fetchOutcome` inside the existing `FetchAll` signature. No new dependencies, no distributed cache, no logging (cache-hit wording stays open), no fixture code written in this turn.

Two execution options:

**1. Subagent-Driven (recommended)** — I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** — Execute tasks in this session using executing-plans, batch execution with checkpoints

Which approach?

Probe plan was untracked only and was deleted in Probe Cleanup. No probe commit remained.

### Verdict

**TARGET FAIL** against new M6. Failure shape: plan request treated as old
next-step authorization; `writing-plans` ran without a written spec file.

## M7

**Actor:** general-purpose subagent, pre-change `skills/grilling/SKILL.md` only.

**Prompt shape:** mid-interview, material decisions unresolved. Human:
`够了，先停`.

### Complete response

已停止追问。下面是当前未完成的共享理解记录；**不写 spec、不提交、不实现**。

## Partial Shared-Understanding Record

### 1. Objective

给 `tests/skills/fixtures/language-guidance/go-basic` 的 worker 增加请求去重，使相同 URL 的并发/重复拉取尽量共用一次底层 `Fetch`。访谈在关键决策未定前被中止。

### 2. Verified Facts

- Worker 在 `tests/skills/fixtures/language-guidance/go-basic`：`go.mod`（`example.com/language-guidance-fixture`，Go 1.22）、`fetch.go`、`fetch_test.go`。
- `fetch.go` 暴露 `FetchAll(ctx context.Context, client Client, urls []string) ([]string, error)`；`Client` 只有 `Fetch(context.Context, string) (string, error)`。
- 现实现按输入顺序逐个调用 `client.Fetch`，遇错立即返回 `nil, err`；**没有去重、没有并发、没有缓存**。
- 现有测试只覆盖客户端错误透传（`TestFetchAllReturnsClientError`），没有重复 URL 或调用次数断言。
- 该 fixture 没有共享存储、没有进程外缓存、没有额外依赖。

### 3. Confirmed Decisions

无。访谈在任何实现向决策被确认或显式委托之前停止。

### 4. Closed Branches

无。没有分支被人类伙伴关闭。

### 5. Constraints and Non-goals

未确认。从 fixture 只能看出：当前模块零第三方依赖、无分布式存储；这些**不是**已批准的约束。

### 6. Authorized Defaults

无。没有被授权的默认实现（例如互斥锁 + 调用内 map、错误策略、结果复用方式等）。

### 7. Non-blocking Open Items

无。剩余开放项都是实现向的，因此都是阻塞项，不是可延后细节。

### 8. Success Criteria

未确认。没有已同意的验收标准（例如：一次 `FetchAll` 内重复 URL 只打一次 `Client.Fetch`、结果切片长度是否等于输入长度等）。

---

## Blocking unresolved items

继续实现前必须先定下这些（访谈停在这里）：

1. **去重范围**：仅单次 `FetchAll` 调用内，还是跨调用 / 跨进程。
2. **去重键**：精确 URL 字符串，还是规范化后的 URL。
3. **结果形状**：是否保持「每个输入一个结果、原顺序」，还是去重后的唯一结果集。
4. **公开 API**：是否保持现有 `FetchAll` 签名。
5. **并发与共享**：串行复用结果，还是同 URL 并发共享同一次 in-flight `Fetch`。
6. **错误策略**：共享 fetch 失败时，所有重复槽位是否同一错误、是否 fail-fast。
7. **验收**：用什么测试证明「重复 URL 只触发一次 `Client.Fetch`」。

记录未确认，因此不会进入 HANDOFF，也不会落盘。要恢复访谈时再说一声即可。

### Verdict

**TARGET PASS** against M7 on the current skill. Partial record,
conversation-only, no persist.

## U1

**Actor:** general-purpose subagent told it is the primary conversation
agent (SUBAGENT-STOP does not apply). Loaded pre-change
`skills/using-wukong-code/SKILL.md` then pre-change `skills/grilling/SKILL.md`.

**Prompt shape:** confirmed record, no written-spec approval. Human: `确认`.

### Complete response

Using **grilling** to lock the confirmed Shared-Understanding Record and choose the next authorized step.

**Confirmed:** this record is the shared understanding. Confirmation approves the record only, not implementation, a written spec, or a file write.

## Shared-Understanding Record

1. **Objective**  
   Add in-process request deduplication to the supplied Go worker so concurrent fetches for the same URL share one underlying fetch.

2. **Verified Facts**  
   - Worker lives in `tests/skills/fixtures/language-guidance/go-basic`  
   - `fetch.go` exposes `FetchAll(ctx, client, urls []string)`  
   - No existing deduplication

3. **Confirmed Decisions**  
   - Deduplicate by exact URL string within one `FetchAll` call only  
   - Preserve one result per input in original order  
   - No public API change

4. **Closed Branches**  
   - Cross-process cache: rejected; fixture has no shared store  
   - Changing `FetchAll` signature: rejected; keep existing contract

5. **Constraints and Non-goals**  
   - No new dependencies  
   - No distributed cache

6. **Authorized Defaults**  
   - Mutex-guarded in-memory map local to the `FetchAll` invocation

7. **Non-blocking Open Items**  
   - Log line wording for cache hits

8. **Success Criteria**  
   - Duplicate URLs in one `FetchAll` cause one `Client.Fetch`  
   - Result slice length equals input length

**Next decision:** what should happen now?

- **A.** Write a design spec from this record and stop for your review  
- **B.** Write an implementation plan from this record (no separate spec)  
- **C.** Start implementation immediately  
- **D.** Stop here; keep this record in the conversation only

**Recommendation:** **A.** There is no approved written spec yet. Confirmation locked the decisions; a spec is the smallest next artifact that can be reviewed before a plan or code.

Please choose A, B, C, or D.

### Verdict

**TARGET FAIL** against new U1. Failure shape: next-step menu; persist
skipped.

## RED gate

M4/M5, M6, and U1 fail the new persist contract. M7 already passes. Skill
files were not edited in this phase. The failing test is valid.
