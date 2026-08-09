# Product Design Core Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (- [ ]) syntax for tracking.

**Goal:** Import all ten Product Design skills and their required local resources into the root Wukong Code plugin, with packaged-artifact coverage.

**Architecture:** Flatten the Product Design package into the existing root-plugin layout: its ten skills live under skills/, while their shared relative-link targets live at references/, scripts/, and templates/. A focused Bash verifier proves that the imported skill graph is complete; the Codex packaging test proves that the same resource graph is shipped.

**Tech Stack:** Markdown skills, Bash test scripts, Node.js built-in assertions, existing Codex archive packager, rsync for mechanical file import.

## Global Constraints

- Import exactly /Users/wukong/Downloads/product-design, version 0.1.52.
- Preserve all ten skill names and complete directories; do not rename or rewrite imported Product Design skill content.
- Copy only Product Design execution resources: skills/, references/, scripts/, and templates/; exclude .DS_Store, caches, and node_modules.
- Do not add package dependencies, MCP servers, hooks, credentials, or deployment defaults.
- Keep all pre-existing Wukong Code skills behaviorally unchanged.
- This is a local-fork-only integration; do not publish it or prepare an upstream PR.
- JavaScript and TypeScript have no registered language-guidance packs in this repository. Use existing project commands and do not invent language-specific guidance.

---

## File Structure

- Create: tests/product-design/test-core-integration.sh — verifies the complete Product Design skill graph and, later, provenance metadata.
- Create: skills/{audit,design-qa,get-context,ideate,image-to-code,index,research,share,url-to-code,user-context}/ — byte-preserving source skill directories, including their supporting references, scripts, and agent metadata.
- Create: references/{communication-protocol.md,critical-overrides.md,existing-codebase-edits.md,local-prototype-preflight.md} — shared targets for skill-relative links.
- Create: scripts/{bootstrap-prototype.mjs,check-sites-starter-contract.mjs} — source-root helper and template contract checker.
- Create: templates/{prototype,mobile-app}/ — complete source starter templates, including lockfiles, tests, and checked-in assets.
- Modify: scripts/package-codex-plugin.sh — archive the three imported source-root resource families and only the two Product Design source-root scripts.
- Modify: tests/codex/test-package-codex-plugin.sh — require Product Design support resources in zip and tar artifacts.
- Modify: .codex-plugin/plugin.json — add accurate Product Design discovery metadata.
- Modify: README.md — document the ten imported capabilities, provenance, and local-fork-only boundary.

## Task 1: Import the Product Design skill graph

**Files:**
- Create: tests/product-design/test-core-integration.sh
- Create: the ten skills, four shared references, two root scripts, and two templates enumerated above.

**Interfaces:**
- Consumes: the source directory /Users/wukong/Downloads/product-design and the root skill location declared in .codex-plugin/plugin.json.
- Produces: tests/product-design/test-core-integration.sh, which exits zero only when the expected graph is present.

- [ ] **Step 1: Write the failing structural integration test**

Create tests/product-design/test-core-integration.sh with this content and make it executable:

~~~bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
EXPECTED_SKILLS=(
  audit design-qa get-context ideate image-to-code
  index research share url-to-code user-context
)
EXPECTED_SHARED_FILES=(
  references/communication-protocol.md
  references/critical-overrides.md
  references/existing-codebase-edits.md
  references/local-prototype-preflight.md
  scripts/bootstrap-prototype.mjs
  scripts/check-sites-starter-contract.mjs
  templates/prototype/package.json
  templates/mobile-app/package.json
)

fail() {
  echo "[FAIL] $1" >&2
  exit 1
}

for skill in "${EXPECTED_SKILLS[@]}"; do
  skill_file="$REPO_ROOT/skills/$skill/SKILL.md"
  [[ -f "$skill_file" ]] || fail "missing Product Design skill: skills/$skill/SKILL.md"
  actual_name="$(awk '/^name: / { sub(/^name: /, ""); print; exit }' "$skill_file")"
  [[ "$actual_name" == "$skill" ]] || fail "skills/$skill/SKILL.md has name '$actual_name'"
done

for relative_path in "${EXPECTED_SHARED_FILES[@]}"; do
  [[ -f "$REPO_ROOT/$relative_path" ]] || fail "missing shared Product Design resource: $relative_path"
done

for skill in "${EXPECTED_SKILLS[@]}"; do
  while IFS= read -r -d '' skill_file; do
    skill_dir="$(dirname "$skill_file")"
    while IFS= read -r target; do
      target="${target%%#*}"
      case "$target" in
        ''|http://*|https://*|mailto:*) continue ;;
      esac
      [[ -e "$skill_dir/$target" ]] || fail "broken local link in ${skill_file#$REPO_ROOT/}: $target"
    done < <({ grep -oE '\]\(([^)#]+)(#[^)]*)?\)' "$skill_file" || true; } | sed -E 's/^\]\(//; s/\)$//' | tr '\n' '\0')
  done < <(find "$REPO_ROOT/skills/$skill" -type f -name '*.md' -print0 | sort -z)
done

for import_root in skills references scripts templates; do
  if find "$REPO_ROOT/$import_root" -name .DS_Store -print -quit | grep -q .; then
    fail "imported Product Design resources contain .DS_Store"
  fi
done

echo "Product Design skill graph is complete."
~~~

- [ ] **Step 2: Run the test to verify it fails**

Run: bash tests/product-design/test-core-integration.sh

Expected: nonzero exit and missing Product Design skill: skills/audit/SKILL.md.

- [ ] **Step 3: Perform the mechanical source import**

Run from the repository root:

~~~bash
SOURCE_PRODUCT_DESIGN=/Users/wukong/Downloads/product-design
for skill in audit design-qa get-context ideate image-to-code index research share url-to-code user-context; do
  rsync -a --exclude '.DS_Store' "$SOURCE_PRODUCT_DESIGN/skills/$skill/" "skills/$skill/"
done
rsync -a --exclude '.DS_Store' "$SOURCE_PRODUCT_DESIGN/references/" references/
rsync -a --exclude '.DS_Store' "$SOURCE_PRODUCT_DESIGN/scripts/" scripts/
rsync -a --exclude '.DS_Store' "$SOURCE_PRODUCT_DESIGN/templates/" templates/
chmod +x tests/product-design/test-core-integration.sh
~~~

Do not copy source-root assets/, agents/openai.yaml, README.md, or package.json: they are presentation metadata rather than execution dependencies of the flattened root plugin.

- [ ] **Step 4: Run the structural test to verify it passes**

Run: bash tests/product-design/test-core-integration.sh

Expected: Product Design skill graph is complete. and exit status 0.

- [ ] **Step 5: Run the imported template contract check**

Run: node scripts/check-sites-starter-contract.mjs

Expected: Product Design web and mobile starters share the Sites preview and artifact contract. and exit status 0.

- [ ] **Step 6: Commit the complete source import**

~~~bash
git add skills references scripts templates tests/product-design/test-core-integration.sh
git commit -m "feat: add product design core skills"
~~~

## Task 2: Ship Product Design resources in Codex archives

**Files:**
- Modify: tests/codex/test-package-codex-plugin.sh
- Modify: scripts/package-codex-plugin.sh

**Interfaces:**
- Consumes: the imported source-root references/, templates/, and two Product Design source-root scripts.
- Produces: rootless zip and tar.gz artifacts that include the imported resource graph but exclude all unrelated root scripts.

- [ ] **Step 1: Extend the package test with failing archive expectations**

Immediately after the existing assertion for assets/wukong-code-small.svg in tests/codex/test-package-codex-plugin.sh, add:

~~~bash
assert_contains "$archive_paths" "references/critical-overrides.md" "archive includes Product Design shared references"
assert_contains "$archive_paths" "scripts/bootstrap-prototype.mjs" "archive includes Product Design bootstrap script"
assert_contains "$archive_paths" "scripts/check-sites-starter-contract.mjs" "archive includes Product Design template contract check"
assert_contains "$archive_paths" "templates/prototype/package.json" "archive includes Product Design web starter"
assert_contains "$archive_paths" "templates/mobile-app/package.json" "archive includes Product Design mobile starter"

unexpected_product_design_scripts="$(
  printf '%s\n' "$archive_paths" |
    awk '$0 ~ /^scripts\// && $0 != "scripts/bootstrap-prototype.mjs" && $0 != "scripts/check-sites-starter-contract.mjs"'
)"
assert_equals "$unexpected_product_design_scripts" "" "archive excludes unrelated root scripts"
~~~

Replace the existing unexpected_pattern assignment with:

~~~bash
unexpected_pattern='(^wukong-code/|^\.agents/|package\.json$|^\.git|^\.pytest_cache|^\.ruff_cache|^tests/|^docs/|^evals/|^lib/|^\.claude|^\.cursor|^\.kimi|^\.opencode|^\.pi|^AGENTS\.md$|^CLAUDE\.md$|^GEMINI\.md$|^RELEASE-NOTES\.md$|^CHANGELOG\.md$)'
~~~

- [ ] **Step 2: Run the package test to verify it fails**

Run: bash tests/codex/test-package-codex-plugin.sh

Expected: new Product Design archive-content assertions fail because the package script does not yet include shared references, templates, or Product Design source-root scripts.

- [ ] **Step 3: Add the required archive inputs**

In scripts/package-codex-plugin.sh, extend the existing git archive path list before skills with:

~~~bash
  references \
  scripts/bootstrap-prototype.mjs \
  scripts/check-sites-starter-contract.mjs \
  templates \
~~~

Replace the current unexpected_paths assignment and single-path guard with:

~~~bash
unexpected_paths="$(
  printf '%s\n' "$archive_paths" |
    grep -E '(^wukong-code/|^\.agents/|^hooks/(hooks\.json|hooks-cursor\.json)$|package\.json$|^\.git|^\.pytest_cache|^\.ruff_cache|^tests/|^docs/|^evals/|^lib/|^\.claude|^\.cursor|^\.kimi|^\.opencode|^\.pi|^AGENTS\.md$|^CLAUDE\.md$|^GEMINI\.md$|^RELEASE-NOTES\.md$|^CHANGELOG\.md$)' || true
)"
unexpected_scripts="$(
  printf '%s\n' "$archive_paths" |
    awk '$0 ~ /^scripts\// && $0 != "scripts/bootstrap-prototype.mjs" && $0 != "scripts/check-sites-starter-contract.mjs"'
)"
if [[ -n "$unexpected_paths" || -n "$unexpected_scripts" ]]; then
  printf '%s\n' "$unexpected_paths" "$unexpected_scripts" | sed '/^$/d; s/^/  /' >&2
  die "archive contains source-only paths"
fi
~~~

- [ ] **Step 4: Run the package test to verify it passes**

Run: bash tests/codex/test-package-codex-plugin.sh

Expected: all zip and tar.gz assertions pass, including the five Product Design resource checks and unrelated-root-script exclusion.

- [ ] **Step 5: Commit the packaging support**

~~~bash
git add scripts/package-codex-plugin.sh tests/codex/test-package-codex-plugin.sh
git commit -m "fix: package product design resources"
~~~

## Task 3: Publish accurate root-plugin discovery metadata

**Files:**
- Modify: tests/product-design/test-core-integration.sh
- Modify: .codex-plugin/plugin.json
- Modify: README.md

**Interfaces:**
- Consumes: the completed skill graph from Task 1.
- Produces: root-plugin metadata and documentation that expose Product Design capability while recording source version and the local-fork boundary.

- [ ] **Step 1: Extend the focused test with failing provenance checks**

Before the final success echo in tests/product-design/test-core-integration.sh, add:

~~~bash
python3 - "$REPO_ROOT/.codex-plugin/plugin.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as manifest_file:
    manifest = json.load(manifest_file)

if "product-design" not in manifest.get("keywords", []):
    raise SystemExit("root plugin manifest is missing the product-design keyword")
PY

grep -Fq "Product Design (local fork integration)" "$REPO_ROOT/README.md" ||
  fail "README is missing the Product Design local-fork section"
grep -Fq "product-design version 0.1.52" "$REPO_ROOT/README.md" ||
  fail "README is missing the imported Product Design source version"
~~~

- [ ] **Step 2: Run the focused test to verify it fails**

Run: bash tests/product-design/test-core-integration.sh

Expected: nonzero exit and root plugin manifest is missing the product-design keyword.

- [ ] **Step 3: Add root-plugin metadata and provenance documentation**

In .codex-plugin/plugin.json, append these exact keywords after workflow:

~~~json
"product-design",
"ux-research",
"prototyping",
"design-qa"
~~~

Extend interface.longDescription with this exact final sentence:

~~~text
 Local-fork Product Design skills add UX research, flow audits, visual ideation, frontend prototyping, and design QA.
~~~

Add this section to README.md after the Meta skill list and before Philosophy:

~~~markdown
### Product Design (local fork integration)

This local fork also bundles Product Design workflows for product brief intake,
UX research, flow audits, visual ideation, image and URL-to-code prototypes,
prototype QA, saved design context, and prototype sharing. These ten skills are
imported from product-design version 0.1.52; their shared references, bootstrap
scripts, and web/mobile starter templates are packaged with the root plugin.
This domain-specific addition is local only and must not be submitted as a
Wukong Code upstream core contribution.
~~~

- [ ] **Step 4: Run the focused test to verify it passes**

Run: bash tests/product-design/test-core-integration.sh

Expected: Product Design skill graph is complete. and exit status 0.

- [ ] **Step 5: Commit discovery metadata and documentation**

~~~bash
git add .codex-plugin/plugin.json README.md tests/product-design/test-core-integration.sh
git commit -m "docs: document product design core integration"
~~~

## Task 4: Verify the completed root-plugin integration

**Files:**
- Verify: tests/product-design/test-core-integration.sh
- Verify: scripts/check-sites-starter-contract.mjs
- Verify: tests/codex/test-package-codex-plugin.sh
- Verify: .codex-plugin/plugin.json

**Interfaces:**
- Consumes: committed Tasks 1 through 3.
- Produces: direct evidence that the skill graph, template contract, and Codex archives meet every acceptance criterion.

- [ ] **Step 1: Run the Product Design graph verifier**

Run: bash tests/product-design/test-core-integration.sh

Expected: Product Design skill graph is complete. and exit status 0.

- [ ] **Step 2: Run the Product Design template contract verifier**

Run: node scripts/check-sites-starter-contract.mjs

Expected: Product Design web and mobile starters share the Sites preview and artifact contract. and exit status 0.

- [ ] **Step 3: Run the Codex packaging verifier**

Run: bash tests/codex/test-package-codex-plugin.sh

Expected: all archive assertions pass for both zip and tar.gz output.

- [ ] **Step 4: Check the final repository delta**

Run: git diff HEAD~3..HEAD --check && git status --short

Expected: no whitespace errors; status contains no changes from this implementation. Preserve the pre-existing untracked docs/wukong-code/plans/2026-08-02-1220-java-language-guidance.md without staging, editing, or deleting it.

- [ ] **Step 5: Record final verification evidence in the handoff**

Report the three passing command summaries, list the ten imported skills, note package archive coverage for references/, two named Product Design scripts, and templates/, and repeat that no upstream PR was created.
