#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Cursor integration tests ==="
echo
bash "$SCRIPT_DIR/test-cursor-plugin.sh"
echo
echo "=== All Cursor tests passed ==="
