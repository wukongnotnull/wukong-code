# Eval Harness Setup

Skill-behavior evals live in a separate repository and are cloned locally into
`evals/`. That directory is gitignored in this repo so harness code, artifacts,
and credentials never ship with the plugin.

## Clone

```bash
git clone https://github.com/wukongnotnull/wukong-code-evals.git evals
```

For language-guidance Cursor/Codex cohorts, use a worktree or branch from that
repository (see `docs/wukong-code/plans/2026-08-16-0011-js-ts-cursor-eval-harness.md`).

## Local quick start

```bash
cd evals
uv sync --extra dev
export ANTHROPIC_API_KEY=sk-...
uv run drill run triggering-test-driven-development -b claude
```

See `evals/README.md` after cloning for authentication, manifest validation, and
runner scripts (`run-cohort.sh`, `run-cursor-cohort.sh`).

## Tiered automation model

| Tier | What runs | When | Needs API keys |
| --- | --- | --- | --- |
| **Static** | `validate-manifest.py` on scenario JSONL | Weekly + manual `workflow_dispatch` (`.github/workflows/evals-static.yml`) | No |
| **Core plugin** | `npm run test:extended` | Every PR/push (`.github/workflows/test.yml`) | No |
| **Full behavioral** | Drill / Cursor cohort matrices | Manual on-demand; nightly when secrets and budget are configured | Yes |

The static workflow pins `wukong-code-evals` at harness commit
`c63a0ffe6bd2333d6c564869fb18d3f1513d2bf4` on branch
`codex/language-guidance-eval-harness` (the only branch that ships
`scenarios/*.jsonl` and `scripts/validate-manifest.py`; `main` does not).
Both values live in the `env` block of `.github/workflows/evals-static.yml`.
Bump them together when manifest validation should track a newer harness
commit; `tests/test-automation/test-test-runner.sh` fails if this document and
the workflow disagree.

If the harness branch history is rewritten, the clone step fails with an
explicit `EVALS_COMMIT ... is not reachable` error instead of a bare
`fatal: unable to read tree`. Re-pin to a commit that exists on the branch.

Full LLM sessions are slow (minutes per scenario) and are intentionally
outside the required PR gate. Use static manifest validation to catch broken
scenario definitions early; run behavioral cohorts before claiming publication
readiness.

## Isolation requirements (Cursor language-guidance)

Cross-session pack `Read` failures usually mean eval temp layout leaked a guided
plugin unpack. Follow:

- `docs/wukong-code/plans/2026-08-20-2126-cursor-eval-plugin-tmp-isolation.md`
- `docs/wukong-code/plans/2026-08-24-1107-cursor-eval-sandbox-isolation.md`

Never copy `~/.cursor` or `~/.codex/auth.json` into eval homes.
