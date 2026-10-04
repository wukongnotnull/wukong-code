#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
MANIFEST="$REPO_ROOT/.kimi-plugin/plugin.json"

python3 - "$MANIFEST" <<'PY'
import json
import sys
from pathlib import Path

manifest_path = Path(sys.argv[1])
manifest = json.loads(manifest_path.read_text(encoding="utf-8"))

def assert_equal(actual, expected, label):
    if actual != expected:
        raise AssertionError(f"{label}: expected {expected!r}, got {actual!r}")

def assert_present(text, needle, label):
    if needle not in text:
        raise AssertionError(f"{label}: missing {needle!r}")

assert_equal(manifest.get("name"), "wukong-code", "plugin name")
assert_equal(manifest.get("skills"), "./skills/", "skills path")
assert_equal(
    manifest.get("sessionStart", {}).get("skill"),
    "using-wukong-code",
    "sessionStart.skill",
)

instructions = manifest.get("skillInstructions")
if not isinstance(instructions, str) or not instructions.strip():
    raise AssertionError("skillInstructions must be a non-empty string")

repo = manifest_path.parents[1]
tools_path = repo / "skills/using-wukong-code/references/kimi-tools.md"
pointer_path = repo / "skills/using-wukong-code/references/product-design-composition-pointer.md"
pd_skill = repo / "skills/product-design/SKILL.md"
tools = tools_path.read_text(encoding="utf-8")
if tools.endswith("\n"):
    tools = tools[:-1]
expected = tools
if pd_skill.is_file() and pointer_path.is_file():
    pointer = pointer_path.read_text(encoding="utf-8")
    if pointer.endswith("\n"):
        pointer = pointer[:-1]
    expected = f"{tools}\n\n{pointer}"
if instructions != expected:
    raise AssertionError(
        "skillInstructions must equal skills/using-wukong-code/references/kimi-tools.md "
        "plus the Product Design pointer when that skill exists "
        "(run .kimi-plugin/sync-skill-instructions.sh after editing the reference files)"
    )
if not instructions.startswith(tools):
    raise AssertionError("skillInstructions lost the kimi-tools.md prefix")

for token in [
    "AskUserQuestion",
    "TodoList",
    "Agent",
    "Skill",
    "Read",
    "Write",
    "Edit",
    "Bash",
    "Grep",
    "Glob",
    "FetchURL",
    "WebSearch",
]:
    assert_present(instructions, token, "skillInstructions")

version_config = json.loads(
    (manifest_path.parents[1] / ".version-bump.json").read_text(encoding="utf-8")
)
version_entries = version_config.get("files")
if not isinstance(version_entries, list):
    raise AssertionError(".version-bump.json must contain files list")

if not any(
    entry.get("path") == ".kimi-plugin/plugin.json" and entry.get("field") == "version"
    for entry in version_entries
    if isinstance(entry, dict)
):
    raise AssertionError(
        ".version-bump.json must update .kimi-plugin/plugin.json version"
    )

unsupported_fields = [
    "tools",
    "commands",
    "hooks",
    "apps",
    "inject",
    "configFile",
    "config_file",
    "bootstrap",
]
present_unsupported = sorted(field for field in unsupported_fields if field in manifest)
if present_unsupported:
    raise AssertionError(
        "unsupported Kimi runtime fields present: "
        + ", ".join(present_unsupported)
    )

print("Kimi plugin manifest looks good")
PY
