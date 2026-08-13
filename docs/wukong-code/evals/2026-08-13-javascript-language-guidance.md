# JavaScript language-guidance evaluation draft — 2026-08-13

> **Draft, not publication evidence.** Static contracts and local fixtures have
> been exercised. No fresh-session behavior cohort and no JavaScript-aware human
> review have been completed. JS1-JS6 below are scenario definitions, not
> measured outcomes. The development sequence below was observed interactively,
> but its raw command output and intermediate repository states were not checked
> in. The public README status must remain unchanged.

## Scope and source distillation

This candidate registers JavaScript separately from TypeScript for `.js`,
`.mjs`, `.cjs`, and `.jsx`, with the nearest `package.json` as an ownership
marker. The pack requires repository evidence before selecting Node, browser,
Bun, Deno, worker, JSX, bundler, CommonJS, ESM, or another host/tool boundary.

The candidate inventory was ECC commit
[`eb4970265169fec82371c92f615e2e133d875e27`](https://github.com/affaan-m/ECC/tree/eb4970265169fec82371c92f615e2e133d875e27),
licensed MIT. Reviewed files included `rules/common/{coding-style,patterns,
testing,code-review}.md` and `rules/typescript/{coding-style,patterns,
testing}.md`. Retained themes were boundary validation, explicit errors,
test-first behavior, and correctness-focused review. Wording in this pack is
independent; no ECC passage was copied.

The following ECC defaults were deliberately excluded because they are not
broad JavaScript correctness rules: universal immutability; function/file-size
limits; fixed naming/style rules; mandatory 80% coverage, integration and E2E
suites; Zod, Playwright, Jest, Vitest, or any dependency default; TypeScript
types; automatic JSDoc; repository/API response patterns; React hooks; and
framework architecture.

## Official sources consulted

| Boundary | Primary source used to check the claim |
| --- | --- |
| ECMAScript promise settlement and input-order results | [TC39 `Promise.all`](https://tc39.es/ecma262/2025/multipage/control-abstraction-objects.html#sec-promise.all) and [MDN `Promise.all`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/all) |
| Own versus inherited properties | [TC39 `Object.hasOwn`](https://tc39.es/ecma262/2025/multipage/fundamental-objects.html#sec-object.hasown) and [MDN `Object.hasOwn`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/hasOwn) |
| ESM syntax and browser module loading | [MDN JavaScript modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules) |
| Abort signaling as a conditional host API | [MDN `AbortSignal`](https://developer.mozilla.org/en-US/docs/Web/API/AbortSignal) and [Node globals: `AbortController`](https://nodejs.org/api/globals.html#class-abortcontroller) |
| Node package boundaries, `.mjs`/`.cjs`, nearest `type`, exports/imports, and conditional exports | [Node package documentation](https://nodejs.org/api/packages.html) |
| Node-owned standard-library test fixture | [Node test runner](https://nodejs.org/api/test.html) |
| Node error identity, cause, and system metadata | [Node error documentation](https://nodejs.org/api/errors.html) |

TC39 supplies language semantics; Node documentation applies only to the
Node-owned fixture or a repository-established Node target. Browser/Web API
claims use MDN. The pack gives no Bun- or Deno-specific command/API claim; it
requires consulting the owning runtime documentation when repository evidence
selects either host.

## Development-session observations

Development-session observations were not preserved as raw output or intermediate commits and are not independently verifiable publication evidence.
They describe the TDD sequence used to develop the candidate, but a reviewer
cannot reconstruct each intermediate state from this repository.

During the development session, the first RED added the exact JavaScript
registry contract, six reference-file requirements, semantic phrases,
zero-dependency fixtures, and JS1-JS6 scenario definitions before any
JavaScript pack existed.

- `bash tests/skills/test-language-guidance.sh` exited 1. Existing Go, Swift,
  Rust, and Java checks remained green; failures named the absent JavaScript
  registry entry, six phase files, and fixtures.
- The session then added the fixture only. `(cd tests/skills/fixtures/language-guidance/
  javascript-basic && npm test)` passed three Node standard-library tests, while
  the language contract remained red only for the registry and references.
- The session reported that after adding profile/implementation, the contract
  remained red for the four absent phases. After adding testing/debugging, it
  remained red for the two absent phases. After review/verification, the
  fixture passed 3/3 and the language contract reported `STATUS: PASSED`.

These statements are development notes, not a stored raw record. Only the final
candidate checks below are directly reproducible from a committed tree.

The fixture declares Node `>=22`, ESM, `node --test`, and no dependency field.
The floor follows this repository's recorded
[Node 22 test-automation design](../specs/2026-08-11-1436-test-automation-design.md);
the related CI workflow was later removed, so this is fixture compatibility
intent rather than a current CI matrix. The observed host (`node v25.8.1`) is
execution evidence only and does not prove the declared floor or another
runtime.

## Reproducible final-candidate checks

Run these commands from the repository root on the final candidate commit:

```bash
bash tests/hooks/test-session-start.sh
(cd tests/skills/fixtures/language-guidance/javascript-basic && npm test)
bash tests/skills/test-language-guidance.sh
bash tests/skills/test-skill-slim-gates.sh
bash tests/codex/test-package-codex-plugin.sh
git diff --check
```

Record their complete output and exact commit when producing publication
evidence. A later successful rerun validates that final tree only; it does not
retroactively make the uncommitted intermediate RED/GREEN states reproducible.

## Behavior scenarios awaiting execution

JS1-JS6 cover implementation, skip-RED pressure, debugging, forced-findings
review pressure, cross-host verification pressure, and nearest-marker routing.
Required adversarial repetitions include pressure to assume Node, migrate to
TypeScript, change package `type`, add JSDoc/`checkJs`, install Jest/Vitest,
treat syntax as test proof, or generalize Node results to browsers, workers,
Bun, or Deno.

No no-guidance fresh-session control, candidate GREEN session, adversarial
repetition, raw transcript, or measured score exists yet. Static phrase matches
and fixture tests do not substitute for that evidence.

## Publication gates and limitations

- Rebase/merge after the TypeScript pack is pending; mixed-repository routing
  must retain both full registry entries and both scenario/assertion families.
- A frozen installed candidate must run fresh no-guidance RED and candidate
  GREEN cohorts, with every flagged output manually reviewed.
- JavaScript-aware human review is pending.
- Both READMEs remain unchanged. The registry uses the plan-required
  `experimental` candidate value, but the pack is not eligible for public
  Experimental publication until behavior and human-review gates pass.
- No framework, runtime, dependency, package manager, transformer, runner,
  DOM emulator, formatter, linter, or cross-host matrix was added.
