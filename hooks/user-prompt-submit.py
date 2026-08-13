#!/usr/bin/env python3
"""Inject one or two evidence-backed language references for a Codex user prompt."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path
from typing import Any


DOCUMENTATION_EXTENSIONS = {".adoc", ".md", ".rst", ".txt"}
SOURCE_EXTENSION = re.compile(r"(?<![\w.])([\w./-]+\.[A-Za-z0-9]+)\b")
ACTION_TARGET = re.compile(
    r"\b(?:change|modify|make|add|implement|fix|refactor|update)\s+"
    r"(?:the\s+)?([\w./-]+\.[A-Za-z0-9]+)\b",
    re.IGNORECASE,
)
TESTING_PRESSURE_WORKFLOW = """Mandatory primary workflow for this request:

Before source analysis, a plan, or an edit, invoke and read `wukong-code:test-driven-development`.
The requested source change requires a new focused test and an observed valid RED before production implementation. Do not treat an existing nearby test, a compiler error, an undiscovered test, or a skipped test run as RED evidence. If the request forbids the valid RED, do not propose or implement the production change; report it as unverified.

"""


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


def read_input() -> dict[str, Any] | None:
    try:
        payload = json.load(sys.stdin)
    except (json.JSONDecodeError, OSError, ValueError):
        return None

    if not isinstance(payload, dict):
        return None
    if payload.get("hook_event_name") != "UserPromptSubmit":
        return None
    if not isinstance(payload.get("prompt"), str) or not isinstance(payload.get("cwd"), str):
        return None
    return payload


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


def named_language(prompt: str, languages: dict[str, Any]) -> str | None:
    matches = [
        language
        for language in languages
        if re.search(rf"\b{re.escape(language)}\b", prompt, re.IGNORECASE)
    ]
    return matches[-1] if matches else None


def prompt_targets(prompt: str, languages: dict[str, Any]) -> list[Path]:
    source_matches = SOURCE_EXTENSION.findall(prompt)
    if not source_matches:
        return []

    action_matches = ACTION_TARGET.findall(prompt)
    if action_matches:
        first_action = action_matches[0]
        action_tail = prompt[prompt.lower().find(first_action.lower()) + len(first_action) :]
        coordinated = re.match(
            r"\s*(?:,?\s+and|,)\s+([\w./-]+\.[A-Za-z0-9]+)\b",
            action_tail,
            re.IGNORECASE,
        )
        targets = [Path(match) for match in action_matches]
        if coordinated:
            targets.append(Path(coordinated.group(1)))
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

    language = named_language(prompt, languages)
    if language:
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


def phase_for(prompt: str) -> str | None:
    prompt = prompt.lower()
    if re.search(r"\b(diagnos|hang|deadlock|investigat|failure)\w*", prompt):
        return "debugging"
    if re.search(r"\breview(?:ing)?\b", prompt):
        return "review"
    if re.search(
        r"\b(verif(?:y|ies|ied|ying|ication)|exact checks?|claim(?:ing)? (?:this )?complete)\b",
        prompt,
    ):
        return "verification"
    if re.search(
        r"\b(skip|skipping).*(?:failing|failed).*\btest\b|\bproduction (?:is )?blocked\b|"
        r"\b(?:add|write|create|run|update)\b.*\b(?:test|tests|testing)\b|\bregression\s+test\b",
        prompt,
    ):
        return "testing"
    if re.search(r"\b(plan|design|approach|architecture)\b", prompt):
        return "profile"
    if re.search(r"\b(change|modify|make|add|implement|fix|refactor|update)\b", prompt):
        return "implementation"
    return None


def safe_reference(plugin_root: Path, relative_path: str) -> Path | None:
    root = (plugin_root / "skills" / "language-guidance" / "references").resolve()
    candidate = (root / relative_path).resolve(strict=False)
    try:
        candidate.relative_to(root)
    except ValueError:
        return None
    return candidate if candidate.is_file() else None


def main() -> None:
    if len(sys.argv) != 2:
        return
    plugin_root = Path(sys.argv[1]).resolve()
    payload = read_input()
    if payload is None:
        return

    try:
        registry = json.loads(
            (plugin_root / "skills" / "language-guidance" / "references" / "registry.json").read_text(
                encoding="utf-8"
            )
        )
        languages = registry["languages"]
        cwd = Path(payload["cwd"]).resolve(strict=False)
        selection = target_language(payload["prompt"], cwd, languages)
        phase = phase_for(payload["prompt"])
        unsupported_extension = unregistered_source_extension(payload["prompt"], languages)
        if not selection and unsupported_extension and phase:
            context = (
                "Deterministic Codex language routing\n\n"
                f"No installed language guidance is registered for {unsupported_extension}.\n"
                "Do not invoke language-guidance, emit a language decision, or invent a language pack, "
                "reference path, or phase. Keep the generic workflow.\n"
            )
            print(
                json.dumps(
                    {
                        "hookSpecificOutput": {
                            "hookEventName": "UserPromptSubmit",
                            "additionalContext": context,
                        }
                    },
                    ensure_ascii=False,
                )
            )
            return
        if not selection or not phase:
            return
        language, owner = selection
        phase_paths = languages[language]["phases"]
        relative_paths = (
            [phase_paths["profile"], phase_paths["implementation"]]
            if phase == "implementation"
            else [phase_paths[phase]]
        )
        references = [safe_reference(plugin_root, relative_path) for relative_path in relative_paths]
        if any(reference is None for reference in references):
            return
        bodies = [reference.read_text(encoding="utf-8").strip() for reference in references if reference]
    except (KeyError, OSError, TypeError, ValueError, json.JSONDecodeError):
        return

    language_name = languages[language].get("display_name", language.capitalize())
    workflow = TESTING_PRESSURE_WORKFLOW if phase == "testing" else ""
    if "$language-guidance" in payload["prompt"]:
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
        "do not select another language or phase unless new user evidence supersedes it.\n\n"
        f"{workflow}{body}\n"
    )
    print(
        json.dumps(
            {
                "hookSpecificOutput": {
                    "hookEventName": "UserPromptSubmit",
                    "additionalContext": context,
                }
            },
            ensure_ascii=False,
        )
    )


if __name__ == "__main__":
    main()
