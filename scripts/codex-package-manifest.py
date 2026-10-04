#!/usr/bin/env python3
"""Read the Codex transport manifest for package and sync scripts.

The manifest is the only include list those scripts may use for the Codex
archive payload and Product Design script includes. It names core archive
paths, runtime scripts, whether the integrity-check script ships, and the
templates/ and references/ roots. It does not invent path names of its own.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

COMMANDS = ("scripts", "archive-paths", "rsync-includes", "validate")


def usage() -> str:
    return (
        "Usage: scripts/codex-package-manifest.py "
        "<scripts|archive-paths|rsync-includes|validate> <manifest|->\n"
    )


def validate_relative_path(relative_path: object, field: str) -> str:
    if not isinstance(relative_path, str) or not relative_path:
        raise SystemExit(f"{field} must be a non-empty relative path")
    if (
        Path(relative_path).is_absolute()
        or Path(relative_path).as_posix() != relative_path
        or relative_path == "."
        or relative_path.startswith("../")
        or "\\" in relative_path
    ):
        raise SystemExit(f"invalid {field}: {relative_path}")
    return relative_path


def validate_manifest(data: object) -> dict:
    if not isinstance(data, dict):
        raise SystemExit("codex-package.manifest.json must be an object")

    core_archive_paths = data.get("core_archive_paths")
    if (
        not isinstance(core_archive_paths, list)
        or not core_archive_paths
        or any(not isinstance(item, str) or not item for item in core_archive_paths)
    ):
        raise SystemExit("core_archive_paths must be a non-empty list of relative paths")
    core_archive_paths = [
        validate_relative_path(item, "core_archive_paths[]")
        for item in core_archive_paths
    ]

    runtime_scripts = data.get("runtime_scripts")
    if (
        not isinstance(runtime_scripts, list)
        or not runtime_scripts
        or any(not isinstance(item, str) or not item for item in runtime_scripts)
    ):
        raise SystemExit("runtime_scripts must be a non-empty list of relative paths")
    runtime_scripts = [
        validate_relative_path(item, "runtime_scripts[]") for item in runtime_scripts
    ]

    ship_integrity_check = data.get("ship_integrity_check")
    if not isinstance(ship_integrity_check, bool):
        raise SystemExit("ship_integrity_check must be a boolean")

    integrity_check = validate_relative_path(
        data.get("integrity_check"),
        "integrity_check",
    )
    templates = validate_relative_path(data.get("templates"), "templates")
    references = validate_relative_path(data.get("references"), "references")

    return {
        "core_archive_paths": core_archive_paths,
        "runtime_scripts": runtime_scripts,
        "ship_integrity_check": ship_integrity_check,
        "integrity_check": integrity_check,
        "templates": templates,
        "references": references,
    }


def load_manifest(path: str) -> dict:
    if path == "-":
        return validate_manifest(json.loads(sys.stdin.read()))
    return validate_manifest(json.loads(Path(path).read_text(encoding="utf-8")))


def unique_keep_order(paths: list[str]) -> list[str]:
    seen: set[str] = set()
    ordered: list[str] = []
    for path in paths:
        if path in seen:
            continue
        seen.add(path)
        ordered.append(path)
    return ordered


def shipped_scripts(manifest: dict) -> list[str]:
    paths = list(manifest["runtime_scripts"])
    if manifest["ship_integrity_check"]:
        paths.append(manifest["integrity_check"])
    return unique_keep_order(paths)


def archive_paths(manifest: dict) -> list[str]:
    return unique_keep_order(
        [
            *manifest["core_archive_paths"],
            manifest["references"],
            manifest["templates"],
            *shipped_scripts(manifest),
        ]
    )


def rsync_includes(manifest: dict) -> list[str]:
    includes: list[str] = []
    seen: set[str] = set()
    for script in shipped_scripts(manifest):
        parts = script.split("/")
        for index in range(1, len(parts)):
            directory = "/" + "/".join(parts[:index]) + "/"
            if directory in seen:
                continue
            seen.add(directory)
            includes.append(directory)
        includes.append("/" + script)
    return includes


def emit(paths: list[str]) -> None:
    sys.stdout.write("\n".join(paths) + "\n")


def main(argv: list[str]) -> int:
    if not argv or argv[0] in ("-h", "--help"):
        sys.stdout.write(usage())
        return 0 if argv and argv[0] in ("-h", "--help") else 2
    if len(argv) != 2 or argv[0] not in COMMANDS:
        sys.stderr.write(usage())
        return 2

    command, path = argv
    manifest = load_manifest(path)
    if command == "validate":
        return 0
    if command == "scripts":
        emit(shipped_scripts(manifest))
        return 0
    if command == "archive-paths":
        emit(archive_paths(manifest))
        return 0
    emit(rsync_includes(manifest))
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
