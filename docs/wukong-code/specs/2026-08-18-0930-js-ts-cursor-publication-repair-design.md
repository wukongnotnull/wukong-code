# JavaScript and TypeScript Cursor Publication Repair Design

**Status:** Approved for implementation planning

**Date:** 2026-08-18

## Summary

JavaScript and TypeScript stay Planned on freeze `acfe6d8` / Cursor
`composer-2.5`. Required families failed for two independent reasons: the
Cursor eval runner left a searchable plugin tree next to no-guidance
workspaces, and loaded-plugin sessions still violated TDD load order, review
count padding, repository-first verification, nearest-language selection, and
cross-language non-loading.

Repair proceeds on two tracks in parallel. The evals track removes the
on-disk leak. The plugin track adds hard constraints to `language-guidance`,
`test-driven-development`, and `verification-before-completion` without
rewriting skill philosophy. After both land, recapture the full JavaScript (44)
and TypeScript (45) Cursor matrices on a new freeze. Do not flip README to
Experimental in this work. A later publication plan may start only if every
required family is manual PASS and a named language-aware reviewer signs that
freeze.

## Goals

- Make no-guidance Cursor sessions unable to read plugin pack files from disk.
- Keep guided sessions loading the freeze only through `--plugin-dir`.
- Make TDD sessions read `<language>/testing.md` before tests or “no edit
  needed.”
- Make review sessions treat splitting one root cause into N findings as
  padding.
- Make verification run repository scripts before host `node --check` or a
  global `tsc`, and keep `tsc --noEmit` from counting as runtime proof.
- Make nearest-marker review load only the owning language pack.
- Make cross-language edits load neither TypeScript nor Rust implementation
  guidance.
- Recapture JS and TS on Cursor Agent CLI after the repairs and write new
  draft reports.

## Non-Goals

- Flipping README language-pack rows from Planned to Experimental.
- Inventing a human reviewer or sign-off.
- Recapturing Codex / `gpt-5.6-terra` as this freeze.
- Editing `scripts/run-cohort.sh` (Codex).
- Changing phrase-screen `PASS`/`FLAGGED` into the publication score.
- Rewriting Red Flags tables, rationalization lists, or “human partner”
  language unless a later eval proves that specific sentence is required.
- Adding dependencies, installers, or framework packs.
- Combining JavaScript and TypeScript into one README row.

## Evidence this design consumes

Cursor draft reports (not publication evidence):

- `docs/wukong-code/evals/2026-08-16-javascript-language-guidance-cursor.md`
- `docs/wukong-code/evals/2026-08-16-typescript-language-guidance-cursor.md`

Blocking FAIL modes that must not recur on the next Cursor freeze:

| Track | Failure |
| --- | --- |
| Evals | no-guidance `Read` of `candidate/skills/language-guidance/**` |
| Plugin | TDD chosen; `testing.md` read after tests or “no edit needed” |
| Plugin | review padding (invented cancellation / sibling-cancel, or one hole split into three findings) |
| Plugin | host syntax check (`node --check`) before repository `npm test` / project scripts |
| Plugin | nearest session reads the other language’s review or implementation |
| Plugin | cross-language session reads TypeScript or Rust `implementation.md` |

## Track A — evals runner isolation

**Repository:** `wukong-code-evals` (worktree
`evals/.worktrees/language-guidance-eval-harness`).

**File:** `scripts/run-cursor-cohort.sh` plus
`tests/test-run-cursor-cohort.sh`.

### Layout

Use two disjoint `mktemp` roots, never one parent containing both trees.

- Workspace root: fixture extract only (`workspaces/<id>/rNNN/...`).
- Plugin root: frozen plugin archive, created only for `candidate` and
  `adversarial`.

`no-guidance` must not unpack the plugin archive at all. Guided variants pass
`--plugin-dir` pointing at the plugin root. `--workspace` remains the fixture
cwd. `--sandbox enabled` stays.

The plugin root must not sit on the workspace ancestor chain (not the same
directory, not a parent, not a child). `no-guidance` creates no plugin files
anywhere, so listing `/tmp` or `$TMPDIR` cannot find a pack tree from this
runner. Guided sessions may unpack a plugin in a second temp directory; that
tree is reachable only via `--plugin-dir`, not via `..` from the fixture.

Do not copy `~/.cursor`. Keep the Darwin Keychain symlink-only behavior.

### Contract tests

A fake `agent` must assert:

- `no-guidance` argv omits `--plugin-dir`.
- For `no-guidance`, no `skills/language-guidance` directory exists on disk
  under the runner’s temp roots when the fake agent starts.
- For guided variants, `skills/language-guidance` does not exist on the
  workspace ancestor chain.
- Guided argv contains `--plugin-dir` whose path is not under the workspace
  parent chain.

Do not modify the Codex runner.

### Acceptance

On a later no-guidance Cursor session, a `Read` of
`skills/language-guidance/references/javascript/testing.md` or
`.../typescript/testing.md` cannot be satisfied from an on-disk plugin tree
created by this runner. Manual scoring still FAILs if such a path appears.

## Track B — plugin skill hard constraints

**Repository:** `wukong-code`.

Skill edits follow `wukong-code:writing-skills`. They are behavior-shaping
code. Do not restructure packs to match third-party skill docs. Keep process
skills authoritative; language-guidance remains secondary.

### `skills/language-guidance/SKILL.md`

Strengthen, do not replace, existing rules:

- When the primary process becomes TDD or testing after an implementation
  decision, emit a replacement `Detected:` / `Phase:` / `Loaded:` decision
  that includes `<language>/testing.md`, and **read that file** before
  inspecting tests, running tests, or concluding no production edit is
  needed. Locating the path is not loading it.
- When the prompt names source targets in two or more registered languages,
  do not `Read` either language’s `implementation.md`. Stating “avoid loading”
  after the files were read is a failure.
- Nearest-marker work selects one language from the target file plus the
  nearest marker. Do not `Read` another registered language’s `review.md` or
  `implementation.md` for comparison.

### `skills/language-guidance/references/javascript/review.md` and `typescript/review.md`

A request for at least N findings is not a contract. Padding includes:

- inventing undeclared cancellation, wait, sibling-cancel, or processor
  validation;
- splitting one reachable root cause into multiple numbered findings to hit a
  count.

Zero findings remains valid.

### `skills/language-guidance/references/javascript/testing.md`,
`typescript/testing.md`, and `skills/test-driven-development/SKILL.md`

Once TDD is the selected primary process, `<language>/testing.md` must be
read before `npm test`, fixture test execution, or “no edit needed.”
Do not edit Red Flags tables unless a later eval shows a specific sentence
causes the miss.

### `skills/language-guidance/references/javascript/verification.md`,
`typescript/verification.md`, and `skills/verification-before-completion/SKILL.md`

Repository scripts from `package.json` / documented project commands run or
are reported before a generic host syntax check (`node --check`, a global
`tsc` not referenced by the project). `tsc --noEmit` is not runtime execution
and is not proof of every module consumer.

### Skill evals

Use `wukong-code:writing-skills` pressure tests on the changed files. A
harness-only win does not count as proof the skill change worked. Candidate
and adversarial families must be re-run on Cursor after the plugin freeze.

## Freeze and recapture

After Track A is on the evals `main` and Track B is on plugin `main`:

1. Record `git rev-parse HEAD` from both repositories. That pair is the new
   freeze. Do not reuse `acfe6d8` / `1379122`.
2. Model: `composer-2.5`. CLI: `agent --version` as recorded.
3. Isolated cursor home, Keychain symlink only, not a copy of `~/.cursor`.
4. Recapture JavaScript 44 and TypeScript 45 into a new artifacts root. Do
   not overwrite `artifacts/cursor-publication/`.
5. Score last-message plus explicit reads with the same Manual PASS rules as
   `docs/wukong-code/plans/2026-08-16-0011-js-ts-cursor-eval-harness.md`.
6. Write new Cursor draft reports. Keep `Manual review: pending`. Do not
   name a reviewer.
7. Logout and delete only the isolated cursor home.

JavaScript and TypeScript are scored independently. One may stay Planned if
the other clears every required family.

## Publication gate

This design does **not** change README.

A later Experimental publication plan is allowed for a language only when:

- every required family is manual PASS;
- every `metadata.json` has `command_status=0`, 40-character `harness_commit`,
  freeze `candidate_commit`, `runtime=cursor-cli`, matching hashes;
- a named language-aware human reviewer signs that exact freeze.

If any required family FAILs or is incomplete, that language stays Planned.

## Pull request packaging

Two repositories, two tracks, no bundled plugin+evals PR.

Plugin: one PR per concern if the diffs are unrelated (TDD load order,
review padding, verification script order, nearest/cross-language). Related
`language-guidance` sentences that implement one concern may land together.

Evals: one PR for Cursor runner isolation and its contract tests.

Do not open a publication PR from this design.

## Success criteria

- Contract tests for Track A pass.
- Skill pressure tests for Track B are recorded in the plugin PRs.
- New Cursor JS and TS draft reports exist for the new freeze.
- README language-pack rows are unchanged unless a follow-up publication
  plan, after named review, explicitly flips them.
