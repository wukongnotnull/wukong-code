#!/usr/bin/env bash
# Delivery-layer contract: injectors append the Product Design composition
# pointer only when skills/product-design/SKILL.md exists. using-wukong-code
# Scope routing stays unchanged.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
HOOK="$REPO_ROOT/hooks/session-start"
SKILL="$REPO_ROOT/skills/using-wukong-code/SKILL.md"
POINTER="$REPO_ROOT/skills/using-wukong-code/references/product-design-composition-pointer.md"
OPENCODE_PLUGIN="$REPO_ROOT/.opencode/plugins/wukong-code.js"
PI_EXTENSION="$REPO_ROOT/.pi/extensions/wukong-code.ts"
KIMI_MANIFEST="$REPO_ROOT/.kimi-plugin/plugin.json"
KIMI_SYNC="$REPO_ROOT/.kimi-plugin/sync-skill-instructions.sh"
KIMI_TOOLS="$REPO_ROOT/skills/using-wukong-code/references/kimi-tools.md"

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

POINTER_TEXT="$(cat "$POINTER")"
POINTER_TEXT="${POINTER_TEXT%$'\n'}"

if [[ ${#POINTER_TEXT} -gt 280 ]]; then
  fail "pointer is longer than 280 characters (${#POINTER_TEXT})"
else
  pass "pointer stays short (${#POINTER_TEXT} characters)"
fi

if grep -q '|' "$POINTER"; then
  fail "pointer must not contain a markdown table"
else
  pass "pointer is not a second Scope table"
fi

for required in \
  "Process skills stay primary" \
  "Product Design is secondary" \
  "keep the process gates" \
  "wukong-product-design-composition.md"
do
  if [[ "$POINTER_TEXT" == *"$required"* ]]; then
    pass "pointer names $required"
  else
    fail "pointer is missing $required"
  fi
done

for forbidden in \
  "Let's build" \
  "Let's make" \
  "react todo" \
  "ordinary UI" \
  "invoke product-design" \
  "use product-design first" \
  "human partner"
do
  if grep -Fiq "$forbidden" "$POINTER"; then
    fail "pointer must not contain $forbidden"
  else
    pass "pointer omits $forbidden"
  fi
done

if grep -Eq 'product-design|Product Design' "$SKILL"; then
  fail "using-wukong-code SKILL.md must not grow a Product Design Scope table"
else
  pass "using-wukong-code SKILL.md still has no Product Design routing"
fi

if grep -Fq '"Let'\''s build X" → wukong-code:brainstorming first' "$SKILL"; then
  pass "Let's build X still routes to brainstorming"
else
  fail "using-wukong-code lost the brainstorming-first Let's build X route"
fi

if pointer_live="$(read_product_design_composition_pointer "$REPO_ROOT")"; then
  pointer_live="${pointer_live%$'\n'}"
  if [[ "$pointer_live" == "$POINTER_TEXT" ]]; then
    pass "session-start helper returns the pointer when Product Design exists"
  else
    fail "session-start helper returned unexpected pointer text"
  fi
else
  fail "session-start helper missed the pointer on the live tree"
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

assert_context_has_pointer() {
  local label="$1"
  local context="$2"
  if [[ "$context" != *"$POINTER_TEXT"* ]]; then
    fail "$label is missing the Product Design pointer"
    return
  fi
  local brainstorm_at pointer_at
  brainstorm_at="$(awk -v needle="Let's build X" 'index($0, needle){print NR; exit}' <<<"$context")"
  pointer_at="$(awk -v needle="$POINTER_TEXT" 'index($0, needle){print NR; exit}' <<<"$context")"
  if [[ -n "$brainstorm_at" && -n "$pointer_at" && "$pointer_at" -gt "$brainstorm_at" ]]; then
    pass "$label appends the pointer after brainstorming-first Scope routing"
  else
    fail "$label did not keep the pointer after using-wukong-code Scope routing"
  fi
}

live_home="$(mktemp -d)"
if live_context="$(session_start_context "$live_home" CLAUDE_PLUGIN_ROOT="$REPO_ROOT" bash "$HOOK")"; then
  assert_context_has_pointer "live SessionStart" "$live_context"
else
  fail "live SessionStart exited non-zero"
fi
rm -rf "$live_home"

make_session_fixture() {
  local tmp="$1"
  local with_pd="$2"
  mkdir -p "$tmp/home" "$tmp/skills/using-wukong-code/references" "$tmp/hooks"
  cp "$HOOK" "$tmp/hooks/session-start"
  chmod +x "$tmp/hooks/session-start"
  cp "$SKILL" "$tmp/skills/using-wukong-code/SKILL.md"
  cp "$POINTER" "$tmp/skills/using-wukong-code/references/product-design-composition-pointer.md"
  if [[ "$with_pd" == "1" ]]; then
    mkdir -p "$tmp/skills/product-design"
    printf '%s\n' "---" "name: product-design" "---" "fixture" > "$tmp/skills/product-design/SKILL.md"
  fi
}

absent_tmp="$(mktemp -d)"
make_session_fixture "$absent_tmp" 0
if ! read_product_design_composition_pointer "$absent_tmp"; then
  pass "session-start helper is empty when Product Design is absent"
else
  fail "session-start helper leaked a pointer without Product Design"
fi
if absent_context="$(session_start_context "$absent_tmp/home" CLAUDE_PLUGIN_ROOT="$absent_tmp" bash "$absent_tmp/hooks/session-start")"; then
  if [[ "$absent_context" == *"$POINTER_TEXT"* ]]; then
    fail "SessionStart fixture without Product Design still injected the pointer"
  else
    pass "SessionStart fixture without Product Design omits the pointer"
  fi
else
  fail "SessionStart fixture without Product Design exited non-zero"
fi
rm -rf "$absent_tmp"

present_tmp="$(mktemp -d)"
make_session_fixture "$present_tmp" 1
if present_context="$(session_start_context "$present_tmp/home" CLAUDE_PLUGIN_ROOT="$present_tmp" bash "$present_tmp/hooks/session-start")"; then
  if [[ "$present_context" == *"$POINTER_TEXT"* ]]; then
    pass "SessionStart fixture with Product Design injects the pointer"
  else
    fail "SessionStart fixture with Product Design missed the pointer"
  fi
else
  fail "SessionStart fixture with Product Design exited non-zero"
fi
rm -rf "$present_tmp"

node --experimental-strip-types --input-type=module - \
  "$REPO_ROOT" "$OPENCODE_PLUGIN" "$PI_EXTENSION" "$POINTER_TEXT" <<'JS'
import os from 'node:os';
import { mkdtempSync, mkdirSync, rmSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';

const [repoRoot, pluginPath, piPath, pointerText] = process.argv.slice(2);
const skillsDir = join(repoRoot, 'skills');

const opencodeMod = await import(pathToFileURL(pluginPath).href);
if (opencodeMod.productDesignCompositionPointer(skillsDir) !== pointerText) {
  throw new Error('OpenCode helper missed the live Product Design pointer');
}

const missingRoot = mkdtempSync(join(os.tmpdir(), 'wukong-pd-pointer-opencode-'));
mkdirSync(join(missingRoot, 'using-wukong-code', 'references'), { recursive: true });
writeFileSync(
  join(missingRoot, 'using-wukong-code', 'references', 'product-design-composition-pointer.md'),
  `${pointerText}\n`,
);
if (opencodeMod.productDesignCompositionPointer(missingRoot) !== '') {
  throw new Error('OpenCode helper leaked a pointer without Product Design');
}

const plugin = await opencodeMod.WukongCodePlugin({ client: {}, directory: '.' });
const transform = plugin['experimental.chat.messages.transform'];
const output = {
  messages: [{
    info: { role: 'user' },
    parts: [{ type: 'text', text: "Let's make a react todo list" }],
  }],
};
await transform({}, output);
const bootstrap = output.messages[0].parts.find(
  (part) => part.type === 'text' && part.text.includes('EXTREMELY_IMPORTANT')
)?.text || '';
if (!bootstrap.includes(pointerText)) {
  throw new Error('OpenCode injected bootstrap is missing the Product Design pointer');
}
if (!bootstrap.includes("Let's build X")) {
  throw new Error('OpenCode injected bootstrap lost the brainstorming-first Scope line');
}
if (bootstrap.indexOf(pointerText) < bootstrap.indexOf("Let's build X")) {
  throw new Error('OpenCode pointer is not after using-wukong-code Scope routing');
}

const piMod = await import(pathToFileURL(piPath).href + `?pointer=${Date.now()}`);
if (piMod.productDesignCompositionPointer(skillsDir) !== pointerText) {
  throw new Error('Pi helper missed the live Product Design pointer');
}
if (piMod.productDesignCompositionPointer(missingRoot) !== '') {
  throw new Error('Pi helper leaked a pointer without Product Design');
}
rmSync(missingRoot, { recursive: true, force: true });

const handlers = new Map();
piMod.default({
  on(event, handler) {
    handlers.set(event, handler);
  },
});
await handlers.get('session_start')({ type: 'session_start' }, {});
const piResult = await handlers.get('context')({
  type: 'context',
  messages: [{
    role: 'user',
    content: [{ type: 'text', text: "Let's make a react todo list" }],
    timestamp: 1,
  }],
}, {});
const piText = piResult.messages[0].content[0].text;
if (!piText.includes(pointerText)) {
  throw new Error('Pi injected bootstrap is missing the Product Design pointer');
}
if (!piText.includes("Let's build X")) {
  throw new Error('Pi injected bootstrap lost the brainstorming-first Scope line');
}
if (piText.indexOf(pointerText) < piText.indexOf("Let's build X")) {
  throw new Error('Pi pointer is not after using-wukong-code Scope routing');
}

console.log('injectors-pointer');
JS
pass "OpenCode live bootstrap appends the pointer after Scope routing"
pass "OpenCode helper is empty when Product Design is absent"
pass "Pi live bootstrap appends the pointer after Scope routing"
pass "Pi helper is empty when Product Design is absent"

kimi_tools="$(cat "$KIMI_TOOLS")"
kimi_tools="${kimi_tools%$'\n'}"
kimi_expected="${kimi_tools}"$'\n\n'"${POINTER_TEXT}"
kimi_live="$(python3 - "$KIMI_MANIFEST" <<'PY'
import json
import sys
from pathlib import Path

print(json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))["skillInstructions"], end="")
PY
)"
if [[ "$kimi_live" == "$kimi_expected" ]]; then
  pass "Kimi skillInstructions is mapping plus the pointer"
else
  fail "Kimi skillInstructions is not mapping plus the pointer"
fi

kimi_fixture="$(mktemp -d)"
mkdir -p "$kimi_fixture/.kimi-plugin" \
  "$kimi_fixture/skills/using-wukong-code/references"
cp "$KIMI_SYNC" "$kimi_fixture/.kimi-plugin/sync-skill-instructions.sh"
chmod +x "$kimi_fixture/.kimi-plugin/sync-skill-instructions.sh"
cp "$KIMI_MANIFEST" "$kimi_fixture/.kimi-plugin/plugin.json"
cp "$KIMI_TOOLS" "$kimi_fixture/skills/using-wukong-code/references/kimi-tools.md"
cp "$POINTER" "$kimi_fixture/skills/using-wukong-code/references/product-design-composition-pointer.md"
if ! bash "$kimi_fixture/.kimi-plugin/sync-skill-instructions.sh"; then
  fail "Kimi sync exited non-zero without Product Design"
else
  kimi_absent="$(python3 - "$kimi_fixture/.kimi-plugin/plugin.json" <<'PY'
import json
import sys
from pathlib import Path

print(json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))["skillInstructions"], end="")
PY
)"
  if [[ "$kimi_absent" == "$kimi_tools" ]]; then
    pass "Kimi sync omits the pointer when Product Design is absent"
  else
    fail "Kimi sync leaked a pointer without Product Design"
  fi
fi

mkdir -p "$kimi_fixture/skills/product-design"
printf '%s\n' "---" "name: product-design" "---" "fixture" > "$kimi_fixture/skills/product-design/SKILL.md"
if ! bash "$kimi_fixture/.kimi-plugin/sync-skill-instructions.sh"; then
  fail "Kimi sync exited non-zero with Product Design"
else
  kimi_present="$(python3 - "$kimi_fixture/.kimi-plugin/plugin.json" <<'PY'
import json
import sys
from pathlib import Path

print(json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))["skillInstructions"], end="")
PY
)"
  if [[ "$kimi_present" == "$kimi_expected" ]]; then
    pass "Kimi sync appends the pointer when Product Design exists"
  else
    fail "Kimi sync missed the pointer when Product Design exists"
  fi
fi
rm -rf "$kimi_fixture"

if [[ "$FAILURES" -gt 0 ]]; then
  echo "STATUS: FAILED ($FAILURES failure(s))"
  exit 1
fi

echo "STATUS: PASSED"
