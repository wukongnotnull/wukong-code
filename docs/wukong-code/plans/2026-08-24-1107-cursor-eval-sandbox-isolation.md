# Cursor Eval Sandbox Isolation Probe Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Prove what `--sandbox enabled` actually does for no-guidance Reads of the operator plugin checkout and `~/.cursor/plugins/local`, without inventing a path-deny flag or loading a skill sentence that no-guidance never sees.

**Architecture:** Keep `--sandbox enabled`, `--force`, `--trust`, and no `--add-dir`. Add a dry-run probe whose argv contract is unit-tested with the fake agent. Run the live probe once with real `agent` and record whether those host paths are readable. Recapture still scores a successful host-pack Read as FAIL; this plan does not create a scoring exemption.

**Tech Stack:** Bash 3.2+, Python 3 standard library, existing fake `agent` in `tests/test-run-cursor-cohort.sh`, Cursor Agent CLI for the live probe only.

## Global Constraints

- Repository: `wukong-code-evals` worktree `/Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness`.
- Continue on branch `cursor/language-guidance-eval-harness`. Do not merge to evals `main` from this plan.
- Do not modify `scripts/run-cohort.sh` (Codex).
- Add no package-manager dependency.
- Keep `--sandbox enabled`. Do not add `--worktree`. Do not add `--add-dir`.
- Do not copy `~/.cursor`. Darwin Keychain remains symlink-only.
- `no-guidance` argv must omit `--plugin-dir`.
- Do not drop `--force` on eval sessions. Headless evals must not wait for approvals.
- Do not sweep Darwin `T` / `/tmp` for other processes' temps.
- Do not flip README language-pack rows. Do not open a publication PR from this plan.
- The runner is bash. Keep `status=$?` in the runner as-is. Never name a zsh variable `status`; use `run_status` in any new wrapper.
- Never print `CURSOR_API_KEY`.

## File map

| Path | Responsibility |
| --- | --- |
| `scripts/probe-cursor-sandbox-reads.sh` | Dry-run argv printer and live host-path Read probe |
| `tests/test-run-cursor-cohort.sh` | No-guidance argv contract plus probe dry-run contract |
| `README.md` | Document probe, no path-deny, and that host-pack Reads remain FAIL |

Reuse without editing: `scripts/run-cursor-cohort.sh` unless a unit test proves no-guidance argv is missing `--sandbox enabled` or `--force`. Do not change retry, nested temps, or `--plugin-dir` omission.

---

### Task 1: Dry-run probe argv contract

**Files:**
- Create: `scripts/probe-cursor-sandbox-reads.sh`
- Modify: `tests/test-run-cursor-cohort.sh`
- Modify: `README.md`

**Interfaces:**
- Consumes: existing leftover no-guidance argv asserts (`--plugin-dir` omitted, `--add-dir` omitted).
- Produces: `probe-cursor-sandbox-reads.sh --dry-run` prints one flag per line; tests assert `--sandbox`, `enabled`, `--force`, `--trust`, `--workspace`, and the absence of `--plugin-dir` and `--add-dir`.

- [ ] **Step 1: Write the failing dry-run contract**

In `tests/test-run-cursor-cohort.sh`, immediately after the leftover `--add-dir` / operator-checkout argv asserts and before `rm -rf "$leftover_unpack"`, add:

```bash
grep -Fxq -- '--sandbox' "$TMP/record-ng-leftover/args"
grep -Fxq -- 'enabled' "$TMP/record-ng-leftover/args"
grep -Fxq -- '--force' "$TMP/record-ng-leftover/args"
grep -Fxq -- '--trust' "$TMP/record-ng-leftover/args"

PROBE="$ROOT/scripts/probe-cursor-sandbox-reads.sh"
if [[ ! -x "$PROBE" ]]; then
  echo "missing executable probe-cursor-sandbox-reads.sh" >&2
  exit 1
fi
"$PROBE" --dry-run --workspace "$TMP/candidate/tests/skills/fixtures/language-guidance/javascript-basic" \
  --model test-model --agent-bin "$TMP/bin/agent" >"$TMP/probe-argv"
grep -Fxq -- '--print' "$TMP/probe-argv"
grep -Fxq -- '--sandbox' "$TMP/probe-argv"
grep -Fxq -- 'enabled' "$TMP/probe-argv"
grep -Fxq -- '--force' "$TMP/probe-argv"
grep -Fxq -- '--trust' "$TMP/probe-argv"
grep -Fxq -- '--workspace' "$TMP/probe-argv"
if grep -Fxq -- '--plugin-dir' "$TMP/probe-argv"; then
  echo "sandbox probe dry-run passed --plugin-dir" >&2
  exit 1
fi
if grep -Fxq -- '--add-dir' "$TMP/probe-argv"; then
  echo "sandbox probe dry-run passed --add-dir" >&2
  exit 1
fi
```

- [ ] **Step 2: Run the test to verify it fails**

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
CURSOR_EVAL_EMPTY_RETRY_SLEEP=0 bash tests/test-run-cursor-cohort.sh
```

Expected: FAIL with `missing executable probe-cursor-sandbox-reads.sh` or a missing `--sandbox` grep on leftover args. Do not write the probe script until this failure is observed. If leftover args already contain `--sandbox`/`enabled`/`--force`/`--trust`, the failure must still be the missing probe script.

- [ ] **Step 3: Write the probe script**

Create `scripts/probe-cursor-sandbox-reads.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

dry_run=0
workspace=""
model="composer-2.5"
agent_bin="agent"
operator_checkout="${WUKONG_CODE_OPERATOR_CHECKOUT:-/Users/wukong/Documents/wukong-code}"
operator_plugin="${WUKONG_CODE_OPERATOR_PLUGIN:-/Users/wukong/.cursor/plugins/local/wukong-code}"

usage() {
  echo "usage: probe-cursor-sandbox-reads.sh [--dry-run] --workspace PATH [--model MODEL] [--agent-bin PATH]" >&2
  exit 2
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --dry-run) dry_run=1; shift ;;
    --workspace) workspace="$2"; shift 2 ;;
    --model) model="$2"; shift 2 ;;
    --agent-bin) agent_bin="$2"; shift 2 ;;
    *) usage ;;
  esac
done

[[ -n "$workspace" ]] || usage
workspace="$(cd "$workspace" && pwd -P)"

args=(--print --output-format stream-json --force --trust --sandbox enabled --workspace "$workspace" --model "$model")

if [[ "$dry_run" -eq 1 ]]; then
  printf '%s\n' "${args[@]}"
  exit 0
fi

prompt="Read these two paths if the tools allow it and quote the first heading from each file that opens: ${operator_checkout}/skills/language-guidance/SKILL.md and ${operator_plugin}/skills/language-guidance/SKILL.md. If a Read is denied, report denied and do not search other copies."

set +e
"$agent_bin" "${args[@]}" "$prompt"
run_status=$?
set -e
exit "$run_status"
```

```bash
chmod +x /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness/scripts/probe-cursor-sandbox-reads.sh
```

Do not add `--add-dir`. Do not add `--plugin-dir`. Do not add `--worktree`. Do not disable sandbox.

- [ ] **Step 4: Run the test to verify it passes**

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
CURSOR_EVAL_EMPTY_RETRY_SLEEP=0 bash tests/test-run-cursor-cohort.sh
```

Expected: `STATUS: PASSED`.

- [ ] **Step 5: Document the probe**

In `README.md`, immediately after the paragraph that ends with `A no-guidance Read of the operator checkout …/Documents/wukong-code/skills/language-guidance/** is still a publication FAIL and must fail recapture smoke.`, add:

```
`scripts/probe-cursor-sandbox-reads.sh --dry-run` prints the no-plugin argv
used to ask Cursor whether `--sandbox enabled` actually denies Reads of the
operator checkout and `~/.cursor/plugins/local/wukong-code`. The runner still
never passes `--add-dir`. A successful host-pack Read remains a no-guidance
FAIL; the probe does not create a scoring exemption. Record the live probe
result in the recapture freeze notes.
```

- [ ] **Step 6: Commit**

```bash
cd /Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
git add scripts/probe-cursor-sandbox-reads.sh tests/test-run-cursor-cohort.sh README.md
git commit -m "$(cat <<'EOF'
test: lock Cursor sandbox probe argv without path-deny flags

EOF
)"
```

---

### Task 2: Live probe with real agent

**Files:**
- Create (ignored): `artifacts/cursor-publication-repair-5/sandbox-probe.md`

**Interfaces:**
- Consumes: Task 1 executable probe and a human-installed `agent`.
- Produces: a freeze note stating whether operator checkout and local-plugin Reads succeeded under `--sandbox enabled --force`.

- [ ] **Step 1: Confirm `agent` exists without installing it**

```bash
command -v agent
agent --version
```

Expected: a version string. Do not run `curl https://cursor.com/install`.

- [ ] **Step 2: Run the live probe**

Use an isolated HOME (Keychain symlink only). Do not copy `~/.cursor`. Source `/tmp/wukong-code-cursor-api-key.env` if present. Never print `CURSOR_API_KEY`.

```bash
EVAL_ROOT=/Users/wukong/Documents/wukong-code/evals/.worktrees/language-guidance-eval-harness
PLUGIN_ROOT=/Users/wukong/Documents/wukong-code/.worktrees/js-ts-skill-hard-constraints
eval_auth_root="$(mktemp -d)"
printf '%s\n' "$eval_auth_root" > /tmp/wukong-code-cursor-eval-auth-root.txt
mkdir -p "$eval_auth_root/cursor-home/Library"
test ! -e "$eval_auth_root/cursor-home/.cursor"
if [[ "$(uname -s)" == Darwin && -d "${HOME}/Library/Keychains" ]]; then
  ln -s "${HOME}/Library/Keychains" "$eval_auth_root/cursor-home/Library/Keychains"
fi
if [[ -z "${CURSOR_API_KEY:-}" && -f /tmp/wukong-code-cursor-api-key.env ]]; then
  set -a
  # shellcheck disable=SC1091
  . /tmp/wukong-code-cursor-api-key.env
  set +a
fi
mkdir -p "$EVAL_ROOT/artifacts/cursor-publication-repair-5"
HOME="$eval_auth_root/cursor-home" \
  "$EVAL_ROOT/scripts/probe-cursor-sandbox-reads.sh" \
  --workspace "$PLUGIN_ROOT/tests/skills/fixtures/language-guidance/javascript-basic" \
  --model composer-2.5 \
  --agent-bin agent \
  >"$EVAL_ROOT/artifacts/cursor-publication-repair-5/sandbox-probe.events.jsonl"
```

If `composer-2.5` is not listed by `HOME="$eval_auth_root/cursor-home" agent --list-models`, stop.

- [ ] **Step 3: Score the probe and write the note**

Search `sandbox-probe.events.jsonl` for successful `Read` of:

- `/Users/wukong/Documents/wukong-code/skills/language-guidance/`
- `/Users/wukong/Documents/wukong-code/.worktrees/` plus `skills/language-guidance/`
- `/Users/wukong/.cursor/plugins/local/wukong-code/skills/language-guidance/`

Write `artifacts/cursor-publication-repair-5/sandbox-probe.md` with exactly one of:

```
sandbox_blocks_host_pack_reads=yes
```

or

```
sandbox_blocks_host_pack_reads=no
```

plus the CLI version and model. Do not commit this file. If `=no`, do not change runner flags and do not add a skill sentence. Recapture-5 still FAILs those Reads.

- [ ] **Step 4: Logout only the probe home if recapture will create a new one**

If the sibling recapture-5 plan will reuse `/tmp/wukong-code-cursor-eval-auth-root.txt`, leave it. If not:

```bash
eval_auth_root="$(cat /tmp/wukong-code-cursor-eval-auth-root.txt)"
HOME="$eval_auth_root/cursor-home" agent logout || true
test -n "$eval_auth_root"
test "$eval_auth_root" != /
test "$eval_auth_root" != /Users/wukong
rm -rf -- "$eval_auth_root"
rm -f /tmp/wukong-code-cursor-eval-auth-root.txt
test -d /Users/wukong/.cursor && echo 'global ~/.cursor untouched'
```

---

## Spec coverage

- Dry-run argv without `--add-dir` / `--plugin-dir`: Task 1.
- Live probe of host-pack Reads: Task 2.
- No scoring exemption: Task 2 Step 3.
- No README language-pack flip: Global Constraints.

## Execution handoff

Skill constraints are `2026-08-24-1107-js-ts-skill-hard-constraints.md`. Recapture-5 is `2026-08-24-1107-js-ts-cursor-recapture.md`.
