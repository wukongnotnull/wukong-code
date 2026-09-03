#!/usr/bin/env bash
# Static contract for the visual companion launch/stop guide.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"

GUIDE=skills/brainstorming/visual-companion.md
SERVER=skills/brainstorming/scripts/server.cjs
failed=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; failed=1; }

assert_file() {
  if [[ -f "$1" ]]; then pass "$1 exists"; else fail "$1 missing"; fi
}

assert_file "$GUIDE"
assert_file "$SERVER"

if [[ -f "$GUIDE" ]]; then
  commands="$(grep -oE '[^[:space:]`]+(start|stop)-server\.sh' "$GUIDE" | sort -u || true)"
  if [[ -z "$commands" ]]; then
    fail "$GUIDE has no start-server.sh or stop-server.sh commands"
  fi
  while IFS= read -r cmd; do
    [[ -z "$cmd" ]] && continue
    if [[ -f "$cmd" ]]; then
      pass "guide command resolves from repo root: $cmd"
    else
      fail "guide command does not resolve from repo root: $cmd"
    fi
  done <<< "$commands"

  if grep -q 'session_dir' "$GUIDE"; then
    pass "$GUIDE mentions session_dir"
  else
    fail "$GUIDE does not mention session_dir"
  fi

  if grep -Fq 'stop-server.sh "$SESSION_DIR"' "$GUIDE"; then
    pass "$GUIDE quotes \"\$SESSION_DIR\" on stop"
  else
    fail "$GUIDE stop command must use quoted \"\$SESSION_DIR\""
  fi
fi

if [[ -f "$SERVER" ]]; then
  if grep -q 'session_dir: SESSION_DIR' "$SERVER"; then
    pass "$SERVER server-started JSON includes session_dir"
  else
    fail "$SERVER server-started JSON missing session_dir"
  fi
fi

if (( failed )); then echo "STATUS: FAILED"; exit 1; fi
echo "STATUS: PASSED"
