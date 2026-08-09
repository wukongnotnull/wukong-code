from __future__ import annotations

import importlib.util
import json
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[2]
MODULE_PATH = (
    REPO_ROOT
    / "skills"
    / "product-design-user-context"
    / "scripts"
    / "state_paths.py"
)


def load_state_paths():
    spec = importlib.util.spec_from_file_location("product_design_state_paths", MODULE_PATH)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {MODULE_PATH}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class ResolveStateDirTests(unittest.TestCase):
    def setUp(self) -> None:
        self.module = load_state_paths()
        self.tempdir = tempfile.TemporaryDirectory()
        self.root = Path(self.tempdir.name)
        self.home = self.root / "home"
        self.home.mkdir()

    def tearDown(self) -> None:
        self.tempdir.cleanup()

    def resolve(self, **overrides: object) -> Path:
        defaults = {
            "state_dir": None,
            "codex_home": None,
            "environ": {},
            "home": self.home,
        }
        defaults.update(overrides)
        return self.module.resolve_state_dir(**defaults)

    def test_cli_state_dir_has_highest_priority(self) -> None:
        explicit = self.root / "explicit-state"
        actual = self.resolve(
            state_dir=explicit,
            codex_home=self.root / "codex-cli",
            environ={
                "PRODUCT_DESIGN_STATE_DIR": str(self.root / "env-state"),
                "CODEX_HOME": str(self.root / "codex-env"),
            },
        )
        self.assertEqual(actual, explicit.resolve())

    def test_environment_state_dir_beats_codex_home(self) -> None:
        explicit = self.root / "env-state"
        actual = self.resolve(
            codex_home=self.root / "codex-cli",
            environ={"PRODUCT_DESIGN_STATE_DIR": str(explicit)},
        )
        self.assertEqual(actual, explicit.resolve())

    def test_explicit_codex_home_preserves_codex_layout(self) -> None:
        codex_home = self.root / "codex-cli"
        self.assertEqual(
            self.resolve(codex_home=codex_home),
            (codex_home / "state/plugins/product-design").resolve(),
        )

    def test_ambient_codex_home_preserves_codex_layout(self) -> None:
        codex_home = self.root / "codex-env"
        self.assertEqual(
            self.resolve(environ={"CODEX_HOME": str(codex_home)}),
            (codex_home / "state/plugins/product-design").resolve(),
        )

    def test_existing_legacy_state_is_reused_without_codex_environment(self) -> None:
        legacy = self.home / ".codex/state/plugins/product-design"
        legacy.mkdir(parents=True)
        (legacy / "user-context.md").write_text("# Existing\n", encoding="utf-8")
        self.assertEqual(self.resolve(), legacy.resolve())

    def test_xdg_state_home_is_used_for_non_codex_hosts(self) -> None:
        xdg = self.root / "xdg-state"
        self.assertEqual(
            self.resolve(environ={"XDG_STATE_HOME": str(xdg)}),
            (xdg / "wukong-code/product-design").resolve(),
        )

    def test_portable_home_fallback_does_not_write_dot_codex(self) -> None:
        self.assertEqual(
            self.resolve(),
            (self.home / ".local/state/wukong-code/product-design").resolve(),
        )

    def test_cli_scripts_work_from_foreign_directory_with_portable_state(self) -> None:
        foreign_cwd = self.root / "foreign-project"
        foreign_cwd.mkdir()
        xdg = self.root / "xdg-state"
        environment = {
            **os.environ,
            "HOME": str(self.home),
            "XDG_STATE_HOME": str(xdg),
        }
        environment.pop("CODEX_HOME", None)
        environment.pop("PRODUCT_DESIGN_STATE_DIR", None)
        scripts = MODULE_PATH.parent

        init_result = subprocess.run(
            [sys.executable, str(scripts / "init_user_context.py")],
            cwd=foreign_cwd,
            env=environment,
            check=False,
            capture_output=True,
            text=True,
        )
        self.assertEqual(init_result.returncode, 0, init_result.stderr)

        expected_state = xdg / "wukong-code/product-design"
        self.assertTrue((expected_state / "user-context.md").is_file())
        self.assertFalse((self.home / ".codex").exists())

        preflight_result = subprocess.run(
            [sys.executable, str(scripts / "user_context_preflight.py")],
            cwd=foreign_cwd,
            env=environment,
            check=False,
            capture_output=True,
            text=True,
        )
        self.assertEqual(preflight_result.returncode, 0, preflight_result.stderr)
        payload = json.loads(preflight_result.stdout)
        self.assertEqual(Path(payload["state_dir"]), expected_state.resolve())
        self.assertEqual(payload["user_context"]["status"], "present")


if __name__ == "__main__":
    unittest.main()
