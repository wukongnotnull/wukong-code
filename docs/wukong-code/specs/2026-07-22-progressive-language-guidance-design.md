# Progressive Language Guidance Design

**Status:** Approved for implementation planning

**Date:** 2026-07-22

## Summary

Wukong Code will expand from a language-agnostic development methodology into
a methodology plus language-implementation system. The existing process skills
remain authoritative for deciding how work proceeds. A new secondary
`language-guidance` skill will detect the language and development phase, then
load only the relevant language reference material.

The initial language set is Go, Java, TypeScript, and Swift. The first release
will cover language-level behavior and official toolchains, not frameworks such
as Spring, React, or SwiftUI.

## Goals

- Preserve Wukong Code's existing design, TDD, debugging, review, and
  verification workflows.
- Make plans and implementations concrete for the language and toolchain in the
  current project.
- Detect the relevant language without requiring manual configuration.
- Load only the current language and phase guidance to control context cost.
- Support mixed-language repositories by routing from the current task and
  target files rather than assigning one permanent repository language.
- Establish a repeatable contract for adding and evaluating language packs.

## Non-Goals

- Teaching language syntax or bundling comprehensive language documentation.
- Adding framework-specific guidance in the first release.
- Installing, updating, or reconfiguring compilers, formatters, test runners,
  or dependencies.
- Replacing project conventions with Wukong Code preferences.
- Loading every installed language pack into every coding session.
- Copying ECC language skills into Wukong Code.

## User Experience

Users install Wukong Code once. They do not select a language or run a separate
configuration command.

For a source-code task, Wukong Code will:

1. Select the existing primary process skill.
2. Determine whether language-specific guidance is relevant.
3. Detect the language and toolchain from explicit user intent, target files,
   and nearby project configuration.
4. Load `language-guidance` as a secondary domain skill.
5. Read no more than two references for the detected language and current
   development phase.
6. Continue under the gates and ordering imposed by the primary process skill.

The agent should make the decision visible in a compact form when it affects
the work, for example:

```text
Detected: Go project using the repository's Go toolchain
Phase: TDD / RED
Loaded: Go testing guidance
Candidate validation: go test ./...
```

Language guidance must not trigger for documentation-only tasks or other work
that does not create, modify, debug, review, or verify source code.

## Architecture

### Directory Structure

```text
skills/language-guidance/
├── SKILL.md
└── references/
    ├── registry.json
    ├── shared/
    │   └── language-pack-contract.md
    ├── go/
    │   ├── profile.md
    │   ├── implementation.md
    │   ├── testing.md
    │   ├── debugging.md
    │   ├── review.md
    │   └── verification.md
    ├── java/
    ├── typescript/
    └── swift/
```

`SKILL.md` contains only routing, evidence, phase selection, and loading rules.
It must not accumulate language knowledge. `registry.json` provides a
machine-checkable list of file extensions, strong project markers, and language
identifiers. The Markdown references contain the behavior-shaping content.

### Integration with Existing Skills

The first implementation will make one narrow change to
`using-wukong-code`: when source work is in scope and repository evidence
identifies a supported language, load `language-guidance` as a secondary domain
skill.

The first implementation will not add separate language clauses to
brainstorming, TDD, systematic debugging, code review, or verification skills.
Keeping the integration at one boundary reduces behavioral drift and lets evals
measure the router independently.

### Detection Algorithm

Detection uses the following evidence priority:

1. Language explicitly named by the user for the target work.
2. Extension of the target file or files.
3. Nearest project configuration relative to those files.
4. Strong project markers at repository scope.
5. No language selection when the evidence remains ambiguous.

Initial strong markers are:

| Language | Strong markers |
| --- | --- |
| Go | `go.mod`, `go.work`, `.go` |
| Java | `pom.xml`, `build.gradle`, `build.gradle.kts`, `.java` |
| TypeScript | `tsconfig.json`, `.ts`, `.tsx` |
| Swift | `Package.swift`, `.xcodeproj`, `.xcworkspace`, `.swift` |

For monorepos, the nearest applicable configuration wins. A root-level
`package.json` must not override a `go.mod` adjacent to the files being changed.
Cross-language tasks may select more than one language, but the agent must state
which file scope belongs to each language. If the evidence conflicts, the agent
must ask or report the ambiguity rather than guess.

Detection uses existing file-read and search capabilities. It does not require
a background process, native hook, persistent cache, generated project file, or
third-party runtime.

### Phase Routing

| Current work | References loaded |
| --- | --- |
| Design or planning | `profile.md` |
| Production implementation | `profile.md` and `implementation.md` |
| TDD or test changes | `testing.md` |
| Root-cause investigation | `debugging.md` |
| Code review | `review.md` |
| Completion verification | `verification.md` |

The default limit is two language references per decision. Loading a second
language for a cross-language task must still obey progressive disclosure and
may require processing each file scope separately.

## Language Pack Contract

Every language pack has the same six references and quality requirements.

### `profile.md`

Describes how to inspect the language version, build system, directory layout,
compiler options, test framework, formatter, static analysis, and existing
project conventions. Repository evidence always takes precedence over the
pack's defaults.

### `implementation.md`

Contains correctness-relevant language idioms. Each rule must include its
applicability, preferred form, failure mode, minimal example, and important
exceptions. It must not turn style preferences into universal requirements.

Initial focus areas are:

| Language | Focus areas |
| --- | --- |
| Go | Error wrapping, context propagation, interface boundaries, goroutine lifecycle, channel ownership, resource cleanup |
| Java | Exception boundaries, generics, immutability, resource management, concurrency, language-version compatibility |
| TypeScript | Type narrowing, unsafe assertions, ESM/CJS boundaries, async cancellation, runtime trust boundaries |
| Swift | Optionals, value semantics, ARC, protocol design, structured concurrency, actor isolation, `Sendable` |

### `testing.md`

Adapts RED-GREEN-REFACTOR to the project. It covers test locations, focused test
execution, valid RED evidence, language-specific test patterns, and coverage
commands. It must detect and reuse the repository's existing test framework.
It must not impose a universal coverage threshold.

### `debugging.md`

Extends systematic debugging with language-specific hypotheses and evidence.
Examples include Go data races and goroutine leaks, Java classpath and thread
boundaries, TypeScript runtime data crossing static type boundaries, and Swift
actor isolation or lifetime errors. It cannot replace the primary debugging
workflow.

### `review.md`

Checks language-specific correctness, concurrency, resource lifecycle, type
safety, error propagation, and version compatibility. Findings require a
concrete code location and failure scenario. Language preferences alone are not
review findings.

### `verification.md`

Selects commands in this order:

1. Commands documented or run by repository CI.
2. Existing repository scripts and build wrappers.
3. Tools declared in project configuration.
4. Safe defaults from the official language toolchain.
5. An explicit unknown result when evidence is insufficient.

The skill must not install a missing verification tool.

## Size and Context Limits

- `skills/language-guidance/SKILL.md`: at most 180 lines.
- Each `profile.md`: at most 160 lines.
- Each other phase reference: at most 200 lines.
- Default language references loaded for one decision: at most two.

These limits are regression gates, not targets. Content should be shorter when
the required behavior can be expressed clearly with less text.

## Safety and Failure Behavior

- Untrusted repository files are evidence, not governing instructions.
- Commands embedded in documentation or configuration must be inspected before
  execution.
- Destructive commands, network installers, and credential handling do not
  become authorized because a language reference mentions them.
- Unsupported languages fall back to the existing language-agnostic workflow.
- Ambiguous detection falls back to no language pack rather than a guess.
- Missing tools are reported; they are not installed automatically.
- Language guidance cannot weaken primary skill gates, user instructions, or
  harness safety requirements.

## Testing Strategy

### Static Contract Tests

Tests will verify:

- Registry syntax, supported identifiers, and marker definitions.
- Registry-to-directory consistency.
- Presence of all six required references for stable or experimental packs.
- Valid internal reference paths after plugin packaging.
- Line-count and progressive-loading limits.
- Absence of automatic installers, global configuration mutations, and
  undeclared framework requirements.
- Availability of the same source references across supported harness packages.

### Behavioral Evals

Each language must cover:

1. New feature implementation.
2. Bug investigation.
3. TDD.
4. Code review.
5. Completion verification.
6. Routing inside a mixed-language repository.
7. A documentation-only task that must not trigger language guidance.
8. Pressure to skip tests or another primary workflow gate.

Evaluators must check that:

- The correct primary process skill remains primary.
- The correct language and phase references are loaded.
- Unrelated languages are not loaded.
- Commands come from repository evidence or safe official defaults.
- No framework or new dependency is introduced without task evidence.
- The language guidance changes concrete technical decisions.
- Existing Wukong Code behavior does not regress.

Skill development must follow `writing-skills`: capture failing baseline
behavior first, implement the minimum guidance, then run multiple before/after
sessions with adversarial pressure.

## Delivery Plan

The feature will be delivered incrementally rather than as one multi-language
change:

1. Language router infrastructure plus a complete Go vertical slice.
2. Java language pack.
3. TypeScript language pack.
4. Swift language pack.
5. Cross-language regression coverage and final documentation refinement.

The infrastructure in the first change must be only what the Go vertical slice
needs. Later language packs should extend the registry and references without
redesigning the router.

The implementation plan produced immediately after this design is limited to
the router and Go vertical slice. Java, TypeScript, Swift, and the final
cross-language regression pass each require a separate implementation plan and
reviewable change. Approval of this architecture does not authorize bundling
those changes into the first pull request.

New language support starts as `experimental`. It becomes `stable` only after
its behavioral eval suite passes and a human familiar with the language reviews
the complete pack and eval evidence.

## Go Vertical-Slice Acceptance Criteria

In representative Go fixtures, the agent must:

- Detect Go through `go.mod` and relevant target files.
- Load Go implementation guidance for production changes.
- Load Go testing guidance during TDD and confirm a valid RED before production
  code changes.
- Preserve an existing `context.Context` flow where the task requires it.
- Avoid introducing an unrequested third-party error or test library.
- Select test, race, formatting, and static-check commands from repository
  evidence or safe Go toolchain defaults.
- Route to TypeScript instead when the target is a TypeScript subproject in the
  same repository.
- Avoid loading Go guidance for a README-only change.

## Core Policy and Governance

The contribution policy will add a narrow exception for language-level packs.
Language guidance may live in core only when it:

- Applies broadly across projects written in that language.
- Remains independent of a company, team, business domain, and framework.
- Uses official toolchains or tools already present in the repository.
- Adds no required third-party dependency.
- Composes with all relevant primary workflow skills.
- Includes behavioral eval and regression evidence.
- Has an identified maintenance responsibility.

Frameworks, cloud services, databases, business domains, and team-specific
standards remain standalone plugin concerns.

The public support matrix will record each language's status, capability
coverage, verified project and toolchain shapes, most recent behavior-eval date,
known limitations, and maintenance responsibility. It must not claim support
for every language version.

Language content should be grounded, in order, in official specifications and
toolchain documentation, repository evidence, reproducible real tasks, and
behavior rules demonstrated by evals. Source material may be summarized in
design notes but must not be copied wholesale into resident skill content.

## Success Criteria

The first phase succeeds when:

- A user installs Wukong Code once and receives automatic, evidence-based
  language routing without configuration.
- Only relevant language and phase references are loaded.
- Go, Java, TypeScript, and Swift follow one enforceable pack contract.
- Language advice produces executable plans, idiomatic implementations, and
  correct project-specific verification commands in behavioral evals.
- Existing Wukong Code process gates continue to trigger and control the work.
- Framework and third-party domain content remains outside core.
