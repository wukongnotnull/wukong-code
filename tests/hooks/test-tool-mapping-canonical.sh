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

for harness in pi opencode kimi codex antigravity; do
  expected="$REFERENCES/${harness}-tools.md"
  if [[ ! -f "$expected" ]]; then
    fail "missing $expected"
    continue
  fi
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

if [[ "$FAILURES" -gt 0 ]]; then
  echo "STATUS: FAILED ($FAILURES failure(s))"
  exit 1
fi

echo "STATUS: PASSED"
