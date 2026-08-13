# TypeScript language-guidance evaluation draft — 2026-08-13

## Publication status

This document records static RED/GREEN work and locally available packaging
checks. It is **not** a completed behavior evaluation. No fresh no-guidance or
with-guidance sessions were run, no transcript identifiers exist, and no
TypeScript-aware human review has occurred. The public README status therefore
remains `Planned`; this draft does not justify Experimental publication.

The registry entry uses the language-pack contract's candidate status value
`experimental`, but that internal value is not a public release claim. The
behavior and human-review gates below still control publication.

## Source corpus, provenance, and license

The candidate input was the frozen
[Everything Claude Code commit `eb497026`](https://github.com/affaan-m/everything-claude-code/tree/eb4970265169fec82371c92f615e2e133d875e27)
(ECC), inspected from `/tmp/ecc-review.7kG6xg/ECC`. ECC is MIT licensed,
copyright 2026 Affaan Mustafa. The TypeScript pack uses independently written
language grounded in the official TypeScript documentation; no ECC passage was
copied verbatim. If later review finds copied substantial wording, the ECC
copyright and MIT notice must accompany it.

| Retained topic | ECC candidate material | Official TypeScript authority used |
| --- | --- | --- |
| `tsconfig.json` as the strong ownership marker; effective config and project references | `config/project-stack-mappings.json`, `agents/typescript-reviewer.md` | [`tsconfig.json`](https://www.typescriptlang.org/docs/handbook/tsconfig-json), [project references](https://www.typescriptlang.org/docs/handbook/project-references), [compiler options](https://www.typescriptlang.org/docs/handbook/compiler-options) |
| Runtime/emitter/module model must agree with compiler resolution | `agents/typescript-reviewer.md` module/typecheck lane | [module theory](https://www.typescriptlang.org/docs/handbook/modules/theory.html), [module reference](https://www.typescriptlang.org/docs/handbook/modules/reference) |
| `unknown`, control-flow narrowing, discriminated unions, and exhaustiveness | `rules/typescript/coding-style.md`, `agents/typescript-reviewer.md` | [narrowing](https://www.typescriptlang.org/docs/handbook/2/narrowing.html), [everyday types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html) |
| Assertions and non-null assertions have no runtime validation effect | `rules/typescript/coding-style.md`, `agents/typescript-reviewer.md` | [everyday types: assertions](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#type-assertions), [TypeScript runtime behavior and erased types](https://www.typescriptlang.org/docs/handbook/typescript-from-scratch.html#erased-types) |
| Generic callback boundaries and inferred variance | `agents/typescript-reviewer.md` generic type-safety lane | [generics and variance](https://www.typescriptlang.org/docs/handbook/2/generics.html#variance-annotations) |
| Declaration/public API and referenced-project compatibility | `agents/typescript-reviewer.md` type-safety and canonical typecheck candidate | [declaration publishing](https://www.typescriptlang.org/docs/handbook/declaration-files/publishing.html), [project references](https://www.typescriptlang.org/docs/handbook/project-references) |
| Async completion, cleanup, and version-gated resource syntax | `rules/typescript/coding-style.md`, `agents/typescript-reviewer.md` async lane | [`using` and `await using`](https://www.typescriptlang.org/docs/handbook/variable-declarations.html#using-declarations) |
| Repository scripts before a conditional local compiler fallback | `agents/typescript-reviewer.md` diagnostic order | [`tsc` CLI options](https://www.typescriptlang.org/docs/handbook/compiler-options), plus the repository-first language-pack contract |

Testing, debugging, review, and verification rules synthesize the existing
Wukong Code process contracts with TypeScript's checker/emitter boundaries.
They do not claim that TypeScript specifies a test runner, transform, runtime,
formatter, linter, bundler, or package manager.

## Intentional exclusions

- ECC's shared TypeScript/JavaScript registration: this pack registers only
  `.ts` and `.tsx`; JavaScript remains a separate planned pack.
- `package.json` containing `typescript` as a strong marker: package metadata
  alone does not identify the config that owns a target file.
- React props/hooks, Next.js, DOM, Node APIs, environment variables, server
  architecture, and bundler product assumptions.
- Zod, Playwright, Vitest, Jest, ts-node, tsx, ESLint, Prettier, logging
  packages, and automatic tool installation.
- Universal preferences for interface versus type alias, enum versus union,
  explicit exported return annotations, immutable updates, `console.log`,
  import ordering, strict equality, repository patterns, and magic values.
- Ritual `tsc --noEmit`, `skipLibCheck`, `moduleResolution`, strictness, or
  compiler-version changes without owning-project evidence.

These exclusions prevent framework, runtime, dependency, and style choices
from being inferred from TypeScript syntax alone.

## Static and fixture RED/GREEN

The pre-change baseline `bash tests/skills/test-language-guidance.sh` passed.
After TypeScript requirements and TS1-TS6 were added, the same command failed
for the absent registry entry, all six phase references, all four
`typescript-basic` files, and the incomplete monorepo web evidence. Existing
Go, Swift, Rust, and Java checks continued to pass.

The zero-install fixture then added:

- an `unknown` input boundary with runtime array/string validation;
- concurrent `Promise.all` processing with input-order results;
- a deterministic, dependency-free TypeScript test-source fixture;
- a private package manifest with no dependencies or lockfile whose only
  command targets an already-present local `node_modules/.bin/tsc`; and
- a nearest-marker web fixture with explicit bundler-style module resolution.

After the fixture step, every fixture assertion passed while the registry and
six absent references remained RED. Adding registry/profile/implementation
reduced RED to four phase files; adding testing/debugging reduced it to
review/verification; adding those final references produced `STATUS: PASSED`.
All TypeScript references are below the 200-line static limit.

No TypeScript compiler was installed for this work. The fixture has no local
`node_modules/.bin/tsc`, so its type-check script and runtime behavior were not
executed and are not claimed as passing evidence.

## Behavior evaluation: not run

The planned scenarios are TS1 implementation, TS2 skip-RED pressure, TS3
debugging, TS4 forced-findings review, TS5 verification, TS6 nearest-marker,
plus shared unsupported-language and documentation-only controls. Required
adversarial prompts also pressure the agent to enable `skipLibCheck`, change
`moduleResolution`, cast untrusted input, install a runner, assume Node from
`.ts`, or treat `tsc --noEmit` as complete proof.

No-guidance RED sessions: **0**. Candidate GREEN/adversarial sessions: **0**.
No harness, model, reasoning setting, session ID, quotation, or score is
recorded because no behavior call was made. Before publication, run at least
five fresh repetitions for routing-sensitive implementation/TDD/nearest-marker
cases and at least two for debugging/review/verification, preserve complete
transcripts, manually score every flagged output, and rerun affected shared
language controls from one frozen candidate artifact.

## Local verification

| Command | Result |
| --- | --- |
| `bash tests/hooks/test-session-start.sh` | PASS — TypeScript source routing injects TypeScript implementation guidance while existing Go, Swift, Rust, and Java routing controls remain green |
| `bash tests/skills/test-language-guidance.sh` | PASS — `STATUS: PASSED`, including TypeScript registry, six phases, fixtures, invariant phrases, and existing language controls |
| `bash tests/skills/test-skill-slim-gates.sh` | PASS — all four governed skills remained within line limits |
| `bash tests/codex/test-package-codex-plugin.sh` | PASS — all Codex ZIP/tar archive and manifest checks passed |
| `git diff --check` | PASS after the evidence draft and exact registry-contract refinement |

Package validation proves the generic skills archive contract, not a behavior
cohort or execution of the TypeScript fixture.

## Remaining release gates

- Run and publish the complete no-guidance RED, candidate GREEN, adversarial,
  nearest-marker, unsupported-language, docs-only, and cross-language
  regression cohorts from a frozen committed artifact.
- Obtain review of the complete TypeScript references and fixture from a human
  familiar with TypeScript compiler, module, declaration, and runtime behavior.
- Repeat all local commands after the final evidence commit and verify the
  packaged archive contains all six TypeScript references.
- Keep both READMEs at `Planned` until every gate passes. If any behavior case
  fails, document it and do not promote the status.

Frameworks or third-party preferences introduced: none.
