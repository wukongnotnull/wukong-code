#!/usr/bin/env python3
"""Same (prompt, cwd) fixtures must match hook JSON and SKILL.md priority."""

from __future__ import annotations

import json
import os
import re
import subprocess
import sys
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[2]
HOOKS = REPO_ROOT / "hooks"
SKILL = REPO_ROOT / "skills" / "language-guidance" / "SKILL.md"

sys.path.insert(0, str(HOOKS))
from language_router import decide  # noqa: E402


SKILL_PHASE_TABLE = (
    ("Design or plan with no requested source edit", "profile"),
    (
        "Requested production-source edit, including brainstorming or pre-edit analysis",
        "implementation",
    ),
    ("Write or run tests", "testing"),
    ("Investigate failure", "debugging"),
    ("Review code", "review"),
    ("Prove completion", "verification"),
)

SKILL_PRECEDENCE = (
    "Explicit failure investigation, code review, and completion verification "
    "intent takes precedence over generic no-edit analysis.",
    "A requested test-source edit selects the testing phase even when the task "
    "also requests a production-source edit.",
)

# Prompt-visible work kinds, first match wins. Matches the skill table plus the
# documented investigation / review / verification / testing precedence. This is
# not a copy of phase_for() regexes; fixtures are labeled by the skill row they
# exercise.
SKILL_PRIORITY = (
    "debugging",
    "review",
    "verification",
    "testing",
    "profile",
    "implementation",
)


def rust_basic() -> Path:
    return REPO_ROOT / "tests/skills/fixtures/language-guidance/rust-basic"


def java_basic() -> Path:
    return REPO_ROOT / "tests/skills/fixtures/language-guidance/java-basic"


def javascript_basic() -> Path:
    return REPO_ROOT / "tests/skills/fixtures/language-guidance/javascript-basic"


def monorepo() -> Path:
    return REPO_ROOT / "tests/skills/fixtures/language-guidance/monorepo"


def go_basic() -> Path:
    return REPO_ROOT / "tests/skills/fixtures/language-guidance/go-basic"


def fixtures() -> list[dict[str, object]]:
    return [
        {
            "name": "Investigate failure selects debugging",
            "prompt": "Investigate a failure in src/lib.rs.",
            "cwd": rust_basic(),
            "skill_work": "Investigate failure",
            "expected_kind": "guidance",
            "expected_language": "rust",
        },
        {
            "name": "Review code selects review over plan wording",
            "prompt": "Review src/lib.rs for correctness and API risks. Plan the approach.",
            "cwd": rust_basic(),
            "skill_work": "Review code",
            "expected_kind": "guidance",
            "expected_language": "rust",
        },
        {
            "name": "Prove completion selects verification over plan wording",
            "prompt": "Verify the exact checks before claiming this change is complete. Plan the approach.",
            "cwd": rust_basic(),
            "skill_work": "Prove completion",
            "expected_kind": "guidance",
            "expected_language": "rust",
        },
        {
            "name": "Write or run tests selects testing over a production edit",
            "prompt": "Add a regression test for src/lib.rs and change process_all.",
            "cwd": rust_basic(),
            "skill_work": "Write or run tests",
            "expected_kind": "guidance",
            "expected_language": "rust",
        },
        {
            "name": "Design or plan with no source edit selects profile",
            "prompt": "Plan a change to src/lib.rs.",
            "cwd": rust_basic(),
            "skill_work": "Design or plan with no requested source edit",
            "expected_kind": "guidance",
            "expected_language": "rust",
        },
        {
            "name": "Requested production-source edit selects implementation",
            "prompt": "Change process_all so it returns the processed items.",
            "cwd": rust_basic(),
            "skill_work": "Requested production-source edit, including brainstorming or pre-edit analysis",
            "expected_kind": "guidance",
            "expected_language": "rust",
        },
        {
            "name": "Java testing pressure is a test-source / production-blocked request",
            "prompt": (
                "Production is blocked. Make processAll concurrent now; skip the "
                "failing test run because the existing test is close enough."
            ),
            "cwd": java_basic(),
            "skill_work": "Write or run tests",
            "expected_kind": "guidance",
            "expected_language": "java",
        },
        {
            "name": "English Let's go is not a named Go language",
            "prompt": "Let's go implement a change.",
            "cwd": javascript_basic(),
            "skill_work": "Requested production-source edit, including brainstorming or pre-edit analysis",
            "expected_kind": "guidance",
            "expected_language": "javascript",
        },
        {
            "name": "Cross-language targets keep the generic workflow",
            "prompt": "Modify web/app.ts and rust-worker/src/lib.rs.",
            "cwd": monorepo(),
            "skill_work": None,
            "expected_kind": "mixed",
            "expected_language": None,
        },
        {
            "name": "Unsupported Python target keeps the generic workflow",
            "prompt": "Modify scripts/example.py and explain which installed language guidance applies. Do not create the file.",
            "cwd": REPO_ROOT,
            "skill_work": None,
            "expected_kind": "unsupported",
            "expected_language": None,
        },
        {
            "name": "Documentation-only prompt makes no language selection",
            "prompt": "Fix a typo in README.md.",
            "cwd": REPO_ROOT,
            "skill_work": None,
            "expected_kind": "none",
            "expected_language": None,
        },
        # Chinese prompts exercise the same skill rows; the hook must not be
        # English-only when the user writes in 中文.
        {
            "name": "Chinese investigate failure selects debugging",
            "prompt": "fetch.go 的测试失败了，查一下原因。",
            "cwd": go_basic(),
            "skill_work": "Investigate failure",
            "expected_kind": "guidance",
            "expected_language": "go",
        },
        {
            "name": "Chinese review selects review over plan wording",
            "prompt": "请review一下src/lib.rs的错误处理，顺便给个方案。",
            "cwd": rust_basic(),
            "skill_work": "Review code",
            "expected_kind": "guidance",
            "expected_language": "rust",
        },
        {
            "name": "Chinese prove completion selects verification over plan wording",
            "prompt": "验证一下 src/lib.rs 的改动是否真的完成了，再给个后续方案。",
            "cwd": rust_basic(),
            "skill_work": "Prove completion",
            "expected_kind": "guidance",
            "expected_language": "rust",
        },
        {
            "name": "Chinese write tests selects testing over a production edit",
            "prompt": "给 src/lib.rs 补一个回归测试，然后修改 process_all。",
            "cwd": rust_basic(),
            "skill_work": "Write or run tests",
            "expected_kind": "guidance",
            "expected_language": "rust",
        },
        {
            "name": "Chinese testing pressure is a test-source / production-blocked request",
            "prompt": "线上阻塞了，先跳过失败的测试直接改 fetch.go。",
            "cwd": go_basic(),
            "skill_work": "Write or run tests",
            "expected_kind": "guidance",
            "expected_language": "go",
        },
        {
            "name": "Chinese plan with no source edit selects profile",
            "prompt": "规划一下 src/lib.rs 的改动方案。",
            "cwd": rust_basic(),
            "skill_work": "Design or plan with no requested source edit",
            "expected_kind": "guidance",
            "expected_language": "rust",
        },
        {
            "name": "Chinese production-source edit selects implementation",
            "prompt": "修改fetch.go，让它保留返回顺序。",
            "cwd": go_basic(),
            "skill_work": "Requested production-source edit, including brainstorming or pre-edit analysis",
            "expected_kind": "guidance",
            "expected_language": "go",
        },
        {
            "name": "Chinese 和-coordinated cross-language targets keep the generic workflow",
            "prompt": "修改 web/app.ts 和 rust-worker/src/lib.rs。",
            "cwd": monorepo(),
            "skill_work": None,
            "expected_kind": "mixed",
            "expected_language": None,
        },
        {
            "name": "Chinese unsupported Python target keeps the generic workflow",
            "prompt": "修改 scripts/example.py，说明适用哪个语言指导。不要创建文件。",
            "cwd": REPO_ROOT,
            "skill_work": None,
            "expected_kind": "unsupported",
            "expected_language": None,
        },
        {
            "name": "Chinese documentation-only prompt makes no language selection",
            "prompt": "修复 README.md 里的错别字。",
            "cwd": REPO_ROOT,
            "skill_work": None,
            "expected_kind": "none",
            "expected_language": None,
        },
    ]


def skill_phase_for_work(work: str) -> str:
    for row_work, phase in SKILL_PHASE_TABLE:
        if row_work == work:
            return phase
    raise AssertionError(f"unknown skill work row: {work}")


def hook_output(prompt: str, cwd: Path, home: Path, plugin_root: Path = REPO_ROOT) -> str:
    payload = json.dumps(
        {
            "hook_event_name": "UserPromptSubmit",
            "cwd": str(cwd),
            "prompt": prompt,
        }
    )
    env = {
        "PATH": os.environ.get("PATH", ""),
        "HOME": str(home),
        "PLUGIN_ROOT": str(plugin_root),
    }
    completed = subprocess.run(
        ["bash", str(plugin_root / "hooks" / "run-hook.cmd"), "user-prompt-submit"],
        input=payload,
        text=True,
        capture_output=True,
        check=False,
        env=env,
    )
    if completed.returncode != 0:
        raise AssertionError(
            f"hook exited {completed.returncode}: {completed.stdout}{completed.stderr}"
        )
    return completed.stdout


def parse_hook_context(output: str) -> str | None:
    if not output.strip():
        return None
    payload = json.loads(output)
    context = payload["hookSpecificOutput"]["additionalContext"]
    if not isinstance(context, str) or not context.strip():
        raise AssertionError("hook additionalContext was empty")
    return context


def assert_skill_document() -> None:
    text = SKILL.read_text(encoding="utf-8")
    for work, phase in SKILL_PHASE_TABLE:
        row = f"| {work} | {phase} |"
        if row not in text:
            raise AssertionError(f"SKILL.md is missing documented phase row: {row}")
    for sentence in SKILL_PRECEDENCE:
        if sentence not in text:
            raise AssertionError(f"SKILL.md is missing documented priority: {sentence}")
    table = text.split("## Phase Selection", 1)[1].split("## Repository-First Rule", 1)[0]
    found_phases = re.findall(
        r"\| (profile|implementation|testing|debugging|review|verification) \|",
        table,
    )
    if set(found_phases) != set(SKILL_PRIORITY):
        raise AssertionError(f"SKILL.md phase table drifted: {found_phases}")


def assert_thin_wrapper() -> None:
    source = (HOOKS / "user-prompt-submit.py").read_text(encoding="utf-8")
    if "from language_router import decide" not in source:
        raise AssertionError("hook must call language_router.decide")
    for forbidden in ("def phase_for", "def target_language", "registry.json"):
        if forbidden in source:
            raise AssertionError(f"hook is no longer a thin wrapper; found {forbidden}")
    for path, label in (
        (HOOKS / "hooks.json", "Claude"),
        (HOOKS / "hooks-cursor.json", "Cursor"),
    ):
        text = path.read_text(encoding="utf-8")
        if "user-prompt-submit" in text or "UserPromptSubmit" in text:
            raise AssertionError(f"{label} hook config must stay unwired to language routing")


def run() -> int:
    failures = 0

    def fail(message: str) -> None:
        nonlocal failures
        failures += 1
        print(f"  [FAIL] {message}")

    def passed(message: str) -> None:
        print(f"  [PASS] {message}")

    try:
        assert_skill_document()
        passed("SKILL.md still documents the phase table and precedence")
    except AssertionError as error:
        fail(str(error))

    try:
        assert_thin_wrapper()
        passed("user-prompt-submit.py only reads stdin, calls decide, wraps JSON")
    except AssertionError as error:
        fail(str(error))

    home = Path(os.environ["CONTRACT_HOME"])
    for fixture in fixtures():
        name = str(fixture["name"])
        prompt = str(fixture["prompt"])
        cwd = Path(str(fixture["cwd"]))
        expected_kind = str(fixture["expected_kind"])
        expected_language = fixture["expected_language"]
        skill_work = fixture["skill_work"]
        expected_phase = skill_phase_for_work(str(skill_work)) if skill_work else None

        try:
            decision = decide(prompt, cwd, REPO_ROOT)
            output = hook_output(prompt, cwd, home)
            context = parse_hook_context(output)
        except (AssertionError, KeyError, json.JSONDecodeError, OSError) as error:
            fail(f"{name}: {error}")
            continue

        if decision.additional_context != context:
            fail(f"{name}: decide() context != hook additionalContext")
            continue
        if decision.kind != expected_kind:
            fail(f"{name}: kind {decision.kind!r} != {expected_kind!r}")
            continue
        if expected_kind == "none":
            if context is not None:
                fail(f"{name}: expected empty hook output")
                continue
        elif context is None:
            fail(f"{name}: expected hook additionalContext")
            continue
        if expected_phase is not None:
            if decision.phase != expected_phase:
                fail(
                    f"{name}: decide phase {decision.phase!r} != SKILL.md "
                    f"{expected_phase!r} ({skill_work})"
                )
                continue
            if context is None or f"Phase: {expected_phase}" not in context:
                fail(f"{name}: hook output missing Phase: {expected_phase}")
                continue
        if expected_language and decision.language != expected_language:
            fail(f"{name}: language {decision.language!r} != {expected_language!r}")
            continue
        if expected_kind == "mixed" and (
            context is None or "Multiple registered languages are in scope" not in context
        ):
            fail(f"{name}: hook did not abstain on mixed languages")
            continue
        if expected_kind == "unsupported" and (
            context is None or "No installed language guidance is registered" not in context
        ):
            fail(f"{name}: hook did not report unsupported language")
            continue
        passed(f"{name} (hook + SKILL.md {expected_phase or expected_kind})")

    if failures:
        print(f"STATUS: FAILED ({failures} failure(s))")
        return 1
    print("STATUS: PASSED")
    return 0


if __name__ == "__main__":
    raise SystemExit(run())
