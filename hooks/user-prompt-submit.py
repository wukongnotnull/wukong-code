#!/usr/bin/env python3
"""Codex UserPromptSubmit wrapper: read stdin, decide, wrap JSON."""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any

from language_router import decide


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


def wrap_json(additional_context: str) -> str:
    return json.dumps(
        {
            "hookSpecificOutput": {
                "hookEventName": "UserPromptSubmit",
                "additionalContext": additional_context,
            }
        },
        ensure_ascii=False,
    )


def main() -> None:
    if len(sys.argv) != 2:
        return
    payload = read_input()
    if payload is None:
        return
    decision = decide(payload["prompt"], payload["cwd"], Path(sys.argv[1]).resolve())
    if not decision.additional_context:
        return
    print(wrap_json(decision.additional_context))


if __name__ == "__main__":
    main()
