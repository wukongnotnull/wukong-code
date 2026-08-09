"""Resolve Product Design state without assuming a Codex-only host."""

from __future__ import annotations

import os
from collections.abc import Mapping
from pathlib import Path


CODEX_STATE_SUFFIX = Path("state/plugins/product-design")
PORTABLE_STATE_SUFFIX = Path("wukong-code/product-design")


def _absolute(path: Path) -> Path:
    return path.expanduser().resolve()


def resolve_state_dir(
    state_dir: Path | None = None,
    codex_home: Path | None = None,
    environ: Mapping[str, str] | None = None,
    home: Path | None = None,
) -> Path:
    """Return the Product Design state directory in documented priority order."""

    active_environment = os.environ if environ is None else environ
    active_home = Path.home() if home is None else home

    if state_dir is not None:
        return _absolute(state_dir)

    environment_state = active_environment.get("PRODUCT_DESIGN_STATE_DIR")
    if environment_state:
        return _absolute(Path(environment_state))

    if codex_home is not None:
        return _absolute(codex_home / CODEX_STATE_SUFFIX)

    environment_codex_home = active_environment.get("CODEX_HOME")
    if environment_codex_home:
        return _absolute(Path(environment_codex_home) / CODEX_STATE_SUFFIX)

    legacy_state = active_home / ".codex" / CODEX_STATE_SUFFIX
    if legacy_state.exists():
        return _absolute(legacy_state)

    xdg_state_home = active_environment.get("XDG_STATE_HOME")
    if xdg_state_home:
        return _absolute(Path(xdg_state_home) / PORTABLE_STATE_SUFFIX)

    return _absolute(active_home / ".local/state" / PORTABLE_STATE_SUFFIX)
