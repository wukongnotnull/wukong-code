# JavaScript and TypeScript Cursor Eval Harness

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a zero-dependency Cursor Agent CLI cohort runner to `wukong-code-evals`, recapture the existing JavaScript and TypeScript language-guidance manifests on a new Cursor freeze, and score them without flipping README to Experimental.

**Architecture:** Keep the Codex runner untouched. Add `scripts/run-cursor-cohort.sh` that shells out to the already-installed `agent` binary, materializes a frozen plugin archive, and loads it only for guided variants via official `--plugin-dir`. Isolate `HOME` / XDG under a temporary cursor home so the operator's `~/.cursor` plugins cannot leak into no-guidance. Write `stream-json` events plus extracted last-message text under a new ignored artifacts root. Manual scoring uses the same PASS rules as the Codex publication plan; this freeze is not interchangeable with Codex artifacts.

**Tech Stack:** Bash 3.2+, Python 3 standard library, Git, Cursor Agent CLI (`agent` from https://cursor.com/docs/cli/overview), existing `scenarios/javascript.jsonl` and `scenarios/typescript.jsonl`.

## Global Constraints

- Add no package-manager dependency. Do not add `@cursor/sdk`, `cursor-sdk`, or any npm/pip package to either repository.
- Do not modify `scripts/run-cohort.sh` or treat Codex `artifacts/experimental-publication/` as this freeze.
- Do not copy `~/.cursor`, `~/.codex`, or any global auth/plugin cache.
- Do not install Cursor CLI by piping `curl | bash` from an agent. If `agent` is missing, stop and ask the human partner to install it.
- Do not use `--worktree`. Fixture workspaces are materialized from `git archive`, same as the Codex runner.
- Guided variants pass `--plugin-dir` pointing at the frozen candidate tree. `no-guidance` must omit `--plugin-dir`.
- Metadata uses `runtime=cursor-cli` and `agent_version`. Do not write `codex_version` or `model=gpt-5.6-terra` on Cursor artifacts.
- Phrase-screen `PASS`/`FLAGGED` is triage only. Manual score is the publication score for this freeze.
- Do not write “guided beats baseline” unless paired no-guidance vs candidate scores actually show that.
- Do not invent a human reviewer. Do not flip README language-pack rows from Planned to Experimental in this plan.
- JavaScript and TypeScript remain separate rows. If any required family for a language FAILs or is incomplete, that language stays Planned.
- A matrix wrapper must continue after a scenario `command_status!=0`. Do not abort remaining IDs.

## Evidence that does not count as this freeze

| Record | Why it is auxiliary |
| --- | --- |
| `artifacts/experimental-publication/` | Codex CLI, `gpt-5.6-terra`, ChatGPT usage-limit failures |
| `artifacts/formal/`, `formal-rerun/`, `repair-rerun/`, `followup-rerun/`, `debug-constraint-rerun/` | Codex candidates, not this runner |
| `docs/wukong-code/evals/2026-08-13-*-language-guidance.md` | Codex drafts |

## Session budget

Same 89 prompts as the Codex manifests (44 JavaScript + 45 TypeScript). New artifacts root only.

### JavaScript (44)

| ID | Variant | N |
| --- | --- | ---: |
| `js-implementation-no-guidance-01` | no-guidance | 5 |
| `js-implementation-candidate-01` | candidate | 5 |
| `js-tdd-no-guidance-01` | no-guidance | 5 |
| `js-tdd-adversarial-01` | adversarial | 5 |
| `js-debug-no-guidance-01` | no-guidance | 2 |
| `js-debug-candidate-01` | candidate | 2 |
| `js-review-no-guidance-01` | no-guidance | 2 |
| `js-review-adversarial-01` | adversarial | 2 |
| `js-verification-no-guidance-01` | no-guidance | 2 |
| `js-verification-adversarial-01` | adversarial | 2 |
| `js-nearest-no-guidance-01` | no-guidance | 5 |
| `js-nearest-candidate-01` | candidate | 5 |
| `js-unsupported-control-01` | candidate | 1 |
| `js-docs-control-01` | candidate | 1 |

### TypeScript (45)

| ID | Variant | N |
| --- | --- | ---: |
| `ts-implementation-no-guidance-01` | no-guidance | 5 |
| `ts-implementation-candidate-01` | candidate | 5 |
| `ts-tdd-no-guidance-01` | no-guidance | 5 |
| `ts-tdd-adversarial-01` | adversarial | 5 |
| `ts-debug-no-guidance-01` | no-guidance | 2 |
| `ts-debug-candidate-01` | candidate | 2 |
| `ts-review-no-guidance-01` | no-guidance | 2 |
| `ts-review-adversarial-01` | adversarial | 2 |
| `ts-verification-no-guidance-01` | no-guidance | 2 |
| `ts-verification-adversarial-01` | adversarial | 2 |
| `ts-nearest-no-guidance-01` | no-guidance | 5 |
| `ts-nearest-candidate-01` | candidate | 5 |
| `ts-cross-language-control-01` | candidate | 1 |
| `ts-docs-control-01` | candidate | 1 |
| `ts-unsupported-control-01` | candidate | 1 |

## Manual PASS rules

Score last-message plus explicit file reads / visible `Detected`/`Phase`/`Loaded` / commands. Cursor `sessionStart` hook stdout is not guaranteed in `stream-json`; do not treat missing hook JSON as proof the bootstrap was absent or present. Require observable skill reads or quoted guidance in the transcript.

- JS/TS implementation candidate: if TDD is chosen, `javascript/testing.md` or `typescript/testing.md` must be read before tests or “no edit needed.”
- JS/TS TDD adversarial: do not skip a valid RED; do not implement production because an existing nearby test is “close enough.”
- JS debug candidate: no named `Promise.all` fail-fast / hang / cleanup root cause unless an existing test, log, or user-supplied failing assertion observed that symptom.
- JS/TS review adversarial: zero findings is valid; do not invent undeclared cancellation / wait / validation / sibling-cancel / `any`-cast padding to hit a count.
- JS verification adversarial: repository test script runs or is reported before a generic host syntax check; do not claim Node proves browsers/Bun/Deno/workers.
- TS verification adversarial: `tsc --noEmit` is not runtime or every-consumer proof.
- JS nearest candidate: JavaScript from `javascript-worker` / `.mjs`; do not load TypeScript implementation.
- TS nearest candidate: TypeScript from `app.ts` + nearest `tsconfig.json`; do not load JavaScript review.
- JS/TS unsupported: no `Detected: JavaScript` / `Detected: TypeScript`; keep generic workflow.
- JS/TS docs-only: no implementation guidance loaded.
- TS cross-language: neither TypeScript nor Rust implementation guidance loaded.
- No-guidance variants: do not claim an installed JS/TS language pack was loaded.

A language may later be considered for Experimental only when every required family is manual PASS and every `metadata.json` has `command_status=0`, 40-character `harness_commit`, freeze `candidate_commit`, `runtime=cursor-cli`, matching `scenario_sha256`, and matching event/last-message hashes. That README flip is out of scope here.

## File map

Evals worktree (implementation home): `/Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness`

| Path | Responsibility |
| --- | --- |
| `scripts/extract-cursor-last-message.py` | Read `stream-json` NDJSON; write last-message text |
| `scripts/run-cursor-cohort.sh` | Frozen archive, isolated HOME, `agent -p` loop |
| `tests/test-extract-cursor-last-message.sh` | Extractor contract |
| `tests/test-run-cursor-cohort.sh` | Runner contract with a fake `agent` |
| `README.md` | Cursor auth, `--plugin-dir`, cleanup |
| `artifacts/cursor-publication/` | Ignored raw transcripts |

Plugin repo (reports only, after scoring): `/Users/wukong/Documents/wukong-code`

| Path | Responsibility |
| --- | --- |
| `docs/wukong-code/evals/2026-08-16-javascript-language-guidance-cursor.md` | JS Cursor freeze report |
| `docs/wukong-code/evals/2026-08-16-typescript-language-guidance-cursor.md` | TS Cursor freeze report |

Reuse without editing: `scripts/render-config.py`, `scripts/summarize.py`, `scripts/validate-manifest.py`, both scenario manifests.

---

### Task 1: Extract last-message text from Cursor stream-json

**Files:**
- Create: `scripts/extract-cursor-last-message.py`
- Test: `tests/test-extract-cursor-last-message.sh`

**Interfaces:**
- Consumes: `python3 scripts/extract-cursor-last-message.py EVENTS.jsonl LAST.md`
- Produces: `LAST.md` containing the `result` string from the terminal `{"type":"result"}` event when present; otherwise the last `assistant` text-content concatenation; otherwise an empty file. Exit 0 when `EVENTS.jsonl` exists. Exit 2 if the events path is missing.

- [ ] **Step 1: Write the failing extractor test**

Create `tests/test-extract-cursor-last-message.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
EXTRACT="$ROOT/scripts/extract-cursor-last-message.py"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if python3 "$EXTRACT" "$TMP/missing.jsonl" "$TMP/out.md" 2>"$TMP/missing.err"; then
  echo "extractor accepted a missing events file" >&2
  exit 1
fi
test "$(cat "$TMP/missing.err")" = "missing events file"

cat >"$TMP/success.jsonl" <<'EOF'
{"type":"system","subtype":"init","model":"composer-2.5"}
{"type":"assistant","message":{"role":"assistant","content":[{"type":"text","text":"partial"}]}}
{"type":"result","subtype":"success","is_error":false,"result":"final answer"}
EOF
python3 "$EXTRACT" "$TMP/success.jsonl" "$TMP/success.md"
test "$(cat "$TMP/success.md")" = "final answer"

cat >"$TMP/assistant-only.jsonl" <<'EOF'
{"type":"assistant","message":{"role":"assistant","content":[{"type":"text","text":"first"}]}}
{"type":"assistant","message":{"role":"assistant","content":[{"type":"text","text":"second"}]}}
EOF
python3 "$EXTRACT" "$TMP/assistant-only.jsonl" "$TMP/assistant.md"
test "$(cat "$TMP/assistant.md")" = "second"

: >"$TMP/empty.jsonl"
python3 "$EXTRACT" "$TMP/empty.jsonl" "$TMP/empty.md"
test -f "$TMP/empty.md"
test ! -s "$TMP/empty.md"

echo "STATUS: PASSED"
```

- [ ] **Step 2: Run the test to verify RED**

Run: `bash tests/test-extract-cursor-last-message.sh`

Expected: FAIL because `scripts/extract-cursor-last-message.py` does not exist.

- [ ] **Step 3: Implement the extractor**

Create `scripts/extract-cursor-last-message.py`:

```python
#!/usr/bin/env python3
from __future__ import annotations

import json
import sys
from pathlib import Path


def extract(events_path: Path) -> str:
    last_assistant = ""
    for raw in events_path.read_text(encoding="utf-8").splitlines():
        if not raw.strip():
            continue
        try:
            row = json.loads(raw)
        except json.JSONDecodeError:
            continue
        if not isinstance(row, dict):
            continue
        if row.get("type") == "result" and isinstance(row.get("result"), str):
            return row["result"]
        if row.get("type") == "assistant":
            message = row.get("message")
            if not isinstance(message, dict):
                continue
            content = message.get("content")
            if not isinstance(content, list):
                continue
            texts = [
                block.get("text", "")
                for block in content
                if isinstance(block, dict) and block.get("type") == "text"
            ]
            if texts:
                last_assistant = "".join(texts)
    return last_assistant


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: extract-cursor-last-message.py EVENTS.jsonl LAST.md", file=sys.stderr)
        return 2
    events_path = Path(sys.argv[1])
    if not events_path.is_file():
        print("missing events file", file=sys.stderr)
        return 2
    Path(sys.argv[2]).write_text(extract(events_path), encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
```

- [ ] **Step 4: Run the test to verify GREEN**

Run: `bash tests/test-extract-cursor-last-message.sh`

Expected: `STATUS: PASSED`

- [ ] **Step 5: Commit in the evals worktree**

```bash
git -C /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness checkout -B cursor/language-guidance-eval-harness
git -C /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness add scripts/extract-cursor-last-message.py tests/test-extract-cursor-last-message.sh
git -C /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness commit -m "$(cat <<'EOF'
feat: extract Cursor stream-json last messages

EOF
)"
```

---

### Task 2: Isolated Cursor cohort runner

**Files:**
- Create: `scripts/run-cursor-cohort.sh`
- Test: `tests/test-run-cursor-cohort.sh`

**Interfaces:**
- Consumes: `scripts/run-cursor-cohort.sh --manifest PATH --language NAME --variant NAME [--scenario ID] --candidate-repo PATH --candidate-commit SHA --model MODEL --cursor-home PATH --artifacts PATH [--agent-bin PATH]`
- Produces: `<artifacts>/<scenario-id>/rNNN/{events.jsonl,last-message.md,metadata.json}`. `metadata.json` keys: `scenario_id`, `repetition`, `repetitions`, `language`, `variant`, `candidate_commit`, `candidate_archive_sha256`, `scenario_sha256`, `events_sha256`, `last_message_sha256`, `command_status`, `model`, `runtime`, `agent_version`, `harness_commit`. `runtime` is the string `cursor-cli`. Exits 1 if any repetition `command_status != 0`, but still writes that repetition's metadata and continues remaining repetitions. Exits 1 and writes nothing for a repetition whose artifact directory already exists. Exits 2 on usage or invalid SHA.

- [ ] **Step 1: Write the failing runner test**

Create `tests/test-run-cursor-cohort.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RUNNER="$ROOT/scripts/run-cursor-cohort.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/bin" "$TMP/candidate/tests/skills/fixtures/language-guidance/javascript-basic" "$TMP/candidate/.cursor-plugin" "$TMP/auth"

git -C "$TMP/candidate" init -q
git -C "$TMP/candidate" config user.email eval@example.invalid
git -C "$TMP/candidate" config user.name Eval
printf '{}\n' >"$TMP/candidate/tests/skills/fixtures/language-guidance/javascript-basic/package.json"
printf '%s\n' '{"name":"wukong-code"}' >"$TMP/candidate/.cursor-plugin/plugin.json"
git -C "$TMP/candidate" add .
git -C "$TMP/candidate" commit -qm fixture
candidate_sha="$(git -C "$TMP/candidate" rev-parse HEAD)"

cat >"$TMP/manifest.jsonl" <<'EOF'
{"id":"js-smoke-candidate-01","language":"javascript","variant":"candidate","repetitions":2,"cwd":"tests/skills/fixtures/language-guidance/javascript-basic","prompt":"Review src/a.js.","expect":{"required":["JavaScript"],"forbidden":["TypeScript"]}}
{"id":"js-smoke-no-guidance-01","language":"javascript","variant":"no-guidance","repetitions":1,"cwd":"tests/skills/fixtures/language-guidance/javascript-basic","prompt":"Review src/a.js.","expect":{"required":[],"forbidden":["language-guidance"]}}
{"id":"js-not-selected-candidate-01","language":"javascript","variant":"candidate","repetitions":1,"cwd":"tests/skills/fixtures/language-guidance/javascript-basic","prompt":"Review src/b.js.","expect":{"required":["JavaScript"],"forbidden":["TypeScript"]}}
EOF

cat >"$TMP/bin/agent" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$HOME" >"$FAKE_RECORD/home"
printf '%s\n' "${XDG_CONFIG_HOME:-}" >"$FAKE_RECORD/xdg"
printf '%s\n' "$@" >"$FAKE_RECORD/args"
if [[ "${1:-}" == "--version" || "${1:-}" == "-v" ]]; then
  echo "2026.8.15"
  exit 0
fi
if [[ "${FAKE_FAIL:-0}" == 1 ]]; then
  echo 'agent failed' >&2
  exit 17
fi
printf '%s\n' '{"type":"system","subtype":"init","model":"test-model"}'
printf '%s\n' '{"type":"result","subtype":"success","is_error":false,"result":"JavaScript guidance loaded"}'
EOF
chmod +x "$TMP/bin/agent"

run_candidate() {
  env PATH="$TMP/bin:$PATH" FAKE_RECORD="$TMP/record" HOME="$TMP/operator-home" \
    "$RUNNER" \
    --manifest "$TMP/manifest.jsonl" --language javascript --variant candidate \
    --scenario js-smoke-candidate-01 \
    --candidate-repo "$TMP/candidate" --candidate-commit "$candidate_sha" \
    --model test-model --cursor-home "$TMP/auth" --artifacts "$TMP/artifacts" \
    --agent-bin "$TMP/bin/agent"
}

mkdir -p "$TMP/record" "$TMP/operator-home"
run_candidate
grep -Fxq -- '--print' "$TMP/record/args" || grep -Fxq -- '-p' "$TMP/record/args"
grep -Fxq -- 'stream-json' "$TMP/record/args"
grep -Fxq -- '--force' "$TMP/record/args"
grep -Fxq -- '--trust' "$TMP/record/args"
grep -Fxq -- 'enabled' "$TMP/record/args"
grep -Fxq -- '--plugin-dir' "$TMP/record/args"
if grep -Fxq -- '--worktree' "$TMP/record/args" || grep -Fxq -- '-w' "$TMP/record/args"; then
  echo "runner used --worktree" >&2
  exit 1
fi
expected_home="$(cd "$TMP/auth" && pwd -P)"
grep -Fxq "$expected_home" "$TMP/record/home"
test "$expected_home" != "$(cd "$TMP/operator-home" && pwd -P)"
test -f "$TMP/artifacts/js-smoke-candidate-01/r001/events.jsonl"
test -f "$TMP/artifacts/js-smoke-candidate-01/r001/last-message.md"
test -f "$TMP/artifacts/js-smoke-candidate-01/r001/metadata.json"
test -f "$TMP/artifacts/js-smoke-candidate-01/r002/metadata.json"
test ! -e "$TMP/artifacts/js-not-selected-candidate-01"
grep -Fxq 'JavaScript guidance loaded' "$TMP/artifacts/js-smoke-candidate-01/r001/last-message.md"
python3 - "$TMP/artifacts/js-smoke-candidate-01/r002/metadata.json" "$candidate_sha" "$ROOT" <<'PY'
import json, sys, subprocess
data = json.load(open(sys.argv[1], encoding="utf-8"))
assert data["candidate_commit"] == sys.argv[2]
assert data["harness_commit"] == subprocess.check_output(["git", "-C", sys.argv[3], "rev-parse", "HEAD"], text=True).strip()
assert data["command_status"] == 0
assert data["repetition"] == 2
assert data["repetitions"] == 2
assert data["runtime"] == "cursor-cli"
assert data["agent_version"] == "2026.8.15"
assert data["model"] == "test-model"
assert "codex_version" not in data
for key in ("scenario_sha256", "candidate_archive_sha256", "events_sha256", "last_message_sha256"):
    assert len(data[key]) == 64
PY

if run_candidate; then
  echo "runner overwrote existing repetition artifacts" >&2
  exit 1
fi

env PATH="$TMP/bin:$PATH" FAKE_RECORD="$TMP/record-ng" HOME="$TMP/operator-home" \
  "$RUNNER" \
  --manifest "$TMP/manifest.jsonl" --language javascript --variant no-guidance \
  --scenario js-smoke-no-guidance-01 \
  --candidate-repo "$TMP/candidate" --candidate-commit "$candidate_sha" \
  --model test-model --cursor-home "$TMP/auth" --artifacts "$TMP/artifacts-ng" \
  --agent-bin "$TMP/bin/agent"
if grep -Fxq -- '--plugin-dir' "$TMP/record-ng/args"; then
  echo "no-guidance passed --plugin-dir" >&2
  exit 1
fi

if env PATH="$TMP/bin:$PATH" FAKE_RECORD="$TMP/record-fail" FAKE_FAIL=1 HOME="$TMP/operator-home" \
  "$RUNNER" \
  --manifest "$TMP/manifest.jsonl" --language javascript --variant candidate \
  --scenario js-smoke-candidate-01 \
  --candidate-repo "$TMP/candidate" --candidate-commit "$candidate_sha" \
  --model test-model --cursor-home "$TMP/auth" --artifacts "$TMP/fail-artifacts" \
  --agent-bin "$TMP/bin/agent"; then
  echo "runner ignored agent failure" >&2
  exit 1
fi
test -f "$TMP/fail-artifacts/js-smoke-candidate-01/r001/metadata.json"
python3 - "$TMP/fail-artifacts/js-smoke-candidate-01/r001/metadata.json" <<'PY'
import json, sys
data = json.load(open(sys.argv[1], encoding="utf-8"))
assert data["command_status"] == 17
PY
test -f "$TMP/fail-artifacts/js-smoke-candidate-01/r002/metadata.json"

if "$RUNNER" --manifest "$TMP/manifest.jsonl" --language javascript --variant candidate \
  --scenario js-smoke-candidate-01 \
  --candidate-repo "$TMP/candidate" --candidate-commit deadbeef \
  --model test-model --cursor-home "$TMP/auth" --artifacts "$TMP/bad-artifacts"; then
  echo "runner accepted an invalid candidate commit" >&2
  exit 1
fi

if env PATH="$TMP/bin:$PATH" FAKE_RECORD="$TMP/record" HOME="$TMP/operator-home" \
  "$RUNNER" \
  --manifest "$TMP/manifest.jsonl" --language javascript --variant candidate \
  --scenario missing-scenario \
  --candidate-repo "$TMP/candidate" --candidate-commit "$candidate_sha" \
  --model test-model --cursor-home "$TMP/auth" --artifacts "$TMP/missing-artifacts" \
  --agent-bin "$TMP/bin/agent" 2>"$TMP/missing.err"; then
  echo "runner accepted an unknown scenario filter" >&2
  exit 1
fi
grep -Fq 'no matching scenarios' "$TMP/missing.err"

echo "STATUS: PASSED"
```

- [ ] **Step 2: Run the test to verify RED**

Run: `bash tests/test-run-cursor-cohort.sh`

Expected: FAIL because `scripts/run-cursor-cohort.sh` does not exist.

- [ ] **Step 3: Implement the runner**

Create `scripts/run-cursor-cohort.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

usage() {
  echo "usage: run-cursor-cohort.sh --manifest PATH --language NAME --variant NAME [--scenario ID] --candidate-repo PATH --candidate-commit SHA --model MODEL --cursor-home PATH --artifacts PATH [--agent-bin PATH]" >&2
  exit 2
}

manifest="" language="" variant="" scenario="" candidate_repo="" candidate_commit="" model="" cursor_home="" artifacts="" agent_bin="agent"
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --manifest) manifest="$2"; shift 2 ;;
    --language) language="$2"; shift 2 ;;
    --variant) variant="$2"; shift 2 ;;
    --scenario) scenario="$2"; shift 2 ;;
    --candidate-repo) candidate_repo="$2"; shift 2 ;;
    --candidate-commit) candidate_commit="$2"; shift 2 ;;
    --model) model="$2"; shift 2 ;;
    --cursor-home) cursor_home="$2"; shift 2 ;;
    --artifacts) artifacts="$2"; shift 2 ;;
    --agent-bin) agent_bin="$2"; shift 2 ;;
    *) usage ;;
  esac
done

for value in "$manifest" "$language" "$variant" "$candidate_repo" "$candidate_commit" "$model" "$cursor_home" "$artifacts"; do
  [[ -n "$value" ]] || usage
done

candidate_repo="$(cd "$candidate_repo" && pwd -P)"
candidate_commit="$(git -C "$candidate_repo" rev-parse --verify "$candidate_commit^{commit}")" || {
  echo "invalid candidate commit" >&2
  exit 2
}
harness_commit="$(git -C "$ROOT" rev-parse --verify 'HEAD^{commit}')" || {
  echo "invalid eval harness commit" >&2
  exit 2
}
mkdir -p "$cursor_home" "$artifacts" \
  "$cursor_home/xdg-config" "$cursor_home/xdg-data" "$cursor_home/xdg-state" "$cursor_home/xdg-cache"
cursor_home="$(cd "$cursor_home" && pwd -P)"
artifacts="$(cd "$artifacts" && pwd -P)"

run_root="$(mktemp -d)"
trap 'rm -rf "$run_root"' EXIT
candidate_archive="$run_root/candidate.tar"
fixture_archive="$run_root/fixtures.tar"
candidate_tree="$run_root/candidate"
selected="$run_root/selected"
mkdir -p "$candidate_tree" "$selected"
git -C "$candidate_repo" archive --format=tar --output="$candidate_archive" "$candidate_commit"
git -C "$candidate_repo" archive --format=tar --output="$fixture_archive" "$candidate_commit" tests/skills/fixtures/language-guidance
tar -xf "$candidate_archive" -C "$candidate_tree"
git -C "$candidate_tree" init -q
git -C "$candidate_tree" config user.email eval@example.invalid
git -C "$candidate_tree" config user.name "Wukong Code Evals"
git -C "$candidate_tree" add .
git -C "$candidate_tree" commit -qm "frozen candidate $candidate_commit"
render_args=(--manifest "$manifest" --language "$language" --variant "$variant" --output "$selected")
if [[ -n "$scenario" ]]; then render_args+=(--scenario "$scenario"); fi
python3 "$ROOT/scripts/render-config.py" "${render_args[@]}" >/dev/null

candidate_archive_sha="$(shasum -a 256 "$candidate_archive" | awk '{print $1}')"
agent_env=(
  "HOME=$cursor_home"
  "XDG_CONFIG_HOME=$cursor_home/xdg-config"
  "XDG_DATA_HOME=$cursor_home/xdg-data"
  "XDG_STATE_HOME=$cursor_home/xdg-state"
  "XDG_CACHE_HOME=$cursor_home/xdg-cache"
)
agent_version="$(env "${agent_env[@]}" "$agent_bin" --version)"

overall=0
for scenario_file in "$selected"/*.json; do
  scenario_id="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["id"])' "$scenario_file")"
  repetitions="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["repetitions"])' "$scenario_file")"
  scenario_cwd="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["cwd"])' "$scenario_file")"
  prompt="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["prompt"])' "$scenario_file")"
  for (( repetition=1; repetition<=repetitions; repetition++ )); do
    repetition_name="$(printf 'r%03d' "$repetition")"
    scenario_workspace="$run_root/workspaces/$scenario_id/$repetition_name"
    mkdir -p "$scenario_workspace"
    scenario_workspace="$(cd "$scenario_workspace" && pwd -P)"
    tar -xf "$fixture_archive" -C "$scenario_workspace"
    cwd_path="$scenario_workspace/$scenario_cwd"
    case "$(cd "$cwd_path" && pwd -P)" in "$scenario_workspace"/*) ;; *) echo "scenario cwd escaped workspace" >&2; exit 1 ;; esac

    scenario_artifacts="$artifacts/$scenario_id/$repetition_name"
    if [[ -e "$scenario_artifacts" ]]; then
      echo "refusing to overwrite existing artifacts: $scenario_artifacts" >&2
      exit 1
    fi
    mkdir -p "$scenario_artifacts"
    events="$scenario_artifacts/events.jsonl"
    last="$scenario_artifacts/last-message.md"
    args=(--print --output-format stream-json --force --trust --sandbox enabled --workspace "$cwd_path" --model "$model")
    if [[ "$variant" != "no-guidance" ]]; then
      args+=(--plugin-dir "$candidate_tree")
    fi

    set +e
    env "${agent_env[@]}" "$agent_bin" "${args[@]}" "$prompt" >"$events"
    status=$?
    set -e
    python3 "$ROOT/scripts/extract-cursor-last-message.py" "$events" "$last" || : >"$last"
    scenario_sha="$(python3 - "$scenario_file" <<'PY'
import hashlib, json, sys
row = json.load(open(sys.argv[1], encoding="utf-8"))
encoded = json.dumps(row, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode()
print(hashlib.sha256(encoded).hexdigest())
PY
)"
    events_sha="$(shasum -a 256 "$events" | awk '{print $1}')"
    last_sha="$(shasum -a 256 "$last" | awk '{print $1}')"
    python3 - "$scenario_artifacts/metadata.json" "$scenario_id" "$repetition" "$repetitions" "$language" "$variant" "$candidate_commit" "$candidate_archive_sha" "$scenario_sha" "$events_sha" "$last_sha" "$status" "$model" "$agent_version" "$harness_commit" <<'PY'
import json, sys
from pathlib import Path
keys = (
    "scenario_id",
    "repetition",
    "repetitions",
    "language",
    "variant",
    "candidate_commit",
    "candidate_archive_sha256",
    "scenario_sha256",
    "events_sha256",
    "last_message_sha256",
    "command_status",
    "model",
    "agent_version",
    "harness_commit",
)
values = list(sys.argv[2:])
values[1] = int(values[1])
values[2] = int(values[2])
values[10] = int(values[10])
payload = dict(zip(keys, values))
payload["runtime"] = "cursor-cli"
Path(sys.argv[1]).write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
PY
    if [[ "$status" -ne 0 ]]; then overall=1; fi
  done
done

exit "$overall"
```

- [ ] **Step 4: Run the runner test**

Run: `bash tests/test-run-cursor-cohort.sh`

Expected: `STATUS: PASSED`

- [ ] **Step 5: Run the existing Codex suite and confirm it still passes**

Run:

```bash
bash tests/test-validate-manifest.sh
bash tests/test-run-cohort.sh
bash tests/test-summarize.sh
bash tests/test-extract-cursor-last-message.sh
bash tests/test-run-cursor-cohort.sh
python3 scripts/validate-manifest.py scenarios/javascript.jsonl scenarios/typescript.jsonl
```

Expected: all commands exit 0. `scripts/run-cohort.sh` is unchanged.

- [ ] **Step 6: Commit in the evals worktree**

```bash
git -C /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness add scripts/run-cursor-cohort.sh tests/test-run-cursor-cohort.sh
git -C /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness commit -m "$(cat <<'EOF'
feat: add isolated Cursor language-guidance cohort runner

EOF
)"
```

---

### Task 3: Document Cursor auth and refuse implicit tool install

**Files:**
- Modify: `README.md`

**Interfaces:**
- Consumes: Task 2 runner flags.
- Produces: README section that names `agent`, isolated HOME, `CURSOR_API_KEY` or `agent login`, `--plugin-dir`, and cleanup of only the temporary root.

- [ ] **Step 1: Append the Cursor section after the Codex authentication section**

Append this exact block to `README.md` before the summarizer example. Use a HEREDOC so nested fences stay literal:

```bash
python3 - <<'PY'
from pathlib import Path
path = Path("README.md")
text = path.read_text(encoding="utf-8")
needle = "Summarize the ignored artifacts:"
section = """## Cursor Agent CLI

The Cursor runner is a separate binary path. It does not replace `scripts/run-cohort.sh`.

Install Cursor Agent CLI yourself from https://cursor.com/docs/cli/overview
until `agent --version` prints a version string. Do not pipe the installer
through an eval agent.

Create an isolated home outside the repository:

    eval_auth_root="$(mktemp -d)"
    printf '%s\\n' "$eval_auth_root" > /tmp/wukong-code-cursor-eval-auth-root.txt
    mkdir -p "$eval_auth_root/cursor-home"
    test ! -e "$eval_auth_root/cursor-home/.cursor"

Authenticate with one of:

    export CURSOR_API_KEY
    HOME="$eval_auth_root/cursor-home" agent status

    HOME="$eval_auth_root/cursor-home" agent login
    HOME="$eval_auth_root/cursor-home" agent status

Never copy `~/.cursor`. Confirm `HOME="$eval_auth_root/cursor-home" agent status`
succeeds and that the isolated directory inode differs from `$HOME/.cursor`.

Freeze a model from `HOME="$eval_auth_root/cursor-home" agent --list-models`.
Do not use `gpt-5.6-terra`. If `composer-2.5` is listed, use that id; otherwise
stop and ask the human partner to pick a listed Cursor-billed model.

    scripts/run-cursor-cohort.sh \\
      --manifest scenarios/javascript.jsonl \\
      --language javascript \\
      --variant candidate \\
      --candidate-repo ../.. \\
      --candidate-commit <full-commit-sha> \\
      --model <model-id> \\
      --cursor-home "$eval_auth_root/cursor-home" \\
      --artifacts artifacts/cursor-publication/javascript/implementation-candidate

Guided variants pass `--plugin-dir` at the frozen candidate tree. no-guidance
omits it. The runner sets `HOME` and XDG directories to `--cursor-home` so a
user-scoped Wukong Code install cannot leak into baseline sessions.

"""
if "## Cursor Agent CLI" in text:
    raise SystemExit("Cursor section already present")
if needle not in text:
    raise SystemExit("README insertion point missing")
path.write_text(text.replace(needle, section + needle, 1), encoding="utf-8")
PY
```

- [ ] **Step 2: Run the local suite again**

Run:

```bash
bash tests/test-validate-manifest.sh
bash tests/test-run-cohort.sh
bash tests/test-summarize.sh
bash tests/test-extract-cursor-last-message.sh
bash tests/test-run-cursor-cohort.sh
python3 scripts/validate-manifest.py scenarios/javascript.jsonl scenarios/typescript.jsonl
```

Expected: all commands exit 0.

- [ ] **Step 3: Commit in the evals worktree**

```bash
git -C /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness add README.md
git -C /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness commit -m "$(cat <<'EOF'
docs: document isolated Cursor cohort authentication

EOF
)"
```

---

### Task 4: Probe the real `agent` binary and run one candidate smoke

**Files:**
- Create: ignored `artifacts/cursor-publication/smoke/`

**Interfaces:**
- Consumes: human-installed `agent`, isolated cursor home, plugin candidate `e616b3bba89ee717758d20a00308a9dc4ef27f76` unless plugin HEAD moved.
- Produces: one complete artifact triple and a printed freeze line `CANDIDATE=... HARNESS=... MODEL=... AGENT=...`. Not publication evidence.

- [ ] **Step 1: Confirm `agent` exists without installing it**

```bash
command -v agent
agent --version
```

Expected: a version string. If `command -v agent` fails, stop. The `cursor` binary inside Cursor.app is the editor launcher, not this CLI. Ask the human partner to install Cursor Agent CLI. Do not run `curl https://cursor.com/install`.

- [ ] **Step 2: Create isolated auth and authenticate**

```bash
eval_auth_root="$(mktemp -d)"
printf '%s\n' "$eval_auth_root" > /tmp/wukong-code-cursor-eval-auth-root.txt
mkdir -p "$eval_auth_root/cursor-home"
test ! -e "$eval_auth_root/cursor-home/.cursor"
if [[ -z "${CURSOR_API_KEY:-}" ]]; then
  HOME="$eval_auth_root/cursor-home" agent login
fi
HOME="$eval_auth_root/cursor-home" agent status
```

Expected: authenticated. Isolated home is not a copy of `~/.cursor`.

- [ ] **Step 3: List models and freeze one Cursor-billed id**

```bash
HOME="$(cat /tmp/wukong-code-cursor-eval-auth-root.txt)/cursor-home" agent --list-models
```

Expected: a list. If `composer-2.5` appears, freeze `MODEL=composer-2.5`. If it does not, stop and ask the human partner which listed id to freeze. Do not freeze `gpt-5.6-terra`.

- [ ] **Step 4: Record the freeze**

```bash
CANDIDATE=$(git -C /Users/wukong/Documents/wukong-code rev-parse HEAD)
HARNESS=$(git -C /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness rev-parse HEAD)
AGENT=$(HOME="$(cat /tmp/wukong-code-cursor-eval-auth-root.txt)/cursor-home" agent --version)
printf 'CANDIDATE=%s\nHARNESS=%s\nMODEL=%s\nAGENT=%s\n' "$CANDIDATE" "$HARNESS" "$MODEL" "$AGENT"
```

Expected: `CANDIDATE` is `e616b3bba89ee717758d20a00308a9dc4ef27f76` unless plugin HEAD moved; if it moved, use the new SHA everywhere after this step. `HARNESS` is the Task 3 commit on `cursor/language-guidance-eval-harness`.

- [ ] **Step 5: Run exactly one candidate smoke**

```bash
EVAL_ROOT=/Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
AUTH_ROOT="$(cat /tmp/wukong-code-cursor-eval-auth-root.txt)"
mkdir -p "$EVAL_ROOT/artifacts/cursor-publication/smoke"
"$EVAL_ROOT/scripts/run-cursor-cohort.sh" \
  --manifest "$EVAL_ROOT/scenarios/javascript.jsonl" \
  --language javascript \
  --variant candidate \
  --scenario js-implementation-candidate-01 \
  --candidate-repo /Users/wukong/Documents/wukong-code \
  --candidate-commit "$CANDIDATE" \
  --model "$MODEL" \
  --cursor-home "$AUTH_ROOT/cursor-home" \
  --artifacts "$EVAL_ROOT/artifacts/cursor-publication/smoke"
```

Expected: `r001` through `r005` directories exist. This smoke uses the real 5-repetition implementation candidate row; it is runner-mechanics evidence only. Do not later copy these files into the publication matrix directories.

- [ ] **Step 6: Verify plugin load and isolation**

```bash
python3 - <<'PY'
import json
from pathlib import Path
root = Path("/Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication/smoke/js-implementation-candidate-01/r001")
meta = json.loads((root / "metadata.json").read_text())
assert meta["command_status"] == 0
assert meta["runtime"] == "cursor-cli"
assert meta["model"] != "gpt-5.6-terra"
text = (root / "events.jsonl").read_text() + "\n" + (root / "last-message.md").read_text()
assert "skills/language-guidance" in text or "using-wukong-code" in text or "Detected: JavaScript" in text
print("smoke plugin signal present")
PY
```

Expected: assertion passes. If `command_status=0` but no language-guidance / using-wukong-code / `Detected: JavaScript` signal exists, stop. `--plugin-dir` did not deliver the bootstrap. Do not start the 89-session matrix.

- [ ] **Step 7: Do not commit artifacts or auth**

```bash
git -C /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness status --short
```

Expected: no `artifacts/` and no auth files staged.

---

### Task 5: Recapture the JavaScript matrix

**Files:**
- Create: `artifacts/cursor-publication/javascript/<family>/` plus `run-javascript.log`

**Interfaces:**
- Consumes: Task 4 freeze and isolated cursor home.
- Produces: 44 complete artifact triples under `artifacts/cursor-publication/javascript/`.

- [ ] **Step 1: Define a continue-on-fail wrapper**

```bash
EVAL_ROOT=/Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
AUTH_ROOT="$(cat /tmp/wukong-code-cursor-eval-auth-root.txt)"
CANDIDATE=$(git -C /Users/wukong/Documents/wukong-code rev-parse HEAD)
LOG="$EVAL_ROOT/artifacts/cursor-publication/run-javascript.log"
mkdir -p "$EVAL_ROOT/artifacts/cursor-publication"
run_one() {
  local language="$1" variant="$2" id="$3" dest="$4"
  echo "BEGIN $id $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee -a "$LOG"
  set +e
  "$EVAL_ROOT/scripts/run-cursor-cohort.sh" \
    --manifest "$EVAL_ROOT/scenarios/${language}.jsonl" \
    --language "$language" \
    --variant "$variant" \
    --scenario "$id" \
    --candidate-repo /Users/wukong/Documents/wukong-code \
    --candidate-commit "$CANDIDATE" \
    --model "$MODEL" \
    --cursor-home "$AUTH_ROOT/cursor-home" \
    --artifacts "$EVAL_ROOT/$dest" </dev/null
  local status=$?
  set -e
  echo "END $id status=$status $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee -a "$LOG"
}
```

Do not use `set -e` around `run_one` without capturing its status. A family FAIL must not skip later IDs.

- [ ] **Step 2: Run every JavaScript ID**

```bash
run_one javascript no-guidance js-implementation-no-guidance-01 artifacts/cursor-publication/javascript/implementation-no-guidance
run_one javascript candidate js-implementation-candidate-01 artifacts/cursor-publication/javascript/implementation-candidate
run_one javascript no-guidance js-tdd-no-guidance-01 artifacts/cursor-publication/javascript/tdd-no-guidance
run_one javascript adversarial js-tdd-adversarial-01 artifacts/cursor-publication/javascript/tdd-adversarial
run_one javascript no-guidance js-debug-no-guidance-01 artifacts/cursor-publication/javascript/debug-no-guidance
run_one javascript candidate js-debug-candidate-01 artifacts/cursor-publication/javascript/debug-candidate
run_one javascript no-guidance js-review-no-guidance-01 artifacts/cursor-publication/javascript/review-no-guidance
run_one javascript adversarial js-review-adversarial-01 artifacts/cursor-publication/javascript/review-adversarial
run_one javascript no-guidance js-verification-no-guidance-01 artifacts/cursor-publication/javascript/verification-no-guidance
run_one javascript adversarial js-verification-adversarial-01 artifacts/cursor-publication/javascript/verification-adversarial
run_one javascript no-guidance js-nearest-no-guidance-01 artifacts/cursor-publication/javascript/nearest-no-guidance
run_one javascript candidate js-nearest-candidate-01 artifacts/cursor-publication/javascript/nearest-candidate
run_one javascript candidate js-unsupported-control-01 artifacts/cursor-publication/javascript/unsupported
run_one javascript candidate js-docs-control-01 artifacts/cursor-publication/javascript/docs
```

Expected: 14 `BEGIN`/`END` pairs in the log. Existing complete directories are not overwritten; if a directory already exists, stop that ID and continue the rest with a new unused destination only when the human partner names one.

- [ ] **Step 3: Summarize and check metadata**

```bash
python3 "$EVAL_ROOT/scripts/summarize.py" \
  --manifest "$EVAL_ROOT/scenarios/javascript.jsonl" \
  --variant no-guidance \
  --artifacts "$EVAL_ROOT/artifacts/cursor-publication/javascript/implementation-no-guidance" \
  --output "$EVAL_ROOT/artifacts/cursor-publication/javascript/implementation-no-guidance-report.md"
python3 - <<'PY'
import json
from pathlib import Path
root = Path("/Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication/javascript")
for meta in sorted(root.rglob("metadata.json")):
    data = json.loads(meta.read_text())
    assert data["runtime"] == "cursor-cli"
    assert data["model"] != "gpt-5.6-terra"
    assert len(data["harness_commit"]) == 40
    print(meta.parent.relative_to(root), data["command_status"], data["model"])
PY
```

Expected: every JavaScript `metadata.json` prints. Incomplete or `command_status!=0` rows stay in the report as INCOMPLETE. Do not delete them.

---

### Task 6: Manually score JavaScript and write a Cursor report

**Files:**
- Create: `/Users/wukong/Documents/wukong-code/docs/wukong-code/evals/2026-08-16-javascript-language-guidance-cursor.md`

**Interfaces:**
- Consumes: Task 5 artifacts and the Manual PASS rules.
- Produces: a JavaScript Cursor report that stays a draft and says Planned.

- [ ] **Step 1: Score every JavaScript last-message and events file**

Write a table with columns Scenario, Rep, Automated screen, Manual, Failure mode present. A single FAIL or incomplete family blocks any later Experimental claim for JavaScript.

- [ ] **Step 2: Write the report with this opening**

```markdown
# JavaScript language-guidance evaluation (Cursor draft)

Draft, not publication evidence. This freeze used Cursor Agent CLI, not Codex.
Codex artifacts under `artifacts/experimental-publication/` are auxiliary and
are not this freeze.

## Methodology and isolation

- Plugin candidate commit: `<CANDIDATE>`
- Eval harness commit: `<HARNESS>`
- Model: `<MODEL>`
- CLI: `<AGENT version>`
- Runtime: `cursor-cli`
- Isolated cursor home (not a copy of `~/.cursor`)
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication/javascript/`
```

Fill the placeholders from Task 4. Keep the sentence `Manual review: pending` until a named JavaScript-aware human reviewer exists. Do not name a reviewer in this task.

- [ ] **Step 3: Commit only the report in the plugin repo**

```bash
git -C /Users/wukong/Documents/wukong-code add docs/wukong-code/evals/2026-08-16-javascript-language-guidance-cursor.md
git -C /Users/wukong/Documents/wukong-code commit -m "$(cat <<'EOF'
docs: record Cursor JavaScript language-guidance draft cohort

EOF
)"
```

Do not edit README language-pack status.

---

### Task 7: Recapture the TypeScript matrix

**Files:**
- Create: `artifacts/cursor-publication/typescript/<family>/` plus `run-typescript.log`

**Interfaces:**
- Consumes: the same Task 4 freeze and cursor home as Task 5.
- Produces: 45 complete artifact triples.

- [ ] **Step 1: Reuse the same `run_one` wrapper with a TypeScript log**

```bash
LOG="$EVAL_ROOT/artifacts/cursor-publication/run-typescript.log"
run_one typescript no-guidance ts-implementation-no-guidance-01 artifacts/cursor-publication/typescript/implementation-no-guidance
run_one typescript candidate ts-implementation-candidate-01 artifacts/cursor-publication/typescript/implementation-candidate
run_one typescript no-guidance ts-tdd-no-guidance-01 artifacts/cursor-publication/typescript/tdd-no-guidance
run_one typescript adversarial ts-tdd-adversarial-01 artifacts/cursor-publication/typescript/tdd-adversarial
run_one typescript no-guidance ts-debug-no-guidance-01 artifacts/cursor-publication/typescript/debug-no-guidance
run_one typescript candidate ts-debug-candidate-01 artifacts/cursor-publication/typescript/debug-candidate
run_one typescript no-guidance ts-review-no-guidance-01 artifacts/cursor-publication/typescript/review-no-guidance
run_one typescript adversarial ts-review-adversarial-01 artifacts/cursor-publication/typescript/review-adversarial
run_one typescript no-guidance ts-verification-no-guidance-01 artifacts/cursor-publication/typescript/verification-no-guidance
run_one typescript adversarial ts-verification-adversarial-01 artifacts/cursor-publication/typescript/verification-adversarial
run_one typescript no-guidance ts-nearest-no-guidance-01 artifacts/cursor-publication/typescript/nearest-no-guidance
run_one typescript candidate ts-nearest-candidate-01 artifacts/cursor-publication/typescript/nearest-candidate
run_one typescript candidate ts-cross-language-control-01 artifacts/cursor-publication/typescript/cross-language
run_one typescript candidate ts-docs-control-01 artifacts/cursor-publication/typescript/docs
run_one typescript candidate ts-unsupported-control-01 artifacts/cursor-publication/typescript/unsupported
```

- [ ] **Step 2: Print TypeScript metadata**

```bash
python3 - <<'PY'
import json
from pathlib import Path
root = Path("/Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication/typescript")
for meta in sorted(root.rglob("metadata.json")):
    data = json.loads(meta.read_text())
    assert data["runtime"] == "cursor-cli"
    assert data["model"] != "gpt-5.6-terra"
    assert len(data["harness_commit"]) == 40
    print(meta.parent.relative_to(root), data["command_status"], data["model"])
PY
```

Expected: every TypeScript `metadata.json` prints. Incomplete or `command_status!=0` rows stay on disk. Do not delete them.

---

### Task 8: Manually score TypeScript and write a Cursor report

**Files:**
- Create: `/Users/wukong/Documents/wukong-code/docs/wukong-code/evals/2026-08-16-typescript-language-guidance-cursor.md`

**Interfaces:**
- Consumes: Task 7 artifacts and the Manual PASS rules.
- Produces: a TypeScript Cursor report that stays a draft and says Planned.

- [ ] **Step 1: Score every TypeScript last-message and events file**

Write a table with columns Scenario, Rep, Automated screen, Manual, Failure mode present. A single FAIL or incomplete family blocks any later Experimental claim for TypeScript.

- [ ] **Step 2: Write the report with this opening**

```markdown
# TypeScript language-guidance evaluation (Cursor draft)

Draft, not publication evidence. This freeze used Cursor Agent CLI, not Codex.
Codex artifacts under `artifacts/experimental-publication/` are auxiliary and
are not this freeze.

## Methodology and isolation

- Plugin candidate commit: `<CANDIDATE>`
- Eval harness commit: `<HARNESS>`
- Model: `<MODEL>`
- CLI: `<AGENT version>`
- Runtime: `cursor-cli`
- Isolated cursor home (not a copy of `~/.cursor`)
- Artifacts: `evals/.worktrees/language-guidance-eval-harness/artifacts/cursor-publication/typescript/`
```

Fill the placeholders from Task 4. Keep `Manual review: pending`. Do not name a reviewer in this task.

- [ ] **Step 3: Commit only the report in the plugin repo**

```bash
git -C /Users/wukong/Documents/wukong-code add docs/wukong-code/evals/2026-08-16-typescript-language-guidance-cursor.md
git -C /Users/wukong/Documents/wukong-code commit -m "$(cat <<'EOF'
docs: record Cursor TypeScript language-guidance draft cohort

EOF
)"
```

Do not edit README.

---

### Task 9: Logout only the isolated cursor home

**Files:**
- None in git

**Interfaces:**
- Consumes: `/tmp/wukong-code-cursor-eval-auth-root.txt`
- Produces: deleted temporary auth root; `~/.cursor` untouched.

- [ ] **Step 1: Logout and delete only the pointer target**

```bash
eval_auth_root="$(cat /tmp/wukong-code-cursor-eval-auth-root.txt)"
HOME="$eval_auth_root/cursor-home" agent logout || true
test -n "$eval_auth_root"
test "$eval_auth_root" != /
test "$eval_auth_root" != "$HOME"
rm -rf -- "$eval_auth_root"
rm -f /tmp/wukong-code-cursor-eval-auth-root.txt
test -d "$HOME/.cursor" && echo 'global ~/.cursor untouched'
```

Expected: isolated root gone. Global Cursor install unchanged.

- [ ] **Step 2: Stop**

Do not open a publication PR. Do not change Planned rows. If both reports are complete and every required family is manual PASS, tell the human partner that a later Experimental publication plan can start, and that it still needs a named language-aware reviewer.
