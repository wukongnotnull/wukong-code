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

for language in go swift rust java typescript javascript; do
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
  assert_contains "$skill" "source targets in two or more registered languages"
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
assert set(data["languages"]) == {
    "go", "swift", "rust", "java", "typescript", "javascript"
}

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
    "java": {
        "status": "experimental",
        "extensions": [".java"],
        "markers": [
            "pom.xml",
            "build.gradle",
            "build.gradle.kts",
            "settings.gradle",
            "settings.gradle.kts",
        ],
    },
    "typescript": {
        "display_name": "TypeScript",
        "status": "experimental",
        "extensions": [".ts", ".tsx"],
        "markers": ["tsconfig.json"],
        "phases": {
            "profile": "typescript/profile.md",
            "implementation": "typescript/implementation.md",
            "testing": "typescript/testing.md",
            "debugging": "typescript/debugging.md",
            "review": "typescript/review.md",
            "verification": "typescript/verification.md",
        },
    },
    "javascript": {
        "display_name": "JavaScript",
        "status": "experimental",
        "extensions": [".js", ".mjs", ".cjs", ".jsx"],
        "markers": ["package.json"],
        "phases": {
            "profile": "javascript/profile.md",
            "implementation": "javascript/implementation.md",
            "testing": "javascript/testing.md",
            "debugging": "javascript/debugging.md",
            "review": "javascript/review.md",
            "verification": "javascript/verification.md",
        },
    },
}

required_phases = {
    "profile", "implementation", "testing", "debugging", "review", "verification"
}
for language, contract in expected.items():
    entry = data["languages"][language]
    if "display_name" in contract:
        assert entry["display_name"] == contract["display_name"]
    assert entry["status"] == contract["status"]
    assert entry["extensions"] == contract["extensions"]
    assert entry["markers"] == contract["markers"]
    if "phases" in contract:
        assert entry["phases"] == contract["phases"]
    assert set(entry["phases"]) == required_phases
    for relative in entry["phases"].values():
        assert (root / relative).is_file(), relative

assert data["languages"]["javascript"]["phases"] == {
    phase: f"javascript/{phase}.md" for phase in required_phases
}
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

for phase in profile implementation testing debugging review verification; do
  file="skills/language-guidance/references/java/$phase.md"
  [[ -f "$file" ]] && assert_max_lines "$file" 200
done

for language in typescript javascript; do
  for phase in profile implementation testing debugging review verification; do
    file="skills/language-guidance/references/$language/$phase.md"
    [[ -f "$file" ]] && assert_max_lines "$file" 200
  done
done

assert_contains skills/language-guidance/references/swift/profile.md "SwiftPM success does not prove an"
assert_contains skills/language-guidance/references/swift/implementation.md "Cancellation is cooperative"
assert_contains skills/language-guidance/references/swift/testing.md "Valid RED reaches the new test"
assert_contains skills/language-guidance/references/swift/verification.md "SwiftPM success is not Xcode"

assert_file tests/skills/fixtures/language-guidance/java-basic/pom.xml
assert_file tests/skills/fixtures/language-guidance/java-basic/src/main/java/example/langguidance/BatchProcessor.java
assert_file tests/skills/fixtures/language-guidance/java-basic/src/test/java/example/langguidance/BatchProcessorTest.java
assert_file tests/skills/fixtures/language-guidance/java-gradle-basic/settings.gradle
assert_file tests/skills/fixtures/language-guidance/java-gradle-basic/build.gradle
assert_file tests/skills/fixtures/language-guidance/java-gradle-basic/src/main/java/example/langguidance/BatchProcessor.java
assert_file tests/skills/fixtures/language-guidance/java-gradle-basic/src/test/java/example/langguidance/BatchProcessorHarness.java
assert_file tests/skills/fixtures/language-guidance/monorepo/java-worker/pom.xml
assert_file tests/skills/fixtures/language-guidance/monorepo/java-worker/src/main/java/example/worker/Worker.java
assert_contains tests/skills/fixtures/language-guidance/java-basic/src/main/java/example/langguidance/BatchProcessor.java "input.startsWith(\"fail:\")"
assert_contains tests/skills/fixtures/language-guidance/java-basic/src/main/java/example/langguidance/BatchProcessor.java "interface ItemProcessor"
assert_contains tests/skills/fixtures/language-guidance/java-basic/src/main/java/example/langguidance/BatchProcessor.java "MAX_WORKERS = 2"
assert_contains tests/skills/fixtures/language-guidance/java-basic/src/test/java/example/langguidance/BatchProcessorTest.java "fail:lowest-index"
assert_contains tests/skills/fixtures/language-guidance/java-basic/src/test/java/example/langguidance/BatchProcessorTest.java "CountDownLatch"
assert_contains tests/skills/fixtures/language-guidance/java-basic/src/test/java/example/langguidance/BatchProcessorTest.java "assertInterruptedCallerWaitsForStartedWork"

for pom in \
  tests/skills/fixtures/language-guidance/java-basic/pom.xml \
  tests/skills/fixtures/language-guidance/monorepo/java-worker/pom.xml; do
  if grep -q '<dependencies>' "$pom"; then
    fail "$pom declares dependencies"
  else
    pass "$pom declares no dependency block"
  fi
done

gradle_build=tests/skills/fixtures/language-guidance/java-gradle-basic/build.gradle
assert_contains "$gradle_build" "JavaLanguageVersion.of(17)"
assert_contains "$gradle_build" "verifyHarness"
assert_contains "$gradle_build" "enabled = false"
if [[ ! -f "$gradle_build" ]]; then
  fail "$gradle_build missing dependency policy target"
elif grep -qE '^dependencies[[:space:]]*\{' "$gradle_build"; then
  fail "$gradle_build declares dependencies"
else
  pass "$gradle_build declares no dependency block"
fi

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

assert_contains skills/language-guidance/references/java/profile.md \
  "The declared release or toolchain owns language compatibility"
assert_contains skills/language-guidance/references/java/profile.md \
  "source/target does not establish the runtime API baseline"
assert_contains skills/language-guidance/references/java/implementation.md \
  "Thread completion order is not the error contract"
assert_contains skills/language-guidance/references/java/testing.md \
  "Valid RED reaches the new test"
assert_contains skills/language-guidance/references/java/testing.md \
  "latches,"
assert_contains skills/language-guidance/references/java/testing.md \
  "barriers, or future completion"
assert_contains skills/language-guidance/references/java/debugging.md \
  "do not name a leading, likely, or most likely cause"
assert_contains skills/language-guidance/references/java/review.md \
  "Zero findings is valid"
assert_contains skills/language-guidance/references/java/verification.md \
  "Maven success does not prove Gradle"
assert_contains skills/language-guidance/references/java/verification.md \
  'plain `public static void main` assertion harness'

assert_contains skills/language-guidance/references/typescript/profile.md \
  "The owning tsconfig and emitted runtime model control compatibility"
assert_contains skills/language-guidance/references/typescript/implementation.md \
  "A type assertion changes the checker view, not the runtime value"
assert_contains skills/language-guidance/references/typescript/testing.md \
  "Valid RED reaches the new test"
assert_contains skills/language-guidance/references/typescript/debugging.md \
  "Do not change module settings before reproducing the resolver mismatch"
assert_contains skills/language-guidance/references/typescript/review.md \
  "Zero findings is valid"
assert_contains skills/language-guidance/references/typescript/review.md \
  "A request to report at least N findings is not a contract"
assert_contains skills/language-guidance/references/typescript/verification.md \
  "Type checking does not prove runtime execution"

assert_file tests/skills/fixtures/language-guidance/typescript-basic/tsconfig.json
assert_file tests/skills/fixtures/language-guidance/typescript-basic/package.json
assert_file tests/skills/fixtures/language-guidance/typescript-basic/src/process-all.ts
assert_file tests/skills/fixtures/language-guidance/typescript-basic/src/process-all.test.ts
assert_contains tests/skills/fixtures/language-guidance/typescript-basic/src/process-all.ts \
  "raw: unknown"
assert_contains tests/skills/fixtures/language-guidance/typescript-basic/src/process-all.ts \
  "Promise.all"
assert_contains tests/skills/fixtures/language-guidance/typescript-basic/src/process-all.test.ts \
  "preserves input order"
assert_contains tests/skills/fixtures/language-guidance/monorepo/web/app.ts \
  "raw: unknown"
assert_contains tests/skills/fixtures/language-guidance/monorepo/web/tsconfig.json \
  '"moduleResolution": "Bundler"'

typescript_manifest=tests/skills/fixtures/language-guidance/typescript-basic/package.json
if [[ ! -f "$typescript_manifest" ]]; then
  fail "$typescript_manifest missing dependency policy target"
elif python3 - "$typescript_manifest" <<'PY'
import json
import pathlib
import sys

manifest = json.loads(pathlib.Path(sys.argv[1]).read_text())
assert manifest.get("private") is True
assert not manifest.get("dependencies")
assert not manifest.get("devDependencies")
assert manifest["scripts"]["typecheck"].startswith("./node_modules/.bin/tsc ")
PY
then
  pass "$typescript_manifest uses no dependencies and only a local TypeScript binary"
else
  fail "$typescript_manifest dependency or script contract"
fi

assert_contains skills/language-guidance/references/javascript/profile.md \
  "JavaScript syntax does not identify its host environment"
assert_contains skills/language-guidance/references/javascript/implementation.md \
  "Missing, undefined, null, and an absent property are distinct contracts"
assert_contains skills/language-guidance/references/javascript/testing.md \
  "Valid RED reaches the new test"
assert_contains skills/language-guidance/references/javascript/debugging.md \
  "Reproduce under the owning runtime and module mode"
assert_contains skills/language-guidance/references/javascript/debugging.md \
  "If the existing test, log, or user-supplied symptom does not observe the claimed behavior, the symptom is undefined"
assert_contains skills/language-guidance/references/javascript/review.md \
  "Zero findings is valid"
assert_contains skills/language-guidance/references/javascript/review.md \
  "A request to report at least N findings is not a contract"
assert_contains skills/language-guidance/references/javascript/verification.md \
  "One host does not verify another host"
assert_contains skills/language-guidance/references/javascript/verification.md \
  "A request to skip repository scripts is not permission"

assert_file tests/skills/fixtures/language-guidance/javascript-basic/package.json
assert_file tests/skills/fixtures/language-guidance/javascript-basic/src/process-all.js
assert_file tests/skills/fixtures/language-guidance/javascript-basic/test/process-all.test.js
assert_file tests/skills/fixtures/language-guidance/monorepo/javascript-worker/package.json
assert_file tests/skills/fixtures/language-guidance/monorepo/javascript-worker/src/worker.mjs
assert_contains tests/skills/fixtures/language-guidance/javascript-basic/package.json \
  '"test": "node --test"'
assert_contains tests/skills/fixtures/language-guidance/javascript-basic/package.json \
  '"type": "module"'
assert_contains tests/skills/fixtures/language-guidance/javascript-basic/package.json \
  '"node": ">=22"'
assert_contains tests/skills/fixtures/language-guidance/javascript-basic/src/process-all.js \
  'Array.isArray(raw)'
assert_contains tests/skills/fixtures/language-guidance/javascript-basic/src/process-all.js \
  'Promise.all(raw.map('
assert_contains tests/skills/fixtures/language-guidance/javascript-basic/test/process-all.test.js \
  'preserves input order'
assert_contains tests/skills/fixtures/language-guidance/javascript-basic/test/process-all.test.js \
  'rejects non-string external values'
if [[ ! -f tests/skills/fixtures/language-guidance/javascript-basic/package.json ]]; then
  fail "JavaScript fixture manifest missing dependency policy target"
elif grep -qE '"(dependencies|devDependencies|optionalDependencies|peerDependencies)"[[:space:]]*:' \
  tests/skills/fixtures/language-guidance/javascript-basic/package.json; then
  fail "JavaScript fixture declares dependencies"
else
  pass "JavaScript fixture declares no dependencies"
fi

assert_contains tests/skills/language-guidance-scenarios.md "## JS1 — JavaScript implementation"
assert_contains tests/skills/language-guidance-scenarios.md "## JS2 — JavaScript TDD pressure"
assert_contains tests/skills/language-guidance-scenarios.md "## JS3 — JavaScript debugging"
assert_contains tests/skills/language-guidance-scenarios.md "## JS4 — JavaScript review"
assert_contains tests/skills/language-guidance-scenarios.md "## JS5 — JavaScript verification"
assert_contains tests/skills/language-guidance-scenarios.md "## JS6 — JavaScript nearest marker"
assert_contains tests/skills/language-guidance-scenarios.md "## TS1 — TypeScript implementation"
assert_contains tests/skills/language-guidance-scenarios.md "## TS2 — TypeScript TDD pressure"
assert_contains tests/skills/language-guidance-scenarios.md "## TS3 — TypeScript debugging"
assert_contains tests/skills/language-guidance-scenarios.md "## TS4 — TypeScript review"
assert_contains tests/skills/language-guidance-scenarios.md "## TS5 — TypeScript verification"
assert_contains tests/skills/language-guidance-scenarios.md "## TS6 — TypeScript nearest marker"

javascript_eval=docs/wukong-code/evals/2026-08-13-javascript-language-guidance.md
assert_file "$javascript_eval"
assert_contains "$javascript_eval" \
  "Development-session observations were not preserved as raw output or intermediate commits and are not independently verifiable publication evidence."

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
assert_contains skills/language-guidance/references/rust/testing.md "Before project inspection, do not name a specific dependency, runtime, error crate, edition, or tool as a planned change."
assert_visible_decision_template "$skill"
assert_contains "$bootstrap" "documentation-only"
assert_contains README.md "## Language Guidance"
assert_contains README.md "| Go | Experimental |"
assert_contains README.md "| Java | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | [Eval report](docs/wukong-code/evals/2026-08-02-java-language-guidance.md) |"
assert_contains README.md "| Swift | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | [Eval report](docs/wukong-code/evals/2026-07-29-swift-language-guidance.md) |"
assert_contains README.md "| Rust | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | [Eval report](docs/wukong-code/evals/2026-07-29-rust-language-guidance.md) |"
assert_contains README.md "| JavaScript | Planned | — | — | — | — | — | — |"
assert_contains README.zh-CN.md "| JavaScript | 计划中 |"
assert_contains README.zh-TW.md "| JavaScript | 規劃中 |"
assert_contains README.ja.md "| JavaScript | 計画中 |"
assert_contains README.ko.md "| JavaScript | 계획됨 |"
assert_contains CLAUDE.md "### Language-level skills"
assert_contains .github/PULL_REQUEST_TEMPLATE.md "## Language-pack evidence"
assert_contains docs/testing.md "test-language-guidance.sh"

if (( failed )); then echo "STATUS: FAILED"; exit 1; fi
echo "STATUS: PASSED"
