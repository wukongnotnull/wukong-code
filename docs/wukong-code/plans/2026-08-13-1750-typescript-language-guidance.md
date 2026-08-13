# TypeScript Language Guidance Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an evidence-driven, zero-dependency TypeScript language-guidance pack covering profile, implementation, testing, debugging, review, and verification.

**Architecture:** Register TypeScript independently from JavaScript using `.ts`, `.tsx`, and the nearest `tsconfig.json`; route production edits to compact TypeScript profile and implementation references while preserving the existing primary process. Treat ECC material as candidate input, verify retained guidance against official TypeScript documentation and repository evidence, and exclude React, Node-only, bundler-specific, and framework mandates unless the target project establishes them.

**Tech Stack:** Markdown skill references, JSON registry, Bash static-contract tests, TypeScript source fixtures, existing repository eval harness.

## Global Constraints

- TypeScript and JavaScript remain separate registry entries and separate PRs.
- TypeScript support starts `experimental`; documentation may claim support only after static contracts, behavior GREEN results, and TypeScript-aware human review are recorded.
- Do not add TypeScript, a package manager, a test runner, a bundler, a formatter, a linter, or any runtime dependency.
- The nearest `tsconfig.json`, extended configuration, package metadata, scripts, CI, and target files override pack examples.
- `module` and `moduleResolution` must model the actual runtime or bundler; never infer Node, DOM, Bun, Deno, React, or a bundler from `.ts` alone.
- Static types do not validate untrusted runtime data; type assertions and `any` are not runtime checks.
- Source provenance must pin ECC commit `eb4970265169fec82371c92f615e2e133d875e27`, retain MIT attribution when wording is copied, and prefer independent wording derived from official sources.

---

### Task 1: Establish TypeScript RED controls and fixtures

**Files:**
- Create: `tests/skills/fixtures/language-guidance/typescript-basic/tsconfig.json`
- Create: `tests/skills/fixtures/language-guidance/typescript-basic/package.json`
- Create: `tests/skills/fixtures/language-guidance/typescript-basic/src/process-all.ts`
- Create: `tests/skills/fixtures/language-guidance/typescript-basic/src/process-all.test.ts`
- Modify: `tests/skills/fixtures/language-guidance/monorepo/web/app.ts`
- Modify: `tests/skills/fixtures/language-guidance/monorepo/web/tsconfig.json`
- Modify: `tests/skills/test-language-guidance.sh`
- Modify: `tests/skills/language-guidance-scenarios.md`

**Interfaces:**
- Consumes: `skills/language-guidance/references/shared/language-pack-contract.md` and the existing language scenario scoring contract.
- Produces: a deterministic TypeScript fixture plus TS1-TS6 behavior scenarios and failing static assertions for the missing pack.

- [ ] **Step 1: Add failing registry and file assertions**

Extend the required language loop and registry expectation with `typescript`. Require all six `typescript/<phase>.md` files and this exact registry shape:

```json
"typescript": {
  "status": "experimental",
  "extensions": [".ts", ".tsx"],
  "markers": ["tsconfig.json"],
  "phases": {
    "profile": "typescript/profile.md",
    "implementation": "typescript/implementation.md",
    "testing": "typescript/testing.md",
    "debugging": "typescript/debugging.md",
    "review": "typescript/review.md",
    "verification": "typescript/verification.md"
  }
}
```

Add content assertions for these invariant phrases:

```bash
assert_contains skills/language-guidance/references/typescript/profile.md \
  "The owning tsconfig and emitted runtime model control compatibility"
assert_contains skills/language-guidance/references/typescript/implementation.md \
  "A type assertion changes the checker view, not the runtime value"
assert_contains skills/language-guidance/references/typescript/testing.md \
  "Valid RED reaches the new test"
assert_contains skills/language-guidance/references/typescript/debugging.md \
  "Do not change module settings before reproducing the resolver mismatch"
assert_contains skills/language-guidance/references/typescript/review.md \
  "Zero findings is valid"
assert_contains skills/language-guidance/references/typescript/verification.md \
  "Type checking does not prove runtime execution"
```

- [ ] **Step 2: Add TS1-TS6 behavior scenarios**

Append implementation, TDD-pressure, debugging, review, verification, and nearest-marker scenarios. TS1 must require runtime validation of an `unknown` input and deterministic result ordering; TS2 must reject skipping RED; TS3 must preserve module-resolution, runtime-shape, async completion, and unrelated slow-work hypotheses; TS4 must allow zero findings and reject style-only findings; TS5 must use repository scripts before `tsc --noEmit`; TS6 must select `monorepo/web/tsconfig.json` over sibling Go, Swift, Rust, and Java markers.

- [ ] **Step 3: Run the static contract to verify RED**

Run: `bash tests/skills/test-language-guidance.sh`

Expected: FAIL because the TypeScript registry entry, six references, and new fixtures are absent.

- [ ] **Step 4: Create a zero-install TypeScript fixture**

Use a package manifest with scripts that call only a locally available declared TypeScript tool when present; do not add dependencies or a lockfile. The checked-in fixture source must expose an `unknown` boundary and an async processor whose output order and error policy are observable. The test source remains fixture evidence and is not executed unless the existing environment already provides the declared tool.

```typescript
export type Processor = (value: string, signal?: AbortSignal) => Promise<string>;

export async function processAll(
  raw: unknown,
  processor: Processor,
  signal?: AbortSignal,
): Promise<string[]> {
  if (!Array.isArray(raw) || !raw.every((value) => typeof value === "string")) {
    throw new TypeError("expected an array of strings");
  }
  return Promise.all(raw.map((value) => processor(value, signal)));
}
```

- [ ] **Step 5: Re-run and isolate the remaining RED**

Run: `bash tests/skills/test-language-guidance.sh`

Expected: fixture assertions pass; failures remain for the missing TypeScript registry entry and reference files.

### Task 2: Register TypeScript and add profile and implementation guidance

**Files:**
- Modify: `skills/language-guidance/references/registry.json`
- Create: `skills/language-guidance/references/typescript/profile.md`
- Create: `skills/language-guidance/references/typescript/implementation.md`
- Modify: `tests/skills/test-language-guidance.sh`

**Interfaces:**
- Consumes: Task 1 controls and the official TypeScript module, narrowing, project-reference, and TSConfig documentation.
- Produces: TypeScript detection plus production-edit guidance loaded as `profile.md` and `implementation.md`.

- [ ] **Step 1: Register TypeScript**

Add the exact registry object from Task 1. Do not add `package.json` as a strong TypeScript marker because it does not establish TypeScript ownership.

- [ ] **Step 2: Write `profile.md`**

Cover the nearest owning `tsconfig.json`, `extends` chain, project references, included/excluded files, compiler version evidence, `target`, `lib`, `module`, `moduleResolution`, `moduleDetection`, `jsx`, `strict` family, declaration/output settings, path aliases, package `type`/`exports`/`imports`, runtime or bundler, scripts, CI, tests, generated code, and mixed browser/server scopes. State explicitly that one `tsconfig` cannot safely describe multiple incompatible runtime environments and that host tools do not establish project compatibility.

- [ ] **Step 3: Write `implementation.md`**

Use conditional guidance for `unknown` versus `any`, control-flow narrowing, discriminated unions and exhaustiveness, optional properties under the owning config, assertion and non-null assertion risk, generics and variance-sensitive callback boundaries, immutable/read-only API contracts, async error/cancellation ownership, resource cleanup, module specifiers, runtime validation, declaration/public API compatibility, and version-gated syntax. Do not mandate strictness changes; report them as project-level migrations requiring explicit scope.

- [ ] **Step 4: Run the contract for partial GREEN**

Run: `bash tests/skills/test-language-guidance.sh`

Expected: registry, profile, and implementation assertions pass; failures remain only for the four missing TypeScript phase files.

### Task 3: Add TypeScript testing and debugging guidance

**Files:**
- Create: `skills/language-guidance/references/typescript/testing.md`
- Create: `skills/language-guidance/references/typescript/debugging.md`
- Modify: `tests/skills/test-language-guidance.sh`

**Interfaces:**
- Consumes: the owning config and scripts established in Task 2.
- Produces: test-phase and debugging-phase references that preserve the primary TDD and systematic-debugging workflows.

- [ ] **Step 1: Write `testing.md`**

Require discovery of the existing runner, transform/runtime, DOM or server environment, test config, type-check command, CI, fixture style, and focused selector. A valid RED must compile/transform/discover/reach the new test and fail for missing behavior. Distinguish runtime tests from type tests and declaration checks. Never introduce Vitest, Jest, Node test, ts-node, tsx, a DOM emulator, coverage thresholds, or a TypeScript upgrade without repository evidence and scope.

- [ ] **Step 2: Write `debugging.md`**

Separate checker errors, emitted/runtime errors, module-resolution mismatches, package export-condition mismatches, stale declaration/output artifacts, source-map location drift, unvalidated external values, promise rejection/completion ordering, cancellation, fake timer/open handle issues, and unrelated slow operations. Require reproduction under the repository command and actual runtime before changing `module`, `moduleResolution`, paths, extensions, interop flags, or package metadata.

- [ ] **Step 3: Run the contract for partial GREEN**

Run: `bash tests/skills/test-language-guidance.sh`

Expected: testing and debugging assertions pass; failures remain only for review and verification.

### Task 4: Add TypeScript review and verification guidance

**Files:**
- Create: `skills/language-guidance/references/typescript/review.md`
- Create: `skills/language-guidance/references/typescript/verification.md`
- Modify: `tests/skills/test-language-guidance.sh`

**Interfaces:**
- Consumes: Tasks 1-3 and repository-first verification ordering.
- Produces: actionable review criteria and evidence-scoped completion commands.

- [ ] **Step 1: Write `review.md`**

Require a tight location, reachable mechanism, and concrete contract failure. Cover unchecked runtime boundaries, unsafe assertions or non-null assertions, lost union members, incorrect optional/missing semantics, unsound generic callbacks, promise or cancellation leaks, resource lifecycle, public declaration breakage, and module/runtime mismatches. Exclude preferences for interfaces versus type aliases, enums versus unions, explicit return annotations, import ordering, strictness migrations, framework architecture, or performance claims without project evidence and a failure scenario. State that zero findings is valid.

- [ ] **Step 2: Write `verification.md`**

Select commands from CI/docs, repository scripts, declared local tools, then safe official defaults only when the tool is already present. Separate type check, build/emission, runtime tests, type tests, lint/format, declarations/API, integration targets, and supported runtime/module variants. `tsc --noEmit` is conditional on a declared/available TypeScript compiler and appropriate owning config; it does not prove runtime execution, bundling, tests, or every project reference. Never install missing tools.

- [ ] **Step 3: Run the complete static contract**

Run: `bash tests/skills/test-language-guidance.sh`

Expected: `STATUS: PASSED` with existing language checks unchanged.

### Task 5: Run TypeScript behavior evals and publish honest evidence

**Files:**
- Create: `docs/wukong-code/evals/2026-08-13-typescript-language-guidance.md`
- Modify: `README.md`
- Modify: `README.zh-CN.md`

**Interfaces:**
- Consumes: TS1-TS6, shared negative controls, static contracts, package tests, and official sources.
- Produces: a reviewable experimental evidence report and synchronized English/Chinese status tables.

- [ ] **Step 1: Run no-guidance RED controls**

Run fresh isolated sessions without the candidate pack for TS1-TS6, recording exact harness, model, reasoning setting, prompt, transcript identifier, and failure behavior. Expected: the agent does not consistently perform the required TypeScript-specific evidence routing.

- [ ] **Step 2: Run GREEN and adversarial cohorts**

Run TS1-TS6 at least five times for routing-sensitive implementation/TDD/nearest-marker cases and at least twice for debugging/review/verification. Add adversarial cases for pressure to enable `skipLibCheck`, change `moduleResolution`, cast untrusted input, install a runner, assume Node from `.ts`, and claim `tsc --noEmit` proves completion. Expected: every published claim is supported; any failure remains documented and the README status remains Planned.

- [ ] **Step 3: Run repository verification**

Run:

```bash
bash tests/skills/test-language-guidance.sh
bash tests/skills/test-skill-slim-gates.sh
bash tests/codex/test-package-codex-plugin.sh
git diff --check
```

Expected: all commands exit 0. If an unrelated pre-existing failure remains, record its exact command and output instead of claiming a pass.

- [ ] **Step 4: Record provenance and update documentation**

The eval report must map retained topics to ECC candidates and official TypeScript sources, list exclusions, RED/GREEN/adversarial results, local verification, limitations, and the TypeScript-aware human-review status. Change TypeScript from Planned to Experimental in both READMEs only when all publication gates pass.

- [ ] **Step 5: Commit the focused TypeScript change**

```bash
git add skills/language-guidance tests/skills docs/wukong-code/evals/2026-08-13-typescript-language-guidance.md README.md README.zh-CN.md
git commit -m "feat: add TypeScript language guidance"
```

