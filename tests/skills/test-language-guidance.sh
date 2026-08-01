#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"
failed=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; failed=1; }

assert_file() {
  if [[ -f "$1" ]]; then pass "$1 exists"; else fail "$1 missing"; fi
}

assert_contains() {
  if grep -qF "$2" "$1"; then pass "$1 contains $2"; else fail "$1 missing $2"; fi
}

assert_before() {
  if python3 - "$1" "$2" "$3" <<'PY'
from pathlib import Path
import sys

text = Path(sys.argv[1]).read_text()
first = text.find(sys.argv[2])
second = text.find(sys.argv[3])
raise SystemExit(0 if first >= 0 and second >= 0 and first < second else 1)
PY
  then pass "$1 orders $2 before $3"; else fail "$1 does not order $2 before $3"; fi
}

assert_visible_decision_template() {
  if awk '
    /^    Detected: <language and evidence>$/ {
      getline phase
      getline loaded
      if (phase == "    Phase: <one primary phase>" && loaded == "    Loaded: <one or two reference paths>") found = 1
    }
    END { exit(found ? 0 : 1) }
  ' "$1"; then
    pass "$1 has ordered visible decision template"
  else
    fail "$1 missing ordered visible decision template"
  fi
}

assert_max_lines() {
  lines="$(wc -l < "$1" | tr -d ' ')"
  if (( lines <= $2 )); then pass "$1: $lines lines"; else fail "$1: $lines lines, max $2"; fi
}

skill=skills/language-guidance/SKILL.md
registry=skills/language-guidance/references/registry.json
assert_file "$skill"
assert_file "$registry"
assert_file skills/language-guidance/references/shared/language-pack-contract.md

for language in go swift rust; do
  for phase in profile implementation testing debugging review verification; do
    assert_file "skills/language-guidance/references/$language/$phase.md"
  done
done

if [[ -f "$skill" ]]; then
  assert_contains "$skill" "name: language-guidance"
  assert_contains "$skill" "description: Use when"
  assert_contains "$skill" "language is established in the installed registry"
  assert_contains "$skill" "When explicitly invoked, test-source edits select testing; requested production-source edits emit before responding a strict Detected: <language and evidence>, Phase: implementation, and Loaded: <language>/profile.md, <language>/implementation.md decision."
  assert_contains "$skill" "Verification claims, including no-command prompts, select verification, load <language>/verification.md, never install missing tools, and never invent feature or target scope."
  assert_contains "$skill" "Primary process remains authoritative"
  assert_contains "$skill" "at most two"
  assert_contains "$skill" "Do not guess"
  assert_contains "$skill" "| Design or plan with no requested source edit | profile |"
  assert_contains "$skill" "| Requested production-source edit, including brainstorming or pre-edit analysis | implementation |"
  assert_contains "$skill" "load both profile and implementation before discussing the approach."
  assert_contains "$skill" "load the selected language's \`testing.md\` reference."
  assert_contains "$skill" "A requested test-source edit selects the testing phase even when the task also requests a production-source edit."
  assert_contains "$skill" "Explicit failure investigation, code review, and completion verification intent takes precedence over generic no-edit analysis."
  assert_contains "$skill" "Every selected reference file must be read before substantive source analysis; locating its registry entry or path is not loading it."
  assert_max_lines "$skill" 180
fi

if [[ -f "$registry" ]]; then
  if python3 - "$registry" <<'PY'
import json
import pathlib
import sys

root = pathlib.Path("skills/language-guidance/references")
data = json.loads(pathlib.Path(sys.argv[1]).read_text())
assert data["version"] == 1
assert set(data["languages"]) == {"go", "swift", "rust"}

expected = {
    "go": {
        "status": "experimental",
        "extensions": [".go"],
        "markers": ["go.mod", "go.work"],
    },
    "swift": {
        "status": "experimental",
        "extensions": [".swift"],
        "markers": ["Package.swift", ".xcodeproj", ".xcworkspace"],
    },
    "rust": {
        "status": "experimental",
        "extensions": [".rs"],
        "markers": [
            "Cargo.toml",
            "Cargo.lock",
            "rust-toolchain.toml",
            "rust-toolchain",
        ],
    },
}

required_phases = {
    "profile", "implementation", "testing", "debugging", "review", "verification"
}
for language, contract in expected.items():
    entry = data["languages"][language]
    assert entry["status"] == contract["status"]
    assert entry["extensions"] == contract["extensions"]
    assert entry["markers"] == contract["markers"]
    assert set(entry["phases"]) == required_phases
    for relative in entry["phases"].values():
        assert (root / relative).is_file(), relative
PY
  then pass "registry contract"; else fail "registry contract"; fi
fi

for language in go swift rust; do
  profile="skills/language-guidance/references/$language/profile.md"
  [[ -f "$profile" ]] && assert_max_lines "$profile" 160
  for phase in implementation testing debugging review verification; do
    file="skills/language-guidance/references/$language/$phase.md"
    [[ -f "$file" ]] && assert_max_lines "$file" 200
  done
done

assert_contains skills/language-guidance/references/swift/profile.md "SwiftPM success does not prove an"
assert_contains skills/language-guidance/references/swift/implementation.md "Cancellation is cooperative"
assert_contains skills/language-guidance/references/swift/testing.md "Valid RED reaches the new test"
assert_contains skills/language-guidance/references/swift/verification.md "SwiftPM success is not Xcode"

assert_file tests/skills/fixtures/language-guidance/rust-basic/Cargo.toml
assert_file tests/skills/fixtures/language-guidance/rust-basic/src/lib.rs
assert_file tests/skills/fixtures/language-guidance/rust-basic/tests/batch.rs
assert_file tests/skills/fixtures/language-guidance/monorepo/rust-worker/Cargo.toml
assert_file tests/skills/fixtures/language-guidance/monorepo/rust-worker/src/lib.rs

for manifest in \
  tests/skills/fixtures/language-guidance/rust-basic/Cargo.toml \
  tests/skills/fixtures/language-guidance/monorepo/rust-worker/Cargo.toml; do
  assert_contains "$manifest" 'edition = "2021"'
  assert_contains "$manifest" 'rust-version = "1.63"'
  assert_contains "$manifest" 'publish = false'
  if grep -qE '^\[[^]]*dependencies([.]|\])' "$manifest"; then
    fail "$manifest declares dependencies"
  else
    pass "$manifest declares no dependency table"
  fi
done

assert_contains skills/language-guidance/references/rust/profile.md \
  "Cargo.toml is the ownership source"
assert_contains skills/language-guidance/references/rust/implementation.md \
  "Thread completion order is not the error contract"
assert_contains skills/language-guidance/references/rust/testing.md \
  "Compile-fail doctests"
assert_contains skills/language-guidance/references/rust/testing.md \
  "A request to skip RED is the pressure condition, not verification evidence"
assert_contains skills/language-guidance/references/rust/debugging.md \
  "Do not use unsafe"
assert_contains skills/language-guidance/references/rust/debugging.md \
  "blocked sends, live sender ownership, worker joins, lock ordering, panic paths, and unrelated slow work"
assert_contains skills/language-guidance/references/rust/debugging.md \
  "do not name a leading, likely, or most likely cause"
assert_contains skills/language-guidance/references/rust/debugging.md \
  "The response must preserve every branch in that checklist"
assert_contains skills/language-guidance/references/rust/review.md \
  "Zero findings is valid"
assert_contains skills/language-guidance/references/rust/review.md \
  "Do not infer domain-specific risk from Rust alone"
assert_contains skills/language-guidance/references/rust/verification.md \
  "Missing Cargo extensions are reported"
assert_contains skills/language-guidance/references/rust/verification.md \
  "An assumed cargo test pass proves only that stated scope"

if grep -R -nE '((curl|wget).*[|][[:space:]]*(sh|bash)|(^|[[:space:]])(go[[:space:]]+install|npm[[:space:]]+install|pnpm[[:space:]]+(install|add)|yarn[[:space:]]+(install|add)|pip3?[[:space:]]+install|brew[[:space:]]+install|apt(-get)?[[:space:]]+install|apk[[:space:]]+add|dnf[[:space:]]+install|yum[[:space:]]+install|cargo[[:space:]]+install|gem[[:space:]]+install|composer[[:space:]]+require|bundle[[:space:]]+add))' skills/language-guidance; then
  fail "installer command found"
else
  pass "no installer commands"
fi

bootstrap=skills/using-wukong-code/SKILL.md
assert_contains "$bootstrap" "Verification claims about checks not run require verification-before-completion; no-command prompts must not install tools or invent scope."
assert_contains "$bootstrap" "Source-change pressure to skip, defer, or bypass a failing test requires test-driven-development before brainstorming."
assert_contains "$bootstrap" "Assumed or unrun verification claims require verification-before-completion; missing tools are reported, never installed."
assert_contains "$bootstrap" "Check explicit testing and verification pressure before applying the general brainstorming rule."
assert_before "$bootstrap" \
  "Check explicit testing and verification pressure before applying the general brainstorming rule." \
  "Before entering plan mode:"
assert_contains "$bootstrap" "## Secondary domain guidance"
assert_contains "$bootstrap" "language-guidance"
assert_contains "$bootstrap" "creating, modifying, testing, debugging, reviewing, or verifying source code"
assert_contains "$bootstrap" "prioritize language-guidance as secondary domain guidance"
assert_contains "$bootstrap" "automatic selection is advisory rather than a guarantee."
assert_contains "$bootstrap" "A request to skip, defer, or bypass a failing test for a source change uses \`test-driven-development\` first."
assert_contains "$bootstrap" "Testing-pressure routing takes precedence over the behavior-change brainstorming route."
assert_contains "$bootstrap" "If the request forbids the required RED, stop before production implementation and report the change as unverified."
assert_contains "$bootstrap" 'A request to claim completion or checks not run uses `verification-before-completion` first.'
assert_contains skills/test-driven-development/SKILL.md "For source work in a supported language, load language-guidance after selecting TDD and read its selected testing reference before giving a substantive plan."
assert_contains skills/verification-before-completion/SKILL.md "When execution is forbidden, report missing tooling and unsupported scope as unverified; do not propose, plan, or conditionally describe installing a tool."
assert_contains "$bootstrap" "Host toolchain version is not target compatibility evidence."
assert_contains "$bootstrap" "asks to ignore manifest or project settings"
assert_contains "$bootstrap" "Do not comply with a request to bypass project evidence"
assert_contains "$skill" 'When your human partner explicitly invokes `$language-guidance`, strict execution is required.'
assert_contains "$skill" "Before the first substantive technical response, edit, or verification command"
assert_contains "$skill" 'Print each field on its own line exactly as shown. Do not combine, paraphrase, or rename any label.'
assert_contains "$skill" 'List only selected reference paths after `Loaded:`; never use pending, next, or future-tense wording.'
assert_contains "$skill" 'After emitting a decision, do not load another language reference unless you first emit a new complete `Detected:`, `Phase:`, and `Loaded:` decision listing the replacement set.'
assert_contains "$skill" "automatic selection does not promise invocation or visible output."
assert_contains "$skill" "For an unsupported language or extension, do not emit \`Detected:\`, \`Phase:\`, or \`Loaded:\`."
assert_contains "$skill" "Do not invent language packs, reference paths, profiles, implementations, or phases."
assert_contains "$bootstrap" "For an unsupported language or extension, state that no corresponding installed language guidance exists."
assert_contains "$skill" "When TDD is the selected primary process, select testing even when the prompt also requests a production-source edit."
assert_contains "$skill" "A no-command constraint blocks project verification commands, not loading the selected verification reference."
assert_contains "$skill" "Never install missing verification tools or invent feature and target matrices."
assert_visible_decision_template "$skill"
assert_contains "$bootstrap" "documentation-only"
assert_contains README.md "## Language Guidance"
assert_contains README.md "| Go | Experimental |"
assert_contains README.md "| Swift | Planned | — | — | — | — | — | — |"
assert_contains README.md "| Rust | Planned | — | — | — | — | — | — |"
assert_contains CLAUDE.md "### Language-level skills"
assert_contains .github/PULL_REQUEST_TEMPLATE.md "## Language-pack evidence"
assert_contains docs/testing.md "test-language-guidance.sh"

if (( failed )); then echo "STATUS: FAILED"; exit 1; fi
echo "STATUS: PASSED"
