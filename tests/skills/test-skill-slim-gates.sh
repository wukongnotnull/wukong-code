#!/usr/bin/env bash
# Assert slimmed skills keep resident gates and on-demand references exist.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"

fail=0
assert_file() {
  if [[ ! -f "$1" ]]; then
    echo "FAIL: missing $1"
    fail=1
  fi
}

assert_contains() {
  local file="$1" needle="$2"
  if ! grep -qF "$needle" "$file"; then
    echo "FAIL: $file missing: $needle"
    fail=1
  fi
}

assert_max_lines() {
  local file="$1" max="$2"
  local n
  n=$(wc -l < "$file" | tr -d ' ')
  if (( n > max )); then
    echo "FAIL: $file has $n lines (max $max)"
    fail=1
  else
    echo "  [PASS] $file: $n lines (max $max)"
  fi
}

echo "=== writing-skills slim gates ==="
assert_file skills/writing-skills/SKILL.md
assert_file skills/writing-skills/references/skill-discovery-optimization.md
assert_file skills/writing-skills/references/authoring-patterns.md
assert_file skills/writing-skills/references/testing-and-bulletproofing.md
assert_file skills/writing-skills/references/anti-patterns.md
assert_file skills/writing-skills/references/discovery-workflow.md
assert_contains skills/writing-skills/SKILL.md "NO SKILL WITHOUT A FAILING TEST FIRST"
assert_contains skills/writing-skills/SKILL.md "Skill Creation Checklist"
assert_contains skills/writing-skills/SKILL.md "NEVER summarize the skill's process"
assert_contains skills/writing-skills/references/testing-and-bulletproofing.md "Too simple to test"
assert_max_lines skills/writing-skills/SKILL.md 280

echo "=== subagent-driven-development slim gates ==="
assert_file skills/subagent-driven-development/SKILL.md
assert_file skills/subagent-driven-development/references/constructing-reviewer-prompts.md
assert_file skills/subagent-driven-development/references/model-selection-depth.md
assert_file skills/subagent-driven-development/references/when-to-use.md
assert_file skills/subagent-driven-development/references/example-workflow.md
assert_file skills/subagent-driven-development/references/advantages.md
assert_contains skills/subagent-driven-development/SKILL.md "## Red Flags"
assert_contains skills/subagent-driven-development/SKILL.md "File Handoffs"
assert_contains skills/subagent-driven-development/SKILL.md "implementer-contract"
assert_contains skills/subagent-driven-development/SKILL.md "never pre-judge"
assert_contains skills/subagent-driven-development/references/constructing-reviewer-prompts.md "do not flag"
assert_max_lines skills/subagent-driven-development/SKILL.md 300

if (( fail )); then
  echo "STATUS: FAILED"
  exit 1
fi
echo "STATUS: PASSED"
