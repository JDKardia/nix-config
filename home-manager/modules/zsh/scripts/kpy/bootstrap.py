import os
import pip._internal.cli.main as pip
import sys
import venv
import site
from pathlib import Path

VENV_DIR: Path = (Path.home() / "bin" / ".venv").absolute()
BIN_DIR = VENV_DIR / "bin"
SITE_PACKAGES: Path = (
    VENV_DIR
    / "lib"
    / f"python{sys.version_info.major}.{sys.version_info.minor}"
    / "site-packages"
)


def create_venv():
    print("creating venv for user-local scripts", file=sys.stderr)
    venv.create(
        env_dir=VENV_DIR,
        clear=True,
        with_pip=True,
        upgrade_deps=True,
    )


def install_deps(*deps: str):
    pip.main(
        [
            "--quiet",
            "--disable-pip-version-check",
            "--no-python-version-warning",
            "--disable-pip-version-check",
            "install",
            *deps,
        ]
    )


def activate():
    """
    Activates the user-local venv for current interpreter, adapted from
    virtualenv's `activate_this.py`.
    This allows my personal scripts to all use the same dependencies and venv
    without having to necessarily know/handle venv's while putzing around

    """  # noqa: D415
    # prepend bin to PATH (this file is inside the bin directory)
    os.environ["PATH"] = f"{BIN_DIR}{os.path.sep}{os.environ.get('PATH','')}"
    # virtual env is right above bin directory
    os.environ["VIRTUAL_ENV"] = str(VENV_DIR)
    os.environ["VIRTUAL_ENV_PROMPT"] = "" or os.path.basename(VENV_DIR)  # noqa: SIM222

    # add the virtual environments libraries to the host python import mechanism
    prev_length = len(sys.path)
    site.addsitedir(str(SITE_PACKAGES))
    # move new site to front of system path
    sys.path[:] = sys.path[prev_length:] + sys.path[0:prev_length]

    sys.real_prefix = sys.prefix
    sys.prefix = VENV_DIR
    sys.real_prefix


if not (VENV_DIR.exists() and BIN_DIR.exists() and SITE_PACKAGES.exists()):
    create_venv()
activate()
