#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

usage() {
  cat <<'EOF'
Usage: bash scripts/test.sh [--suite core|extended]

Suites:
  core      Deterministic repository checks used by pull-request CI (default).
  extended  Runs core, then brainstorm-server and Antigravity checks.

Host CLI integrations and Drill LLM evaluations remain manual; see docs/testing.md.
EOF
}

run() {
  printf '\n>>> '
  printf '%q ' "$@"
  printf '\n'
  "$@"
}

run_core() {
  run bash tests/skills/test-core-skill-admission-policy.sh
  run bash tests/skills/test-language-guidance.sh
  run bash tests/skills/test-skill-slim-gates.sh
  run bash tests/skills/test-gemini-retirement.sh
  run bash tests/hooks/test-session-start.sh
  run bash tests/opencode/run-tests.sh
  run bash tests/kimi/run-tests.sh
  run node --test tests/pi/test-pi-extension.mjs
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
    run_core
    ;;
  extended)
    run_extended
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac

printf '\nAll %s tests passed\n' "$suite"
