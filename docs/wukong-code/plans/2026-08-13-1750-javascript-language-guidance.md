# JavaScript Language Guidance Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an evidence-driven, zero-dependency JavaScript language-guidance pack covering profile, implementation, testing, debugging, review, and verification without treating JavaScript as TypeScript without annotations.

**Architecture:** Register JavaScript independently using `.js`, `.mjs`, `.cjs`, `.jsx`, and the nearest `package.json`, while treating the package marker as ownership evidence only after inspecting scripts, `type`, engines, exports, and target files. Keep ECMAScript semantics separate from host behavior; repository evidence must establish Node, browser, Bun, Deno, a bundler, JSX transform, or another runtime before host-specific advice applies.

**Tech Stack:** Markdown skill references, JSON registry, Bash static-contract tests, standard-library JavaScript fixtures, existing repository eval harness.

## Global Constraints

- JavaScript and TypeScript remain separate registry entries and separate PRs; the JavaScript pack must not route `.ts` or `.tsx`.
- JavaScript support starts `experimental`; publish that status only after static contracts, behavior GREEN results, and JavaScript-aware human review are recorded.
- Do not add Node, Bun, Deno, a package manager, transpiler, bundler, test runner, DOM emulator, formatter, linter, or dependency.
- Separate language semantics from host APIs. `.js` alone does not prove Node, browser, JSX, React, CommonJS, or ESM.
- The nearest package boundary, file extension, package `type`, scripts, exports/imports, engines, runtime configuration, CI, HTML/worker entry points, and target files override examples.
- JSDoc and `checkJs` apply only when existing repository evidence enables or uses them; never turn a JavaScript task into a TypeScript migration.
- Source provenance must pin ECC commit `eb4970265169fec82371c92f615e2e133d875e27`, retain MIT attribution when wording is copied, and verify retained claims against TC39, MDN, and the owning runtime documentation.

---

### Task 1: Establish JavaScript RED controls and fixtures

**Files:**
- Create: `tests/skills/fixtures/language-guidance/javascript-basic/package.json`
- Create: `tests/skills/fixtures/language-guidance/javascript-basic/src/process-all.js`
- Create: `tests/skills/fixtures/language-guidance/javascript-basic/test/process-all.test.js`
- Create: `tests/skills/fixtures/language-guidance/monorepo/javascript-worker/package.json`
- Create: `tests/skills/fixtures/language-guidance/monorepo/javascript-worker/src/worker.mjs`
- Modify: `tests/skills/test-language-guidance.sh`
- Modify: `tests/skills/language-guidance-scenarios.md`

**Interfaces:**
- Consumes: the shared language-pack contract and existing scenario scoring contract.
- Produces: standard-library JavaScript fixtures, JS1-JS6 scenarios, and failing static assertions for the absent pack.

- [ ] **Step 1: Add failing registry and reference assertions**

Require all six `javascript/<phase>.md` files and this registry entry:

```json
"javascript": {
  "status": "experimental",
  "extensions": [".js", ".mjs", ".cjs", ".jsx"],
  "markers": ["package.json"],
  "phases": {
    "profile": "javascript/profile.md",
    "implementation": "javascript/implementation.md",
    "testing": "javascript/testing.md",
    "debugging": "javascript/debugging.md",
    "review": "javascript/review.md",
    "verification": "javascript/verification.md"
  }
}
```

Add semantic assertions:

```bash
assert_contains skills/language-guidance/references/javascript/profile.md \
  "JavaScript syntax does not identify its host environment"
assert_contains skills/language-guidance/references/javascript/implementation.md \
  "Missing, undefined, null, and an absent property are distinct contracts"
assert_contains skills/language-guidance/references/javascript/testing.md \
  "Valid RED reaches the new test"
assert_contains skills/language-guidance/references/javascript/debugging.md \
  "Reproduce under the owning runtime and module mode"
assert_contains skills/language-guidance/references/javascript/review.md \
  "Zero findings is valid"
assert_contains skills/language-guidance/references/javascript/verification.md \
  "One host does not verify another host"
```

- [ ] **Step 2: Add JS1-JS6 behavior scenarios**

Append implementation, TDD-pressure, debugging, review, verification, and nearest-marker cases. Require JS1 to validate an external value and preserve promise-result ordering; JS2 to preserve RED; JS3 to keep module mode, host APIs, promise settlement, event-loop liveness, cancellation, and unrelated slow-work hypotheses open; JS4 to reject stylistic findings; JS5 to choose repository scripts before any host default; and JS6 to select the nearest JavaScript worker rather than a sibling TypeScript project.

- [ ] **Step 3: Run the contract to verify RED**

Run: `bash tests/skills/test-language-guidance.sh`

Expected: FAIL because JavaScript is not registered and its references and fixtures do not exist.

- [ ] **Step 4: Create a Node-owned standard-library fixture without dependencies**

The fixture `package.json` must declare `"type": "module"`, an existing Node engine floor chosen from repository-compatible evidence, and `"test": "node --test"`; it must declare no dependencies. Use `node:test` only because this fixture explicitly establishes Node, not as generic JavaScript guidance.

```javascript
export async function processAll(raw, processor, signal) {
  if (!Array.isArray(raw) || !raw.every((value) => typeof value === "string")) {
    throw new TypeError("expected an array of strings");
  }
  return Promise.all(raw.map((value) => processor(value, { signal })));
}
```

- [ ] **Step 5: Run fixture and static controls**

Run:

```bash
(cd tests/skills/fixtures/language-guidance/javascript-basic && npm test)
bash tests/skills/test-language-guidance.sh
```

Expected: the fixture tests pass using the already installed Node runtime; the static contract remains RED only for missing registry/reference content.

### Task 2: Register JavaScript and add profile and implementation guidance

**Files:**
- Modify: `skills/language-guidance/references/registry.json`
- Create: `skills/language-guidance/references/javascript/profile.md`
- Create: `skills/language-guidance/references/javascript/implementation.md`
- Modify: `tests/skills/test-language-guidance.sh`

**Interfaces:**
- Consumes: Task 1 controls plus TC39 ECMAScript, MDN, and conditional owning-runtime documentation.
- Produces: JavaScript detection and production-edit references.

- [ ] **Step 1: Register JavaScript independently**

Add the exact object from Task 1. Detection must use explicit target extensions before a root `package.json`; in mixed repositories, a nearer TypeScript `tsconfig.json` and `.ts` target must not select JavaScript.

- [ ] **Step 2: Write `profile.md`**

Inspect the target extension, nearest package boundary, `type`, scripts, engines, exports/imports, workspaces, lockfile only as package-manager evidence, runtime config, bundler/transpiler config, HTML/service-worker/worker entry points, JSX transform, tests, lint/format, CI, generated code, and supported hosts. Explain `.mjs`/`.cjs` explicitness and `.js` dependence on the owning host/package rules. Do not rely on the host machine version as target compatibility evidence.

- [ ] **Step 3: Write `implementation.md`**

Use conditional guidance for missing versus `undefined` versus `null`, coercion at comparison/arithmetic/string boundaries, own versus inherited properties, mutation and reference aliasing, iterable and collection semantics, errors and causes, promise settlement and ordering, cancellation when the established host supplies it, resource cleanup, ESM/CommonJS interop, package export contracts, runtime validation, and version-gated syntax. Do not recommend JSDoc types, `checkJs`, TypeScript, classes, functional style, or immutability as universal preferences.

- [ ] **Step 4: Run the contract for partial GREEN**

Run: `bash tests/skills/test-language-guidance.sh`

Expected: registry, profile, and implementation assertions pass; four phase files remain RED.

### Task 3: Add JavaScript testing and debugging guidance

**Files:**
- Create: `skills/language-guidance/references/javascript/testing.md`
- Create: `skills/language-guidance/references/javascript/debugging.md`
- Modify: `tests/skills/test-language-guidance.sh`

**Interfaces:**
- Consumes: the host and module evidence recorded by the profile.
- Produces: host-aware testing and root-cause debugging guidance without prescribing a runner.

- [ ] **Step 1: Write `testing.md`**

Require discovery of the actual runner, host, module mode, transforms, environment, fixture/mocking style, focused selector, and CI. A valid RED reaches the new test and fails for missing behavior; syntax/module/transform failure, absent DOM/service, unavailable dependency, and unrelated suite failure do not prove RED. Preserve existing Node test, Vitest, Jest, Mocha, browser, Bun, Deno, or custom harnesses. Fake timers, DOM emulation, coverage, and runner migration require repository evidence and explicit scope.

- [ ] **Step 2: Write `debugging.md`**

Separate parse/module-loader errors, package export/import resolution, CJS/ESM interop, host-global absence, coercion and missing-property bugs, promise rejection and ordering, event-loop liveness/open handles, cancellation, timer/microtask ordering, stale transformed output/source maps, and unrelated slow work. Require reproduction under the owning runtime and module mode. Do not change package `type`, file extensions, exports, transforms, or runtime versions before evidence identifies the boundary.

- [ ] **Step 3: Run the contract for partial GREEN**

Run: `bash tests/skills/test-language-guidance.sh`

Expected: testing/debugging assertions pass; review and verification remain RED.

### Task 4: Add JavaScript review and verification guidance

**Files:**
- Create: `skills/language-guidance/references/javascript/review.md`
- Create: `skills/language-guidance/references/javascript/verification.md`
- Modify: `tests/skills/test-language-guidance.sh`

**Interfaces:**
- Consumes: Tasks 1-3 and the shared review/verification contracts.
- Produces: concrete JavaScript correctness review and evidence-scoped verification.

- [ ] **Step 1: Write `review.md`**

Require tight locations and reachable failures. Cover ambiguous missing/null contracts, unsafe coercion, prototype/ownership mistakes, mutation aliasing, swallowed errors, promise/cancellation/resource leaks, event-listener cleanup, module-format or package-export breakage, and use of APIs absent from an established target host. Exclude semicolons, quote style, `var`/`let`/`const` preference without a reachable issue, classes versus functions, ESM migration preferences, TypeScript migration, framework architecture, and speculative micro-performance. State that zero findings is valid.

- [ ] **Step 2: Write `verification.md`**

Choose CI/docs, repository scripts, declared tools, then already-installed host defaults. Separate syntax/build/transform, unit tests, browser or other host integration, lint/format, package exports, supported module modes, and supported runtime versions. A Node `node --test` result applies only to Node-owned tests; one host does not verify browsers, Bun, Deno, workers, or another Node version. Never install tools or invent a cross-host matrix.

- [ ] **Step 3: Run complete static and fixture verification**

Run:

```bash
(cd tests/skills/fixtures/language-guidance/javascript-basic && npm test)
bash tests/skills/test-language-guidance.sh
```

Expected: fixture tests pass and the language contract reports `STATUS: PASSED`.

### Task 5: Rebase after TypeScript, run JavaScript evals, and publish evidence

**Files:**
- Create: `docs/wukong-code/evals/2026-08-13-javascript-language-guidance.md`
- Modify: `README.md`
- Modify: `README.zh-CN.md`
- Resolve after rebase: `skills/language-guidance/references/registry.json`
- Resolve after rebase: `tests/skills/test-language-guidance.sh`
- Resolve after rebase: `tests/skills/language-guidance-scenarios.md`

**Interfaces:**
- Consumes: the merged TypeScript pack, JS1-JS6, shared controls, repository tests, and official source mapping.
- Produces: a union registry containing both languages, non-overlapping routing, an honest eval report, and synchronized documentation.

- [ ] **Step 1: Rebase onto the merged TypeScript branch**

Resolve shared files by retaining both complete registry entries, all TS and JS static assertions, and both scenario families. Verify `.ts`/`.tsx` select TypeScript, `.js`/`.mjs`/`.cjs`/`.jsx` select JavaScript, and the nearest target marker wins in mixed monorepos.

- [ ] **Step 2: Run no-guidance RED and candidate GREEN cohorts**

Record fresh-session RED controls and run JS1-JS6 with repeated routing-sensitive cases. Add adversarial prompts that pressure the agent to assume Node, migrate to TypeScript, change package `type`, install Jest/Vitest, add JSDoc/`checkJs`, treat a syntax check as tests, or claim Node verifies browser behavior. Publish only measured results.

- [ ] **Step 3: Run repository verification**

Run:

```bash
(cd tests/skills/fixtures/language-guidance/javascript-basic && npm test)
bash tests/skills/test-language-guidance.sh
bash tests/skills/test-skill-slim-gates.sh
bash tests/codex/test-package-codex-plugin.sh
git diff --check
```

Expected: all commands exit 0. Report any pre-existing failure exactly and keep JavaScript Planned if publication gates are incomplete.

- [ ] **Step 4: Record provenance and update both READMEs**

Document ECC candidate mapping, official TC39/MDN/owning-runtime sources, exclusions, RED/GREEN/adversarial outcomes, verification, limitations, and JavaScript-aware human review. Add a separate JavaScript row; never combine it with TypeScript. Mark it Experimental only after all gates pass.

- [ ] **Step 5: Commit the focused JavaScript change**

```bash
git add skills/language-guidance tests/skills docs/wukong-code/evals/2026-08-13-javascript-language-guidance.md README.md README.zh-CN.md
git commit -m "feat: add JavaScript language guidance"
```

