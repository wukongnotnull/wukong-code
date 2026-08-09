# Product Design Core Integration Design

## Status

Approved by the user on 2026-08-09. This document defines a local fork
integration only. It must not be submitted upstream as a Wukong Code core
contribution because the imported workflows are product-design-specific.

## Goal

Import every Product Design capability supplied in
`/Users/wukong/Downloads/product-design` into this repository's root plugin so
they load from its existing `skills/` directory alongside Wukong Code's
development-process skills.

## Source Baseline

The source package identifies itself as `product-design` version `0.1.52` and
contains ten skills:

1. `audit`
2. `design-qa`
3. `get-context`
4. `ideate`
5. `image-to-code`
6. `index`
7. `research`
8. `share`
9. `url-to-code`
10. `user-context`

The source's relative links also require its shared `references/`, `scripts/`,
`templates/`, and selected `assets/` directories. The downloaded package
declares itself private and omits its repository-level license file, while the
canonical `openai/role-specific-plugins` repository publishes Product Design
under the MIT License. The integration will preserve the upstream copyright,
MIT-licensed terms, provenance, and version in the packaged artifact. It will
not be proposed upstream to Wukong Code because this remains a domain-specific
local-fork customization.

## Target Layout

```text
wukong-code/
├── skills/
│   ├── product-design/
│   ├── product-design-audit/
│   ├── product-design-context/
│   ├── product-design-design-qa/
│   ├── product-design-ideate/
│   ├── product-design-image-to-code/
│   ├── product-design-research/
│   ├── product-design-share/
│   ├── product-design-url-to-code/
│   └── product-design-user-context/
├── references/                  # shared Product Design references
├── scripts/                     # Product Design bootstrap and checks
├── templates/
│   ├── prototype/
│   └── mobile-app/
└── tests/product-design/         # integration-specific checks
```

The existing root `.codex-plugin/plugin.json` continues to declare
`"skills": "./skills/"`; no second plugin manifest or marketplace entry is
introduced. Existing Wukong Code skills remain unchanged.

## Integration Boundaries

- Preserve all ten source capabilities under collision-free
  `product-design-*` directory and frontmatter names. Their per-skill
  references, scripts, and `agents/openai.yaml` files stay beside the
  corresponding `SKILL.md` files; `product-design.lock.json` records the source
  identity and local adaptation.
- Copy source-root shared resources to the root locations expected by relative
  links: `references/`, `scripts/`, and `templates/`. Do not copy the source
  package's presentation-only `assets/`; the root plugin keeps its existing
  Wukong Code assets.
- Do not copy macOS `.DS_Store` files, source `node_modules`, caches, or other
  generated files.
- Do not add runtime dependencies, MCP servers, hooks, external credentials,
  or deployment defaults.
- Update root discovery documentation and plugin metadata only to accurately
  describe the added local Product Design capabilities and source provenance.
- Treat the Product Design workflows as domain guidance. When they build or
  change source code, the existing Wukong Code process skills remain the
  governing lifecycle rules.
- Route tool-specific behavior through the shared host-capability contract.
  Codex state remains compatible; non-Codex hosts use an explicit or portable
  state root rather than silently writing a new `~/.codex` tree.
- Identify this local fork as `6.3.0-product-design.1` across every declared
  harness manifest.

## Verification Design

The implementation adds a focused Product Design integration check before any
production import is made. It must cover:

1. the exact ten expected skill directories and their `SKILL.md` files;
2. valid YAML frontmatter with each expected skill name;
3. resolution of local Markdown links and referenced files used by the
   imported skills;
4. required shared resources at their expected repository-root paths;
5. absence of ignored source artifacts such as `.DS_Store`; and
6. portable state-root priority and legacy compatibility;
7. routing-scenario coverage and host-capability fallbacks; and
8. the provided `check-sites-starter-contract.mjs` validation against imported
   templates.

After import, run the focused integration check, the source template-contract
check, and the repository's relevant plugin packaging tests. Report any
environment-dependent checks that cannot be exercised.

## Acceptance Criteria

- All ten namespaced Product Design skills are present under root `skills/`,
  loadable through the existing root-plugin skill path, and no legacy generic
  Product Design directories remain.
- Every local reference needed by an imported skill resolves inside this
  repository.
- Supporting references, scripts, templates, and required assets are present
  without generated clutter.
- No existing Wukong Code skill changes behavior as part of this migration.
- Source provenance/version and the local-fork-only boundary are documented.
- All declared harness manifests use `6.3.0-product-design.1`.
- Codex and portable state resolution pass isolated-home tests.
- Focused integration checks, source template-contract validation, and
  relevant root-plugin packaging tests pass.

## Non-Goals

- Creating a nested Product Design plugin or marketplace entry.
- Publishing or opening a pull request for this local fork integration.
- Rewriting imported Product Design workflows, their templates, or their
  external-tool guidance.
- Adding Figma, browser, image-generation, hosting, or other connector
  dependencies to Wukong Code.
