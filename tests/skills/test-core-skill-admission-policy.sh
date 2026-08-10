#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
README="$REPO_ROOT/README.md"
TEMPLATE="$REPO_ROOT/.github/PULL_REQUEST_TEMPLATE.md"

failures=0

require_contains() {
  local file="$1"
  local text="$2"
  local description="$3"
  if rg -Fq -- "$text" "$file"; then
    printf '  [PASS] %s\n' "$description"
  else
    printf '  [FAIL] %s\n' "$description"
    failures=$((failures + 1))
  fi
}

require_absent() {
  local file="$1"
  local text="$2"
  local description="$3"
  if rg -Fq -- "$text" "$file"; then
    printf '  [FAIL] %s\n' "$description"
    failures=$((failures + 1))
  else
    printf '  [PASS] %s\n' "$description"
  fi
}

echo "Core skill admission policy tests"
require_contains "$README" "Domain-specific and externally sourced skills are eligible" "README permits domain-specific and externally sourced skills"
require_contains "$README" "license, dependency impact," "README discloses license and dependency impact"
require_contains "$README" "tests or evaluations, and maintenance or update strategy" "README requires evidence and maintenance strategy"
require_absent "$README" "we don't generally accept contributions of new skills" "README removes categorical new-skill rejection"
require_contains "$TEMPLATE" "Domain-specific and externally sourced skills may be appropriate for core" "template permits domain-specific and externally sourced skills"
require_contains "$TEMPLATE" "source, license, maintenance owner," "template requires source, license, and maintenance disclosure"
require_contains "$TEMPLATE" "and runtime or tool dependencies" "template requires dependency disclosure"
require_absent "$TEMPLATE" "it belongs in its own plugin — not here" "template removes standalone-plugin mandate"
require_contains "$TEMPLATE" "A human has reviewed the COMPLETE proposed diff before submission" "template retains human review gate"

if [[ "$failures" -gt 0 ]]; then
  printf '%s policy test(s) failed\n' "$failures"
  exit 1
fi

echo "All core skill admission policy tests passed"
