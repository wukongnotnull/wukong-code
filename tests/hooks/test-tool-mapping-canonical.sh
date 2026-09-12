#!/usr/bin/env bash
# Contract: each harness mapping has one source of truth —
# skills/using-wukong-code/references/<harness>-tools.md — and injectors wrap
# that file instead of keeping a handwritten table.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
HOOK="$REPO_ROOT/hooks/session-start"
SKILL="$REPO_ROOT/skills/using-wukong-code/SKILL.md"
REFERENCES="$REPO_ROOT/skills/using-wukong-code/references"
OPENCODE_PLUGIN="$REPO_ROOT/.opencode/plugins/wukong-code.js"
PI_EXTENSION="$REPO_ROOT/.pi/extensions/wukong-code.ts"
KIMI_MANIFEST="$REPO_ROOT/.kimi-plugin/plugin.json"

FAILURES=0

pass() {
  echo "  [PASS] $1"
}

fail() {
  echo "  [FAIL] $1" >&2
  FAILURES=$((FAILURES + 1))
}

# shellcheck source=../../hooks/session-start
WUKONG_SESSION_START_LIB_ONLY=1 source "$HOOK"

echo "=== Canonical harness tool mappings ==="

# Every on-disk mapping must have a contract: injector equality, skillInstructions
# equality, or pointer-only (SessionStart cannot detect the harness).
mapping_contract() {
  case "$1" in
    opencode) printf '%s' inject_opencode ;;
    pi) printf '%s' inject_pi ;;
    kimi) printf '%s' skill_instructions ;;
    codex|antigravity) printf '%s' pointer_only ;;
    cursor|claude|copilot) printf '%s' shape_a_session_start ;;
    *) printf '%s' unknown ;;
  esac
}

shopt -s nullglob
found_mappings=0
for expected in "$REFERENCES"/*-tools.md; do
  found_mappings=$((found_mappings + 1))
  harness="$(basename "$expected")"
  harness="${harness%-tools.md}"
  contract="$(mapping_contract "$harness")"
  if [[ "$contract" == unknown ]]; then
    fail "unclassified mapping ${harness}-tools.md — add an injector / skillInstructions assertion"
    continue
  fi
  pass "${harness}-tools.md has contract ${contract}"
  if ! got="$(read_harness_tools "$REPO_ROOT" "$harness")"; then
    fail "bash read_harness_tools could not read $harness"
    continue
  fi
  if [[ "$got" == "$(cat "$expected")" ]]; then
    pass "bash read_harness_tools $harness equals ${harness}-tools.md"
  else
    fail "bash read_harness_tools $harness does not equal the reference file"
  fi
done
shopt -u nullglob

if [[ "$found_mappings" -eq 0 ]]; then
  fail "no references/*-tools.md files found"
fi

for required in pi opencode kimi codex antigravity; do
  if [[ -f "$REFERENCES/${required}-tools.md" ]]; then
    pass "required mapping ${required}-tools.md exists"
  else
    fail "missing required mapping ${required}-tools.md"
  fi
done

for gone in claude-code-tools.md copilot-tools.md; do
  if [[ -e "$REFERENCES/$gone" ]]; then
    fail "deleted mapping $gone must not return"
  else
    pass "$gone stays deleted (no dedicated Claude/Copilot mapping file)"
  fi
done

skill_raw="$(cat "$SKILL")"
export WUKONG_BASH_STRIPPED_BODY
WUKONG_BASH_STRIPPED_BODY="$(strip_yaml_frontmatter "$skill_raw")"

python3 - "$KIMI_MANIFEST" "$REFERENCES/kimi-tools.md" <<'PY'
import json
import sys
from pathlib import Path

manifest = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
tools = Path(sys.argv[2]).read_text(encoding="utf-8")
if tools.endswith("\n"):
    tools = tools[:-1]
instructions = manifest.get("skillInstructions")
if instructions != tools:
    raise SystemExit("skillInstructions does not equal references/kimi-tools.md")
print("kimi-equal")
PY
pass "Kimi skillInstructions equals references/kimi-tools.md"

node --experimental-strip-types --input-type=module - "$REPO_ROOT" "$OPENCODE_PLUGIN" "$PI_EXTENSION" "$SKILL" <<'JS'
import fs from 'node:fs';
import { pathToFileURL } from 'node:url';
import { resolve } from 'node:path';

const [repoRoot, pluginPath, piPath, skillPath] = process.argv.slice(2);

const opencodeMod = await import(pathToFileURL(pluginPath).href);
const plugin = await opencodeMod.WukongCodePlugin({ client: {}, directory: '.' });
const transform = plugin['experimental.chat.messages.transform'];
const output = {
  messages: [{
    info: { role: 'user' },
    parts: [{ type: 'text', text: 'canonical mapping probe' }],
  }],
};
await transform({}, output);
const bootstrap = output.messages[0].parts.find(
  (part) => part.type === 'text' && part.text.includes('EXTREMELY_IMPORTANT')
)?.text || '';
const opencodeTools = fs.readFileSync(
  resolve(repoRoot, 'skills/using-wukong-code/references/opencode-tools.md'),
  'utf8'
).replace(/\s+$/, '');
if (!bootstrap.includes(opencodeTools)) {
  throw new Error('OpenCode injected bootstrap does not contain opencode-tools.md verbatim');
}

const piMod = await import(pathToFileURL(piPath).href + `?canonical=${Date.now()}`);
const handlers = new Map();
piMod.default({
  on(event, handler) {
    handlers.set(event, handler);
  },
});
await handlers.get('session_start')({ type: 'session_start' }, {});
const piResult = await handlers.get('context')({
  type: 'context',
  messages: [{ role: 'user', content: [{ type: 'text', text: 'canonical mapping probe' }], timestamp: 1 }],
}, {});
const piText = piResult.messages[0].content[0].text;
const piTools = fs.readFileSync(
  resolve(repoRoot, 'skills/using-wukong-code/references/pi-tools.md'),
  'utf8'
).replace(/\s+$/, '');
if (!piText.includes(piTools)) {
  throw new Error('Pi injected bootstrap does not contain pi-tools.md verbatim');
}

const skill = fs.readFileSync(skillPath, 'utf8');
const bashBody = process.env.WUKONG_BASH_STRIPPED_BODY;
const jsBody = opencodeMod.stripYamlFrontmatter(skill).trim();
const tsBody = piMod.stripFrontmatter(skill).trim();
if (jsBody !== tsBody) {
  throw new Error('OpenCode and Pi frontmatter strippers disagree on SKILL.md');
}
if (bashBody.trim() !== jsBody) {
  throw new Error('bash frontmatter strip does not match OpenCode/Pi on SKILL.md');
}

console.log('injectors-equal');
JS
pass "OpenCode injected mapping equals references/opencode-tools.md"
pass "Pi injected mapping equals references/pi-tools.md"
pass "bash / OpenCode / Pi frontmatter strippers agree on SKILL.md"

for pointer in opencode-tools.md kimi-tools.md pi-tools.md antigravity-tools.md codex-tools.md; do
  if grep -Fq "$pointer" "$SKILL"; then
    pass "Platform Adaptation points at $pointer"
  else
    fail "SKILL.md Platform Adaptation missing $pointer"
  fi
done

if grep -Fq 'opencode-tools.md' "$OPENCODE_PLUGIN" && ! grep -Fq 'Tool Mapping for OpenCode' "$OPENCODE_PLUGIN"; then
  pass "OpenCode injector reads the reference file and has no handwritten table"
else
  fail "OpenCode injector still has a handwritten mapping table"
fi

if grep -Fq 'pi-tools.md' "$PI_EXTENSION" && ! grep -Fq 'function piToolMapping' "$PI_EXTENSION"; then
  pass "Pi injector reads the reference file and has no handwritten table"
else
  fail "Pi injector still has a handwritten mapping table"
fi

if grep -Fq 'read_harness_tools' "$HOOK" && ! grep -Fq 'todowrite' "$HOOK"; then
  pass "session-start reads harness tool files and has no handwritten table"
else
  fail "session-start is missing read_harness_tools or still embeds a mapping table"
fi

session_start_context() {
  local home="$1"
  shift
  local output
  if ! output="$(env -i PATH="${PATH:-}" HOME="$home" "$@" 2>&1)"; then
    printf '%s' ""
    return 1
  fi
  printf '%s' "$output" | node -e '
const fs = require("fs");
const payload = JSON.parse(fs.readFileSync(0, "utf8"));
const context = payload.additional_context
  || payload.additionalContext
  || (payload.hookSpecificOutput && payload.hookSpecificOutput.additionalContext)
  || "";
process.stdout.write(context);
'
}

# Shape A injects references/<detected>-tools.md when that file exists.
# Detected names are cursor / claude / copilot; those files are absent today.
# The hook derives PLUGIN_ROOT from its own path (the temp tree). The env vars
# below only select the JSON branch / detect_session_harness name.
assert_shape_a_injects_mapping() {
  local harness="$1"
  shift
  local token="CANONICAL_${harness}_MAPPING_$$"
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/home" "$tmp/skills/using-wukong-code/references" "$tmp/hooks"
  cp "$HOOK" "$tmp/hooks/session-start"
  chmod +x "$tmp/hooks/session-start"
  cp "$SKILL" "$tmp/skills/using-wukong-code/SKILL.md"
  printf '%s\n' "$token" > "$tmp/skills/using-wukong-code/references/${harness}-tools.md"

  local context
  if ! context="$(session_start_context "$tmp/home" "$@" bash "$tmp/hooks/session-start")"; then
    fail "Shape A $harness SessionStart exited non-zero when ${harness}-tools.md exists"
    rm -rf "$tmp"
    return
  fi
  if [[ "$context" == *"$token"* ]]; then
    pass "Shape A $harness SessionStart injects ${harness}-tools.md"
  else
    fail "Shape A $harness SessionStart did not inject ${harness}-tools.md"
  fi
  rm -rf "$tmp"
}

echo "=== Shape A SessionStart mapping injection ==="

assert_shape_a_injects_mapping \
  claude \
  CLAUDE_PLUGIN_ROOT=/tmp/wukong-canonical-claude

assert_shape_a_injects_mapping \
  cursor \
  CURSOR_PLUGIN_ROOT=/tmp/wukong-canonical-cursor \
  CLAUDE_PLUGIN_ROOT=/tmp/wukong-canonical-claude

assert_shape_a_injects_mapping \
  copilot \
  COPILOT_CLI=1 \
  CLAUDE_PLUGIN_ROOT=/tmp/wukong-canonical-claude

echo "=== Live SessionStart must not inline another harness mapping ==="

live_home="$(mktemp -d)"

assert_live_session_omits_other_mappings() {
  local label="$1"
  shift
  local context
  if ! context="$(session_start_context "$live_home" "$@" bash "$HOOK")"; then
    fail "$label SessionStart exited non-zero"
    return
  fi
  local needle
  local failed=0
  while IFS= read -r needle; do
    [[ -n "$needle" ]] || continue
    if [[ "$context" == *"$needle"* ]]; then
      fail "$label SessionStart inlined another harness mapping ($needle)"
      failed=1
    fi
  done <<EOF
Tool Mapping for OpenCode
Kimi Code tool mapping
pi-subagents
spawn_agent
IsSkillFile
EOF
  if [[ "$failed" -eq 0 ]]; then
    pass "$label SessionStart does not inline OpenCode/Pi/Kimi/Codex/Antigravity mappings"
  fi
}

assert_live_session_omits_other_mappings \
  "Claude" \
  CLAUDE_PLUGIN_ROOT="$REPO_ROOT"
assert_live_session_omits_other_mappings \
  "Cursor" \
  CURSOR_PLUGIN_ROOT="$REPO_ROOT" \
  CLAUDE_PLUGIN_ROOT="$REPO_ROOT"
assert_live_session_omits_other_mappings \
  "Copilot" \
  COPILOT_CLI=1 \
  CLAUDE_PLUGIN_ROOT="$REPO_ROOT"
assert_live_session_omits_other_mappings \
  "Codex-shaped" \
  PLUGIN_ROOT="$REPO_ROOT" \
  CLAUDE_PLUGIN_ROOT="$REPO_ROOT"

rm -rf "$live_home"

if [[ "$FAILURES" -gt 0 ]]; then
  echo "STATUS: FAILED ($FAILURES failure(s))"
  exit 1
fi

echo "STATUS: PASSED"
