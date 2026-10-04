#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

usage() {
  cat <<'EOF'
Usage: bash scripts/test.sh [--suite core|extended]

Suites:
  core      Deterministic repository checks (default).
  extended  Runs core, then brainstorm-server and Antigravity checks.

Host CLI integrations and Drill LLM evaluations remain manual; see docs/testing.md.

Both suites check for the host tools they shell out to before running anything
and exit 3 with the full list of missing tools (see docs/testing.md).
EOF
}

# Host tools the core suite shells out to, with the test that needs each one.
# Checked up front so a missing tool is reported once, by name, instead of
# surfacing as dozens of unrelated assertion failures deep in one test.
CORE_TOOLS=(
  "git:tests/codex-plugin-sync, tests/codex"
  "node:tests/pi, tests/brainstorm-server, tests/product-design"
  "python3:tests/hooks, tests/kimi, tests/codex-plugin-sync"
  "rg:tests/skills, tests/product-design"
  "rsync:tests/codex-plugin-sync"
  "jq:tests/codex/test-package-codex-plugin.sh"
  "zip:tests/codex/test-package-codex-plugin.sh"
  "unzip:tests/codex/test-package-codex-plugin.sh"
  "tar:tests/codex/test-package-codex-plugin.sh"
  "gzip:tests/codex/test-package-codex-plugin.sh"
  "shasum:tests/codex/test-package-codex-plugin.sh"
)
EXTENDED_TOOLS=(
  "npm:tests/brainstorm-server"
)

preflight() {
  local missing=()
  local entry tool used_by
  for entry in "$@"; do
    tool="${entry%%:*}"
    used_by="${entry#*:}"
    command -v "$tool" >/dev/null 2>&1 || missing+=("  $tool (used by $used_by)")
  done
  [[ "${#missing[@]}" -eq 0 ]] && return 0
  {
    echo "scripts/test.sh: missing required host tools:"
    printf '%s\n' "${missing[@]}"
    echo "Install them and re-run. docs/testing.md lists every tool the suites expect."
  } >&2
  exit 3
}

run() {
  printf '\n>>> '
  printf '%q ' "$@"
  printf '\n'
  "$@"
}

run_core() {
  run bash tests/test-automation/test-test-runner.sh
  run bash tests/skills/test-core-skill-admission-policy.sh
  run bash tests/skills/test-language-guidance.sh
  run bash tests/skills/test-visual-companion.sh
  run bash tests/skills/test-skill-slim-gates.sh
  run bash tests/skills/test-gemini-retirement.sh
  run bash tests/hooks/test-session-start.sh
  run bash tests/hooks/test-language-router.sh
  run bash tests/hooks/test-tool-mapping-canonical.sh
  run bash tests/opencode/run-tests.sh
  run bash tests/kimi/run-tests.sh
  run bash tests/cursor/run-tests.sh
  run node --experimental-strip-types --test tests/pi/test-pi-extension.mjs
  run node --test tests/brainstorm-server/wrap-frame.test.cjs
  run bash tests/codex/test-marketplace-manifest.sh
  run bash tests/codex/test-package-codex-plugin.sh
  run bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh
  run bash tests/product-design/test-core-integration.sh
  run node --test tests/product-design/test-import-integrity.mjs
  run bash tests/shell-lint/test-lint-shell.sh
}

run_extended() {
  run_core
  run npm ci --prefix tests/brainstorm-server
  run npm test --prefix tests/brainstorm-server
  run bash tests/antigravity/run-tests.sh
}

suite="core"
case "${1:-}" in
  "")
    ;;
  --help|-h)
    usage
    exit 0
    ;;
  --suite)
    if [[ "$#" -ne 2 ]]; then
      usage >&2
      exit 2
    fi
    suite="$2"
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac

case "$suite" in
  core)
    preflight "${CORE_TOOLS[@]}"
    run_core
    ;;
  extended)
    preflight "${CORE_TOOLS[@]}" "${EXTENDED_TOOLS[@]}"
    run_extended
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac

printf '\nAll %s tests passed\n' "$suite"
