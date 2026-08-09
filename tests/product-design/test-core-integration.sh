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
