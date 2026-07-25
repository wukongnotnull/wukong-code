# Go Language Guidance Vertical Slice Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use wukong-code:subagent-driven-development (recommended) or wukong-code:executing-plans to implement this plan task-by-task. Steps use checkbox (- [ ]) syntax for tracking.

**Goal:** Add an evidence-driven secondary language-guidance skill that supplies Go-specific implementation, testing, debugging, review, and verification guidance without weakening Wukong Code primary process skills.

**Architecture:** Keep one portable routing skill under skills/language-guidance, a machine-checkable registry, and phase-specific references loaded progressively. Add one narrow secondary-skill rule to using-wukong-code. All harnesses keep using the shared skills tree; Codex packaging learns to prefer source-owned metadata for newly introduced skills.

**Tech Stack:** Markdown skills, JSON, Bash, Python standard library, Go official toolchain, existing harness tests, and adversarial LLM behavior evals.

## Global Constraints

- Scope is router plus Go only. Java, TypeScript, Swift, and their positive routing require separate plans and PRs.
- Zero new third-party dependencies.
- Framework guidance is out of scope.
- The existing primary process skill remains authoritative.
- Ambiguous or unsupported language evidence falls back to the language-agnostic workflow.
- Never install or update a compiler, formatter, linter, test framework, or dependency.
- Repository commands and configuration override language defaults.
- skills/language-guidance/SKILL.md is at most 180 lines.
- profile.md is at most 160 lines; every other phase reference is at most 200 lines.
- One routing decision loads at most two language references.
- Invoke wukong-code:writing-skills before implementation. Capture RED behavior before writing skill text.
- Preserve the using-wukong-code 1% rule, primary-workflow rule, Red Flags, and the todo-list brainstorming acceptance invariant.
- Do not open a PR before duplicate search, full human diff review, and explicit submission approval.
- Cross-check Go claims against primary sources before writing the pack: the
  official testing package documentation at https://pkg.go.dev/testing, context
  guidance at https://go.dev/blog/context and
  https://go.dev/blog/context-and-structs, the race detector at
  https://go.dev/doc/articles/race_detector, and Go security/tooling guidance at
  https://go.dev/doc/security/best-practices. Record the sources actually used
  in the eval report and PR template.

## File Map

| Path | Responsibility |
| --- | --- |
| skills/language-guidance/SKILL.md | Evidence detection, phase selection, progressive loading |
| skills/language-guidance/references/registry.json | Supported identifiers, markers, status, phase files |
| skills/language-guidance/references/shared/language-pack-contract.md | Contract for current and future language packs |
| skills/language-guidance/references/go/*.md | Go profile, implementation, testing, debugging, review, verification |
| skills/language-guidance/agents/openai.yaml | Source-owned Codex skill metadata |
| skills/using-wukong-code/SKILL.md | One secondary-domain routing rule |
| tests/skills/fixtures/language-guidance/* | Stable Go and monorepo behavior fixtures |
| tests/skills/language-guidance-scenarios.md | Exact prompts and scoring rubric |
| tests/skills/test-language-guidance.sh | Static contract and size gates |
| scripts/package-codex-plugin.sh | Source metadata first, official-package metadata fallback |
| tests/codex/test-package-codex-plugin.sh | New-skill packaging regression |
| docs/wukong-code/evals/2026-07-22-go-language-guidance.md | Actual RED/GREEN evidence |
| README.md | User-facing experimental support matrix |
| CLAUDE.md | Narrow language-level core exception |
| .github/PULL_REQUEST_TEMPLATE.md | Language-pack evidence requirements |
| docs/testing.md | Static and behavior test instructions |

---

### Task 1: Create fixtures and capture the failing behavior baseline

**Files:**
- Create: tests/skills/fixtures/language-guidance/go-basic/go.mod
- Create: tests/skills/fixtures/language-guidance/go-basic/fetch.go
- Create: tests/skills/fixtures/language-guidance/go-basic/fetch_test.go
- Create: tests/skills/fixtures/language-guidance/monorepo/web/tsconfig.json
- Create: tests/skills/fixtures/language-guidance/monorepo/web/app.ts
- Create: tests/skills/fixtures/language-guidance/monorepo/backend/go.mod
- Create: tests/skills/fixtures/language-guidance/monorepo/backend/worker.go
- Create: tests/skills/language-guidance-scenarios.md
- Create after real runs: docs/wukong-code/evals/2026-07-22-go-language-guidance.md

**Interfaces:**
- Consumes: current checkout without language-guidance
- Produces: reproducible fixtures, fixed prompts, rubric, and verbatim no-guidance controls

- [ ] **Step 1: Invoke writing-skills, then add the Go fixture**

Create go.mod:

    module example.com/language-guidance-fixture

    go 1.22

Create fetch.go:

    package fetch

    import "context"

    type Client interface {
        Fetch(context.Context, string) (string, error)
    }

    func FetchAll(ctx context.Context, client Client, urls []string) ([]string, error) {
        results := make([]string, 0, len(urls))
        for _, url := range urls {
            result, err := client.Fetch(ctx, url)
            if err != nil {
                return nil, err
            }
            results = append(results, result)
        }
        return results, nil
    }

Create fetch_test.go:

    package fetch

    import (
        "context"
        "errors"
        "testing"
    )

    type stubClient struct {
        result string
        err    error
    }

    func (s stubClient) Fetch(context.Context, string) (string, error) {
        return s.result, s.err
    }

    func TestFetchAllReturnsClientError(t *testing.T) {
        want := errors.New("fetch failed")
        _, got := FetchAll(context.Background(), stubClient{err: want}, []string{"/one"})
        if !errors.Is(got, want) {
            t.Fatalf("FetchAll error = %v; want %v", got, want)
        }
    }

Create the monorepo fixture:

    // web/tsconfig.json
    {
      "compilerOptions": {
        "strict": true
      }
    }

    // web/app.ts
    export const appName: string = "fixture";

    // backend/go.mod
    module example.com/language-guidance-monorepo/backend

    go 1.22

    // backend/worker.go
    package worker

    func Name() string { return "worker" }

- [ ] **Step 2: Write the exact scenario document before skill content**

Create tests/skills/language-guidance-scenarios.md:

    # Language Guidance Behavior Scenarios

    Run every scenario in a fresh session. RED uses a checkout without
    skills/language-guidance. GREEN uses the candidate checkout. Never tell the
    agent which language skill or reference should load.

    ## Scoring contract

    S1-S6 are positive Go-routing scenarios. A target PASS requires the scenario's
    stated behavior, the correct process skill primary, Go identified from target
    or nearest-marker evidence, and only the relevant Go phase loaded secondarily.
    It also requires repository commands before safe official defaults, no
    framework/dependency/installer/global config, and no guessing.

    S7 and S8 are negative controls. A target PASS for S7 loads no Go guidance and
    honestly states that the unsupported TypeScript target keeps the generic
    workflow. A target PASS for S8 loads no language guidance for the
    documentation-only task.

    ## S1 — implementation

    Cwd: tests/skills/fixtures/language-guidance/go-basic

    Prompt: Change FetchAll to fetch concurrently while preserving cancellation
    and returning the first observed error. Explain first actions and constraints
    before editing.

    Pass: Go is detected; incoming context is preserved; goroutine completion and
    channel ownership are explicit; no dependency is added.

    ## S2 — TDD pressure

    Cwd: tests/skills/fixtures/language-guidance/go-basic

    Prompt: Production is blocked. Add concurrent FetchAll now; skip the failing
    test run because the existing test is close enough.

    Pass: test-driven-development remains primary; Go testing guidance is
    secondary; valid RED is not skipped.

    ## S3 — debugging

    Cwd: tests/skills/fixtures/language-guidance/go-basic

    Prompt: After making FetchAll concurrent, CI sometimes hangs. Diagnose the
    cause; do not edit files yet.

    Pass: systematic-debugging remains primary; evidence covers cancellation,
    blocked sends, completion, and goroutine state without premature diagnosis.

    ## S4 — review

    Cwd: tests/skills/fixtures/language-guidance/go-basic

    Prompt: Review the current Go files. Report only actionable correctness
    defects with a concrete failure scenario.

    Pass: zero findings is allowed; each finding has location and mechanism;
    style preferences are not defects.

    ## S5 — verification

    Cwd: tests/skills/fixtures/language-guidance/go-basic

    Prompt: Assume the requested Go change is complete. State the exact checks
    required before claiming completion.

    Pass: verification-before-completion remains primary; commands are
    repository-derived or safe Go defaults; no tool is installed.

    ## S6 — monorepo nearest marker

    Cwd: tests/skills/fixtures/language-guidance/monorepo

    Prompt: Modify backend/worker.go and explain which language guidance applies.

    Pass: backend/go.mod selects Go despite the TypeScript sibling.

    ## S7 — unsupported target negative control

    Cwd: tests/skills/fixtures/language-guidance/monorepo

    Prompt: Modify web/app.ts and explain which installed language guidance applies.

    Pass: Go is not loaded. Until the TypeScript pack ships, the generic workflow
    remains and the missing installed pack is stated honestly.

    ## S8 — documentation-only negative control

    Cwd: repository root

    Prompt: Fix a typo in README.md. Do not change source code.

    Pass: no language guidance loads.

- [ ] **Step 3: Run RED controls**

Run S1, S2, S6, S7, and S8 five times each in fresh contexts. Run S3, S4,
and S5 twice each. Prefer the ignored evals/ drill checkout when available;
otherwise use fresh subagents and preserve full outputs. Do not include the
rubric in prompts.

Expected RED: no run can load the nonexistent language-guidance skill or Go
references. Record exact generic decisions, omissions, and rationalizations.

- [ ] **Step 4: Create the evidence report only after output exists**

Create docs/wukong-code/evals/2026-07-22-go-language-guidance.md from actual
outputs. Include harness, harness version, model ID, installed plugins, prompt,
repetition count, per-run verdict, and verbatim failure excerpts. Do not create
blank tables or placeholder rows. State whether drill was unavailable.

- [ ] **Step 5: Verify the fixture**

Run:

    cd tests/skills/fixtures/language-guidance/go-basic
    gofmt -w fetch.go fetch_test.go
    go test ./...

Expected: ok example.com/language-guidance-fixture.

- [ ] **Step 6: Commit RED evidence**

    git add tests/skills/fixtures/language-guidance tests/skills/language-guidance-scenarios.md docs/wukong-code/evals/2026-07-22-go-language-guidance.md
    git commit -m "test: capture Go language guidance baseline"

---

### Task 2: Add static contract tests and the complete Go pack

**Files:**
- Create: tests/skills/test-language-guidance.sh
- Create: skills/language-guidance/SKILL.md
- Create: skills/language-guidance/references/registry.json
- Create: skills/language-guidance/references/shared/language-pack-contract.md
- Create: skills/language-guidance/references/go/profile.md
- Create: skills/language-guidance/references/go/implementation.md
- Create: skills/language-guidance/references/go/testing.md
- Create: skills/language-guidance/references/go/debugging.md
- Create: skills/language-guidance/references/go/review.md
- Create: skills/language-guidance/references/go/verification.md

**Interfaces:**
- Consumes: process phase, target files, explicit language, nearest markers, repository commands
- Produces: Go or no selection, one phase, and no more than two reference paths

- [ ] **Step 1: Write the failing contract test**

Create tests/skills/test-language-guidance.sh:

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

    assert_max_lines() {
      lines="$(wc -l < "$1" | tr -d ' ')"
      if (( lines <= $2 )); then pass "$1: $lines lines"; else fail "$1: $lines lines, max $2"; fi
    }

    skill=skills/language-guidance/SKILL.md
    registry=skills/language-guidance/references/registry.json
    assert_file "$skill"
    assert_file "$registry"
    assert_file skills/language-guidance/references/shared/language-pack-contract.md

    for phase in profile implementation testing debugging review verification; do
      assert_file "skills/language-guidance/references/go/$phase.md"
    done

    if [[ -f "$skill" ]]; then
      assert_contains "$skill" "name: language-guidance"
      assert_contains "$skill" "description: Use when"
      assert_contains "$skill" "Primary process remains authoritative"
      assert_contains "$skill" "at most two"
      assert_contains "$skill" "Do not guess"
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
    assert set(data["languages"]) == {"go"}
    go = data["languages"]["go"]
    assert go["status"] == "experimental"
    assert go["extensions"] == [".go"]
    assert go["markers"] == ["go.mod", "go.work"]
    assert set(go["phases"]) == {
        "profile", "implementation", "testing", "debugging", "review", "verification"
    }
    for relative in go["phases"].values():
        assert (root / relative).is_file(), relative
    PY
      then pass "registry contract"; else fail "registry contract"; fi
    fi

    [[ -f skills/language-guidance/references/go/profile.md ]] &&
      assert_max_lines skills/language-guidance/references/go/profile.md 160
    for phase in implementation testing debugging review verification; do
      file="skills/language-guidance/references/go/$phase.md"
      [[ -f "$file" ]] && assert_max_lines "$file" 200
    done

    if rg -n 'curl.*\|[[:space:]]*(sh|bash)|go install[[:space:]]|brew install|apt(-get)? install' skills/language-guidance; then
      fail "installer command found"
    else
      pass "no installer commands"
    fi

    if (( failed )); then echo "STATUS: FAILED"; exit 1; fi
    echo "STATUS: PASSED"

- [ ] **Step 2: Prove static RED**

Run: bash tests/skills/test-language-guidance.sh

Expected: STATUS: FAILED with missing language-guidance paths.

- [ ] **Step 3: Create registry.json**

    {
      "version": 1,
      "languages": {
        "go": {
          "status": "experimental",
          "extensions": [".go"],
          "markers": ["go.mod", "go.work"],
          "phases": {
            "profile": "go/profile.md",
            "implementation": "go/implementation.md",
            "testing": "go/testing.md",
            "debugging": "go/debugging.md",
            "review": "go/review.md",
            "verification": "go/verification.md"
          }
        }
      }
    }

- [ ] **Step 4: Create the shared contract**

Create references/shared/language-pack-contract.md:

    # Language Pack Contract

    Every registered language implements profile, implementation, testing,
    debugging, review, and verification.

    ## Invariants

    - Repository evidence overrides pack defaults.
    - Language guidance remains secondary to the process skill.
    - Unsupported or ambiguous evidence produces no language selection.
    - One decision loads at most two references.
    - Packs do not install tools, change global config, require frameworks, or
      add dependencies.
    - Recommendations state observable applicability and important exceptions.
    - Review findings require a location and failure scenario.
    - Verification chooses CI/docs, repository scripts, declared tools, then
      safe official-toolchain defaults.

    New packs require failing controls, repeated GREEN runs, adversarial pressure,
    a language-aware human reviewer, and experimental status before release.

- [ ] **Step 5: Create SKILL.md**

    ---
    name: language-guidance
    description: Use when creating, changing, testing, debugging, reviewing, or verifying source code whose language can be identified from explicit task or repository evidence
    ---

    # Language Guidance

    ## Overview

    Load concrete language guidance only after the task primary process is known.
    **Primary process remains authoritative.** This skill supplies technical
    decisions; it never replaces design, TDD, debugging, review, or verification.

    ## When to Use

    Use for source work when a registered language is established by evidence.
    Do not use for documentation-only, unsupported-language, or ambiguous work.

    ## Detection Evidence

    Evaluate in order:

    1. Language explicitly named for the target work.
    2. Extension of target files.
    3. Nearest project marker above target files.
    4. Repository marker only when target paths are unknown.

    Read references/registry.json for supported identifiers. Nearest markers beat
    unrelated root files. **Do not guess.** Ask or return no selection when
    evidence conflicts.

    ## Phase Selection

    | Work | Phase |
    | --- | --- |
    | Design or plan for known language | profile |
    | Edit production source | profile and implementation |
    | Write or run tests | testing |
    | Investigate failure | debugging |
    | Review code | review |
    | Prove completion | verification |

    Load at most two references per decision. For cross-language work, state each
    target scope and process scopes separately when the limit would be exceeded.

    ## Repository-First Rule

    Inspect language version, module/build file, CI, scripts, tests, and nearby
    code before applying a reference. Existing evidence overrides pack examples.
    Do not introduce frameworks, dependencies, installers, or global config.

    ## Visible Decision

        Detected: <language and evidence>
        Phase: <phase>
        Loaded: <reference paths>

    Then resume the primary process. If no registered language matches, keep the
    generic workflow and do not claim guidance was loaded.

    ## Common Mistakes

    - Treating a root package file as proof for every monorepo target.
    - Loading every phase for possible future use.
    - Recommending familiar tools before repository commands.
    - Reporting style preferences as correctness rules.
    - Weakening the primary process gate.

- [ ] **Step 6: Create Go profile.md and implementation.md**

Create profile.md:

    # Go Project Profile

    ## Inspect Before Advising

    1. Read the nearest go.mod: module path, go directive, toolchain directive.
    2. Check go.work and determine which module owns the target.
    3. Inspect nearby .go and _test.go files for package, error, and test style.
    4. Read CI, Makefile, Taskfile, and scripts before proposing commands.
    5. Check generated files, build tags, cgo, and platform suffixes.

    ## Boundaries

    - Do not restructure packages without a task-driven reason.
    - Do not add a dependency when standard library or existing dependencies fit.
    - Do not assume a newer feature than the declared module/CI toolchain.
    - Use a focused package command for RED or diagnosis before broad verification.

Create implementation.md:

    # Go Implementation Guidance

    Apply only rules whose conditions occur in target code.

    ## Errors

    - Return errors to a handling boundary; avoid log-and-return duplication.
    - Wrap with percent-w when callers need errors.Is or errors.As.
    - Preserve established sentinel and typed-error contracts.

    ## Context and Cancellation

    - Pass an incoming context through blocking or remote operations.
    - Put context first; do not store it in a struct without an existing contract.
    - Call every derived-context cancel function on all paths.

    ## Concurrency Ownership

    Before starting a goroutine, identify who waits, how it stops, and who owns
    channel close. Avoid sends that can block after the owner returns. Specify
    ordering, first-error behavior, cancellation, and partial-result policy in
    tests before selecting a channel, mutex, or indexed result strategy.

    ## Interfaces, Data, Resources

    - Define an interface at the consuming boundary only when substitution helps.
    - Synchronize or copy maps, slice backing arrays, and pointers crossing owners.
    - Close resources at the acquiring layer unless ownership is transferred.
    - Place defer after successful acquire; use helper scope in long loops.

    ## Minimal Example

        func Load(ctx context.Context, client Client, id string) (Item, error) {
            item, err := client.Load(ctx, id)
            if err != nil {
                return Item{}, fmt.Errorf("load item %q: %w", id, err)
            }
            return item, nil
        }

    The example demonstrates propagation and wrapping, not required new types.

- [ ] **Step 7: Create Go testing.md and debugging.md**

Create testing.md:

    # Go Testing Guidance

    The active TDD skill controls RED-GREEN-REFACTOR.

    ## Discovery and RED

    Inspect existing _test.go files before choosing package style, table tests,
    helpers, parallel subtests, or existing third-party helpers.

        go test ./path/to/package -run '^TestName$/^Subtest$' -count=1

    Valid RED reaches the new test and fails for missing behavior. Syntax errors,
    unused imports, missing tools, and unrelated failures are invalid RED.

    ## GREEN and Expansion

        go test ./path/to/package -count=1
        go test ./...

    Use -race when concurrency is in scope and the environment supports it.
    A race run observes only executed paths.

    ## Test Design

    - Test behavior and error contracts, not private sequencing.
    - Use t.Cleanup for test-lifecycle cleanup.
    - With t.Parallel, verify fixture and captured-variable ownership.
    - Use tables only for cases sharing behavior and setup.
    - Add fuzzing only when the accepted task has a relevant input boundary.
    - Do not add a dependency when testing and existing helpers are sufficient.

Create debugging.md:

    # Go Debugging Guidance

    Systematic debugging remains authoritative. Gather evidence before fixes.

    ## Classify

    - Compile error: exact package, position, and declared Go version.
    - Test failure: focused rerun with -count=1.
    - Hang/leak: bounded timeout or goroutine stacks; blocked operations/creators.
    - Race: smallest reproducer under -race when supported; keep both stacks.
    - Panic: full stack and first application frame with a false invariant.

    ## Hypotheses Requiring Proof

    Typed nil interfaces; missing cancellation; blocked sends; shared map/slice/
    pointer ownership; defer in long loops; build tags, cgo, workspace, module
    replacements, and platform-specific selection.

    ## Focused Commands

        go test ./path/to/package -run '^TestName$' -count=1 -v
        go test ./path/to/package -run '^TestName$' -count=20
        go test -race ./path/to/package -run '^TestName$' -count=1
        go test ./path/to/package -run '^TestName$' -timeout=10s

    Reproduce, trace data/control flow, then change the smallest causal point.

- [ ] **Step 8: Create Go review.md and verification.md**

Create review.md:

    # Go Review Guidance

    Report only concrete failure modes with exact file and tight lines. Zero
    findings is valid.

    ## Check

    - Lost error identity across errors.Is/errors.As contracts.
    - Discarded context, missing propagation, or uncanceled derived context.
    - Goroutine without completion, blocking after owner return, or unsynchronized data.
    - Unclear channel close ownership, double close, or send after close.
    - Unsafe map, slice backing array, pointer, or resource ownership.
    - Cleanup skipped on reachable error path.
    - Feature newer than module or CI toolchain.
    - Exported behavior changed without appropriate tests/API consideration.

    Do not report naming, interface placement, table-test, or layout preferences
    without a project rule or failure scenario. Do not invent races.

Create verification.md:

    # Go Verification Guidance

    Verification-before-completion remains authoritative. Choose commands from
    CI/docs, repository scripts, declared tools, then safe Go defaults.

        gofmt -l <changed-go-files>
        go test ./path/to/changed/package
        go test ./...
        go vet ./...

    Any gofmt output is failure. Add -race only when concurrency is in scope and
    supported; report unsupported prerequisites instead of installing them.

    Report exact commands, exit codes, test counts when available, formatting
    output, and skipped checks. Do not claim one command proves another concern.
    For build tags, cgo, generated files, or platform files, state the verified
    target and remaining untested targets.

- [ ] **Step 9: Run static GREEN**

    bash tests/skills/test-language-guidance.sh
    bash tests/skills/test-skill-slim-gates.sh
    git diff --check

Expected: both scripts pass; diff check is silent.

- [ ] **Step 10: Record the standalone-pack boundary**

Run static GREEN and retain any explicit-invocation smoke evidence, but do not
claim a behavioral GREEN campaign for the standalone pack. The primary process
and secondary-language routing become one executable path only after Task 3
integrates language-guidance with using-wukong-code. Task 3 owns the complete
S1-S8 automatic-routing GREEN matrix; do not use partial standalone results as
a substitute for that matrix.

- [ ] **Step 11: Commit the independently reviewable pack**

    git add skills/language-guidance tests/skills/test-language-guidance.sh
    git commit -m "feat: add progressive Go language guidance"

---

### Task 3: Add automatic secondary routing

**Files:**
- Modify: tests/skills/test-language-guidance.sh
- Modify: skills/using-wukong-code/SKILL.md:50-59
- Modify: docs/wukong-code/evals/2026-07-22-go-language-guidance.md

**Interfaces:**
- Produces exactly one primary process plus optional language-guidance

- [ ] **Step 1: Add failing assertions**

Append:

    bootstrap=skills/using-wukong-code/SKILL.md
    assert_contains "$bootstrap" "## Secondary domain guidance"
    assert_contains "$bootstrap" "language-guidance"
    assert_contains "$bootstrap" "creating, modifying, testing, debugging, reviewing, or verifying source code"
    assert_contains "$bootstrap" "documentation-only"

- [ ] **Step 2: Verify RED**

Run: bash tests/skills/test-language-guidance.sh

Expected: missing secondary-domain strings.

- [ ] **Step 3: Insert the routing section before Progress budget**

    ## Secondary domain guidance

    After selecting the primary process, load language-guidance as a secondary
    domain skill when the task is creating, modifying, testing, debugging,
    reviewing, or verifying source code and a supported language is established
    from explicit target or repository evidence. It supplements technical
    decisions; the primary process remains authoritative.

    Do not load language guidance for documentation-only work, unsupported
    languages, or ambiguous evidence. Do not preload every language or phase.
    Let language-guidance select the smallest relevant reference set.

Do not edit the 1% rule, routing table, primary bullets, budget, or Red Flags.

- [ ] **Step 4: Static GREEN and protected invariants**

    bash tests/skills/test-language-guidance.sh
    rg -n "1% chance|Load \*\*exactly one\*\* primary|## Red Flags" skills/using-wukong-code/SKILL.md
    bash tests/skills/test-skill-slim-gates.sh

Expected: both tests pass and all protected patterns print.

- [ ] **Step 5: Automatic-routing GREEN**

Run S1, S2, S6, S7, S8 five times each; S3-S5 twice. Do not name the skill.
S1-S6 must route Go by phase. S7 must not load Go. S8 must not load language
guidance. Mixed key runs are failures, not average PASS. Append actual output.

- [ ] **Step 6: Re-run bootstrap acceptance**

Fresh-session prompt: Let's make a react todo list

Expected: brainstorming before code. No TypeScript pack is claimed.

- [ ] **Step 7: Commit**

    git add skills/using-wukong-code/SKILL.md tests/skills/test-language-guidance.sh docs/wukong-code/evals/2026-07-22-go-language-guidance.md
    git commit -m "feat: route Go source work to language guidance"

---

### Task 4: Package source-owned metadata for Codex

**Files:**
- Create: skills/language-guidance/agents/openai.yaml
- Modify: tests/codex/test-package-codex-plugin.sh:120-180
- Modify: scripts/package-codex-plugin.sh:258-275

**Interfaces:**
- Consumes source metadata or prior-package fallback metadata
- Produces one openai.yaml per packaged skill

- [ ] **Step 1: Add failing package regression**

After metadata fixture creation:

    rm -rf "$metadata_source/skills/language-guidance"

After archive path assertions:

    assert_contains "$archive_paths" "skills/language-guidance/agents/openai.yaml" "archive keeps source metadata"
    language_metadata="$(read_archive_file "$archive" skills/language-guidance/agents/openai.yaml)"
    assert_contains "$language_metadata" "display_name: \"Language Guidance\"" "uses source metadata"

- [ ] **Step 2: Verify RED**

Run: bash tests/codex/test-package-codex-plugin.sh

Expected: missing metadata for language-guidance.

- [ ] **Step 3: Create source metadata**

    interface:
      display_name: "Language Guidance"
      short_description: "Apply evidence-based language guidance to source work"
      default_prompt: "Apply the relevant language guidance to this coding task."
    policy:
      allow_implicit_invocation: true

- [ ] **Step 4: Prefer source, then fallback**

Replace the metadata loop body:

    missing_metadata=0
    while IFS= read -r skill_dir; do
      skill_name="$(basename "$skill_dir")"
      source_metadata="$skill_dir/agents/openai.yaml"
      fallback_metadata="$METADATA_ROOT/skills/$skill_name/agents/openai.yaml"

      if [[ -f "$source_metadata" ]]; then
        continue
      fi
      if [[ ! -f "$fallback_metadata" ]]; then
        echo "Missing OpenAI agent metadata for skill: $skill_name" >&2
        missing_metadata=1
        continue
      fi
      mkdir -p "$skill_dir/agents"
      cp "$fallback_metadata" "$skill_dir/agents/openai.yaml"
    done < <(find "$STAGE/skills" -mindepth 1 -maxdepth 1 -type d -print | sort)

    if [[ "$missing_metadata" -ne 0 ]]; then
      die "metadata source is incomplete"
    fi

- [ ] **Step 5: Verify packaging**

    bash tests/codex/test-package-codex-plugin.sh
    bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh

Expected: both exit 0; source metadata assertion passes.

- [ ] **Step 6: Commit**

    git add skills/language-guidance/agents/openai.yaml scripts/package-codex-plugin.sh tests/codex/test-package-codex-plugin.sh
    git commit -m "fix(codex): package source-owned skill metadata"

---

### Task 5: Document support and governance

**Files:**
- Modify: tests/skills/test-language-guidance.sh
- Modify: README.md:159-220
- Modify: CLAUDE.md:11-18,56-59
- Modify: .github/PULL_REQUEST_TEMPLATE.md:35-46,109-128
- Modify: docs/testing.md:1-35

**Interfaces:**
- Consumes: shipped experimental Go pack and completed behavior evidence
- Produces: honest support status, a narrow core-policy exception, PR evidence fields, and reproducible test instructions

- [ ] **Step 1: Add failing docs assertions**

    assert_contains README.md "## Language Guidance"
    assert_contains README.md "| Go | Experimental |"
    assert_contains CLAUDE.md "### Language-level skills"
    assert_contains .github/PULL_REQUEST_TEMPLATE.md "## Language-pack evidence"
    assert_contains docs/testing.md "test-language-guidance.sh"

- [ ] **Step 2: Verify RED**

Run: bash tests/skills/test-language-guidance.sh

Expected: all five documentation assertions fail.

- [ ] **Step 3: Add README section before What Is Inside**

    ## Language Guidance

    Wukong Code keeps methodology language-agnostic, then loads concrete
    language guidance when target files and nearby markers provide evidence.
    Only the current language and phase load; unsupported or ambiguous work keeps
    the generic workflow.

    | Language | Status | Implementation | Testing | Debugging | Review | Verification | Evidence |
    | --- | --- | --- | --- | --- | --- | --- | --- |
    | Go | Experimental | ✓ | ✓ | ✓ | ✓ | ✓ | Eval report |
    | Java | Planned | — | — | — | — | — | — |
    | TypeScript | Planned | — | — | — | — | — | — |
    | Swift | Planned | — | — | — | — | — | — |

    Experimental means initial behavior evals exist but real-project evidence is
    still accumulating. Packs never install tools or override repository
    commands. Framework guidance remains outside core. Link Go Eval report to
    docs/wukong-code/evals/2026-07-22-go-language-guidance.md; that report must
    record the verified fixture/toolchain, eval date, known limitations, and the
    named language-aware reviewer or maintenance responsibility. Do not publish
    Experimental status until those fields contain real evidence.

Also list language-guidance under a Language implementation skill category.

- [ ] **Step 4: Add narrow CLAUDE.md exception**

After Domain-specific skills:

    ### Language-level skills

    Language-level implementation guidance is the narrow exception to the
    domain-specific rule. It may live in core only when broadly applicable
    across projects in that language, based on official toolchains or tools
    already present, zero-dependency, composable with process skills, and backed
    by failing controls plus repeated behavior evals.

    Frameworks, cloud services, databases, business domains, and team standards
    remain standalone plugins. Packs start experimental and need a human reviewer
    familiar with the language before stable status.

Refine pre-PR check 4 to point to this exception.

- [ ] **Step 5: Add PR evidence section**

After Evaluation:

    ## Language-pack evidence

    - Language and support status:
    - Real failure generic methodology handled incorrectly:
    - Project markers and toolchain versions:
    - Official sources:
    - No-guidance repetitions and failures:
    - With-guidance repetitions and results:
    - Monorepo, unsupported-language, and docs-only controls:
    - Human reviewer familiar with the language:
    - Frameworks or third-party preferences introduced:

The final line must be none for a core language pack.

- [ ] **Step 6: Document testing**

Add:

    ### Language guidance

    Run static contracts with:

        bash tests/skills/test-language-guidance.sh

    Behavior prompts live in tests/skills/language-guidance-scenarios.md.
    Run no-guidance controls before edits, repeat candidate prompts in fresh
    sessions, and record harness, model, repetitions, full failures, and verdicts
    in docs/wukong-code/evals. Static strings are not behavior evidence.

- [ ] **Step 7: Verify and commit**

    bash tests/skills/test-language-guidance.sh
    bash tests/skills/test-skill-slim-gates.sh
    git diff --check
    git add README.md CLAUDE.md .github/PULL_REQUEST_TEMPLATE.md docs/testing.md tests/skills/test-language-guidance.sh
    git commit -m "docs: govern experimental language packs"

---

### Task 6: Full regression, evidence finalization, and human gate

**Files:**
- Modify: docs/wukong-code/evals/2026-07-22-go-language-guidance.md
- Modify other files only for verified failures

**Interfaces:**
- Consumes: complete candidate implementation, fixed scenarios, and all supported harness test entrypoints
- Produces: fresh regression evidence, a final before/after record, and a complete diff ready for human review

- [ ] **Step 1: Run full local verification**

    bash tests/skills/test-language-guidance.sh
    bash tests/skills/test-skill-slim-gates.sh
    bash tests/hooks/test-session-start.sh
    bash tests/opencode/run-tests.sh
    bash tests/kimi/run-tests.sh
    node --test tests/pi/test-pi-extension.mjs
    bash tests/codex/test-package-codex-plugin.sh
    bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh
    bash scripts/lint-shell.sh
    git diff --check

Expected: every command exits 0. Missing platform tools are explicit unverified
limits, not passes.

- [ ] **Step 2: Run final behavior matrix**

Repeat S1, S2, S6, S7, S8 five times; S3-S5 twice. At least one supported
Harness must discover the skill automatically. Re-run the todo-list prompt.

Expected: key repetitions converge; all other runs pass; no unsupported pack is
claimed.

- [ ] **Step 3: Finalize evidence without placeholders**

Report model/harness/version/plugins, candidate SHA, exact repetition counts,
before/after results, every inconsistent excerpt, bootstrap result, command
summary, absence of positive TypeScript routing, and evidence-limited conclusion.

Run:

    ! rg -n 'TBD|TODO|FIXME|PLACEHOLDER|paste results|fill in' docs/wukong-code/evals/2026-07-22-go-language-guidance.md

Expected: exit 0 with no output.

- [ ] **Step 4: Review complete diff against design**

    git diff --check
    git status --short
    git diff --stat
    git diff -- skills/language-guidance skills/using-wukong-code/SKILL.md tests/skills scripts/package-codex-plugin.sh tests/codex/test-package-codex-plugin.sh README.md CLAUDE.md .github/PULL_REQUEST_TEMPLATE.md docs/testing.md docs/wukong-code/evals

Confirm every requirement maps to code, test, eval, or an explicitly deferred
language plan. Confirm no Java, TypeScript, Swift, or framework content entered.

- [ ] **Step 5: Request two reviews**

Use requesting-code-review for implementation. Obtain human review from someone
familiar with Go for reference content. After any skill-text edit, rerun affected
static and behavior checks.

- [ ] **Step 6: Commit final evidence**

    git add docs/wukong-code/evals/2026-07-22-go-language-guidance.md
    git commit -m "test: record Go language guidance evals"

- [ ] **Step 7: Stop before PR**

Search open and closed PRs, populate every PR-template field with real evidence,
show the complete diff to the human partner, and target dev. Do not create a PR
without explicit approval.
