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
  references/wukong-product-design-composition.md
  scripts/bootstrap-prototype.mjs
  scripts/check-sites-starter-contract.mjs
  templates/prototype/package.json
  templates/mobile-app/package.json
  product-design.lock.json
  THIRD_PARTY_NOTICES.md
)
MARKDOWN_ROOTS=("$REPO_ROOT/references")
for skill in "${EXPECTED_SKILLS[@]}"; do
  MARKDOWN_ROOTS+=("$REPO_ROOT/skills/$skill")
done

fail() {
  echo "[FAIL] $1" >&2
  exit 1
}

python3 - "$REPO_ROOT" "${EXPECTED_SKILLS[@]}" <<'PY'
from pathlib import Path
import sys

root = Path(sys.argv[1])
for expected in sys.argv[2:]:
    skill_file = root / "skills" / expected / "SKILL.md"
    if not skill_file.is_file():
        raise SystemExit(f"missing Product Design skill: skills/{expected}/SKILL.md")

    lines = skill_file.read_text(encoding="utf-8").splitlines()
    if not lines or lines[0] != "---":
        raise SystemExit(f"skills/{expected}/SKILL.md is missing opening YAML frontmatter delimiter")
    try:
        closing = lines.index("---", 1)
    except ValueError:
        raise SystemExit(f"skills/{expected}/SKILL.md is missing closing YAML frontmatter delimiter")

    names = [line.removeprefix("name: ") for line in lines[1:closing] if line.startswith("name: ")]
    if names != [expected]:
        raise SystemExit(
            f"skills/{expected}/SKILL.md frontmatter names {names!r}; expected exactly [{expected!r}]"
        )
PY

for relative_path in "${EXPECTED_SHARED_FILES[@]}"; do
  [[ -f "$REPO_ROOT/$relative_path" ]] || fail "missing shared Product Design resource: $relative_path"
done

for markdown_root in "${MARKDOWN_ROOTS[@]}"; do
  while IFS= read -r -d '' markdown_file; do
    markdown_dir="$(dirname "$markdown_file")"
    while IFS= read -r target; do
      target="${target%%#*}"
      case "$target" in
        ''|http://*|https://*|mailto:*) continue ;;
      esac
      [[ -e "$markdown_dir/$target" ]] || fail "broken local link in ${markdown_file#$REPO_ROOT/}: $target"
    done < <({ grep -oE '\]\(([^)#]+)(#[^)]*)?\)' "$markdown_file" || true; } | sed -E 's/^\]\(//; s/\)$//' | tr '\n' '\0')
  done < <(find "$markdown_root" -type f -name '*.md' -print0 | sort -z)
done

grep -Fq "Wukong process selection remains primary" \
  "$REPO_ROOT/references/wukong-product-design-composition.md" ||
  fail "composition contract does not preserve Wukong process authority"
grep -Fq "wukong-product-design-composition.md" "$REPO_ROOT/skills/index/SKILL.md" ||
  fail "Product Design router does not link the Wukong composition contract"
grep -Fq "wukong-product-design-composition.md" "$REPO_ROOT/references/critical-overrides.md" ||
  fail "Product Design critical overrides do not link the Wukong composition contract"

if grep -Fq "/plugins/product-design/" "$REPO_ROOT/references/local-prototype-preflight.md"; then
  fail "local prototype preflight still assumes a standalone product-design plugin path"
fi
if grep -Fq "python3 scripts/" "$REPO_ROOT/skills/user-context/SKILL.md"; then
  fail "user-context still resolves helper scripts from the user's current directory"
fi

python3 - "$REPO_ROOT/product-design.lock.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as lock_file:
    lock = json.load(lock_file)

expected = {
    "name": "product-design",
    "version": "0.1.52",
    "license": "MIT",
    "distribution": "local-only",
}
for key, value in expected.items():
    if lock.get(key) != value:
        raise SystemExit(f"product-design.lock.json {key!r} must equal {value!r}")
PY

grep -Fq "Copyright (c) 2026 OpenAI" "$REPO_ROOT/THIRD_PARTY_NOTICES.md" ||
  fail "third-party notice is missing the upstream OpenAI copyright"
grep -Fq "Permission is hereby granted, free of charge" "$REPO_ROOT/THIRD_PARTY_NOTICES.md" ||
  fail "third-party notice is missing the upstream MIT license terms"
grep -Fq "MIT-licensed" \
  "$REPO_ROOT/docs/wukong-code/specs/2026-08-09-1744-product-design-core-integration-design.md" ||
  fail "integration design does not record the verified upstream MIT license"
if grep -Fq "includes no repository license file" \
  "$REPO_ROOT/docs/wukong-code/specs/2026-08-09-1744-product-design-core-integration-design.md"; then
  fail "integration design still claims the Product Design source has no license"
fi

for import_root in skills references scripts templates; do
  if find "$REPO_ROOT/$import_root" -name .DS_Store -print -quit | grep -q .; then
    fail "imported Product Design resources contain .DS_Store"
  fi
done

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

echo "Product Design skill graph is complete."
