#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"

failed=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; failed=1; }

assert_contains() {
  if grep -qF "$2" "$1"; then
    pass "$1 contains $2"
  else
    fail "$1 missing $2"
  fi
}

assert_not_contains() {
  if grep -qF "$2" "$1"; then
    fail "$1 retains obsolete policy: $2"
  else
    pass "$1 does not retain obsolete policy"
  fi
}

for policy_file in AGENTS.md CLAUDE.md .github/PULL_REQUEST_TEMPLATE.md; do
  assert_contains "$policy_file" 'target the `main` branch directly'
  assert_contains "$policy_file" 'dev → main'
  assert_not_contains "$policy_file" 'target the `dev` branch, not `main`'
done

if (( failed )); then
  exit 1
fi

echo "Pull-request target policy tests passed."
