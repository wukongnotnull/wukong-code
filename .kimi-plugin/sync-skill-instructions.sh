#!/usr/bin/env bash
# Copy skills/using-wukong-code/references/kimi-tools.md into
# .kimi-plugin/plugin.json skillInstructions. When
# skills/product-design/SKILL.md exists, append the composition pointer after
# the mapping. Edit the markdown files, then run this script. Do not
# hand-edit the mapping string in plugin.json.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
MANIFEST="$REPO_ROOT/.kimi-plugin/plugin.json"
TOOLS="$REPO_ROOT/skills/using-wukong-code/references/kimi-tools.md"
POINTER="$REPO_ROOT/skills/using-wukong-code/references/product-design-composition-pointer.md"
PD_SKILL="$REPO_ROOT/skills/product-design/SKILL.md"

python3 - "$MANIFEST" "$TOOLS" "$POINTER" "$PD_SKILL" <<'PY'
import json
import sys
from pathlib import Path

manifest_path = Path(sys.argv[1])
tools_path = Path(sys.argv[2])
pointer_path = Path(sys.argv[3])
pd_skill_path = Path(sys.argv[4])
text = tools_path.read_text(encoding="utf-8")
if text.endswith("\n"):
    text = text[:-1]
if pd_skill_path.is_file() and pointer_path.is_file():
    pointer = pointer_path.read_text(encoding="utf-8")
    if pointer.endswith("\n"):
        pointer = pointer[:-1]
    text = f"{text}\n\n{pointer}"
manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
manifest["skillInstructions"] = text
manifest_path.write_text(
    json.dumps(manifest, indent=2, ensure_ascii=False) + "\n",
    encoding="utf-8",
)
print(f"updated {manifest_path} skillInstructions from {tools_path}")
PY
