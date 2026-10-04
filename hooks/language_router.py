#!/usr/bin/env python3
"""Registry-driven language and phase decision for Codex prompt routing."""

from __future__ import annotations

import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Any


DOCUMENTATION_EXTENSIONS = {".adoc", ".md", ".rst", ".txt"}
# File paths are ASCII so a CJK character next to a path ("修改main.go，")
# counts as a boundary. Python's \w and \b treat CJK as word characters and
# would swallow the surrounding prose into the path or refuse to match.
_PATH = r"[A-Za-z0-9_./-]+\.[A-Za-z0-9]+"
_PATH_START = r"(?<![A-Za-z0-9_.])"
_PATH_END = r"(?![A-Za-z0-9_])"
SOURCE_EXTENSION = re.compile(rf"{_PATH_START}({_PATH}){_PATH_END}")
_ACTION_VERBS_EN = r"change|modify|make|add|implement|fix|refactor|update"
# 编辑(?!器) keeps "编辑器" (editor, a noun) from reading as an edit request.
_ACTION_VERBS_ZH = (
    r"修改|更改|改动|改一下|调整|编辑(?!器)|实现|添加|新增|增加|修复|修好|重构|重写|改写|迁移|更新|优化"
)
# "修改 main.go" / "修改main.go" and object-fronting "给 main.go 加…" / "把 main.go 改成…".
ACTION_TARGET = re.compile(
    rf"(?:\b(?:{_ACTION_VERBS_EN})\s+(?:the\s+)?"
    rf"|(?:{_ACTION_VERBS_ZH})\s*(?:一下\s*)?"
    rf"|(?:给|把|将|对|为)\s*)"
    rf"({_PATH}){_PATH_END}",
    re.IGNORECASE,
)
# "a.ts and b.ts" / "a.ts, b.ts" / "a.ts、b.ts" / "a.ts 和 b.ts".
COORDINATED_TARGET = re.compile(
    rf"\s*(?:,?\s+and|,|、|，|\s*(?:和|与|及|以及|跟)\s*)\s*({_PATH}){_PATH_END}",
    re.IGNORECASE,
)
TESTING_PRESSURE_WORKFLOW = """Mandatory primary workflow for this request:

Before source analysis, a plan, or an edit, invoke and read `wukong-code:test-driven-development`.
The requested source change requires a new focused test and an observed valid RED before production implementation. Do not treat an existing nearby test, a compiler error, an undiscovered test, or a skipped test run as RED evidence. If the request forbids the valid RED, do not propose or implement the production change; report it as unverified.

"""
DEBUGGING_UNOBSERVED_WORKFLOW = """Mandatory investigation constraint for this request:

If the existing test suite passes and does not observe the claimed symptom, the symptom is undefined. Do not name a root cause. A self-authored fail-fast, hang, or cleanup probe does not define the user symptom.

"""
DEBUGGING_JS_COMPLETION_CONSTRAINT = """If the existing suite passes and does not observe completion order, do not name Promise.all fail-fast as the cause of that test.

"""


@dataclass(frozen=True)
class LanguageDecision:
    """Structured result of one registry-driven language/phase decision."""

    kind: str
    additional_context: str | None = None
    language: str | None = None
    language_name: str | None = None
    owner: str | None = None
    phase: str | None = None
    delivered: tuple[str, ...] = ()


EMPTY_DECISION = LanguageDecision(kind="none")


def explicit_language_guidance_workflow(
    language_name: str, phase: str, relative_paths: list[str]
) -> str:
    loaded = ", ".join(relative_paths)
    return f"""Strict explicit language-guidance decision is required.

The user explicitly invoked `$language-guidance`. Before any substantive
analysis, command, or conclusion, begin the response with these exact labels on
separate lines:
Detected: {language_name} — <repository evidence>
Phase: {phase}
Loaded: {loaded}

Read the delivered reference before continuing. A no-command constraint blocks
project commands, not repository inspection or the selected reference. Do not
invent wrappers, modules, profiles, tools, or unverified scope.

"""


def owner_with_distance(directory: Path, markers: list[str]) -> tuple[Path, int] | None:
    current = directory.resolve(strict=False)
    for distance, candidate in enumerate((current, *current.parents)):
        if any((candidate / marker).exists() for marker in markers):
            return candidate, distance
    return None


def owner_for(directory: Path, markers: list[str]) -> Path | None:
    match = owner_with_distance(directory, markers)
    return match[0] if match else None


def extension_languages(languages: dict[str, Any]) -> dict[str, str]:
    return {
        extension.lower(): language
        for language, data in languages.items()
        for extension in data["extensions"]
    }


# Language names are ASCII; "用Rust实现" names Rust even with no spaces.
_NAME_START = r"(?<![A-Za-z0-9_])"
_NAME_END = r"(?![A-Za-z0-9_])"
_GO_TOKEN = re.compile(rf"{_NAME_START}go(?:lang)?{_NAME_END}", re.IGNORECASE)
_ENGLISH_GO_PREFIX = re.compile(r"(?:let'?s|please)\s+$", re.IGNORECASE)
_ENGLISH_GO_AHEAD = re.compile(r"^\s+ahead\b", re.IGNORECASE)
_ENGLISH_GO_IMPERATIVE = re.compile(
    r"^\s+(?:implement|fix|add|change|update|make|modify|refactor|write|create|run)\b",
    re.IGNORECASE,
)
# ASCII sentence punctuation still needs whitespace; CJK full-width punctuation does not.
_SENTENCE_START = re.compile(r"(?:\A|[.!?]\s+|[。！？]\s*)\Z")


def _is_english_go_idiom(prompt: str, match: re.Match[str]) -> bool:
    if match.group(0).lower() != "go":
        return False
    prefix = prompt[: match.start()]
    suffix = prompt[match.end() :]
    if _ENGLISH_GO_PREFIX.search(prefix):
        return True
    if _ENGLISH_GO_AHEAD.match(suffix):
        return True
    return bool(
        _SENTENCE_START.search(prefix) and _ENGLISH_GO_IMPERATIVE.match(suffix)
    )


def _go_language_matches(prompt: str) -> list[re.Match[str]]:
    return [
        match
        for match in _GO_TOKEN.finditer(prompt)
        if not _is_english_go_idiom(prompt, match)
    ]


def named_language_matches(prompt: str, language: str) -> list[re.Match[str]]:
    if language == "go":
        return _go_language_matches(prompt)
    return list(
        re.finditer(rf"{_NAME_START}{re.escape(language)}{_NAME_END}", prompt, re.IGNORECASE)
    )


def named_languages(prompt: str, languages: dict[str, Any]) -> list[str]:
    found: list[tuple[int, str]] = []
    for language in languages:
        matches = named_language_matches(prompt, language)
        if matches:
            found.append((matches[0].start(), language))
    found.sort()
    return [name for _, name in found]


def named_language(prompt: str, languages: dict[str, Any]) -> str | None:
    names = named_languages(prompt, languages)
    return names[0] if len(names) == 1 else None


def mixed_named_languages(prompt: str, languages: dict[str, Any]) -> list[str] | None:
    names = named_languages(prompt, languages)
    return names if len(names) > 1 else None


def prompt_targets(prompt: str, languages: dict[str, Any]) -> list[Path]:
    source_matches = SOURCE_EXTENSION.findall(prompt)
    if not source_matches:
        return []

    action_matches = ACTION_TARGET.findall(prompt)
    if action_matches:
        first_action = action_matches[0]
        action_tail = prompt[prompt.lower().find(first_action.lower()) + len(first_action) :]
        targets = [Path(match) for match in action_matches]
        while coordinated := COORDINATED_TARGET.match(action_tail):
            targets.append(Path(coordinated.group(1)))
            action_tail = action_tail[coordinated.end() :]
        return list(dict.fromkeys(targets))

    non_documentation_sources = [
        Path(match)
        for match in source_matches
        if Path(match).suffix.lower() not in DOCUMENTATION_EXTENSIONS
    ]
    if non_documentation_sources:
        return list(dict.fromkeys(non_documentation_sources))

    marker_names = {
        marker for data in languages.values() for marker in data["markers"]
    }
    marker_targets = [Path(match) for match in source_matches if Path(match).name in marker_names]
    return marker_targets if len(marker_targets) == 1 else []


def target_selection(
    target: Path, cwd: Path, languages: dict[str, Any]
) -> tuple[str, Path] | None:
    extension = target.suffix.lower()
    try:
        candidate = (cwd / target).resolve(strict=False)
        candidate.relative_to(cwd.resolve(strict=False))
    except ValueError:
        return None

    language = extension_languages(languages).get(extension)
    if language:
        owner = owner_for(candidate.parent, languages[language]["markers"])
        return (language, owner) if owner else None

    marker_languages = [
        language
        for language, data in languages.items()
        if target.name in data["markers"]
    ]
    if len(marker_languages) == 1:
        language = marker_languages[0]
        owner = owner_for(candidate.parent, languages[language]["markers"])
        return language, owner or candidate.parent
    return None


def mixed_registered_languages(
    prompt: str, cwd: Path, languages: dict[str, Any]
) -> list[str] | None:
    targets = prompt_targets(prompt, languages)
    if len(targets) < 2:
        return None
    names: list[str] = []
    for target in targets:
        selection = target_selection(target, cwd, languages)
        if selection is not None:
            names.append(selection[0])
    unique = list(dict.fromkeys(names))
    return unique if len(unique) > 1 else None


def target_language(prompt: str, cwd: Path, languages: dict[str, Any]) -> tuple[str, Path] | None:
    targets = prompt_targets(prompt, languages)
    if targets:
        selections = [target_selection(target, cwd, languages) for target in targets]
        if any(selection is None for selection in selections):
            return None
        unique = list(dict.fromkeys(selection for selection in selections if selection))
        return unique[0] if len(unique) == 1 else None

    if SOURCE_EXTENSION.search(prompt):
        return None

    names = named_languages(prompt, languages)
    if len(names) > 1:
        return None
    if len(names) == 1:
        language = names[0]
        owner = owner_for(cwd, languages[language]["markers"])
        return (language, owner) if owner else None

    candidates: list[tuple[str, Path, int]] = []
    for language, data in languages.items():
        match = owner_with_distance(cwd, data["markers"])
        if match:
            owner, distance = match
            candidates.append((language, owner, distance))
    if not candidates:
        return None
    nearest_distance = min(distance for _, _, distance in candidates)
    nearest = [
        (language, owner)
        for language, owner, distance in candidates
        if distance == nearest_distance
    ]
    return (nearest[0][0], nearest[0][1]) if len(nearest) == 1 else None


def unregistered_source_extension(prompt: str, languages: dict[str, Any]) -> str | None:
    targets = prompt_targets(prompt, languages)
    if len(targets) != 1:
        return None
    target = targets[0]
    extension = target.suffix.lower()
    if extension in extension_languages(languages) or extension in DOCUMENTATION_EXTENSIONS:
        return None
    return extension


def _kw(pattern: str) -> str:
    """ASCII-boundary keyword: like \\b but a CJK neighbour still counts as a boundary."""
    return rf"{_NAME_START}(?:{pattern}){_NAME_END}"


# A bounded gap that stays inside one Chinese clause, so "验证，然后修改" does not
# pair 验证 with a 修改 from the next clause.
_IN_CLAUSE = r"[^，。；,;!?！？]{0,20}"

# Phase cues, English and Chinese, in SKILL.md precedence order: investigation,
# review, and verification intent beat generic no-edit analysis; test-source work
# beats a production edit. The English alternatives are the original regexes with
# ASCII boundaries. Chinese has no word boundaries, so a cue is either a word that
# only ever means that phase (排查, 死锁, 评审) or a word that doubles as a feature
# noun (验证 = validation, 定位 = CSS position, 审核 = approval flow, 挂起 =
# suspend) constrained to the phrase shape that means the phase.
_PHASE_PATTERNS: tuple[tuple[str, re.Pattern[str]], ...] = (
    (
        "debugging",
        re.compile(
            rf"{_NAME_START}(?:diagnos|hang|deadlock|investigat|failure)"
            r"|调试|排查|排错|诊断|调查|卡死|卡住|挂死|挂了|挂起了|死锁|崩溃|闪退"
            rf"|(?:查|找|定位){_IN_CLAUSE}(?:原因|根因|问题所在|问题(?:出)?在哪|哪里(?:出|有|不)|bug|故障)"
            rf"|定位{_IN_CLAUSE}问题"
            r"|(?:失败|报错|出错)(?:的)?原因"
            rf"|为什么{_IN_CLAUSE}(?:失败|报错|出错|不通过|不对|异常|挂)",
        ),
    ),
    ("review", re.compile(_kw(r"review(?:ing)?") + r"|审查|评审|审阅|走查")),
    (
        "verification",
        re.compile(
            _kw(r"verif(?:y|ies|ied|ying|ication)|exact checks?|claim(?:ing)? (?:this )?complete")
            + r"|核实"
            + rf"|(?:验证|核验)(?:一下|下)?{_IN_CLAUSE}(?:是否|有没有|是不是|完成|通过|正确|无误|生效)"
            + r"|确认.{0,8}(?:完成|通过|正确|无误)|证明.{0,8}完成|(?:声称|宣称).{0,6}完成",
        ),
    ),
    (
        "testing",
        re.compile(
            _kw(r"skip|skipping") + r".*(?:failing|failed).*" + _kw(r"test")
            + r"|" + _kw(r"production (?:is )?blocked")
            + r"|" + _kw(r"add|write|create|run|update") + r".*" + _kw(r"test|tests|testing")
            + r"|" + _kw(r"regression\s+test")
            + r"|跳过.{0,12}测试|不(?:要|用|必|需要)?(?:跑|运行|执行).{0,6}测试"
            + r"|(?:线上|生产|上线|发布).{0,6}(?:阻塞|受阻|被堵|堵住)"
            + r"|(?:加(?!载)|写|补|增加|添加|新增|编写|补充|创建|运行|跑|执行|更新).{0,12}(?:测试|单测|用例)"
            + r"|回归测试|单元测试|单测",
        ),
    ),
    (
        "profile",
        re.compile(
            _kw(r"plan|design|approach|architecture")
            + r"|规划|计划|方案|设计|架构|思路|怎么(?:做|改|实现|设计)|如何(?:做|改|实现|设计)",
        ),
    ),
    (
        "implementation",
        re.compile(
            _kw(_ACTION_VERBS_EN)
            + rf"|{_ACTION_VERBS_ZH}|改成|改为|改掉|写一个|加一个|加上|去掉|删除|删掉|替换",
        ),
    ),
)


def phase_for(prompt: str) -> str | None:
    prompt = prompt.lower()
    for phase, pattern in _PHASE_PATTERNS:
        if pattern.search(prompt):
            return phase
    return None


def safe_reference(plugin_root: Path, relative_path: str) -> Path | None:
    root = (plugin_root / "skills" / "language-guidance" / "references").resolve()
    candidate = (root / relative_path).resolve(strict=False)
    try:
        candidate.relative_to(root)
    except ValueError:
        return None
    return candidate if candidate.is_file() else None


def load_registry(plugin_root: Path) -> dict[str, Any]:
    return json.loads(
        (plugin_root / "skills" / "language-guidance" / "references" / "registry.json").read_text(
            encoding="utf-8"
        )
    )


def decide(prompt: str, cwd: str | Path, plugin_root: str | Path) -> LanguageDecision:
    """Select language, phase, and injected context from prompt + registry evidence."""
    plugin_root = Path(plugin_root).resolve()
    try:
        registry = load_registry(plugin_root)
        languages = registry["languages"]
        cwd_path = Path(cwd).resolve(strict=False)
        selection = target_language(prompt, cwd_path, languages)
        phase = phase_for(prompt)
        unsupported_extension = unregistered_source_extension(prompt, languages)
        mixed = mixed_registered_languages(prompt, cwd_path, languages)
        if mixed is None and not prompt_targets(prompt, languages):
            mixed = mixed_named_languages(prompt, languages)
        if mixed:
            display = ", ".join(
                languages[name].get("display_name", name.capitalize()) for name in mixed
            )
            context = (
                "Deterministic Codex language routing\n\n"
                f"Multiple registered languages are in scope: {display}.\n"
                "Do not invoke language-guidance, emit a language decision, or load either "
                "language's references. State each target scope separately and keep the "
                "generic workflow until the human partner selects one target.\n"
            )
            return LanguageDecision(kind="mixed", additional_context=context)
        if not selection and unsupported_extension and phase:
            context = (
                "Deterministic Codex language routing\n\n"
                f"No installed language guidance is registered for {unsupported_extension}.\n"
                "Do not invoke language-guidance, emit a language decision, or invent a language pack, "
                "reference path, or phase. Keep the generic workflow.\n"
            )
            return LanguageDecision(
                kind="unsupported",
                additional_context=context,
                phase=phase,
            )
        if not selection or not phase:
            return EMPTY_DECISION
        language, owner = selection
        phase_paths = languages[language]["phases"]
        relative_paths = (
            [phase_paths["profile"], phase_paths["implementation"]]
            if phase == "implementation"
            else [phase_paths[phase]]
        )
        references = [safe_reference(plugin_root, relative_path) for relative_path in relative_paths]
        if any(reference is None for reference in references):
            return EMPTY_DECISION
        bodies = [reference.read_text(encoding="utf-8").strip() for reference in references if reference]
    except (KeyError, OSError, TypeError, ValueError, json.JSONDecodeError):
        return EMPTY_DECISION

    language_name = languages[language].get("display_name", language.capitalize())
    workflow = TESTING_PRESSURE_WORKFLOW if phase == "testing" else ""
    if phase == "debugging":
        workflow = DEBUGGING_UNOBSERVED_WORKFLOW
        if language == "javascript":
            workflow += DEBUGGING_JS_COMPLETION_CONSTRAINT
    if "$language-guidance" in prompt:
        workflow += explicit_language_guidance_workflow(language_name, phase, relative_paths)
    delivered = ", ".join(relative_paths)
    body = "\n\n".join(bodies)
    context = (
        "Deterministic Codex language routing\n\n"
        f"Language: {language_name}\n"
        f"Evidence: {owner}\n"
        f"Phase: {phase}\n"
        f"Delivered: {delivered}\n\n"
        "This hook has already delivered the selected language guidance for this turn; "
        "do not select another language unless new user evidence supersedes it.\n"
    )
    if phase == "implementation":
        context += (
            "If the primary process later becomes TDD or testing, read the selected "
            "language's testing.md before inspecting tests, running tests, or concluding "
            "no production edit is needed.\n"
        )
    context += f"\n{workflow}{body}\n"
    return LanguageDecision(
        kind="guidance",
        additional_context=context,
        language=language,
        language_name=language_name,
        owner=str(owner),
        phase=phase,
        delivered=tuple(relative_paths),
    )
