# Gemini Integration Retirement Design

**Date:** 2026-08-11  
**Status:** Approved for implementation

## Problem

The repository simultaneously declares Gemini support and states that Gemini CLI
support was removed. `gemini-extension.json` still selects `GEMINI.md`, while
`GEMINI.md` imports a removed `gemini-tools.md` mapping. Installing through the
remaining extension entry therefore cannot load its declared context completely.

## Decision

Retire Gemini integration completely. Wukong Code will not advertise, package,
version, or test Gemini as a supported harness.

## Scope

Remove the active Gemini extension artifacts:

- `gemini-extension.json`
- `GEMINI.md`
- The Gemini version entry in `.version-bump.json`

Update current documentation that still presents Gemini as active support:

- `docs/testing.md` must describe only currently supported eval harnesses.
- `docs/porting-to-a-new-harness.md` must not list Gemini as a current harness.

Add a `v6.3.0` release-note entry that records the retirement cleanup and
clarifies that it removes residual configuration after prior Gemini support was
ended.

## Non-goals

- Do not restore `gemini-tools.md` or add a Gemini compatibility layer.
- Do not rewrite historical release notes or historical design documents that
  describe past Gemini support.
- Do not bundle CI, test-runner, policy, language-guidance, or Antigravity
  changes into this work.

## Acceptance Criteria

1. No active Gemini extension entry or context file remains in the repository.
2. No current operational documentation presents Gemini as a supported harness.
3. Version validation succeeds without Gemini configuration.
4. Existing static checks affected by the cleanup pass, and the working tree is
   clean after verification.
5. Historical material retains its original context rather than being rewritten
   as current documentation.

## Verification

Run the focused version audit and the static documentation/configuration suites.
Search active project metadata and operational documentation for Gemini entries;
any remaining hits must be historical release notes, specifications, or plans.
