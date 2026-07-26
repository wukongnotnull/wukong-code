---
name: language-guidance
description: Use when creating, changing, testing, debugging, reviewing, or verifying source code whose language can be identified from explicit task or repository evidence
---

# Language Guidance

## Overview

Load concrete language guidance only after the task primary process is known.
**Primary process remains authoritative.** This skill supplies technical
decisions; it never replaces design, TDD, debugging, review, or verification.

## When to Use

Use for source work when a registered language is established by evidence.
Do not use for documentation-only, unsupported-language, or ambiguous work.

## Detection Evidence

Evaluate in order:

1. Language explicitly named for the target work.
2. Extension of target files.
3. Nearest project marker above target files.
4. Repository marker only when target paths are unknown.

Read references/registry.json for supported identifiers. Nearest markers beat
unrelated root files. **Do not guess.** Ask or return no selection when
evidence conflicts.

## Phase Selection

| Work | Phase |
| --- | --- |
| Design or plan for known language | profile |
| Edit production source | profile and implementation |
| Write or run tests | testing |
| Investigate failure | debugging |
| Review code | review |
| Prove completion | verification |

When the already-selected primary process is TDD or testing, select the testing
phase and load references/go/testing.md. Language guidance does not determine
or enforce the primary process.
For a request that will edit production source, select the implementation phase
and load both profile and implementation, including before the edit begins.
Load at most two references per decision. For cross-language work, state each
target scope and process scopes separately when the limit would be exceeded.

## Repository-First Rule

Inspect language version, module/build file, CI, scripts, tests, and nearby
code before applying a reference. Existing evidence overrides pack examples.
Do not introduce frameworks, dependencies, installers, or global config.

## Visible Decision

When your human partner explicitly invokes `$language-guidance`, strict execution is required.
Before a response, edit, or verification command, detect the language using
the ordered evidence above, select the phase, select one or two references,
and state this decision:

    Detected: <language and evidence>
    Phase: <one primary phase>
    Loaded: <one or two reference paths>

For automatic selection, language-guidance may provide this decision when
loaded; automatic selection does not promise invocation or visible output.

If no registered language matches, keep the generic workflow and do not claim
guidance was loaded.

## Common Mistakes

- Treating a root package file as proof for every monorepo target.
- Loading every phase for possible future use.
- Recommending familiar tools before repository commands.
- Reporting style preferences as correctness rules.
- Weakening the primary process gate.
