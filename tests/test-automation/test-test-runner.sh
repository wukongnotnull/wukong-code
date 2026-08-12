#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
RUNNER="$REPO_ROOT/scripts/test.sh"

if [[ ! -f "$RUNNER" ]]; then
  echo "FAIL: scripts/test.sh is missing" >&2
  exit 1
fi

TEST_ROOT="$(mktemp -d)"
FIXTURE="$TEST_ROOT/repo"
LOG="$TEST_ROOT/commands.log"

cleanup() {
  rm -rf "$TEST_ROOT"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_equals() {
  local actual="$1"
  local expected="$2"
  local description="$3"

  if [[ "$actual" != "$expected" ]]; then
    echo "FAIL: $description" >&2
    echo "Expected:" >&2
    printf '%s\n' "$expected" >&2
    echo "Actual:" >&2
    printf '%s\n' "$actual" >&2
    exit 1
  fi
}

assert_file_contains() {
  local file="$1"
  local expected="$2"
  local description="$3"

  [[ -f "$file" ]] || fail "$description: missing $file"
  grep -Fq -- "$expected" "$file" || fail "$description: expected $expected"
}

make_shell_stub() {
  local relative_path="$1"
  local target="$FIXTURE/$relative_path"

  mkdir -p "$(dirname "$target")"
  cat >"$target" <<EOF
#!/usr/bin/env bash
printf '%s\\n' '$relative_path' >> "\${WUKONG_TEST_RUNNER_LOG}"
if [[ "\${WUKONG_TEST_RUNNER_FAIL_PATH:-}" == '$relative_path' ]]; then
  exit 42
fi
EOF
  chmod +x "$target"
}

mkdir -p "$FIXTURE/scripts" "$FIXTURE/bin"
cp "$RUNNER" "$FIXTURE/scripts/test.sh"
chmod +x "$FIXTURE/scripts/test.sh"

for test_path in \
  tests/skills/test-core-skill-admission-policy.sh \
  tests/skills/test-language-guidance.sh \
  tests/skills/test-skill-slim-gates.sh \
  tests/skills/test-gemini-retirement.sh \
  tests/hooks/test-session-start.sh \
  tests/opencode/run-tests.sh \
  tests/kimi/run-tests.sh \
  tests/codex/test-marketplace-manifest.sh \
  tests/codex/test-package-codex-plugin.sh \
  tests/codex-plugin-sync/test-sync-to-codex-plugin.sh \
  tests/product-design/test-core-integration.sh \
  tests/shell-lint/test-lint-shell.sh \
  tests/antigravity/run-tests.sh; do
  make_shell_stub "$test_path"
done

cat >"$FIXTURE/bin/node" <<'EOF'
#!/usr/bin/env bash
printf 'node' >> "${WUKONG_TEST_RUNNER_LOG}"
printf ' %s' "$@" >> "${WUKONG_TEST_RUNNER_LOG}"
printf '\n' >> "${WUKONG_TEST_RUNNER_LOG}"
EOF
chmod +x "$FIXTURE/bin/node"

cat >"$FIXTURE/bin/npm" <<'EOF'
#!/usr/bin/env bash
printf 'npm' >> "${WUKONG_TEST_RUNNER_LOG}"
printf ' %s' "$@" >> "${WUKONG_TEST_RUNNER_LOG}"
printf '\n' >> "${WUKONG_TEST_RUNNER_LOG}"
EOF
chmod +x "$FIXTURE/bin/npm"

run_fixture() {
  (
    cd "$FIXTURE"
    PATH="$FIXTURE/bin:$PATH" \
      WUKONG_TEST_RUNNER_LOG="$LOG" \
      bash scripts/test.sh "$@"
  )
}

CORE_LOG="$(cat <<'EOF'
tests/skills/test-core-skill-admission-policy.sh
tests/skills/test-language-guidance.sh
tests/skills/test-skill-slim-gates.sh
tests/skills/test-gemini-retirement.sh
tests/hooks/test-session-start.sh
tests/opencode/run-tests.sh
tests/kimi/run-tests.sh
node --test tests/pi/test-pi-extension.mjs
tests/codex/test-marketplace-manifest.sh
tests/codex/test-package-codex-plugin.sh
tests/codex-plugin-sync/test-sync-to-codex-plugin.sh
tests/product-design/test-core-integration.sh
node --test tests/product-design/test-import-integrity.mjs
tests/shell-lint/test-lint-shell.sh
EOF
)"

: >"$LOG"
run_fixture --suite core
assert_equals "$(cat "$LOG")" "$CORE_LOG" "core suite command order"

: >"$LOG"
run_fixture --suite extended
EXTENDED_LOG="$(cat <<EOF
$CORE_LOG
npm ci --prefix tests/brainstorm-server
npm test --prefix tests/brainstorm-server
tests/antigravity/run-tests.sh
EOF
)"
assert_equals "$(cat "$LOG")" "$EXTENDED_LOG" "extended suite appends opt-in checks"

if help_output="$(run_fixture --help)"; then
  [[ "$help_output" == *"core"* ]] || fail "help output omits core suite"
  [[ "$help_output" == *"extended"* ]] || fail "help output omits extended suite"
else
  fail "help exits successfully"
fi

if run_fixture --suite unknown >/dev/null 2>&1; then
  fail "unknown suite exits successfully"
fi

: >"$LOG"
if WUKONG_TEST_RUNNER_FAIL_PATH="tests/hooks/test-session-start.sh" run_fixture --suite core >/dev/null 2>&1; then
  fail "child failure exits successfully"
else
  status=$?
  [[ "$status" -eq 42 ]] || fail "child failure exits with $status instead of 42"
fi

assert_file_contains "$REPO_ROOT/package.json" \
  '"test": "bash scripts/test.sh --suite core"' \
  "package metadata exposes the core suite"
assert_file_contains "$REPO_ROOT/package.json" \
  '"test:extended": "bash scripts/test.sh --suite extended"' \
  "package metadata exposes the extended suite"
assert_file_contains "$REPO_ROOT/.github/workflows/test.yml" \
  'run: npm run test:extended' \
  "workflow runs the extended suite for pull requests and pushes"
assert_file_contains "$REPO_ROOT/.github/workflows/test.yml" \
  'cache-dependency-path: tests/brainstorm-server/package-lock.json' \
  "workflow caches the nested extended-suite lockfile"
assert_file_contains "$REPO_ROOT/.github/workflows/test.yml" \
  'workflow_dispatch:' \
  "workflow exposes manual dispatch"
assert_file_contains "$REPO_ROOT/docs/testing.md" \
  'npm run test:extended' \
  "testing guide documents the extended suite"
assert_file_contains "$REPO_ROOT/docs/testing.md" \
  'GitHub Actions runs the extended suite for pull requests and pushes to `main` and `dev`.' \
  "testing guide documents the mandatory extended CI gate"

echo "PASS: layered test runner contract"
