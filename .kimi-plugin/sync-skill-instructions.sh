#!/usr/bin/env bash
# Copy skills/using-wukong-code/references/kimi-tools.md into
# .kimi-plugin/plugin.json skillInstructions. Edit the markdown file, then run
# this script. Do not hand-edit the mapping string in plugin.json.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
MANIFEST="$REPO_ROOT/.kimi-plugin/plugin.json"
TOOLS="$REPO_ROOT/skills/using-wukong-code/references/kimi-tools.md"

python3 - "$MANIFEST" "$TOOLS" <<'PY'
import json
import sys
from pathlib import Path

manifest_path = Path(sys.argv[1])
tools_path = Path(sys.argv[2])
text = tools_path.read_text(encoding="utf-8")
if text.endswith("\n"):
    text = text[:-1]
manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
manifest["skillInstructions"] = text
manifest_path.write_text(
    json.dumps(manifest, indent=2, ensure_ascii=False) + "\n",
    encoding="utf-8",
)
print(f"updated {manifest_path} skillInstructions from {tools_path}")
PY
