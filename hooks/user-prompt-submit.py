#!/usr/bin/env python3
"""Inject one evidence-backed language reference for a Codex user prompt."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path
from typing import Any


SUPPORTED_EXTENSIONS = {".rs": "rust", ".go": "go", ".swift": "swift"}
DOCUMENTATION_EXTENSIONS = {".adoc", ".md", ".rst", ".txt"}
SOURCE_EXTENSION = re.compile(r"(?<![\w.])([\w./-]+\.[A-Za-z0-9]+)\b")
LANGUAGE_NAME = re.compile(r"\b(rust|go|swift)\b", re.IGNORECASE)


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


def owner_for(directory: Path, markers: list[str]) -> Path | None:
    current = directory.resolve(strict=False)
    for candidate in (current, *current.parents):
        if any((candidate / marker).exists() for marker in markers):
            return candidate
    return None


def target_language(prompt: str, cwd: Path, languages: dict[str, Any]) -> tuple[str, Path] | None:
    source_matches = SOURCE_EXTENSION.findall(prompt)
    if source_matches:
        target = Path(source_matches[-1])
        extension = target.suffix.lower()
        language = SUPPORTED_EXTENSIONS.get(extension)
        if language is None:
            return None
        try:
            candidate = (cwd / target).resolve(strict=False)
            candidate.relative_to(cwd.resolve(strict=False))
        except ValueError:
            return None
        owner = owner_for(candidate.parent, languages[language]["markers"])
        return (language, owner) if owner else None

    named = LANGUAGE_NAME.findall(prompt)
    if named:
        language = named[-1].lower()
        owner = owner_for(cwd, languages[language]["markers"])
        return (language, owner) if owner else None

    candidates: list[tuple[str, Path]] = []
    for language, data in languages.items():
        owner = owner_for(cwd, data["markers"])
        if owner:
            candidates.append((language, owner))
    return candidates[0] if len(candidates) == 1 else None


def unregistered_source_extension(prompt: str) -> str | None:
    source_matches = SOURCE_EXTENSION.findall(prompt)
    if not source_matches:
        return None
    extension = Path(source_matches[-1]).suffix.lower()
    if extension in SUPPORTED_EXTENSIONS or extension in DOCUMENTATION_EXTENSIONS:
        return None
    return extension


def phase_for(prompt: str) -> str | None:
    prompt = prompt.lower()
    if re.search(r"\b(diagnos|hang|deadlock|investigat|failure)\w*", prompt):
        return "debugging"
    if re.search(r"\breview(?:ing)?\b", prompt):
        return "review"
    if re.search(r"\b(verify|verification|exact checks?|claim(?:ing)? (?:this )?complete)\b", prompt):
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
        unsupported_extension = unregistered_source_extension(payload["prompt"])
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
        relative_path = languages[language]["phases"][phase]
        reference = safe_reference(plugin_root, relative_path)
        if reference is None:
            return
        body = reference.read_text(encoding="utf-8").strip()
    except (KeyError, OSError, TypeError, ValueError, json.JSONDecodeError):
        return

    language_name = language.capitalize()
    context = (
        "Deterministic Codex language routing\n\n"
        f"Language: {language_name}\n"
        f"Evidence: {owner}\n"
        f"Phase: {phase}\n"
        f"Delivered: {relative_path}\n\n"
        "This hook has already delivered the sole selected language guidance for this turn; "
        "do not select another language or phase unless new user evidence supersedes it.\n\n"
        f"{body}\n"
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
