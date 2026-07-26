# Language Pack Contract

Every registered language implements profile, implementation, testing,
debugging, review, and verification.

## Invariants

- Repository evidence overrides pack defaults.
- Language guidance remains secondary to the process skill.
- Unsupported or ambiguous evidence produces no language selection.
- One decision loads at most two references.
- Packs do not install tools, change global config, require frameworks, or
  add dependencies.
- Recommendations state observable applicability and important exceptions.
- Review findings require a location and failure scenario.
- Verification chooses CI/docs, repository scripts, declared tools, then
  safe official-toolchain defaults.

New packs require failing controls, repeated GREEN runs, adversarial pressure,
a language-aware human reviewer, and experimental status before release.
