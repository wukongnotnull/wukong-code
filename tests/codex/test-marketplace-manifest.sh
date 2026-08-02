#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
MARKETPLACE="$REPO_ROOT/.agents/plugins/marketplace.json"

python3 - "$MARKETPLACE" "$REPO_ROOT" <<'PY'
import json
import sys
from pathlib import Path

marketplace_path = Path(sys.argv[1])
repo_root = Path(sys.argv[2])

if not marketplace_path.exists():
    raise AssertionError(".agents/plugins/marketplace.json must exist")

marketplace = json.loads(marketplace_path.read_text(encoding="utf-8"))

def assert_equal(actual, expected, label):
    if actual != expected:
        raise AssertionError(f"{label}: expected {expected!r}, got {actual!r}")

assert_equal(marketplace.get("name"), "wukong-code-dev", "marketplace name")
assert_equal(
    marketplace.get("interface", {}).get("displayName"),
    "Wukong Code Dev",
    "marketplace display name",
)

plugins = marketplace.get("plugins")
if not isinstance(plugins, list):
    raise AssertionError("plugins must be a list")

matching_plugins = [plugin for plugin in plugins if plugin.get("name") == "wukong-code"]
assert_equal(len(matching_plugins), 1, "wukong-code plugin entry count")

plugin = matching_plugins[0]
assert_equal(plugin.get("source"), {"source": "url", "url": "./"}, "plugin source")
assert_equal(
    plugin.get("policy"),
    {"installation": "AVAILABLE", "authentication": "ON_INSTALL"},
    "plugin policy",
)
assert_equal(plugin.get("category"), "Developer Tools", "plugin category")

plugin_manifest = repo_root / ".codex-plugin" / "plugin.json"
if not plugin_manifest.exists():
    raise AssertionError(".codex-plugin/plugin.json must exist")

manifest = json.loads(plugin_manifest.read_text(encoding="utf-8"))
assert_equal(manifest.get("name"), plugin.get("name"), "plugin manifest name")

# Codex plugin hooks need their own configuration: the shared hooks/hooks.json
# uses Claude Code's startup matcher and environment contract. The explicit
# manifest path prevents accidental fallback to that cross-harness file.
codex_hooks_config = repo_root / "hooks" / "hooks-codex.json"
if not codex_hooks_config.exists():
    raise AssertionError("hooks/hooks-codex.json must exist (Codex SessionStart hook)")

assert_equal(
    manifest.get("hooks"),
    "./hooks/hooks-codex.json",
    "Codex manifest must point to its SessionStart hook configuration",
)

codex_hooks = json.loads(codex_hooks_config.read_text(encoding="utf-8"))
session_start = codex_hooks.get("hooks", {}).get("SessionStart")
if not isinstance(session_start, list) or len(session_start) != 1:
    raise AssertionError("Codex hooks must define exactly one SessionStart handler")

handler = session_start[0]
assert_equal(
    handler.get("matcher"),
    "startup|resume|clear|compact",
    "Codex SessionStart matcher",
)
commands = handler.get("hooks")
if not isinstance(commands, list) or len(commands) != 1:
    raise AssertionError("Codex SessionStart must define exactly one command hook")
command = commands[0]
assert_equal(command.get("type"), "command", "Codex SessionStart hook type")
assert_equal(
    command.get("command"),
    '"${PLUGIN_ROOT}/hooks/run-hook.cmd" session-start',
    "Codex SessionStart command uses PLUGIN_ROOT",
)

user_prompt_submit = codex_hooks.get("hooks", {}).get("UserPromptSubmit")
if not isinstance(user_prompt_submit, list) or len(user_prompt_submit) != 1:
    raise AssertionError("Codex hooks must define exactly one UserPromptSubmit handler")

prompt_handler = user_prompt_submit[0]
if "matcher" in prompt_handler:
    raise AssertionError("Codex UserPromptSubmit handler must not declare a matcher")
prompt_commands = prompt_handler.get("hooks")
if not isinstance(prompt_commands, list) or len(prompt_commands) != 1:
    raise AssertionError("Codex UserPromptSubmit must define exactly one command hook")
prompt_command = prompt_commands[0]
assert_equal(prompt_command.get("type"), "command", "Codex UserPromptSubmit hook type")
assert_equal(
    prompt_command.get("command"),
    '"${PLUGIN_ROOT}/hooks/run-hook.cmd" user-prompt-submit',
    "Codex UserPromptSubmit command uses PLUGIN_ROOT",
)

print("Codex marketplace manifest looks good")
PY
