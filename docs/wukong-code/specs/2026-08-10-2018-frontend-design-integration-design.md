# Frontend Design Integration Design

**Status:** Approved for implementation planning

**Date:** 2026-08-10

**Source:** `anthropics/skills`, `skills/frontend-design` on the `main` branch,
retrieved 2026-08-10.

## Summary

Wukong Code will ship Anthropic's `frontend-design` skill as a first-class
top-level skill. The upstream skill will be copied without behavioral edits and
will retain the Apache License 2.0 supplied with its source. Wukong Code's MIT
license will continue to govern the repository as a whole, except for the
bundled third-party skill and its accompanying license.

## Problem

Wukong Code provides methodology and process skills but has no complementary
guidance for agents building or reshaping frontend interfaces. Users who want
the framework's workflow and Anthropic's design direction must currently
install or copy the latter separately, which prevents one consistent,
cross-harness skill installation.

## Goals

- Add `skills/frontend-design/SKILL.md` as an exact copy of the upstream skill
  retrieved on 2026-08-10.
- Include the upstream `LICENSE.txt` (Apache License 2.0) next to the copied
  skill, satisfying the upstream redistribution requirement.
- Attribute the source and separate license in the README's skill inventory.
- Extend the Codex archive packaging test to ensure the skill and its license
  are shipped.
- Preserve existing automatic discovery: every existing harness already loads
  the repository's `skills/` directory.

## Non-Goals

- Rewriting, merging, or otherwise modifying Anthropic's design guidance.
- Adding framework-specific templates, frontend dependencies, tools, or
  runtime code.
- Changing Wukong Code's process-skill routing or making frontend design
  mandatory for unrelated work.
- Publishing an upstream pull request.

## Architecture and Files

```text
skills/frontend-design/
├── SKILL.md       # Exact upstream copy, Apache-2.0
└── LICENSE.txt    # Upstream Apache License 2.0 text
```

The following repository surfaces will change:

- `README.md` will list `frontend-design` under the skills library, explain it
  is an Apache-2.0 skill from Anthropic, and link to its source.
- `tests/codex/test-package-codex-plugin.sh` will assert that both bundled
  files are present in the generated archive. Its metadata fixture already
  derives a metadata file for each skill directory, so no production manifest
  change is needed.

## Licensing and Attribution

The copied files will retain their upstream content. The nearby `LICENSE.txt`
will provide the Apache License 2.0 text required by its front matter. The
README will identify Anthropic and link to the upstream skill. No Anthropic
trademark is used to brand this plugin; the attribution describes the source
of the bundled content only.

## Verification

1. Confirm the copied `SKILL.md` matches the downloaded upstream version.
2. Confirm the copied `LICENSE.txt` matches the upstream Apache-2.0 license.
3. Run `tests/codex/test-package-codex-plugin.sh` and verify that the generated
   archive contains both files and that every packaged skill receives metadata.
4. Run the relevant shell-lint test for changed shell tests.

## Risks and Mitigations

- **Upstream drift:** this integration is a snapshot, so the README identifies
  the source and retrieval date rather than claiming automatic synchronization.
- **License ambiguity:** keeping the complete Apache-2.0 file beside the
  copied skill makes its scope clear to archive consumers.
- **Core scope:** the skill is framework-agnostic frontend design guidance;
  it introduces neither a third-party dependency nor project-specific
  configuration.
