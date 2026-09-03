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

echo "=== test-driven-development slim gates ==="
assert_file skills/test-driven-development/SKILL.md
assert_file skills/test-driven-development/references/red-green-refactor-depth.md
assert_file skills/test-driven-development/references/rationalizations-and-examples.md
assert_file skills/test-driven-development/testing-anti-patterns.md
assert_contains skills/test-driven-development/SKILL.md "NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST"
assert_contains skills/test-driven-development/SKILL.md "Red Flags - STOP and Start Over"
assert_contains skills/test-driven-development/SKILL.md "Verification Checklist"
assert_contains skills/test-driven-development/SKILL.md "human partner"
assert_contains skills/test-driven-development/references/red-green-refactor-depth.md "retries failed operations 3 times"
assert_contains skills/test-driven-development/references/rationalizations-and-examples.md "I'll write tests after"
assert_max_lines skills/test-driven-development/SKILL.md 180

echo "=== receiving-code-review slim gates ==="
assert_file skills/receiving-code-review/SKILL.md
assert_file skills/receiving-code-review/references/examples.md
assert_file skills/receiving-code-review/references/external-review-and-yagni.md
assert_contains skills/receiving-code-review/SKILL.md "You're absolutely right!"
assert_contains skills/receiving-code-review/SKILL.md "human partner"
assert_contains skills/receiving-code-review/SKILL.md "The Response Pattern"
assert_contains skills/receiving-code-review/SKILL.md "Technical correctness over social comfort"
assert_contains skills/receiving-code-review/references/examples.md "Performative Agreement"
assert_contains skills/receiving-code-review/references/external-review-and-yagni.md "be skeptical, but check carefully"
assert_max_lines skills/receiving-code-review/SKILL.md 160

echo "=== brainstorming TDD fixture boundary ==="
assert_file skills/brainstorming/SKILL.md
assert_contains skills/brainstorming/SKILL.md \
  "If TDD will apply to implementation source or tests, use README, package metadata, and docs only"

echo "=== document review dispatch ==="
assert_contains skills/brainstorming/SKILL.md "spec-document-reviewer-prompt.md"
assert_contains skills/brainstorming/SKILL.md "Dispatch spec reviewer"
assert_contains skills/brainstorming/SKILL.md "no subagent dispatch tool"
assert_contains skills/writing-plans/SKILL.md "plan-document-reviewer-prompt.md"
assert_contains skills/writing-plans/SKILL.md "Dispatch plan reviewer"
assert_contains skills/writing-plans/SKILL.md "no subagent dispatch tool"
assert_contains skills/writing-plans/SKILL.md "After the plan review loop passes"

if (( fail )); then
  echo "STATUS: FAILED"
  exit 1
fi
echo "STATUS: PASSED"
