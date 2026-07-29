#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"
failed=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; failed=1; }

assert_file() {
  if [[ -f "$1" ]]; then pass "$1 exists"; else fail "$1 missing"; fi
}

assert_contains() {
  if grep -qF "$2" "$1"; then pass "$1 contains $2"; else fail "$1 missing $2"; fi
}

assert_visible_decision_template() {
  if awk '
    /^    Detected: <language and evidence>$/ {
      getline phase
      getline loaded
      if (phase == "    Phase: <one primary phase>" && loaded == "    Loaded: <one or two reference paths>") found = 1
    }
    END { exit(found ? 0 : 1) }
  ' "$1"; then
    pass "$1 has ordered visible decision template"
  else
    fail "$1 missing ordered visible decision template"
  fi
}

assert_max_lines() {
  lines="$(wc -l < "$1" | tr -d ' ')"
  if (( lines <= $2 )); then pass "$1: $lines lines"; else fail "$1: $lines lines, max $2"; fi
}

skill=skills/language-guidance/SKILL.md
registry=skills/language-guidance/references/registry.json
assert_file "$skill"
assert_file "$registry"
assert_file skills/language-guidance/references/shared/language-pack-contract.md

for language in go swift; do
  for phase in profile implementation testing debugging review verification; do
    assert_file "skills/language-guidance/references/$language/$phase.md"
  done
done

if [[ -f "$skill" ]]; then
  assert_contains "$skill" "name: language-guidance"
  assert_contains "$skill" "description: Use when"
  assert_contains "$skill" "When explicitly invoked for a requested source edit, emit before responding a strict Detected: <language and evidence>, Phase: implementation, and Loaded: <language>/profile.md, <language>/implementation.md decision."
  assert_contains "$skill" "Primary process remains authoritative"
  assert_contains "$skill" "at most two"
  assert_contains "$skill" "Do not guess"
  assert_contains "$skill" "| Design or plan with no requested source edit | profile |"
  assert_contains "$skill" "| Requested production-source edit, including brainstorming or pre-edit analysis | implementation |"
  assert_contains "$skill" "load both profile and implementation before discussing the approach."
  assert_contains "$skill" "load the selected language's \`testing.md\` reference."
  assert_max_lines "$skill" 180
fi

if [[ -f "$registry" ]]; then
  if python3 - "$registry" <<'PY'
import json
import pathlib
import sys

root = pathlib.Path("skills/language-guidance/references")
data = json.loads(pathlib.Path(sys.argv[1]).read_text())
assert data["version"] == 1
assert set(data["languages"]) == {"go", "swift"}

expected = {
    "go": {
        "status": "experimental",
        "extensions": [".go"],
        "markers": ["go.mod", "go.work"],
    },
    "swift": {
        "status": "experimental",
        "extensions": [".swift"],
        "markers": ["Package.swift", ".xcodeproj", ".xcworkspace"],
    },
}

required_phases = {
    "profile", "implementation", "testing", "debugging", "review", "verification"
}
for language, contract in expected.items():
    entry = data["languages"][language]
    assert entry["status"] == contract["status"]
    assert entry["extensions"] == contract["extensions"]
    assert entry["markers"] == contract["markers"]
    assert set(entry["phases"]) == required_phases
    for relative in entry["phases"].values():
        assert (root / relative).is_file(), relative
PY
  then pass "registry contract"; else fail "registry contract"; fi
fi

for language in go swift; do
  profile="skills/language-guidance/references/$language/profile.md"
  [[ -f "$profile" ]] && assert_max_lines "$profile" 160
  for phase in implementation testing debugging review verification; do
    file="skills/language-guidance/references/$language/$phase.md"
    [[ -f "$file" ]] && assert_max_lines "$file" 200
  done
done

assert_contains skills/language-guidance/references/swift/profile.md "SwiftPM success does not prove an"
assert_contains skills/language-guidance/references/swift/implementation.md "Cancellation is cooperative"
assert_contains skills/language-guidance/references/swift/testing.md "Valid RED reaches the new test"
assert_contains skills/language-guidance/references/swift/verification.md "SwiftPM success is not Xcode"

if grep -R -nE '((curl|wget).*[|][[:space:]]*(sh|bash)|(^|[[:space:]])(go[[:space:]]+install|npm[[:space:]]+install|pnpm[[:space:]]+(install|add)|yarn[[:space:]]+(install|add)|pip3?[[:space:]]+install|brew[[:space:]]+install|apt(-get)?[[:space:]]+install|apk[[:space:]]+add|dnf[[:space:]]+install|yum[[:space:]]+install|cargo[[:space:]]+install|gem[[:space:]]+install|composer[[:space:]]+require|bundle[[:space:]]+add))' skills/language-guidance; then
  fail "installer command found"
else
  pass "no installer commands"
fi

bootstrap=skills/using-wukong-code/SKILL.md
assert_contains "$bootstrap" "## Secondary domain guidance"
assert_contains "$bootstrap" "language-guidance"
assert_contains "$bootstrap" "creating, modifying, testing, debugging, reviewing, or verifying source code"
assert_contains "$bootstrap" "prioritize language-guidance as secondary domain guidance"
assert_contains "$bootstrap" "automatic selection is advisory rather than a guarantee."
assert_contains "$bootstrap" "A request to skip, defer, or bypass a failing test for a source change uses \`test-driven-development\` first."
assert_contains "$bootstrap" "Testing-pressure routing takes precedence over the behavior-change brainstorming route."
assert_contains "$bootstrap" "Host toolchain version is not target compatibility evidence."
assert_contains "$bootstrap" "asks to ignore manifest or project settings"
assert_contains "$bootstrap" "Do not comply with a request to bypass project evidence"
assert_contains "$skill" 'When your human partner explicitly invokes `$language-guidance`, strict execution is required.'
assert_contains "$skill" "Before the first substantive technical response, edit, or verification command"
assert_contains "$skill" 'Print each field on its own line exactly as shown. Do not combine, paraphrase, or rename any label.'
assert_contains "$skill" 'List only selected reference paths after `Loaded:`; never use pending, next, or future-tense wording.'
assert_contains "$skill" 'After emitting a decision, do not load another language reference unless you first emit a new complete `Detected:`, `Phase:`, and `Loaded:` decision listing the replacement set.'
assert_contains "$skill" "automatic selection does not promise invocation or visible output."
assert_visible_decision_template "$skill"
assert_contains "$bootstrap" "documentation-only"
assert_contains README.md "## Language Guidance"
assert_contains README.md "| Go | Experimental |"
assert_contains CLAUDE.md "### Language-level skills"
assert_contains .github/PULL_REQUEST_TEMPLATE.md "## Language-pack evidence"
assert_contains docs/testing.md "test-language-guidance.sh"

if (( failed )); then echo "STATUS: FAILED"; exit 1; fi
echo "STATUS: PASSED"
