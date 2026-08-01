#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
HOOK_UNDER_TEST="$REPO_ROOT/hooks/session-start"
WRAPPER_UNDER_TEST="$REPO_ROOT/hooks/run-hook.cmd"
PROMPT_ROUTER_UNDER_TEST="$REPO_ROOT/hooks/user-prompt-submit"

FAILURES=0
TEST_ROOT="$(mktemp -d)"

cleanup() {
    rm -rf "$TEST_ROOT"
}
trap cleanup EXIT

pass() {
    echo "  [PASS] $1"
}

fail() {
    echo "  [FAIL] $1"
    FAILURES=$((FAILURES + 1))
}

make_home() {
    local name="$1"
    local home="$TEST_ROOT/$name/home"
    mkdir -p "$home"
    printf '%s\n' "$home"
}

assert_command_output() {
    local description="$1"
    local shape="$2"
    local contains="$3"
    local not_contains="$4"
    local home="$5"
    shift 5

    local output
    if ! output="$(env -i PATH="${PATH:-}" HOME="$home" "$@" 2>&1)"; then
        fail "$description"
        echo "    hook exited non-zero"
        echo "$output" | sed 's/^/      /'
        return
    fi

    if printf '%s' "$output" | \
        EXPECT_SHAPE="$shape" \
        EXPECT_CONTAINS="$contains" \
        EXPECT_NOT_CONTAINS="$not_contains" \
        node -e '
const fs = require("fs");

const input = fs.readFileSync(0, "utf8");
let payload;
try {
  payload = JSON.parse(input);
} catch (error) {
  console.error(`invalid JSON: ${error.message}`);
  process.exit(1);
}

function hasOwn(object, key) {
  return Object.prototype.hasOwnProperty.call(object, key);
}

function fail(message) {
  console.error(message);
  process.exit(1);
}

const shape = process.env.EXPECT_SHAPE;
let context;

if (shape === "nested") {
  if (!hasOwn(payload, "hookSpecificOutput")) {
    fail("missing hookSpecificOutput");
  }
  if (hasOwn(payload, "additional_context") || hasOwn(payload, "additionalContext")) {
    fail("nested output also included a top-level context field");
  }
  const hookOutput = payload.hookSpecificOutput;
  if (!hookOutput || typeof hookOutput !== "object" || Array.isArray(hookOutput)) {
    fail("hookSpecificOutput is not an object");
  }
  if (hookOutput.hookEventName !== "SessionStart") {
    fail(`unexpected hookEventName: ${hookOutput.hookEventName}`);
  }
  context = hookOutput.additionalContext;
} else if (shape === "cursor") {
  if (hasOwn(payload, "hookSpecificOutput")) {
    fail("cursor output included hookSpecificOutput");
  }
  if (!hasOwn(payload, "additional_context")) {
    fail("cursor output missing additional_context");
  }
  if (hasOwn(payload, "additionalContext")) {
    fail("cursor output included additionalContext");
  }
  context = payload.additional_context;
} else if (shape === "sdk") {
  if (hasOwn(payload, "hookSpecificOutput")) {
    fail("sdk output included hookSpecificOutput");
  }
  if (!hasOwn(payload, "additionalContext")) {
    fail("sdk output missing additionalContext");
  }
  if (hasOwn(payload, "additional_context")) {
    fail("sdk output included additional_context");
  }
  context = payload.additionalContext;
} else {
  fail(`unknown expected shape: ${shape}`);
}

if (typeof context !== "string" || context.trim() === "") {
  fail("injected context was empty");
}

const expectedText = process.env.EXPECT_CONTAINS || "";
if (expectedText && !context.includes(expectedText)) {
  fail(`context did not contain expected text: ${expectedText}`);
}

const forbiddenTexts = (process.env.EXPECT_NOT_CONTAINS || "")
  .split("\u001f")
  .filter(Boolean);
for (const forbiddenText of forbiddenTexts) {
  if (context.includes(forbiddenText)) {
    fail(`context contained forbidden text: ${forbiddenText}`);
  }
}
'; then
        pass "$description"
    else
        fail "$description"
        echo "    output:"
        echo "$output" | sed 's/^/      /'
    fi
}

assert_prompt_router_output() {
    local description="$1"
    local input="$2"
    local contains="$3"
    local not_contains="$4"
    local home="$5"

    local output
    if ! output="$(printf '%s' "$input" | env -i PATH="${PATH:-}" HOME="$home" PLUGIN_ROOT="$REPO_ROOT" bash "$WRAPPER_UNDER_TEST" user-prompt-submit 2>&1)"; then
        fail "$description"
        echo "    hook exited non-zero"
        echo "$output" | sed 's/^/      /'
        return
    fi

    if printf '%s' "$output" | \
        EXPECT_CONTAINS="$contains" \
        EXPECT_NOT_CONTAINS="$not_contains" \
        node -e '
const fs = require("fs");
const input = fs.readFileSync(0, "utf8");
let payload;
try {
  payload = JSON.parse(input);
} catch (error) {
  console.error(`invalid JSON: ${error.message}`);
  process.exit(1);
}
const hookOutput = payload.hookSpecificOutput;
if (!hookOutput || typeof hookOutput !== "object" || Array.isArray(hookOutput)) {
  console.error("missing UserPromptSubmit hookSpecificOutput");
  process.exit(1);
}
if (hookOutput.hookEventName !== "UserPromptSubmit") {
  console.error(`unexpected hookEventName: ${hookOutput.hookEventName}`);
  process.exit(1);
}
const context = hookOutput.additionalContext;
if (typeof context !== "string" || context.trim() === "") {
  console.error("injected context was empty");
  process.exit(1);
}
const expectedText = process.env.EXPECT_CONTAINS || "";
if (expectedText && !context.includes(expectedText)) {
  console.error(`context did not contain expected text: ${expectedText}`);
  process.exit(1);
}
const forbiddenTexts = (process.env.EXPECT_NOT_CONTAINS || "")
  .split("\u001f")
  .filter(Boolean);
for (const forbiddenText of forbiddenTexts) {
  if (context.includes(forbiddenText)) {
    console.error(`context contained forbidden text: ${forbiddenText}`);
    process.exit(1);
  }
}
'; then
        pass "$description"
    else
        fail "$description"
        echo "    output:"
        echo "$output" | sed 's/^/      /'
    fi
}

assert_prompt_router_empty() {
    local description="$1"
    local input="$2"
    local home="$3"

    local output
    if ! output="$(printf '%s' "$input" | env -i PATH="${PATH:-}" HOME="$home" PLUGIN_ROOT="$REPO_ROOT" bash "$WRAPPER_UNDER_TEST" user-prompt-submit 2>&1)"; then
        fail "$description"
        echo "    hook exited non-zero"
        echo "$output" | sed 's/^/      /'
    elif [[ -n "$output" ]]; then
        fail "$description"
        echo "    expected no output:"
        echo "$output" | sed 's/^/      /'
    else
        pass "$description"
    fi
}

echo "SessionStart hook output tests"

if [[ -x "$PROMPT_ROUTER_UNDER_TEST" ]]; then
    pass "UserPromptSubmit router script exists and is executable"
else
    fail "UserPromptSubmit router script exists and is executable"
fi

claude_home="$(make_home claude-code)"
assert_command_output \
    "Claude Code emits nested SessionStart additionalContext" \
    "nested" \
    "" \
    "" \
    "$claude_home" \
    CLAUDE_PLUGIN_ROOT="$REPO_ROOT" \
    bash "$HOOK_UNDER_TEST"

router_home="$(make_home user-prompt-submit)"
assert_prompt_router_output \
    "Rust source change injects Rust implementation guidance only" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/rust-basic\",\"prompt\":\"Change process_all so it returns the processed items.\"}" \
    "# Rust Implementation Guidance" \
    "go/implementation.md"$'\037'"swift/implementation.md" \
    "$router_home"

assert_prompt_router_output \
    "Rust review request injects Rust review guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/rust-basic\",\"prompt\":\"Review src/lib.rs for correctness and API risks.\"}" \
    "# Rust Review Guidance" \
    "rust/implementation.md"$'\037'"go/review.md" \
    "$router_home"

assert_prompt_router_output \
    "Go review request injects Go review guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/go-basic\",\"prompt\":\"Review main.go for correctness and error handling.\"}" \
    "# Go Review Guidance" \
    "rust/review.md"$'\037'"swift/review.md" \
    "$router_home"

assert_prompt_router_output \
    "Swift verification request injects Swift verification guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/swift-basic\",\"prompt\":\"Verify the exact checks before claiming this Swift package is complete.\"}" \
    "# Swift Verification Guidance" \
    "rust/verification.md"$'\037'"go/verification.md" \
    "$router_home"

assert_prompt_router_empty \
    "TypeScript source request does not inject language guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/monorepo\",\"prompt\":\"Modify web/src/app.ts to fix the button state.\"}" \
    "$router_home"

assert_prompt_router_empty \
    "Documentation typo does not inject language guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT\",\"prompt\":\"Fix a typo in README.md.\"}" \
    "$router_home"

assert_prompt_router_empty \
    "Malformed hook input does not inject language guidance" \
    "not-json" \
    "$router_home"

wrapper_home="$(make_home run-hook-wrapper)"
assert_command_output \
    "run-hook.cmd wrapper dispatches to the named session-start script" \
    "nested" \
    "" \
    "" \
    "$wrapper_home" \
    CLAUDE_PLUGIN_ROOT="$REPO_ROOT" \
    bash "$WRAPPER_UNDER_TEST" session-start

codex_home="$(make_home codex)"
assert_command_output \
    "Codex emits nested SessionStart additionalContext" \
    "nested" \
    "You have wukong-code" \
    "" \
    "$codex_home" \
    PLUGIN_ROOT="$REPO_ROOT" \
    CLAUDE_PLUGIN_ROOT="$REPO_ROOT" \
    bash "$WRAPPER_UNDER_TEST" session-start

cursor_home="$(make_home cursor)"
assert_command_output \
    "Cursor emits top-level additional_context only" \
    "cursor" \
    "" \
    "" \
    "$cursor_home" \
    CURSOR_PLUGIN_ROOT="$REPO_ROOT" \
    CLAUDE_PLUGIN_ROOT="$REPO_ROOT" \
    bash "$HOOK_UNDER_TEST"

copilot_home="$(make_home copilot-cli)"
assert_command_output \
    "Copilot CLI emits top-level additionalContext only" \
    "sdk" \
    "" \
    "" \
    "$copilot_home" \
    COPILOT_CLI=1 \
    CLAUDE_PLUGIN_ROOT="$REPO_ROOT" \
    bash "$HOOK_UNDER_TEST"

fm_home="$(make_home frontmatter-stripped)"
assert_command_output \
    "SessionStart strips YAML frontmatter from using-wukong-code" \
    "nested" \
    "You have wukong-code" \
    "name: using-wukong-code"$'\037'"description: Use when starting" \
    "$fm_home" \
    CLAUDE_PLUGIN_ROOT="$REPO_ROOT" \
    bash "$HOOK_UNDER_TEST"

assert_command_output \
    "SessionStart preserves Red Flags after frontmatter strip" \
    "nested" \
    "Red Flags" \
    "" \
    "$fm_home" \
    CLAUDE_PLUGIN_ROOT="$REPO_ROOT" \
    bash "$HOOK_UNDER_TEST"

legacy_home="$(make_home legacy-warning-removed)"
mkdir -p "$legacy_home/.config/wukong-code/skills"
assert_command_output \
    "SessionStart omits obsolete legacy custom-skill warning" \
    "nested" \
    "" \
    "Wukong Code now uses"$'\037'"~/.config/wukong-code/skills"$'\037'"~/.claude/skills"$'\037'"legacy" \
    "$legacy_home" \
    CLAUDE_PLUGIN_ROOT="$REPO_ROOT" \
    bash "$HOOK_UNDER_TEST"

if [[ "$FAILURES" -gt 0 ]]; then
    echo "STATUS: FAILED ($FAILURES failure(s))"
    exit 1
fi

echo "STATUS: PASSED"
