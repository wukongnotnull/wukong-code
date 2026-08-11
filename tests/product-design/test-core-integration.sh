#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
EXPECTED_SKILLS=(
  product-design
  product-design-audit
  product-design-context
  product-design-design-qa
  product-design-ideate
  product-design-image-to-code
  product-design-research
  product-design-share
  product-design-url-to-code
  product-design-user-context
)
LEGACY_PRODUCT_DESIGN_SKILLS=(
  audit design-qa get-context ideate image-to-code
  index research share url-to-code user-context
)
EXPECTED_SHARED_FILES=(
  references/communication-protocol.md
  references/critical-overrides.md
  references/existing-codebase-edits.md
  references/local-prototype-preflight.md
  references/product-design-host-capabilities.md
  references/wukong-product-design-composition.md
  scripts/bootstrap-prototype.mjs
  scripts/check-product-design-import.mjs
  scripts/check-sites-starter-contract.mjs
  templates/prototype/package.json
  templates/mobile-app/package.json
  skills/product-design-user-context/scripts/state_paths.py
  product-design.lock.json
  THIRD_PARTY_NOTICES.md
)
ROUTING_SCENARIOS="$REPO_ROOT/tests/product-design/routing-scenarios.md"
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

for legacy_skill in "${LEGACY_PRODUCT_DESIGN_SKILLS[@]}"; do
  [[ ! -e "$REPO_ROOT/skills/$legacy_skill" ]] ||
    fail "legacy Product Design skill directory still exists: skills/$legacy_skill"
done

[[ -f "$ROUTING_SCENARIOS" ]] || fail "missing Product Design routing scenarios"
for skill in "${EXPECTED_SKILLS[@]}"; do
  grep -Fq "$skill" "$ROUTING_SCENARIOS" ||
    fail "routing scenarios do not cover $skill"
done
for scenario in PD1 PD2 PD3 PD4 PD5 PD6 PD7 PD8; do
  grep -Fq "## $scenario:" "$ROUTING_SCENARIOS" ||
    fail "routing scenarios are missing $scenario"
done
grep -Fq "Ordinary UI implementation remains Wukong-led" "$ROUTING_SCENARIOS" ||
  fail "routing scenarios are missing the ordinary-coding negative case"

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
grep -Fq "wukong-product-design-composition.md" "$REPO_ROOT/skills/product-design/SKILL.md" ||
  fail "Product Design router does not link the Wukong composition contract"
grep -Fq "product-design-host-capabilities.md" "$REPO_ROOT/skills/product-design/SKILL.md" ||
  fail "Product Design router does not link the host capability contract"
grep -Fq "wukong-product-design-composition.md" "$REPO_ROOT/references/critical-overrides.md" ||
  fail "Product Design critical overrides do not link the Wukong composition contract"

if grep -Fq "/plugins/product-design/" "$REPO_ROOT/references/local-prototype-preflight.md"; then
  fail "local prototype preflight still assumes a standalone product-design plugin path"
fi
if grep -Fq "python3 scripts/" "$REPO_ROOT/skills/product-design-user-context/SKILL.md"; then
  fail "user-context still resolves helper scripts from the user's current directory"
fi
grep -Fq "PRODUCT_DESIGN_STATE_DIR" "$REPO_ROOT/skills/product-design-user-context/SKILL.md" ||
  fail "user-context does not document the portable state override"
grep -Fq ".local/state/wukong-code/product-design" \
  "$REPO_ROOT/skills/product-design-user-context/SKILL.md" ||
  fail "user-context does not document the portable state fallback"

python3 - "$REPO_ROOT" <<'PY'
from pathlib import Path
import json
import sys

root = Path(sys.argv[1])
expected = "^20.19.0 || >=22.12.0"
for template in ("prototype", "mobile-app"):
    package = json.loads((root / "templates" / template / "package.json").read_text(encoding="utf-8"))
    actual = package.get("engines", {}).get("node")
    if actual != expected:
        raise SystemExit(f"templates/{template}/package.json Node engine is {actual!r}; expected {expected!r}")
PY

grep -Fq "requires registry or network access" \
  "$REPO_ROOT/references/local-prototype-preflight.md" ||
  fail "prototype preflight does not disclose package installation connectivity"

if grep -Fq "Chat isn't supported by the Product Design plugin" \
  "$REPO_ROOT/skills/product-design/SKILL.md"; then
  fail "Product Design router still refuses non-Work-Mode hosts categorically"
fi

for host in "Codex Desktop" "ChatGPT Work Mode" "Claude Code" Cursor Kimi OpenCode Pi; do
  grep -Fq "$host" "$REPO_ROOT/references/product-design-host-capabilities.md" ||
    fail "host capability contract is missing $host"
done
if rg -qi 'gemini' "$REPO_ROOT/references/product-design-host-capabilities.md"; then
  fail "host capability contract still lists Gemini"
fi
if rg -qi 'gemini' "$REPO_ROOT/skills/product-design/SKILL.md"; then
  fail "Product Design router still lists Gemini"
fi
grep -Fq "sequential fallback" "$REPO_ROOT/references/product-design-host-capabilities.md" ||
  fail "host capability contract does not define a sequential fallback"

python3 - "$REPO_ROOT/product-design.lock.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as lock_file:
    lock = json.load(lock_file)

expected = {
    "name": "product-design",
    "version": "0.1.52",
    "wukong_code_version": "6.3.0",
    "license": "MIT",
    "distribution": "local-only",
}
for key, value in expected.items():
    if lock.get(key) != value:
        raise SystemExit(f"product-design.lock.json {key!r} must equal {value!r}")

expected_imported_roots = [
    "skills/product-design",
    "skills/product-design-audit",
    "skills/product-design-context",
    "skills/product-design-design-qa",
    "skills/product-design-ideate",
    "skills/product-design-image-to-code",
    "skills/product-design-research",
    "skills/product-design-share",
    "skills/product-design-url-to-code",
    "skills/product-design-user-context",
    "references/communication-protocol.md",
    "references/critical-overrides.md",
    "references/existing-codebase-edits.md",
    "references/local-prototype-preflight.md",
    "references/product-design-host-capabilities.md",
    "references/wukong-product-design-composition.md",
    "scripts/bootstrap-prototype.mjs",
    "scripts/check-sites-starter-contract.mjs",
    "templates",
]
if lock.get("imported_roots") != expected_imported_roots:
    raise SystemExit("product-design.lock.json must use the exact imported source boundary")
PY

python3 - "$REPO_ROOT" <<'PY'
from pathlib import Path
import json
import sys

root = Path(sys.argv[1])
expected = "6.3.0"
config = json.loads((root / ".version-bump.json").read_text(encoding="utf-8"))

for entry in config["files"]:
    data = json.loads((root / entry["path"]).read_text(encoding="utf-8"))
    value = data
    for segment in entry["field"].split("."):
        value = value[int(segment)] if segment.isdigit() else value[segment]
    if value != expected:
        raise SystemExit(f"{entry['path']} version is {value!r}; expected {expected!r}")
PY

python3 - "$REPO_ROOT" <<'PY'
from pathlib import Path
import json
import sys

root = Path(sys.argv[1])
for relative in (
    ".codex-plugin/plugin.json",
    ".claude-plugin/plugin.json",
    ".cursor-plugin/plugin.json",
    ".kimi-plugin/plugin.json",
    "package.json",
):
    manifest = json.loads((root / relative).read_text(encoding="utf-8"))
    interface = manifest.get("interface", {})
    searchable = " ".join(
        [
            str(manifest.get("description", "")),
            " ".join(str(value) for value in manifest.get("keywords", [])),
            str(interface.get("shortDescription", "")),
            str(interface.get("longDescription", "")),
        ]
    ).casefold()
    if "product design" not in searchable and "product-design" not in searchable:
        raise SystemExit(f"{relative} does not advertise Product Design")
PY

grep -Fq "6.3.0" "$REPO_ROOT/README.md" ||
  fail "README does not identify the local Product Design fork version"

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

node "$REPO_ROOT/scripts/check-product-design-import.mjs" --root "$REPO_ROOT"

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

default_prompts = manifest.get("interface", {}).get("defaultPrompt", [])
if len(default_prompts) != 3:
    raise SystemExit(
        "root plugin manifest must declare exactly three default prompts; "
        "Codex ignores prompts beyond its supported limit"
    )

product_prompts = [
    prompt
    for prompt in default_prompts
    if "product" in prompt.casefold() and "design" in prompt.casefold()
]
if len(product_prompts) < 2:
    raise SystemExit("root plugin manifest needs at least two Product Design starter prompts")
PY

grep -Fq "When an auditable screenshot or URL is supplied, do not load" \
  "$REPO_ROOT/skills/product-design/SKILL.md" ||
  fail "Product Design router does not keep direct audits independent of saved context"
grep -Fq "When an auditable screenshot or URL is supplied, do not load" \
  "$REPO_ROOT/skills/product-design-audit/SKILL.md" ||
  fail "audit skill does not avoid unrelated saved-context preflight"
grep -Fq "When both the selected visual target and implementation target are supplied, do not load" \
  "$REPO_ROOT/skills/product-design-image-to-code/SKILL.md" ||
  fail "image-to-code does not avoid unrelated saved-context preflight"
for template in "$REPO_ROOT/templates/prototype/AGENTS.md" "$REPO_ROOT/templates/mobile-app/AGENTS.md"; do
  grep -Fq '`$product-design-context`' "$template" ||
    fail "${template#$REPO_ROOT/} does not name the namespaced Product Design context skill"
  if grep -Fq "Product Design plugin's \`get-context\` skill" "$template"; then
    fail "${template#$REPO_ROOT/} still points to the standalone generic get-context skill"
  fi
done

grep -Fq "Process selection is mandatory before focused Product Design routing." \
  "$REPO_ROOT/skills/product-design/SKILL.md" ||
  fail "Product Design router does not require Wukong process selection first"
grep -Fq 'New visual directions and URL clones: load `$brainstorming` first.' \
  "$REPO_ROOT/skills/product-design/SKILL.md" ||
  fail "Product Design router does not route new directions and clones through brainstorming"
grep -Fq 'A request to save Product Design context always loads `$product-design-user-context` before a build.' \
  "$REPO_ROOT/skills/product-design/SKILL.md" ||
  fail "Product Design router does not prioritize explicit context saves"
grep -Fq "Do not read saved context merely because it exists." \
  "$REPO_ROOT/references/critical-overrides.md" ||
  fail "critical overrides force unrelated saved-context reads"
grep -Fq "approved visual target or implementation specification" \
  "$REPO_ROOT/skills/using-wukong-code/SKILL.md" ||
  fail "Wukong scope routing does not recognize approved implementation targets"
grep -Fq '`test-driven-development` first, then the focused domain guidance' \
  "$REPO_ROOT/skills/using-wukong-code/SKILL.md" ||
  fail "Wukong scope routing does not send approved implementation targets to TDD"

grep -Fq "Product Design (local fork integration)" "$REPO_ROOT/README.md" ||
  fail "README is missing the Product Design local-fork section"
grep -Fq "product-design version 0.1.52" "$REPO_ROOT/README.md" ||
  fail "README is missing the imported Product Design source version"

echo "Product Design skill graph is complete."
