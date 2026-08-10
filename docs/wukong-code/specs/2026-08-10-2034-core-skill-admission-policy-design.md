# Core Skill Admission Policy Design

**Status:** Approved for implementation planning

**Date:** 2026-08-10

## Summary

Wukong Code will remove its blanket exclusion of domain-specific skills from the core library. New skills will be evaluated on disclosed scope, maintenance burden, license compatibility, dependency impact, test evidence, and demonstrated cross-project value rather than on their subject area alone.

This change preserves the repository's existing quality safeguards: a real problem statement, duplicate PR search, complete PR template, model and harness disclosure, full human review of the proposed diff, tests, and a `dev`-targeted pull request.

## Problem

The current contributor-facing text implies that new skills are generally unwelcome and directs domain-specific skills and third-party integrations to standalone plugins. That categorical rule prevents maintainers from deliberately accepting useful, zero-dependency skills such as frontend design guidance into the curated core library, even when the maintainer approves the inclusion.

## Goals

- Allow domain-specific and externally sourced skills to be considered for inclusion in Wukong Code core.
- Keep maintainers' ability to reject skills with narrow utility, high maintenance cost, incompatible licenses, unsafe behavior, or undeclared dependencies.
- Update the README and pull request template so prospective contributors receive consistent guidance.
- Preserve all existing requirements that establish provenance, human involvement, testing, and a single coherent PR scope.

## Non-Goals

- Automatically accept every submitted skill.
- Add third-party runtime dependencies, services, installers, or network calls.
- Remove the requirements for human review, duplicate checks, complete templates, attribution, or testing.
- Change the existing frontend-design content or license.
- Create a separate standalone plugin.

## Policy

A proposed core skill is eligible for review regardless of whether its subject matter is general-purpose or domain-specific. Its PR must explain:

1. the concrete problem and intended audience;
2. why core distribution is more appropriate than a standalone plugin;
3. licensing, source attribution, and any runtime or tool dependencies;
4. tests or evaluations proportionate to behavior impact; and
5. the maintenance owner or update strategy when the skill is externally sourced.

A skill that depends on an external runtime or service remains subject to the repository's zero-dependency principle unless that dependency is already allowed under separately documented harness support. A vendored or copied skill must retain the applicable license and attribution.

## Changes

- `README.md` will revise the contributor guidance from a presumptive rejection of new skills to a quality-gated review policy.
- `.github/PULL_REQUEST_TEMPLATE.md` will replace its domain-specific/third-party exclusion with questions that require contributors to justify core placement, scope, maintenance, license, and dependencies.

## Verification

- Search both files for the retired categorical language and confirm it is absent.
- Verify the template still requires a concrete core-library justification and retains all human-review, duplicate-search, environment, and rigor sections.
- Run `git diff --check`.
- Run the repository's relevant shell test and Codex package test to ensure unrelated packaging and test infrastructure remain healthy.

## Risks and Mitigations

- **Lower-quality submissions:** preserve the real-problem, testing, human-review, and full-template gates.
- **Unmaintained imported content:** require attribution plus a maintenance/update strategy in the PR template.
- **Undeclared dependencies:** retain the zero-dependency expectation and require explicit disclosure.
- **Policy ambiguity:** use the same core-placement questions in both README and PR template.
