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

for phase in profile implementation testing debugging review verification; do
  assert_file "skills/language-guidance/references/go/$phase.md"
done

if [[ -f "$skill" ]]; then
  assert_contains "$skill" "name: language-guidance"
  assert_contains "$skill" "description: Use when"
  assert_contains "$skill" "Primary process remains authoritative"
  assert_contains "$skill" "at most two"
  assert_contains "$skill" "Do not guess"
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
assert set(data["languages"]) == {"go"}
go = data["languages"]["go"]
assert go["status"] == "experimental"
assert go["extensions"] == [".go"]
assert go["markers"] == ["go.mod", "go.work"]
assert set(go["phases"]) == {
    "profile", "implementation", "testing", "debugging", "review", "verification"
}
for relative in go["phases"].values():
    assert (root / relative).is_file(), relative
PY
  then pass "registry contract"; else fail "registry contract"; fi
fi

[[ -f skills/language-guidance/references/go/profile.md ]] &&
  assert_max_lines skills/language-guidance/references/go/profile.md 160
for phase in implementation testing debugging review verification; do
  file="skills/language-guidance/references/go/$phase.md"
  [[ -f "$file" ]] && assert_max_lines "$file" 200
done

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
