# Cursor Eval Plugin Temp Isolation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Stop no-guidance Cursor eval sessions from discovering a leftover guided plugin unpack as `tmp.*/skills/language-guidance/**` under Darwin `/var/folders/.../T` (or `/tmp`) after a previous cohort process exits.

**Architecture:** Create one private `eval_tmp_root`. Put workspace, agent `TMPDIR`, no-guidance HOME, and the guided plugin unpack inside it. Guided `--plugin-dir` is `$eval_tmp_root/plugin` (not a top-level `tmp.*` whose `skills/` directory is a direct child). Delete the whole root on EXIT after `chmod -R u+w`. Fake-agent tests prove TMPDIR's parent is that private root, so a sibling leftover `tmp.*/skills/language-guidance/SKILL.md` is invisible.

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
- Do not sweep all of Darwin `T` / `/tmp` for `tmp.*/skills` (that would delete a parallel cohort's plugin). Only delete this process's `eval_tmp_root`.
- Do not flip README language-pack rows. Do not open a publication PR from this plan.
- zsh is not this runner; the runner is bash. Keep the existing `status=$?` local in the runner as-is.

## File map

| Path | Responsibility |
| --- | --- |
| `scripts/run-cursor-cohort.sh` | Nested eval temp; plugin at `$eval_tmp_root/plugin`; EXIT deletes the root |
| `tests/test-run-cursor-cohort.sh` | Fake-agent leftover layout hits; plugin path gone after EXIT |
| `README.md` | Document nested eval temp and leftover `tmp.*/skills/language-guidance` close |

Reuse without editing: `scripts/render-config.py`, `scripts/extract-cursor-last-message.py`, `scripts/summarize.py`, `scenarios/javascript.jsonl`, `scenarios/typescript.jsonl`.

Do not start the recapture-3 plan until this plan has its commit on the evals worktree.

---

### Task 1: Nest eval temps so no-guidance cannot see sibling plugin unpacks

**Files:**
- Modify: `tests/test-run-cursor-cohort.sh`
- Modify: `scripts/run-cursor-cohort.sh`
- Modify: `README.md`

**Interfaces:**
- Consumes: existing `workspace_root`, `plugin_root`, `agent_tmp`, `no_guidance_home`, fake agent `isolation.json` / `tmpdir` / `home`.
- Produces: one `eval_tmp_root`; guided plugin at `$eval_tmp_root/plugin`; agent `TMPDIR` is a `tmp.*` child of `eval_tmp_root`; no-guidance `isolation.json` `tmpdir_parent_plugin_layout_hits` is `[]` even when a sibling leftover unpack exists under Darwin `T`; guided plugin path does not exist after the runner exits.

- [ ] **Step 1: Write the failing leftover-layout assertions**

In `tests/test-run-cursor-cohort.sh`, inside the fake `agent` isolation Python block, after `workspace_under_plugin` is computed and before `Path(sys.argv[3]).write_text`, add TMPDIR-parent leftover detection. The glob must match the recapture-2 leak layout: `tmp.*/skills/language-guidance/SKILL.md` as a **direct** child of a `tmp.*` directory (not `$TMP/candidate/skills/...`).

Replace the `Path(sys.argv[3]).write_text(json.dumps({...}))` payload so it also includes `tmpdir_parent_plugin_layout_hits`. Keep every existing key. The new Python immediately before `Path(sys.argv[3]).write_text` is:

```python
import os
tmpdir = Path(os.environ.get("TMPDIR") or "/tmp").resolve()
tmpdir_parent_plugin_layout_hits = [
    str(p.resolve())
    for p in tmpdir.parent.glob("tmp.*/skills/language-guidance/SKILL.md")
]
```

Add this key to the JSON object:

```python
"tmpdir_parent_plugin_layout_hits": tmpdir_parent_plugin_layout_hits,
```

Immediately after the existing first `run_candidate` isolation assert block that ends with `assert not data["ancestor_candidate_skill"]`, add a plugin-cleanup assertion:

```bash
python3 - "$TMP/record/isolation.json" <<'PY'
import json, sys
from pathlib import Path
data = json.load(open(sys.argv[1], encoding="utf-8"))
plugin = Path(data["plugin"])
assert data["plugin"]
assert not plugin.exists(), plugin
PY
```

Immediately after the existing `record-ng-cache` HOME-cache Python assert (the block that asserts `cache["cache_skill_hits"] == []`) and the `--plugin-dir` grep that follows it, seed a sibling leftover unpack under the test process temp parent and run no-guidance:

```bash
leftover_unpack="$(mktemp -d "${TMPDIR:-/tmp}/tmp.XXXXXX")"
mkdir -p "$leftover_unpack/skills/language-guidance"
printf '%s\n' '# leftover unpack' >"$leftover_unpack/skills/language-guidance/SKILL.md"
mkdir -p "$TMP/record-ng-leftover"
env PATH="$TMP/bin:$PATH" FAKE_RECORD="$TMP/record-ng-leftover" HOME="$TMP/operator-home" \
  "$RUNNER" \
  --manifest "$TMP/manifest.jsonl" --language javascript --variant no-guidance \
  --scenario js-smoke-no-guidance-01 \
  --candidate-repo "$TMP/candidate" --candidate-commit "$candidate_sha" \
  --model test-model --cursor-home "$TMP/auth" --artifacts "$TMP/artifacts-ng-leftover" \
  --agent-bin "$TMP/bin/agent"
python3 - "$TMP/record-ng-leftover/isolation.json" "$leftover_unpack" <<'PY'
import json, sys
from pathlib import Path
data = json.load(open(sys.argv[1], encoding="utf-8"))
leftover = Path(sys.argv[2]).resolve() / "skills" / "language-guidance" / "SKILL.md"
assert leftover.is_file()
assert data["tmpdir_parent_plugin_layout_hits"] == [], data
assert not data["plugin"]
PY
if grep -Fxq -- '--plugin-dir' "$TMP/record-ng-leftover/args"; then
  echo "no-guidance leftover rerun passed --plugin-dir" >&2
  exit 1
fi
rm -rf "$leftover_unpack"
```

- [ ] **Step 2: Run the test to verify it fails**

Run:

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
bash tests/test-run-cursor-cohort.sh
```

Expected: FAIL. The leftover no-guidance run's `tmpdir_parent_plugin_layout_hits` is non-empty because agent `TMPDIR` is still a direct child of Darwin `T` / `/tmp`, so `TMPDIR.parent.glob("tmp.*/skills/language-guidance/SKILL.md")` finds `$leftover_unpack`. Do not edit the runner until this failure is observed.

- [ ] **Step 3: Nest eval temps in the runner**

In `scripts/run-cursor-cohort.sh`, replace the current temp creation and `cleanup` (today: `workspace_root="$(mktemp -d)"`, `plugin_root=""`, `no_guidance_home=""`, `agent_tmp="$(mktemp -d)"`, and per-path `rm -rf`) with:

```bash
eval_tmp_root="$(mktemp -d)"
workspace_root="$(mktemp -d "$eval_tmp_root/tmp.XXXXXX")"
plugin_root=""
no_guidance_home=""
agent_tmp="$(mktemp -d "$eval_tmp_root/tmp.XXXXXX")"
cleanup() {
  if [[ -n "${eval_tmp_root:-}" && -d "$eval_tmp_root" ]]; then
    chmod -R u+w "$eval_tmp_root" 2>/dev/null || true
    rm -rf "$eval_tmp_root"
  fi
}
trap cleanup EXIT
```

Keep the Darwin Keychain symlink block for `--cursor-home` unchanged.

In the `no-guidance` HOME block, replace `no_guidance_home="$(mktemp -d)"` with:

```bash
  no_guidance_home="$(mktemp -d "$eval_tmp_root/tmp.XXXXXX")"
```

Keep the xdg mkdir and Keychain symlink against `"$no_guidance_home"` unchanged.

In the guided unpack block, replace `plugin_root="$(mktemp -d)"` with:

```bash
  plugin_root="$eval_tmp_root/plugin"
  mkdir -p "$plugin_root"
```

Keep `candidate_tree="$plugin_root"` and the git archive / init / commit sequence unchanged.

Do not unpack the plugin for `no-guidance`. Do not pass `--plugin-dir` for `no-guidance`.

Do not change `--sandbox enabled`. Do not add `--worktree`.

- [ ] **Step 4: Run the test to verify it passes**

Run:

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
bash tests/test-run-cursor-cohort.sh
```

Expected: `STATUS: PASSED`. Guided isolation asserts still hold (`plugin_skill`, not ancestor, `skill_hits == []`). Agent `TMPDIR` basename still starts with `tmp.`. no-guidance HOME basename still starts with `tmp.`. Leftover sibling unpack is not in `tmpdir_parent_plugin_layout_hits`. Guided `plugin` path does not exist after EXIT.

- [ ] **Step 5: Document the nested eval temp**

In `README.md`, replace this paragraph:

```
The Cursor runner uses two disjoint mktemp roots. Workspaces get fixture
extracts only. Guided variants (`candidate`, `adversarial`) unpack the frozen
plugin into a second temp and pass it as `--plugin-dir`; that plugin root is
not the workspace, not a parent of it, and not a child of it. `no-guidance`
omits `--plugin-dir` and does not unpack the plugin archive, so
`skills/language-guidance/SKILL.md` is not on disk under the runner temps.
`no-guidance` sessions receive a fresh HOME with Keychain symlink only and
never inherit `--cursor-home/plugins/cache`. Guided sessions still set `HOME`
and XDG directories to `--cursor-home`.
```

with:

```
The Cursor runner creates one private eval temp and nests workspace, agent
`TMPDIR`, no-guidance HOME, and the guided plugin unpack under it. Workspaces
get fixture extracts only. Guided variants (`candidate`, `adversarial`) unpack
the frozen plugin into `$eval_tmp_root/plugin` and pass it as `--plugin-dir`;
that plugin root is not the workspace, not a parent of it, and not a child of
it, and it is not a top-level `tmp.*` whose `skills/` directory is a direct
child. `no-guidance` omits `--plugin-dir` and does not unpack the plugin
archive. Agent `TMPDIR` is a `tmp.*` child of the private eval temp, so a
sibling leftover `tmp.*/skills/language-guidance` under Darwin `T` or `/tmp`
is not visible by listing `TMPDIR`'s parent. The runner deletes the private
eval temp on EXIT and does not sweep other processes' temps. `no-guidance`
sessions receive a fresh HOME with Keychain symlink only and never inherit
`--cursor-home/plugins/cache`. Guided sessions still set `HOME` and XDG
directories to `--cursor-home`.
```

- [ ] **Step 6: Commit**

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
git add tests/test-run-cursor-cohort.sh scripts/run-cursor-cohort.sh README.md
git commit -m "$(cat <<'EOF'
fix: nest Cursor eval temps so leftover plugin unpacks stay invisible

EOF
)"
```

---

## Spec coverage

- Private prefix for plugin unpack: Task 1 (`$eval_tmp_root/plugin`).
- EXIT deletes the unpack: Task 1 (`chmod` + `rm -rf "$eval_tmp_root"`).
- no-guidance cannot discover sibling `tmp.*/skills/language-guidance` via TMPDIR parent: Task 1 leftover assertion.
- Fake-agent leftover SKILL.md contract: Task 1.
- No Darwin-T sweep of parallel cohorts: Global Constraints plus README.
- No README language-pack flip, no publication PR: Global Constraints.

## Execution handoff

Skill constraints are `2026-08-20-2126-js-ts-skill-hard-constraints.md`. Recapture-3 is `2026-08-20-2126-js-ts-cursor-recapture.md` and must not start until this plan and the skill plan have commits on their worktrees.
