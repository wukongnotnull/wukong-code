#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
failures=0

fail() { printf '  [FAIL] %s\n' "$1"; failures=$((failures + 1)); }
pass() { printf '  [PASS] %s\n' "$1"; }

require_missing() {
  local path="$1" description="$2"
  [[ -e "$path" ]] && fail "$description" || pass "$description"
}

require_absent() {
  local pattern="$1" path="$2" description="$3"
  rg -qi -- "$pattern" "$path" && fail "$description" || pass "$description"
}

echo "Gemini retirement checks"
require_missing "$REPO_ROOT/GEMINI.md" "Gemini context file is absent"
require_missing "$REPO_ROOT/gemini-extension.json" "Gemini extension manifest is absent"

if jq -e '.files[] | select(.path == "gemini-extension.json")' "$REPO_ROOT/.version-bump.json" >/dev/null; then
  fail "version metadata still declares the Gemini manifest"
else
  pass "version metadata omits the Gemini manifest"
fi

require_absent 'Gemini|gemini' "$REPO_ROOT/docs/testing.md" "testing guide does not advertise Gemini"
require_absent 'Gemini|gemini' "$REPO_ROOT/docs/porting-to-a-new-harness.md" "porting guide does not advertise Gemini"
require_absent 'GEMINI\.md|gemini-extension\.json' "$REPO_ROOT/scripts/sync-to-codex-plugin.sh" "Codex sync has no stale Gemini exclusions"

if rg -Fq '## v6.3.0' "$REPO_ROOT/RELEASE-NOTES.md"; then
  pass "release notes include v6.3.0"
else
  fail "release notes omit v6.3.0"
fi

if [[ "$failures" -gt 0 ]]; then
  printf '%s Gemini retirement check(s) failed\n' "$failures"
  exit 1
fi

echo "All Gemini retirement checks passed"
