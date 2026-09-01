---
name: language-guidance
description: Use when creating, changing, testing, debugging, reviewing, or verifying source code whose language is established in the installed registry from explicit task or repository evidence. When explicitly invoked, test-source edits select testing; requested production-source edits emit before responding a strict Detected: <language and evidence>, Phase: implementation, and Loaded: <language>/profile.md, <language>/implementation.md decision. Verification claims, including no-command prompts, select verification, load <language>/verification.md, never install missing tools, and never invent feature or target scope.
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
Nearest-marker work selects one language from the target file plus the nearest marker. Do not `Read` another registered language's `review.md` or `implementation.md` for comparison.
If a prompt names source targets in two or more registered languages, do not
emit `Detected:`, `Phase:`, or `Loaded:` and do not read either language pack.
State each target scope separately and keep the generic workflow.
Do not `Read` either named language's `implementation.md`. Stating "avoid loading" after those files were read is a failure.
A Glob of skills/language-guidance or its references pack, including **/skills/language-guidance/**, or a Read of typescript/implementation.md or rust/implementation.md is a failure when the prompt names TypeScript and Rust or the selected language is javascript; symmetrically, do not Read javascript/implementation.md or rust/implementation.md when the selected language is typescript, including to confirm they should not be loaded.

## Phase Selection

| Work | Phase |
| --- | --- |
| Design or plan with no requested source edit | profile |
| Requested production-source edit, including brainstorming or pre-edit analysis | implementation |
| Write or run tests | testing |
| Investigate failure | debugging |
| Review code | review |
| Prove completion | verification |

Explicit failure investigation, code review, and completion verification intent takes precedence over generic no-edit analysis.
A requested test-source edit selects the testing phase even when the task also requests a production-source edit. When the already-selected primary process is TDD or testing, select the testing phase and load the selected language's `testing.md` reference. Language guidance does not determine or enforce the primary process.
When TDD is the selected primary process, select testing even when the prompt also requests a production-source edit.
For a requested production-source edit, select the implementation phase and
load both profile and implementation before discussing the approach. This
remains true when brainstorming or an instruction to explain first actions
delays the edit.
A no-command constraint blocks project verification commands, not loading the selected verification reference.
Never install missing verification tools or invent feature and target matrices.
Load at most two references per decision. For cross-language work, state each
target scope and process scopes separately when the limit would be exceeded.
Every selected reference file must be read before substantive source analysis; locating its registry entry or path is not loading it.

## Repository-First Rule

Inspect language version, module/build file, CI, scripts, tests, and nearby
code before applying a reference. Existing evidence overrides pack examples.
Do not introduce frameworks, dependencies, installers, or global config.

## Visible Decision

When your human partner explicitly invokes `$language-guidance`, strict execution is required.
Before the first substantive technical response, edit, or verification command, detect the language using
the ordered evidence above, select the phase, select one or two references,
and state this decision:

    Detected: <language and evidence>
    Phase: <one primary phase>
    Loaded: <one or two reference paths>

Print each field on its own line exactly as shown. Do not combine, paraphrase, or rename any label.
List only selected reference paths after `Loaded:`; never use pending, next, or future-tense wording.
After emitting a decision, do not load another language reference unless you first emit a new complete `Detected:`, `Phase:`, and `Loaded:` decision listing the replacement set.
If the primary process later becomes TDD or testing after an implementation decision, including invoking `wukong-code:test-driven-development`, emit a replacement `Detected:`, `Phase:`, and `Loaded:` decision that includes `<language>/testing.md` and read that file before inspecting tests, running tests, or concluding no production edit is needed. Locating `testing.md` is not loading it.
A Read of testing.md after tests already ran, or after a no-edit conclusion, is too late.
Do not Read fixture test files until testing.md has been read.
Inspecting fixture tests first is not a reason to delay testing.md. After TDD SKILL.md is Read, the next file Read must be the selected language testing.md; Read of fixture src or tests in between is FAIL. After TDD or testing applies, Glob **/* of the fixture workspace, or any Glob that lists fixture src or tests, is forbidden until language-guidance testing.md Read completes, including after TDD SKILL.md or language-guidance SKILL.md were already Read; a workspace-root **/* that lists src or tests is a TDD failure; if TDD or testing will be used at all, fixture Reads cannot precede testing.md and late switch after exploring src is still FAIL; any fixture or src Glob, Grep, Read, or **/* workspace listing before that Read completes is a failure.

For automatic selection, language-guidance may provide this decision when
loaded; automatic selection does not promise invocation or visible output.

If no registered language matches, keep the generic workflow and do not claim
guidance was loaded.

For an unsupported language or extension, do not emit `Detected:`, `Phase:`, or `Loaded:`.
State that no corresponding installed language guidance exists and keep the generic workflow.
Do not invent language packs, reference paths, profiles, implementations, or phases.

## Common Mistakes

- Treating a root package file as proof for every monorepo target.
- Loading every phase for possible future use.
- Recommending familiar tools before repository commands.
- Reporting style preferences as correctness rules.
- Weakening the primary process gate.
