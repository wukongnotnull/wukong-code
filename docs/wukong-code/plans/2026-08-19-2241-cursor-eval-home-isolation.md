# Cursor Eval Home Isolation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Stop no-guidance Cursor eval sessions from reading language-guidance files out of a shared isolated `HOME` plugin cache, stop agent mktemps from leaving searchable `/tmp/.../candidate/skills` trees, and retry once when a session writes empty events.

**Architecture:** Keep `--cursor-home` as the authenticated Keychain/API root for guided variants. For `no-guidance`, give the agent a fresh mktemp `HOME` with Keychain symlink only and no `plugins/cache`. Point `TMPDIR` at a cohort temp that the runner deletes. If `events.jsonl` is empty, rerun that repetition once in place before writing metadata.

**Tech Stack:** Bash 3.2+, Python 3 standard library, existing fake `agent` in `tests/test-run-cursor-cohort.sh`.

## Global Constraints

- Repository: `wukong-code-evals` worktree `/Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness`.
- Continue on branch `cursor/language-guidance-eval-harness`. Do not merge to evals `main` from this plan.
- Do not modify `scripts/run-cohort.sh` (Codex).
- Add no package-manager dependency.
- Keep `--sandbox enabled`. Do not add `--worktree`.
- Do not copy `~/.cursor`. Darwin Keychain remains symlink-only.
- `no-guidance` argv must omit `--plugin-dir`.
- Guided `--plugin-dir` stays off the workspace ancestor chain.
- Do not flip README language-pack rows. Do not open a publication PR from this plan.

## File map

| Path | Responsibility |
| --- | --- |
| `scripts/run-cursor-cohort.sh` | Clean no-guidance HOME; cohort `TMPDIR`; one empty-session retry |
| `tests/test-run-cursor-cohort.sh` | Fake-agent contracts for HOME cache, TMPDIR, retry |
| `README.md` | Document no-guidance HOME and TMPDIR isolation |

Reuse without editing: `scripts/render-config.py`, `scripts/extract-cursor-last-message.py`, `scripts/summarize.py`, `scenarios/javascript.jsonl`, `scenarios/typescript.jsonl`.

---

### Task 1: no-guidance HOME has no plugin cache

**Files:**
- Modify: `tests/test-run-cursor-cohort.sh`
- Modify: `scripts/run-cursor-cohort.sh`
- Modify: `README.md`

**Interfaces:**
- Consumes: existing `--cursor-home`, Darwin Keychain symlink, fake agent that writes `$FAKE_RECORD/home`.
- Produces: `no-guidance` agent `HOME` is not `--cursor-home` and contains no `plugins/cache/**/skills/language-guidance/SKILL.md`. Guided still uses `--cursor-home`.

- [ ] **Step 1: Write the failing HOME-cache assertions**

In `tests/test-run-cursor-cohort.sh`, extend the fake `agent` so it also records plugin-cache hits under `$HOME`. Immediately after `printf '%s\n' "$HOME" >"$FAKE_RECORD/home"`, add:

```
python3 - "$FAKE_RECORD/home-cache.json" <<'PY'
import json, os, sys
from pathlib import Path
home = Path(os.environ["HOME"]).resolve()
hits = [str(p) for p in home.rglob("skills/language-guidance/SKILL.md") if "/plugins/cache/" in str(p)]
Path(sys.argv[1]).write_text(
    json.dumps({"home": str(home), "cache_skill_hits": hits}, indent=2) + "\n",
    encoding="utf-8",
)
PY
```

Immediately after the existing no-guidance isolation Python block that asserts `not data["plugin"]`, seed a leak cache on `--cursor-home` and assert the agent did not see it. Insert this after:

```
assert not data["ancestor_candidate_skill"]
PY
```

of the `record-ng` isolation check:

```bash
mkdir -p "$TMP/auth/plugins/cache/wukong-code-dev/wukong-code/6.3.0/skills/language-guidance"
printf '%s\n' '# leaked cache' >"$TMP/auth/plugins/cache/wukong-code-dev/wukong-code/6.3.0/skills/language-guidance/SKILL.md"
mkdir -p "$TMP/record-ng-cache"
env PATH="$TMP/bin:$PATH" FAKE_RECORD="$TMP/record-ng-cache" HOME="$TMP/operator-home" \
  "$RUNNER" \
  --manifest "$TMP/manifest.jsonl" --language javascript --variant no-guidance \
  --scenario js-smoke-no-guidance-01 \
  --candidate-repo "$TMP/candidate" --candidate-commit "$candidate_sha" \
  --model test-model --cursor-home "$TMP/auth" --artifacts "$TMP/artifacts-ng-cache" \
  --agent-bin "$TMP/bin/agent"
python3 - "$TMP/record-ng-cache/home" "$TMP/record-ng-cache/home-cache.json" "$TMP/auth" <<'PY'
from pathlib import Path
import json, sys
agent_home = Path(Path(sys.argv[1]).read_text().strip()).resolve()
cache = json.loads(Path(sys.argv[2]).read_text())
auth = Path(sys.argv[3]).resolve()
assert agent_home != auth, (agent_home, auth)
assert cache["cache_skill_hits"] == [], cache
assert not (
    agent_home / "plugins" / "cache" / "wukong-code-dev" / "wukong-code" / "6.3.0"
    / "skills" / "language-guidance" / "SKILL.md"
).is_file()
PY
if grep -Fxq -- '--plugin-dir' "$TMP/record-ng-cache/args"; then
  echo "no-guidance cache rerun passed --plugin-dir" >&2
  exit 1
fi
```

Guided `run_candidate` must still grep `$TMP/record/home` equal to `$TMP/auth`. Do not change that assertion.

- [ ] **Step 2: Run the test to verify it fails**

Run:

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
bash tests/test-run-cursor-cohort.sh
```

Expected: FAIL. Today's runner sets `HOME` to `--cursor-home` for every variant, so `agent_home == auth` and `cache_skill_hits` is non-empty. Do not implement the runner change before this failure is observed.

- [ ] **Step 3: Give no-guidance a clean HOME**

In `scripts/run-cursor-cohort.sh`, keep creating Keychain symlink on `$cursor_home` for guided auth. Add a `no_guidance_home=""` next to `plugin_root=""`. Extend `cleanup`:

```bash
cleanup() {
  rm -rf "$workspace_root"
  if [[ -n "$plugin_root" ]]; then
    rm -rf "$plugin_root"
  fi
  if [[ -n "$no_guidance_home" ]]; then
    rm -rf "$no_guidance_home"
  fi
}
```

After `cursor_home="$(cd "$cursor_home" && pwd -P)"`, if `variant` is `no-guidance`, create the clean home. Use the operator `HOME` (the shell's HOME before `agent_env`) for the Keychain source, same Darwin rule as `$cursor_home`:

```bash
no_guidance_home=""
if [[ "$variant" == "no-guidance" ]]; then
  no_guidance_home="$(mktemp -d)"
  mkdir -p "$no_guidance_home/xdg-config" "$no_guidance_home/xdg-data" "$no_guidance_home/xdg-state" "$no_guidance_home/xdg-cache"
  if [[ "$(uname -s)" == Darwin && -d "${HOME}/Library/Keychains" ]]; then
    mkdir -p "$no_guidance_home/Library"
    if [[ ! -e "$no_guidance_home/Library/Keychains" ]]; then
      ln -s "${HOME}/Library/Keychains" "$no_guidance_home/Library/Keychains"
    fi
  fi
fi
```

Replace the single `agent_env` HOME assignment with a helper used inside the repetition loop so guided still uses `$cursor_home` and no-guidance uses `$no_guidance_home`:

```bash
    session_home="$cursor_home"
    if [[ "$variant" == "no-guidance" ]]; then
      session_home="$no_guidance_home"
    fi
    agent_env=(
      "HOME=$session_home"
      "XDG_CONFIG_HOME=$session_home/xdg-config"
      "XDG_DATA_HOME=$session_home/xdg-data"
      "XDG_STATE_HOME=$session_home/xdg-state"
      "XDG_CACHE_HOME=$session_home/xdg-cache"
    )
```

Move `agent_version="$(env "${agent_env[@]}" "$agent_bin" --version)"` to after `session_home` exists. For version, guided may use `$cursor_home`; no-guidance may use `$no_guidance_home`. Do not copy `$cursor_home/plugins` into `$no_guidance_home`. Do not pass `--plugin-dir` for no-guidance.

In `README.md`, add one sentence under the Cursor runner section: no-guidance sessions receive a fresh HOME with Keychain symlink only and never inherit `--cursor-home/plugins/cache`.

- [ ] **Step 4: Run the test to verify it passes**

Run:

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
bash tests/test-run-cursor-cohort.sh
```

Expected: `STATUS: PASSED`. Guided home still equals `--cursor-home`. no-guidance home is a different directory with empty cache hits.

- [ ] **Step 5: Commit**

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
git add scripts/run-cursor-cohort.sh tests/test-run-cursor-cohort.sh README.md
git commit -m "$(cat <<'EOF'
fix: isolate Cursor no-guidance HOME from plugin cache

EOF
)"
```

---

### Task 2: Cohort TMPDIR so leftover candidate trees die with the run

**Files:**
- Modify: `tests/test-run-cursor-cohort.sh`
- Modify: `scripts/run-cursor-cohort.sh`

**Interfaces:**
- Consumes: Task 1 runner and fake agent `$FAKE_RECORD`.
- Produces: agent `TMPDIR` is a runner-owned mktemp deleted on EXIT; it is not `/tmp` and not `--cursor-home`.

- [ ] **Step 1: Write the failing TMPDIR assertion**

In the fake `agent`, after the HOME printf, add:

```
printf '%s\n' "${TMPDIR:-}" >"$FAKE_RECORD/tmpdir"
```

After the guided isolation Python on `$TMP/record/isolation.json` succeeds, add:

```bash
python3 - "$TMP/record/tmpdir" "$TMP/auth" <<'PY'
from pathlib import Path
import sys
tmpdir = Path(Path(sys.argv[1]).read_text().strip()).resolve()
auth = Path(sys.argv[2]).resolve()
assert tmpdir != Path("/tmp")
assert tmpdir != auth
assert tmpdir.is_dir()
PY
```

After the first no-guidance run (`record-ng`), add the same assertion against `"$TMP/record-ng/tmpdir"`.

- [ ] **Step 2: Run the test to verify it fails**

Run:

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
bash tests/test-run-cursor-cohort.sh
```

Expected: FAIL. Today's runner does not set `TMPDIR`, so the fake agent records empty or `/var/folders/...` operator temp, not a runner-owned directory distinct from `/tmp`.

- [ ] **Step 3: Set TMPDIR to a cleaned mktemp**

In `scripts/run-cursor-cohort.sh`, add `agent_tmp="$(mktemp -d)"` next to `workspace_root`. Add `rm -rf "$agent_tmp"` to `cleanup`. Put `TMPDIR=$agent_tmp` in every `agent_env` array (guided and no-guidance). Do not extract the plugin into `$agent_tmp`. Do not name any extract directory `candidate`.

- [ ] **Step 4: Run the test to verify it passes**

Run:

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
bash tests/test-run-cursor-cohort.sh
```

Expected: `STATUS: PASSED`.

- [ ] **Step 5: Commit**

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
git add scripts/run-cursor-cohort.sh tests/test-run-cursor-cohort.sh
git commit -m "$(cat <<'EOF'
fix: confine Cursor eval agent TMPDIR to a cleaned temp

EOF
)"
```

---

### Task 3: Retry empty sessions once

**Files:**
- Modify: `tests/test-run-cursor-cohort.sh`
- Modify: `scripts/run-cursor-cohort.sh`

**Interfaces:**
- Consumes: Task 1–2 runner; `FAKE_FAIL` already covers non-empty failures that must still be recorded.
- Produces: if the first `agent` invoke writes a zero-byte `events.jsonl`, the runner invokes `agent` once more into the same paths before hashing metadata. A second empty file still records `command_status` from the retry.

- [ ] **Step 1: Write the failing retry assertion**

Add a third fake-agent mode. After the existing `FAKE_FAIL` block, insert:

```
if [[ "${FAKE_EMPTY_ONCE:-0}" == 1 ]]; then
  marker="$FAKE_RECORD/empty-once"
  if [[ ! -e "$marker" ]]; then
    touch "$marker"
    exit 1
  fi
fi
```

Place this before the success `printf` JSON lines so the first call writes nothing to stdout (the runner redirects stdout to `events.jsonl`). After the existing `FAKE_FAIL` metadata assertion, add:

```bash
mkdir -p "$TMP/record-empty"
if ! env PATH="$TMP/bin:$PATH" FAKE_RECORD="$TMP/record-empty" FAKE_EMPTY_ONCE=1 HOME="$TMP/operator-home" \
  "$RUNNER" \
  --manifest "$TMP/manifest.jsonl" --language javascript --variant candidate \
  --scenario js-smoke-candidate-01 \
  --candidate-repo "$TMP/candidate" --candidate-commit "$candidate_sha" \
  --model test-model --cursor-home "$TMP/auth" --artifacts "$TMP/empty-artifacts" \
  --agent-bin "$TMP/bin/agent"; then
  echo "runner did not recover from one empty agent invoke" >&2
  exit 1
fi
test -s "$TMP/empty-artifacts/js-smoke-candidate-01/r001/events.jsonl"
python3 - "$TMP/empty-artifacts/js-smoke-candidate-01/r001/metadata.json" <<'PY'
import json, sys
data = json.load(open(sys.argv[1], encoding="utf-8"))
assert data["command_status"] == 0
PY
grep -Fxq 'JavaScript guidance loaded' "$TMP/empty-artifacts/js-smoke-candidate-01/r001/last-message.md"
```

The overwrite-refusal test already ran `run_candidate` twice against `$TMP/artifacts`. Use a new artifacts directory here.

- [ ] **Step 2: Run the test to verify it fails**

Run:

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
bash tests/test-run-cursor-cohort.sh
```

Expected: FAIL with `runner did not recover from one empty agent invoke` because today's runner writes metadata after the first empty stdout and does not retry.

- [ ] **Step 3: Retry once when events are empty**

In `scripts/run-cursor-cohort.sh`, after the first `env ... "$agent_bin" ... >"$events"` and `status=$?`, add:

```bash
    if [[ ! -s "$events" ]]; then
      set +e
      env "${agent_env[@]}" "$agent_bin" "${args[@]}" "$prompt" >"$events"
      status=$?
      set -e
    fi
```

Then run `extract-cursor-last-message.py` and write metadata as today. Do not retry when `$events` is non-empty, even if `status != 0`. Do not retry more than once. Do not delete the artifacts directory on retry (overwrite of `events.jsonl` in place is required).

- [ ] **Step 4: Run the test to verify it passes**

Run:

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
bash tests/test-run-cursor-cohort.sh
```

Expected: `STATUS: PASSED`. `FAKE_FAIL=1` still records `command_status == 17` without requiring a retry (that fake writes no success JSON but the failure path currently prints `agent failed` on stderr and exits 17; stdout may be empty). If `FAKE_FAIL` now retries and the second call also fails empty, metadata must still show 17. Keep `FAKE_FAIL` exiting 17 on every invoke so retry still fails; that is acceptable. If the new empty-retry causes `FAKE_FAIL` to invoke twice, both exit 17; metadata stays 17.

- [ ] **Step 5: Commit**

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
git add scripts/run-cursor-cohort.sh tests/test-run-cursor-cohort.sh
git commit -m "$(cat <<'EOF'
fix: retry empty Cursor eval sessions once

EOF
)"
```

---

## Spec coverage

- no-guidance must not `Read` HOME plugin cache: Task 1.
- Leftover `/tmp/.../candidate/skills` from agent/runner temps: Task 2 (`TMPDIR` cleaned on EXIT). One-time disk sweep of old leftovers is the recapture plan, not this plan.
- Empty `command_status=1` transcripts: Task 3.
- No README language-pack flip, no publication PR: Global Constraints.

## Execution handoff

This plan is isolation-only. Plugin skill sentences are `2026-08-19-2241-js-ts-skill-hard-constraints.md`. Full 89-session recapture is `2026-08-19-2241-js-ts-cursor-recapture.md` and must not start until this plan and the skill plan have commits on their worktrees.
