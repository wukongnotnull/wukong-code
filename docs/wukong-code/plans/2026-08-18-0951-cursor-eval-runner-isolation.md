# Cursor Eval Runner Isolation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Stop the Cursor language-guidance eval runner from unpacking a searchable plugin tree next to no-guidance workspaces, and keep guided `--plugin-dir` off the workspace ancestor chain.

**Architecture:** Replace the single `run_root` temp with two disjoint `mktemp` directories. The workspace root holds fixture extracts only. The plugin root is created only for `candidate` and `adversarial`, and is passed solely as `--plugin-dir`. `no-guidance` hashes the frozen plugin archive without extracting it, so a `Read` of `skills/language-guidance/SKILL.md` cannot be satisfied from runner-created disk.

**Tech Stack:** Bash 3.2+, Python 3 standard library, Git, existing fake `agent` in `tests/test-run-cursor-cohort.sh`.

## Global Constraints

- Repository: `wukong-code-evals` worktree `/Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness`.
- Do not modify `scripts/run-cohort.sh` (Codex).
- Add no package-manager dependency.
- Keep `--sandbox enabled`. Do not add `--worktree`.
- Do not copy `~/.cursor`. Keep Darwin Keychain symlink-only behavior.
- `no-guidance` argv must omit `--plugin-dir`.
- Guided argv must contain `--plugin-dir` pointing at a tree that is not the workspace directory, not a parent of it, and not a child of it.
- `candidate_archive_sha256` remains a 64-character SHA-256 of the full frozen plugin tar, including for `no-guidance`.
- Do not flip README language-pack rows. Do not open a publication PR from this plan.

## File map

| Path | Responsibility |
| --- | --- |
| `scripts/run-cursor-cohort.sh` | Disjoint workspace/plugin temps; extract plugin only for guided variants |
| `tests/test-run-cursor-cohort.sh` | Fake-agent contract: argv, pack `SKILL.md` absence, ancestor isolation |
| `README.md` | Document that no-guidance never unpacks the plugin and guided plugin root is not on the workspace ancestor chain |

Reuse without editing: `scripts/render-config.py`, `scripts/extract-cursor-last-message.py`, `scripts/summarize.py`, `scenarios/javascript.jsonl`, `scenarios/typescript.jsonl`.

---

### Task 1: Fail the current sibling-plugin leak

**Files:**
- Modify: `tests/test-run-cursor-cohort.sh`

**Interfaces:**
- Consumes: existing `run-cursor-cohort.sh` flags; fake `agent` writes `$FAKE_RECORD/args` as one argv token per line.
- Produces: assertions that fail on today's runner, where `candidate/skills/language-guidance/SKILL.md` sits under the same `mktemp` parent as `workspaces/`.

- [ ] **Step 1: Write the failing isolation assertions**

In `tests/test-run-cursor-cohort.sh`, keep the existing fake `agent` that writes `"$@"` to `$FAKE_RECORD/args`. After the existing `no-guidance` block that already forbids `--plugin-dir` (the `record-ng` run), add this exact check. After the first successful `run_candidate` (the `record` run that already requires `--plugin-dir`), add the guided ancestor check. Insert the no-guidance check immediately after:

```
if grep -Fxq -- '--plugin-dir' "$TMP/record-ng/args"; then
  echo "no-guidance passed --plugin-dir" >&2
  exit 1
fi
```

Insert this:

```bash
python3 - "$TMP/record-ng/args" <<'PY'
from pathlib import Path
import sys

args = Path(sys.argv[1]).read_text(encoding="utf-8").splitlines()
assert "--plugin-dir" not in args, args
workspace = Path(args[args.index("--workspace") + 1]).resolve()

def ancestors(start):
    cur = start
    while True:
        yield cur
        if cur.parent == cur:
            return
        cur = cur.parent

workspace_root = None
for cur in ancestors(workspace):
    if (cur / "workspaces").is_dir():
        workspace_root = cur
        break
assert workspace_root is not None, workspace
hits = list(workspace_root.rglob("skills/language-guidance/SKILL.md"))
assert hits == [], hits
for cur in ancestors(workspace):
    assert not (cur / "skills" / "language-guidance" / "SKILL.md").is_file(), cur
    assert not (cur / "candidate" / "skills" / "language-guidance" / "SKILL.md").is_file(), cur
PY
```

Insert the guided check immediately after the existing:

```
grep -Fxq -- '--plugin-dir' "$TMP/record/args"
```

Insert this:

```bash
python3 - "$TMP/record/args" <<'PY'
from pathlib import Path
import sys

args = Path(sys.argv[1]).read_text(encoding="utf-8").splitlines()
assert "--plugin-dir" in args, args
workspace = Path(args[args.index("--workspace") + 1]).resolve()
plugin = Path(args[args.index("--plugin-dir") + 1]).resolve()

def ancestors(start):
    cur = start
    while True:
        yield cur
        if cur.parent == cur:
            return
        cur = cur.parent

workspace_root = None
for cur in ancestors(workspace):
    if (cur / "workspaces").is_dir():
        workspace_root = cur
        break
assert workspace_root is not None, workspace
ws = str(workspace_root)
pl = str(plugin)
assert pl != ws
assert not pl.startswith(ws + "/")
assert not ws.startswith(pl + "/")
assert plugin not in list(ancestors(workspace))
assert (plugin / "skills" / "language-guidance" / "SKILL.md").is_file(), plugin
assert list(workspace_root.rglob("skills/language-guidance/SKILL.md")) == []
PY
```

Do not change the Codex runner test files.

- [ ] **Step 2: Run the test to verify it fails**

Run:

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
bash tests/test-run-cursor-cohort.sh
```

Expected: FAIL. Today's runner extracts the full plugin into `$run_root/candidate` and materializes workspaces under the same `$run_root`, so the no-guidance Python block finds `candidate/skills/language-guidance/SKILL.md` on an ancestor, and/or the guided block finds `--plugin-dir` on the workspace ancestor chain. Do not implement the runner change before this failure is observed.

- [ ] **Step 3: Split workspace and plugin temps in the runner**

In `scripts/run-cursor-cohort.sh`, replace the single-root block that currently reads:

```bash
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
```

with this exact replacement. Keep the Darwin Keychain symlink block above it unchanged. Keep `agent_env`, `agent_version`, the scenario loop, `--sandbox enabled`, overwrite refusal, and metadata writer unchanged except `scenario_workspace` and `--plugin-dir` as shown.

```bash
workspace_root="$(mktemp -d)"
plugin_root=""
cleanup() {
  rm -rf "$workspace_root"
  if [[ -n "$plugin_root" ]]; then
    rm -rf "$plugin_root"
  fi
}
trap cleanup EXIT
fixture_archive="$workspace_root/fixtures.tar"
git -C "$candidate_repo" archive --format=tar --output="$fixture_archive" "$candidate_commit" tests/skills/fixtures/language-guidance
candidate_archive_sha="$(git -C "$candidate_repo" archive --format=tar "$candidate_commit" | shasum -a 256 | awk '{print $1}')"
selected="$workspace_root/selected"
mkdir -p "$selected"
candidate_tree=""
if [[ "$variant" != "no-guidance" ]]; then
  plugin_root="$(mktemp -d)"
  candidate_tree="$plugin_root"
  git -C "$candidate_repo" archive --format=tar "$candidate_commit" | tar -xf - -C "$candidate_tree"
  git -C "$candidate_tree" init -q
  git -C "$candidate_tree" config user.email eval@example.invalid
  git -C "$candidate_tree" config user.name "Wukong Code Evals"
  git -C "$candidate_tree" add .
  git -C "$candidate_tree" commit -qm "frozen candidate $candidate_commit"
fi
```

Delete the later line that currently hashes the on-disk tar:

```bash
candidate_archive_sha="$(shasum -a 256 "$candidate_archive" | awk '{print $1}')"
```

`candidate_archive_sha` is now computed before the scenario loop. Leave the metadata Python argv that already passes `"$candidate_archive_sha"` unchanged.

In the scenario loop, replace:

```bash
    scenario_workspace="$run_root/workspaces/$scenario_id/$repetition_name"
```

with:

```bash
    scenario_workspace="$workspace_root/workspaces/$scenario_id/$repetition_name"
```

Replace the guided plugin-dir assignment so a missing plugin root cannot pass an empty path:

```bash
    if [[ "$variant" != "no-guidance" ]]; then
      args+=(--plugin-dir "$candidate_tree")
    fi
```

If `variant` is not `no-guidance` and `candidate_tree` is empty, the script must already have created `plugin_root` in the setup block. Do not extract the plugin archive when `variant` is `no-guidance`. Do not place `plugin_root` under `workspace_root`.

- [ ] **Step 4: Run the test to verify it passes**

Run:

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
bash tests/test-run-cursor-cohort.sh
```

Expected: `STATUS: PASSED`. Confirm `git -C /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness diff -- scripts/run-cohort.sh` is empty.

- [ ] **Step 5: Document the disjoint temps**

In `README.md`, replace these three sentences:

```
Guided variants pass `--plugin-dir` at the frozen candidate tree. no-guidance
omits it. The runner sets `HOME` and XDG directories to `--cursor-home` so a
user-scoped Wukong Code install cannot leak into baseline sessions.
```

with:

```
The Cursor runner uses two disjoint mktemp roots. Workspaces get fixture
extracts only. Guided variants (`candidate`, `adversarial`) unpack the frozen
plugin into a second temp and pass it as `--plugin-dir`; that plugin root is
not the workspace, not a parent of it, and not a child of it. `no-guidance`
omits `--plugin-dir` and does not unpack the plugin archive, so
`skills/language-guidance/SKILL.md` is not on disk under the runner temps.
The runner sets `HOME` and XDG directories to `--cursor-home` so a
user-scoped Wukong Code install cannot leak into baseline sessions.
```

- [ ] **Step 6: Re-run tests and commit in the evals worktree**

Run:

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
bash tests/test-run-cursor-cohort.sh
git add scripts/run-cursor-cohort.sh tests/test-run-cursor-cohort.sh README.md
git commit -m "$(cat <<'EOF'
fix: isolate Cursor no-guidance workspaces from plugin files

EOF
)"
```

Expected: `STATUS: PASSED`, then a new evals commit. Do not push unless the human partner asks. Do not open a plugin PR from this commit. This evals change is one PR of its own when the human partner asks to publish it.

---

## Spec coverage

- Two disjoint `mktemp` roots: Task 1 setup replacement.
- `no-guidance` never unpacks plugin: `if [[ "$variant" != "no-guidance" ]]` extract guard.
- Guided `--plugin-dir` only: existing argv branch plus ancestor assertions.
- `--sandbox enabled` unchanged.
- Darwin Keychain symlink only: untouched.
- Fake-agent contract tests: Task 1 Python blocks.
- Codex `run-cohort.sh` untouched: Step 4 diff check.
- No README language-pack flip: README edit is evals runner docs only.
