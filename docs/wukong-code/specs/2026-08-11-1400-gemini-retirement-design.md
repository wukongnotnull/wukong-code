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

Remove Gemini from every current operational reference:

- `docs/testing.md` must describe only currently supported eval harnesses.
- `docs/porting-to-a-new-harness.md` must remove Gemini integration examples and
  the Gemini row from the current reference-integrations table.
- `references/product-design-host-capabilities.md` and
  `skills/product-design/SKILL.md` must not list Gemini as a supported host.
- `tests/product-design/test-core-integration.sh` must no longer require Gemini
  artifacts or list Gemini as a supported host.
- `scripts/sync-to-codex-plugin.sh` must remove its obsolete Gemini exclusion.

Add a focused regression test that proves active Gemini artifacts and active
Gemini-support claims are absent. Because the cleanup changes a behavior-shaping
skill, use `wukong-code:writing-skills` and run the required adversarial
evaluation before treating that skill change as verified.

Add a `v6.3.0` release-note entry that records the retirement cleanup and
clarifies that it removes residual configuration after prior Gemini support was
ended.

## Non-goals

- Do not restore `gemini-tools.md` or add a Gemini compatibility layer.
- Do not rewrite historical release notes or historical design documents that
  describe past Gemini support.
- Do not change Product Design workflows other than removing Gemini from their
  supported-host wording and metadata checks.
- Do not bundle CI, test-runner, policy, language-guidance, or Antigravity
  changes into this work.

## Acceptance Criteria

1. No active Gemini extension entry or context file remains in the repository.
2. No current operational documentation presents Gemini as a supported harness.
3. Product Design current skills, host metadata, and static integration checks
   no longer declare Gemini support.
4. Version validation succeeds without Gemini configuration.
5. A focused regression test and the existing affected static checks pass, and
   the working tree is clean after verification.
6. Historical material retains its original context rather than being rewritten
   as current documentation.

## Verification

Run the focused Gemini-retirement test, version audit, Product Design integration
test, and static documentation/configuration suites. Search active project
metadata and operational documentation for Gemini entries; any remaining hits
must be historical release notes, specifications, plans, or raw evaluation
records. Record the required skill-change evaluation separately; do not treat
static tests as behavior evidence.
