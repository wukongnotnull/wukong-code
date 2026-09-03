#!/usr/bin/env bash
# Validate the Cursor plugin integration. Cursor loads bundled skills and runs
# the SessionStart hook for bootstrap via hooks/hooks-cursor.json. CI-safe: does
# not require the Cursor IDE or agent CLI installed.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

MANIFEST="$REPO_ROOT/.cursor-plugin/plugin.json"
HOOKS="$REPO_ROOT/hooks/hooks-cursor.json"
RUN_HOOK="$REPO_ROOT/hooks/run-hook.cmd"
SESSION_START="$REPO_ROOT/hooks/session-start"

fail() { echo "FAIL: $*" >&2; exit 1; }

echo "test-cursor-plugin: checking Cursor plugin wiring"

[ -f "$MANIFEST" ] || fail "manifest missing at $MANIFEST"
[ -f "$HOOKS" ] || fail "hooks config missing at $HOOKS"
[ -f "$RUN_HOOK" ] || fail "run-hook.cmd missing at $RUN_HOOK"
[ -x "$SESSION_START" ] || fail "session-start hook is missing or not executable"

python3 - "$MANIFEST" "$HOOKS" <<'PY'
import json
import sys
from pathlib import Path

manifest_path = Path(sys.argv[1])
hooks_path = Path(sys.argv[2])

manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
hooks = json.loads(hooks_path.read_text(encoding="utf-8"))

def assert_equal(actual, expected, label):
    if actual != expected:
        raise AssertionError(f"{label}: expected {expected!r}, got {actual!r}")

def assert_present(text, needle, label):
    if needle not in text:
        raise AssertionError(f"{label}: missing {needle!r}")

assert_equal(manifest.get("name"), "wukong-code", "plugin name")
assert_equal(manifest.get("skills"), "./skills/", "skills path")
assert_equal(manifest.get("hooks"), "./hooks/hooks-cursor.json", "hooks path")
assert_present(str(manifest.get("version", "")), ".", "plugin version")

session_start = hooks.get("hooks", {}).get("sessionStart", [])
if not session_start:
    raise AssertionError("hooks-cursor.json missing sessionStart hook")
command = session_start[0].get("command", "")
assert_present(command, "session-start", "sessionStart command")

print("PASS: Cursor plugin manifest and sessionStart hook wiring valid")
PY
