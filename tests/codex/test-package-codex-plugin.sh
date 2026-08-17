#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SCRIPT_UNDER_TEST="$REPO_ROOT/scripts/package-codex-plugin.sh"

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

assert_equals() {
  local actual="$1"
  local expected="$2"
  local description="$3"

  if [[ "$actual" == "$expected" ]]; then
    pass "$description"
  else
    fail "$description"
    echo "    expected: $expected"
    echo "    actual:   $actual"
  fi
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local description="$3"

  if printf '%s' "$haystack" | grep -Fq -- "$needle"; then
    pass "$description"
  else
    fail "$description"
    echo "    expected to find: $needle"
  fi
}

assert_not_matches() {
  local haystack="$1"
  local pattern="$2"
  local description="$3"

  if printf '%s' "$haystack" | grep -Eq -- "$pattern"; then
    fail "$description"
    echo "    did not expect to match: $pattern"
  else
    pass "$description"
  fi
}

list_archive() {
  local archive_path="$1"

  case "$archive_path" in
    *.tar.gz|*.tgz)
      tar -tzf "$archive_path"
      ;;
    *.zip)
      unzip -Z1 "$archive_path"
      ;;
    *)
      unzip -Z1 "$archive_path"
      ;;
  esac
}

normalize_archive_paths() {
  sed 's#/$##' | LC_ALL=C sort
}

extract_archive() {
  local archive_path="$1"
  local destination="$2"

  mkdir -p "$destination"
  case "$archive_path" in
    *.tar.gz|*.tgz)
      tar -xzf "$archive_path" -C "$destination"
      ;;
    *.zip)
      unzip -q "$archive_path" -d "$destination"
      ;;
    *)
      unzip -q "$archive_path" -d "$destination"
      ;;
  esac
}

read_archive_file() {
  local archive_path="$1"
  local file_path="$2"

  case "$archive_path" in
    *.tar.gz|*.tgz)
      tar -xOf "$archive_path" "$file_path"
      ;;
    *.zip)
      unzip -p "$archive_path" "$file_path"
      ;;
    *)
      unzip -p "$archive_path" "$file_path"
      ;;
  esac
}

write_metadata_fixture() {
  local destination="$1"
  local skill

  while IFS= read -r skill; do
    mkdir -p "$destination/skills/$skill/agents"
    cat >"$destination/skills/$skill/agents/openai.yaml" <<EOF
interface:
  display_name: "$skill"
  short_description: "Fixture metadata for $skill"
EOF
  done < <(find "$REPO_ROOT/skills" -mindepth 1 -maxdepth 1 -type d -print | sed 's#.*/##' | sort)
}

echo "Codex package archive tests"

# Package the candidate working tree without mutating the real index or HEAD.
# The packaging script intentionally archives a Git ref, even with
# `--allow-dirty`, so using HEAD here would test stale committed content.
candidate_index="$TEST_ROOT/candidate-index"
GIT_INDEX_FILE="$candidate_index" git -C "$REPO_ROOT" read-tree HEAD
GIT_INDEX_FILE="$candidate_index" git -C "$REPO_ROOT" add --all
candidate_tree="$(GIT_INDEX_FILE="$candidate_index" git -C "$REPO_ROOT" write-tree)"
candidate_ref="$(
  GIT_AUTHOR_NAME="Wukong Code Tests" \
  GIT_AUTHOR_EMAIL="tests@wukong-code.local" \
  GIT_COMMITTER_NAME="Wukong Code Tests" \
  GIT_COMMITTER_EMAIL="tests@wukong-code.local" \
    git -C "$REPO_ROOT" commit-tree "$candidate_tree" -p HEAD \
      -m "Temporary Codex packaging candidate"
)"

metadata_source="$TEST_ROOT/metadata-source"
archive="$TEST_ROOT/wukong-code"
tar_archive="$TEST_ROOT/wukong-code.tar.gz"
extracted="$TEST_ROOT/extracted"
tar_extracted="$TEST_ROOT/tar-extracted"
write_metadata_fixture "$metadata_source"
rm -rf "$metadata_source/skills/language-guidance"

source_hooks="$(python3 -c 'import json; print(json.load(open("'"$REPO_ROOT"'/.codex-plugin/plugin.json")).get("hooks"))')"
assert_equals "$source_hooks" "./hooks/hooks-codex.json" "source Codex manifest declares its SessionStart hook"

if output="$("$SCRIPT_UNDER_TEST" --allow-dirty --ref "$candidate_ref" --metadata-source "$metadata_source" --output "$archive" 2>&1)"; then
  pass "package script exits successfully"
else
  fail "package script exits successfully"
  printf '%s\n' "$output" | sed 's/^/      /'
fi

if [[ -f "$archive" ]]; then
  pass "package script writes archive"
else
  fail "package script writes archive"
fi

assert_contains "$output" "Archive:" "reports archive path"
assert_contains "$output" "Format:  zip" "reports default zip format"
assert_contains "$output" "SHA-256:" "reports archive checksum"

extract_archive "$archive" "$extracted"

archive_paths="$(list_archive "$archive" | normalize_archive_paths)"
unexpected_pattern='(^wukong-code/|^\.agents/|^package\.json$|^\.git|^\.pytest_cache|^\.ruff_cache|^tests/|^docs/|^evals/|^lib/|^\.claude|^\.cursor|^\.kimi|^\.opencode|^\.pi|^AGENTS\.md$|^CLAUDE\.md$|^GEMINI\.md$|^RELEASE-NOTES\.md$|^CHANGELOG\.md$)'
assert_not_matches "$archive_paths" "$unexpected_pattern" "archive excludes source-only paths"
assert_contains "$archive_paths" ".codex-plugin/plugin.json" "archive includes Codex manifest"
assert_contains "$archive_paths" "hooks/hooks-codex.json" "archive includes Codex hook configuration"
assert_contains "$archive_paths" "hooks/run-hook.cmd" "archive includes Codex hook dispatcher"
assert_contains "$archive_paths" "hooks/session-start" "archive includes Codex SessionStart script"
assert_contains "$archive_paths" "hooks/user-prompt-submit" "archive includes Codex UserPromptSubmit router"
assert_contains "$archive_paths" "hooks/user-prompt-submit.py" "archive includes Codex language router implementation"
if printf '%s' "$archive_paths" | grep -Fxq "hooks/hooks.json"; then
  fail "archive excludes cross-harness hook configuration"
else
  pass "archive excludes cross-harness hook configuration"
fi
assert_contains "$archive_paths" "skills/brainstorming/SKILL.md" "archive includes skills"
assert_contains "$archive_paths" "skills/product-design/SKILL.md" "archive includes namespaced Product Design router"
if printf '%s' "$archive_paths" | grep -Fxq "skills/index/SKILL.md"; then
  fail "archive excludes legacy generic Product Design router"
else
  pass "archive excludes legacy generic Product Design router"
fi
if printf '%s' "$archive_paths" | grep -Fxq "skills/frontend-design/SKILL.md"; then
  fail "archive excludes removed standalone frontend-design skill"
else
  pass "archive excludes removed standalone frontend-design skill"
fi
assert_contains "$archive_paths" \
  "skills/product-design-ideate/references/original-visual-direction.md" \
  "archive includes folded original visual-direction guidance"
assert_contains "$archive_paths" \
  "references/licenses/frontend-design-APACHE-2.0.txt" \
  "archive includes frontend-design Apache license"
for swift_phase in profile implementation testing debugging review verification; do
  assert_contains "$archive_paths" \
    "skills/language-guidance/references/swift/$swift_phase.md" \
    "archive includes Swift $swift_phase reference"
done
for rust_phase in profile implementation testing debugging review verification; do
  assert_contains "$archive_paths" \
    "skills/language-guidance/references/rust/$rust_phase.md" \
    "archive includes Rust $rust_phase reference"
done
for java_phase in profile implementation testing debugging review verification; do
  assert_contains "$archive_paths" \
    "skills/language-guidance/references/java/$java_phase.md" \
    "archive includes Java $java_phase reference"
done
assert_contains "$archive_paths" "skills/brainstorming/agents/openai.yaml" "archive includes OpenAI skill metadata"
assert_contains "$archive_paths" "skills/language-guidance/agents/openai.yaml" "archive keeps source metadata"
language_metadata="$(read_archive_file "$archive" skills/language-guidance/agents/openai.yaml)"
assert_contains "$language_metadata" "display_name: \"Language Guidance\"" "uses source metadata"
assert_contains "$archive_paths" "assets/app-icon.png" "archive includes app icon"
assert_contains "$archive_paths" "assets/wukong-code-small.svg" "archive includes composer icon"
assert_contains "$archive_paths" "assets/readme/hero.png" "archive includes published README hero"
assert_contains "$archive_paths" "assets/readme/workflow.svg" "archive includes published README workflow"
if printf '%s' "$archive_paths" | grep -Fq "assets/readme/source/"; then
  fail "archive excludes README source intermediates"
else
  pass "archive excludes README source intermediates"
fi
assert_contains "$archive_paths" "references/critical-overrides.md" "archive includes Product Design shared references"
assert_contains "$archive_paths" "scripts/bootstrap-prototype.mjs" "archive includes Product Design bootstrap script"
assert_contains "$archive_paths" "scripts/check-product-design-import.mjs" "archive includes Product Design integrity check"
assert_contains "$archive_paths" "scripts/check-sites-starter-contract.mjs" "archive includes Product Design template contract check"
assert_contains "$archive_paths" "templates/prototype/package.json" "archive includes Product Design web starter"
assert_contains "$archive_paths" "templates/mobile-app/package.json" "archive includes Product Design mobile starter"
assert_contains "$archive_paths" "product-design.lock.json" "archive includes Product Design provenance lock"
assert_contains "$archive_paths" "THIRD_PARTY_NOTICES.md" "archive includes third-party license boundary"

if integrity_output="$(node "$extracted/scripts/check-product-design-import.mjs" --root "$extracted" 2>&1)"; then
  pass "packaged Product Design content matches its integrity lock"
else
  fail "packaged Product Design content matches its integrity lock"
  printf '%s\n' "$integrity_output" | sed 's/^/    /'
fi

unexpected_product_design_scripts="$(
  printf '%s\n' "$archive_paths" |
    awk '$0 ~ /^scripts\// && $0 != "scripts/bootstrap-prototype.mjs" && $0 != "scripts/check-product-design-import.mjs" && $0 != "scripts/check-sites-starter-contract.mjs"'
)"
assert_equals "$unexpected_product_design_scripts" "" "archive excludes unrelated root scripts"

manifest_summary="$(read_archive_file "$archive" .codex-plugin/plugin.json | python3 -c 'import json,sys; data=json.load(sys.stdin); print("\t".join([data["name"], data["version"], data["skills"], str(data.get("hooks"))]))')"
expected_version="$(python3 -c 'import json; print(json.load(open("'"$REPO_ROOT"'/.codex-plugin/plugin.json"))["version"])')"
assert_equals "$manifest_summary" "wukong-code	$expected_version	./skills/	$source_hooks" "archive manifest preserves source hooks"

skill_count="$(find "$extracted/skills" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"
metadata_count="$(find "$extracted/skills" -path '*/agents/openai.yaml' -type f | wc -l | tr -d ' ')"
assert_equals "$metadata_count" "$skill_count" "every packaged skill has OpenAI metadata"

if [[ -x "$extracted/skills/subagent-driven-development/scripts/task-brief" ]]; then
  pass "archive preserves executable script mode"
else
  fail "archive preserves executable script mode"
fi

zip_times="$(python3 - "$archive" <<'PY'
import sys
import zipfile

with zipfile.ZipFile(sys.argv[1]) as archive:
    print("\n".join(sorted({str(info.date_time) for info in archive.infolist()})))
PY
)"
assert_equals "$zip_times" "(1980, 1, 1, 0, 0, 0)" "zip archive normalizes entry timestamps"

if tar_output="$("$SCRIPT_UNDER_TEST" --allow-dirty --ref "$candidate_ref" --metadata-source "$metadata_source" --format tar.gz --output "$tar_archive" 2>&1)"; then
  pass "package script writes explicit tar.gz archive"
else
  fail "package script writes explicit tar.gz archive"
  printf '%s\n' "$tar_output" | sed 's/^/      /'
fi
assert_contains "$tar_output" "Format:  tar.gz" "reports explicit tar.gz format"

extract_archive "$tar_archive" "$tar_extracted"
tar_archive_paths="$(list_archive "$tar_archive" | normalize_archive_paths)"
assert_equals "$tar_archive_paths" "$archive_paths" "zip and tar.gz archives contain the same paths"

tar_task_brief_mode="$(tar -tzvf "$tar_archive" skills/subagent-driven-development/scripts/task-brief | awk '{print $1}')"
assert_equals "$tar_task_brief_mode" "-rwxr-xr-x" "tar.gz archive preserves executable script mode"

tar_metadata_times="$(python3 - "$tar_archive" <<'PY'
import sys
import tarfile

with tarfile.open(sys.argv[1], "r:gz") as archive:
    print("\\n".join(sorted({str(member.mtime) for member in archive.getmembers()})))
PY
)"
assert_equals "$tar_metadata_times" "0" "tar.gz archive normalizes entry timestamps"

metadata_archive="$TEST_ROOT/metadata-source.tar.gz"
metadata_zip="$TEST_ROOT/metadata-source.zip"
archive_from_tar_source="$TEST_ROOT/wukong-code-from-tar-source.zip"
archive_from_zip_source="$TEST_ROOT/wukong-code-from-zip-source.zip"
(
  cd "$metadata_source"
  tar -czf "$metadata_archive" .
  zip -X -q -r "$metadata_zip" .
)

if output="$("$SCRIPT_UNDER_TEST" --allow-dirty --ref "$candidate_ref" --metadata-source "$metadata_archive" --output "$archive_from_tar_source" 2>&1)"; then
  pass "package script accepts tarball metadata source"
else
  fail "package script accepts tarball metadata source"
  printf '%s\n' "$output" | sed 's/^/      /'
fi

if cmp -s "$archive" "$archive_from_tar_source"; then
  pass "tarball metadata source produces identical archive"
else
  fail "tarball metadata source produces identical archive"
fi

if output="$("$SCRIPT_UNDER_TEST" --allow-dirty --ref "$candidate_ref" --metadata-source "$metadata_zip" --output "$archive_from_zip_source" 2>&1)"; then
  pass "package script accepts zip metadata source"
else
  fail "package script accepts zip metadata source"
  printf '%s\n' "$output" | sed 's/^/      /'
fi

if cmp -s "$archive" "$archive_from_zip_source"; then
  pass "zip metadata source produces identical archive"
else
  fail "zip metadata source produces identical archive"
fi

incomplete_metadata="$TEST_ROOT/incomplete-metadata"
mkdir -p "$incomplete_metadata/skills/brainstorming/agents"
cp "$metadata_source/skills/brainstorming/agents/openai.yaml" \
  "$incomplete_metadata/skills/brainstorming/agents/openai.yaml"

set +e
missing_output="$("$SCRIPT_UNDER_TEST" --allow-dirty --ref "$candidate_ref" --metadata-source "$incomplete_metadata" --output "$TEST_ROOT/missing.tar.gz" 2>&1)"
missing_status=$?
set -e
if [[ "$missing_status" -ne 0 ]]; then
  pass "package script rejects incomplete metadata source"
else
  fail "package script rejects incomplete metadata source"
fi
assert_contains "$missing_output" "ERROR: metadata source is incomplete" "incomplete metadata reports clear error"

dirty_repo="$TEST_ROOT/dirty-repo"
git clone -q --no-local "$REPO_ROOT" "$dirty_repo"
printf '\n# dirty fixture\n' >>"$dirty_repo/README.md"
set +e
dirty_output="$(
  cd "$dirty_repo"
  scripts/package-codex-plugin.sh \
    --metadata-source "$metadata_source" \
    --output "$TEST_ROOT/dirty.zip" 2>&1
)"
dirty_status=$?
set -e
if [[ "$dirty_status" -ne 0 ]]; then
  pass "package script rejects dirty worktree by default"
else
  fail "package script rejects dirty worktree by default"
fi
assert_contains "$dirty_output" "Working tree has uncommitted changes:" "dirty worktree reports changed files"

if [[ "$FAILURES" -eq 0 ]]; then
  echo "All Codex package archive tests passed"
else
  echo "$FAILURES Codex package archive test(s) failed"
  exit 1
fi
