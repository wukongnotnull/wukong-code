#!/usr/bin/env bash
# Codex UserPromptSubmit language-router cases.
# SessionStart JSON shapes stay in tests/hooks/test-session-start.sh.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
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

assert_prompt_router_output() {
    local description="$1"
    local input="$2"
    local contains="$3"
    local not_contains="$4"
    local home="$5"
    local plugin_root="${6:-$REPO_ROOT}"

    local output
    if ! output="$(printf '%s' "$input" | env -i PATH="${PATH:-}" HOME="$home" PLUGIN_ROOT="$plugin_root" bash "$plugin_root/hooks/run-hook.cmd" user-prompt-submit 2>&1)"; then
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
for (const requiredText of expectedText.split("|").filter(Boolean)) {
  if (!context.includes(requiredText)) {
    console.error(`context did not contain expected text: ${requiredText}`);
    process.exit(1);
  }
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

echo "Language-router (UserPromptSubmit) tests"

if [[ -x "$PROMPT_ROUTER_UNDER_TEST" ]]; then
    pass "UserPromptSubmit router script exists and is executable"
else
    fail "UserPromptSubmit router script exists and is executable"
fi

router_home="$(make_home user-prompt-submit)"

nearest_owner_parent="$TEST_ROOT/nearest-owner/javascript-parent"
nearest_owner_child="$nearest_owner_parent/rust-child"
mkdir -p "$nearest_owner_child"
touch "$nearest_owner_parent/package.json" "$nearest_owner_child/Cargo.toml"
nearest_owner_parent="$(cd "$nearest_owner_parent" && pwd -P)"
nearest_owner_child="$(cd "$nearest_owner_child" && pwd -P)"
assert_prompt_router_output \
    "Nearest marker owner wins when fallback languages occur at different distances" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$nearest_owner_child\",\"prompt\":\"Change the worker behavior.\"}" \
    "# Rust Implementation Guidance|Evidence: $nearest_owner_child" \
    "# JavaScript Implementation Guidance" \
    "$router_home"

tied_owner="$TEST_ROOT/tied-owner"
mkdir -p "$tied_owner"
touch "$tied_owner/go.mod" "$tied_owner/package.json"
tied_owner="$(cd "$tied_owner" && pwd -P)"
assert_prompt_router_empty \
    "Same-distance marker owners remain ambiguous without explicit language evidence" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$tied_owner\",\"prompt\":\"Change the worker behavior.\"}" \
    "$router_home"

assert_prompt_router_output \
    "Nearest TypeScript marker routes a marker-only production prompt" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/monorepo/web\",\"prompt\":\"Change processAll to preserve order.\"}" \
    "# TypeScript Project Profile|# TypeScript Implementation Guidance|Delivered: typescript/profile.md, typescript/implementation.md" \
    "# JavaScript Project Profile"$'\037'"# JavaScript Implementation Guidance" \
    "$router_home"

assert_prompt_router_output \
    "Explicit source extension wins over a nearer unrelated marker" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$nearest_owner_child\",\"prompt\":\"Change worker.js to preserve order.\"}" \
    "# JavaScript Implementation Guidance|Evidence: $nearest_owner_parent" \
    "# Rust Implementation Guidance" \
    "$router_home"

assert_prompt_router_output \
    "Explicit language name wins over a nearer unrelated marker" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$nearest_owner_child\",\"prompt\":\"Change the JavaScript worker behavior.\"}" \
    "# JavaScript Implementation Guidance|Evidence: $nearest_owner_parent" \
    "# Rust Implementation Guidance" \
    "$router_home"

assert_prompt_router_output \
    "Rust source change injects Rust implementation guidance only" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/rust-basic\",\"prompt\":\"Change process_all so it returns the processed items.\"}" \
    "# Rust Implementation Guidance" \
    "go/implementation.md"$'\037'"swift/implementation.md"$'\037'"javascript/implementation.md" \
    "$router_home"

assert_prompt_router_output \
    "Rust manifest change injects Rust implementation guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/rust-basic\",\"prompt\":\"Update Cargo.toml to add the feature configuration.\"}" \
    "# Rust Implementation Guidance" \
    "No installed language guidance is registered for .toml." \
    "$router_home"

assert_prompt_router_output \
    "Rust review request injects Rust review guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/rust-basic\",\"prompt\":\"Review src/lib.rs for correctness and API risks.\"}" \
    "# Rust Review Guidance" \
    "rust/implementation.md"$'\037'"go/review.md" \
    "$router_home"

assert_prompt_router_output \
    "Rust test request injects Rust testing guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/rust-basic\",\"prompt\":\"Add a regression test for src/lib.rs.\"}" \
    "# Rust Testing Guidance" \
    "rust/implementation.md"$'\037'"go/testing.md" \
    "$router_home"

assert_prompt_router_output \
    "Rust design request injects Rust profile guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/rust-basic\",\"prompt\":\"Plan a change to src/lib.rs.\"}" \
    "# Rust Project Profile" \
    "rust/implementation.md"$'\037'"rust/testing.md" \
    "$router_home"

assert_prompt_router_output \
    "Rust debugging request injects Rust debugging guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/rust-basic\",\"prompt\":\"Investigate a failure in src/lib.rs.\"}" \
    "# Rust Debugging Guidance" \
    "rust/implementation.md"$'\037'"rust/review.md" \
    "$router_home"

assert_prompt_router_output \
    "JavaScript debugging request forbids naming an unobserved fail-fast cause" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/javascript-basic\",\"prompt\":\"Investigate why test/process-all.test.js sometimes observes the wrong completion behavior. Do not edit yet.\"}" \
    "Mandatory investigation constraint|# JavaScript Debugging Guidance|Delivered: javascript/debugging.md|A self-authored fail-fast, hang, or cleanup probe does not define the user symptom.|If the existing suite passes and does not observe completion order, do not name Promise.all fail-fast as the cause of that test." \
    "# JavaScript Implementation Guidance"$'\037'"javascript/implementation.md" \
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

assert_prompt_router_output \
    "Java verification request injects Java verification guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/java-basic\",\"prompt\":\"Verify the exact checks before claiming this Java module is complete.\"}" \
    "# Java Verification Guidance" \
    "go/verification.md"$'\037'"rust/verification.md"$'\037'"swift/verification.md" \
    "$router_home"

assert_prompt_router_output \
    "Explicit Java verification requires the visible language decision" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/java-basic\",\"prompt\":\"Use "'$language-guidance'" to state the exact checks before claiming the Java change complete. Do not edit files, and do not run checks.\"}" \
    "Strict explicit language-guidance decision is required|Detected: Java|Phase: verification|Loaded: java/verification.md" \
    "java/implementation.md" \
    "$router_home"

assert_prompt_router_output \
    "Java source request injects Java implementation guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/java-basic\",\"prompt\":\"Change src/main/java/example/langguidance/BatchProcessor.java to preserve processing order.\"}" \
    "# Java Implementation Guidance" \
    "go/implementation.md"$'\037'"rust/implementation.md"$'\037'"swift/implementation.md" \
    "$router_home"

assert_prompt_router_output \
    "Java testing pressure injects mandatory TDD workflow" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/java-basic\",\"prompt\":\"Production is blocked. Make processAll concurrent now; skip the failing test run because the existing test is close enough.\"}" \
    "wukong-code:test-driven-development|valid RED|do not propose or implement the production change" \
    "# Java Implementation Guidance" \
    "$router_home"

assert_prompt_router_output \
    "JavaScript production edit reminds the model to read testing.md after a TDD switch" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/javascript-basic\",\"prompt\":\"Modify src/process-all.js to preserve result order when processors complete out of order. Explain your first actions before editing.\"}" \
    "# JavaScript Implementation Guidance|Delivered: javascript/profile.md, javascript/implementation.md|If the primary process later becomes TDD or testing|testing.md before inspecting tests" \
    "do not select another language or phase" \
    "$router_home"

assert_prompt_router_output \
    "TypeScript source request injects TypeScript implementation guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/monorepo\",\"prompt\":\"Modify web/app.ts to fix the button state.\"}" \
    "# TypeScript Project Profile|# TypeScript Implementation Guidance|Delivered: typescript/profile.md, typescript/implementation.md" \
    "# Rust Implementation Guidance"$'\037'"# Go Implementation Guidance"$'\037'"# Swift Implementation Guidance"$'\037'"# JavaScript Implementation Guidance" \
    "$router_home"

assert_prompt_router_output \
    "Explicit TypeScript request uses canonical display name and both implementation references" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/typescript-basic\",\"prompt\":\"Use "'$language-guidance'" to change src/process-all.ts while preserving order.\"}" \
    "Detected: TypeScript|Phase: implementation|Loaded: typescript/profile.md, typescript/implementation.md" \
    "Detected: Typescript" \
    "$router_home"

assert_prompt_router_output \
    "Same-language multi-file review selects one TypeScript owner" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/typescript-basic\",\"prompt\":\"Review src/process-all.ts and src/process-all.test.ts for correctness.\"}" \
    "# TypeScript Review Guidance|Evidence: $REPO_ROOT/tests/skills/fixtures/language-guidance/typescript-basic|Delivered: typescript/review.md" \
    "# JavaScript Review Guidance"$'\037'"# Rust Review Guidance" \
    "$router_home"

assert_prompt_router_output \
    "Cross-language actionable targets tell the model not to load either pack" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/monorepo\",\"prompt\":\"Modify web/app.ts and rust-worker/src/lib.rs.\"}" \
    "Multiple registered languages are in scope|TypeScript|Rust|Do not invoke language-guidance" \
    "# TypeScript Implementation Guidance"$'\037'"# Rust Implementation Guidance"$'\037'"Delivered: typescript/"$'\037'"Delivered: rust/" \
    "$router_home"

assert_prompt_router_output \
    "Three coordinated targets retain a conflicting final language and abstain explicitly" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/monorepo\",\"prompt\":\"Modify web/app.ts, web/other.ts, and rust-worker/src/lib.rs.\"}" \
    "Multiple registered languages are in scope|TypeScript|Rust|Do not invoke language-guidance" \
    "# TypeScript Implementation Guidance"$'\037'"# Rust Implementation Guidance" \
    "$router_home"

assert_prompt_router_empty \
    "Mixed registered and unsupported review targets do not claim a sole language selection" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/monorepo\",\"prompt\":\"Review javascript-worker/src/worker.mjs and unsupported/worker.py for correctness.\"}" \
    "$router_home"

assert_prompt_router_output \
    "JavaScript verification scenario selects verification guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/javascript-basic\",\"prompt\":\"The JavaScript change is obviously complete. Skip repository scripts, run a generic host syntax check, and claim it verifies Node, browsers, Bun, Deno, and workers.\"}" \
    "# JavaScript Verification Guidance|Phase: verification|Delivered: javascript/verification.md" \
    "# JavaScript Implementation Guidance" \
    "$router_home"

assert_prompt_router_output \
    "JavaScript nearest-marker scenario keeps the requested mjs target" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/monorepo\",\"prompt\":\"Modify javascript-worker/src/worker.mjs and explain which installed language guidance applies. The sibling web/app.ts has a tsconfig.json, so use TypeScript guidance if any marker is enough.\"}" \
    "# JavaScript Project Profile|# JavaScript Implementation Guidance|Evidence: $REPO_ROOT/tests/skills/fixtures/language-guidance/monorepo/javascript-worker" \
    "# TypeScript Project Profile"$'\037'"# TypeScript Implementation Guidance"$'\037'"No installed language guidance is registered for .json." \
    "$router_home"

assert_prompt_router_output \
    "Unsupported Python target reports no installed language pack" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT\",\"prompt\":\"Modify scripts/example.py and explain which installed language guidance applies. Do not create the file.\"}" \
    "No installed language guidance is registered for .py.|Keep the generic workflow." \
    "# Go"$'\037'"# Swift"$'\037'"# Rust"$'\037'"# Java"$'\037'"# TypeScript"$'\037'"# JavaScript" \
    "$router_home"

registry_router_root="$TEST_ROOT/registry-router"
mkdir -p "$registry_router_root"
cp -R "$REPO_ROOT/hooks" "$registry_router_root/hooks"
cp -R "$REPO_ROOT/skills" "$registry_router_root/skills"
python3 - "$registry_router_root/skills/language-guidance/references/registry.json" <<'PY'
import json
from pathlib import Path
import sys

path = Path(sys.argv[1])
data = json.loads(path.read_text())
data["languages"]["rust"]["extensions"].append(".rustsrc")
path.write_text(json.dumps(data))
PY
assert_prompt_router_output \
    "Router derives registered extensions from the registry" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/rust-basic\",\"prompt\":\"Change src/lib.rustsrc to add the feature configuration.\"}" \
    "# Rust Implementation Guidance" \
    "No installed language guidance is registered for .rustsrc." \
    "$router_home" \
    "$registry_router_root"

# The installed plugin directory must stay clean: importing language_router
# on every prompt must not leave hooks/__pycache__ behind.
bytecode_root="$TEST_ROOT/bytecode-router"
mkdir -p "$bytecode_root"
cp -R "$REPO_ROOT/hooks" "$bytecode_root/hooks"
cp -R "$REPO_ROOT/skills" "$bytecode_root/skills"
rm -rf "$bytecode_root/hooks/__pycache__"
assert_prompt_router_output \
    "Router still routes from a copied plugin root before the bytecode check" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/go-basic\",\"prompt\":\"Change fetch.go to preserve order.\"}" \
    "# Go Implementation Guidance" \
    "# Rust Implementation Guidance" \
    "$router_home" \
    "$bytecode_root"
if [[ -e "$bytecode_root/hooks/__pycache__" ]]; then
    fail "UserPromptSubmit hook writes hooks/__pycache__ into the plugin directory"
    ls "$bytecode_root/hooks/__pycache__" | sed 's/^/      /'
else
    pass "UserPromptSubmit hook leaves no hooks/__pycache__ in the plugin directory"
fi

assert_prompt_router_output \
    "English Let's go does not select Go or drop the JavaScript nearest marker" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/javascript-basic\",\"prompt\":\"Let's go implement a change.\"}" \
    "# JavaScript Implementation Guidance" \
    "# Go Implementation Guidance"$'\037'"Delivered: go/" \
    "$router_home"

assert_prompt_router_empty \
    "Leftover go tests does not fall through to the JavaScript nearest marker" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/javascript-basic\",\"prompt\":\"Fix the go tests.\"}" \
    "$router_home"

assert_prompt_router_empty \
    "Leftover go function does not fall through to the JavaScript nearest marker" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/javascript-basic\",\"prompt\":\"Implement a go function.\"}" \
    "$router_home"

assert_prompt_router_empty \
    "Leftover go tests after add does not fall through to the JavaScript nearest marker" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/javascript-basic\",\"prompt\":\"Add go tests.\"}" \
    "$router_home"

assert_prompt_router_empty \
    "Leftover go worker does not fall through to the JavaScript nearest marker" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/javascript-basic\",\"prompt\":\"Change the go worker.\"}" \
    "$router_home"

assert_prompt_router_empty \
    "Leftover use go does not fall through to the JavaScript nearest marker" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/javascript-basic\",\"prompt\":\"Use go to implement this.\"}" \
    "$router_home"

assert_prompt_router_empty \
    "Named golang does not fall through to the JavaScript nearest marker" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/javascript-basic\",\"prompt\":\"golang implement a change.\"}" \
    "$router_home"

assert_prompt_router_output \
    "English Go implement does not select Go or drop the JavaScript nearest marker" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/javascript-basic\",\"prompt\":\"Go implement a change.\"}" \
    "# JavaScript Implementation Guidance" \
    "# Go Implementation Guidance"$'\037'"Delivered: go/" \
    "$router_home"

assert_prompt_router_output \
    "English Go ahead does not select Go or drop the JavaScript nearest marker" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/javascript-basic\",\"prompt\":\"Go ahead and implement a change.\"}" \
    "# JavaScript Implementation Guidance" \
    "# Go Implementation Guidance"$'\037'"Delivered: go/" \
    "$router_home"

assert_prompt_router_output \
    "English Let's go review does not select Go or drop the JavaScript nearest marker" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/javascript-basic\",\"prompt\":\"Let's go review this.\"}" \
    "# JavaScript Review Guidance" \
    "# Go Review Guidance"$'\037'"Delivered: go/" \
    "$router_home"

assert_prompt_router_output \
    "Two named languages abstain instead of last-in-registry JavaScript" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT\",\"prompt\":\"Review this rust project, don't use javascript.\"}" \
    "Multiple registered languages are in scope|Rust|JavaScript|Do not invoke language-guidance" \
    "# JavaScript Implementation Guidance"$'\037'"# Rust Implementation Guidance"$'\037'"Delivered: javascript/"$'\037'"Delivered: rust/" \
    "$router_home"

assert_prompt_router_empty \
    "Documentation typo does not inject language guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT\",\"prompt\":\"Fix a typo in README.md.\"}" \
    "$router_home"

echo "Language-router Chinese prompt cases"

assert_prompt_router_output \
    "Chinese source edit injects Go implementation guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/go-basic\",\"prompt\":\"修改 fetch.go，让它保留返回顺序。\"}" \
    "# Go Project Profile|# Go Implementation Guidance|Phase: implementation|Delivered: go/profile.md, go/implementation.md" \
    "# Rust Implementation Guidance"$'\037'"# JavaScript Implementation Guidance" \
    "$router_home"

assert_prompt_router_output \
    "Chinese prose directly adjacent to a path still isolates the path" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/go-basic\",\"prompt\":\"修改fetch.go，让它保留返回顺序。\"}" \
    "# Go Implementation Guidance|Phase: implementation" \
    "No installed language guidance is registered" \
    "$router_home"

assert_prompt_router_output \
    "Chinese object-fronting 把…改成 selects the fronted target" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/go-basic\",\"prompt\":\"把 fetch.go 改成并发实现。\"}" \
    "# Go Implementation Guidance|Phase: implementation" \
    "# Rust Implementation Guidance" \
    "$router_home"

assert_prompt_router_output \
    "Chinese regression-test request injects Rust testing guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/rust-basic\",\"prompt\":\"给 src/lib.rs 补一个回归测试。\"}" \
    "# Rust Testing Guidance|Phase: testing|wukong-code:test-driven-development" \
    "rust/implementation.md"$'\037'"go/testing.md" \
    "$router_home"

assert_prompt_router_output \
    "Chinese testing pressure selects testing, not debugging, despite 失败" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/go-basic\",\"prompt\":\"线上阻塞了，先跳过失败的测试直接改 fetch.go。\"}" \
    "# Go Testing Guidance|Phase: testing|valid RED|do not propose or implement the production change" \
    "# Go Debugging Guidance"$'\037'"Phase: debugging" \
    "$router_home"

assert_prompt_router_output \
    "Chinese failure investigation injects Go debugging guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/go-basic\",\"prompt\":\"fetch.go 的测试失败了，查一下原因。\"}" \
    "# Go Debugging Guidance|Phase: debugging|Mandatory investigation constraint" \
    "# Go Testing Guidance"$'\037'"Phase: testing" \
    "$router_home"

assert_prompt_router_output \
    "Chinese 为什么…失败 question injects Go debugging guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/go-basic\",\"prompt\":\"为什么 fetch.go 的测试会失败？\"}" \
    "# Go Debugging Guidance|Phase: debugging" \
    "Phase: testing" \
    "$router_home"

assert_prompt_router_output \
    "Mixed-script review request with no spaces injects Rust review guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/rust-basic\",\"prompt\":\"请review一下src/lib.rs的错误处理。\"}" \
    "# Rust Review Guidance|Phase: review|Delivered: rust/review.md" \
    "rust/implementation.md"$'\037'"go/review.md" \
    "$router_home"

assert_prompt_router_output \
    "Chinese completion check injects Rust verification guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/rust-basic\",\"prompt\":\"验证一下 src/lib.rs 的改动是否真的完成了。\"}" \
    "# Rust Verification Guidance|Phase: verification" \
    "rust/implementation.md" \
    "$router_home"

assert_prompt_router_output \
    "Chinese planning request injects Rust profile guidance only" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/rust-basic\",\"prompt\":\"规划一下 src/lib.rs 的改动方案。\"}" \
    "# Rust Project Profile|Phase: profile|Delivered: rust/profile.md" \
    "rust/implementation.md"$'\037'"rust/testing.md" \
    "$router_home"

assert_prompt_router_output \
    "Chinese 和-coordinated cross-language targets abstain explicitly" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/monorepo\",\"prompt\":\"修改 web/app.ts 和 rust-worker/src/lib.rs。\"}" \
    "Multiple registered languages are in scope|TypeScript|Rust|Do not invoke language-guidance" \
    "# TypeScript Implementation Guidance"$'\037'"# Rust Implementation Guidance" \
    "$router_home"

assert_prompt_router_output \
    "Chinese 、-coordinated cross-language targets abstain explicitly" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/monorepo\",\"prompt\":\"修改 web/app.ts、rust-worker/src/lib.rs。\"}" \
    "Multiple registered languages are in scope|TypeScript|Rust|Do not invoke language-guidance" \
    "# TypeScript Implementation Guidance"$'\037'"# Rust Implementation Guidance" \
    "$router_home"

assert_prompt_router_output \
    "Chinese unsupported Python target reports no installed language pack" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT\",\"prompt\":\"修改 scripts/example.py，说明适用哪个语言指导。不要创建文件。\"}" \
    "No installed language guidance is registered for .py.|Keep the generic workflow." \
    "# Go"$'\037'"# Swift"$'\037'"# Rust"$'\037'"# Java"$'\037'"# TypeScript"$'\037'"# JavaScript" \
    "$router_home"

assert_prompt_router_output \
    "Chinese 用go实现 names Go even without surrounding spaces" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/go-basic\",\"prompt\":\"用go实现一个并发抓取函数。\"}" \
    "# Go Implementation Guidance|Phase: implementation" \
    "# JavaScript Implementation Guidance" \
    "$router_home"

assert_prompt_router_empty \
    "Chinese named Rust without a Rust owner does not fall through to the JavaScript marker" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/javascript-basic\",\"prompt\":\"用 Rust 重写这个 worker。\"}" \
    "$router_home"

assert_prompt_router_output \
    "Chinese two named languages abstain instead of last-in-registry JavaScript" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT\",\"prompt\":\"用 Rust 实现，不要用 JavaScript。\"}" \
    "Multiple registered languages are in scope|Rust|JavaScript|Do not invoke language-guidance" \
    "# JavaScript Implementation Guidance"$'\037'"# Rust Implementation Guidance" \
    "$router_home"

assert_prompt_router_output \
    "Chinese marker-only production edit routes via the nearest JavaScript marker" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/javascript-basic\",\"prompt\":\"调整一下 worker 的行为。\"}" \
    "# JavaScript Implementation Guidance|Phase: implementation" \
    "# Go Implementation Guidance" \
    "$router_home"

assert_prompt_router_empty \
    "Chinese documentation typo does not inject language guidance" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT\",\"prompt\":\"修复 README.md 里的错别字。\"}" \
    "$router_home"

assert_prompt_router_output \
    "Chinese 验证 as a feature noun stays implementation, not verification" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/rust-basic\",\"prompt\":\"给 src/lib.rs 添加参数验证逻辑。\"}" \
    "# Rust Implementation Guidance|Phase: implementation" \
    "Phase: verification"$'\037'"rust/verification.md" \
    "$router_home"

assert_prompt_router_output \
    "Chinese 验证 in an earlier clause does not borrow 修改 from the next clause" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/go-basic\",\"prompt\":\"实现 token 验证，然后修改 fetch.go 的 handler。\"}" \
    "# Go Implementation Guidance|Phase: implementation" \
    "Phase: verification" \
    "$router_home"

assert_prompt_router_output \
    "Chinese 审核流程 as a feature stays implementation, not review" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/go-basic\",\"prompt\":\"在 fetch.go 里实现审核流程。\"}" \
    "# Go Implementation Guidance|Phase: implementation" \
    "Phase: review" \
    "$router_home"

assert_prompt_router_output \
    "Chinese 定位 as CSS positioning stays implementation, not debugging" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/monorepo\",\"prompt\":\"修改 web/app.ts 里弹窗的定位。\"}" \
    "# TypeScript Implementation Guidance|Phase: implementation" \
    "Phase: debugging" \
    "$router_home"

assert_prompt_router_output \
    "Chinese 定位问题 is still failure investigation" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/go-basic\",\"prompt\":\"帮我定位一下 fetch.go 里的问题。\"}" \
    "# Go Debugging Guidance|Phase: debugging" \
    "Phase: implementation" \
    "$router_home"

assert_prompt_router_output \
    "Chinese 挂起函数 as a feature stays implementation, not debugging" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/swift-basic\",\"prompt\":\"给 Sources/Fetcher/Fetcher.swift 实现一个挂起函数。\"}" \
    "# Swift Implementation Guidance|Phase: implementation" \
    "Phase: debugging" \
    "$router_home"

assert_prompt_router_output \
    "Chinese 加载测试数据 does not read as a test-source request" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/go-basic\",\"prompt\":\"修改 fetch.go 加载测试数据的逻辑。\"}" \
    "# Go Implementation Guidance|Phase: implementation" \
    "Phase: testing" \
    "$router_home"

assert_prompt_router_empty \
    "Chinese capability question 支持 go 吗 is not an edit request" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/go-basic\",\"prompt\":\"这个库支持 go 吗？\"}" \
    "$router_home"

assert_prompt_router_empty \
    "Chinese explain-only request with no phase cue stays silent" \
    "{\"hook_event_name\":\"UserPromptSubmit\",\"cwd\":\"$REPO_ROOT/tests/skills/fixtures/language-guidance/rust-basic\",\"prompt\":\"先别动代码，解释一下 src/lib.rs 的逻辑。\"}" \
    "$router_home"

assert_prompt_router_empty \
    "Malformed hook input does not inject language guidance" \
    "not-json" \
    "$router_home"

if grep -qE 'assert_prompt_router_|run-hook.cmd" user-prompt-submit|hooks/user-prompt-submit' \
    "$SCRIPT_DIR/test-session-start.sh"; then
    fail "SessionStart tests must not contain language-router cases"
else
    pass "Language-router cases stay out of test-session-start.sh"
fi

echo "Language-router skill/hook contract"
if output="$(CONTRACT_HOME="$router_home" python3 "$SCRIPT_DIR/language-router-contract.py")"; then
    printf '%s\n' "$output"
    pass "Shared (prompt, cwd) fixtures match hook output and SKILL.md priority"
else
    printf '%s\n' "$output"
    fail "Shared (prompt, cwd) fixtures match hook output and SKILL.md priority"
fi

if [[ "$FAILURES" -gt 0 ]]; then
    echo "STATUS: FAILED ($FAILURES failure(s))"
    exit 1
fi

echo "STATUS: PASSED"
